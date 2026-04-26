local TweenService = game:GetService("TweenService")
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ToggleBtn = Instance.new("TextButton")
local MenuButton = Instance.new("TextButton")
local MenuCorner = Instance.new("UICorner")

-- إعدادات واجهة المستخدم
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

-- إعداد الزر العائم (أحمر افتراضي)
MenuButton.Name = "MenuButton"
MenuButton.Parent = ScreenGui
MenuButton.Size = UDim2.new(0, 50, 0, 50)
MenuButton.Position = UDim2.new(-0.1, 0, 0.4, 0)
MenuButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
MenuButton.Text = ""
MenuButton.AutoButtonColor = false
MenuCorner.CornerRadius = UDim.new(0, 12)
MenuCorner.Parent = MenuButton

for i = -1, 1 do
    local line = Instance.new("Frame")
    line.Parent = MenuButton
    line.Size = UDim2.new(0, 26, 0, 3)
    line.Position = UDim2.new(0.5, -13, 0.5, i * 8)
    line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    line.BorderSizePixel = 0
end

-- القائمة الرئيسية (Crystal Hub)
MainFrame.Name = "CrystalHub"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Position = UDim2.new(-0.3, 0, 0.4, 55)
MainFrame.Size = UDim2.new(0, 180, 0, 110)
MainFrame.BorderSizePixel = 0
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 15)
MainCorner.Parent = MainFrame

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "Crystal Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold

ToggleBtn.Parent = MainFrame
ToggleBtn.Position = UDim2.new(0.1, 0, 0.45, 0)
ToggleBtn.Size = UDim2.new(0.8, 0, 0.4, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
ToggleBtn.Text = "Esp Candy Off"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.GothamSemibold
ToggleBtn.TextSize = 12
ToggleBtn.AutoButtonColor = false
local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 10)
BtnCorner.Parent = ToggleBtn

-- وظائف الأنيميشن
local function PlayTween(obj, prop, val)
    TweenService:Create(obj, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {[prop] = val}):Play()
end

MenuButton:TweenPosition(UDim2.new(0.02, 0, 0.4, 0), "Out", "Back", 0.6)

local menuOpen = false
MenuButton.MouseButton1Click:Connect(function()
    menuOpen = not menuOpen
    if menuOpen then
        PlayTween(MenuButton, "BackgroundColor3", Color3.fromRGB(50, 200, 50)) -- يتحول للأخضر
        MainFrame:TweenPosition(UDim2.new(0.02, 0, 0.4, 55), "Out", "Exponential", 0.5)
    else
        PlayTween(MenuButton, "BackgroundColor3", Color3.fromRGB(200, 50, 50)) -- يعود للأحمر
        MainFrame:TweenPosition(UDim2.new(-0.3, 0, 0.4, 55), "Out", "Exponential", 0.5)
    end
end)

-- منطق الكشف (تعديل خاص لواجهة المقايضة)
local espActive = false
ToggleBtn.MouseButton1Click:Connect(function()
    espActive = not espActive
    if espActive then
        ToggleBtn.Text = "Esp Candy On"
        PlayTween(ToggleBtn, "BackgroundColor3", Color3.fromRGB(50, 200, 50))
    else
        ToggleBtn.Text = "Esp Candy Off"
        PlayTween(ToggleBtn, "BackgroundColor3", Color3.fromRGB(200, 50, 50))
    end
end)

task.spawn(function()
    while true do
        task.wait(0.1)
        if espActive then
            -- كشف الكاندي في العالم (Workspace)
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj.Name == "Candy" or obj.Name == "Diamond" then
                    if obj:IsA("BasePart") and not obj:FindFirstChild("Highlight") then
                        local hl = Instance.new("Highlight", obj)
                        hl.FillColor = Color3.fromRGB(160, 32, 240) -- بنفسجي ثقيل
                        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    end
                end
            end
            
            -- كشف الكاندي داخل واجهة المقايضة (GUI)
            local playerGui = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
            if playerGui then
                for _, uiObj in pairs(playerGui:GetDescendants()) do
                    -- البحث عن الكاندي المخفي تحت الكروت في الـ UI
                    if (uiObj.Name:lower():match("candy") or uiObj.Name:lower():match("reward")) and uiObj:IsA("ImageLabel") then
                        -- وضع إطار بنفسجي ثقيل جداً حول الكرت الصحيح
                        uiObj.BorderColor3 = Color3.fromRGB(160, 32, 240)
                        uiObj.BorderSizePixel = 5 -- سمك كبير ليكون واضحاً
                        uiObj.ZIndex = 100 -- يظهر فوق كل شيء
                    end
                end
            end
        end
    end
end)
