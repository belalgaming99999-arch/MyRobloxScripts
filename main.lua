local Services = setmetatable({}, {
    __index = function(t, k)
        return game:GetService(k)
    end
})

local TS, UIS, CG, LP, RS = Services.TweenService, Services.UserInputService, Services.CoreGui, Services.Players.LocalPlayer, Services.ReplicatedStorage

local UI_ID = "CRYSTAL_ULTRA_2026"
local Existing = CG:FindFirstChild(UI_ID)
if Existing then Existing:Destroy() end

getgenv().Config = {
    AutoPop = false,
    ConnectFour = false,
    Accuracy = 7
}

local Screen = Instance.new("ScreenGui", CG)
Screen.Name = UI_ID
Screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local OpenBtn = Instance.new("TextButton", Screen)
OpenBtn.Size = UDim2.new(0, 110, 0, 35)
OpenBtn.Position = UDim2.new(0.5, -55, 0.15, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
OpenBtn.Text = "Crystal Hub"
OpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.TextSize = 12
OpenBtn.AutoButtonColor = false
OpenBtn.ZIndex = 10
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 18)

local BtnStroke = Instance.new("UIStroke", OpenBtn)
BtnStroke.Color = Color3.fromRGB(0, 140, 255)
BtnStroke.Thickness = 1.8
BtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local Main = Instance.new("CanvasGroup", Screen)
Main.Size = UDim2.new(0, 380, 0, 190)
Main.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
Main.Visible = false
Main.GroupTransparency = 1
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 20)

local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = Color3.fromRGB(0, 140, 255)
MainStroke.Thickness = 1.5
MainStroke.Transparency = 1

local function SmoothTransition(state)
    local info = TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
    if state then
        Main.Position = UDim2.new(OpenBtn.Position.X.Scale, OpenBtn.Position.X.Offset - 135, OpenBtn.Position.Y.Scale, OpenBtn.Position.Y.Offset + 50)
        Main.Visible = true
        TS:Create(Main, info, {GroupTransparency = 0, Size = UDim2.new(0, 380, 0, 190)}):Play()
        TS:Create(MainStroke, info, {Transparency = 0}):Play()
        TS:Create(OpenBtn, info, {BackgroundTransparency = 1, TextTransparency = 1}):Play()
        TS:Create(BtnStroke, info, {Transparency = 1}):Play()
        task.delay(0.5, function() OpenBtn.Visible = false end)
    else
        TS:Create(MainStroke, info, {Transparency = 1}):Play()
        local hide = TS:Create(Main, info, {GroupTransparency = 1, Size = UDim2.new(0, 350, 0, 160)})
        hide:Play()
        OpenBtn.Visible = true
        TS:Create(OpenBtn, info, {BackgroundTransparency = 0, TextTransparency = 0}):Play()
        TS:Create(BtnStroke, info, {Transparency = 0}):Play()
        hide.Completed:Connect(function() Main.Visible = false end)
    end
end

local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 20)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "CRYSTAL HUB v3.0 | 2026"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.BackgroundTransparency = 1

local CloseBtn = Instance.new("TextButton", Main)
CloseBtn.Size = UDim2.new(0, 40, 0, 40)
CloseBtn.Position = UDim2.new(1, -45, 0, 0)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 60, 60)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
CloseBtn.BackgroundTransparency = 1

local function AddToggle(name, pos, var)
    local Frame = Instance.new("Frame", Main)
    Frame.Size, Frame.Position, Frame.BackgroundColor3 = UDim2.new(0, 175, 0, 45), pos, Color3.fromRGB(25, 25, 25)
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 15)

    local Switch = Instance.new("TextButton", Frame)
    Switch.Size, Switch.Position, Switch.BackgroundColor3, Switch.Text = UDim2.new(0, 34, 0, 18), UDim2.new(1, -44, 0.5, -9), Color3.fromRGB(45, 45, 45), ""
    Switch.AutoButtonColor = false
    Instance.new("UICorner", Switch).CornerRadius = UDim.new(1, 0)

    local Dot = Instance.new("Frame", Switch)
    Dot.Size, Dot.Position, Dot.BackgroundColor3 = UDim2.new(0, 14, 0, 14), UDim2.new(0, 2, 0.5, -7), Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)

    local Label = Instance.new("TextLabel", Frame)
    Label.Size, Label.Position, Label.Text = UDim2.new(0, 100, 1, 0), UDim2.new(0, 15, 0, 0), name
    Label.TextColor3, Label.Font, Label.TextSize = Color3.fromRGB(255, 255, 255), Enum.Font.GothamBold, 11
    Label.BackgroundTransparency, Label.TextXAlignment = 1, Enum.TextXAlignment.Left

    Switch.MouseButton1Click:Connect(function()
        getgenv().Config[var] = not getgenv().Config[var]
        TS:Create(Switch, TweenInfo.new(0.35, Enum.EasingStyle.Quart), {BackgroundColor3 = getgenv().Config[var] and Color3.fromRGB(0, 140, 255) or Color3.fromRGB(45, 45, 45)}):Play()
        TS:Create(Dot, TweenInfo.new(0.35, Enum.EasingStyle.Back), {Position = getgenv().Config[var] and UDim2.new(0, 18, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)}):Play()
    end)
end

AddToggle("Auto Popcorn", UDim2.new(0, 10, 0, 55), "AutoPop")
AddToggle("Connect Four", UDim2.new(0, 195, 0, 55), "ConnectFour")

local SliderFrame = Instance.new("Frame", Main)
SliderFrame.Size, SliderFrame.Position, SliderFrame.BackgroundColor3 = UDim2.new(1, -20, 0, 75), UDim2.new(0, 10, 1, -85), Color3.fromRGB(25, 25, 25)
Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0, 15)

local AccLabel = Instance.new("TextLabel", SliderFrame)
AccLabel.Text = "Accuracy: 7"
AccLabel.Size, AccLabel.Position = UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, 10)
AccLabel.TextColor3, AccLabel.Font, AccLabel.TextSize = Color3.fromRGB(255, 255, 255), Enum.Font.GothamBold, 12
AccLabel.BackgroundTransparency = 1

local Bar = Instance.new("Frame", SliderFrame)
Bar.Size, Bar.Position, Bar.BackgroundColor3 = UDim2.new(0, 240, 0, 6), UDim2.new(0.5, -120, 0, 50), Color3.fromRGB(50, 50, 50)
Instance.new("UICorner", Bar).CornerRadius = UDim.new(1, 0)

local Fill = Instance.new("Frame", Bar)
Fill.Size, Fill.BackgroundColor3 = UDim2.new(0.7, 0, 1, 0), Color3.fromRGB(0, 140, 255)
Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

local function UpdateSlider(step)
    getgenv().Config.Accuracy = math.clamp(getgenv().Config.Accuracy + step, 1, 10)
    AccLabel.Text = "Accuracy: " .. getgenv().Config.Accuracy
    TS:Create(Fill, TweenInfo.new(0.4, Enum.EasingStyle.Back), {Size = UDim2.new(getgenv().Config.Accuracy/10, 0, 1, 0)}):Play()
end

local LBtn = Instance.new("TextButton", SliderFrame)
LBtn.Size, LBtn.Position, LBtn.Text = UDim2.new(0, 30, 0, 30), UDim2.new(0, 25, 0, 38), "<"
LBtn.TextColor3, LBtn.BackgroundColor3, LBtn.Font = Color3.fromRGB(255, 255, 255), Color3.fromRGB(0, 140, 255), Enum.Font.GothamBold
Instance.new("UICorner", LBtn).CornerRadius = UDim.new(1, 0)

local RBtn = Instance.new("TextButton", SliderFrame)
RBtn.Size, RBtn.Position, RBtn.Text = UDim2.new(0, 30, 0, 30), UDim2.new(1, -55, 0, 38), ">"
RBtn.TextColor3, RBtn.BackgroundColor3, RBtn.Font = Color3.fromRGB(255, 255, 255), Color3.fromRGB(0, 140, 255), Enum.Font.GothamBold
Instance.new("UICorner", RBtn).CornerRadius = UDim.new(1, 0)

LBtn.MouseButton1Click:Connect(function() UpdateSlider(-1) end)
RBtn.MouseButton1Click:Connect(function() UpdateSlider(1) end)

local Dragging, DragInput, DragStart, StartPos
OpenBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        Dragging, DragStart, StartPos = true, input.Position, OpenBtn.Position
    end
end)
UIS.InputChanged:Connect(function(input)
    if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local Delta = input.Position - DragStart
        OpenBtn.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
    end
end)
UIS.InputEnded:Connect(function() Dragging = false end)

OpenBtn.MouseButton1Click:Connect(function() SmoothTransition(true) end)
CloseBtn.MouseButton1Click:Connect(function() SmoothTransition(false) end)

task.spawn(function()
    local Net = RS:WaitForChild("Shared"):WaitForChild("Remotes"):WaitForChild("Networking")
    local RE = Net:WaitForChild("RE/Minigame/MinigameGameAction")
    
    while task.wait() do
        if getgenv().Config.AutoPop then
            local Count = getgenv().Config.Accuracy
            for i = 1, Count do
                task.spawn(function() 
                    RE:FireServer("AttemptPop", tick() + math.random()) 
                end)
            end
            task.wait(math.clamp(0.14 - (Count * 0.009), 0.05, 0.14))
        end
        
        if getgenv().Config.ConnectFour then
            local Moves = {4, 3, 5, 2, 6, 1, 7}
            for _, move in ipairs(Moves) do
                RE:FireServer("PlaceDisc", move)
                task.wait(0.06)
            end
            task.wait(0.4)
        end
    end
end)
