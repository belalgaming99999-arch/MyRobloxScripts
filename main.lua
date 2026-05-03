local Services = setmetatable({}, {
    __index = function(t, k)
        return game:GetService(k)
    end
})

local TS, UIS, CG, LP, RS = Services.TweenService, Services.UserInputService, Services.CoreGui, Services.Players.LocalPlayer, Services.ReplicatedStorage

local UI_ID = "Crystal_Elite_2026"
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
OpenBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
OpenBtn.Text = "Crystal Hub"
OpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.TextSize = 12
OpenBtn.AutoButtonColor = false
OpenBtn.ZIndex = 10
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 18)

local BtnStroke = Instance.new("UIStroke", OpenBtn)
BtnStroke.Color = Color3.fromRGB(0, 120, 255)
BtnStroke.Thickness = 1.5
BtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local Main = Instance.new("CanvasGroup", Screen)
Main.Size = UDim2.new(0, 380, 0, 190)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Main.Visible = false
Main.GroupTransparency = 1 
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 18)

local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = Color3.fromRGB(0, 120, 255)
MainStroke.Thickness = 1.5
MainStroke.Transparency = 1

local function ToggleUI(state)
    local info = TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    if state then
        Main.Position = UDim2.new(OpenBtn.Position.X.Scale, OpenBtn.Position.X.Offset - 135, OpenBtn.Position.Y.Scale, OpenBtn.Position.Y.Offset + 48)
        OpenBtn.Visible = false 
        Main.Visible = true
        TS:Create(Main, info, {GroupTransparency = 0, Size = UDim2.new(0, 380, 0, 190)}):Play()
        TS:Create(MainStroke, info, {Transparency = 0}):Play()
    else
        TS:Create(MainStroke, info, {Transparency = 1}):Play()
        local hide = TS:Create(Main, info, {GroupTransparency = 1, Size = UDim2.new(0, 360, 0, 170)})
        hide:Play()
        hide.Completed:Connect(function() 
            Main.Visible = false 
            OpenBtn.Visible = true
            TS:Create(OpenBtn, info, {BackgroundTransparency = 0, TextTransparency = 0}):Play()
            TS:Create(BtnStroke, info, {Transparency = 0}):Play()
        end)
    end
end

local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 38)
Header.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Header.BorderSizePixel = 0
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 18)

local HeaderSquare = Instance.new("Frame", Header)
HeaderSquare.Size = UDim2.new(1, 0, 0, 10)
HeaderSquare.Position = UDim2.new(0, 0, 1, -10)
HeaderSquare.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
HeaderSquare.BorderSizePixel = 0

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 38)
Title.Text = "Crystal Hub - Mini Games"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 12
Title.BackgroundTransparency = 1
Title.ZIndex = 3

local CloseBtn = Instance.new("TextButton", Main)
CloseBtn.Size = UDim2.new(0, 35, 0, 38)
CloseBtn.Position = UDim2.new(1, -38, 0, 0)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 12
CloseBtn.BackgroundTransparency = 1
CloseBtn.ZIndex = 3

local function CreateToggle(name, pos, icon, var)
    local F = Instance.new("Frame", Main)
    F.Size, F.Position, F.BackgroundColor3 = UDim2.new(0, 175, 0, 42), pos, Color3.fromRGB(35, 35, 35)
    Instance.new("UICorner", F).CornerRadius = UDim.new(0, 18)
    
    local I = Instance.new("TextLabel", F)
    I.Size = UDim2.new(0, 28, 0, 28)
    I.Position = UDim2.new(0, 8, 0.5, -14)
    I.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    I.Text = icon
    I.TextColor3 = Color3.fromRGB(255, 255, 255)
    I.Font = Enum.Font.GothamBold
    I.TextSize = 12
    Instance.new("UICorner", I).CornerRadius = UDim.new(1, 0)
    
    local L = Instance.new("TextLabel", F)
    L.Size, L.Position, L.Text = UDim2.new(0, 85, 1, 0), UDim2.new(0, 44, 0, 0), name
    L.TextColor3, L.Font, L.TextSize = Color3.fromRGB(255, 255, 255), Enum.Font.GothamBold, 11
    L.BackgroundTransparency, L.TextXAlignment = 1, Enum.TextXAlignment.Left

    local B = Instance.new("TextButton", F)
    B.Size, B.Position, B.BackgroundColor3, B.Text = UDim2.new(0, 32, 0, 16), UDim2.new(1, -40, 0.5, -8), Color3.fromRGB(50, 50, 50), ""
    B.AutoButtonColor = false
    Instance.new("UICorner", B).CornerRadius = UDim.new(1, 0)
    
    local Dot = Instance.new("Frame", B)
    Dot.Size, Dot.Position, Dot.BackgroundColor3 = UDim2.new(0, 12, 0, 12), UDim2.new(0, 2, 0.5, -6), Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)

    B.MouseButton1Click:Connect(function()
        getgenv().Config[var] = not getgenv().Config[var]
        TS:Create(B, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {BackgroundColor3 = getgenv().Config[var] and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(50, 50, 50)}):Play()
        TS:Create(Dot, TweenInfo.new(0.25, Enum.EasingStyle.Back), {Position = getgenv().Config[var] and UDim2.new(0, 18, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)}):Play()
    end)
end

CreateToggle("Auto Popcorn", UDim2.new(0, 10, 0, 55), "P", "AutoPop")
CreateToggle("Connect Four", UDim2.new(0, 195, 0, 55), "C", "ConnectFour")

local SF = Instance.new("Frame", Main)
SF.Size, SF.Position, SF.BackgroundColor3 = UDim2.new(1, 0, 0, 75), UDim2.new(0, 0, 1, -75), Color3.fromRGB(35, 35, 35)
SF.BorderSizePixel = 0
Instance.new("UICorner", SF).CornerRadius = UDim.new(0, 18)

local SFSquare = Instance.new("Frame", SF)
SFSquare.Size = UDim2.new(1, 0, 0, 10)
SFSquare.Position = UDim2.new(0, 0, 0, 0)
SFSquare.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
SFSquare.BorderSizePixel = 0

local CombinedLabel = Instance.new("TextLabel", SF)
CombinedLabel.Text = "Accuracy - 7"
CombinedLabel.Size, CombinedLabel.Position = UDim2.new(1, 0, 0, 20), UDim2.new(0, 0, 0, 12)
CombinedLabel.TextColor3, CombinedLabel.Font, CombinedLabel.TextSize = Color3.fromRGB(255, 255, 255), Enum.Font.GothamBold, 12
CombinedLabel.BackgroundTransparency = 1
CombinedLabel.ZIndex = 3

local SBtn = Instance.new("Frame", SF)
SBtn.Size, SBtn.Position, SBtn.BackgroundColor3 = UDim2.new(0, 240, 0, 6), UDim2.new(0.5, -120, 0, 48), Color3.fromRGB(60, 60, 60)
Instance.new("UICorner", SBtn).CornerRadius = UDim.new(1, 0)

local SFill = Instance.new("Frame", SBtn)
SFill.Name, SFill.Size, SFill.BackgroundColor3 = "Fill", UDim2.new(0.7, 0, 1, 0), Color3.fromRGB(0, 120, 255)
Instance.new("UICorner", SFill).CornerRadius = UDim.new(1, 0)

local function CreateArr(t, p, step)
    local b = Instance.new("TextButton", SF)
    b.Size, b.Position, b.BackgroundColor3, b.Text = UDim2.new(0, 28, 0, 28), p, Color3.fromRGB(0, 120, 255), t
    b.TextColor3, b.Font, b.TextSize = Color3.fromRGB(255, 255, 255), Enum.Font.GothamBold, 14
    Instance.new("UICorner", b).CornerRadius = UDim.new(1, 0)
    b.MouseButton1Click:Connect(function()
        getgenv().Config.Accuracy = math.clamp(getgenv().Config.Accuracy + step, 1, 10)
        CombinedLabel.Text = "Accuracy - " .. tostring(getgenv().Config.Accuracy)
        TS:Create(SFill, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {Size = UDim2.new(getgenv().Config.Accuracy/10, 0, 1, 0)}):Play()
    end)
end

CreateArr("<", UDim2.new(0, 33, 0, 37), -1)
CreateArr(">", UDim2.new(1, -61, 0, 37), 1)

local dragToggle, dragStart, startPos
OpenBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragToggle, dragStart, startPos = true, input.Position, OpenBtn.Position
    end
end)
UIS.InputChanged:Connect(function(input)
    if dragToggle and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        OpenBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UIS.InputEnded:Connect(function() dragToggle = false end)

OpenBtn.MouseButton1Click:Connect(function() ToggleUI(true) end)
CloseBtn.MouseButton1Click:Connect(function() ToggleUI(false) end)

task.spawn(function()
    local Net = RS:WaitForChild("Shared"):WaitForChild("Remotes"):WaitForChild("Networking")
    local Action = Net:WaitForChild("RE/Minigame/MinigameGameAction")
    while task.wait() do
        if getgenv().Config.AutoPop then
            local burst = getgenv().Config.Accuracy
            for i = 1, burst do
                task.spawn(function() Action:FireServer("AttemptPop", tick() + math.random()) end)
            end
            task.wait(math.clamp(0.14 - (burst * 0.01), 0.06, 0.14))
        end
        if getgenv().Config.ConnectFour then
            local Moves = {4, 3, 5, 2, 6, 1, 7}
            for _, col in ipairs(Moves) do
                Action:FireServer("PlaceDisc", col)
                task.wait(0.06)
            end
            task.wait(0.5)
        end
    end
end)
