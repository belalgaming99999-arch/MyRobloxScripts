-- [[ Crystal Hub - Super Stable Version v2 ]] --

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Player = Players.LocalPlayer

-- الألوان الموحدة
local CrystalPurple = Color3.fromRGB(120, 0, 255) 
local RightPartColor = Color3.fromRGB(0, 0, 0)
local RightPartTrans = 0.15 
local LeftPartTrans = 0.5   

-- المتغيرات التقنية للميزات
local Settings = {
    Aimbot = false,
    Spin = false,
    Unwalk = true,
    AntiRagdoll = true,
    LockSpeed = 59
}

-- 1. تنظيف شامل
local function FinalCleanup()
    local all_guis = {game:GetService("CoreGui"), Player:WaitForChild("PlayerGui")}
    for _, parent in pairs(all_guis) do
        for _, child in pairs(parent:GetChildren()) do
            if child:IsA("ScreenGui") and (child.Name:find("Crystal") or child.Name == "Crystal_Final_Safe") then
                child:Destroy()
            end
        end
    end
end
FinalCleanup()

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Crystal_Stable_Final"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 9999

local success = pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not success then ScreenGui.Parent = Player:WaitForChild("PlayerGui") end

-- وظيفة السحب
local function MakeDraggable(gui)
    local dragging, dragStart, startPos
    local moved = false
    gui.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            dragging = true; moved = false; dragStart = input.Position; startPos = gui.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            if delta.Magnitude > 2 then 
                moved = true
                gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end
    end)
    gui.InputEnded:Connect(function() dragging = false end)
    return function() return not moved end 
end

-- [[ اللوحة العلوية والسفلية ]] --
local MainContainer = Instance.new("Frame", ScreenGui)
MainContainer.Size = UDim2.new(0, 250, 0, 60); MainContainer.Position = UDim2.new(0.5, -125, 0.18, 0); MainContainer.BackgroundTransparency = 1
MakeDraggable(MainContainer)

local TopBar = Instance.new("Frame", MainContainer)
TopBar.Size = UDim2.new(1, 0, 0, 34); TopBar.BackgroundColor3 = Color3.fromRGB(0,0,0); TopBar.BackgroundTransparency = 0.15; TopBar.BorderSizePixel = 0
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 10)
local TopStroke = Instance.new("UIStroke", TopBar)
TopStroke.Color = CrystalPurple; TopStroke.Thickness = 2; TopStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local InfoLabel = Instance.new("TextLabel", TopBar)
InfoLabel.Size = UDim2.new(1, 0, 1, 0); InfoLabel.BackgroundTransparency = 1; InfoLabel.TextColor3 = CrystalPurple; InfoLabel.TextSize = 13; InfoLabel.Font = Enum.Font.GothamBold
InfoLabel.Text = "Crystal Hub | Initializing..."

-- [[ المنيو الجانبي ]] --
local SideMenu = Instance.new("Frame", ScreenGui)
SideMenu.Size = UDim2.new(0, 160, 0, 320); SideMenu.Position = UDim2.new(-0.7, 0, 0.35, 0)
SideMenu.BackgroundColor3 = Color3.fromRGB(0,0,0); SideMenu.BackgroundTransparency = LeftPartTrans; SideMenu.BorderSizePixel = 0
Instance.new("UICorner", SideMenu).CornerRadius = UDim.new(0, 10)
local SideStroke = Instance.new("UIStroke", SideMenu); SideStroke.Color = CrystalPurple; SideStroke.Thickness = 2

local UIList = Instance.new("UIListLayout", SideMenu)
UIList.Padding = UDim.new(0, 7); UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
Instance.new("UIPadding", SideMenu).PaddingTop = UDim.new(0, 12)

-- وظيفة إنشاء الأزرار المربوطة بالأكشن
local function CreateBtn(txt, parent, size, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = size or UDim2.new(0, 140, 0, 36)
    btn.BackgroundColor3 = RightPartColor; btn.BackgroundTransparency = RightPartTrans; btn.BorderSizePixel = 0
    btn.Text = txt; btn.TextColor3 = Color3.fromRGB(255,255,255); btn.Font = Enum.Font.GothamBold; btn.TextSize = 10
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
    local s = Instance.new("UIStroke", btn); s.Color = CrystalPurple; s.Thickness = 1.5; s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    
    local active = false
    btn.MouseButton1Click:Connect(function()
        active = not active
        btn.BackgroundColor3 = active and CrystalPurple or RightPartColor
        btn.BackgroundTransparency = active and 0 or RightPartTrans
        if callback then callback(active) end
    end)
    return btn
end

-- ميزات المنيو
CreateBtn("Esp Player", SideMenu, nil, function(state) print("ESP State:", state) end)

local function Row(p)
    local f = Instance.new("Frame", p); f.Size = UDim2.new(0, 140, 0, 32); f.BackgroundTransparency = 1
    local l = Instance.new("UIListLayout", f); l.FillDirection = Enum.FillDirection.Horizontal; l.Padding = UDim.new(0, 8); l.HorizontalAlignment = Enum.HorizontalAlignment.Center
    return f
end

-- زر Aimbot
local R1 = Row(SideMenu)
CreateBtn("AimBot", R1, UDim2.new(0, 66, 1, 0), function(state) Settings.Aimbot = state end)
-- زر Spin
CreateBtn("Spin Bot", R1, UDim2.new(0, 66, 1, 0), function(state) Settings.Spin = state end)

local R2 = Row(SideMenu)
CreateBtn("Auto Medusa", R2, UDim2.new(0, 140, 1, 0), function(state) print("Medusa Active") end)

-- [[ ميزات الحركة التلقائية ]] --

-- 1. Anti-Ragdoll & Unwalk
RunService.Heartbeat:Connect(function()
    local char = Player.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        local hum = char:FindFirstChildOfClass("Humanoid")
        
        -- Unwalk logic
        if Settings.Unwalk then
            local animator = hum:FindFirstChildOfClass("Animator")
            if animator then
                for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                    if track.Name:lower():find("walk") or track.Name:lower():find("run") then
                        track:Stop(0)
                    end
                end
            end
        end

        -- Anti Ragdoll logic
        if Settings.AntiRagdoll then
            if hum:GetState() == Enum.HumanoidStateType.Physics or hum:GetState() == Enum.HumanoidStateType.Ragdoll then
                hum:ChangeState(Enum.HumanoidStateType.Running)
                if char:FindFirstChild("HumanoidRootPart") then
                    char.HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
                end
            end
        end
        
        -- Spin Bot logic
        if Settings.Spin and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 100, 0)
        end
    end
end)

-- [[ الأيقونة العائمة ]] --
local SideButton = Instance.new("TextButton", ScreenGui)
SideButton.Size = UDim2.new(0, 60, 0, 60); SideButton.Position = UDim2.new(1, -75, 0.30, 0); SideButton.BackgroundColor3 = CrystalPurple; SideButton.Text = ""; SideButton.BorderSizePixel = 0
Instance.new("UICorner", SideButton).CornerRadius = UDim.new(0, 10)
local canOpen = MakeDraggable(SideButton) 

for i=0,2 do
    local line = Instance.new("Frame", SideButton)
    line.Size = UDim2.new(0, 28, 0, 4); line.Position = UDim2.new(0.5, -14, 0, 18 + (i * 10)); line.BackgroundColor3 = Color3.fromRGB(255, 255, 255); line.BorderSizePixel = 0; Instance.new("UICorner", line).CornerRadius = UDim.new(0, 2)
end

local menuOpen = false
SideButton.MouseButton1Up:Connect(function()
    if canOpen() then 
        menuOpen = not menuOpen
        SideMenu:TweenPosition(UDim2.new(menuOpen and 0.02 or -0.7, 0, 0.35, 0), "Out", "Quart", 0.4, true)
    end
end)

-- تحديث الـ FPS والـ MS
task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            local fps = math.floor(1 / RunService.RenderStepped:Wait())
            InfoLabel.Text = string.format("Crystal Hub | FPS %d | MS %d", fps, ping)
        end)
    end
end)
        btn.BackgroundColor3 = active and CrystalPurple or RightPartColor
        btn.BackgroundTransparency = active and 0 or RightPartTrans
    end)
    return btn
end

-- زر ESP Player في القمة
CreateBtn("Esp Player", SideMenu)

local function Row(p)
    local f = Instance.new("Frame", p); f.Size = UDim2.new(0, 140, 0, 32); f.BackgroundTransparency = 1
    local l = Instance.new("UIListLayout", f); l.FillDirection = Enum.FillDirection.Horizontal; l.Padding = UDim.new(0, 8); l.HorizontalAlignment = Enum.HorizontalAlignment.Center
    return f
end

local R1 = Row(SideMenu); CreateBtn("AimBot", R1, UDim2.new(0, 66, 1, 0)); CreateBtn("Steal Nearest", R1, UDim2.new(0, 66, 1, 0))
local R2 = Row(SideMenu); CreateBtn("Auto Play", R2, UDim2.new(0, 66, 1, 0)); CreateBtn("Auto Medusa", R2, UDim2.new(0, 66, 1, 0))
local R3 = Row(SideMenu); CreateBtn("Down", R3, UDim2.new(0, 66, 1, 0)); CreateBtn("Drop", R3, UDim2.new(0, 66, 1, 0))

-- [[ الأيقونة العائمة ]] --
local SideButton = Instance.new("TextButton", ScreenGui)
SideButton.Size = UDim2.new(0, 60, 0, 60); SideButton.Position = UDim2.new(1, -75, 0.30, 0); SideButton.BackgroundColor3 = CrystalPurple; SideButton.Text = ""; SideButton.BorderSizePixel = 0
Instance.new("UICorner", SideButton).CornerRadius = UDim.new(0, 10)
local canOpen = MakeDraggable(SideButton) 

for i=0,2 do
    local line = Instance.new("Frame", SideButton)
    line.Size = UDim2.new(0, 28, 0, 4); line.Position = UDim2.new(0.5, -14, 0, 18 + (i * 10)); line.BackgroundColor3 = Color3.fromRGB(255, 255, 255); line.BorderSizePixel = 0; Instance.new("UICorner", line).CornerRadius = UDim.new(0, 2)
end

local menuOpen = false
SideButton.MouseButton1Up:Connect(function()
    if canOpen() then 
        menuOpen = not menuOpen
        SideMenu:TweenPosition(UDim2.new(menuOpen and 0.02 or -0.7, 0, 0.35, 0), "Out", "Quart", 0.4, true)
    end
end)

-- تحديث الـ FPS والـ MS (حل مشكلة التأخير في البداية)
local function UpdateStats()
    pcall(function()
        local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        local fps = math.floor(1 / RunService.RenderStepped:Wait())
        InfoLabel.Text = string.format("Crystal Hub | FPS %d | MS %d", fps, ping)
    end)
end

-- تشغيل التحديث فوراً
task.spawn(function()
    while task.wait(0.5) do -- تحديث أسرع (نصف ثانية)
        UpdateStats()
    end
end)
    
    btn.MouseButton1Click:Connect(function()
        local active = (btn.BackgroundColor3 == RightPartColor)
        btn.BackgroundColor3 = active and CrystalPurple or RightPartColor
        btn.BackgroundTransparency = active and 0 or RightPartTrans
    end)
    return btn
end

-- Esp Player في الأعلى
CreateBtn("Esp Player", SideMenu)

local function Row(p)
    local f = Instance.new("Frame", p); f.Size = UDim2.new(0, 140, 0, 32); f.BackgroundTransparency = 1
    local l = Instance.new("UIListLayout", f); l.FillDirection = Enum.FillDirection.Horizontal; l.Padding = UDim.new(0, 8); l.HorizontalAlignment = Enum.HorizontalAlignment.Center
    return f
end

local R1 = Row(SideMenu); CreateBtn("AimBot", R1, UDim2.new(0, 66, 1, 0)); CreateBtn("Steal Nearest", R1, UDim2.new(0, 66, 1, 0))
local R2 = Row(SideMenu); CreateBtn("Auto Play", R2, UDim2.new(0, 66, 1, 0)); CreateBtn("Auto Medusa", R2, UDim2.new(0, 66, 1, 0))
local R3 = Row(SideMenu); CreateBtn("Down", R3, UDim2.new(0, 66, 1, 0)); CreateBtn("Drop", R3, UDim2.new(0, 66, 1, 0))

-- [[ الأيقونة ]] --
local SideButton = Instance.new("TextButton", ScreenGui)
SideButton.Size = UDim2.new(0, 60, 0, 60); SideButton.Position = UDim2.new(1, -75, 0.30, 0); SideButton.BackgroundColor3 = CrystalPurple; SideButton.Text = ""; SideButton.BorderSizePixel = 0
Instance.new("UICorner", SideButton).CornerRadius = UDim.new(0, 8)
local canOpen = MakeDraggable(SideButton) 

for i=0,2 do
    local line = Instance.new("Frame", SideButton)
    line.Size = UDim2.new(0, 28, 0, 4); line.Position = UDim2.new(0.5, -14, 0, 18 + (i * 10)); line.BackgroundColor3 = Color3.fromRGB(255, 255, 255); line.BorderSizePixel = 0; Instance.new("UICorner", line).CornerRadius = UDim.new(0, 2)
end

local menuOpen = false
SideButton.MouseButton1Up:Connect(function()
    if canOpen() then 
        menuOpen = not menuOpen
        SideMenu:TweenPosition(UDim2.new(menuOpen and 0.02 or -0.7, 0, 0.35, 0), "Out", "Quart", 0.4, true)
    end
end)

task.spawn(function()
    while task.wait(1) do
        pcall(function()
            local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            local fps = math.floor(1 / RunService.RenderStepped:Wait())
            InfoLabel.Text = string.format("Crystal Hub | FPS %d | MS %d", fps, ping)
        end)
    end
end)
