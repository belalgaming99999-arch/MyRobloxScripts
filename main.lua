local TS = game:GetService("TweenService")
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LP = game:GetService("Players").LocalPlayer

getgenv().Config = {AutoPop = false, ConnectFour = false, Accuracy = 7}

local Screen = Instance.new("ScreenGui", game:GetService("CoreGui"))
local Main = Instance.new("Frame", Screen)
Main.Size, Main.Position = UDim2.new(0, 450, 0, 240), UDim2.new(0.5, -225, 0.5, -120)
Main.BackgroundColor3, Main.BorderSizePixel = Color3.fromRGB(15, 15, 15), 0
Main.Active, Main.Draggable = true, true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", Main).Color = Color3.fromRGB(45, 45, 45)

local Title = Instance.new("TextLabel", Main)
Title.Size, Title.Text = UDim2.new(1, 0, 0, 45), "CRYSTAL HUB - SMART CONTROL"
Title.TextColor3, Title.Font, Title.TextSize, Title.BackgroundTransparency = Color3.fromRGB(255, 255, 255), 20, 14, 1

local function CreateToggle(name, pos, icon, var)
    local F = Instance.new("Frame", Main)
    F.Size, F.Position, F.BackgroundColor3 = UDim2.new(0, 200, 0, 45), pos, Color3.fromRGB(25, 25, 25)
    Instance.new("UICorner", F).CornerRadius = UDim.new(0, 6)
    local I = Instance.new("TextLabel", F)
    I.Size, I.Position, I.BackgroundColor3, I.Text, I.TextColor3, I.Font = UDim2.new(0, 25, 0, 25), UDim2.new(0, 10, 0.5, -12.5), Color3.fromRGB(0, 120, 255), icon, Color3.fromRGB(255, 255, 255), 20
    Instance.new("UICorner", I).CornerRadius = UDim.new(0, 4)
    local L = Instance.new("TextLabel", F)
    L.Size, L.Position, L.Text, L.TextColor3, L.Font, L.TextXAlignment, L.BackgroundTransparency = UDim2.new(0, 100, 1, 0), UDim2.new(0, 45, 0, 0), name, Color3.fromRGB(200, 200, 200), 20, 0, 1
    local B = Instance.new("TextButton", F)
    B.Size, B.Position, B.BackgroundColor3, B.Text = UDim2.new(0, 36, 0, 18), UDim2.new(1, -46, 0.5, -9), Color3.fromRGB(50, 50, 50), ""
    Instance.new("UICorner", B).CornerRadius = UDim.new(1, 0)
    local Dot = Instance.new("Frame", B)
    Dot.Size, Dot.Position, Dot.BackgroundColor3 = UDim2.new(0, 14, 0, 14), UDim2.new(0, 2, 0.5, -7), Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)
    B.MouseButton1Click:Connect(function()
        getgenv().Config[var] = not getgenv().Config[var]
        local active = getgenv().Config[var]
        TS:Create(B, TweenInfo.new(0.2), {BackgroundColor3 = active and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(50, 50, 50)}):Play()
        TS:Create(Dot, TweenInfo.new(0.2), {Position = active and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)}):Play()
    end)
end

CreateToggle("Auto Popcorn", UDim2.new(0, 20, 0, 60), "P", "AutoPop")
CreateToggle("Connect Four", UDim2.new(0, 230, 0, 60), "C", "ConnectFour")

local SF = Instance.new("Frame", Main)
SF.Size, SF.Position, SF.BackgroundColor3 = UDim2.new(0, 200, 0, 60), UDim2.new(0, 230, 0, 115), Color3.fromRGB(25, 25, 25)
Instance.new("UICorner", SF).CornerRadius = UDim.new(0, 6)
local SL, SV = Instance.new("TextLabel", SF), Instance.new("TextLabel", SF)
SL.Text, SL.Position, SL.Size, SL.TextColor3, SL.BackgroundTransparency = "Accuracy", UDim2.new(0, 10, 0, 10), UDim2.new(0, 100, 0, 20), Color3.fromRGB(180, 180, 180), 1
SV.Text, SV.Position, SV.Size, SV.TextColor3, SV.BackgroundTransparency = "7", UDim2.new(1, -30, 0, 10), UDim2.new(0, 20, 0, 20), Color3.fromRGB(0, 120, 255), 1
local SBar = Instance.new("TextButton", SF)
SBar.Size, SBar.Position, SBar.BackgroundColor3, SBar.Text = UDim2.new(0, 180, 0, 4), UDim2.new(0.5, -90, 0.7, 0), Color3.fromRGB(50, 50, 50), ""
local SFill = Instance.new("Frame", SBar)
SFill.Size, SFill.BackgroundColor3, SFill.BorderSizePixel = UDim2.new(0.7, 0, 1, 0), Color3.fromRGB(0, 120, 255), 0
local SDot = Instance.new("Frame", SFill)
SDot.Size, SDot.Position, SDot.BackgroundColor3 = UDim2.new(0, 12, 0, 12), UDim2.new(1, -6, 0.5, -6), Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", SDot).CornerRadius = UDim.new(1, 0)

local drag = false
SBar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = true end end)
UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end end)
RS.RenderStepped:Connect(function()
    if drag then
        local r = math.clamp((UIS:GetMouseLocation().X - SBar.AbsolutePosition.X) / SBar.AbsoluteSize.X, 0, 1)
        local val = math.floor(r * 10)
        if val >= 0 and val <= 10 then
            SFill.Size, getgenv().Config.Accuracy, SV.Text = UDim2.new(r, 0, 1, 0), val, tostring(val)
        end
    end
end)

RS.Heartbeat:Connect(function()
    pcall(function()
        if getgenv().Config.AutoPop then
            local PopUI = LP.PlayerGui:FindFirstChild("PopcornGame") or LP.PlayerGui:FindFirstChild("PopcornDuel")
            if PopUI then
                local Best, Val = nil, 25
                for _, v in pairs(PopUI:GetDescendants()) do
                    if v:IsA("TextLabel") and string.find(v.Text, "+") then
                        local n = tonumber(string.match(v.Text, "%d+"))
                        if n and n > Val then Val, Best = n, v end
                    end
                end
                if Best and math.random(1, 10) <= getgenv().Config.Accuracy then
                    local b = Best.Parent:FindFirstChildOfClass("TextButton") or Best.Parent:FindFirstChildOfClass("ImageButton")
                    if b then firesignal(b.MouseButton1Click) firesignal(b.Activated) end
                end
            end
        end
        if getgenv().Config.ConnectFour then
            local CF4 = LP.PlayerGui:FindFirstChild("ConnectFour") or LP.PlayerGui:FindFirstChild("FourInARow")
            if CF4 then
                for _, slot in pairs(CF4:GetDescendants()) do
                    if slot:IsA("TextButton") and slot.Visible and slot.Name == "Slot" then
                         firesignal(slot.MouseButton1Click)
                    end
                end
            end
        end
    end)
end)

