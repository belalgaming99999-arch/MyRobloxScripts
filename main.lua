-- [[ Crystal Hub - Professional Instant Injection ]]

-- منع تكرار السكربت
if _G.CrystalLoaded then return end
_G.CrystalLoaded = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local Player = Players.LocalPlayer

-- اللون الأزرق الكهربائي (نفس الصورة)
local NovaBlue = Color3.fromRGB(0, 160, 255)

local function InitiateHub()
    local PlayerGui = Player:WaitForChild("PlayerGui", 20)
    
    -- تنظيف الشاشة من أي نسخ قديمة
    for _, v in pairs(PlayerGui:GetChildren()) do
        if v.Name == "CrystalHub_Final" then v:Destroy() end
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "CrystalHub_Final"
    ScreenGui.Parent = PlayerGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    ScreenGui.DisplayOrder = 9999

    -- 1. القائمة العلوية (المقاسات والموقع بظبط)
    local MainBar = Instance.new("Frame")
    MainBar.Name = "MainBar"
    MainBar.Size = UDim2.new(0, 240, 0, 32)
    MainBar.Position = UDim2.new(0.5, -120, 0.05, 0)
    MainBar.BackgroundColor3 = Color3.fromRGB(2, 2, 2)
    MainBar.BackgroundTransparency = 0.15
    MainBar.BorderSizePixel = 0
    MainBar.Parent = ScreenGui

    Instance.new("UICorner", MainBar).CornerRadius = UDim.new(0, 10)
    local MainStroke = Instance.new("UIStroke", MainBar)
    MainStroke.Color = NovaBlue
    MainStroke.Thickness = 1.1

    local InfoLabel = Instance.new("TextLabel")
    InfoLabel.Size = UDim2.new(1, 0, 1, 0)
    InfoLabel.BackgroundTransparency = 1
    InfoLabel.TextColor3 = NovaBlue
    InfoLabel.TextSize = 13
    InfoLabel.Font = Enum.Font.GothamBold
    InfoLabel.Text = "Crystal Hub | FPS: -- | MS: --"
    InfoLabel.Parent = MainBar
    Instance.new("UIStroke", InfoLabel).Color = Color3.fromRGB(0,0,0)

    -- 2. الشريط السفلي الرفيع (المقسوم)
    local BottomBar = Instance.new("Frame")
    BottomBar.Name = "BottomBar"
    BottomBar.Size = UDim2.new(0, 240, 0, 6)
    BottomBar.Position = UDim2.new(0.5, -120, 0.05, 36)
    BottomBar.BackgroundTransparency = 1
    BottomBar.Parent = ScreenGui

    local function MakeBar(pos, txt)
        local f = Instance.new("Frame")
        f.Size = UDim2.new(0.48, 0, 1, 0)
        f.Position = pos
        f.BackgroundColor3 = Color3.fromRGB(2, 2, 2)
        f.BackgroundTransparency = 0.15
        f.Parent = BottomBar
        Instance.new("UICorner", f).CornerRadius = UDim.new(1, 0)
        local s = Instance.new("UIStroke", f)
        s.Color = NovaBlue
        s.Thickness = 0.8
        local t = Instance.new("TextLabel", f)
        t.Size = UDim2.new(1, 0, 1, 0)
        t.BackgroundTransparency = 1
        t.Text = txt
        t.TextColor3 = Color3.fromRGB(255, 255, 255)
        t.TextSize = 8
        t.Font = Enum.Font.GothamBold
    end

    MakeBar(UDim2.new(0,0,0,0), "0%")
    MakeBar(UDim2.new(0.52,0,0,0), "7.4")

    -- 3. تحديث البيانات (FPS/Ping) وسرعة 0.0
    task.spawn(function()
        while task.wait(0.5) do
            local fps = math.floor(1 / (RunService.RenderStepped:Wait() + 0.0001))
            local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            InfoLabel.Text = "Crystal Hub | " .. fps .. " FPS | " .. ping .. " MS"
        end
    end)
    
    -- نظام الـ Overhead (الاسم والسرعة)
    local function TrackPlayer(targetPlayer)
        targetPlayer.CharacterAdded:Connect(function(char)
            local head = char:WaitForChild("Head", 10)
            local root = char:WaitForChild("HumanoidRootPart", 10)
            
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
            discordLabel.TextColor3 = NovaBlue
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
        if targetPlayer.Character then pcall(function() TrackPlayer(targetPlayer) end) end
    end

    for _, p in pairs(Players:GetPlayers()) do TrackPlayer(p) end
    Players.PlayerAdded:Connect(TrackPlayer)
end

-- تشغيل السكربت بأسلوب "التعليق المباشر" لضمان الحقن
pcall(InitiateHub)

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
        discordLabel.TextColor3 = NovaElectricBlue
        discordLabel.Text = "discord.gg/VHUSrhjq9u"
        discordLabel.TextSize = 12 
        discordLabel.Font = Enum.Font.GothamBold
        Instance.new("UIStroke", discordLabel).Thickness = 1

        task.spawn(function()
            while char:IsDescendantOf(workspace) and root do
                local speed = root.Velocity.Magnitude
                if targetPlayer == Player then
                    topLabel.Text = "Speed: " .. string.format("%.1f", speed)
                else
                    topLabel.Text = targetPlayer.DisplayName
                end
                task.wait(0.05)
            end
        end)
    end
    if targetPlayer.Character then apply(targetPlayer.Character) end
    targetPlayer.CharacterAdded:Connect(apply)
end

task.spawn(function()
    for _, p in pairs(Players:GetPlayers()) do CreateOverhead(p) end
    Players.PlayerAdded:Connect(CreateOverhead)
end)

task.spawn(function()
    while task.wait(0.5) do
        local fps = math.floor(1 / (RunService.RenderStepped:Wait() + 0.0001))
        local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        InfoLabel.Text = "Crystal Hub | " .. fps .. " FPS | " .. ping .. " MS"
    end
end)
                end
                task.wait(0.05)
            end
        end)
    end
    if targetPlayer.Character then apply(targetPlayer.Character) end
    targetPlayer.CharacterAdded:Connect(apply)
end

-- تشغيل الـ Overhead للكل فوراً
task.spawn(function()
    for _, p in pairs(Players:GetPlayers()) do CreateOverhead(p) end
    Players.PlayerAdded:Connect(CreateOverhead)
end)

-- تحديث العدادات (FPS / MS)
task.spawn(function()
    while task.wait(0.5) do
        local fps = math.floor(1 / (RunService.RenderStepped:Wait() + 0.0001))
        local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        InfoLabel.Text = "Crystal Hub | " .. fps .. " FPS | " .. ping .. " MS"
    end
end)
