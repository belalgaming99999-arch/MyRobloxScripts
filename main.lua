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

local Theme = {
    Bg = Color3.fromRGB(15, 15, 20),
    MainBlue = Color3.fromRGB(45, 85, 160),
    White = Color3.new(1, 1, 1),
    OffRed = Color3.fromRGB(175, 55, 55),
    OnGreen = Color3.fromRGB(55, 165, 95)
}

local CrystalToggles = {AutoFourRow = false, AutoPopcorn = false, AutoShips = false}

-- [ الأيقونة ]
local MenuButton = Instance.new("TextButton", CrystalGui)
MenuButton.Name = "MenuButton"
MenuButton.Size = UDim2.new(0, 52, 0, 52)
MenuButton.Position = UDim2.new(0.05, 0, 0.25, 0)
MenuButton.BackgroundColor3 = Theme.MainBlue
MenuButton.Text = ""
MenuButton.AutoButtonColor = false
MenuButton.ZIndex = 10
Instance.new("UICorner", MenuButton).CornerRadius = UDim.new(0, 10)

for Index = -1, 1 do
    local Line = Instance.new("Frame", MenuButton)
    Line.Size = UDim2.new(0, 24, 0, 3)
    Line.Position = UDim2.new(0.5, -12, 0.5, (Index * 9) - 1.5)
    Line.BackgroundColor3 = Theme.White
    Line.BorderSizePixel = 0
    Line.ZIndex = 11
    Instance.new("UICorner", Line).CornerRadius = UDim.new(1, 0)
end

-- [ القائمة الرئيسية ]
local MainFrame = Instance.new("Frame", CrystalGui)
MainFrame.Name = "MainFrame"
MainFrame.BackgroundColor3 = Theme.Bg
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame.Position = UDim2.new(MenuButton.Position.X.Scale, MenuButton.Position.X.Offset, MenuButton.Position.Y.Scale, MenuButton.Position.Y.Offset + 60)
MainFrame.ClipsDescendants = true
MainFrame.Visible = false
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

local FrameStroke = Instance.new("UIStroke", MainFrame)
FrameStroke.Thickness = 1.8
FrameStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local BorderGradient = Instance.new("UIGradient", FrameStroke)
BorderGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Theme.MainBlue),
    ColorSequenceKeypoint.new(0.5, Theme.White),
    ColorSequenceKeypoint.new(1, Theme.MainBlue)
})

-- [ العنوان الفوق خالص ]
local Title = Instance.new("TextLabel", MainFrame)
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 45)
Title.Position = UDim2.new(0, 0, 0, 5)
Title.Text = "Crystal Hub"
Title.TextColor3 = Theme.White
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.BackgroundTransparency = 1

local TitleGradient = Instance.new("UIGradient", Title)
TitleGradient.Color = BorderGradient.Color

local UnderLine = Instance.new("Frame", MainFrame)
UnderLine.Name = "UnderLine"
UnderLine.Size = UDim2.new(0.7, 0, 0, 2)
UnderLine.Position = UDim2.new(0.15, 0, 0, 45)
UnderLine.BackgroundColor3 = Theme.White
UnderLine.BorderSizePixel = 0
Instance.new("UICorner", UnderLine).CornerRadius = UDim.new(1, 0)

-- [ أنيميشن التدوير ]
task.spawn(function()
    local Rotation = 0
    while task.wait(0.01) do
        Rotation = (Rotation + 3) % 360
        BorderGradient.Rotation = Rotation
        TitleGradient.Rotation = Rotation
    end
end)

-- [ أزرار التفعيل بمواقع ثابتة ]
local function CreateButton(Text, Key, PosY, Logic)
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
        if CrystalToggles[Key] then task.spawn(Logic) end
    end)
end

-- توزيع يدوي دقيق للمسافات
CreateButton("Auto 4-Row", "AutoFourRow", 60, function() end)
CreateButton("Auto Popcorn", "AutoPopcorn", 105, function() end)
CreateButton("Auto Ships", "AutoShips", 150, function() end)

-- [ نظام السحب ]
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
        if MainFrame.Visible then
            MainFrame.Position = UDim2.new(NewPos.X.Scale, NewPos.X.Offset, NewPos.Y.Scale, NewPos.Y.Offset + 60)
        end
    end
end)

UserInputService.InputEnded:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then Dragging = false end
end)

MenuButton.MouseButton1Click:Connect(function()
    if not IsDragged then
        if not MainFrame.Visible then
            MainFrame.Visible = true
            MainFrame.Position = UDim2.new(MenuButton.Position.X.Scale, MenuButton.Position.X.Offset, MenuButton.Position.Y.Scale, MenuButton.Position.Y.Offset + 60)
            MainFrame:TweenSize(UDim2.new(0, 205, 0, 200), "Out", "Back", 0.4, true)
        else
            MainFrame:TweenSize(UDim2.new(0, 0, 0, 0), "In", "Back", 0.3, true, function() MainFrame.Visible = false end)
        end
    end
end)
