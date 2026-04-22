-- [[ Crystal Hub - Full Visual Clone with Bottom Bar ]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local Player = Players.LocalPlayer

local function GetSafeParent()
    local success, coreGui = pcall(function() return game:GetService("CoreGui") end)
    if success and coreGui:FindFirstChild("RobloxGui") then return coreGui end
    return Player:WaitForChild("PlayerGui")
end

local TargetParent = GetSafeParent()
if TargetParent:FindFirstChild("CrystalHub_Final") then TargetParent.CrystalHub_Final:Destroy() end

local NovaElectricBlue = Color3.fromRGB(0, 160, 255) 

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CrystalHub_Final"
ScreenGui.Parent = TargetParent
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999999

-- [[ 1. القائمة العلوية الأساسية ]]
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
MainStroke.Color = NovaElectricBlue
MainStroke.Thickness = 1.1 

local InfoLabel = Instance.new("TextLabel")
InfoLabel.Size = UDim2.new(1, 0, 1, 0)
InfoLabel.BackgroundTransparency = 1
InfoLabel.TextColor3 = NovaElectricBlue 
InfoLabel.TextSize = 13 
InfoLabel.Font = Enum.Font.GothamBold
InfoLabel.Text = "Crystal Hub | Loading..."
InfoLabel.Parent = MainBar
Instance.new("UIStroke", InfoLabel).Color = Color3.fromRGB(0,0,0)

-- [[ 2. القائمة الصغيرة الرفيعة (The Bottom Bar) ]]
local BottomBar = Instance.new("Frame")
BottomBar.Name = "BottomBar"
BottomBar.Size = UDim2.new(0, 240, 0, 6) -- رفيعة جداً كما في الصورة
BottomBar.Position = UDim2.new(0.5, -120, 0.05, 36) -- تحت القائمة بـ 4 بكسل بظبط
BottomBar.BackgroundTransparency = 1 -- الشفافية تعتمد على الأجزاء الداخلية
BottomBar.Parent = ScreenGui

-- الجزء الأيسر (0%)
local LeftBar = Instance.new("Frame")
LeftBar.Size = UDim2.new(0.48, 0, 1, 0)
LeftBar.BackgroundColor3 = Color3.fromRGB(2, 2, 2)
LeftBar.BackgroundTransparency = 0.15
LeftBar.BorderSizePixel = 0
LeftBar.Parent = BottomBar
Instance.new("UICorner", LeftBar).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", LeftBar).Color = NovaElectricBlue

local LeftText = Instance.new("TextLabel")
LeftText.Size = UDim2.new(1, 0, 1, 0)
LeftText.BackgroundTransparency = 1
LeftText.Text = "0%"
LeftText.TextColor3 = Color3.fromRGB(255, 255, 255)
LeftText.TextSize = 8
LeftText.Font = Enum.Font.GothamBold
LeftText.Parent = LeftBar

-- الجزء الأيمن (7.4)
local RightBar = Instance.new("Frame")
RightBar.Size = UDim2.new(0.48, 0, 1, 0)
RightBar.Position = UDim2.new(0.52, 0, 0, 0)
RightBar.BackgroundColor3 = Color3.fromRGB(2, 2, 2)
RightBar.BackgroundTransparency = 0.15
RightBar.BorderSizePixel = 0
RightBar.Parent = BottomBar
Instance.new("UICorner", RightBar).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", RightBar).Color = NovaElectricBlue

local RightText = Instance.new("TextLabel")
RightText.Size = UDim2.new(1, 0, 1, 0)
RightText.BackgroundTransparency = 1
RightText.Text = "7.4"
RightText.TextColor3 = Color3.fromRGB(255, 255, 255)
RightText.TextSize = 8
RightText.Font = Enum.Font.GothamBold
RightText.Parent = RightBar

-- [[ 3. نظام الـ Overhead ]]
local function CreateOverhead(targetPlayer)
    local function apply(char)
        local head = char:WaitForChild("Head", 15)
        local root = char:WaitForChild("HumanoidRootPart", 15)
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
