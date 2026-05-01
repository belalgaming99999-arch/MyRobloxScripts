local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

-- إزالة أي نسخة سابقة لضمان عدم التداخل
if CoreGui:FindFirstChild("Crystal_GodMode") then CoreGui.Crystal_GodMode:Destroy() end

local Crystal = Instance.new("ScreenGui", CoreGui)
Crystal.Name = "Crystal_GodMode"

local Toggles = {AutoPop = false}

-- [[ محرك الذكاء الخارق: نظام كشف المكسب المسبق ]] --
task.spawn(function()
    while true do
        if Toggles.AutoPop then
            pcall(function()
                -- المسح الشامل لكل العناصر التفاعلية في الخريطة
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if not Toggles.AutoPop then break end
                    
                    if obj:IsA("ClickDetector") then
                        local parent = obj.Parent
                        local isWinner = false
                        
                        -- 1. فحص القيم المخفية (الحالة الأكثر شيوعاً للمكسب المضمون)
                        local val = parent:FindFirstChildOfClass("NumberValue") or parent:FindFirstChildOfClass("IntValue") or parent:FindFirstChild("Value")
                        if val and val.Value > 0 then
                            isWinner = true
                        end
                        
                        -- 2. نظام الكشف البصري البرمجي (للأطباق المتشقلبة)
                        -- إذا كان هناك عنصر "Food" أو "Popcorn" مرئي تحت الطبق الشفاف
                        if not isWinner then
                            local visual = parent:FindFirstChild("Food") or parent:FindFirstChild("Popcorn") or parent:FindFirstChild("Model")
                            if visual and visual.Transparency < 1 then
                                isWinner = true
                            end
                        end
                        
                        -- 3. نظام "صيد" المكسب (التنفيذ بسرعة 10ms)
                        if isWinner then
                            fireclickdetector(obj)
                            -- تجميد مؤقت لمنع الـ Kick بسبب السرعة الزائدة بعد المكسب
                            task.wait(0.01) 
                        end
                    end
                end
            end)
        end
        task.wait(0.01) -- التردد العالمي 10ms
    end
end)

-- [[ واجهة المستخدم الحديثة 2026 ]] --
local Main = Instance.new("Frame", Crystal)
Main.Size = UDim2.new(0, 240, 0, 140)
Main.Position = UDim2.new(0.5, -120, 0.4, -70)
Main.BackgroundColor3 = Color3.fromRGB(15, 20, 30)
Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 15)

-- تأثير التوهج (Glow)
local UIStroke = Instance.new("UIStroke", Main)
UIStroke.Color = Color3.fromRGB(45, 85, 160)
UIStroke.Thickness = 2
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Text = "CRYSTAL AI - GOD MODE"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.Orbitron -- خط مستقبلي
Title.TextSize = 16
Title.BackgroundTransparency = 1

local StartBtn = Instance.new("TextButton", Main)
StartBtn.Size = UDim2.new(0, 200, 0, 50)
StartBtn.Position = UDim2.new(0.5, -100, 0.5, 0)
StartBtn.BackgroundColor3 = Color3.fromRGB(135, 55, 55)
StartBtn.Text = "ACTIVATE WINNER MODE"
StartBtn.TextColor3 = Color3.new(1, 1, 1)
StartBtn.Font = Enum.Font.GothamBold
StartBtn.TextSize = 14
StartBtn.AutoButtonColor = false
Instance.new("UICorner", StartBtn).CornerRadius = UDim.new(0, 10)

StartBtn.MouseButton1Click:Connect(function()
    Toggles.AutoPop = not Toggles.AutoPop
    StartBtn.Text = Toggles.AutoPop and "SYSTEM ONLINE" or "ACTIVATE WINNER MODE"
    
    local targetColor = Toggles.AutoPop and Color3.fromRGB(55, 120, 85) or Color3.fromRGB(135, 55, 55)
    TweenService:Create(StartBtn, TweenInfo.new(0.4), {BackgroundColor3 = targetColor}):Play()
    TweenService:Create(UIStroke, TweenInfo.new(0.4), {Color = targetColor}):Play()
end)

-- نظام السحب الذكي
local dragging, dragStart, startPos
Main.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true dragStart = i.Position startPos = Main.Position
    end
end)
UserInputService.InputChanged:Connect(function(i)
    if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
        local d = i.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
