local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Player = Players.LocalPlayer

-- الألوان المعتمدة لـ Crystal Hub
local CrystalPurple = Color3.fromRGB(120, 0, 255)
local PureBlack = Color3.fromRGB(0, 0, 0)
local PureWhite = Color3.fromRGB(255, 255, 255)

-- تنظيف أي نسخة قديمة فوراً عند التشغيل
local function CleanUI()
    local old = game:GetService("CoreGui"):FindFirstChild("Crystal_Final_UI") or Player:WaitForChild("PlayerGui"):FindFirstChild("Crystal_Final_UI")
    if old then old:Destroy() end
end
CleanUI()

-- إنشاء الحاوية (بدون تخزين بيانات)
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
ScreenGui.Name = "Crystal_Final_UI"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999999

-- وظيفة التحريك الحر (Dragging)
local function MakeDraggable(gui)
    local dragging, dragInput, dragStart, startPos
    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = gui.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    gui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- 1. القائمة العلوية (FPS & Ping)
local MainBar = Instance.new("Frame", ScreenGui)
MainBar.Size = UDim2.new(0, 250, 0, 34)
MainBar.Position = UDim2.new(0.5, -125, 0.06, 0)
MainBar.BackgroundColor3 = PureBlack; MainBar.BackgroundTransparency = 0.15
Instance.new("UICorner", MainBar).CornerRadius = UDim.new(0, 15)
Instance.new("UIStroke", MainBar).Color = CrystalPurple

local InfoLabel = Instance.new("TextLabel", MainBar)
InfoLabel.Size = UDim2.new(1, 0, 1, 0); InfoLabel.BackgroundTransparency = 1
InfoLabel.TextColor3 = CrystalPurple; InfoLabel.TextSize = 14; InfoLabel.Font = Enum.Font.GothamBold
InfoLabel.Text = "Crystal Hub | FPS -- | MS --"

-- 2. زر المنيو (الأيقونة)
local SideButton = Instance.new("TextButton", ScreenGui)
SideButton.Size = UDim2.new(0, 46, 0, 46)
SideButton.Position = UDim2.new(1, -65, 0.65, 0)
SideButton.BackgroundColor3 = CrystalPurple; SideButton.Text = ""
Instance.new("UICorner", SideButton).CornerRadius = UDim.new(0, 15)
MakeDraggable(SideButton)

-- رسم الثلاث خطوط للأيقونة
for i=1,3 do
    local l = Instance.new("Frame", SideButton)
    l.Size = UDim2.new(0.5, 0, 0.07, 0)
    l.Position = UDim2.new(0.25, 0, 0.25 + (i*0.15), 0)
    l.BackgroundColor3 = PureWhite; l.BorderSizePixel = 0
    Instance.new("UICorner", l).CornerRadius = UDim.new(0, 2)
end

-- 3. القائمة الجانبية (فارغة للمهام فقط)
local SideMenu = Instance.new("Frame", ScreenGui)
SideMenu.Size = UDim2.new(0, 160, 0, 200)
SideMenu.Position = UDim2.new(-0.7, 0, 0.35, 0)
SideMenu.BackgroundColor3 = PureBlack; SideMenu.BackgroundTransparency = 0.1
Instance.new("UICorner", SideMenu).CornerRadius = UDim.new(0, 15)
Instance.new("UIStroke", SideMenu).Color = CrystalPurple
MakeDraggable(SideMenu)

-- أنيميشن الفتح والإغلاق بسلاسة
local menuOpen = false
SideButton.MouseButton1Click:Connect(function()
    menuOpen = not menuOpen
    local targetX = menuOpen and 0.02 or -0.7
    TweenService:Create(SideMenu, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(targetX, 0, 0.35, 0)}):Play()
end)

-- 4. نظام عرض السرعة (أبيض)
local function SetupSpeed(p, char)
    local head = char:WaitForChild("Head", 10)
    if not head then return end
    local bill = Instance.new("BillboardGui", head)
    bill.Name = "CrystalTag"; bill.Size = UDim2.new(0, 80, 0, 20); bill.StudsOffset = Vector3.new(0, 3, 0); bill.AlwaysOnTop = true
    local label = Instance.new("TextLabel", bill)
    label.Size = UDim2.new(1, 0, 1, 0); label.BackgroundTransparency = 1; label.TextColor3 = PureWhite
    label.TextSize = 11; label.Font = Enum.Font.GothamBold
    
    local c; c = RunService.Heartbeat:Connect(function()
        if not char:IsDescendantOf(workspace) then c:Disconnect() return end
        if char:FindFirstChild("HumanoidRootPart") then
            label.Text = (p == Player) and "Speed: "..string.format("%.1f", char.HumanoidRootPart.Velocity.Magnitude) or p.DisplayName
        end
    end)
end

Players.PlayerAdded:Connect(function(p) p.CharacterAdded:Connect(function(c) SetupSpeed(p, c) end) end)
for _, v in pairs(Players:GetPlayers()) do if v.Character then SetupSpeed(v, v.Character) end end

-- تحديث FPS و Ping بشكل مستمر
task.spawn(function()
    while true do
        local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        local fps = math.floor(1 / (RunService.RenderStepped:Wait()))
        InfoLabel.Text = string.format("Crystal Hub | FPS %d | MS %d", fps, ping)
        task.wait(1)
    end
end)
