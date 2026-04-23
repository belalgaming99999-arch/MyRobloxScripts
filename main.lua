-- [[ Crystal Hub - Hamburger Menu Fixed Icon Edition ]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local TweenService = game:GetService("TweenService")
local Player = Players.LocalPlayer

-- منع التكرار
if _G.CrystalLoaded then _G.CrystalLoaded = nil end
_G.CrystalLoaded = true

-- إعدادات الألوان (البنفسجي الموحد)
local CrystalPurple = Color3.fromRGB(120, 0, 255)
local LightPurple = Color3.fromRGB(180, 100, 255)
local PureBlack = Color3.fromRGB(0, 0, 0)

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
ScreenGui.IgnoreGuiInset = true

-- [[ 1. القوائم المركزية (علوية وسفلية) ]]
local MainBar = Instance.new("Frame", ScreenGui)
MainBar.Size = UDim2.new(0, 250, 0, 34)
MainBar.Position = UDim2.new(0.5, -125, -0.15, 0) -- تبدأ مخفية فوق
MainBar.BackgroundColor3 = PureBlack
MainBar.BackgroundTransparency = 0.15
Instance.new("UICorner", MainBar).CornerRadius = UDim.new(0, 15)
local MainStroke = Instance.new("UIStroke", MainBar)
MainStroke.Color = CrystalPurple; MainStroke.Thickness = 1.2

local InfoLabel = Instance.new("TextLabel", MainBar)
InfoLabel.Size = UDim2.new(1, 0, 1, 0); InfoLabel.BackgroundTransparency = 1
InfoLabel.TextColor3 = LightPurple; InfoLabel.TextSize = 14; InfoLabel.Font = Enum.Font.GothamBold
InfoLabel.Text = "Crystal Hub | FPS -- | MS --"

local BottomBar = Instance.new("Frame", ScreenGui)
BottomBar.Size = UDim2.new(0, 250, 0, 14)
BottomBar.Position = UDim2.new(0.5, -125, -0.15, 40) -- تبدأ مخفية فوق
BottomBar.BackgroundTransparency = 1

local function CreatePart(pos, size, trans, txt)
    local f = Instance.new("Frame", BottomBar)
    f.Size = size; f.Position = pos; f.BackgroundColor3 = PureBlack; f.BackgroundTransparency = trans; f.BorderSizePixel = 0
    Instance.new("UICorner", f).CornerRadius = UDIm.new(0, 20) 
    local t = Instance.new("TextLabel", f)
    t.Size = UDim2.new(1, 0, 1, 0); t.BackgroundTransparency = 1
    t.Text = txt; t.TextColor3 = Color3.fromRGB(255, 255, 255); t.TextSize = 10; t.Font = Enum.Font.GothamBold
end
CreatePart(UDim2.new(0, 0, 0, 0), UDim2.new(0.49, 0, 1, 0), 0.5, "0%") 
CreatePart(UDim2.new(0.51, 0, 0, 0), UDim2.new(0.49, 0, 1, 0), 0.15, "7.4") 

-- [[ 2. زر المنيو (تعديل الشكل ليكون 3 خطوط متطابقة) ]]
local SideButton = Instance.new("TextButton", ScreenGui)
SideButton.Size = UDim2.new(0, 42, 0, 42)
SideButton.Position = UDim2.new(1.1, 0, 0.9, -110) -- يبدأ مخفي يمين
SideButton.BackgroundColor3 = CrystalPurple
SideButton.Text = "" -- إلغاء النص العادي
Instance.new("UICorner", SideButton).CornerRadius = UDim.new(0, 10)

-- إضافة إطار داخلي للخطوط لضمان التمركز
local LinesFrame = Instance.new("Frame", SideButton)
LinesFrame.Size = UDim2.new(0.6, 0, 0.5, 0)
LinesFrame.Position = UDim2.new(0.2, 0, 0.25, 0)
LinesFrame.BackgroundTransparency = 1

local function CreateLine(posOffset)
    local l = Instance.new("Frame", LinesFrame)
    l.Size = UDim2.new(1, 0, 0.18, 0) -- خطوط سميكة
    l.Position = UDim2.new(0, 0, posOffset, 0)
    l.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    l.BorderSizePixel = 0
    Instance.new("UICorner", l).CornerRadius = UDim.new(0, 2) -- حواف ناعمة للخطوط
end

-- إنشاء الخطوط الثلاثة بالترتيب
CreateLine(0)    -- الخط العلوي
CreateLine(0.38) -- الخط الأوسط (مسافة مثالية)
CreateLine(0.76) -- الخط السفلي

-- [[ 3. القائمة الجانبية (تظهر من الشمال) ]]
local SideMenu = Instance.new("Frame", ScreenGui)
SideMenu.Size = UDim2.new(0, 160, 0, 220)
SideMenu.Position = UDim2.new(-0.2, 0, 0.4, 0) -- تبدأ مخفية أقصى الشمال
SideMenu.BackgroundColor3 = PureBlack
SideMenu.BackgroundTransparency = 0.1
Instance.new("UICorner", SideMenu).CornerRadius = UDim.new(0, 15)
local MenuStroke = Instance.new("UIStroke", SideMenu)
MenuStroke.Color = CrystalPurple; MenuStroke.Thickness = 1.5

-- [[ أنيميشن التشغيل (الإطلاق الموحد) ]]
local introTween = TweenInfo.new(0.8, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
TweenService:Create(MainBar, introTween, {Position = UDim2.new(0.5, -125, 0.04, 0)}):Play()
TweenService:Create(BottomBar, introTween, {Position = UDim2.new(0.5, -125, 0.04, 40)}):Play()
TweenService:Create(SideButton, introTween, {Position = UDim2.new(1, -55, 0.9, -110)}):Play()

-- [[ برمجة فتح المنيو من الشمال ]]
local menuOpen = false
SideButton.MouseButton1Click:Connect(function()
    menuOpen = not menuOpen
    local targetPos = menuOpen and UDim2.new(0.02, 0, 0.4, 0) or UDim2.new(-0.3, 0, 0.4, 0)
    TweenService:Create(SideMenu, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = targetPos}):Play()
end)

-- [[ 4. نظام السرعة ]]
local function SetupTag(p)
    local function addTag(char)
        if not char then return end
        local head = char:WaitForChild("Head", 10); local root = char:WaitForChild("HumanoidRootPart", 10)
        if head:FindFirstChild("CrystalTag") then head.CrystalTag:Destroy() end
        local bill = Instance.new("BillboardGui", head); bill.Name = "CrystalTag"; bill.Size = UDIm2.new(0, 80, 0, 20); bill.StudsOffset = Vector3.new(0, 3.5, 0); bill.AlwaysOnTop = true
        local label = Instance.new("TextLabel", bill); label.Size = UDIm2.new(1, 0, 1, 0); label.BackgroundTransparency = 1; label.TextColor3 = Color3.fromRGB(255, 255, 255); label.TextSize = 11; label.Font = Enum.Font.GothamBold
        RunService.RenderStepped:Connect(function()
            if char:IsDescendantOf(workspace) and root then
                label.Text = p == Player and "Speed: " .. string.format("%.1f", root.Velocity.Magnitude) or p.DisplayName
                if p ~= Player then label.TextColor3 = LightPurple end
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

RunService.RenderStepped:Connect(function()
    local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
    InfoLabel.Text = string.format("Crystal Hub  |  FPS %d  |  MS %d", curFps, ping)
end)

for _, v in pairs(Players:GetPlayers()) do SetupTag(v) end
Players.PlayerAdded:Connect(SetupTag)
            if char:IsDescendantOf(workspace) and root then
                label.Text = p == Player and "Speed: " .. string.format("%.1f", root.Velocity.Magnitude) or p.DisplayName
            end
        end)
    end
    if p.Character then addTag(p.Character) end
    p.CharacterAdded:Connect(addTag)
end

-- تحديث العدادات
local curFps = 0
task.spawn(function()
    while true do
        curFps = math.floor(1 / (RunService.RenderStepped:Wait() + 0.0001))
        task.wait(0.5)
    end
end)

RunService.RenderStepped:Connect(function()
    local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
    InfoLabel.Text = string.format("Crystal Hub  |  FPS %d  |  MS %d", curFps, ping)
end)

for _, v in pairs(Players:GetPlayers()) do SetupTag(v) end
Players.PlayerAdded:Connect(SetupTag)
