-- [[ Crystal Hub - Final Turbo Edition ]] --
-- Integrated with ZAY DUELS Save System & Auto Load

if _G.CrystalLoaded then return end
_G.CrystalLoaded = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local Player = Players.LocalPlayer

-- ============================================================
-- 1. STATE & CONFIG SYSTEM (From ZAY Source)
-- ============================================================
local ConfigFileName = "CrystalHub_Config.json"
_G.Enabled = {
    SpeedBoost = false, AntiRagdoll = false, SpinBot = false,
    AutoSteal = false, Optimizer = false, SpamBat = false,
    Float = false, Aimbot = false
}
_G.Values = {
    BoostSpeed = 30, SpinSpeed = 30, FOV = 70, FloatHeight = 8
}

local function SaveConfig()
    local data = {Enabled = _G.Enabled, Values = _G.Values}
    local ok = false
    if writefile then
        pcall(function() 
            writefile(ConfigFileName, HttpService:JSONEncode(data))
            ok = true 
        end)
    end
    return ok
end

local function LoadConfig()
    pcall(function()
        if readfile and isfile and isfile(ConfigFileName) then
            local data = HttpService:JSONDecode(readfile(ConfigFileName))
            if data then
                _G.Enabled = data.Enabled or _G.Enabled
                _G.Values = data.Values or _G.Values
            end
        end
    end)
end
LoadConfig()

-- ============================================================
-- 2. INSTANT UI SETUP (Turbo Speed)
-- ============================================================
local CrystalPurple = Color3.fromRGB(120, 0, 255)
local DarkColor = Color3.fromRGB(0, 0, 0)

-- تنظيف فوري لأي نسخة قديمة
for _, child in pairs(CoreGui:GetChildren()) do
    if child:IsA("ScreenGui") and child.Name:find("Crystal") then child:Destroy() end
end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "Crystal_Turbo_Final"

-- [Top HUD - Instant Name]
local HUDContainer = Instance.new("Frame", ScreenGui)
HUDContainer.Size = UDim2.new(0, 230, 0, 70); HUDContainer.Position = UDim2.new(0.5, -115, 0.02, 0); HUDContainer.BackgroundTransparency = 1

local TopBar = Instance.new("Frame", HUDContainer)
TopBar.Size = UDim2.new(0.9, 0, 0, 28); TopBar.Position = UDim2.new(0.05, 0, 0, 0); TopBar.BackgroundColor3 = DarkColor; TopBar.BackgroundTransparency = 0.2
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 15)
local TopS = Instance.new("UIStroke", TopBar); TopS.Color = CrystalPurple; TopS.Thickness = 1.5

local Info = Instance.new("TextLabel", TopBar)
Info.Size = UDim2.new(1,0,1,0); Info.BackgroundTransparency = 1; Info.TextColor3 = Color3.fromRGB(255, 255, 255)
Info.Font = Enum.Font.GothamBold; Info.TextSize = 10
-- ظهور فوري للاسم مع البيانات
local f_init = math.floor(1/RunService.RenderStepped:Wait())
Info.Text = "Crystal Hub | FPS " .. f_init .. " | MS " .. math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())

-- ============================================================
-- 3. SIDEBAR MENU & BUTTONS
-- ============================================================
local MainMenu = Instance.new("Frame", ScreenGui)
MainMenu.Size = UDim2.new(0, 180, 0, 320); MainMenu.Position = UDim2.new(-0.7, 0, 0.5, -160) 
MainMenu.BackgroundColor3 = DarkColor; MainMenu.BackgroundTransparency = 0.4
Instance.new("UICorner", MainMenu).CornerRadius = UDim.new(0, 15)
Instance.new("UIStroke", MainMenu).Color = CrystalPurple

local function CreateToggle(name, parent, enabledKey)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, -20, 0, 30); btn.BackgroundColor3 = _G.Enabled[enabledKey] and CrystalPurple or DarkColor
    btn.BackgroundTransparency = _G.Enabled[enabledKey] and 0 or 0.3; btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = name; btn.Font = Enum.Font.GothamBold; btn.TextSize = 10
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 15)
    
    btn.MouseButton1Click:Connect(function()
        _G.Enabled[enabledKey] = not _G.Enabled[enabledKey]
        local active = _G.Enabled[enabledKey]
        TweenService:Create(btn, TweenInfo.new(0.2), {
            BackgroundColor3 = active and CrystalPurple or DarkColor,
            BackgroundTransparency = active and 0 or 0.3
        }):Play()
        -- هنا تضع دالة التشغيل الخاصة بكل ميزة
    end)
    return btn
end

-- الأزرار مرتبة كما في الكود الأصلي
local Grid = Instance.new("Frame", MainMenu)
Grid.Size = UDim2.new(1, -20, 0, 200); Grid.Position = UDim2.new(0, 10, 0, 15); Grid.BackgroundTransparency = 1
local UIGrid = Instance.new("UIGridLayout", Grid); UIGrid.CellSize = UDim2.new(0, 75, 0, 28); UIGrid.CellPadding = UDim2.new(0, 10, 0, 8)

CreateToggle("Speed Boost", Grid, "SpeedBoost")
CreateToggle("Spin Bot", Grid, "SpinBot")
CreateToggle("Anti Ragdoll", Grid, "AntiRagdoll")
CreateToggle("Auto Steal", Grid, "AutoSteal")
CreateToggle("Spam Bat", Grid, "SpamBat")
CreateToggle("Float", Grid, "Float")
CreateToggle("Optimizer", Grid, "Optimizer")
CreateToggle("Aimbot", Grid, "Aimbot")

-- زر حفظ الإعدادات (نفس نظام ZAY)
local SaveBtn = Instance.new("TextButton", MainMenu)
SaveBtn.Size = UDim2.new(1, -20, 0, 35); SaveBtn.Position = UDim2.new(0, 10, 1, -50)
SaveBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20); SaveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SaveBtn.Text = "💾 SAVE CONFIG"; SaveBtn.Font = Enum.Font.GothamBold; Instance.new("UICorner", SaveBtn).CornerRadius = UDim.new(0, 10)

SaveBtn.MouseButton1Click:Connect(function()
    local ok = SaveConfig()
    SaveBtn.Text = ok and "✅ SAVED!" or "❌ FAILED"
    task.delay(1.5, function() SaveBtn.Text = "💾 SAVE CONFIG" end)
end)

-- ============================================================
-- 4. INITIALIZATION & AUTO LOAD
-- ============================================================
task.spawn(function()
    task.wait(0.5) -- انتظار بسيط لضمان تحميل الخصائص
    if _G.Enabled.Optimizer then -- مثال لتشغيل ميزة تلقائياً
        -- دالة الـ Optimizer الخاصة بك
    end
    -- يمكنك إضافة باقي الشروط هنا بناءً على الـ Enabled
end)

-- تحديث الـ HUD المستمر
task.spawn(function()
    while task.wait(0.1) do
        local fps = math.floor(1 / RunService.RenderStepped:Wait())
        local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        Info.Text = "Crystal Hub | FPS " .. fps .. " | MS " .. ping
    end
end)

-- زر القائمة العائم (Floating Button)
local SideButton = Instance.new("TextButton", ScreenGui)
SideButton.Size = UDim2.new(0, 45, 0, 45); SideButton.Position = UDim2.new(1, -60, 0.5, -22)
SideButton.BackgroundColor3 = CrystalPurple; SideButton.Text = "C"; SideButton.TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", SideButton).CornerRadius = UDim.new(1, 0)

local menuOpen = false
SideButton.MouseButton1Click:Connect(function()
    menuOpen = not menuOpen
    MainMenu:TweenPosition(UDim2.new(menuOpen and 0.02 or -0.7, 0, 0.5, -160), "Out", "Quart", 0.4, true)
end)

print("Crystal Hub Turbo Loaded with Save System!")

