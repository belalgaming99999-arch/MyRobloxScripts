local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Player = Players.LocalPlayer

local CrystalPurple = Color3.fromRGB(120, 0, 255) 
local PureBlack = Color3.fromRGB(0, 0, 0)
local PureWhite = Color3.fromRGB(255, 255, 255)

local function CleanUI()
    local name = "Crystal_Final_UI"
    pcall(function()
        if game:GetService("CoreGui"):FindFirstChild(name) then game:GetService("CoreGui")[name]:Destroy() end
        if Player:WaitForChild("PlayerGui"):FindFirstChild(name) then Player.PlayerGui[name]:Destroy() end
    end)
end
CleanUI()

local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
ScreenGui.Name = "Crystal_Final_UI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 999999

local isDraggingBtn = false
local dragStartPos = nil

local function MakeDraggable(gui)
    local dragging, dragInput, dragStart, startPos
    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = gui.Position
            dragStartPos = input.Position
            input.Changed:Connect(function() 
                if input.UserInputState == Enum.UserInputState.End then 
                    dragging = false 
                    task.wait(0.05)
                    isDraggingBtn = false
                end 
            end)
        end
    end)
    gui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            if (input.Position - dragStartPos).Magnitude > 7 then
                isDraggingBtn = true
            end
            gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- [ القوائم المركزية - نفس موقع الصورة ]
local MainContainer = Instance.new("Frame", ScreenGui)
MainContainer.Size = UDim2.new(0, 250, 0, 60)
MainContainer.Position = UDim2.new(0.5, -125, 0.12, 0) -- نزلتها لتحت شوية زي الصورة
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

local BottomBar = Instance.new("Frame", MainContainer)
BottomBar.Size = UDim2.new(1, 0, 0, 16)
BottomBar.Position = UDim2.new(0, 0, 0, 40)
BottomBar.BackgroundTransparency = 1

local function CreateStatPart(pos, size, trans, txt)
    local f = Instance.new("Frame", BottomBar)
    f.Size = size; f.Position = pos; f.BackgroundColor3 = PureBlack; f.BackgroundTransparency = trans
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 20)
    local t = Instance.new("TextLabel", f)
    t.Size = UDim2.new(1, 0, 1, 0); t.BackgroundTransparency = 1
    t.Text = txt; t.TextColor3 = PureWhite; t.TextSize = 10; t.Font = Enum.Font.GothamBold
end
CreateStatPart(UDim2.new(0, 0, 0, 0), UDim2.new(0.49, 0, 1, 0), 0.5, "0%") 
CreateStatPart(UDim2.new(0.51, 0, 0, 0), UDim2.new(0.49, 0, 1, 0), 0.15, "7.4") 

-- [ زر المنيو والقائمة الجانبية ]
local SideButton = Instance.new("TextButton", ScreenGui)
SideButton.Size = UDim2.new(0, 60, 0, 60)
SideButton.Position = UDim2.new(1, -80, 0.5, 0)
SideButton.BackgroundColor3 = CrystalPurple; SideButton.Text = ""
Instance.new("UICorner", SideButton).CornerRadius = UDim.new(0, 15)
MakeDraggable(SideButton)

local LinesFrame = Instance.new("Frame", SideButton)
LinesFrame.Size = UDim2.new(0.5, 0, 0.4, 0); LinesFrame.Position = UDim2.new(0.25, 0, 0.3, 0); LinesFrame.BackgroundTransparency = 1
for i=0,2 do
    local l = Instance.new("Frame", LinesFrame); l.Size = UDim2.new(1, 0, 0.18, 0)
    l.Position = UDim2.new(0, 0, i * 0.4, 0); l.BackgroundColor3 = PureWhite; l.BorderSizePixel = 0
    Instance.new("UICorner", l).CornerRadius = UDim.new(0, 2)
end

local SideMenu = Instance.new("Frame", ScreenGui)
SideMenu.Size = UDim2.new(0, 160, 0, 220)
SideMenu.Position = UDim2.new(-0.7, 0, 0.35, 0)
SideMenu.BackgroundColor3 = PureBlack; SideMenu.BackgroundTransparency = 0.1
Instance.new("UICorner", SideMenu).CornerRadius = UDim.new(0, 15)
Instance.new("UIStroke", SideMenu).Color = CrystalPurple
MakeDraggable(SideMenu)

local menuOpen = false
SideButton.MouseButton1Click:Connect(function()
    if not isDraggingBtn then
        menuOpen = not menuOpen
        local targetX = menuOpen and 0.02 or -0.7
        TweenService:Create(SideMenu, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(targetX, 0, 0.35, 0)}):Play()
    end
end)

-- تحديث الـ FPS و الـ MS (تأكدت من تشغيله فوراً)
task.spawn(function()
    while true do
        local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        local fps = math.floor(1 / (RunService.RenderStepped:Wait()))
        InfoLabel.Text = string.format("Crystal Hub | FPS %d | MS %d", fps, ping)
        task.wait(1)
    end
end)
local SideMenu = Instance.new("Frame", ScreenGui)
SideMenu.Size = UDim2.new(0, 160, 0, 220)
SideMenu.Position = UDim2.new(-0.6, 0, 0.4, 0) -- يبدأ مخفي
SideMenu.BackgroundColor3 = PureBlack; SideMenu.BackgroundTransparency = 0.1
Instance.new("UICorner", SideMenu).CornerRadius = UDim.new(0, 15) -- موحد 15
local SideStroke = Instance.new("UIStroke", SideMenu)
SideStroke.Color = CrystalPurple; SideStroke.Thickness = 1.5
MakeDraggable(SideMenu) -- قابل للسحب

-- [ أنيميشن دخول الواجهة ]
local it = TweenInfo.new(1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
TweenService:Create(MainContainer, it, {Position = UDim2.new(0.5, -125, 0.04, 0)}):Play()
TweenService:Create(SideButton, it, {Position = UDim2.new(1, -80, 0.9, -120)}):Play()

-- تفاعل القائمة الجانبية
local menuOpen = false
SideButton.MouseButton1Click:Connect(function()
    menuOpen = not menuOpen
    local targetPos = menuOpen and UDim2.new(0.02, 0, 0.4, 0) or UDim2.new(-0.6, 0, 0.4, 0)
    TweenService:Create(SideMenu, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = targetPos}):Play()
end)

-- [ 3. الأنظمة الفرعية والتحديث البطيء ]
local function SetupSpeedTag(p)
    p.CharacterAdded:Connect(function(char)
        local head = char:WaitForChild("Head", 15)
        local bill = Instance.new("BillboardGui", head)
        bill.Name = "CrystalTag"; bill.Size = UDim2.new(0, 80, 0, 20); bill.StudsOffset = Vector3.new(0, 3.5, 0); bill.AlwaysOnTop = true
        local label = Instance.new("TextLabel", bill)
        label.Size = UDim2.new(1, 0, 1, 0); label.BackgroundTransparency = 1; label.TextColor3 = PureWhite; label.TextSize = 11; label.Font = Enum.Font.GothamBold
        RunService.Heartbeat:Connect(function()
            if char:FindFirstChild("HumanoidRootPart") then
                label.Text = p == Player and "Speed: " .. string.format("%.1f", char.HumanoidRootPart.Velocity.Magnitude) or p.DisplayName
            end
        end)
    end)
    if p.Character then SetupSpeedTag(p) end -- لتشغيلها لو اللاعب موجود
end
for _, v in pairs(Players:GetPlayers()) do SetupSpeedTag(v) end
Players.PlayerAdded:Connect(SetupSpeedTag)

-- تحديث FPS/Ping بهدوء (شلت رابط الديسكورد)
task.spawn(function()
    while true do
        local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        local fps = math.floor(1 / (RunService.RenderStepped:Wait()))
        TitleLabel.Text = string.format("Crystal Hub | FPS %d | MS %d", fps, ping)
        task.wait(1.2)
    end
end)
-- تحديث البيانات
task.spawn(function()
    while true do
        local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        local fps = math.floor(1 / (RunService.RenderStepped:Wait()))
        InfoLabel.Text = string.format("Crystal Hub | FPS %d | MS %d", fps, ping)
        task.wait(1)
    end
end)
