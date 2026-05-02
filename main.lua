local TS = game:GetService("TweenService")
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LP = game:GetService("Players").LocalPlayer

local ScreenName = "CrystalHubFinalSharp"
local ExistingUI = game:GetService("CoreGui"):FindFirstChild(ScreenName) or LP.PlayerGui:FindFirstChild(ScreenName)
if ExistingUI then ExistingUI:Destroy() end

getgenv().Config = {AutoPop = false, ConnectFour = false, Accuracy = 7}

local Screen = Instance.new("ScreenGui", game:GetService("CoreGui"))
Screen.Name = ScreenName

-- // زر الفتح
local OpenBtn = Instance.new("TextButton", Screen)
OpenBtn.Name = "OpenBtn"
OpenBtn.Size = UDim2.new(0, 110, 0, 35)
OpenBtn.Position = UDim2.new(0, 50, 0.5, -17)
OpenBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
OpenBtn.Text, OpenBtn.TextColor3 = "Crystal Hub", Color3.fromRGB(255, 255, 255)
OpenBtn.Font, OpenBtn.TextSize = Enum.Font.GothamBold, 13
OpenBtn.TextStrokeTransparency = 1
OpenBtn.AutoButtonColor = false
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 18)
local BtnStroke = Instance.new("UIStroke", OpenBtn)
BtnStroke.Color, BtnStroke.Thickness = Color3.fromRGB(0, 120, 255), 1.5

-- // الإطار الرئيسي
local Main = Instance.new("Frame", Screen)
Main.Name = "Main"
Main.Size = UDim2.new(0, 380, 0, 190)
Main.Position = UDim2.new(0.5, -190, 0.5, -95)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Main.Visible, Main.Active = false, true
Main.ClipsDescendants = true -- لضمان بقاء العناصر داخل حدود القائمة المنحنية
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 18)
local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color, MainStroke.Thickness = Color3.fromRGB(0, 120, 255), 1.5

-- // الهيدر
local Header = Instance.new("Frame", Main)
Header.Size, Header.BackgroundColor3 = UDim2.new(1, 0, 0, 38), Color3.fromRGB(35, 35, 35)
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 18)
local HeaderFix = Instance.new("Frame", Header) -- لإلغاء الدوران من الأسفل
HeaderFix.Size, HeaderFix.Position, HeaderFix.BackgroundColor3, HeaderFix.BorderSizePixel = UDim2.new(1, 0, 0, 10), UDim2.new(0, 0, 1, -10), Color3.fromRGB(35, 35, 35), 0

local Title = Instance.new("TextLabel", Main)
Title.Size, Title.Text = UDim2.new(1, 0, 0, 38), "Crystal Hub - Mini Games"
Title.TextColor3, Title.Font, Title.TextSize = Color3.fromRGB(255, 255, 255), Enum.Font.GothamBold, 13
Title.TextStrokeTransparency = 1
Title.BackgroundTransparency = 1

-- // زر الإغلاق (X) بنفس حجم خط العنوان
local CloseBtn = Instance.new("TextButton", Main)
CloseBtn.Name = "CloseBtn"
CloseBtn.Size = UDim2.new(0, 35, 0, 38)
CloseBtn.Position = UDim2.new(1, -38, 0, 0)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 13 -- مطابق لحجم خط العنوان
CloseBtn.TextStrokeTransparency = 1
CloseBtn.BackgroundTransparency = 1
CloseBtn.AutoButtonColor = false
CloseBtn.ZIndex = 10

-- // أزرار التفعيل
local function CreateToggle(name, pos, icon, var)
    local F = Instance.new("Frame", Main)
    F.Size, F.Position, F.BackgroundColor3 = UDim2.new(0, 175, 0, 42), pos, Color3.fromRGB(35, 35, 35)
    Instance.new("UICorner", F).CornerRadius = UDim.new(0, 18)
    local I = Instance.new("TextLabel", F)
    I.Size, I.Position, I.BackgroundColor3 = UDim2.new(0, 28, 0, 28), UDim2.new(0, 8, 0.5, -14), Color3.fromRGB(0, 120, 255)
    I.Text, I.TextColor3, I.Font, I.TextSize = icon, Color3.fromRGB(255, 255, 255), Enum.Font.GothamBold, 12
    I.TextStrokeTransparency = 1
    Instance.new("UICorner", I).CornerRadius = UDim.new(1, 0)
    local L = Instance.new("TextLabel", F)
    L.Size, L.Position, L.Text = UDim2.new(0, 80, 1, 0), UDim2.new(0, 45, 0, 0), name
    L.TextColor3, L.Font, L.TextSize, L.BackgroundTransparency = Color3.fromRGB(255, 255, 255), Enum.Font.GothamBold, 12, 1
    L.TextStrokeTransparency = 1
    L.TextXAlignment = 0
    local B = Instance.new("TextButton", F)
    B.Size, B.Position, B.BackgroundColor3 = UDim2.new(0, 32, 0, 16), UDim2.new(1, -42, 0.5, -8), Color3.fromRGB(50, 50, 50)
    B.Text, B.AutoButtonColor = "", false
    Instance.new("UICorner", B).CornerRadius = UDim.new(1, 0)
    local Dot = Instance.new("Frame", B)
    Dot.Size, Dot.Position, Dot.BackgroundColor3 = UDim2.new(0, 12, 0, 12), UDim2.new(0, 2, 0.5, -6), Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)
    B.MouseButton1Click:Connect(function()
        getgenv().Config[var] = not getgenv().Config[var]
        TS:Create(B, TweenInfo.new(0.2), {BackgroundColor3 = getgenv().Config[var] and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(50, 50, 50)}):Play()
        TS:Create(Dot, TweenInfo.new(0.2), {Position = getgenv().Config[var] and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)}):Play()
    end)
end

CreateToggle("Auto Popcorn", UDim2.new(0, 10, 0, 55), "P", "AutoPop")
CreateToggle("Connect Four", UDim2.new(0, 195, 0, 55), "C", "ConnectFour")

-- // المنطقة الرمادية السفلية (مربعة من الأعلى)
local SF = Instance.new("Frame", Main)
SF.Name = "SliderFrame"
SF.Size, SF.Position, SF.BackgroundColor3 = UDim2.new(1, 0, 0, 72), UDim2.new(0, 0, 1, -72), Color3.fromRGB(35, 35, 35)
SF.BorderSizePixel = 0
-- ملاحظة: لا يوجد UICorner هنا لتكون مربعة من الأعلى، وستبدو منحنية من الأسفل بسبب ClipsDescendants في القائمة الرئيسية

local CombinedLabel = Instance.new("TextLabel", SF)
CombinedLabel.Text = "Accuracy - " .. tostring(getgenv().Config.Accuracy)
CombinedLabel.Size = UDim2.new(1, 0, 0, 20)
CombinedLabel.Position = UDim2.new(0, 0, 0, 12)
CombinedLabel.TextColor3, CombinedLabel.Font, CombinedLabel.TextSize = Color3.fromRGB(255, 255, 255), Enum.Font.GothamBold, 13
CombinedLabel.TextStrokeTransparency, CombinedLabel.BackgroundTransparency = 1, 1

local function CreateArr(t, p, step)
    local b = Instance.new("TextButton", SF)
    b.Size, b.Position, b.BackgroundColor3, b.Text = UDim2.new(0, 28, 0, 28), p, Color3.fromRGB(0, 120, 255), t
    b.TextColor3, b.Font, b.TextSize, b.AutoButtonColor = Color3.fromRGB(255, 255, 255), Enum.Font.GothamBold, 14, false
    b.TextStrokeTransparency = 1
    Instance.new("UICorner", b).CornerRadius = UDim.new(1, 0)
    b.MouseButton1Click:Connect(function()
        getgenv().Config.Accuracy = math.clamp(getgenv().Config.Accuracy + step, 0, 10)
        CombinedLabel.Text = "Accuracy - " .. tostring(getgenv().Config.Accuracy)
        TS:Create(Main:FindFirstChild("Fill", true), TweenInfo.new(0.2), {Size = UDim2.new(getgenv().Config.Accuracy/10, 0, 1, 0)}):Play()
    end)
end

-- شريط السلايدر مرفوع قليلاً
local SBtn = Instance.new("Frame", SF)
SBtn.Size, SBtn.Position, SBtn.BackgroundColor3 = UDim2.new(0, 240, 0, 6), UDim2.new(0.5, -120, 0, 48), Color3.fromRGB(60, 60, 60)
Instance.new("UICorner", SBtn).CornerRadius = UDim.new(1, 0)

local SFill = Instance.new("Frame", SBtn)
SFill.Name, SFill.Size, SFill.BackgroundColor3 = "Fill", UDim2.new(getgenv().Config.Accuracy/10, 0, 1, 0), Color3.fromRGB(0, 120, 255)
Instance.new("UICorner", SFill).CornerRadius = UDim.new(1, 0)

-- الأسهم بمسافة 9 بيكسل من السلايدر
CreateArr("<", UDim2.new(0, 33, 0, 37), -1)
CreateArr(">", UDim2.new(1, -61, 0, 37), 1)

-- // سحب وإغلاق وفتح
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
UIS.InputEnded:Connect(function(i) dragging = false end)

OpenBtn.MouseButton1Click:Connect(function()
    if dragDist < 5 then
        Main.Visible = true
        OpenBtn.Visible = false
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    Main.Visible = false
    OpenBtn.Visible = true
end)

-- // الحلقة البرمجية للألعاب
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
