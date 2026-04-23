-- [[ Crystal Hub - Final Version ]] --

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local UserInputService = game:GetService("UserInputService")
local Player = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")

local CrystalPurple = Color3.fromRGB(120, 0, 255)
local RightPartColor = Color3.fromRGB(0, 0, 0)
local RightPartTrans = 0.15
local LeftPartTrans = 0.5

local Toggles = {
    Esp = false,
    Optimizer = false,
    Spin = false,
    Aimbot = false,
    Steal = false,
    AutoMedusa = false,
    AutoPlay = false,
    AntiFling = false,
    AntiRagdoll = false,
    NoWalk = false,
    InfJump = false,
}

-- OPTIMIZER
local optimizerEnabled = false
local savedLighting = {}
local optimized = {}

local function enableOptimizer()
    if optimizerEnabled then return end
    optimizerEnabled = true
    savedLighting = {
        GlobalShadows = Lighting.GlobalShadows,
        FogStart = Lighting.FogStart,
        FogEnd = Lighting.FogEnd,
        Brightness = Lighting.Brightness,
        EnvironmentDiffuseScale = Lighting.EnvironmentDiffuseScale,
        EnvironmentSpecularScale = Lighting.EnvironmentSpecularScale
    }
    Lighting.GlobalShadows = false
    Lighting.FogStart = 0
    Lighting.FogEnd = 1e9
    Lighting.Brightness = 1
    Lighting.EnvironmentDiffuseScale = 0
    Lighting.EnvironmentSpecularScale = 0
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            optimized[v] = { v.Material, v.Reflectance }
            v.Material = Enum.Material.Plastic
            v.Reflectance = 0
        elseif v:IsA("Decal") or v:IsA("Texture") then
            optimized[v] = v.Transparency
            v.Transparency = 1
        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") then
            optimized[v] = v.Enabled
            v.Enabled = false
        end
    end
end

local function disableOptimizer()
    if not optimizerEnabled then return end
    optimizerEnabled = false
    for k, v in pairs(savedLighting) do Lighting[k] = v end
    for obj, val in pairs(optimized) do
        if obj and obj.Parent then
            if typeof(val) == "table" then
                obj.Material = val[1]
                obj.Reflectance = val[2]
            elseif typeof(val) == "boolean" then
                obj.Enabled = val
            else
                obj.Transparency = val
            end
        end
    end
    optimized = {}
end

-- SPIN
local spinForce = nil
local spinEnabled = false

local function startSpin()
    if spinEnabled then return end
    spinEnabled = true
    task.spawn(function()
        while spinEnabled do
            pcall(function()
                local char = Player.Character
                if char and Toggles.Spin then
                    local root = char:FindFirstChild("HumanoidRootPart")
                    if root then
                        if not spinForce then
                            spinForce = Instance.new("BodyAngularVelocity")
                            spinForce.Name = "SpinForce"
                            spinForce.MaxTorque = Vector3.new(0, math.huge, 0)
                            spinForce.P = 1250
                        end
                        spinForce.AngularVelocity = Vector3.new(0, 25, 0)
                        spinForce.Parent = root
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
