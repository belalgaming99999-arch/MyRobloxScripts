-- [[ Crystal Hub - Ultra Precision UI (Clone Nova Hub) ]]

local Player = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")

-- تحديد مكان الظهور
local ParentUI = (game:GetService("CoreGui"):FindFirstChild("RobloxGui") and game:GetService("CoreGui")) or Player:WaitForChild("PlayerGui")

-- تنظيف أي نسخ قديمة
if ParentUI:FindFirstChild("CrystalHub_Fixed") then ParentUI.CrystalHub_Fixed:Destroy() end

-- [[ إنشاء الواجهة ]]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CrystalHub_Fixed"
ScreenGui.Parent = ParentUI
ScreenGui.ResetOnSpawn = false

-- المستطيل الأسود (تصغير الحجم وتعديل الشفافية ليطابق الصورة)
local MainBar = Instance.new("Frame")
MainBar.Name = "MainBar"
MainBar.Size = UDim2.new(0, 260, 0, 32) -- حجم أصغر وأكثر رشاقة زي الصورة
MainBar.Position = UDim2.new(0.5, -130, 0.02, 0) -- في المنتصف العلوي تماماً
MainBar.BackgroundColor3 = Color3.fromRGB(10, 10, 10) -- أسود عميق
MainBar.BackgroundTransparency = 0.45 -- شفافية مطابقة للصورة
MainBar.BorderSizePixel = 0
MainBar.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12) -- حواف دائرية ناعمة
UICorner.Parent = MainBar

-- النص (Crystal Hub | FPS | MS) مع تعديل اللون للأزرق السماوي المطابق
local InfoLabel = Instance.new("TextLabel")
InfoLabel.Size = UDim2.new(1, 0, 1, 0)
InfoLabel.BackgroundTransparency = 1
InfoLabel.TextColor3 = Color3.fromRGB(0, 175, 255) -- نفس درجة اللون الأزرق في Nova Hub
InfoLabel.TextSize = 13 -- خط أصغر وأوضح
InfoLabel.Font = Enum.Font.GothamBold
InfoLabel.Text = "Crystal Hub | Loading..."
InfoLabel.Parent = MainBar

-- [[ نظام الـ Overhead (السرعة والأسماء بدقة عالية) ]]
local function CreateOverhead(targetPlayer)
    local function apply(char)
        local head = char:WaitForChild("Head", 15)
        if not head then return end
        
        if head:FindFirstChild("CrystalTag") then head.CrystalTag:Destroy() end

        local billboard = Instance.new("BillboardGui")
        billboard.Name = "CrystalTag"
        billboard.Size = UDim2.new(0, 150, 0, 40)
        billboard.StudsOffset = Vector3.new(0, 3.2, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = head

        local topLabel = Instance.new("TextLabel")
        topLabel.Size = UDim2.new(1, 0, 0.5, 0)
        topLabel.BackgroundTransparency = 1
        topLabel.TextColor3 = Color3.fromRGB(255, 255, 255) -- أبيض للسرعة/الاسم
        topLabel.TextSize = 12
        topLabel.Font = Enum.Font.GothamBold
        topLabel.Parent = billboard
        
        local discordLabel = Instance.new("TextLabel")
        discordLabel.Position = UDim2.new(0, 0, 0.45, 0)
        discordLabel.Size = UDim2.new(1, 0, 0.5, 0)
        discordLabel.BackgroundTransparency = 1
        discordLabel.TextColor3 = Color3.fromRGB(0, 175, 255) -- أزرق سماوي
        discordLabel.Text = "discord.gg/VHUSrhjq9u"
        discordLabel.TextSize = 10
        discordLabel.Font = Enum.Font.GothamBold
        discordLabel.Parent = billboard

        task.spawn(function()
            while char:IsDescendantOf(workspace) do
                local hum = char:FindFirstChild("Humanoid")
                if hum then
                    if targetPlayer == Player then
                        topLabel.Text = "Speed: " .. string.format("%.1f", hum.WalkSpeed)
                    else
                        topLabel.Text = targetPlayer.DisplayName
                    end
                end
                task.wait(0.1)
            end
        end)
    end
    if targetPlayer.Character then apply(targetPlayer.Character) end
    targetPlayer.CharacterAdded:Connect(apply)
end

for _, p in game:GetService("Players"):GetPlayers() do CreateOverhead(p) end
game:GetService("Players").PlayerAdded:Connect(CreateOverhead)

-- [[ تحديث العدادات ]]
task.spawn(function()
    while task.wait(0.5) do
        local fps = math.floor(1 / (RunService.RenderStepped:Wait() + 0.0001))
        local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        InfoLabel.Text = "Crystal Hub | " .. fps .. " FPS | " .. ping .. " MS"
    end
end)
