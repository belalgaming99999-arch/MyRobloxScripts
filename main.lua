-- [[ Crystal Hub - Ultra Soft Tags & Centered ]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local Player = Players.LocalPlayer

local DeepNovaBlue = Color3.fromRGB(0, 130, 255)
local TextColor = Color3.fromRGB(0, 150, 255) 
local DeepDarkBg = Color3.fromRGB(2, 2, 2)

local function Clean()
    local pGui = Player:FindFirstChild("PlayerGui")
    if pGui and pGui:FindFirstChild("Crystal_Final_UI") then pGui.Crystal_Final_UI:Destroy() end
    local s, cGui = pcall(function() return game:GetService("CoreGui") end)
    if s and cGui:FindFirstChild("Crystal_Final_UI") then cGui.Crystal_Final_UI:Destroy() end
end
Clean()

local Target = Player:WaitForChild("PlayerGui")
local s, core = pcall(function() return game:GetService("CoreGui") end)
if s then Target = core end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Crystal_Final_UI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = Target

-- [[ 1. القائمة العلوية - متمركزة بالمنتصف تماماً ]]
local MainBar = Instance.new("Frame")
MainBar.Size = UDim2.new(0, 240, 0, 32)
MainBar.Position = UDim2.new(0.5, -120, 0.04, 0) 
MainBar.BackgroundColor3 = DeepDarkBg
MainBar.BackgroundTransparency = 0.08
MainBar.BorderSizePixel = 0
MainBar.Parent = ScreenGui

Instance.new("UICorner", MainBar).CornerRadius = UDim.new(0, 8)
local Stroke = Instance.new("UIStroke", MainBar)
Stroke.Color = DeepNovaBlue
Stroke.Thickness = 1.3

local InfoLabel = Instance.new("TextLabel")
InfoLabel.Size = UDim2.new(1, 0, 1, 0)
InfoLabel.BackgroundTransparency = 1
InfoLabel.TextColor3 = TextColor
InfoLabel.TextSize = 13
InfoLabel.Font = Enum.Font.GothamBold
InfoLabel.Text = "Crystal Hub | Fps -- | Ms --"
InfoLabel.Parent = MainBar

-- [[ 2. الشريط السفلي ]]
local BottomBar = Instance.new("Frame")
BottomBar.Size = UDim2.new(0, 240, 0, 10)
BottomBar.Position = UDim2.new(0.5, -120, 0.04, 34)
BottomBar.BackgroundTransparency = 1
BottomBar.Parent = ScreenGui

local function CreatePart(pos, color, txt)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(0.5, 0, 1, 0)
    f.Position = pos
    f.BackgroundColor3 = color
    f.BorderSizePixel = 0
    f.Parent = BottomBar
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 4)
    local t = Instance.new("TextLabel", f)
    t.Size = UDim2.new(1, 0, 1, 0)
    t.BackgroundTransparency = 1
    t.Text = txt
    t.TextColor3 = Color3.fromRGB(200, 200, 200)
    t.TextSize = 9
    t.Font = Enum.Font.GothamBold
    t.Parent = f
end

CreatePart(UDim2.new(0,0,0,0), Color3.fromRGB(30, 30, 30), "0%")
CreatePart(UDim2.new(0.5,0,0,0), Color3.fromRGB(10, 10, 10), "7.4")

-- [[ 3. نظام السرعة - تصغير الحجم لـ 14 وتخفيف الحواف لـ 0.5 ]]
local function SetupTag(p)
    local function addTag(char)
        local head = char:WaitForChild("Head", 10)
        local root = char:WaitForChild("HumanoidRootPart", 10)
        if head:FindFirstChild("CrystalTag") then head.CrystalTag:Destroy() end

        local bill = Instance.new("BillboardGui", head)
        bill.Name = "CrystalTag"
        bill.Size = UDim2.new(0, 200, 0, 50)
        bill.StudsOffset = Vector3.new(0, 4.0, 0) 
        bill.AlwaysOnTop = true

        local label = Instance.new("TextLabel", bill)
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextSize = 14 -- صغرتها درجتين كمان
        label.Font = Enum.Font.GothamBold
        
        local sStroke = Instance.new("UIStroke", label)
        sStroke.Thickness = 0.5 -- خففت الحواف درجة كمان
        sStroke.Color = Color3.fromRGB(0, 0, 0)

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
