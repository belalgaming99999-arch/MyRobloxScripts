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
    Main = Color3.fromRGB(45, 85, 160),
    White = Color3.new(1, 1, 1),
    Off = Color3.fromRGB(135, 55, 55), 
    On = Color3.fromRGB(55, 120, 85),
    Slider = Color3.fromRGB(40, 50, 75)
}

local Toggles = {AutoPop = false, AutoFour = false, Feature3 = false}
local Accuracy = 7 
local UI_Open, Dragging = false, false

local MenuBtn = Instance.new("TextButton", CrystalGui)
MenuBtn.Size = UDim2.new(0, 52, 0, 52)
MenuBtn.Position = UDim2.new(0.05, 0, 0.25, 0)
MenuBtn.BackgroundColor3 = Theme.Main
MenuBtn.Text = ""
MenuBtn.AutoButtonColor = false
Instance.new("UICorner", MenuBtn).CornerRadius = UDim.new(0, 10)

for i = -1, 1 do
    local L = Instance.new("Frame", MenuBtn)
    L.Size = UDim2.new(0, 26, 0, 4)
    L.Position = UDim2.new(0.5, -13, 0.5, (i * 10) - 2)
    L.BackgroundColor3 = Theme.White
    Instance.new("UICorner", L).CornerRadius = UDim.new(1, 0)
end

local Border = Instance.new("Frame", CrystalGui)
Border.Size = UDim2.new(0, 0, 0, 0)
Border.Visible = false
Border.BackgroundColor3 = Theme.White
Border.ClipsDescendants = true
Instance.new("UICorner", Border).CornerRadius = UDim.new(0, 12)

local Main = Instance.new("Frame", Border)
Main.Size = UDim2.new(1, -4, 1, -4)
Main.Position = UDim2.new(0, 2, 0, 2)
Main.BackgroundColor3 = Theme.Bg
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

local GlobalGrad = Instance.new("UIGradient", Border)
GlobalGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Theme.Main),
    ColorSequenceKeypoint.new(0.5, Theme.White),
    ColorSequenceKeypoint.new(1, Theme.Main)
})

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 45)
Title.Text = "Crystal Hub"
Title.TextColor3 = Theme.White
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.BackgroundTransparency = 1
local TitleGrad = GlobalGrad:Clone()
TitleGrad.Parent = Title

local UnderLine = Instance.new("Frame", Main)
UnderLine.Size = UDim2.new(0, 120, 0, 6)
UnderLine.Position = UDim2.new(0.5, -60, 0, 40)
UnderLine.BackgroundColor3 = Theme.White
Instance.new("UICorner", UnderLine).CornerRadius = UDim.new(1, 0)
local LineGrad = GlobalGrad:Clone()
LineGrad.Parent = UnderLine

local function CreateBtn(txt, key, y)
    local B = Instance.new("TextButton", Main)
    B.Size = UDim2.new(0, 180, 0, 36)
    B.Position = UDim2.new(0.5, -90, 0, y)
    B.BackgroundColor3 = Theme.Off
    B.Text = txt .. " [Disable]"
    B.TextColor3 = Theme.White
    B.Font = Enum.Font.GothamBold
    B.TextSize = 13
    B.AutoButtonColor = false
    Instance.new("UICorner", B).CornerRadius = UDim.new(0, 8)

    B.MouseButton1Click:Connect(function()
        Toggles[key] = not Toggles[key]
        B.Text = txt .. (Toggles[key] and " [Active]" or " [Disable]")
        TweenService:Create(B, TweenInfo.new(0.3), {BackgroundColor3 = Toggles[key] and Theme.On or Theme.Off}):Play()
    end)
end

CreateBtn("Auto Pop", "AutoPop", 55)
CreateBtn("Auto 4-Row", "AutoFour", 97)
CreateBtn("Feature 3", "Feature3", 139)

local SliderLabel = Instance.new("TextLabel", Main)
SliderLabel.Size = UDim2.new(1, 0, 0, 20)
SliderLabel.Position = UDim2.new(0, 0, 0, 180)
SliderLabel.BackgroundTransparency = 1
SliderLabel.Text = "Accuracy: 7"
SliderLabel.TextColor3 = Theme.White
SliderLabel.Font = Enum.Font.GothamBold
SliderLabel.TextSize = 16
local SliderGrad = GlobalGrad:Clone()
SliderGrad.Parent = SliderLabel

local SliderBg = Instance.new("Frame", Main)
SliderBg.Size = UDim2.new(0, 120, 0, 6)
SliderBg.Position = UDim2.new(0.5, -60, 0, 208)
SliderBg.BackgroundColor3 = Theme.Slider
Instance.new("UICorner", SliderBg).CornerRadius = UDim.new(1, 0)

local SliderFill = Instance.new("Frame", SliderBg)
SliderFill.Size = UDim2.new(0.7, 0, 1, 0)
SliderFill.BackgroundColor3 = Theme.White
Instance.new("UICorner", SliderFill).CornerRadius = UDim.new(1, 0)
local FillGrad = GlobalGrad:Clone()
FillGrad.Parent = SliderFill

local Knob = Instance.new("Frame", SliderFill)
Knob.Size = UDim2.new(0, 16, 0, 16)
Knob.Position = UDim2.new(1, -8, 0.5, -8)
Knob.BackgroundColor3 = Theme.White
Knob.ZIndex = 5
Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)
local KnobGrad = GlobalGrad:Clone()
KnobGrad.Parent = Knob

local function UpdateSlider(input)
    local xPos = input.Position.X - SliderBg.AbsolutePosition.X
    local rawPos = math.clamp(xPos / SliderBg.AbsoluteSize.X, 0, 1)
    local stepped = math.floor(rawPos * 10)
    if stepped < 1 then stepped = 1 end
    Accuracy = stepped
    SliderLabel.Text = "Accuracy: " .. Accuracy
    SliderFill.Size = UDim2.new(Accuracy / 10, 0, 1, 0)
end

local Sliding = false
SliderBg.InputBegan:Connect(function(i) 
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then 
        Sliding = true; UpdateSlider(i) 
    end 
end)

UserInputService.InputChanged:Connect(function(i) 
    if Sliding and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then 
        UpdateSlider(i) 
    end 
end)

UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then 
        Sliding = false 
    end 
end)

local dStart, sPos, isDragged
MenuBtn.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        Dragging, isDragged, dStart, sPos = true, false, i.Position, MenuBtn.Position
    end
end)

UserInputService.InputChanged:Connect(function(i)
    if Dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        local delta = i.Position - dStart
        if delta.Magnitude > 3 then isDragged = true end
        MenuBtn.Position = UDim2.new(sPos.X.Scale, sPos.X.Offset + delta.X, sPos.Y.Scale, sPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function() Dragging = false end)

MenuBtn.MouseButton1Click:Connect(function()
    if not isDragged then
        UI_Open = not UI_Open
        if UI_Open then
            Border.Visible = true
            Border:TweenSize(UDim2.new(0, 204, 0, 235), "Out", "Quint", 0.4, true)
        else
            Border:TweenSize(UDim2.new(0, 0, 0, 0), "In", "Quint", 0.3, true, function() Border.Visible = false end)
        end
    end
end)

RunService.RenderStepped:Connect(function(dt)
    Border.Position = UDim2.new(MenuBtn.Position.X.Scale, MenuBtn.Position.X.Offset, MenuBtn.Position.Y.Scale, MenuBtn.Position.Y.Offset + 62)
    local rot = (GlobalGrad.Rotation + 150 * dt) % 360
    GlobalGrad.Rotation = rot
    TitleGrad.Rotation = rot
    LineGrad.Rotation = rot
    FillGrad.Rotation = rot
    SliderGrad.Rotation = rot
    KnobGrad.Rotation = rot
end)

task.spawn(function()
    local Remote = ReplicatedStorage:FindFirstChild("MinigameGameAction", true)
    local ClientGlobals = require(ReplicatedStorage:WaitForChild("Client"):WaitForChild("Modules"):WaitForChild("ClientGlobals"))
    
    while true do
        if Toggles.AutoPop and Remote then
            local PopBoard = workspace:FindFirstChild("PopcornBurstBoard", true)
            if PopBoard then
                for _, obj in pairs(PopBoard:GetDescendants()) do
                    if obj:IsA("MeshPart") and obj.Name == "Popcorn" and obj.MeshId ~= "rbxassetid://126040453117483" then
                        local target = obj:GetAttribute("TargetScale")
                        if target then
                            local threshold = 0.9 + (Accuracy * 0.008)
                            if obj.Size.X >= (target * threshold) then
                                task.defer(function() Remote:FireServer("AttemptPop", workspace:GetServerTimeNow()) end)
                            end
                        end
                    end
                end
            end
        end

        if Toggles.AutoFour and Remote then
            local activeGame = ClientGlobals.ActiveMinigame
            if activeGame and activeGame.session and activeGame.session.public then
                local session = activeGame.session
                local myIndex = session.private and session.private.seatIndex
                local currentTurn = session.public.currentTurn
                local phase = session.public.phase
                local grid = session.public.grid

                if phase == "Playing" and currentTurn == myIndex then
                    for col = 1, 7 do
                        local columnData = grid and grid[tostring(col)] or {}
                        if #columnData < 6 then
                            task.wait(0.5)
                            Remote:FireServer("DropChip", col)
                            break
                        end
                    end
                end
            end
        end
        RunService.Heartbeat:Wait()
    end
end)

