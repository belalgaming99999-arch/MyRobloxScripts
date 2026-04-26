local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ToggleBtn = Instance.new("TextButton")
local MenuButton = Instance.new("TextButton")
local MenuCorner = Instance.new("UICorner")

-- إعدادات الواجهة
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

-- إعداد الزر العائم (الأيقونة)
MenuButton.Name = "CrystalMenuBtn"
MenuButton.Parent = ScreenGui
MenuButton.Size = UDim2.new(0, 55, 0, 55)
MenuButton.Position = UDim2.new(0.05, 0, 0.4, 0)
MenuButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50) -- يبدأ أحمر
MenuButton.Text = ""
MenuButton.AutoButtonColor = false
MenuButton.ZIndex = 10 
Instance.new("UICorner", MenuButton).CornerRadius = UDim.new(0, 14)

-- الخطوط الثلاثة البيضاء
for i = -1, 1 do
    local line = Instance.new("Frame")
    line.Parent = MenuButton
    line.Size = UDim2.new(0, 28, 0, 4)
    line.Position = UDim2.new(0.5, -14, 0.5, i * 9)
    line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    line.BorderSizePixel = 0
    line.ZIndex = 11
end

-- القائمة الرئيسية
MainFrame.Name = "CrystalHub"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Position = UDim2.new(-0.5, 0, 0.4, 65)
MainFrame.Size = UDim2.new(0, 190, 0, 120)
MainFrame.BorderSizePixel = 0
MainFrame.ZIndex = 5
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 15)

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 45)
Title.Text = "Crystal Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold

ToggleBtn.Parent = MainFrame
ToggleBtn.Position = UDim2.new(0.1, 0, 0.45, 0)
ToggleBtn.Size = UDim2.new(0.8, 0, 0.4, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
ToggleBtn.Text = "[Off]" 
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.GothamSemibold
ToggleBtn.TextSize = 16
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 10)

-- [ وظيفة السحب السلس ] --
local dragging, dragStart, startPos
MenuButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MenuButton.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MenuButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- [ منطق الضغط ] --
local menuOpen = false
MenuButton.MouseButton1Click:Connect(function()
    menuOpen = not menuOpen
    if menuOpen then
        TweenService:Create(MenuButton, TweenInfo.new(0.4), {BackgroundColor3 = Color3.fromRGB(50, 200, 50)}):Play()
        MainFrame:TweenPosition(UDim2.new(MenuButton.Position.X.Scale, MenuButton.Position.X.Offset, MenuButton.Position.Y.Scale, MenuButton.Position.Y.Offset + 65), "Out", "Quint", 0.5, true)
    else
        TweenService:Create(MenuButton, TweenInfo.new(0.4), {BackgroundColor3 = Color3.fromRGB(200, 50, 50)}):Play()
        MainFrame:TweenPosition(UDim2.new(-0.5, 0, MenuButton.Position.Y.Scale, MenuButton.Position.Y.Offset + 65), "Out", "Quint", 0.5, true)
    end
end)

-- [ منطق الكشف - كشف القنابل باللون الأحمر الكثيف ] --
local espActive = false
ToggleBtn.MouseButton1Click:Connect(function()
    espActive = not espActive
    ToggleBtn.Text = espActive and "[On]" or "[Off]"
    TweenService:Create(ToggleBtn, TweenInfo.new(0.3), {BackgroundColor3 = espActive and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)}):Play()
end)

task.spawn(function()
    while true do
        task.wait(0.3)
        local pGui = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
        if espActive and pGui then
            local bombCount = 0
            for _, v in pairs(pGui:GetDescendants()) do
                -- البحث عن العناصر التي تحتوي على "قنبلة" برمجياً
                if (v:IsA("Frame") or v:IsA("ImageLabel") or v:IsA("TextButton")) then
                    local isBomb = false
                    
                    -- فحص الأسماء أو الصفات التي تدل على القنبلة (Bomb/Explosive/Lose)
                    if v.Name:lower():match("bomb") or v.Name:lower():match("lose") or v:GetAttribute("IsBomb") == true then
                        isBomb = true
                    end
                    
                    if isBomb and bombCount < 3 then
                        -- وضع إطار أحمر كثيف جداً (علامة خطر)
                        v.BorderColor3 = Color3.fromRGB(255, 0, 0) -- أحمر ناصع
                        v.BorderSizePixel = 12 -- سمك كبير جداً
                        v.ZIndex = 10000
                        bombCount = bombCount + 1
                    else
                        -- تنظيف أي إطارات قديمة إذا لم تعد قنبلة
                        if v.BorderSizePixel == 12 and v.BorderColor3 == Color3.fromRGB(255, 0, 0) and not isBomb then
                            v.BorderSizePixel = 0
                        end
                    end
                end
            end
        else
            -- إزالة كل الألوان الحمراء عند إيقاف الكشف
            if pGui then
                for _, v in pairs(pGui:GetDescendants()) do
                    if v.BorderSizePixel == 12 and v.BorderColor3 == Color3.fromRGB(255, 0, 0) then
                        v.BorderSizePixel = 0
                    end
                end
            end
        end
    end
end)
