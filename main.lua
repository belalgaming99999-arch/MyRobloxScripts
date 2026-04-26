-- ==========================================
-- HONEY DUELS V3.0
-- Complete Redesign | Mobile Optimized | Animated Yellow Theme
-- Two Column Layout | Beautiful Toggles | Combined Features
-- ==========================================
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local VirtualInputManager = game:GetService("VirtualInputManager")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")

-- Detect if mobile
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local isTablet = UserInputService.TouchEnabled and UserInputService.KeyboardEnabled

-- Screen size based scaling
local viewportSize = workspace.CurrentCamera.ViewportSize
local screenScale = math.clamp(viewportSize.X / 1920, 0.5, 1.2)
if isMobile then
    screenScale = math.clamp(viewportSize.X / 400, 0.8, 1.3)
elseif isTablet then
    screenScale = math.clamp(viewportSize.X / 1024, 0.7, 1.1)
end

-- Dummy getconnections fallback
if not getconnections then
    getconnections = function() return {} end
end

-- ==========================================
-- ANTI-LAG: Frame rate limiter
-- ==========================================
local lastUpdateTimes = {}
local function shouldUpdate(key, interval)
    local now = tick()
    if not lastUpdateTimes[key] or (now - lastUpdateTimes[key]) >= interval then
        lastUpdateTimes[key] = now
        return true
    end
    return false
end

-- ==========================================
-- ANIMATED YELLOW GRADIENT SYSTEM
-- ==========================================
local activeGradients = {}
local animationAngle = 0
local floatingDots = {}

local function registerGradient(gradient)
    table.insert(activeGradients, gradient)
end

local gradientUpdateCounter = 0
RunService.Heartbeat:Connect(function(dt)
    gradientUpdateCounter = gradientUpdateCounter + 1
    if gradientUpdateCounter % 3 ~= 0 then return end
    
    animationAngle = (animationAngle + (dt * 120 * 3)) % 360
    for i = #activeGradients, 1, -1 do
        local grad = activeGradients[i]
        if grad and grad.Parent then
            grad.Rotation = animationAngle
        else
            table.remove(activeGradients, i)
        end
    end
    
    for i, dot in ipairs(floatingDots) do
        if dot and dot.Parent then
            local baseY = dot:GetAttribute("BaseY") or 0
            local offset = math.sin(tick() * 2 + i) * 3
            dot.Position = UDim2.new(dot.Position.X.Scale, dot.Position.X.Offset, 0, baseY + offset)
        end
    end
end)

local function createAnimatedYellowText(textLabel)
    local gradient = Instance.new("UIGradient")
    gradient.Parent = textLabel
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 230, 100)),
        ColorSequenceKeypoint.new(0.25, Color3.fromRGB(255, 200, 50)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 240, 120)),
        ColorSequenceKeypoint.new(0.75, Color3.fromRGB(255, 180, 30)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 230, 100))
    })
    registerGradient(gradient)
    return gradient
end

local function createAnimatedGreenText(textLabel)
    local gradient = Instance.new("UIGradient")
    gradient.Parent = textLabel
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 255, 100)),
        ColorSequenceKeypoint.new(0.25, Color3.fromRGB(30, 200, 80)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(80, 255, 120)),
        ColorSequenceKeypoint.new(0.75, Color3.fromRGB(20, 180, 60)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 255, 100))
    })
    registerGradient(gradient)
    return gradient
end

local function createAnimatedRedText(textLabel)
    local gradient = Instance.new("UIGradient")
    gradient.Parent = textLabel
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 80, 80)),
        ColorSequenceKeypoint.new(0.25, Color3.fromRGB(200, 50, 50)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 100, 100)),
        ColorSequenceKeypoint.new(0.75, Color3.fromRGB(180, 40, 40)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 80, 80))
    })
    registerGradient(gradient)
    return gradient
end

local function addAnimatedYellowStroke(frame, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Name = "AnimatedYellowStroke"
    stroke.Color = Color3.fromRGB(255, 200, 50)
    stroke.Thickness = thickness or 2
    stroke.Transparency = 0
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = frame

    local gradient = Instance.new("UIGradient")
    gradient.Parent = stroke
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 230, 100)),
        ColorSequenceKeypoint.new(0.25, Color3.fromRGB(255, 180, 30)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 240, 120)),
        ColorSequenceKeypoint.new(0.75, Color3.fromRGB(255, 160, 20)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 230, 100))
    })
    
    registerGradient(gradient)
    return stroke
end

-- ==========================================
-- THEME COLORS - YELLOW
-- ==========================================
local Theme = {
    Primary = Color3.fromRGB(255, 200, 50),
    Secondary = Color3.fromRGB(255, 180, 30),
    Accent = Color3.fromRGB(255, 230, 100),
    Background = Color3.fromRGB(20, 18, 15),
    Background2 = Color3.fromRGB(35, 30, 25),
    Background3 = Color3.fromRGB(45, 40, 32),
    Text = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(200, 190, 180),
    Success = Color3.fromRGB(100, 255, 150),
    Danger = Color3.fromRGB(255, 100, 100),
    ToggleOn = Color3.fromRGB(255, 200, 50),
    ToggleOff = Color3.fromRGB(60, 55, 50),
    ToggleOffBg = Color3.fromRGB(40, 38, 35),
    SliderFill = Color3.fromRGB(255, 200, 50),
    DotColor = Color3.fromRGB(255, 200, 50),
    Keybind = Color3.fromRGB(255, 230, 100),
    Glow = Color3.fromRGB(255, 220, 80),
    CircleBorder = Color3.fromRGB(255, 200, 50)
}

-- ==========================================
-- CONFIGURATION SYSTEM
-- ==========================================
local function saveConfig(data)
    if writefile then
        pcall(function()
            writefile("HoneyDuelsConfigV3.json", HttpService:JSONEncode(data))
        end)
    end
end

local function loadConfig()
    if readfile and isfile then
        if isfile("HoneyDuelsConfigV3.json") then
            local success, result = pcall(function()
                return HttpService:JSONDecode(readfile("HoneyDuelsConfigV3.json"))
            end)
            if success then return result end
        end
    end
    -- Default values as requested
    return {
        espEnabled = false,
        infJumpEnabled = false,
        antiRagdollEnabled = false,
        autoHitEnabled = false,
        autoMedusaEnabled = false,
        medusaRange = 10,
        spinbotEnabled = false,
        spinbotSpeed = 30,
        autoStealEnabled = false,
        autoStealRadius = 20,
        unwalkEnabled = false,
        hitboxEnabled = false,
        hitboxSize = 12,
        xrayEnabled = false,
        optimizerEnabled = false,
        movementSpeedEnabled = false,
        movementSpeedValue = 58,
        stealSpeedEnabled = false,
        stealSpeedValue = 29,
        jumpBoostEnabled = false,
        jumpBoostValue = 75,
        gravityBoostEnabled = false,
        gravityBoostValue = 80,
        boosterUIEnabled = false,
        boosterUIMinimized = false,
        lockPlayerEnabled = false,
        lockPlayerUIEnabled = false,
        batAimbotEnabled = false,
        batAimbotWasAutoEnabled = false,
        autoLeftUIEnabled = false,
        autoRightUIEnabled = false,
        keybinds = {},
        boosterKeybinds = {}
    }
end

local config = loadConfig()
local keybinds = {}
local boosterKeybinds = {}

if config.keybinds then
    for feature, stored in pairs(config.keybinds) do
        if typeof(stored) == "string" then
            local success, enumVal = pcall(function() return Enum.KeyCode[stored] end)
            if success and enumVal then
                keybinds[feature] = enumVal
            end
        end
    end
end

if config.boosterKeybinds then
    for feature, stored in pairs(config.boosterKeybinds) do
        if typeof(stored) == "string" then
            local success, enumVal = pcall(function() return Enum.KeyCode[stored] end)
            if success and enumVal then
                boosterKeybinds[feature] = enumVal
            end
        end
    end
end

-- ==========================================
-- GLOBAL VARIABLES
-- ==========================================
local movementSpeedEnabled = false
local movementSpeedValue = config.movementSpeedValue or 58
local movementSpeedConnection = nil

local stealSpeedEnabled = false
local stealSpeedValue = config.stealSpeedValue or 29
local stealSpeedConnection = nil

local jumpBoostEnabled = false
local jumpBoostValue = config.jumpBoostValue or 75
local jumpBoostConnection = nil

local gravityBoostEnabled = false
local gravityBoostValue = config.gravityBoostValue or 80
local gravityBoostConnection = nil

local boosterUIEnabled = false
local boosterUIMinimized = config.boosterUIMinimized or false
local boosterUIFrame = nil

local espEnabled = false
local espFolder = nil
local espBoxes = {}
local espBillboards = {}
local espConnections = {}

local infJumpEnabled = false
local FIXED_JUMP_VELOCITY = 50

local antiRagdollEnabled = false

local autoStealProgressFrame = nil
local autoStealProgressBar = nil
local autoStealProgressFill = nil
local currentStealProgress = 0
local currentStealTarget = nil
local stealStartTime = nil
local STEAL_DURATION = 1.3

local autoHitEnabled = false
local autoHitConnection = nil

local autoMedusaEnabled = false
local autoMedusaConnection = nil
local medusaLastUsed = 0
local medusaRange = config.medusaRange or 10

local spinbotEnabled = false
local spinbotConnection = nil
local spinbotSpeed = config.spinbotSpeed or 30

local autoStealEnabled = false
local allAnimalsCache = {}
local InternalStealCache = {}
local cachedPrompts = {}
local AUTO_STEAL_PROX_RADIUS = config.autoStealRadius or 20
local stealConnection = nil
local isActivelyStealingAnimal = false
local lastStealAttempt = 0
local STEAL_COOLDOWN = 0.1

local unwalkEnabled = false
local savedAnimations = {}

local hitboxEnabled = false
local hitboxSize = config.hitboxSize or 12
local hitboxConnection = nil

local xrayEnabled = false
local originalTransparency = {}
local invisibleWallsLoaded = false

local optimizerEnabled = false
local originalLightingSettings = {}

local lockPlayerEnabled = false
local lockPlayerConnection = nil
local cachedBatForLockPlayer = nil

local lockPlayerUIEnabled = false
local lockPlayerUIFrame = nil

local batAimbotEnabled = false
local batAimbotConnection = nil
local batAimbotWasAutoEnabled = false
local alignOri = nil
local attach0 = nil
local AIMBOT_RANGE = 35
local AIMBOT_DISABLE_RANGE = 40

local autoLeftUIEnabled = false
local autoRightUIEnabled = false
local autoLeftUIFrame = nil
local autoRightUIFrame = nil
local autoLeftActive = false
local autoRightActive = false

-- Auto Left/Right coordinates from script 4
local leftTargets = {
    Vector3.new(-474.92510986328125, -6.398684978485107, 95.64352416992188),
    Vector3.new(-482.6980285644531, -4.433956623077393, 98.34976196289062)
}
local leftTargetsReturn = {
    Vector3.new(-482.6980285644531, -4.433956623077393, 98.34976196289062),
    Vector3.new(-474.92510986328125, -6.398684978485107, 95.64352416992188)
}
local rightTargets = {
    Vector3.new(-473.9881286621094, -6.398684024810791, 25.45433807373047),
    Vector3.new(-482.8011474609375, -4.433956623077393, 24.77419090270996)
}
local rightTargetsReturn = {
    Vector3.new(-482.8011474609375, -4.433956623077393, 24.77419090270996),
    Vector3.new(-473.9881286621094, -6.398684024810791, 25.45433807373047)
}
local autoMoveSpeed = 60

local toggles = {}
local boosterToggles = {}
local sliders = {}

local isCurrentlyStealing = false
local stealingDetectionConnection = nil
local wasMovementSpeedEnabledBeforeSteal = false

local mainFrame = nil

-- ==========================================
-- REMOTE FINDER UTILITY
-- ==========================================
local cachedRemotes = {}

local function findRemote(remoteName, searchPaths)
    if cachedRemotes[remoteName] then
        if cachedRemotes[remoteName].Parent then
            return cachedRemotes[remoteName]
        end
        cachedRemotes[remoteName] = nil
    end
    
    local pathsToSearch = searchPaths or {
        ReplicatedStorage,
        ReplicatedStorage:FindFirstChild("Packages"),
        ReplicatedStorage:FindFirstChild("Net"),
    }
    
    local function searchRecursive(parent, depth)
        if not parent or depth > 5 then return nil end
        for _, child in ipairs(parent:GetChildren()) do
            if (child:IsA("RemoteEvent") or child:IsA("RemoteFunction")) then
                if child.Name == remoteName or child.Name:find(remoteName) then
                    cachedRemotes[remoteName] = child
                    return child
                end
            end
            if child:IsA("Folder") or child:IsA("ModuleScript") then
                local found = searchRecursive(child, depth + 1)
                if found then return found end
            end
        end
        return nil
    end
    
    for _, path in ipairs(pathsToSearch) do
        if path then
            local found = searchRecursive(path, 0)
            if found then return found end
        end
    end
    
    for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
        if (v:IsA("RemoteEvent") or v:IsA("RemoteFunction")) and (v.Name == remoteName or v.Name:find(remoteName)) then
            cachedRemotes[remoteName] = v
            return v
        end
    end
    
    return nil
end

-- ==========================================
-- KEYBIND HANDLER
-- ==========================================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
    
    for featureName, keyCode in pairs(keybinds) do
        if input.KeyCode == keyCode then
            local tog = toggles[featureName]
            if tog then
                tog.SetState(not tog.GetState())
            end
        end
    end
    
    for featureName, keyCode in pairs(boosterKeybinds) do
        if input.KeyCode == keyCode then
            local tog = boosterToggles[featureName]
            if tog then
                local newState = not tog.IsEnabled()
                tog.SetEnabled(newState)
            end
        end
    end
end)

-- ==========================================
-- STEALING DETECTION SYSTEM
-- ==========================================
local function isPlayerStealing()
    if LocalPlayer:GetAttribute("Stealing") then
        return true
    end
    
    local char = LocalPlayer.Character
    if not char then return false end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return false end
    
    for _, plot in ipairs(plots:GetChildren()) do
        local podiums = plot:FindFirstChild("AnimalPodiums")
        if podiums then
            for _, podium in ipairs(podiums:GetChildren()) do
                local base = podium:FindFirstChild("Base")
                if base then
                    local spawn = base:FindFirstChild("Spawn")
                    if spawn then
                        local podiumPos = podium:GetPivot().Position
                        local dist = (hrp.Position - podiumPos).Magnitude
                        
                        if dist < 8 then
                            local attach = spawn:FindFirstChild("PromptAttachment")
                            if attach then
                                for _, p in ipairs(attach:GetChildren()) do
                                    if p:IsA("ProximityPrompt") and p.Enabled then
                                        return true
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return false
end

local function onStealingStateChanged(isStealing)
    if isStealing then
        if movementSpeedEnabled then
            wasMovementSpeedEnabledBeforeSteal = true
            if movementSpeedConnection then
                movementSpeedConnection:Disconnect()
                movementSpeedConnection = nil
            end
            if boosterToggles["Movement Speed"] then
                boosterToggles["Movement Speed"].SetEnabled(false)
            end
            movementSpeedEnabled = false
        end
        
        if stealSpeedEnabled and not stealSpeedConnection then
            stealSpeedConnection = RunService.Heartbeat:Connect(function()
                if not shouldUpdate("stealSpeed", 0.016) then return end
                local char = LocalPlayer.Character
                if not char then return end
                local hrp = char:FindFirstChild("HumanoidRootPart")
                local hum = char:FindFirstChildOfClass("Humanoid")
                if not hrp or not hum then return end
                if hum.MoveDirection.Magnitude > 0.01 then
                    local flatDir = Vector3.new(hum.MoveDirection.X, 0, hum.MoveDirection.Z).Unit
                    local boostVel = flatDir * stealSpeedValue
                    hrp.AssemblyLinearVelocity = Vector3.new(boostVel.X, hrp.AssemblyLinearVelocity.Y, boostVel.Z)
                end
            end)
        end
    else
        if stealSpeedConnection then
            stealSpeedConnection:Disconnect()
            stealSpeedConnection = nil
        end
        
        if wasMovementSpeedEnabledBeforeSteal then
            wasMovementSpeedEnabledBeforeSteal = false
            movementSpeedEnabled = true
            if boosterToggles["Movement Speed"] then
                boosterToggles["Movement Speed"].SetEnabled(true)
            end
            if not movementSpeedConnection then
                movementSpeedConnection = RunService.Heartbeat:Connect(function()
                    if not shouldUpdate("movementSpeed", 0.016) then return end
                    local char = LocalPlayer.Character
                    if not char then return end
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if not hrp or not hum then return end
                    if hum.MoveDirection.Magnitude > 0.01 then
                        local flatDir = Vector3.new(hum.MoveDirection.X, 0, hum.MoveDirection.Z).Unit
                        local boostVel = flatDir * movementSpeedValue
                        hrp.AssemblyLinearVelocity = Vector3.new(boostVel.X, hrp.AssemblyLinearVelocity.Y, boostVel.Z)
                    end
                end)
            end
        end
    end
end

local function startStealingDetection()
    if stealingDetectionConnection then return end
    
    pcall(function()
        LocalPlayer:GetAttributeChangedSignal("Stealing"):Connect(function()
            local isStealing = LocalPlayer:GetAttribute("Stealing") == true
            if isStealing ~= isCurrentlyStealing then
                isCurrentlyStealing = isStealing
                onStealingStateChanged(isStealing)
            end
        end)
    end)
    
    stealingDetectionConnection = RunService.Heartbeat:Connect(function()
        if not shouldUpdate("stealDetect", 0.1) then return end
        local nowStealing = isPlayerStealing()
        if nowStealing ~= isCurrentlyStealing then
            isCurrentlyStealing = nowStealing
            onStealingStateChanged(nowStealing)
        end
    end)
end

local function stopStealingDetection()
    if stealingDetectionConnection then
        stealingDetectionConnection:Disconnect()
        stealingDetectionConnection = nil
    end
end

-- ==========================================
-- BOOSTER FUNCTIONS
-- ==========================================
local function toggleMovementSpeed(state)
    movementSpeedEnabled = state
    config.movementSpeedEnabled = state
    saveConfig(config)
    
    if movementSpeedConnection then 
        movementSpeedConnection:Disconnect() 
        movementSpeedConnection = nil 
    end
    
    if state and not isCurrentlyStealing then
        movementSpeedConnection = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChildOfClass("Humanoid")
            if not hrp or not hum then return end
            if hum.MoveDirection.Magnitude > 0.01 then
                local flatDir = Vector3.new(hum.MoveDirection.X, 0, hum.MoveDirection.Z).Unit
                local boostVel = flatDir * movementSpeedValue
                hrp.AssemblyLinearVelocity = Vector3.new(boostVel.X, hrp.AssemblyLinearVelocity.Y, boostVel.Z)
            end
        end)
    end
    
    if movementSpeedEnabled or stealSpeedEnabled then
        startStealingDetection()
    else
        stopStealingDetection()
    end
end

local function toggleStealSpeed(state)
    stealSpeedEnabled = state
    config.stealSpeedEnabled = state
    saveConfig(config)
    
    if stealSpeedConnection then 
        stealSpeedConnection:Disconnect() 
        stealSpeedConnection = nil 
    end
    
    if state and isCurrentlyStealing then
        stealSpeedConnection = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChildOfClass("Humanoid")
            if not hrp or not hum then return end
            if hum.MoveDirection.Magnitude > 0.01 then
                local flatDir = Vector3.new(hum.MoveDirection.X, 0, hum.MoveDirection.Z).Unit
                local boostVel = flatDir * stealSpeedValue
                hrp.AssemblyLinearVelocity = Vector3.new(boostVel.X, hrp.AssemblyLinearVelocity.Y, boostVel.Z)
            end
        end)
    end
    
    if movementSpeedEnabled or stealSpeedEnabled then
        startStealingDetection()
    else
        stopStealingDetection()
    end
end

-- ==========================================
-- JUMP BOOST (Fixed same height every jump)
-- ==========================================
local jumpBoostActiveConnection = nil

local function toggleJumpBoost(state)
    jumpBoostEnabled = state
    if jumpBoostConnection then jumpBoostConnection:Disconnect() jumpBoostConnection = nil end
    if jumpBoostActiveConnection then jumpBoostActiveConnection:Disconnect() jumpBoostActiveConnection = nil end
    
    if state then
        local function applyJumpBoost()
            local char = LocalPlayer.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            
            hrp.AssemblyLinearVelocity = Vector3.new(
                hrp.AssemblyLinearVelocity.X,
                50 + jumpBoostValue,
                hrp.AssemblyLinearVelocity.Z
            )
        end
        
        jumpBoostActiveConnection = UserInputService.JumpRequest:Connect(function()
            if not jumpBoostEnabled then return end
            
            local char = LocalPlayer.Character
            if not char then return end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if not hum then return end
            
            local state = hum:GetState()
            if state == Enum.HumanoidStateType.Freefall or 
               state == Enum.HumanoidStateType.Flying or
               state == Enum.HumanoidStateType.Swimming then
                return
            end
            
            task.wait(0.05)
            applyJumpBoost()
        end)
        
        jumpBoostConnection = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            if not char then return end
            local hum = char:FindFirstChildOfClass("Humanoid")
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hum or not hrp then return end
            
            if hum:GetState() == Enum.HumanoidStateType.Freefall then
                if hrp.AssemblyLinearVelocity.Y > 0 and hrp.AssemblyLinearVelocity.Y < 60 then
                    local continuousBoost = (jumpBoostValue / 100) * 0.5
                    hrp.AssemblyLinearVelocity = Vector3.new(
                        hrp.AssemblyLinearVelocity.X,
                        hrp.AssemblyLinearVelocity.Y + continuousBoost,
                        hrp.AssemblyLinearVelocity.Z
                    )
                end
            end
        end)
    end
    
    config.jumpBoostEnabled = state
    saveConfig(config)
end

-- ==========================================
-- GRAVITY BOOST
-- ==========================================
local function toggleGravityBoost(state)
    gravityBoostEnabled = state
    if gravityBoostConnection then 
        gravityBoostConnection:Disconnect() 
        gravityBoostConnection = nil 
    end
    
    if state then
        gravityBoostConnection = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            
            local currentVelocity = hrp.AssemblyLinearVelocity
            
            if currentVelocity.Y < 0 then
                local slowdownFactor = gravityBoostValue / 100
                local resistanceForce = currentVelocity.Y * slowdownFactor * 0.8
                
                hrp.AssemblyLinearVelocity = Vector3.new(
                    currentVelocity.X,
                    currentVelocity.Y - resistanceForce,
                    currentVelocity.Z
                )
                
                local minFallSpeed = -100 + (gravityBoostValue * 0.95)
                
                if hrp.AssemblyLinearVelocity.Y > minFallSpeed then
                    hrp.AssemblyLinearVelocity = Vector3.new(
                        hrp.AssemblyLinearVelocity.X,
                        minFallSpeed,
                        hrp.AssemblyLinearVelocity.Z
                    )
                end
            end
        end)
    end
    
    config.gravityBoostEnabled = state
    saveConfig(config)
end

-- ==========================================
-- ANTI-RAGDOLL SYSTEM
-- ==========================================
local ANTI_RAGDOLL = {
    enabled = false,
    connections = {},
    cachedCharData = {}
}

local function disconnectAllAntiRagdoll()
    for _, conn in ipairs(ANTI_RAGDOLL.connections) do
        pcall(function() conn:Disconnect() end)
    end
    ANTI_RAGDOLL.connections = {}
end

local function cacheCharacterData()
    local char = LocalPlayer.Character
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root then return false end
    ANTI_RAGDOLL.cachedCharData = {
        character = char,
        humanoid = hum,
        root = root,
        isFrozen = false
    }
    return true
end

local function isRagdolled()
    if not ANTI_RAGDOLL.cachedCharData.humanoid then return false end
    local hum = ANTI_RAGDOLL.cachedCharData.humanoid
    local state = hum:GetState()
    local ragdollStates = {
        [Enum.HumanoidStateType.Physics] = true,
        [Enum.HumanoidStateType.Ragdoll] = true,
        [Enum.HumanoidStateType.FallingDown] = true
    }
    if ragdollStates[state] then return true end
    local endTime = LocalPlayer:GetAttribute("RagdollEndTime")
    if endTime then
        local now = workspace:GetServerTimeNow()
        if (endTime - now) > 0 then return true end
    end
    return false
end

local function removeRagdollConstraints()
    if not ANTI_RAGDOLL.cachedCharData.character then return false end
    local removed = false
    for _, descendant in ipairs(ANTI_RAGDOLL.cachedCharData.character:GetDescendants()) do
        if descendant:IsA("BallSocketConstraint") or
           (descendant:IsA("Attachment") and descendant.Name:find("RagdollAttachment")) then
            pcall(function()
                descendant:Destroy()
                removed = true
            end)
        end
    end
    return removed
end

local function forceExitRagdoll()
    if not ANTI_RAGDOLL.cachedCharData.humanoid or not ANTI_RAGDOLL.cachedCharData.root then return end
    local hum = ANTI_RAGDOLL.cachedCharData.humanoid
    local root = ANTI_RAGDOLL.cachedCharData.root
   
    pcall(function()
        local now = workspace:GetServerTimeNow()
        LocalPlayer:SetAttribute("RagdollEndTime", now)
    end)
   
    if hum.Health > 0 then
        hum:ChangeState(Enum.HumanoidStateType.Running)
    end
   
    root.Anchored = false
    root.AssemblyLinearVelocity = Vector3.zero
    root.AssemblyAngularVelocity = Vector3.zero
end

local function v1HeartbeatLoop()
    while ANTI_RAGDOLL.enabled and ANTI_RAGDOLL.cachedCharData.humanoid do
        task.wait(0.05)
        if isRagdolled() then
            removeRagdollConstraints()
            forceExitRagdoll()
        end
    end
end

local function setupCameraBinding()
    if not ANTI_RAGDOLL.cachedCharData.humanoid then return end
    local conn = RunService.RenderStepped:Connect(function()
        if not ANTI_RAGDOLL.enabled then return end
        if not shouldUpdate("camera", 0.1) then return end
        local cam = workspace.CurrentCamera
        if cam and ANTI_RAGDOLL.cachedCharData.humanoid and cam.CameraSubject ~= ANTI_RAGDOLL.cachedCharData.humanoid then
            cam.CameraSubject = ANTI_RAGDOLL.cachedCharData.humanoid
        end
    end)
    table.insert(ANTI_RAGDOLL.connections, conn)
end

local function onCharacterAddedAntiRagdoll(char)
    task.wait(0.5)
    if not ANTI_RAGDOLL.enabled then return end
    if cacheCharacterData() then
        setupCameraBinding()
        task.spawn(v1HeartbeatLoop)
    end
end

local function toggleAntiRagdoll(state)
    antiRagdollEnabled = state
    config.antiRagdollEnabled = state
    saveConfig(config)
   
    if state then
        if not cacheCharacterData() then
            return
        end
       
        ANTI_RAGDOLL.enabled = true
        local charConn = LocalPlayer.CharacterAdded:Connect(onCharacterAddedAntiRagdoll)
        table.insert(ANTI_RAGDOLL.connections, charConn)
       
        setupCameraBinding()
        task.spawn(v1HeartbeatLoop)
    else
        ANTI_RAGDOLL.enabled = false
        disconnectAllAntiRagdoll()
        ANTI_RAGDOLL.cachedCharData = {}
    end
end

-- ==========================================
-- XRAY SYSTEM
-- ==========================================
local function isBaseWall(obj)
    if not obj:IsA("BasePart") then return false end
    local n = obj.Name:lower()
    local parent = obj.Parent and obj.Parent.Name:lower() or ""
    return n:find("base") or parent:find("base") or n:find("wall") or parent:find("wall")
end

local function enableXray()
    xrayEnabled = true
    config.xrayEnabled = true
    saveConfig(config)
    
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Anchored and obj.CanCollide and isBaseWall(obj) then
            if not originalTransparency[obj] then
                originalTransparency[obj] = obj.LocalTransparencyModifier
            end
            obj.LocalTransparencyModifier = 0.85
        end
    end
    
    if not invisibleWallsLoaded then
        invisibleWallsLoaded = true
        workspace.DescendantAdded:Connect(function(obj)
            if xrayEnabled and isBaseWall(obj) then
                if not originalTransparency[obj] then
                    originalTransparency[obj] = obj.LocalTransparencyModifier
                end
                obj.LocalTransparencyModifier = 0.85
            end
        end)
    end
end

local function disableXray()
    xrayEnabled = false
    config.xrayEnabled = false
    saveConfig(config)
    
    for part, value in pairs(originalTransparency) do
        if part and part.Parent then
            part.LocalTransparencyModifier = value
        end
    end
    originalTransparency = {}
end

local function toggleXray(state)
    if state then
        enableXray()
    else
        disableXray()
    end
end

-- ==========================================
-- OPTIMIZER SYSTEM
-- ==========================================
local function enableOptimizer()
    optimizerEnabled = true
    config.optimizerEnabled = true
    saveConfig(config)
    
    originalLightingSettings = {
        Brightness = Lighting.Brightness,
        GlobalShadows = Lighting.GlobalShadows,
        FogEnd = Lighting.FogEnd,
        Ambient = Lighting.Ambient,
        OutdoorAmbient = Lighting.OutdoorAmbient,
    }
    
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 100000
    Lighting.Brightness = 2
    Lighting.Ambient = Color3.fromRGB(135, 206, 235)
    Lighting.OutdoorAmbient = Color3.fromRGB(135, 206, 235)
    
    for _, effect in ipairs(Lighting:GetChildren()) do
        if effect:IsA("PostEffect") then
            effect.Enabled = false
        end
    end
    
    pcall(function()
        workspace.Terrain.WaterWaveSize = 0
        workspace.Terrain.WaterWaveSpeed = 0
        workspace.Terrain.WaterReflectance = 0
        workspace.Terrain.Decoration = false
    end)
    
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            obj.CastShadow = false
        end
    end
    
    workspace.DescendantAdded:Connect(function(obj)
        if optimizerEnabled and obj:IsA("BasePart") then
            obj.CastShadow = false
        end
    end)
    
    pcall(function()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    end)
end

local function disableOptimizer()
    optimizerEnabled = false
    config.optimizerEnabled = false
    saveConfig(config)
    
    if originalLightingSettings.Brightness then
        Lighting.Brightness = originalLightingSettings.Brightness
    end
    if originalLightingSettings.GlobalShadows ~= nil then
        Lighting.GlobalShadows = originalLightingSettings.GlobalShadows
    end
    if originalLightingSettings.FogEnd then
        Lighting.FogEnd = originalLightingSettings.FogEnd
    end
    if originalLightingSettings.Ambient then
        Lighting.Ambient = originalLightingSettings.Ambient
    end
    if originalLightingSettings.OutdoorAmbient then
        Lighting.OutdoorAmbient = originalLightingSettings.OutdoorAmbient
    end
    
    for _, effect in ipairs(Lighting:GetChildren()) do
        if effect:IsA("PostEffect") then
            effect.Enabled = true
        end
    end
    
    pcall(function()
        workspace.Terrain.Decoration = true
    end)
end

local function toggleOptimizer(state)
    if state then
        enableOptimizer()
    else
        disableOptimizer()
    end
end

-- ==========================================
-- HITBOX EXPANDER
-- ==========================================
local function toggleHitbox(state)
    hitboxEnabled = state
    config.hitboxEnabled = state
    saveConfig(config)
    
    if hitboxConnection then hitboxConnection:Disconnect() hitboxConnection = nil end
    
    if not state then
        for _, p in Players:GetPlayers() do
            if p ~= LocalPlayer and p.Character then
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                if hrp then 
                    hrp.Size = Vector3.new(2, 2, 1) 
                    hrp.Transparency = 1 
                end
            end
        end
        return
    end
    
    hitboxConnection = RunService.Heartbeat:Connect(function()
        if not shouldUpdate("hitbox", 0.1) then return end
        for _, p in Players:GetPlayers() do
            if p ~= LocalPlayer and p.Character then
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
                    hrp.Transparency = 0.7
                    hrp.CanCollide = false
                end
            end
        end
    end)
end

-- ==========================================
-- INF JUMP (Fixed same height every jump)
-- ==========================================
local infJumpConnection = nil

local function toggleInfJump(state)
    infJumpEnabled = state
    config.infJumpEnabled = state
    saveConfig(config)
    
    if infJumpConnection then 
        infJumpConnection:Disconnect() 
        infJumpConnection = nil 
    end
    
    if not state then 
        return 
    end
    
    infJumpConnection = UserInputService.JumpRequest:Connect(function()
        if not infJumpEnabled then return end
        
        local char = LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hum or not hrp then return end
        
        if hum.Health <= 0 then return end
        
        local state = hum:GetState()
        if state == Enum.HumanoidStateType.Seated or 
           state == Enum.HumanoidStateType.Dead then
            return
        end
        
        -- Fixed jump velocity - same height every time
        hrp.AssemblyLinearVelocity = Vector3.new(
            hrp.AssemblyLinearVelocity.X,
            FIXED_JUMP_VELOCITY,
            hrp.AssemblyLinearVelocity.Z
        )
    end)
end

-- ==========================================
-- AUTO HIT (Hit players when close)
-- ==========================================
local cachedBat = nil
local lastBatCheck = 0
local lastHitTime = 0

local function toggleAutoHit(state)
    autoHitEnabled = state
    config.autoHitEnabled = state
    saveConfig(config)
    
    if autoHitConnection then autoHitConnection:Disconnect() autoHitConnection = nil end
    if not state then 
        cachedBat = nil
        return 
    end
    
    autoHitConnection = RunService.Heartbeat:Connect(function()
        if not shouldUpdate("autoHit", 0.15) then return end
        
        if isCurrentlyStealing then return end
        
        local now = tick()
        if now - lastHitTime < 0.3 then return end
       
        local char = LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end
        
        if now - lastBatCheck > 1 or not cachedBat or not cachedBat.Parent then
            lastBatCheck = now
            cachedBat = nil
            local backpack = LocalPlayer:FindFirstChild("Backpack")
            
            if backpack then
                cachedBat = backpack:FindFirstChild("Bat") or backpack:FindFirstChild("bat")
                if not cachedBat then
                    for _, tool in ipairs(backpack:GetChildren()) do
                        if tool:IsA("Tool") and tool.Name:lower():find("bat") then
                            cachedBat = tool
                            break
                        end
                    end
                end
            end
            
            if not cachedBat then
                cachedBat = char:FindFirstChild("Bat") or char:FindFirstChild("bat")
                if not cachedBat then
                    for _, tool in ipairs(char:GetChildren()) do
                        if tool:IsA("Tool") and tool.Name:lower():find("bat") then
                            cachedBat = tool
                            break
                        end
                    end
                end
            end
        end
        
        if not cachedBat then return end
        
        local myPos = hrp.Position
        local closestPlayer = nil
        local closestDist = 16
        
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local theirRoot = p.Character:FindFirstChild("HumanoidRootPart")
                local theirHum = p.Character:FindFirstChildOfClass("Humanoid")
                if theirRoot and theirHum and theirHum.Health > 0 then
                    local dist = (myPos - theirRoot.Position).Magnitude
                    if dist < closestDist then
                        closestDist = dist
                        closestPlayer = p
                    end
                end
            end
        end
        
        if closestPlayer then
            if cachedBat.Parent ~= char then
                hum:EquipTool(cachedBat)
            end
            
            if cachedBat.Parent == char then
                cachedBat:Activate()
                lastHitTime = now
            end
        end
    end)
end

-- ==========================================
-- AUTO MEDUSA
-- ==========================================
local function toggleAutoMedusa(state)
    autoMedusaEnabled = state
    config.autoMedusaEnabled = state
    saveConfig(config)
    
    if autoMedusaConnection then autoMedusaConnection:Disconnect() autoMedusaConnection = nil end
    if not state then return end
    
    autoMedusaConnection = RunService.Heartbeat:Connect(function()
        if not shouldUpdate("autoMedusa", 0.2) then return end
        
        if isCurrentlyStealing then return end
        
        if tick() - medusaLastUsed < 2 then return end

        local char = LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end
        
        local medusa = nil
        for _, tool in ipairs(char:GetChildren()) do
            if tool:IsA("Tool") then
                local toolName = tool.Name:lower()
                if toolName:find("medusa") or toolName:find("head") or toolName:find("stone") then
                    medusa = tool
                    break
                end
            end
        end
        
        if not medusa then return end
        
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local theirRoot = p.Character:FindFirstChild("HumanoidRootPart")
                local theirHum = p.Character:FindFirstChildOfClass("Humanoid")
                if theirRoot and theirHum and theirHum.Health > 0 then
                    local dist = (hrp.Position - theirRoot.Position).Magnitude
                    if dist <= medusaRange then
                        medusa:Activate()
                        
                        pcall(function()
                            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                            task.wait(0.01)
                            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
                        end)
                        
                        local useItemRemote = findRemote("UseItem")
                        if useItemRemote then
                            pcall(function()
                                if useItemRemote:IsA("RemoteEvent") then
                                    useItemRemote:FireServer(medusa)
                                else
                                    useItemRemote:InvokeServer(medusa)
                                end
                            end)
                        end
                        
                        medusaLastUsed = tick()
                        break
                    end
                end
            end
        end
    end)
end

-- ==========================================
-- SPINBOT
-- ==========================================
local function toggleSpinbot(state)
    spinbotEnabled = state
    config.spinbotEnabled = state
    saveConfig(config)
    
    if spinbotConnection then spinbotConnection:Disconnect() spinbotConnection = nil end

    local char = LocalPlayer.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local bodyAngularVel = hrp:FindFirstChild("SpinbotAngularVelocity")
            if bodyAngularVel then bodyAngularVel:Destroy() end
        end
    end

    if not state then return end
    
    spinbotConnection = RunService.Heartbeat:Connect(function()
        if not spinbotEnabled then return end
        local char = LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        
        local bodyAngularVel = hrp:FindFirstChild("SpinbotAngularVelocity")
        if not bodyAngularVel then
            bodyAngularVel = Instance.new("BodyAngularVelocity")
            bodyAngularVel.Name = "SpinbotAngularVelocity"
            bodyAngularVel.MaxTorque = Vector3.new(0, math.huge, 0)
            bodyAngularVel.Parent = hrp
        end
        
        bodyAngularVel.AngularVelocity = Vector3.new(0, spinbotSpeed, 0)
    end)
end

-- ==========================================
-- UNWALK
-- ==========================================
local function toggleUnwalk(state)
    unwalkEnabled = state
    config.unwalkEnabled = state
    saveConfig(config)
    
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local animate = char:FindFirstChild("Animate")
    local hum = char:FindFirstChildOfClass("Humanoid")
    
    if state then
        if animate then
            savedAnimations = {}
            local anims = {"run", "walk", "jump", "idle", "fall", "climb", "swim", "sit"}
            for _, n in ipairs(anims) do
                local a = animate:FindFirstChild(n)
                if a then
                    savedAnimations[n] = {}
                    for _, obj in ipairs(a:GetChildren()) do
                        if obj:IsA("Animation") then 
                            savedAnimations[n][obj.Name] = obj.AnimationId
                            obj.AnimationId = "rbxassetid://0" 
                        end
                    end
                end
            end
        end
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Landed)
        end
    else
        if animate and savedAnimations then
            for animName, animData in pairs(savedAnimations) do
                local a = animate:FindFirstChild(animName)
                if a then
                    for _, obj in ipairs(a:GetChildren()) do
                        if obj:IsA("Animation") and animData[obj.Name] then
                            obj.AnimationId = animData[obj.Name]
                        end
                    end
                end
            end
        end
        
        if animate then
            local animateClone = animate:Clone()
            animate:Destroy()
            animateClone.Parent = char
        end
        
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Running)
        end
        
        savedAnimations = {}
    end
end

-- ==========================================
-- ESP
-- ==========================================
local function createESP(player)
    if player == LocalPlayer then return end
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    if espBoxes[player.Name] then espBoxes[player.Name]:Destroy() espBoxes[player.Name] = nil end
    if espBillboards[player.Name] then espBillboards[player.Name]:Destroy() espBillboards[player.Name] = nil end
   
    local box = Instance.new("BoxHandleAdornment")
    box.Name = player.Name .. "_BOX"
    box.Adornee = hrp
    box.AlwaysOnTop = true
    box.ZIndex = 5
    box.Size = Vector3.new(4, 6, 4)
    box.Color3 = Theme.Primary
    box.Transparency = 0.7
    box.Parent = espFolder
   
    local bb = Instance.new("BillboardGui")
    bb.Name = player.Name .. "_NAME"
    bb.Adornee = hrp
    bb.Size = UDim2.new(0, 200, 0, 50)
    bb.StudsOffset = Vector3.new(0, 3.5, 0)
    bb.AlwaysOnTop = true
    bb.MaxDistance = 1000
    bb.Parent = espFolder
   
    local nameLabel = Instance.new("TextLabel", bb)
    nameLabel.Name = "NameLabel"
    nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = Theme.TextSecondary
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextSize = 14
    nameLabel.Font = Enum.Font.FredokaOne
   
    local distLabel = Instance.new("TextLabel", bb)
    distLabel.Name = "DistLabel"
    distLabel.Size = UDim2.new(1, 0, 0.5, 0)
    distLabel.Position = UDim2.new(0, 0, 0.5, 0)
    distLabel.BackgroundTransparency = 1
    distLabel.Text = "0 studs"
    distLabel.TextColor3 = Theme.TextSecondary
    distLabel.TextStrokeTransparency = 0
    distLabel.TextSize = 12
    distLabel.Font = Enum.Font.FredokaOne
   
    espBoxes[player.Name] = box
    espBillboards[player.Name] = bb
end

local function removeESP(player)
    local playerName = type(player) == "string" and player or player.Name
    if espBoxes[playerName] then espBoxes[playerName]:Destroy() espBoxes[playerName] = nil end
    if espBillboards[playerName] then espBillboards[playerName]:Destroy() espBillboards[playerName] = nil end
end

local function updateESP()
    if not espEnabled then return end
    if not shouldUpdate("esp", 0.1) then return end
    
    for _, p in ipairs(Players:GetPlayers()) do
        if p == LocalPlayer then continue end
        local char = p.Character
        if not char then removeESP(p) continue end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then removeESP(p) continue end
        
        if not espBoxes[p.Name] or not espBillboards[p.Name] then
            createESP(p)
        else
            local box = espBoxes[p.Name]
            local bb = espBillboards[p.Name]
            box.Adornee = hrp
            box.Color3 = Theme.Primary
            bb.Adornee = hrp
            
            local lhrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if lhrp then
                local d = (hrp.Position - lhrp.Position).Magnitude
                local distLabel = bb:FindFirstChild("DistLabel")
                if distLabel then
                    distLabel.Text = math.floor(d) .. " studs"
                end
            end
        end
    end
    
    for n in pairs(espBoxes) do
        if not Players:FindFirstChild(n) then removeESP(n) end
    end
end

local function clearESP()
    for _, b in pairs(espBoxes) do if b then b:Destroy() end end
    for _, b in pairs(espBillboards) do if b then b:Destroy() end end
    espBoxes = {}
    espBillboards = {}
end

local function startESP()
    espEnabled = true
    config.espEnabled = true
    saveConfig(config)
    
    clearESP()
    espFolder = espFolder or Instance.new("Folder")
    espFolder.Name = "HONEY_ESP"
    espFolder.Parent = CoreGui
    
    table.insert(espConnections, RunService.RenderStepped:Connect(updateESP))
    table.insert(espConnections, Players.PlayerAdded:Connect(createESP))
    table.insert(espConnections, Players.PlayerRemoving:Connect(removeESP))
    
    for _, p in ipairs(Players:GetPlayers()) do 
        if p ~= LocalPlayer then createESP(p) end 
    end
end

local function stopESP()
    espEnabled = false
    config.espEnabled = false
    saveConfig(config)
    
    for _, c in ipairs(espConnections) do if c then c:Disconnect() end end
    espConnections = {}
    clearESP()
    if espFolder then espFolder:Destroy() espFolder = nil end
end

-- ==========================================
-- BAT AIMBOT (From Script 3)
-- ==========================================
local function getClosestTarget()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end

    local hrp = char.HumanoidRootPart
    local closest = nil
    local shortestDistance = AIMBOT_RANGE

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local theirHum = plr.Character:FindFirstChildOfClass("Humanoid")
            if theirHum and theirHum.Health > 0 then
                local targetHrp = plr.Character.HumanoidRootPart
                local dist = (targetHrp.Position - hrp.Position).Magnitude

                if dist <= shortestDistance then
                    shortestDistance = dist
                    closest = targetHrp
                end
            end
        end
    end
    return closest
end

local function stopBatAimbot()
    if batAimbotConnection then batAimbotConnection:Disconnect() batAimbotConnection = nil end
    if alignOri then alignOri:Destroy() alignOri = nil end
    if attach0 then attach0:Destroy() attach0 = nil end

    local char = LocalPlayer.Character
    if char then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid.AutoRotate = true end
    end
end

local function startBatAimbot()
    if batAimbotConnection then return end
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    
    if not hrp or not hum then return end
    hum.AutoRotate = false

    attach0 = Instance.new("Attachment", hrp)
    alignOri = Instance.new("AlignOrientation")
    alignOri.Attachment0 = attach0
    alignOri.Mode = Enum.OrientationAlignmentMode.OneAttachment
    alignOri.RigidityEnabled = true
    alignOri.MaxTorque = math.huge
    alignOri.Responsiveness = 200
    alignOri.Parent = hrp

    batAimbotConnection = RunService.RenderStepped:Connect(function()
        local target = getClosestTarget()
        if not target then return end

        local dist = (target.Position - hrp.Position).Magnitude
        if dist > AIMBOT_DISABLE_RANGE then return end

        local lookPos = Vector3.new(target.Position.X, hrp.Position.Y, target.Position.Z)
        alignOri.CFrame = CFrame.lookAt(hrp.Position, lookPos)
    end)
end

local function toggleBatAimbot(state)
    batAimbotEnabled = state
    config.batAimbotEnabled = state
    saveConfig(config)
    
    if state then
        startBatAimbot()
    else
        stopBatAimbot()
    end
end

-- ==========================================
-- LOCK PLAYER (Previously Auto Go & Hit)
-- ==========================================
local function toggleLockPlayer(state)
    lockPlayerEnabled = state
    config.lockPlayerEnabled = state
    saveConfig(config)
    
    if lockPlayerConnection then lockPlayerConnection:Disconnect() lockPlayerConnection = nil end
    if not state then 
        cachedBatForLockPlayer = nil
        
        -- Disable Bat Aimbot if it was auto-enabled
        if batAimbotWasAutoEnabled then
            batAimbotWasAutoEnabled = false
            config.batAimbotWasAutoEnabled = false
            saveConfig(config)
            toggleBatAimbot(false)
            if toggles["Bat Aimbot"] then
                toggles["Bat Aimbot"].SetState(false)
            end
        end
        return 
    end
    
    -- Auto-enable Bat Aimbot if not already enabled
    if not batAimbotEnabled then
        batAimbotWasAutoEnabled = true
        config.batAimbotWasAutoEnabled = true
        saveConfig(config)
        toggleBatAimbot(true)
        if toggles["Bat Aimbot"] then
            toggles["Bat Aimbot"].SetState(true)
        end
    end
    
    local lastHitTimeLockPlayer = 0
    local lastBatCheckLockPlayer = 0
    
    lockPlayerConnection = RunService.Heartbeat:Connect(function()
        if not lockPlayerEnabled then return end
        if not shouldUpdate("lockPlayer", 0.016) then return end
        
        local char = LocalPlayer.Character
        if not char then return end
        local myRoot = char:FindFirstChild("HumanoidRootPart")
        local myHum = char:FindFirstChildOfClass("Humanoid")
        if not myRoot or not myHum then return end
        
        local closestPlayer = nil
        local closestDist = 200
        
        for _, p in ipairs(Players:GetPlayers()) do
            if p == LocalPlayer or not p.Character then continue end
            local theirRoot = p.Character:FindFirstChild("HumanoidRootPart")
            if not theirRoot then continue end
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            if not hum or hum.Health <= 0 then continue end
            local dist = (myRoot.Position - theirRoot.Position).Magnitude
            if dist < closestDist then
                closestDist = dist
                closestPlayer = p
            end
        end
        
        if not closestPlayer or not closestPlayer.Character then return end
        
        local theirRoot = closestPlayer.Character:FindFirstChild("HumanoidRootPart")
        local theirHum = closestPlayer.Character:FindFirstChildOfClass("Humanoid")
        if not theirRoot or not theirHum then return end
        
        local theirVelocity = theirRoot.AssemblyLinearVelocity
        local dirToPlayer = (theirRoot.Position - myRoot.Position)
        local horizontalDir = Vector3.new(dirToPlayer.X, 0, dirToPlayer.Z)
        local horizontalDist = horizontalDir.Magnitude
        
        if horizontalDist > 0.1 then
            horizontalDir = horizontalDir.Unit
        else
            horizontalDir = Vector3.zero
        end
        
        local targetOffset = 2.5
        local targetPosition = theirRoot.Position - horizontalDir * targetOffset
        local moveDir = (targetPosition - myRoot.Position)
        local moveDirHorizontal = Vector3.new(moveDir.X, 0, moveDir.Z)
        
        if moveDirHorizontal.Magnitude > 0.5 then
            moveDirHorizontal = moveDirHorizontal.Unit
            local chaseSpeed = math.clamp(horizontalDist * 2, 20, 60)
            
            myRoot.AssemblyLinearVelocity = Vector3.new(
                moveDirHorizontal.X * chaseSpeed + theirVelocity.X * 0.5,
                myRoot.AssemblyLinearVelocity.Y,
                moveDirHorizontal.Z * chaseSpeed + theirVelocity.Z * 0.5
            )
        else
            myRoot.AssemblyLinearVelocity = Vector3.new(
                theirVelocity.X,
                myRoot.AssemblyLinearVelocity.Y,
                theirVelocity.Z
            )
        end
        
        local theirState = theirHum:GetState()
        local myState = myHum:GetState()
        
        if theirState == Enum.HumanoidStateType.Jumping or 
           (theirState == Enum.HumanoidStateType.Freefall and theirVelocity.Y > 10) then
            if myState == Enum.HumanoidStateType.Running or myState == Enum.HumanoidStateType.Landed then
                myHum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
        
        local yDiff = theirRoot.Position.Y - myRoot.Position.Y
        if math.abs(yDiff) > 3 and horizontalDist < 10 then
            if yDiff > 0 then
                if myState == Enum.HumanoidStateType.Running or myState == Enum.HumanoidStateType.Landed then
                    myHum:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
        end
        
        local now = tick()
        if horizontalDist <= 6 and now - lastHitTimeLockPlayer > 0.4 then
            if now - lastBatCheckLockPlayer > 1 or not cachedBatForLockPlayer or not cachedBatForLockPlayer.Parent then
                lastBatCheckLockPlayer = now
                cachedBatForLockPlayer = nil
                local backpack = LocalPlayer:FindFirstChild("Backpack")
                
                if backpack then
                    cachedBatForLockPlayer = backpack:FindFirstChild("Bat") or backpack:FindFirstChild("bat")
                    if not cachedBatForLockPlayer then
                        for _, tool in ipairs(backpack:GetChildren()) do
                            if tool:IsA("Tool") and tool.Name:lower():find("bat") then
                                cachedBatForLockPlayer = tool
                                break
                            end
                        end
                    end
                end
                
                if not cachedBatForLockPlayer then
                    cachedBatForLockPlayer = char:FindFirstChild("Bat") or char:FindFirstChild("bat")
                    if not cachedBatForLockPlayer then
                        for _, tool in ipairs(char:GetChildren()) do
                            if tool:IsA("Tool") and tool.Name:lower():find("bat") then
                                cachedBatForLockPlayer = tool
                                break
                            end
                        end
                    end
                end
            end
            
            if cachedBatForLockPlayer then
                if cachedBatForLockPlayer.Parent ~= char then
                    myHum:EquipTool(cachedBatForLockPlayer)
                end
                
                if cachedBatForLockPlayer.Parent == char then
                    cachedBatForLockPlayer:Activate()
                    lastHitTimeLockPlayer = now
                end
            end
        end
    end)
end

-- ==========================================
-- AUTO STEAL SYSTEM (From Script 2 - Marine Blue style)
-- ==========================================
local function getHRP()
    local c = LocalPlayer.Character
    if not c then return nil end
    return c:FindFirstChild("HumanoidRootPart") or c:FindFirstChild("UpperTorso") or c.PrimaryPart
end

-- Circle border system from Script 2
local CIRCLE_SEGMENTS = 64
local SEGMENT_HEIGHT = 0.15
local SEGMENT_THICKNESS = 0.25
local circleParts = {}

local function destroyCircleParts()
    for _, part in ipairs(circleParts) do
        if part and part.Parent then part:Destroy() end
    end
    circleParts = {}
    pcall(function()
        RunService:UnbindFromRenderStep("AutoStealCircleFollow")
    end)
end

local function createCircleBorder()
    destroyCircleParts()

    local char = LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local points = {}
    for i = 0, CIRCLE_SEGMENTS - 1 do
        local angle = math.rad(i * 360 / CIRCLE_SEGMENTS)
        table.insert(points, Vector3.new(math.cos(angle), 0, math.sin(angle)) * AUTO_STEAL_PROX_RADIUS)
    end

    for i = 1, #points do
        local nextIndex = i % #points + 1
        local p1 = points[i]
        local p2 = points[nextIndex]

        local part = Instance.new("Part")
        part.Anchored = true
        part.CanCollide = false
        part.Size = Vector3.new((p2 - p1).Magnitude, SEGMENT_HEIGHT, SEGMENT_THICKNESS)
        part.Color = Theme.CircleBorder
        part.Material = Enum.Material.Neon
        part.Transparency = 0.25
        part.TopSurface = Enum.SurfaceType.Smooth
        part.BottomSurface = Enum.SurfaceType.Smooth
        part.CastShadow = false
        part.Parent = workspace
        table.insert(circleParts, part)
    end

    RunService:BindToRenderStep("AutoStealCircleFollow", Enum.RenderPriority.Camera.Value + 1, function()
        local r = char:FindFirstChild("HumanoidRootPart")
        if not r then return end

        local pts = {}
        for i = 0, CIRCLE_SEGMENTS - 1 do
            local angle = math.rad(i * 360 / CIRCLE_SEGMENTS)
            table.insert(pts, Vector3.new(math.cos(angle), 0, math.sin(angle)) * AUTO_STEAL_PROX_RADIUS)
        end

        for idx, p in ipairs(circleParts) do
            if p and p.Parent then
                local nextIndex = idx % #pts + 1
                local a = pts[idx]
                local b = pts[nextIndex]
                local center = (a + b) / 2 + Vector3.new(r.Position.X, r.Position.Y - 2.8, r.Position.Z)
                p.Size = Vector3.new((b - a).Magnitude, SEGMENT_HEIGHT, SEGMENT_THICKNESS)
                p.CFrame = CFrame.new(center, center + Vector3.new(b.X - a.X, 0, b.Z - a.Z)) * CFrame.Angles(0, math.pi / 2, 0)
            end
        end
    end)
end

local function updateRadiusCircle()
    destroyCircleParts()
    if autoStealEnabled then
        createCircleBorder()
    end
end

local function isMyBase(plotName)
    local plot = workspace:FindFirstChild("Plots") and workspace.Plots:FindFirstChild(plotName)
    if not plot then return false end
    local sign = plot:FindFirstChild("PlotSign")
    if sign then
        local yourBase = sign:FindFirstChild("YourBase")
        if yourBase and yourBase:IsA("BillboardGui") then
            return yourBase.Enabled == true
        end
    end
    return false
end

local function isStealPrompt(prompt)
    if not prompt or not prompt:IsA("ProximityPrompt") then return false end
    local objText = prompt.ObjectText and prompt.ObjectText:lower() or ""
    local actText = prompt.ActionText and prompt.ActionText:lower() or ""
    return objText:find("steal") or actText:find("steal")
end

local function findPromptForAnimal(animalData)
    if not animalData then return nil end

    local uid = animalData.uid
    if uid and cachedPrompts[uid] and cachedPrompts[uid].Parent then
        if isStealPrompt(cachedPrompts[uid]) then
            return cachedPrompts[uid]
        else
            cachedPrompts[uid] = nil
        end
    end

    local plots = workspace:FindFirstChild("Plots")
    if not plots then return nil end

    local plot = plots:FindFirstChild(animalData.plot)
    if not plot then return nil end

    local podiums = plot:FindFirstChild("AnimalPodiums")
    if not podiums then return nil end

    local podium = podiums:FindFirstChild(animalData.slot)
    if not podium then return nil end

    local base = podium:FindFirstChild("Base")
    if not base then return nil end

    local spawn = base:FindFirstChild("Spawn")
    if not spawn then return nil end

    local attach = spawn:FindFirstChild("PromptAttachment")
    if attach then
        for _, p in ipairs(attach:GetChildren()) do
            if p:IsA("ProximityPrompt") and isStealPrompt(p) then
                if uid then cachedPrompts[uid] = p end
                return p
            end
        end
    end

    for _, c in ipairs(spawn:GetChildren()) do
        if c:IsA("ProximityPrompt") and isStealPrompt(c) then
            if uid then cachedPrompts[uid] = c end
            return c
        end
    end

    return nil
end

local function buildStealCallbacks(prompt)
    if not prompt then return nil end
    if InternalStealCache[prompt] then return InternalStealCache[prompt] end

    local data = {holdCallbacks = {}, triggerCallbacks = {}, ready = true}

    local ok, conns = pcall(getconnections, prompt.PromptButtonHoldBegan)
    if ok and conns then
        for _, conn in ipairs(conns) do
            if type(conn.Function) == "function" then
                table.insert(data.holdCallbacks, conn.Function)
            end
        end
    end

    local ok2, conns2 = pcall(getconnections, prompt.Triggered)
    if ok2 and conns2 then
        for _, conn in ipairs(conns2) do
            if type(conn.Function) == "function" then
                table.insert(data.triggerCallbacks, conn.Function)
            end
        end
    end

    if #data.holdCallbacks > 0 or #data.triggerCallbacks > 0 then
        InternalStealCache[prompt] = data
        return data
    end

    return nil
end

local function runCallbackList(list)
    for _, fn in ipairs(list) do
        task.spawn(fn)
    end
end

local function updateAutoStealProgress(progress)
    if not autoStealProgressFill then return end
    progress = math.clamp(progress, 0, 100)
    TweenService:Create(autoStealProgressFill, TweenInfo.new(0.1, Enum.EasingStyle.Linear), {
        Size = UDim2.new(progress / 100, 0, 1, 0)
    }):Play()
end

local function hideAutoStealProgress()
    updateAutoStealProgress(0)
    isActivelyStealingAnimal = false
    stealStartTime = nil
    currentStealTarget = nil
end

local function executeSteal(prompt, animalData)
    if not prompt then return false end

    local data = buildStealCallbacks(prompt)
    if not data or not data.ready then return false end

    data.ready = false
    isActivelyStealingAnimal = true
    stealStartTime = tick()
    currentStealTarget = animalData

    updateAutoStealProgress(0)

    task.spawn(function()
        runCallbackList(data.holdCallbacks)

        local elapsed = 0
        while elapsed < STEAL_DURATION and isActivelyStealingAnimal do
            task.wait(0.03)
            elapsed = tick() - stealStartTime
            local progress = math.min((elapsed / STEAL_DURATION) * 100, 100)
            updateAutoStealProgress(progress)
        end

        runCallbackList(data.triggerCallbacks)

        updateAutoStealProgress(100)
        task.wait(0.2)

        isActivelyStealingAnimal = false
        stealStartTime = nil
        currentStealTarget = nil
        data.ready = true

        task.wait(0.15)
        if not isActivelyStealingAnimal then
            hideAutoStealProgress()
        end
    end)

    return true
end

local function scanSinglePlot(plot)
    if not plot or not plot:IsA("Model") then return end
    if isMyBase(plot.Name) then return end

    local podiums = plot:FindFirstChild("AnimalPodiums")
    if not podiums then return end

    for _, podium in ipairs(podiums:GetChildren()) do
        if not podium:IsA("Model") then continue end

        local hasAnimal = false
        local animalName = nil

        local base = podium:FindFirstChild("Base")
        if base then
            local spawn = base:FindFirstChild("Spawn")
            if spawn then
                for _, child in ipairs(spawn:GetChildren()) do
                    if child:IsA("Model") and child.Name ~= "PromptAttachment" then
                        hasAnimal = true
                        animalName = child.Name
                        break
                    end
                end
            end
        end

        if not hasAnimal then
            for _, part in ipairs(podium:GetDescendants()) do
                if part:IsA("Model") and part.Name ~= "Base" and part.Name ~= "Spawn" then
                    hasAnimal = true
                    animalName = part.Name
                    break
                end
            end
        end

        if hasAnimal then
            table.insert(allAnimalsCache, {
                name = animalName or podium.Name,
                plot = plot.Name,
                slot = podium.Name,
                worldPosition = podium:GetPivot().Position,
                uid = plot.Name .. "_" .. podium.Name,
            })
        end
    end
end

local function initializeScanner()
    local plots = workspace:FindFirstChild("Plots")
    if not plots then
        plots = workspace:WaitForChild("Plots", 10)
    end
    if not plots then return end

    allAnimalsCache = {}
    for _, plot in ipairs(plots:GetChildren()) do
        scanSinglePlot(plot)
    end

    plots.ChildAdded:Connect(function(plot)
        if plot:IsA("Model") then
            task.wait(0.5)
            scanSinglePlot(plot)
        end
    end)

    task.spawn(function()
        while task.wait(5) do
            if not autoStealEnabled then continue end
            allAnimalsCache = {}
            for _, plot in ipairs(plots:GetChildren()) do
                scanSinglePlot(plot)
            end
        end
    end)
end

local function shouldSteal(animalData)
    if not animalData or not animalData.worldPosition then return false end

    local hrp = getHRP()
    if not hrp then return false end

    local currentDistance = (hrp.Position - animalData.worldPosition).Magnitude
    return currentDistance <= AUTO_STEAL_PROX_RADIUS
end

local function getNearestAnimal()
    local hrp = getHRP()
    if not hrp then return nil end

    local nearest = nil
    local minDist = math.huge

    for _, animalData in ipairs(allAnimalsCache) do
        if isMyBase(animalData.plot) then continue end

        if animalData.worldPosition then
            local dist = (hrp.Position - animalData.worldPosition).Magnitude
            if dist < minDist then
                minDist = dist
                nearest = animalData
            end
        end
    end

    return nearest
end

local function autoStealLoop()
    if stealConnection then stealConnection:Disconnect() stealConnection = nil end
    if not autoStealEnabled then return end

    stealConnection = RunService.Heartbeat:Connect(function()
        if not autoStealEnabled then return end
        if not shouldUpdate("autoSteal", 0.03) then return end
        if isActivelyStealingAnimal then return end

        local now = tick()
        if now - lastStealAttempt < STEAL_COOLDOWN then return end

        local target = getNearestAnimal()
        if not target then
            updateAutoStealProgress(0)
            return
        end

        if not shouldSteal(target) then
            updateAutoStealProgress(0)
            return
        end

        local prompt = findPromptForAnimal(target)
        if prompt and prompt.Enabled then
            lastStealAttempt = now
            executeSteal(prompt, target)
        else
            updateAutoStealProgress(0)
        end
    end)
end

local function toggleAutoSteal(state)
    autoStealEnabled = state
    config.autoStealEnabled = state
    saveConfig(config)

    if state then
        if not game:IsLoaded() then game.Loaded:Wait() end
        if not LocalPlayer.Character then LocalPlayer.CharacterAdded:Wait() end

        cachedPrompts = {}
        InternalStealCache = {}
        lastStealAttempt = 0

        updateAutoStealProgress(0)
        updateRadiusCircle()

        task.spawn(autoStealLoop)
    else
        hideAutoStealProgress()
        destroyCircleParts()

        isActivelyStealingAnimal = false
        stealStartTime = nil
        currentStealTarget = nil

        if stealConnection then
            stealConnection:Disconnect()
            stealConnection = nil
        end

        cachedPrompts = {}
    end
end

-- ==========================================
-- AUTO LEFT/RIGHT FUNCTIONS (From Script 4)
-- ==========================================
local function moveToTargets(targetList, checkFlag)
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = character:WaitForChild("HumanoidRootPart")
    for i, target in ipairs(targetList) do
        while (hrp.Position - target).Magnitude > 1 do
            if not checkFlag() then return false end
            hrp.Velocity = (target - hrp.Position).Unit * autoMoveSpeed
            RunService.RenderStepped:Wait()
        end
    end
    hrp.Velocity = Vector3.new(0, 0, 0)
    return true
end

local function runAutoLeft()
    autoLeftActive = true
    autoRightActive = false
    
    task.spawn(function()
        local completed = moveToTargets(leftTargets, function() return autoLeftActive end)
        if completed then
            moveToTargets(leftTargetsReturn, function() return autoLeftActive end)
        end
        autoLeftActive = false
    end)
end

local function runAutoRight()
    autoRightActive = true
    autoLeftActive = false
    
    task.spawn(function()
        local completed = moveToTargets(rightTargets, function() return autoRightActive end)
        if completed then
            moveToTargets(rightTargetsReturn, function() return autoRightActive end)
        end
        autoRightActive = false
    end)
end

-- ==========================================
-- UI CREATION
-- ==========================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "HoneyDuels"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 1000
screenGui.Parent = PlayerGui

-- ==========================================
-- UNIVERSAL DRAG FUNCTION (Works on Mobile and PC)
-- ==========================================
local function makeDraggable(frame)
    local dragging = false
    local dragInput = nil
    local dragStart = nil
    local startPos = nil
    
    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
    
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

-- ==========================================
-- AUTO STEAL UI (Simplified - No name label, wider, no border)
-- ==========================================
local function createAutoStealUI()
    local baseWidth = isMobile and 240 or 280
    local baseHeight = isMobile and 36 or 42

    autoStealProgressFrame = Instance.new("Frame")
    autoStealProgressFrame.Name = "AutoStealPanel"
    autoStealProgressFrame.Size = UDim2.new(0, baseWidth, 0, baseHeight)
    -- Positioned above center
    autoStealProgressFrame.Position = UDim2.new(0.5, -baseWidth / 2, 0.35, 0)
    autoStealProgressFrame.BackgroundColor3 = Theme.Background
    autoStealProgressFrame.BackgroundTransparency = 0.05
    autoStealProgressFrame.Active = true
    autoStealProgressFrame.Parent = screenGui

    Instance.new("UICorner", autoStealProgressFrame).CornerRadius = UDim.new(0, 10)
    -- No border/stroke

    makeDraggable(autoStealProgressFrame)

    local topRow = Instance.new("Frame")
    topRow.Size = UDim2.new(1, 0, 0, isMobile and 20 or 24)
    topRow.Position = UDim2.new(0, 0, 0, 2)
    topRow.BackgroundTransparency = 1
    topRow.Parent = autoStealProgressFrame

    -- Toggle
    local toggleWidth = isMobile and 36 or 42
    local toggleHeight = isMobile and 18 or 20
    local toggleContainer = Instance.new("Frame")
    toggleContainer.Size = UDim2.new(0, toggleWidth, 0, toggleHeight)
    toggleContainer.Position = UDim2.new(0, 6, 0.5, -toggleHeight / 2)
    toggleContainer.BackgroundTransparency = 1
    toggleContainer.Parent = topRow

    local toggleBg = Instance.new("Frame")
    toggleBg.Size = UDim2.new(1, 0, 1, 0)
    toggleBg.BackgroundColor3 = Theme.ToggleOffBg
    toggleBg.Parent = toggleContainer
    Instance.new("UICorner", toggleBg).CornerRadius = UDim.new(1, 0)

    local toggleTrack = Instance.new("Frame")
    toggleTrack.Size = UDim2.new(1, -4, 1, -4)
    toggleTrack.Position = UDim2.new(0, 2, 0, 2)
    toggleTrack.BackgroundColor3 = Theme.ToggleOff
    toggleTrack.Parent = toggleBg
    Instance.new("UICorner", toggleTrack).CornerRadius = UDim.new(1, 0)

    local circleSize = toggleHeight - 8
    local toggleCircle = Instance.new("Frame")
    toggleCircle.Size = UDim2.new(0, circleSize, 0, circleSize)
    toggleCircle.Position = UDim2.new(0, 4, 0.5, -circleSize / 2)
    toggleCircle.BackgroundColor3 = Color3.fromRGB(130, 140, 160)
    toggleCircle.Parent = toggleBg
    Instance.new("UICorner", toggleCircle).CornerRadius = UDim.new(1, 0)

    local toggleGradientRef = nil

    local function updateToggleVisuals(enabled, animate)
        local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        if enabled then
            local pos = UDim2.new(1, -circleSize - 4, 0.5, -circleSize / 2)
            if animate then
                TweenService:Create(toggleCircle, tweenInfo, {Position = pos}):Play()
                TweenService:Create(toggleTrack, tweenInfo, {BackgroundColor3 = Theme.ToggleOn}):Play()
                TweenService:Create(toggleCircle, tweenInfo, {BackgroundColor3 = Color3.fromRGB(255, 250, 240)}):Play()
            else
                toggleCircle.Position = pos
                toggleTrack.BackgroundColor3 = Theme.ToggleOn
                toggleCircle.BackgroundColor3 = Color3.fromRGB(255, 250, 240)
            end
            if not toggleGradientRef then
                toggleGradientRef = Instance.new("UIGradient")
                toggleGradientRef.Parent = toggleTrack
                toggleGradientRef.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 220, 80)),
                    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 200, 50)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 180, 30))
                })
                toggleGradientRef.Rotation = 45
                registerGradient(toggleGradientRef)
            end
        else
            local pos = UDim2.new(0, 4, 0.5, -circleSize / 2)
            if animate then
                TweenService:Create(toggleCircle, tweenInfo, {Position = pos}):Play()
                TweenService:Create(toggleTrack, tweenInfo, {BackgroundColor3 = Theme.ToggleOff}):Play()
                TweenService:Create(toggleCircle, tweenInfo, {BackgroundColor3 = Color3.fromRGB(130, 140, 160)}):Play()
            else
                toggleCircle.Position = pos
                toggleTrack.BackgroundColor3 = Theme.ToggleOff
                toggleCircle.BackgroundColor3 = Color3.fromRGB(130, 140, 160)
            end
            if toggleGradientRef then
                for i, g in ipairs(activeGradients) do
                    if g == toggleGradientRef then table.remove(activeGradients, i) break end
                end
                toggleGradientRef:Destroy()
                toggleGradientRef = nil
            end
        end
    end

    local autoLabel = Instance.new("TextLabel")
    autoLabel.Size = UDim2.new(0, isMobile and 28 or 34, 1, 0)
    autoLabel.Position = UDim2.new(0, toggleWidth + 10, 0, 0)
    autoLabel.BackgroundTransparency = 1
    autoLabel.Text = "Auto"
    autoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    autoLabel.Font = Enum.Font.FredokaOne
    autoLabel.TextSize = isMobile and 11 or 13
    autoLabel.TextXAlignment = Enum.TextXAlignment.Left
    autoLabel.Parent = topRow

    local stealLabel = Instance.new("TextLabel")
    stealLabel.Size = UDim2.new(0, isMobile and 34 or 40, 1, 0)
    stealLabel.Position = UDim2.new(0, toggleWidth + (isMobile and 38 or 46), 0, 0)
    stealLabel.BackgroundTransparency = 1
    stealLabel.Text = "Steal"
    stealLabel.TextColor3 = Theme.Primary
    stealLabel.Font = Enum.Font.FredokaOne
    stealLabel.TextSize = isMobile and 11 or 13
    stealLabel.TextXAlignment = Enum.TextXAlignment.Left
    stealLabel.Parent = topRow
    createAnimatedYellowText(stealLabel)

    local radiusBox = Instance.new("TextBox")
    radiusBox.Name = "RadiusBox"
    radiusBox.Size = UDim2.new(0, isMobile and 40 or 48, 0, isMobile and 20 or 24)
    radiusBox.Position = UDim2.new(1, -(isMobile and 48 or 56), 0.5, -(isMobile and 10 or 12))
    radiusBox.BackgroundColor3 = Color3.fromRGB(25, 40, 60)
    radiusBox.BorderSizePixel = 0
    radiusBox.Text = tostring(AUTO_STEAL_PROX_RADIUS)
    radiusBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    radiusBox.Font = Enum.Font.FredokaOne
    radiusBox.TextSize = isMobile and 10 or 12
    radiusBox.TextXAlignment = Enum.TextXAlignment.Center
    radiusBox.PlaceholderText = "R"
    radiusBox.ClearTextOnFocus = false
    radiusBox.Parent = topRow
    Instance.new("UICorner", radiusBox).CornerRadius = UDim.new(0, 6)

    radiusBox.FocusLost:Connect(function()
        local newRadius = tonumber(radiusBox.Text)
        if newRadius and newRadius >= 5 then
            AUTO_STEAL_PROX_RADIUS = math.floor(newRadius)
            config.autoStealRadius = AUTO_STEAL_PROX_RADIUS
            saveConfig(config)
            radiusBox.Text = tostring(AUTO_STEAL_PROX_RADIUS)
            updateRadiusCircle()
        else
            radiusBox.Text = tostring(AUTO_STEAL_PROX_RADIUS)
        end
    end)

    -- Progress bar (wider)
    autoStealProgressBar = Instance.new("Frame")
    autoStealProgressBar.Name = "ProgressBarBg"
    autoStealProgressBar.Size = UDim2.new(1, -12, 0, isMobile and 8 or 10)
    autoStealProgressBar.Position = UDim2.new(0, 6, 1, -(isMobile and 12 or 14))
    autoStealProgressBar.BackgroundColor3 = Color3.fromRGB(40, 35, 30)
    autoStealProgressBar.Parent = autoStealProgressFrame
    Instance.new("UICorner", autoStealProgressBar).CornerRadius = UDim.new(1, 0)

    autoStealProgressFill = Instance.new("Frame")
    autoStealProgressFill.Name = "ProgressFill"
    autoStealProgressFill.Size = UDim2.new(0, 0, 1, 0)
    autoStealProgressFill.BackgroundColor3 = Theme.Primary
    autoStealProgressFill.Parent = autoStealProgressBar
    Instance.new("UICorner", autoStealProgressFill).CornerRadius = UDim.new(1, 0)

    local fillGrad = Instance.new("UIGradient")
    fillGrad.Parent = autoStealProgressFill
    fillGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 220, 80)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 200, 50)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 220, 80))
    })
    registerGradient(fillGrad)

    toggleBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            autoStealEnabled = not autoStealEnabled
            updateToggleVisuals(autoStealEnabled, true)
            toggleAutoSteal(autoStealEnabled)
        end
    end)

    if config.autoStealEnabled then
        autoStealEnabled = true
        updateToggleVisuals(true, false)
        task.spawn(function()
            task.wait(1.5)
            toggleAutoSteal(true)
        end)
    end
end

-- ==========================================
-- INFO BAR (Top bar with OPEN button replacing float button)
-- ==========================================
local infoBarFrame = nil

local function createInfoBar()
    local barWidth = isMobile and 340 or 420
    local barHeight = isMobile and 50 or 60
    
    infoBarFrame = Instance.new("Frame")
    infoBarFrame.Name = "InfoBar"
    infoBarFrame.Size = UDim2.new(0, barWidth, 0, barHeight)
    infoBarFrame.Position = UDim2.new(0.5, -barWidth/2, 1, -barHeight - 10)
    infoBarFrame.BackgroundColor3 = Theme.Background
    infoBarFrame.BackgroundTransparency = 0.05
    infoBarFrame.Parent = screenGui
    
    Instance.new("UICorner", infoBarFrame).CornerRadius = UDim.new(0, 12)
    
    makeDraggable(infoBarFrame)
    
    -- Title: "Honey Duels"
    local titleText1 = Instance.new("TextLabel")
    titleText1.Size = UDim2.new(0, isMobile and 55 or 70, 0, isMobile and 22 or 26)
    titleText1.Position = UDim2.new(0, 8, 0, 4)
    titleText1.BackgroundTransparency = 1
    titleText1.Text = "HONEY"
    titleText1.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleText1.Font = Enum.Font.FredokaOne
    titleText1.TextSize = isMobile and 14 or 18
    titleText1.TextXAlignment = Enum.TextXAlignment.Left
    titleText1.Parent = infoBarFrame
    
    local titleText2 = Instance.new("TextLabel")
    titleText2.Size = UDim2.new(0, isMobile and 50 or 65, 0, isMobile and 22 or 26)
    titleText2.Position = UDim2.new(0, isMobile and 60 or 75, 0, 4)
    titleText2.BackgroundTransparency = 1
    titleText2.Text = "DUELS"
    titleText2.TextColor3 = Theme.Primary
    titleText2.Font = Enum.Font.FredokaOne
    titleText2.TextSize = isMobile and 14 or 18
    titleText2.TextXAlignment = Enum.TextXAlignment.Left
    titleText2.Parent = infoBarFrame
    createAnimatedYellowText(titleText2)
    
    -- Separator line under title
    local separator1 = Instance.new("Frame")
    separator1.Size = UDim2.new(0, isMobile and 100 or 130, 0, 2)
    separator1.Position = UDim2.new(0, 8, 0, isMobile and 26 or 30)
    separator1.BackgroundColor3 = Theme.Primary
    separator1.Parent = infoBarFrame
    Instance.new("UICorner", separator1).CornerRadius = UDim.new(0, 1)
    createAnimatedYellowText(separator1)
    
    -- "By FelipeTuffBoii"
    local byLabel = Instance.new("TextLabel")
    byLabel.Size = UDim2.new(0, isMobile and 85 or 105, 0, isMobile and 14 or 18)
    byLabel.Position = UDim2.new(0, 8, 0, isMobile and 30 or 34)
    byLabel.BackgroundTransparency = 1
    byLabel.Text = "By FelipeTuffBoii"
    byLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    byLabel.Font = Enum.Font.FredokaOne
    byLabel.TextSize = isMobile and 8 or 10
    byLabel.TextXAlignment = Enum.TextXAlignment.Left
    byLabel.Parent = infoBarFrame
    
    -- Small separator
    local separator2 = Instance.new("Frame")
    separator2.Size = UDim2.new(0, 2, 0, isMobile and 10 or 12)
    separator2.Position = UDim2.new(0, isMobile and 95 or 115, 0, isMobile and 32 or 37)
    separator2.BackgroundColor3 = Theme.Primary
    separator2.Parent = infoBarFrame
    Instance.new("UICorner", separator2).CornerRadius = UDim.new(0, 1)
    createAnimatedYellowText(separator2)
    
    -- Discord
    local discordLabel = Instance.new("TextLabel")
    discordLabel.Size = UDim2.new(0, isMobile and 90 or 110, 0, isMobile and 14 or 18)
    discordLabel.Position = UDim2.new(0, isMobile and 100 or 122, 0, isMobile and 30 or 34)
    discordLabel.BackgroundTransparency = 1
    discordLabel.Text = "discord.gg/fmq8u5ksV"
    discordLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    discordLabel.Font = Enum.Font.FredokaOne
    discordLabel.TextSize = isMobile and 7 or 9
    discordLabel.TextXAlignment = Enum.TextXAlignment.Left
    discordLabel.Parent = infoBarFrame
    
    -- Vertical separator before OPEN
    local separator3 = Instance.new("Frame")
    separator3.Size = UDim2.new(0, 2, 0, barHeight - 16)
    separator3.Position = UDim2.new(0, isMobile and 195 or 240, 0, 8)
    separator3.BackgroundColor3 = Theme.Primary
    separator3.Parent = infoBarFrame
    Instance.new("UICorner", separator3).CornerRadius = UDim.new(0, 1)
    createAnimatedYellowText(separator3)
    
    -- OPEN button
    local openBtn = Instance.new("TextButton")
    openBtn.Size = UDim2.new(0, isMobile and 55 or 70, 0, barHeight - 16)
    openBtn.Position = UDim2.new(0, isMobile and 205 or 252, 0, 8)
    openBtn.BackgroundColor3 = Theme.Background
    openBtn.Text = ""
    openBtn.Parent = infoBarFrame
    Instance.new("UICorner", openBtn).CornerRadius = UDim.new(0, 8)
    
    local openText = Instance.new("TextLabel")
    openText.Size = UDim2.new(1, 0, 1, 0)
    openText.BackgroundTransparency = 1
    openText.Text = "OPEN"
    openText.TextColor3 = Color3.fromRGB(255, 255, 255)
    openText.Font = Enum.Font.FredokaOne
    openText.TextSize = isMobile and 12 or 14
    openText.Parent = openBtn
    
    openBtn.MouseButton1Click:Connect(function()
        if mainFrame then
            mainFrame.Visible = not mainFrame.Visible
        end
    end)
    
    -- Separator after OPEN
    local separator4 = Instance.new("Frame")
    separator4.Size = UDim2.new(0, 2, 0, barHeight - 16)
    separator4.Position = UDim2.new(0, isMobile and 265 or 330, 0, 8)
    separator4.BackgroundColor3 = Theme.Primary
    separator4.Parent = infoBarFrame
    Instance.new("UICorner", separator4).CornerRadius = UDim.new(0, 1)
    createAnimatedYellowText(separator4)
    
    -- Version "V3.0"
    local versionLabel = Instance.new("TextLabel")
    versionLabel.Size = UDim2.new(0, isMobile and 50 or 65, 0, barHeight - 16)
    versionLabel.Position = UDim2.new(0, isMobile and 275 or 342, 0, 8)
    versionLabel.BackgroundTransparency = 1
    versionLabel.Text = "V3.0"
    versionLabel.TextColor3 = Theme.Primary
    versionLabel.Font = Enum.Font.FredokaOne
    versionLabel.TextSize = isMobile and 16 or 20
    versionLabel.Parent = infoBarFrame
    createAnimatedYellowText(versionLabel)
end

-- ==========================================
-- LOCK PLAYER UI (With universal drag)
-- ==========================================
local lockPlayerUITextGradient = nil

local function createLockPlayerUI()
    if lockPlayerUIFrame then
        lockPlayerUIFrame.Visible = true
        return
    end
    
    local uiWidth = isMobile and 170 or 210
    local uiHeight = isMobile and 40 or 48
    
    lockPlayerUIFrame = Instance.new("Frame")
    lockPlayerUIFrame.Name = "LockPlayerUI"
    lockPlayerUIFrame.Size = UDim2.new(0, uiWidth, 0, uiHeight)
    lockPlayerUIFrame.Position = UDim2.new(1, -uiWidth - 10, 0, 10)
    lockPlayerUIFrame.BackgroundColor3 = Theme.Background
    lockPlayerUIFrame.BackgroundTransparency = 0.1
    lockPlayerUIFrame.Active = true
    lockPlayerUIFrame.Parent = screenGui
    
    Instance.new("UICorner", lockPlayerUIFrame).CornerRadius = UDim.new(0, 10)
    
    makeDraggable(lockPlayerUIFrame)
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "ToggleButton"
    toggleButton.Size = UDim2.new(1, -12, 1, -8)
    toggleButton.Position = UDim2.new(0, 6, 0, 4)
    toggleButton.BackgroundTransparency = 1
    toggleButton.Text = "Enable Lock Player"
    toggleButton.TextColor3 = Color3.fromRGB(100, 255, 150)
    toggleButton.Font = Enum.Font.FredokaOne
    toggleButton.TextSize = isMobile and 10 or 13
    toggleButton.TextWrapped = true
    toggleButton.Parent = lockPlayerUIFrame
    
    lockPlayerUITextGradient = createAnimatedGreenText(toggleButton)
    
    local function updateLockPlayerUIState()
        if lockPlayerEnabled then
            toggleButton.Text = "Disable Lock Player"
            if lockPlayerUITextGradient then
                for i, g in ipairs(activeGradients) do
                    if g == lockPlayerUITextGradient then
                        table.remove(activeGradients, i)
                        break
                    end
                end
                lockPlayerUITextGradient:Destroy()
            end
            lockPlayerUITextGradient = createAnimatedRedText(toggleButton)
        else
            toggleButton.Text = "Enable Lock Player"
            if lockPlayerUITextGradient then
                for i, g in ipairs(activeGradients) do
                    if g == lockPlayerUITextGradient then
                        table.remove(activeGradients, i)
                        break
                    end
                end
                lockPlayerUITextGradient:Destroy()
            end
            lockPlayerUITextGradient = createAnimatedGreenText(toggleButton)
        end
    end
    
    toggleButton.MouseButton1Click:Connect(function()
        lockPlayerEnabled = not lockPlayerEnabled
        toggleLockPlayer(lockPlayerEnabled)
        updateLockPlayerUIState()
        
        if toggles["Lock Player"] then
            toggles["Lock Player"].SetState(lockPlayerEnabled)
        end
    end)
    
    updateLockPlayerUIState()
end

local function toggleLockPlayerUI(state)
    lockPlayerUIEnabled = state
    config.lockPlayerUIEnabled = state
    saveConfig(config)
    
    if state then
        createLockPlayerUI()
    else
        if lockPlayerUIFrame then
            lockPlayerUIFrame.Visible = false
        end
    end
end

-- ==========================================
-- AUTO LEFT UI (With universal drag)
-- ==========================================
local autoLeftUITextGradient = nil

local function createAutoLeftUI()
    if autoLeftUIFrame then
        autoLeftUIFrame.Visible = true
        return
    end
    
    local uiWidth = isMobile and 170 or 210
    local uiHeight = isMobile and 40 or 48
    
    autoLeftUIFrame = Instance.new("Frame")
    autoLeftUIFrame.Name = "AutoLeftUI"
    autoLeftUIFrame.Size = UDim2.new(0, uiWidth, 0, uiHeight)
    autoLeftUIFrame.Position = UDim2.new(0, 10, 0, 70)
    autoLeftUIFrame.BackgroundColor3 = Theme.Background
    autoLeftUIFrame.BackgroundTransparency = 0.1
    autoLeftUIFrame.Active = true
    autoLeftUIFrame.Parent = screenGui
    
    Instance.new("UICorner", autoLeftUIFrame).CornerRadius = UDim.new(0, 10)
    
    makeDraggable(autoLeftUIFrame)
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "ToggleButton"
    toggleButton.Size = UDim2.new(1, -12, 1, -8)
    toggleButton.Position = UDim2.new(0, 6, 0, 4)
    toggleButton.BackgroundTransparency = 1
    toggleButton.Text = "Enable Auto Left"
    toggleButton.TextColor3 = Color3.fromRGB(100, 255, 150)
    toggleButton.Font = Enum.Font.FredokaOne
    toggleButton.TextSize = isMobile and 10 or 13
    toggleButton.TextWrapped = true
    toggleButton.Parent = autoLeftUIFrame
    
    autoLeftUITextGradient = createAnimatedGreenText(toggleButton)
    
    local function updateAutoLeftUIState()
        if autoLeftActive then
            toggleButton.Text = "Disable Auto Left"
            if autoLeftUITextGradient then
                for i, g in ipairs(activeGradients) do
                    if g == autoLeftUITextGradient then
                        table.remove(activeGradients, i)
                        break
                    end
                end
                autoLeftUITextGradient:Destroy()
            end
            autoLeftUITextGradient = createAnimatedRedText(toggleButton)
        else
            toggleButton.Text = "Enable Auto Left"
            if autoLeftUITextGradient then
                for i, g in ipairs(activeGradients) do
                    if g == autoLeftUITextGradient then
                        table.remove(activeGradients, i)
                        break
                    end
                end
                autoLeftUITextGradient:Destroy()
            end
            autoLeftUITextGradient = createAnimatedGreenText(toggleButton)
        end
    end
    
    toggleButton.MouseButton1Click:Connect(function()
        if autoLeftActive then
            autoLeftActive = false
            updateAutoLeftUIState()
        else
            runAutoLeft()
            updateAutoLeftUIState()
            
            -- Monitor for completion
            task.spawn(function()
                while autoLeftActive do
                    task.wait(0.1)
                end
                updateAutoLeftUIState()
            end)
        end
    end)
    
    updateAutoLeftUIState()
end

local function toggleAutoLeftUI(state)
    autoLeftUIEnabled = state
    config.autoLeftUIEnabled = state
    saveConfig(config)
    
    if state then
        createAutoLeftUI()
    else
        if autoLeftUIFrame then
            autoLeftUIFrame.Visible = false
        end
        autoLeftActive = false
    end
end

-- ==========================================
-- AUTO RIGHT UI (With universal drag)
-- ==========================================
local autoRightUITextGradient = nil

local function createAutoRightUI()
    if autoRightUIFrame then
        autoRightUIFrame.Visible = true
        return
    end
    
    local uiWidth = isMobile and 170 or 210
    local uiHeight = isMobile and 40 or 48
    
    autoRightUIFrame = Instance.new("Frame")
    autoRightUIFrame.Name = "AutoRightUI"
    autoRightUIFrame.Size = UDim2.new(0, uiWidth, 0, uiHeight)
    autoRightUIFrame.Position = UDim2.new(0, 10, 0, 130)
    autoRightUIFrame.BackgroundColor3 = Theme.Background
    autoRightUIFrame.BackgroundTransparency = 0.1
    autoRightUIFrame.Active = true
    autoRightUIFrame.Parent = screenGui
    
    Instance.new("UICorner", autoRightUIFrame).CornerRadius = UDim.new(0, 10)
    
    makeDraggable(autoRightUIFrame)
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "ToggleButton"
    toggleButton.Size = UDim2.new(1, -12, 1, -8)
    toggleButton.Position = UDim2.new(0, 6, 0, 4)
    toggleButton.BackgroundTransparency = 1
    toggleButton.Text = "Enable Auto Right"
    toggleButton.TextColor3 = Color3.fromRGB(100, 255, 150)
    toggleButton.Font = Enum.Font.FredokaOne
    toggleButton.TextSize = isMobile and 10 or 13
    toggleButton.TextWrapped = true
    toggleButton.Parent = autoRightUIFrame
    
    autoRightUITextGradient = createAnimatedGreenText(toggleButton)
    
    local function updateAutoRightUIState()
        if autoRightActive then
            toggleButton.Text = "Disable Auto Right"
            if autoRightUITextGradient then
                for i, g in ipairs(activeGradients) do
                    if g == autoRightUITextGradient then
                        table.remove(activeGradients, i)
                        break
                    end
                end
                autoRightUITextGradient:Destroy()
            end
            autoRightUITextGradient = createAnimatedRedText(toggleButton)
        else
            toggleButton.Text = "Enable Auto Right"
            if autoRightUITextGradient then
                for i, g in ipairs(activeGradients) do
                    if g == autoRightUITextGradient then
                        table.remove(activeGradients, i)
                        break
                    end
                end
                autoRightUITextGradient:Destroy()
            end
            autoRightUITextGradient = createAnimatedGreenText(toggleButton)
        end
    end
    
    toggleButton.MouseButton1Click:Connect(function()
        if autoRightActive then
            autoRightActive = false
            updateAutoRightUIState()
        else
            runAutoRight()
            updateAutoRightUIState()
            
            -- Monitor for completion
            task.spawn(function()
                while autoRightActive do
                    task.wait(0.1)
                end
                updateAutoRightUIState()
            end)
        end
    end)
    
    updateAutoRightUIState()
end

local function toggleAutoRightUI(state)
    autoRightUIEnabled = state
    config.autoRightUIEnabled = state
    saveConfig(config)
    
    if state then
        createAutoRightUI()
    else
        if autoRightUIFrame then
            autoRightUIFrame.Visible = false
        end
        autoRightActive = false
    end
end

-- ==========================================
-- FLOATING DOTS DECORATION
-- ==========================================
local function createFloatingDots(parent, count)
    for i = 1, count do
        local dot = Instance.new("Frame")
        dot.Name = "FloatingDot_" .. i
        dot.Size = UDim2.new(0, math.random(3, 6), 0, math.random(3, 6))
        local xPos = math.random(10, 90) / 100
        local yPos = math.random(10, 90)
        dot.Position = UDim2.new(xPos, 0, 0, yPos)
        dot.BackgroundColor3 = Theme.DotColor
        dot.BackgroundTransparency = math.random(30, 70) / 100
        dot.Parent = parent
        dot:SetAttribute("BaseY", yPos)
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = dot
        
        table.insert(floatingDots, dot)
    end
end

-- ==========================================
-- BEAUTIFUL TOGGLE CREATION
-- ==========================================
local function createBeautifulToggle(name, defaultState, callback, parent, hasSlider, sliderMin, sliderMax, sliderDefault, sliderCallback, sliderStep)
    local frameHeight = hasSlider and (isMobile and 65 or 75) or (isMobile and 44 or 52)
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -8, 0, frameHeight)
    frame.BackgroundColor3 = Theme.Background2
    frame.BackgroundTransparency = 0.2
    frame.Parent = parent
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 10)
    frameCorner.Parent = frame
    
    local innerGlow = Instance.new("Frame")
    innerGlow.Size = UDim2.new(1, -4, 1, -4)
    innerGlow.Position = UDim2.new(0, 2, 0, 2)
    innerGlow.BackgroundColor3 = Theme.Background3
    innerGlow.BackgroundTransparency = 0.5
    innerGlow.ZIndex = 0
    innerGlow.Parent = frame
    Instance.new("UICorner", innerGlow).CornerRadius = UDim.new(0, 8)
    
    local toggleRow = Instance.new("Frame")
    toggleRow.Size = UDim2.new(1, 0, 0, isMobile and 32 or 38)
    toggleRow.BackgroundTransparency = 1
    toggleRow.Parent = frame
    
    local kbSize = isMobile and 20 or 24
    local kbFrame = Instance.new("Frame")
    kbFrame.Name = "KeybindBox"
    kbFrame.Size = UDim2.new(0, kbSize, 0, kbSize)
    kbFrame.Position = UDim2.new(0, 6, 0.5, -kbSize/2)
    kbFrame.BackgroundColor3 = Color3.fromRGB(50, 45, 35)
    kbFrame.BorderSizePixel = 0
    kbFrame.Parent = toggleRow
    Instance.new("UICorner", kbFrame).CornerRadius = UDim.new(0, 6)
    
    local kbStroke = Instance.new("UIStroke")
        kbStroke.Color = Color3.fromRGB(80, 70, 50)
    kbStroke.Thickness = 1
    kbStroke.Parent = kbFrame
    
    local kbLabel = Instance.new("TextLabel")
    kbLabel.Size = UDim2.new(1, 0, 1, 0)
    kbLabel.BackgroundTransparency = 1
    kbLabel.Text = keybinds[name] and keybinds[name].Name or "-"
    kbLabel.TextColor3 = keybinds[name] and Theme.Keybind or Color3.fromRGB(100, 100, 100)
    kbLabel.Font = Enum.Font.FredokaOne
    kbLabel.TextSize = isMobile and 8 or 10
    kbLabel.Parent = kbFrame
    
    local isBinding = false
    
    kbFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isBinding = true
            kbLabel.Text = "..."
            kbLabel.TextColor3 = Theme.Accent
            kbStroke.Color = Theme.Primary
        end
    end)
    
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not isBinding then return end
        if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
        if input.KeyCode == Enum.KeyCode.Escape then
            keybinds[name] = nil
        elseif input.KeyCode ~= Enum.KeyCode.Unknown then
            keybinds[name] = input.KeyCode
        end
        kbLabel.Text = keybinds[name] and keybinds[name].Name or "-"
        kbLabel.TextColor3 = keybinds[name] and Theme.Keybind or Color3.fromRGB(100, 100, 100)
        kbStroke.Color = keybinds[name] and Color3.fromRGB(100, 90, 60) or Color3.fromRGB(80, 70, 50)
        config.keybinds = {}
        for k, v in pairs(keybinds) do
            config.keybinds[k] = v.Name
        end
        saveConfig(config)
        isBinding = false
    end)
    
    local labelOffset = isMobile and 30 or 36
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60 - labelOffset, 1, 0)
    label.Position = UDim2.new(0, labelOffset, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Theme.Text
    label.Font = Enum.Font.FredokaOne
    label.TextSize = isMobile and 9 or 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextScaled = false
    label.Parent = toggleRow
    
    -- BEAUTIFUL TOGGLE DESIGN
    local toggleWidth = isMobile and 44 or 52
    local toggleHeight = isMobile and 22 or 26
    
    local toggleContainer = Instance.new("Frame")
    toggleContainer.Size = UDim2.new(0, toggleWidth, 0, toggleHeight)
    toggleContainer.Position = UDim2.new(1, -toggleWidth - 6, 0.5, -toggleHeight/2)
    toggleContainer.BackgroundTransparency = 1
    toggleContainer.Parent = toggleRow
    
    local toggleBg = Instance.new("Frame")
    toggleBg.Size = UDim2.new(1, 0, 1, 0)
    toggleBg.BackgroundColor3 = Theme.ToggleOffBg
    toggleBg.Parent = toggleContainer
    Instance.new("UICorner", toggleBg).CornerRadius = UDim.new(1, 0)
    
    local toggleTrack = Instance.new("Frame")
    toggleTrack.Size = UDim2.new(1, -4, 1, -4)
    toggleTrack.Position = UDim2.new(0, 2, 0, 2)
    toggleTrack.BackgroundColor3 = Theme.ToggleOff
    toggleTrack.Parent = toggleBg
    Instance.new("UICorner", toggleTrack).CornerRadius = UDim.new(1, 0)
    
    local circleSize = toggleHeight - 8
    local toggleCircle = Instance.new("Frame")
    toggleCircle.Size = UDim2.new(0, circleSize, 0, circleSize)
    toggleCircle.Position = UDim2.new(0, 4, 0.5, -circleSize/2)
    toggleCircle.BackgroundColor3 = Color3.fromRGB(150, 145, 140)
    toggleCircle.Parent = toggleBg
    Instance.new("UICorner", toggleCircle).CornerRadius = UDim.new(1, 0)
    
    local circleHighlight = Instance.new("Frame")
    circleHighlight.Size = UDim2.new(0.6, 0, 0.6, 0)
    circleHighlight.Position = UDim2.new(0.2, 0, 0.1, 0)
    circleHighlight.BackgroundColor3 = Color3.fromRGB(200, 195, 190)
    circleHighlight.BackgroundTransparency = 0.5
    circleHighlight.Parent = toggleCircle
    Instance.new("UICorner", circleHighlight).CornerRadius = UDim.new(1, 0)
    
    local statusDot = Instance.new("Frame")
    statusDot.Size = UDim2.new(0, 6, 0, 6)
    statusDot.Position = UDim2.new(0.5, -3, 0.5, -3)
    statusDot.BackgroundColor3 = Color3.fromRGB(100, 95, 90)
    statusDot.Parent = toggleCircle
    Instance.new("UICorner", statusDot).CornerRadius = UDim.new(1, 0)
    
    local glowEffect = Instance.new("ImageLabel")
    glowEffect.Size = UDim2.new(1.5, 0, 1.5, 0)
    glowEffect.Position = UDim2.new(-0.25, 0, -0.25, 0)
    glowEffect.BackgroundTransparency = 1
    glowEffect.Image = "rbxassetid://5028857084"
    glowEffect.ImageColor3 = Theme.Glow
    glowEffect.ImageTransparency = 1
    glowEffect.Parent = toggleCircle
    
    local isEnabled = false
    local toggleGradient = nil
    
    local function updateVisuals(animate)
        local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        
        if isEnabled then
            local circlePos = UDim2.new(1, -circleSize - 4, 0.5, -circleSize/2)
            
            if animate then
                TweenService:Create(toggleCircle, tweenInfo, {Position = circlePos}):Play()
                TweenService:Create(toggleTrack, tweenInfo, {BackgroundColor3 = Theme.ToggleOn}):Play()
                TweenService:Create(toggleCircle, tweenInfo, {BackgroundColor3 = Color3.fromRGB(255, 250, 240)}):Play()
                TweenService:Create(circleHighlight, tweenInfo, {BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
                TweenService:Create(statusDot, tweenInfo, {BackgroundColor3 = Theme.Primary}):Play()
                TweenService:Create(glowEffect, tweenInfo, {ImageTransparency = 0.7}):Play()
            else
                toggleCircle.Position = circlePos
                toggleTrack.BackgroundColor3 = Theme.ToggleOn
                toggleCircle.BackgroundColor3 = Color3.fromRGB(255, 250, 240)
                circleHighlight.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                statusDot.BackgroundColor3 = Theme.Primary
                glowEffect.ImageTransparency = 0.7
            end
            
            if not toggleGradient then
                toggleGradient = Instance.new("UIGradient")
                toggleGradient.Parent = toggleTrack
                toggleGradient.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 220, 80)),
                    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 200, 50)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 180, 30))
                })
                toggleGradient.Rotation = 45
                registerGradient(toggleGradient)
            end
        else
            local circlePos = UDim2.new(0, 4, 0.5, -circleSize/2)
            
            if animate then
                TweenService:Create(toggleCircle, tweenInfo, {Position = circlePos}):Play()
                TweenService:Create(toggleTrack, tweenInfo, {BackgroundColor3 = Theme.ToggleOff}):Play()
                TweenService:Create(toggleCircle, tweenInfo, {BackgroundColor3 = Color3.fromRGB(150, 145, 140)}):Play()
                TweenService:Create(circleHighlight, tweenInfo, {BackgroundColor3 = Color3.fromRGB(200, 195, 190)}):Play()
                TweenService:Create(statusDot, tweenInfo, {BackgroundColor3 = Color3.fromRGB(100, 95, 90)}):Play()
                TweenService:Create(glowEffect, tweenInfo, {ImageTransparency = 1}):Play()
            else
                toggleCircle.Position = circlePos
                toggleTrack.BackgroundColor3 = Theme.ToggleOff
                toggleCircle.BackgroundColor3 = Color3.fromRGB(150, 145, 140)
                circleHighlight.BackgroundColor3 = Color3.fromRGB(200, 195, 190)
                statusDot.BackgroundColor3 = Color3.fromRGB(100, 95, 90)
                glowEffect.ImageTransparency = 1
            end
            
            if toggleGradient then
                for i, g in ipairs(activeGradients) do
                    if g == toggleGradient then
                        table.remove(activeGradients, i)
                        break
                    end
                end
                toggleGradient:Destroy()
                toggleGradient = nil
            end
        end
    end
    
    toggleBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isEnabled = not isEnabled
            updateVisuals(true)
            callback(isEnabled)
        end
    end)
    
    toggles[name] = {
        GetState = function() return isEnabled end,
        SetState = function(state)
            isEnabled = state
            updateVisuals(true)
            callback(isEnabled)
        end
    }
    
    if hasSlider then
        local sliderRow = Instance.new("Frame")
        sliderRow.Size = UDim2.new(1, -14, 0, isMobile and 20 or 24)
        sliderRow.Position = UDim2.new(0, 7, 0, isMobile and 36 or 42)
        sliderRow.BackgroundTransparency = 1
        sliderRow.Parent = frame
        
        local sliderBg = Instance.new("Frame")
        sliderBg.Size = UDim2.new(1, -50, 0, 6)
        sliderBg.Position = UDim2.new(0, 0, 0.5, -3)
        sliderBg.BackgroundColor3 = Color3.fromRGB(50, 45, 35)
        sliderBg.Parent = sliderRow
        Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(1, 0)
        
        local sliderFill = Instance.new("Frame")
        sliderFill.Size = UDim2.new((sliderDefault - sliderMin) / (sliderMax - sliderMin), 0, 1, 0)
        sliderFill.BackgroundColor3 = Theme.SliderFill
        sliderFill.Parent = sliderBg
        Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(1, 0)
        
        local fillGradient = Instance.new("UIGradient")
        fillGradient.Parent = sliderFill
        fillGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 220, 80)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 180, 30))
        })
        
        local sliderKnob = Instance.new("Frame")
        sliderKnob.Size = UDim2.new(0, 12, 0, 12)
        sliderKnob.Position = UDim2.new((sliderDefault - sliderMin) / (sliderMax - sliderMin), -6, 0.5, -6)
        sliderKnob.BackgroundColor3 = Color3.fromRGB(255, 245, 220)
        sliderKnob.Parent = sliderBg
        Instance.new("UICorner", sliderKnob).CornerRadius = UDim.new(1, 0)
        
        local knobStroke = Instance.new("UIStroke")
        knobStroke.Color = Theme.Primary
        knobStroke.Thickness = 2
        knobStroke.Parent = sliderKnob
        
        local inputBox = Instance.new("TextBox")
        inputBox.Size = UDim2.new(0, isMobile and 38 or 45, 0, isMobile and 18 or 22)
        inputBox.Position = UDim2.new(1, isMobile and -40 or -47, 0.5, isMobile and -9 or -11)
        inputBox.BackgroundColor3 = Color3.fromRGB(50, 45, 35)
        inputBox.Text = tostring(sliderDefault)
        inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        inputBox.Font = Enum.Font.FredokaOne
        inputBox.TextSize = isMobile and 9 or 11
        inputBox.ClearTextOnFocus = false
        inputBox.Parent = sliderRow
        Instance.new("UICorner", inputBox).CornerRadius = UDim.new(0, 6)
        
        local inputStroke = Instance.new("UIStroke")
        inputStroke.Color = Color3.fromRGB(80, 70, 50)
        inputStroke.Thickness = 1
        inputStroke.Parent = inputBox
        
        local currentValue = sliderDefault
        local dragging = false
        local stepSize = sliderStep or 1
        
        local function updateSlider(percent, updateInput)
            percent = math.clamp(percent, 0, 1)
            local rawValue = sliderMin + (sliderMax - sliderMin) * percent
            currentValue = math.floor(rawValue / stepSize + 0.5) * stepSize
            currentValue = math.clamp(currentValue, sliderMin, sliderMax)
            local actualPercent = (currentValue - sliderMin) / (sliderMax - sliderMin)
            sliderFill.Size = UDim2.new(actualPercent, 0, 1, 0)
            sliderKnob.Position = UDim2.new(actualPercent, -6, 0.5, -6)
            if updateInput ~= false then
                inputBox.Text = tostring(currentValue)
            end
            if sliderCallback then sliderCallback(currentValue) end
        end
        
        sliderBg.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                local pos = input.Position.X - sliderBg.AbsolutePosition.X
                local percent = math.clamp(pos / sliderBg.AbsoluteSize.X, 0, 1)
                updateSlider(percent)
            end
        end)
        
        sliderBg.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local pos = input.Position.X - sliderBg.AbsolutePosition.X
                local percent = math.clamp(pos / sliderBg.AbsoluteSize.X, 0, 1)
                updateSlider(percent)
            end
        end)
        
        inputBox.FocusLost:Connect(function()
            local num = tonumber(inputBox.Text)
            if num then
                num = math.clamp(num, sliderMin, sliderMax)
                local percent = (num - sliderMin) / (sliderMax - sliderMin)
                updateSlider(percent, false)
                inputBox.Text = tostring(currentValue)
            else
                inputBox.Text = tostring(currentValue)
            end
        end)
        
        sliders[name] = {
            GetValue = function() return currentValue end,
            SetValue = function(val)
                local p = (val - sliderMin) / (sliderMax - sliderMin)
                updateSlider(p)
            end
        }
    end
    
    return frame
end

-- ==========================================
-- BOOSTER UI (With 0.1 step for input box, 0.5 for slider)
-- ==========================================
local boosterSectionsContainer = nil
local boosterMinimizeBtn = nil
local boosterMinimizeText = nil

local function createBoosterSliderWithInput(name, min, max, defaultValue, callback, parent, step)
    local frameHeight = isMobile and 62 or 74
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, frameHeight)
    frame.BackgroundColor3 = Theme.Background2
    frame.BackgroundTransparency = 0.3
    frame.Parent = parent
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
    
    local topRow = Instance.new("Frame")
    topRow.Size = UDim2.new(1, 0, 0, isMobile and 28 or 34)
    topRow.BackgroundTransparency = 1
    topRow.Parent = frame
    
    local kbSize = isMobile and 18 or 22
    local kbFrame = Instance.new("Frame")
    kbFrame.Name = "KeybindBox"
    kbFrame.Size = UDim2.new(0, kbSize, 0, kbSize)
    kbFrame.Position = UDim2.new(0, 5, 0.5, -kbSize/2)
    kbFrame.BackgroundColor3 = Color3.fromRGB(55, 48, 30)
    kbFrame.BorderSizePixel = 0
    kbFrame.Parent = topRow
    Instance.new("UICorner", kbFrame).CornerRadius = UDim.new(0, 4)
    
    local kbLabel = Instance.new("TextLabel")
    kbLabel.Size = UDim2.new(1, 0, 1, 0)
    kbLabel.BackgroundTransparency = 1
    kbLabel.Text = boosterKeybinds[name] and boosterKeybinds[name].Name or "-"
    kbLabel.TextColor3 = boosterKeybinds[name] and Theme.Keybind or Color3.fromRGB(100, 100, 100)
    kbLabel.Font = Enum.Font.FredokaOne
    kbLabel.TextSize = isMobile and 7 or 9
    kbLabel.Parent = kbFrame
    
    local isBinding = false
    
    kbFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isBinding = true
            kbLabel.Text = "..."
            kbLabel.TextColor3 = Theme.Accent
        end
    end)
    
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not isBinding then return end
        if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
        if input.KeyCode == Enum.KeyCode.Escape then
            boosterKeybinds[name] = nil
        elseif input.KeyCode ~= Enum.KeyCode.Unknown then
            boosterKeybinds[name] = input.KeyCode
        end
        kbLabel.Text = boosterKeybinds[name] and boosterKeybinds[name].Name or "-"
        kbLabel.TextColor3 = boosterKeybinds[name] and Theme.Keybind or Color3.fromRGB(100, 100, 100)
        config.boosterKeybinds = {}
        for k, v in pairs(boosterKeybinds) do
            config.boosterKeybinds[k] = v.Name
        end
        saveConfig(config)
        isBinding = false
    end)
    
    local labelOffset = isMobile and 26 or 30
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.55, -labelOffset, 1, 0)
    label.Position = UDim2.new(0, labelOffset, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Theme.TextSecondary
    label.Font = Enum.Font.FredokaOne
    label.TextSize = isMobile and 8 or 10
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = topRow
    
    -- Beautiful toggle
    local toggleWidth = isMobile and 40 or 48
    local toggleHeight = isMobile and 20 or 24
    
    local toggleContainer = Instance.new("Frame")
    toggleContainer.Size = UDim2.new(0, toggleWidth, 0, toggleHeight)
    toggleContainer.Position = UDim2.new(1, -toggleWidth - 5, 0.5, -toggleHeight/2)
    toggleContainer.BackgroundTransparency = 1
    toggleContainer.Parent = topRow
    
    local toggleBg = Instance.new("Frame")
    toggleBg.Size = UDim2.new(1, 0, 1, 0)
    toggleBg.BackgroundColor3 = Theme.ToggleOffBg
    toggleBg.Parent = toggleContainer
    Instance.new("UICorner", toggleBg).CornerRadius = UDim.new(1, 0)
    
    local toggleTrack = Instance.new("Frame")
    toggleTrack.Size = UDim2.new(1, -4, 1, -4)
    toggleTrack.Position = UDim2.new(0, 2, 0, 2)
    toggleTrack.BackgroundColor3 = Theme.ToggleOff
    toggleTrack.Parent = toggleBg
    Instance.new("UICorner", toggleTrack).CornerRadius = UDim.new(1, 0)
    
    local circleSize = toggleHeight - 8
    local toggleCircle = Instance.new("Frame")
    toggleCircle.Size = UDim2.new(0, circleSize, 0, circleSize)
    toggleCircle.Position = UDim2.new(0, 4, 0.5, -circleSize/2)
    toggleCircle.BackgroundColor3 = Color3.fromRGB(150, 145, 140)
    toggleCircle.Parent = toggleBg
    Instance.new("UICorner", toggleCircle).CornerRadius = UDim.new(1, 0)
    
    local circleHighlight = Instance.new("Frame")
    circleHighlight.Size = UDim2.new(0.6, 0, 0.6, 0)
    circleHighlight.Position = UDim2.new(0.2, 0, 0.1, 0)
    circleHighlight.BackgroundColor3 = Color3.fromRGB(200, 195, 190)
    circleHighlight.BackgroundTransparency = 0.5
    circleHighlight.Parent = toggleCircle
    Instance.new("UICorner", circleHighlight).CornerRadius = UDim.new(1, 0)
    
    local statusDot = Instance.new("Frame")
    statusDot.Size = UDim2.new(0, 5, 0, 5)
    statusDot.Position = UDim2.new(0.5, -2.5, 0.5, -2.5)
    statusDot.BackgroundColor3 = Color3.fromRGB(100, 95, 90)
    statusDot.Parent = toggleCircle
    Instance.new("UICorner", statusDot).CornerRadius = UDim.new(1, 0)
    
    local glowEffect = Instance.new("ImageLabel")
    glowEffect.Size = UDim2.new(1.5, 0, 1.5, 0)
    glowEffect.Position = UDim2.new(-0.25, 0, -0.25, 0)
    glowEffect.BackgroundTransparency = 1
    glowEffect.Image = "rbxassetid://5028857084"
    glowEffect.ImageColor3 = Theme.Glow
    glowEffect.ImageTransparency = 1
    glowEffect.Parent = toggleCircle
    
    local isEnabled = false
    local toggleGradient = nil
    
    local sliderRow = Instance.new("Frame")
    sliderRow.Size = UDim2.new(1, -14, 0, isMobile and 22 or 28)
    sliderRow.Position = UDim2.new(0, 7, 0, isMobile and 32 or 38)
    sliderRow.BackgroundTransparency = 1
    sliderRow.Parent = frame
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -50, 0, 6)
    sliderBg.Position = UDim2.new(0, 0, 0.5, -3)
    sliderBg.BackgroundColor3 = Color3.fromRGB(70, 60, 40)
    sliderBg.Parent = sliderRow
    Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(1, 0)
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((defaultValue - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Theme.SliderFill
    sliderFill.Parent = sliderBg
    Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(1, 0)
    
    local fillGradient = Instance.new("UIGradient")
    fillGradient.Parent = sliderFill
    fillGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 220, 80)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 180, 30))
    })
    
    local sliderKnob = Instance.new("Frame")
    sliderKnob.Size = UDim2.new(0, 12, 0, 12)
    sliderKnob.Position = UDim2.new((defaultValue - min) / (max - min), -6, 0.5, -6)
    sliderKnob.BackgroundColor3 = Color3.fromRGB(255, 245, 220)
    sliderKnob.Parent = sliderBg
    Instance.new("UICorner", sliderKnob).CornerRadius = UDim.new(1, 0)
    
    local knobStroke = Instance.new("UIStroke")
    knobStroke.Color = Theme.Primary
    knobStroke.Thickness = 2
    knobStroke.Parent = sliderKnob
    
    local inputBox = Instance.new("TextBox")
    inputBox.Size = UDim2.new(0, isMobile and 38 or 45, 0, isMobile and 18 or 22)
    inputBox.Position = UDim2.new(1, isMobile and -40 or -47, 0.5, isMobile and -9 or -11)
    inputBox.BackgroundColor3 = Color3.fromRGB(70, 60, 40)
    inputBox.Text = tostring(defaultValue)
    inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    inputBox.Font = Enum.Font.FredokaOne
    inputBox.TextSize = isMobile and 8 or 10
    inputBox.ClearTextOnFocus = false
    inputBox.Parent = sliderRow
    Instance.new("UICorner", inputBox).CornerRadius = UDim.new(0, 4)
    
    local currentValue = defaultValue
    local dragging = false
    local sliderStepSize = 0.5  -- Slider uses 0.5 step
    local inputStepSize = 0.1   -- Input box uses 0.1 step
    
    local function updateSlider(percent, updateInput, useInputStep)
        percent = math.clamp(percent, 0, 1)
        local rawValue = min + (max - min) * percent
        local stepToUse = useInputStep and inputStepSize or sliderStepSize
        currentValue = math.floor(rawValue / stepToUse + 0.5) * stepToUse
        currentValue = math.clamp(currentValue, min, max)
        local actualPercent = (currentValue - min) / (max - min)
        sliderFill.Size = UDim2.new(actualPercent, 0, 1, 0)
        sliderKnob.Position = UDim2.new(actualPercent, -6, 0.5, -6)
        if updateInput ~= false then
            inputBox.Text = tostring(currentValue)
        end
        if isEnabled then
            callback(currentValue, true)
        end
    end
    
    local function updateToggle()
        local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quint)
        if isEnabled then
            TweenService:Create(toggleCircle, tweenInfo, {Position = UDim2.new(1, -circleSize - 4, 0.5, -circleSize/2)}):Play()
            TweenService:Create(toggleTrack, tweenInfo, {BackgroundColor3 = Theme.ToggleOn}):Play()
            TweenService:Create(toggleCircle, tweenInfo, {BackgroundColor3 = Color3.fromRGB(255, 250, 240)}):Play()
            TweenService:Create(circleHighlight, tweenInfo, {BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            TweenService:Create(statusDot, tweenInfo, {BackgroundColor3 = Theme.Primary}):Play()
            TweenService:Create(glowEffect, tweenInfo, {ImageTransparency = 0.7}):Play()
            if not toggleGradient then
                toggleGradient = Instance.new("UIGradient")
                toggleGradient.Parent = toggleTrack
                toggleGradient.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 220, 80)),
                    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 200, 50)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 180, 30))
                })
                toggleGradient.Rotation = 45
                registerGradient(toggleGradient)
            end
            callback(currentValue, true)
        else
            TweenService:Create(toggleCircle, tweenInfo, {Position = UDim2.new(0, 4, 0.5, -circleSize/2)}):Play()
            TweenService:Create(toggleTrack, tweenInfo, {BackgroundColor3 = Theme.ToggleOff}):Play()
            TweenService:Create(toggleCircle, tweenInfo, {BackgroundColor3 = Color3.fromRGB(150, 145, 140)}):Play()
            TweenService:Create(circleHighlight, tweenInfo, {BackgroundColor3 = Color3.fromRGB(200, 195, 190)}):Play()
            TweenService:Create(statusDot, tweenInfo, {BackgroundColor3 = Color3.fromRGB(100, 95, 90)}):Play()
            TweenService:Create(glowEffect, tweenInfo, {ImageTransparency = 1}):Play()
            if toggleGradient then
                for i, g in ipairs(activeGradients) do
                    if g == toggleGradient then
                        table.remove(activeGradients, i)
                        break
                    end
                end
                toggleGradient:Destroy()
                toggleGradient = nil
            end
            callback(currentValue, false)
        end
    end
    
    toggleBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isEnabled = not isEnabled
            updateToggle()
        end
    end)
    
    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            local pos = input.Position.X - sliderBg.AbsolutePosition.X
            local percent = math.clamp(pos / sliderBg.AbsoluteSize.X, 0, 1)
            updateSlider(percent, true, false)  -- Use slider step (0.5)
        end
    end)
    
    sliderBg.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local pos = input.Position.X - sliderBg.AbsolutePosition.X
            local percent = math.clamp(pos / sliderBg.AbsoluteSize.X, 0, 1)
            updateSlider(percent, true, false)  -- Use slider step (0.5)
        end
    end)
    
    inputBox.FocusLost:Connect(function()
        local num = tonumber(inputBox.Text)
        if num then
            num = math.clamp(num, min, max)
            -- Round to 0.1 for input box
            num = math.floor(num / inputStepSize + 0.5) * inputStepSize
            currentValue = num
            local percent = (currentValue - min) / (max - min)
            sliderFill.Size = UDim2.new(percent, 0, 1, 0)
            sliderKnob.Position = UDim2.new(percent, -6, 0.5, -6)
            inputBox.Text = tostring(currentValue)
            if isEnabled then
                callback(currentValue, true)
            end
        else
            inputBox.Text = tostring(currentValue)
        end
    end)
    
    local obj = {
        GetValue = function() return currentValue end,
        SetValue = function(v)
            currentValue = math.clamp(v, min, max)
            local p = (currentValue - min) / (max - min)
            updateSlider(p, true, true)
        end,
        SetEnabled = function(e)
            if isEnabled ~= e then
                isEnabled = e
                updateToggle()
            end
        end,
        IsEnabled = function() return isEnabled end
    }
    
    boosterToggles[name] = obj
    return obj
end

local function updateBoosterMinimizeState()
    if not boosterUIFrame or not boosterSectionsContainer or not boosterMinimizeText then return end
    
    if boosterUIMinimized then
        boosterSectionsContainer.Visible = false
        boosterMinimizeText.Text = "+"
        local boosterWidth = isMobile and 180 or 220
        boosterUIFrame.Size = UDim2.new(0, boosterWidth, 0, 40)
    else
        boosterSectionsContainer.Visible = true
        boosterMinimizeText.Text = "-"
        local boosterWidth = isMobile and 180 or 220
        local boosterHeight = isMobile and 300 or 360
        boosterUIFrame.Size = UDim2.new(0, boosterWidth, 0, boosterHeight)
    end
    
    config.boosterUIMinimized = boosterUIMinimized
    saveConfig(config)
end

local function createBoosterUI()
    if boosterUIFrame then
        boosterUIFrame.Visible = true
        return
    end
    
    local boosterWidth = isMobile and 180 or 220
    local boosterHeight = isMobile and 300 or 360
    
    boosterUIFrame = Instance.new("Frame")
    boosterUIFrame.Name = "BoosterUI"
    boosterUIFrame.Size = UDim2.new(0, boosterWidth, 0, boosterHeight)
    boosterUIFrame.Position = UDim2.new(0, 10, 0, 200)
    boosterUIFrame.BackgroundColor3 = Theme.Background
    boosterUIFrame.BackgroundTransparency = 0.05
    boosterUIFrame.Active = true
    boosterUIFrame.Parent = screenGui
    
    Instance.new("UICorner", boosterUIFrame).CornerRadius = UDim.new(0, 12)
    
    makeDraggable(boosterUIFrame)
    
    createFloatingDots(boosterUIFrame, 8)
    
    -- Title: "Honey Booster" with normal spacing
    local boosterTitleContainer = Instance.new("Frame")
    boosterTitleContainer.Size = UDim2.new(1, -60, 0, 26)
    boosterTitleContainer.Position = UDim2.new(0, 8, 0, 6)
    boosterTitleContainer.BackgroundTransparency = 1
    boosterTitleContainer.Parent = boosterUIFrame
    
    local honeyBoosterText1 = Instance.new("TextLabel")
    honeyBoosterText1.Size = UDim2.new(0, isMobile and 48 or 58, 0, 26)
    honeyBoosterText1.Position = UDim2.new(0, 0, 0, 0)
    honeyBoosterText1.BackgroundTransparency = 1
    honeyBoosterText1.Text = "HONEY"
    honeyBoosterText1.TextColor3 = Color3.fromRGB(255, 255, 255)
    honeyBoosterText1.Font = Enum.Font.FredokaOne
    honeyBoosterText1.TextSize = isMobile and 12 or 15
    honeyBoosterText1.TextXAlignment = Enum.TextXAlignment.Left
    honeyBoosterText1.Parent = boosterTitleContainer
    
    local honeyBoosterText2 = Instance.new("TextLabel")
    honeyBoosterText2.Size = UDim2.new(0, isMobile and 60 or 75, 0, 26)
    honeyBoosterText2.Position = UDim2.new(0, isMobile and 50 or 60, 0, 0)  -- Normal spacing
    honeyBoosterText2.BackgroundTransparency = 1
    honeyBoosterText2.Text = "BOOSTER"
    honeyBoosterText2.TextColor3 = Theme.Primary
    honeyBoosterText2.Font = Enum.Font.FredokaOne
    honeyBoosterText2.TextSize = isMobile and 12 or 15
    honeyBoosterText2.TextXAlignment = Enum.TextXAlignment.Left
    honeyBoosterText2.Parent = boosterTitleContainer
    createAnimatedYellowText(honeyBoosterText2)
    
    boosterMinimizeBtn = Instance.new("TextButton")
    boosterMinimizeBtn.Size = UDim2.new(0, 22, 0, 22)
    boosterMinimizeBtn.Position = UDim2.new(1, -54, 0, 6)
    boosterMinimizeBtn.BackgroundColor3 = Theme.Background2
    boosterMinimizeBtn.BackgroundTransparency = 0.5
    boosterMinimizeBtn.Text = ""
    boosterMinimizeBtn.Parent = boosterUIFrame
    Instance.new("UICorner", boosterMinimizeBtn).CornerRadius = UDim.new(0, 6)
    addAnimatedYellowStroke(boosterMinimizeBtn, 2)
    
    boosterMinimizeText = Instance.new("TextLabel")
    boosterMinimizeText.Size = UDim2.new(1, 0, 1, 0)
    boosterMinimizeText.BackgroundTransparency = 1
    boosterMinimizeText.Text = boosterUIMinimized and "+" or "-"
    boosterMinimizeText.Font = Enum.Font.FredokaOne
    boosterMinimizeText.TextSize = 14
    boosterMinimizeText.TextColor3 = Theme.Primary
    boosterMinimizeText.Parent = boosterMinimizeBtn
    createAnimatedYellowText(boosterMinimizeText)
    
    boosterMinimizeBtn.MouseButton1Click:Connect(function()
        boosterUIMinimized = not boosterUIMinimized
        updateBoosterMinimizeState()
    end)
    
    local boosterClose = Instance.new("TextButton")
    boosterClose.Size = UDim2.new(0, 22, 0, 22)
    boosterClose.Position = UDim2.new(1, -30, 0, 6)
    boosterClose.BackgroundColor3 = Theme.Background2
    boosterClose.BackgroundTransparency = 0.5
    boosterClose.Text = ""
    boosterClose.Parent = boosterUIFrame
    Instance.new("UICorner", boosterClose).CornerRadius = UDim.new(0, 6)
    addAnimatedYellowStroke(boosterClose, 2)
    
    local boosterCloseText = Instance.new("TextLabel")
    boosterCloseText.Size = UDim2.new(1, 0, 1, 0)
    boosterCloseText.BackgroundTransparency = 1
    boosterCloseText.Text = "X"
    boosterCloseText.Font = Enum.Font.FredokaOne
    boosterCloseText.TextSize = 12
    boosterCloseText.TextColor3 = Color3.fromRGB(255, 255, 255)
    boosterCloseText.Parent = boosterClose
    
    boosterClose.MouseButton1Click:Connect(function()
        boosterUIFrame.Visible = false
        boosterUIEnabled = false
        config.boosterUIEnabled = false
        saveConfig(config)
        if toggles["Booster UI"] then
            toggles["Booster UI"].SetState(false)
        end
    end)
    
    boosterSectionsContainer = Instance.new("ScrollingFrame")
    boosterSectionsContainer.Name = "SectionsContainer"
    boosterSectionsContainer.Size = UDim2.new(1, -12, 1, -40)
    boosterSectionsContainer.Position = UDim2.new(0, 6, 0, 34)
    boosterSectionsContainer.BackgroundTransparency = 1
    boosterSectionsContainer.ScrollBarThickness = 2
    boosterSectionsContainer.ScrollBarImageColor3 = Theme.Primary
    boosterSectionsContainer.Parent = boosterUIFrame
    
    local boosterLayout = Instance.new("UIListLayout")
    boosterLayout.Padding = UDim.new(0, 6)
    boosterLayout.Parent = boosterSectionsContainer
    
    createBoosterSliderWithInput("Movement Speed", 20, 70, movementSpeedValue, function(val, enabled)
        movementSpeedValue = val
        config.movementSpeedValue = val
        config.movementSpeedEnabled = enabled
        saveConfig(config)
        toggleMovementSpeed(enabled)
    end, boosterSectionsContainer, 0.5)
    
    createBoosterSliderWithInput("Steal Speed", 10, 35, stealSpeedValue, function(val, enabled)
        stealSpeedValue = val
        config.stealSpeedValue = val
        config.stealSpeedEnabled = enabled
        saveConfig(config)
        toggleStealSpeed(enabled)
    end, boosterSectionsContainer, 0.5)
    
    createBoosterSliderWithInput("Jump Boost", 0, 100, jumpBoostValue, function(val, enabled)
        jumpBoostValue = val
        config.jumpBoostValue = val
        config.jumpBoostEnabled = enabled
        saveConfig(config)
        toggleJumpBoost(enabled)
    end, boosterSectionsContainer, 1)
    
    createBoosterSliderWithInput("Gravity %", 0, 100, gravityBoostValue, function(val, enabled)
        gravityBoostValue = val
        config.gravityBoostValue = val
        config.gravityBoostEnabled = enabled
        saveConfig(config)
        toggleGravityBoost(enabled)
    end, boosterSectionsContainer, 1)
    
    boosterSectionsContainer.CanvasSize = UDim2.new(0, 0, 0, boosterLayout.AbsoluteContentSize.Y + 10)
    boosterLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        boosterSectionsContainer.CanvasSize = UDim2.new(0, 0, 0, boosterLayout.AbsoluteContentSize.Y + 10)
    end)
    
    if boosterUIMinimized then
        updateBoosterMinimizeState()
    end
    
    task.spawn(function()
        task.wait(0.2)
        if config.movementSpeedEnabled and boosterToggles["Movement Speed"] then
            boosterToggles["Movement Speed"].SetEnabled(true)
        end
        if config.stealSpeedEnabled and boosterToggles["Steal Speed"] then
            boosterToggles["Steal Speed"].SetEnabled(true)
        end
        if config.jumpBoostEnabled and boosterToggles["Jump Boost"] then
            boosterToggles["Jump Boost"].SetEnabled(true)
        end
        if config.gravityBoostEnabled and boosterToggles["Gravity %"] then
            boosterToggles["Gravity %"].SetEnabled(true)
        end
    end)
end

local function toggleBoosterUI(state)
    boosterUIEnabled = state
    config.boosterUIEnabled = state
    saveConfig(config)
    
    if state then
        createBoosterUI()
    else
        if boosterUIFrame then
            boosterUIFrame.Visible = false
        end
    end
end

-- ==========================================
-- MAIN MENU UI - TWO COLUMNS
-- ==========================================
local mainFrameWidth = isMobile and 300 or 380
local mainFrameHeight = isMobile and 380 or 460

mainFrame = Instance.new("Frame")
mainFrame.Name = "MainPanel"
mainFrame.Size = UDim2.new(0, mainFrameWidth, 0, mainFrameHeight)
mainFrame.Position = UDim2.new(0.5, -mainFrameWidth/2, 0.5, -mainFrameHeight/2)
mainFrame.BackgroundColor3 = Theme.Background
mainFrame.BackgroundTransparency = 0.02
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Active = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 14)
mainCorner.Parent = mainFrame

makeDraggable(mainFrame)

createFloatingDots(mainFrame, 12)

-- Title: "Honey Duels"
local titleContainer = Instance.new("Frame")
titleContainer.Size = UDim2.new(1, -50, 0, isMobile and 28 or 34)
titleContainer.Position = UDim2.new(0, 12, 0, 8)
titleContainer.BackgroundTransparency = 1
titleContainer.Parent = mainFrame

local honeyText = Instance.new("TextLabel")
honeyText.Size = UDim2.new(0, isMobile and 55 or 70, 1, 0)
honeyText.Position = UDim2.new(0, 0, 0, 0)
honeyText.BackgroundTransparency = 1
honeyText.Text = "HONEY"
honeyText.TextColor3 = Color3.fromRGB(255, 255, 255)
honeyText.TextSize = isMobile and 18 or 22
honeyText.Font = Enum.Font.FredokaOne
honeyText.TextXAlignment = Enum.TextXAlignment.Left
honeyText.Parent = titleContainer

local duelsText = Instance.new("TextLabel")
duelsText.Size = UDim2.new(0, isMobile and 50 or 65, 1, 0)
duelsText.Position = UDim2.new(0, isMobile and 57 or 72, 0, 0)
duelsText.BackgroundTransparency = 1
duelsText.Text = "DUELS"
duelsText.TextColor3 = Theme.Primary
duelsText.TextSize = isMobile and 18 or 22
duelsText.Font = Enum.Font.FredokaOne
duelsText.TextXAlignment = Enum.TextXAlignment.Left
duelsText.Parent = titleContainer
createAnimatedYellowText(duelsText)

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, isMobile and 26 or 30, 0, isMobile and 26 or 30)
closeBtn.Position = UDim2.new(1, isMobile and -34 or -40, 0, 8)
closeBtn.BackgroundColor3 = Theme.Background2
closeBtn.BackgroundTransparency = 0.3
closeBtn.Text = ""
closeBtn.Parent = mainFrame
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)

local closeText = Instance.new("TextLabel")
closeText.Size = UDim2.new(1, 0, 1, 0)
closeText.BackgroundTransparency = 1
closeText.Text = "X"
closeText.Font = Enum.Font.FredokaOne
closeText.TextSize = isMobile and 14 or 16
closeText.TextColor3 = Color3.fromRGB(255, 255, 255)
closeText.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

-- Two columns container
local columnsContainer = Instance.new("Frame")
columnsContainer.Size = UDim2.new(1, -14, 1, -(isMobile and 48 or 56))
columnsContainer.Position = UDim2.new(0, 7, 0, isMobile and 42 or 50)
columnsContainer.BackgroundTransparency = 1
columnsContainer.Parent = mainFrame

-- Left column
local leftColumn = Instance.new("ScrollingFrame")
leftColumn.Name = "LeftColumn"
leftColumn.Size = UDim2.new(0.5, -3, 1, 0)
leftColumn.Position = UDim2.new(0, 0, 0, 0)
leftColumn.BackgroundTransparency = 1
leftColumn.ScrollBarThickness = 2
leftColumn.ScrollBarImageColor3 = Theme.Primary
leftColumn.Parent = columnsContainer

local leftLayout = Instance.new("UIListLayout")
leftLayout.Padding = UDim.new(0, 5)
leftLayout.Parent = leftColumn

local leftPadding = Instance.new("UIPadding")
leftPadding.PaddingTop = UDim.new(0, 2)
leftPadding.PaddingLeft = UDim.new(0, 2)
leftPadding.PaddingRight = UDim.new(0, 2)
leftPadding.Parent = leftColumn

-- Right column
local rightColumn = Instance.new("ScrollingFrame")
rightColumn.Name = "RightColumn"
rightColumn.Size = UDim2.new(0.5, -3, 1, 0)
rightColumn.Position = UDim2.new(0.5, 3, 0, 0)
rightColumn.BackgroundTransparency = 1
rightColumn.ScrollBarThickness = 2
rightColumn.ScrollBarImageColor3 = Theme.Primary
rightColumn.Parent = columnsContainer

local rightLayout = Instance.new("UIListLayout")
rightLayout.Padding = UDim.new(0, 5)
rightLayout.Parent = rightColumn

local rightPadding = Instance.new("UIPadding")
rightPadding.PaddingTop = UDim.new(0, 2)
rightPadding.PaddingLeft = UDim.new(0, 2)
rightPadding.PaddingRight = UDim.new(0, 2)
rightPadding.Parent = rightColumn

-- ==========================================
-- CREATE ALL TOGGLES - SPLIT INTO TWO COLUMNS
-- ==========================================

-- LEFT COLUMN TOGGLES
createBeautifulToggle("Booster UI", false, toggleBoosterUI, leftColumn)
createBeautifulToggle("Anti Ragdoll", false, toggleAntiRagdoll, leftColumn)
createBeautifulToggle("Bat Aimbot", false, toggleBatAimbot, leftColumn)
createBeautifulToggle("Lock Player", false, toggleLockPlayer, leftColumn)
createBeautifulToggle("Lock Player UI", false, toggleLockPlayerUI, leftColumn)
createBeautifulToggle("Spin Bot", false, toggleSpinbot, leftColumn, true, 0, 100, spinbotSpeed, function(v)
    spinbotSpeed = v
    config.spinbotSpeed = v
    saveConfig(config)
end, 1)
createBeautifulToggle("Inf Jump", false, toggleInfJump, leftColumn)
createBeautifulToggle("Auto Hit", false, toggleAutoHit, leftColumn)

-- RIGHT COLUMN TOGGLES
createBeautifulToggle("Auto Medusa", false, toggleAutoMedusa, rightColumn, true, 5, 30, medusaRange, function(v)
    medusaRange = v
    config.medusaRange = v
    saveConfig(config)
end, 1)
createBeautifulToggle("Unwalk", false, toggleUnwalk, rightColumn)
createBeautifulToggle("XRay", false, toggleXray, rightColumn)
createBeautifulToggle("Player ESP", false, function(s) if s then startESP() else stopESP() end end, rightColumn)
createBeautifulToggle("Hitbox", false, toggleHitbox, rightColumn, true, 6, 20, hitboxSize, function(v)
    hitboxSize = v
    config.hitboxSize = v
    saveConfig(config)
end, 1)
createBeautifulToggle("Optimizer", false, toggleOptimizer, rightColumn)
createBeautifulToggle("Auto Left UI", false, toggleAutoLeftUI, rightColumn)
createBeautifulToggle("Auto Right UI", false, toggleAutoRightUI, rightColumn)

-- Update canvas sizes for both columns
leftLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    leftColumn.CanvasSize = UDim2.new(0, 0, 0, leftLayout.AbsoluteContentSize.Y + 10)
end)

rightLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    rightColumn.CanvasSize = UDim2.new(0, 0, 0, rightLayout.AbsoluteContentSize.Y + 10)
end)

-- ==========================================
-- CREATE ALL UI ELEMENTS
-- ==========================================
createAutoStealUI()
createInfoBar()

-- Initialize scanner for auto steal
task.spawn(function()
    task.wait(2)
    initializeScanner()
end)

-- ==========================================
-- AUTO-LOAD SAVED SETTINGS
-- ==========================================
task.spawn(function()
    task.wait(1.5)
    
    if config.boosterUIEnabled then
        if toggles["Booster UI"] then
            toggles["Booster UI"].SetState(true)
        end
    end
    
    if config.infJumpEnabled then
        if toggles["Inf Jump"] then
            toggles["Inf Jump"].SetState(true)
        end
    end
    
    if config.antiRagdollEnabled then
        if toggles["Anti Ragdoll"] then
            toggles["Anti Ragdoll"].SetState(true)
        end
    end
    
    if config.autoHitEnabled then
        if toggles["Auto Hit"] then
            toggles["Auto Hit"].SetState(true)
        end
    end
    
    if config.lockPlayerEnabled then
        if toggles["Lock Player"] then
            toggles["Lock Player"].SetState(true)
        end
    end
    
    if config.batAimbotEnabled then
        if toggles["Bat Aimbot"] then
            toggles["Bat Aimbot"].SetState(true)
        end
    end
    
    if config.autoMedusaEnabled then
        if toggles["Auto Medusa"] then
            toggles["Auto Medusa"].SetState(true)
        end
        if sliders["Auto Medusa"] then
            sliders["Auto Medusa"].SetValue(config.medusaRange or 10)
        end
    end
    
    if config.espEnabled then
        if toggles["Player ESP"] then
            toggles["Player ESP"].SetState(true)
        end
    end
    
    if config.spinbotEnabled then
        if toggles["Spin Bot"] then
            toggles["Spin Bot"].SetState(true)
        end
        if sliders["Spin Bot"] then
            sliders["Spin Bot"].SetValue(config.spinbotSpeed or 30)
        end
    end
    
    if config.unwalkEnabled then
        if toggles["Unwalk"] then
            toggles["Unwalk"].SetState(true)
        end
    end
    
    if config.hitboxEnabled then
        if toggles["Hitbox"] then
            toggles["Hitbox"].SetState(true)
        end
        if sliders["Hitbox"] then
            sliders["Hitbox"].SetValue(config.hitboxSize or 12)
        end
    end
    
    if config.xrayEnabled then
        if toggles["XRay"] then
            toggles["XRay"].SetState(true)
        end
    end
    
    if config.optimizerEnabled then
        if toggles["Optimizer"] then
            toggles["Optimizer"].SetState(true)
        end
    end
    
    if config.lockPlayerUIEnabled then
        if toggles["Lock Player UI"] then
            toggles["Lock Player UI"].SetState(true)
        end
    end
    
    if config.autoLeftUIEnabled then
        if toggles["Auto Left UI"] then
            toggles["Auto Left UI"].SetState(true)
        end
    end
    
    if config.autoRightUIEnabled then
        if toggles["Auto Right UI"] then
            toggles["Auto Right UI"].SetState(true)
        end
    end
    
    if config.autoStealRadius then
        AUTO_STEAL_PROX_RADIUS = config.autoStealRadius
    end
end)

-- ==========================================
-- CHARACTER RESPAWN HANDLER
-- ==========================================
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    
    isCurrentlyStealing = false
    wasMovementSpeedEnabledBeforeSteal = false
    isActivelyStealingAnimal = false
    stealStartTime = nil
    currentStealTarget = nil
    
    if espEnabled then 
        stopESP() 
        startESP() 
    end
    
    if antiRagdollEnabled then 
        toggleAntiRagdoll(false)
        task.wait(0.1)
        toggleAntiRagdoll(true) 
    end
    
    if autoHitEnabled then 
        toggleAutoHit(false)
        task.wait(0.1)
        toggleAutoHit(true) 
    end
    
    if lockPlayerEnabled then
        toggleLockPlayer(false)
        task.wait(0.1)
        toggleLockPlayer(true)
    end
    
    if batAimbotEnabled then
        toggleBatAimbot(false)
        task.wait(0.1)
        toggleBatAimbot(true)
    end
    
    if autoMedusaEnabled then 
        toggleAutoMedusa(false)
        task.wait(0.1)
        toggleAutoMedusa(true) 
    end
    
    if spinbotEnabled then 
        toggleSpinbot(false)
        task.wait(0.1)
        toggleSpinbot(true) 
    end
    
    if autoStealEnabled then 
        toggleAutoSteal(false)
        task.wait(0.1)
        toggleAutoSteal(true) 
    end
    
    if hitboxEnabled then 
        toggleHitbox(false)
        task.wait(0.1)
        toggleHitbox(true) 
    end
    
    if infJumpEnabled then
        toggleInfJump(false)
        task.wait(0.1)
        toggleInfJump(true)
    end
    
    if movementSpeedEnabled or stealSpeedEnabled then
        startStealingDetection()
        if movementSpeedEnabled and not isCurrentlyStealing then
            toggleMovementSpeed(true)
        end
    end
    
    if jumpBoostEnabled then 
        toggleJumpBoost(false)
        task.wait(0.1)
        toggleJumpBoost(true) 
    end
    
    if gravityBoostEnabled then 
        toggleGravityBoost(false)
        task.wait(0.1)
        toggleGravityBoost(true) 
    end
    
    if xrayEnabled then
        enableXray()
    end
    
    if optimizerEnabled then
        enableOptimizer()
    end
end)

-- ==========================================
-- CLEANUP ON SCRIPT DESTROY
-- ==========================================
screenGui.Destroying:Connect(function()
    if movementSpeedConnection then movementSpeedConnection:Disconnect() end
    if stealSpeedConnection then stealSpeedConnection:Disconnect() end
    if jumpBoostConnection then jumpBoostConnection:Disconnect() end
    if jumpBoostActiveConnection then jumpBoostActiveConnection:Disconnect() end
    if gravityBoostConnection then gravityBoostConnection:Disconnect() end
    if stealingDetectionConnection then stealingDetectionConnection:Disconnect() end
    if infJumpConnection then infJumpConnection:Disconnect() end
    for _, c in ipairs(ANTI_RAGDOLL.connections) do pcall(function() c:Disconnect() end) end
    if autoHitConnection then autoHitConnection:Disconnect() end
    if lockPlayerConnection then lockPlayerConnection:Disconnect() end
    if batAimbotConnection then batAimbotConnection:Disconnect() end
    if autoMedusaConnection then autoMedusaConnection:Disconnect() end
    if spinbotConnection then spinbotConnection:Disconnect() end
    if stealConnection then stealConnection:Disconnect() end
    if hitboxConnection then hitboxConnection:Disconnect() end
    if espFolder then espFolder:Destroy() end
    for _, connection in ipairs(espConnections) do if connection then connection:Disconnect() end end
    
    destroyCircleParts()
    
    local char = LocalPlayer.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local bodyAngularVel = hrp:FindFirstChild("SpinbotAngularVelocity")
            if bodyAngularVel then bodyAngularVel:Destroy() end
        end
    end
    
    if autoStealProgressFrame then
        autoStealProgressFrame:Destroy()
    end
    
    if lockPlayerUIFrame then
        lockPlayerUIFrame:Destroy()
    end
    
    if autoLeftUIFrame then
        autoLeftUIFrame:Destroy()
    end
    
    if autoRightUIFrame then
        autoRightUIFrame:Destroy()
    end
    
    if infoBarFrame then
        infoBarFrame:Destroy()
    end
    
    stopBatAimbot()
    disableXray()
    disableOptimizer()
end)

-- ==========================================
-- INITIAL SETUP
-- ==========================================
task.spawn(function()
    task.wait(0.5)
    
    leftColumn.CanvasSize = UDim2.new(0, 0, 0, leftLayout.AbsoluteContentSize.Y + 10)
    rightColumn.CanvasSize = UDim2.new(0, 0, 0, rightLayout.AbsoluteContentSize.Y + 10)
    
    print("[HONEY DUELS] Successfully loaded - V3.0")
    print(" Two column layout with scrolling")
    print(" Beautiful animated toggles with glow effects")
    print(" Combined features from all scripts")
    print(" Auto Steal with circle radius indicator")
    print(" Lock Player with auto Bat Aimbot")
    print(" Auto Left/Right movement functions")
    print(" Info bar with OPEN button")
    print(" Booster sliders: 0.5 step for drag, 0.1 for input")
    print(" Mobile/Tablet/PC optimized with universal drag")
end)