local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

if CoreGui:FindFirstChild("CrystalProject") then 
    CoreGui.CrystalProject:Destroy() 
end

local CrystalGui = Instance.new("ScreenGui", CoreGui)
CrystalGui.Name = "CrystalProject"
CrystalGui.IgnoreGuiInset = true

local CrystalToggles = {
    AutoFourRow = false,
    AutoPopcorn = false,
    AutoShips = false
}

-- [ الأيقونة الزرقاء السلسة ]
local MenuButton = Instance.new("TextButton", CrystalGui)
MenuButton.Name = "MenuButton"
MenuButton.Size = UDim2.new(0, 55, 0, 55)
MenuButton.Position = UDim2.new(0.05, 0, 0.25, 0)
MenuButton.BackgroundColor3 = Color3.fromRGB(35, 65, 135) -- أزرق سلس
MenuButton.Text = ""
MenuButton.AutoButtonColor = false
MenuButton.ZIndex = 10
Instance.new("UICorner", MenuButton).CornerRadius = UDim.new(0, 12)

for Index = -1, 1 do
    local Line = Instance.new("Frame", MenuButton)
    Line.Size = UDim2.new(0, 26, 0, 4)
    Line.Position = UDim2.new(0.5, -13, 0.5, (Index * 10) - 2)
    Line.BackgroundColor3 = Color3.new(1, 1, 1)
    Line.BorderSizePixel = 0
    Line.ZIndex = 11
    Instance.new("UICorner", Line).CornerRadius = UDim.new(1, 0)
end

-- [ القائمة الرئيسية ]
local MainFrame = Instance.new("Frame", CrystalGui)
MainFrame.Name = "MainFrame"
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame.Position = UDim2.new(MenuButton.Position.X.Scale, MenuButton.Position.X.Offset, MenuButton.Position.Y.Scale, MenuButton.Position.Y.Offset + 65)
MainFrame.ClipsDescendants = true
MainFrame.Visible = false
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 15)

local FrameStroke = Instance.new("UIStroke", MainFrame)
FrameStroke.Color = Color3.fromRGB(45, 90, 200) -- حواف زرقاء سلسة
FrameStroke.Thickness = 2
FrameStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local ListLayout = Instance.new("UIListLayout", MainFrame)
ListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
ListLayout.Padding = UDim.new(0, 10)

-- [ العنوان والخط - فوق خالص ]
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 45)
Title.Text = "Crystal Hub"
Title.TextColor3 = Color3.fromRGB(65, 130, 255) -- أزرق كريستالي سلس
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22
Title.BackgroundTransparency = 1

local UnderLine = Instance.new("Frame", MainFrame)
UnderLine.Size = UDim2.new(0.8, 0, 0, 2)
UnderLine.BackgroundColor3 = Color3.fromRGB(65, 130, 255)
UnderLine.BorderSizePixel = 0
Instance.new("UICorner", UnderLine).CornerRadius = UDim.new(1, 0)

-- [ وظيفة صنع الأزرار بالألوان السلسة ]
local function CreateButton(Text, Key, Logic)
    local Btn = Instance.new("TextButton", MainFrame)
    Btn.Size = UDim2.new(0, 185, 0, 42)
    Btn.BackgroundColor3 = Color3.fromRGB(175, 55, 55) -- أحمر سلس
    Btn.Text = Text .. " [Disable]"
    Btn.TextColor3 = Color3.new(1, 1, 1)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 14
    Btn.AutoButtonColor = false
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)

    Btn.MouseButton1Click:Connect(function()
        CrystalToggles[Key] = not CrystalToggles[Key]
        Btn.Text = Text .. (CrystalToggles[Key] and " [Active]" or " [Disable]")
        
        -- أنيميشن تغيير اللون للأخضر السلس
        TweenService:Create(Btn, TweenInfo.new(0.3), {
            BackgroundColor3 = CrystalToggles[Key] and Color3.fromRGB(55, 165, 95) or Color3.fromRGB(175, 55, 55)
        }):Play()
        
        if CrystalToggles[Key] then task.spawn(Logic) end
    end)
end

CreateButton("Auto 4-Row", "AutoFourRow", function() while CrystalToggles.AutoFourRow do task.wait(0.1) end end)
CreateButton("Auto Popcorn", "AutoPopcorn", function() while CrystalToggles.AutoPopcorn do task.wait(0.01) end end)
CreateButton("Auto Ships", "AutoShips", function() while CrystalToggles.AutoShips do task.wait(0.1) end end)

-- [ نظام السحب والربط ]
local Dragging, DragStart, StartPos
local IsDragged = false

MenuButton.InputBegan:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
        Dragging = true
        IsDragged = false
        DragStart = Input.Position
        StartPos = MenuButton.Position
    end
end)

UserInputService.InputChanged:Connect(function(Input)
    if Dragging and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
        local Delta = Input.Position - DragStart
        if Delta.Magnitude > 3 then IsDragged = true end
        
        local NewPos = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
        MenuButton.Position = NewPos
        
        if MainFrame.Visible then
            MainFrame.Position = UDim2.new(NewPos.X.Scale, NewPos.X.Offset, NewPos.Y.Scale, NewPos.Y.Offset + 65)
        end
    end
end)

UserInputService.InputEnded:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
        Dragging = false
    end
end)

MenuButton.MouseButton1Click:Connect(function()
    if not IsDragged then
        if not MainFrame.Visible then
            MainFrame.Visible = true
            MainFrame.Position = UDim2.new(MenuButton.Position.X.Scale, MenuButton.Position.X.Offset, MenuButton.Position.Y.Scale, MenuButton.Position.Y.Offset + 65)
            MainFrame:TweenSize(UDim2.new(0, 215, 0, 265), "Out", "Back", 0.4, true)
        else
            MainFrame:TweenSize(UDim2.new(0, 0, 0, 0), "In", "Back", 0.3, true, function() MainFrame.Visible = false end)
        end
    end
end)
