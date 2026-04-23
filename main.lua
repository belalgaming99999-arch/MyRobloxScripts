-- [[ Crystal Hub - Premium Glossy Edition ]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local Player = Players.LocalPlayer

-- الألوان
local DeepNovaBlue = Color3.fromRGB(0, 130, 255)
local TextColor = Color3.fromRGB(0, 150, 255) 
local PureBlack = Color3.fromRGB(0, 0, 0)

local function Clean()
    local pGui = Player:FindFirstChild("PlayerGui")
    if pGui and pGui:FindFirstChild("Crystal_Final_UI") then pGui.Crystal_Final_UI:Destroy() end
    local s, core = pcall(function() return game:GetService("CoreGui") end)
    if s and core:FindFirstChild("Crystal_Final_UI") then core.Crystal_Final_UI:Destroy() end
end
Clean()

local Target = Player:WaitForChild("PlayerGui")
local s, core = pcall(function() return game:GetService("CoreGui") end)
if s then Target = core end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Crystal_Final_UI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = Target

-- [[ 1. القائمة العلوية - أسود غامق شفاف ]]
local MainBar = Instance.new("Frame")
MainBar.Size = UDim2.new(0, 240, 0, 32)
MainBar.Position = UDim2.new(0.5, -120, 0.04, 0) 
MainBar.BackgroundColor3 = PureBlack
MainBar.BackgroundTransparency = 0.3 -- درجة الشفافية المطلوبة (أسود غامق شفاف)
MainBar.BorderSizePixel = 0
MainBar.Parent = ScreenGui

local MainCorner = Instance.new("UICorner", MainBar)
MainCorner.CornerRadius = UDim.new(0, 10) -- حواف بيضاوية ناعمة

local MainStroke = Instance.new("UIStroke", MainBar)
MainStroke.Color = DeepNovaBlue
MainStroke.Thickness = 1.0

local InfoLabel = Instance.new("TextLabel")
InfoLabel.Size = UDim2.new(1, 0, 1, 0)
InfoLabel.BackgroundTransparency = 1
InfoLabel.TextColor3 = TextColor
InfoLabel.TextSize = 13
InfoLabel.Font = Enum.Font.GothamBold
InfoLabel.Text = "Crystal Hub | Fps -- | Ms --"
InfoLabel.Parent = MainBar

-- [[ 2. القائمة السفلى - حواف بيضاوية وتقسيم ألوان ]]
local BottomBar = Instance.new("Frame")
BottomBar.Size = UDim2.new(0, 240, 0, 12) -- زودت الطول سنة عشان تبان الحواف
BottomBar.Position = UDim2.new(0.5, -120, 0.04, 38)
BottomBar.BackgroundTransparency = 1
BottomBar.Parent = ScreenGui

-- حاوية الشريط السفلي لجعل الحواف بيضاوية (Rounded)
local BarContainer = Instance.new("Frame")
BarContainer.Size = UDim2.new(1, 0, 1, 0)
BarContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
BarContainer.BackgroundTransparency = 1 -- الحاوية شفافة
BarContainer.ClipsDescendants = true -- عشان تقص الأجزاء اللي جواها وتطلع بيضاوية
BarContainer.Parent = BottomBar

local BottomCorner = Instance.new("UICorner", BarContainer)
BottomCorner.CornerRadius = UDim.new(0, 10) -- نفس دوران القائمة اللي فوق

local function CreatePart(pos, size, color, trans, txt)
    local f = Instance.new("Frame")
    f.Size = size
    f.Position = pos
    f.BackgroundColor3 = color
    f.BackgroundTransparency = trans
    f.BorderSizePixel = 0
    f.Parent = BarContainer
    
    local t = Instance.new("TextLabel", f)
    t.Size = UDim2.new(1, 0, 1, 0)
    t.BackgroundTransparency = 1
    t.Text = txt
    t.TextColor3 = Color3.fromRGB(220, 220, 220)
    t.TextSize = 9
    t.Font = Enum.Font.GothamBold
    t.Parent = f
end

-- الجزء الشمال (شفاف تماماً)
CreatePart(UDim2.new(0,0,0,0), UDim2.new(0.5, 0, 1, 0), PureBlack, 1, "0%")
-- الجزء اليمين (أسود غامق شفاف 180 درجة/0.3)
CreatePart(UDim2.new(0.5,0,0,0), UDim2.new(0.5, 0, 1, 0), PureBlack, 0.3, "7.4")

-- [[ 3. نظام السرعة ]]
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
        label.TextSize = 12
        label.Font = Enum.Font.GothamBold
        
        local sStroke = Instance.new("UIStroke", label)
        sStroke.Thickness = 0.3
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
        label.TextSize = 14
        label.Font = Enum.Font.GothamBold
        
        local sStroke = Instance.new("UIStroke", label)
        sStroke.Thickness = 0.5
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
