-- [[ Crystal Hub - Custom UI (No Rayfield) ]]

local Player = game.Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")

-- حذف أي واجهة قديمة (سواء Rayfield أو غيرها) لضمان نظافة التشغيل
if CoreGui:FindFirstChild("CrystalHub_Fixed") then CoreGui.CrystalHub_Fixed:Destroy() end
if CoreGui:FindFirstChild("Rayfield") then CoreGui.Rayfield:Destroy() end

-- [[ إنشاء الواجهة العلوية الثابتة ]]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CrystalHub_Fixed"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- المستطيل الأسود الشفاف (التوأم اللي في الصورة)
local MainBar = Instance.new("Frame")
MainBar.Name = "MainBar"
MainBar.Size = UDim2.new(0, 320, 0, 40) 
MainBar.Position = UDim2.new(0.5, -160, 0.02, 0) -- ثابت في أعلى المنتصف
MainBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainBar.BackgroundTransparency = 0.4 
MainBar.BorderSizePixel = 0
MainBar.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 15)
UICorner.Parent = MainBar

-- نص المعلومات (Crystal Hub | FPS | MS)
local InfoLabel = Instance.new("TextLabel")
InfoLabel.Size = UDim2.new(1, 0, 1, 0)
InfoLabel.BackgroundTransparency = 1
InfoLabel.TextColor3 = Color3.fromRGB(0, 180, 255) -- أزرق زاهي
InfoLabel.TextSize = 15
InfoLabel.Font = Enum.Font.GothamBold
InfoLabel.Text = "Crystal Hub | Calculating..."
InfoLabel.Parent = MainBar

-- [[ نظام الـ Overhead (السرعة فوقك والأسماء فوق الخصم) ]]
local function CreateOverhead(targetPlayer)
    local function apply(char)
        local head = char:WaitForChild("Head", 10)
        if not head then return end
        
        if head:FindFirstChild("CrystalTag") then head.CrystalTag:Destroy() end

        local billboard = Instance.new("BillboardGui")
        billboard.Name = "CrystalTag"
        billboard.Size = UDim2.new(0, 200, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 3.5, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = head

        local topLabel = Instance.new("TextLabel")
        topLabel.Size = UDim2.new(1, 0, 0.4, 0)
        topLabel.BackgroundTransparency = 1
        topLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        topLabel.TextScaled = true
        topLabel.Font = Enum.Font.GothamBold
        topLabel.Parent = billboard
        
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

for _, p in pairs(game.Players:GetPlayers()) do CreateOverhead(p) end
game.Players.PlayerAdded:Connect(CreateOverhead)

-- [[ تحديث العدادات ]]
task.spawn(function()
    while task.wait(0.5) do
        local fps = math.floor(1 / (RunService.RenderStepped:Wait() + 0.0001))
        local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        InfoLabel.Text = "Crystal Hub | " .. fps .. " FPS | " .. ping .. " MS"
    end
end)
end)
