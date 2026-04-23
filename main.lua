local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Player = Players.LocalPlayer

local CrystalPurple = Color3.fromRGB(120, 0, 255) 
local PureBlack = Color3.fromRGB(0, 0, 0)
local PureWhite = Color3.fromRGB(255, 255, 255)
local ButtonColor = Color3.fromRGB(30, 30, 30)

-- [[ تنظيف أي نسخة قديمة ]] --
local UI_NAME = "Crystal_Final_Final"
pcall(function()
    if game:GetService("CoreGui"):FindFirstChild(UI_NAME) then game:GetService("CoreGui")[UI_NAME]:Destroy() end
    if Player.PlayerGui:FindFirstChild(UI_NAME) then Player.PlayerGui[UI_NAME]:Destroy() end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = UI_NAME
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 999999
pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not ScreenGui.Parent then ScreenGui.Parent = Player:WaitForChild("PlayerGui") end

-- [[ وظيفة السحب للأيقونة فقط ]] --
local function MakeDraggable(gui)
    local dragging, dragInput, dragStart, startPos
    local moved = false
    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; moved = false; dragStart = input.Position; startPos = gui.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            if delta.Magnitude > 5 then 
                moved = true
                gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end
    end)
    gui.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
    return function() return not moved end 
end

-- [[ اللوحة المركزية والسفلية - ثابتة ]] --
local MainContainer = Instance.new("Frame", ScreenGui)
MainContainer.Size = UDim2.new(0, 250, 0, 60); MainContainer.Position = UDim2.new(0.5, -125, 0.18, 0); MainContainer.BackgroundTransparency = 1

local TopBar = Instance.new("Frame", MainContainer)
TopBar.Size = UDim2.new(1, 0, 0, 34); TopBar.BackgroundColor3 = PureBlack; TopBar.BackgroundTransparency = 0.15
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 15)
Instance.new("UIStroke", TopBar).Color = CrystalPurple

local InfoLabel = Instance.new("TextLabel", TopBar)
InfoLabel.Size = UDim2.new(1, 0, 1, 0); InfoLabel.BackgroundTransparency = 1; InfoLabel.TextColor3 = CrystalPurple; InfoLabel.TextSize = 14; InfoLabel.Font = Enum.Font.GothamBold; InfoLabel.Text = "Crystal Hub | FPS .. | MS .."

local BottomBar = Instance.new("Frame", MainContainer)
BottomBar.Size = UDim2.new(1, 0, 0, 16); BottomBar.Position = UDim2.new(0, 0, 0, 40); BottomBar.BackgroundTransparency = 1
local function CreateStatPart(pos, size, trans, txt)
    local f = Instance.new("Frame", BottomBar)
    f.Size = size; f.Position = pos; f.BackgroundColor3 = PureBlack; f.BackgroundTransparency = trans
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 20)
    local t = Instance.new("TextLabel", f)
    t.Size = UDim2.new(1, 0, 1, 0); t.BackgroundTransparency = 1; t.Text = txt; t.TextColor3 = PureWhite; t.TextSize = 10; t.Font = Enum.Font.GothamBold
end
CreateStatPart(UDim2.new(0, 0, 0, 0), UDim2.new(0.49, 0, 1, 0), 0.5, "0%") 
CreateStatPart(UDim2.new(0.51, 0, 0, 0), UDim2.new(0.49, 0, 1, 0), 0.15, "7.4") 

-- [[ المنيو الجانبي - شفاف وثابت ]] --
local SideMenu = Instance.new("Frame", ScreenGui)
SideMenu.Size = UDim2.new(0, 160, 0, 250); SideMenu.Position = UDim2.new(-0.7, 0, 0.35, 0); SideMenu.BackgroundColor3 = PureBlack; SideMenu.BackgroundTransparency = 0.5
Instance.new("UICorner", SideMenu).CornerRadius = UDim.new(0, 15)
Instance.new("UIStroke", SideMenu).Color = CrystalPurple; Instance.new("UIStroke", SideMenu).Thickness = 2

local UIList = Instance.new("UIListLayout", SideMenu)
UIList.Padding = UDim.new(0, 10); UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
Instance.new("UIPadding", SideMenu).PaddingTop = UDim.new(0, 15)

-- [[ وظيفة إنشاء الأزرار ]] --
local function CreateButton(text, parent, size)
    local btn = Instance.new("TextButton", parent)
    btn.Size = size or UDim2.new(0, 140, 0, 45)
    btn.BackgroundColor3 = ButtonColor; btn.BackgroundTransparency = 0.15; btn.Text = text; btn.TextColor3 = PureWhite; btn.Font = Enum.Font.GothamBold; btn.TextSize = 12
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
    local s = Instance.new("UIStroke", btn); s.Color = CrystalPurple; s.Thickness = 1.5
    local act = false
    btn.MouseButton1Click:Connect(function()
        act = not act
        btn.BackgroundColor3 = act and CrystalPurple or ButtonColor
        btn.BackgroundTransparency = act and 0 or 0.15
    end)
    return btn
end

local EspBtn = CreateButton("Esp Player", SideMenu)

local DoubleFrame = Instance.new("Frame", SideMenu)
DoubleFrame.Size = UDim2.new(0, 140, 0, 40); DoubleFrame.BackgroundTransparency = 1
local DL = Instance.new("UIListLayout", DoubleFrame); DL.FillDirection = Enum.FillDirection.Horizontal; DL.Padding = UDim.new(0, 8); DL.HorizontalAlignment = Enum.HorizontalAlignment.Center

local AimBtn = CreateButton("AimBot", DoubleFrame, UDim2.new(0, 66, 1, 0))
local StealBtn = CreateButton("Auto Steal", DoubleFrame, UDim2.new(0, 66, 1, 0))

-- [[ زر الأيقونة - قابل للسحب ]] --
local SideButton = Instance.new("TextButton", ScreenGui)
SideButton.Size = UDim2.new(0, 60, 0, 60); SideButton.Position = UDim2.new(1, -75, 0.30, 0); SideButton.BackgroundColor3 = CrystalPurple; SideButton.Text = ""
Instance.new("UICorner", SideButton).CornerRadius = UDim.new(0, 15)
local canOpen = MakeDraggable(SideButton) 
for i=0,2 do
    local l = Instance.new("Frame", SideButton); l.Size = UDim2.new(0.5, 0, 0.08, 0); l.Position = UDim2.new(0.25, 0, 0.35 + (i*0.15), 0); l.BackgroundColor3 = PureWhite; l.BorderSizePixel = 0; Instance.new("UICorner", l).CornerRadius = UDim.new(0, 2)
end

local menuOpen = false
SideButton.MouseButton1Up:Connect(function()
    if canOpen() then 
        menuOpen = not menuOpen
        SideMenu:TweenPosition(UDim2.new(menuOpen and 0.02 or -0.7, 0, 0.35, 0), "Out", "Quart", 0.4, true)
    end
end)

-- [[ السرعة والتاج ]] --
local function CreateTag(p)
    p.CharacterAdded:Connect(function(char)
        local h = char:WaitForChild("Head", 10); local b = Instance.new("BillboardGui", h)
        b.Size = UDim2.new(0, 120, 0, 40); b.StudsOffset = Vector3.new(0, 4.2, 0); b.AlwaysOnTop = true
        local l = Instance.new("TextLabel", b); l.Size = UDim2.new(1, 0, 1, 0); l.BackgroundTransparency = 1; l.TextColor3 = PureWhite; l.TextSize = 14; l.Font = Enum.Font.GothamBold
        RunService.RenderStepped:Connect(function()
            if char:FindFirstChild("HumanoidRootPart") then
                l.Text = (p == Player) and ("Speed: "..string.format("%.1f", char.HumanoidRootPart.Velocity.Magnitude)) or p.DisplayName
            end
        end)
    end)
    if p.Character then p:CharacterAdded(p.Character) end
end
for _, v in pairs(Players:GetPlayers()) do CreateTag(v) end
Players.PlayerAdded:Connect(CreateTag)

task.spawn(function()
    while true do
        local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        local fps = math.floor(1 / (RunService.RenderStepped:Wait()))
        InfoLabel.Text = string.format("Crystal Hub | FPS %d | MS %d", fps, ping)
        task.wait(1)
    end
end)
