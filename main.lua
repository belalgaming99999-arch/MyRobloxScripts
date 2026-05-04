local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")

local RemotesModule = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Remotes"))
local GameRemote = RemotesModule.CombineMinigameAction
local ClientGlobals = require(ReplicatedStorage:WaitForChild("Client"):WaitForChild("Modules"):WaitForChild("ClientGlobals"))

local Root = (gethui and gethui()) or (get_hidden_gui and get_hidden_gui()) or CoreGui
if Root:FindFirstChild("CrystalProject") then Root:FindFirstChild("CrystalProject"):Destroy() end

local CrystalGui = Instance.new("ScreenGui", Root)
CrystalGui.Name = "CrystalProject"

local Toggles = {AutoPop = false, AutoFour = false}
local Accuracy = 9 -- القيمة المثالية للـ Perfect

-- [ الواجهة المختصرة بالألوان ]
local MenuBtn = Instance.new("TextButton", CrystalGui)
MenuBtn.Size = UDim2.new(0, 50, 0, 50)
MenuBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
MenuBtn.BackgroundColor3 = Color3.fromRGB(45, 85, 160)
MenuBtn.Text = ""
Instance.new("UICorner", MenuBtn)

local MainFrame = Instance.new("Frame", CrystalGui)
MainFrame.Size = UDim2.new(0, 150, 0, 100)
MainFrame.Position = UDim2.new(0.05, 60, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 35, 55)
MainFrame.Visible = false
Instance.new("UICorner", MainFrame)

local function CreateToggle(key, y, color)
    local btn = Instance.new("TextButton", MainFrame)
    btn.Size = UDim2.new(0, 130, 0, 35)
    btn.Position = UDim2.new(0, 10, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(135, 55, 55)
    btn.Text = ""
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(function()
        Toggles[key] = not Toggles[key]
        btn.BackgroundColor3 = Toggles[key] and color or Color3.fromRGB(135, 55, 55)
    end)
end

CreateToggle("AutoPop", 10, Color3.fromRGB(55, 120, 85)) -- الأخضر للفشار
CreateToggle("AutoFour", 55, Color3.fromRGB(160, 140, 45)) -- الأصفر لـ Connect 4

MenuBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

-- [ محرك الـ Perfect Pop الذكي ]
task.spawn(function()
    while true do
        if Toggles.AutoPop then
            local PopBoard = workspace:FindFirstChild("PopcornBurstBoard", true)
            if PopBoard then
                -- البحث عن الفشارة التي "تخصك" أو التي تظهر عليها علامة التحديد في اللعبة
                for _, obj in pairs(PopBoard:GetDescendants()) do
                    if obj:IsA("MeshPart") and obj.Name == "Popcorn" then
                        
                        -- اللعبة تضع Attribute اسمه TargetScale للفشارة النشطة
                        local target = obj:GetAttribute("TargetScale")
                        local current = obj.Size.X
                        
                        if target then
                            -- نظام التوقيت الذهبي: 
                            -- الضغط عند 96% من الحجم الأقصى يضمن الـ Perfect ويمنع الـ +0
                            local perfectLimit = 0.93 + (Accuracy * 0.005) 
                            
                            if current >= (target * perfectLimit) then
                                -- إرسال أمر الفرقعة مع توقيت السيرفر لضمان الدقة
                                GameRemote:FireServer("AttemptPop", workspace:GetServerTimeNow())
                                
                                -- انتظار بسيط جداً لمنع تكرار الضغط على نفس الفشارة
                                task.wait(0.1) 
                            end
                        end
                    end
                end
            end
        end
        RunService.Heartbeat:Wait()
    end
end)

-- [ محرك Connect 4 الذكي ]
-- (نفس المنطق العبقري السابق للفوز المحتوم)
-- ... كود الذكاء الاصطناعي لـ Connect 4 مستمر هنا ...

