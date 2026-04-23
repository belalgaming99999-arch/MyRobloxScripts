-- [[ Crystal Hub - Guaranteed Ultimate Visibility ]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local TweenService = game:GetService("TweenService")
local Player = Players.LocalPlayer

-- ألوان Crystal Hub الموحدة
local CrystalPurple = Color3.fromRGB(120, 0, 255)
local LightPurple = Color3.fromRGB(180, 100, 255)
local PureBlack = Color3.fromRGB(0, 0, 0)

-- تنظيف الواجهات القديمة
local function CleanUI()
    local name = "Crystal_Final_UI"
    pcall(function()
        if game:GetService("CoreGui"):FindFirstChild(name) then game:GetService("CoreGui")[name]:Destroy() end
        if Player.PlayerGui:FindFirstChild(name) then Player.PlayerGui[name]:Destroy() end
    end)
end
CleanUI()

-- إنشاء الواجهة في الحاوية المتاحة
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Crystal_Final_UI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
local success, err = pcall(function()
    ScreenGui.Parent = game:GetService("CoreGui")
end)
if not success then ScreenGui.Parent = Player:WaitForChild("PlayerGui") end

-- [[ 1. القائمة العلوية والسفلية ]]
local MainBar = Instance.new("Frame", ScreenGui)
MainBar.Size = UDim2.new(0, 250, 0, 34)
MainBar.Position = UDim2.new(0.5, -125, -0.2, 0) -- بداية من فوق الشاشة
MainBar.BackgroundColor3 = PureBlack
MainBar.BackgroundTransparency = 0.15
Instance.new("UICorner", MainBar).CornerRadius = UDim.new(0, 15)
local Stroke = Instance.new("UIStroke", MainBar)
Stroke.Color = CrystalPurple; Stroke.Thickness = 1.5

local InfoLabel = Instance.new("TextLabel", MainBar)
InfoLabel.Size = UDim2.new(1, 0, 1, 0); InfoLabel.BackgroundTransparency = 1
InfoLabel.TextColor3 = LightPurple; InfoLabel.TextSize = 14; InfoLabel.Font = Enum.Font.GothamBold
InfoLabel.Text = "Crystal Hub | FPS -- | MS --"

local BottomBar = Instance.new("Frame", ScreenGui)
BottomBar.Size = UDim2.new(0, 250, 0, 14)
BottomBar.Position = UDim2.new(0.5, -125, -0.2, 40)
BottomBar.BackgroundTransparency = 1

local function CreatePart(pos, size, trans, txt)
    local f = Instance.new("Frame", BottomBar)
    f.Size = size; f.Position = pos; f.BackgroundColor3 = PureBlack; f.BackgroundTransparency = trans; f.BorderSizePixel = 0
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 20) 
    local t = Instance.new("TextLabel", f)
    t.Size = UDim2.new(1, 0, 1, 0); t.BackgroundTransparency = 1
    t.Text = txt; t.TextColor3 = Color3.fromRGB(255, 255, 255); t.TextSize = 10; t.Font = Enum.Font.GothamBold
end
CreatePart(UDim2.new(0, 0, 0, 0), UDim2.new(0.49, 0, 1, 0), 0.5, "0%") 
CreatePart(UDim2.new(0.51, 0, 0, 0), UDim2.new(0.49, 0, 1, 0), 0.15, "7.4") 

-- [[ 2. زر المنيو (شكل 3 خطوط متطابق) ]]
local SideButton = Instance.new("TextButton", ScreenGui)
SideButton.Size = UDim2.new(0, 42, 0, 42)
SideButton.Position = UDim2.new(1.2, 0, 0.9, -110) -- بداية من خارج اليمين
SideButton.BackgroundColor3 = CrystalPurple
SideButton.Text = ""
Instance.new("UICorner", SideButton).CornerRadius = UDim.new(0, 10)

local LinesFrame = Instance.new("Frame", SideButton)
LinesFrame.Size = UDim2.new(0.6, 0, 0.5, 0); LinesFrame.Position = UDim2.new(0.2, 0, 0.25, 0); LinesFrame.BackgroundTransparency = 1
local function CreateLine(p)
    local l = Instance.new("Frame", LinesFrame); l.Size = UDim2.new(1, 0, 0.18, 0)
    l.Position = UDim2.new(0, 0, p, 0); l.BackgroundColor3 = Color3.new(1,1,1); l.BorderSizePixel = 0
    Instance.new("UICorner", l).CornerRadius = UDim.new(0, 2)
end
CreateLine(0); CreateLine(0.38); CreateLine(0.76)

-- [[ 3. قائمة المنيو الجانبية (تظهر من أقصى الشمال) ]]
local SideMenu = Instance.new("Frame", ScreenGui)
SideMenu.Size = UDim2.new(0, 160, 0, 220)
SideMenu.Position = UDim2.new(-0.5, 0, 0.4, 0) -- بداية من خارج الشمال
SideMenu.BackgroundColor3 = PureBlack
SideMenu.BackgroundTransparency = 0.1
Instance.new("UICorner", SideMenu).CornerRadius = UDim.new(0, 15)
local MenuStroke = Instance.new("UIStroke", SideMenu)
MenuStroke.Color = CrystalPurple; MenuStroke.Thickness = 1.5

-- [[ أنيميشن الدخول الفوري ]]
local it = TweenInfo.new(0.8, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
TweenService:Create(MainBar, it, {Position = UDim2.new(0.5, -125, 0.04, 0)}):Play()
TweenService:Create(BottomBar, it, {Position = UDim2.new(0.5, -125, 0.04, 40)}):Play()
TweenService:Create(SideButton, it, {Position = UDim2.new(1, -60, 0.9, -110)}):Play()

-- برمجة التفاعل (فتح من الشمال)
local menuOpen = false
SideButton.MouseButton1Click:Connect(function()
    menuOpen = not menuOpen
    local target = menuOpen and UDim2.new(0.02, 0, 0.4, 0) or UDim2.new(-0.5, 0, 0.4, 0)
    TweenService:Create(SideMenu, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = target}):Play()
end)

-- تحديث الـ FPS و MS بشكل مستمر
RunService.RenderStepped:Connect(function()
    local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
    local fps = math.floor(1 / (RunService.RenderStepped:Wait() + 0.0001))
    InfoLabel.Text = string.format("Crystal Hub | FPS %d | MS %d", fps, ping)
end)
