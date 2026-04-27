local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local UnderLine = Instance.new("Frame")
local BigBtn = Instance.new("TextButton")
local MenuButton = Instance.new("TextButton")

ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

-- تصميم الزرار الخارجي
MenuButton.Name = "CrystalMenuBtn"
MenuButton.Parent = ScreenGui
MenuButton.Size = UDim2.new(0, 50, 0, 50)
MenuButton.Position = UDim2.new(0.05, 0, 0.2, 0)
MenuButton.BackgroundColor3 = Color3.fromRGB(45, 85, 160)
MenuButton.Text = "C"
MenuButton.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", MenuButton).CornerRadius = UDim.new(0, 10)

-- القائمة الرئيسية
MainFrame.Name = "CrystalHub"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Size = UDim2.new(0, 200, 0, 120)
MainFrame.Position = UDim2.new(0.4, 0, 0.4, 0)
MainFrame.Visible = false
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "CANDY ESP"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold

BigBtn.Name = "EspMainBtn"
BigBtn.Parent = MainFrame
BigBtn.Position = UDim2.new(0.1, 0, 0.45, 0)
BigBtn.Size = UDim2.new(0.8, 0, 0, 45)
BigBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
BigBtn.Text = "Enable ESP"
BigBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
BigBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", BigBtn).CornerRadius = UDim.new(0, 8)

-- فتح وقفل المنيو
MenuButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

local espActive = false
BigBtn.MouseButton1Click:Connect(function()
    espActive = not espActive
    BigBtn.Text = espActive and "Disable ESP" or "Enable ESP"
    BigBtn.BackgroundColor3 = espActive and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(180, 0, 0)

    task.spawn(function()
        while espActive do
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and (obj.Name:find("Candy") or obj.Name:find("Card") or obj.Name:find("Tile")) then
                    -- فحص لو الكرت قنبلة (زي الفيديو بالظبط)
                    local isBomb = obj:FindFirstChild("Bomb") or obj:FindFirstChild("Mine") or obj:GetAttribute("IsBomb") == true
                    
                    -- لو اللعبة مخبية القيمة
                    if not isBomb then
                        for _, v in pairs(obj:GetChildren()) do
                            if v:IsA("ValueBase") and v.Name:lower():find("bomb") then
                                isBomb = true; break
                            end
                        end
                    end

                    if isBomb then
                        -- عمل المربع الأحمر العايم فوق الكرت
                        local bill = obj:FindFirstChild("BombMarker") or Instance.new("BillboardGui", obj)
                        bill.Name = "BombMarker"
                        bill.AlwaysOnTop = true
                        bill.Size = UDim2.new(2, 0, 2, 0) -- حجم المربع
                        bill.ExtentsOffset = Vector3.new(0, 1, 0) -- يظهر فوق الكرت بمسافة

                        local box = bill:FindFirstChild("Box") or Instance.new("Frame", bill)
                        box.Name = "Box"
                        box.Size = UDim2.new(1, 0, 1, 0)
                        box.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- أحمر فاقع
                        box.BackgroundTransparency = 0.2 -- شفافية بسيطة زي الفيديو
                        box.BorderSizePixel = 2
                        
                        local stroke = box:FindFirstChild("UIStroke") or Instance.new("UIStroke", box)
                        stroke.Color = Color3.fromRGB(255, 255, 255)
                        stroke.Thickness = 1.5
                    end
                end
            end
            task.wait(0.1)
        end
        -- تنظيف عند القفل
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:FindFirstChild("BombMarker") then obj.BombMarker:Destroy() end
        end
    end)
end)
