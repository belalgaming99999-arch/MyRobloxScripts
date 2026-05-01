local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

if CoreGui:FindFirstChild("CrystalHub") then CoreGui.CrystalHub:Destroy() end

local Crystal = Instance.new("ScreenGui", CoreGui)
Crystal.Name = "CrystalHub"
Crystal.IgnoreGuiInset = true

local Toggles = {
    AutoPop = false,
    AutoFourRow = false,
    AutoShips = false
}

task.spawn(function()
    while true do
        task.wait(0.01)
        if Toggles.AutoPop then
            pcall(function()
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("ClickDetector") then 
                        fireclickdetector(v) 
                    end
                end
            end)
        end
    end
end)

local Main = Instance.new("Frame", Crystal)
Main.Size = UDim2.new(0, 220, 0, 260)
Main.Position = UDim2.new(0.5, -110, 0.4, -130)
Main.BackgroundColor3 = Color3.fromRGB(25, 35, 55)
Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Text = "Crystal Hub"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.BackgroundTransparency = 1

local function CreateBtn(name, key, posY)
    local Btn = Instance.new("TextButton", Main)
    Btn.Size = UDim2.new(0, 180, 0, 45)
    Btn.Position = UDim2.new(0.5, -90, 0, posY)
    Btn.BackgroundColor3 = Color3.fromRGB(135, 55, 55)
    Btn.Text = name .. " [OFF]"
    Btn.TextColor3 = Color3.new(1, 1, 1)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 14
    Btn.AutoButtonColor = false
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)

    Btn.MouseButton1Click:Connect(function()
        Toggles[key] = not Toggles[key]
        Btn.Text = name .. (Toggles[key] and " [ON]" or " [OFF]")
        local targetColor = Toggles[key] and Color3.fromRGB(55, 120, 85) or Color3.fromRGB(135, 55, 55)
        TweenService:Create(Btn, TweenInfo.new(0.3), {BackgroundColor3 = targetColor}):Play()
    end)
end

CreateBtn("Auto Pop", "AutoPop", 60)
CreateBtn("Auto FourRow", "AutoFourRow", 115)
CreateBtn("Auto Ships", "AutoShips", 170)

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
UserInputService.InputEnded:Connect(function(i) 
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then 
        dragging = false 
    end 
end)
