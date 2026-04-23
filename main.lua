-- [[ Crystal Hub - Fully Unified Rounded Edition (15 Radius) ]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local TweenService = game:GetService("TweenService")
local Player = Players.LocalPlayer

-- اللون البنفسجي الموحد
local CrystalPurple = Color3.fromRGB(120, 0, 255) 
local PureBlack = Color3.fromRGB(0, 0, 0)
local PureWhite = Color3.fromRGB(255, 255, 255)

-- تنظيف الواجهة القديمة
local function CleanUI()
    local name = "Crystal_Final_UI"
    pcall(function()
        if game:GetService("CoreGui"):FindFirstChild(name) then game:GetService("CoreGui")[name]:Destroy() end
        if Player.PlayerGui:FindFirstChild(name) then Player.PlayerGui[name]:Destroy() end
    end)
end
CleanUI()

-- إعداد حاوية الواجهة
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Crystal_Final_UI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not ScreenGui.Parent then ScreenGui.Parent = Player:WaitForChild("PlayerGui") end

-- [[ 1. القوائم العلوية والسفلية (انحناء 15) ]]
local MainBar = Instance.new("Frame", ScreenGui)
MainBar.Size = UDim2.new(0, 250, 0, 34)
MainBar.Position = UDim2.new(0.5, -125, 0.04, 0)
MainBar.BackgroundColor3 = PureBlack
MainBar.BackgroundTransparency = 0.15
Instance.new("UICorner", MainBar).CornerRadius = UDim.new(0, 15) -- موحد 15
local MainStroke = Instance.new("UIStroke", MainBar)
MainStroke.Color = CrystalPurple
MainStroke.Thickness = 1.5

local InfoLabel = Instance.new("TextLabel", MainBar)
InfoLabel.Size = UDim2.new(1, 0, 1, 0); InfoLabel.BackgroundTransparency = 1
InfoLabel.TextColor3 = CrystalPurple
InfoLabel.TextSize = 14; InfoLabel.Font = Enum.Font.GothamBold
InfoLabel.Text = "Crystal Hub | FPS -- | MS --"

local BottomBar = Instance.new("Frame", ScreenGui)
BottomBar.Size = UDim2.new(0, 250, 0, 14)
BottomBar.Position = UDim2.new(0.5, -125, 0.04, 40)
BottomBar.BackgroundTransparency = 1

local function CreatePart(pos, size, trans, txt)
    local f = Instance.new("Frame", BottomBar)
    f.Size = size; f.Position = pos; f.BackgroundColor3 = PureBlack; f.BackgroundTransparency = trans; f.BorderSizePixel = 0
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 20) 
    local t = Instance.new("TextLabel", f)
    t.Size = UDim2.new(1, 0, 1, 0); t.BackgroundTransparency = 1
    t.Text = txt; t.TextColor3 = PureWhite; t.TextSize = 10; t.Font = Enum.Font.GothamBold
end
CreatePart(UDim2.new(0, 0, 0, 0), UDim2.new(0.49, 0, 1, 0), 0.5, "0%") 
CreatePart(UDim2.new(0.51, 0, 0, 0), UDim2.new(0.49, 0, 1, 0), 0.15, "7.4") 

-- [[ 2. زر المنيو (انحناء 15 موحد) ]]
local SideButton = Instance.new("TextButton", ScreenGui)
SideButton.Size = UDim2.new(0, 45, 0, 45) -- كبرت الحجم شوية عشان البيضاوي يبان
SideButton.Position = UDim2.new(1.1, 0, 0.9, -110)
SideButton.BackgroundColor3 = CrystalPurple
SideButton.Text = ""
Instance.new("UICorner", SideButton).CornerRadius = UDim.new(0, 15) -- موحد 15

local LinesFrame = Instance.new("Frame", SideButton)
LinesFrame.Size = UDim2.new(0.5, 0, 0.4, 0); LinesFrame.Position = UDim2.new(0.25, 0, 0.3, 0); LinesFrame.BackgroundTransparency = 1
local function CreateLine(p)
    local l = Instance.new("Frame", LinesFrame); l.Size = UDim2.new(1, 0, 0.18, 0)
    l.Position = UDim2.new(0, 0, p, 0); l.BackgroundColor3 = PureWhite; l.BorderSizePixel = 0
    Instance.new("UICorner", l).CornerRadius = UDim.new(0, 2)
end
CreateLine(0); CreateLine(0.4); CreateLine(0.8)

-- [[ 3. القائمة الجانبية (انحناء 15 موحد) ]]
local SideMenu = Instance.new("Frame", ScreenGui)
SideMenu.Size = UDim2.new(0, 160, 0, 220)
SideMenu.Position = UDim2.new(-0.5, 0, 0.4, 0)
SideMenu.BackgroundColor3 = PureBlack
SideMenu.BackgroundTransparency = 0.1
Instance.new("UICorner", SideMenu).CornerRadius = UDim.new(0, 15) -- موحد 15
local SideStroke = Instance.new("UIStroke", SideMenu)
SideStroke.Color = CrystalPurple
SideStroke.Thickness = 1.5

-- أنيميشن دخول الزر
local it = TweenInfo.new(0.8, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
TweenService:Create(SideButton, it, {Position = UDim2.new(1, -65, 0.9, -110)}):Play()

-- تفاعل القائمة الجانبية
local menuOpen = false
SideButton.MouseButton1Click:Connect(function()
    menuOpen = not menuOpen
    local target = menuOpen and UDim2.new(0.02, 0, 0.4, 0) or UDim2.new(-0.5, 0, 0.4, 0)
    TweenService:Create(SideMenu, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = target}):Play()
end)

-- [[ 4. نظام السرعة (أبيض) والتحديث البطيء ]]
local function SetupSpeedTag(p)
    local function addTag(char)
        if not char then return end
        local head = char:WaitForChild("Head", 10)
        local root = char:WaitForChild("HumanoidRootPart", 10)
        if head:FindFirstChild("CrystalTag") then head.CrystalTag:Destroy() end
        local bill = Instance.new("BillboardGui", head)
        bill.Name = "CrystalTag"; bill.Size = UDim2.new(0, 80, 0, 20); bill.StudsOffset = Vector3.new(0, 3.5, 0); bill.AlwaysOnTop = true
        local label = Instance.new("TextLabel", bill)
        label.Size = UDim2.new(1, 0, 1, 0); label.BackgroundTransparency = 1
        label.TextColor3 = PureWhite; label.TextSize = 11; label.Font = Enum.Font.GothamBold
        task.spawn(function()
            while char:IsDescendantOf(workspace) do
                if root then
                    label.Text = p == Player and "Speed: " .. string.format("%.1f", root.Velocity.Magnitude) or p.DisplayName
                end
                task.wait(0.1)
            end
        end)
    end
    if p.Character then addTag(p.Character) end
    p.CharacterAdded:Connect(addTag)
end

for _, v in pairs(Players:GetPlayers()) do Setup
