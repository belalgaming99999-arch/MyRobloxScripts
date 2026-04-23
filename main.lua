local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Player = Players.LocalPlayer

local CrystalPurple = Color3.fromRGB(120, 0, 255) 
local PureBlack = Color3.fromRGB(0, 0, 0)
local PureWhite = Color3.fromRGB(255, 255, 255)

-- تنظيف أي نسخة قديمة فوراً
local UI_NAME = "Crystal_Final_UI"
local function CleanUI()
    pcall(function()
        if game:GetService("CoreGui"):FindFirstChild(UI_NAME) then game:GetService("CoreGui")[UI_NAME]:Destroy() end
        if Player:WaitForChild("PlayerGui"):FindFirstChild(UI_NAME) then Player.PlayerGui[UI_NAME]:Destroy() end
    end)
end
CleanUI()

-- إنشاء الواجهة الأساسية
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = UI_NAME
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 999999

-- محاولة التثبيت في CoreGui وإذا فشل يثبت في PlayerGui لضمان الظهور
local success, err = pcall(function()
    ScreenGui.Parent = game:GetService("CoreGui")
end)
if not success then
    ScreenGui.Parent = Player:WaitForChild("PlayerGui")
end

-- [ اللوحة المركزية - FPS & Stats ]
local MainContainer = Instance.new("Frame", ScreenGui)
MainContainer.Size = UDim2.new(0, 250, 0, 60)
MainContainer.Position = UDim2.new(0.5, -125, 0.18, 0) 
MainContainer.BackgroundTransparency = 1

local TopBar = Instance.new("Frame", MainContainer)
TopBar.Size = UDim2.new(1, 0, 0, 34)
TopBar.BackgroundColor3 = PureBlack; TopBar.BackgroundTransparency = 0.15
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 15)
Instance.new("UIStroke", TopBar).Color = CrystalPurple

local InfoLabel = Instance.new("TextLabel", TopBar)
InfoLabel.Size = UDim2.new(1, 0, 1, 0); InfoLabel.BackgroundTransparency = 1
InfoLabel.TextColor3 = CrystalPurple; InfoLabel.TextSize = 14; InfoLabel.Font = Enum.Font.GothamBold
InfoLabel.Text = "Crystal Hub | FPS .. | MS .."

-- [ زر الأيقونة الجانبي ]
local SideButton = Instance.new("TextButton", ScreenGui)
SideButton.Size = UDim2.new(0, 60, 0, 60)
SideButton.Position = UDim2.new(1, -75, 0.30, 0) -- الموقع اللي طلبته (مرفوع سنة)
SideButton.BackgroundColor3 = CrystalPurple
SideButton.Text = ""
Instance.new("UICorner", SideButton).CornerRadius = UDim.new(0, 15)

-- [ المنيو الجانبي ]
local SideMenu = Instance.new("Frame", ScreenGui)
SideMenu.Size = UDim2.new(0, 160, 0, 250)
SideMenu.Position = UDim2.new(-0.7, 0, 0.35, 0) -- يبدأ مخفي جهة اليسار
SideMenu.BackgroundColor3 = PureBlack; SideMenu.BackgroundTransparency = 0.1
Instance.new("UICorner", SideMenu).CornerRadius = UDim.new(0, 15)
local MenuStroke = Instance.new("UIStroke", SideMenu)
MenuStroke.Color = CrystalPurple; MenuStroke.Thickness = 2

-- ترتيب الأزرار داخل المنيو
local UIList = Instance.new("UIListLayout", SideMenu)
UIList.Padding = UDim.new(0, 10); UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center; UIList.VerticalAlignment = Enum.VerticalAlignment.Top
Instance.new("UIPadding", SideMenu).PaddingTop = UDim.new(0, 15)

-- [[ زر ESP Player الجديد ]]
local EspBtn = Instance.new("TextButton", SideMenu)
EspBtn.Size = UDim2.new(0, 140, 0, 45)
EspBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
EspBtn.Text = "Esp Player"
EspBtn.TextColor3 = PureWhite; EspBtn.TextSize = 14; EspBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", EspBtn).CornerRadius = UDim.new(0, 10)
local EspStroke = Instance.new("UIStroke", EspBtn)
EspStroke.Color = CrystalPurple; EspStroke.Thickness = 1.5

-- تفعيل/إيقاف الـ ESP
local espActive = false
EspBtn.MouseButton1Click:Connect(function()
    espActive = not espActive
    EspBtn.BackgroundColor3 = espActive and CrystalPurple or Color3.fromRGB(30, 30, 30)
end)

-- فتح وإغلاق المنيو
local menuOpen = false
SideButton.MouseButton1Click:Connect(function()
    menuOpen = not menuOpen
    local targetX = menuOpen and 0.02 or -0.7
    TweenService:Create(SideMenu, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(targetX, 0, 0.35, 0)}):Play()
end)

-- [[ نظام الـ Speed بالعلامة العشرية 0.0 ]]
local function CreateTag(p)
    p.CharacterAdded:Connect(function(char)
        local head = char:WaitForChild("Head", 10)
        local bill = Instance.new("BillboardGui", head)
        bill.Name = "CrystalTag"; bill.Size = UDim2.new(0, 120, 0, 40)
        bill.StudsOffset = Vector3.new(0, 4.2, 0) -- الموقع اللي طلبته (مرفوع سنة)
        bill.AlwaysOnTop = true
        
        local label = Instance.new("TextLabel", bill)
        label.Size = UDim2.new(1, 0, 1, 0); label.BackgroundTransparency = 1; label.TextColor3 = PureWhite
        label.TextSize = 14; label.Font = Enum.Font.GothamBold; label.TextStrokeTransparency = 0.5

        RunService.RenderStepped:Connect(function()
            if char:FindFirstChild("HumanoidRootPart") then
                if p == Player then
                    label.Text = "Speed: " .. string.format("%.1f", char.HumanoidRootPart.Velocity.Magnitude)
                else
                    label.Text = p.DisplayName
                end
            end
        end)
    end)
end

-- تفعيل النظام فوراً للجميع ولنفسك
for _, v in pairs(Players:GetPlayers()) do CreateTag(v) if v.Character then CreateTag(v) end end
Players.PlayerAdded:Connect(CreateTag)

-- تحديث الـ FPS والـ MS باستمرار
task.spawn(function()
    while true do
        local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        local fps = math.floor(1 / (RunService.RenderStepped:Wait()))
        InfoLabel.Text = string.format("Crystal Hub | FPS %d | MS %d", fps, ping)
        task.wait(0.5)
    end
end)
