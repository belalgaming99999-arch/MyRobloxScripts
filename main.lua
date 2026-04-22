-- [[ Crystal Hub - Universal Multi-Platform UI ]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local Player = Players.LocalPlayer

-- ضمان إيجاد الـ PlayerGui مهما كان نوع الجهاز
local PlayerGui = Player:FindFirstChild("PlayerGui") or Player:WaitForChild("PlayerGui", 10)

-- حذف أي نسخة قديمة فوراً لتجنب التكرار
if PlayerGui:FindFirstChild("CrystalHub_Universal") then 
    PlayerGui.CrystalHub_Fixed:Destroy() 
end

-- [[ إنشاء الواجهة ]]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CrystalHub_Universal"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false -- القائمة مش هتختفي لما تموت
ScreenGui.DisplayOrder = 99999 -- فوق كل شيء

-- 1. المستطيل الأساسي (تصميم طبق الأصل)
local MainBar = Instance.new("Frame")
MainBar.Name = "MainBar"
MainBar.Size = UDim2.new(0, 260, 0, 32) 
MainBar.Position = UDim2.new(0.5, -130, 0.02, 0) -- ثابت فوق في النص
MainBar.BackgroundColor3 = Color3.fromRGB(10, 10, 10) 
MainBar.BackgroundTransparency = 0.45 
MainBar.BorderSizePixel = 0
MainBar.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12) 
UICorner.Parent = MainBar

-- حواف ثقيلة بنفس لون الكتابة
local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(0, 175, 255)
MainStroke.Thickness = 2
MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
MainStroke.Parent = MainBar

-- نص المعلومات مع الحواف السوداء للكتابة
local InfoLabel = Instance.new("TextLabel")
InfoLabel.Size = UDim2.new(1, 0, 1, 0)
InfoLabel.BackgroundTransparency = 1
InfoLabel.TextColor3 = Color3.fromRGB(0, 175, 255) 
InfoLabel.TextSize = 13 
InfoLabel.Font = Enum.Font.GothamBold
InfoLabel.Text = "Crystal Hub | FPS: -- | MS: --"
InfoLabel.Parent = MainBar

local TextOutline = Instance.new("UIStroke")
TextOutline.Color = Color3.fromRGB(0, 0, 0)
TextOutline.Thickness = 1
TextOutline.Parent = InfoLabel

-- [[ 2. نظام الـ Overhead وسرعة Vector3 الحقيقية ]]
local function CreateOverhead(targetPlayer)
    local function apply(char)
        local head = char:WaitForChild("Head", 15)
        local root = char:WaitForChild("HumanoidRootPart", 15)
        if not head or not root then return end
        
        if head:FindFirstChild("CrystalTag") then head.CrystalTag:Destroy() end

        local billboard = Instance.new("BillboardGui")
        billboard.Name = "CrystalTag"
        billboard.Size = UDim2.new(0, 150, 0, 40)
        billboard.StudsOffset = Vector3.new(0, 3.5, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = head

        local topLabel = Instance.new("TextLabel")
        topLabel.Size = UDim2.new(1, 0, 0.5, 0)
        topLabel.BackgroundTransparency = 1
        topLabel.TextColor3 = Color3.fromRGB(255, 255, 255) 
        topLabel.TextSize = 12
        topLabel.Font = Enum.Font.GothamBold
        Instance.new("UIStroke", topLabel).Thickness = 1.2 -- حواف سوداء للكتابة
        topLabel.Parent = billboard
        
        local discordLabel = Instance.new("TextLabel")
        discordLabel.Position = UDim2.new(0, 0, 0.45, 0)
        discordLabel.Size = UDim2.new(1, 0, 0.5, 0)
        discordLabel.BackgroundTransparency = 1
        discordLabel.TextColor3 = Color3.fromRGB(0, 175, 255) 
        discordLabel.Text = "discord.gg/VHUSrhjq9u"
        discordLabel.TextSize = 10
        discordLabel.Font = Enum.Font.GothamBold
        Instance.new("UIStroke", discordLabel).Thickness = 1.2 -- حواف سوداء للرابط
        discordLabel.Parent = billboard

        task.spawn(function()
            while char:IsDescendantOf(workspace) and char:FindFirstChild("HumanoidRootPart") do
                -- حساب السرعة الحقيقية من الـ Velocity
                local vel = char.HumanoidRootPart.Velocity
                local speed = math.floor(Vector3.new(vel.X, 0, vel.Z).Magnitude)
                
                if targetPlayer == Player then
                    topLabel.Text = "Speed: " .. speed
                else
                    topLabel.Text = targetPlayer.DisplayName
                end
                task.wait(0.05) -- تحديث سريع جداً
            end
        end)
    end
    if targetPlayer.Character then apply(targetPlayer.Character) end
    targetPlayer.CharacterAdded:Connect(apply)
end

-- التشغيل الفوري للجميع
for _, p in pairs(Players:GetPlayers()) do CreateOverhead(p) end
Players.PlayerAdded:Connect(CreateOverhead)

-- [[ تحديث العدادات العلوي ]]
task.spawn(function()
    while task.wait(0.4) do
        local fps = math.floor(1 / (RunService.RenderStepped:Wait() + 0.0001))
        local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        InfoLabel.Text = "Crystal Hub | " .. fps .. " FPS | " .. ping .. " MS"
    end
end)
                
                if targetPlayer == Player then
                    topLabel.Text = "Speed: " .. realSpeed
                else
                    topLabel.Text = targetPlayer.DisplayName
                end
                task.wait(0.1)
            end
        end)
    end
    if targetPlayer.Character then apply(targetPlayer.Character) end
    targetPlayer.CharacterAdded:Connect(apply)
end

for _, p in pairs(Players:GetPlayers()) do CreateOverhead(p) end
Players.PlayerAdded:Connect(CreateOverhead)

-- تحديث البيانات
task.spawn(function()
    while task.wait(0.5) do
        local fps = math.floor(1 / (RunService.RenderStepped:Wait() + 0.0001))
        local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        InfoLabel.Text = "Crystal Hub | " .. fps .. " FPS | " .. ping .. " MS"
    end
end)
                task.wait(0.1)
            end
        end)
    end
    if targetPlayer.Character then apply(targetPlayer.Character) end
    targetPlayer.CharacterAdded:Connect(apply)
end

for _, p in game:GetService("Players"):GetPlayers() do CreateOverhead(p) end
game:GetService("Players").PlayerAdded:Connect(CreateOverhead)

-- تحديث العدادات العلوي
task.spawn(function()
    while task.wait(0.5) do
        local fps = math.floor(1 / (RunService.RenderStepped:Wait() + 0.0001))
        local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        InfoLabel.Text = "Crystal Hub | " .. fps .. " FPS | " .. ping .. " MS"
    end
end)
        InfoLabel.Text = "Crystal Hub | " .. fps .. " FPS | " .. ping .. " MS"
    end
end)
