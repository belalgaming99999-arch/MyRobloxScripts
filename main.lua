-- [[ Crystal Hub - Professional HUD Animation ]] --

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Player = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

local CrystalPurple = Color3.fromRGB(120, 0, 255)
local DarkColor = Color3.fromRGB(0, 0, 0)
local CornerRadius15 = UDim.new(0, 15)
local CornerRadius10 = UDim.new(0, 10)

-- تنظيف الشاشة
for _, child in pairs(CoreGui:GetChildren()) do
    if child:IsA("ScreenGui") and child.Name:find("Crystal") then child:Destroy() end
end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "Crystal_Final_Anim"
ScreenGui.ResetOnSpawn = false

-- ========== 1. اللوحة العلوية والسفلية (HUD) ==========
local HudContainer = Instance.new("Frame", ScreenGui)
HudContainer.Size = UDim2.new(0, 260, 0, 80)
HudContainer.Position = UDim2.new(0.5, -130, 0.05, 0)
HudContainer.BackgroundTransparency = 1

-- اللوحة العلوية
local TopBar = Instance.new("Frame", HudContainer)
TopBar.Size = UDim2.new(1, 0, 0, 38)
TopBar.BackgroundColor3 = DarkColor
TopBar.BackgroundTransparency = 0.15
Instance.new("UICorner", TopBar).CornerRadius = CornerRadius15
local TopStroke = Instance.new("UIStroke", TopBar); TopStroke.Color = CrystalPurple; TopStroke.Thickness = 1.5

local InfoLabel = Instance.new("TextLabel", TopBar)
InfoLabel.Size = UDim2.new(1, 0, 1, 0); InfoLabel.BackgroundTransparency = 1
InfoLabel.TextColor3 = CrystalPurple; InfoLabel.Font = Enum.Font.GothamBold; InfoLabel.TextSize = 14
InfoLabel.Text = "Crystal Hub | FPS: 0 | MS: 0"

-- اللوحة السفلية
local BottomBar = Instance.new("Frame", HudContainer)
BottomBar.Size = UDim2.new(1, 0, 0, 20)
BottomBar.Position = UDim2.new(0, 0, 0, 44)
BottomBar.BackgroundTransparency = 1

local function CreateStatBox(pos, size, label, trans)
    local f = Instance.new("Frame", BottomBar)
    f.Size = size; f.Position = pos
    f.BackgroundColor3 = DarkColor
    f.BackgroundTransparency = trans
    f.ClipsDescendants = true -- عشان تأثير التعبئة ميتطلعش بره
    Instance.new("UICorner", f).CornerRadius = CornerRadius10
    
    local t = Instance.new("TextLabel", f)
    t.Size = UDim2.new(1, 0, 1, 0); t.BackgroundTransparency = 1; t.ZIndex = 3
    t.TextColor3 = Color3.fromRGB(255, 255, 255); t.TextSize = 11; t.Font = Enum.Font.GothamBold; t.Text = label
    return t, f
end

-- اليمين ثابتة 7.4 (غامقة) | الشمال 0% متغيرة (شفافة فاتحة)
local LeftLabel, LeftFrame = CreateStatBox(UDim2.new(0, 0, 0, 0), UDim2.new(0.48, 0, 1, 0), "0%", 0.7)
local RightLabel, RightFrame = CreateStatBox(UDim2.new(0.52, 0, 0, 0), UDim2.new(0.48, 0, 1, 0), "7.4", 0.2)

-- شريط التعبئة الداخلي (للجهة الشمال فقط)
local LeftFill = Instance.new("Frame", LeftFrame)
LeftFill.Size = UDim2.new(0, 0, 1, 0)
LeftFill.BackgroundColor3 = DarkColor
LeftFill.BackgroundTransparency = 0.2 -- اللون الغامق بتاع التعبئة
LeftFill.BorderSizePixel = 0
LeftFill.ZIndex = 2

-- ========== 2. المنيو الجانبي (ثابت للتفعيلات فقط) ==========
local MainMenu = Instance.new("Frame", ScreenGui)
MainMenu.Size = UDim2.new(0, 160, 0, 400)
MainMenu.Position = UDim2.new(-0.7, 0, 0.3, 0)
MainMenu.BackgroundColor3 = DarkColor; MainMenu.BackgroundTransparency = 0.5
Instance.new("UICorner", MainMenu).CornerRadius = CornerRadius15
local MenuStroke = Instance.new("UIStroke", MainMenu); MenuStroke.Color = CrystalPurple

local UIList = Instance.new("UIListLayout", MainMenu)
UIList.Padding = UDim.new(0, 8); UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
Instance.new("UIPadding", MainMenu).PaddingTop = UDim.new(0, 12)

-- وظيفة تحريك الرقم من 0 لـ 100 (سريع)
local function AnimateSteal()
    -- التعبئة من الشمال لليمين في اللوحة السفلية
    LeftFill.Size = UDim2.new(0, 0, 1, 0)
    
    -- Tween للتعبئة وللأرقام
    local duration = 0.4 -- سرعة الوصول لـ 100%
    TweenService:Create(LeftFill, TweenInfo.new(duration, Enum.EasingStyle.Linear), {Size = UDim2.new(1, 0, 1, 0)}):Play()
    
    task.spawn(function()
        for i = 0, 100, 5 do -- يزيد بسرعة
            LeftLabel.Text = i .. "%"
            task.wait(duration / 20)
        end
        task.wait(0.2) -- ثبات بسيط عند الـ 100%
        
        -- العودة للصفر
        TweenService:Create(LeftFill, TweenInfo.new(0.3), {Size = UDim2.new(0, 0, 1, 0)}):Play()
        for i = 100, 0, -10 do
            LeftLabel.Text = i .. "%"
            task.wait(0.02)
        end
    end)
end

local function CreateBtn(name, key)
    local btn = Instance.new("TextButton", MainMenu)
    btn.Size = UDim2.new(0, 140, 0, 34); btn.BackgroundColor3 = DarkColor; btn.BackgroundTransparency = 0.2
    btn.TextColor3 = Color3.fromRGB(255, 255, 255); btn.Text = name; btn.Font = Enum.Font.GothamBold; btn.TextSize = 11
    Instance.new("UICorner", btn).CornerRadius = CornerRadius10
    local s = Instance.new("UIStroke", btn); s.Color = CrystalPurple; s.Thickness = 1.2

    btn.MouseButton1Click:Connect(function()
        if key == "StealNearest" then
            AnimateSteal() -- التأثير يحدث هنا فقط
        end
        -- هنا تضع كود التفعيل الخاص بكل زر
    end)
end

CreateBtn("Esp Player", "Esp")
CreateBtn("Bat Aimbot", "Bat")
CreateBtn("Steal Nearest", "StealNearest")
CreateBtn("Auto Medusa", "Medusa")
CreateBtn("Infinite Jump", "Jump")

-- ========== 3. الأيقونة والسحب ==========
local SideButton = Instance.new("TextButton", ScreenGui)
SideButton.Size = UDim2.new(0, 60, 0, 60); SideButton.Position = UDim2.new(1, -80, 0.5, 0); SideButton.BackgroundColor3 = CrystalPurple; SideButton.Text = ""
Instance.new("UICorner", SideButton).CornerRadius = CornerRadius15
for i = 0, 2 do
    local l = Instance.new("Frame", SideButton); l.Size = UDim2.new(0, 28, 0, 4); l.Position = UDim2.new(0.5, -14, 0, 18 + (i * 10)); l.BackgroundColor3 = Color3.fromRGB(255, 255, 255); Instance.new("UICorner", l).CornerRadius = UDim.new(0, 2)
end

local menuOpen = false
local dragging, dragStart, startPos, clickCheck
SideButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = SideButton.Position; clickCheck = input.Position
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
        if clickCheck and (input.Position - clickCheck).Magnitude < 8 then
            menuOpen = not menuOpen
            MainMenu:TweenPosition(UDim2.new(menuOpen and 0.02 or -0.7, 0, 0.3, 0), "Out", "Quart", 0.4, true)
        end
    end
end)

-- ========== 4. تحديث الـ HUD ==========
task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            local fps = math.floor(1 / RunService.RenderStepped:Wait())
            local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            InfoLabel.Text = string.format("Crystal Hub | FPS: %d | MS: %d", fps, ping)
        end)
    end
end)
