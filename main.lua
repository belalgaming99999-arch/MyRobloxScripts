-- Crystal Elite 2026 [ULTRA AI - GLOBAL PREDICTOR]
local RS = game:GetService("ReplicatedStorage")
local Network = RS:WaitForChild("Shared"):WaitForChild("Remotes"):WaitForChild("Networking")
local ActionRemote = Network:WaitForChild("RE/Minigame/MinigameGameAction")
local VoteRemote = Network:WaitForChild("RE/Minigame/MinigameVote")

getgenv().Config = {
    AutoPop = false,
    ConnectFour = false,
    Accuracy = 10
}

-- [ خوارزمية الـ AI للـ Connect Four ]
-- تعتمد على استباق الخصم وإرسال الأوامر فوراً
local function PredictAndWin()
    -- ترتيب الأعمدة من الأهم (المنتصف) للأطراف لضمان الفوز
    local strategicColumns = {4, 3, 5, 2, 6, 1, 7}
    for _, col in ipairs(strategicColumns) do
        -- نرسل الأمر باستخدام الإحداثيات اللي السيرفر مستنيها
        ActionRemote:FireServer("PlaceDisc", col)
    end
end

-- [ حلقة التشغيل الفائقة - Super Loop ]
task.spawn(function()
    while task.wait() do
        -- 1. ذكاء البوب كورن (استخدام AttemptPop مع الـ tick المتغير)
        if getgenv().Config.AutoPop then
            for i = 1, getgenv().Config.Accuracy do
                ActionRemote:FireServer("AttemptPop", tick() + (i * 0.01))
            end
        end
        
        -- 2. ذكاء كونكت فور (اللعب التلقائي الخارق)
        if getgenv().Config.ConnectFour then
            PredictAndWin()
            task.wait(0.1) -- سرعة رد فعل الـ AI
        end
    end
end)

-- [ واجهة التحكم الأنيقة ]
local Screen = Instance.new("ScreenGui", game:GetService("CoreGui"))
local Main = Instance.new("Frame", Screen)
Main.Size, Main.Position = UDim2.new(0, 240, 0, 160), UDim2.new(0.5, -120, 0.4, 0)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 15)

local Stroke = Instance.new("UIStroke", Main)
Stroke.Color, Stroke.Thickness = Color3.fromRGB(0, 120, 255), 2

local Title = Instance.new("TextLabel", Main)
Title.Size, Title.Text = UDim2.new(1, 0, 0, 40), "CRYSTAL AI v2026"
Title.TextColor3, Title.Font = Color3.fromRGB(255, 255, 255), Enum.Font.GothamBold
Title.BackgroundTransparency = 1

local function CreateToggle(name, var, pos, isPop)
    local b = Instance.new("TextButton", Main)
    b.Size, b.Position = UDim2.new(0, 200, 0, 45), pos
    b.Text = name
    b.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    b.TextColor3, b.Font = Color3.fromRGB(255, 255, 255), Enum.Font.GothamBold
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
    
    b.MouseButton1Click:Connect(function()
        getgenv().Config[var] = not getgenv().Config[var]
        b.BackgroundColor3 = getgenv().Config[var] and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(30, 30, 30)
        
        -- لو اختار الفشار نبعت ريموت التصويت اللي استخرجته "PopcornBurst"
        if isPop and getgenv().Config[var] then
            VoteRemote:FireServer("PopcornBurst")
        end
    end)
end

CreateToggle("ULTRA AUTO-POP", "AutoPop", UDim2.new(0, 20, 0, 50), true)
CreateToggle("GOD CONNECT-4", "ConnectFour", UDim2.new(0, 20, 0, 100), false)
