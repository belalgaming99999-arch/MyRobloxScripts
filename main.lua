-- [[ Crystal Hub - Dynamic Progress Background Edition ]] --

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local UserInputService = game:GetService("UserInputService")
local Player = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

local CrystalPurple = Color3.fromRGB(120, 0, 255)
local DarkColor = Color3.fromRGB(0, 0, 0)
local CornerRadius = UDim.new(0, 15)

-- تنظيف النسخ القديمة
for _, child in pairs(CoreGui:GetChildren()) do
    if child:IsA("ScreenGui") and child.Name:find("Crystal") then child:Destroy() end
end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "Crystal_Steal_FX"
ScreenGui.ResetOnSpawn = false

-- ========== المنيو الجانبي مع خاصية التعبئة ==========
local MainMenu = Instance.new("Frame", ScreenGui)
MainMenu.Size = UDim2.new(0, 160, 0, 420)
MainMenu.Position = UDim2.new(-0.7, 0, 0.3, 0)
MainMenu.BackgroundColor3 = DarkColor
MainMenu.BackgroundTransparency = 0.6 -- الشفافية الأساسية
Instance.new("UICorner", MainMenu).CornerRadius = CornerRadius
Instance.new("UIStroke", MainMenu).Color = CrystalPurple

-- شريط التعبئة (Progress Fill) مخفي في البداية
local ProgressFill = Instance.new("Frame", MainMenu)
ProgressFill.Size = UDim2.new(0, 0, 1, 0) -- يبدأ بعرض صفر
ProgressFill.BackgroundColor3 = DarkColor
ProgressFill.BackgroundTransparency = 0.15 -- اللون الغامق (مثل اليمين)
ProgressFill.BorderSizePixel = 0
ProgressFill.ZIndex = 0 -- يكون خلف الأزرار
Instance.new("UICorner", ProgressFill).CornerRadius = CornerRadius

local UIList = Instance.new("UIListLayout", MainMenu); UIList.Padding = UDim.new(0, 7); UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center; UIList.SortOrder = Enum.SortOrder.LayoutOrder
Instance.new("UIPadding", MainMenu).PaddingTop = UDim.new(0, 12)

-- وظيفة محاكاة التعبئة عند السرقة
local function StartStealEffect(duration)
    duration = duration or 0.35
    ProgressFill.Size = UDim2.new(0, 0, 1, 0)
    local tween = game:GetService("TweenService"):Create(ProgressFill, TweenInfo.new(duration, Enum.EasingStyle.Linear), {Size = UDim2.new(1, 0, 1, 0)})
    tween:Play()
    tween.Completed:Connect(function()
        task.wait(0.1)
        ProgressFill.Size = UDim2.new(0, 0, 1, 0) -- يصفر العرض بعد الانتهاء
    end)
end

-- ========== العناصر العلوية ==========
local TopBar = Instance.new("Frame", ScreenGui)
TopBar.Size = UDim2.new(0, 250, 0, 34); TopBar.Position = UDim2.new(0.5, -125, 0.05, 0); TopBar.BackgroundColor3 = DarkColor; TopBar.BackgroundTransparency = 0.15
Instance.new("UICorner", TopBar).CornerRadius = CornerRadius
Instance.new("UIStroke", TopBar).Color = CrystalPurple

local InfoLabel = Instance.new("TextLabel", TopBar)
InfoLabel.Size = UDim2.new(1, 0, 1, 0); InfoLabel.BackgroundTransparency = 1; InfoLabel.TextColor3 = CrystalPurple; InfoLabel.Font = Enum.Font.GothamBold; InfoLabel.Text = "Crystal Hub | Running"

-- وظيفة إنشاء الأزرار
local function CreateBtn(txt, parent, size, toggleKey, action)
    local btn = Instance.new("TextButton", parent)
    btn.Size = size or UDim2.new(0, 140, 0, 36)
    btn.BackgroundColor3 = DarkColor; btn.BackgroundTransparency = 0.2; btn.ZIndex = 1
    btn.Text = txt; btn.TextColor3 = Color3.fromRGB(255, 255, 255); btn.Font = Enum.Font.GothamBold; btn.TextSize = 10
    Instance.new("UICorner", btn).CornerRadius = CornerRadius
    Instance.new("UIStroke", btn).Color = CrystalPurple

    btn.MouseButton1Click:Connect(function()
        if toggleKey then
            -- إذا ضغطت على Steal Nearest، شغل تأثير التعبئة
            if toggleKey == "StealNearest" then StartStealEffect(0.35) end
            
            _G[toggleKey] = not _G[toggleKey]
            btn.BackgroundColor3 = _G[toggleKey] and CrystalPurple or DarkColor
            btn.BackgroundTransparency = _G[toggleKey] and 0 or 0.2
        end
        if action then action() end
    end)
end

local function Row(p)
    local f = Instance.new("Frame", p); f.Size = UDim2.new(0, 140, 0, 32); f.BackgroundTransparency = 1; f.ZIndex = 1
    local l = Instance.new("UIListLayout", f); l.FillDirection = Enum.FillDirection.Horizontal; l.Padding = UDim.new(0, 8); l.HorizontalAlignment = Enum.HorizontalAlignment.Center
    return f
end

-- بناء المنيو
CreateBtn("Esp Player", MainMenu, nil, "Esp")
local R1 = Row(MainMenu); CreateBtn("Bat Aimbot", R1, UDim2.new(0, 66, 1, 0), "BatAimbot"); CreateBtn("Steal Nearest", R1, UDim2.new(0, 66, 1, 0), "StealNearest")
local R2 = Row(MainMenu); CreateBtn("Auto Medusa", R2, UDim2.new(0, 66, 1, 0), "AutoMedusa"); CreateBtn("Auto Play", R2, UDim2.new(0, 66, 1, 0), nil, function() end)

-- ========== الأيقونة العائمة ==========
local SideButton = Instance.new("TextButton", ScreenGui)
SideButton.Size = UDim2.new(0, 60, 0, 60); SideButton.Position = UDim2.new(1, -80, 0.5, 0); SideButton.BackgroundColor3 = CrystalPurple; SideButton.Text = ""
Instance.new("UICorner", SideButton).CornerRadius = CornerRadius

for i = 0, 2 do
    local l = Instance.new("Frame", SideButton); l.Size = UDim2.new(0, 30, 0, 4); l.Position = UDim2.new(0.5, -15, 0, 18 + (i * 10)); l.BackgroundColor3 = Color3.fromRGB(255, 255, 255); Instance.new("UICorner", l).CornerRadius = UDim.new(0, 2)
end

local menuOpen = false
local dragging, dragStart, startPos, clickDetector

SideButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = SideButton.Position; clickDetector = input.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        SideButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

SideButton.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
        if clickDetector and (input.Position - clickDetector).Magnitude < 8 then
            menuOpen = not menuOpen
            MainMenu:TweenPosition(UDim2.new(menuOpen and 0.02 or -0.7, 0, 0.3, 0), "Out", "Quart", 0.4, true)
        end
    end
end)
