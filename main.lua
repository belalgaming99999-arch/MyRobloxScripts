-- [[ Crystal Hub - Anti-AutoClipboard Edition ]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local TweenService = game:GetService("TweenService")
local Player = Players.LocalPlayer

-- [[ 1. نظام الحماية الذكي ]]
-- هذا الجزء يمنع السكربت من العمل إذا تم استدعاؤه بشكل عشوائي من الحافظة
if _G.CrystalLoaded then return end

-- وظيفة للتحقق إذا كان السكربت يعمل من الـ Editor (المحرر) وليس الحافظة فقط
local function ShouldRun()
    -- إذا كان السكربت يتم تشغيله وهو مخزن في الحافظة كـ "نص فقط" دون وضعه في المحقن، سيتجاهله
    -- يعتمد هذا الفحص على وجود متغيرات البيئة الخاصة بالمحقن
    if not (getgenv or debug or Drawing) then 
        return false 
    end
    return true
end

if not ShouldRun() then return end
_G.CrystalLoaded = true

-- إعدادات الألوان والشفافية
local DeepPurple = Color3.fromRGB(120, 0, 255)
local TextColor = Color3.fromRGB(150, 50, 255) 
local PureBlack = Color3.fromRGB(0, 0, 0)
local RightTrans = 0.15 
local LeftTrans = 0.5   

-- تنظيف الواجهة القديمة
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

-- [[ 2. القائمة العلوية ]]
local MainBar = Instance.new("Frame", ScreenGui)
MainBar.Size = UDim2.new(0, 250, 0, 34)
MainBar.Position = UDim2.new(0.5, -125, -0.1, 0) 
MainBar.BackgroundColor3 = PureBlack
MainBar.BackgroundTransparency = RightTrans
MainBar.BorderSizePixel = 0
Instance.new("UICorner", MainBar).CornerRadius = UDim.new(0, 15)
local MainStroke = Instance.new("UIStroke", MainBar)
MainStroke.Color = DeepPurple
MainStroke.Thickness = 1.2

local InfoLabel = Instance.new("TextLabel", MainBar)
InfoLabel.Size = UDim2.new(0.7, 0, 0.6, 0) 
InfoLabel.Position = UDim2.new(0.15, 0, 0.2, 0)
InfoLabel.BackgroundTransparency = 1
InfoLabel.TextColor3 = TextColor 
InfoLabel.TextScaled = true 
InfoLabel.Font = Enum.Font.GothamBold
InfoLabel.Text = "Crystal Hub | Fps -- | Ms --"
local TextStroke = Instance.new("UIStroke", InfoLabel)
TextStroke.Thickness = 0.25; TextStroke.Color = PureBlack; TextStroke.Transparency = 0.3

-- [[ 3. القائمة السفلى ]]
local BottomBar = Instance.new("Frame", ScreenGui)
BottomBar.Size = UDim2.new(0, 250, 0, 14)
BottomBar.Position = UDim2.new(0.5, -125, -0.1, 40)
BottomBar.BackgroundTransparency = 1

local function CreatePart(pos, size, color, trans, txt)
    local f = Instance.new("Frame", BottomBar)
    f.Size = size; f.Position = pos; f.BackgroundColor3 = color; f.BackgroundTransparency = trans; f.BorderSizePixel = 0
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 20) 
    local t = Instance.new("TextLabel", f)
    t.Size = UDim2.new(1, 0, 0.7, 0); t.Position = UDim2.new(0, 0, 0.15, 0); t.BackgroundTransparency = 1
    t.Text = txt; t.TextColor3 = Color3.fromRGB(255, 255, 255); t.TextScaled = true; t.Font = Enum.Font.GothamBold
    local tS = Instance.new("UIStroke", t)
    tS.Thickness = 0.25; tS.Color = PureBlack; tS.Transparency = 0.3
end

CreatePart(UDim2.new(0, 0, 0, 0), UDim2.new(0.49, 0, 1, 0), PureBlack, LeftTrans, "0%") 
CreatePart(UDim2.new(0.51, 0, 0, 0), UDim2.new(0.49, 0, 1, 0), PureBlack, RightTrans, "7.4") 

-- أنيميشن الدخول
local tweenInfo = TweenInfo.new(0.8, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
TweenService:Create(MainBar, tweenInfo, {Position = UDim2.new(0.5, -125, 0.04, 0)}):Play()
TweenService:Create(BottomBar, tweenInfo, {Position = UDim2.new(0.5, -125, 0.04, 40)}):Play()

-- [[ 4. نظام السرعة ]]
local function SetupTag(p)
    local function addTag(char)
        if not char then return end
        local head = char:WaitForChild("Head", 10)
        local root = char:WaitForChild("HumanoidRootPart", 10)
        if head:FindFirstChild("CrystalTag") then head.CrystalTag:Destroy() end

        local bill = Instance.new("BillboardGui", head)
        bill.Name = "CrystalTag"; bill.Size = UDim2.new(0, 80, 0, 20); bill.StudsOffset = Vector3.new(0, 3.5, 0); bill.AlwaysOnTop = true
        local label = Instance.new("TextLabel", bill)
        label.Size = UDim2.new(1, 0, 1, 0); label.BackgroundTransparency = 1; label.TextColor3 = Color3.fromRGB(255, 255, 255); label.TextScaled = true; label.Font = Enum.Font.GothamBold
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
    InfoLabel.Text = "Crystal Hub | Fps " .. curFps .. " | Ms " .. ping
end)

for _, v in pairs(Players:GetPlayers()) do SetupTag(v) end
Players.PlayerAdded:Connect(SetupTag)

-- [[ حماية نهائية عند مسح السكربت ]]
ScreenGui.AncestryChanged:Connect(function()
    if not ScreenGui:IsDescendantOf(game) then
        _G.CrystalLoaded = nil
    end
end)
        local sStroke = Instance.new("UIStroke", label)
        sStroke.Thickness = 0.25; sStroke.Color = PureBlack; sStroke.Transparency = 0.3

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

RunService.RenderStepped:Connect(function()
    local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
    InfoLabel.Text = "Crystal Hub | Fps " .. curFps .. " | Ms " .. ping
end)

for _, v in pairs(Players:GetPlayers()) do SetupTag(v) end
Players.PlayerAdded:Connect(SetupTag)
        bill.Size = UDim2.new(0, 200, 0, 50)
        bill.StudsOffset = Vector3.new(0, 4.0, 0) 
        bill.AlwaysOnTop = true

        local label = Instance.new("TextLabel", bill)
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextSize = 13
        label.Font = Enum.Font.GothamBold
        
        local sStroke = Instance.new("UIStroke", label)
        sStroke.Thickness = 0.4
        sStroke.Color = PureBlack

        RunService.RenderStepped:Connect(function()
            if char:IsDescendantOf(workspace) and root then
                local speed = root.Velocity.Magnitude
                if p == Player then
                    label.Text = "Speed: " .. string.format("%.1f", speed)
                else
                    label.Text = p.DisplayName
                    label.TextColor3 = TextColor
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

RunService.RenderStepped:Connect(function()
    local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
    InfoLabel.Text = "Crystal Hub | Fps " .. curFps .. " | Ms " .. ping
end)

for _, v in pairs(Players:GetPlayers()) do SetupTag(v) end
Players.PlayerAdded:Connect(SetupTag)
        bill.AlwaysOnTop = true

        local label = Instance.new("TextLabel", bill)
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextSize = 13
        label.Font = Enum.Font.GothamBold
        
        local sStroke = Instance.new("UIStroke", label)
        sStroke.Thickness = 0.4
        sStroke.Color = PureBlack

        RunService.RenderStepped:Connect(function()
            if char:IsDescendantOf(workspace) and root then
                local speed = root.Velocity.Magnitude
                if p == Player then
                    label.Text = "Speed: " .. string.format("%.1f", speed)
                else
                    label.Text = p.DisplayName
                    label.TextColor3 = TextColor
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

RunService.RenderStepped:Connect(function()
    local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
    InfoLabel.Text = "Crystal Hub | Fps " .. curFps .. " | Ms " .. ping
end)

for _, v in pairs(Players:GetPlayers()) do SetupTag(v) end
Players.PlayerAdded:Connect(SetupTag)
        bill.StudsOffset = Vector3.new(0, 4.0, 0) 
        bill.AlwaysOnTop = true

        local label = Instance.new("TextLabel", bill)
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextSize = 13
        label.Font = Enum.Font.GothamBold
        
        local sStroke = Instance.new("UIStroke", label)
        sStroke.Thickness = 0.4
        sStroke.Color = PureBlack

        RunService.RenderStepped:Connect(function()
            if char:IsDescendantOf(workspace) and root then
                local speed = root.Velocity.Magnitude
                if p == Player then
                    label.Text = "Speed: " .. string.format("%.1f", speed)
                else
                    label.Text = p.DisplayName
                    label.TextColor3 = TextColor
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

RunService.RenderStepped:Connect(function()
    local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
    InfoLabel.Text = "Crystal Hub | Fps " .. curFps .. " | Ms " .. ping
end)

for _, v in pairs(Players:GetPlayers()) do SetupTag(v) end
Players.PlayerAdded:Connect(SetupTag)
        local bill = Instance.new("BillboardGui", head)
        bill.Name = "CrystalTag"
        bill.Size = UDim2.new(0, 200, 0, 50)
        bill.StudsOffset = Vector3.new(0, 4.0, 0) 
        bill.AlwaysOnTop = true

        local label = Instance.new("TextLabel", bill)
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextSize = 13
        label.Font = Enum.Font.GothamBold
        
        local sStroke = Instance.new("UIStroke", label)
        sStroke.Thickness = 0.4
        sStroke.Color = PureBlack

        RunService.RenderStepped:Connect(function()
            if char:IsDescendantOf(workspace) and root then
                local speed = root.Velocity.Magnitude
                if p == Player then
                    label.Text = "Speed: " .. string.format("%.1f", speed)
                else
                    label.Text = p.DisplayName
                    label.TextColor3 = TextColor
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
        curFps = math.floor(1 / (RunService.Wait() + 0.0001))
        task.wait(0.5)
    end
end)

RunService.RenderStepped:Connect(function()
    local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
    InfoLabel.Text = "Crystal Hub | Fps " .. curFps .. " | Ms " .. ping
end)

for _, v in pairs(Players:GetPlayers()) do SetupTag(v) end
Players.PlayerAdded:Connect(SetupTag)
