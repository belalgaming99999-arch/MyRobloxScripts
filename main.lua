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
MenuButton.Position = UDim2.new(0.05, 0, 0.4, 0)
MenuButton.BackgroundColor3 = Color3.fromRGB(45, 85, 160) -- الأزرق الهادي
MenuButton.Text = ""
MenuButton.BorderSizePixel = 0
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
MainFrame.Position = UDim2.new(-0.5, 0, 0.4, 65)
MainFrame.Size = UDim2.new(0, 220, 0, 110)
MainFrame.BorderSizePixel = 1 -- حواف نحيفة
MainFrame.BorderColor3 = Color3.fromRGB(45, 85, 160) -- حواف زرقاء مطفية
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

-- [ الاسم والخط السلس ] --
Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "CRYSTAL HUB"
Title.TextColor3 = Color3.fromRGB(45, 85, 160) -- الاسم بنفس لون الحواف
Title.BackgroundTransparency = 1
Title.TextSize = 17
Title.Font = Enum.Font.GothamBold

UnderLine.Parent = MainFrame
UnderLine.BackgroundColor3 = Color3.fromRGB(45, 85, 160)
UnderLine.BorderSizePixel = 0
UnderLine.Position = UDim2.new(0.25, 0, 0, 32)
UnderLine.Size = UDim2.new(0.5, 0, 0, 2)
Instance.new("UICorner", UnderLine).CornerRadius = UDim.new(1, 0)

-- [ الزر الكبير - أحمر مطفي ] --
BigBtn.Name = "EspMainBtn"
BigBtn.Parent = MainFrame
BigBtn.Position = UDim2.new(0.05, 0, 0.45, 0)
BigBtn.Size = UDim2.new(0.9, 0, 0.45, 0)
BigBtn.BackgroundColor3 = Color3.fromRGB(140, 50, 50) -- أحمر مطفي هادي (Muted Red)
BigBtn.Text = "Esp Disable"
BigBtn.TextColor3 = Color3.fromRGB(240, 240, 240)
BigBtn.Font = Enum.Font.GothamBold
BigBtn.TextSize = 15
BigBtn.BorderSizePixel = 0
Instance.new("UICorner", BigBtn).CornerRadius = UDim.new(0, 10)

-- [ منطق السحب ] --
local dragging, dragStart, startPos
MenuButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true dragStart = input.Position startPos = MenuButton.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MenuButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function() dragging = false end)

-- [ الفتح والغلق ] --
local menuOpen = false
MenuButton.MouseButton1Click:Connect(function()
    menuOpen = not menuOpen
    local targetPos = menuOpen and UDim2.new(MenuButton.Position.X.Scale, MenuButton.Position.X.Offset, MenuButton.Position.Y.Scale, MenuButton.Position.Y.Offset + 65) or UDim2.new(-0.5, 0, 0.4, 65)
    MainFrame:TweenPosition(targetPos, "Out", "Quint", 0.4, true)
end)

-- [ التفعيل وتغيير الألوان ] --
local espActive = false
BigBtn.MouseButton1Click:Connect(function()
    espActive = not espActive
    if espActive then
        BigBtn.Text = "Esp Active"
        TweenService:Create(BigBtn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(50, 120, 80)}):Play() -- أخضر هادي
    else
        BigBtn.Text = "Esp Disable"
        TweenService:Create(BigBtn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(140, 50, 50)}):Play() -- أحمر مطفي
        -- إيقاف الكشف
        local pGui = LocalPlayer:FindFirstChild("PlayerGui")
        if pGui then
            for _, v in pairs(pGui:GetDescendants()) do
                if v:IsA("GuiObject") and v.BorderSizePixel == 10 then v.BorderSizePixel = 0 end
            end
        end
    end
end)

-- [ حلقة الكشف ] --
task.spawn(function()
    while true do
        task.wait(0.3)
        if espActive then
            local pGui = LocalPlayer:FindFirstChild("PlayerGui")
            if pGui then
                for _, v in pairs(pGui:GetDescendants()) do
                    if v.Name:lower():match("blue") or v.Name:lower():match("opponent") then
                        if v:GetAttribute("IsBomb") or v:GetAttribute("HasBomb") or v.Name:lower():match("bomb") then
                            v.BorderColor3 = Color3.fromRGB(255, 50, 50)
                            v.BorderSizePixel = 10
                        end
                    end
                end
            end
        end
    end
end)
