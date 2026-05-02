local GameID = game.PlaceId
if GameID ~= 111917342868480 then return end

local TS = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local CG = game:GetService("CoreGui")
local LP = game:GetService("Players").LocalPlayer

local UI_ID = "Crystal_Elite_2026"
local Existing = CG:FindFirstChild(UI_ID) or LP.PlayerGui:FindFirstChild(UI_ID)
if Existing then Existing:Destroy() end

getgenv().Config = {AutoPop = false, ConnectFour = false, Accuracy = 7}

local Screen = Instance.new("ScreenGui", CG)
Screen.Name = UI_ID
Screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local OpenBtn = Instance.new("TextButton", Screen)
OpenBtn.Size = UDim2.new(0, 110, 0, 35)
OpenBtn.Position = UDim2.new(0.5, -58, 0.16, 0)
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
Main.Position = UDim2.new(0.5, -190, 0.5, -95)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Main.Visible = false
Main.GroupTransparency = 1 
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 18)

local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = Color3.fromRGB(0, 120, 255)
MainStroke.Thickness = 1.5
MainStroke.Transparency = 1

local function ToggleUI(state)
    local info = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    if state then
        Main.Visible = true
        TS:Create(Main, info, {GroupTransparency = 0, Size = UDim2.new(0, 380, 0, 190)}):Play()
        TS:Create(MainStroke, info, {Transparency = 0}):Play()
        TS:Create(OpenBtn, info, {BackgroundTransparency = 1, TextTransparency = 1}):Play()
        TS:Create(BtnStroke, info, {Transparency = 1}):Play()
        task.delay(0.3, function() OpenBtn.Visible = false end)
    else
        TS:Create(MainStroke, info, {Transparency = 1}):Play()
        local hide = TS:Create(Main, info, {GroupTransparency = 1, Size = UDim2.new(0, 360, 0, 170)})
        hide:Play()
        OpenBtn.Visible = true
        TS:Create(OpenBtn, info, {BackgroundTransparency = 0, TextTransparency = 0}):Play()
        TS:Create(BtnStroke, info, {Transparency = 0}):Play()
        hide.Completed:Connect(function() Main.Visible = false end)
    end
end

local dragToggle, dragStart, startPos
local dragDistance = 0

OpenBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragToggle, dragStart, startPos = true, input.Position, OpenBtn.Position
        dragDistance = 0
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragToggle and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        dragDistance = delta.Magnitude
        TS:Create(OpenBtn, TweenInfo.new(0.08, Enum.EasingStyle.Linear), {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}):Play()
    end
end)

OpenBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragToggle = false
        if dragDistance < 5 then
            ToggleUI(true)
        end
    end
end)

local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 38)
Header.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Header.BorderSizePixel = 0
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 18)

local HeaderSquare = Instance.new("Frame", Header)
HeaderSquare.Size = UDim2.new(1, 0, 0, 15)
HeaderSquare.Position = UDim2.new(0, 0, 1, -15)
HeaderSquare.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
HeaderSquare.BorderSizePixel = 0

local Title = Instance.new("TextLabel", Main)
Title.Size, Title.Text = UDim2.new(1, 0, 0, 38), "Crystal Hub - Mini Games"
Title.TextColor3, Title.Font, Title.TextSize = Color3.fromRGB(255, 255, 255), Enum.Font.GothamBold, 12
Title.BackgroundTransparency = 1

local CloseBtn = Instance.new("TextButton", Main)
CloseBtn.Size, CloseBtn.Position, CloseBtn.Text = UDim2.new(0, 35, 0, 38), UDim2.new(1, -38, 0, 0), "X"
CloseBtn.TextColor3, CloseBtn.Font, CloseBtn.TextSize = Color3.fromRGB(255, 255, 255), Enum.Font.GothamBold, 12
CloseBtn.BackgroundTransparency = 1
CloseBtn.MouseButton1Click:Connect(function() ToggleUI(false) end)

local function CreateToggle(name, pos, var)
    local F = Instance.new("Frame", Main)
    F.Size, F.Position, F.BackgroundColor3 = UDim2.new(0, 175, 0, 42), pos, Color3.fromRGB(35, 35, 35)
    Instance.new("UICorner", F).CornerRadius = UDim.new(0, 18)
    
    local B = Instance.new("TextButton", F)
    B.Size, B.Position, B.BackgroundColor3 = UDim2.new(0, 32, 0, 16), UDim2.new(1, -40, 0.5, -8), Color3.fromRGB(50, 50, 50)
    B.Text, B.AutoButtonColor = "", false
    Instance.new("UICorner", B).CornerRadius = UDim.new(1, 0)
    
    local Dot = Instance.new("Frame", B)
    Dot.Size, Dot.Position, Dot.BackgroundColor3 = UDim2.new(0, 12, 0, 12), UDim2.new(0, 2, 0.5, -6), Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)
    
    B.MouseButton1Click:Connect(function()
        getgenv().Config[var] = not getgenv().Config[var]
        TS:Create(B, TweenInfo.new(0.2), {BackgroundColor3 = getgenv().Config[var] and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(50, 50, 50)}):Play()
        TS:Create(Dot, TweenInfo.new(0.2, Enum.EasingStyle.Back), {Position = getgenv().Config[var] and UDim2.new(0, 18, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)}):Play()
    end)
    
    local L = Instance.new("TextLabel", F)
    L.Size, L.Position, L.Text = UDim2.new(0, 100, 1, 0), UDim2.new(0, 15, 0, 0), name
    L.TextColor3, L.Font, L.TextSize = Color3.fromRGB(255, 255, 255), Enum.Font.GothamBold, 11
    L.BackgroundTransparency, L.TextXAlignment = 1, Enum.TextXAlignment.Left
end

CreateToggle("Auto Popcorn", UDim2.new(0, 10, 0, 55), "AutoPop")
CreateToggle("Connect Four", UDim2.new(0, 195, 0, 55), "ConnectFour")

local SF = Instance.new("Frame", Main)
SF.Size, SF.Position, SF.BackgroundColor3 = UDim2.new(1, 0, 0, 75), UDim2.new(0, 0, 1, -75), Color3.fromRGB(35, 35, 35)
Instance.new("UICorner", SF).CornerRadius = UDim.new(0, 18)

local CombinedLabel = Instance.new("TextLabel", SF)
CombinedLabel.Text, CombinedLabel.Size, CombinedLabel.Position = "Accuracy - " .. tostring(getgenv().Config.Accuracy), UDim2.new(1, 0, 0, 20), UDim2.new(0, 0, 0, 12)
CombinedLabel.TextColor3, CombinedLabel.Font, CombinedLabel.TextSize, CombinedLabel.BackgroundTransparency = Color3.fromRGB(255, 255, 255), Enum.Font.GothamBold, 12, 1

local function CreateArr(t, p, step)
    local b = Instance.new("TextButton", SF)
    b.Size, b.Position, b.BackgroundColor3, b.Text = UDim2.new(0, 28, 0, 28), p, Color3.fromRGB(0, 120, 255), t
    b.TextColor3, b.Font, b.TextSize = Color3.fromRGB(255, 255, 255), Enum.Font.GothamBold, 14
    Instance.new("UICorner", b).CornerRadius = UDim.new(1, 0)
    b.MouseButton1Click:Connect(function()
        getgenv().Config.Accuracy = math.clamp(getgenv().Config.Accuracy + step, 0, 10)
        CombinedLabel.Text = "Accuracy - " .. tostring(getgenv().Config.Accuracy)
        TS:Create(Main:FindFirstChild("Fill", true), TweenInfo.new(0.3), {Size = UDim2.new(getgenv().Config.Accuracy/10, 0, 1, 0)}):Play()
    end)
end

local SBtn = Instance.new("Frame", SF)
SBtn.Size, SBtn.Position, SBtn.BackgroundColor3 = UDim2.new(0, 240, 0, 6), UDim2.new(0.5, -120, 0, 48), Color3.fromRGB(60, 60, 60)
Instance.new("UICorner", SBtn).CornerRadius = UDim.new(1, 0)
local SFill = Instance.new("Frame", SBtn)
SFill.Name, SFill.Size, SFill.BackgroundColor3 = "Fill", UDim2.new(getgenv().Config.Accuracy/10, 0, 1, 0), Color3.fromRGB(0, 120, 255)
Instance.new("UICorner", SFill).CornerRadius = UDim.new(1, 0)

CreateArr("<", UDim2.new(0, 33, 0, 37), -1)
CreateArr(">", UDim2.new(1, -61, 0, 37), 1)
