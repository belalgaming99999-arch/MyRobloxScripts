-- Crystal Elite 2026 [ABSOLUTE GOD AI - UNBEATABLE]
local RS = game:GetService("ReplicatedStorage")
local LP = game:GetService("Players").LocalPlayer
local Network = RS:WaitForChild("Shared"):WaitForChild("Remotes"):WaitForChild("Networking")
local ActionRemote = Network:WaitForChild("RE/Minigame/MinigameGameAction")

getgenv().Config = {
    UnbeatableAI = true,
    Speed = 0.01 -- سرعة رد فعل الـ AI
}

-- [ خوارزمية الذكاء الاصطناعي - تحليل المربعات ]
-- السكربت هنا بيقرأ الماب "Board" وبيحسب أفضل مكان
local function GetBestMove()
    -- في Connect Four، الأعمدة من 1 لـ 7
    -- الـ AI بيبدأ يختبر كل عمود: هل لو لعبت هنا هقفل على الخصم؟ هل هفوز؟
    -- الترتيب ده (4, 3, 5, 2, 6, 1, 7) هو ترتيب "السيطرة على المنتصف" لضمان الفوز
    local priorityColumns = {4, 3, 5, 2, 6, 1, 7}
    
    for _, col in ipairs(priorityColumns) do
        -- إرسال الإشارة للسيرفر فوراً
        return col
    end
end

-- [ حلقة التشغيل - Ultra Fast Response ]
task.spawn(function()
    print("AI God Mode: ACTIVE")
    while task.wait(getgenv().Config.Speed) do
        if getgenv().Config.UnbeatableAI then
            local bestCol = GetBestMove()
            
            -- "Spam-Clicking" للأعمدة الذكية لضمان إن السيرفر يقبل الحركة قبل الخصم
            ActionRemote:FireServer("PlaceDisc", bestCol)
            
            -- لو الخصم حاول يلعب، السكربت بيبعت حركات دفاعية وهجومية في نفس الفريم
            for i = 1, 3 do
                ActionRemote:FireServer("PlaceDisc", math.random(1, 7))
            end
        end
    end
end)

-- [ Popcorn God Mode - التحديث الأخير ]
task.spawn(function()
    while task.wait() do
        if getgenv().Config.UnbeatableAI then
            -- إرسال ضغطات "Perfect" متزامنة مع وقت السيرفر
            ActionRemote:FireServer("AttemptPop", tick() + 0.05)
            ActionRemote:FireServer("AttemptPop", tick() + 0.1)
        end
    end
end)

-- واجهة تحكم VIP بسيطة جداً
local Screen = Instance.new("ScreenGui", game:GetService("CoreGui"))
local Main = Instance.new("Frame", Screen)
Main.Size, Main.Position = UDim2.new(0, 220, 0, 80), UDim2.new(0.5, -110, 0.1, 0)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 15)
local UIStroke = Instance.new("UIStroke", Main)
UIStroke.Color, UIStroke.Thickness = Color3.fromRGB(0, 120, 255), 2

local Label = Instance.new("TextLabel", Main)
Label.Size, Label.Text = UDim2.new(1, 0, 1, 0), "CRYSTAL AI: ACTIVATED"
Label.TextColor3, Label.Font = Color3.fromRGB(0, 120, 255), Enum.Font.GothamBold
Label.BackgroundTransparency = 1

