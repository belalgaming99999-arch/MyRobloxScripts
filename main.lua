-- [[ Crystal Hub - Fully Unified Edition ]] --

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
-- 1. CONFIG SYSTEM
-- ============================================================
local ConfigFileName = "CrystalHub_Settings.json"
_G.Enabled = {
    ["Player Esp"] = false, ["Bat Aimbot"] = false, ["Steal Near"] = false,
    ["Auto Medusa"] = false, ["Auto Play"] = false, ["Anti Fling"] = false,
    ["Anti Ragdoll"] = false, ["Un Walk"] = false, ["Inf Jump"] = false,
    ["Spin Bot"] = false, ["Optimizer"] = false
}

local function SaveConfig()
    local ok = pcall(function()
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
            for k, v in pairs(data) do _G.Enabled[k] = v end
        end
    end)
end
LoadConfig()

-- ============================================================
-- 2. UI SETUP (UNIFIED SIZES)
-- ============================================================
local CrystalPurple = Color3.fromRGB(120, 0, 255)
local DarkColor = Color3.fromRGB(0, 0, 0)
local GlobalRadius = UDim.new(0, 15) 
local UnifiedStroke = 1.2
local UnifiedFontSize = 10

for _, child in pairs(CoreGui:GetChildren()) do
    if child:IsA("ScreenGui") and child.Name:find("Crystal") then child:Destroy() end
end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "Crystal_Unified_Pro"

local function SmoothTween(obj, goal)
    TweenService:Create(obj, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), goal):Play()
end

-- [ Top HUD - Unified Border ]
local HUDContainer = Instance.new("Frame", ScreenGui)
HUDContainer.Size = UDim2.new(0, 230, 0, 70); HUDContainer.Position = UDim2.new(0.5, -115, 0.02, 0); HUDContainer.BackgroundTransparency = 1

local TopBar = Instance.new("Frame", HUDContainer)
TopBar.Size = UDim2.new(0.9, 0, 0, 28); TopBar.Position = UDim2.new(0.05, 0, 0, 0); TopBar.BackgroundColor3 = DarkColor; TopBar.BackgroundTransparency = 0.2
Instance.new("UICorner", TopBar).CornerRadius = GlobalRadius
local TopS = Instance.new("UIStroke", TopBar); TopS.Color = CrystalPurple; TopS.Thickness = UnifiedStroke

local Info = Instance.new("TextLabel", TopBar)
Info.Size = UDim2.new(1,0,1,0); Info.BackgroundTransparency = 1; Info.TextColor3 = Color3.fromRGB(255, 255, 255)
Info.Font = Enum.Font.GothamBold; Info.TextSize = UnifiedFontSize
Info.Text = "Crystal Hub | FPS ... | MS ..."

-- [ Bottom Stats - Unified ]
local BottomBar = Instance.new("Frame", HUDContainer)
BottomBar.Size = UDim2.new(0.9, 0, 0, 14); BottomBar.Position = UDim2.new(0.05, 0, 0, 35); BottomBar.BackgroundTransparency = 1

local PercentLabel = nil  -- النسبة المئوية اللي هتتغير

local function CreateStatBox(pos, size, txt, trans)
    local f = Instance.new("Frame", BottomBar); f.Size = size; f.Position = pos; f.BackgroundColor3 = DarkColor; f.BackgroundTransparency = trans
    Instance.new("UICorner", f).CornerRadius = GlobalRadius
    local s = Instance.new("UIStroke", f); s.Color = CrystalPurple; s.Thickness = 1
    local t = Instance.new("TextLabel", f); t.Size = UDim2.new(1,0,1,0); t.BackgroundTransparency = 1; t.TextColor3 = Color3.fromRGB(255,255,255); t.Font = Enum.Font.GothamBold; t.TextSize = 9; t.Text = txt
    if txt == "0%" then PercentLabel = t end
    return t
end
CreateStatBox(UDim2.new(0, 0, 0, 0), UDim2.new(0.48, 0, 1, 0), "0%", 0.5) 
CreateStatBox(UDim2.new(0.52, 0, 0, 0), UDim2.new(0.48, 0, 1, 0), "7.4", 0.15) 

-- [ Sidebar Menu - Unified Border ]
local MainMenu = Instance.new("Frame", ScreenGui)
MainMenu.Size = UDim2.new(0, 180, 0, 285); MainMenu.Position = UDim2.new(-0.7, 0, 0.5, -142) 
MainMenu.BackgroundColor3 = DarkColor; MainMenu.BackgroundTransparency = 0.4
Instance.new("UICorner", MainMenu).CornerRadius = GlobalRadius
local MenuS = Instance.new("UIStroke", MainMenu); MenuS.Color = CrystalPurple; MenuS.Thickness = 1.5

-- [ Unified Toggle Design ]
local function CreateToggle(name, parent)
    local btn = Instance.new("TextButton", parent)
    btn.BackgroundColor3 = _G.Enabled[name] and CrystalPurple or DarkColor
    btn.BackgroundTransparency = _G.Enabled[name] and 0 or 0.3
    btn.TextColor3 = Color3.fromRGB(255, 255, 255); btn.Text = name; btn.Font = Enum.Font.GothamBold; btn.TextSize = UnifiedFontSize
    btn.AutoButtonColor = false 
    
    Instance.new("UICorner", btn).CornerRadius = GlobalRadius
    local s = Instance.new("UIStroke", btn); s.Color = CrystalPurple; s.Thickness = UnifiedStroke; s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    btn.MouseButton1Click:Connect(function()
        _G.Enabled[name] = not _G.Enabled[name]
        local active = _G.Enabled[name]
        SmoothTween(btn, {
            BackgroundColor3 = active and CrystalPurple or DarkColor,
            BackgroundTransparency = active and 0 or 0.3
        })
    end)
    return btn
end

local features = {"Player Esp", "Bat Aimbot", "Steal Near", "Auto Medusa", "Auto Play", "Anti Fling", "Anti Ragdoll", "Un Walk", "Inf Jump", "Spin Bot", "Optimizer"}
local EspBtn = CreateToggle("Player Esp", MainMenu)
EspBtn.Size = UDim2.new(1, -20, 0, 30); EspBtn.Position = UDim2.new(0, 10, 0, 15)

local Grid = Instance.new("Frame", MainMenu); Grid.Size = UDim2.new(1, -20, 0, 180); Grid.Position = UDim2.new(0, 10, 0, 55); Grid.BackgroundTransparency = 1
local UIGrid = Instance.new("UIGridLayout", Grid); UIGrid.CellSize = UDim2.new(0, 75, 0, 28); UIGrid.CellPadding = UDim2.new(0, 10, 0, 8)
for i = 2, #features do CreateToggle(features[i], Grid) end

-- [ Save Button ]
local SaveBtn = Instance.new("TextButton", MainMenu)
SaveBtn.Size = UDim2.new(1, -20, 0, 30); SaveBtn.Position = UDim2.new(0, 10, 1, -45)
SaveBtn.BackgroundColor3 = DarkColor; SaveBtn.BackgroundTransparency = 0.3; SaveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SaveBtn.Text = "Save Config"; SaveBtn.Font = Enum.Font.GothamBold; SaveBtn.TextSize = UnifiedFontSize
SaveBtn.AutoButtonColor = false
Instance.new("UICorner", SaveBtn).CornerRadius = GlobalRadius
local SaveS = Instance.new("UIStroke", SaveBtn); SaveS.Color = CrystalPurple; SaveS.Thickness = UnifiedStroke; SaveS.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

SaveBtn.MouseButton1Click:Connect(function()
    SaveConfig()
    SaveBtn.Text = "Config Saved"
    SmoothTween(SaveBtn, {BackgroundColor3 = CrystalPurple, BackgroundTransparency = 0})
    task.delay(1, function()
        SaveBtn.Text = "Save Config"
        SmoothTween(SaveBtn, {BackgroundColor3 = DarkColor, BackgroundTransparency = 0.3})
    end)
end)

-- [ Side Button ]
local SideButton = Instance.new("TextButton", ScreenGui)
SideButton.Size = UDim2.new(0, 50, 0, 50); SideButton.Position = UDim2.new(1, -65, 0.20, 0); SideButton.BackgroundColor3 = CrystalPurple; SideButton.Text = ""; SideButton.BorderSizePixel = 0
Instance.new("UICorner", SideButton).CornerRadius = GlobalRadius
local SideStroke = Instance.new("UIStroke", SideButton); SideStroke.Color = Color3.fromRGB(255,255,255); SideStroke.Thickness = 1.5

for i=0,2 do
    local line = Instance.new("Frame", SideButton); line.Size = UDim2.new(0, 24, 0, 4); line.Position = UDim2.new(0.5, -12, 0, 15 + (i * 9)); line.BackgroundColor3 = Color3.fromRGB(255, 255, 255); line.BorderSizePixel = 0; Instance.new("UICorner", line).CornerRadius = UDim.new(0, 2)
end

-- ============================================================
-- SPEED LABEL (سريع - تحديث كل إطار زي ZAY)
-- ============================================================
local SpeedLabel = nil

local function CreateFastSpeedTag(char)
    local head = char:WaitForChild("Head", 5)
    if not head then return end
    
    local old = head:FindFirstChild("SpeedTag")
    if old then old:Destroy() end
    
    local billboard = Instance.new("BillboardGui", head)
    billboard.Name = "SpeedTag"
    billboard.Size = UDim2.new(0, 120, 0, 32)
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.AlwaysOnTop = true
    
    local label = Instance.new("TextLabel", billboard)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 13
    label.Text = "Speed: 0.0"
    
    local stroke = Instance.new("UIStroke", label)
    stroke.Color = Color3.fromRGB(0, 0, 0)
    stroke.Thickness = 1.5
    stroke.Transparency = 0.4
    
    SpeedLabel = label
end

-- تحديث السرعة كل إطار (أسرع طريقة زي ZAY)
task.spawn(function()
    while true do
        RunService.RenderStepped:Wait()
        pcall(function()
            if SpeedLabel and Player.Character then
                local hrp = Player.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local vel = hrp.AssemblyLinearVelocity
                    local horizontalSpeed = math.floor(Vector3.new(vel.X, 0, vel.Z).Magnitude * 10) / 10
                    SpeedLabel.Text = string.format("Speed: %.1f", horizontalSpeed)
                end
            end
        end)
    end
end)

Player.CharacterAdded:Connect(function(char)
    task.wait(0.2)
    CreateFastSpeedTag(char)
end)

if Player.Character then
    CreateFastSpeedTag(Player.Character)
end

-- ============================================================
-- STEAL PROGRESS (النسبة 0% تتملى زيه زي ZAY)
-- ============================================================
local isStealing = false
local STEAL_DURATION = 1.3

-- بدء عملية السرقة وتحديث النسبة
local function StartStealProgress()
    if isStealing then return end
    isStealing = true
    
    local startTime = tick()
    
    task.spawn(function()
        while isStealing do
            local elapsed = tick() - startTime
            local percent = math.floor(math.clamp((elapsed / STEAL_DURATION) * 100, 0, 100))
            
            if PercentLabel then
                PercentLabel.Text = tostring(percent) .. "%"
            end
            
            if percent >= 100 then
                isStealing = false
                task.delay(0.3, function()
                    if PercentLabel then
                        PercentLabel.Text = "0%"
                    end
                end)
                break
            end
            
            RunService.RenderStepped:Wait()
        end
    end)
end

-- كشف عملية السرقة في اللعبة
local function DetectSteal()
    -- مراقبة Attribute "Stealing"
    pcall(function()
        Player:GetAttributeChangedSignal("Stealing"):Connect(function()
            if Player:GetAttribute("Stealing") == true then
                StartStealProgress()
            end
        end)
    end)
    
    -- مراقبة سرعة المشي
    task.spawn(function()
        local lastSpeed = 0
        while true do
            task.wait(0.05)
            pcall(function()
                local char = Player.Character
                if char then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum and hum.WalkSpeed < 20 and hum.WalkSpeed > 0 and not isStealing then
                        StartStealProgress()
                    end
                end
            end)
        end
    end)
end

task.spawn(DetectSteal)

-- ============================================================
-- Drag & Performance
-- ============================================================
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

-- تحديث FPS و Ping
task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            local fps = math.floor(1 / RunService.RenderStepped:Wait())
            local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            Info.Text = "Crystal Hub | FPS " .. fps .. " | MS " .. ping
        end)
    end
end)
