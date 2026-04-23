-- [[ Crystal Hub - Complete Logic Edition ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Player = Players.LocalPlayer

-- الألوان
local CrystalPurple = Color3.fromRGB(120, 0, 255)
local PureBlack = Color3.fromRGB(0, 0, 0)
local PureWhite = Color3.fromRGB(255, 255, 255)
local ButtonColor = Color3.fromRGB(30, 30, 30)

-- تنظيف قديم
local UI_NAME = "Crystal_Full_Logic"
pcall(function()
    if game:GetService("CoreGui"):FindFirstChild(UI_NAME) then game:GetService("CoreGui")[UI_NAME]:Destroy() end
    if Player.PlayerGui:FindFirstChild(UI_NAME) then Player.PlayerGui[UI_NAME]:Destroy() end
end)

local ScreenGui = Instance.new("ScreenGui", Player.PlayerGui)
ScreenGui.Name = UI_NAME
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true

-- متغيرات التفعيل
local Flags = {
    Esp = false,
    Aimbot = false,
    AutoSteal = false
}

-- [[ وظيفة السحب للأيقونة ]] --
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
            if delta.Magnitude > 7 then 
                moved = true
                gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end
    end)
    gui.InputEnded:Connect(function(input) dragging = false end)
    return function() return not moved end 
end

-- [[ الواجهات الثابتة ]] --
local MainContainer = Instance.new("Frame", ScreenGui)
MainContainer.Size = UDim2.new(0, 250, 0, 60); MainContainer.Position = UDim2.new(0.5, -125, 0.18, 0); MainContainer.BackgroundTransparency = 1

local TopBar = Instance.new("Frame", MainContainer)
TopBar.Size = UDim2.new(1, 0, 0, 34); TopBar.BackgroundColor3 = PureBlack; TopBar.BackgroundTransparency = 0.15
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 15)
Instance.new("UIStroke", TopBar).Color = CrystalPurple

local InfoLabel = Instance.new("TextLabel", TopBar)
InfoLabel.Size = UDim2.new(1, 0, 1, 0); InfoLabel.BackgroundTransparency = 1; InfoLabel.TextColor3 = CrystalPurple; InfoLabel.TextSize = 14; InfoLabel.Font = Enum.Font.GothamBold; InfoLabel.Text = "Crystal Hub | FPS -- | MS --"

-- [[ المنيو الجانبي الشفاف ]] --
local SideMenu = Instance.new("Frame", ScreenGui)
SideMenu.Size = UDim2.new(0, 160, 0, 250); SideMenu.Position = UDim2.new(-0.7, 0, 0.35, 0); SideMenu.BackgroundColor3 = PureBlack; SideMenu.BackgroundTransparency = 0.5
Instance.new("UICorner", SideMenu).CornerRadius = UDim.new(0, 15)
Instance.new("UIStroke", SideMenu).Color = CrystalPurple

local UIList = Instance.new("UIListLayout", SideMenu)
UIList.Padding = UDim.new(0, 10); UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
Instance.new("UIPadding", SideMenu).PaddingTop = UDim.new(0, 15)

-- [[ نظام الأزرار وربط التفعيلات ]] --
local function CreateToggle(name, text, parent, size)
    local btn = Instance.new("TextButton", parent)
    btn.Size = size or UDim2.new(0, 140, 0, 45)
    btn.BackgroundColor3 = ButtonColor; btn.BackgroundTransparency = 0.2; btn.Text = text; btn.TextColor3 = PureWhite; btn.Font = Enum.Font.GothamBold; btn.TextSize = 12
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
    Instance.new("UIStroke", btn).Color = CrystalPurple

    btn.MouseButton1Click:Connect(function()
        Flags[name] = not Flags[name]
        btn.BackgroundColor3 = Flags[name] and CrystalPurple or ButtonColor
        btn.BackgroundTransparency = Flags[name] and 0 or 0.2
        print(text .. " is now: " .. tostring(Flags[name]))
    end)
    return btn
end

local EspBtn = CreateToggle("Esp", "Esp Player", SideMenu)

local DoubleCont = Instance.new("Frame", SideMenu)
DoubleCont.Size = UDim2.new(0, 140, 0, 40); DoubleCont.BackgroundTransparency = 1
Instance.new("UIListLayout", DoubleCont).FillDirection = Enum.FillDirection.Horizontal
DoubleCont.UIListLayout.Padding = UDim.new(0, 8); DoubleCont.UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local AimBtn = CreateToggle("Aimbot", "AimBot", DoubleCont, UDim2.new(0, 66, 1, 0))
local StealBtn = CreateToggle("AutoSteal", "Auto Steal", DoubleCont, UDim2.new(0, 66, 1, 0))

-- [[ زر الأيقونة القابل للسحب ]] --
local SideButton = Instance.new("TextButton", ScreenGui)
SideButton.Size = UDim2.new(0, 60, 0, 60); SideButton.Position = UDim2.new(1, -75, 0.30, 0); SideButton.BackgroundColor3 = CrystalPurple; SideButton.Text = ""
Instance.new("UICorner", SideButton).CornerRadius = UDim.new(0, 15)
local canOpen = MakeDraggable(SideButton) 

for i=0,2 do
    local l = Instance.new("Frame", SideButton)
    l.Size = UDim2.new(0.5, 0, 0.08, 0); l.Position = UDim2.new(0.25, 0, 0.35 + (i*0.15), 0); l.BackgroundColor3 = PureWhite; Instance.new("UICorner", l).CornerRadius = UDim.new(0, 2)
end

local menuOpen = false
SideButton.MouseButton1Up:Connect(function()
    if canOpen() then 
        menuOpen = not menuOpen
        SideMenu:TweenPosition(UDim2.new(menuOpen and 0.02 or -0.7, 0, 0.35, 0), "Out", "Quart", 0.4, true)
    end
end)

-- [[ نظام الـ Speed Tag (مرفوع 4.2) ]] --
local function CreateTag(p)
    p.CharacterAdded:Connect(function(char)
        local h = char:WaitForChild("Head", 10)
        local b = Instance.new("BillboardGui", h)
        b.Name = "CrystalTag"; b.Size = UDim2.new(0, 150, 0, 50); b.StudsOffset = Vector3.new(0, 4.2, 0); b.AlwaysOnTop = true
        local l = Instance.new("TextLabel", b); l.Size = UDim2.new(1, 0, 1, 0); l.BackgroundTransparency = 1; l.TextColor3 = PureWhite; l.TextSize = 14; l.Font = Enum.Font.GothamBold
        
        RunService.RenderStepped:Connect(function()
            if char:FindFirstChild("HumanoidRootPart") then
                if p == Player then
                    l.Text = "Speed: " .. string.format("%.1f", char.HumanoidRootPart.Velocity.Magnitude)
                else
                    l.Text = p.DisplayName
                end
            end
            -- إخفاء التاج لو حبيت تعمل زر لإخفائه مستقبلاً
            b.Enabled = true 
        end)
    end)
    if p.Character then p:CharacterAdded(p.Character) end
end
for _, v in pairs(Players:GetPlayers()) do CreateTag(v) end
Players.PlayerAdded:Connect(CreateTag)

-- [[ تحديث البيانات (FPS/MS) ]] --
task.spawn(function()
    while true do
        pcall(function()
            local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            local fps = math.floor(1 / RunService.RenderStepped:Wait())
            InfoLabel.Text = string.format("Crystal Hub | FPS %d | MS %d", fps, ping)
        end)
        task.wait(1)
    end
end)
