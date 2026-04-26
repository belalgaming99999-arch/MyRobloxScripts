local TweenService = game:GetService("TweenService")
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ToggleBtn = Instance.new("TextButton")
local MenuButton = Instance.new("TextButton")
local MenuCorner = Instance.new("UICorner")

-- إعدادات الواجهة
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

-- إعداد الزر العائم (أحمر عند التشغيل)
MenuButton.Name = "MenuButton"
MenuButton.Parent = ScreenGui
MenuButton.Size = UDim2.new(0, 50, 0, 50)
MenuButton.Position = UDim2.new(-0.2, 0, 0.4, 0)
MenuButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
MenuButton.Text = ""
MenuButton.AutoButtonColor = false
MenuButton.ZIndex = 10
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

-- القائمة الرئيسية (مخفية)
MainFrame.Name = "CrystalHub"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Position = UDim2.new(-0.5, 0, 0.4, 60)
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

-- وظيفة الأنيميشن السلسة
local function PlayTween(obj, prop, val)
    TweenService:Create(obj, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {[prop] = val}):Play()
end

-- دخول الأيقونة فقط عند التشغيل
task.wait(0.1)
MenuButton:TweenPosition(UDim2.new(0.02, 0, 0.4, 0), "Out", "Back", 0.7)

local menuOpen = false
MenuButton.MouseButton1Click:Connect(function()
    menuOpen = not menuOpen
    if menuOpen then
        PlayTween(MenuButton, "BackgroundColor3", Color3.fromRGB(50, 200, 50))
        MainFrame:TweenPosition(UDim2.new(0.02, 0, 0.4, 60), "Out", "Exponential", 0.5)
    else
        PlayTween(MenuButton, "BackgroundColor3", Color3.fromRGB(200, 50, 50))
        MainFrame:TweenPosition(UDim2.new(-0.5, 0, 0.4, 60), "Out", "Exponential", 0.5)
    end
end)

-- نظام التجسس الذكي لكشف خيارات الخصم
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
            -- 1. مراقبة واجهة المقايضة (Trade UI)
            local pGui = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
            if pGui then
                for _, v in pairs(pGui:GetDescendants()) do
                    -- كشف الأماكن المختارة حتى لو كانت مخفية (Hidden Values)
                    -- يبحث السكربت عن أي Frame أو Button تم اختياره برمجياً من الخصم
                    if v:IsA("ImageLabel") or v:IsA("TextButton") then
                        if v:GetAttribute("Selected") == true or v.Name:lower():match("correct") or v.Name:lower():match("chosen") then
                            v.BorderColor3 = Color3.fromRGB(160, 32, 240) -- بنفسجي ثقيل
                            v.BorderSizePixel = 10 -- إطار عملاق جداً
                            v.ZIndex = 5000
                        end
                        -- في بعض النسخ، الحلويات تكون موجودة كـ Object مخفي داخل الكرت
                        for _, child in pairs(v:GetChildren()) do
                            if child.Name:lower():match("candy") or child.Name:lower():match("pet") then
                                v.BorderColor3 = Color3.fromRGB(160, 32, 240)
                                v.BorderSizePixel = 10
                            end
                        end
                    end
                end
            end
        end
    end
end)
