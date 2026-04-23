-- [[ Crystal Hub - Fixed Layout & Button Borders ]] --

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Player = Players.LocalPlayer

local CrystalPurple = Color3.fromRGB(120, 0, 255)
local DarkColor = Color3.fromRGB(0, 0, 0)
local GlobalRadius = UDim.new(0, 15)
local BorderThickness = 1.5

-- تنظيف النسخ القديمة
local function FullCleanup()
    for _, child in pairs(CoreGui:GetChildren()) do
        if child:IsA("ScreenGui") and (child.Name:find("Crystal") or child.Name:find("Nova")) then child:Destroy() end
    end
end
FullCleanup()

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "Crystal_Fixed_UI"

-- ========== 1. Top & Bottom HUD ==========
local HUDContainer = Instance.new("Frame", ScreenGui)
HUDContainer.Size = UDim2.new(0, 210, 0, 60); HUDContainer.Position = UDim2.new(0.5, -105, 0.02, 0); HUDContainer.BackgroundTransparency = 1

local TopBar = Instance.new("Frame", HUDContainer)
TopBar.Size = UDim2.new(0.9, 0, 0, 28); TopBar.Position = UDim2.new(0.05, 0, 0, 0); TopBar.BackgroundColor3 = DarkColor; TopBar.BackgroundTransparency = 0.2
Instance.new("UICorner", TopBar).CornerRadius = GlobalRadius
local TopS = Instance.new("UIStroke", TopBar); TopS.Color = CrystalPurple; TopS.Thickness = BorderThickness
local Info = Instance.new("TextLabel", TopBar); Info.Size = UDim2.new(1,0,1,0); Info.BackgroundTransparency = 1; Info.TextColor3 = CrystalPurple; Info.Font = Enum.Font.GothamBold; Info.TextSize = 12; Info.Text = "Crystal Hub"

local BottomBar = Instance.new("Frame", HUDContainer)
BottomBar.Size = UDim2.new(0.9, 0, 0, 14); BottomBar.Position = UDim2.new(0.05, 0, 0, 32); BottomBar.BackgroundTransparency = 1

local function CreateStatBox(pos, size, txt, trans)
    local f = Instance.new("Frame", BottomBar)
    f.Size = size; f.Position = pos; f.BackgroundColor3 = DarkColor; f.BackgroundTransparency = trans
    Instance.new("UICorner", f).CornerRadius = GlobalRadius
    local s = Instance.new("UIStroke", f); s.Color = Color3.fromRGB(0, 0, 0); s.Thickness = 1; s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    local t = Instance.new("TextLabel", f); t.Size = UDim2.new(1,0,1,0); t.BackgroundTransparency = 1; t.TextColor3 = Color3.fromRGB(255,255,255); t.Font = Enum.Font.GothamBold; t.TextSize = 9; t.Text = txt
end
CreateStatBox(UDim2.new(0, 0, 0, 0), UDim2.new(0.48, 0, 1, 0), "0%", 0.5) 
CreateStatBox(UDim2.new(0.52, 0, 0, 0), UDim2.new(0.48, 0, 1, 0), "7.4", 0.15) 

-- ========== 2. Main Side Menu (تم زيادة الطول لضبط الترتيب) ==========
local MainMenu = Instance.new("Frame", ScreenGui)
MainMenu.Size = UDim2.new(0, 170, 0, 240); MainMenu.Position = UDim2.new(-0.7, 0, 0.5, -120) 
MainMenu.BackgroundColor3 = DarkColor; MainMenu.BackgroundTransparency = 0.4
Instance.new("UICorner", MainMenu).CornerRadius = GlobalRadius
local MenuS = Instance.new("UIStroke", MainMenu); MenuS.Color = CrystalPurple; MenuS.Thickness = BorderThickness

local function StyleButton(btn, thick)
    btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = GlobalRadius
    local s = Instance.new("UIStroke", btn)
    s.Color = CrystalPurple
    s.Thickness = thick or 1.2
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    
    local active = false
    btn.MouseButton1Click:Connect(function()
        if btn.Name ~= "SaveBtn" then
            active = not active
            TweenService:Create(btn, TweenInfo.new(0.25), {
                BackgroundColor3 = active and CrystalPurple or DarkColor,
                BackgroundTransparency = active and 0 or 0.3
            }):Play()
        end
    end)
end

-- زر Player Esp
local EspBtn = Instance.new("TextButton", MainMenu)
EspBtn.Size = UDim2.new(0, 150, 0, 28); EspBtn.Position = UDim2.new(0.5, -75, 0, 12)
EspBtn.BackgroundColor3 = DarkColor; EspBtn.BackgroundTransparency = 0.3; EspBtn.TextColor3 = Color3.fromRGB(255, 255, 255); EspBtn.Text = "Player Esp"; EspBtn.Font = Enum.Font.GothamBold; EspBtn.TextSize = 10
StyleButton(EspBtn, 1.5)

-- الشبكة (Grid)
local Grid = Instance.new("Frame", MainMenu)
Grid.Size = UDim2.new(1, -20, 0, 140); Grid.Position = UDim2.new(0, 10, 0, 48); Grid.BackgroundTransparency = 1
local UIGrid = Instance.new("UIGridLayout", Grid); UIGrid.CellSize = UDim2.new(0, 70, 0, 26); UIGrid.CellPadding = UDim2.new(0, 10, 0, 6)

local features = {"Bat Aimbot", "Steal Near", "Auto Medusa", "Auto Play", "Anti Fling", "Anti Ragdoll", "Un Walk", "Inf Jump", "Spin Bot", "Optimizer"}
for _, f in pairs(features) do 
    local btn = Instance.new("TextButton", Grid)
    btn.BackgroundColor3 = DarkColor; btn.BackgroundTransparency = 0.3; btn.TextColor3 = Color3.fromRGB(255, 255, 255); btn.Text = f; btn.Font = Enum.Font.GothamBold; btn.TextSize = 8
    StyleButton(btn, 1)
end

-- زر Save Config (تم ضبط مكانه بالأسفل مع حواف واضحة)
local SaveBtn = Instance.new("TextButton", MainMenu)
SaveBtn.Name = "SaveBtn"
SaveBtn.Size = UDim2.new(0, 150, 0, 28); SaveBtn.Position = UDim2.new(0.5, -75, 1, -40) 
SaveBtn.BackgroundColor3 = DarkColor; SaveBtn.BackgroundTransparency = 0.3; SaveBtn.ZIndex = 5
SaveBtn.TextColor3 = Color3.fromRGB(255, 255, 255); SaveBtn.Text = "SAVE CONFIG"; SaveBtn.Font = Enum.Font.GothamBold; SaveBtn.TextSize = 9
StyleButton(SaveBtn, 1.5)

-- ========== 3. Floating Button ==========
local SideButton = Instance.new("TextButton", ScreenGui)
SideButton.Size = UDim2.new(0, 50, 0, 50); SideButton.Position = UDim2.new(1, -60, 0.35, 0); SideButton.BackgroundColor3 = CrystalPurple; SideButton.Text = ""; SideButton.BorderSizePixel = 0
Instance.new("UICorner", SideButton).CornerRadius = GlobalRadius

for i=0,2 do
    local line = Instance.new("Frame", SideButton)
    line.Size = UDim2.new(0, 24, 0, 4); line.Position = UDim2.new(0.5, -12, 0, 15 + (i * 9)); line.BackgroundColor3 = Color3.fromRGB(255, 255, 255); line.BorderSizePixel = 0; Instance.new("UICorner", line).CornerRadius = UDim.new(0, 2)
end

local menuOpen = false
SideButton.MouseButton1Up:Connect(function()
    menuOpen = not menuOpen
    MainMenu:TweenPosition(UDim2.new(menuOpen and 0.02 or -0.7, 0, 0.5, -120), "Out", "Quart", 0.4, true)
end)

-- ========== 4. Head Display & Update Loop ==========
task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            local fps = math.floor(1 / RunService.RenderStepped:Wait())
            local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            Info.Text = string.format("Crystal Hub | FPS: %d | MS: %d", fps, ping)
        end)
    end
end)
