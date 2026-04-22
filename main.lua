-- [[ Crystal Hub - Solo & Instant Execution Edition ]]

-- منع التكرار لضمان السرعة القصوى
if _G.CrystalFinalLoaded then return end
_G.CrystalFinalLoaded = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local Player = Players.LocalPlayer

-- اللون الأزرق الكهربائي (نفس الصورة)
local NovaBlue = Color3.fromRGB(0, 160, 255)

-- [[ المرحلة 1: إيجاد مكان الظهور فوراً ]]
local function GetUIFolder()
    local success, coreGui = pcall(function() return game:GetService("CoreGui") end)
    if success and coreGui:FindFirstChild("RobloxGui") then
        return coreGui
    end
    return Player:WaitForChild("PlayerGui", 10)
end

local TargetParent = GetUIFolder()

-- [[ المرحلة 2: رسم القائمة فوراً (لا تعتمد على أي لاعب) ]]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CrystalHub_Final"
ScreenGui.Parent = TargetParent
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999999

-- القائمة العلوية
local MainBar = Instance.new("Frame")
MainBar.Size = UDim2.new(0, 240, 0, 32)
MainBar.Position = UDim2.new(0.5, -120, 0.05, 0)
MainBar.BackgroundColor3 = Color3.fromRGB(2, 2, 2)
MainBar.BackgroundTransparency = 0.15 -- خلفية ثقيلة
MainBar.BorderSizePixel = 0
MainBar.Parent = ScreenGui

Instance.new("UICorner", MainBar).CornerRadius = UDim.new(0, 10)
local Stroke = Instance.new("UIStroke", MainBar)
Stroke.Color = NovaBlue
Stroke.Thickness = 1.1

local InfoLabel = Instance.new("TextLabel")
InfoLabel.Size = UDim2.new(1, 0, 1, 0)
InfoLabel.BackgroundTransparency = 1
InfoLabel.TextColor3 = NovaBlue
InfoLabel.TextSize = 13
InfoLabel.Font = Enum.Font.GothamBold
InfoLabel.Text = "Crystal Hub | FPS: -- | MS: --"
InfoLabel.Parent = MainBar
Instance.new("UIStroke", InfoLabel).Color = Color3.fromRGB(0,0,0)

-- الشريط السفلي الرفيع (الذي طلبته)
local BottomBar = Instance.new("Frame")
BottomBar.Size = UDim2.new(0, 240, 0, 6)
BottomBar.Position = UDim2.new(0.5, -120, 0.05, 36)
BottomBar.BackgroundTransparency = 1
BottomBar.Parent = ScreenGui

local function CreateMiniBar(pos, txt)
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

CreateMiniBar(UDim2.new(0,0,0,0), "0%")
CreateMiniBar(UDim2.new(0.52,0,0,0), "7.4")

-- [[ المرحلة 3: تشغيل الأنظمة في الخلفية ]]

-- تحديث العدادات (FPS / Ping)
task.spawn(function()
    while task.wait(0.5) do
        local fps = math.floor(1 / (RunService.RenderStepped:Wait() + 0.0001))
        local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        InfoLabel.Text = "Crystal Hub | " .. fps .. " FPS | " .. ping .. " MS"
    end
end)

-- نظام الـ Overhead (السرعة 0.0)
local function SetupOverhead(targetPlayer)
    targetPlayer.CharacterAdded:Connect(function(char)
        local head = char:WaitForChild("Head", 15)
        local root = char:WaitForChild("HumanoidRootPart", 15)
        
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
    end)
    if targetPlayer.Character then 
        -- إذا كانت الشخصية موجودة بالفعل، نفذ الكود فوراً
        task.spawn(function() targetPlayer.CharacterAdded:Fire(targetPlayer.Character) end) 
    end
end

-- تفعيل النظام لك ولأي لاعب يدخل لاحقاً
for _, p in pairs(Players:GetPlayers()) do SetupOverhead(p) end
Players.PlayerAdded:Connect(SetupOverhead)

print("Crystal Hub: Fully Autonomous & Injected.")
