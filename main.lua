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
    local old = game:GetService("CoreGui"):FindFirstChild("Crystal_Final_UI") or Player:WaitForChild("PlayerGui"):FindFirstChild("Crystal_Final_UI")
    if old then old:Destroy() end
end
CleanUI()

local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
ScreenGui.Name = "Crystal_Final_UI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true

-- متغيرات لمنع فتح القائمة أثناء السحب
local isDraggingBtn = false

local function MakeDraggable(gui)
    local dragging, dragInput, dragStart, startPos
    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = gui.Position
            input.Changed:Connect(function() 
                if input.UserInputState == Enum.UserInputState.End then 
                    dragging = false 
                    task.wait(0.1)
                    isDraggingBtn = false
                end 
            end)
        end
    end)
    gui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then 
            dragInput = input 
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            if delta.Magnitude > 5 then -- إذا تحرك أكثر من 5 بكسل يعتبر سحب
                isDraggingBtn = true
            end
            gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- [ القوائم المركزية ]
local MainBar = Instance.new("Frame", ScreenGui)
MainBar.Size = UDim2.new(0, 250, 0, 34)
MainBar.Position = UDim2.new(0.5, -125, 0.05, 0)
MainBar.BackgroundColor3 = PureBlack; MainBar.BackgroundTransparency = 0.15
Instance.new("UICorner", MainBar).CornerRadius = UDim.new(0, 15)
Instance.new("UIStroke", MainBar).Color = CrystalPurple

local InfoLabel = Instance.new("TextLabel", MainBar)
InfoLabel.Size = UDim2.new(1, 0, 1, 0); InfoLabel.BackgroundTransparency = 1
InfoLabel.TextColor3 = CrystalPurple; InfoLabel.TextSize = 14; InfoLabel.Font = Enum.Font.GothamBold
InfoLabel.Text = "Crystal Hub | FPS -- | MS --"

local BottomBar = Instance.new("Frame", ScreenGui)
BottomBar.Size = UDim2.new(0, 250, 0, 34)
BottomBar.Position = UDim2.new(0.5, -125, 0.05, 42)
BottomBar.BackgroundColor3 = PureBlack; BottomBar.BackgroundTransparency = 0.15
Instance.new("UICorner", BottomBar).CornerRadius = UDim.new(0, 15)
Instance.new("UIStroke", BottomBar).Color = CrystalPurple

-- [ زر المنيو - أكبر ومرتفع للأعلى ]
local SideButton = Instance.new("TextButton", ScreenGui)
SideButton.Size = UDim2.new(0, 55, 0, 55) -- تم تكبيره من 46 إلى 55
SideButton.Position = UDim2.new(1, -75, 0.5, 0) -- تم رفعه لمنتصف الشاشة تقريباً
SideButton.BackgroundColor3 = CrystalPurple; SideButton.Text = ""
Instance.new("UICorner", SideButton).CornerRadius = UDim.new(0, 15)
MakeDraggable(SideButton)

for i=1,3 do
    local l = Instance.new("Frame", SideButton)
    l.Size = UDim2.new(0.5, 0, 0.07, 0); l.Position = UDim2.new(0.25, 0, 0.25 + (i*0.15), 0)
    l.BackgroundColor3 = PureWhite; l.BorderSizePixel = 0; Instance.new("UICorner", l).CornerRadius = UDim.new(0, 2)
end

-- [ القائمة الجانبية ]
local SideMenu = Instance.new("Frame", ScreenGui)
SideMenu.Size = UDim2.new(0, 160, 0, 200)
SideMenu.Position = UDim2.new(-0.7, 0, 0.35, 0)
SideMenu.BackgroundColor3 = PureBlack; SideMenu.BackgroundTransparency = 0.1
Instance.new("UICorner", SideMenu).CornerRadius = UDim.new(0, 15)
Instance.new("UIStroke", SideMenu).Color = CrystalPurple
MakeDraggable(SideMenu)

-- وظيفة الفتح (لا تعمل إذا كان المستخدم يسحب الزر)
local menuOpen = false
SideButton.MouseButton1Click:Connect(function()
    if not isDraggingBtn then
        menuOpen = not menuOpen
        local targetX = menuOpen and 0.02 or -0.7
        TweenService:Create(SideMenu, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(targetX, 0, 0.35, 0)}):Play()
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
