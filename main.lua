-- [[ Crystal Hub - Oval Edition (Radius 15) ]] --

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
local GlobalRadius = UDim.new(0, 15) -- تحويل الكل لبيضاوي 15
local BorderThickness = 1.5

-- تنظيف النسخ القديمة
local function FullCleanup()
    for _, child in pairs(CoreGui:GetChildren()) do
        if child:IsA("ScreenGui") and (child.Name:find("Crystal") or child.Name:find("Nova")) then child:Destroy() end
    end
    if Player.Character and Player.Character:FindFirstChild("CrystalHeadGui") then
        Player.Character.CrystalHeadGui:Destroy()
    end
end
FullCleanup()

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "Crystal_Oval_15"

-- وظيفة السحب
local function MakeDraggable(gui)
    local dragging, dragStart, startPos
    local moved = false
    gui.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            dragging = true; moved = false; dragStart = input.Position; startPos = gui.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            if delta.Magnitude > 2 then 
                moved = true
                gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end
    end)
    gui.InputEnded:Connect(function() dragging = false end)
    return function() return not moved end 
end

-- ========== 1. Top & Bottom HUD ==========
local HUDContainer = Instance.new("Frame", ScreenGui)
HUDContainer.Size = UDim2.new(0, 250, 0, 60); HUDContainer.Position = UDim2.new(0.5, -125, 0.02, 0); HUDContainer.BackgroundTransparency = 1

local TopBar = Instance.new("Frame", HUDContainer)
TopBar.Size = UDim2.new(1, 0, 0, 32); TopBar.BackgroundColor3 = DarkColor; TopBar.BackgroundTransparency = 0.2
Instance.new("UICorner", TopBar).CornerRadius = GlobalRadius
local TopS = Instance.new("UIStroke", TopBar); TopS.Color = CrystalPurple; TopS.Thickness = BorderThickness
local Info = Instance.new("TextLabel", TopBar); Info.Size = UDim2.new(1,0,1,0); Info.BackgroundTransparency = 1; Info.TextColor3 = CrystalPurple; Info.Font = Enum.Font.GothamBold; Info.TextSize = 12; Info.Text = "Crystal Hub | FPS: 0 | MS: 0"

-- اللوحة السفلية (تم تصغيرها)
local BottomBar = Instance.new("Frame", HUDContainer)
BottomBar.Size = UDim2.new(1, 0, 0, 14); BottomBar.Position = UDim2.new(0, 0, 0, 36); BottomBar.BackgroundTransparency = 1

local function CreateStatBox(pos, size, txt, trans)
    local f = Instance.new("Frame", BottomBar)
    f.Size = size; f.Position = pos; f.BackgroundColor3 = DarkColor; f.BackgroundTransparency = trans
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 15) -- بيضاوي 15
    local s = Instance.new("UIStroke", f); s.Color = Color3.fromRGB(0, 0, 0); s.Thickness = 1; s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    local t = Instance.new("TextLabel", f); t.Size = UDim2.new(1,0,1,0); t.BackgroundTransparency = 1; t.TextColor3 = Color3.fromRGB(255,255,255); t.Font = Enum.Font.GothamBold; t.TextSize = 9; t.Text = txt
end
CreateStatBox(UDim2.new(0.05, 0, 0, 0), UDim2.new(0.4, 0, 1, 0), "0%", 0.5) -- اليسار
CreateStatBox(UDim2.new(0.55, 0, 0, 0), UDim2.new(0.4, 0, 1, 0), "7.4", 0.15) -- اليمين

-- ========== 2. Main Side Menu (Compact 210) ==========
local MainMenu = Instance.new("Frame", ScreenGui)
MainMenu.Size = UDim2.new(0, 170, 0, 210); MainMenu.Position = UDim2.new(-0.7, 0, 0.5, -105) 
MainMenu.BackgroundColor3 = DarkColor; MainMenu.BackgroundTransparency = 0.4
Instance.new("UICorner", MainMenu).CornerRadius = GlobalRadius
local MenuS = Instance.new("UIStroke", MainMenu); MenuS.Color = CrystalPurple; MenuS.Thickness = BorderThickness

local function MakeToggleLogic(btn)
    local active = false
    btn.AutoButtonColor = false
    btn.MouseButton1Click:Connect(function()
        active = not active
        TweenService:Create(btn, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {
            BackgroundColor3 = active and CrystalPurple or DarkColor,
            BackgroundTransparency = active and 0 or 0.3
        }):Play()
    end)
end

-- زر Player Esp
local EspBtn = Instance.new("TextButton", MainMenu)
EspBtn.Size = UDim2.new(0, 150, 0, 28); EspBtn.Position = UDim2.new(0.5, -75, 0, 10)
EspBtn.BackgroundColor3 = DarkColor; EspBtn.BackgroundTransparency = 0.3; EspBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
EspBtn.Text = "Player Esp"; EspBtn.Font = Enum.Font.GothamBold; EspBtn.TextSize = 10
Instance.new("UICorner", EspBtn).CornerRadius = GlobalRadius
local EspS = Instance.new("UIStroke", EspBtn); EspS.Color = CrystalPurple; EspS.Thickness = 1.2
MakeToggleLogic(EspBtn)

-- الشبكة (Grid)
local Grid = Instance.new("Frame", MainMenu)
Grid.Size = UDim2.new(1, -20, 0, 130); Grid.Position = UDim2.new(0, 10, 0, 44); Grid.BackgroundTransparency = 1
local UIGrid = Instance.new("UIGridLayout", Grid); UIGrid.CellSize = UDim2.new(0, 70, 0, 26); UIGrid.CellPadding = UDim2.new(0, 10, 0, 5)

local features = {"Bat Aimbot", "Steal Near", "Auto Medusa", "Auto Play", "Anti Fling", "Anti Ragdoll", "Un Walk", "Inf Jump", "Spin Bot", "Optimizer"}
for _, f in pairs(features) do 
    local btn = Instance.new("TextButton", Grid)
    btn.BackgroundColor3 = DarkColor; btn.BackgroundTransparency = 0.3; btn.TextColor3 = Color3.fromRGB(255, 255, 255); btn.Text = f; btn.Font = Enum.Font.GothamBold; btn.TextSize = 8
    Instance.new("UICorner", btn).CornerRadius = GlobalRadius
    local s = Instance.new("UIStroke", btn); s.Color = CrystalPurple; s.Thickness = 1
    MakeToggleLogic(btn)
end

-- زر Save Config (تحت التفعيلات مباشرة)
local SaveBtn = Instance.new("TextButton", MainMenu)
SaveBtn.Size = UDim2.new(0, 150, 0, 26); SaveBtn.Position = UDim2.new(0.5, -75, 1, -34) 
SaveBtn.BackgroundColor3 = DarkColor; SaveBtn.BackgroundTransparency = 0.3
SaveBtn.TextColor3 = Color3.fromRGB(255, 255, 255); SaveBtn.Text = "SAVE CONFIG"; SaveBtn.Font = Enum.Font.GothamBold; SaveBtn.TextSize = 9
Instance.new("UICorner", SaveBtn).CornerRadius = GlobalRadius
local SaveS = Instance.new("UIStroke", SaveBtn); SaveS.Color = CrystalPurple; SaveS.Thickness = 1.2
SaveBtn.AutoButtonColor = false

-- ========== 3. Floating Button (تم رفعه) ==========
local SideButton = Instance.new("TextButton", ScreenGui)
SideButton.Size = UDim2.new(0, 50, 0, 50)
SideButton.Position = UDim2.new(1, -60, 0.35, 0) -- رفعت الأيقونة فوق شوية
SideButton.BackgroundColor3 = CrystalPurple; SideButton.Text = ""; SideButton.BorderSizePixel = 0
Instance.new("UICorner", SideButton).CornerRadius = GlobalRadius
local canOpen = MakeDraggable(SideButton)

for i=0,2 do
    local line = Instance.new("Frame", SideButton)
    line.Size = UDim2.new(0, 24, 0, 4); line.Position = UDim2.new(0.5, -12, 0, 15 + (i * 9)); line.BackgroundColor3 = Color3.fromRGB(255, 255, 255); line.BorderSizePixel = 0; Instance.new("UICorner", line).CornerRadius = UDim.new(0, 2)
end

local menuOpen = false
SideButton.MouseButton1Up:Connect(function()
    if canOpen() then 
        menuOpen = not menuOpen
        MainMenu:TweenPosition(UDim2.new(menuOpen and 0.02 or -0.7, 0, 0.5, -105), "Out", "Quart", 0.4, true)
    end
end)

-- ========== 4. Head Display (Speed) ==========
local function CreateHeadDisplay()
    local char = Player.Character or Player.CharacterAdded:Wait()
    local head = char:WaitForChild("Head")
    local billboard = Instance.new("BillboardGui", char)
    billboard.Name = "CrystalHeadGui"; billboard.Adornee = head; billboard.Size = UDim2.new(0, 100, 0, 40); billboard.StudsOffset = Vector3.new(0, 2.5, 0); billboard.AlwaysOnTop = true
    local textLabel = Instance.new("TextLabel", billboard); textLabel.Size = UDim2.new(1, 0, 1, 0); textLabel.BackgroundTransparency = 1; textLabel.TextColor3 = Color3.fromRGB(255, 255, 255); textLabel.Font = Enum.Font.GothamBold; textLabel.TextSize = 14; textLabel.Text = "Speed: 0.0"
    local stroke = Instance.new("UIStroke", textLabel); stroke.Color = Color3.fromRGB(0, 0, 0); stroke.Thickness = 1.2
    return textLabel
end

local HeadSpeedLabel = CreateHeadDisplay()
Player.CharacterAdded:Connect(function() HeadSpeedLabel = CreateHeadDisplay() end)

task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            local fps = math.floor(1 / RunService.RenderStepped:Wait())
            local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            local char = Player.Character
            local speed = (char and char:FindFirstChild("HumanoidRootPart")) and char.HumanoidRootPart.Velocity.Magnitude or 0
            Info.Text = string.format("Crystal Hub | FPS: %d | MS: %d", fps, ping)
            if HeadSpeedLabel then HeadSpeedLabel.Text = string.format("Speed: %.1f", speed) end
        end)
    end
end)
