-- [[ Crystal Hub - Universal Multi-Executor Version ]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local Player = Players.LocalPlayer

-- وظيفة ذكية لاختيار أفضل مكان للظهور بناءً على نوع المشغل
local function GetParent()
    local success, coreGui = pcall(function() return game:GetService("CoreGui") end)
    if success and coreGui:FindFirstChild("RobloxGui") then
        return coreGui
    else
        return Player:WaitForChild("PlayerGui")
    end
end

local TargetParent = GetParent()

-- حذف أي نسخة قديمة فوراً
if TargetParent:FindFirstChild("CrystalHub_Final") then 
    TargetParent.CrystalHub_Final:Destroy() 
end

-- [[ إنشاء الواجهة فوراً ]]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CrystalHub_Final"
ScreenGui.Parent = TargetParent
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999999

-- المستطيل (المقاسات المعدلة بظبط: عرض 240، موقع 0.05، خلفية ثقيلة)
local MainBar = Instance.new("Frame")
MainBar.Name = "MainBar"
MainBar.Size = UDim2.new(0, 240, 0, 32) 
MainBar.Position = UDim2.new(0.5, -120, 0.05, 0) -- نازل درجتين
MainBar.BackgroundColor3 = Color3.fromRGB(2, 2, 2) 
MainBar.BackgroundTransparency = 0.15 -- خلفية ثقيلة فخمة
MainBar.BorderSizePixel = 0
MainBar.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 10)
Corner.Parent = MainBar

-- حواف زرقاء خفيفة (درجة واحدة)
local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(0, 175, 255)
MainStroke.Thickness = 1.1 
MainStroke.Parent = MainBar

local InfoLabel = Instance.new("TextLabel")
InfoLabel.Size = UDim2.new(1, 0, 1, 0)
InfoLabel.BackgroundTransparency = 1
InfoLabel.TextColor3 = Color3.fromRGB(0, 175, 255) 
InfoLabel.TextSize = 13 
InfoLabel.Font = Enum.Font.GothamBold
InfoLabel.Text = "Crystal Hub | FPS: -- | MS: --"
InfoLabel.Parent = MainBar

local TextOutline = Instance.new("UIStroke")
TextOutline.Thickness = 0.8
TextOutline.Color = Color3.fromRGB(0, 0, 0)
TextOutline.Parent = InfoLabel

-- [[ نظام الـ Overhead وسرعة 0.0 ]]
local function CreateOverhead(targetPlayer)
    local function apply(char)
        local head = char:WaitForChild("Head", 15)
        local root = char:WaitForChild("HumanoidRootPart", 15)
        if not head or not root then return end
        
        if head:FindFirstChild("CrystalTag") then head.CrystalTag:Destroy() end

        local billboard = Instance.new("BillboardGui")
        billboard.Name = "CrystalTag"
        billboard.Size = UDim2.new(0, 200, 0, 60)
        billboard.StudsOffset = Vector3.new(0, 3.8, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = head

        local topLabel = Instance.new("TextLabel")
        topLabel.Size = UDim2.new(1, 0, 0.5, 0)
        topLabel.BackgroundTransparency = 1
        topLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        topLabel.TextSize = 16 -- تكبير كلمة سبيد
        topLabel.Font = Enum.Font.GothamBold
        Instance.new("UIStroke", topLabel).Thickness = 1.2
        topLabel.Parent = billboard
        
        local discordLabel = Instance.new("TextLabel")
        discordLabel.Position = UDim2.new(0, 0, 0.5, 0)
        discordLabel.Size = UDim2.new(1, 0, 0.4, 0)
        discordLabel.BackgroundTransparency = 1
        discordLabel.TextColor3 = Color3.fromRGB(0, 175, 255)
        discordLabel.Text = "discord.gg/VHUSrhjq9u"
        discordLabel.TextSize = 12 -- تكبير رابط الديسكورد
        discordLabel.Font = Enum.Font.GothamBold
        Instance.new("UIStroke", discordLabel).Thickness = 1
        discordLabel.Parent = billboard

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
