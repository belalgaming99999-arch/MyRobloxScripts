-- // Crystal Hub - Mini Games (Clean & Compact Version)
local TS = game:GetService("TweenService")
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LP = game:GetService("Players").LocalPlayer

getgenv().Config = {AutoPop = false, ConnectFour = false, Accuracy = 7}

local Screen = Instance.new("ScreenGui", game:GetService("CoreGui"))
Screen.Name = "CrystalHubFinal"

-- // 1. الزر البيضاوي للفتح (Crystal Hub)
local OpenBtn = Instance.new("TextButton", Screen)
OpenBtn.Size = UDim2.new(0, 110, 0, 35)
OpenBtn.Position = UDim2.new(0, 40, 0.5, -17)
OpenBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
OpenBtn.Text = "Crystal Hub"
OpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255) -- أبيض صافي
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.TextSize = 13
OpenBtn.Visible = true -- يبدأ مقفول (يظهر الزر فقط)
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 18)
local OpenStroke = Instance.new("UIStroke", OpenBtn)
OpenStroke.Color = Color3.fromRGB(0, 120, 255)
OpenStroke.Thickness = 1.5
OpenStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- // 2. القائمة الرئيسية (مصغرة ومضبوطة)
local Main = Instance.new("Frame", Screen)
Main.Size = UDim2.new(0, 380, 0, 210) -- حجم أصغر وملموم
Main.Position = UDim2.new(0.5, -190, 0.5, -105)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Main.Active = true
Main.Draggable = true
Main.Visible = false -- تبدأ مخفية
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)
local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = Color3.fromRGB(40, 40, 40)
MainStroke.Thickness = 1

-- العنوان
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "Crystal Hub - Mini Games"
Title.TextColor3 = Color3.fromRGB(255, 255, 255) -- أبيض
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.BackgroundTransparency = 1

-- زر الإغلاق (X)
local CloseBtn = Instance.new("TextButton", Main)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16

-- // 3. وظيفة إنشاء الصفوف (Toggles)
local Toggles = {}
local function CreateToggle(name, pos, icon, var, key)
    local F = Instance.new("Frame", Main)
    F.Size = UDim2.new(0, 175, 0, 45)
    F.Position = pos
    F.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Instance.new("UICorner", F).CornerRadius = UDim.new(0, 5)
    
    -- أيقونة الحرف (P/C)
    local I = Instance.new("TextLabel", F)
    I.Size = UDim2.new(0, 28, 0, 28)
    I.Position = UDim2.new(0, 8, 0.5, -14)
    I.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    I.Text = icon
    I.TextColor3 = Color3.fromRGB(255, 255, 255)
    I.Font = Enum.Font.GothamBold
    I.TextSize = 14
    Instance.new("UICorner", I).CornerRadius = UDim.new(0, 4)
    
    -- اسم التفعيلة
    local L = Instance.new("TextLabel", F)
    L.Size = UDim2.new(0, 80, 1, 0)
    L.Position = UDim2.new(0, 42, 0, 0) -- المسافة بين الأيقونة والاسم 6px
    L.Text = name
    L.TextColor3 = Color3.fromRGB(255, 255, 255) -- أبيض
    L.Font = Enum.Font.GothamMedium
    L.TextSize = 13
    L.TextXAlignment = Enum.TextXAlignment.Left
    L.BackgroundTransparency = 1
    
    -- زر التبديل
    local B = Instance.new("TextButton", F)
    B.Size = UDim2.new(0, 34, 0, 17)
    B.Position = UDim2.new(1, -42, 0.5, -8.5) -- مسافة موزونة
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
        local active = getgenv().Config[var]
        TS:Create(B, TweenInfo.new(0.25), {BackgroundColor3 = active and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(40, 40, 40)}):Play()
        TS:Create(Dot, TweenInfo.new(0.25), {Position = active and UDim2.new(1, -15, 0.5, -6.5) or UDim2.new(0, 2, 0.5, -6.5)}):Play()
    end
    B.MouseButton1Click:Connect(Toggle)
    Toggles[key] = Toggle
end

CreateToggle("Auto Pop", UDim2.new(0, 10, 0, 50), "P", "AutoPop", Enum.KeyCode.P)
CreateToggle("Connect 4", UDim2.new(0, 195, 0, 50), "C", "ConnectFour", Enum.KeyCode.C)

-- // 4. حاوية السلايدر (Accuracy)
local SF = Instance.new("Frame", Main)
SF.Size = UDim2.new(0, 360, 0, 75)
SF.Position = UDim2.new(0, 10, 0, 105)
SF.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UICorner", SF).CornerRadius = UDim.new(0, 5)

local SL = Instance.new("TextLabel", SF)
SL.Size = UDim2.new(0, 100, 0, 25)
SL.Position = UDim2.new(0, 10, 0, 10)
SL.Text = "Accuracy"
SL.TextColor3 = Color3.fromRGB(255, 255, 255) -- أبيض
SL.Font = Enum.Font.GothamMedium
SL.TextSize = 14
SL.TextXAlignment = Enum.TextXAlignment.Left
SL.BackgroundTransparency = 1

local SV = Instance.new("TextLabel", SF)
SV.Size = UDim2.new(0, 30, 0, 25)
SV.Position = UDim2.new(1, -40, 0, 10)
SV.Text = "7"
SV.TextColor3 = Color3.fromRGB(0, 120, 255) -- الرقم أزرق للتمييز
SV.Font = Enum.Font.GothamBold
SV.TextSize = 15
SV.BackgroundTransparency = 1

-- أزرار الأسهم
local function CreateArrow(txt, pos)
    local B = Instance.new("TextButton", SF)
    B.Size = UDim2.new(0, 28, 0, 28)
    B.Position = pos
    B.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    B.Text = txt
    B.TextColor3 = Color3.fromRGB(255, 255, 255)
    B.Font = Enum.Font.GothamBold
    B.TextSize = 14
    Instance.new("UICorner", B).CornerRadius = UDim.new(0, 4)
    return B
end

local LeftArrow = CreateArrow("<", UDim2.new(0, 10, 0, 40))
local RightArrow = CreateArrow(">", UDim2.new(1, -38, 0, 40))

-- شريط السلايدر
local SBtn = Instance.new("TextButton", SF)
SBtn.Size = UDim2.new(0, 270, 0, 6)
SBtn.Position = UDim2.new(0.5, -135, 0, 51)
SBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
SBtn.Text = ""
SBtn.AutoButtonColor = false
Instance.new("UICorner", SBtn)

local SFill = Instance.new("Frame", SBtn)
SFill.Size = UDim2.new(0.7, 0, 1, 0)
SFill.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
Instance.new("UICorner", SFill)

local function UpdSlider()
    local rel = math.clamp(getgenv().Config.Accuracy / 10, 0, 1)
    TS:Create(SFill, TweenInfo.new(0.2), {Size = UDim2.new(rel, 0, 1, 0)}):Play()
    SV.Text = tostring(getgenv().Config.Accuracy)
end

LeftArrow.MouseButton1Click:Connect(function() getgenv().Config.Accuracy = math.clamp(getgenv().Config.Accuracy - 1, 0, 10) UpdSlider() end)
RightArrow.MouseButton1Click:Connect(function() getgenv().Config.Accuracy = math.clamp(getgenv().Config.Accuracy + 1, 0, 10) UpdSlider() end)

-- سحب السلايدر بالماوس
local dragS = false
SBtn.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragS = true end end)
UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragS = false end end)
UIS.InputChanged:Connect(function(i)
    if dragS and i.UserInputType == Enum.UserInputType.MouseMovement then
        local r = math.clamp((i.Position.X - SBtn.AbsolutePosition.X) / SBtn.AbsoluteSize.X, 0, 1)
        getgenv().Config.Accuracy = math.floor(r * 10)
        UpdSlider()
    end
end)

-- // 5. التفاعلات (فتح/إغلاق/كيبورد)
CloseBtn.MouseButton1Click:Connect(function() Main.Visible = false OpenBtn.Visible = true end)
OpenBtn.MouseButton1Click:Connect(function() OpenBtn.Visible = false Main.Visible = true end)
OpenBtn.Draggable = true

UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if Toggles[input.KeyCode] then Toggles[input.KeyCode]() end
    if input.KeyCode == Enum.KeyCode.Right then getgenv().Config.Accuracy = math.clamp(getgenv().Config.Accuracy + 1, 0, 10) UpdSlider() end
    if input.KeyCode == Enum.KeyCode.Left then getgenv().Config.Accuracy = math.clamp(getgenv().Config.Accuracy - 1, 0, 10) UpdSlider() end
end)

-- // 6. محرك الألعاب (المنطق)
RS.Heartbeat:Connect(function()
    pcall(function()
        if getgenv().Config.AutoPop then
            local UI = LP.PlayerGui:FindFirstChild("PopcornGame") or LP.PlayerGui:FindFirstChild("PopcornDuel")
            if UI then
                local B, V = nil, 25
                for _, v in pairs(UI:GetDescendants()) do
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
