-- [[ Crystal AI - Aggressive Force Edition ]] --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- التأكد من الوصول للريموت مباشرة
local GameRemote = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Remotes"):WaitForChild("MinigameGameAction")

-- [ الواجهة ] --
if CoreGui:FindFirstChild("CrystalForce") then CoreGui:FindFirstChild("CrystalForce"):Destroy() end
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "CrystalForce"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 200, 0, 100)
Main.Position = UDim2.new(0.5, -100, 0.2, 0)
Main.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main)

local ToggleBtn = Instance.new("TextButton", Main)
ToggleBtn.Size = UDim2.new(0, 160, 0, 40)
ToggleBtn.Position = UDim2.new(0.5, -80, 0.5, -10)
ToggleBtn.Text = "AUTO PLAY: OFF"
ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", ToggleBtn)

local IsActive = false
ToggleBtn.MouseButton1Click:Connect(function()
    IsActive = not IsActive
    ToggleBtn.Text = IsActive and "AI: ACTIVE ✅" or "AI: OFF ❌"
    ToggleBtn.BackgroundColor3 = IsActive and Color3.fromRGB(0, 150, 80) or Color3.fromRGB(50, 50, 60)
end)

-- [ منطق اللعب المباشر ] --
-- لو مش عارفين نقرأ اللوحة، السكربت هيجرب يرمي في العواميد المتاحة بالترتيب
local columns = {4, 3, 5, 2, 6, 1, 7}

RunService.Heartbeat:Connect(function()
    if not IsActive then return end
    
    -- محاولة إرسال أمر اللعب (السيرفر هيرفض لو مش دورك، فمش هنخسر حاجة)
    pcall(function()
        for _, col in ipairs(columns) do
            -- بنجرب نلعب في كل عمود لغاية ما السيرفر يقبل واحد
            GameRemote:FireServer("DropChip", col)
        end
    end)
    
    -- انتظار بسيط عشان ميعملش Kick بسبب الـ Spam
    task.wait(0.8) 
end)
