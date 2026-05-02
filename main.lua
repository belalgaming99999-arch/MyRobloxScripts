local TS = game:GetService("TweenService")
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LP = game:GetService("Players").LocalPlayer

getgenv().Config = {AutoPop = false, ConnectFour = false, Accuracy = 7}

local Screen = Instance.new("ScreenGui")
Screen.Name = "CrystalHubFinal"
pcall(function() Screen.Parent = game:GetService("CoreGui") end)
if not Screen.Parent then Screen.Parent = LP.PlayerGui end

local Main = Instance.new("Frame", Screen)
Main.Size = UDim2.new(0, 380, 0, 190)
Main.Position = UDim2.new(0.5, -190, 0.5, -95)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Main.ClipsDescendants, Main.Visible, Main.Active = true, false, true
local MainCorner = Instance.new("UICorner", Main)
MainCorner.CornerRadius = UDim.new(0, 18)

local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = Color3.fromRGB(0, 120, 255)
MainStroke.Thickness = 1.5
MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local function AddStroke(obj)
    local s = Instance.new("UIStroke", obj)
    s.Color = Color3.fromRGB(0, 120, 255)
    s.Thickness = 1.5
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
end

local function MakeOval(obj, radius)
    local c = Instance.new("UICorner", obj)
    c.CornerRadius = radius or UDim.new(0, 18)
end

local OpenBtn = Instance.new("TextButton", Screen)
OpenBtn.Size = UDim2.new(0, 110, 0, 35)
OpenBtn.Position = UDim2.new(0, 50, 0.5, -17)
OpenBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
OpenBtn.Text = "Crystal Hub"
OpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenBtn.Font, OpenBtn.TextSize = Enum.Font.GothamBold, 13
OpenBtn.AutoButtonColor, OpenBtn.Active = false, true
MakeOval(OpenBtn)
AddStroke(OpenBtn)

local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 38)
Header.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Header.BorderSizePixel = 0
local HeaderCorner = Instance.new("UICorner", Header)
HeaderCorner.CornerRadius = UDim.new(0, 18)

local HeaderFix = Instance.new("Frame", Header)
HeaderFix.Size = UDim2.new(1, 0, 0, 10)
HeaderFix.Position = UDim2.new(0, 0, 1, -10)
HeaderFix.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
HeaderFix.BorderSizePixel = 0

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 38)
Title.Text = "Crystal Hub - Mini Games"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font, Title.TextSize, Title.BackgroundTransparency = Enum.Font.GothamBold, 13, 1
Title.ZIndex = 3

local CloseBtn = Instance.new("TextButton", Main)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 4)
CloseBtn.BackgroundTransparency, CloseBtn.Text = 1, "X"
CloseBtn.TextColor3, CloseBtn.Font, CloseBtn.TextSize = Color3.fromRGB(255, 80, 80), Enum.Font.GothamBold, 13
CloseBtn.ZIndex = 4

local function CreateToggle(name, pos, icon, var)
    local F = Instance.new("Frame", Main)
    F.Size, F.Position, F.BackgroundColor3 = UDim2.new(0, 175, 0, 42), pos, Color3.fromRGB(35, 35, 35)
    MakeOval(F, UDim.new(0, 18))
    local I = Instance.new("TextLabel", F)
    I.Size, I.Position, I.BackgroundColor3 = UDim2.new(0, 28, 0, 28), UDim2.new(0, 8, 0.5, -14), Color3.fromRGB(0, 120, 255)
    I.Text, I.TextColor3, I.Font, I.TextSize = icon, Color3.fromRGB(255, 255, 255), Enum.Font.GothamBold, 12
    MakeOval(I, UDim.new(0, 18))
    local L = Instance.new("TextLabel", F)
    L.Size, L.Position, L.Text = UDim2.new(0, 80, 1, 0), UDim2.new(0, 45, 0, 0), name
    L.TextColor3, L.Font, L.TextSize, L.TextXAlignment, L.BackgroundTransparency = Color3.fromRGB(255, 255, 255), Enum.Font.GothamBold, 12, 0, 1
    local B = Instance.new("TextButton", F)
    B.Size, B.Position, B.BackgroundColor3 = UDim2.new(0, 32, 0, 16), UDim2.new(1, -42, 0.5, -8), Color3.fromRGB(50, 50, 50)
    B.Text, B.AutoButtonColor, B.Active = "", false, true
    MakeOval(B, UDim.new(1, 0))
    local Dot = Instance.new("Frame", B)
    Dot.Size, Dot.Position, Dot.BackgroundColor3 = UDim2.new(0, 12, 0, 12), UDim2.new(0, 2, 0.5, -6), Color3.fromRGB(255, 255, 255)
    MakeOval(Dot, UDim.new(1, 0))
    B.MouseButton1Click:Connect(function()
        getgenv().Config[var] = not getgenv().Config[var]
        local act = getgenv().Config[var]
        TS:Create(B, TweenInfo.new(0.2), {BackgroundColor3 = act and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(50, 50, 50)}):Play()
        TS:Create(Dot, TweenInfo.new(0.2), {Position = act and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)}):Play()
    end)
end

CreateToggle("Auto Popcorn", UDim2.new(0, 10, 0, 48), "P", "AutoPop")
CreateToggle("Connect Four", UDim2.new(0, 195, 0, 48), "C", "ConnectFour")

local SF = Instance.new("Frame", Main)
SF.Size, SF.Position, SF.BackgroundColor3 = UDim2.new(1, 0, 0, 80), UDim2.new(0, 0, 1, -80), Color3.fromRGB(35, 35, 35)
SF.BorderSizePixel = 0
local SFCorner = Instance.new("UICorner", SF)
SFCorner.CornerRadius = UDim.new(0, 18)

local SFFix = Instance.new("Frame", SF)
SFFix.Size = UDim2.new(1, 0, 0, 8)
SFFix.Position = UDim2.new(0, 0, 0, 0)
SFFix.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
SFFix.BorderSizePixel = 0

local SL = Instance.new("TextLabel", SF)
SL.Text, SL.Size, SL.Position, SL.BackgroundTransparency = "Accuracy", UDim2.new(0, 100, 0, 25), UDim2.new(0, 20, 0, 10), 1
SL.TextColor3, SL.Font, SL.TextSize, SL.TextXAlignment = Color3.fromRGB(255, 255, 255), Enum.Font.GothamBold, 12, 0
SL.ZIndex = 3

local SV = Instance.new("TextLabel", SF)
SV.Text, SV.Size, SV.Position, SV.BackgroundTransparency = "7", UDim2.new(0, 30, 0, 25), UDim2.new(1, -50, 0, 10), 1
SV.TextColor3, SV.Font, SV.TextSize = Color3.fromRGB(0, 120, 255), Enum.Font.GothamBold, 12
SV.ZIndex = 3

local function CreateArr(t, p)
    local b = Instance.new("TextButton", SF)
    b.Size, b.Position, b.BackgroundColor3, b.Text = UDim2.new(0, 28, 0, 28), p, Color3.fromRGB(0, 120, 255), t
    b.TextColor3, b.Font, b.TextSize, b.AutoButtonColor, b.Active = Color3.fromRGB(255, 255, 255), Enum.Font.GothamBold, 12, false, true
    MakeOval(b, UDim.new(0, 18))
    b.ZIndex = 3
    return b
end

local L_Arr, R_Arr = CreateArr("<", UDim2.new(0, 20, 0, 42)), CreateArr(">", UDim2.new(1, -48, 0, 42))
local SBtn = Instance.new("TextButton", SF)
SBtn.Size, SBtn.Position, SBtn.BackgroundColor3 = UDim2.new(0, 260, 0, 6), UDim2.new(0.5, -130, 0, 53), Color3.fromRGB(60, 60, 60)
SBtn.Text, SBtn.AutoButtonColor, SBtn.Active = "", false, true
SBtn.ZIndex = 3
MakeOval(SBtn, UDim.new(1, 0))
local SFill = Instance.new("Frame", SBtn)
SFill.Size, SFill.BackgroundColor3 = UDim2.new(0.7, 0, 1, 0), Color3.fromRGB(0, 120, 255)
MakeOval(SFill, UDim.new(1, 0))

local function UpdS()
    local r = math.clamp(getgenv().Config.Accuracy / 10, 0, 1)
    TS:Create(SFill, TweenInfo.new(0.2), {Size = UDim2.new(r, 0, 1, 0)}):Play()
    SV.Text = tostring(getgenv().Config.Accuracy)
end

L_Arr.MouseButton1Click:Connect(function() getgenv().Config.Accuracy = math.clamp(getgenv().Config.Accuracy - 1, 0, 10) UpdS() end)
R_Arr.MouseButton1Click:Connect(function() getgenv().Config.Accuracy = math.clamp(getgenv().Config.Accuracy + 1, 0, 10) UpdS() end)

local dragging, dragStart, startPos, dragDistance = false, nil, nil, 0
OpenBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging, dragStart, startPos, dragDistance = true, input.Position, OpenBtn.Position, 0
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        dragDistance = delta.Magnitude
        OpenBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local function ToggleUI(s)
    if s then
        Main.Visible = true
        MainStroke.Transparency = 0
        Main.Size = UDim2.new(0, 380, 0, 0)
        TS:Create(Main, TweenInfo.new(0.3), {Size = UDim2.new(0, 380, 0, 190)}):Play()
        OpenBtn.Visible = false
    else
        MainStroke.Transparency = 1
        TS:Create(Main, TweenInfo.new(0.2), {Size = UDim2.new(0, 380, 0, 0)}):Play()
        task.wait(0.2) 
        Main.Visible = false
        OpenBtn.Visible = true
    end
end

OpenBtn.MouseButton1Click:Connect(function() if dragDistance < 5 then ToggleUI(true) end end)
CloseBtn.MouseButton1Click:Connect(function() ToggleUI(false) end)

RS.Heartbeat:Connect(function()
    pcall(function()
        if getgenv().Config.AutoPop then
            local G = LP.PlayerGui:FindFirstChild("PopcornGame") or LP.PlayerGui:FindFirstChild("PopcornDuel")
            if G then
                local B, V = nil, 25
                for _, v in pairs(G:GetDescendants()) do
                    if v:IsA("TextLabel") and v.Visible and string.find(v.Text, "+") then
                        local n = tonumber(string.match(v.Text, "%d+"))
                        if n and n > V then V, B = n, v end
                    end
                end
                if B and math.random(1, 10) <= getgenv().Config.Accuracy then
                    local btn = B.Parent:FindFirstChildOfClass("TextButton") or B.Parent:FindFirstChildOfClass("ImageButton")
                    if btn then firesignal(btn.MouseButton1Click) end
                end
            end
        end
        if getgenv().Config.ConnectFour then
            local C4 = LP.PlayerGui:FindFirstChild("ConnectFour") or LP.PlayerGui:FindFirstChild("FourInARow")
            if C4 then
                for _, s in pairs(C4:GetDescendants()) do
                    if s:IsA("TextButton") and s.Visible and s.Name == "Slot" then firesignal(s.MouseButton1Click) end
                end
            end
        end
    end)
end)
