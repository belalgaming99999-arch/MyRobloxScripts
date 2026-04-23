local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Player = Players.LocalPlayer

local CrystalPurple = Color3.fromRGB(120, 0, 255) 
local PureBlack = Color3.fromRGB(0, 0, 0)
local PureWhite = Color3.fromRGB(255, 255, 255)

-- تنظيف الواجهة القديمة
local UI_NAME = "Crystal_Final_UI"
local function CleanUI()
    pcall(function()
        if game:GetService("CoreGui"):FindFirstChild(UI_NAME) then game:GetService("CoreGui")[UI_NAME]:Destroy() end
        if Player:WaitForChild("PlayerGui"):FindFirstChild(UI_NAME) then Player.PlayerGui[UI_NAME]:Destroy() end
    end)
end
CleanUI()

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = UI_NAME
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 999999
pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not ScreenGui.Parent then ScreenGui.Parent = Player:WaitForChild("PlayerGui") end

-- [[ وظيفة السحب السلسة جداً ]] --
local function MakeDraggable(gui)
    local dragging, dragInput, dragStart, startPos
    local moved = false

    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            moved = false
            dragStart = input.Position
            startPos = gui.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            if delta.Magnitude > 5 then -- لو اتحرك اكتر من 5 بكسل يبقى سحب
                moved = true
                gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end
    end)

    gui.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    return function() return not moved end -- بترجع "صح" لو ملمسش الشاشة بحركة سحب
end

-- [[ اللوحة المركزية ]] --
local MainContainer = Instance.new("Frame", ScreenGui)
MainContainer.Size = UDim2.new(0, 250, 0, 60)
MainContainer.Position = UDim2.new(0.5, -125, 0.18, 0) 
MainContainer.BackgroundTransparency = 1
MakeDraggable(MainContainer)

local TopBar = Instance.new("Frame", MainContainer)
TopBar.Size = UDim2.new(1, 0, 0, 34)
TopBar.BackgroundColor3 = PureBlack; TopBar.BackgroundTransparency = 0.15
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 15)
Instance.new("UIStroke", TopBar).Color = CrystalPurple

local InfoLabel = Instance.new("TextLabel", TopBar)
InfoLabel.Size = UDim2.new(1, 0, 1, 0); InfoLabel.BackgroundTransparency = 1
InfoLabel.TextColor3 = CrystalPurple; InfoLabel.TextSize = 14; InfoLabel.Font = Enum.Font.GothamBold
InfoLabel.Text = "Crystal Hub | FPS .. | MS .."

-- القائمة السفلية
local BottomBar = Instance.new("Frame", MainContainer)
BottomBar.Size = UDim2.new(1, 0, 0, 16)
BottomBar.Position = UDim2.new(0, 0, 0, 40)
BottomBar.BackgroundTransparency = 1

local function CreateStatPart(pos, size, trans, txt)
    local f = Instance.new("Frame", BottomBar)
    f.Size = size; f.Position = pos; f.BackgroundColor3 = PureBlack; f.BackgroundTransparency = trans
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 20)
    local t = Instance.new("TextLabel", f)
    t.Size = UDim2.new(1, 0, 1, 0); t.BackgroundTransparency = 1
    t.Text = txt; t.TextColor3 = PureWhite; t.TextSize = 10; t.Font = Enum.Font.GothamBold
end
CreateStatPart(UDim2.new(0, 0, 0, 0), UDim2.new(0.49, 0, 1, 0), 0.5, "0%") 
CreateStatPart(UDim2.new(0.51, 0, 0, 0), UDim2.new(0.49, 0, 1, 0), 0.15, "7.4") 

-- [[ زر الأيقونة الجانبي ]] --
local SideButton = Instance.new("TextButton", ScreenGui)
SideButton.Size = UDim2.new(0, 60, 0, 60)
SideButton.Position = UDim2.new(1, -75, 0.30, 0) 
SideButton.BackgroundColor3 = CrystalPurple; SideButton.Text = ""
Instance.new("UICorner", SideButton).CornerRadius = UDim.new(0, 15)
local canOpen = MakeDraggable(SideButton) 

local LinesFrame = Instance.new("Frame", SideButton)
LinesFrame.Size = UDim2.new(0.5, 0, 0.4, 0); LinesFrame.Position = UDim2.new(0.25, 0, 0.3, 0); LinesFrame.BackgroundTransparency = 1
for i=0,2 do
    local l = Instance.new("Frame", LinesFrame); l.Size = UDim2.new(1, 0, 0.18, 0)
    l.Position = UDim2.new(0, 0, i * 0.4, 0); l.BackgroundColor3 = PureWhite; l.BorderSizePixel = 0
    Instance.new("UICorner", l).CornerRadius = UDim.new(0, 2)
end

-- [[ المنيو الجانبي ]] --
local SideMenu = Instance.new("Frame", ScreenGui)
SideMenu.Size = UDim2.new(0, 160, 0, 250)
SideMenu.Position = UDim2.new(-0.7, 0, 0.35, 0)
SideMenu.BackgroundColor3 = PureBlack; SideMenu.BackgroundTransparency = 0.1
Instance.new("UICorner", SideMenu).CornerRadius = UDim.new(0, 15)
Instance.new("UIStroke", SideMenu).Color = CrystalPurple
MakeDraggable(SideMenu)

local UIList = Instance.new("UIListLayout", SideMenu)
UIList.Padding = UDim.new(0, 10); UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
Instance.new("UIPadding", SideMenu).PaddingTop = UDim.new(0, 15)

-- زر Esp Player
local EspBtn = Instance.new("TextButton", SideMenu)
EspBtn.Size = UDim2.new(0, 140, 0, 45); EspBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
EspBtn.Text = "Esp Player"; EspBtn.TextColor3 = PureWhite; EspBtn.Font = Enum.Font.GothamBold; EspBtn.TextSize = 14
Instance.new("UICorner", EspBtn).CornerRadius = UDim.new(0, 10)
local EspStroke = Instance.new("UIStroke", EspBtn); EspStroke.Color = CrystalPurple

local menuOpen = false
SideButton.MouseButton1Up:Connect(function() -- استخدمنا MouseButton1Up لضمان انتهاء الحركة
    if canOpen() then 
        menuOpen = not menuOpen
        local targetX = menuOpen and 0.02 or -0.7
        TweenService:Create(SideMenu, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(targetX, 0, 0.35, 0)}):Play()
    end
end)

-- نظام السرعة والتاج
local function CreateTag(p)
    local function ApplyTag(char)
        local head = char:WaitForChild("Head", 10)
        local bill = Instance.new("BillboardGui", head)
        bill.Name = "CrystalTag"; bill.Size = UDim2.new(0, 120, 0, 40)
        bill.StudsOffset = Vector3.new(0, 4.2, 0); bill.AlwaysOnTop = true
        local label = Instance.new("TextLabel", bill)
        label.Size = UDim2.new(1, 0, 1, 0); label.BackgroundTransparency = 1; label.TextColor3 = PureWhite
        label.TextSize = 14; label.Font = Enum.Font.GothamBold
        RunService.RenderStepped:Connect(function()
            if char:FindFirstChild("HumanoidRootPart") then
                if p == Player then label.Text = "Speed: " .. string.format("%.1f", char.HumanoidRootPart.Velocity.Magnitude)
                else label.Text = p.DisplayName end
            end
        end)
    end
    p.CharacterAdded:Connect(ApplyTag)
    if p.Character then ApplyTag(p.Character) end
end
for _, v in pairs(Players:GetPlayers()) do CreateTag(v) end
Players.PlayerAdded:Connect(CreateTag)

-- تحديث الـ FPS
task.spawn(function()
    while true do
        local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        local fps = math.floor(1 / (RunService.RenderStepped:Wait()))
        InfoLabel.Text = string.format("Crystal Hub | FPS %d | MS %d", fps, ping)
        task.wait(1)
    end
end)
        bill.Name = "CrystalTag"; bill.Size = UDim2.new(0, 120, 0, 40)
        bill.StudsOffset = Vector3.new(0, 4.2, 0) -- الموقع اللي طلبته (مرفوع سنة)
        bill.AlwaysOnTop = true
        
        local label = Instance.new("TextLabel", bill)
        label.Size = UDim2.new(1, 0, 1, 0); label.BackgroundTransparency = 1; label.TextColor3 = PureWhite
        label.TextSize = 14; label.Font = Enum.Font.GothamBold; label.TextStrokeTransparency = 0.5

        RunService.RenderStepped:Connect(function()
            if char:FindFirstChild("HumanoidRootPart") then
                if p == Player then
                    label.Text = "Speed: " .. string.format("%.1f", char.HumanoidRootPart.Velocity.Magnitude)
                else
                    label.Text = p.DisplayName
                end
            end
        end)
    end)
end

-- تفعيل النظام فوراً للجميع ولنفسك
for _, v in pairs(Players:GetPlayers()) do CreateTag(v) if v.Character then CreateTag(v) end end
Players.PlayerAdded:Connect(CreateTag)

-- تحديث الـ FPS والـ MS باستمرار
task.spawn(function()
    while true do
        local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        local fps = math.floor(1 / (RunService.RenderStepped:Wait()))
        InfoLabel.Text = string.format("Crystal Hub | FPS %d | MS %d", fps, ping)
        task.wait(0.5)
    end
end)
