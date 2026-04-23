-- [[ Crystal Hub - Compact & Top Aligned Edition ]] --

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local CrystalPurple = Color3.fromRGB(120, 0, 255)
local DarkColor = Color3.fromRGB(0, 0, 0)
local GlobalRadius = UDim.new(0, 12) -- زوايا أنعم قليلاً
local BorderThickness = 1.2 -- حواف نحيفة جداً لراحة العين

-- تنظيف النسخ القديمة
for _, child in pairs(CoreGui:GetChildren()) do
    if child:IsA("ScreenGui") and child.Name:find("Crystal") then child:Destroy() end
end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "Crystal_Compact_Menu"

-- ========== 1. HUD Bars (Top) ==========
local HudContainer = Instance.new("Frame", ScreenGui)
HudContainer.Size = UDim2.new(0, 220, 0, 40)
HudContainer.Position = UDim2.new(0.5, -110, 0.02, 0)
HudContainer.BackgroundTransparency = 1

local TopBar = Instance.new("Frame", HudContainer)
TopBar.Size = UDim2.new(1, 0, 0, 28)
TopBar.BackgroundColor3 = DarkColor; TopBar.BackgroundTransparency = 0.2
Instance.new("UICorner", TopBar).CornerRadius = GlobalRadius
local TopS = Instance.new("UIStroke", TopBar); TopS.Color = CrystalPurple; TopS.Thickness = BorderThickness

local InfoLabel = Instance.new("TextLabel", TopBar)
InfoLabel.Size = UDim2.new(1, 0, 1, 0); InfoLabel.BackgroundTransparency = 1
InfoLabel.TextColor3 = CrystalPurple; InfoLabel.Font = Enum.Font.GothamBold; InfoLabel.TextSize = 12
InfoLabel.Text = "Crystal Hub | FPS: 0 | MS: 0"

-- ========== 2. Main Side Menu (Compact) ==========
local MainMenu = Instance.new("Frame", ScreenGui)
MainMenu.Size = UDim2.new(0, 170, 0, 270) -- صغرنا الحجم الكلي
MainMenu.Position = UDim2.new(-0.7, 0, 0.15, 0) -- رفعنا المنيو فوق
MainMenu.BackgroundColor3 = DarkColor; MainMenu.BackgroundTransparency = 0.4
Instance.new("UICorner", MainMenu).CornerRadius = GlobalRadius
local MenuS = Instance.new("UIStroke", MainMenu); MenuS.Color = CrystalPurple; MenuS.Thickness = BorderThickness

-- زر Player ESP (أول المنيو)
local EspBtn = Instance.new("TextButton", MainMenu)
EspBtn.Size = UDim2.new(0, 140, 0, 28); EspBtn.Position = UDim2.new(0.5, -70, 0, 12)
EspBtn.BackgroundColor3 = DarkColor; EspBtn.BackgroundTransparency = 0.3; EspBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
EspBtn.Text = "Player ESP"; EspBtn.Font = Enum.Font.GothamBold; EspBtn.TextSize = 10
Instance.new("UICorner", EspBtn).CornerRadius = GlobalRadius
local EspS = Instance.new("UIStroke", EspBtn); EspS.Color = CrystalPurple; EspS.Thickness = BorderThickness

-- حاوية الأزرار
local Grid = Instance.new("Frame", MainMenu)
Grid.Size = UDim2.new(1, -20, 0, 160); Grid.Position = UDim2.new(0, 10, 0, 48); Grid.BackgroundTransparency = 1
local UIGrid = Instance.new("UIGridLayout", Grid); UIGrid.CellSize = UDim2.new(0, 70, 0, 26); UIGrid.CellPadding = UDim2.new(0, 10, 0, 6)

local function CreateToggle(name)
    local btn = Instance.new("TextButton", Grid)
    btn.BackgroundColor3 = DarkColor; btn.BackgroundTransparency = 0.3
    btn.TextColor3 = Color3.fromRGB(255, 255, 255); btn.Text = name; btn.Font = Enum.Font.GothamBold; btn.TextSize = 8
    Instance.new("UICorner", btn).CornerRadius = GlobalRadius
    local s = Instance.new("UIStroke", btn); s.Color = CrystalPurple; s.Thickness = BorderThickness
    
    local active = false
    btn.MouseButton1Click:Connect(function()
        active = not active
        TweenService:Create(btn, TweenInfo.new(0.3), {BackgroundColor3 = active and CrystalPurple or DarkColor}):Play()
    end)
end

local features = {"Bat Aimbot", "Steal Near", "Auto Medusa", "Auto Play", "Anti Fling", "Anti Ragdoll", "Un Walk", "Inf Jump", "Spin Bot", "Optimizer"}
for _, f in pairs(features) do CreateToggle(f) end

-- ========== 3. Save Config Button (The Last One) ==========
local SaveBtn = Instance.new("TextButton", MainMenu)
SaveBtn.Name = "SaveConfig"
SaveBtn.Size = UDim2.new(0, 140, 0, 30)
SaveBtn.Position = UDim2.new(0.5, -70, 1, -40) -- متموضع ليكون آخر زر في المنيو
SaveBtn.BackgroundColor3 = DarkColor; SaveBtn.BackgroundTransparency = 0.3
SaveBtn.TextColor3 = Color3.fromRGB(255, 255, 255); SaveBtn.Text = "SAVE CONFIG"; SaveBtn.Font = Enum.Font.GothamBold; SaveBtn.TextSize = 9
Instance.new("UICorner", SaveBtn).CornerRadius = GlobalRadius
local SaveS = Instance.new("UIStroke", SaveBtn); SaveS.Color = CrystalPurple; SaveS.Thickness = BorderThickness

SaveBtn.MouseButton1Click:Connect(function()
    SaveBtn.BackgroundColor3 = CrystalPurple
    task.wait(0.1)
    TweenService:Create(SaveBtn, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {BackgroundColor3 = DarkColor}):Play()
end)

-- ========== 4. Floating Icon ==========
local SideButton = Instance.new("TextButton", ScreenGui)
SideButton.Size = UDim2.new(0, 40, 0, 40); SideButton.Position = UDim2.new(1, -50, 0.5, -20); SideButton.BackgroundColor3 = CrystalPurple; SideButton.Text = ""
Instance.new("UICorner", SideButton).CornerRadius = GlobalRadius

local menuOpen = false
SideButton.MouseButton1Click:Connect(function()
    menuOpen = not menuOpen
    MainMenu:TweenPosition(UDim2.new(menuOpen and 0.02 or -0.7, 0, 0.15, 0), "Out", "Quart", 0.4, true)
end)

-- Stats
task.spawn(function()
    while task.wait(0.1) do
        local fps = math.floor(1 / RunService.RenderStepped:Wait())
        local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        InfoLabel.Text = string.format("Crystal Hub | FPS: %d | MS: %d", fps, ping)
    end
end)
