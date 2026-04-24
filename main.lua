-- [[ Crystal Hub - Clean Version ]] --

if game:GetService("CoreGui"):FindFirstChild("Crystal_Clean") then
    game:GetService("CoreGui").Crystal_Clean:Destroy()
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local UserInputService = game:GetService("UserInputService")
local Player = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")

local CrystalPurple = Color3.fromRGB(120, 0, 255)

local Toggles = {
    Esp = false,
    BatAimbot = false,
    StealNearest = false,
    AutoMedusa = false,
    AntiFling = false,
    AntiRagdoll = false,
    NoWalk = false,
    InfJump = false,
    Spin = false,
    Optimizer = false,
}

-- ========== ESP ==========
local espConns = {}
local function createESP(plr)
    if plr == Player or not plr.Character then return end
    if plr.Character:FindFirstChild("ESP_BLUE") then return end
    local char = plr.Character
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local head = char:FindFirstChild("Head")
    if not (hrp and head) then return end
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP_BLUE"
    highlight.FillColor = CrystalPurple
    highlight.OutlineColor = CrystalPurple
    highlight.FillTransparency = 0.2
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = char
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_Name"
    billboard.Adornee = head
    billboard.Size = UDim2.new(0, 150, 0, 40)
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.Parent = char
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = plr.Name
    label.TextColor3 = CrystalPurple
    label.Font = Enum.Font.GothamBold
    label.TextScaled = true
    label.Parent = billboard
end
local function removeESP(plr)
    if not plr.Character then return end
    local h = plr.Character:FindFirstChild("ESP_BLUE")
    if h then h:Destroy() end
    local n = plr.Character:FindFirstChild("ESP_Name")
    if n then n:Destroy() end
end
local function toggleESP(enable)
    if enable then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= Player then
                if plr.Character then createESP(plr) end
                table.insert(espConns, plr.CharacterAdded:Connect(function()
                    task.wait(0.2)
                    if Toggles.Esp then createESP(plr) end
                end))
            end
        end
        table.insert(espConns, Players.PlayerAdded:Connect(function(plr)
            if plr == Player then return end
            table.insert(espConns, plr.CharacterAdded:Connect(function()
                task.wait(0.2)
                if Toggles.Esp then createESP(plr) end
            end))
        end))
    else
        for _, plr in ipairs(Players:GetPlayers()) do removeESP(plr) end
        for _, c in ipairs(espConns) do if c then c:Disconnect() end end
        espConns = {}
    end
end

-- ========== BAT AIMBOT ==========
local batAimbotActive = false
local batConn = nil
local function startBatAimbot()
    if batConn then return end
    batConn = RunService.RenderStepped:Connect(function()
        if not batAimbotActive then return end
        local char = Player.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end
        local target, minD = nil, 8
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= Player and plr.Character then
                local tHrp = plr.Character:FindFirstChild("HumanoidRootPart")
                if tHrp then
                    local d = (tHrp.Position - hrp.Position).Magnitude
                    if d < minD then target, minD = tHrp, d end
                end
            end
        end
        if target then
            hrp.CFrame = CFrame.lookAt(hrp.Position, Vector3.new(target.Position.X, hrp.Position.Y, target.Position.Z))
            if minD < 4 then
                local bat = char:FindFirstChild("Bat") or Player.Backpack:FindFirstChild("Bat")
                if bat then
                    if bat.Parent ~= char then hum:EquipTool(bat) end
                    pcall(function() bat:Activate() end)
                end
            end
            hrp.AssemblyLinearVelocity = (target.Position - hrp.Position).Unit * 55
        end
    end)
end
local function stopBatAimbot()
    if batConn then batConn:Disconnect() batConn = nil end
end

-- ========== ANTI FLING ==========
local antiFlingConn = nil
local function startAntiFling()
    if antiFlingConn then return end
    antiFlingConn = RunService.Heartbeat:Connect(function()
        if Toggles.AntiFling and Player.Character then
            local hrp = Player.Character:FindFirstChild("HumanoidRootPart")
            if hrp and hrp.AssemblyLinearVelocity.Magnitude > 150 then
                hrp.AssemblyLinearVelocity = Vector3.zero
            end
        end
    end)
end
local function stopAntiFling()
    if antiFlingConn then antiFlingConn:Disconnect() antiFlingConn = nil end
end

-- ========== ANTI RAGDOLL ==========
local function startAntiRagdoll()
    local function fixChar(char)
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
        end
    end
    if Player.Character then fixChar(Player.Character) end
    Player.CharacterAdded:Connect(fixChar)
end

-- ========== NO WALK (UNWALK) ==========
local unwalkConn = nil
local function startNoWalk()
    if unwalkConn then unwalkConn:Disconnect() end
    unwalkConn = RunService.Heartbeat:Connect(function()
        if not Toggles.NoWalk then return end
        local char = Player.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        local anim = hum:FindFirstChildOfClass("Animator")
        if anim then
            for _, t in pairs(anim:GetPlayingAnimationTracks()) do
                local n = t.Name:lower()
                if n:find("walk") or n:find("run") or n:find("jump") then
                    t:Stop(0)
                end
            end
        end
    end)
end
local function stopNoWalk()
    if unwalkConn then unwalkConn:Disconnect() unwalkConn = nil end
end

-- ========== INFINITE JUMP ==========
local infConn = nil
local function startInfJump()
    if infConn then return end
    infConn = UserInputService.JumpRequest:Connect(function()
        if Toggles.InfJump and Player.Character then
            local hrp = Player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, 50, hrp.AssemblyLinearVelocity.Z)
            end
        end
    end)
end
local function stopInfJump()
    if infConn then infConn:Disconnect() infConn = nil end
end

-- ========== SPIN ==========
local spinForce = nil
local function startSpin()
    local char = Player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    if spinForce then spinForce:Destroy() end
    spinForce = Instance.new("BodyAngularVelocity")
    spinForce.Name = "SpinForce"
    spinForce.AngularVelocity = Vector3.new(0, 30, 0)
    spinForce.MaxTorque = Vector3.new(0, math.huge, 0)
    spinForce.Parent = root
end
local function stopSpin()
    if spinForce then spinForce:Destroy() spinForce = nil end
end

-- ========== OPTIMIZER ==========
local optimizerActive = false
local function enableOptimizer()
    if optimizerActive then return end
    optimizerActive = true
    Lighting.GlobalShadows = false
    Lighting.FogStart = 0
    Lighting.FogEnd = 1e9
    Lighting.Brightness = 1
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Material = Enum.Material.Plastic
        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Fire") then
            v.Enabled = false
        elseif v:IsA("Decal") or v:IsA("Texture") then
            v.Transparency = 1
        end
    end
end
local function disableOptimizer()
    if not optimizerActive then return end
    optimizerActive = false
    Lighting.GlobalShadows = true
    Lighting.FogEnd = 100000
    Lighting.Brightness = 2
end

-- ========== AUTO STEAL (بسيط وسريع) ==========
local stealActive = false
local stealing = false
local stealConnection = nil

local function findNearestSteal()
    local char = Player.Character
    if not char then return nil end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return nil end
    local nearest, minDist = nil, 15
    for _, plot in ipairs(plots:GetChildren()) do
        local sign = plot:FindFirstChild("PlotSign")
        if sign then
            local yb = sign:FindFirstChild("YourBase")
            if yb and yb:IsA("BillboardGui") and yb.Enabled then
            else
                local pods = plot:FindFirstChild("AnimalPodiums")
                if pods then
                    for _, pod in ipairs(pods:GetChildren()) do
                        local base = pod:FindFirstChild("Base")
                        local spawn = base and base:FindFirstChild("Spawn")
                        if spawn then
                            local dist = (spawn.Position - hrp.Position).Magnitude
                            if dist < minDist then
                                local att = spawn:FindFirstChild("PromptAttachment")
                                if att then
                                    for _, p in ipairs(att:GetChildren()) do
                                        if p:IsA("ProximityPrompt") then
                                            nearest, minDist = p, dist
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return nearest
end

local function doSteal(prompt)
    if stealing then return end
    stealing = true
    pcall(function()
        prompt:InputHoldBegin()
        task.wait(0.3)
        prompt:InputHoldEnd()
    end)
    stealing = false
end

local function startSteal()
    if stealConnection then return end
    stealConnection = RunService.Heartbeat:Connect(function()
        if stealActive and not stealing then
            local p = findNearestSteal()
            if p then doSteal(p) end
        end
    end)
end
local function stopSteal()
    if stealConnection then stealConnection:Disconnect() stealConnection = nil end
    stealing = false
end

-- ========== AUTO MEDUSA ==========
local medLast = 0
task.spawn(function()
    while true do
        if Toggles.AutoMedusa then
            pcall(function()
                local char = Player.Character
                if char then
                    local root = char:FindFirstChild("HumanoidRootPart")
                    if root then
                        local med = nil
                        for _, t in ipairs(char:GetChildren()) do
                            if t:IsA("Tool") and t.Name == "Medusa's Head" then med = t; break end
                        end
                        if med and tick() - medLast >= 0.15 then
                            for _, plr in ipairs(Players:GetPlayers()) do
                                if plr ~= Player and plr.Character then
                                    local pRoot = plr.Character:FindFirstChild("HumanoidRootPart")
                                    if pRoot and (pRoot.Position - root.Position).Magnitude <= 10 then
                                        med:Activate()
                                        medLast = tick()
                                        break
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        end
        task.wait(0.1)
    end
end)

-- ========== AUTO PLAY ==========
local playActive = false
local playConn = nil
local waypoints = {
    Vector3.new(-476.14, -6.90, 25.66),
    Vector3.new(-482.98, -5.27, 24.82),
    Vector3.new(-476.80, -6.57, 94.64),
    Vector3.new(-482.82, -5.27, 94.81),
}
local wpIndex = 1
local function startAutoPlay()
    if playConn then return end
    playActive = true
    playConn = RunService.Heartbeat:Connect(function()
        if Toggles.AutoPlay and Player.Character then
            local hum = Player.Character:FindFirstChildOfClass("Humanoid")
            local root = Player.Character:FindFirstChild("HumanoidRootPart")
            if hum and root then
                local target = waypoints[wpIndex]
                hum:MoveTo(target)
                if (root.Position - target).Magnitude < 3 then
                    wpIndex = wpIndex % #waypoints + 1
                end
            end
        end
    end)
end
local function stopAutoPlay()
    if playConn then playConn:Disconnect() playConn = nil end
    playActive = false
end

-- ========== GUI ==========
for _, c in pairs(CoreGui:GetChildren()) do
    if c:IsA("ScreenGui") and c.Name:find("Crystal") then c:Destroy() end
end

local sg = Instance.new("ScreenGui", CoreGui)
sg.Name = "Crystal_Clean"

local MainFrame = Instance.new("Frame", sg)
MainFrame.Size = UDim2.new(0, 220, 0, 60)
MainFrame.Position = UDim2.new(0.5, -110, 0.02, 0)
MainFrame.BackgroundTransparency = 1

local Top = Instance.new("Frame", MainFrame)
Top.Size = UDim2.new(1, 0, 0, 32)
Top.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Top.BackgroundTransparency = 0.15
Instance.new("UICorner", Top).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", Top).Color = CrystalPurple

local Title = Instance.new("TextLabel", Top)
Title.Size = UDim2.new(1, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.Text = "Crystal Hub | Loading..."
Title.TextColor3 = CrystalPurple
Title.TextSize = 12
Title.Font = Enum.Font.GothamBold

local Bottom = Instance.new("Frame", MainFrame)
Bottom.Size = UDim2.new(1, 0, 0, 14)
Bottom.Position = UDim2.new(0, 0, 0, 38)
Bottom.BackgroundTransparency = 1

local function addStat(x, txt)
    local f = Instance.new("Frame", Bottom)
    f.Size = UDim2.new(0.48, 0, 1, 0)
    f.Position = UDim2.new(x, 0, 0, 0)
    f.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    f.BackgroundTransparency = 0.5
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 10)
    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(1, 0, 1, 0)
    l.BackgroundTransparency = 1
    l.Text = txt
    l.TextColor3 = Color3.fromRGB(255, 255, 255)
    l.TextSize = 9
    l.Font = Enum.Font.GothamBold
end
addStat(0, "0%")
addStat(0.52, "7.4")

local Menu = Instance.new("Frame", sg)
Menu.Size = UDim2.new(0, 160, 0, 340)
Menu.Position = UDim2.new(-0.7, 0, 0.5, -170)
Menu.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Menu.BackgroundTransparency = 0.4
Instance.new("UICorner", Menu).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", Menu).Color = CrystalPurple

local Layout = Instance.new("UIListLayout", Menu)
Layout.Padding = UDim.new(0, 6)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local btnEsp = Instance.new("TextButton", Menu)
btnEsp.Size = UDim2.new(0, 140, 0, 34)
btnEsp.BackgroundColor3 = Toggles.Esp and CrystalPurple or Color3.fromRGB(0, 0, 0)
btnEsp.BackgroundTransparency = Toggles.Esp and 0 or 0.3
btnEsp.Text = "Esp Player"
btnEsp.TextColor3 = Color3.fromRGB(255, 255, 255)
btnEsp.Font = Enum.Font.GothamBold
btnEsp.TextSize = 11
Instance.new("UICorner", btnEsp).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", btnEsp).Color = CrystalPurple

local function makeRow(parent)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(0, 140, 0, 34)
    f.BackgroundTransparency = 1
    local l = Instance.new("UIListLayout", f)
    l.FillDirection = Enum.FillDirection.Horizontal
    l.Padding = UDim.new(0, 8)
    l.HorizontalAlignment = Enum.HorizontalAlignment.Center
    return f
end

local function makeBtn(parent, txt, w)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(0, w or 66, 0, 34)
    b.Text = txt
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 10
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
    Instance.new("UIStroke", b).Color = CrystalPurple
    return b
end

local R1 = makeRow(Menu)
local btnBat = makeBtn(R1, "Bat Aimbot", 66)
local btnSteal = makeBtn(R1, "Steal Nearest", 66)

local R2 = makeRow(Menu)
local btnMed = makeBtn(R2, "Auto Medusa", 66)
local btnPlay = makeBtn(R2, "Auto Play", 66)

local R3 = makeRow(Menu)
local btnFling = makeBtn(R3, "Anti Fling", 66)
local btnRag = makeBtn(R3, "Anti Ragdoll", 66)

local R4 = makeRow(Menu)
local btnWalk = makeBtn(R4, "No Walk", 66)
local btnJump = makeBtn(R4, "Infinite Jump", 66)

local R5 = makeRow(Menu)
local btnSpin = makeBtn(R5, "Spin Player", 66)
local btnOpt = makeBtn(R5, "Optimizer", 66)

-- تحديثات الأزرار
local function updateBtn(btn, state)
    btn.BackgroundColor3 = state and CrystalPurple or Color3.fromRGB(0, 0, 0)
    btn.BackgroundTransparency = state and 0 or 0.3
end

btnEsp.MouseButton1Click:Connect(function()
    Toggles.Esp = not Toggles.Esp
    updateBtn(btnEsp, Toggles.Esp)
    toggleESP(Toggles.Esp)
end)

btnBat.MouseButton1Click:Connect(function()
    Toggles.BatAimbot = not Toggles.BatAimbot
    updateBtn(btnBat, Toggles.BatAimbot)
    batAimbotActive = Toggles.BatAimbot
    if batAimbotActive then startBatAimbot() else stopBatAimbot() end
end)

btnSteal.MouseButton1Click:Connect(function()
    Toggles.StealNearest = not Toggles.StealNearest
    updateBtn(btnSteal, Toggles.StealNearest)
    stealActive = Toggles.StealNearest
    if stealActive then startSteal() else stopSteal() end
end)

btnMed.MouseButton1Click:Connect(function()
    Toggles.AutoMedusa = not Toggles.AutoMedusa
    updateBtn(btnMed, Toggles.AutoMedusa)
end)

btnPlay.MouseButton1Click:Connect(function()
    Toggles.AutoPlay = not Toggles.AutoPlay
    updateBtn(btnPlay, Toggles.AutoPlay)
    if Toggles.AutoPlay then startAutoPlay() else stopAutoPlay() end
end)

btnFling.MouseButton1Click:Connect(function()
    Toggles.AntiFling = not Toggles.AntiFling
    updateBtn(btnFling, Toggles.AntiFling)
    if Toggles.AntiFling then startAntiFling() else stopAntiFling() end
end)

btnRag.MouseButton1Click:Connect(function()
    Toggles.AntiRagdoll = not Toggles.AntiRagdoll
    updateBtn(btnRag, Toggles.AntiRagdoll)
    if Toggles.AntiRagdoll then startAntiRagdoll() end
end)

btnWalk.MouseButton1Click:Connect(function()
    Toggles.NoWalk = not Toggles.NoWalk
    updateBtn(btnWalk, Toggles.NoWalk)
    if Toggles.NoWalk then startNoWalk() else stopNoWalk() end
end)

btnJump.MouseButton1Click:Connect(function()
    Toggles.InfJump = not Toggles.InfJump
    updateBtn(btnJump, Toggles.InfJump)
    if Toggles.InfJump then startInfJump() else stopInfJump() end
end)

btnSpin.MouseButton1Click:Connect(function()
    Toggles.Spin = not Toggles.Spin
    updateBtn(btnSpin, Toggles.Spin)
    if Toggles.Spin then startSpin() else stopSpin() end
end)

btnOpt.MouseButton1Click:Connect(function()
    Toggles.Optimizer = not Toggles.Optimizer
    updateBtn(btnOpt, Toggles.Optimizer)
    if Toggles.Optimizer then enableOptimizer() else disableOptimizer() end
end)

-- أيقونة القائمة
local FloatBtn = Instance.new("TextButton", sg)
FloatBtn.Size = UDim2.new(0, 50, 0, 50)
FloatBtn.Position = UDim2.new(1, -65, 0.3, 0)
FloatBtn.BackgroundColor3 = CrystalPurple
FloatBtn.Text = ""
Instance.new("UICorner", FloatBtn).CornerRadius = UDim.new(0, 10)

for i = 0, 2 do
    local line = Instance.new("Frame", FloatBtn)
    line.Size = UDim2.new(0, 24, 0, 3)
    line.Position = UDim2.new(0.5, -12, 0, 15 + (i * 9))
    line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", line).CornerRadius = UDim.new(0, 2)
end

local menuVis = false
FloatBtn.MouseButton1Click:Connect(function()
    menuVis = not menuVis
    Menu:TweenPosition(UDim2.new(menuVis and 0.02 or -0.7, 0, 0.5, -170), "Out", "Quart", 0.4, true)
end)

task.spawn(function()
    while true do
        pcall(function()
            local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            local fps = math.floor(1 / RunService.RenderStepped:Wait())
            Title.Text = "Crystal Hub | FPS " .. fps .. " | MS " .. ping
        end)
        task.wait(0.5)
    end
end)

updateBtn(btnEsp, Toggles.Esp)
updateBtn(btnBat, Toggles.BatAimbot)
updateBtn(btnSteal, Toggles.StealNearest)
updateBtn(btnMed, Toggles.AutoMedusa)
updateBtn(btnPlay, Toggles.AutoPlay)
updateBtn(btnFling, Toggles.AntiFling)
updateBtn(btnRag, Toggles.AntiRagdoll)
updateBtn(btnWalk, Toggles.NoWalk)
updateBtn(btnJump, Toggles.InfJump)
updateBtn(btnSpin, Toggles.Spin)
updateBtn(btnOpt, Toggles.Optimizer)

print("Crystal Hub Loaded!")
