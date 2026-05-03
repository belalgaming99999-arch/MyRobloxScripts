local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")

local Root = (gethui and gethui()) or (get_hidden_gui and get_hidden_gui()) or CoreGui
if Root:FindFirstChild("CrystalProject") then
    Root:FindFirstChild("CrystalProject"):Destroy()
end

local CrystalGui = Instance.new("ScreenGui", Root)
CrystalGui.Name = "CrystalProject"
CrystalGui.IgnoreGuiInset = true
CrystalGui.DisplayOrder = 9e9
CrystalGui.ResetOnSpawn = false

local Theme = {
    Bg = Color3.fromRGB(25, 35, 55),
    Main = Color3.fromRGB(45, 85, 160), -- لون كريستال
    White = Color3.new(1, 1, 1),
    Off = Color3.fromRGB(135, 55, 55), 
    On = Color3.fromRGB(55, 120, 85),
    Slider = Color3.fromRGB(40, 50, 75)
}

local Toggles = {AutoPop = false, AutoFour = false}
local Accuracy = 10 -- ضبطناه على 10 لضمان الفوز
local UI_Open, Dragging = false, false

-- // إنشاء واجهة المستخدم (UI) بنفس تصميمك الأنيق
local MenuBtn = Instance.new("TextButton", CrystalGui)
MenuBtn.Size, MenuBtn.Position, MenuBtn.BackgroundColor3 = UDim2.new(0, 52, 0, 52), UDim2.new(0.05, 0, 0.25, 0), Theme.Main
MenuBtn.Text, MenuBtn.AutoButtonColor = "", false
Instance.new("UICorner", MenuBtn).CornerRadius = UDim.new(0, 10)

for i = -1, 1 do
    local L = Instance.new("Frame", MenuBtn)
    L.Size, L.Position = UDim2.new(0, 26, 0, 4), UDim2.new(0.5, -13, 0.5, (i * 10) - 2)
    L.BackgroundColor3 = Theme.White
    Instance.new("UICorner", L).CornerRadius = UDim.new(1, 0)
end

local Border = Instance.new("Frame", CrystalGui)
Border.Size, Border.Visible, Border.BackgroundColor3 = UDim2.new(0, 0, 0, 0), false, Theme.White
Border.ClipsDescendants = true
Instance.new("UICorner", Border).CornerRadius = UDim.new(0, 12)

local Main = Instance.new("Frame", Border)
Main.Size, Main.Position, Main.BackgroundColor3 = UDim2.new(1, -4, 1, -4), UDim2.new(0, 2, 0, 2), Theme.Bg
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

local GlobalGrad = Instance.new("UIGradient", Border)
GlobalGrad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Theme.Main), ColorSequenceKeypoint.new(0.5, Theme.White), ColorSequenceKeypoint.new(1, Theme.Main)})

local Title = Instance.new("TextLabel", Main)
Title.Size, Title.Text, Title.TextColor3 = UDim2.new(1, 0, 0, 45), "Crystal Hub v2", Theme.White
Title.Font, Title.TextSize, Title.BackgroundTransparency = Enum.Font.GothamBold, 16, 1
local TitleGrad = GlobalGrad:Clone(); TitleGrad.Parent = Title

-- // وظيفة إنشاء الأزرار
local function CreateBtn(txt, key, y)
    local B = Instance.new("TextButton", Main)
    B.Size, B.Position, B.BackgroundColor3 = UDim2.new(0, 180, 0, 36), UDim2.new(0.5, -90, 0, y), Theme.Off
    B.Text, B.TextColor3, B.Font, B.TextSize = txt.." [OFF]", Theme.White, Enum.Font.GothamBold, 13
    B.AutoButtonColor = false
    Instance.new("UICorner", B).CornerRadius = UDim.new(0, 8)

    B.MouseButton1Click:Connect(function()
        Toggles[key] = not Toggles[key]
        B.Text = txt .. (Toggles[key] and " [ON]" or " [OFF]")
        TweenService:Create(B, TweenInfo.new(0.3), {BackgroundColor3 = Toggles[key] and Theme.On or Theme.Off}):Play()
    end)
end

CreateBtn("Auto Popcorn", "AutoPop", 55)
CreateBtn("Auto Connect4", "AutoFour", 97)

-- // سلايدر الـ Accuracy لضبط قوة السكربت
local SliderLabel = Instance.new("TextLabel", Main)
SliderLabel.Size, SliderLabel.Position, SliderLabel.BackgroundTransparency = UDim2.new(1, 0, 0, 20), UDim2.new(0, 0, 0, 150), 1
SliderLabel.Text, SliderLabel.TextColor3, SliderLabel.Font, SliderLabel.TextSize = "Accuracy: 10", Theme.White, Enum.Font.GothamBold, 16

local SliderBg = Instance.new("Frame", Main)
SliderBg.Size, SliderBg.Position, SliderBg.BackgroundColor3 = UDim2.new(0, 120, 0, 6), UDim2.new(0.5, -60, 0, 178), Theme.Slider
Instance.new("UICorner", SliderBg).CornerRadius = UDim.new(1, 0)

local SliderFill = Instance.new("Frame", SliderBg)
SliderFill.Size, SliderFill.BackgroundColor3 = UDim2.new(1, 0, 1, 0), Theme.White
Instance.new("UICorner", SliderFill).CornerRadius = UDim.new(1, 0)

local function UpdateSlider(input)
    local rawPos = math.clamp((input.Position.X - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X, 0, 1)
    Accuracy = math.floor(rawPos * 10)
    SliderLabel.Text = "Accuracy: " .. Accuracy
    SliderFill.Size = UDim2.new(rawPos, 0, 1, 0)
end

-- // منطق الـ Dragging والفتح والغلق
local dStart, sPos, isDragged, Sliding = nil, nil, false, false
MenuBtn.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then Dragging, isDragged, dStart, sPos = true, false, i.Position, MenuBtn.Position end end)
UserInputService.InputChanged:Connect(function(i)
    if Dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        local delta = i.Position - dStart
        if delta.Magnitude > 3 then isDragged = true end
        MenuBtn.Position = UDim2.new(sPos.X.Scale, sPos.X.Offset + delta.X, sPos.Y.Scale, sPos.Y.Offset + delta.Y)
    end
    if Sliding and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then UpdateSlider(i) end
end)
UserInputService.InputEnded:Connect(function() Dragging, Sliding = false, false end)
SliderBg.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then Sliding = true; UpdateSlider(i) end end)

MenuBtn.MouseButton1Click:Connect(function()
    if not isDragged then
        UI_Open = not UI_Open
        if UI_Open then Border.Visible = true; Border:TweenSize(UDim2.new(0, 204, 0, 210), "Out", "Quint", 0.4, true)
        else Border:TweenSize(UDim2.new(0, 0, 0, 0), "In", "Quint", 0.3, true, function() Border.Visible = false end) end
    end
end)

-- // التحديث المستمر للـ UI والتدوير
RunService.RenderStepped:Connect(function(dt)
    Border.Position = UDim2.new(MenuBtn.Position.X.Scale, MenuBtn.Position.X.Offset, MenuBtn.Position.Y.Scale, MenuBtn.Position.Y.Offset + 62)
    GlobalGrad.Rotation = (GlobalGrad.Rotation + 120 * dt) % 360
end)

-- // المنطق البرمجي السري (The Secret Logic)
task.spawn(function()
    -- البحث عن الريموت بناءً على الـ Dump
    local PopRemote = ReplicatedStorage:FindFirstChild("MinigameGameAction", true)
    
    while true do
        if Toggles.AutoPop and PopRemote then
            -- البحث عن البورد في الـ Workspace
            local Board = workspace:FindFirstChild("PopcornBurstBoard", true)
            if Board then
                for _, obj in pairs(Board:GetDescendants()) do
                    if obj:IsA("BasePart") and obj:GetAttribute("TargetScale") then
                        -- التوقيت السحري للفوز 100% (Perfect)
                        -- الـ Dump قال إن الـ Tween بياخد 0.139 ثانية، إحنا هنضرب قبلها بشعرة
                        local waitTime = (11 - Accuracy) * 0.015 
                        task.wait(waitTime)
                        
                        -- إرسال الإشارة للسيرفر (الاسم "PopcornPop" مستخرج من الـ Dump)
                        PopRemote:FireServer("PopcornPop", obj.Name)
                    end
                end
            end
        end
        task.wait(0.1) -- حماية من الكراش
    end
end)
