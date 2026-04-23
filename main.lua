-- [[ Crystal Hub - Interactive Side Menu Edition ]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local TweenService = game:GetService("TweenService")
local Player = Players.LocalPlayer

-- منع التكرار
if _G.CrystalLoaded then _G.CrystalLoaded = nil end
_G.CrystalLoaded = true

-- إعدادات الألوان
local NovaBlue = Color3.fromRGB(0, 102, 255) 
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

-- [[ 1. القوائم العلوية الثابتة ]]
local MainBar = Instance.new("Frame", ScreenGui)
MainBar.Size = UDim2.new(0, 250, 0, 34)
MainBar.Position = UDim2.new(0.5, -125, 0.04, 0)
MainBar.BackgroundColor3 = PureBlack
MainBar.BackgroundTransparency = 0.2
Instance.new("UICorner", MainBar).CornerRadius = UDim.new(0, 15)
local MainStroke = Instance.new("UIStroke", MainBar)
MainStroke.Color = NovaBlue
MainStroke.Thickness = 1.2

local InfoLabel = Instance.new("TextLabel", MainBar)
InfoLabel.Size = UDim2.new(1, 0, 1, 0)
InfoLabel.BackgroundTransparency = 1
InfoLabel.TextColor3 = Color3.fromRGB(0, 160, 255)
InfoLabel.TextSize = 14
InfoLabel.Font = Enum.Font.GothamBold
InfoLabel.Text = "Crystal Hub | FPS -- | MS --"

-- [[ 2. نظام القائمة الجانبية التفاعلية ]]

-- الزر الجانبي (فوق زر النط)
local SideButton = Instance.new("TextButton", ScreenGui)
SideButton.Size = UDim2.new(0, 45, 0, 45)
SideButton.Position = UDim2.new(1, -60, 0.9, -110) -- موقعه فوق زر النط
SideButton.BackgroundColor3 = NovaBlue
SideButton.Text = "☰"
SideButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SideButton.TextSize = 25
SideButton.Font = Enum.Font.GothamBold
Instance.new("UICorner", SideButton).CornerRadius = UDim.new(0, 10)

-- القائمة الجانبية (مخفية في البداية)
local SideMenu = Instance.new("Frame", ScreenGui)
SideMenu.Size = UDim2.new(0, 150, 0, 200)
SideMenu.Position = UDim2.new(1, 10, 0.5, -100) -- خارج الشاشة من اليمين
SideMenu.BackgroundColor3 = PureBlack
SideMenu.BackgroundTransparency = 0.1
Instance.new("UICorner", SideMenu).CornerRadius = UDim.new(0, 15)
local MenuStroke = Instance.new("UIStroke", SideMenu)
MenuStroke.Color = NovaBlue
MenuStroke.Thickness = 1.2

-- محتوى القائمة الجانبية (مثال: أزرار سريعة)
local Title = Instance.new("TextLabel", SideMenu)
Title.Size = UDim2.new(1, 0, 0.2, 0)
Title.BackgroundTransparency = 1
Title.Text = "QUICK MENU"
Title.TextColor3 = NovaBlue
Title.TextSize = 12
Title.Font = Enum.Font.GothamBold

-- برمجة فتح وإغلاق القائمة
local menuOpen = false
SideButton.MouseButton1Click:Connect(function()
    local targetPos = menuOpen and UDim2.new(1, 10, 0.5, -100) or UDim2.new(1, -170, 0.5, -100)
    menuOpen = not menuOpen
    
    TweenService:Create(SideMenu, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Position = targetPos
    }):Play()
end)

-- [[ 3. نظام السرعة ]]
local function SetupTag(p)
    local function addTag(char)
        if not char then return end
        local head = char:WaitForChild("Head", 10)
        local root = char:WaitForChild("HumanoidRootPart", 10)
        if head:FindFirstChild("CrystalTag") then head.CrystalTag:Destroy() end

        local bill = Instance.new("BillboardGui", head)
        bill.Name = "CrystalTag"; bill.Size = UDim2.new(0, 80, 0, 20); bill.StudsOffset = Vector3.new(0, 3.5, 0); bill.AlwaysOnTop = true
        local label = Instance.new("TextLabel", bill)
        label.Size = UDim2.new(1, 0, 1, 0); label.BackgroundTransparency = 1; label.TextColor3 = Color3.fromRGB(255, 255, 255); label.TextSize = 11; label.Font = Enum.Font.GothamBold
        Instance.new("UIStroke", label).Thickness = 0.2

        RunService.RenderStepped:Connect(function()
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
