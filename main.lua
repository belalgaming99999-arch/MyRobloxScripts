-- [[ المنيو الجانبي المحدث ]] --
local SideMenu = Instance.new("Frame", ScreenGui)
SideMenu.Size = UDim2.new(0, 160, 0, 250) -- زدنا الطول قليلاً لاستيعاب الأزرار الجديدة
SideMenu.Position = UDim2.new(-0.7, 0, 0.35, 0)
SideMenu.BackgroundColor3 = PureBlack
SideMenu.BackgroundTransparency = 0.1
Instance.new("UICorner", SideMenu).CornerRadius = UDim.new(0, 15)
Instance.new("UIStroke", SideMenu).Color = CrystalPurple
MakeDraggable(SideMenu)

-- نظام ترتيب الأزرار تلقائياً داخل المنيو
local UIListLayout = Instance.new("UIListLayout", SideMenu)
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Top

-- مسافة داخلية من الأعلى
local UIPadding = Instance.new("UIPadding", SideMenu)
UIPadding.PaddingTop = UDim.new(0, 15)

-- [[ وظيفة إنشاء الأزرار بنفس ستايل الصورة ]] --
local function CreateMenuButton(name, text)
    local btn = Instance.new("TextButton", SideMenu)
    btn.Name = name
    btn.Size = UDim2.new(0, 140, 0, 40) -- عرض الزر مناسب لعرض المنيو
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30) -- لون غامق افتراضي
    btn.Text = text
    btn.TextColor3 = PureWhite
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 10)
    
    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = CrystalPurple
    stroke.Thickness = 1.5
    
    return btn
end

-- [[ إضافة زر Esp Player ]] --
local EspBtn = CreateMenuButton("EspBtn", "Esp Player")

local espEnabled = false
EspBtn.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    if espEnabled then
        EspBtn.BackgroundColor3 = CrystalPurple -- يتغير للبنفسجي عند التفعيل
        -- هنا نضع كود الـ ESP لاحقاً
        print("ESP Activated")
    else
        EspBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30) -- يعود للرمادي عند الإيقاف
        print("ESP Deactivated")
    end
end)

-- [[ إضافة زر Speed للتحكم (اختياري) ]] --
local SpeedToggleBtn = CreateMenuButton("SpeedToggleBtn", "Speed Hack")

-- [ المنيو الجانبي ]
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

-- [ نظام الـ Speed بالعلامة العشرية 0.0 وتكبير الخط ]
local function CreateTag(p)
    local function ApplyTag(char)
        local head = char:WaitForChild("Head", 10)
        if not head then return end
        
        local old = head:FindFirstChild("CrystalTag")
        if old then old:Destroy() end

        local bill = Instance.new("BillboardGui", head)
        bill.Name = "CrystalTag"; bill.Size = UDim2.new(0, 120, 0, 40); bill.StudsOffset = Vector3.new(0, 3.5, 0); bill.AlwaysOnTop = true
        
        local label = Instance.new("TextLabel", bill)
        label.Size = UDim2.new(1, 0, 1, 0); label.BackgroundTransparency = 1; label.TextColor3 = PureWhite
        label.TextSize = 14; label.Font = Enum.Font.GothamBold; label.TextStrokeTransparency = 0.5

        local conn
        conn = RunService.RenderStepped:Connect(function()
            if not char:IsDescendantOf(game) or not head:IsDescendantOf(char) then
                conn:Disconnect()
                return
            end
            if char:FindFirstChild("HumanoidRootPart") then
                if p == Player then
                    -- إظهار السرعة بالعلامة العشرية (0.0)
                    label.Text = "Speed: " .. string.format("%.1f", char.HumanoidRootPart.Velocity.Magnitude)
                else
                    label.Text = p.DisplayName
                end
            end
        end)
    end
    
    p.CharacterAdded:Connect(ApplyTag)
    if p.Character then ApplyTag(p.Character) end
end

for _, v in pairs(Players:GetPlayers()) do CreateTag(v) end
Players.PlayerAdded:Connect(CreateTag)

-- تحديث الـ FPS والـ MS
task.spawn(function()
    while true do
        local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        local fps = math.floor(1 / (RunService.RenderStepped:Wait()))
        InfoLabel.Text = string.format("Crystal Hub | FPS %d | MS %d", fps, ping)
        task.wait(1)
    end
end)
