local GameID = game.PlaceId
-- التحقق من الماب (رقم التريد بلازا اللي بعته)
if GameID ~= 111917342868480 then return end

local TS = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local CG = game:GetService("CoreGui")
local LP = game:GetService("Players").LocalPlayer

local UI_ID = "Crystal_Elite_2026_Final"
local Existing = CG:FindFirstChild(UI_ID) or LP.PlayerGui:FindFirstChild(UI_ID)
if Existing then Existing:Destroy() end

getgenv().Config = {AutoPop = false, ConnectFour = false, Accuracy = 7}

local Screen = Instance.new("ScreenGui", CG)
Screen.Name = UI_ID
Screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- // الأيقونة (تعديل الأولوية لضمان الاستجابة)
local OpenBtn = Instance.new("TextButton", Screen)
OpenBtn.Size = UDim2.new(0, 110, 0, 35)
OpenBtn.Position = UDim2.new(0.5, -58, 0.16, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
OpenBtn.Text = "Crystal Hub"
OpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.TextSize = 12
OpenBtn.AutoButtonColor = true -- تفعيل التفاعل التلقائي لضمان اللمس
OpenBtn.ZIndex = 100
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 18)

local BtnStroke = Instance.new("UIStroke", OpenBtn)
BtnStroke.Color = Color3.fromRGB(0, 120, 255)
BtnStroke.Thickness = 1.5

-- // القائمة
local Main = Instance.new("CanvasGroup", Screen)
Main.Size = UDim2.new(0, 380, 0, 190)
Main.Position = UDim2.new(0.5, -190, 0.5, -95)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Main.Visible = false
Main.GroupTransparency = 1 
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 18)

local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = Color3.fromRGB(0, 120, 255)
MainStroke.Thickness = 1.5
MainStroke.Transparency = 1

local function ToggleUI(state)
    local info = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    if state then
        Main.Visible = true
        TS:Create(Main, info, {GroupTransparency = 0}):Play()
        TS:Create(MainStroke, info, {Transparency = 0}):Play()
        TS:Create(OpenBtn, info, {BackgroundTransparency = 1, TextTransparency = 1}):Play()
        TS:Create(BtnStroke, info, {Transparency = 1}):Play()
        task.delay(0.3, function() OpenBtn.Visible = false end)
    else
        TS:Create(MainStroke, info, {Transparency = 1}):Play()
        local hide = TS:Create(Main, info, {GroupTransparency = 1})
        hide:Play()
        OpenBtn.Visible = true
        TS:Create(OpenBtn, info, {BackgroundTransparency = 0, TextTransparency = 0}):Play()
        TS:Create(BtnStroke, info, {Transparency = 0}):Play()
        hide.Completed:Connect(function() Main.Visible = false end)
    end
end

-- // الهيدر والمحتوى
local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 38)
Header.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Header.BorderSizePixel = 0
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 18)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 38)
Title.Text = "Crystal Hub - Mini Games"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 12
Title.BackgroundTransparency = 1

local CloseBtn = Instance.new("TextButton", Main)
CloseBtn.Size = UDim2.new(0, 35, 0, 38)
CloseBtn.Position = UDim2.new(1, -38, 0, 0)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BackgroundTransparency = 1

-- // نظام الحركة (Dragging) المحسن
local dragging, dragInput, dragStart, startPos
local function update(input)
    local delta = input.Position - dragStart
    OpenBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

OpenBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = OpenBtn.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

OpenBtn.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then update(input) end
end)

-- // ربط الأزرار (فتح وإغلاق)
OpenBtn.Activated:Connect(function()
    ToggleUI(true)
end)

CloseBtn.MouseButton1Click:Connect(function()
    ToggleUI(false)
end)

-- إضافة التوجلز والسلايدر هنا (نفس الكود السابق)
local function CreateToggle(name, pos, icon, var)
    local F = Instance.new("Frame", Main)
    F.Size, F.Position, F.BackgroundColor3 = UDim2.new(0, 175, 0, 42), pos, Color3.fromRGB(35, 35, 35)
    Instance.new("UICorner", F).CornerRadius = UDim.new(0, 18)
    local B = Instance.new("TextButton", F)
    B.Size, B.Position, B.BackgroundColor3 = UDim2.new(0, 32, 0, 16), UDim2.new(1, -40, 0.5, -8), Color3.fromRGB(50, 50, 50)
    B.Text = ""
    Instance.new("UICorner", B).CornerRadius = UDim.new(1, 0)
    local Dot = Instance.new("Frame", B)
    Dot.Size, Dot.Position, Dot.BackgroundColor3 = UDim2.new(0, 12, 0, 12), UDim2.new(0, 2, 0.5, -6), Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)
    B.MouseButton1Click:Connect(function()
        getgenv().Config[var] = not getgenv().Config[var]
        TS:Create(B, TweenInfo.new(0.2), {BackgroundColor3 = getgenv().Config[var] and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(50, 50, 50)}):Play()
        TS:Create(Dot, TweenInfo.new(0.2), {Position = getgenv().Config[var] and UDim2.new(0, 18, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)}):Play()
    end)
    local L = Instance.new("TextLabel", F)
    L.Size, L.Position, L.Text = UDim2.new(0, 85, 1, 0), UDim2.new(0, 44, 0, 0), name
    L.TextColor3, L.Font, L.TextSize, L.BackgroundTransparency = Color3.fromRGB(255, 255, 255), Enum.Font.GothamBold, 11, 1
end

CreateToggle("Auto Popcorn", UDim2.new(0, 10, 0, 55), "P", "AutoPop")
CreateToggle("Connect Four", UDim2.new(0, 195, 0, 55), "C", "ConnectFour")
