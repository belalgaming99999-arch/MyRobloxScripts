-- [[ Crystal Hub - Ultra Clone v2 ]]

local Player = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")

local ParentUI = (game:GetService("CoreGui"):FindFirstChild("RobloxGui") and game:GetService("CoreGui")) or Player:WaitForChild("PlayerGui")

if ParentUI:FindFirstChild("CrystalHub_Fixed") then ParentUI.CrystalHub_Fixed:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CrystalHub_Fixed"
ScreenGui.Parent = ParentUI
ScreenGui.ResetOnSpawn = false

-- [[ 1. القائمة العلوية مع الحواف الملونة ]]
local MainBar = Instance.new("Frame")
MainBar.Name = "MainBar"
MainBar.Size = UDim2.new(0, 260, 0, 32) 
MainBar.Position = UDim2.new(0.5, -130, 0.02, 0) 
MainBar.BackgroundColor3 = Color3.fromRGB(10, 10, 10) 
MainBar.BackgroundTransparency = 0.45 
MainBar.BorderSizePixel = 0 -- نلغي الحواف القديمة
MainBar.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10) 
UICorner.Parent = MainBar

-- إضافة إطار (حواف) بنفس لون الكتابة للمستطيل
local FrameStroke = Instance.new("UIStroke")
FrameStroke.Color = Color3.fromRGB(0, 175, 255) -- نفس اللون الأزرق
FrameStroke.Thickness = 1.8 -- ثقل الحافة
FrameStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
FrameStroke.Parent = MainBar

local InfoLabel = Instance.new("TextLabel")
InfoLabel.Size = UDim2.new(1, 0, 1, 0)
InfoLabel.BackgroundTransparency = 1
InfoLabel.TextColor3 = Color3.fromRGB(0, 175, 255) 
InfoLabel.TextSize = 13 
InfoLabel.Font = Enum.Font.GothamBold
InfoLabel.Text = "Crystal Hub | Loading..."

-- حواف سوداء للكتابة (Outline)
local TextStroke = Instance.new("UIStroke")
TextStroke.Color = Color3.fromRGB(0, 0, 0)
TextStroke.Thickness = 1
TextStroke.Parent = InfoLabel

InfoLabel.Parent = MainBar

-- [[ 2. نظام الـ Overhead وحساب السرعة الحقيقية ]]
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
        
        -- حواف سوداء لكتابة Speed
        local ts1 = Instance.new("UIStroke")
        ts1.Color = Color3.fromRGB(0, 0, 0)
        ts1.Thickness = 1
        ts1.Parent = topLabel
        topLabel.Parent = billboard
        
        local discordLabel = Instance.new("TextLabel")
        discordLabel.Position = UDim2.new(0, 0, 0.45, 0)
        discordLabel.Size = UDim2.new(1, 0, 0.5, 0)
        discordLabel.BackgroundTransparency = 1
        discordLabel.TextColor3 = Color3.fromRGB(0, 175, 255) 
        discordLabel.Text = "discord.gg/VHUSrhjq9u"
        discordLabel.TextSize = 10
        discordLabel.Font = Enum.Font.GothamBold
        
        -- حواف سوداء لكتابة الرابط
        local ts2 = Instance.new("UIStroke")
        ts2.Color = Color3.fromRGB(0, 0, 0)
        ts2.Thickness = 1
        ts2.Parent = discordLabel
        discordLabel.Parent = billboard

        task.spawn(function()
            while char:IsDescendantOf(workspace) do
                -- حساب السرعة الحقيقية بناءً على الحركة وليس الـ WalkSpeed الثابت
                local realSpeed = math.floor(Vector3.new(root.Velocity.X, 0, root.Velocity.Z).Magnitude)
                
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
