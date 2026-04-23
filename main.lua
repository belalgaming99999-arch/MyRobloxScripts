-- [[ Crystal Hub - With Blue Steal Circle ]] --

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local UserInputService = game:GetService("UserInputService")
local Player = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

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
}

-- ========== STEAL CIRCLE (الدائرة الزرقاء تحت اللاعب) ==========
local stealCircle = nil
local STEAL_RADIUS = 30

local function createStealCircle()
    if stealCircle then stealCircle:Destroy() end
    
    stealCircle = Instance.new("Part")
    stealCircle.Name = "StealCircle"
    stealCircle.Anchored = true
    stealCircle.CanCollide = false
    stealCircle.CanTouch = false
    stealCircle.Transparency = 0.6
    stealCircle.Color = Color3.fromRGB(0, 150, 255)
    stealCircle.Material = Enum.Material.Neon
    stealCircle.Shape = Enum.PartType.Cylinder
    stealCircle.Size = Vector3.new(0.05, STEAL_RADIUS * 2, STEAL_RADIUS * 2)
    stealCircle.Parent = workspace
end

createStealCircle()

-- تحديث موقع الدائرة كل إطار
RunService.RenderStepped:Connect(function()
    if Toggles.AutoSteal or Toggles.AutoPlay then
        local char = Player.Character
        if char then
            local root = char:FindFirstChild("HumanoidRootPart")
            if root then
                stealCircle.Transparency = 0.5
                stealCircle.CFrame = CFrame.new(root.Position + Vector3.new(0, -2.8, 0)) * CFrame.Angles(0, 0, math.rad(90))
            end
        end
    else
        if stealCircle then
            stealCircle.Transparency = 1
        end
    end
end)

-- ========== BAT AIMBOT ==========
local aimbotConnection = nil
local AIMBOT_SPEED = 60

local function findBat()
    local char = Player.Character
    if char then
        for _, tool in ipairs(char:GetChildren()) do
            if tool:IsA("Tool") and tool.Name == "Bat" then return tool end
        end
    end
    local bp = Player:FindFirstChild("Backpack")
    if bp then
        for _, tool in ipairs(bp:GetChildren()) do
            if tool:IsA("Tool") and tool.Name == "Bat" then return tool end
        end
    end
    return nil
end

local function isTargetValid(targetChar)
    if not targetChar then return false end
    local hum = targetChar:FindFirstChildOfClass("Humanoid")
    local hrp = targetChar:FindFirstChild("HumanoidRootPart")
    return hum and hrp and hum.Health > 0
end

local function getBestTarget(myHRP)
    local shortestDistance = 70
    local bestTarget = nil
    local bestHRP = nil
    
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= Player and plr.Character then
            local targetChar = plr.Character
            local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
            local targetHum = targetChar:FindFirstChildOfClass("Humanoid")
            
            if targetHRP and targetHum and targetHum.Health > 0 then
                local distance = (targetHRP.Position - myHRP.Position).Magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    bestTarget = targetChar
                    bestHRP = targetHRP
                end
            end
        end
    end
    return bestHRP, bestTarget
end

local function startBatAimbot()
    if aimbotConnection then return end
    
    aimbotConnection = RunService.Heartbeat:Connect(function()
        if not Toggles.BatAimbot then return end
        
        local char = Player.Character
        if not char then return end
        
        local myHRP = char:FindFirstChild("HumanoidRootPart")
        local myHum = char:FindFirstChildOfClass("Humanoid")
        if not myHRP or not myHum then return end
        
        local bat = findBat()
        if not bat then return end
        
        if bat.Parent ~= char then
            myHum:EquipTool(bat)
        end
        
        local targetHRP, targetChar = getBestTarget(myHRP)
        
        if targetHRP and targetChar then
            local moveDir = (targetHRP.Position - myHRP.Position)
            local distance = moveDir.Magnitude
            
            myHRP.CFrame = CFrame.lookAt(myHRP.Position, Vector3.new(targetHRP.Position.X, myHRP.Position.Y, targetHRP.Position.Z))
            
            if distance > 2 then
                myHRP.AssemblyLinearVelocity = moveDir.Unit * AIMBOT_SPEED
            else
                pcall(function() bat:Activate() end)
                if distance < 1.5 then
                    myHRP.AssemblyLinearVelocity = moveDir.Unit * 15
                end
            end
        else
            myHRP.AssemblyLinearVelocity = Vector3.zero
        end
    end)
end

local function stopBatAimbot()
    if aimbotConnection then
        aimbotConnection:Disconnect()
        aimbotConnection = nil
    end
    local char = Player.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.AssemblyLinearVelocity = Vector3.zero
        end
    end
end

-- ========== ESP ==========
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

-- ========== AUTO STEAL ==========
local isStealing = false
local stealDuration = 0.2

local function isMyPlot(plotName)
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return false end
    local plot = plots:FindFirstChild(plotName)
    if not plot then return false end
    local sign = plot:FindFirstChild("PlotSign")
    if sign then
        local yb = sign:FindFirstChild("YourBase")
        if yb and yb:IsA("BillboardGui") then return yb.Enabled == true end
    end
    return false
end

local function findNearestStealPrompt()
    local char = Player.Character
    if not char then return nil end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return nil end
    local nearestPrompt, minDist = nil, STEAL_RADIUS
    for _, plot in ipairs(plots:GetChildren()) do
        if not isMyPlot(plot.Name) then
            local podiums = plot:FindFirstChild("AnimalPodiums")
            if podiums then
                for _, pod in ipairs(podiums:GetChildren()) do
                    local base = pod:FindFirstChild("Base")
                    local spawn = base and base:FindFirstChild("Spawn")
                    if spawn then
                        local dist = (spawn.Position - hrp.Position).Magnitude
                        if dist < minDist then
                            local att = spawn:FindFirstChild("PromptAttachment")
                            if att then
                                for _, ch in ipairs(att:GetChildren()) do
                                    if ch:IsA("ProximityPrompt") then
                                        nearestPrompt = ch
                                        minDist = dist
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return nearestPrompt
end

local function executeSteal(prompt)
    if isStealing then return end
    isStealing = true
    pcall(function()
        prompt:InputHoldBegin()
        task.wait(stealDuration)
        prompt:InputHoldEnd()
    end)
    isStealing = false
end

local autoStealLoop = nil
local function startAutoSteal()
    if autoStealLoop then return end
    autoStealLoop = RunService.Heartbeat:Connect(function()
        if Toggles.AutoSteal and not isStealing then
            local prompt = findNearestStealPrompt()
            if prompt then executeSteal(prompt) end
        end
    end)
end
local function stopAutoSteal()
    if autoStealLoop then autoStealLoop:Disconnect() autoStealLoop = nil end
    isStealing = false
end

-- ========== AUTO MEDUSA ==========
local medusaPart = nil
local medusaLastUse = 0
local MEDUSA_RADIUS = 10
local MEDUSA_DELAY = 0.15

local function createMedusaRadius()
    if medusaPart then medusaPart:Destroy() end
    medusaPart = Instance.new("Part")
    medusaPart.Name = "MedusaRadius"
    medusaPart.Anchored = true
    medusaPart.CanCollide = false
    medusaPart.Transparency = 1
    medusaPart.Material = Enum.Material.Neon
    medusaPart.Color = CrystalPurple
    medusaPart.Shape = Enum.PartType.Cylinder
    medusaPart.Size = Vector3.new(0.05, MEDUSA_RADIUS*2, MEDUSA_RADIUS*2)
    medusaPart.Parent = workspace
end
createMedusaRadius()

RunService.RenderStepped:Connect(function()
    if Toggles.AutoMedusa then
        medusaPart.Transparency = 0.75
        local char = Player.Character
        if char then
            local root = char:FindFirstChild("HumanoidRootPart")
            if root then
                medusaPart.CFrame = CFrame.new(root.Position + Vector3.new(0, -2.5, 0)) * CFrame.Angles(0, 0, math.rad(90))
            end
        end
    else
        medusaPart.Transparency = 1
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

-- ========== AUTO PLAY ==========
local autoPlayActive = false
local autoPlayLoop = nil
local waypoints = {
    {pos = Vector3.new(-476.14, -6.90, 25.66)},
    {pos = Vector3.new(-482.98, -5.27, 24.82)},
    {pos = Vector3.new(-476.80, -6.57, 94.64)},
    {pos = Vector3.new(-482.82, -5.27, 94.81)},
}

local function startAutoPlay()
    if autoPlayLoop then return end
    autoPlayActive = true
    autoPlayLoop = task.spawn(function()
        while autoPlayActive and Toggles.AutoPlay do
            local char = Player.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                local root = char:FindFirstChild("HumanoidRootPart")
                if hum and root then
                    for _, wp in ipairs(waypoints) do
                        if not Toggles.AutoPlay then break end
                        hum:MoveTo(wp.pos)
                        repeat
                            task.wait(0.1)
                        until (root.Position - wp.pos).Magnitude < 5 or not Toggles.AutoPlay
                    end
                end
            end
            task.wait(0.5)
        end
    end)
end

local function stopAutoPlay()
    autoPlayActive = false
    if autoPlayLoop then task.cancel(autoPlayLoop) autoPlayLoop = nil end
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

-- ========== ANTI RAGDOLL ==========
local antiRagdollActive = false
local function startAntiRagdoll()
    if antiRagdollActive then return end
    antiRagdollActive = true
    local function initChar(char)
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
        end
    end
    if Player.Character then initChar(Player.Character) end
    Player.CharacterAdded:Connect(initChar)
end
local function stopAntiRagdoll()
    antiRagdollActive = false
end

-- ========== NO WALK ==========
local unwalkConn = nil
local function startNoWalk()
    if unwalkConn then unwalkConn:Disconnect() end
    unwalkConn = RunService.Heartbeat:Connect(function()
        if not Toggles.NoWalk then return end
        local char = Player.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        local animator = hum:FindFirstChildOfClass("Animator")
        if not animator then return end
        for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
            local n = track.Name:lower()
            if n:find("walk") or n:find("run") or n:find("jump") or n:find("fall") then
                track:Stop(0)
            end
        end
    end)
end
local function stopNoWalk()
    if unwalkConn then unwalkConn:Disconnect() unwalkConn = nil end
end

-- ========== INFINITE JUMP ==========
local infJumpConn = nil
local JUMP_POWER = 50
local lastJump = 0
local COOLDOWN = 0.15

local function startInfJump()
    if infJumpConn then return end
    infJumpConn = UserInputService.JumpRequest:Connect(function()
        if Toggles.InfJump and Player.Character then
            local hrp = Player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local now = tick()
                if now - lastJump >= COOLDOWN then
                    lastJump = now
                    hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, JUMP_POWER, hrp.AssemblyLinearVelocity.Z)
                end
            end
        end
    end)
end
local function stopInfJump()
    if infJumpConn then infJumpConn:Disconnect() infJumpConn = nil end
end

-- ========== SPIN ==========
local spinForce = nil
local SPIN_SPEED = 100

local function startSpin()
    if spinForce then return end
    local char = Player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    spinForce = Instance.new("BodyAngularVelocity")
    spinForce.Name = "SpinForce"
    spinForce.MaxTorque = Vector3.new(0, math.huge, 0)
    spinForce.P = 1200
    spinForce.AngularVelocity = Vector3.new(0, SPIN_SPEED, 0)
    spinForce.Parent = root
end
local function stopSpin()
    if spinForce then spinForce:Destroy() spinForce = nil end
end

-- ========== GUI ==========
for _, child in pairs(CoreGui:GetChildren()) do
    if child:IsA("ScreenGui") and child.Name:find("Crystal") then
        child:Destroy()
    end
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Crystal_BatAimbot"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 9999
ScreenGui.Parent = CoreGui

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
SideMenu.Size = UDim2.new(0, 160, 0, 340)
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
            if Toggles.BatAimbot then startBatAimbot() else stopBatAimbot() end
        elseif toggleKey == "AutoSteal" then
            if Toggles.AutoSteal then startAutoSteal() else stopAutoSteal() end
        elseif toggleKey == "AutoPlay" then
            if Toggles.AutoPlay then startAutoPlay() else stopAutoPlay() end
        elseif toggleKey == "AntiFling" then
            if Toggles.AntiFling then startAntiFling() else stopAntiFling() end
        elseif toggleKey == "AntiRagdoll" then
            if Toggles.AntiRagdoll then startAntiRagdoll() else stopAntiRagdoll() end
        elseif toggleKey == "NoWalk" then
            if Toggles.NoWalk then startNoWalk() else stopNoWalk() end
        elseif toggleKey == "InfJump" then
            if Toggles.InfJump then startInfJump() else stopInfJump() end
        elseif toggleKey == "Spin" then
            if Toggles.Spin then startSpin() else stopSpin() end
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

-- الأزرار
CreateBtn("Esp Player", SideMenu, nil, "Esp")
CreateBtn("Bat Aimbot", SideMenu, nil, "BatAimbot")

local R1 = Row(SideMenu)
CreateBtn("Auto Steal", R1, UDim2.new(0, 66, 1, 0), "AutoSteal")
CreateBtn("Auto Medusa", R1, UDim2.new(0, 66, 1, 0), "AutoMedusa")

local R2 = Row(SideMenu)
CreateBtn("Auto Play", R2, UDim2.new(0, 66, 1, 0), "AutoPlay")
CreateBtn("Anti Fling", R2, UDim2.new(0, 66, 1, 0), "AntiFling")

local R3 = Row(SideMenu)
CreateBtn("Anti Ragdoll", R3, UDim2.new(0, 66, 1, 0), "AntiRagdoll")
CreateBtn("No Walk", R3, UDim2.new(0, 66, 1, 0), "NoWalk")

local R4 = Row(SideMenu)
CreateBtn("Infinite Jump", R4, UDim2.new(0, 66, 1, 0), "InfJump")
CreateBtn("Spin Player", R4, UDim2.new(0, 66, 1, 0), "Spin")

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
end)                        spinForce.Parent = root
                    end
                elseif spinForce then
                    spinForce:Destroy()
                    spinForce = nil
                end
            end)
            task.wait(0.1)
        end
    end)
end

local function stopSpin()
    spinEnabled = false
    if spinForce then spinForce:Destroy() spinForce = nil end
end

-- ESP
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
    local hitbox = Instance.new("BoxHandleAdornment")
    hitbox.Name = "ESP_Hitbox"
    hitbox.Adornee = hrp
    hitbox.Size = Vector3.new(4, 6, 2)
    hitbox.Color3 = CrystalPurple
    hitbox.Transparency = 0.5
    hitbox.AlwaysOnTop = true
    hitbox.Parent = char
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
    local hitbox = char:FindFirstChild("ESP_Hitbox")
    if hitbox then hitbox:Destroy() end
    local name = char:FindFirstChild("ESP_Name")
    if name then name:Destroy() end
end

function toggleESPPlayers(enable)
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
        local playerAddedConn = Players.PlayerAdded:Connect(function(plr)
            if plr == Player then return end
            local conn = plr.CharacterAdded:Connect(function()
                task.wait(0.2)
                if Toggles.Esp then createESP(plr) end
            end)
            table.insert(espConnections, conn)
        end)
        table.insert(espConnections, playerAddedConn)
    else
        for _, plr in ipairs(Players:GetPlayers()) do removeESP(plr) end
        for _, conn in ipairs(espConnections) do
            if conn and conn.Connected then conn:Disconnect() end
        end
        espConnections = {}
    end
end

-- HITBOX EXPANDER
local hitboxExpanded = false
local originalHRPSizes = {}

local function expandHitboxes()
    if hitboxExpanded then return end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= Player and plr.Character then
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            if hrp and not originalHRPSizes[hrp] then
                originalHRPSizes[hrp] = hrp.Size
                hrp.Size = Vector3.new(8, 8, 8)
            end
        end
    end
    hitboxExpanded = true
end

local function restoreHitboxes()
    if not hitboxExpanded then return end
    for hrp, origSize in pairs(originalHRPSizes) do
        if hrp and hrp.Parent then hrp.Size = origSize end
    end
    originalHRPSizes = {}
    hitboxExpanded = false
end

-- AUTO STEAL
local stealCooldown = 0.2
local HOLD_DURATION = 0.5

local function getPromptPart(prompt)
    local parent = prompt.Parent
    if parent:IsA("BasePart") then return parent end
    if parent:IsA("Model") then return parent.PrimaryPart or parent:FindFirstChildWhichIsA("BasePart") end
    return parent:FindFirstChildWhichIsA("BasePart", true)
end

local function findNearestStealPrompt()
    local char = Player.Character
    if not char then return nil end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    local nearestPrompt, minDist = nil, math.huge
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return nil end
    for _, desc in ipairs(plots:GetDescendants()) do
        if desc:IsA("ProximityPrompt") and desc.Enabled and desc.ActionText == "Steal" then
            local part = getPromptPart(desc)
            if part then
                local dist = (hrp.Position - part.Position).Magnitude
                if dist < minDist then
                    minDist = dist
                    nearestPrompt = desc
                end
            end
        end
    end
    return nearestPrompt
end

local function triggerPrompt(prompt)
    if not prompt or not prompt:IsDescendantOf(workspace) then return end
    prompt.MaxActivationDistance = 9e9
    prompt.RequiresLineOfSight = false
    pcall(function() fireproximityprompt(prompt, 9e9, HOLD_DURATION) end)
end

task.spawn(function()
    while true do
        if Toggles.Steal then
            pcall(function()
                local prompt = findNearestStealPrompt()
                if prompt then triggerPrompt(prompt) end
            end)
        end
        task.wait(stealCooldown)
    end
end)

-- AUTO MEDUSA
local MEDUSA_RADIUS = 10
local SPAM_DELAY = 0.15
local lastMedusaUse = 0

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
                    if t:IsA("Tool") and t.Name == "Medusa's Head" then tool = t; break end
                end
                if tool and tick() - lastMedusaUse >= SPAM_DELAY then
                    for _, plr in ipairs(Players:GetPlayers()) do
                        if plr ~= Player then
                            local pChar = plr.Character
                            local pRoot = pChar and pChar:FindFirstChild("HumanoidRootPart")
                            if pRoot and (pRoot.Position - root.Position).Magnitude <= MEDUSA_RADIUS then
                                tool:Activate()
                                lastMedusaUse = tick()
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

-- AUTO PLAY (Auto Walk)
local walkActive = false

local routes = {
    START_A = { StartPoint = Vector3.new(-475.92, -7.02, 99.32), Route = { Vector3.new(-476.14, -6.90, 25.66), Vector3.new(-482.98, -5.27, 24.82) } },
    START_B = { StartPoint = Vector3.new(-476.72, -6.60, 25.47), Route = { Vector3.new(-476.80, -6.57, 94.64), Vector3.new(-482.82, -5.27, 94.81) } }
}

local function getClosestRoute()
    local char = Player.Character
    if not char then return nil end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local closest, shortest = nil, math.huge
    for _, data in pairs(routes) do
        local dist = (root.Position - data.StartPoint).Magnitude
        if dist < shortest then shortest = dist; closest = data end
    end
    return closest
end

local function followRoute(route)
    local char = Player.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root then return end
    for _, waypoint in ipairs(route.Route) do
        if not Toggles.AutoPlay then break end
        hum:MoveTo(waypoint)
        repeat
            task.wait(0.1)
        until (waypoint - root.Position).Magnitude < 5 or not Toggles.AutoPlay
    end
end

task.spawn(function()
    while true do
        if Toggles.AutoPlay then
            local route = getClosestRoute()
            if route then followRoute(route) end
        end
        task.wait(1)
    end
end)

-- ANTI FLING
local antiFlingConn
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

-- ANTI RAGDOLL
local antiRagdollActive = false
local function startAntiRagdoll()
    if antiRagdollActive then return end
    antiRagdollActive = true
    task.spawn(function()
        while antiRagdollActive do
            task.wait()
            local char = Player.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then
                    local state = hum:GetState()
                    if state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown then
                        hum:ChangeState(Enum.HumanoidStateType.Running)
                    end
                end
            end
        end
    end)
end
local function stopAntiRagdoll()
    antiRagdollActive = false
end

-- NO WALK (No Walk Animation)
local function startNoWalk()
    pcall(function()
        local char = Player.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.WalkSpeed = 16
            end
        end
    end)
end

-- INFINITE JUMP
local infJumpConn
local function startInfJump()
    if infJumpConn then return end
    infJumpConn = UserInputService.JumpRequest:Connect(function()
        if Toggles.InfJump and Player.Character then
            local hrp = Player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, 50, hrp.AssemblyLinearVelocity.Z)
            end
        end
    end)
end
local function stopInfJump()
    if infJumpConn then infJumpConn:Disconnect() infJumpConn = nil end
end

-- GUI
local function FinalCleanup()
    for _, child in pairs(CoreGui:GetChildren()) do
        if child:IsA("ScreenGui") and child.Name:find("Crystal") then
            child:Destroy()
        end
    end
end
FinalCleanup()

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Crystal_Final"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 9999
ScreenGui.Parent = CoreGui

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
SideMenu.Size = UDim2.new(0, 160, 0, 320)
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
        btn.BackgroundColor3 = Toggles[toggleKey] and CrystalPurple or RightPartColor
        btn.BackgroundTransparency = Toggles[toggleKey] and 0 or RightPartTrans
    end
    UpdateButton()

    btn.MouseButton1Click:Connect(function()
        Toggles[toggleKey] = not Toggles[toggleKey]
        UpdateButton()

        if toggleKey == "Esp" then toggleESPPlayers(Toggles.Esp)
        elseif toggleKey == "Optimizer" then
            if Toggles.Optimizer then enableOptimizer() else disableOptimizer() end
        elseif toggleKey == "Spin" then
            if Toggles.Spin then startSpin() else stopSpin() end
        elseif toggleKey == "Aimbot" then
            if Toggles.Aimbot then expandHitboxes() else restoreHitboxes() end
        elseif toggleKey == "AntiFling" then
            if Toggles.AntiFling then startAntiFling() else stopAntiFling() end
        elseif toggleKey == "AntiRagdoll" then
            if Toggles.AntiRagdoll then startAntiRagdoll() else stopAntiRagdoll() end
        elseif toggleKey == "InfJump" then
            if Toggles.InfJump then startInfJump() else stopInfJump() end
        elseif toggleKey == "NoWalk" then
            if Toggles.NoWalk then startNoWalk() end
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

CreateBtn("Esp Player", SideMenu, nil, "Esp")

local TopRow = Row(SideMenu)
CreateBtn("Optimizer", TopRow, UDim2.new(0, 66, 1, 0), "Optimizer")
CreateBtn("Spin Player", TopRow, UDim2.new(0, 66, 1, 0), "Spin")

local R1 = Row(SideMenu)
CreateBtn("AimBot", R1, UDim2.new(0, 66, 1, 0), "Aimbot")
CreateBtn("Steal Nearest", R1, UDim2.new(0, 66, 1, 0), "Steal")

local R2 = Row(SideMenu)
CreateBtn("Auto Medusa", R2, UDim2.new(0, 66, 1, 0), "AutoMedusa")
CreateBtn("Auto Play", R2, UDim2.new(0, 66, 1, 0), "AutoPlay")

local R3 = Row(SideMenu)
CreateBtn("Anti Fling", R3, UDim2.new(0, 66, 1, 0), "AntiFling")
CreateBtn("Anti Ragdoll", R3, UDim2.new(0, 66, 1, 0), "AntiRagdoll")

local R4 = Row(SideMenu)
CreateBtn("No Walk", R4, UDim2.new(0, 66, 1, 0), "NoWalk")
CreateBtn("Infinite Jump", R4, UDim2.new(0, 66, 1, 0), "InfJump")

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
    SideMenu:TweenPosition(UDim2.new(menuOpen and 0.02 or -0.7, 0, 0.30, 0), "Out", "Quart", 0.4, true)
end)

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
