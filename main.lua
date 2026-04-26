local Lib = Instance.new("ScreenGui")
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
Lib.Name = "Faction_Duels"
Lib.ResetOnSpawn = false
Lib.Parent = game:GetService("CoreGui")
Lib.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local rightWaypoints = {
    Vector3.new(-473.04,-6.99,29.71), Vector3.new(-483.57,-5.10,18.74),
    Vector3.new(-475.00,-6.99,26.43), Vector3.new(-474.67,-6.94,105.48),
}
local leftWaypoints = {
    Vector3.new(-472.49,-7.00,90.62), Vector3.new(-484.62,-5.10,100.37),
    Vector3.new(-475.08,-7.00,93.29), Vector3.new(-474.22,-6.96,16.18),
}
local patrolMode = "none"
local floating = false
local floatingV2 = false
local currentWaypoint = 1
local heartbeatConn
local waitingForCountdownLeft = false
local waitingForCountdownRight = false
local AUTO_START_DELAY = 0.7
local batAimbotActive = false
local batAimbotConn = nil
local AimbotRadius = 100
local BatAimbotSpeed = 55
local SlapList = {
    {1,"Bat"},{2,"Slap"},{3,"Iron Slap"},{4,"Gold Slap"},{5,"Diamond Slap"},
    {6,"Emerald Slap"},{7,"Ruby Slap"},{8,"Dark Matter Slap"},{9,"Flame Slap"},
    {10,"Nuclear Slap"},{11,"Galaxy Slap"},{12,"Glitched Slap"}
}
local spinActive = false
local spinAngle = 0
local spinSpeed = 20
local spinAlign, spinAttachment, spinConn = nil, nil, nil
local hitTPActive = false
local hitTPConn = nil
local wasRagdolled = false
local antiRagdollActive = false
local antiRagdollConn = nil
local infiniteJumpActive = false
local infiniteJumpJumpConn = nil
local infiniteJumpHeartbeatConn = nil

-- New auto steal variables
local autoStealActive = false
local autoStealConn = nil
local autoStealIsStealing = false
local autoStealLastCheck = 0
local autoStealAllPodiums = {}
local autoStealPromptCache = {}
local autoStealPlotsFolder = workspace:FindFirstChild("Plots")
local autoStealConfig = {
    RADIUS = 7,
    PREDICT_FACTOR = 1.5,
}

-- Waypoint positions for teleport
local leftBase = { Vector3.new(-483.59,-5.04,104.24) }
local rightBase = { Vector3.new(-483.51,-5.10,18.89) }

local function setupSpinBot()
    local char = player.Character; if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
    if spinAlign then spinAlign:Destroy() end
    if spinAttachment then spinAttachment:Destroy() end
    spinAttachment = Instance.new("Attachment"); spinAttachment.Parent = hrp
    spinAlign = Instance.new("AlignOrientation")
    spinAlign.Attachment0 = spinAttachment
    spinAlign.Mode = Enum.OrientationAlignmentMode.OneAttachment
    spinAlign.Responsiveness = 30; spinAlign.MaxTorque = math.huge
    spinAlign.RigidityEnabled = false; spinAlign.Enabled = false; spinAlign.Parent = hrp
end

local function startSpinBot()
    setupSpinBot()
    if spinAlign then spinAlign.Enabled = true end
    if spinConn then spinConn:Disconnect() end
    spinConn = RunService.Heartbeat:Connect(function(dt)
        if not spinActive then return end
        if not spinAlign or not spinAlign.Parent then
            setupSpinBot()
            if spinAlign then spinAlign.Enabled = true end
            return
        end
        spinAngle = spinAngle + spinSpeed * dt
        spinAlign.CFrame = CFrame.Angles(0, spinAngle, 0)
    end)
end

local function stopSpinBot()
    spinActive = false
    if spinConn then spinConn:Disconnect(); spinConn = nil end
    if spinAlign then spinAlign.Enabled = false end
end

local stealSpeedActive = false
local stealSpeedConn = nil
local STEAL_SPEED_VALUE = 29

local function startStealSpeed()
    if stealSpeedConn then stealSpeedConn:Disconnect() end
    stealSpeedConn = RunService.Heartbeat:Connect(function()
        if not stealSpeedActive then return end
        local char = player.Character; if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not hum or not root then return end
        if hum.MoveDirection.Magnitude > 0.1 then
            local md = hum.MoveDirection.Unit
            root.AssemblyLinearVelocity = Vector3.new(
                md.X * STEAL_SPEED_VALUE,
                root.AssemblyLinearVelocity.Y,
                md.Z * STEAL_SPEED_VALUE
            )
        end
    end)
end

local function stopStealSpeed()
    if stealSpeedConn then stealSpeedConn:Disconnect(); stealSpeedConn = nil end
end

local tpFinalLeft  = Vector3.new(-483.59,-5.04,104.24)
local tpFinalRight = Vector3.new(-483.51,-5.10,18.89)
local tpCheckA     = Vector3.new(-472.60,-7.00,57.52)
local tpCheckLeft  = Vector3.new(-472.65,-7.00,95.69)
local tpCheckRight = Vector3.new(-471.76,-7.00,26.22)
local lastTpSide = "none"

local function tpMove(pos)
    local char = player.Character; if not char then return end
    char:PivotTo(CFrame.new(pos))
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp then hrp.AssemblyLinearVelocity = Vector3.new(0,0,0) end
end

local function doTPLeft()
    tpMove(tpCheckA); task.wait(0.1)
    tpMove(tpCheckLeft); task.wait(0.1)
    tpMove(tpFinalLeft)
    lastTpSide = "left"
end

local function doTPRight()
    tpMove(tpCheckA); task.wait(0.1)
    tpMove(tpCheckRight); task.wait(0.1)
    tpMove(tpFinalRight)
    lastTpSide = "right"
end

-- TP Down function (instant downward teleport)
local function doTPDown()
    local char = player.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = hrp.CFrame * CFrame.new(0, -20, 0)
        end
    end
end

-- Target function to get nearest enemy position
local function getTargetPosition()
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local myPos = root.Position
    local nearestPlayer = nil
    local nearestDist = math.huge
    
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player and p.Character then
            local targetRoot = p.Character:FindFirstChild("HumanoidRootPart")
            if targetRoot then
                local dist = (targetRoot.Position - myPos).Magnitude
                if dist < nearestDist then
                    nearestDist = dist
                    nearestPlayer = p
                end
            end
        end
    end
    
    if nearestPlayer and nearestPlayer.Character then
        return nearestPlayer.Character:FindFirstChild("HumanoidRootPart")
    end
    return nil
end

-- Original go() function logic
local function go()
    local t = getTargetPosition()
    if not t then return end
    local l = (t.Position - leftBase[1]).Magnitude
    local r = (t.Position - rightBase[1]).Magnitude
    if l > r then 
        doTPLeft()
    else 
        doTPRight()
    end
end

local function isRagdolled(char)
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum and hum:GetState() == Enum.HumanoidStateType.Ragdoll then return true end
    local ragVal = char:FindFirstChild("Ragdoll") or char:FindFirstChild("IsRagdoll")
    if ragVal and ragVal:IsA("BoolValue") and ragVal.Value then return true end
    return false
end

local function startHitTP()
    if hitTPConn then return end
    hitTPConn = RunService.Heartbeat:Connect(function()
        if not hitTPActive then return end
        local char = player.Character
        if not char then return end
        
        local nowRagdolled = isRagdolled(char)
        
        if nowRagdolled and not wasRagdolled then
            wasRagdolled = true
            task.spawn(function()
                task.wait(0.1)
                go()
            end)
        elseif not nowRagdolled then
            wasRagdolled = false
        end
    end)
end

local function stopHitTP()
    if hitTPConn then hitTPConn:Disconnect(); hitTPConn = nil end
    wasRagdolled = false
end

-- Anti-Ragdoll functionality
local function startAntiRagdoll()
    if antiRagdollConn then return end
    antiRagdollConn = RunService.Heartbeat:Connect(function()
        if not antiRagdollActive then return end
        local char = player.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if hum then
            local s = hum:GetState()
            if s == Enum.HumanoidStateType.Physics
            or s == Enum.HumanoidStateType.Ragdoll
            or s == Enum.HumanoidStateType.FallingDown then
                hum:ChangeState(Enum.HumanoidStateType.Running)
                if workspace.CurrentCamera then
                    workspace.CurrentCamera.CameraSubject = hum
                end
                if root then
                    root.Velocity = Vector3.new(0,0,0)
                    root.RotVelocity = Vector3.new(0,0,0)
                end
            end
        end
        for _, obj in ipairs(char:GetDescendants()) do
            if obj:IsA("Motor6D") and not obj.Enabled then obj.Enabled = true end
        end
    end)
end

local function stopAntiRagdoll()
    if antiRagdollConn then antiRagdollConn:Disconnect(); antiRagdollConn = nil end
end

-- Infinite Jump functionality
local function startInfiniteJump()
    if infiniteJumpJumpConn then return end

    infiniteJumpJumpConn = UIS.JumpRequest:Connect(function()
        if not infiniteJumpActive then return end
        local char = player.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, 50, hrp.AssemblyLinearVelocity.Z)
        end
    end)

    infiniteJumpHeartbeatConn = RunService.Heartbeat:Connect(function()
        if not infiniteJumpActive then return end
        local char = player.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp and hrp.AssemblyLinearVelocity.Y < -80 then
            hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, -80, hrp.AssemblyLinearVelocity.Z)
        end
    end)
end

local function stopInfiniteJump()
    if infiniteJumpJumpConn then
        infiniteJumpJumpConn:Disconnect()
        infiniteJumpJumpConn = nil
    end
    if infiniteJumpHeartbeatConn then
        infiniteJumpHeartbeatConn:Disconnect()
        infiniteJumpHeartbeatConn = nil
    end
end

-- Auto Steal Functions
local function autoStealRescan()
    autoStealAllPodiums = {}
    local plots = autoStealPlotsFolder
    if not plots then return end

    for _, plot in ipairs(plots:GetChildren()) do
        if plot:IsA("Model") then
            local sign = plot:FindFirstChild("PlotSign")
            local yourBase = sign and sign:FindFirstChild("YourBase")
            if not (yourBase and yourBase:IsA("BillboardGui") and yourBase.Enabled) then
                local podiums = plot:FindFirstChild("Podiums") or plot:FindFirstChild("AnimalPodiums")
                if podiums then
                    for _, podium in ipairs(podiums:GetChildren()) do
                        if podium:IsA("Model") and podium:FindFirstChild("Base") then
                            local pos = podium:GetPivot().Position
                            local uid = plot.Name .. "_" .. podium.Name
                            table.insert(autoStealAllPodiums, {
                                uid = uid,
                                pos = pos,
                                plot = plot.Name,
                                podium = podium
                            })
                        end
                    end
                end
            end
        end
    end
end

local function autoStealGetHRP()
    local char = player.Character
    return char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso"))
end

local function autoStealGetPrompt(data)
    local cached = autoStealPromptCache[data.uid]
    if cached and cached.Parent then return cached end

    local base = data.podium:FindFirstChild("Base")
    if base then
        local spawn = base:FindFirstChild("Spawn")
        if spawn then
            local attach = spawn:FindFirstChild("PromptAttachment")
            if attach then
                for _, obj in ipairs(attach:GetChildren()) do
                    if obj:IsA("ProximityPrompt") and obj.Enabled then
                        autoStealPromptCache[data.uid] = obj
                        return obj
                    end
                end
            end
        end
        for _, obj in ipairs(base:GetDescendants()) do
            if obj:IsA("ProximityPrompt") and obj.Enabled then
                autoStealPromptCache[data.uid] = obj
                return obj
            end
        end
        for _, obj in ipairs(data.podium.Parent:GetDescendants()) do
            if obj:IsA("ProximityPrompt") and obj.Enabled and 
               (obj.ActionText:lower():find("steal") or obj.ObjectText:lower():find("brain")) then
                autoStealPromptCache[data.uid] = obj
                return obj
            end
        end
    end
    return nil
end

local function autoStealFirePrompt(prompt)
    if not prompt or not prompt.Parent then return false end
    if fireproximityprompt then
        fireproximityprompt(prompt)
    else
        prompt:InputHoldBegin()
        task.wait(0.001)
        prompt:InputHoldEnd()
    end
    return true
end

local function autoStealAttemptSteal(data)
    if autoStealIsStealing then return false end
    autoStealIsStealing = true

    local prompt = autoStealGetPrompt(data)
    local success = false
    
    for i = 1, 8 do
        if prompt and autoStealFirePrompt(prompt) then
            success = true
        end
        task.wait(0.001)
        prompt = autoStealGetPrompt(data)
        if not prompt then break end
    end

    task.wait(0.08)
    autoStealIsStealing = false
    return success
end

local function autoStealStart()
    if autoStealConn then return end
    autoStealConn = RunService.Heartbeat:Connect(function()
        if not autoStealActive or autoStealIsStealing then return end
        if tick() - autoStealLastCheck < 0.04 then return end
        autoStealLastCheck = tick()

        local hrp = autoStealGetHRP()
        if not hrp then return end

        local velocity = hrp.AssemblyLinearVelocity or Vector3.new(0,0,0)
        local nearest = nil
        local minDist = math.huge

        for _, data in ipairs(autoStealAllPodiums) do
            local dir = (data.pos - hrp.Position).Unit
            local dist = (data.pos - hrp.Position).Magnitude
            local approach_speed = velocity:Dot(dir)
            local predicted_dist = dist - (approach_speed * autoStealConfig.PREDICT_FACTOR)
            if predicted_dist < minDist and predicted_dist < autoStealConfig.RADIUS then
                minDist = predicted_dist
                nearest = data
            end
        end

        if nearest then
            autoStealAttemptSteal(nearest)
        end
    end)
end

local function autoStealStop()
    if autoStealConn then
        autoStealConn:Disconnect()
        autoStealConn = nil
    end
end

local rescanTimer = nil
local function startRescanTimer()
    if rescanTimer then return end
    rescanTimer = task.spawn(function()
        while true do
            task.wait(10)
            if autoStealActive then
                autoStealRescan()
            end
        end
    end)
end

-- Existing functions
local unwalkActive = false
local unwalkConn = nil

local function startUnwalk()
    if unwalkConn then unwalkConn:Disconnect() end
    unwalkConn = RunService.Heartbeat:Connect(function()
        if not unwalkActive then return end
        local char = player.Character; if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid"); if not hum then return end
        local anim = hum:FindFirstChildOfClass("Animator"); if not anim then return end
        for _, t in pairs(anim:GetPlayingAnimationTracks()) do t:Stop() end
    end)
end

local function stopUnwalk()
    if unwalkConn then unwalkConn:Disconnect(); unwalkConn = nil end
end

local antiFlingActive = false
local antiFlingConn = nil

local function startAntiFling()
    if antiFlingConn then antiFlingConn:Disconnect() end
    antiFlingConn = RunService.Heartbeat:Connect(function()
        if not antiFlingActive then return end
        local char = player.Character; if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart"); if not root then return end
        local vel = root.AssemblyLinearVelocity
        local maxSpeed = 100
        if vel.Magnitude > maxSpeed then
            root.AssemblyLinearVelocity = vel.Unit * maxSpeed
        end
    end)
end

local function stopAntiFling()
    if antiFlingConn then antiFlingConn:Disconnect(); antiFlingConn = nil end
end

local ragdollAutoActive = false
local ragdollDetectorConn = nil
local startMovement
local stopMovement
local ragdollWasActive = false

local function startRagdollDetector()
    if ragdollDetectorConn then ragdollDetectorConn:Disconnect() end
    ragdollDetectorConn = RunService.Heartbeat:Connect(function()
        if not ragdollAutoActive then return end
        local char = player.Character; if not char then return end
        local nowRagdolled = isRagdolled(char)
        if nowRagdolled and not ragdollWasActive then
            ragdollWasActive = true
            task.spawn(function()
                task.wait(0.15)
                if lastTpSide == "left" then
                    doTPLeft(); task.wait(0.2)
                    if patrolMode ~= "left" and startMovement then startMovement("left", nil) end
                elseif lastTpSide == "right" then
                    doTPRight(); task.wait(0.2)
                    if patrolMode ~= "right" and startMovement then startMovement("right", nil) end
                end
            end)
        elseif not nowRagdolled then
            ragdollWasActive = false
        end
    end)
end

local function stopRagdollDetector()
    if ragdollDetectorConn then ragdollDetectorConn:Disconnect(); ragdollDetectorConn = nil end
    ragdollWasActive = false
end

-- Original steal (unused, but kept for compatibility)
local stealActive = false
local stealConn = nil
local isStealing  = false
local stealLoopRunning = false
local stealThread = nil

local function getPromptPosition(prompt)
    local p = prompt.Parent
    if p:IsA("BasePart") then
        return p.Position
    elseif p:IsA("Model") then
        local prim = p.PrimaryPart or p:FindFirstChildWhichIsA("BasePart")
        return prim and prim.Position
    elseif p:IsA("Attachment") then
        return p.WorldPosition
    else
        local part = p:FindFirstChildWhichIsA("BasePart", true)
        return part and part.Position
    end
end

local function findNearestStealPrompt()
    local c = player.Character
    local root = c and c:FindFirstChild("HumanoidRootPart")
    if not root then return nil, math.huge end
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return nil, math.huge end
    local myPos = root.Position
    local nearestPrompt = nil
    local nearestDist = math.huge
    for _, plot in ipairs(plots:GetChildren()) do
        for _, obj in ipairs(plot:GetDescendants()) do
            if obj:IsA("ProximityPrompt") and obj.Enabled and obj.ActionText == "Steal" then
                local pos = getPromptPosition(obj)
                if pos then
                    local dist = (myPos - pos).Magnitude
                    if dist <= obj.MaxActivationDistance and dist < nearestDist then
                        nearestPrompt = obj
                        nearestDist = dist
                    end
                end
            end
        end
    end
    return nearestPrompt, nearestDist
end

local function firePrompt(prompt)
    if not prompt then return end
    task.spawn(function()
        pcall(function()
            fireproximityprompt(prompt, 10000)
            prompt:InputHoldBegin()
            task.wait(0.05)
            prompt:InputHoldEnd()
        end)
    end)
end

local function stealLoop()
    while stealActive do
        local c = player.Character
        local hum = c and c:FindFirstChildOfClass("Humanoid")
        if hum and hum.WalkSpeed > 29 then
            local prompt = findNearestStealPrompt()
            if prompt then
                task.wait(0.1)
                firePrompt(prompt)
            end
        end
        task.wait(0.3)
    end
    stealLoopRunning = false
end

local function startStealLoop()
    if stealLoopRunning then return end
    stealLoopRunning = true
    stealThread = task.spawn(stealLoop)
end

local function stopStealLoop()
    stealLoopRunning = false
    if stealThread then task.cancel(stealThread); stealThread = nil end
    if stealConn then stealConn:Disconnect(); stealConn = nil end
    isStealing = false
end

local function initSteal()
    startStealLoop()
end

-- Walk fling functions
local _wfConns = {}
local _wfActive = false

local function startWalkFling()
    _wfActive = true
    table.insert(_wfConns, RunService.Stepped:Connect(function()
        if not _wfActive then return end
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player and p.Character then
                for _, part in ipairs(p.Character:GetChildren()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end
    end))
    local co = coroutine.create(function()
        while _wfActive do
            RunService.Heartbeat:Wait()
            local char = player.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if not root then RunService.Heartbeat:Wait(); continue end
            local vel = root.Velocity
            root.Velocity = vel * 10000 + Vector3.new(0, 10000, 0)
            RunService.RenderStepped:Wait()
            if root and root.Parent then root.Velocity = vel end
            RunService.Stepped:Wait()
            if root and root.Parent then root.Velocity = vel + Vector3.new(0, 0.1, 0) end
        end
    end)
    coroutine.resume(co)
    table.insert(_wfConns, co)
end

local function stopWalkFling()
    _wfActive = false
    for _, c in ipairs(_wfConns) do
        if typeof(c) == "RBXScriptConnection" then c:Disconnect()
        elseif typeof(c) == "thread" then pcall(task.cancel, c) end
    end
    _wfConns = {}
end

local function findBat()
    local c = player.Character; if not c then return nil end
    local bp = player:FindFirstChildOfClass("Backpack")
    for _, ch in ipairs(c:GetChildren()) do
        if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end
    end
    if bp then
        for _, ch in ipairs(bp:GetChildren()) do
            if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end
        end
    end
    for _, i in ipairs(SlapList) do
        local t = c:FindFirstChild(i[2]) or (bp and bp:FindFirstChild(i[2]))
        if t then return t end
    end
end

local function findNearestEnemy(myHRP)
    local nearest, nearestDist, nearestTorso = nil, math.huge, nil
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player and p.Character then
            local eh = p.Character:FindFirstChild("HumanoidRootPart")
            local torso = p.Character:FindFirstChild("UpperTorso") or p.Character:FindFirstChild("Torso")
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            if eh and hum and hum.Health > 0 then
                local d = (eh.Position - myHRP.Position).Magnitude
                if d < nearestDist and d <= AimbotRadius then
                    nearestDist = d; nearest = eh; nearestTorso = torso or eh
                end
            end
        end
    end
    return nearest, nearestDist, nearestTorso
end

local function startBatAimbot()
    if batAimbotConn then return end
    batAimbotConn = RunService.Heartbeat:Connect(function()
        local c = player.Character; if not c then return end
        local h = c:FindFirstChild("HumanoidRootPart")
        local hum = c:FindFirstChildOfClass("Humanoid")
        if not h or not hum then return end
        local bat = findBat()
        if bat and bat.Parent ~= c then hum:EquipTool(bat) end
        local target, dist, torso = findNearestEnemy(h)
        if target and torso then
            local PredictedPos = torso.Position + (torso.AssemblyLinearVelocity * 0.13)
            local dir = PredictedPos - h.Position
            if Vector3.new(dir.X,0,dir.Z).Magnitude > 0 then hum.AutoRotate = true end
            if dir.Magnitude > 1.5 then
                h.AssemblyLinearVelocity = dir.Unit * BatAimbotSpeed
            else
                h.AssemblyLinearVelocity = target.AssemblyLinearVelocity
            end
        end
    end)
end

local function stopBatAimbot()
    if batAimbotConn then batAimbotConn:Disconnect(); batAimbotConn = nil end
end

local function isCountdownNumber(text)
    local num = tonumber(text)
    if num and num >= 1 and num <= 5 then return true, num end
    return false
end

local function isTimerInCountdown(label)
    if not label then return false end
    local ok, num = isCountdownNumber(label.Text)
    return ok and num >= 1 and num <= 5
end

local function getCurrentSpeed()
    if patrolMode == "right" then return currentWaypoint >= 3 and 29.4 or 60
    elseif patrolMode == "left" then return currentWaypoint >= 3 and 29.4 or 60 end
    return 0
end

local function getCurrentWaypoints()
    if patrolMode == "right" then return rightWaypoints
    elseif patrolMode == "left" then return leftWaypoints end
    return {}
end

local function startFloat()
    floating = true
end

local function stopFloat()
    floating = false
    local char = player.Character
    if char then
        local root = char:FindFirstChild("HumanoidRootPart")
        if root then root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, 0, root.AssemblyLinearVelocity.Z) end
    end
end

local function startFloatV2()
    floatingV2 = true
end

local function stopFloatV2()
    floatingV2 = false
    local char = player.Character
    if char then
        local root = char:FindFirstChild("HumanoidRootPart")
        if root then root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, 0, root.AssemblyLinearVelocity.Z) end
    end
end

local function updateWalking()
    local char = player.Character; if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart"); if not root then return end
    local currentVel = root.AssemblyLinearVelocity
    
    if floating or floatingV2 then
        local rp = RaycastParams.new()
        rp.FilterType = Enum.RaycastFilterType.Blacklist
        rp.FilterDescendantsInstances = {char}
        local res = workspace:Raycast(root.Position, Vector3.new(0,-50,0), rp)
        if res then
            local diff = (res.Position.Y + 8) - root.Position.Y
            if math.abs(diff) > 0.3 then
                root.AssemblyLinearVelocity = Vector3.new(currentVel.X, diff*15, currentVel.Z)
            else
                root.AssemblyLinearVelocity = Vector3.new(currentVel.X, 0, currentVel.Z)
            end
        end
    end
    
    if patrolMode ~= "none" then
        local waypoints = getCurrentWaypoints()
        local targetPos = waypoints[currentWaypoint]
        local currentPos = root.Position
        local targetXZ  = Vector3.new(targetPos.X, 0, targetPos.Z)
        local currentXZ = Vector3.new(currentPos.X, 0, currentPos.Z)
        local distanceXZ = (targetXZ - currentXZ).Magnitude
        if distanceXZ > 3 then
            local moveDir = (targetXZ - currentXZ).Unit
            local spd = getCurrentSpeed()
            root.AssemblyLinearVelocity = Vector3.new(moveDir.X*spd, root.AssemblyLinearVelocity.Y, moveDir.Z*spd)
        else
            if currentWaypoint == #waypoints then
                currentWaypoint = 1
                root.AssemblyLinearVelocity = Vector3.new(0, root.AssemblyLinearVelocity.Y, 0)
            else
                currentWaypoint = currentWaypoint + 1
            end
        end
    end
end

-- Black and Red Theme
local C_BG     = Color3.fromRGB(0, 0, 0)
local C_ACTIVE = Color3.fromRGB(139, 0, 0)
local C_BORDER = Color3.fromRGB(180, 0, 0)
local C_TEXT   = Color3.fromRGB(255, 255, 255)
local C_DOT_ON = Color3.fromRGB(255, 0, 0)
local C_DOT_OFF = Color3.fromRGB(80, 0, 0)

local function MakeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = frame.Position
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

-- Slightly smaller dimensions
local BH    = 32    -- reduced from 38
local BW    = 105   -- reduced from 118
local SW    = 75    -- reduced from 88
local GAP   = 5     -- reduced from 6
local L_X   = 6     
local Y_TOP = 60    -- moved up from 80

local Y1 = Y_TOP
local Y2 = Y1 + BH + GAP
local Y3 = Y2 + BH + GAP
local Y4 = Y3 + BH + GAP
local RB_X = SW + L_X + 6
local RY1 = Y1
local RY2 = RY1 + BH + GAP
local RY3 = RY2 + BH + GAP
local RY4 = RY3 + BH + GAP
local RY5 = RY4 + BH + GAP
local RY6 = RY5 + BH + GAP
local RY7 = RY6 + BH + GAP

-- Top Right side buttons
local TOP_RIGHT_X = 1
local TOP_RIGHT_OFFSET = -130
local TRY1 = Y1
local TRY2 = TRY1 + BH + GAP

local function MakeMainBtnTopRight(labelText, xScale, xOff, yScale, yOff, w, h)
    local b = Instance.new("TextButton", Lib)
    b.Size = UDim2.new(0, w, 0, h)
    b.Position = UDim2.new(xScale, xOff, yScale, yOff)
    b.Text = ""; b.AutoButtonColor = false
    b.BackgroundColor3 = C_BG
    b.BackgroundTransparency = 0.15
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 9)
    local s = Instance.new("UIStroke", b)
    s.Color = C_BORDER; s.Thickness = 1; s.Transparency = 0.2
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    MakeDraggable(b)
    local dot = Instance.new("Frame", b)
    dot.Name = "StatusDot"
    dot.Size = UDim2.new(0, 7, 0, 7)
    dot.Position = UDim2.new(0, 8, 0.5, -3)
    dot.BackgroundColor3 = C_DOT_OFF; dot.BorderSizePixel = 0
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
    local lbl = Instance.new("TextLabel", b)
    lbl.Name = "Label"
    lbl.Size = UDim2.new(1, -34, 1, 0)
    lbl.Position = UDim2.new(0, 22, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = labelText; lbl.TextColor3 = C_TEXT
    lbl.Font = Enum.Font.Gotham; lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    return b
end

local function MakeSideBtnV2(labelText, xScale, xOff, yScale, yOff, w, h)
    local b = Instance.new("TextButton", Lib)
    b.Size = UDim2.new(0, w, 0, h)
    b.Position = UDim2.new(xScale, xOff, yScale, yOff)
    b.Text = labelText; b.TextColor3 = C_TEXT
    b.Font = Enum.Font.GothamBold; b.TextSize = 12
    b.AutoButtonColor = false
    b.BackgroundColor3 = C_BG
    b.BackgroundTransparency = 0.15
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 9)
    local s = Instance.new("UIStroke", b)
    s.Color = C_BORDER; s.Thickness = 1; s.Transparency = 0.2
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    MakeDraggable(b)
    return b
end

local function MakeMainBtnV2(labelText, xScale, xOff, yScale, yOff, w, h)
    local b = Instance.new("TextButton", Lib)
    b.Size = UDim2.new(0, w, 0, h)
    b.Position = UDim2.new(xScale, xOff, yScale, yOff)
    b.Text = ""; b.AutoButtonColor = false
    b.BackgroundColor3 = C_BG
    b.BackgroundTransparency = 0.15
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 9)
    local s = Instance.new("UIStroke", b)
    s.Color = C_BORDER; s.Thickness = 1; s.Transparency = 0.2
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    MakeDraggable(b)
    local dot = Instance.new("Frame", b)
    dot.Name = "StatusDot"
    dot.Size = UDim2.new(0, 7, 0, 7)
    dot.Position = UDim2.new(0, 8, 0.5, -3)
    dot.BackgroundColor3 = C_DOT_OFF; dot.BorderSizePixel = 0
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
    local lbl = Instance.new("TextLabel", b)
    lbl.Name = "Label"
    lbl.Size = UDim2.new(1, -34, 1, 0)
    lbl.Position = UDim2.new(0, 22, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = labelText; lbl.TextColor3 = C_TEXT
    lbl.Font = Enum.Font.Gotham; lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    return b
end

local function updateButtonState(button, isActive, activeText, inactiveText)
    button.BackgroundColor3 = isActive and C_ACTIVE or C_BG
    button.BackgroundTransparency = 0
    local dot = button:FindFirstChild("StatusDot")
    if dot then dot.BackgroundColor3 = isActive and C_DOT_ON or C_DOT_OFF end
    local lbl = button:FindFirstChild("Label")
    if lbl then lbl.Text = isActive and activeText or inactiveText end
end

-- Title Bar (slightly smaller)
local TitleBar = Instance.new("TextButton", Lib)
TitleBar.Size = UDim2.new(0, 260, 0, 38)
TitleBar.Position = UDim2.new(0.5, -130, 0, 6)
TitleBar.BackgroundColor3 = C_BG
TitleBar.BackgroundTransparency = 0.15
TitleBar.Text = "FACTION DUELS"
TitleBar.TextColor3 = Color3.fromRGB(255, 0, 0)
TitleBar.Font = Enum.Font.GothamBold
TitleBar.TextSize = 18
TitleBar.AutoButtonColor = false
TitleBar.BorderSizePixel = 0
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 9)
local tbStroke = Instance.new("UIStroke", TitleBar)
tbStroke.Color = C_BORDER; tbStroke.Thickness = 1; tbStroke.Transparency = 0.2
MakeDraggable(TitleBar)

local tauntButtons = {}
tauntButtons["TAUNT"] = MakeSideBtnV2("•FD SOLOS•", 0, L_X, 0, Y2, SW + 15, BH)
tauntButtons["DROP"]  = MakeSideBtnV2("DROP",     0, L_X, 0, Y3, SW, BH)
tauntButtons["TP Down"] = MakeSideBtnV2("TP Down", 0, L_X, 0, Y4, SW, BH)

local buttons = {}
buttons["Aimbot [X]"] = MakeMainBtnV2("Aimbot [X]",      0, RB_X, 0, RY1, BW, BH)
buttons["autoleft"]   = MakeMainBtnV2("Auto Left [Z]",    0, RB_X, 0, RY2, BW, BH)
buttons["autoright"]  = MakeMainBtnV2("Auto Right [C]",   0, RB_X, 0, RY3, BW, BH)
buttons["float"]      = MakeMainBtnV2("Float [T]",        0, RB_X, 0, RY4, BW, BH)
buttons["Float V2"]   = MakeMainBtnV2("Float V2 [B]",     0, RB_X, 0, RY5, BW, BH)
buttons["Auto Steal"] = MakeMainBtnV2("Auto Steal [S]",   0, RB_X, 0, RY6, BW, BH)
buttons["Hit TP"]     = MakeMainBtnV2("Hit TP [V]",       0, RB_X, 0, RY7, BW, BH)

local topRightButtons = {}
topRightButtons["Infinite Jump"] = MakeMainBtnTopRight("Infinite Jump [J]", TOP_RIGHT_X, TOP_RIGHT_OFFSET, 0, TRY1, BW, BH)
topRightButtons["Anti-Ragdoll"] = MakeMainBtnTopRight("Anti-Ragdoll [R]", TOP_RIGHT_X, TOP_RIGHT_OFFSET, 0, TRY2, BW, BH)

startMovement = function(mode, button)
    patrolMode = mode; currentWaypoint = 1
    local btn = button
    if not btn then
        btn = (mode == "right") and buttons["autoright"] or buttons["autoleft"]
    end
    if mode == "right" then
        updateButtonState(btn, true, "Auto Right [ON]", "Auto Right [C]")
    else
        updateButtonState(btn, true, "Auto Left [ON]", "Auto Left [Z]")
    end
end

stopMovement = function(rightButton, leftButton)
    patrolMode = "none"; currentWaypoint = 1
    waitingForCountdownLeft = false; waitingForCountdownRight = false
    updateButtonState(rightButton, false, "", "Auto Right [C]")
    updateButtonState(leftButton,  false, "", "Auto Left [Z]")
    local char = player.Character
    if char then
        local root = char:FindFirstChild("HumanoidRootPart")
        if root then root.AssemblyLinearVelocity = Vector3.new(0, root.AssemblyLinearVelocity.Y, 0) end
    end
end

buttons["float"].MouseButton1Click:Connect(function()
    floating = not floating
    if floating then
        updateButtonState(buttons["float"], true, "Float [ON]", "Float [T]")
        startFloat()
    else
        updateButtonState(buttons["float"], false, "", "Float [T]")
        stopFloat()
    end
end)

buttons["Float V2"].MouseButton1Click:Connect(function()
    floatingV2 = not floatingV2
    if floatingV2 then
        updateButtonState(buttons["Float V2"], true, "Float V2 [ON]", "Float V2 [B]")
        startFloatV2()
    else
        updateButtonState(buttons["Float V2"], false, "", "Float V2 [B]")
        stopFloatV2()
    end
end)

buttons["autoright"].MouseButton1Click:Connect(function()
    if patrolMode == "right" or waitingForCountdownRight then
        stopMovement(buttons["autoright"], buttons["autoleft"])
    else
        local ok, label = pcall(function()
            return player.PlayerGui:FindFirstChild("DuelsMachineTopFrame")
                and player.PlayerGui.DuelsMachineTopFrame:FindFirstChild("DuelsMachineTopFrame")
                and player.PlayerGui.DuelsMachineTopFrame.DuelsMachineTopFrame:FindFirstChild("Timer")
                and player.PlayerGui.DuelsMachineTopFrame.DuelsMachineTopFrame.Timer:FindFirstChild("Label")
        end)
        if ok and label and isTimerInCountdown(label) then
            waitingForCountdownRight = true
            buttons["autoright"]:FindFirstChild("Label").Text = "Waiting..."
            buttons["autoright"]:FindFirstChild("StatusDot").BackgroundColor3 = Color3.fromRGB(220,180,50)
        else
            startMovement("right", buttons["autoright"])
        end
    end
end)

buttons["autoleft"].MouseButton1Click:Connect(function()
    if patrolMode == "left" or waitingForCountdownLeft then
        stopMovement(buttons["autoright"], buttons["autoleft"])
    else
        local ok, label = pcall(function()
            return player.PlayerGui:FindFirstChild("DuelsMachineTopFrame")
                and player.PlayerGui.DuelsMachineTopFrame:FindFirstChild("DuelsMachineTopFrame")
                and player.PlayerGui.DuelsMachineTopFrame.DuelsMachineTopFrame:FindFirstChild("Timer")
                and player.PlayerGui.DuelsMachineTopFrame.DuelsMachineTopFrame.Timer:FindFirstChild("Label")
        end)
        if ok and label and isTimerInCountdown(label) then
            waitingForCountdownLeft = true
            buttons["autoleft"]:FindFirstChild("Label").Text = "Waiting..."
            buttons["autoleft"]:FindFirstChild("StatusDot").BackgroundColor3 = Color3.fromRGB(220,180,50)
        else
            startMovement("left", buttons["autoleft"])
        end
    end
end)

buttons["Aimbot [X]"].MouseButton1Click:Connect(function()
    batAimbotActive = not batAimbotActive
    if batAimbotActive then
        updateButtonState(buttons["Aimbot [X]"], true, "Aimbot [ON]", "Aimbot [X]")
        startBatAimbot()
    else
        updateButtonState(buttons["Aimbot [X]"], false, "", "Aimbot [X]")
        stopBatAimbot()
    end
end)

buttons["Auto Steal"].MouseButton1Click:Connect(function()
    autoStealActive = not autoStealActive
    if autoStealActive then
        updateButtonState(buttons["Auto Steal"], true, "Auto Steal [ON]", "Auto Steal [S]")
        autoStealRescan()
        startRescanTimer()
        autoStealStart()
    else
        updateButtonState(buttons["Auto Steal"], false, "", "Auto Steal [S]")
        autoStealStop()
        if rescanTimer then
            task.cancel(rescanTimer)
            rescanTimer = nil
        end
    end
end)

buttons["Hit TP"].MouseButton1Click:Connect(function()
    hitTPActive = not hitTPActive
    if hitTPActive then
        updateButtonState(buttons["Hit TP"], true, "Hit TP [ON]", "Hit TP [V]")
        startHitTP()
    else
        updateButtonState(buttons["Hit TP"], false, "", "Hit TP [V]")
        stopHitTP()
    end
end)

topRightButtons["Infinite Jump"].MouseButton1Click:Connect(function()
    infiniteJumpActive = not infiniteJumpActive
    if infiniteJumpActive then
        updateButtonState(topRightButtons["Infinite Jump"], true, "Infinite Jump [ON]", "Infinite Jump [J]")
        startInfiniteJump()
    else
        updateButtonState(topRightButtons["Infinite Jump"], false, "", "Infinite Jump [J]")
        stopInfiniteJump()
    end
end)

topRightButtons["Anti-Ragdoll"].MouseButton1Click:Connect(function()
    antiRagdollActive = not antiRagdollActive
    if antiRagdollActive then
        updateButtonState(topRightButtons["Anti-Ragdoll"], true, "Anti-Ragdoll [ON]", "Anti-Ragdoll [R]")
        startAntiRagdoll()
    else
        updateButtonState(topRightButtons["Anti-Ragdoll"], false, "", "Anti-Ragdoll [R]")
        stopAntiRagdoll()
    end
end)

tauntButtons["TP Down"].MouseButton1Click:Connect(function()
    doTPDown()
end)

tauntButtons["DROP"].MouseButton1Click:Connect(function()
    startWalkFling()
    task.delay(0.4, stopWalkFling)
end)

local tauntActive = false
local tauntLoop = nil

tauntButtons["TAUNT"].MouseButton1Click:Connect(function()
    tauntActive = not tauntActive
    tauntButtons["TAUNT"].BackgroundColor3 = tauntActive and C_ACTIVE or C_BG
    if tauntActive then
        tauntLoop = task.spawn(function()
            while tauntActive do
                pcall(function()
                    local TCS = game:GetService("TextChatService")
                    local ch = TCS.TextChannels:FindFirstChild("RBXGeneral")
                    if ch then ch:SendAsync("•FD SOLOS•") end
                end)
                task.wait(0.5)
            end
        end)
    else
        if tauntLoop then task.cancel(tauntLoop); tauntLoop = nil end
    end
end)

heartbeatConn = RunService.Heartbeat:Connect(updateWalking)

player.CharacterAdded:Connect(function()
    task.wait(1)
    patrolMode = "none"; currentWaypoint = 1
    waitingForCountdownLeft = false; waitingForCountdownRight = false
    floating = false; floatingV2 = false; batAimbotActive = false; hitTPActive = false; antiRagdollActive = false; infiniteJumpActive = false; autoStealActive = false
    updateButtonState(buttons["autoright"],  false, "", "Auto Right [C]")
    updateButtonState(buttons["autoleft"],   false, "", "Auto Left [Z]")
    updateButtonState(buttons["float"],      false, "", "Float [T]")
    updateButtonState(buttons["Float V2"],   false, "", "Float V2 [B]")
    updateButtonState(buttons["Aimbot [X]"], false, "", "Aimbot [X]")
    updateButtonState(buttons["Auto Steal"], false, "", "Auto Steal [S]")
    updateButtonState(buttons["Hit TP"],     false, "", "Hit TP [V]")
    updateButtonState(topRightButtons["Infinite Jump"], false, "", "Infinite Jump [J]")
    updateButtonState(topRightButtons["Anti-Ragdoll"], false, "", "Anti-Ragdoll [R]")
    stopBatAimbot()
    stopHitTP()
    stopAntiRagdoll()
    stopInfiniteJump()
    autoStealStop()
    if rescanTimer then
        task.cancel(rescanTimer)
        rescanTimer = nil
    end
    ragdollAutoActive = false; ragdollWasActive = false
    stopRagdollDetector()
    if unwalkActive then startUnwalk() end
    if stealSpeedActive then startStealSpeed() end
    if spinActive then startSpinBot() end
    if antiFlingActive then startAntiFling() end
    if stealActive then startStealLoop() end
end)

local function onTextChanged(label)
    local ok, number = isCountdownNumber(label.Text)
    if ok and number == 1 then
        if waitingForCountdownLeft then
            task.wait(AUTO_START_DELAY)
            waitingForCountdownLeft = false
            startMovement("left", buttons["autoleft"])
        end
        if waitingForCountdownRight then
            task.wait(AUTO_START_DELAY)
            waitingForCountdownRight = false
            startMovement("right", buttons["autoright"])
        end
    end
end

spawn(function()
    local ok, label = pcall(function()
        return player.PlayerGui:FindFirstChild("DuelsMachineTopFrame")
            and player.PlayerGui.DuelsMachineTopFrame:FindFirstChild("DuelsMachineTopFrame")
            and player.PlayerGui.DuelsMachineTopFrame.DuelsMachineTopFrame:FindFirstChild("Timer")
            and player.PlayerGui.DuelsMachineTopFrame.DuelsMachineTopFrame.Timer:FindFirstChild("Label")
    end)
    if ok and label then
        onTextChanged(label)
        label:GetPropertyChangedSignal("Text"):Connect(function() onTextChanged(label) end)
    end
end)

Lib.Destroying:Connect(function()
    if heartbeatConn then heartbeatConn:Disconnect() end
end)
