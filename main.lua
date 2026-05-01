local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

if CoreGui:FindFirstChild("CrystalProject") then 
    CoreGui.CrystalProject:Destroy() 
end

local CrystalGui = Instance.new("ScreenGui")
CrystalGui.Name = "CrystalProject"
CrystalGui.IgnoreGuiInset = true
CrystalGui.ResetOnSpawn = false
CrystalGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
CrystalGui.Parent = CoreGui

local Theme = {
    Bg = Color3.fromRGB(25, 35, 55),
    MainBlue = Color3.fromRGB(45, 85, 160),
    White = Color3.new(1, 1, 1),
    OffRed = Color3.fromRGB(135, 55, 55), 
    OnGreen = Color3.fromRGB(55, 120, 85),
}

local CrystalToggles = {AutoFourRow = false, AutoPopcorn = false, AutoShips = false}

local function ExecuteLogic(key)
    task.spawn(function()
        while CrystalToggles[key] do
            if key == "AutoPopcorn" then
                -- [ منطق تشغيل طاولة الفشار التلقائي ]
            elseif key == "AutoShips" then
                -- [ منطق تشغيل طاولة السفن التلقائي ]
            elseif key == "AutoFourRow" then
                -- [ منطق تشغيل طاولة 4 صفوف التلقائي ]
            end
            task.wait(0.05)
        end
    end)
end

local MenuButton = Instance.new("TextButton")
MenuButton.Name = "MenuButton"
MenuButton.Size = UDim2.new(0, 52, 0, 52)
MenuButton.Position = UDim2.new(0.05, 0, 0.25, 0)
MenuButton.BackgroundColor3 = Theme.MainBlue
MenuButton.Text = ""
MenuButton.AutoButtonColor = false
MenuButton.ZIndex = 100
MenuButton.Parent = CrystalGui

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 10)
ButtonCorner.Parent = MenuButton

for i = -1, 1 do
    local Line = Instance.new("Frame")
    Line.Size = UDim2.new(0, 26, 0, 4)
    Line.Position = UDim2.new(0.5, -13, 0.5, (i * 10) - 2)
    Line.BackgroundColor3 = Theme.White
    Line.BorderSizePixel = 0
    Line.ZIndex = 101
    Line.Parent = MenuButton
    local LineCorner = Instance.new("UICorner")
    LineCorner.CornerRadius = UDim.new(1, 0)
    LineCorner.Parent = Line
end

local BorderFrame = Instance.new("Frame")
BorderFrame.Name = "BorderFrame"
BorderFrame.BackgroundColor3 = Theme.White
BorderFrame.Size = UDim2.new(0, 0, 0, 0)
BorderFrame.Position = UDim2.new(MenuButton.Position.X.Scale, MenuButton.Position.X.Offset, MenuButton.Position.Y.Scale, MenuButton.Position.Y.Offset + 62)
BorderFrame.ClipsDescendants = true
BorderFrame.Visible = false
BorderFrame.ZIndex = 90
BorderFrame.Parent = CrystalGui

local BorderCorner = Instance.new("UICorner")
BorderCorner.CornerRadius = UDim.new(0, 12)
BorderCorner.Parent = BorderFrame

local MainFrame = Instance.new("Frame")
MainFrame.BackgroundColor3 = Theme.Bg
MainFrame.Size = UDim2.new(1, -4, 1, -4) 
MainFrame.Position = UDim2.new(0, 2, 0, 2)
MainFrame.BorderSizePixel = 0
MainFrame.ZIndex = 91
MainFrame.Parent = BorderFrame

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local GlobalGradient = Instance.new("UIGradient")
GlobalGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Theme.MainBlue),
    ColorSequenceKeypoint.new(0.5, Theme.White),
    ColorSequenceKeypoint.new(1, Theme.MainBlue)
})
GlobalGradient.Parent = BorderFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 45)
Title.Text = "Crystal Hub"
Title.TextColor3 = Theme.White
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.BackgroundTransparency = 1
Title.ZIndex = 92
Title.Parent = MainFrame

local TitleGradient = Instance.new("UIGradient")
TitleGradient.Color = GlobalGradient.Color
TitleGradient.Parent = Title

local UnderLine = Instance.new("Frame")
UnderLine.Size = UDim2.new(0, 120, 0, 4)
UnderLine.Position = UDim2.new(0.5, -60, 0, 40)
UnderLine.BackgroundColor3 = Theme.White
UnderLine.BorderSizePixel = 0
UnderLine.ZIndex = 92
UnderLine.Parent = MainFrame

local UnderLineCorner = Instance.new("UICorner")
UnderLineCorner.CornerRadius = UDim.new(1, 0)
UnderLineCorner.Parent = UnderLine

local LineGradient = Instance.new("UIGradient")
LineGradient.Color = GlobalGradient.Color
LineGradient.Parent = UnderLine

task.spawn(function()
    local rotation = 0
    RunService.RenderStepped:Connect(function(dt)
        rotation = (rotation + 180 * dt) % 360
        GlobalGradient.Rotation = rotation
        TitleGradient.Rotation = rotation
        LineGradient.Rotation = rotation
    end)
end)

local function CreateButton(text, key, posY)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 180, 0, 38)
    Btn.Position = UDim2.new(0.5, -90, 0, posY)
    Btn.BackgroundColor3 = Theme.OffRed
    Btn.Text = text .. " [Disable]"
    Btn.TextColor3 = Theme.White
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 13
    Btn.AutoButtonColor = false
    Btn.ZIndex = 93
    Btn.Parent = MainFrame

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 8)
    BtnCorner.Parent = Btn

    Btn.MouseButton1Click:Connect(function()
        CrystalToggles[key] = not CrystalToggles[key]
        Btn.Text = text .. (CrystalToggles[key] and " [Active]" or " [Disable]")
        
        TweenService:Create(Btn, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            BackgroundColor3 = CrystalToggles[key] and Theme.OnGreen or Theme.OffRed
        }):Play()

        if CrystalToggles[key] then
            ExecuteLogic(key)
        end
    end)
end

CreateButton("Auto 4-Row", "AutoFourRow", 55)
CreateButton("Auto Popcorn", "AutoPopcorn", 101)
CreateButton("Auto Ships", "AutoShips", 147)

local dragging, dragStart, startPos
local isDragged = false

MenuButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; isDragged = false; dragStart = input.Position; startPos = MenuButton.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        if delta.Magnitude > 5 then isDragged = true end
        local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        MenuButton.Position = newPos
        if BorderFrame.Visible then
            BorderFrame.Position = UDim2.new(newPos.X.Scale, newPos.X.Offset, newPos.Y.Scale, newPos.Y.Offset + 62)
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
end)

MenuButton.MouseButton1Click:Connect(function()
    if not isDragged then
        if not BorderFrame.Visible then
            BorderFrame.Visible = true
            BorderFrame:TweenSize(UDim2.new(0, 204, 0, 201), Enum.EasingDirection.Out, Enum.EasingStyle.Back, 0.5, true)
        else
            BorderFrame:TweenSize(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.In, Enum.EasingStyle.Back, 0.4, true, function() BorderFrame.Visible = false end)
        end
    end
end)

