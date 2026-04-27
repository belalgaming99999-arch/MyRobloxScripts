local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local UnderLine = Instance.new("Frame")
local UnderLineGlow = Instance.new("Frame")
local BigBtn = Instance.new("TextButton")
local MenuButton = Instance.new("TextButton")

ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

MenuButton.Name = "CrystalMenuBtn"
MenuButton.Parent = ScreenGui
MenuButton.Size = UDim2.new(0, 55, 0, 55)
MenuButton.Position = UDim2.new(0.05, 0, 0.15, 0)
MenuButton.BackgroundColor3 = Color3.fromRGB(45, 85, 160)
MenuButton.Text = ""
MenuButton.BorderSizePixel = 0
MenuButton.AutoButtonColor = false 
Instance.new("UICorner", MenuButton).CornerRadius = UDim.new(0, 14)

for i = -1, 1 do
    local line = Instance.new("Frame")
    line.Parent = MenuButton
    line.Size = UDim2.new(0, 28, 0, 4)
    line.Position = UDim2.new(0.5, -14, 0.5, i * 9)
    line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    line.BorderSizePixel = 0
end

MainFrame.Name = "CrystalHub"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 30, 45)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true 
MainFrame.Visible = false
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame.Position = MenuButton.Position
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Color3.fromRGB(45, 85, 160)
MainStroke.Thickness = 1.5

Title.Parent = MainFrame
Title.Size = UDim2.new(0, 190, 0, 40)
Title.Text = "CRYSTAL HUB"
Title.TextColor3 = Color3.fromRGB(45, 85, 160)
Title.BackgroundTransparency = 1
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold

UnderLine.Parent = MainFrame
UnderLine.BackgroundColor3 = Color3.fromRGB(45, 85, 160)
UnderLine.BorderSizePixel = 0
UnderLine.Position = UDim2.new(0.5, -45, 0, 36)
UnderLine.Size = UDim2.new(0, 90, 0, 2)
Instance.new("UICorner", UnderLine).CornerRadius = UDim.new(1, 0)

UnderLineGlow.Parent = UnderLine
UnderLineGlow.BackgroundColor3 = Color3.fromRGB(45, 85, 160)
UnderLineGlow.BackgroundTransparency = 0.6
UnderLineGlow.BorderSizePixel = 0
UnderLineGlow.Position = UDim2.new(-0.1, 0, -0.5, 0)
UnderLineGlow.Size = UDim2.new(1.2, 0, 2, 0)
Instance.new("UICorner", UnderLineGlow).CornerRadius = UDim.new(1, 0)

BigBtn.Name = "EspMainBtn"
BigBtn.Parent = MainFrame
BigBtn.Position = UDim2.new(0.1, 0, 0.42, 0)
BigBtn.Size = UDim2.new(0.8, 0, 0, 55)
BigBtn.BackgroundColor3 = Color3.fromRGB(140, 50, 50)
BigBtn.Text = "Esp Disable"
BigBtn.TextColor3 = Color3.fromRGB(240, 240, 240)
BigBtn.Font = Enum.Font.GothamBold
BigBtn.TextSize = 18
BigBtn.BorderSizePixel = 0
BigBtn.AutoButtonColor = false
Instance.new("UICorner", BigBtn).CornerRadius = UDim.new(0, 10)

local dragging, dragStart, startPos, dragDistance = false, nil, nil, 0
local menuOpen = false

local function toggleMenu()
    menuOpen = not menuOpen
    if menuOpen then
        MainFrame.Visible = true
        MainFrame:TweenSizeAndPosition(UDim2.new(0, 190, 0, 130), UDim2.new(MenuButton.Position.X.Scale, MenuButton.Position.X.Offset, MenuButton.Position.Y.Scale, MenuButton.Position.Y.Offset + 65), "Out", "Back", 0.5, true)
    else
        MainFrame:TweenSizeAndPosition(UDim2.new(0, 0, 0, 0), MenuButton.Position, "In", "Back", 0.4, true, function() if not menuOpen then MainFrame.Visible = false end end)
    end
end

MenuButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging, dragStart, startPos, dragDistance = true, input.Position, MenuButton.Position, 0
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        dragDistance = delta.Magnitude
        MenuButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        if menuOpen then MainFrame.Position = UDim2.new(MenuButton.Position.X.Scale, MenuButton.Position.X.Offset, MenuButton.Position.Y.Scale, MenuButton.Position.Y.Offset + 65) end
    end
end)

MenuButton.MouseButton1Click:Connect(function() if dragDistance < 5 then toggleMenu() end end)
UserInputService.InputEnded:Connect(function() dragging = false end)

local espActive = false
BigBtn.MouseButton1Click:Connect(function()
    espActive = not espActive
    BigBtn.Text = espActive and "Esp Active" or "Esp Disable"
    TweenService:Create(BigBtn, TweenInfo.new(0.4), {BackgroundColor3 = espActive and Color3.fromRGB(50, 120, 80) or Color3.fromRGB(140, 50, 50)}):Play()

    while espActive do
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Model") or obj:IsA("BasePart") then
                if obj.Name:lower():find("bomb") or obj.Name:lower():find("mine") then
                    local h = obj:FindFirstChild("Highlight") or Instance.new("Highlight", obj)
                    h.FillColor = Color3.fromRGB(255, 0, 0)
                    h.Enabled = true
                elseif obj.Name:lower():find("card") or obj.Name:lower():find("safe") then
                    local h = obj:FindFirstChild("Highlight") or Instance.new("Highlight", obj)
                    h.FillColor = Color3.fromRGB(0, 255, 0)
                    h.Enabled = true
                end
            end
        end
        task.wait(1)
        if not espActive then break end
    end
    
    if not espActive then
        for _, obj in pairs(workspace:GetDescendants()) do
            local h = obj:FindFirstChild("Highlight")
            if h then h:Destroy() end
        end
    end
end)
