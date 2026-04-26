local TweenService = game:GetService("TweenService")
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ToggleBtn = Instance.new("TextButton")
local MainCorner = Instance.new("UICorner")
local BtnCorner = Instance.new("UICorner")

-- إعدادات الواجهة (Crystal Hub)
ScreenGui.Parent = game:GetService("CoreGui")

MainFrame.Name = "CrystalHub"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Position = UDim2.new(0.02, 0, 0.4, 0)
MainFrame.Size = UDim2.new(0, 180, 0, 110)
MainFrame.BorderSizePixel = 0

MainCorner.CornerRadius = UDim.new(0, 15)
MainCorner.Parent = MainFrame

-- العنوان الرئيسي
Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "Crystal Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold

-- زر التحكم (أحمر سلس عند الإيقاف)
ToggleBtn.Parent = MainFrame
ToggleBtn.Position = UDim2.new(0.1, 0, 0.45, 0)
ToggleBtn.Size = UDim2.new(0.8, 0, 0.4, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
ToggleBtn.Text = "Esp Candy Off"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.GothamSemibold
ToggleBtn.TextSize = 14
ToggleBtn.AutoButtonColor = false

BtnCorner.CornerRadius = UDim.new(0, 10)
BtnCorner.Parent = ToggleBtn

-- وظيفة تحريك الألوان بسلاسة فائقة
local function AnimateColor(targetColor)
    local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    TweenService:Create(ToggleBtn, tweenInfo, {BackgroundColor3 = targetColor}):Play()
end

local active = false
ToggleBtn.MouseButton1Click:Connect(function()
    active = not active
    if active then
        ToggleBtn.Text = "Esp Candy On"
        AnimateColor(Color3.fromRGB(40, 180, 40)) -- أخضر سلس
    else
        ToggleBtn.Text = "Esp Candy Off"
        AnimateColor(Color3.fromRGB(180, 40, 40)) -- أحمر سلس
    end
end)

-- حلقة الكشف الذكي (X-Ray)
task.spawn(function()
    while true do
        task.wait(0.1)
        if active then
            for _, obj in pairs(workspace:GetDescendants()) do
                -- كشف الجوائز (Candy/Diamond)
                if obj.Name == "Candy" or obj.Name == "Diamond" then
                    if obj:IsA("BasePart") and not obj:FindFirstChild("Highlight") then
                        local hl = Instance.new("Highlight")
                        hl.Parent = obj
                        hl.FillColor = Color3.fromRGB(40, 180, 40)
                        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    end
                -- جعل الكروت شفافة لرؤية ما تحتها
                elseif obj.Name == "Card" or obj.Name == "Cover" then
                    obj.Transparency = 0.5
                end
            end
        else
            -- إيقاف الكشف وإعادة كل شيء لطبيعته
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:FindFirstChild("Highlight") then obj.Highlight:Destroy() end
                if obj.Name == "Card" or obj.Name == "Cover" then obj.Transparency = 0 end
            end
        end
    end
end)

