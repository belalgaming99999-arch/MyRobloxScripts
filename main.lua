-- [[ Crystal Hub - Fully Draggable & Universal Edition ]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Player = Players.LocalPlayer

-- الألوان الموحدة
local CrystalPurple = Color3.fromRGB(120, 0, 255) 
local PureBlack = Color3.fromRGB(0, 0, 0)
local PureWhite = Color3.fromRGB(255, 255, 255)

-- تنظيف الواجهات القديمة
local function ForceClean()
    local name = "Crystal_Final_UI"
    pcall(function()
        if game:GetService("CoreGui"):FindFirstChild(name) then game:GetService("CoreGui")[name]:Destroy() end
        if Player:WaitForChild("PlayerGui"):FindFirstChild(name) then Player.PlayerGui[name]:Destroy() end
    end)
end
ForceClean()

-- إنشاء حاوية الواجهة
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Crystal_Final_UI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 999999
pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not ScreenGui.Parent then ScreenGui.Parent = Player:WaitForChild("PlayerGui") end

-- [[ وظيفة السحب (Drag Function) ]]
local function MakeDraggable(gui)
    local dragging, dragInput, dragStart, startPos
    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    gui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- [[ 1. القوائم المركزية (ثابتة في الأعلى مع أنيميشن دخول) ]]
local MainBar = Instance.new("Frame", ScreenGui)
MainBar.Size = UDim2.new(0, 250, 0, 34)
MainBar.Position = UDim2.new(0.5, -125, -0.2, 0)
MainBar.BackgroundColor3 = PureBlack
MainBar.BackgroundTransparency = 0.15
Instance.new("UICorner", MainBar).CornerRadius = UDim.new(0, 15)
Instance.new("UIStroke", MainBar).Color = CrystalPurple

local InfoLabel = Instance.new("TextLabel", MainBar)
InfoLabel.Size = UDim2.new(1, 0, 1, 0); InfoLabel.BackgroundTransparency = 1
InfoLabel.TextColor3 = CrystalPurple; InfoLabel.TextSize = 14; InfoLabel.Font = Enum.Font.GothamBold
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
    t.Text = txt; t.TextColor3 = PureWhite; t.TextSize = 10; t.Font = Enum.Font.GothamBold
end
CreatePart(UDim2.new(0, 0, 0, 0), UDim2.new(0.49, 0, 1, 0), 0.5, "0%") 
CreatePart(UDim2.new(0.51, 0, 0, 0), UDim2.new(0.49, 0, 1, 0), 0.15, "7.4") 

-- [[ 2. زر المنيو (قابل للسحب) ]]
local SideButton = Instance.new("TextButton", ScreenGui)
SideButton.Size = UDim2.new(0, 46, 0, 46)
SideButton.Position = UDim2.new(1.2, 0, 0.9, -110)
SideButton.BackgroundColor3 = CrystalPurple
SideButton.Text = ""
Instance.new("UICorner", SideButton).CornerRadius = UDim.new(0, 15)
MakeDraggable(SideButton) -- تفعيل السحب للزر

local LinesFrame = Instance.new("Frame", SideButton)
LinesFrame.Size = UDim2.new(0.5, 0, 0.4, 0); LinesFrame.Position = UDim2.new(0.25, 0, 0.3, 0); LinesFrame.BackgroundTransparency = 1
local function CreateLine(p)
    local l = Instance.new("Frame", LinesFrame); l.Size = UDim2.new(1, 0, 0.18, 0)
    l.Position = UDim2.new(0, 0, p, 0); l.BackgroundColor3 = PureWhite; l.BorderSizePixel = 0
    Instance.new("UICorner", l).CornerRadius = UDim.new(0, 2)
end
CreateLine(0); CreateLine(0.4); CreateLine(0.8)

-- [[ 3. القائمة الجانبية (قابلة للسحب) ]]
local SideMenu = Instance.new("Frame", ScreenGui)
SideMenu.Size = UDim2.new(0, 160, 0, 220)
SideMenu.Position = UDim2.new(-0.6, 0, 0.4, 0)
SideMenu.BackgroundColor3 = PureBlack
SideMenu.BackgroundTransparency = 0.1
Instance.new("UICorner", SideMenu).CornerRadius = UDim.new(0, 15)
Instance.new("UIStroke", SideMenu).Color = CrystalPurple
MakeDraggable(SideMenu) -- تفعيل السحب للمنيو

-- [[ أنيميشن الدخول ]]
local it = TweenInfo.new(1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
TweenService:Create(MainBar, it, {Position = UDim2.new(0.5, -125, 0.04, 0)}):Play()
TweenService:Create(BottomBar, it, {Position = UDim2.new(0.5, -125, 0.04, 40)}):Play()
TweenService:Create(SideButton, it, {Position = UDim2.new(1, -65, 0.9, -110)}):Play()

-- برمجة فتح المنيو
local menuOpen = false
SideButton.MouseButton1Click:Connect(function()
    if menuOpen == false then
        menuOpen = true
        SideMenu.Position = UDim2.new(0.02, 0, 0.4, 0) -- تظهر في مكان افتراضي عند الفتح
    else
        menuOpen = false
        SideMenu.Position = UDim2.new(-0.6, 0, 0.4, 0)
    end
end)

-- [[ 4. نظام السرعة والتحديث البطيء ]]
local function SetupSpeedTag(p)
    p.CharacterAdded:Connect(function(char)
        local head = char:WaitForChild("Head", 15)
        local bill = Instance.new("BillboardGui", head)
        bill.Name = "CrystalTag"; bill.Size = UDim2.new(0, 80, 0, 20); bill.StudsOffset = Vector3.new(0, 3.5, 0); bill.AlwaysOnTop = true
        local label = Instance.new("TextLabel", bill)
        label.Size = UDim2.new(1, 0, 1, 0); label.BackgroundTransparency = 1; label.TextColor3 = PureWhite; label.TextSize = 11; label.Font = Enum.Font.GothamBold
        RunService.Heartbeat:Connect(function()
            if char:FindFirstChild("HumanoidRootPart") then
                label.Text = p == Player and "Speed: " .. string.format("%.1f", char.HumanoidRootPart.Velocity.Magnitude) or p.DisplayName
            end
        end)
    end)
    if p.Character then task.spawn(function()
        local char = p.Character
        local head = char:WaitForChild("Head", 15)
        local bill = Instance.new("BillboardGui", head)
        bill.Name = "CrystalTag"; bill.Size = UDim2.new(0, 80, 0, 20); bill.StudsOffset = Vector3.new(0, 3.5, 0); bill.AlwaysOnTop = true
        local label = Instance.new("TextLabel", bill)
        label.Size = UDim2.new(1, 0, 1, 0); label.BackgroundTransparency = 1; label.TextColor3 = PureWhite; label.TextSize = 11; label.Font = Enum.Font.GothamBold
        RunService.Heartbeat:Connect(function()
            if char:FindFirstChild("HumanoidRootPart") then
                label.Text = p == Player and "Speed: " .. string.format("%.1f", char.HumanoidRootPart.Velocity.Magnitude) or p.DisplayName
            end
        end)
    end) end
end
for _, v in pairs(Players:GetPlayers()) do SetupSpeedTag(v) end
Players.PlayerAdded:Connect(SetupSpeedTag)

task.spawn(function()
    while true do
        local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        local fps = math.floor(1 / (RunService.RenderStepped:Wait()))
        InfoLabel.Text = string.format("Crystal Hub | FPS %d | MS %d", fps, ping)
        task.wait(1.2)
    end
end)
