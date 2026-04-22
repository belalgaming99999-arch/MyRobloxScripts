-- [[ Crystal Hub - Heavy Background & Adjusted UI ]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local Player = Players.LocalPlayer

local function GetSafeParent()
    local success, coreGui = pcall(function() return game:GetService("CoreGui") end)
    if success and coreGui:FindFirstChild("RobloxGui") then
        return coreGui
    end
    return Player:WaitForChild("PlayerGui")
end

local TargetGui = GetSafeParent()

if TargetGui:FindFirstChild("CrystalHub_Final") then 
    TargetGui.CrystalHub_Final:Destroy() 
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CrystalHub_Final"
ScreenGui.Parent = TargetGui
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999999

-- 1. القائمة العلوية (عرض أكبر + مكان أنزل + خلفية أثقل)
local MainBar = Instance.new("Frame")
MainBar.Name = "MainBar"
MainBar.Size = UDim2.new(0, 240, 0, 32) -- تكبير العرض درجتين
MainBar.Position = UDim2.new(0.5, -120, 0.05, 0) -- تنزيل القائمة تحت درجتين بظبط
MainBar.BackgroundColor3 = Color3.fromRGB(5, 5, 5) -- أسود أثقل (قريب من القاتم)
MainBar.BackgroundTransparency = 0.25 -- تقليل الشفافية لتصبح الخلفية "ثقيلة"
MainBar.BorderSizePixel = 0
MainBar.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 10)
Corner.Parent = MainBar

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
InfoLabel.Text = "Crystal Hub | Loading..."
InfoLabel.Parent = MainBar

local TextOutline = Instance.new("UIStroke")
TextOutline.Thickness = 0.8
TextOutline.Color = Color3.fromRGB(0, 0, 0)
TextOutline.Parent = InfoLabel

-- 2. نظام الـ Overhead (السرعة 0.0)
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
        topLabel.TextSize = 16 
        topLabel.Font = Enum.Font.GothamBold
        Instance.new("UIStroke", topLabel).Thickness = 1.2
        topLabel.Parent = billboard
        
        local discordLabel = Instance.new("TextLabel")
        discordLabel.Position = UDim2.new(0, 0, 0.5, 0)
        discordLabel.Size = UDim2.new(1, 0, 0.4, 0)
        discordLabel.BackgroundTransparency = 1
        discordLabel.TextColor3 = Color3.fromRGB(0, 175, 255)
        discordLabel.Text = "discord.gg/VHUSrhjq9u"
        discordLabel.TextSize = 12 
        discordLabel.Font = Enum.Font.GothamBold
        Instance.new("UIStroke", discordLabel).Thickness = 1
        discordLabel.Parent = billboard

        task.spawn(function()
            while char:IsDescendantOf(workspace) and root do
                local vel = root.Velocity
                local speed = Vector3.new(vel.X, 0, vel.Z).Magnitude
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

for _, p in pairs(Players:GetPlayers()) do CreateOverhead(p) end
Players.PlayerAdded:Connect(CreateOverhead)

-- 3. تحديث العدادات
task.spawn(function()
    while task.wait(0.5) do
        local fps = math.floor(1 / (RunService.RenderStepped:Wait() + 0.0001))
        local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        InfoLabel.Text = "Crystal Hub | " .. fps .. " FPS | " .. ping .. " MS"
    end
end)
                -- عرض السرعة بصيغة 0.0
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

-- تفعيل الـ Overhead لكل من يدخل (بما فيهم أنت)
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

print("Crystal Hub v3 Loaded - Instant Show Enabled")
