local TS = game:GetService("TweenService")
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LP = game:GetService("Players").LocalPlayer

getgenv().Config = {AutoPop = false, ConnectFour = false, Accuracy = 7}

local Screen = Instance.new("ScreenGui", game:GetService("CoreGui"))
Screen.Name = "CrystalHubV3"

-- // القائمة الرئيسية
local Main = Instance.new("Frame", Screen)
Main.Size, Main.Position = UDim2.new(0, 450, 0, 240), UDim2.new(0.5, -225, 0.5, -120)
Main.BackgroundColor3, Main.BorderSizePixel = Color3.fromRGB(15, 15, 15), 0
Main.Active, Main.Draggable, Main.Visible = true, true, false
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", Main).Color = Color3.fromRGB(45, 45, 45)

-- // زر الفتح (بيضاوي)
local OpenBtn = Instance.new("TextButton", Screen)
OpenBtn.Size, OpenBtn.Position = UDim2.new(0, 120, 0, 40), UDim2.new(0, 50, 0.5, -20)
OpenBtn.BackgroundColor3, OpenBtn.Text = Color3.fromRGB(20, 20, 20), "Crystal Hub"
OpenBtn.TextColor3, OpenBtn.Font, OpenBtn.TextSize = Color3.fromRGB(0, 120, 255), 20, 14
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 20)
Instance.new("UIStroke", OpenBtn).Color = Color3.fromRGB(0, 120, 255)

local CloseBtn = Instance.new("TextButton", Main)
CloseBtn.Size, CloseBtn.Position, CloseBtn.BackgroundTransparency = UDim2.new(0, 30, 0, 30), UDim2.new(1, -35, 0, 7), 1
CloseBtn.Text, CloseBtn.TextColor3, CloseBtn.Font, CloseBtn.TextSize = "X", Color3.fromRGB(255, 50, 50), 20, 18

CloseBtn.MouseButton1Click:Connect(function() Main.Visible = false OpenBtn.Visible = true end)
OpenBtn.MouseButton1Click:Connect(function() OpenBtn.Visible = false Main.Visible = true end)
OpenBtn.Active, OpenBtn.Draggable = true, true

local Title = Instance.new("TextLabel", Main)
Title.Size, Title.Text = UDim2.new(1, 0, 0, 45), "Crystal Hub - Mini Games"
Title.TextColor3, Title.Font, Title.TextSize, Title.BackgroundTransparency = Color3.fromRGB(255, 255, 255), 20, 16, 1

-- // وظيفة إنشاء الأزرار (Toggles)
local Toggles = {}
local function CreateToggle(name, pos, icon, var, key)
    local F = Instance.new("Frame", Main)
    F.Size, F.Position, F.BackgroundColor3 = UDim2.new(0, 200, 0, 50), pos, Color3.fromRGB(25, 25, 25)
    Instance.new("UICorner", F).CornerRadius = UDim.new(0, 6)
    
    local I = Instance.new("TextLabel", F)
    I.Size, I.Position, I.BackgroundColor3, I.Text, I.TextColor3, I.Font = UDim2.new(0, 30, 0, 30), UDim2.new(0, 10, 0.5, -15), Color3.fromRGB(0, 120, 255), icon, Color3.fromRGB(255, 255, 255), 20
    Instance.new("UICorner", I).CornerRadius = UDim.new(0, 4)
    
    local L = Instance.new("TextLabel", F)
    L.Size, L.Position, L.Text, L.TextColor3, L.Font, L.TextSize, L.TextXAlignment, L.BackgroundTransparency = UDim2.new(0, 100, 1, 0), UDim2.new(0, 50, 0, 0), name, Color3.fromRGB(230, 230, 230), 20, 16, 0, 1
    
    local B = Instance.new("TextButton", F)
    B.Size, B.Position, B.BackgroundColor3, B.Text, B.AutoButtonColor = UDim2.new(0, 40, 0, 20), UDim2.new(1, -50, 0.5, -10), Color3.fromRGB(40, 40, 40), "", false
    Instance.new("UICorner", B).CornerRadius = UDim.new(1, 0)
    
    local Dot = Instance.new("Frame", B)
    Dot.Size, Dot.Position, Dot.BackgroundColor3 = UDim2.new(0, 16, 0, 16), UDim2.new(0, 2, 0.5, -8), Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)
    
    local function Act()
        getgenv().Config[var] = not getgenv().Config[var]
        local active = getgenv().Config[var]
        TS:Create(B, TweenInfo.new(0.3), {BackgroundColor3 = active and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(40, 40, 40)}):Play()
        TS:Create(Dot, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Position = active and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}):Play()
    end
    B.MouseButton1Click:Connect(Act)
    Toggles[key] = Act
end

CreateToggle("Auto Popcorn", UDim2.new(0, 20, 0, 60), "P", "AutoPop", Enum.KeyCode.P)
CreateToggle("Connect Four", UDim2.new(0, 230, 0, 60), "C", "ConnectFour", Enum.KeyCode.C)

-- // حاوية السلايدر
local SF = Instance.new("Frame", Main)
SF.Size, SF.Position, SF.BackgroundColor3 = UDim2.new(0, 410, 0, 70), UDim2.new(0, 20, 0, 120), Color3.fromRGB(25, 25, 25)
Instance.new("UICorner", SF).CornerRadius = UDim.new(0, 6)

local SL = Instance.new("TextLabel", SF)
SL.Text, SL.Position, SL.Size, SL.TextColor3, SL.Font, SL.TextSize, SL.BackgroundTransparency = "Accuracy Control", UDim2.new(0, 15, 0, 10), UDim2.new(0, 120, 0, 20), Color3.fromRGB(180, 180, 180), 20, 15, 1

local SV = Instance.new("TextLabel", SF)
SV.Text, SV.Position, SV.Size, SV.TextColor3, SV.Font, SV.TextSize, SV.BackgroundTransparency = "7", UDim2.new(1, -40, 0, 10), UDim2.new(0, 30, 0, 20), Color3.fromRGB(0, 120, 255), 20, 16, 1

-- زر السهم اليسار (مربع أزرق)
local LeftBtn = Instance.new("TextButton", SF)
LeftBtn.Size, LeftBtn.Position, LeftBtn.BackgroundColor3, LeftBtn.Text, LeftBtn.TextColor3, LeftBtn.Font = UDim2.new(0, 30, 0, 30), UDim2.new(0, 15, 0.7, -15), Color3.fromRGB(0, 120, 255), "<", Color3.fromRGB(255, 255, 255), 20
Instance.new("UICorner", LeftBtn).CornerRadius = UDim.new(0, 4)

-- زر السهم اليمين (مربع أزرق)
local RightBtn = Instance.new("TextButton", SF)
RightBtn.Size, RightBtn.Position, RightBtn.BackgroundColor3, RightBtn.Text, RightBtn.TextColor3, RightBtn.Font = UDim2.new(0, 30, 0, 30), UDim2.new(1, -45, 0.7, -15), Color3.fromRGB(0, 120, 255), ">", Color3.fromRGB(255, 255, 255), 20
Instance.new("UICorner", RightBtn).CornerRadius = UDim.new(0, 4)

-- السلايدر (في المنتصف بين السهمين)
local SBtn = Instance.new("TextButton", SF)
SBtn.Size, SBtn.Position, SBtn.BackgroundColor3, SBtn.Text, SBtn.AutoButtonColor = UDim2.new(0, 300, 0, 6), UDim2.new(0.5, -150, 0.7, -3), Color3.fromRGB(50, 50, 50), "", false
Instance.new("UICorner", SBtn)

local SFill = Instance.new("Frame", SBtn)
SFill.Size, SFill.BackgroundColor3 = UDim2.new(0.7, 0, 1, 0), Color3.fromRGB(0, 120, 255)
Instance.new("UICorner", SFill)

local function UpdateSliderVis()
    local rel = math.clamp(getgenv().Config.Accuracy / 10, 0, 1)
    TS:Create(SFill, TweenInfo.new(0.2), {Size = UDim2.new(rel, 0, 1, 0)}):Play()
    SV.Text = tostring(getgenv().Config.Accuracy)
end

-- وظائف الضغط على الأسهم
LeftBtn.MouseButton1Click:Connect(function() getgenv().Config.Accuracy = math.clamp(getgenv().Config.Accuracy - 1, 0, 10) UpdateSliderVis() end)
RightBtn.MouseButton1Click:Connect(function() getgenv().Config.Accuracy = math.clamp(getgenv().Config.Accuracy + 1, 0, 10) UpdateSliderVis() end)

-- تحكم الماوس بالسحب
local dragging = false
SBtn.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end end)
UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
UIS.InputChanged:Connect(function(i)
    if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
        local rel = math.clamp((i.Position.X - SBtn.AbsolutePosition.X) / SBtn.AbsoluteSize.X, 0, 1)
        getgenv().Config.Accuracy = math.floor(rel * 10)
        UpdateSliderVis()
    end
end)

-- تحكم الكيبورد
UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if Toggles[input.KeyCode] then Toggles[input.KeyCode]() end
    if input.KeyCode == Enum.KeyCode.Right then getgenv().Config.Accuracy = math.clamp(getgenv().Config.Accuracy + 1, 0, 10) UpdateSliderVis() end
    if input.KeyCode == Enum.KeyCode.Left then getgenv().Config.Accuracy = math.clamp(getgenv().Config.Accuracy - 1, 0, 10) UpdateSliderVis() end
end)

-- // منطق الذكاء الاصطناعي للألعاب
RS.Heartbeat:Connect(function()
    pcall(function()
        if getgenv().Config.AutoPop then
            local PopUI = LP.PlayerGui:FindFirstChild("PopcornGame") or LP.PlayerGui:FindFirstChild("PopcornDuel")
            if PopUI then
                local Best, Val = nil, 25
                for _, v in pairs(PopUI:GetDescendants()) do
                    if v:IsA("TextLabel") and v.Visible and string.find(v.Text, "+") then
                        local n = tonumber(string.match(v.Text, "%d+"))
                        if n and n > Val then Val, Best = n, v end
                    end
                end
                if Best and math.random(1, 10) <= getgenv().Config.Accuracy then
                    local b = Best.Parent:FindFirstChildOfClass("TextButton") or Best.Parent:FindFirstChildOfClass("ImageButton")
                    if b then firesignal(b.MouseButton1Click) end
                end
            end
        end
        if getgenv().Config.ConnectFour then
            local CF4 = LP.PlayerGui:FindFirstChild("ConnectFour") or LP.PlayerGui:FindFirstChild("FourInARow")
            if CF4 then
                for _, slot in pairs(CF4:GetDescendants()) do
                    if slot:IsA("TextButton") and slot.Visible and slot.Name == "Slot" then firesignal(slot.MouseButton1Click) end
                end
            end
        end
    end)
end)
