-- // Crystal Hub - Ultra Smooth Edition
local TS = game:GetService("TweenService")
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LP = game:GetService("Players").LocalPlayer

getgenv().Config = {AutoPop = false, ConnectFour = false, Accuracy = 7}

local Screen = Instance.new("ScreenGui", game:GetService("CoreGui"))
Screen.Name = "CrystalHubSmooth"

-- // وظيفة عامة لإضافة الحواف (Stroke)
local function AddStroke(obj, color, thick)
    local s = Instance.new("UIStroke", obj)
    s.Color = color or Color3.fromRGB(0, 120, 255)
    s.Thickness = thick or 1.5
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    return s
end

-- // 1. الأيقونة البيضاوية (الفتح)
local OpenBtn = Instance.new("TextButton", Screen)
OpenBtn.Size = UDim2.new(0, 110, 0, 35)
OpenBtn.Position = UDim2.new(0, 50, 0.5, -17)
OpenBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
OpenBtn.Text = "Crystal Hub"
OpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.TextSize = 13
OpenBtn.AutoButtonColor = false -- إزالة اللون الرمادي
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 18)
AddStroke(OpenBtn)

-- // 2. القائمة الرئيسية
local Main = Instance.new("Frame", Screen)
Main.Size = UDim2.new(0, 380, 0, 195) -- مقاس ملموم ومضبوط
Main.Position = UDim2.new(0.5, -190, 0.5, -97)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Main.ClipsDescendants = true
Main.Visible = false
Main.Active = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)
AddStroke(Main) -- نفس حواف الأيقونة

-- خلفية منطقة العنوان (الرمادي العلوي)
local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 38)
Header.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Header.BorderSizePixel = 0
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 38)
Title.Text = "Crystal Hub - Mini Games"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.BackgroundTransparency = 1

local CloseBtn = Instance.new("TextButton", Main)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 4)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.AutoButtonColor = false
CloseBtn.TextSize = 16

-- // 3. وظيفة التبديل (Toggles)
local Toggles = {}
local function CreateToggle(name, pos, icon, var, key)
    local F = Instance.new("Frame", Main)
    F.Size = UDim2.new(0, 175, 0, 45)
    F.Position = pos
    F.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Instance.new("UICorner", F).CornerRadius = UDim.new(0, 5)
    
    local I = Instance.new("TextLabel", F)
    I.Size = UDim2.new(0, 28, 0, 28)
    I.Position = UDim2.new(0, 8, 0.5, -14)
    I.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    I.Text = icon
    I.TextColor3 = Color3.fromRGB(255, 255, 255)
    I.Font = Enum.Font.GothamBold
    I.TextSize = 14
    Instance.new("UICorner", I).CornerRadius = UDim.new(0, 4)
    AddStroke(I, Color3.fromRGB(255, 255, 255), 1) -- حواف بسيطة
    
    local L = Instance.new("TextLabel", F)
    L.Size = UDim2.new(0, 80, 1, 0)
    L.Position = UDim2.new(0, 42, 0, 0)
    L.Text = name
    L.TextColor3 = Color3.fromRGB(255, 255, 255)
    L.Font = Enum.Font.GothamMedium
    L.TextSize = 13
    L.TextXAlignment = Enum.TextXAlignment.Left
    L.BackgroundTransparency = 1
    
    local B = Instance.new("TextButton", F)
    B.Size = UDim2.new(0, 34, 0, 17)
    B.Position = UDim2.new(1, -42, 0.5, -8.5)
    B.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    B.Text = ""
    B.AutoButtonColor = false
    Instance.new("UICorner", B).CornerRadius = UDim.new(1, 0)
    
    local Dot = Instance.new("Frame", B)
    Dot.Size = UDim2.new(0, 13, 0, 13)
    Dot.Position = UDim2.new(0, 2, 0.5, -6.5)
    Dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)
    
    local function Toggle()
        getgenv().Config[var] = not getgenv().Config[var]
        local act = getgenv().Config[var]
        TS:Create(B, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {BackgroundColor3 = act and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(40, 40, 40)}):Play()
        TS:Create(Dot, TweenInfo.new(0.25, Enum.EasingStyle.Back), {Position = act and UDim2.new(1, -15, 0.5, -6.5) or UDim2.new(0, 2, 0.5, -6.5)}):Play()
    end
    B.MouseButton1Click:Connect(Toggle)
    Toggles[key] = Toggle
end

CreateToggle("Auto Popcorn", UDim2.new(0, 10, 0, 48), "P", "AutoPop", Enum.KeyCode.P)
CreateToggle("Connect Four", UDim2.new(0, 195, 0, 48), "C", "ConnectFour", Enum.KeyCode.C)

-- // 4. قسم Accuracy
local SF = Instance.new("Frame", Main)
SF.Size = UDim2.new(0, 360, 0, 75)
SF.Position = UDim2.new(0, 10, 0, 105)
SF.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UICorner", SF).CornerRadius = UDim.new(0, 5)

local SL = Instance.new("TextLabel", SF)
SL.Size, SL.Position, SL.BackgroundTransparency = UDim2.new(0, 100, 0, 25), UDim2.new(0, 12, 0, 10), 1
SL.Text, SL.TextColor3, SL.Font, SL.TextSize, SL.TextXAlignment = "Accuracy", Color3.fromRGB(255, 255, 255), Enum.Font.GothamMedium, 14, 0

local SV = Instance.new("TextLabel", SF)
SV.Size, SV.Position, SV.BackgroundTransparency = UDim2.new(0, 30, 0, 25), UDim2.new(1, -42, 0, 10), 1
SV.Text, SV.TextColor3, SV.Font, SV.TextSize = "7", Color3.fromRGB(0, 120, 255), Enum.Font.GothamBold, 15

local function CreateArr(t, p)
    local b = Instance.new("TextButton", SF)
    b.Size, b.Position, b.BackgroundColor3 = UDim2.new(0, 28, 0, 28), p, Color3.fromRGB(0, 120, 255)
    b.Text, b.TextColor3, b.Font, b.TextSize, b.AutoButtonColor = t, Color3.fromRGB(255, 255, 255), Enum.Font.GothamBold, 14, false
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    AddStroke(b, Color3.fromRGB(255,255,255), 1)
    return b
end

local L_Arr = CreateArr("<", UDim2.new(0, 12, 0, 40))
local R_Arr = CreateArr(">", UDim2.new(1, -40, 0, 40))

local SBtn = Instance.new("TextButton", SF)
SBtn.Size, SBtn.Position, SBtn.BackgroundColor3 = UDim2.new(0, 265, 0, 6), UDim2.new(0.5, -132, 0, 51), Color3.fromRGB(45, 45, 45)
SBtn.Text, SBtn.AutoButtonColor = "", false
Instance.new("UICorner", SBtn)

local SFill = Instance.new("Frame", SBtn)
SFill.Size, SFill.BackgroundColor3 = UDim2.new(0.7, 0, 1, 0), Color3.fromRGB(0, 120, 255)
Instance.new("UICorner", SFill)

local function UpdS()
    local r = math.clamp(getgenv().Config.Accuracy / 10, 0, 1)
    TS:Create(SFill, TweenInfo.new(0.2), {Size = UDim2.new(r, 0, 1, 0)}):Play()
    SV.Text = tostring(getgenv().Config.Accuracy)
end

L_Arr.MouseButton1Click:Connect(function() getgenv().Config.Accuracy = math.clamp(getgenv().Config.Accuracy - 1, 0, 10) UpdS() end)
R_Arr.MouseButton1Click:Connect(function() getgenv().Config.Accuracy = math.clamp(getgenv().Config.Accuracy + 1, 0, 10) UpdS() end)

-- // 5. السلاسة والتحكم
local function ToggleUI(state)
    if state then
        Main.Visible = true
        Main.Size = UDim2.new(0, 380, 0, 0)
        TS:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {Size = UDim2.new(0, 380, 0, 195)}):Play()
        OpenBtn.Visible = false
    else
        TS:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.new(0, 380, 0, 0)}):Play()
        task.wait(0.3)
        Main.Visible = false
        OpenBtn.Visible = true
    end
end

CloseBtn.MouseButton1Click:Connect(function() ToggleUI(false) end)
OpenBtn.MouseButton1Click:Connect(function() ToggleUI(true) end)

-- جعل الأيقونة تتحرك بسلاسة عند السحب
local dragging, dragInput, dragStart, startPos
OpenBtn.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true dragStart = i.Position startPos = OpenBtn.Position
        i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
UIS.InputChanged:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseMovement then dragInput = i end
end)
RS.RenderStepped:Connect(function()
    if dragging and dragInput then
        local delta = dragInput.Position - dragStart
        TS:Create(OpenBtn, TweenInfo.new(0.1), {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}):Play()
    end
end)

-- السلايدر بالماوس
local dragS = false
SBtn.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragS = true end end)
UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragS = false end end)
UIS.InputChanged:Connect(function(i)
    if dragS and i.UserInputType == Enum.UserInputType.MouseMovement then
        local r = math.clamp((i.Position.X - SBtn.AbsolutePosition.X) / SBtn.AbsoluteSize.X, 0, 1)
        getgenv().Config.Accuracy = math.floor(r * 10)
        UpdS()
    end
end)

-- كيبورد
UIS.InputBegan:Connect(function(k, g)
    if g then return end
    if Toggles[k.KeyCode] then Toggles[k.KeyCode]() end
    if k.KeyCode == Enum.KeyCode.Right then getgenv().Config.Accuracy = math.clamp(getgenv().Config.Accuracy + 1, 0, 10) UpdS() end
    if k.KeyCode == Enum.KeyCode.Left then getgenv().Config.Accuracy = math.clamp(getgenv().Config.Accuracy - 1, 0, 10) UpdS() end
end)

-- منطق اللعب (Popcorn & Connect4)
RS.Heartbeat:Connect(function()
    pcall(function()
        if getgenv().Config.AutoPop then
            local Gui = LP.PlayerGui:FindFirstChild("PopcornGame") or LP.PlayerGui:FindFirstChild("PopcornDuel")
            if Gui then
                local B, V = nil, 25
                for _, v in pairs(Gui:GetDescendants()) do
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
