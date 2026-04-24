-- [[ Crystal Hub - Turbo Instant Edition + SAVE SYSTEM ]] --

if _G.CrystalLoaded then return end
_G.CrystalLoaded = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local Player = Players.LocalPlayer

-- ============================================================
-- 1. CONFIG SYSTEM (نظام الحفظ المدمج)
-- ============================================================
local ConfigFileName = "CrystalHub_Settings.json"
_G.Enabled = {
    ["Player Esp"] = false, ["Bat Aimbot"] = false, ["Steal Near"] = false,
    ["Auto Medusa"] = false, ["Auto Play"] = false, ["Anti Fling"] = false,
    ["Anti Ragdoll"] = false, ["Un Walk"] = false, ["Inf Jump"] = false,
    ["Spin Bot"] = false, ["Optimizer"] = false
}

local function SaveConfig()
    local ok, err = pcall(function()
        if writefile then
            writefile(ConfigFileName, HttpService:JSONEncode(_G.Enabled))
        end
    end)
    return ok
end

local function LoadConfig()
    pcall(function()
        if isfile and isfile(ConfigFileName) then
            local data = HttpService:JSONDecode(readfile(ConfigFileName))
            for k, v in pairs(data) do
                _G.Enabled[k] = v
            end
        end
    end)
end
LoadConfig() -- تحميل الإعدادات فوراً عند التشغيل

-- ============================================================
-- 2. UI SETUP (نفس التصميم والسرعة)
-- ============================================================
local CrystalPurple = Color3.fromRGB(120, 0, 255)
local DarkColor = Color3.fromRGB(0, 0, 0)
local GlobalRadius = UDim.new(0, 15) 
local BorderThickness = 1.5

for _, child in pairs(CoreGui:GetChildren()) do
    if child:IsA("ScreenGui") and child.Name:find("Crystal") then child:Destroy() end
end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "Crystal_Turbo_Final"

local function Tween(obj, info, goal)
    return TweenService:Create(obj, TweenInfo.new(info, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), goal):Play()
end

-- [ Top HUD ]
local HUDContainer = Instance.new("Frame", ScreenGui)
HUDContainer.Size = UDim2.new(0, 230, 0, 70); HUDContainer.Position = UDim2.new(0.5, -115, 0.02, 0); HUDContainer.BackgroundTransparency = 1

local TopBar = Instance.new("Frame", HUDContainer)
TopBar.Size = UDim2.new(0.9, 0, 0, 28); TopBar.Position = UDim2.new(0.05, 0, 0, 0); TopBar.BackgroundColor3 = DarkColor; TopBar.BackgroundTransparency = 0.2
Instance.new("UICorner", TopBar).CornerRadius = GlobalRadius
local TopS = Instance.new("UIStroke", TopBar); TopS.Color = CrystalPurple; TopS.Thickness = BorderThickness

local Info = Instance.new("TextLabel", TopBar)
Info.Size = UDim2.new(1,0,1,0); Info.BackgroundTransparency = 1; Info.TextColor3 = Color3.fromRGB(255, 255, 255)
Info.Font = Enum.Font.GothamBold; Info.TextSize = 10
-- جلب البيانات فوراً
local f = math.floor(1/RunService.RenderStepped:Wait())
local p = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
Info.Text = "Crystal Hub | FPS " .. f .. " | MS " .. p

-- [ Bottom Stats ]
local BottomBar = Instance.new("Frame", HUDContainer)
BottomBar.Size = UDim2.new(0.9, 0, 0, 14); BottomBar.Position = UDim2.new(0.05, 0, 0, 35); BottomBar.BackgroundTransparency = 1

local function CreateStatBox(pos, size, txt, trans)
    local f = Instance.new("Frame", BottomBar); f.Size = size; f.Position = pos; f.BackgroundColor3 = DarkColor; f.BackgroundTransparency = trans
    Instance.new("UICorner", f).CornerRadius = GlobalRadius
    local s = Instance.new("UIStroke", f); s.Color = CrystalPurple; s.Thickness = 1
    local t = Instance.new("TextLabel", f); t.Size = UDim2.new(1,0,1,0); t.BackgroundTransparency = 1; t.TextColor3 = Color3.fromRGB(255,255,255); t.Font = Enum.Font.GothamBold; t.TextSize = 9; t.Text = txt
end
CreateStatBox(UDim2.new(0, 0, 0, 0), UDim2.new(0.48, 0, 1, 0), "0%", 0.5) 
CreateStatBox(UDim2.new(0.52, 0, 0, 0), UDim2.new(0.48, 0, 1, 0), "7.4", 0.15) 

-- [ Sidebar Menu ]
local MainMenu = Instance.new("Frame", ScreenGui)
MainMenu.Size = UDim2.new(0, 180, 0, 285); MainMenu.Position = UDim2.new(-0.7, 0, 0.5, -142) 
MainMenu.BackgroundColor3 = DarkColor; MainMenu.BackgroundTransparency = 0.4
Instance.new("UICorner", MainMenu).CornerRadius = GlobalRadius
local MenuS = Instance.new("UIStroke", MainMenu); MenuS.Color = CrystalPurple; MenuS.Thickness = BorderThickness

-- [ Toggle Logic ]
local function CreateToggle(name, parent, isEsp)
    local btn = Instance.new("TextButton", parent)
    btn.BackgroundColor3 = _G.Enabled[name] and CrystalPurple or DarkColor
    btn.BackgroundTransparency = _G.Enabled[name] and 0 or 0.3
    btn.TextColor3 = Color3.fromRGB(255, 255, 255); btn.Text = name; btn.Font = Enum.Font.GothamBold; btn.TextSize = 10
    Instance.new("UICorner", btn).CornerRadius = GlobalRadius
    local s = Instance.new("UIStroke", btn); s.Color = CrystalPurple; s.Thickness = 1.2; s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    btn.MouseButton1Click:Connect(function()
        _G.Enabled[name] = not _G.Enabled[name]
        local active = _G.Enabled[name]
        Tween(btn, 0.25, {
            BackgroundColor3 = active and CrystalPurple or DarkColor,
            BackgroundTransparency = active and 0 or 0.3
        })
    end)
    return btn
end

-- Buttons Creation
local EspBtn = CreateToggle("Player Esp", MainMenu)
EspBtn.Size = UDim2.new(1, -20, 0, 30); EspBtn.Position = UDim2.new(0, 10, 0, 15)

local Grid = Instance.new("Frame", MainMenu)
Grid.Size = UDim2.new(1, -20, 0, 180); Grid.Position = UDim2.new(0, 10, 0, 55); Grid.BackgroundTransparency = 1
local UIGrid = Instance.new("UIGridLayout", Grid); UIGrid.CellSize = UDim2.new(0, 75, 0, 28); UIGrid.CellPadding = UDim2.new(0, 10, 0, 8)

local features = {"Bat Aimbot", "Steal Near", "Auto Medusa", "Auto Play", "Anti Fling", "Anti Ragdoll", "Un Walk", "Inf Jump", "Spin Bot", "Optimizer"}
for _, fName in pairs(features) do 
    CreateToggle(fName, Grid)
end

-- [ Save Button (The Real One) ]
local SaveBtn = Instance.new("TextButton", MainMenu)
SaveBtn.Size = UDim2.new(1, -20, 0, 30); SaveBtn.Position = UDim2.new(0, 10, 1, -45)
SaveBtn.BackgroundColor3 = DarkColor; SaveBtn.BackgroundTransparency = 0.3; SaveBtn.TextColor3 = Color3.fromRGB(255, 255, 255); SaveBtn.Text = "Save Config"; SaveBtn.Font = Enum.Font.GothamBold; SaveBtn.TextSize = 10
Instance.new("UICorner", SaveBtn).CornerRadius = GlobalRadius
local SaveS = Instance.new("UIStroke", SaveBtn); SaveS.Color = CrystalPurple; SaveS.Thickness = 1.5

SaveBtn.MouseButton1Click:Connect(function()
    local success = SaveConfig()
    SaveBtn.Text = success and "Config Saved!" or "Error Saving"
    Tween(SaveBtn, 0.2, {BackgroundColor3 = CrystalPurple, BackgroundTransparency = 0})
    task.delay(1, function()
        SaveBtn.Text = "Save Config"
        Tween(SaveBtn, 0.4, {BackgroundColor3 = DarkColor, BackgroundTransparency = 0.3})
    end)
end)

-- ============================================================
-- 3. INTERFACE CONTROLS & LOOPS
-- ============================================================
local SideButton = Instance.new("TextButton", ScreenGui)
SideButton.Size = UDim2.new(0, 50, 0, 50); SideButton.Position = UDim2.new(1, -65, 0.30, 0)
SideButton.BackgroundColor3 = CrystalPurple; SideButton.Text = ""; SideButton.BorderSizePixel = 0
Instance.new("UICorner", SideButton).CornerRadius = GlobalRadius
local SideStroke = Instance.new("UIStroke", SideButton); SideStroke.Color = Color3.fromRGB(255,255,255); SideStroke.Thickness = 1.5

for i=0,2 do
    local line = Instance.new("Frame", SideButton)
    line.Size = UDim2.new(0, 24, 0, 4); line.Position = UDim2.new(0.5, -12, 0, 15 + (i * 9)); line.BackgroundColor3 = Color3.fromRGB(255, 255, 255); line.BorderSizePixel = 0; Instance.new("UICorner", line).CornerRadius = UDim.new(0, 2)
end

local dragging, dragStart, startPos, menuOpen = false, nil, nil, false
SideButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging, dragStart, startPos = true, input.Position, SideButton.Position
        local startTick = tick()
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
                if (tick() - startTick) < 0.25 and (input.Position - dragStart).Magnitude < 5 then
                    menuOpen = not menuOpen
                    MainMenu:TweenPosition(UDim2.new(menuOpen and 0.02 or -0.7, 0, 0.5, -142), "Out", "Quart", 0.4, true)
                end
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        SideButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            local fps = math.floor(1 / RunService.RenderStepped:Wait())
            local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            Info.Text = "Crystal Hub | FPS " .. fps .. " | MS " .. ping
        end)
    end
end)
