-- [[ Crystal Hub - Fixed Top UI ]]

local Player = game.Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")

-- تنظيف أي نسخة سابقة
if CoreGui:FindFirstChild("CrystalHub_Fixed") then
    CoreGui.CrystalHub_Fixed:Destroy()
end

-- [[ الواجهة الرئيسية ]]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CrystalHub_Fixed"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- المستطيل العلوي (ثابت في المنتصف)
local MainBar = Instance.new("Frame")
MainBar.Name = "MainBar"
-- العرض 350 والطول 45 مع وضعه في منتصف الشاشة عرضياً
MainBar.Size = UDim2.new(0, 320, 0, 40) 
MainBar.Position = UDim2.new(0.5, -160, 0.05, 0) -- ثابت في الأعلى بنسبة 5% من الشاشة
MainBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15) -- أسود غامق
MainBar.BackgroundTransparency = 0.3 -- شفافية متوسطة
MainBar.BorderSizePixel = 0
MainBar.Active = false -- إيقاف التفاعل عشان ما يتحركش
MainBar.Parent = ScreenGui

-- حواف دائرية انسيابية
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 15)
UICorner.Parent = MainBar

-- عداد المعلومات (Crystal Hub | FPS | MS)
local InfoLabel = Instance.new("TextLabel")
InfoLabel.Size = UDim2.new(1, 0, 1, 0)
InfoLabel.BackgroundTransparency = 1
InfoLabel.TextColor3 = Color3.fromRGB(0, 180, 255) -- أزرق زاهي
InfoLabel.TextSize = 15
InfoLabel.Font = Enum.Font.GothamBold
InfoLabel.Text = "Crystal Hub | 0 FPS | 0 MS"
InfoLabel.Parent = MainBar

-- [[ نظام الـ Overhead (البيانات فوق الرأس) كما في الفيديو ]]
local function CreateOverhead(targetPlayer)
    targetPlayer.CharacterAdded:Connect(function(char)
        local head = char:WaitForChild("Head", 5)
        if not head then return end
        
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "CrystalTag"
        billboard.Size = UDim2.new(0, 200, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 3, 0) -- الارتفاع فوق الرأس
        billboard.AlwaysOnTop = true
        billboard.Parent = head

        -- النص العلوي (أبيض للسرعة أو الاسم)
        local topLabel = Instance.new("TextLabel")
        topLabel.Size = UDim2.new(1, 0, 0.4, 0)
        topLabel.BackgroundTransparency = 1
        topLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        topLabel.TextScaled = true
        topLabel.Font = Enum.Font.GothamBold
        topLabel.Parent = billboard
        
        -- رابط الديسكورد (أزرق)
        local discordLabel = Instance.new("TextLabel")
        discordLabel.Position = UDim2.new(0, 0, 0.45, 0)
        discordLabel.Size = UDim2.new(1, 0, 0.35, 0)
        discordLabel.BackgroundTransparency = 1
        discordLabel.TextColor3 = Color3.fromRGB(0, 170, 255)
        discordLabel.Text = "discord.gg/VHUSrhjq9u"
        discordLabel.TextScaled = true
        discordLabel.Font = Enum.Font.GothamBold
        discordLabel.Parent = billboard

        task.spawn(function()
            while char:IsDescendantOf(workspace) do
                local hum = char:FindFirstChild("Humanoid")
                if hum then
                    if targetPlayer == Player then
                        topLabel.Text = "Speed: " .. string.format("%.1f", hum.WalkSpeed) -- عرض سرعة اللاعب
                    else
                        topLabel.Text = targetPlayer.DisplayName -- عرض اسم الخصم
                    end
                end
                task.wait(0.1)
            end
        end)
    end)
end

-- تطبيق النظام على الجميع
for _, p in pairs(game.Players:GetPlayers()) do CreateOverhead(p) end
game.Players.PlayerAdded:Connect(CreateOverhead)

-- [[ محرك تحديث الـ FPS والـ Ping ]]
task.spawn(function()
    while task.wait(0.5) do
        local fps = math.floor(1 / (RunService.RenderStepped:Wait() + 0.0001))
        local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        InfoLabel.Text = "Crystal Hub | " .. fps .. " FPS | " .. ping .. " MS"
    end
end)
