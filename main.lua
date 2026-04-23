-- [[ Crystal Hub - Color Matched Version ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local UserInputService = game:GetService("UserInputService")
local Player = Players.LocalPlayer

-- إعدادات الألوان المتطابقة مع اللوحة السفلية
local CrystalPurple = Color3.fromRGB(120, 0, 255)
local RightPartColor = Color3.fromRGB(0, 0, 0) -- لون الجزء اليمين (أسود)
local RightPartTrans = 0.15 -- شفافية الجزء اليمين
local LeftPartTrans = 0.5 -- شفافية الجزء الشمال (للخلفية)

local UI_NAME = "Crystal_Color_Matched"
pcall(function()
    if Player.PlayerGui:FindFirstChild(UI_NAME) then Player.PlayerGui[UI_NAME]:Destroy() end
end)

local ScreenGui = Instance.new("ScreenGui", Player.PlayerGui)
ScreenGui.Name = UI_NAME
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true

-- وظيفة السحب للأيقونة
local function MakeDraggable(gui)
    local dragging, dragStart, startPos
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
    gui.InputEnded:Connect(function() dragging = false end)
    return function() return not moved end 
end

-- [[ اللوحات الثابتة ]] --
local MainContainer = Instance.new("Frame", ScreenGui)
MainContainer.Size = UDim2.new(0, 250, 0, 60); MainContainer.Position = UDim2.new(0.5, -125, 0.18, 0); MainContainer.BackgroundTransparency = 1

local TopBar = Instance.new("Frame", MainContainer)
TopBar.Size = UDim2.new(1, 0, 0, 34); TopBar.BackgroundColor3 = Color3.fromRGB(0,0,0); TopBar.BackgroundTransparency = 0.15
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 15)
Instance.new("UIStroke", TopBar).Color = CrystalPurple; Instance.new("UIStroke", TopBar).Thickness = 2

local InfoLabel = Instance.new("TextLabel", TopBar)
InfoLabel.Size = UDim2.new(1, 0, 1, 0); InfoLabel.BackgroundTransparency = 1; InfoLabel.TextColor3 = CrystalPurple; InfoLabel.TextSize = 14; InfoLabel.Font = Enum.Font.GothamBold; InfoLabel.Text = "Crystal Hub | FPS -- | MS --"

local BottomBar = Instance.new("Frame", MainContainer)
BottomBar.Size = UDim2.new(1, 0, 0, 16); BottomBar.Position = UDim2.new(0, 0, 0, 40); BottomBar.BackgroundTransparency = 1

local function CreateStat(pos, size, trans, txt)
    local f = Instance.new("Frame", BottomBar)
    f.Size = size; f.Position = pos; f.BackgroundColor3 = Color3.fromRGB(0,0,0); f.BackgroundTransparency = trans
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 20)
    local t = Instance.new("TextLabel", f)
    t.Size = UDim2.new(1, 0, 1, 0); t.BackgroundTransparency = 1; t.Text = txt; t.TextColor3 = Color3.fromRGB(255,255,255); t.TextSize = 10; t.Font = Enum.Font.GothamBold
end
CreateStat(UDim2.new(0, 0, 0, 0), UDim2.new(0.49, 0, 1, 0), LeftPartTrans, "0%") -- الشمال
CreateStat(UDim2.new(0.51, 0, 0, 0), UDim2.new(0.49, 0, 1, 0), RightPartTrans, "7.4") -- اليمين

-- [[ المنيو الجانبي - الشفافية مثل الناحية الشمال ]] --
local SideMenu = Instance.new("Frame", ScreenGui)
SideMenu.Size = UDim2.new(0, 160, 0, 280); SideMenu.Position = UDim2.new(-0.7, 0, 0.35, 0)
SideMenu.BackgroundColor3 = Color3.fromRGB(0,0,0); SideMenu.BackgroundTransparency = LeftPartTrans -- مطابقة للناحية الشمال
Instance.new("UICorner", SideMenu).CornerRadius = UDim.new(0, 15)
Instance.new("UIStroke", SideMenu).Color = CrystalPurple; Instance.new("UIStroke", SideMenu).Thickness = 2

local UIList = Instance.new("UIListLayout", SideMenu)
UIList.Padding = UDim.new(0, 8); UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
Instance.new("UIPadding", SideMenu).PaddingTop = UDim.new(0, 12)

-- وظيفة الأزرار - اللون مثل الناحية اليمين
local function CreateBtn(txt, parent, size)
    local btn = Instance.new("TextButton", parent)
    btn.Size = size or UDim2.new(0, 140, 0, 40)
    btn.BackgroundColor3 = RightPartColor; btn.BackgroundTransparency = RightPartTrans -- مطابقة للناحية اليمين
    btn.Text = txt; btn.TextColor3 = Color3.fromRGB(255,255,255); btn.Font = Enum.Font.GothamBold; btn.TextSize = 10
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    local s = Instance.new("UIStroke", btn); s.Color = CrystalPurple; s.Thickness = 1.2
    local active = false
    btn.MouseButton1Click:Connect(function()
        active = not active
        btn.BackgroundColor3 = active and CrystalPurple or RightPartColor
        btn.BackgroundTransparency = active and 0 or RightPartTrans
    end)
    return btn
end

-- الأزرار بالترتيب
local EspBtn = CreateBtn("Esp Player", SideMenu)

local function Row(p)
    local f = Instance.new("Frame", p); f.Size = UDim2.new(0, 140, 0, 35); f.BackgroundTransparency = 1
    Instance.new("UIListLayout", f).FillDirection = Enum.FillDirection.Horizontal
    f.UIListLayout.Padding = UDim.new(0, 8); f.UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    return f
end

local R1 = Row(SideMenu); CreateBtn("AimBot", R1, UDim2.new(0, 66, 1, 0)); CreateBtn("Steal Nearest", R1, UDim2.new(0, 66, 1, 0))
local R2 = Row(SideMenu); CreateBtn("Auto Play", R2, UDim2.new(0, 66, 1, 0)); CreateBtn("Auto Medusa", R2, UDim2.new(0, 66, 1, 0))
local R3 = Row(SideMenu); CreateBtn("Down", R3, UDim2.new(0, 66, 1, 0)); CreateBtn("Drop", R3, UDim2.new(0, 66, 1, 0))

-- [[ زر الأيقونة ]] --
local SideButton = Instance.new("TextButton", ScreenGui)
SideButton.Size = UDim2.new(0, 60, 0, 60); SideButton.Position = UDim2.new(1, -75, 0.30, 0); SideButton.BackgroundColor3 = CrystalPurple; SideButton.Text = ""
Instance.new("UICorner", SideButton).CornerRadius = UDim.new(0, 15)
local canOpen = MakeDraggable(SideButton) 
for i=0,2 do
    local l = Instance.new("Frame", SideButton); l.Size = UDim2.new(0.5, 0, 0.08, 0); l.Position = UDim2.new(0.25, 0, 0.35 + (i*0.15), 0); l.BackgroundColor3 = Color3.fromRGB(255,255,255); Instance.new("UICorner", l).CornerRadius = UDim.new(0, 2)
end

local menuOpen = false
SideButton.MouseButton1Up:Connect(function()
    if canOpen() then 
        menuOpen = not menuOpen
        SideMenu:TweenPosition(UDim2.new(menuOpen and 0.02 or -0.7, 0, 0.35, 0), "Out", "Quart", 0.4, true)
    end
end)

-- نظام التاج والسرعة
local function Tag(p)
    p.CharacterAdded:Connect(function(char)
        local h = char:WaitForChild("Head", 10); local b = Instance.new("BillboardGui", h)
        b.Size = UDim2.new(0, 150, 0, 50); b.StudsOffset = Vector3.new(0, 4.2, 0); b.AlwaysOnTop = true
        local l = Instance.new("TextLabel", b); l.Size = UDim2.new(1, 0, 1, 0); l.BackgroundTransparency = 1; l.TextColor3 = Color3.fromRGB(255,255,255); l.TextSize = 14; l.Font = Enum.Font.GothamBold
        RunService.RenderStepped:Connect(function()
            if char:FindFirstChild("HumanoidRootPart") then
                l.Text = (p == Player) and ("Speed: " .. string.format("%.1f", char.HumanoidRootPart.Velocity.Magnitude)) or p.DisplayName
            end
        end)
    end)
end
for _, v in pairs(Players:GetPlayers()) do Tag(v) end
Players.PlayerAdded:Connect(Tag)

-- تحديث FPS & MS
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
