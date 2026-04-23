-- [[ Crystal Hub - Save Config Integrated Edition ]] --

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService") -- مكتبة التعامل مع البيانات
local Player = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

local CrystalPurple = Color3.fromRGB(120, 0, 255)
local DarkColor = Color3.fromRGB(0, 0, 0)
local GlobalRadius = UDim.new(0, 15) -- كل الزوايا بيضاوية 15
local GlobalStroke = 10 -- كل الإطارات بنفسجية 10

-- تنظيف الشاشة
for _, child in pairs(CoreGui:GetChildren()) do
    if child:IsA("ScreenGui") and child.Name:find("Crystal") then child:Destroy() end
end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "Crystal_Config_Final"
ScreenGui.ResetOnSpawn = false

-- ========== 1. HUD (Top & Bottom Bars) ==========
local HudContainer = Instance.new("Frame", ScreenGui)
HudContainer.Size = UDim2.new(0, 260, 0, 65)
HudContainer.Position = UDim2.new(0.5, -130, 0.05, 0)
HudContainer.BackgroundTransparency = 1

-- اللوحة العلوية
local TopBar = Instance.new("Frame", HudContainer)
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundColor3 = DarkColor; TopBar.BackgroundTransparency = 0.15
Instance.new("UICorner", TopBar).CornerRadius = GlobalRadius
local TopS = Instance.new("UIStroke", TopBar); TopS.Color = CrystalPurple; TopS.Thickness = GlobalStroke

local InfoLabel = Instance.new("TextLabel", TopBar)
InfoLabel.Size = UDim2.new(1, 0, 1, 0); InfoLabel.BackgroundTransparency = 1
InfoLabel.TextColor3 = CrystalPurple; InfoLabel.Font = Enum.Font.GothamBold; InfoLabel.TextSize = 14
InfoLabel.Text = "Crystal Hub | FPS: 0 | MS: 0"

-- اللوحة السفلية
local BottomBar = Instance.new("Frame", HudContainer)
BottomBar.Size = UDim2.new(1, 0, 0, 18)
BottomBar.Position = UDim2.new(0, 0, 0, 42)
BottomBar.BackgroundTransparency = 1

local function CreateStatBox(pos, size, label, trans)
    local f = Instance.new("Frame", BottomBar)
    f.Size = size; f.Position = pos; f.BackgroundColor3 = DarkColor; f.BackgroundTransparency = trans; f.ClipsDescendants = true
    Instance.new("UICorner", f).CornerRadius = GlobalRadius
    local t = Instance.new("TextLabel", f)
    t.Size = UDim2.new(1, 0, 1, 0); t.BackgroundTransparency = 1; t.ZIndex = 3; t.TextColor3 = Color3.fromRGB(255, 255, 255); t.TextSize = 10; t.Font = Enum.Font.GothamBold; t.Text = label
    return t, f
end

local LeftLabel, LeftFrame = CreateStatBox(UDim2.new(0, 0, 0, 0), UDim2.new(0.48, 0, 1, 0), "0%", 0.7)
local RightLabel, RightFrame = CreateStatBox(UDim2.new(0.52, 0, 0, 0), UDim2.new(0.48, 0, 1, 0), "7.4", 0.2)

-- ========== 2. Side Menu (Main UI) ==========
local MainMenu = Instance.new("Frame", ScreenGui)
MainMenu.Size = UDim2.new(0, 200, 0, 310) -- صغرنا الطول ليكون آخره زر الحفظ
MainMenu.Position = UDim2.new(-0.7, 0, 0.2, 0) -- رفعنا المنيو فوق شوية
MainMenu.BackgroundColor3 = DarkColor; MainMenu.BackgroundTransparency = 0.5
Instance.new("UICorner", MainMenu).CornerRadius = GlobalRadius
local MenuS = Instance.new("UIStroke", MainMenu); MenuS.Color = CrystalPurple; MenuS.Thickness = GlobalStroke

-- زر Player ESP العلوي
local EspBtn = Instance.new("TextButton", MainMenu)
EspBtn.Size = UDim2.new(0, 160, 0, 32); EspBtn.Position = UDim2.new(0.5, -80, 0, 20)
EspBtn.BackgroundColor3 = DarkColor; EspBtn.BackgroundTransparency = 0.2; EspBtn.TextColor3 = Color3.fromRGB(255, 255, 255); EspBtn.Text = "Player ESP"; EspBtn.Font = Enum.Font.GothamBold; EspBtn.TextSize = 11
Instance.new("UICorner", EspBtn).CornerRadius = GlobalRadius
local EspS = Instance.new("UIStroke", EspBtn); EspS.Color = CrystalPurple; EspS.Thickness = GlobalStroke

-- حاوية الأزرار الثنائية
local GridContainer = Instance.new("Frame", MainMenu)
GridContainer.Size = UDim2.new(1, -30, 0, 160)
GridContainer.Position = UDim2.new(0, 15, 0, 65)
GridContainer.BackgroundTransparency = 1
local UIGrid = Instance.new("UIGridLayout", GridContainer); UIGrid.CellSize = UDim2.new(0, 80, 0, 32); UIGrid.CellPadding = UDim2.new(0, 10, 0, 10); UIGrid.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- وظيفة إنشاء أزرار الشبكة
local function CreateGridBtn(name)
    local btn = Instance.new("TextButton", GridContainer)
    btn.BackgroundColor3 = DarkColor; btn.BackgroundTransparency = 0.2
    btn.TextColor3 = Color3.fromRGB(255, 255, 255); btn.Text = name; btn.Font = Enum.Font.GothamBold; btn.TextSize = 8
    Instance.new("UICorner", btn).CornerRadius = GlobalRadius
    local s = Instance.new("UIStroke", btn); s.Color = CrystalPurple; s.Thickness = GlobalStroke
end

local btnNames = {"Bat Aimbot", "Steal Nearest", "Auto Medusa", "Auto Play", "Anti Fling", "Anti Ragdoll", "Un Walk", "Infinite Jump", "Spin Bot", "Optimizer"}
for _, n in pairs(btnNames) do CreateGridBtn(n) end

-- ========== 3. Save Config Button (الطلب الجديد) ==========
local SaveBtn = Instance.new("TextButton", MainMenu)
SaveBtn.Name = "SaveConfig"
SaveBtn.Text = "SAVE CONFIG"
SaveBtn.Size = UDim2.new(0, 160, 0, 32)
SaveBtn.Position = UDim2.new(0.5, -80, 1, -52) -- في أسفل المنيو
SaveBtn.BackgroundColor3 = DarkColor; SaveBtn.BackgroundTransparency = 0.2 -- نفس لون أزرار التفعيلات
SaveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SaveBtn.Font = Enum.Font.GothamBold
SaveBtn.TextSize = 11
Instance.new("UICorner", SaveBtn).CornerRadius = GlobalRadius -- بيضاوية 15
local SaveS = Instance.new("UIStroke", SaveBtn); SaveS.Color = CrystalPurple; SaveS.Thickness = GlobalStroke -- حواف بيضاوية 10 بنفسجية

-- برمجة تأثير الوميض البنفسجي عند الضغط (Logic)
SaveBtn.MouseButton1Click:Connect(function()
    -- تأثير الوميض البنفسجي
    local originalColor = SaveBtn.BackgroundColor3
    local originalTransparency = SaveBtn.BackgroundTransparency

    -- يظهر لون بنفسجي فجأة
    SaveBtn.BackgroundColor3 = CrystalPurple
    SaveBtn.BackgroundTransparency = 0 -- معتم تماماً

    task.delay(0.2, function() -- وميض سريع
        -- يعود للون الأسود الشفاف التدريجي
        TweenService:Create(SaveBtn, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            BackgroundColor3 = originalColor,
            BackgroundTransparency = originalTransparency
        }):Play()
    end)
    
    -- يمكنك هنا إضافة كود حفظ البيانات الفعلي مستقبلاً
    print("[Crystal Hub] Config Save Initiated")
end)

-- ========== 4. Floating Icon & Logic ==========
local SideButton = Instance.new("TextButton", ScreenGui)
SideButton.Size = UDim2.new(0, 55, 0, 55); SideButton.Position = UDim2.new(1, -70, 0.5, -27); SideButton.BackgroundColor3 = CrystalPurple; SideButton.Text = ""
Instance.new("UICorner", SideButton).CornerRadius = GlobalRadius
for i = 0, 2 do
    local l = Instance.new("Frame", SideButton); l.Size = UDim2.new(0, 25, 0, 4); l.Position = UDim2.new(0.5, -12.5, 0, 18 + (i * 9)); l.BackgroundColor3 = Color3.fromRGB(255, 255, 255); Instance.new("UICorner", l).CornerRadius = UDim.new(0, 2)
end

local menuOpen = false
local dragging, dragStart, startPos, clickCheck
SideButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true; dragStart = input.Position; startPos = SideButton.Position; clickCheck = input.Position end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart; SideButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
SideButton.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
        if clickCheck and (input.Position - clickCheck).Magnitude < 8 then
            menuOpen = not menuOpen
            MainMenu:TweenPosition(UDim2.new(menuOpen and 0.02 or -0.7, 0, 0.2, 0), "Out", "Quart", 0.4, true)
        end
    end
end)

-- تحديث الـ Stats
task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            local fps = math.floor(1 / RunService.RenderStepped:Wait())
            local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            InfoLabel.Text = string.format("Crystal Hub | FPS: %d | MS: %d", fps, ping)
        end)
    end
end)

