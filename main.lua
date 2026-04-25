-- https://discord.gg/WfTDsBPR9njpin for more cheap sources inter sources

task.spawn(function()
repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local Player = Players.LocalPlayer

local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local s = isMobile and 0.65 or 1 -- UI Scale factor

-- Safe character wait
local function waitForCharacter()
    local char = Player.Character
    if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChildOfClass("Humanoid") then
        return char
    end
    return Player.CharacterAdded:Wait()
end

task.spawn(function()
    waitForCharacter()
end)

if not getgenv then
    getgenv = function() return _G end
end

-- NEW: Global Better PC Dragging Logic
local function MakeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then update(input) end
    end)
end

local ConfigFileName = "Zyphrot_Hub_Config_V3.json"

local Enabled = {
    SpeedBoost = false,
    AntiRagdoll = false,
    SpinBot = false,
    SpeedWhileStealing = false,
    AutoSteal = false,
    Unwalk = false,
    Optimizer = false,
    Galaxy = false,
    SpamBat = false,
    BatAimbot = false,
    GalaxySkyBright = false,
    AutoWalkEnabled = false,
    AutoRightEnabled = false,
    AutoPlayLeftEnabled = false,
    AutoPlayRightEnabled = false,
    InfJump = false,
    ESP = false,
    Hover = false,
    Stats = false,
    SpeedMeter = false
}

local Values = {
    BoostSpeed = 30,
    SpinSpeed = 30,
    StealingSpeedValue = 29,
    STEAL_RADIUS = 20,
    STEAL_DURATION = 1.3,
    AutoLeftSpeed = 59.5,
    AutoRightSpeed = 59.5,
    AutoWalkReturnSpeed = 30,
    AutoPlayReturnSpeed = 30,
    AutoWalkWaitTime = 1.0,
    AutoPlayWaitTime = 1.0,
    AutoPlayExitDist = 6.0,
    DEFAULT_GRAVITY = 196.2,
    GalaxyGravityPercent = 70,
    HOP_POWER = 35,
    HOP_COOLDOWN = 0.08,
    FOV = 105.8,
    HoverHeight = 15
}

local KEYBINDS = {
    SPEED = Enum.KeyCode.V,
    SPIN = Enum.KeyCode.N,
    GALAXY = Enum.KeyCode.M,
    BATAIMBOT = Enum.KeyCode.X,
    NUKE = Enum.KeyCode.Q,
    AUTOLEFT = Enum.KeyCode.Z,
    AUTORIGHT = Enum.KeyCode.C,
    AUTOPLAYLEFT = Enum.KeyCode.F10,
    AUTOPLAYRIGHT = Enum.KeyCode.F11,
    ANTIRAGDOLL = Enum.KeyCode.F1,
    SPEEDSTEAL = Enum.KeyCode.F2,
    AUTOSTEAL = Enum.KeyCode.F3,
    UNWALK = Enum.KeyCode.F4,
    OPTIMIZER = Enum.KeyCode.F5,
    SPAMBAT = Enum.KeyCode.F6,
    GALAXY_SKY = Enum.KeyCode.F7,
    INFJUMP = Enum.KeyCode.F8,
    ESP = Enum.KeyCode.P,
    HOVER = Enum.KeyCode.G,
    STATS = Enum.KeyCode.F9,
    SPEEDMETER = Enum.KeyCode.J
}

-- Theme and Background settings defined globally so they can save/load
local CurrentThemeIndex = 1
local isRainbow = false
local CurrentBgEffectIndex = 1

-- Load Config
local configLoaded = false
pcall(function()
    if readfile and isfile and isfile(ConfigFileName) then
        local data = HttpService:JSONDecode(readfile(ConfigFileName))
        if data then
            for k, v in pairs(data) do
                if Enabled[k] ~= nil then Enabled[k] = v end
            end
            for k, v in pairs(data) do
                if Values[k] ~= nil then Values[k] = v end
            end
            if data.KEY_SPEED then KEYBINDS.SPEED = Enum.KeyCode[data.KEY_SPEED] end
            if data.KEY_SPIN then KEYBINDS.SPIN = Enum.KeyCode[data.KEY_SPIN] end
            if data.KEY_GALAXY then KEYBINDS.GALAXY = Enum.KeyCode[data.KEY_GALAXY] end
            if data.KEY_BATAIMBOT then KEYBINDS.BATAIMBOT = Enum.KeyCode[data.KEY_BATAIMBOT] end
            if data.KEY_AUTOLEFT then KEYBINDS.AUTOLEFT = Enum.KeyCode[data.KEY_AUTOLEFT] end
            if data.KEY_AUTORIGHT then KEYBINDS.AUTORIGHT = Enum.KeyCode[data.KEY_AUTORIGHT] end
            if data.KEY_AUTOPLAYLEFT then KEYBINDS.AUTOPLAYLEFT = Enum.KeyCode[data.KEY_AUTOPLAYLEFT] end
            if data.KEY_AUTOPLAYRIGHT then KEYBINDS.AUTOPLAYRIGHT = Enum.KeyCode[data.KEY_AUTOPLAYRIGHT] end
            if data.KEY_ANTIRAGDOLL then KEYBINDS.ANTIRAGDOLL = Enum.KeyCode[data.KEY_ANTIRAGDOLL] end
            if data.KEY_SPEEDSTEAL then KEYBINDS.SPEEDSTEAL = Enum.KeyCode[data.KEY_SPEEDSTEAL] end
            if data.KEY_AUTOSTEAL then KEYBINDS.AUTOSTEAL = Enum.KeyCode[data.KEY_AUTOSTEAL] end
            if data.KEY_UNWALK then KEYBINDS.UNWALK = Enum.KeyCode[data.KEY_UNWALK] end
            if data.KEY_OPTIMIZER then KEYBINDS.OPTIMIZER = Enum.KeyCode[data.KEY_OPTIMIZER] end
            if data.KEY_SPAMBAT then KEYBINDS.SPAMBAT = Enum.KeyCode[data.KEY_SPAMBAT] end
            if data.KEY_GALAXY_SKY then KEYBINDS.GALAXY_SKY = Enum.KeyCode[data.KEY_GALAXY_SKY] end
            if data.KEY_INFJUMP then KEYBINDS.INFJUMP = Enum.KeyCode[data.KEY_INFJUMP] end
            if data.KEY_ESP then KEYBINDS.ESP = Enum.KeyCode[data.KEY_ESP] end
            if data.KEY_HOVER then KEYBINDS.HOVER = Enum.KeyCode[data.KEY_HOVER] end
            if data.KEY_STATS then KEYBINDS.STATS = Enum.KeyCode[data.KEY_STATS] end
            if data.KEY_SPEEDMETER then KEYBINDS.SPEEDMETER = Enum.KeyCode[data.KEY_SPEEDMETER] end
            
            if data.CurrentThemeIndex then CurrentThemeIndex = data.CurrentThemeIndex end
            if data.isRainbow ~= nil then isRainbow = data.isRainbow end
            if data.CurrentBgEffectIndex then CurrentBgEffectIndex = data.CurrentBgEffectIndex end
            
            configLoaded = true
        end
    end
end)

-- Save Config
local function SaveConfig()
    local data = {}
    for k, v in pairs(Enabled) do data[k] = v end
    for k, v in pairs(Values) do data[k] = v end
    data.KEY_SPEED = KEYBINDS.SPEED.Name
    data.KEY_SPIN = KEYBINDS.SPIN.Name
    data.KEY_GALAXY = KEYBINDS.GALAXY.Name
    data.KEY_BATAIMBOT = KEYBINDS.BATAIMBOT.Name
    data.KEY_AUTOLEFT = KEYBINDS.AUTOLEFT.Name
    data.KEY_AUTORIGHT = KEYBINDS.AUTORIGHT.Name
    data.KEY_AUTOPLAYLEFT = KEYBINDS.AUTOPLAYLEFT.Name
    data.KEY_AUTOPLAYRIGHT = KEYBINDS.AUTOPLAYRIGHT.Name
    data.KEY_ANTIRAGDOLL = KEYBINDS.ANTIRAGDOLL.Name
    data.KEY_SPEEDSTEAL = KEYBINDS.SPEEDSTEAL.Name
    data.KEY_AUTOSTEAL = KEYBINDS.AUTOSTEAL.Name
    data.KEY_UNWALK = KEYBINDS.UNWALK.Name
    data.KEY_OPTIMIZER = KEYBINDS.OPTIMIZER.Name
    data.KEY_SPAMBAT = KEYBINDS.SPAMBAT.Name
    data.KEY_GALAXY_SKY = KEYBINDS.GALAXY_SKY.Name
    data.KEY_INFJUMP = KEYBINDS.INFJUMP.Name
    data.KEY_ESP = KEYBINDS.ESP.Name
    data.KEY_HOVER = KEYBINDS.HOVER.Name
    data.KEY_STATS = KEYBINDS.STATS.Name
    data.KEY_SPEEDMETER = KEYBINDS.SPEEDMETER.Name
    
    data.CurrentThemeIndex = CurrentThemeIndex
    data.isRainbow = isRainbow
    data.CurrentBgEffectIndex = CurrentBgEffectIndex
    
    local success = false
    if writefile then
        pcall(function()
            writefile(ConfigFileName, HttpService:JSONEncode(data))
            success = true
        end)
    end
    return success
end

local Connections = {}
local isStealing = false
local lastBatSwing = 0
local BAT_SWING_COOLDOWN = 0.12

local SlapList = {
    {1, "Bat"}, {2, "Slap"}, {3, "Iron Slap"}, {4, "Gold Slap"},
    {5, "Diamond Slap"}, {6, "Emerald Slap"}, {7, "Ruby Slap"},
    {8, "Dark Matter Slap"}, {9, "Flame Slap"}, {10, "Nuclear Slap"},
    {11, "Galaxy Slap"}, {12, "Glitched Slap"}
}

local ADMIN_KEY = "78a772b6-9e1c-4827-ab8b-04a07838f298"
local REMOTE_EVENT_ID = "352aad58-c786-4998-886b-3e4fa390721e"
local BALLOON_REMOTE = ReplicatedStorage:FindFirstChild(REMOTE_EVENT_ID, true)

local function INSTANT_NUKE(target)
    if not BALLOON_REMOTE or not target then return end
    for _, p in ipairs({"balloon", "ragdoll", "jumpscare", "morph", "tiny", "rocket", "inverse", "jail"}) do
        BALLOON_REMOTE:FireServer(ADMIN_KEY, target, p)
    end
end

local function getNearestPlayer()
    local c = Player.Character
    if not c then return nil end
    local h = c:FindFirstChild("HumanoidRootPart")
    if not h then return nil end
    local pos = h.Position
    local nearest, dist = nil, math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= Player and p.Character then
            local oh = p.Character:FindFirstChild("HumanoidRootPart")
            if oh then
                local d = (pos - oh.Position).Magnitude
                if d < dist then
                    dist = d
                    nearest = p
                end
            end
        end
    end
    return nearest
end

local function findBat()
    local c = Player.Character
    if not c then return nil end
    local bp = Player:FindFirstChildOfClass("Backpack")
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
    return nil
end

local function startSpamBat()
    if Connections.spamBat then return end
    Connections.spamBat = RunService.Heartbeat:Connect(function()
        if not Enabled.SpamBat then return end
        local c = Player.Character
        if not c then return end
        local bat = findBat()
        if not bat then return end
        if bat.Parent ~= c then bat.Parent = c end
        local now = tick()
        if now - lastBatSwing < BAT_SWING_COOLDOWN then return end
        lastBatSwing = now
        pcall(function() bat:Activate() end)
    end)
end

local function stopSpamBat()
    if Connections.spamBat then Connections.spamBat:Disconnect() Connections.spamBat = nil end
end

local spinBAV = nil
local function startSpinBot()
    local c = Player.Character
    if not c then return end
    local hrp = c:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if spinBAV then spinBAV:Destroy() spinBAV = nil end
    for _, v in pairs(hrp:GetChildren()) do if v.Name == "SpinBAV" then v:Destroy() end end
    spinBAV = Instance.new("BodyAngularVelocity")
    spinBAV.Name = "SpinBAV"
    spinBAV.MaxTorque = Vector3.new(0, math.huge, 0)
    spinBAV.AngularVelocity = Vector3.new(0, Values.SpinSpeed, 0)
    spinBAV.Parent = hrp
end

local function stopSpinBot()
    if spinBAV then spinBAV:Destroy() spinBAV = nil end
    local c = Player.Character
    if c then
        local hrp = c:FindFirstChild("HumanoidRootPart")
        if hrp then
            for _, v in pairs(hrp:GetChildren()) do if v.Name == "SpinBAV" then v:Destroy() end end
        end
    end
end

RunService.Heartbeat:Connect(function()
    if Enabled.SpinBot and spinBAV then
        if Player:GetAttribute("Stealing") then
            spinBAV.AngularVelocity = Vector3.new(0, 0, 0)
        else
            spinBAV.AngularVelocity = Vector3.new(0, Values.SpinSpeed, 0)
        end
    end
end)

-- ============================================
-- SPEED METER LOGIC
-- ============================================
local speedMeterConnection = nil
local speedMeterGui = nil

local function toggleSpeedMeter(state)
    if speedMeterConnection then
        speedMeterConnection:Disconnect()
        speedMeterConnection = nil
    end
    if speedMeterGui then
        speedMeterGui:Destroy()
        speedMeterGui = nil
    end

    if state then
        local char = Player.Character
        if not char then return end
        local head = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
        if not head then return end
        
        speedMeterGui = Instance.new("BillboardGui")
        speedMeterGui.Name = "ZyphrotSpeedMeter"
        speedMeterGui.Adornee = head
        speedMeterGui.Size = UDim2.new(0, 150, 0, 40)
        speedMeterGui.StudsOffset = Vector3.new(0, 3.5, 0)
        speedMeterGui.AlwaysOnTop = true
        
        local textLabel = Instance.new("TextLabel", speedMeterGui)
        textLabel.Name = "SpeedText"
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.Text = "Speed: 0"
        textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        textLabel.TextStrokeTransparency = 0
        textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        textLabel.Font = Enum.Font.GothamBold
        textLabel.TextSize = 16 * s
        
        local successHl, _ = pcall(function() speedMeterGui.Parent = game:GetService("CoreGui") end)
        if not successHl then speedMeterGui.Parent = Player:WaitForChild("PlayerGui") end
        
        speedMeterConnection = RunService.Heartbeat:Connect(function()
            if not Player.Character or not Player.Character:FindFirstChild("HumanoidRootPart") then return end
            local hrp = Player.Character.HumanoidRootPart
            if speedMeterGui and speedMeterGui:FindFirstChild("SpeedText") then
                -- Only use horizontal velocity for an accurate walkspeed reading
                local horizontalVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, 0, hrp.AssemblyLinearVelocity.Z)
                local speed = math.round(horizontalVelocity.Magnitude)
                speedMeterGui.SpeedText.Text = "Speed: " .. tostring(speed)
            end
        end)
    end
end

-- ============================================
-- NEW BAT AIMBOT LOGIC (EXACTLY AS PROVIDED)
-- ============================================
local aimbotConnection = nil
local lockedTarget = nil
local AIMBOT_SPEED = 60
local MELEE_OFFSET = 3
local MAX_DISTANCE = math.huge 

local aimbotHighlight = Instance.new("Highlight")
aimbotHighlight.Name = "AimbotTargetESP"
aimbotHighlight.FillColor = Color3.fromRGB(255, 0, 0)
aimbotHighlight.OutlineColor = Color3.fromRGB(255, 255, 255)
aimbotHighlight.FillTransparency = 0.5
aimbotHighlight.OutlineTransparency = 0
local successHl, _ = pcall(function() aimbotHighlight.Parent = game:GetService("CoreGui") end)
if not successHl then aimbotHighlight.Parent = Player:WaitForChild("PlayerGui") end

local function isTargetValid(targetChar)
    if not targetChar then return false end
    local hum = targetChar:FindFirstChildOfClass("Humanoid")
    local hrp = targetChar:FindFirstChild("HumanoidRootPart")
    local ff = targetChar:FindFirstChildOfClass("ForceField")
    return hum and hrp and hum.Health > 0 and not ff
end

local function getBestTarget(myHRP)
    if lockedTarget and isTargetValid(lockedTarget) then
        return lockedTarget:FindFirstChild("HumanoidRootPart"), lockedTarget
    end

    local shortestDistance = MAX_DISTANCE
    local newTargetChar = nil
    local newTargetHRP = nil

    for _, targetPlayer in ipairs(Players:GetPlayers()) do
        if targetPlayer ~= Player and isTargetValid(targetPlayer.Character) then
            local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
            local distance = (targetHRP.Position - myHRP.Position).Magnitude
            
            if distance < shortestDistance then
                shortestDistance = distance
                newTargetHRP = targetHRP
                newTargetChar = targetPlayer.Character
            end
        end
    end
    
    lockedTarget = newTargetChar
    return newTargetHRP, newTargetChar
end

local function startBatAimbot()
    if aimbotConnection then return end
    
    local c = Player.Character
    if not c then return end
    local h = c:FindFirstChild("HumanoidRootPart")
    local hum = c:FindFirstChildOfClass("Humanoid")
    if not h or not hum then return end
    
    hum.AutoRotate = false
    local attachment = h:FindFirstChild("AimbotAttachment") or Instance.new("Attachment", h)
    attachment.Name = "AimbotAttachment"
    
    local align = h:FindFirstChild("AimbotAlign") or Instance.new("AlignOrientation", h)
    align.Name = "AimbotAlign"
    align.Mode = Enum.OrientationAlignmentMode.OneAttachment
    align.Attachment0 = attachment
    align.MaxTorque = math.huge
    align.Responsiveness = 200
    
    aimbotConnection = RunService.Heartbeat:Connect(function(dt)
        if not Enabled.BatAimbot then return end
        
        if not Player.Character or not Player.Character:FindFirstChild("HumanoidRootPart") then return end
        local currentHRP = Player.Character.HumanoidRootPart
        local currentHum = Player.Character:FindFirstChildOfClass("Humanoid")
        
        local bat = findBat()
        if bat and bat.Parent ~= Player.Character then currentHum:EquipTool(bat) end
        
        local targetHRP, targetChar = getBestTarget(currentHRP)
        
        if targetHRP and targetChar then
            aimbotHighlight.Adornee = targetChar
            
            -- Dynamic Prediction based on how fast they are moving
            local targetVelocity = targetHRP.AssemblyLinearVelocity
            local speed = targetVelocity.Magnitude
            local dynamicPredictTime = math.clamp(speed / 150, 0.05, 0.2)
            
            local predictedPos = targetHRP.Position + (targetVelocity * dynamicPredictTime)
            
            -- Calculate offset position (stay slightly behind them)
            local dirToTarget = (predictedPos - currentHRP.Position)
            local distance3D = dirToTarget.Magnitude
            
            local targetStandPos = predictedPos
            if distance3D > 0 then
                targetStandPos = predictedPos - (dirToTarget.Unit * MELEE_OFFSET)
            end

            -- Face the actual predicted position
            align.CFrame = CFrame.lookAt(currentHRP.Position, predictedPos)
            
            -- Move towards the offset position
            local moveDir = (targetStandPos - currentHRP.Position)
            local distToStandPos = moveDir.Magnitude
            
            if distToStandPos > 1 then
                currentHRP.AssemblyLinearVelocity = moveDir.Unit * AIMBOT_SPEED
            else
                currentHRP.AssemblyLinearVelocity = targetVelocity
            end
        else
            lockedTarget = nil
            currentHRP.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            aimbotHighlight.Adornee = nil
        end
    end)
end

local function stopBatAimbot()
    if aimbotConnection then
        aimbotConnection:Disconnect()
        aimbotConnection = nil
    end
    
    local c = Player.Character
    local h = c and c:FindFirstChild("HumanoidRootPart")
    local hum = c and c:FindFirstChildOfClass("Humanoid")
    
    if h then
        local att = h:FindFirstChild("AimbotAttachment")
        if att then att:Destroy() end
        
        local align = h:FindFirstChild("AimbotAlign")
        if align then align:Destroy() end
        
        h.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    end
    if hum then
        hum.AutoRotate = true
    end
    
    lockedTarget = nil
    aimbotHighlight.Adornee = nil
end

-- Galaxy Mode
local galaxyVectorForce, galaxyAttachment, galaxyEnabled, hopsEnabled = nil, nil, false, false
local lastHopTime, spaceHeld, originalJumpPower = 0, false, 50

local function captureJumpPower()
    local c = Player.Character
    if c then
        local hum = c:FindFirstChildOfClass("Humanoid")
        if hum and hum.JumpPower > 0 then originalJumpPower = hum.JumpPower end
    end
end
task.spawn(function() task.wait(1) captureJumpPower() end)
Player.CharacterAdded:Connect(function() task.wait(1) captureJumpPower() end)

local function setupGalaxyForce()
    pcall(function()
        local c = Player.Character
        local h = c and c:FindFirstChild("HumanoidRootPart")
        if not h then return end
        if galaxyVectorForce then galaxyVectorForce:Destroy() end
        if galaxyAttachment then galaxyAttachment:Destroy() end
        galaxyAttachment = Instance.new("Attachment", h)
        galaxyVectorForce = Instance.new("VectorForce", h)
        galaxyVectorForce.Attachment0 = galaxyAttachment
        galaxyVectorForce.ApplyAtCenterOfMass = true
        galaxyVectorForce.RelativeTo = Enum.ActuatorRelativeTo.World
        galaxyVectorForce.Force = Vector3.new(0, 0, 0)
    end)
end

local function updateGalaxyForce()
    if not galaxyEnabled or not galaxyVectorForce then return end
    local c = Player.Character
    if not c then return end
    local mass = 0
    for _, p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then mass = mass + p:GetMass() end end
    local tg = Values.DEFAULT_GRAVITY * (Values.GalaxyGravityPercent / 100)
    galaxyVectorForce.Force = Vector3.new(0, mass * (Values.DEFAULT_GRAVITY - tg) * 0.95, 0)
end

local function adjustGalaxyJump()
    pcall(function()
        local c = Player.Character
        local hum = c and c:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        if not galaxyEnabled then hum.JumpPower = originalJumpPower return end
        local ratio = math.sqrt((Values.DEFAULT_GRAVITY * (Values.GalaxyGravityPercent / 100)) / Values.DEFAULT_GRAVITY)
        hum.JumpPower = originalJumpPower * ratio
    end)
end

local function doMiniHop()
    if not hopsEnabled then return end
    pcall(function()
        local c = Player.Character
        local h = c and c:FindFirstChild("HumanoidRootPart")
        local hum = c and c:FindFirstChildOfClass("Humanoid")
        if not h or not hum then return end
        if tick() - lastHopTime < Values.HOP_COOLDOWN then return end
        lastHopTime = tick()
        if hum.FloorMaterial == Enum.Material.Air then
            h.AssemblyLinearVelocity = Vector3.new(h.AssemblyLinearVelocity.X, Values.HOP_POWER, h.AssemblyLinearVelocity.Z)
        end
    end)
end

local function startGalaxy() galaxyEnabled = true hopsEnabled = true setupGalaxyForce() adjustGalaxyJump() end
local function stopGalaxy()
    galaxyEnabled = false hopsEnabled = false
    if galaxyVectorForce then galaxyVectorForce:Destroy() galaxyVectorForce = nil end
    if galaxyAttachment then galaxyAttachment:Destroy() galaxyAttachment = nil end
    adjustGalaxyJump()
end

RunService.Heartbeat:Connect(function()
    if hopsEnabled and spaceHeld then doMiniHop() end
    if galaxyEnabled then updateGalaxyForce() end
end)

local function getMovementDirection()
    local c = Player.Character
    local hum = c and c:FindFirstChildOfClass("Humanoid")
    return hum and hum.MoveDirection or Vector3.zero
end

-- Speed Boost
local function startSpeedBoost()
    if Connections.speed then return end
    Connections.speed = RunService.Heartbeat:Connect(function()
        if not Enabled.SpeedBoost then return end
        pcall(function()
            local c = Player.Character
            local h = c and c:FindFirstChild("HumanoidRootPart")
            if not h then return end
            local md = getMovementDirection()
            if md.Magnitude > 0.1 then
                h.AssemblyLinearVelocity = Vector3.new(md.X * Values.BoostSpeed, h.AssemblyLinearVelocity.Y, md.Z * Values.BoostSpeed)
            end
        end)
    end)
end
local function stopSpeedBoost() if Connections.speed then Connections.speed:Disconnect() Connections.speed = nil end end

-- Ghost Hover
local hoverTargetY = 0
local function ToggleHover(state)
    local char = Player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if state and hrp then
        hoverTargetY = hrp.Position.Y + Values.HoverHeight
    else
        if hrp then hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, -10, hrp.AssemblyLinearVelocity.Z) end
    end
end

RunService.Heartbeat:Connect(function()
    if Enabled.Hover then
        local char = Player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local myY = hrp.Position.Y
            local error = hoverTargetY - myY
            local currentY = math.clamp(error * 10, -50, 50)
            hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, currentY, hrp.AssemblyLinearVelocity.Z)
        end
    end
end)

-- Auto Walk & Right Coordinates
local POSITION_1 = Vector3.new(-476.48, -6.28, 92.73)
local POSITION_2 = Vector3.new(-483.12, -4.95, 94.80)
local POSITION_R1 = Vector3.new(-476.16, -6.52, 25.62)
local POSITION_R2 = Vector3.new(-483.04, -5.09, 23.14)

-- Dynamically project studs out to avoid all base walls based on slider
local dirL = (Vector3.new(POSITION_1.X, 0, POSITION_1.Z) - Vector3.new(POSITION_2.X, 0, POSITION_2.Z)).Unit
local dirR = (Vector3.new(POSITION_R1.X, 0, POSITION_R1.Z) - Vector3.new(POSITION_R2.X, 0, POSITION_R2.Z)).Unit

local function GET_POS_1_OUT() return POSITION_1 + (dirL * Values.AutoPlayExitDist) end
local function GET_POS_R1_OUT() return POSITION_R1 + (dirR * Values.AutoPlayExitDist) end

local coordESPFolder = Instance.new("Folder", workspace)
coordESPFolder.Name = "Zyphrot_CoordESP"

local function createCoordMarker(position, labelText, color)
    local dot = Instance.new("Part", coordESPFolder)
    dot.Name = "CoordMarker_" .. labelText
    dot.Anchored = true dot.CanCollide = false dot.CastShadow = false
    dot.Material = Enum.Material.Neon dot.Color = color dot.Shape = Enum.PartType.Ball
    dot.Size = Vector3.new(1, 1, 1) dot.Position = position dot.Transparency = 0.2

    local bb = Instance.new("BillboardGui", dot)
    bb.AlwaysOnTop = true bb.Size = UDim2.new(0, 100, 0, 20) bb.StudsOffset = Vector3.new(0, 2, 0)
    
    local text = Instance.new("TextLabel", bb)
    text.Size = UDim2.new(1, 0, 1, 0) text.BackgroundTransparency = 1 text.Text = labelText
    text.TextColor3 = color text.Font = Enum.Font.GothamBold text.TextSize = 12
    return dot
end

createCoordMarker(POSITION_1, "L1", Color3.fromRGB(255, 100, 100))
createCoordMarker(POSITION_2, "L END", Color3.fromRGB(220, 20, 60))
createCoordMarker(POSITION_R1, "R1", Color3.fromRGB(255, 150, 50))
createCoordMarker(POSITION_R2, "R END", Color3.fromRGB(220, 100, 30))

local autoWalkPhase, autoRightPhase = 1, 1
local autoPlayLeftPhase, autoPlayRightPhase = 1, 1

local AutoWalkEnabled, AutoRightEnabled = false, false
local AutoPlayLeftEnabled, AutoPlayRightEnabled = false, false

local autoWalkConnection, autoRightConnection = nil, nil
local autoPlayLeftConnection, autoPlayRightConnection = nil, nil

local function faceCam(angleY)
    local c = Player.Character
    local h = c and c:FindFirstChild("HumanoidRootPart")
    if not h then return end
    
    local camera = workspace.CurrentCamera
    if camera then
        if angleY == 0 then
            camera.CFrame = CFrame.new(h.Position.X, h.Position.Y + 5, h.Position.Z - 12) * CFrame.Angles(math.rad(-15), 0, 0)
        else
            camera.CFrame = CFrame.new(h.Position.X, h.Position.Y + 2, h.Position.Z + 12) * CFrame.Angles(0, math.rad(180), 0)
        end
    end
end

-- ============================================
-- AUTO PLAY LEFT SEQUENCE
-- ============================================
local autoPlayLeftWait = false
local autoPlayLeftWaitStart = 0

local function startAutoPlayLeft()
    if autoPlayLeftConnection then autoPlayLeftConnection:Disconnect() end
    autoPlayLeftPhase = 1
    autoPlayLeftWait = false
    autoPlayLeftWaitStart = 0
    
    local c = Player.Character
    local h = c and c:FindFirstChild("HumanoidRootPart")
    if h then
        local walkOri = h:FindFirstChild("AutoWalkOri")
        if not walkOri then
            local walkAtt = Instance.new("Attachment", h)
            walkAtt.Name = "AutoWalkAtt"
            walkOri = Instance.new("AlignOrientation", h)
            walkOri.Name = "AutoWalkOri"
            walkOri.Mode = Enum.OrientationAlignmentMode.OneAttachment
            walkOri.Attachment0 = walkAtt
            walkOri.MaxTorque = math.huge
            walkOri.Responsiveness = 200
        end
    end

    local sequence = {GET_POS_1_OUT, POSITION_1, POSITION_2, POSITION_1, GET_POS_1_OUT, GET_POS_R1_OUT, POSITION_R1, POSITION_R2}

    autoPlayLeftConnection = RunService.Heartbeat:Connect(function()
        if not AutoPlayLeftEnabled then return end
        local char = Player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        
        local wo = hrp:FindFirstChild("AutoWalkOri")
        
        if autoPlayLeftWait then
            hrp.AssemblyLinearVelocity = Vector3.new(0, hrp.AssemblyLinearVelocity.Y, 0)
            if tick() - autoPlayLeftWaitStart >= Values.AutoPlayWaitTime then
                autoPlayLeftWait = false
                autoPlayLeftPhase = autoPlayLeftPhase + 1
            end
            return
        end
        
        if autoPlayLeftPhase <= #sequence then
            local targetPos = sequence[autoPlayLeftPhase]
            if type(targetPos) == "function" then targetPos = targetPos() end
            
            local dist = (Vector3.new(targetPos.X, hrp.Position.Y, targetPos.Z) - hrp.Position).Magnitude
            
            if dist < 1 then
                hrp.AssemblyLinearVelocity = Vector3.new(0, hrp.AssemblyLinearVelocity.Y, 0)
                if autoPlayLeftPhase == 3 then
                    autoPlayLeftWait = true
                    autoPlayLeftWaitStart = tick()
                else
                    autoPlayLeftPhase = autoPlayLeftPhase + 1
                end
            else
                local flatDir = Vector3.new(targetPos.X - hrp.Position.X, 0, targetPos.Z - hrp.Position.Z)
                local moveDir = flatDir.Unit
                if wo then wo.CFrame = CFrame.lookAt(hrp.Position, Vector3.new(targetPos.X, hrp.Position.Y, targetPos.Z)) end
                
                local speedToUse = (autoPlayLeftPhase >= 4) and Values.AutoPlayReturnSpeed or Values.AutoLeftSpeed
                hrp.AssemblyLinearVelocity = Vector3.new(moveDir.X * speedToUse, hrp.AssemblyLinearVelocity.Y, moveDir.Z * speedToUse)
            end
        else
            hrp.AssemblyLinearVelocity = Vector3.new(0, hrp.AssemblyLinearVelocity.Y, 0)
            AutoPlayLeftEnabled, Enabled.AutoPlayLeftEnabled = false, false
            if VisualSetters.AutoPlayLeftEnabled then VisualSetters.AutoPlayLeftEnabled(false) end
            if autoPlayLeftConnection then autoPlayLeftConnection:Disconnect() autoPlayLeftConnection = nil end
            local wa = hrp:FindFirstChild("AutoWalkAtt")
            if wo then wo:Destroy() end
            if wa then wa:Destroy() end
            faceCam(0)
        end
    end)
end

local function stopAutoPlayLeft()
    if autoPlayLeftConnection then autoPlayLeftConnection:Disconnect() autoPlayLeftConnection = nil end
    local h = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    if h then 
        h.AssemblyLinearVelocity = Vector3.new(0, h.AssemblyLinearVelocity.Y, 0)
        local wo = h:FindFirstChild("AutoWalkOri")
        local wa = h:FindFirstChild("AutoWalkAtt")
        if wo then wo:Destroy() end
        if wa then wa:Destroy() end
    end
end

-- ============================================
-- AUTO PLAY RIGHT SEQUENCE
-- ============================================
local autoPlayRightWait = false
local autoPlayRightWaitStart = 0

local function startAutoPlayRight()
    if autoPlayRightConnection then autoPlayRightConnection:Disconnect() end
    autoPlayRightPhase = 1
    autoPlayRightWait = false
    autoPlayRightWaitStart = 0
    
    local c = Player.Character
    local h = c and c:FindFirstChild("HumanoidRootPart")
    if h then
        local walkOri = h:FindFirstChild("AutoWalkOri")
        if not walkOri then
            local walkAtt = Instance.new("Attachment", h)
            walkAtt.Name = "AutoWalkAtt"
            walkOri = Instance.new("AlignOrientation", h)
            walkOri.Name = "AutoWalkOri"
            walkOri.Mode = Enum.OrientationAlignmentMode.OneAttachment
            walkOri.Attachment0 = walkAtt
            walkOri.MaxTorque = math.huge
            walkOri.Responsiveness = 200
        end
    end

    local sequence = {GET_POS_R1_OUT, POSITION_R1, POSITION_R2, POSITION_R1, GET_POS_R1_OUT, GET_POS_1_OUT, POSITION_1, POSITION_2}

    autoPlayRightConnection = RunService.Heartbeat:Connect(function()
        if not AutoPlayRightEnabled then return end
        local char = Player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        
        local wo = hrp:FindFirstChild("AutoWalkOri")
        
        if autoPlayRightWait then
            hrp.AssemblyLinearVelocity = Vector3.new(0, hrp.AssemblyLinearVelocity.Y, 0)
            if tick() - autoPlayRightWaitStart >= Values.AutoPlayWaitTime then
                autoPlayRightWait = false
                autoPlayRightPhase = autoPlayRightPhase + 1
            end
            return
        end
        
        if autoPlayRightPhase <= #sequence then
            local targetPos = sequence[autoPlayRightPhase]
            if type(targetPos) == "function" then targetPos = targetPos() end
            
            local dist = (Vector3.new(targetPos.X, hrp.Position.Y, targetPos.Z) - hrp.Position).Magnitude
            
            if dist < 1 then
                hrp.AssemblyLinearVelocity = Vector3.new(0, hrp.AssemblyLinearVelocity.Y, 0)
                if autoPlayRightPhase == 3 then
                    autoPlayRightWait = true
                    autoPlayRightWaitStart = tick()
                else
                    autoPlayRightPhase = autoPlayRightPhase + 1
                end
            else
                local flatDir = Vector3.new(targetPos.X - hrp.Position.X, 0, targetPos.Z - hrp.Position.Z)
                local moveDir = flatDir.Unit
                if wo then wo.CFrame = CFrame.lookAt(hrp.Position, Vector3.new(targetPos.X, hrp.Position.Y, targetPos.Z)) end
                
                local speedToUse = (autoPlayRightPhase >= 4) and Values.AutoPlayReturnSpeed or Values.AutoRightSpeed
                hrp.AssemblyLinearVelocity = Vector3.new(moveDir.X * speedToUse, hrp.AssemblyLinearVelocity.Y, moveDir.Z * speedToUse)
            end
        else
            hrp.AssemblyLinearVelocity = Vector3.new(0, hrp.AssemblyLinearVelocity.Y, 0)
            AutoPlayRightEnabled, Enabled.AutoPlayRightEnabled = false, false
            if VisualSetters.AutoPlayRightEnabled then VisualSetters.AutoPlayRightEnabled(false) end
            if autoPlayRightConnection then autoPlayRightConnection:Disconnect() autoPlayRightConnection = nil end
            local wa = hrp:FindFirstChild("AutoWalkAtt")
            if wo then wo:Destroy() end
            if wa then wa:Destroy() end
            faceCam(math.rad(180))
        end
    end)
end

local function stopAutoPlayRight()
    if autoPlayRightConnection then autoPlayRightConnection:Disconnect() autoPlayRightConnection = nil end
    local h = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    if h then 
        h.AssemblyLinearVelocity = Vector3.new(0, h.AssemblyLinearVelocity.Y, 0)
        local wo = h:FindFirstChild("AutoWalkOri")
        local wa = h:FindFirstChild("AutoWalkAtt")
        if wo then wo:Destroy() end
        if wa then wa:Destroy() end
    end
end

local function startAutoWalk()
    if autoWalkConnection then autoWalkConnection:Disconnect() end
    autoWalkPhase = 1
    local waitStartTime = 0
    
    local c = Player.Character
    local h = c and c:FindFirstChild("HumanoidRootPart")
    if h then
        local walkOri = h:FindFirstChild("AutoWalkOri")
        if not walkOri then
            local walkAtt = Instance.new("Attachment", h)
            walkAtt.Name = "AutoWalkAtt"
            walkOri = Instance.new("AlignOrientation", h)
            walkOri.Name = "AutoWalkOri"
            walkOri.Mode = Enum.OrientationAlignmentMode.OneAttachment
            walkOri.Attachment0 = walkAtt
            walkOri.MaxTorque = math.huge
            walkOri.Responsiveness = 200
        end
    end

    autoWalkConnection = RunService.Heartbeat:Connect(function()
        if not AutoWalkEnabled then return end
        local c = Player.Character
        local h = c and c:FindFirstChild("HumanoidRootPart")
        if not h then return end
        
        local wo = h:FindFirstChild("AutoWalkOri")
        local pos1 = POSITION_1
        local pos2 = POSITION_2
        
        if autoWalkPhase == 1 then
            local dist = (Vector3.new(pos1.X, h.Position.Y, pos1.Z) - h.Position).Magnitude
            if dist < 1 then
                autoWalkPhase = 2
            else
                local flatDir = Vector3.new(pos1.X - h.Position.X, 0, pos1.Z - h.Position.Z)
                local moveDir = flatDir.Unit
                if wo then wo.CFrame = CFrame.lookAt(h.Position, Vector3.new(pos1.X, h.Position.Y, pos1.Z)) end
                h.AssemblyLinearVelocity = Vector3.new(moveDir.X * Values.AutoLeftSpeed, h.AssemblyLinearVelocity.Y, moveDir.Z * Values.AutoLeftSpeed)
            end
            
        elseif autoWalkPhase == 2 then
            local dist = (Vector3.new(pos2.X, h.Position.Y, pos2.Z) - h.Position).Magnitude
            if dist < 1 then
                autoWalkPhase = 3
                waitStartTime = tick()
                h.AssemblyLinearVelocity = Vector3.new(0, h.AssemblyLinearVelocity.Y, 0)
            else
                local flatDir = Vector3.new(pos2.X - h.Position.X, 0, pos2.Z - h.Position.Z)
                local moveDir = flatDir.Unit
                if wo then wo.CFrame = CFrame.lookAt(h.Position, Vector3.new(pos2.X, h.Position.Y, pos2.Z)) end
                h.AssemblyLinearVelocity = Vector3.new(moveDir.X * Values.AutoLeftSpeed, h.AssemblyLinearVelocity.Y, moveDir.Z * Values.AutoLeftSpeed)
            end
            
        elseif autoWalkPhase == 3 then
            h.AssemblyLinearVelocity = Vector3.new(0, h.AssemblyLinearVelocity.Y, 0)
            if tick() - waitStartTime >= Values.AutoWalkWaitTime then
                autoWalkPhase = 4
            end
            
        elseif autoWalkPhase == 4 then
            local dist = (Vector3.new(pos1.X, h.Position.Y, pos1.Z) - h.Position).Magnitude
            if dist < 1 then
                autoWalkPhase = 5
            else
                local flatDir = Vector3.new(pos1.X - h.Position.X, 0, pos1.Z - h.Position.Z)
                local moveDir = flatDir.Unit
                if wo then wo.CFrame = CFrame.lookAt(h.Position, Vector3.new(pos1.X, h.Position.Y, pos1.Z)) end
                h.AssemblyLinearVelocity = Vector3.new(moveDir.X * Values.AutoWalkReturnSpeed, h.AssemblyLinearVelocity.Y, moveDir.Z * Values.AutoWalkReturnSpeed)
            end
            
        elseif autoWalkPhase == 5 then
            h.AssemblyLinearVelocity = Vector3.new(0, h.AssemblyLinearVelocity.Y, 0)
            AutoWalkEnabled, Enabled.AutoWalkEnabled = false, false
            if VisualSetters.AutoWalkEnabled then VisualSetters.AutoWalkEnabled(false) end
            if autoWalkConnection then autoWalkConnection:Disconnect() autoWalkConnection = nil end
            local wa = h:FindFirstChild("AutoWalkAtt")
            if wo then wo:Destroy() end
            if wa then wa:Destroy() end
            faceCam(0)
        end
    end)
end

local function stopAutoWalk()
    if autoWalkConnection then autoWalkConnection:Disconnect() autoWalkConnection = nil end
    local h = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    if h then 
        h.AssemblyLinearVelocity = Vector3.new(0, h.AssemblyLinearVelocity.Y, 0)
        local wo = h:FindFirstChild("AutoWalkOri")
        local wa = h:FindFirstChild("AutoWalkAtt")
        if wo then wo:Destroy() end
        if wa then wa:Destroy() end
    end
end

local function startAutoRight()
    if autoRightConnection then autoRightConnection:Disconnect() end
    autoRightPhase = 1
    local waitStartTime = 0
    
    local c = Player.Character
    local h = c and c:FindFirstChild("HumanoidRootPart")
    if h then
        local walkOri = h:FindFirstChild("AutoWalkOri")
        if not walkOri then
            local walkAtt = Instance.new("Attachment", h)
            walkAtt.Name = "AutoWalkAtt"
            walkOri = Instance.new("AlignOrientation", h)
            walkOri.Name = "AutoWalkOri"
            walkOri.Mode = Enum.OrientationAlignmentMode.OneAttachment
            walkOri.Attachment0 = walkAtt
            walkOri.MaxTorque = math.huge
            walkOri.Responsiveness = 200
        end
    end

    autoRightConnection = RunService.Heartbeat:Connect(function()
        if not AutoRightEnabled then return end
        local c = Player.Character
        local h = c and c:FindFirstChild("HumanoidRootPart")
        if not h then return end
        
        local wo = h:FindFirstChild("AutoWalkOri")
        local pos1 = POSITION_R1
        local pos2 = POSITION_R2
        
        if autoRightPhase == 1 then
            local dist = (Vector3.new(pos1.X, h.Position.Y, pos1.Z) - h.Position).Magnitude
            if dist < 1 then
                autoRightPhase = 2
            else
                local flatDir = Vector3.new(pos1.X - h.Position.X, 0, pos1.Z - h.Position.Z)
                local moveDir = flatDir.Unit
                if wo then wo.CFrame = CFrame.lookAt(h.Position, Vector3.new(pos1.X, h.Position.Y, pos1.Z)) end
                h.AssemblyLinearVelocity = Vector3.new(moveDir.X * Values.AutoRightSpeed, h.AssemblyLinearVelocity.Y, moveDir.Z * Values.AutoRightSpeed)
            end
            
        elseif autoRightPhase == 2 then
            local dist = (Vector3.new(pos2.X, h.Position.Y, pos2.Z) - h.Position).Magnitude
            if dist < 1 then
                autoRightPhase = 3
                waitStartTime = tick()
                h.AssemblyLinearVelocity = Vector3.new(0, h.AssemblyLinearVelocity.Y, 0)
            else
                local flatDir = Vector3.new(pos2.X - h.Position.X, 0, pos2.Z - h.Position.Z)
                local moveDir = flatDir.Unit
                if wo then wo.CFrame = CFrame.lookAt(h.Position, Vector3.new(pos2.X, h.Position.Y, pos2.Z)) end
                h.AssemblyLinearVelocity = Vector3.new(moveDir.X * Values.AutoRightSpeed, h.AssemblyLinearVelocity.Y, moveDir.Z * Values.AutoRightSpeed)
            end
            
        elseif autoRightPhase == 3 then
            h.AssemblyLinearVelocity = Vector3.new(0, h.AssemblyLinearVelocity.Y, 0)
            if tick() - waitStartTime >= Values.AutoWalkWaitTime then
                autoRightPhase = 4
            end
            
        elseif autoRightPhase == 4 then
            local dist = (Vector3.new(pos1.X, h.Position.Y, pos1.Z) - h.Position).Magnitude
            if dist < 1 then
                autoRightPhase = 5
            else
                local flatDir = Vector3.new(pos1.X - h.Position.X, 0, pos1.Z - h.Position.Z)
                local moveDir = flatDir.Unit
                if wo then wo.CFrame = CFrame.lookAt(h.Position, Vector3.new(pos1.X, h.Position.Y, pos1.Z)) end
                h.AssemblyLinearVelocity = Vector3.new(moveDir.X * Values.AutoWalkReturnSpeed, h.AssemblyLinearVelocity.Y, moveDir.Z * Values.AutoWalkReturnSpeed)
            end
            
        elseif autoRightPhase == 5 then
            h.AssemblyLinearVelocity = Vector3.new(0, h.AssemblyLinearVelocity.Y, 0)
            AutoRightEnabled, Enabled.AutoRightEnabled = false, false
            if VisualSetters.AutoRightEnabled then VisualSetters.AutoRightEnabled(false) end
            if autoRightConnection then autoRightConnection:Disconnect() autoRightConnection = nil end
            local wa = h:FindFirstChild("AutoWalkAtt")
            if wo then wo:Destroy() end
            if wa then wa:Destroy() end
            faceCam(math.rad(180))
        end
    end)
end

local function stopAutoRight()
    if autoRightConnection then autoRightConnection:Disconnect() autoRightConnection = nil end
    local h = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    if h then 
        h.AssemblyLinearVelocity = Vector3.new(0, h.AssemblyLinearVelocity.Y, 0)
        local wo = h:FindFirstChild("AutoWalkOri")
        local wa = h:FindFirstChild("AutoWalkAtt")
        if wo then wo:Destroy() end
        if wa then wa:Destroy() end
    end
end

-- Original Source First-Ever Anti Ragdoll Fix
local function startAntiRagdoll()
    if Connections.antiRagdoll then return end
    Connections.antiRagdoll = RunService.Heartbeat:Connect(function()
        if not Enabled.AntiRagdoll then return end
        local char = Player.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            local humState = hum:GetState()
            if humState == Enum.HumanoidStateType.Physics or humState == Enum.HumanoidStateType.Ragdoll or humState == Enum.HumanoidStateType.FallingDown then
                hum:ChangeState(Enum.HumanoidStateType.Running)
                workspace.CurrentCamera.CameraSubject = hum
                pcall(function()
                    if Player.Character then
                        local PlayerModule = Player.PlayerScripts:FindFirstChild("PlayerModule")
                        if PlayerModule then
                            local Controls = require(PlayerModule:FindFirstChild("ControlModule"))
                            Controls:Enable()
                        end
                    end
                end)
                if root then
                    root.Velocity = Vector3.new(0, 0, 0)
                    root.RotVelocity = Vector3.new(0, 0, 0)
                end
            end
        end
        for _, obj in ipairs(char:GetDescendants()) do
            if obj:IsA("Motor6D") and obj.Enabled == false then obj.Enabled = true end
        end
    end)
end
local function stopAntiRagdoll() if Connections.antiRagdoll then Connections.antiRagdoll:Disconnect() Connections.antiRagdoll = nil end end

local function startSpeedWhileStealing()
    if Connections.speedWhileStealing then return end
    Connections.speedWhileStealing = RunService.Heartbeat:Connect(function()
        if not Enabled.SpeedWhileStealing or not Player:GetAttribute("Stealing") then return end
        local h = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
        if not h then return end
        local md = getMovementDirection()
        if md.Magnitude > 0.1 then
            h.AssemblyLinearVelocity = Vector3.new(md.X * Values.StealingSpeedValue, h.AssemblyLinearVelocity.Y, md.Z * Values.StealingSpeedValue)
        end
    end)
end
local function stopSpeedWhileStealing() if Connections.speedWhileStealing then Connections.speedWhileStealing:Disconnect() end end

-- Visual Radius Cylinder
local radiusVisualizer = Instance.new("Part")
radiusVisualizer.Name = "ZyphrotRadiusVisualizer"
radiusVisualizer.Shape = Enum.PartType.Cylinder
radiusVisualizer.CanCollide = false
radiusVisualizer.Anchored = true
radiusVisualizer.CastShadow = false
radiusVisualizer.Material = Enum.Material.ForceField
radiusVisualizer.Color = Color3.fromRGB(220, 20, 60)
radiusVisualizer.Transparency = 0.5

RunService.Heartbeat:Connect(function()
    if Enabled.AutoSteal and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        if radiusVisualizer.Parent ~= workspace then radiusVisualizer.Parent = workspace end
        radiusVisualizer.Size = Vector3.new(0.05, Values.STEAL_RADIUS * 2, Values.STEAL_RADIUS * 2)
        radiusVisualizer.CFrame = Player.Character.HumanoidRootPart.CFrame * CFrame.new(0, -2.8, 0) * CFrame.Angles(0, 0, math.rad(90))
    else
        if radiusVisualizer.Parent then radiusVisualizer.Parent = nil end
    end
end)

-- Auto Steal & Progress Bar UI
local StealData = {}
local isStealing = false
local StealProgress = 0
local autoStealGui = nil
local barFill = nil

local function createAutoStealUI()
    if autoStealGui then return end
    autoStealGui = Instance.new("ScreenGui", Player.PlayerGui)
    autoStealGui.Name = "ZyphrotAutoStealUI"
    autoStealGui.ResetOnSpawn = false
    
    local mainFrame = Instance.new("Frame", autoStealGui)
    mainFrame.Size = UDim2.new(0, 240, 0, 45) 
    mainFrame.Position = UDim2.fromScale(0.5, 0.4)
    mainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
    mainFrame.Active = true
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)
    
    MakeDraggable(mainFrame) 
    
    local mainStroke = Instance.new("UIStroke", mainFrame)
    mainStroke.Thickness = 2
    mainStroke.Color = Color3.fromRGB(220, 20, 60)
    
    local title = Instance.new("TextLabel", mainFrame)
    title.Size = UDim2.new(1, 0, 0, 25)
    title.Position = UDim2.new(0, 0, 0.15, 0)
    title.Background
