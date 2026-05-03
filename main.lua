local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Root = (gethui and gethui()) or CoreGui
if Root:FindFirstChild("CrystalProject") then Root.CrystalProject:Destroy() end

local CrystalGui = Instance.new("ScreenGui", Root)
CrystalGui.Name = "CrystalProject"
CrystalGui.IgnoreGuiInset = true
CrystalGui.DisplayOrder = 1e6

local Theme = {
    Bg = Color3.fromRGB(25, 35, 55),
    MainBlue = Color3.fromRGB(45, 85, 160),
    White = Color3.new(1, 1, 1),
    OffRed = Color3.fromRGB(135, 55, 55), 
    OnGreen = Color3.fromRGB(55, 120, 85),
    SliderBg = Color3.fromRGB(40, 50, 75)
}

local Toggles = {AutoPop = false, State2 = false, State3 = false}
local Accuracy = 7
local TargetPos = UDim2.new(0.05, 0, 0.25, 0)
local UI_Open, Dragging = false, false

-- [[ الأيقونة العائمة ]] --
local MenuBtn = Instance.new("TextButton", CrystalGui)
MenuBtn.Size = UDim2.new(0, 52, 0, 52)
MenuBtn.Position = TargetPos
MenuBtn.BackgroundColor3 = Theme.MainBlue
MenuBtn.Text = ""
MenuBtn.AutoButtonColor = false
Instance.new("UICorner", MenuBtn).CornerRadius = UDim.new(0, 10)

for i = -1, 1 do
    local L = Instance.new("Frame", MenuBtn)
    L.Size = UDim2.new(0, 26, 0, 4)
    L.Position = UDim2.new(0.5, -13, 0.5, (i * 10) - 2)
    L.BackgroundColor3 = Theme.White
    Instance.new("UICorner", L).CornerRadius = UDim.new(1, 0)
end

-- [[ القائمة الرئيسية ]] --
local Border = Instance.new("Frame", CrystalGui)
Border.Size = UDim2.new(0, 0, 0, 0)
Border.BackgroundColor3 = Theme.White
Border.ClipsDescendants = true
Border.Visible = false
Instance.new("UICorner", Border).CornerRadius = UDim.new(0, 12)

local Main = Instance.new("Frame", Border)
Main.Size = UDim2.new(1, -4, 1, -4)
Main.Position = UDim2.new(0, 2, 0, 2)
Main.BackgroundColor3 = Theme.Bg
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

local GlobalGrad = Instance.new("UIGradient", Border)
GlobalGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Theme.MainBlue),
    ColorSequenceKeypoint.new(0.5, Theme.White),
    ColorSequenceKeypoint.new(1, Theme.MainBlue)
})

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 45)
Title.Text = "Crystal Hub"
Title.TextColor3 = Theme.White
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.BackgroundTransparency = 1

local TitleGrad = Instance.new("UIGradient", Title)
TitleGrad.Color = GlobalGrad.Color

local UnderLine = Instance.new("Frame", Main)
UnderLine.Size = UDim2.new(0, 120, 0, 4)
UnderLine.Position = UDim2.new(0.5, -60, 0, 40)
UnderLine.BackgroundColor3 = Theme.White
Instance.new("UICorner", UnderLine).CornerRadius = UDim.new(1, 0)
local LineGrad = Instance.new("UIGradient", UnderLine)
LineGrad.Color = GlobalGrad.Color

-- [[ الأزرار ]] --
local function AddBtn(txt, key, y)
    local B = Instance.new("TextButton", Main)
    B.Size = UDim2.new(0, 180, 0, 36)
    B.Position = UDim2.new(0.5, -90, 0, y)
    B.BackgroundColor3 = Theme.OffRed
    B.Text = txt .. " [Disable]"
    B.TextColor3 = Theme.White
    B.Font = Enum.Font.GothamBold
    B.TextSize = 13
    B.AutoButtonColor = false
    Instance.new("UICorner", B).CornerRadius = UDim.new(0, 8)

    B.MouseButton1Click:Connect(function()
        Toggles[key] = not Toggles[key]
        B.Text = txt .. (Toggles[key] and " [Active]" or " [Disable]")
        TweenService:Create(B, TweenInfo.new(0.3), {BackgroundColor3 = Toggles[key] and Theme.OnGreen or Theme.OffRed}):Play()
    end)
end

AddBtn("Auto Pop", "AutoPop", 55)
AddBtn("Feature 2", "State2", 97)
AddBtn("Feature 3", "State3", 139)

-- [[ السلايدر المطور مع تأثير الموجات ]] --
local SliderLabel = Instance.new("TextLabel", Main)
SliderLabel.Size = UDim2.new(1, 0, 0, 20)
SliderLabel.Position = UDim2.new(0, 0, 0, 180)
SliderLabel.Text = "Accuracy: 7"
SliderLabel.TextColor3 = Theme.White
SliderLabel.Font = Enum.Font.GothamBold
SliderLabel.TextSize = 12
SliderLabel.BackgroundTransparency = 1

local SliderBg = Instance.new("Frame", Main)
SliderBg.Size = UDim2.new(0, 160, 0, 6)
SliderBg.Position = UDim2.new(0.5, -80, 0, 205)
SliderBg.BackgroundColor3 = Theme.SliderBg
Instance.new("UICorner", SliderBg).CornerRadius = UDim.new(1, 0)

local SliderFill = Instance.new("Frame", SliderBg)
SliderFill.Size = UDim2.new(0.7, 0, 1, 0)
SliderFill.BackgroundColor3 = Theme.MainBlue
Instance.new("UICorner", SliderFill).CornerRadius = UDim.new(1, 0)
local FillGrad = Instance.new("UIGradient", SliderFill)
FillGrad.Color = GlobalGrad.Color

-- الدائرة البيضاء (Knob)
local SliderKnob = Instance.new("Frame", SliderFill)
SliderKnob.Size = UDim2.new(0, 12, 0, 12)
SliderKnob.Position = UDim2.new(1, -6, 0.5, -6)
SliderKnob.BackgroundColor3 = Theme.White
SliderKnob.ZIndex = 5
Instance.new("UICorner", SliderKnob).CornerRadius = UDim.new(1, 0)

-- تأثير الموجات/الحواف المنطلقة (Ripple/Wave Effect)
local function CreateWave()
    local Wave = Instance.new("Frame", SliderKnob)
    Wave.Name = "Wave"
    Wave.AnchorPoint = Vector2.new(0.5, 0.5)
    Wave.Size = UDim2.new(1, 0, 1, 0) -- تبدأ بنفس حجم الدائرة
    Wave.Position = UDim2.new(0.5, 0, 0.5, 0)
    Wave.BackgroundColor3 = Theme.White
    Wave.BackgroundTransparency = 0.4 -- تبدأ شبه شفافة
    Wave.ZIndex = 4 -- تحت الدائرة الأساسية
    Instance.new("UICorner", Wave).CornerRadius = UDim.new(1, 0)
    
    local WaveStroke = Instance.new("UIStroke", Wave)
    WaveStroke.Color = Theme.White
    WaveStroke.Thickness = 1
    WaveStroke.Transparency = 0.4

    -- أنميشن الانطلاق والاختفاء
    local info = TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(Wave, info, {
        Size = UDim2.new(4, 0, 4, 0), -- تكبر 4 أضعاف
        BackgroundTransparency = 1 -- وتختفي تماماً
    })
    local strokeTween = TweenService:Create(WaveStroke, info, {
        Thickness = 0, -- الإطار يختفي أيضاً
        Transparency = 1
    })
    
    tween:Play()
    strokeTween:Play()
    
    -- حذف العنصر بعد انتهاء الأنميشن
    tween.Completed:Connect(function()
        Wave:Destroy()
    end)
end

-- إطلاق موجة جديدة كل فترة
task.spawn(function()
    while task.wait(0.8) do -- كل 0.8 ثانية تطلع موجة
        if Border.Visible then -- فقط إذا كانت القائمة مفتوحة
            CreateWave()
        end
    end
end)

local function UpdateSlider(input)
    local pos = math.clamp((input.Position.X - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X, 0, 1)
    Accuracy = math.floor(pos * 10)
    SliderLabel.Text = "Accuracy: " .. Accuracy
    TweenService:Create(SliderFill, TweenInfo.new(0.1, Enum.EasingStyle.Linear), {Size = UDim2.new(pos, 0, 1, 0)}):Play()
end

local Sliding = false
SliderBg.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        Sliding = true
        UpdateSlider(input)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if Sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        UpdateSlider(input)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        Sliding = false
    end
end)

-- [[ الأنميشن والحركة العامة ]] --
RunService.RenderStepped:Connect(function(dt)
    if not Dragging then MenuBtn.Position = MenuBtn.Position:Lerp(TargetPos, 0.25) end
    Border.Position = UDim2.new(MenuBtn.Position.X.Scale, MenuBtn.Position.X.Offset, MenuBtn.Position.Y.Scale, MenuBtn.Position.Y.Offset + 62)
    local rot = (GlobalGrad.Rotation + 150 * dt) % 360
    GlobalGrad.Rotation = rot
    TitleGrad.Rotation = rot
    LineGrad.Rotation = rot
    FillGrad.Rotation = rot
end)

-- نظام السحب والفتح
local dStart, sPos, isDragged
MenuBtn.InputBegan:Connect(function(i)
    if (i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch) then
        Dragging = true; isDragged = false; dStart = i.Position; sPos = MenuBtn.Position
    end
end)
UserInputService.InputChanged:Connect(function(i)
    if Dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        local delta = i.Position - dStart
        if delta.Magnitude > 3 then isDragged = true end
        TargetPos = UDim2.new(sPos.X.Scale, sPos.X.Offset + delta.X, sPos.Y.Scale, sPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(i)
    if (i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch) then
        Dragging = false
    end
end)

MenuBtn.MouseButton1Click:Connect(function()
    if not isDragged then
        UI_Open = not UI_Open
        if UI_Open then
            Border.Visible = true
            Border:TweenSize(UDim2.new(0, 204, 0, 235), "Out", "Quint", 0.4, true)
        else
            Border:TweenSize(UDim2.new(0, 0, 0, 0), "In", "Quint", 0.3, true, function() Border.Visible = false end)
        end
    end
end)

-- [[ أتمتة العمليات ]] --
task.spawn(function()
    local Path = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Remotes"):WaitForChild("Networking"):WaitForChild("RE/Minigame/MinigameGameAction")
    while task.wait() do
        if Toggles.AutoPop then
            for i = 1, Accuracy do
                task.spawn(function() Path:FireServer("AttemptPop", tick() + math.random()) end)
            end
            task.wait(math.clamp(0.14 - (Accuracy * 0.01), 0.06, 0.14))
        end
    end
end)
