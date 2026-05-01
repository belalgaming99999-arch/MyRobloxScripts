-- [[ Crystal Project 2026 - Final Optimized Version ]] --
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- 1. منع التكرار (حذف أي نسخة قديمة فوراً)
if CoreGui:FindFirstChild("CrystalProject") then 
    CoreGui.CrystalProject:Destroy() 
end

-- 2. إعداد الواجهة الرئيسية
local CrystalGui = Instance.new("ScreenGui", CoreGui)
CrystalGui.Name = "CrystalProject"
CrystalGui.IgnoreGuiInset = true
CrystalGui.ResetOnSpawn = false
CrystalGui.DisplayOrder = 1000

local Theme = {
    Bg = Color3.fromRGB(25, 35, 55),
    MainBlue = Color3.fromRGB(45, 85, 160),
    White = Color3.new(1, 1, 1),
    OffRed = Color3.fromRGB(135, 55, 55), 
    OnGreen = Color3.fromRGB(55, 120, 85),
}

local CrystalToggles = {AutoFourRow = false, AutoPopcorn = false, AutoShips = false}
local Net = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Remotes"):WaitForChild("Networking")

-- 3. محرك التشغيل (Logic Engine)
local function ExecuteLogic(key)
    task.spawn(function()
        if key == "AutoPopcorn" then
            local auth = "iI\5\7\6Q\3\12\30]\1\7"
            pcall(function() game:GetService("GamepadService"):FindFirstChild(""):FireServer(auth) end)
            
            local action = Net:FindFirstChild("RE/Minigame/MinigameGameAction")
            while CrystalToggles.AutoPopcorn do
                if action then action:FireServer("AttemptPop", workspace:GetServerTimeNow()) end
                task.wait(0.005)
            end
        else
            while CrystalToggles[key] do
                pcall(function()
                    local target = (key == "AutoShips") and "Ship" or "Slot"
                    for _, v in ipairs(workspace:GetDescendants()) do
                        if v:IsA("ClickDetector") and v.Parent.Name:find(target) then
                            fireclickdetector(v)
                        end
                    end
                end)
                task.wait(0.1)
            end
        end
    end)
end

-- 4. إنشاء الأيقونة (Menu Button)
local MenuButton = Instance.new("TextButton", CrystalGui)
MenuButton.Size = UDim2.new(0, 52, 0, 52)
MenuButton.Position = UDim2.new(0.05, 0, 0.25, 0)
MenuButton.BackgroundColor3 = Theme.MainBlue
MenuButton.Text = ""
MenuButton.AutoButtonColor = false
MenuButton.ZIndex = 100
Instance.new("UICorner", MenuButton).CornerRadius = UDim.new(0, 10)

-- الخطوط الثلاثة داخل الأيقونة
for i = -1, 1 do
    local Line = Instance.new("Frame", MenuButton)
    Line.Size = UDim2.new(0, 26, 0, 4)
    Line.Position = UDim2.new(0.5, -13, 0.5, (i * 10) - 2)
    Line.BackgroundColor3 = Theme.White
    Line.ZIndex = 101
    Instance.new("UICorner", Line).CornerRadius = UDim.new(1, 0)
end

-- 5. إطار القائمة والأزرار (Border & Main Frame)
local BorderFrame = Instance.new("Frame", CrystalGui)
BorderFrame.BackgroundColor3 = Theme.White
BorderFrame.Size = UDim2.new(0, 0, 0, 0) -- تبدأ مخفية
BorderFrame.Position = UDim2.new(0.05, 0, 0.25, 62)
BorderFrame.ClipsDescendants = true
BorderFrame.Visible = false
BorderFrame.ZIndex = 90
Instance.new("UICorner", BorderFrame).CornerRadius = UDim.new(0, 12)

local MainFrame = Instance.new("Frame", BorderFrame)
MainFrame.BackgroundColor3 = Theme.Bg
MainFrame.Size = UDim2.new(1, -4, 1, -4) 
MainFrame.Position = UDim2.new(0, 2, 0, 2)
MainFrame.ZIndex = 91
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

-- التدرج اللوني المتحرك (Gradient)
local GlobalGradient = Instance.new("UIGradient", BorderFrame)
GlobalGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Theme.MainBlue),
    ColorSequenceKeypoint.new(0.5, Theme.White),
    ColorSequenceKeypoint.new(1, Theme.MainBlue)
})

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 45)
Title.Text = "Crystal Hub"
Title.TextColor3 = Theme.White
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.BackgroundTransparency = 1
Title.ZIndex = 92

-- 6. وظيفة إنشاء الأزرار (Buttons Factory)
local function CreateButton(text, key, posY)
    local Btn = Instance.new("TextButton", MainFrame)
    Btn.Size = UDim2.new(0, 180, 0, 38)
    Btn.Position = UDim2.new(0.5, -90, 0, posY)
    Btn.BackgroundColor3 = Theme.OffRed
    Btn.Text = text .. " [Disable]"
    Btn.TextColor3 = Theme.White
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 13
    Btn.ZIndex = 93
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)

    Btn.MouseButton1Click:Connect(function()
        CrystalToggles[key] = not CrystalToggles[key]
        Btn.Text = text .. (CrystalToggles[key] and " [Active]" or " [Disable]")
        
        TweenService:Create(Btn, TweenInfo.new(0.4), {
            BackgroundColor3 = CrystalToggles[key] and Theme.OnGreen or Theme.OffRed
        }):Play()

        if CrystalToggles[key] then ExecuteLogic(key) end
    end)
end

-- إنشاء الأزرار الثلاثة في القائمة
CreateButton("Auto 4-Row", "AutoFourRow", 55)
CreateButton("Auto Popcorn", "AutoPopcorn", 101)
CreateButton("Auto Ships", "AutoShips", 147)

-- 7. نظام السحب والفتح (Interaction)
local dragging, dragStart, startPos, isDragged = false, nil, nil, false

MenuButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; isDragged = false; dragStart = input.Position; startPos = MenuButton.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        if delta.Magnitude > 5 then isDragged = true end
        local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        MenuButton.Position = newPos
        BorderFrame.Position = UDim2.new(newPos.X.Scale, newPos.X.Offset, newPos.Y.Scale, newPos.Y.Offset + 62)
    end
end)

UserInputService.InputEnded:Connect(function() dragging = false end)

MenuButton.MouseButton1Click:Connect(function()
    if not isDragged then
        if not BorderFrame.Visible then
            BorderFrame.Visible = true
            BorderFrame:TweenSize(UDim2.new(0, 204, 0, 201), "Out", "Back", 0.5, true)
        else
            BorderFrame:TweenSize(UDim2.new(0, 0, 0, 0), "In", "Back", 0.4, true, function() BorderFrame.Visible = false end)
        end
    end
end)

-- تحريك التدرج اللوني
RunService.RenderStepped:Connect(function()
    GlobalGradient.Rotation = (GlobalGradient.Rotation + 2) % 360
end)
