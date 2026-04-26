local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local UnderLine = Instance.new("Frame")
local BigBtn = Instance.new("TextButton")
local MenuButton = Instance.new("TextButton")

-- [ إعدادات الشاشة ] --
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

-- [ الأيقونة العائمة ] --
MenuButton.Name = "CrystalMenuBtn"
MenuButton.Parent = ScreenGui
MenuButton.Size = UDim2.new(0, 55, 0, 55)
MenuButton.Position = UDim2.new(0.05, 0, 0.15, 0)
MenuButton.BackgroundColor3 = Color3.fromRGB(45, 85, 160)
MenuButton.Text = ""
MenuButton.BorderSizePixel = 0
MenuButton.AutoButtonColor = false -- إلغاء اللون الرمادي عند الضغط
Instance.new("UICorner", MenuButton).CornerRadius = UDim.new(0, 14)

for i = -1, 1 do
    local line = Instance.new("Frame")
    line.Parent = MenuButton
    line.Size = UDim2.new(0, 28, 0, 4)
    line.Position = UDim2.new(0.5, -14, 0.5, i * 9)
    line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    line.BorderSizePixel = 0
end

-- [ القائمة الرئيسية ] --
MainFrame.Name = "CrystalHub"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 30, 45)
MainFrame.Position = UDim2.new(-0.5, 0, 0.15, 65)
MainFrame.Size = UDim2.new(0, 190, 0, 130)
MainFrame.BorderSizePixel = 0
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Color3.fromRGB(45, 85, 160)
MainStroke.Thickness = 1.5

-- [ الاسم والخط ] --
Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "CRYSTAL HUB"
Title.TextColor3 = Color3.fromRGB(45, 85, 160)
Title.BackgroundTransparency = 1
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold

UnderLine.Parent = MainFrame
UnderLine.BackgroundColor3 = Color3.fromRGB(45, 85, 160)
UnderLine.BorderSizePixel = 0
UnderLine.Position = UDim2.new(0.15, 0, 0, 35)
UnderLine.Size = UDim2.new(0.7, 0, 0, 2)
Instance.new("UICorner", UnderLine).CornerRadius = UDim.new(1, 0)

-- [ الزر الكبير - تفعيل سلس بدون ألوان إضافية ] --
BigBtn.Name = "EspMainBtn"
BigBtn.Parent = MainFrame
BigBtn.Position = UDim2.new(0.1, 0, 0.38, 5)
BigBtn.Size = UDim2.new(0.8, 0, 0, 60)
BigBtn.BackgroundColor3 = Color3.fromRGB(140, 50, 50) -- الأحمر المطفي الهادئ
BigBtn.Text = "Esp Disable"
BigBtn.TextColor3 = Color3.fromRGB(240, 240, 240)
BigBtn.Font = Enum.Font.GothamBold
BigBtn.TextSize = 18
BigBtn.BorderSizePixel = 0
BigBtn.AutoButtonColor = false -- أهم تعديل: يمنع ظهور اللون الأبيض/الرمادي عند اللمس
Instance.new("UICorner", BigBtn).CornerRadius = UDim.new(0, 10)

-- [ منطق السحب الذكي ] --
local dragging, dragStart, startPos
local dragDistance = 0

MenuButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MenuButton.Position
        dragDistance = 0
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        dragDistance = delta.Magnitude
        MenuButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local menuOpen = false
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
        if dragDistance < 5 then
            menuOpen = not menuOpen
            local targetPos = menuOpen and UDim2.new(MenuButton.Position.X.Scale, MenuButton.Position.X.Offset, MenuButton.Position.Y.Scale, MenuButton.Position.Y.Offset + 65) or UDim2.new(-0.8, 0, MenuButton.Position.Y.Scale, MenuButton.Position.Y.Offset)
            MainFrame:TweenPosition(targetPos, "Out", "Quint", 0.4, true)
        end
    end
end)

-- [ منطق التفعيل السلس ] --
local espActive = false
BigBtn.MouseButton1Click:Connect(function()
    espActive = not espActive
    if espActive then
        BigBtn.Text = "Esp Active"
        -- تحول سلس للأخضر الهادئ
        TweenService:Create(BigBtn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(50, 120, 80)}):Play()
    else
        BigBtn.Text = "Esp Disable"
        -- عودة سلسة للأحمر المطفي الهادئ
        TweenService:Create(BigBtn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(140, 50, 50)}):Play()
    end
end)

