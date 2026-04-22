-- [[ Crystal Hub - Universal & Instant UI ]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local Player = Players.LocalPlayer

-- وظيفة الوصول السريع للـ UI
local function GetGuiParent()
    local success, coreGui = pcall(function() return game:GetService("CoreGui") end)
    if success and coreGui:FindFirstChild("RobloxGui") then
        return coreGui
    end
    return Player:WaitForChild("PlayerGui")
end

local TargetGui = GetGuiParent()

-- حذف أي نسخة قديمة
if TargetGui:FindFirstChild("CrystalHub_Final") then 
    TargetGui.CrystalHub_Final:Destroy() 
end

-- [[ إنشاء الشاشة ]]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CrystalHub_Final"
ScreenGui.Parent = TargetGui
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999999

-- [[ 1. القائمة العلوية (تظهر فوراً) ]]
local MainBar = Instance.new("Frame")
MainBar.Name = "MainBar"
MainBar.Size = UDim2.new(0, 260, 0, 32) 
MainBar.Position = UDim2.new(0.5, -130, 0.02, 0) 
MainBar.BackgroundColor3 = Color3.fromRGB(10, 10, 10) 
MainBar.BackgroundTransparency = 0.45 
MainBar.BorderSizePixel = 0
MainBar.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 10)
Corner.Parent = MainBar

-- حواف زرقاء ثقيلة للمستطيل
local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(0, 175, 255)
MainStroke.Thickness = 2
MainStroke.Parent = MainBar

-- نص المعلومات (Crystal Hub)
local InfoLabel = Instance.new("TextLabel")
InfoLabel.Size = UDim2.new(1, 0, 1, 0)
InfoLabel.BackgroundTransparency = 1
InfoLabel.TextColor3 = Color3.fromRGB(0, 175, 255) 
InfoLabel.TextSize = 14
InfoLabel.Font = Enum.Font.GothamBold
InfoLabel.Text = "Crystal Hub | Loading..."
InfoLabel.Parent = MainBar

-- حواف سوداء للكتابة (Outline)
local TextOutline = Instance.new("UIStroke")
TextOutline.Thickness = 1
TextOutline.Color = Color3.fromRGB(0, 0, 0)
TextOutline.Parent = InfoLabel

-- [[ 2. نظام الـ Overhead (يشتغل لما الشخصية تظهر) ]]
local function CreateOverhead(targetPlayer)
    local function apply(char)
        -- ننتظر الرأس والجذع لكن السكربت شغال في الخلفية
        local head = char:WaitForChild("Head", 10)
        local root = char:WaitForChild("HumanoidRootPart", 10)
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
        Instance.new("UIStroke", topLabel).Thickness = 1
        topLabel.Parent = billboard
        
        local discordLabel = Instance.new("TextLabel")
        discordLabel.Position = UDim2.new(0, 0, 0.45, 0)
        discordLabel.Size = UDim2.new(1, 0, 0.5, 0)
        discordLabel.BackgroundTransparency = 1
        discordLabel.TextColor3 = Color3.fromRGB(0, 175, 255)
        discordLabel.Text = "discord.gg/VHUSrhjq9u"
        discordLabel.TextSize = 10
        discordLabel.Font = Enum.Font.GothamBold
        Instance.new("UIStroke", discordLabel).Thickness = 1
        discordLabel.Parent = billboard

        task.spawn(function()
            while char:IsDescendantOf(workspace) and root do
                local vel = root.Velocity
                local speed = math.floor(Vector3.new(vel.X, 0, vel.Z).Magnitude)
                if targetPlayer == Player then
                    topLabel.Text = "Speed: " .. speed
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

-- تشغيل الـ Overhead للكل
for _, p in pairs(Players:GetPlayers()) do CreateOverhead(p) end
Players.PlayerAdded:Connect(CreateOverhead)

-- [[ 3. تحديث العدادات (FPS / MS) ]]
task.spawn(function()
    while task.wait(0.5) do
        local fps = math.floor(1 / (RunService.RenderStepped:Wait() + 0.0001))
        local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        InfoLabel.Text = "Crystal Hub | " .. fps .. " FPS | " .. ping .. " MS"
    end
end)

print("Crystal Hub v2 Loaded!")
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
