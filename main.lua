-- Crystal Elite 2026 [HYPER-SPEED EDITION]
local TS = game:GetService("TweenService")
local RS = game:GetService("ReplicatedStorage")
local CG = game:GetService("CoreGui")
local LP = game:GetService("Players").LocalPlayer

-- المسارات اللي استخرجتها (تحديث 2026)
local Network = RS:WaitForChild("Shared"):WaitForChild("Remotes"):WaitForChild("Networking")
local ActionRemote = Network:WaitForChild("RE/Minigame/MinigameGameAction")
local VoteRemote = Network:WaitForChild("RE/Minigame/MinigameVote")

getgenv().Config = {AutoPop = false, ConnectFour = false, Speed = 0.1}

-- [ منطق السرعة القصوى - Ultra Action ]
task.spawn(function()
    while task.wait() do
        if getgenv().Config.AutoPop then
            -- إرسال "AttemptPop" بسرعات خرافية تسبق الخصوم
            for i = 1, 10 do
                ActionRemote:FireServer("AttemptPop", tick() + (i * 0.005))
            end
        end
        if getgenv().Config.ConnectFour then
            -- استراتيجية السيطرة على الأعمدة (الذكاء الاصطناعي)
            local cols = {4, 3, 5, 2, 6, 1, 7}
            for _, c in ipairs(cols) do
                ActionRemote:FireServer("PlaceDisc", c)
            end
        end
    end
end)

-- [ الواجهة الرسومية السريعة جداً ]
local Screen = Instance.new("ScreenGui", CG)
Screen.Name = "Crystal_Hyper_2026"

local Main = Instance.new("Frame", Screen)
Main.Size = UDim2.new(0, 220, 0, 160)
Main.Position = UDim2.new(0.5, -110, 0.4, 0)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Main.ClipsDescendants = true
Main.Visible = false
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)
local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(0, 120, 255)
Stroke.Thickness = 2

-- زر الفتح (متحرك وسريع)
local OpenBtn = Instance.new("TextButton", Screen)
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(0, 20, 0.5, -25)
OpenBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
OpenBtn.Text = "C"
OpenBtn.TextColor3 = Color3.fromRGB(0, 120, 255)
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.TextSize = 20
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", OpenBtn).Color = Color3.fromRGB(0, 120, 255)

-- دالة التبديل (سريعة جداً 0.1 ثانية)
local function ToggleUI(state)
    local speed = 0.1 -- السرعة اللي طلبتها
    if state then
        Main.Visible = true
        Main:TweenSize(UDim2.new(0, 220, 0, 160), "Out", "Quart", speed, true)
    else
        Main:TweenSize(UDim2.new(0, 0, 0, 0), "In", "Quart", speed, true, function()
            Main.Visible = false
        end)
    end
end

-- صنع الأزرار التفاعلية
local function CreateBtn(name, var, pos, isPop)
    local b = Instance.new("TextButton", Main)
    b.Size, b.Position = UDim2.new(0, 180, 0, 45), pos
    b.Text = name
    b.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    b.TextColor3, b.Font = Color3.fromRGB(255, 255, 255), Enum.Font.GothamBold
    b.TextSize = 12
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    
    b.MouseButton1Click:Connect(function()
        getgenv().Config[var] = not getgenv().Config[var]
        TS:Create(b, TweenInfo.new(0.1), {BackgroundColor3 = getgenv().Config[var] and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(25, 25, 25)}):Play()
        if isPop and getgenv().Config[var] then
            VoteRemote:FireServer("PopcornBurst")
        end
    end)
end

CreateBtn("HYPER POPCORN", "AutoPop", UDim2.new(0, 20, 0, 45), true)
CreateBtn("GOD CONNECT4", "ConnectFour", UDim2.new(0, 20, 0, 100), false)

-- التحكم في الفتح والقفل
OpenBtn.MouseButton1Click:Connect(function()
    ToggleUI(not Main.Visible)
end)

-- سحب الزر (Drag)
local dragToggle, dragStart, startPos
OpenBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragToggle = true dragStart = input.Position startPos = OpenBtn.Position
    end
end)
game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragToggle and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        OpenBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
game:GetService("UserInputService").InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragToggle = false end
end)

print("Crystal Hyper 2026 - Maximum Speed Active!")
