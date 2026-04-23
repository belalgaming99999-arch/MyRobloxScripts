-- [[ تعديل قسم الأزرار داخل المنيو ]] --

-- 1. زر Esp Player (العرض الكامل)
local EspBtn = Instance.new("TextButton", SideMenu)
EspBtn.Size = UDim2.new(0, 140, 0, 45)
EspBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
EspBtn.BackgroundTransparency = 0.15
EspBtn.Text = "Esp Player"
EspBtn.TextColor3 = PureWhite; EspBtn.Font = Enum.Font.GothamBold; EspBtn.TextSize = 13
Instance.new("UICorner", EspBtn).CornerRadius = UDim.new(0, 8)
local EspStroke = Instance.new("UIStroke", EspBtn)
EspStroke.Color = CrystalPurple; EspStroke.Thickness = 1.5

-- 2. حاوية للأزرار المزدوجة (AimBot & Auto Steal)
local DoubleButtonsFrame = Instance.new("Frame", SideMenu)
DoubleButtonsFrame.Size = UDim2.new(0, 140, 0, 40)
DoubleButtonsFrame.BackgroundTransparency = 1

local UIListDouble = Instance.new("UIListLayout", DoubleButtonsFrame)
UIListDouble.FillDirection = Enum.FillDirection.Horizontal
UIListDouble.Padding = UDim.new(0, 8)
UIListDouble.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- وظيفة لإنشاء الأزرار الصغيرة
local function CreateSmallBtn(name, text, parent)
    local btn = Instance.new("TextButton", parent)
    btn.Name = name
    btn.Size = UDim2.new(0, 66, 1, 0) -- نصف العرض تقريباً
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.BackgroundTransparency = 0.15
    btn.Text = text
    btn.TextColor3 = PureWhite
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = CrystalPurple
    stroke.Thickness = 1.2
    
    -- نظام التفعيل (اللون البنفسجي الموحد)
    local active = false
    btn.MouseButton1Click:Connect(function()
        active = not active
        if active then
            btn.BackgroundColor3 = CrystalPurple
            btn.BackgroundTransparency = 0
        else
            btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            btn.BackgroundTransparency = 0.15
        end
    end)
    return btn
end

local AimBtn = CreateSmallBtn("AimBtn", "AimBot", DoubleButtonsFrame)
local StealBtn = CreateSmallBtn("StealBtn", "Auto Steal", DoubleButtonsFrame)

-- [[ تفعيل زر ESP السابق ]] --
local espActive = false
EspBtn.MouseButton1Click:Connect(function()
    espActive = not espActive
    if espActive then
        EspBtn.BackgroundColor3 = CrystalPurple
        EspBtn.BackgroundTransparency = 0
    else
        EspBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        EspBtn.BackgroundTransparency = 0.15
    end
end)
