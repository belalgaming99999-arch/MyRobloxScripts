-- [[ Crystal Hub - Ultra Force Show UI ]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local Player = Players.LocalPlayer

-- محاولة إيجاد أفضل مكان لوضع القائمة
local function GetGuiParent()
    local success, coreGui = pcall(function() return game:GetService("CoreGui") end)
    if success and coreGui then
        return coreGui
    else
        return Player:WaitForChild("PlayerGui")
    end
end

local TargetParent = GetGuiParent()

-- حذف أي نسخة قديمة فوراً
if TargetParent:FindFirstChild("CrystalHub_Fixed") then 
    TargetParent.CrystalHub_Fixed:Destroy() 
end

-- [[ إنشاء الواجهة ]]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CrystalHub_Fixed"
ScreenGui.Parent = TargetParent
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999 -- عشان تظهر فوق أي حاجة تانية

-- 1. المستطيل الأساسي (نفس المقاس اللي طلبته)
local MainBar = Instance.new("Frame")
MainBar.Name = "MainBar"
MainBar.Size = UDim2.new(0, 260, 0, 32) 
MainBar.Position = UDim2.new(0.5, -130, 0.02, 0) 
MainBar.BackgroundColor3 = Color3.fromRGB(10, 10, 10) 
MainBar.BackgroundTransparency = 0.45 
MainBar.BorderSizePixel = 0
MainBar.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10) 
UICorner.Parent = MainBar

-- حواف ثقيلة للمستطيل (UIStroke)
local FrameStroke = Instance.new("UIStroke")
FrameStroke.Color = Color3.fromRGB(0, 175, 255)
FrameStroke.Thickness = 2
FrameStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
FrameStroke.Parent = MainBar

-- نص المعلومات (Crystal Hub | FPS | MS)
local InfoLabel = Instance.new("TextLabel")
InfoLabel.Size = UDim2.new(1, 0, 1, 0)
InfoLabel.BackgroundTransparency = 1
InfoLabel.TextColor3 = Color3.fromRGB(0, 175, 255) 
InfoLabel.TextSize = 13 
InfoLabel.Font = Enum.Font.GothamBold
InfoLabel.Text = "Crystal Hub | Loading..."
InfoLabel.Parent = MainBar

-- حواف سوداء للكتابة
local TextStroke = Instance.new("UIStroke")
TextStroke.Color = Color3.fromRGB(0, 0, 0)
TextStroke.Thickness = 1
TextStroke.Parent = InfoLabel

-- [[ 2. نظام الـ Overhead وسرعة Vector3 ]]
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
            while char:IsDescendantOf(workspace) and char:FindFirstChild("HumanoidRootPart") do
                local velocity = char.HumanoidRootPart.Velocity
                local realSpeed = math.floor(Vector3.new(velocity.X, 0, velocity.Z).Magnitude)
                
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
