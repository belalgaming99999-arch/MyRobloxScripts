-- [[ Crystal Hub - Precision Grid & Symmetry Edition ]] --

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Player = Players.LocalPlayer

local CrystalPurple = Color3.fromRGB(120, 0, 255)
local DarkColor = Color3.fromRGB(0, 0, 0)
local GlobalRadius = UDim.new(0, 15) 
local BorderThickness = 1.5

local function FullCleanup()
    for _, child in pairs(CoreGui:GetChildren()) do
        if child:IsA("ScreenGui") and (child.Name:find("Crystal") or child.Name:find("Fixed")) then child:Destroy() end
    end
end
FullCleanup()

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "Crystal_Symmetric_Final"

-- ========== 1. Top HUD (Oval 15) ==========
local HUDContainer = Instance.new("Frame", ScreenGui)
HUDContainer.Size = UDim2.new(0, 230, 0, 70); HUDContainer.Position = UDim2.new(0.5, -115, 0.02, 0); HUDContainer.BackgroundTransparency = 1

local TopBar = Instance.new("Frame", HUDContainer)
TopBar.Size = UDim2.new(0.9, 0, 0, 28); TopBar.Position = UDim2.new(0.05, 0, 0, 0); TopBar.BackgroundColor3 = DarkColor; TopBar.BackgroundTransparency = 0.2
Instance.new("UICorner", TopBar).CornerRadius = GlobalRadius
local TopS = Instance.new("UIStroke", TopBar); TopS.Color = CrystalPurple; TopS.Thickness = BorderThickness

local Info = Instance.new("TextLabel", TopBar)
Info.Size = UDim2.new(1,0,1,0); Info.BackgroundTransparency = 1; Info.TextColor3 = Color3.fromRGB(255, 255, 255); Info.Font = Enum.Font.GothamBold; Info.TextSize = 10
Info.Text = "Crystal Hub | FPS -- | MS --"

local BottomBar = Instance.new("Frame", HUDContainer)
BottomBar.Size = UDim2.new(0.9, 0, 0, 14); BottomBar.Position = UDim2.new(0.05, 0, 0, 35); BottomBar.BackgroundTransparency = 1

local function CreateStatBox(pos, size, txt, trans)
    local f = Instance.new("Frame", BottomBar)
    f.Size = size; f.Position = pos; f.BackgroundColor3 = DarkColor; f.BackgroundTransparency = trans
    Instance.new("UICorner", f).CornerRadius = GlobalRadius
    local s = Instance.new("UIStroke", f); s.Color = CrystalPurple; s.Thickness = 1
    local t = Instance.new("TextLabel", f); t.Size = UDim2.new(1,0,1,0); t.BackgroundTransparency = 1; t.TextColor3 = Color3.fromRGB(255,255,255); t.Font = Enum.Font.GothamBold; t.TextSize = 9; t.Text = txt
end
CreateStatBox(UDim2.new(0, 0, 0, 0), UDim2.new(0.48, 0, 1, 0), "0%", 0.5) 
CreateStatBox(UDim2.new(0.52, 0, 0, 0), UDim2.new(0.48, 0, 1, 0), "7.4", 0.15) 

-- ========== 2. Speed Tag (نزلت تحت سنة) ==========
local SpeedLabel
local function CreateSpeedTag(char)
    local head = char:WaitForChild("Head", 5)
    local billboard = Instance.new("BillboardGui", char)
    billboard.Name = "SpeedTag"; billboard.Adornee = head; billboard.Size = UDim2.new(0, 120, 0, 40)
    billboard.StudsOffset = Vector3.new(0, 2.4, 0); billboard.AlwaysOnTop = true
    local label = Instance.new("TextLabel", billboard); label.Size = UDim2.new(1, 0, 1, 0); label.BackgroundTransparency = 1; label.TextColor3 = Color3.fromRGB(255, 255, 255); label.Font = Enum.Font.GothamBold; label.TextSize = 11; label.Text = "Speed: 0"
    SpeedLabel = label
end
Player.CharacterAdded:Connect(CreateSpeedTag)
if Player.Character then CreateSpeedTag(Player.Character) end

-- ========== 3. Main Side Menu (مرتبة بالمللي) ==========
local MainMenu = Instance.new("Frame", ScreenGui)
MainMenu.Size = UDim2.new(0, 180, 0, 280); MainMenu.Position = UDim2.new(-0.7, 0, 0.5, -140) 
MainMenu.BackgroundColor3 = DarkColor; MainMenu.BackgroundTransparency = 0.4
Instance.new("UICorner", MainMenu).CornerRadius = GlobalRadius
local MenuS = Instance.new("UIStroke", MainMenu); MenuS.Color = CrystalPurple; MenuS.Thickness = BorderThickness

local function StyleButton(btn, thick)
    btn.AutoButtonColor = false; Instance.new("UICorner", btn).CornerRadius = GlobalRadius
    local s = Instance.new("UIStroke", btn); s.Color = CrystalPurple; s.Thickness = thick or BorderThickness
    btn.MouseButton1Click:Connect(function()
        if btn.Name ~= "SaveBtn" then
            local active = btn.BackgroundColor3 == CrystalPurple
            btn.BackgroundColor3 = active and DarkColor or CrystalPurple
            btn.BackgroundTransparency = active and 0.3 or 0
        end
    end)
end

local EspBtn = Instance.new("TextButton", MainMenu)
EspBtn.Size = UDim2.new(1, -20, 0, 30); EspBtn.Position = UDim2.new(0, 10, 0, 15)
EspBtn.BackgroundColor3 = DarkColor; EspBtn.BackgroundTransparency = 0.3; EspBtn.TextColor3 = Color3.fromRGB(255, 255, 255); EspBtn.Text = "Player Esp"; EspBtn.Font = Enum.Font.GothamBold; EspBtn.TextSize = 10
StyleButton(EspBtn, BorderThickness)

local Grid = Instance.new("Frame", MainMenu)
Grid.Size = UDim2.new(1, -20, 0, 175); Grid.Position = UDim2.new(0, 10, 0, 55); Grid.BackgroundTransparency = 1
local UIGrid = Instance.new("UIGridLayout", Grid); UIGrid.CellSize = UDim2.new(0, 75, 0, 28); UIGrid.CellPadding = UDim2.new(0, 10, 0, 8)

local features = {"Bat Aimbot", "Steal Near", "Auto Medusa", "Auto Play", "Anti Fling", "Anti Ragdoll", "Un Walk", "Inf Jump", "Spin Bot", "Optimizer"}
for _, f in pairs(features) do 
    local btn = Instance.new("TextButton", Grid)
    btn.BackgroundColor3 = DarkColor; btn.BackgroundTransparency = 0.3; btn.TextColor3 = Color3.fromRGB(255, 255, 255); btn.Text = f; btn.Font = Enum.Font.GothamBold; btn.TextSize = 10
    StyleButton(btn, 1)
end

local SaveBtn = Instance.new("TextButton", MainMenu)
SaveBtn.Name = "SaveBtn"
SaveBtn.Size = UDim2.new(1, -20, 0, 30); SaveBtn.Position = UDim2.new(0, 10, 1, -45) -- مرفوع سنتين
SaveBtn.BackgroundColor3 = DarkColor; SaveBtn.BackgroundTransparency = 0.3; SaveBtn.TextColor3 = Color3.fromRGB(255, 255, 255); SaveBtn.Text = "Save Config"; SaveBtn.Font = Enum.Font.GothamBold; SaveBtn.TextSize = 10
StyleButton(SaveBtn, BorderThickness)

-- ========== 4. Floating Button (ارتفع سنتين) ==========
local SideButton = Instance.new("TextButton", ScreenGui)
SideButton.Size = UDim2.new(0, 50, 0, 50); SideButton.Position = UDim2.new(1, -65, 0.30, 0)
SideButton.BackgroundColor3 = CrystalPurple; SideButton.Text = ""; SideButton.BorderSizePixel = 0
Instance.new("UICorner", SideButton).CornerRadius = GlobalRadius
local SideStroke = Instance.new("UIStroke", SideButton); SideStroke.Color = Color3.fromRGB(255,255,255); SideStroke.Thickness = 1.5

for i=0,2 do
    local line = Instance.new("Frame", SideButton)
    line.Size = UDim2.new(0, 24, 0, 4); line.Position = UDim2.new(0.5, -12, 0, 15 + (i * 9)); line.BackgroundColor3 = Color3.fromRGB(255, 255, 255); line.BorderSizePixel = 0; Instance.new("UICorner", line).CornerRadius = UDim.new(0, 2)
end

local dragging, dragStart, startPos
local menuOpen = false

SideButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = SideButton.Position
        local startTick = tick()
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
                if (tick() - startTick) < 0.25 and (input.Position - dragStart).Magnitude < 5 then
                    menuOpen = not menuOpen
                    MainMenu:TweenPosition(UDim2.new(menuOpen and 0.02 or -0.7, 0, 0.5, -140), "Out", "Quart", 0.4, true)
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

-- ========== 5. Update Loop ==========
task.spawn(function()
    while task.wait(0.2) do
        pcall(function()
            local fps = math.floor(1 / RunService.RenderStepped:Wait())
            local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            Info.Text = "Crystal Hub | FPS " .. fps .. " | MS " .. ping
            if SpeedLabel and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                SpeedLabel.Text = "Speed: " .. math.floor(Player.Character.HumanoidRootPart.Velocity.Magnitude)
            end
        end)
    end
end)
