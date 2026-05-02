local TS = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local LP = game:GetService("Players").LocalPlayer

local ScreenName = "CrystalHubSmoothV7"
local ExistingUI = game:GetService("CoreGui"):FindFirstChild(ScreenName) or LP.PlayerGui:FindFirstChild(ScreenName)
if ExistingUI then ExistingUI:Destroy() end

getgenv().Config = {AutoPop = false, ConnectFour = false, Accuracy = 7}

local Screen = Instance.new("ScreenGui", game:GetService("CoreGui"))
Screen.Name = ScreenName
Screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- // زر الفتح (الأيقونة)
local OpenBtn = Instance.new("TextButton", Screen)
OpenBtn.Name = "OpenBtn"
OpenBtn.Size = UDim2.new(0, 110, 0, 35)
-- البداية في منتصف الشاشة بالظبط
OpenBtn.Position = UDim2.new(0.5, -55, 0.5, -17)
OpenBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
OpenBtn.Text, OpenBtn.TextColor3 = "Crystal Hub", Color3.fromRGB(255, 255, 255)
OpenBtn.Font, OpenBtn.TextSize = Enum.Font.GothamBold, 13
OpenBtn.TextStrokeTransparency = 1 
OpenBtn.AutoButtonColor = false
OpenBtn.ZIndex = 10 -- لضمان ظهورها فوق كل شيء
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 18)

local BtnStroke = Instance.new("UIStroke", OpenBtn)
BtnStroke.Color, BtnStroke.Thickness = Color3.fromRGB(0, 120, 255), 1.5
BtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- // الإطار الرئيسي
local Main = Instance.new("Frame", Screen)
Main.Name = "Main"
Main.Size = UDim2.new(0, 380, 0, 190)
Main.Position = UDim2.new(0.5, -190, 0.5, -95)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Main.Visible = false
Main.Active = true
Main.ClipsDescendants = true 
Main.BackgroundTransparency = 1 -- للبدء بتأثير الظهور
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 18)

local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color, MainStroke.Thickness = Color3.fromRGB(0, 120, 255), 1.5
MainStroke.Transparency = 1

-- // وظيفة الفتح والإغلاق بسلاسة
local function ToggleUI(state)
    if state then
        Main.Visible = true
        Main.Size = UDim2.new(0, 360, 0, 170) -- تبدأ أصغر شوية
        TS:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Size = UDim2.new(0, 380, 0, 190), BackgroundTransparency = 0}):Play()
        TS:Create(MainStroke, TweenInfo.new(0.3), {Transparency = 0}):Play()
        TS:Create(OpenBtn, TweenInfo.new(0.2), {BackgroundTransparency = 1, TextTransparency = 1}):Play()
        TS:Create(BtnStroke, TweenInfo.new(0.2), {Transparency = 1}):Play()
        task.wait(0.2)
        OpenBtn.Visible = false
    else
        TS:Create(Main, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {Size = UDim2.new(0, 360, 0, 170), BackgroundTransparency = 1}):Play()
        TS:Create(MainStroke, TweenInfo.new(0.2), {Transparency = 1}):Play()
        task.wait(0.2)
        Main.Visible = false
        OpenBtn.Visible = true
        TS:Create(OpenBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0, TextTransparency = 0}):Play()
        TS:Create(BtnStroke, TweenInfo.new(0.2), {Transparency = 0}):Play()
    end
end

-- // الهيدر
local Header = Instance.new("Frame", Main)
Header.Size, Header.BackgroundColor3 = UDim2.new(1, 0, 0, 38), Color3.fromRGB(35, 35, 35)
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 18)
local HeaderFix = Instance.new("Frame", Header)
HeaderFix.Size, HeaderFix.Position, HeaderFix.BackgroundColor3, HeaderFix.BorderSizePixel = UDim2.new(1, 0, 0, 10), UDim2.new(0, 0, 1, -10), Color3.fromRGB(35, 35, 35), 0

local Title = Instance.new("TextLabel", Main)
Title.Size, Title.Text = UDim2.new(1, 0, 0, 38), "Crystal Hub - Mini Games"
Title.TextColor3, Title.Font, Title.TextSize = Color3.fromRGB(255, 255, 255), Enum.Font.GothamBold, 13
Title.TextStrokeTransparency, Title.BackgroundTransparency = 1, 1

local CloseBtn = Instance.new("TextButton", Main)
CloseBtn.Size, CloseBtn.Position = UDim2.new(0, 35, 0, 38), UDim2.new(1, -38, 0, 0)
CloseBtn.Text, CloseBtn.TextColor3 = "X", Color3.fromRGB(255, 255, 255)
CloseBtn.Font, CloseBtn.TextSize = Enum.Font.GothamBold, 13
CloseBtn.TextStrokeTransparency, CloseBtn.BackgroundTransparency = 1, 1

-- // أزرار التفعيل
local function CreateToggle(name, pos, icon, var)
    local F = Instance.new("Frame", Main)
    F.Size, F.Position, F.BackgroundColor3 = UDim2.new(0, 175, 0, 42), pos, Color3.fromRGB(35, 35, 35)
    Instance.new("UICorner", F).CornerRadius = UDim.new(0, 18)
    
    local I = Instance.new("TextLabel", F)
    I.Size, I.Position, I.BackgroundColor3 = UDim2.new(0, 28, 0, 28), UDim2.new(0, 8, 0.5, -14), Color3.fromRGB(0, 120, 255)
    I.Text, I.TextColor3, I.Font, I.TextSize = icon, Color3.fromRGB(255, 255, 255), Enum.Font.GothamBold, 12
    I.TextStrokeTransparency = 1
    Instance.new("UICorner", I).CornerRadius = UDim.new(1, 0)
    
    local L = Instance.new("TextLabel", F)
    L.Size, L.Position, L.Text = UDim2.new(0, 85, 1, 0), UDim2.new(0, 44, 0, 0), name
    L.TextColor3, L.Font, L.TextSize, L.TextStrokeTransparency, L.BackgroundTransparency = Color3.fromRGB(255, 255, 255), Enum.Font.GothamBold, 11, 1, 1
    L.TextXAlignment = Enum.TextXAlignment.Left
    
    local B = Instance.new("TextButton", F)
    B.Size, B.Position, B.BackgroundColor3 = UDim2.new(0, 32, 0, 16), UDim2.new(1, -40, 0.5, -8), Color3.fromRGB(50, 50, 50)
    B.Text, B.AutoButtonColor = "", false
    Instance.new("UICorner", B).CornerRadius = UDim.new(1, 0)
    
    local Dot = Instance.new("Frame", B)
    Dot.Size, Dot.Position, Dot.BackgroundColor3 = UDim2.new(0, 12, 0, 12), UDim2.new(0, 2, 0.5, -6), Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)
    
    B.MouseButton1Click:Connect(function()
        getgenv().Config[var] = not getgenv().Config[var]
        local onP = UDim2.new(0, 18, 0.5, -6) 
        local offP = UDim2.new(0, 2, 0.5, -6)
        TS:Create(B, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {BackgroundColor3 = getgenv().Config[var] and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(50, 50, 50)}):Play()
        TS:Create(Dot, TweenInfo.new(0.25, Enum.EasingStyle.Back), {Position = getgenv().Config[var] and onP or offP}):Play()
    end)
end

CreateToggle("Auto Popcorn", UDim2.new(0, 10, 0, 55), "P", "AutoPop")
CreateToggle("Connect Four", UDim2.new(0, 195, 0, 55), "C", "ConnectFour")

-- // المنطقة الرمادية السفلية
local SF = Instance.new("Frame", Main)
SF.Name = "SliderFrame"
SF.Size = UDim2.new(1, 0, 0, 75)
SF.Position = UDim2.new(0, 0, 1, -75)
SF.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
SF.BorderSizePixel = 0
Instance.new("UICorner", SF).CornerRadius = UDim.new(0, 18)

local SFFix = Instance.new("Frame", SF)
SFFix.Size = UDim2.new(1, 0, 0, 20)
SFFix.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
SFFix.BorderSizePixel = 0
SFFix.ZIndex = 1

local CombinedLabel = Instance.new("TextLabel", SF)
CombinedLabel.Text = "Accuracy - " .. tostring(getgenv().Config.Accuracy)
CombinedLabel.Size = UDim2.new(1, 0, 0, 20)
CombinedLabel.Position = UDim2.new(0, 0, 0, 12)
CombinedLabel.TextColor3, CombinedLabel.Font, CombinedLabel.TextSize = Color3.fromRGB(255, 255, 255), Enum.Font.GothamBold, 13
CombinedLabel.TextStrokeTransparency, CombinedLabel.BackgroundTransparency = 1, 1
CombinedLabel.ZIndex = 2

local function CreateArr(t, p, step)
    local b = Instance.new("TextButton", SF)
    b.Size, b.Position, b.BackgroundColor3, b.Text = UDim2.new(0, 28, 0, 28), p, Color3.fromRGB(0, 120, 255), t
    b.TextColor3, b.Font, b.TextSize, b.AutoButtonColor = Color3.fromRGB(255, 255, 255), Enum.Font.GothamBold, 14, false
    b.TextStrokeTransparency, b.ZIndex = 1, 3
    Instance.new("UICorner", b).CornerRadius = UDim.new(1, 0)
    b.MouseButton1Click:Connect(function()
        getgenv().Config.Accuracy = math.clamp(getgenv().Config.Accuracy + step, 0, 10)
        CombinedLabel.Text = "Accuracy - " .. tostring(getgenv().Config.Accuracy)
        TS:Create(Main:FindFirstChild("Fill", true), TweenInfo.new(0.3, Enum.EasingStyle.Sine), {Size = UDim2.new(getgenv().Config.Accuracy/10, 0, 1, 0)}):Play()
    end)
end

local SBtn = Instance.new("Frame", SF)
SBtn.Size, SBtn.Position, SBtn.BackgroundColor3, SBtn.ZIndex = UDim2.new(0, 240, 0, 6), UDim2.new(0.5, -120, 0, 48), Color3.fromRGB(60, 60, 60), 3
Instance.new("UICorner", SBtn).CornerRadius = UDim.new(1, 0)
local SFill = Instance.new("Frame", SBtn)
SFill.Name, SFill.Size, SFill.BackgroundColor3, SFill.ZIndex = "Fill", UDim2.new(getgenv().Config.Accuracy/10, 0, 1, 0), Color3.fromRGB(0, 120, 255), 4
Instance.new("UICorner", SFill).CornerRadius = UDim.new(1, 0)

CreateArr("<", UDim2.new(0, 33, 0, 37), -1)
CreateArr(">", UDim2.new(1, -61, 0, 37), 1)

-- // سحب الأيقونة بسلاسة (Smooth Dragging)
local dragToggle, dragStart, startPos
OpenBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragToggle = true
        dragStart = input.Position
        startPos = OpenBtn.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragToggle and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        local targetPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        -- استخدام Tween للتحريك السلس أثناء السحب
        TS:Create(OpenBtn, TweenInfo.new(0.1, Enum.EasingStyle.Linear), {Position = targetPos}):Play()
    end
end)

OpenBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragToggle = false
    end
end)

-- // تشغيل الأزرار
OpenBtn.MouseButton1Click:Connect(function() ToggleUI(true) end)
CloseBtn.MouseButton1Click:Connect(function() ToggleUI(false) end)
