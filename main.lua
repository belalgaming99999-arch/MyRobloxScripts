-- [[ Crystal Hub - Dual Smooth Menus (Up & Right) ]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local TweenService = game:GetService("TweenService")
local Player = Players.LocalPlayer

-- منع التكرار
if _G.CrystalLoaded then _G.CrystalLoaded = nil end
_G.CrystalLoaded = true

-- إعدادات الألوان والشفافية (الثيم النوفا الجديد)
local NovaBlue = Color3.fromRGB(0, 102, 255) -- نفس لون زر النط
local TextColor = Color3.fromRGB(0, 150, 255) 
local PureBlack = Color3.fromRGB(0, 0, 0)
local DarkTrans = 0.2 -- تعتيم القائمة الجانبية

-- تنظيف الواجهة القديمة
local function Clean()
    local targetUI = "Crystal_Final_UI"
    local s, core = pcall(function() return game:GetService("CoreGui") end)
    if s and core:FindFirstChild(targetUI) then core[targetUI]:Destroy() end
    if Player.PlayerGui:FindFirstChild(targetUI) then Player.PlayerGui[targetUI]:Destroy() end
end
Clean()

local TargetContainer = game:GetService("CoreGui") or Player:WaitForChild("PlayerGui")
local ScreenGui = Instance.new("ScreenGui", TargetContainer)
ScreenGui.Name = "Crystal_Final_UI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true -- لضمان الموقع الدقيق فوق زر النط

-- [[ 1. القائمة الأصلية (الزرقاء) ]]
local TopBar = Instance.new("Frame", ScreenGui)
TopBar.Size = UDim2.new(0, 250, 0, 34)
-- تبدأ مخفية فوق الشاشة
TopBar.Position = UDim2.new(0.5, -125, -0.2, 0) 
TopBar.BackgroundColor3 = PureBlack
TopBar.BackgroundTransparency = 0.3
TopBar.BorderSizePixel = 0
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 15)

local TopInfo = Instance.new("TextLabel", TopBar)
TopInfo.Size = UDim2.new(1, 0, 1, 0)
TopInfo.BackgroundTransparency = 1
TopInfo.TextColor3 = Color3.fromRGB(0, 170, 255)
TopInfo.TextSize = 14
TopInfo.Font = Enum.Font.GothamBold
TopInfo.Text = "Crystal Hub  |  Fps --  |  Ms --"
Instance.new("UIStroke", TopInfo).Color = PureBlack

local CornerBottom = Instance.new("Frame", ScreenGui)
CornerBottom.Size = UDim2.new(0, 250, 0, 14)
-- تبدأ مخفية فوق الشاشة
CornerBottom.Position = UDim2.new(0.5, -125, -0.2, 40)
CornerBottom.BackgroundTransparency = 1

local function CreatePart(pos, size, color, trans, txt)
    local f = Instance.new("Frame", CornerBottom)
    f.Size = size; f.Position = pos; f.BackgroundColor3 = color; f.BackgroundTransparency = trans; f.BorderSizePixel = 0
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 20) 
    local t = Instance.new("TextLabel", f)
    t.Size = UDim2.new(1, 0, 1, 0); t.BackgroundTransparency = 1
    t.Text = txt; t.TextColor3 = Color3.fromRGB(255, 255, 255); t.TextSize = 10; t.Font = Enum.Font.GothamBold
end

CreatePart(UDim2.new(0, 0, 0, 0), UDim2.new(0.49, 0, 1, 0), PureBlack, 0.6, "0%") 
CreatePart(UDim2.new(0.51, 0, 0, 0), UDim2.new(0.49, 0, 1, 0), PureBlack, 0.3, "7.4") 

-- [[ 2. القائمة الجديدة (الجانبية) - تظهر من اليمين للخارج ]]
-- الموقع: يمين الشاشة، فوق زر النط (في الـ IgnoreGuiInset)
local SidePanel = Instance.new("Frame", ScreenGui)
SidePanel.Size = UDim2.new(0, 140, 0, 34) -- حجم ملموم وشيك
-- تبدأ مخفية تماماً خارج الشاشة من اليمين
SidePanel.Position = UDim2.new(1, 10, 0.9, -50) -- X=1 يعني خارج الشاشة
SidePanel.BackgroundColor3 = PureBlack
SidePanel.BackgroundTransparency = DarkTrans
SidePanel.BorderSizePixel = 0
Instance.new("UICorner", SidePanel).CornerRadius = UDim.new(0, 15)

local SideStroke = Instance.new("UIStroke", SidePanel)
SideStroke.Color = NovaBlue -- حواف زرقاء متناسقة مع زر النط
SideStroke.Thickness = 1.0

-- النصوص داخل القائمة الجانبية (FPS و MS)
local SideInfo = Instance.new("TextLabel", SidePanel)
SideInfo.Size = UDim2.new(0.9, 0, 0.8, 0)
SideInfo.Position = UDim2.new(0.05, 0, 0.1, 0)
SideInfo.BackgroundTransparency = 1
SideInfo.TextColor3 = Color3.fromRGB(230, 230, 230)
SideInfo.TextSize = 12
SideInfo.Font = Enum.Font.GothamBold
SideInfo.Text = "FPS --  |  MS --"
SideInfo.Parent = SidePanel

-- [[ أنيميشن الدخول السلس لكلا القائمتين معاً ]]
-- التوقيت: 0.7 ثانية، سريع وسلس (Quart Out)
local tweenInfo = TweenInfo.new(0.7, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

-- زحلقة القائمة الأصلية من فوق لتحت
TweenService:Create(TopBar, tweenInfo, {Position = UDim2.new(0.5, -125, 0.04, 0)}):Play()
TweenService:Create(CornerBottom, tweenInfo, {Position = UDim2.new(0.5, -125, 0.04, 40)}):Play()

-- زحلقة القائمة الجانبية من اليمين لليسار (تستقر في مكانها فوق زر النط)
TweenService:Create(SidePanel, tweenInfo, {Position = UDim2.new(1, -150, 0.9, -50)}):Play() -- X=1-150 يعني داخل الشاشة

-- [[ 3. نظام السرعة ]]
local function SetupTag(p)
    local function addTag(char)
        if not char then return end
        local head = char:WaitForChild("Head", 10)
        local root = char:WaitForChild("HumanoidRootPart", 10)
        if head:FindFirstChild("CrystalTag") then head.CrystalTag:Destroy() end

        local bill = Instance.new("BillboardGui", head)
        bill.Name = "CrystalTag"; bill.Size = UDim2.new(0, 80, 0, 20)
        bill.StudsOffset = Vector3.new(0, 3.5, 0); bill.AlwaysOnTop = true

        local label = Instance.new("TextLabel", bill)
        label.Size = UDim2.new(1, 0, 1, 0); label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(255, 255, 255); label.TextSize = 11; label.Font = Enum.Font.GothamBold
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

-- العدادات وتحديث البيانات
local curFps = 0
task.spawn(function()
    while true do
        curFps = math.floor(1 / (RunService.RenderStepped:Wait() + 0.0001))
        task.wait(0.5)
    end
end)

RunService.RenderStepped:Connect(function()
    local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
    -- تحديث القائمة الأصلية
    TopInfo.Text = string.format("Crystal Hub  |  Fps %d  |  Ms %d", curFps, ping)
    -- تحديث القائمة الجانبية الجديدة
    SideInfo.Text = string.format("FPS %d  |  MS %d", curFps, ping)
end)

for _, v in pairs(Players:GetPlayers()) do SetupTag(v) end
Players.PlayerAdded:Connect(SetupTag)
