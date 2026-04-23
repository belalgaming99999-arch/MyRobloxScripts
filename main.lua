-- [[ Crystal Hub - No Border Bottom HUD ]] --

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
ScreenGui.Name = "Crystal_No_Bottom_Borders"
ScreenGui.ResetOnSpawn = false

-- ========== 1. HUD (Top & Bottom Bars) ==========
local HudContainer = Instance.new("Frame", ScreenGui)
HudContainer.Size = UDim2.new(0, 260, 0, 80)
HudContainer.Position = UDim2.new(0.5, -130, 0.05, 0)
HudContainer.BackgroundTransparency = 1

-- اللوحة العلوية (بإطار بنفسجي)
local TopBar = Instance.new("Frame", HudContainer)
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundColor3 = DarkColor
TopBar.BackgroundTransparency = 0.2
Instance.new("UICorner", TopBar).CornerRadius = CornerRadius15
local TopStroke = Instance.new("UIStroke", TopBar); TopStroke.Color = CrystalPurple; TopStroke.Thickness = 1.5

local InfoLabel = Instance.new("TextLabel", TopBar)
InfoLabel.Size = UDim2.new(1, 0, 1, 0); InfoLabel.BackgroundTransparency = 1
InfoLabel.TextColor3 = CrystalPurple; InfoLabel.Font = Enum.Font.GothamBold; InfoLabel.TextSize = 12
InfoLabel.Text = "Crystal Hub | FPS: 0 | MS: 0"

-- اللوحة السفلية (بدون حواف/إطارات)
local BottomBar = Instance.new("Frame", HudContainer)
BottomBar.Size = UDim2.new(1, 0, 0, 24)
BottomBar.Position = UDim2.new(0, 0, 0, 42)
BottomBar.BackgroundTransparency = 1

local function CreateStatBox(pos, size, label, trans)
    local f = Instance.new("Frame", BottomBar)
    f.Size = size; f.Position = pos
    f.BackgroundColor3 = DarkColor
    f.BackgroundTransparency = trans 
    f.BorderSizePixel = 0 -- التأكيد على مسح الحواف التقليدية
    Instance.new("UICorner", f).CornerRadius = CornerRadius10
    
    -- ملاحظة: لم يتم إضافة UIStroke هنا بناءً على طلبك
    
    local t = Instance.new("TextLabel", f)
    t.Size = UDim2.new(1, 0, 1, 0); t.BackgroundTransparency = 1
    t.TextColor3 = Color3.fromRGB(255, 255, 255); t.TextSize = 11; t.Font = Enum.Font.GothamBold; t.Text = label
    return t, f
end

-- الشمال فاتح (0.7) | اليمين غامق (0.2) - كلاهما بدون إطار بنفسجي
local LeftLabel, LeftFrame = CreateStatBox(UDim2.new(0, 0, 0, 0), UDim2.new(0.48, 0, 1, 0), "0%", 0.7)
local RightLabel, RightFrame = CreateStatBox(UDim2.new(0.52, 0, 0, 0), UDim2.new(0.48, 0, 1, 0), "7.4", 0.2)

-- ========== 2. Side Menu (بإطار بنفسجي) ==========
local MainMenu = Instance.new("Frame", ScreenGui)
MainMenu.Size = UDim2.new(0, 160, 0, 400)
MainMenu.Position = UDim2.new(-0.7, 0, 0.3, 0)
MainMenu.BackgroundColor3 = DarkColor; MainMenu.BackgroundTransparency = 0.5
Instance.new("UICorner", MainMenu).CornerRadius = CornerRadius15
Instance.new("UIStroke", MainMenu).Color = CrystalPurple

local ProgressFill = Instance.new("Frame", MainMenu)
ProgressFill.Size = UDim2.new(0, 0, 1, 0); ProgressFill.BackgroundColor3 = DarkColor; ProgressFill.BackgroundTransparency = 0.2
ProgressFill.ZIndex = 0; Instance.new("UICorner", ProgressFill).CornerRadius = CornerRadius15

local UIList = Instance.new("UIListLayout", MainMenu); UIList.Padding = UDim.new(0, 8); UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
Instance.new("UIPadding", MainMenu).PaddingTop = UDim.new(0, 12)

local function CreateBtn(name, key)
    local btn = Instance.new("TextButton", MainMenu)
    btn.Size = UDim2.new(0, 140, 0, 34); btn.BackgroundColor3 = DarkColor; btn.BackgroundTransparency = 0.2
    btn.TextColor3 = Color3.fromRGB(255, 255, 255); btn.Text = name; btn.Font = Enum.Font.GothamBold; btn.TextSize = 10; btn.ZIndex = 2
    Instance.new("UICorner", btn).CornerRadius = CornerRadius10
    local s = Instance.new("UIStroke", btn); s.Color = CrystalPurple; s.Thickness = 1.2

    btn.MouseButton1Click:Connect(function()
        if key == "StealNearest" then
            LeftLabel.Text = "100%"
            TweenService:Create(ProgressFill, TweenInfo.new(0.4), {Size = UDim2.new(1, 0, 1, 0)}):Play()
            task.delay(0.6, function()
                LeftLabel.Text = "0%"
                TweenService:Create(ProgressFill, TweenInfo.new(0.4), {Size = UDim2.new(0, 0, 1, 0)}):Play()
            end)
        end
    end)
end

CreateBtn("Esp Player", "Esp")
CreateBtn("Bat Aimbot", "Bat")
CreateBtn("Steal Nearest", "StealNearest")
CreateBtn("Auto Medusa", "Medusa")
CreateBtn("Infinite Jump", "Jump")

-- ========== 3. Floating Icon ==========
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

-- ========== 4. Stats Loop ==========
task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            local fps = math.floor(1 / RunService.RenderStepped:Wait())
            local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            local speed = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") and math.floor(Player.Character.HumanoidRootPart.AssemblyLinearVelocity.Magnitude * 10) / 10 or 7.4
            InfoLabel.Text = string.format("Crystal Hub | FPS: %d | MS: %d", fps, ping)
            RightLabel.Text = tostring(speed)
        end)
    end
end)
