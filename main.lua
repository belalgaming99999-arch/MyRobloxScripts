-- [[ Crystal Hub - Smart Drag & Oval Sync ]] --

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

-- تنظيف النسخ السابقة
local function FullCleanup()
    for _, child in pairs(CoreGui:GetChildren()) do
        if child:IsA("ScreenGui") and (child.Name:find("Crystal") or child.Name:find("Nova")) then child:Destroy() end
    end
end
FullCleanup()

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "Crystal_Smart_UI"

-- ========== 1. Top HUD (Oval 15) ==========
local HUDContainer = Instance.new("Frame", ScreenGui)
HUDContainer.Size = UDim2.new(0, 230, 0, 70); HUDContainer.Position = UDim2.new(0.5, -115, 0.02, 0); HUDContainer.BackgroundTransparency = 1

local TopBar = Instance.new("Frame", HUDContainer)
TopBar.Size = UDim2.new(0.9, 0, 0, 28); TopBar.Position = UDim2.new(0.05, 0, 0, 0); TopBar.BackgroundColor3 = DarkColor; TopBar.BackgroundTransparency = 0.2
Instance.new("UICorner", TopBar).CornerRadius = GlobalRadius
local TopS = Instance.new("UIStroke", TopBar); TopS.Color = CrystalPurple; TopS.Thickness = BorderThickness

local Info = Instance.new("TextLabel", TopBar)
Info.Size = UDim2.new(1,0,1,0); Info.BackgroundTransparency = 1; Info.TextColor3 = Color3.fromRGB(255, 255, 255); Info.Font = Enum.Font.GothamBold; Info.TextSize = 10
Info.Text = "Crystal Hub | FPS 0 | MS 0" 

-- ========== 2. Speed Tag ==========
local SpeedLabel
local function CreateSpeedTag(char)
    if char:FindFirstChild("SpeedTag") then char.SpeedTag:Destroy() end
    local head = char:WaitForChild("Head", 5)
    local billboard = Instance.new("BillboardGui", char)
    billboard.Name = "SpeedTag"; billboard.Adornee = head; billboard.Size = UDim2.new(0, 120, 0, 40); billboard.StudsOffset = Vector3.new(0, 3.2, 0); billboard.AlwaysOnTop = true
    local label = Instance.new("TextLabel", billboard); label.Size = UDim2.new(1, 0, 1, 0); label.BackgroundTransparency = 1; label.TextColor3 = Color3.fromRGB(255, 255, 255); label.Font = Enum.Font.GothamBold; label.TextSize = 11; label.Text = "Speed: 0.0"
    local stroke = Instance.new("UIStroke", label); stroke.Color = Color3.fromRGB(0, 0, 0); stroke.Thickness = 1; stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
    SpeedLabel = label
end
Player.CharacterAdded:Connect(CreateSpeedTag)
if Player.Character then CreateSpeedTag(Player.Character) end

-- ========== 3. Main Side Menu (Oval 15) ==========
local MainMenu = Instance.new("Frame", ScreenGui)
MainMenu.Size = UDim2.new(0, 170, 0, 255); MainMenu.Position = UDim2.new(-0.7, 0, 0.5, -127) 
MainMenu.BackgroundColor3 = DarkColor; MainMenu.BackgroundTransparency = 0.4
Instance.new("UICorner", MainMenu).CornerRadius = GlobalRadius
local MenuS = Instance.new("UIStroke", MainMenu); MenuS.Color = CrystalPurple; MenuS.Thickness = BorderThickness

local function StyleButton(btn, thick)
    btn.AutoButtonColor = false; Instance.new("UICorner", btn).CornerRadius = GlobalRadius
    local s = Instance.new("UIStroke", btn); s.Color = CrystalPurple; s.Thickness = thick or 1.2
    btn.MouseButton1Click:Connect(function()
        if btn.Name ~= "SaveBtn" then
            local active = btn.BackgroundColor3 == CrystalPurple
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = active and DarkColor or CrystalPurple, BackgroundTransparency = active and 0.3 or 0}):Play()
        end
    end)
end

local EspBtn = Instance.new("TextButton", MainMenu)
EspBtn.Size = UDim2.new(0, 150, 0, 28); EspBtn.Position = UDim2.new(0.5, -75, 0, 12)
EspBtn.BackgroundColor3 = DarkColor; EspBtn.BackgroundTransparency = 0.3; EspBtn.TextColor3 = Color3.fromRGB(255, 255, 255); EspBtn.Text = "Player Esp"; EspBtn.Font = Enum.Font.GothamBold; EspBtn.TextSize = 10
StyleButton(EspBtn, 1.5)

local Grid = Instance.new("Frame", MainMenu)
Grid.Size = UDim2.new(1, -20, 0, 160); Grid.Position = UDim2.new(0, 10, 0, 48); Grid.BackgroundTransparency = 1
local UIGrid = Instance.new("UIGridLayout", Grid); UIGrid.CellSize = UDim2.new(0, 70, 0, 26); UIGrid.CellPadding = UDim2.new(0, 10, 0, 6)

local features = {"Bat Aimbot", "Steal Near", "Auto Medusa", "Auto Play", "Anti Fling", "Anti Ragdoll", "Un Walk", "Inf Jump", "Spin Bot", "Optimizer"}
for _, f in pairs(features) do 
    local btn = Instance.new("TextButton", Grid)
    btn.BackgroundColor3 = DarkColor; btn.BackgroundTransparency = 0.3; btn.TextColor3 = Color3.fromRGB(255, 255, 255); btn.Text = f; btn.Font = Enum.Font.GothamBold; btn.TextSize = 10
    StyleButton(btn, 1)
end

local SaveBtn = Instance.new("TextButton", MainMenu)
SaveBtn.Name = "SaveBtn"
SaveBtn.Size = UDim2.new(0, 150, 0, 28); SaveBtn.Position = UDim2.new(0.5, -75, 1, -42) 
SaveBtn.BackgroundColor3 = DarkColor; SaveBtn.BackgroundTransparency = 0.3; SaveBtn.TextColor3 = Color3.fromRGB(255, 255, 255); SaveBtn.Text = "Save Config"; SaveBtn.Font = Enum.Font.GothamBold; SaveBtn.TextSize = 10
StyleButton(SaveBtn, 1.5)

-- ========== 4. Floating Button (Smart Dragging + Oval 15) ==========
local SideButton = Instance.new("TextButton", ScreenGui)
SideButton.Size = UDim2.new(0, 50, 0, 50)
-- رفعناها سنتين (من 0.35 إلى 0.33)
SideButton.Position = UDim2.new(1, -60, 0.33, 0) 
SideButton.BackgroundColor3 = CrystalPurple; SideButton.Text = ""; SideButton.BorderSizePixel = 0; SideButton.AutoButtonColor = false
Instance.new("UICorner", SideButton).CornerRadius = GlobalRadius
local SideStroke = Instance.new("UIStroke", SideButton); SideStroke.Color = Color3.fromRGB(255,255,255); SideStroke.Thickness = 1.5

for i=0,2 do
    local line = Instance.new("Frame", SideButton)
    line.Size = UDim2.new(0, 24, 0, 4); line.Position = UDim2.new(0.5, -12, 0, 15 + (i * 9)); line.BackgroundColor3 = Color3.fromRGB(255, 255, 255); line.BorderSizePixel = 0; Instance.new("UICorner", line).CornerRadius = UDim.new(0, 2)
end

-- نظام التحريك الذكي
local dragging, dragInput, dragStart, startPos
local menuOpen = false
local dragThreshold = 5 -- المسافة المطلوبة لاعتبار الحركة "سحباً" وليس "ضغطة"
local startTime

local function update(input)
    local delta = input.Position - dragStart
    SideButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

SideButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = SideButton.Position
        startTime = tick()
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
                -- إذا كان الوقت قصير والمسافة صغيرة، نعتبرها ضغطة لفتح القائمة
                local duration = tick() - startTime
                local distance = (input.Position - dragStart).Magnitude
                if duration < 0.3 and distance < dragThreshold then
                    menuOpen = not menuOpen
                    MainMenu:TweenPosition(UDim2.new(menuOpen and 0.02 or -0.7, 0, 0.5, -127), "Out", "Quart", 0.4, true)
                end
            end
        end)
    end
end)

SideButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- ========== 5. Update Loop ==========
task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            local fps = math.floor(1 / RunService.RenderStepped:Wait())
            local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            Info.Text = string.format("Crystal Hub | FPS %d | MS %d", fps, ping)
        end)
    end
end)
