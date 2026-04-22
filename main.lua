-- [[ Crystal Hub - Clean Edition (No Links + High Overhead) ]]

if _G.CrystalFinalV4 then return end
_G.CrystalFinalV4 = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local Player = Players.LocalPlayer

local NovaBlue = Color3.fromRGB(0, 160, 255)

-- [[ نظام الحقن العالمي ]]
local function GetUIFolder()
    local success, core = pcall(function() return game:GetService("CoreGui") end)
    if success and core:FindFirstChild("RobloxGui") then return core end
    return Player:WaitForChild("PlayerGui", 5)
end

local TargetParent = GetUIFolder()
if TargetParent:FindFirstChild("Crystal_Final_UI") then TargetParent.Crystal_Final_UI:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Crystal_Final_UI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = TargetParent

-- [[ 1. القائمة العلوية (FPS/MS) ]]
local MainBar = Instance.new("Frame")
MainBar.Size = UDim2.new(0, 240, 0, 32)
MainBar.Position = UDim2.new(0.5, -120, 0.05, 0)
MainBar.BackgroundColor3 = Color3.fromRGB(2, 2, 2)
MainBar.BackgroundTransparency = 0.15
MainBar.BorderSizePixel = 0
MainBar.Parent = ScreenGui

Instance.new("UICorner", MainBar).CornerRadius = UDim.new(0, 8)
local MainStroke = Instance.new("UIStroke", MainBar)
MainStroke.Color = NovaBlue
MainStroke.Thickness = 1.2

local InfoLabel = Instance.new("TextLabel")
InfoLabel.Size = UDim2.new(1, 0, 1, 0)
InfoLabel.BackgroundTransparency = 1
InfoLabel.TextColor3 = NovaBlue
InfoLabel.TextSize = 13
InfoLabel.Font = Enum.Font.GothamBold
InfoLabel.Text = "Crystal Hub | FPS: -- | MS: --"
InfoLabel.Parent = MainBar
Instance.new("UIStroke", InfoLabel).Color = Color3.fromRGB(0,0,0)

-- [[ 2. الشريط السفلي (ملتحم - نص فاتح ونص غامق - بدون حواف) ]]
local BottomBar = Instance.new("Frame")
BottomBar.Size = UDim2.new(0, 240, 0, 10)
BottomBar.Position = UDim2.new(0.5, -120, 0.05, 34) -- تحت القائمة مباشرة
BottomBar.BackgroundTransparency = 1
BottomBar.BorderSizePixel = 0
BottomBar.Parent = ScreenGui

-- الجزء الأيسر (0%) - فاتح وبدون حواف
local LeftPart = Instance.new("Frame")
LeftPart.Size = UDim2.new(0.5, 0, 1, 0)
LeftPart.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
LeftPart.BorderSizePixel = 0
LeftPart.Parent = BottomBar
Instance.new("UICorner", LeftPart).CornerRadius = UDim.new(0, 4)

local LeftText = Instance.new("TextLabel")
LeftText.Size = UDim2.new(1, 0, 1, 0)
LeftText.BackgroundTransparency = 1
LeftText.Text = "0%"
LeftText.TextColor3 = Color3.fromRGB(255, 255, 255)
LeftText.TextSize = 9
LeftText.Font = Enum.Font.GothamBold
LeftText.Parent = LeftPart

-- الجزء الأيمن (7.4) - غامق وبدون حواف
local RightPart = Instance.new("Frame")
RightPart.Size = UDim2.new(0.5, 0, 1, 0)
RightPart.Position = UDim2.new(0.5, 0, 0, 0)
RightPart.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
RightPart.BorderSizePixel = 0
RightPart.Parent = BottomBar
Instance.new("UICorner", RightPart).CornerRadius = UDim.new(0, 4)

local RightText = Instance.new("TextLabel")
RightText.Size = UDim2.new(1, 0, 1, 0)
RightText.BackgroundTransparency = 1
RightText.Text = "7.4"
RightText.TextColor3 = Color3.fromRGB(255, 255, 255)
RightText.TextSize = 9
RightText.Font = Enum.Font.GothamBold
RightText.Parent = RightPart

-- [[ 3. نظام السرعة فوق الرأس (بدون روابط + مرفوع للأعلى) ]]
local function SetupOverhead(p)
    local function apply(char)
        local head = char:WaitForChild("Head", 15)
        local root = char:WaitForChild("HumanoidRootPart", 15)
        
        -- حذف أي تاج قديم
        if head:FindFirstChild("CrystalTag") then head.CrystalTag:Destroy() end

        local bill = Instance.new("BillboardGui", head)
        bill.Name = "CrystalTag"
        bill.Size = UDim2.new(0, 200, 0, 50)
        bill.StudsOffset = Vector3.new(0, 4.5, 0) -- رفعناه شوية فوق الدماغ زي ما طلبت
        bill.AlwaysOnTop = true

        local speedLabel = Instance.new("TextLabel", bill)
        speedLabel.Size = UDim2.new(1, 0, 1, 0)
        speedLabel.BackgroundTransparency = 1
        speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        speedLabel.TextSize = 18 -- تكبير الخط ليكون أوضح
        speedLabel.Font = Enum.Font.GothamBold
        local stroke = Instance.new("UIStroke", speedLabel)
        stroke.Thickness = 1.5
        stroke.Color = Color3.fromRGB(0, 0, 0)

        task.spawn(function()
            while char:IsDescendantOf(workspace) and root do
                local vel = root.Velocity
                local speed = Vector3.new(vel.X, 0, vel.Z).Magnitude
                if p == Player then
                    speedLabel.Text = "Speed: " .. string.format("%.1f", speed)
                    speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                else
                    speedLabel.Text = p.DisplayName
                    speedLabel.TextColor3 = NovaBlue -- لون اسم اللاعبين الآخرين بالأزرق
                end
                task.wait(0.05)
            end
        end)
    end
    if p.Character then apply(p.Character) end
    p.CharacterAdded:Connect(apply)
end

-- تفعيل العدادات
task.spawn(function()
    while task.wait(0.5) do
        local fps = math.floor(1 / (RunService.RenderStepped:Wait() + 0.0001))
        local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        InfoLabel.Text = "Crystal Hub | " .. fps .. " FPS | " .. ping .. " MS"
    end
end)

for _, v in pairs(Players:GetPlayers()) do SetupOverhead(v) end
Players.PlayerAdded:Connect(SetupOverhead)

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
