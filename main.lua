local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local UnderLine = Instance.new("Frame")
local UnderLineGlow = Instance.new("Frame")
local MenuButton = Instance.new("TextButton")
local EspBtn = Instance.new("TextButton")
local PopBtn = Instance.new("TextButton")

ScreenGui.Name = "CrystalProject"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

MenuButton.Name = "MenuIcon"
MenuButton.Parent = ScreenGui
MenuButton.Size = UDim2.new(0, 55, 0, 55)
MenuButton.Position = UDim2.new(0.05, 0, 0.15, 0)
MenuButton.BackgroundColor3 = Color3.fromRGB(45, 85, 160)
MenuButton.BorderSizePixel = 0
MenuButton.AutoButtonColor = false 
MenuButton.Text = ""
Instance.new("UICorner", MenuButton).CornerRadius = UDim.new(0, 14)

local LinesContainer = Instance.new("Frame", MenuButton)
LinesContainer.Size = UDim2.new(0, 28, 0, 22)
LinesContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
LinesContainer.AnchorPoint = Vector2.new(0.5, 0.5)
LinesContainer.BackgroundTransparency = 1

for i = 0, 2 do
    local line = Instance.new("Frame")
    line.Parent = LinesContainer
    line.Size = UDim2.new(1, 0, 0, 4)
    line.Position = UDim2.new(0, 0, 0, i * 9)
    line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    line.BorderSizePixel = 0 
end

MainFrame.Name = "MainHub"
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

local Layout = Instance.new("UIListLayout", MainFrame)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Layout.Padding = UDim.new(0, 12)
Layout.SortOrder = Enum.SortOrder.LayoutOrder

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 45)
Title.Text = "CRYSTAL HUB"
Title.TextColor3 = Color3.fromRGB(45, 85, 160)
Title.BackgroundTransparency = 1
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.LayoutOrder = 1

UnderLine.Parent = Title
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

local function ConfigButton(btn, text, order)
    btn.Parent = MainFrame
    btn.Size = UDim2.new(0.85, 0, 0, 42)
    btn.BackgroundColor3 = Color3.fromRGB(140, 50, 50)
    btn.Text = text .. " [Disable]"
    btn.TextColor3 = Color3.fromRGB(240, 240, 240)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.LayoutOrder = order
    btn.AutoButtonColor = false 
    btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
end

ConfigButton(EspBtn, "Esp Bomb", 2)
ConfigButton(PopBtn, "Auto Pop", 3)

local dragging, dragStart, startPos = false, nil, nil
local isActuallyDragging = false

MenuButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        isActuallyDragging = false
        dragStart = input.Position
        startPos = MenuButton.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        if delta.Magnitude > 5 then
            isActuallyDragging = true
        end
        MenuButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        if MainFrame.Visible then
            MainFrame.Position = UDim2.new(MenuButton.Position.X.Scale, MenuButton.Position.X.Offset, MenuButton.Position.Y.Scale, MenuButton.Position.Y.Offset + 65)
        end
    end
end)

MenuButton.MouseButton1Click:Connect(function()
    if not isActuallyDragging then
        local open = not MainFrame.Visible
        if open then
            MainFrame.Visible = true
            MainFrame:TweenSizeAndPosition(UDim2.new(0, 190, 0, 175), UDim2.new(MenuButton.Position.X.Scale, MenuButton.Position.X.Offset, MenuButton.Position.Y.Scale, MenuButton.Position.Y.Offset + 65), "Out", "Back", 0.3, true)
        else
            MainFrame:TweenSizeAndPosition(UDim2.new(0, 0, 0, 0), MenuButton.Position, "In", "Back", 0.2, true, function() if not MainFrame.Visible then MainFrame.Visible = false end end)
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

local espActive = false
EspBtn.MouseButton1Click:Connect(function()
    espActive = not espActive
    EspBtn.Text = espActive and "Esp Bomb [Active]" or "Esp Bomb [Disable]"
    TweenService:Create(EspBtn, TweenInfo.new(0.2), {BackgroundColor3 = espActive and Color3.fromRGB(50, 120, 80) or Color3.fromRGB(140, 50, 50)}):Play()
    if not espActive then
        for _, v in pairs(workspace:GetDescendants()) do if v.Name == "BombTracker" then v:Destroy() end end
    end
end)

local popActive = false
PopBtn.MouseButton1Click:Connect(function()
    popActive = not popActive
    PopBtn.Text = popActive and "Auto Pop [Active]" or "Auto Pop [Disable]"
    TweenService:Create(PopBtn, TweenInfo.new(0.2), {BackgroundColor3 = popActive and Color3.fromRGB(50, 120, 80) or Color3.fromRGB(140, 50, 50)}):Play()
end)

task.spawn(function()
    while true do
        if espActive then
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("Model") and (obj.Name == "Candy Bomb" or obj.Name:find("Bomb")) then
                    for _, p in pairs(obj:GetDescendants()) do
                        if p:IsA("BasePart") and not p:FindFirstChild("BombTracker") then
                            if p.Name:lower():find("bomb") or (p.Color.R > 0.6 and p.Color.G < 0.3) then
                                local b = Instance.new("BillboardGui", p)
                                b.Name = "BombTracker"; b.AlwaysOnTop = true; b.Size = UDim2.new(3,0,3,0)
                                local f = Instance.new("Frame", b)
                                f.Size = UDim2.new(1,0,1,0); f.BackgroundColor3 = Color3.fromRGB(255,0,0); f.BackgroundTransparency = 0.5
                                Instance.new("UIStroke", f).Color = Color3.fromRGB(255,255,255)
                            end
                        end
                    end
                end
            end
        end
        task.wait(0.4)
    end
end)

RunService.Heartbeat:Connect(function()
    if popActive then
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            for _, m in pairs(workspace:GetDescendants()) do
                if m:IsA("Model") and m.Name == "Popcorn Burst" then
                    for _, p in pairs(m:GetDescendants()) do
                        if p:IsA("BasePart") and p.Transparency < 0.5 then
                            firetouchinterest(hrp, p, 0)
                            firetouchinterest(hrp, p, 1)
                        end
                    end
                end
            end
        end
    end
end)
