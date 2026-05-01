local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

if CoreGui:FindFirstChild("CrystalProject") then 
    CoreGui.CrystalProject:Destroy() 
end

local CrystalGui = Instance.new("ScreenGui", CoreGui)
CrystalGui.Name = "CrystalProject"
CrystalGui.IgnoreGuiInset = true

-- [ إعدادات الألوان المقتبسة من Velocity Controller ]
local Theme = {
    Bg = Color3.fromRGB(25, 35, 55),    -- نفس خلفية السكربت الذي أرسلته
    MainBlue = Color3.fromRGB(45, 85, 160), -- الأزرق الملكي المتطابق
    White = Color3.new(1, 1, 1),
    -- ألوان هادئة ومتناسقة مع الأزرق
    OffRed = Color3.fromRGB(160, 70, 70),  -- أحمر هادئ صلب
    OnGreen = Color3.fromRGB(55, 180, 120), -- أخضر هادئ صلب (نفس درجة الـ ON)
}

local CrystalToggles = {AutoFourRow = false, AutoPopcorn = false, AutoShips = false}

-- [ الأيقونة - زرقاء متطابقة ]
local MenuButton = Instance.new("TextButton", CrystalGui)
MenuButton.Size = UDim2.new(0, 52, 0, 52)
MenuButton.Position = UDim2.new(0.05, 0, 0.25, 0)
MenuButton.BackgroundColor3 = Theme.MainBlue
MenuButton.Text = ""
MenuButton.AutoButtonColor = false
MenuButton.ZIndex = 10
Instance.new("UICorner", MenuButton).CornerRadius = UDim.new(0, 10)

for i = -1, 1 do
    local Line = Instance.new("Frame", MenuButton)
    Line.Size = UDim2.new(0, 24, 0, 3)
    Line.Position = UDim2.new(0.5, -12, 0.5, (i * 9) - 1.5)
    Line.BackgroundColor3 = Theme.White
    Line.ZIndex = 11
    Instance.new("UICorner", Line).CornerRadius = UDim.new(1, 0)
end

-- [ القائمة الرئيسية - نظام الحواف المتحركة ]
local BorderFrame = Instance.new("Frame", CrystalGui)
BorderFrame.Name = "BorderFrame"
BorderFrame.BackgroundColor3 = Theme.White
BorderFrame.Size = UDim2.new(0, 0, 0, 0)
BorderFrame.Position = UDim2.new(MenuButton.Position.X.Scale, MenuButton.Position.X.Offset, MenuButton.Position.Y.Scale, MenuButton.Position.Y.Offset + 60)
BorderFrame.ClipsDescendants = true
BorderFrame.Visible = false
Instance.new("UICorner", BorderFrame).CornerRadius = UDim.new(0, 12)

local MainFrame = Instance.new("Frame", BorderFrame)
MainFrame.Name = "MainFrame"
MainFrame.BackgroundColor3 = Theme.Bg
MainFrame.BackgroundTransparency = 0
MainFrame.Size = UDim2.new(1, -4, 1, -4) 
MainFrame.Position = UDim2.new(0, 2, 0, 2)
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

-- [ التدرج اللوني (أزرق وأبيض انسيابي) ]
local GlobalGradient = Instance.new("UIGradient", BorderFrame)
GlobalGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Theme.MainBlue),
    ColorSequenceKeypoint.new(0.5, Theme.White), -- الشيء الأبيض الذي يمر بسلاسة
    ColorSequenceKeypoint.new(1, Theme.MainBlue)
})

-- [ العنوان فوق ]
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 45)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.Text = "Crystal Hub"
Title.TextColor3 = Theme.White
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.BackgroundTransparency = 1
local TitleGradient = Instance.new("UIGradient", Title)
TitleGradient.Color = GlobalGradient.Color

-- [ الخط تحت الاسم - نفس سُمك الحواف ]
local UnderLine = Instance.new("Frame", MainFrame)
UnderLine.Size = UDim2.new(0, 120, 0, 2) 
UnderLine.Position = UDim2.new(0.5, -60, 0, 40)
UnderLine.BackgroundColor3 = Theme.White
UnderLine.BorderSizePixel = 0
Instance.new("UICorner", UnderLine).CornerRadius = UDim.new(1, 0)
local LineGradient = Instance.new("UIGradient", UnderLine)
LineGradient.Color = GlobalGradient.Color

-- [ أنيميشن الدوران السلس ]
task.spawn(function()
    local rot = 0
    while task.wait(0.01) do
        rot = (rot + 3) % 360
        GlobalGradient.Rotation = rot
        TitleGradient.Rotation = rot
        LineGradient.Rotation = rot
    end
end)

-- [ وظيفة صنع الأزرار بالألوان الهادئة ]
local function CreateButton(Text, Key, PosY)
    local Btn = Instance.new("TextButton", MainFrame)
    Btn.Size = UDim2.new(0, 180, 0, 38)
    Btn.Position = UDim2.new(0.5, -90, 0, PosY)
    Btn.BackgroundColor3 = Theme.OffRed
    Btn.BackgroundTransparency = 0
    Btn.Text = Text .. " [Disable]"
    Btn.TextColor3 = Theme.White
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 13
    Btn.AutoButtonColor = false
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)

    Btn.MouseButton1Click:Connect(function()
        CrystalToggles[Key] = not CrystalToggles[Key]
        Btn.Text = Text .. (CrystalToggles[Key] and " [Active]" or " [Disable]")
        
        TweenService:Create(Btn, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
            BackgroundColor3 = CrystalToggles[Key] and Theme.OnGreen or Theme.OffRed
        }):Play()
    end)
end

CreateButton("Auto 4-Row", "AutoFourRow", 55)
CreateButton("Auto Popcorn", "AutoPopcorn", 101)
CreateButton("Auto Ships", "AutoShips", 147)

-- [ نظام السحب والفتح الموحد ]
local Dragging, DragStart, StartPos
local IsDragged = false

MenuButton.InputBegan:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
        Dragging = true; IsDragged = false; DragStart = Input.Position; StartPos = MenuButton.Position
    end
end)

UserInputService.InputChanged:Connect(function(Input)
    if Dragging and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
        local Delta = Input.Position - DragStart
        if Delta.Magnitude > 3 then IsDragged = true end
        local NewPos = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
        MenuButton.Position = NewPos
        if BorderFrame.Visible then
            BorderFrame.Position = UDim2.new(NewPos.X.Scale, NewPos.X.Offset, NewPos.Y.Scale, NewPos.Y.Offset + 60)
        end
    end
end)

UserInputService.InputEnded:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then Dragging = false end
end)

MenuButton.MouseButton1Click:Connect(function()
    if not IsDragged then
        if not BorderFrame.Visible then
            BorderFrame.Visible = true
            BorderFrame:TweenSize(UDim2.new(0, 204, 0, 199), "Out", "Back", 0.4, true)
        else
            BorderFrame:TweenSize(UDim2.new(0, 0, 0, 0), "In", "Back", 0.3, true, function() BorderFrame.Visible = false end)
        end
    end
end)
