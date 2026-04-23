-- [[ Crystal Hub - Extended Version ]] --

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- الألوان والشفافية الأصلية
local CrystalPurple = Color3.fromRGB(120, 0, 255) 
local RightPartColor = Color3.fromRGB(0, 0, 0)
local RightPartTrans = 0.15 
local LeftPartTrans = 0.5   

-- نظام التبديل (Toggles) لجميع الأزرار
local Toggles = {
    Esp = false,
    Aimbot = false,
    Steal = false,
    AutoPlay = false,
    AutoMedusa = false,
    Down = false,
    Drop = false,
    AntiRagdoll = false, -- جديد
    AntiFling = false,   -- جديد
    InfJump = false,     -- جديد
    NoWalkAnim = false   -- جديد
}

-- تنظيف النسخ السابقة
local function Cleanup()
    if CoreGui:FindFirstChild("Crystal_Restored_UI") then 
        CoreGui:FindFirstChild("Crystal_Restored_UI"):Destroy() 
    end
end
Cleanup()

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "Crystal_Restored_UI"
ScreenGui.ResetOnSpawn = false

-- [[ اللوحة العلوية ]] --
local MainContainer = Instance.new("Frame", ScreenGui)
MainContainer.Size = UDim2.new(0, 250, 0, 60); MainContainer.Position = UDim2.new(0.5, -125, 0.18, 0); MainContainer.BackgroundTransparency = 1

local TopBar = Instance.new("Frame", MainContainer)
TopBar.Size = UDim2.new(1, 0, 0, 34); TopBar.BackgroundColor3 = Color3.fromRGB(0,0,0); TopBar.BackgroundTransparency = 0.15
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 10)
local TopStroke = Instance.new("UIStroke", TopBar); TopStroke.Color = CrystalPurple; TopStroke.Thickness = 2

local InfoLabel = Instance.new("TextLabel", TopBar)
InfoLabel.Size = UDim2.new(1, 0, 1, 0); InfoLabel.BackgroundTransparency = 1; InfoLabel.TextColor3 = CrystalPurple; InfoLabel.TextSize = 13; InfoLabel.Font = Enum.Font.GothamBold; InfoLabel.Text = "Crystal Hub | Active"

-- [[ المنيو الجانبي - تم زيادة الطول ليستوعب الأزرار الجديدة ]] --
local SideMenu = Instance.new("Frame", ScreenGui)
SideMenu.Size = UDim2.new(0, 160, 0, 380); SideMenu.Position = UDim2.new(-0.7, 0, 0.3, 0)
SideMenu.BackgroundColor3 = Color3.fromRGB(0,0,0); SideMenu.BackgroundTransparency = LeftPartTrans
Instance.new("UICorner", SideMenu).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", SideMenu).Color = CrystalPurple

local UIList = Instance.new("UIListLayout", SideMenu); UIList.Padding = UDim.new(0, 7); UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
Instance.new("UIPadding", SideMenu).PaddingTop = UDim.new(0, 12)

-- وظيفة إنشاء الأزرار
local function CreateBtn(txt, parent, size, toggleKey)
    local btn = Instance.new("TextButton", parent)
    btn.Size = size or UDim2.new(0, 140, 0, 36)
    btn.BackgroundColor3 = RightPartColor; btn.BackgroundTransparency = RightPartTrans; btn.Text = txt; btn.TextColor3 = Color3.fromRGB(255,255,255); btn.Font = Enum.Font.GothamBold; btn.TextSize = 10
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
    Instance.new("UIStroke", btn).Color = CrystalPurple

    btn.MouseButton1Click:Connect(function()
        Toggles[toggleKey] = not Toggles[toggleKey]
        local active = Toggles[toggleKey]
        btn.BackgroundColor3 = active and CrystalPurple or RightPartColor
        btn.BackgroundTransparency = active and 0 or RightPartTrans
    end)
end

local function Row(p)
    local f = Instance.new("Frame", p); f.Size = UDim2.new(0, 140, 0, 32); f.BackgroundTransparency = 1
    local l = Instance.new("UIListLayout", f); l.FillDirection = Enum.FillDirection.Horizontal; l.Padding = UDim.new(0, 8); l.HorizontalAlignment = Enum.HorizontalAlignment.Center
    return f
end

-- [[ الأزرار بالترتيب المطلوب ]] --

-- 1. Esp Player في القمة
CreateBtn("Esp Player", SideMenu, nil, "Esp")

-- 2. الصف الأول
local R1 = Row(SideMenu)
CreateBtn("AimBot", R1, UDim2.new(0, 66, 1, 0), "Aimbot")
CreateBtn("Steal Nearest", R1, UDim2.new(0, 66, 1, 0), "Steal")

-- 3. الصف الثاني
local R2 = Row(SideMenu)
CreateBtn("Auto Play", R2, UDim2.new(0, 66, 1, 0), "AutoPlay")
CreateBtn("Auto Medusa", R2, UDim2.new(0, 66, 1, 0), "AutoMedusa")

-- 4. الصف الثالث
local R3 = Row(SideMenu)
CreateBtn("Down", R3, UDim2.new(0, 66, 1, 0), "Down")
CreateBtn("Drop", R3, UDim2.new(0, 66, 1, 0), "Drop")

-- 5. الصف الرابع (الجديد)
local R4 = Row(SideMenu)
CreateBtn("Anti Ragdoll", R4, UDim2.new(0, 66, 1, 0), "AntiRagdoll")
CreateBtn("Anti Fling", R4, UDim2.new(0, 66, 1, 0), "AntiFling")

-- 6. الصف الخامس (الجديد)
local R5 = Row(SideMenu)
CreateBtn("Infinite Jump", R5, UDim2.new(0, 66, 1, 0), "InfJump")
CreateBtn("No Walk Animation", R5, UDim2.new(0, 66, 1, 0), "NoWalkAnim")

-- [[ الأيقونة العائمة ]] --
local SideButton = Instance.new("TextButton", ScreenGui)
SideButton.Size = UDim2.new(0, 60, 0, 60); SideButton.Position = UDim2.new(1, -75, 0.30, 0); SideButton.BackgroundColor3 = CrystalPurple; SideButton.Text = ""; SideButton.BorderSizePixel = 0
Instance.new("UICorner", SideButton).CornerRadius = UDim.new(0, 10)

local menuOpen = false
SideButton.MouseButton1Click:Connect(function()
    menuOpen = not menuOpen
    SideMenu:TweenPosition(UDim2.new(menuOpen and 0.02 or -0.7, 0, 0.3, 0), "Out", "Quart", 0.4, true)
end)

-- [ تحديث الإحصائيات ] --
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
