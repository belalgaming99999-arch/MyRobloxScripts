-- سكربت مبسط ومضمون (تم تجميعه من ميزات HONEY DUELS)
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- إعدادات عامة
local speed = 56          -- سرعة الحركة العادية
local stealSpeed = 29     -- سرعة أثناء السرقة
local jumpPower = 75      -- قوة القفز
local isStealing = false

-- ***** قفل الهدف وتتبعه (Lock Player) *****
local lockEnabled = false
local lockedTarget = nil
local lockConnection = nil
local function lockPlayer()
    if lockConnection then lockConnection:Disconnect() end
    lockConnection = RunService.Heartbeat:Connect(function()
        if not lockEnabled then return end
        local char = LocalPlayer.Character
        local myRoot = char and char:FindFirstChild("HumanoidRootPart")
        if not myRoot then return end
        local closest, closestDist = nil, math.huge
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local theirRoot = p.Character:FindFirstChild("HumanoidRootPart")
                if theirRoot then
                    local d = (myRoot.Position - theirRoot.Position).Magnitude
                    if d < closestDist then closestDist = d; closest = p.Character end
                end
            end
        end
        lockedTarget = closest
        -- حركة التتبع
        if lockedTarget then
            local targetHRP = lockedTarget:FindFirstChild("HumanoidRootPart")
            if targetHRP then
                local dir = (targetHRP.Position - myRoot.Position)
                local flatDir = Vector3.new(dir.X, 0, dir.Z).Unit
                myRoot.AssemblyLinearVelocity = flatDir * 58
            end
        end
    end)
end

-- ***** منع السقوط (Anti-Ragdoll) *****
local antiRagdollConn = nil
local function antiRagdoll()
    if antiRagdollConn then antiRagdollConn:Disconnect() end
    antiRagdollConn = RunService.Heartbeat:Connect(function()
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum and (hum:GetState() == Enum.HumanoidStateType.Ragdoll or hum:GetState() == Enum.HumanoidStateType.FallingDown) then
            hum:ChangeState(Enum.HumanoidStateType.Running)
        end
    end)
end

-- ***** سرقة تلقائية (Auto Steal) *****
local autoStealEnabled = false
local autoStealConn = nil
local function autoSteal()
    if autoStealConn then autoStealConn:Disconnect() end
    autoStealConn = RunService.Heartbeat:Connect(function()
        if not autoStealEnabled then return end
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            for _, prompt in pairs(workspace:GetDescendants()) do
                if prompt:IsA("ProximityPrompt") and prompt.ActionText == "Steal" then
                    local distance = (hrp.Position - prompt.Parent.Position).Magnitude
                    if distance < 10 then
                        pcall(function() fireproximityprompt(prompt) end)
                    end
                end
            end
        end
    end)
end

-- ***** قفز لا نهائي وجاذبية *****
local infJump = false
UserInputService.JumpRequest:Connect(function()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp and infJump then hrp.Velocity = Vector3.new(hrp.Velocity.X, jumpPower, hrp.Velocity.Z) end
end)

-- ***** مراقبة السرقة (لتحديد السرعة) *****
LocalPlayer:GetAttributeChangedSignal("Stealing"):Connect(function()
    isStealing = LocalPlayer:GetAttribute("Stealing") == true
end)

-- ***** تحسين سرعة الحركة *****
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hrp and hum and hum.MoveDirection.Magnitude > 0.1 then
        local currentSpeed = isStealing and stealSpeed or speed
        hrp.AssemblyLinearVelocity = hum.MoveDirection * currentSpeed + Vector3.new(0, hrp.AssemblyLinearVelocity.Y, 0)
    end
end)

-- ***** تشغيل الميزات الأساسية *****
antiRagdoll()                     -- تفعيل منع السقوط
autoSteal()                       -- تفعيل السرقة التلقائية
lockPlayer()                      -- تفعيل قفل الهدف (اختياري)
