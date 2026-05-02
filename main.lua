local TS = game:GetService("TweenService")
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LP = game:GetService("Players").LocalPlayer

getgenv().Config = {AutoPop = false, ConnectFour = false, Accuracy = 7}

local Screen = Instance.new("ScreenGui")
Screen.Name = "CrystalHubUniversal"
pcall(function() Screen.Parent = game:GetService("CoreGui") end)
if not Screen.Parent then Screen.Parent = LP.PlayerGui end

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

local Main = Instance.new("Frame", Screen)
Main.Size = UDim2.new(0, 380, 0, 190)
Main.Position = UDim2.new(0.5, -190, 0.5, -95)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Main.ClipsDescendants, Main.Visible, Main.Active = true, false, true
MakeOval(Main, UDim.new(0, 18))
AddStroke(Main)

local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 38)
Header.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Header.BorderSizePixel = 0
MakeOval(Header, UDim.new(0, 18))

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 38)
Title.Text = "Crystal Hub - Mini Games"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font, Title.TextSize, Title.BackgroundTransparency = Enum.Font.GothamBold, 13, 1

local CloseBtn = Instance.new("TextButton", Main)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -40, 0, 4)
CloseBtn.BackgroundTransparency, CloseBtn.Text = 1, "X"
CloseBtn.TextColor3, CloseBtn.Font, CloseBtn.TextSize = Color3.fromRGB(255, 80, 80), Enum.Font.GothamBold, 13

local Toggles = {}
local function CreateToggle(name, pos, icon, var)
    local F = Instance.new("Frame", Main)
    F.Size, F.Position, F.BackgroundColor3 = UDim2.new(0, 175, 0, 45), pos, Color3.fromRGB(35, 35, 35)
    MakeOval(F, UDim.new(0, 18))
    local I = Instance.new("TextLabel", F)
    I.Size, I.Position, I.BackgroundColor3 = UDim2.new(0, 30, 0, 30), UDim2.new(0, 8, 0.5, -15), Color3.fromRGB(0, 120, 255)
    I.Text, I.TextColor3, I.Font, I.TextSize = icon, Color3.fromRGB(255, 255, 255), Enum.Font.GothamBold, 13
    MakeOval(I, UDim.new(0, 18))
    local L = Instance.new("TextLabel", F)
    L.Size, L.Position, L.Text = UDim2.new(0, 80, 1, 0), UDim2.new(0, 45, 0, 0), name
    L.TextColor3, L.Font, L.TextSize, L.TextXAlignment, L.BackgroundTransparency = Color3.fromRGB(255, 255, 255), Enum.Font.GothamBold, 13, 0, 1
    local B = Instance.new("TextButton", F)
    B.Size, B.Position, B.BackgroundColor3 = UDim2.new(0, 34, 0, 17), UDim2.new(1, -45, 0.5, -8.5), Color3.fromRGB(50, 50, 50)
    B.Text, B.AutoButtonColor, B.Active = "", false, true
    MakeOval(B, UDim.new(1, 0))
    local Dot = Instance.new("Frame", B)
    Dot.Size, Dot.Position, Dot.BackgroundColor3 = UDim2.new(0, 13, 0, 13), UDim2.new(0, 2, 0.5, -6.5), Color3.fromRGB(255, 255, 255)
    MakeOval(Dot, UDim.new(1, 0))
    B.MouseButton1Click:Connect(function()
        getgenv().Config[var] = not getgenv().Config[var]
        local act = getgenv().Config[var]
        TS:Create(B, TweenInfo.new(0.25), {BackgroundColor3 = act and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(50, 50, 50)}):Play()
        TS:Create(Dot, TweenInfo.new(0.25, Enum.EasingStyle.Back), {Position = act and UDim2.new(1, -15, 0.5, -6.5) or UDim2.new(0, 2, 0.5, -6.5)}):Play()
    end)
end

CreateToggle("Auto Popcorn", UDim2.new(0, 10, 0, 48), "P", "AutoPop")
CreateToggle("Connect Four", UDim2.new(0, 195, 0, 48), "C", "ConnectFour")

local SF = Instance.new("Frame", Main)
SF.Size, SF.Position, SF.BackgroundColor3 = UDim2.new(0, 360, 0, 75), UDim2.new(0, 10, 0, 105), Color3.fromRGB(35, 35, 35)
MakeOval(SF, UDim.new(0, 18))
local SL = Instance.new("TextLabel", SF)
SL.Text, SL.Size, SL.Position, SL.BackgroundTransparency = "Accuracy", UDim2.new(0, 100, 0, 25), UDim2.new(0, 15, 0, 10), 1
SL.TextColor3, SL.Font, SL.TextSize, SL.TextXAlignment = Color3.fromRGB(255, 255, 255), Enum.Font.GothamBold, 13, 0
local SV = Instance.new("TextLabel", SF)
SV.Text, SV.Size, SV.Position, SV.BackgroundTransparency = "7", UDim2.new(0, 30, 0, 25), UDim2.new(1, -45, 0, 10), 1
SV.TextColor3, SV.Font, SV.TextSize = Color3.fromRGB(0, 120, 255), Enum.Font.GothamBold, 13

local function CreateArr(t, p)
    local b = Instance.new("TextButton", SF)
    b.Size, b.Position, b.BackgroundColor3, b.Text = UDim2.new(0, 30, 0, 30), p, Color3.fromRGB(0, 120, 255), t
    b.TextColor3, b.Font, b.TextSize, b.AutoButtonColor, b.Active = Color3.fromRGB(255, 255, 255), Enum.Font.GothamBold, 13, false, true
    MakeOval(b, UDim.new(0, 18))
    return b
end

local L_Arr, R_Arr = CreateArr("<", UDim2.new(0, 15, 0, 40)), CreateArr(">", UDim2.new(1, -45, 0, 40))
local SBtn = Instance.new("TextButton", SF)
SBtn.Size, SBtn.Position, SBtn.BackgroundColor3 = UDim2.new(0, 255, 0, 6), UDim2.new(0.5, -127, 0, 52), Color3.fromRGB(60, 60, 60)
SBtn.Text, SBtn.AutoButtonColor, SBtn.Active = "", false, true
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

local function MakeDraggable(obj)
    local dragStart, startPos, dragging
    obj.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging, dragStart, startPos = true, i.Position, obj.Position
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local delta = i.Position - dragStart
            TS:Create(obj, TweenInfo.new(0.12), {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}):Play()
        end
    end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
end
MakeDraggable(OpenBtn)

local function ToggleUI(s)
    if s then
        Main.Visible, Main.Size = true, UDim2.new(0, 380, 0, 0)
        TS:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, 380, 0, 190)}):Play()
        OpenBtn.Visible = false
    else
        TS:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = UDim2.new(0, 380, 0, 0)}):Play()
        task.wait(0.3) Main.Visible, OpenBtn.Visible = false, true
    end
end

CloseBtn.MouseButton1Click:Connect(function() ToggleUI(false) end)
OpenBtn.MouseButton1Click:Connect(function() ToggleUI(true) end)

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
