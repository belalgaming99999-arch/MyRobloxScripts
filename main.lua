local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

local function CleanUI()
    for _, child in ipairs(CoreGui:GetChildren()) do
        if child.Name == "CrystalProject" or child.Name == "CrystalHub" then
            child:Destroy()
        end
    end
end
CleanUI()

local CrystalGui = Instance.new("ScreenGui", CoreGui)
CrystalGui.Name = "CrystalProject"
CrystalGui.IgnoreGuiInset = true
CrystalGui.ResetOnSpawn = false

local Theme = {
    Bg = Color3.fromRGB(25, 35, 55),
    MainBlue = Color3.fromRGB(45, 85, 160),
    White = Color3.new(1, 1, 1),
    OffRed = Color3.fromRGB(135, 55, 55), 
    OnGreen = Color3.fromRGB(55, 120, 85),
}

local Toggles = {AutoFourRow = false, AutoPopcorn = false, AutoShips = false}

local function ExecuteLogic(key)
    task.spawn(function()
        while Toggles[key] do
            pcall(function()
                if key == "AutoPopcorn" then
                    local items = workspace:GetDescendants()
                    for i = 1, #items do
                        local v = items[i]
                        if v:IsA("ClickDetector") and Toggles.AutoPopcorn then
                            local plate = v.Parent
                            local isWin = false
                            
                            if plate:GetAttribute("Winning") or (plate:GetAttribute("Multiplier") and plate:GetAttribute("Multiplier") > 0) then
                                isWin = true
                            end
                            
                            if not isWin then
                                local val = plate:FindFirstChild("Value") or plate:FindFirstChildOfClass("IntValue")
                                if val and val.Value > 0 then
                                    isWin = true
                                end
                            end
                            
                            if not isWin then
                                local target = plate:FindFirstChild("Popcorn") or plate:FindFirstChild("Food") or plate:FindFirstChild("Model")
                                if target then
                                    local part = target:IsA("BasePart") and target or target:FindFirstChildOfClass("BasePart")
                                    if part and part.Transparency < 0.6 then
                                        isWin = true
                                    end
                                end
                            end

                            if isWin then
                                fireclickdetector(v)
                            end
                        end
                    end
                elseif key == "AutoShips" then
                    for _, v in ipairs(workspace:GetDescendants()) do
                        if v:IsA("ClickDetector") and v.Parent.Name:find("Ship") then
                            fireclickdetector(v)
                        end
                    end
                elseif key == "AutoFourRow" then
                    for _, v in ipairs(workspace:GetDescendants()) do
                        if v:IsA("ClickDetector") and v.Parent.Name == "Slot" then
                            fireclickdetector(v)
                        end
                    end
                end
            end)
            task.wait(0.003)
        end
    end)
end

local MenuButton = Instance.new("TextButton", CrystalGui)
MenuButton.Size = UDim2.new(0, 52, 0, 52)
MenuButton.Position = UDim2.new(0.05, 0, 0.25, 0)
MenuButton.BackgroundColor3 = Theme.MainBlue
MenuButton.Text = ""
MenuButton.AutoButtonColor = false
MenuButton.ZIndex = 100
Instance.new("UICorner", MenuButton).CornerRadius = UDim.new(0, 10)

for i = -1, 1 do
    local Line = Instance.new("Frame", MenuButton)
    Line.Size = UDim2.new(0, 26, 0, 4)
    Line.Position = UDim2.new(0.5, -13, 0.5, (i * 10) - 2)
    Line.BackgroundColor3 = Theme.White
    Line.ZIndex = 101
    Instance.new("UICorner", Line).CornerRadius = UDim.new(1, 0)
end

local BorderFrame = Instance.new("Frame", CrystalGui)
BorderFrame.BackgroundColor3 = Theme.White
BorderFrame.Size = UDim2.new(0, 0, 0, 0)
BorderFrame.Position = UDim2.new(MenuButton.Position.X.Scale, MenuButton.Position.X.Offset, MenuButton.Position.Y.Scale, MenuButton.Position.Y.Offset + 62)
BorderFrame.ClipsDescendants = true
BorderFrame.Visible = false
BorderFrame.ZIndex = 90
Instance.new("UICorner", BorderFrame).CornerRadius = UDim.new(0, 12)

local MainFrame = Instance.new("Frame", BorderFrame)
MainFrame.BackgroundColor3 = Theme.Bg
MainFrame.Size = UDim2.new(1, -4, 1, -4) 
MainFrame.Position = UDim2.new(0, 2, 0, 2)
MainFrame.ZIndex = 91
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

local GlobalGradient = Instance.new("UIGradient", BorderFrame)
GlobalGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Theme.MainBlue),
    ColorSequenceKeypoint.new(0.5, Theme.White),
    ColorSequenceKeypoint.new(1, Theme.MainBlue)
})

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 45)
Title.Text = "Crystal Hub AI"
Title.TextColor3 = Theme.White
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.BackgroundTransparency = 1
Title.ZIndex = 92
local TitleGradient = Instance.new("UIGradient", Title)
TitleGradient.Color = GlobalGradient.Color

local UnderLine = Instance.new("Frame", MainFrame)
UnderLine.Size = UDim2.new(0, 120, 0, 4)
UnderLine.Position = UDim2.new(0.5, -60, 0, 40)
UnderLine.BackgroundColor3 = Theme.White
UnderLine.ZIndex = 92
Instance.new("UICorner", UnderLine).CornerRadius = UDim.new(1, 0)
local LineGradient = Instance.new("UIGradient", UnderLine)
LineGradient.Color = GlobalGradient.Color

task.spawn(function()
    local rot = 0
    RunService.RenderStepped:Connect(function(dt)
        rot = (rot + 180 * dt) % 360
        GlobalGradient.Rotation = rot
        TitleGradient.Rotation = rot
        LineGradient.Rotation = rot
    end)
end)

local function CreateButton(text, key, posY)
    local Btn = Instance.new("TextButton", MainFrame)
    Btn.Size = UDim2.new(0, 180, 0, 38)
    Btn.Position = UDim2.new(0.5, -90, 0, posY)
    Btn.BackgroundColor3 = Theme.OffRed
    Btn.Text = text .. " [OFF]"
    Btn.TextColor3 = Theme.White
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 12
    Btn.AutoButtonColor = false
    Btn.ZIndex = 93
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)

    Btn.MouseButton1Click:Connect(function()
        Toggles[key] = not Toggles[key]
        Btn.Text = text .. (Toggles[key] and " [AI ACTIVE]" or " [OFF]")
        TweenService:Create(Btn, TweenInfo.new(0.3), {BackgroundColor3 = Toggles[key] and Theme.OnGreen or Theme.OffRed}):Play()
        if Toggles[key] then ExecuteLogic(key) end
    end)
end

CreateButton("Auto 4-Row", "AutoFourRow", 55)
CreateButton("Auto Popcorn", "AutoPopcorn", 101)
CreateButton("Auto Ships", "AutoShips", 147)

local dragging, dragStart, startPos, isDragged
MenuButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; isDragged = false; dragStart = input.Position; startPos = MenuButton.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        if delta.Magnitude > 2 then isDragged = true end
        local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        MenuButton.Position = newPos
        BorderFrame.Position = UDim2.new(newPos.X.Scale, newPos.X.Offset, newPos.Y.Scale, newPos.Y.Offset + 62)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
end)

MenuButton.MouseButton1Click:Connect(function()
    if not isDragged then
        if not BorderFrame.Visible then
            BorderFrame.Visible = true
            BorderFrame:TweenSize(UDim2.new(0, 204, 0, 201), "Out", "Back", 0.5, true)
        else
            BorderFrame:TweenSize(UDim2.new(0, 0, 0, 0), "In", "Back", 0.4, true, function() BorderFrame.Visible = false end)
        end
    end
end)
