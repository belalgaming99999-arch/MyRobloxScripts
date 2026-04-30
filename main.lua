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
CrystalGui.IgnoreGuiInset = True

local CrystalToggles = {
    AutoFourRow = False,
    AutoPopcorn = False,
    AutoShips = False
}

local MenuButton = Instance.new("TextButton", CrystalGui)
MenuButton.Name = "MenuButton"
MenuButton.Size = UDim2.new(0, 65, 0, 65)
MenuButton.Position = UDim2.new(0.05, 0, 0.25, 0)
MenuButton.BackgroundColor3 = Color3.fromRGB(30, 50, 100)
MenuButton.Text = ""
MenuButton.ZIndex = 10
Instance.new("UICorner", MenuButton).CornerRadius = UDim.new(0, 15)

for Index = -1, 1 do
    local LineFrame = Instance.new("Frame", MenuButton)
    LineFrame.Size = UDim2.new(0, 32, 0, 5)
    LineFrame.Position = UDim2.new(0.5, -16, 0.5, (Index * 12) - 2)
    LineFrame.BackgroundColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", LineFrame).CornerRadius = UDim.new(1, 0)
end

local MainFrame = Instance.new("Frame", CrystalGui)
MainFrame.Name = "MainFrame"
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame.Position = MenuButton.Position
MainFrame.ClipsDescendants = True
MainFrame.Visible = False
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 15)

local ListLayout = Instance.new("UIListLayout", MainFrame)
ListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
ListLayout.Padding = UDim.new(0, 12)

local TitleLabel = Instance.new("TextLabel", MainFrame)
TitleLabel.Size = UDim2.new(1, 0, 0, 50)
TitleLabel.Text = "Crystal Hub"
TitleLabel.TextColor3 = Color3.fromRGB(70, 140, 255)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 24
TitleLabel.BackgroundTransparency = 1

local UnderLine = Instance.new("Frame", MainFrame)
UnderLine.Size = UDim2.new(0.8, 0, 0, 2)
UnderLine.BackgroundColor3 = Color3.fromRGB(70, 140, 255)
UnderLine.BorderSizePixel = 0
Instance.new("UICorner", UnderLine).CornerRadius = UDim.new(1, 0)

local function CreatePremiumButton(ButtonText, ToggleKey, LogicFunction)
    local ActionButton = Instance.new("TextButton", MainFrame)
    ActionButton.Size = UDim2.new(0.9, 0, 0, 55)
    ActionButton.BackgroundColor3 = Color3.fromRGB(160, 45, 45)
    ActionButton.Text = ButtonText .. " [Disable]"
    ActionButton.TextColor3 = Color3.new(1, 1, 1)
    ActionButton.Font = Enum.Font.GothamBold
    ActionButton.TextSize = 17
    Instance.new("UICorner", ActionButton).CornerRadius = UDim.new(0, 10)

    ActionButton.MouseButton1Click:Connect(function()
        CrystalToggles[ToggleKey] = not CrystalToggles[ToggleKey]
        ActionButton.Text = ButtonText .. (CrystalToggles[ToggleKey] and " [Active]" or " [Disable]")
        TweenService:Create(ActionButton, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {
            BackgroundColor3 = CrystalToggles[ToggleKey] and Color3.fromRGB(45, 160, 80) or Color3.fromRGB(160, 45, 45)
        }):Play()
        if CrystalToggles[ToggleKey] then Task.spawn(LogicFunction) end
    end)
end

CreatePremiumButton("Auto 4-Row", "AutoFourRow", function()
    while CrystalToggles.AutoFourRow do Task.wait(0.1) end
end)

CreatePremiumButton("Auto Popcorn", "AutoPopcorn", function()
    local Connection
    Connection = RunService.RenderStepped:Connect(function()
        if not CrystalToggles.AutoPopcorn then Connection:Disconnect() return end
    end)
end)

CreatePremiumButton("Auto Ships", "AutoShips", function()
    while CrystalToggles.AutoShips do Task.wait(0.2) end
end)

local IsDragging, DragStart, StartPosition
MenuButton.InputBegan:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
        IsDragging = True; DragStart = Input.Position; StartPosition = MenuButton.Position
    end
end)

UserInputService.InputChanged:Connect(function(Input)
    if IsDragging and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
        local Delta = Input.Position - DragStart
        MenuButton.Position = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
        if MainFrame.Visible then
            MainFrame.Position = UDim2.new(MenuButton.Position.X.Scale, MenuButton.Position.X.Offset, MenuButton.Position.Y.Scale, MenuButton.Position.Y.Offset + 75)
        end
    end
end)

MenuButton.MouseButton1Click:Connect(function()
    if IsDragging then IsDragging = False end
    if not MainFrame.Visible then
        MainFrame.Visible = True
        MainFrame:TweenSizeAndPosition(UDim2.new(0, 240, 0, 300), UDim2.new(MenuButton.Position.X.Scale, MenuButton.Position.X.Offset, MenuButton.Position.Y.Scale, MenuButton.Position.Y.Offset + 75), "Out", "Back", 0.4, True)
    else
        MainFrame:TweenSizeAndPosition(UDim2.new(0, 0, 0, 0), MenuButton.Position, "In", "Back", 0.3, True, function() MainFrame.Visible = False end)
    end
end)
