-- [[ Crystal Hub - Ultra Compact & Fixed Logic ]] --

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local CrystalPurple = Color3.fromRGB(120, 0, 255)
local DarkColor = Color3.fromRGB(0, 0, 0)
local GlobalRadius = UDim.new(0, 12)
local BorderThickness = 1.2

-- تنظيف النسخ القديمة
for _, child in pairs(CoreGui:GetChildren()) do
    if child:IsA("ScreenGui") and child.Name:find("Crystal") then child:Destroy() end
end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "Crystal_Final_Pro"

-- ========== 1. Main Side Menu (Compact Size) ==========
local MainMenu = Instance.new("Frame", ScreenGui)
MainMenu.Size = UDim2.new(0, 170, 0, 255) -- حجم ملموم ومظبوط
MainMenu.Position = UDim2.new(-0.7, 0, 0.15, 0)
MainMenu.BackgroundColor3 = DarkColor; MainMenu.BackgroundTransparency = 0.4
Instance.new("UICorner", MainMenu).CornerRadius = GlobalRadius
local MenuS = Instance.new("UIStroke", MainMenu); MenuS.Color = CrystalPurple; MenuS.Thickness = BorderThickness

-- وظيفة عامة لتأثير الضغط (Toggle)
local function MakeToggleLogic(btn)
    local active = false
    btn.MouseButton1Click:Connect(function()
        active = not active
        TweenService:Create(btn, TweenInfo.new(0.3), {
            BackgroundColor3 = active and CrystalPurple or DarkColor,
            BackgroundTransparency = active and 0 or 0.3
        }):Play()
    end)
end

-- زر Player ESP (تم إصلاحه)
local EspBtn = Instance.new("TextButton", MainMenu)
EspBtn.Size = UDim2.new(0, 150, 0, 28); EspBtn.Position = UDim2.new(0.5, -75, 0, 10)
EspBtn.BackgroundColor3 = DarkColor; EspBtn.BackgroundTransparency = 0.3; EspBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
EspBtn.Text = "Player ESP"; EspBtn.Font = Enum.Font.GothamBold; EspBtn.TextSize = 10
Instance.new("UICorner", EspBtn).CornerRadius = GlobalRadius
local EspS = Instance.new("UIStroke", EspBtn); EspS.Color = CrystalPurple; EspS.Thickness = BorderThickness
MakeToggleLogic(EspBtn) -- الآن ينور ويثبت عند الضغط

-- حاوية التفعيلات
local Grid = Instance.new("Frame", MainMenu)
Grid.Size = UDim2.new(1, -20, 0, 160); Grid.Position = UDim2.new(0, 10, 0, 45); Grid.BackgroundTransparency = 1
local UIGrid = Instance.new("UIGridLayout", Grid); UIGrid.CellSize = UDim2.new(0, 70, 0, 26); UIGrid.CellPadding = UDim2.new(0, 10, 0, 6)

local function CreateToggle(name)
    local btn = Instance.new("TextButton", Grid)
    btn.BackgroundColor3 = DarkColor; btn.BackgroundTransparency = 0.3
    btn.TextColor3 = Color3.fromRGB(255, 255, 255); btn.Text = name; btn.Font = Enum.Font.GothamBold; btn.TextSize = 8
    Instance.new("UICorner", btn).CornerRadius = GlobalRadius
    local s = Instance.new("UIStroke", btn); s.Color = CrystalPurple; s.Thickness = BorderThickness
    MakeToggleLogic(btn)
end

local features = {"Bat Aimbot", "Steal Near", "Auto Medusa", "Auto Play", "Anti Fling", "Anti Ragdoll", "Un Walk", "Inf Jump", "Spin Bot", "Optimizer"}
for _, f in pairs(features) do CreateToggle(f) end

-- ========== 2. Save Config Button (مرفوع تحت آخر تفعيلة بظبط) ==========
local SaveBtn = Instance.new("TextButton", MainMenu)
SaveBtn.Name = "SaveConfig"
SaveBtn.Size = UDim2.new(0, 150, 0, 28)
SaveBtn.Position = UDim2.new(0.5, -75, 0, 215) -- موقع دقيق جداً تحت الشبكة مباشرة
SaveBtn.BackgroundColor3 = DarkColor; SaveBtn.BackgroundTransparency = 0.3
SaveBtn.TextColor3 = Color3.fromRGB(255, 255, 255); SaveBtn.Text = "SAVE CONFIG"; SaveBtn.Font = Enum.Font.GothamBold; SaveBtn.TextSize = 9
Instance.new("UICorner", SaveBtn).CornerRadius = GlobalRadius
local SaveS = Instance.new("UIStroke", SaveBtn); SaveS.Color = CrystalPurple; SaveS.Thickness = BorderThickness

-- تأثير ضغطة زر الحفظ (يختفي ويرجع للسود)
SaveBtn.MouseButton1Click:Connect(function()
    SaveBtn.BackgroundColor3 = CrystalPurple
    SaveBtn.BackgroundTransparency = 0
    task.wait(0.1)
    TweenService:Create(SaveBtn, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {
        BackgroundColor3 = DarkColor,
        BackgroundTransparency = 0.3
    }):Play()
end)

-- ========== 3. Floating Button & Menu Toggle ==========
local SideButton = Instance.new("TextButton", ScreenGui)
SideButton.Size = UDim2.new(0, 40, 0, 40); SideButton.Position = UDim2.new(1, -50, 0.5, -20); SideButton.BackgroundColor3 = CrystalPurple; SideButton.Text = ""
Instance.new("UICorner", SideButton).CornerRadius = GlobalRadius

local menuOpen = false
SideButton.MouseButton1Click:Connect(function()
    menuOpen = not menuOpen
    MainMenu:TweenPosition(UDim2.new(menuOpen and 0.02 or -0.7, 0, 0.15, 0), "Out", "Quart", 0.4, true)
end)

-- Stats (Top Bar)
local TopBar = Instance.new("Frame", ScreenGui)
TopBar.Size = UDim2.new(0, 200, 0, 26); TopBar.Position = UDim2.new(0.5, -100, 0.02, 0); TopBar.BackgroundColor3 = DarkColor; TopBar.BackgroundTransparency = 0.2
Instance.new("UICorner", TopBar).CornerRadius = GlobalRadius
local TopS = Instance.new("UIStroke", TopBar); TopS.Color = CrystalPurple; TopS.Thickness = BorderThickness
local Info = Instance.new("TextLabel", TopBar); Info.Size = UDim2.new(1,0,1,0); Info.BackgroundTransparency = 1; Info.TextColor3 = CrystalPurple; Info.Font = Enum.Font.GothamBold; Info.TextSize = 11; Info.Text = "Crystal Hub | Loading..."

task.spawn(function()
    while task.wait(0.1) do
        local fps = math.floor(1 / RunService.RenderStepped:Wait())
        local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        Info.Text = string.format("Crystal Hub | FPS: %d | MS: %d", fps, ping)
    end
end)
