local TS = game:GetService("TweenService")
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LP = game:GetService("Players").LocalPlayer

local ScreenName = "CrystalHubFinal"
local OldUI = game:GetService("CoreGui"):FindFirstChild(ScreenName) or LP.PlayerGui:FindFirstChild(ScreenName)
if OldUI then return end

getgenv().Config = {AutoPop = false, ConnectFour = false, Accuracy = 7}

local Screen = Instance.new("ScreenGui", game:GetService("CoreGui"))
Screen.Name = ScreenName

local Main = Instance.new("Frame", Screen)
Main.Size = UDim2.new(0, 380, 0, 190)
Main.Position = UDim2.new(0.5, -190, 0.5, -95)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Main.ClipsDescendants, Main.Visible, Main.Active = true, false, true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 18)

local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color, MainStroke.Thickness = Color3.fromRGB(0, 120, 255), 1.5
MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local function AddDesign(obj)
    Instance.new("UICorner", obj).CornerRadius = UDim.new(0, 18)
    local s = Instance.new("UIStroke", obj)
    s.Color, s.Thickness = Color3.fromRGB(0, 120, 255), 1.5
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
end

local OpenBtn = Instance.new("TextButton", Screen)
OpenBtn.Size = UDim2.new(0, 110, 0, 35)
OpenBtn.Position = UDim2.new(0, 50, 0.5, -17)
OpenBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
OpenBtn.Text, OpenBtn.TextColor3 = "Crystal Hub", Color3.fromRGB(255, 255, 255)
OpenBtn.Font, OpenBtn.TextSize = Enum.Font.GothamBold, 13
AddDesign(OpenBtn)

local Header = Instance.new("Frame", Main)
Header.Size, Header.BackgroundColor3 = UDim2.new(1, 0, 0, 38), Color3.fromRGB(35, 35, 35)
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 18)

local HeaderFix = Instance.new("Frame", Header)
HeaderFix.Size, HeaderFix.Position = UDim2.new(1, 0, 0, 10), UDim2.new(0, 0, 1, -10)
HeaderFix.BackgroundColor3, HeaderFix.BorderSizePixel = Color3.fromRGB(35, 35, 35), 0

local Title = Instance.new("TextLabel", Main)
Title.Size, Title.Text = UDim2.new(1, 0, 0, 38), "Crystal Hub - Mini Games"
Title.TextColor3, Title.Font, Title.TextSize = Color3.fromRGB(255, 255, 255), Enum.Font.GothamBold, 13
Title.BackgroundTransparency, Title.ZIndex = 1, 5

local CloseBtn = Instance.new("TextButton", Main)
CloseBtn.Size, CloseBtn.Position = UDim2.new(0, 30, 0, 30), UDim2.new(1, -35, 0, 4)
CloseBtn.Text, CloseBtn.TextColor3 = "X", Color3.fromRGB(255, 80, 80)
CloseBtn.Font, CloseBtn.TextSize, CloseBtn.BackgroundTransparency = Enum.Font.GothamBold, 13, 1
CloseBtn.ZIndex = 6

local function CreateToggle(name, pos, icon, var)
    local F = Instance.new("Frame", Main)
    F.Size, F.Position, F.BackgroundColor3 = UDim2.new(0, 175, 0, 42), pos, Color3.fromRGB(35, 35, 35)
    Instance.new("UICorner", F).CornerRadius = UDim.new(0, 18)
    local I = Instance.new("TextLabel", F)
    I.Size, I.Position, I.BackgroundColor3 = UDim2.new(0, 28, 0, 28), UDim2.new(0, 8, 0.5, -14), Color3.fromRGB(0, 120, 255)
    I.Text, I.TextColor3, I.Font, I.TextSize = icon, Color3.fromRGB(255, 255, 255), Enum.Font.GothamBold, 12
    Instance.new("UICorner", I).CornerRadius = UDim.new(0, 18)
    local L = Instance.new("TextLabel", F)
    L.Size, L.Position, L.Text = UDim2.new(0, 80, 1, 0), UDim2.new(0, 45, 0, 0), name
    L.TextColor3, L.Font, L.TextSize = Color3.fromRGB(255, 255, 255), Enum.Font.GothamBold, 12
    L.TextXAlignment, L.BackgroundTransparency = 0, 1
    local B = Instance.new("TextButton", F)
    B.Size, B.Position, B.BackgroundColor3 = UDim2.new(0, 32, 0, 16), UDim2.new(1, -42, 0.5, -8), Color3.fromRGB(50, 50, 50)
    B.Text, B.AutoButtonColor = "", false
    Instance.new("UICorner", B).CornerRadius = UDim.new(1, 0)
    local Dot = Instance.new("Frame", B)
    Dot.Size, Dot.Position, Dot.BackgroundColor3 = UDim2.new(0, 12, 0, 12), UDim2.new(0, 2, 0.5, -6), Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)
    B.MouseButton1Click:Connect(function()
        getgenv().Config[var] = not getgenv().Config[var]
        local act = getgenv().Config[var]
        TS:Create(B, TweenInfo.new(0.2), {BackgroundColor3 = act and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(50, 50, 50)}):Play()
        TS:Create(Dot, TweenInfo.new(0.2), {Position = act and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)}):Play()
    end)
end

CreateToggle("Auto Popcorn", UDim2.new(0, 10, 0, 58), "P", "AutoPop")
CreateToggle("Connect Four", UDim2.new(0, 195, 0, 58), "C", "ConnectFour")

local SF = Instance.new("Frame", Main)
SF.Size, SF.Position, SF.BackgroundColor3 = UDim2.new(1, 0, 0, 72), UDim2.new(0, 0, 1, -72), Color3.fromRGB(35, 35, 35)
Instance.new("UICorner", SF).CornerRadius = UDim.new(0, 18)

local SFFix = Instance.new("Frame", SF)
SFFix.Size, SFFix.Position, SFFix.BackgroundColor3, SFFix.BorderSizePixel = UDim2.new(1, 0, 0, 10), UDim2.new(0, 0, 0, 0), Color3.fromRGB(35, 35, 35), 0

-- إعادة إضافة كلمة Accuracy
local AccLabel = Instance.new("TextLabel", SF)
AccLabel.Text, AccLabel.Size, AccLabel.Position = "Accuracy", UDim2.new(0, 100, 0, 25), UDim2.new(0, 20, 0, 8)
AccLabel.TextColor3, AccLabel.Font, AccLabel.TextSize = Color3.fromRGB(255, 255, 255), Enum.Font.GothamBold, 12
AccLabel.TextXAlignment, AccLabel.BackgroundTransparency, AccLabel.ZIndex = 0, 1, 10

local SV = Instance.new("TextLabel", SF)
SV.Text, SV.Size, SV.Position = "7", UDim2.new(0, 30, 0, 25), UDim2.new(1, -50, 0, 8)
SV.TextColor3, SV.Font, SV.TextSize, SV.BackgroundTransparency, SV.ZIndex = Color3.fromRGB(0, 120, 255), Enum.Font.GothamBold, 12, 1, 10

local function CreateArr(t, p, step)
    local b = Instance.new("TextButton", SF)
    b.Size, b.Position, b.BackgroundColor3, b.Text = UDim2.new(0, 28, 0, 28), p, Color3.fromRGB(0, 120, 255), t
    b.TextColor3, b.Font, b.TextSize, b.ZIndex = Color3.fromRGB(255, 255, 255), Enum.Font.GothamBold, 12, 10
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 18)
    b.MouseButton1Click:Connect(function()
        getgenv().Config.Accuracy = math.clamp(getgenv().Config.Accuracy + step, 0, 10)
        SV.Text = tostring(getgenv().Config.Accuracy)
        TS:Create(Main:FindFirstChild("Fill", true), TweenInfo.new(0.2), {Size = UDim2.new(getgenv().Config.Accuracy/10, 0, 1, 0)}):Play()
    end)
end

CreateArr("<", UDim2.new(0, 20, 0, 36), -1)
CreateArr(">", UDim2.new(1, -48, 0, 36), 1)

local SBtn = Instance.new("Frame", SF)
SBtn.Size, SBtn.Position, SBtn.BackgroundColor3, SBtn.ZIndex = UDim2.new(0, 260, 0, 6), UDim2.new(0.5, -130, 0, 47), Color3.fromRGB(60, 60, 60), 11
Instance.new("UICorner", SBtn).CornerRadius = UDim.new(1, 0)

local SFill = Instance.new("Frame", SBtn)
SFill.Name, SFill.Size, SFill.BackgroundColor3, SFill.ZIndex = "Fill", UDim2.new(0.7, 0, 1, 0), Color3.fromRGB(0, 120, 255), 12
Instance.new("UICorner", SFill).CornerRadius = UDim.new(1, 0)

local dragging, dragStart, startPos, dragDist = false, nil, nil, 0
OpenBtn.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        dragging, dragStart, startPos, dragDist = true, i.Position, OpenBtn.Position, 0
    end
end)
UIS.InputChanged:Connect(function(i)
    if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        local delta = i.Position - dragStart
        dragDist = delta.Magnitude
        OpenBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false end end)

local function ToggleUI(s)
    if s then
        Main.Visible, MainStroke.Transparency = true, 0
        Main.Size = UDim2.new(0, 380, 0, 0)
        TS:Create(Main, TweenInfo.new(0.3), {Size = UDim2.new(0, 380, 0, 190)}):Play()
        OpenBtn.Visible = false
    else
        MainStroke.Transparency = 1
        TS:Create(Main, TweenInfo.new(0.2), {Size = UDim2.new(0, 380, 0, 0)}):Play()
        task.wait(0.2)
        Main.Visible, OpenBtn.Visible = false, true
    end
end

OpenBtn.MouseButton1Click:Connect(function() if dragDist < 5 then ToggleUI(true) end end)
CloseBtn.MouseButton1Click:Connect(function() ToggleUI(false) end)

RS.Heartbeat:Connect(function()
    pcall(function()
        if getgenv().Config.AutoPop then
            local G = LP.PlayerGui:FindFirstChild("PopcornGame") or LP.PlayerGui:FindFirstChild("PopcornDuel")
            if G then
                local B, V = nil, 25
                for _, v in pairs(G:GetDescendants()) do
                    if v:IsA("TextLabel") and v.Visible and v.Text:find("+") then
                        local n = tonumber(v.Text:match("%d+"))
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
