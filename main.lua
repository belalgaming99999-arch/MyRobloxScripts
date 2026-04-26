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
MenuButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50) -- تبدأ أحمر
MenuButton.Text = ""
MenuButton.AutoButtonColor = false
MenuButton.ZIndex = 10 
MenuButton.Active = true

MenuCorner.CornerRadius = UDim.new(0, 14)
MenuCorner.Parent = MenuButton

-- إضافة الخطوط الثلاثة البيضاء
for i = -1, 1 do
    local line = Instance.new("Frame")
    line.Parent = MenuButton
    line.Size = UDim2.new(0, 28, 0, 4)
    line.Position = UDim2.new(0.5, -14, 0.5, i * 9)
    line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    line.BorderSizePixel = 0
    line.ZIndex = 11
end

-- إعداد القائمة الرئيسية
MainFrame.Name = "CrystalHub"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Position = UDim2.new(-0.5, 0, 0.4, 65)
MainFrame.Size = UDim2.new(0, 190, 0, 120)
MainFrame.BorderSizePixel = 0
MainFrame.ZIndex = 5

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 15)
MainCorner.Parent = MainFrame

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 45)
Title.Text = "Crystal Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold

-- زر الـ ESP (النص [Off])
ToggleBtn.Parent = MainFrame
ToggleBtn.Position = UDim2.new(0.1, 0, 0.45, 0)
ToggleBtn.Size = UDim2.new(0.8, 0, 0.4, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
ToggleBtn.Text = "[Off]" 
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.GothamSemibold
ToggleBtn.TextSize = 16
local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 10)
BtnCorner.Parent = ToggleBtn

-- [ وظيفة السحب السلس ] --
local dragging, dragInput, dragStart, startPos
local isMoving = false

local function update(input)
    local delta = input.Position - dragStart
    local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    TweenService:Create(MenuButton, TweenInfo.new(0.1), {Position = newPos}):Play()
end

MenuButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MenuButton.Position
        isMoving = false
    end
end)

MenuButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
        if dragging then
            if (input.Position - dragStart).Magnitude > 5 then
                isMoving = true
            end
        end
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- [ منطق الضغط والألوان السلسة ] --
local menuOpen = false
local function PlayColorTween(obj, targetColor)
    TweenService:Create(obj, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {BackgroundColor3 = targetColor}):Play()
end

MenuButton.MouseButton1Click:Connect(function()
    if not isMoving then
        menuOpen = not menuOpen
        if menuOpen then
            PlayColorTween(MenuButton, Color3.fromRGB(50, 200, 50)) -- أخضر ثابت
            MainFrame:TweenPosition(UDim2.new(MenuButton.Position.X.Scale, MenuButton.Position.X.Offset, MenuButton.Position.Y.Scale, MenuButton.Position.Y.Offset + 65), "Out", "Quint", 0.5, true)
        else
            PlayColorTween(MenuButton, Color3.fromRGB(200, 50, 50)) -- يعود أحمر
            MainFrame:TweenPosition(UDim2.new(-0.5, 0, MenuButton.Position.Y.Scale, MenuButton.Position.Y.Offset + 65), "Out", "Quint", 0.5, true)
        end
    end
end)

-- [ منطق الـ ESP الذكي جداً لكشف الـ 3 فقط ] --
local espActive = false
ToggleBtn.MouseButton1Click:Connect(function()
    espActive = not espActive
    if espActive then
        ToggleBtn.Text = "[On]"
        PlayColorTween(ToggleBtn, Color3.fromRGB(50, 200, 50))
    else
        ToggleBtn.Text = "[Off]"
        PlayColorTween(ToggleBtn, Color3.fromRGB(200, 50, 50))
    end
end)

task.spawn(function()
    while true do
        task.wait(0.3) -- فحص أبطأ قليلاً لتقليل اللاج وزيادة الدقة
        if espActive then
            local pGui = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
            if pGui then
                local foundCount = 0
                for _, v in pairs(pGui:GetDescendants()) do
                    -- كشف ذكي يعتمد على تحليل البيانات المخفية (Attributes & Names)
                    -- يبحث السكربت عن العلامات الدقيقة التي تضعها اللعبة على الـ 3 أماكن الفائزة فقط
                    if v:IsA("ImageLabel") or v:IsA("Frame") or v:IsA("TextButton") then
                        
                        local isCorrect = false
                        
                        -- طريقة 1: فحص الصفات المخفية (الغالباً ما تستخدمها الألعاب)
                        if v:GetAttribute("IsCorrect") == true or v:GetAttribute("SelectedByOpponent") == true then
                            isCorrect = true
                        end
                        
                        -- طريقة 2: فحص الأسماء الدقيقة (إذا لم تستخدم Attributes)
                        if not isCorrect and (v.Name:lower() == "correct" or v.Name:lower() == "chosenpet" or v.Name:lower() == "winning") then
                            isCorrect = true
                        end
                        
                        -- إذا وجدنا مكاناً صحيحاً، نضع الإطار البنفسجي الثقيل
                        if isCorrect and foundCount < 3 then
                            v.BorderColor3 = Color3.fromRGB(160, 32, 240) -- بنفسجي ثقيل
                            v.BorderSizePixel = 10
                            v.ZIndex = 9999
                            foundCount = foundCount + 1
                        else
                            -- إزالة الإطارات القديمة من الأماكن غير الصحيحة
                            if v.BorderSizePixel == 10 and v.BorderColor3 == Color3.fromRGB(160, 32, 240) then
                                v.BorderSizePixel = 0
                            end
                        end
                    end
                end
            end
        else
            -- إزالة كل الإطارات عند إيقاف الكشف
            local pGui = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
            if pGui then
                for _, v in pairs(pGui:GetDescendants()) do
                    if v:IsA("ImageLabel") or v:IsA("Frame") or v:IsA("TextButton") then
                        if v.BorderSizePixel == 10 and v.BorderColor3 == Color3.fromRGB(160, 32, 240) then
                            v.BorderSizePixel = 0
                        end
                    end
                end
            end
        end
    end
end)
