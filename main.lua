-- [[ Crystal Hub - Static UI & Smooth Stats ]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local TweenService = game:GetService("TweenService")
local Player = Players.LocalPlayer

-- منع التكرار
if _G.CrystalLoaded then _G.CrystalLoaded = nil end
_G.CrystalLoaded = true

-- إعدادات الألوان
local DeepPurple = Color3.fromRGB(120, 0, 255)
local TextColor = Color3.fromRGB(150, 50, 255) 
local PureBlack = Color3.fromRGB(0, 0, 0)
local RightTrans = 0.15 
local LeftTrans = 0.5   

local function CleanOldUI()
    local targetUI = "Crystal_Final_UI"
    local s, core = pcall(function() return game:GetService("CoreGui") end)
    if s and core:FindFirstChild(targetUI) then core[targetUI]:Destroy() end
    if Player.PlayerGui:FindFirstChild(targetUI) then Player.PlayerGui[targetUI]:Destroy() end
end
CleanOldUI()

local TargetContainer = game:GetService("CoreGui") or Player:WaitForChild("PlayerGui")
local ScreenGui = Instance.new("ScreenGui", TargetContainer)
ScreenGui.Name = "Crystal_Final_UI"
ScreenGui.ResetOnSpawn = false

-- [[ 1. القائمة العلوية - تثبيت الخط ]]
local MainBar = Instance.new("Frame", ScreenGui)
MainBar.Size = UDim2.new(0, 250, 0, 34)
MainBar.Position = UDim2.new(0.5, -125, 0.04, 0) 
MainBar.BackgroundColor3 = PureBlack
MainBar.BackgroundTransparency = RightTrans
MainBar.BorderSizePixel = 0
Instance.new("UICorner", MainBar).CornerRadius = UDim.new(0, 15)
local MainStroke = Instance.new("UIStroke", MainBar)
MainStroke.Color = DeepPurple
MainStroke.Thickness = 1.2

local InfoLabel = Instance.new("TextLabel", MainBar)
InfoLabel.Size = UDim2.new(1, 0, 1, 0) -- ملء المساحة بالكامل
InfoLabel.BackgroundTransparency = 1
InfoLabel.TextColor3 = TextColor 
InfoLabel.TextSize = 14 -- حجم ثابت لمنع الرعشة
InfoLabel.Font = Enum.Font.GothamBold
InfoLabel.TextXAlignment = Enum.TextXAlignment.Center -- تثبيت النص في المنتصف
InfoLabel.Parent = MainBar

local TextStroke = Instance.new("UIStroke", InfoLabel)
TextStroke.Thickness = 0.25; TextStroke.Color = PureBlack; TextStroke.Transparency = 0.3

-- [[ 2. القائمة السفلى ]]
local BottomBar = Instance.new("Frame", ScreenGui)
BottomBar.Size = UDim2.new(0, 250, 0, 14)
BottomBar.Position = UDim2.new(0.5, -125, 0.04, 40)
BottomBar.BackgroundTransparency = 1

local function CreatePart(pos, size, color, trans, txt)
    local f = Instance.new("Frame", BottomBar)
    f.Size = size; f.Position = pos; f.BackgroundColor3 = color; f.BackgroundTransparency = trans; f.BorderSizePixel = 0
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 20) 
    local t = Instance.new("TextLabel", f)
    t.Size = UDim2.new(1, 0, 1, 0); t.BackgroundTransparency = 1
    t.Text = txt; t.TextColor3 = Color3.fromRGB(255, 255, 255); t.TextSize = 10; t.Font = Enum.Font.GothamBold
    local tS = Instance.new("UIStroke", t)
    tS.Thickness = 0.2; tS.Color = PureBlack; tS.Transparency = 0.4
end

CreatePart(UDim2.new(0, 0, 0, 0), UDim2.new(0.49, 0, 1, 0), PureBlack, LeftTrans, "0%") 
CreatePart(UDim2.new(0.51, 0, 0, 0), UDim2.new(0.49, 0, 1, 0), PureBlack, RightTrans, "7.4") 

-- [[ 3. نظام السرعة ]]
local function SetupTag(p)
    local function addTag(char)
        if not char then return end
        local head = char:WaitForChild("Head", 10)
        local root = char:WaitForChild("HumanoidRootPart", 10)
        if head:FindFirstChild("CrystalTag") then head.CrystalTag:Destroy() end

        local bill = Instance.new("BillboardGui", head)
        bill.Name = "CrystalTag"; bill.Size = UDim2.new(0, 100, 0, 25)
        bill.StudsOffset = Vector3.new(0, 3.5, 0); bill.AlwaysOnTop = true

        local label = Instance.new("TextLabel", bill)
        label.Size = UDim2.new(1, 0, 1, 0); label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(255, 255, 255); label.TextSize = 12; label.Font = Enum.Font.GothamBold
        local sStroke = Instance.new("UIStroke", label)
        sStroke.Thickness = 0.2; sStroke.Color = PureBlack; sStroke.Transparency = 0.4

        RunService.RenderStepped:Connect(function()
            if char:IsDescendantOf(workspace) and root then
                local speed = root.Velocity.Magnitude
                if p == Player then
                    label.Text = "Speed: " .. string.format("%.1f", speed)
                else
                    label.Text = p.DisplayName; label.TextColor3 = TextColor
                end
            end
        end)
    end
    if p.Character then addTag(p.Character) end
    p.CharacterAdded:Connect(addTag)
end

-- العدادات
local curFps = 0
task.spawn(function()
    while true do
        curFps = math.floor(1 / (RunService.RenderStepped:Wait() + 0.0001))
        task.wait(0.5)
    end
end)

-- تحديث البيانات بدون تغيير حجم النص
RunService.RenderStepped:Connect(function()
    local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
    -- استخدام string.format لضمان أن المسافات تظل ثابتة نوعاً ما
    InfoLabel.Text = string.format("Crystal Hub  |  Fps %d  |  Ms %d", curFps, ping)
end)

for _, v in pairs(Players:GetPlayers()) do SetupTag(v) end
Players.PlayerAdded:Connect(SetupTag)
