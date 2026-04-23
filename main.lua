-- [[ Crystal Hub - Final Complete Version ]] --

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Player = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CrystalPurple = Color3.fromRGB(120, 0, 255)
local RightPartColor = Color3.fromRGB(0, 0, 0)
local RightPartTrans = 0.15
local LeftPartTrans = 0.5

local Toggles = {
    Esp = false,
    BatAimbot = false,
    AutoSteal = false,
    AutoMedusa = false,
    AutoPlay = false,
    AntiFling = false,
    AntiRagdoll = false,
    NoWalk = false,
    InfJump = false,
    Spin = false,
    Optimizer = false,
}

-- ========== ESP PLAYER ==========
local espConnections = {}

local function createESP(plr)
    if plr == Player then return end
    if not plr.Character then return end
    if plr.Character:FindFirstChild("ESP_BLUE") then return end
    local char = plr.Character
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local head = char:FindFirstChild("Head")
    if not (hrp and head) then return end
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP_BLUE"
    highlight.FillColor = CrystalPurple
    highlight.OutlineColor = CrystalPurple
    highlight.FillTransparency = 0.2
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = char
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_Name"
    billboard.Adornee = head
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = char
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = plr.DisplayName or plr.Name
    label.TextColor3 = CrystalPurple
    label.Font = Enum.Font.GothamBold
    label.TextScaled = true
    label.Parent = billboard
end

local function removeESP(plr)
    if not plr.Character then return end
    local char = plr.Character
    local highlight = char:FindFirstChild("ESP_BLUE")
    if highlight then highlight:Destroy() end
    local name = char:FindFirstChild("ESP_Name")
    if name then name:Destroy() end
end

local function toggleESP(enable)
    if enable then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= Player then
                if plr.Character then createESP(plr) end
                local conn = plr.CharacterAdded:Connect(function()
                    task.wait(0.2)
                    if Toggles.Esp then createESP(plr) end
                end)
                table.insert(espConnections, conn)
            end
        end
        local conn = Players.PlayerAdded:Connect(function(plr)
            if plr == Player then return end
            local c = plr.CharacterAdded:Connect(function()
                task.wait(0.2)
                if Toggles.Esp then createESP(plr) end
            end)
            table.insert(espConnections, c)
        end)
        table.insert(espConnections, conn)
    else
        for _, plr in ipairs(Players:GetPlayers()) do removeESP(plr) end
        for _, conn in ipairs(espConnections) do
            if conn and conn.Connected then conn:Disconnect() end
        end
        espConnections = {}
    end
end

-- ========== BAT AIMBOT (بدون دائرة) ==========
local AimbotState = false
local AimbotData = { Conn = nil, Align = nil, Attach = nil }

local function startBatAimbot()
    local char = Player.Character or Player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    
    AimbotData.Attach = Instance.new("Attachment", hrp)
    AimbotData.Align = Instance.new("AlignOrientation", hrp)
    AimbotData.Align.Attachment0 = AimbotData.Attach
    AimbotData.Align.Mode = Enum.OrientationAlignmentMode.OneAttachment
    AimbotData.Align.RigidityEnabled = true
    
    AimbotData.Conn = RunService.RenderStepped:Connect(function()
        if not AimbotState or not char.Parent then return end
        local target, dmin = nil, 7.25
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= Player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local d = (plr.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
                if d <= dmin then
                    target = plr.Character.HumanoidRootPart
                    dmin = d
                end
            end
        end
        
        if target then
            char.Humanoid.AutoRotate = false
            AimbotData.Align.Enabled = true
            AimbotData.Align.CFrame = CFrame.lookAt(hrp.Position, Vector3.new(target.Position.X, hrp.Position.Y, target.Position.Z))
            local tool = char:FindFirstChild("Bat") or char:FindFirstChild("Medusa's Head")
            if tool then pcall(function() tool:Activate() end) end
        else
            AimbotData.Align.Enabled = false
            char.Humanoid.AutoRotate = true
        end
    end)
end

local function stopBatAimbot()
    if AimbotData.Conn then AimbotData.Conn:Disconnect() end
    if AimbotData.Align then AimbotData.Align:Destroy() end
    if AimbotData.Attach then AimbotData.Attach:Destroy() end
    if Player.Character and Player.Character:FindFirstChild("Humanoid") then
        Player.Character.Humanoid.AutoRotate = true
    end
    AimbotData = { Conn = nil, Align = nil, Attach = nil }
end

-- ========== AUTO STEAL (مع دائرة بنفسجية) ==========
local AutoStealState = false
local isStealing = false
local stealStartTime = nil
local progressConnection = nil
local StealData = {}
local STEAL_DURATION = 1.3
local STEAL_RADIUS = 30

-- دائرة Auto Steal البنفسجية
local stealCircle = nil
local function createStealCircle()
    if stealCircle then stealCircle:Destroy() end
    stealCircle = Instance.new("Part")
    stealCircle.Name = "StealCircle"
    stealCircle.Anchored = true
    stealCircle.CanCollide = false
    stealCircle.Transparency = 0.5
    stealCircle.Color = CrystalPurple
    stealCircle.Material = Enum.Material.Neon
    stealCircle.Shape = Enum.PartType.Cylinder
    stealCircle.Size = Vector3.new(0.05, STEAL_RADIUS * 2, STEAL_RADIUS * 2)
    stealCircle.Parent = workspace
end
createStealCircle()

RunService.RenderStepped:Connect(function()
    if Toggles.AutoSteal then
        local char = Player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local root = char.HumanoidRootPart
            stealCircle.Transparency = 0.4
            stealCircle.CFrame = CFrame.new(root.Position + Vector3.new(0, -2.8, 0)) * CFrame.Angles(0, 0, math.rad(90))
        end
    else
        if stealCircle then stealCircle.Transparency = 1 end
    end
end)

-- شريط التقدم
local ScreenProgressFrame = nil
local ScreenProgressBarFill = nil
local ScreenProgressLabel = nil
local ScreenProgressPercentLabel = nil

local function createProgressBar()
    if ScreenProgressFrame then return end
    ScreenProgressFrame = Instance.new("Frame")
    ScreenProgressFrame.Name = "StealProgressBar"
    ScreenProgressFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    ScreenProgressFrame.BorderSizePixel = 0
    ScreenProgressFrame.Position = UDim2.new(0.5, -150, 0, 20)
    ScreenProgressFrame.Size = UDim2.new(0, 300, 0, 30)
    ScreenProgressFrame.Parent = ScreenGui
    
    Instance.new("UICorner", ScreenProgressFrame).CornerRadius = UDim.new(0, 8)
    local stroke = Instance.new("UIStroke", ScreenProgressFrame)
    stroke.Color = CrystalPurple
    stroke.Thickness = 2
    
    ScreenProgressLabel = Instance.new("TextLabel")
    ScreenProgressLabel.BackgroundTransparency = 1
    ScreenProgressLabel.Position = UDim2.new(0, 10, 0, 0)
    ScreenProgressLabel.Size = UDim2.new(0.6, 0, 1, 0)
    ScreenProgressLabel.Font = Enum.Font.GothamBold
    ScreenProgressLabel.Text = "READY"
    ScreenProgressLabel.TextColor3 = CrystalPurple
    ScreenProgressLabel.TextSize = 12
    ScreenProgressLabel.TextXAlignment = Enum.TextXAlignment.Left
    ScreenProgressLabel.Parent = ScreenProgressFrame
    
    ScreenProgressPercentLabel = Instance.new("TextLabel")
    ScreenProgressPercentLabel.BackgroundTransparency = 1
    ScreenProgressPercentLabel.Position = UDim2.new(0.6, 0, 0, 0)
    ScreenProgressPercentLabel.Size = UDim2.new(0.4, -10, 1, 0)
    ScreenProgressPercentLabel.Font = Enum.Font.GothamBold
    ScreenProgressPercentLabel.Text = "0%"
    ScreenProgressPercentLabel.TextColor3 = CrystalPurple
    ScreenProgressPercentLabel.TextSize = 12
    ScreenProgressPercentLabel.TextXAlignment = Enum.TextXAlignment.Right
    ScreenProgressPercentLabel.Parent = ScreenProgressFrame
    
    local track = Instance.new("Frame")
    track.BackgroundColor3 = Color3.fromRGB(50, 40, 0)
    track.Position = UDim2.new(0, 10, 0, 22)
    track.Size = UDim2.new(1, -20, 0, 8)
    track.Parent = ScreenProgressFrame
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)
    
    ScreenProgressBarFill = Instance.new("Frame")
    ScreenProgressBarFill.BackgroundColor3 = CrystalPurple
    ScreenProgressBarFill.Size = UDim2.new(0, 0, 1, 0)
    ScreenProgressBarFill.Parent = track
    Instance.new("UICorner", ScreenProgressBarFill).CornerRadius = UDim.new(1, 0)
end

local function ResetProgressBar()
    if ScreenProgressLabel then ScreenProgressLabel.Text = "READY" end
    if ScreenProgressPercentLabel then ScreenProgressPercentLabel.Text = "0%" end
    if ScreenProgressBarFill then ScreenProgressBarFill.Size = UDim2.new(0, 0, 1, 0) end
end

local function isMyPlotByName(pn)
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return false end
    local plot = plots:FindFirstChild(pn)
    if not plot then return false end
    local sign = plot:FindFirstChild("PlotSign")
    if sign then
        local yb = sign:FindFirstChild("YourBase")
        if yb and yb:IsA("BillboardGui") then return yb.Enabled == true end
    end
    return false
end

local function findNearestPrompt()
    local h = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    if not h then return nil end
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return nil end
    local np, nd, nn = nil, math.huge, nil
    for _, plot in ipairs(plots:GetChildren()) do
        if isMyPlotByName(plot.Name) then
        else
            local podiums = plot:FindFirstChild("AnimalPodiums")
            if podiums then
                for _, pod in ipairs(podiums:GetChildren()) do
                    pcall(function()
                        local base = pod:FindFirstChild("Base")
                        local spawn = base and base:FindFirstChild("Spawn")
                        if spawn then
                            local dist = (spawn.Position - h.Position).Magnitude
                            if dist < nd and dist <= STEAL_RADIUS then
                                local att = spawn:FindFirstChild("PromptAttachment")
                                if att then
                                    for _, ch in ipairs(att:GetChildren()) do
                                        if ch:IsA("ProximityPrompt") then np, nd, nn = ch, dist, pod.Name end
                                    end
                                end
                            end
                        end
                    end)
                end
            end
        end
    end
    return np, nd, nn
end

local function executeSteal(prompt, name)
    if isStealing then return end
    if not StealData[prompt] then
        StealData[prompt] = {hold = {}, trigger = {}, ready = true}
        pcall(function()
            if getconnections then
                for _, c in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do
                    if c.Function then table.insert(StealData[prompt].hold, c.Function) end
                end
                for _, c in ipairs(getconnections(prompt.Triggered)) do
                    if c.Function then table.insert(StealData[prompt].trigger, c.Function) end
                end
            end
        end)
    end
    local data = StealData[prompt]
    if not data.ready then return end
    data.ready = false
    isStealing = true
    stealStartTime = tick()
    if ScreenProgressLabel then ScreenProgressLabel.Text = name or "STEALING..." end
    if progressConnection then progressConnection:Disconnect() end
    progressConnection = RunService.Heartbeat:Connect(function()
        if not isStealing then progressConnection:Disconnect() return end
        local prog = math.clamp((tick() - stealStartTime) / STEAL_DURATION, 0, 1)
        if ScreenProgressBarFill then ScreenProgressBarFill.Size = UDim2.new(prog, 0, 1, 0) end
        if ScreenProgressPercentLabel then ScreenProgressPercentLabel.Text = math.floor(prog * 100) .. "%" end
    end)
    task.spawn(function()
        for _, f in ipairs(data.hold) do task.spawn(f) end
        task.wait(STEAL_DURATION)
        for _, f in ipairs(data.trigger) do task.spawn(f) end
        if progressConnection then progressConnection:Disconnect() end
        ResetProgressBar()
        data.ready = true
        isStealing = false
    end)
end

local autoStealConn = nil
local function startAutoSteal()
    if autoStealConn then return end
    autoStealConn = RunService.Heartbeat:Connect(function()
        if not AutoStealState or isStealing then return end
        local p, _, n = findNearestPrompt()
        if p then executeSteal(p, n) end
    end)
end
local function stopAutoSteal()
    if autoStealConn then autoStealConn:Disconnect() autoStealConn = nil end
    isStealing = false
    ResetProgressBar()
end

-- ========== AUTO MEDUSA (مع دائرة بنفسجية) ==========
local medusaCircle = nil
local medusaLastUse = 0
local MEDUSA_RADIUS = 10
local MEDUSA_DELAY = 0.15

local function createMedusaCircle()
    if medusaCircle then medusaCircle:Destroy() end
    medusaCircle = Instance.new("Part")
    medusaCircle.Name = "MedusaCircle"
    medusaCircle.Anchored = true
    medusaCircle.CanCollide = false
    medusaCircle.Transparency = 0.5
    medusaCircle.Color = CrystalPurple
    medusaCircle.Material = Enum.Material.Neon
    medusaCircle.Shape = Enum.PartType.Cylinder
    medusaCircle.Size = Vector3.new(0.05, MEDUSA_RADIUS * 2, MEDUSA_RADIUS * 2)
    medusaCircle.Parent = workspace
end
createMedusaCircle()

RunService.RenderStepped:Connect(function()
    if Toggles.AutoMedusa then
        local char = Player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local root = char.HumanoidRootPart
            medusaCircle.Transparency = 0.4
            medusaCircle.CFrame = CFrame.new(root.Position + Vector3.new(0, -2.8, 0)) * CFrame.Angles(0, 0, math.rad(90))
        end
    else
        if medusaCircle then medusaCircle.Transparency = 1 end
    end
end)

task.spawn(function()
    while true do
        if Toggles.AutoMedusa then
            pcall(function()
                local char = Player.Character
                if not char then return end
                local root = char:FindFirstChild("HumanoidRootPart")
                if not root then return end
                local tool = nil
                for _, t in ipairs(char:GetChildren()) do
                    if t:IsA("Tool") and t.Name == "Medusa's Head" then
                        tool = t
                        break
                    end
                end
                if tool and tick() - medusaLastUse >= MEDUSA_DELAY then
                    for _, plr in ipairs(Players:GetPlayers()) do
                        if plr ~= Player then
                            local pChar = plr.Character
                            local pRoot = pChar and pChar:FindFirstChild("HumanoidRootPart")
                            if pRoot and (pRoot.Position - root.Position).Magnitude <= MEDUSA_RADIUS then
                                tool:Activate()
                                medusaLastUse = tick()
                                break
                            end
                        end
                    end
                end
            end)
        end
        task.wait(0.1)
    end
end)

-- ========== AUTO PLAY (من Ambitious Hub) ==========
local pathActive = false
local lastFlatVel = Vector3.zero
local PATH_VELOCITY_SPEED = 59.2
local PATH_SECOND_SPEED = 29.6
local PATH_BASE_STOP = 1.35
local PATH_MIN_STOP = 0.65
local PATH_NEXT_POINT_BIAS = 0.45
local PATH_SMOOTH_FACTOR = 0.12

local stealPath1 = {
    {pos = Vector3.new(-470.6, -5.9, 34.4)},
    {pos = Vector3.new(-484.2, -3.9, 21.4)},
    {pos = Vector3.new(-475.6, -5.8, 29.3)},
    {pos = Vector3.new(-473.4, -5.9, 111)}
}

local function pathMoveToPoint(hrp, current, nextPoint, speed)
    local conn
    conn = RunService.Heartbeat:Connect(function()
        if not pathActive then
            conn:Disconnect()
            hrp.AssemblyLinearVelocity = Vector3.zero
            return
        end
        local pos = hrp.Position
        local target = Vector3.new(current.X, pos.Y, current.Z)
        local dir = target - pos
        local dist = dir.Magnitude
        local stopDist = math.clamp(PATH_BASE_STOP - dist * 0.04, PATH_MIN_STOP, PATH_BASE_STOP)
        if dist <= stopDist then
            conn:Disconnect()
            hrp.AssemblyLinearVelocity = Vector3.zero
            return
        end
        local moveDir = dir.Unit
        if nextPoint then
            local nextDir = (Vector3.new(nextPoint.X, pos.Y, nextPoint.Z) - pos).Unit
            moveDir = (moveDir + nextDir * PATH_NEXT_POINT_BIAS).Unit
        end
        if lastFlatVel.Magnitude > 0.1 then
            moveDir = (moveDir * (1 - PATH_SMOOTH_FACTOR) + lastFlatVel.Unit * PATH_SMOOTH_FACTOR).Unit
        end
        local vel = Vector3.new(moveDir.X * speed, hrp.AssemblyLinearVelocity.Y, moveDir.Z * speed)
        hrp.AssemblyLinearVelocity = vel
        lastFlatVel = Vector3.new(vel.X, 0, vel.Z)
    end)
    while pathActive and (Vector3.new(hrp.Position.X, 0, hrp.Position.Z) - Vector3.new(current.X, 0, current.Z)).Magnitude > PATH_BASE_STOP do
        RunService.Heartbeat:Wait()
    end
end

local function runStealPath(path)
    local hrp = (Player.Character or Player.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart")
    for i, p in ipairs(path) do
        if not pathActive then return end
        local speed = i > 2 and PATH_SECOND_SPEED or PATH_VELOCITY_SPEED
        local nextP = path[i + 1] and path[i + 1].pos
        pathMoveToPoint(hrp, p.pos, nextP, speed)
        if i == 2 then task.wait(0.2) else task.wait(0.01) end
    end
end

local function startAutoPlay()
    if pathActive then return end
    pathActive = true
    task.spawn(function()
        while pathActive and Toggles.AutoPlay do
            runStealPath(stealPath1)
            task.wait(0.1)
        end
    end)
end

local function stopAutoPlay()
    pathActive = false
    local hrp = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then hrp.AssemblyLinearVelocity = Vector3.zero end
end

-- ========== ANTI FLING ==========
local antiFlingConn = nil
local function startAntiFling()
    if antiFlingConn then return end
    antiFlingConn = RunService.Heartbeat:Connect(function()
        if Toggles.AntiFling and Player.Character then
            local hrp = Player.Character:FindFirstChild("HumanoidRootPart")
            if hrp and hrp.AssemblyLinearVelocity.Magnitude > 150 then
                hrp.AssemblyLinearVelocity = Vector3.zero
            end
        end
    end)
end
local function stopAntiFling()
    if antiFlingConn then antiFlingConn:Disconnect() antiFlingConn = nil end
end

-- ========== ANTI RAGDOLL (متطور) ==========
local antiRagdollActive = false
local ragdollDisabled = false
local ragdollDisableFunc = nil

local function initAntiRagdoll()
    local ok, ragdollRemote = pcall(function()
        return ReplicatedStorage:WaitForChild("Packages", 5):WaitForChild("Ragdoll", 5):WaitForChild("Ragdoll", 5)
    end)
    if not ok then return nil end

    local PlayerModule = require(Player:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule"))
    local Controls = PlayerModule:GetControls()
    local updating = false

    local function getRoot()
        return Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    end

    local function forceEnableControls(duration)
        local start = tick()
        RunService.RenderStepped:Connect(function()
            if ragdollDisabled or tick() - start > duration then return end
            Controls:Enable()
        end)
    end

    local function addLinearVelocity()
        if ragdollDisabled then return end
        local root = getRoot()
        local humanoid = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
        if not root or not humanoid then return end

        if not root:FindFirstChild("AntiRagdollLV") then
            local attachment = Instance.new("Attachment")
            attachment.Name = "AntiRagdollAttachment"
            attachment.Parent = root
            local lv = Instance.new("LinearVelocity")
            lv.Name = "AntiRagdollLV"
            lv.Attachment0 = attachment
            lv.MaxForce = math.huge
            lv.RelativeTo = Enum.ActuatorRelativeTo.World
            lv.Parent = root
        end

        forceEnableControls(0.1)
        humanoid:ChangeState(Enum.HumanoidStateType.Freefall)

        if not updating then
            updating = true
            task.spawn(function()
                while not ragdollDisabled and getRoot() and getRoot():FindFirstChild("AntiRagdollLV") do
                    local root2 = getRoot()
                    local hum2 = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
                    local lv = root2 and root2:FindFirstChild("AntiRagdollLV")
                    if lv and hum2 then
                        local dir = hum2.MoveDirection
                        lv.VectorVelocity = dir.Magnitude > 0.1 and (dir.Unit * hum2.WalkSpeed) or Vector3.zero
                    end
                    task.wait(0.05)
                end
                updating = false
            end)
        end
    end

    local function removeLinearVelocity()
        local root = getRoot()
        if not root then return end
        local lv = root:FindFirstChild("AntiRagdollLV")
        if lv then lv:Destroy() end
        local att = root:FindFirstChild("AntiRagdollAttachment")
        if att then att:Destroy() end
    end

    Player.AttributeChanged:Connect(function(attr)
        if ragdollDisabled then return end
        if attr == "RagdollEndTime" and Player:GetAttribute("RagdollEndTime") then
            addLinearVelocity()
        else
            removeLinearVelocity()
        end
    end)

    if ragdollRemote then
        ragdollRemote.OnClientEvent:Connect(function(p1, p2)
            if ragdollDisabled then return end
            if p1 == "Destroy" or p2 == "manualD" then
                removeLinearVelocity()
            end
        end)
    end

    return function()
        ragdollDisabled = true
        removeLinearVelocity()
    end
end

local function startAntiRagdoll()
    if antiRagdollActive then return end
    antiRagdollActive = true
    ragdollDisabled = false
    ragdollDisableFunc = initAntiRagdoll()
end

local function stopAntiRagdoll()
    antiRagdollActive = false
    if ragdollDisableFunc then ragdollDisableFunc() end
    ragdollDisabled = true
    ragdollDisableFunc = nil
end

-- ========== NO WALK ==========
local NoAnimState = false
local NoAnimConnections = {}

local function disableAnims(character)
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
        track:Stop()
    end
    if NoAnimConnections[character] then
        NoAnimConnections[character]:Disconnect()
    end
    NoAnimConnections[character] = humanoid.AnimationPlayed:Connect(function(track)
        track:Stop()
    end)
end

local function startNoWalk()
    if NoAnimState then return end
    NoAnimState = true
    local char = Player.Character
    if char then disableAnims(char) end
    if NoAnimConnections.characterAdded then
        NoAnimConnections.characterAdded:Disconnect()
    end
    NoAnimConnections.characterAdded = Player.CharacterAdded:Connect(function(newChar)
        disableAnims(newChar)
    end)
end

local function stopNoWalk()
    NoAnimState = false
    if NoAnimConnections.characterAdded then
        NoAnimConnections.characterAdded:Disconnect()
        NoAnimConnections.characterAdded = nil
    end
    for character, conn in pairs(NoAnimConnections) do
        if character ~= "characterAdded" then
            conn:Disconnect()
            NoAnimConnections[character] = nil
        end
    end
end

-- ========== INFINITE JUMP ==========
local InfiniteJumpState = false
local InfiniteJumpConn = nil
local JUMP_POWER = 50
local COOLDOWN = 0.15
local lastJump = 0

local function startInfJump()
    if InfiniteJumpConn then return end
    InfiniteJumpConn = UserInputService.JumpRequest:Connect(function()
        if not InfiniteJumpState then return end
        local char = Player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hrp and hum then
            if hum.FloorMaterial == Enum.Material.Air then
                local now = tick()
                if now - lastJump >= COOLDOWN then
                    lastJump = now
                    hrp.Velocity = Vector3.new(hrp.Velocity.X, JUMP_POWER, hrp.Velocity.Z)
                end
            end
        end
    end)
end

local function stopInfJump()
    if InfiniteJumpConn then InfiniteJumpConn:Disconnect() InfiniteJumpConn = nil end
end

-- ========== SPIN (HELICOPTER) ==========
local HelicopterState = false
local spinBAV = nil
local SPIN_SPEED = 30

local function startSpin()
    local c = Player.Character
    if not c then return end
    local hrp = c:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if spinBAV then spinBAV:Destroy() spinBAV = nil end
    spinBAV = Instance.new("BodyAngularVelocity")
    spinBAV.Name = "SpinBAV"
    spinBAV.MaxTorque = Vector3.new(0, math.huge, 0)
    spinBAV.AngularVelocity = Vector3.new(0, SPIN_SPEED, 0)
    spinBAV.Parent = hrp
end

local function stopSpin()
    if spinBAV then spinBAV:Destroy() spinBAV = nil end
    local c = Player.Character
    if c then
        local hrp = c:FindFirstChild("HumanoidRootPart")
        if hrp then
            for _, v in pairs(hrp:GetChildren()) do
                if v.Name == "SpinBAV" then v:Destroy() end
            end
        end
    end
end

-- ========== OPTIMIZER ==========
local optimizerActive = false

local function enableOptimizer()
    if optimizerActive then return end
    optimizerActive = true
    Lighting.GlobalShadows = false
    Lighting.FogStart = 0
    Lighting.FogEnd = 1e9
    Lighting.Brightness = 1
    Lighting.EnvironmentDiffuseScale = 0
    Lighting.EnvironmentSpecularScale = 0
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Material = Enum.Material.Plastic
            v.Reflectance = 0
        elseif v:IsA("Decal") or v:IsA("Texture") then
            v.Transparency = 1
        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") then
            v.Enabled = false
        end
    end
end

local function disableOptimizer()
    if not optimizerActive then return end
    optimizerActive = false
    Lighting.GlobalShadows = true
    Lighting.FogStart = 0
    Lighting.FogEnd = 100000
    Lighting.Brightness = 2
    Lighting.EnvironmentDiffuseScale = 1
    Lighting.EnvironmentSpecularScale = 1
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Material = Enum.Material.SmoothPlastic
            v.Reflectance = 0
        elseif v:IsA("Decal") or v:IsA("Texture") then
            v.Transparency = 0
        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") then
            v.Enabled = true
        end
    end
end

-- ========== GUI ==========
for _, child in pairs(CoreGui:GetChildren()) do
    if child:IsA("ScreenGui") and child.Name:find("Crystal") then
        child:Destroy()
    end
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Crystal_Final"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 9999
ScreenGui.Parent = CoreGui

createProgressBar()

local MainContainer = Instance.new("Frame", ScreenGui)
MainContainer.Size = UDim2.new(0, 250, 0, 60)
MainContainer.Position = UDim2.new(0.5, -125, 0.18, 0)
MainContainer.BackgroundTransparency = 1

local TopBar = Instance.new("Frame", MainContainer)
TopBar.Size = UDim2.new(1, 0, 0, 34)
TopBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TopBar.BackgroundTransparency = 0.15
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", TopBar).Color = CrystalPurple

local InfoLabel = Instance.new("TextLabel", TopBar)
InfoLabel.Size = UDim2.new(1, 0, 1, 0)
InfoLabel.BackgroundTransparency = 1
InfoLabel.TextColor3 = CrystalPurple
InfoLabel.TextSize = 13
InfoLabel.Font = Enum.Font.GothamBold
InfoLabel.Text = "Crystal Hub"

local BottomBar = Instance.new("Frame", MainContainer)
BottomBar.Size = UDim2.new(1, 0, 0, 16)
BottomBar.Position = UDim2.new(0, 0, 0, 40)
BottomBar.BackgroundTransparency = 1

local function CreateStat(pos, size, trans, txt)
    local f = Instance.new("Frame", BottomBar)
    f.Size = size
    f.Position = pos
    f.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    f.BackgroundTransparency = trans
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 10)
    local t = Instance.new("TextLabel", f)
    t.Size = UDim2.new(1, 0, 1, 0)
    t.BackgroundTransparency = 1
    t.Text = txt
    t.TextColor3 = Color3.fromRGB(255, 255, 255)
    t.TextSize = 10
    t.Font = Enum.Font.GothamBold
end

CreateStat(UDim2.new(0, 0, 0, 0), UDim2.new(0.49, 0, 1, 0), LeftPartTrans, "0%")
CreateStat(UDim2.new(0.51, 0, 0, 0), UDim2.new(0.49, 0, 1, 0), RightPartTrans, "7.4")

local SideMenu = Instance.new("Frame", ScreenGui)
SideMenu.Size = UDim2.new(0, 160, 0, 400)
SideMenu.Position = UDim2.new(-0.7, 0, 0.30, 0)
SideMenu.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
SideMenu.BackgroundTransparency = LeftPartTrans
Instance.new("UICorner", SideMenu).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", SideMenu).Color = CrystalPurple

local UIList = Instance.new("UIListLayout", SideMenu)
UIList.Padding = UDim.new(0, 7)
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
Instance.new("UIPadding", SideMenu).PaddingTop = UDim.new(0, 12)

local function CreateBtn(txt, parent, size, toggleKey)
    local btn = Instance.new("TextButton", parent)
    btn.Size = size or UDim2.new(0, 140, 0, 36)
    btn.BackgroundColor3 = RightPartColor
    btn.BackgroundTransparency = RightPartTrans
    btn.Text = txt
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 10
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
    Instance.new("UIStroke", btn).Color = CrystalPurple

    local function UpdateButton()
        if Toggles[toggleKey] then
            btn.BackgroundColor3 = CrystalPurple
            btn.BackgroundTransparency = 0
        else
            btn.BackgroundColor3 = RightPartColor
            btn.BackgroundTransparency = RightPartTrans
        end
    end
    UpdateButton()

    btn.MouseButton1Click:Connect(function()
        Toggles[toggleKey] = not Toggles[toggleKey]
        UpdateButton()
        
        if toggleKey == "Esp" then
            toggleESP(Toggles.Esp)
        elseif toggleKey == "BatAimbot" then
            AimbotState = Toggles.BatAimbot
            if AimbotState then startBatAimbot() else stopBatAimbot() end
        elseif toggleKey == "AutoSteal" then
            AutoStealState = Toggles.AutoSteal
            if AutoStealState then startAutoSteal() else stopAutoSteal() end
        elseif toggleKey == "AutoPlay" then
            if Toggles.AutoPlay then startAutoPlay() else stopAutoPlay() end
        elseif toggleKey == "AntiFling" then
            if Toggles.AntiFling then startAntiFling() else stopAntiFling() end
        elseif toggleKey == "AntiRagdoll" then
            if Toggles.AntiRagdoll then startAntiRagdoll() else stopAntiRagdoll() end
        elseif toggleKey == "NoWalk" then
            if Toggles.NoWalk then startNoWalk() else stopNoWalk() end
        elseif toggleKey == "InfJump" then
            InfiniteJumpState = Toggles.InfJump
            if InfiniteJumpState then startInfJump() else stopInfJump() end
        elseif toggleKey == "Spin" then
            HelicopterState = Toggles.Spin
            if HelicopterState then startSpin() else stopSpin() end
        elseif toggleKey == "Optimizer" then
            if Toggles.Optimizer then enableOptimizer() else disableOptimizer() end
        end
    end)
    return btn
end

local function Row(p)
    local f = Instance.new("Frame", p)
    f.Size = UDim2.new(0, 140, 0, 32)
    f.BackgroundTransparency = 1
    local l = Instance.new("UIListLayout", f)
    l.FillDirection = Enum.FillDirection.Horizontal
    l.Padding = UDim.new(0, 8)
    l.HorizontalAlignment = Enum.HorizontalAlignment.Center
    return f
end

-- الأزرار بالترتيب المطلوب
CreateBtn("Esp Player", SideMenu, nil, "Esp")

local R1 = Row(SideMenu)
CreateBtn("Bat Aimbot", R1, UDim2.new(0, 66, 1, 0), "BatAimbot")
CreateBtn("Auto Steal", R1, UDim2.new(0, 66, 1, 0), "AutoSteal")

local R2 = Row(SideMenu)
CreateBtn("Auto Medusa", R2, UDim2.new(0, 66, 1, 0), "AutoMedusa")
CreateBtn("Auto Play", R2, UDim2.new(0, 66, 1, 0), "AutoPlay")

local R3 = Row(SideMenu)
CreateBtn("Anti Fling", R3, UDim2.new(0, 66, 1, 0), "AntiFling")
CreateBtn("Anti Ragdoll", R3, UDim2.new(0, 66, 1, 0), "AntiRagdoll")

local R4 = Row(SideMenu)
CreateBtn("No Walk", R4, UDim2.new(0, 66, 1, 0), "NoWalk")
CreateBtn("Infinite Jump", R4, UDim2.new(0, 66, 1, 0), "InfJump")

local R5 = Row(SideMenu)
CreateBtn("Spin Player", R5, UDim2.new(0, 66, 1, 0), "Spin")
CreateBtn("Optimizer", R5, UDim2.new(0, 66, 1, 0), "Optimizer")

-- الأيقونة العائمة
local SideButton = Instance.new("TextButton", ScreenGui)
SideButton.Size = UDim2.new(0, 60, 0, 60)
SideButton.Position = UDim2.new(1, -75, 0.30, 0)
SideButton.BackgroundColor3 = CrystalPurple
SideButton.Text = ""
Instance.new("UICorner", SideButton).CornerRadius = UDim.new(0, 10)

for i = 0, 2 do
    local line = Instance.new("Frame", SideButton)
    line.Size = UDim2.new(0, 28, 0, 4)
    line.Position = UDim2.new(0.5, -14, 0, 18 + (i * 10))
    line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", line).CornerRadius = UDim.new(0, 2)
end

local menuOpen = false
SideButton.MouseButton1Click:Connect(function()
    menuOpen = not menuOpen
    if menuOpen then
        SideMenu:TweenPosition(UDim2.new(0.02, 0, 0.30, 0), "Out", "Quart", 0.4, true)
    else
        SideMenu:TweenPosition(UDim2.new(-0.7, 0, 0.30, 0), "Out", "Quart", 0.4, true)
    end
end)

-- تحديث FPS و MS
task.spawn(function()
    while true do
        pcall(function()
            local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            local fps = math.floor(1 / RunService.RenderStepped:Wait())
            InfoLabel.Text = string.format("Crystal Hub | FPS %d | MS %d", fps, ping)
        end)
        task.wait(0.5)
    end
end)

print("✓ Crystal Hub Loaded Successfully!")
print("✓ 11 Features Ready:")
print("  - Esp Player")
print("  - Bat Aimbot (No Circle)")
print("  - Auto Steal (Purple Circle + Progress Bar)")
print("  - Auto Medusa (Purple Circle)")
print("  - Auto Play")
print("  - Anti Fling")
print("  - Anti Ragdoll")
print("  - No Walk")
print("  - Infinite Jump")
print("  - Spin Player")
print("  - Optimizer")
