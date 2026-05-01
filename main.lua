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

-- [ الإعدادات اللونية الموحدة ]
local MainBlue = Color3.fromRGB(45, 85, 160)
local Theme = {
    Bg = Color3.fromRGB(12, 12, 15),
    White = Color3.new(1, 1, 1),
    OffRed = Color3.fromRGB(175, 55, 55),
    OnGreen = Color3.fromRGB(55, 165, 95)
}

local CrystalToggles = {AutoFourRow = false, AutoPopcorn = false, AutoShips = false}

-- [ الأيقونة ]
local MenuButton = Instance.new("TextButton", CrystalGui)
MenuButton.Size = UDim2.new(0, 52, 0, 52)
MenuButton.Position = UDim2.new(0.05, 0, 0.25, 0)
MenuButton.BackgroundColor3 = MainBlue
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

-- [ القائمة الرئيسية - نظام الإطار المزدوج لضمان الحواف ]
local BorderFrame = Instance.new("Frame", CrystalGui) -- هذا هو إطار الحافة
BorderFrame.Name = "BorderFrame"
BorderFrame.BackgroundColor3 = Theme.White
BorderFrame.Size = UDim2.new(0, 0, 0, 0) -- سيبدأ من الصفر
BorderFrame.Position = UDim2.new(MenuButton.Position.X.Scale, MenuButton.Position.X.Offset, MenuButton.Position.Y.Scale, MenuButton.Position.Y.Offset + 60)
BorderFrame.ClipsDescendants = true
BorderFrame.Visible = false
Instance.new("UICorner", BorderFrame).CornerRadius = UDim.new(0, 10)

local MainFrame = Instance.new("Frame", BorderFrame) -- القائمة الفعلية بالداخل
MainFrame.Name = "MainFrame"
MainFrame.BackgroundColor3 = Theme.Bg
MainFrame.Size = UDim2.new(1, -4, 1, -4) -- ترك مسافة 2 بكسل لكل حافة
MainFrame.Position = UDim2.new(0, 2, 0, 2)
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 9)

-- [ التدرج اللوني الموحد للحواف والخط ]
local GlobalGradient = Instance.new("UIGradient", BorderFrame)
GlobalGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, MainBlue),
    ColorSequenceKeypoint.new(0.5, Theme.White),
    ColorSequenceKeypoint.new(1, MainBlue)
})

-- [ العنوان ]
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

-- [ الخط تحت الاسم - سُمك مطابق للحافة ]
local UnderLine = Instance.new("Frame", MainFrame)
UnderLine.Size = UDim2.new(0, 120, 0, 2) -- سُمك 2 بكسل
UnderLine.Position = UDim2.new(0.5, -60, 0, 40)
UnderLine.BackgroundColor3 = Theme.White
UnderLine.BorderSizePixel = 0
Instance.new("UICorner", UnderLine).CornerRadius = UDim.new(1, 0)

local LineGradient = Instance.new("UIGradient", UnderLine)
LineGradient.Color = GlobalGradient.Color

-- [ أنيميشن التدوير المستمر ]
task.spawn(function()
    local rot = 0
    while task.wait(0.01) do
        rot = (rot + 3) % 360
        GlobalGradient.Rotation = rot
        TitleGradient.Rotation = rot
        LineGradient.Rotation = rot
    end
end)

-- [ صنع الأزرار ]
local function CreateButton(Text, Key, PosY)
    local Btn = Instance.new("TextButton", MainFrame)
    Btn.Size = UDim2.new(0, 180, 0, 38)
    Btn.Position = UDim2.new(0.5, -90, 0, PosY)
    Btn.BackgroundColor3 = Theme.OffRed
    Btn.Text = Text .. " [Disable]"
    Btn.TextColor3 = Theme.White
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 13
    Btn.AutoButtonColor = false
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)

    Btn.MouseButton1Click:Connect(function()
        CrystalToggles[Key] = not CrystalToggles[Key]
        Btn.Text = Text .. (CrystalToggles[Key] and " [Active]" or " [Disable]")
        TweenService:Create(Btn, TweenInfo.new(0.3), {
            BackgroundColor3 = CrystalToggles[Key] and Theme.OnGreen or Theme.OffRed
        }):Play()
    end)
end

CreateButton("Auto 4-Row", "AutoFourRow", 55)
CreateButton("Auto Popcorn", "AutoPopcorn", 101)
CreateButton("Auto Ships", "AutoShips", 147)

-- [ نظام السحب والفتح ]
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

