-- Crystal Hub - Fully Unified Edition

if _G.CrystalLoaded then return end
_G.CrystalLoaded = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local Player = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")

local ConfigFileName = "CrystalHub_Settings.json"
_G.Enabled = {
    ["Player Esp"] = false,
    ["Bat Aimbot"] = false,
    ["Steal Near"] = false,
    ["Auto Medusa"] = false,
    ["Auto Play"] = false,
    ["Anti Fling"] = false,
    ["Anti Ragdoll"] = false,
    ["Un Walk"] = false,
    ["Inf Jump"] = false,
    ["Spin Bot"] = false,
    ["Optimizer"] = false
}

local function SaveConfig()
    local ok = pcall(function()
        if writefile then
            writefile(ConfigFileName, HttpService:JSONEncode(_G.Enabled))
        end
    end)
    return ok
end

local function LoadConfig()
    pcall(function()
        if isfile and isfile(ConfigFileName) then
            local data = HttpService:JSONDecode(readfile(ConfigFileName))
            for k, v in pairs(data) do _G.Enabled[k] = v end
        end
    end)
end
LoadConfig()

local CrystalPurple = Color3.fromRGB(120, 0, 255)
local DarkColor = Color3.fromRGB(0, 0, 0)
local GlobalRadius = UDim.new(0, 15)
local UnifiedStroke = 1.2
local UnifiedFontSize = 10

for _, child in pairs(CoreGui:GetChildren()) do
    if child:IsA("ScreenGui") and child.Name:find("Crystal") then child:Destroy() end
end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "Crystal_Unified_Pro"

local function SmoothTween(obj, goal)
    TweenService:Create(obj, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), goal):Play()
end

local HUDContainer = Instance.new("Frame", ScreenGui)
HUDContainer.Size = UDim2.new(0, 230, 0, 70)
HUDContainer.Position = UDim2.new(0.5, -115, 0.02, 0)
HUDContainer.BackgroundTransparency = 1

local TopBar = Instance.new("Frame", HUDContainer)
TopBar.Size = UDim2.new(0.9, 0, 0, 28)
TopBar.Position = UDim2.new(0.05, 0, 0, 0)
TopBar.BackgroundColor3 = DarkColor
TopBar.BackgroundTransparency = 0.2
Instance.new("UICorner", TopBar).CornerRadius = GlobalRadius

local TopS = Instance.new("UIStroke", TopBar)
TopS.Color = CrystalPurple
TopS.Thickness = UnifiedStroke

local Info = Instance.new("TextLabel", TopBar)
Info.Size = UDim2.new(1, 0, 1, 0)
Info.BackgroundTransparency = 1
Info.TextColor3 = Color3.fromRGB(255, 255, 255)
Info.Font = Enum.Font.GothamBold
Info.TextSize = UnifiedFontSize
Info.Text = "Crystal Hub | FPS ... | MS ..."

local BottomBar = Instance.new("Frame", HUDContainer)
BottomBar.Size = UDim2.new(0.9, 0, 0, 14)
BottomBar.Position = UDim2.new(0.05, 0, 0, 35)
BottomBar.BackgroundTransparency = 1

local function CreateStatBox(pos, size, txt, trans)
    local f = Instance.new("Frame", BottomBar)
    f.Size = size
    f.Position = pos
    f.BackgroundColor3 = DarkColor
    f.BackgroundTransparency = trans
    Instance.new("UICorner", f).CornerRadius = GlobalRadius
    local s = Instance.new("UIStroke", f)
    s.Color = CrystalPurple
    s.Thickness = 1
    local t = Instance.new("TextLabel", f)
    t.Size = UDim2.new(1, 0, 1, 0)
    t.BackgroundTransparency = 1
    t.TextColor3 = Color3.fromRGB(255, 255, 255)
    t.Font = Enum.Font.GothamBold
    t.TextSize = 9
    t.Text = txt
end

CreateStatBox(UDim2.new(0, 0, 0, 0), UDim2.new(0.48, 0, 1, 0), "0%", 0.5)
CreateStatBox(UDim2.new(0.52, 0, 0, 0), UDim2.new(0.48, 0, 1, 0), "7.4", 0.15)

local MainMenu = Instance.new("Frame", ScreenGui)
MainMenu.Size = UDim2.new(0, 180, 0, 285)
MainMenu.Position = UDim2.new(-0.7, 0, 0.5, -142)
MainMenu.BackgroundColor3 = DarkColor
MainMenu.BackgroundTransparency = 0.4
Instance.new("UICorner", MainMenu).CornerRadius = GlobalRadius

local MenuS = Instance.new("UIStroke", MainMenu)
MenuS.Color = CrystalPurple
MenuS.Thickness = 1.5

local function CreateToggle(name, parent)
    local btn = Instance.new("TextButton", parent)
    btn.BackgroundColor3 = _G.Enabled[name] and CrystalPurple or DarkColor
    btn.BackgroundTransparency = _G.Enabled[name] and 0 or 0.3
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = UnifiedFontSize
    btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = GlobalRadius
    local s = Instance.new("UIStroke", btn)
    s.Color = CrystalPurple
    s.Thickness = UnifiedStroke
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    btn.MouseButton1Click:Connect(function()
        _G.Enabled[name] = not _G.Enabled[name]
        local active = _G.Enabled[name]
        SmoothTween(btn, {
            BackgroundColor3 = active and CrystalPurple or DarkColor,
            BackgroundTransparency = active and 0 or 0.3
        })
        -- تشغيل التفعيلة
        if name == "Player Esp" then
            toggleESP(active)
        elseif name == "Bat Aimbot" then
            if active then startBatAimbot() else stopBatAimbot() end
        elseif name == "Steal Near" then
            if active then startStealNearest() else stopStealNearest() end
        elseif name == "Auto Medusa" then
            -- handled in loop
        elseif name == "Anti Fling" then
            if active then startAntiFling() else stopAntiFling() end
        elseif name == "Anti Ragdoll" then
            if active then startAntiRagdoll() else stopAntiRagdoll() end
        elseif name == "Un Walk" then
            if active then startUnWalk() else stopUnWalk() end
        elseif name == "Inf Jump" then
            InfiniteJumpState = active
            if active then startInfJump() else stopInfJump() end
        elseif name == "Spin Bot" then
            if active then startSpin() else stopSpin() end
        elseif name == "Optimizer" then
            if active then enableOptimizer() else disableOptimizer() end
        end
    end)
    return btn
end

local features = {"Player Esp", "Bat Aimbot", "Steal Near", "Auto Medusa", "Auto Play", "Anti Fling", "Anti Ragdoll", "Un Walk", "Inf Jump", "Spin Bot", "Optimizer"}
local EspBtn = CreateToggle("Player Esp", MainMenu)
EspBtn.Size = UDim2.new(1, -20, 0, 30)
EspBtn.Position = UDim2.new(0, 10, 0, 15)

local Grid = Instance.new("Frame", MainMenu)
Grid.Size = UDim2.new(1, -20, 0, 180)
Grid.Position = UDim2.new(0, 10, 0, 55)
Grid.BackgroundTransparency = 1

local UIGrid = Instance.new("UIGridLayout", Grid)
UIGrid.CellSize = UDim2.new(0, 75, 0, 28)
UIGrid.CellPadding = UDim2.new(0, 10, 0, 8)

for i = 2, #features do
    CreateToggle(features[i], Grid)
end

local SaveBtn = Instance.new("TextButton", MainMenu)
SaveBtn.Size = UDim2.new(1, -20, 0, 30)
SaveBtn.Position = UDim2.new(0, 10, 1, -45)
SaveBtn.BackgroundColor3 = DarkColor
SaveBtn.BackgroundTransparency = 0.3
SaveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SaveBtn.Text = "Save Config"
SaveBtn.Font = Enum.Font.GothamBold
SaveBtn.TextSize = UnifiedFontSize
SaveBtn.AutoButtonColor = false
Instance.new("UICorner", SaveBtn).CornerRadius = GlobalRadius

local SaveS = Instance.new("UIStroke", SaveBtn)
SaveS.Color = CrystalPurple
SaveS.Thickness = UnifiedStroke
SaveS.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

SaveBtn.MouseButton1Click:Connect(function()
    SaveConfig()
    SaveBtn.Text = "Config Saved"
    SmoothTween(SaveBtn, {BackgroundColor3 = CrystalPurple, BackgroundTransparency = 0})
    task.delay(1, function()
        SaveBtn.Text = "Save Config"
        SmoothTween(SaveBtn, {BackgroundColor3 = DarkColor, BackgroundTransparency = 0.3})
    end)
end)

local SideButton = Instance.new("TextButton", ScreenGui)
SideButton.Size = UDim2.new(0, 50, 0, 50)
SideButton.Position = UDim2.new(1, -65, 0.20, 0)
SideButton.BackgroundColor3 = CrystalPurple
SideButton.Text = ""
SideButton.BorderSizePixel = 0
Instance.new("UICorner", SideButton).CornerRadius = GlobalRadius

local SideStroke = Instance.new("UIStroke", SideButton)
SideStroke.Color = Color3.fromRGB(255, 255, 255)
SideStroke.Thickness = 1.5

for i = 0, 2 do
    local line = Instance.new("Frame", SideButton)
    line.Size = UDim2.new(0, 24, 0, 4)
    line.Position = UDim2.new(0.5, -12, 0, 15 + (i * 9))
    line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    line.BorderSizePixel = 0
    Instance.new("UICorner", line).CornerRadius = UDim.new(0, 2)
end

-- ========== SPEED LABEL ==========
local SpeedLabel = nil

local function CreateSpeedTag(char)
    local head = char:WaitForChild("Head", 5)
    if not head then return end
    local billboard = Instance.new("BillboardGui", head)
    billboard.Name = "SpeedTag"
    billboard.Size = UDim2.new(0, 100, 0, 30)
    billboard.StudsOffset = Vector3.new(0, 2.2, 0)
    billboard.AlwaysOnTop = true
    local label = Instance.new("TextLabel", billboard)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 12
    label.Text = "Speed: 0.0"
    local stroke = Instance.new("UIStroke", label)
    stroke.Color = Color3.fromRGB(0, 0, 0)
    stroke.Thickness = 1.5
    stroke.Transparency = 0.4
    SpeedLabel = label
end

Player.CharacterAdded:Connect(CreateSpeedTag)
if Player.Character then CreateSpeedTag(Player.Character) end

task.spawn(function()
    while true do
        RunService.RenderStepped:Wait()
        pcall(function()
            if SpeedLabel and Player.Character then
                local hrp = Player.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local vel = hrp.AssemblyLinearVelocity
                    local horizontalSpeed = math.floor(Vector3.new(vel.X, 0, vel.Z).Magnitude * 10) / 10
                    SpeedLabel.Text = string.format("Speed: %.1f", horizontalSpeed)
                end
            end
        end)
    end
end)

-- ========== ESP PLAYER ==========
local espConnections = {}

local function createESP(plr)
    if plr == Player then return end
    if not plr.Character then return end
    if plr.Character:FindFirstChild("ESP_BLUE") then return end
    local char = plr.Character
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP_BLUE"
    highlight.FillColor = CrystalPurple
    highlight.OutlineColor = CrystalPurple
    highlight.FillTransparency = 0.2
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = char
    local head = char:FindFirstChild("Head")
    if head then
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "ESP_Name"
        billboard.Adornee = head
        billboard.Size = UDim2.new(0, 200, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 2.5, 0)
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
                    if _G.Enabled["Player Esp"] then createESP(plr) end
                end)
                table.insert(espConnections, conn)
            end
        end
        local conn = Players.PlayerAdded:Connect(function(plr)
            if plr == Player then return end
            local c = plr.CharacterAdded:Connect(function()
                task.wait(0.2)
                if _G.Enabled["Player Esp"] then createESP(plr) end
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

if _G.Enabled["Player Esp"] then toggleESP(true) end

-- ========== BAT AIMBOT ==========
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

if _G.Enabled["Bat Aimbot"] then AimbotState = true startBatAimbot() end

-- ========== STEAL NEAREST ==========
local StealNearestState = false
local isStealing = false
local stealStartTime = nil
local progressConnection = nil
local StealData = {}
local STEAL_DURATION = 0.35
local STEAL_RADIUS = 10

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
    if _G.Enabled["Steal Near"] then
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
    ScreenProgressFrame.Position = UDim2.new(0.5, -150, 0.1, 0)
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
createProgressBar()

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

local stealConn = nil
local function startStealNearest()
    if stealConn then return end
    stealConn = RunService.Heartbeat:Connect(function()
        if not StealNearestState or isStealing then return end
        local p, _, n = findNearestPrompt()
        if p then executeSteal(p, n) end
    end)
end

local function stopStealNearest()
    if stealConn then stealConn:Disconnect() stealConn = nil end
    isStealing = false
    ResetProgressBar()
end

if _G.Enabled["Steal Near"] then StealNearestState = true startStealNearest() end

-- ========== AUTO MEDUSA ==========
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
    if _G.Enabled["Auto Medusa"] then
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
        if _G.Enabled["Auto Medusa"] then
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

-- ========== AUTO PLAY (LEFT / RIGHT) ==========
local leftPathActive = false
local rightPathActive = false
local lastFlatVel = Vector3.zero
local PATH_VELOCITY_SPEED = 60
local PATH_SECOND_SPEED = 30
local PATH_BASE_STOP = 1.35
local PATH_MIN_STOP = 0.65
local PATH_NEXT_POINT_BIAS = 0.45
local PATH_SMOOTH_FACTOR = 0.12

local path_Right = {
    {pos = Vector3.new(-470.6, -5.9, 34.4)},
    {pos = Vector3.new(-484.2, -3.9, 21.4)},
    {pos = Vector3.new(-475.6, -5.8, 29.3)},
    {pos = Vector3.new(-473.4, -5.9, 111.0)}
}

local path_Left = {
    {pos = Vector3.new(-474.7, -5.9, 91.0)},
    {pos = Vector3.new(-483.4, -3.9, 97.3)},
    {pos = Vector3.new(-474.7, -5.9, 91.0)},
    {pos = Vector3.new(-476.1, -5.5, 25.4)}
}

local function pathMoveToPoint(hrp, current, nextPoint, speed)
    local conn
    conn = RunService.Heartbeat:Connect(function()
        if not (leftPathActive or rightPathActive) then
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
    while (leftPathActive or rightPathActive) and (Vector3.new(hrp.Position.X, 0, hrp.Position.Z) - Vector3.new(current.X, 0, current.Z)).Magnitude > PATH_BASE_STOP do
        RunService.Heartbeat:Wait()
    end
end

local function runLeftPath()
    local hrp = (Player.Character or Player.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart")
    for i, p in ipairs(path_Left) do
        if not leftPathActive then return end
        local speed = i > 2 and PATH_SECOND_SPEED or PATH_VELOCITY_SPEED
        local nextP = path_Left[i + 1] and path_Left[i + 1].pos
        pathMoveToPoint(hrp, p.pos, nextP, speed)
        if i == 2 then task.wait(0.2) else task.wait(0.01) end
    end
end

local function runRightPath()
    local hrp = (Player.Character or Player.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart")
    for i, p in ipairs(path_Right) do
        if not rightPathActive then return end
        local speed = i > 2 and PATH_SECOND_SPEED or PATH_VELOCITY_SPEED
        local nextP = path_Right[i + 1] and path_Right[i + 1].pos
        pathMoveToPoint(hrp, p.pos, nextP, speed)
        if i == 2 then task.wait(0.2) else task.wait(0.01) end
    end
end

local function startLeftSteal()
    if leftPathActive then return end
    leftPathActive = true
    task.spawn(function()
        while leftPathActive and _G.Enabled["Auto Play"] do
            runLeftPath()
            task.wait(0.1)
        end
    end)
end

local function stopLeftSteal()
    leftPathActive = false
    local hrp = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then hrp.AssemblyLinearVelocity = Vector3.zero end
end

local function startRightSteal()
    if rightPathActive then return end
    rightPathActive = true
    task.spawn(function()
        while rightPathActive and _G.Enabled["Auto Play"] do
            runRightPath()
            task.wait(0.1)
        end
    end)
end

local function stopRightSteal()
    rightPathActive = false
    local hrp = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then hrp.AssemblyLinearVelocity = Vector3.zero end
end

-- ========== ANTI FLING ==========
local antiFlingConn = nil
local function startAntiFling()
    if antiFlingConn then return end
    antiFlingConn = RunService.Heartbeat:Connect(function()
        if _G.Enabled["Anti Fling"] and Player.Character then
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
if _G.Enabled["Anti Fling"] then startAntiFling() end

-- ========== ANTI RAGDOLL ==========
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
if _G.Enabled["Anti Ragdoll"] then startAntiRagdoll() end

-- ========== UN WALK ==========
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

local function startUnWalk()
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

local function stopUnWalk()
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
if _G.Enabled["Un Walk"] then startUnWalk() end

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
if _G.Enabled["Inf Jump"] then InfiniteJumpState = true startInfJump() end

-- ========== SPIN BOT ==========
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
if _G.Enabled["Spin Bot"] then startSpin() end

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
if _G.Enabled["Optimizer"] then enableOptimizer() end

-- ========== DRAG & UPDATES ==========
local dragging, dragStart, startPos, menuOpen = false, nil, nil, false

SideButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging, dragStart, startPos = true, input.Position, SideButton.Position
        local startTick = tick()
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
                if (tick() - startTick) < 0.25 and (input.Position - dragStart).Magnitude < 5 then
                    menuOpen = not menuOpen
                    MainMenu:TweenPosition(UDim2.new(menuOpen and 0.02 or -0.7, 0, 0.5, -142), "Out", "Quart", 0.4, true)
                end
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        SideButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            local fps = math.floor(1 / RunService.RenderStepped:Wait())
            local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            Info.Text = "Crystal Hub | FPS " .. fps .. " | MS " .. ping
        end)
    end
end)

print("Crystal Hub Loaded Successfully!")
