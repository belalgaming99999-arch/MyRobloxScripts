-- [[ Crystal Hub - Super Fast & Instant UI ]]

-- 1. رسم القائمة فوراً في أول جزء من الثانية
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local pGui = Player:FindFirstChild("PlayerGui") or Player:WaitForChild("PlayerGui", 5)

-- حذف القديم بسرعة
if pGui:FindFirstChild("CrystalHub_Final") then pGui.CrystalHub_Final:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CrystalHub_Final"
ScreenGui.Parent = pGui
ScreenGui.DisplayOrder = 999999
ScreenGui.ResetOnSpawn = false

local MainBar = Instance.new("Frame")
MainBar.Name = "MainBar"
MainBar.Size = UDim2.new(0, 240, 0, 32) 
MainBar.Position = UDim2.new(0.5, -120, 0.05, 0) -- نازل درجتين زي ما طلبت
MainBar.BackgroundColor3 = Color3.fromRGB(2, 2, 2) -- خلفية أثقل (أسود شبه تام)
MainBar.BackgroundTransparency = 0.15 -- شفافية ضعيفة جداً عشان تكون الخلفية "ثقيلة"
MainBar.BorderSizePixel = 0
MainBar.Parent = ScreenGui

Instance.new("UICorner", MainBar).CornerRadius = UDim.new(0, 10)

local MainStroke = Instance.new("UIStroke", MainBar)
MainStroke.Color = Color3.fromRGB(0, 175, 255)
MainStroke.Thickness = 1.1

local InfoLabel = Instance.new("TextLabel")
InfoLabel.Size = UDim2.new(1, 0, 1, 0)
InfoLabel.BackgroundTransparency = 1
InfoLabel.TextColor3 = Color3.fromRGB(0, 175, 255) 
InfoLabel.TextSize = 13 
InfoLabel.Font = Enum.Font.GothamBold
InfoLabel.Text = "Crystal Hub | Initializing..."
InfoLabel.Parent = MainBar

local TextOutline = Instance.new("UIStroke", InfoLabel)
TextOutline.Thickness = 0.8
TextOutline.Color = Color3.fromRGB(0, 0, 0)

-- 2. تشغيل باقي الأنظمة في الخلفية (بدون تأخير الواجهة)
task.spawn(function()
    local RunService = game:GetService("RunService")
    local Stats = game:GetService("Stats")

    -- تحديث العدادات
    task.spawn(function()
        while task.wait(0.5) do
            local fps = math.floor(1 / (RunService.RenderStepped:Wait() + 0.0001))
            local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            InfoLabel.Text = "Crystal Hub | " .. fps .. " FPS | " .. ping .. " MS"
        end
    end)

    -- نظام الـ Overhead
    local function CreateOverhead(targetPlayer)
        targetPlayer.CharacterAdded:Connect(function(char)
            local head = char:WaitForChild("Head", 10)
            local root = char:WaitForChild("HumanoidRootPart", 10)
            if not head or not root then return end
            
            local billboard = Instance.new("BillboardGui", head)
            billboard.Name = "CrystalTag"
            billboard.Size = UDim2.new(0, 200, 0, 60)
            billboard.StudsOffset = Vector3.new(0, 3.8, 0)
            billboard.AlwaysOnTop = true

            local topLabel = Instance.new("TextLabel", billboard)
            topLabel.Size = UDim2.new(1, 0, 0.5, 0)
            topLabel.BackgroundTransparency = 1
            topLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            topLabel.TextSize = 16 
            topLabel.Font = Enum.Font.GothamBold
            Instance.new("UIStroke", topLabel).Thickness = 1.2
            
            local discordLabel = Instance.new("TextLabel", billboard)
            discordLabel.Position = UDim2.new(0, 0, 0.5, 0)
            discordLabel.Size = UDim2.new(1, 0, 0.4, 0)
            discordLabel.BackgroundTransparency = 1
            discordLabel.TextColor3 = Color3.fromRGB(0, 175, 255)
            discordLabel.Text = "discord.gg/VHUSrhjq9u"
            discordLabel.TextSize = 12 
            discordLabel.Font = Enum.Font.GothamBold
            Instance.new("UIStroke", discordLabel).Thickness = 1

            task.spawn(function()
                while char:IsDescendantOf(workspace) do
                    local speed = root.Velocity.Magnitude
                    if targetPlayer == Player then
                        topLabel.Text = "Speed: " .. string.format("%.1f", speed)
                    else
                        topLabel.Text = targetPlayer.DisplayName
                    end
                    task.wait(0.05)
                end
            end)
        end)
        if targetPlayer.Character then -- تشغيل فوري لو الشخصية موجودة
            pcall(function() targetPlayer.CharacterAdded:Fire(targetPlayer.Character) end)
        end
    end

    for _, p in pairs(Players:GetPlayers()) do CreateOverhead(p) end
    Players.PlayerAdded:Connect(CreateOverhead)
end)
