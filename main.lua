local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

if CoreGui:FindFirstChild("CrystalHub") then CoreGui.CrystalHub:Destroy() end

local Crystal = Instance.new("ScreenGui", CoreGui)
Crystal.Name = "CrystalHub"
Crystal.IgnoreGuiInset = true

local Toggles = {AutoPop = false, Connect4 = false}

-- محرك التنفيذ السريع (10ms)
task.spawn(function()
    while true do
        task.wait(0.01) -- سرعة الـ 10ms التي طلبتها
        
        -- تفعيل الأوتو بوب (Auto Pop)
        if Toggles.AutoPop then
            pcall(function()
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("ClickDetector") then
                        fireclickdetector(v)
                    end
                end
            end)
        end

        -- تفعيل كونكت فور (Connect Four) بالأكواد التي صطدتها
        if Toggles.Connect4 then
            pcall(function()
                local Remote = ReplicatedStorage.Shared.Remotes.Networking["RF/NegotiationSetSlot"]
                Remote:InvokeServer("1", "0f8d5004-d9c8-48b9-954b-18315ff7bc68")
                Remote:InvokeServer("2", "efc6c599-a30c-4af8-a910-e36a732367e9")
            end)
        end
    end
end)

-- تصميم الواجهة
local Main = Instance.new("Frame", Crystal)
Main.Size = UDim2.new(0, 200, 0, 160)
Main.Position = UDim2.new(0.5, -100, 0.4, -80)
Main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "Crystal Hub"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.BackgroundTransparency = 1

local function CreateToggle(name, key, posY)
    local Btn = Instance.new("TextButton", Main)
    Btn.Size = UDim2.new(0, 170, 0, 40)
    Btn.Position = UDim2.new(0.5, -85, 0, posY)
    Btn.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
    Btn.Text = name .. " [OFF]"
    Btn.TextColor3 = Color3.new(1, 1, 1)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 14
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)

    Btn.MouseButton1Click:Connect(function()
        Toggles[key] = not Toggles[key]
        Btn.Text = name .. (Toggles[key] and " [ON]" or " [OFF]")
        Btn.BackgroundColor3 = Toggles[key] and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(150, 50, 50)
    end)
end

CreateToggle("Auto Pop", "AutoPop", 50)
CreateToggle("Connect Four", "Connect4", 100)

-- نظام السحب (للجوال والكمبيوتر)
local dragging, dragStart, startPos
Main.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        dragging = true dragStart = i.Position startPos = Main.Position
    end
end)
UserInputService.InputChanged:Connect(function(i)
    if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        local d = i.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
