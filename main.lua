-- leaked by https://discord.gg/WfTDsBPR9n join for more sources

repeat task.wait() until game:IsLoaded()

local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local UserInputService  = game:GetService("UserInputService")
local TweenService      = game:GetService("TweenService")
local SoundService      = game:GetService("SoundService")
local Lighting          = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService       = game:GetService("HttpService")
local Player            = Players.LocalPlayer

local function waitForCharacter()
    local char = Player.Character
    if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChildOfClass("Humanoid") then return char end
    return Player.CharacterAdded:Wait()
end
task.spawn(waitForCharacter)

if not getgenv then getgenv = function() return _G end end

-- ============================================================
-- STATE
-- ============================================================
local ConfigFileName = "ZAY_DUELS_Config.json"

local Enabled = {
    SpeedBoost         = false,
    AntiRagdoll        = false,
    SpinBot            = false,
    SpeedWhileStealing = false,
    AutoSteal          = false,
    Unwalk             = false,
    Optimizer          = false,
    Galaxy             = false,
    SpamBat            = false,
    AutoDisableSpeed   = true,
    AutoWalkEnabled    = false,
    AutoRightEnabled   = false,
    ScriptUserESP      = true,
    InfiniteJump       = false,
    NoDie              = false,
    Aimbot             = false,
    Float              = false,
    FullAutoDuel       = false,
}

local Values = {
    BoostSpeed           = 30,
    SpinSpeed            = 30,
    StealingSpeedValue   = 29,
    STEAL_RADIUS         = 20,
    STEAL_DURATION       = 1.3,
    DEFAULT_GRAVITY      = 196.2,
    GalaxyGravityPercent = 70,
    HOP_POWER            = 35,
    HOP_COOLDOWN         = 0.08,
    FOV                  = 70,
    FloatHeight          = 8,
}

local KEYBINDS = {
    SPEED       = Enum.KeyCode.V,
    SPIN        = Enum.KeyCode.N,
    GALAXY      = Enum.KeyCode.M,
    AUTOLEFT    = Enum.KeyCode.Z,
    AUTORIGHT   = Enum.KeyCode.C,
    ANTIRAGDOLL    = Enum.KeyCode.Unknown,
    AIMBOT         = Enum.KeyCode.Unknown,
    FLOAT          = Enum.KeyCode.Unknown,
    FULLAUTODUEL   = Enum.KeyCode.Unknown,
}

-- ============================================================
-- CONFIG
-- ============================================================
local function SaveConfig()
    local data = {}
    for k,v in pairs(Enabled)  do data[k]         = v end
    for k,v in pairs(Values)   do data[k]         = v end
    for k,v in pairs(KEYBINDS) do data["KEY_"..k] = v.Name end
    local ok = false
    if writefile then
        pcall(function() writefile(ConfigFileName, HttpService:JSONEncode(data)); ok=true end)
    end
    return ok
end

local function LoadConfig()
    pcall(function()
        if readfile and isfile and isfile(ConfigFileName) then
            local data = HttpService:JSONDecode(readfile(ConfigFileName))
            if data then
                for k,v in pairs(data) do
                    if Enabled[k] ~= nil then Enabled[k] = v end
                    if Values[k]  ~= nil then Values[k]  = v end
                end
                for k in pairs(KEYBINDS) do
                    local key = "KEY_"..k
                    if data[key] then
                        local ok,kc = pcall(function() return Enum.KeyCode[data[key]] end)
                        if ok and kc then KEYBINDS[k] = kc end
                    end
                end
            end
        end
    end)
end
LoadConfig()

-- ============================================================
-- BACKEND
-- ============================================================
local Connections        = { infiniteJump = {heartbeat=nil,jumpRequest=nil} }
local lastBatSwing       = 0
local BAT_SWING_COOLDOWN = 0.12

local SlapList = {
    {1,"Bat"},{2,"Slap"},{3,"Iron Slap"},{4,"Gold Slap"},
    {5,"Diamond Slap"},{6,"Emerald Slap"},{7,"Ruby Slap"},
    {8,"Dark Matter Slap"},{9,"Flame Slap"},{10,"Nuclear Slap"},
    {11,"Galaxy Slap"},{12,"Glitched Slap"},
}

local function getNearestPlayer()
    local c = Player.Character if not c then return nil end
    local h = c:FindFirstChild("HumanoidRootPart") if not h then return nil end
    local nearest, dist = nil, math.huge
    for _,p in ipairs(Players:GetPlayers()) do
        if p ~= Player and p.Character then
            local oh = p.Character:FindFirstChild("HumanoidRootPart")
            if oh then local d=(h.Position-oh.Position).Magnitude if d<dist then dist=d; nearest=p end end
        end
    end
    return nearest
end

local function findBat()
    local c = Player.Character if not c then return nil end
    local bp = Player:FindFirstChildOfClass("Backpack")
    for _,ch in ipairs(c:GetChildren()) do
        if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end
    end
    if bp then
        for _,ch in ipairs(bp:GetChildren()) do
            if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end
        end
    end
    for _,i in ipairs(SlapList) do
        local t = c:FindFirstChild(i[2]) or (bp and bp:FindFirstChild(i[2]))
        if t then return t end
    end
    return nil
end

local function startSpamBat()
    if Connections.spamBat then return end
    Connections.spamBat = RunService.Heartbeat:Connect(function()
        if not Enabled.SpamBat then return end
        local c = Player.Character if not c then return end
        local bat = findBat() if not bat then return end
        if bat.Parent ~= c then bat.Parent = c end
        local now = tick()
        if now - lastBatSwing < BAT_SWING_COOLDOWN then return end
        lastBatSwing = now
        pcall(function() bat:Activate() end)
    end)
end
local function stopSpamBat()
    if Connections.spamBat then Connections.spamBat:Disconnect(); Connections.spamBat=nil end
end

local spamBatCircle, spamBatCircleConn
local function createSpamBatCircle()
    if spamBatCircle then spamBatCircle:Destroy(); spamBatCircle=nil end
    local c = Player.Character if not c then return end
    local hrp = c:FindFirstChild("HumanoidRootPart") if not hrp then return end
    local circle = Instance.new("Part")
    circle.Name="ZAY_SpamBatCircle"; circle.Anchored=true; circle.CanCollide=false
    circle.CastShadow=false; circle.Material=Enum.Material.Neon
    circle.Color=Color3.fromRGB(200,200,200); circle.Shape=Enum.PartType.Cylinder
    circle.Size=Vector3.new(0.08,20,20); circle.Transparency=0.18; circle.Parent=workspace
    spamBatCircle = circle
end
local function removeSpamBatCircle()
    if spamBatCircle then spamBatCircle:Destroy(); spamBatCircle=nil end
    if spamBatCircleConn then spamBatCircleConn:Disconnect(); spamBatCircleConn=nil end
end
local function startSpamBatCircle()
    removeSpamBatCircle(); createSpamBatCircle()
    spamBatCircleConn = RunService.Heartbeat:Connect(function()
        if not Enabled.SpamBat then removeSpamBatCircle(); return end
        local c = Player.Character if not c then return end
        local hrp = c:FindFirstChild("HumanoidRootPart") if not hrp then return end
        if not spamBatCircle or not spamBatCircle.Parent then createSpamBatCircle(); return end
        spamBatCircle.CFrame = CFrame.new(hrp.Position.X,hrp.Position.Y-3.2,hrp.Position.Z)*CFrame.Angles(0,0,math.rad(90))
    end)
end

local spinBAV
local function startSpinBot()
    local c = Player.Character if not c then return end
    local hrp = c:FindFirstChild("HumanoidRootPart") if not hrp then return end
    if spinBAV then spinBAV:Destroy(); spinBAV=nil end
    for _,v in pairs(hrp:GetChildren()) do if v.Name=="SpinBAV" then v:Destroy() end end
    spinBAV = Instance.new("BodyAngularVelocity")
    spinBAV.Name="SpinBAV"; spinBAV.MaxTorque=Vector3.new(0,math.huge,0)
    spinBAV.AngularVelocity=Vector3.new(0,Values.SpinSpeed,0); spinBAV.Parent=hrp
end
local function stopSpinBot()
    if spinBAV then spinBAV:Destroy(); spinBAV=nil end
    local c = Player.Character
    if c then local hrp=c:FindFirstChild("HumanoidRootPart") if hrp then for _,v in pairs(hrp:GetChildren()) do if v.Name=="SpinBAV" then v:Destroy() end end end end
end

local AutoWalkEnabled  = false
local AutoRightEnabled = false
local onAutoRightDone  = nil
local onAutoLeftDone   = nil

RunService.Heartbeat:Connect(function()
    if Enabled.SpinBot and spinBAV then
        spinBAV.AngularVelocity = Player:GetAttribute("Stealing") and Vector3.new(0,0,0) or Vector3.new(0,Values.SpinSpeed,0)
    end
end)

local galaxyVectorForce, galaxyAttachment
local galaxyEnabled  = false
local hopsEnabled    = false
local lastHopTime    = 0
local spaceHeld      = false
local originalJumpPower = 50

local function captureJumpPower()
    local c = Player.Character if not c then return end
    local hum = c:FindFirstChildOfClass("Humanoid")
    if hum and hum.JumpPower > 0 then originalJumpPower = hum.JumpPower end
end
task.spawn(function() task.wait(1); captureJumpPower() end)
Player.CharacterAdded:Connect(function() task.wait(1); captureJumpPower() end)

local function setupGalaxyForce()
    pcall(function()
        local c = Player.Character if not c then return end
        local h = c:FindFirstChild("HumanoidRootPart") if not h then return end
        if galaxyVectorForce then galaxyVectorForce:Destroy() end
        if galaxyAttachment  then galaxyAttachment:Destroy()  end
        galaxyAttachment = Instance.new("Attachment"); galaxyAttachment.Parent = h
        galaxyVectorForce = Instance.new("VectorForce")
        galaxyVectorForce.Attachment0 = galaxyAttachment
        galaxyVectorForce.ApplyAtCenterOfMass = true
        galaxyVectorForce.RelativeTo = Enum.ActuatorRelativeTo.World
        galaxyVectorForce.Force = Vector3.new(0,0,0); galaxyVectorForce.Parent = h
    end)
end
local function updateGalaxyForce()
    if not galaxyEnabled or not galaxyVectorForce then return end
    local c = Player.Character if not c then return end
    local mass = 0
    for _,p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then mass+=p:GetMass() end end
    local tg = Values.DEFAULT_GRAVITY*(Values.GalaxyGravityPercent/100)
    galaxyVectorForce.Force = Vector3.new(0,mass*(Values.DEFAULT_GRAVITY-tg)*0.95,0)
end
local function adjustGalaxyJump()
    pcall(function()
        local c = Player.Character if not c then return end
        local hum = c:FindFirstChildOfClass("Humanoid") if not hum then return end
        if not galaxyEnabled then hum.JumpPower=originalJumpPower; return end
        local ratio = math.sqrt((Values.DEFAULT_GRAVITY*(Values.GalaxyGravityPercent/100))/Values.DEFAULT_GRAVITY)
        hum.JumpPower = originalJumpPower*ratio
    end)
end
local function doMiniHop()
    if not hopsEnabled then return end
    pcall(function()
        local c = Player.Character if not c then return end
        local h = c:FindFirstChild("HumanoidRootPart")
        local hum = c:FindFirstChildOfClass("Humanoid")
        if not h or not hum then return end
        if tick()-lastHopTime < Values.HOP_COOLDOWN then return end
        lastHopTime = tick()
        if hum.FloorMaterial == Enum.Material.Air then
            h.AssemblyLinearVelocity = Vector3.new(h.AssemblyLinearVelocity.X,Values.HOP_POWER,h.AssemblyLinearVelocity.Z)
        end
    end)
end
local function startGalaxy() galaxyEnabled=true; hopsEnabled=true; setupGalaxyForce(); adjustGalaxyJump() end
local function stopGalaxy()
    galaxyEnabled=false; hopsEnabled=false
    if galaxyVectorForce then galaxyVectorForce:Destroy(); galaxyVectorForce=nil end
    if galaxyAttachment  then galaxyAttachment:Destroy();  galaxyAttachment=nil  end
    adjustGalaxyJump()
end

RunService.Heartbeat:Connect(function()
    if hopsEnabled and spaceHeld then doMiniHop() end
    if galaxyEnabled then updateGalaxyForce() end
end)

local function getMovementDirection()
    local c = Player.Character if not c then return Vector3.zero end
    local hum = c:FindFirstChildOfClass("Humanoid")
    return hum and hum.MoveDirection or Vector3.zero
end

local function startSpeedBoost()
    if Connections.speed then return end
    Connections.speed = RunService.Heartbeat:Connect(function()
        if not Enabled.SpeedBoost then return end
        if Player:GetAttribute("Stealing") then return end
        pcall(function()
            local c = Player.Character if not c then return end
            local h = c:FindFirstChild("HumanoidRootPart") if not h then return end
            local md = getMovementDirection()
            if md.Magnitude > 0.1 then
                h.AssemblyLinearVelocity = Vector3.new(md.X*Values.BoostSpeed,h.AssemblyLinearVelocity.Y,md.Z*Values.BoostSpeed)
            end
        end)
    end)
end
local function stopSpeedBoost()
    if Connections.speed then Connections.speed:Disconnect(); Connections.speed=nil end
end

-- ============================================================
-- FLOAT BACKEND
--
-- Simple invisible-ground float:
--   HOVERING  → hold player at FloatHeight above real ground.
--   JUMPING   → zero out float force completely, let physics
--               (including Galaxy gravity) do the whole arc naturally.
--   LANDING   → once descending and back near float level, resume hover.
--               Hard clamp stops player sinking below float height.
-- ============================================================
local floatAttachment   = nil
local floatVectorForce  = nil
local floatInfJumpConn  = nil
local floatMassCache    = 0
local floatLastMassTime = 0
local FLOAT_MASS_INTERVAL = 2

local FLOAT_KP       = 380   -- spring toward float height (tune if too bouncy/slow)
local FLOAT_KD       = 70    -- velocity damping
local FLOAT_DEADZONE = 0.08

local floatJumping = false

local function getCharacterMassFloat(char)
    local mass = 0
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then mass = mass + part:GetMass() end
    end
    return mass
end

local function setupFloatObjects(char)
    if floatVectorForce then floatVectorForce:Destroy(); floatVectorForce = nil end
    if floatAttachment  then floatAttachment:Destroy();  floatAttachment  = nil end
    local hrp = char and char:FindFirstChild("HumanoidRootPart") if not hrp then return end
    floatAttachment        = Instance.new("Attachment")
    floatAttachment.Name   = "ZAY_FloatAttachment"
    floatAttachment.Parent = hrp
    floatVectorForce                    = Instance.new("VectorForce")
    floatVectorForce.Name               = "ZAY_FloatForce"
    floatVectorForce.Attachment0        = floatAttachment
    floatVectorForce.ApplyAtCenterOfMass = true
    floatVectorForce.RelativeTo         = Enum.ActuatorRelativeTo.World
    floatVectorForce.Force              = Vector3.new(0, 0, 0)
    floatVectorForce.Parent             = hrp
end

local function startFloat()
    if Connections.float then return end
    local char = Player.Character if not char then return end
    setupFloatObjects(char)
    floatMassCache    = getCharacterMassFloat(char)
    floatLastMassTime = tick()
    floatJumping      = false

    -- Mark jump start so we release float force for the whole arc
    if floatInfJumpConn then floatInfJumpConn:Disconnect() end
    floatInfJumpConn = UserInputService.JumpRequest:Connect(function()
        if not Enabled.Float then return end
        floatJumping = true
    end)

    Connections.float = RunService.Heartbeat:Connect(function()
        if not Enabled.Float then return end
        pcall(function()
            local c   = Player.Character if not c then return end
            local hrp = c:FindFirstChild("HumanoidRootPart") if not hrp then return end
            if not floatVectorForce or not floatVectorForce.Parent then setupFloatObjects(c) end

            local now = tick()
            if now - floatLastMassTime > FLOAT_MASS_INTERVAL then
                floatMassCache    = getCharacterMassFloat(c)
                floatLastMassTime = now
            end

            local velY = hrp.AssemblyLinearVelocity.Y

            -- Raycast to real ground below
            local rp = RaycastParams.new()
            rp.FilterDescendantsInstances = {c}
            rp.FilterType = Enum.RaycastFilterType.Exclude
            local ray     = workspace:Raycast(hrp.Position, Vector3.new(0, -500, 0), rp)
            local groundY = ray and ray.Position.Y or (hrp.Position.Y - Values.FloatHeight)
            local targetY = groundY + Values.FloatHeight
            local diff    = targetY - hrp.Position.Y  -- positive = below target

            -- ── JUMPING: force = 0, let all physics run freely ──────────────
            -- floatJumping stays true while still going up OR
            -- while still above float level on the way down.
            if floatJumping then
                if velY > 0 then
                    -- Still ascending — hands off completely
                    floatVectorForce.Force = Vector3.new(0, 0, 0)
                    return
                else
                    -- Descending — stay hands-off until we reach float height
                    if hrp.Position.Y > targetY + 0.3 then
                        floatVectorForce.Force = Vector3.new(0, 0, 0)
                        return
                    else
                        -- Back at float level — stop jump mode, clamp, resume hover
                        floatJumping = false
                        hrp.AssemblyLinearVelocity = Vector3.new(
                            hrp.AssemblyLinearVelocity.X, 0,
                            hrp.AssemblyLinearVelocity.Z
                        )
                    end
                end
            end

            -- ── HOVERING: PD controller holds float height ──────────────────
            local gravComp = floatMassCache * workspace.Gravity

            -- Deadzone: perfectly still, just cancel gravity
            if math.abs(diff) < FLOAT_DEADZONE and math.abs(velY) < 0.3 then
                floatVectorForce.Force = Vector3.new(0, gravComp, 0)
                return
            end

            local pdForce = floatMassCache * (FLOAT_KP * diff - FLOAT_KD * velY)
            floatVectorForce.Force = Vector3.new(0, gravComp + pdForce, 0)

            -- Hard floor: never go below float height
            if hrp.Position.Y < targetY and velY < 0 then
                hrp.AssemblyLinearVelocity = Vector3.new(
                    hrp.AssemblyLinearVelocity.X, 0, hrp.AssemblyLinearVelocity.Z
                )
            end
        end)
    end)
end

local function stopFloat()
    if Connections.float then Connections.float:Disconnect(); Connections.float = nil end
    if floatInfJumpConn  then floatInfJumpConn:Disconnect();  floatInfJumpConn  = nil end
    if floatVectorForce  then floatVectorForce:Destroy();     floatVectorForce  = nil end
    if floatAttachment   then floatAttachment:Destroy();      floatAttachment   = nil end
    pcall(function()
        local c   = Player.Character if not c then return end
        local hum = c:FindFirstChildOfClass("Humanoid")
        if hum then
            if galaxyEnabled then adjustGalaxyJump() else hum.JumpPower = originalJumpPower end
        end
    end)
end

-- ============================================================

local POSITION_1  = Vector3.new(-476.48,-6.28, 92.73)
local POSITION_2  = Vector3.new(-483.12,-4.95, 94.80)
local POSITION_R1 = Vector3.new(-476.16,-6.52, 25.62)
local POSITION_R2 = Vector3.new(-483.04,-5.09, 23.14)
local autoWalkPhase  = 1
local autoRightPhase = 1
local autoWalkConnection, autoRightConnection

local coordESPFolder = Instance.new("Folder",workspace); coordESPFolder.Name="ZAY_CoordESP"
local function createCoordMarker(pos,lbl,col)
    local dot = Instance.new("Part",coordESPFolder)
    dot.Anchored=true; dot.CanCollide=false; dot.CastShadow=false
    dot.Material=Enum.Material.Neon; dot.Color=col; dot.Shape=Enum.PartType.Ball
    dot.Size=Vector3.new(1,1,1); dot.Position=pos; dot.Transparency=0.2
    local bb=Instance.new("BillboardGui",dot); bb.AlwaysOnTop=true; bb.Size=UDim2.new(0,100,0,20)
    bb.StudsOffset=Vector3.new(0,2,0); bb.MaxDistance=300
    local tx=Instance.new("TextLabel",bb); tx.Size=UDim2.new(1,0,1,0)
    tx.BackgroundTransparency=1; tx.Text=lbl; tx.TextColor3=col
    tx.TextStrokeColor3=Color3.fromRGB(0,0,0); tx.TextStrokeTransparency=0
    tx.Font=Enum.Font.GothamBold; tx.TextSize=12
end
createCoordMarker(POSITION_1,  "L1",    Color3.fromRGB(200,200,200))
createCoordMarker(POSITION_2,  "L END", Color3.fromRGB(160,160,160))
createCoordMarker(POSITION_R1, "R1",    Color3.fromRGB(220,220,220))
createCoordMarker(POSITION_R2, "R END", Color3.fromRGB(180,180,180))

local function faceSouth()
    local c=Player.Character if not c then return end
    local h=c:FindFirstChild("HumanoidRootPart") if not h then return end
    h.CFrame=CFrame.new(h.Position)*CFrame.Angles(0,0,0)
    local cam=workspace.CurrentCamera
    if cam then cam.CFrame=CFrame.new(h.Position.X,h.Position.Y+5,h.Position.Z-12)*CFrame.Angles(math.rad(-15),0,0) end
end
local function faceNorth()
    local c=Player.Character if not c then return end
    local h=c:FindFirstChild("HumanoidRootPart") if not h then return end
    h.CFrame=CFrame.new(h.Position)*CFrame.Angles(0,math.rad(180),0)
    local cam=workspace.CurrentCamera
    if cam then cam.CFrame=CFrame.new(h.Position.X,h.Position.Y+2,h.Position.Z+12)*CFrame.Angles(0,math.rad(180),0) end
end

local function startAutoWalk()
    if autoWalkConnection then autoWalkConnection:Disconnect() end
    autoWalkPhase=1
    autoWalkConnection = RunService.Heartbeat:Connect(function()
        if not AutoWalkEnabled then return end
        local c=Player.Character if not c then return end
        local h=c:FindFirstChild("HumanoidRootPart"); local hum=c:FindFirstChildOfClass("Humanoid")
        if not h or not hum then return end
        local target = autoWalkPhase==1 and POSITION_1 or POSITION_2
        local dist = (Vector3.new(target.X,h.Position.Y,target.Z)-h.Position).Magnitude
        if dist < 1 then
            if autoWalkPhase==1 then autoWalkPhase=2; return end
            hum:Move(Vector3.zero,false); h.AssemblyLinearVelocity=Vector3.new(0,0,0)
            AutoWalkEnabled=false; Enabled.AutoWalkEnabled=false
            if VisualSetters and VisualSetters.AutoWalkEnabled then VisualSetters.AutoWalkEnabled(false,true) end
            if autoWalkConnection then autoWalkConnection:Disconnect(); autoWalkConnection=nil end
            if onAutoLeftDone then onAutoLeftDone() end
            faceSouth(); return
        end
        local dir=(target-h.Position); local md=Vector3.new(dir.X,0,dir.Z).Unit
        hum:Move(md,false); h.AssemblyLinearVelocity=Vector3.new(md.X*Values.BoostSpeed,h.AssemblyLinearVelocity.Y,md.Z*Values.BoostSpeed)
    end)
end
local function stopAutoWalk()
    if autoWalkConnection then autoWalkConnection:Disconnect(); autoWalkConnection=nil end
    autoWalkPhase=1
    local c=Player.Character if c then local hum=c:FindFirstChildOfClass("Humanoid") if hum then hum:Move(Vector3.zero,false) end end
end

local function startAutoRight()
    if autoRightConnection then autoRightConnection:Disconnect() end
    autoRightPhase=1
    autoRightConnection = RunService.Heartbeat:Connect(function()
        if not AutoRightEnabled then return end
        local c=Player.Character if not c then return end
        local h=c:FindFirstChild("HumanoidRootPart"); local hum=c:FindFirstChildOfClass("Humanoid")
        if not h or not hum then return end
        local target = autoRightPhase==1 and POSITION_R1 or POSITION_R2
        local dist = (Vector3.new(target.X,h.Position.Y,target.Z)-h.Position).Magnitude
        if dist < 1 then
            if autoRightPhase==1 then autoRightPhase=2; return end
            hum:Move(Vector3.zero,false); h.AssemblyLinearVelocity=Vector3.new(0,0,0)
            AutoRightEnabled=false; Enabled.AutoRightEnabled=false
            if VisualSetters and VisualSetters.AutoRightEnabled then VisualSetters.AutoRightEnabled(false,true) end
            if autoRightConnection then autoRightConnection:Disconnect(); autoRightConnection=nil end
            if onAutoRightDone then onAutoRightDone() end
            faceNorth(); return
        end
        local dir=(target-h.Position); local md=Vector3.new(dir.X,0,dir.Z).Unit
        hum:Move(md,false); h.AssemblyLinearVelocity=Vector3.new(md.X*Values.BoostSpeed,h.AssemblyLinearVelocity.Y,md.Z*Values.BoostSpeed)
    end)
end
local function stopAutoRight()
    if autoRightConnection then autoRightConnection:Disconnect(); autoRightConnection=nil end
    autoRightPhase=1
    local c=Player.Character if c then local hum=c:FindFirstChildOfClass("Humanoid") if hum then hum:Move(Vector3.zero,false) end end
end

-- ============================================================
-- FULL AUTO DUEL BACKEND  (logic ported from Silent Hub)
-- Waypoints auto-selected based on which side the player is on.
-- Pauses at grab waypoints (4 & 6) and waits for WalkSpeed to
-- drop below 23 (game signals a grab) before continuing.
-- ============================================================
local fadWaypoints     = {}
local fadCurrent       = 1
local fadMoving        = false
local fadWaiting       = false    -- waiting for a grab detection
local fadGrabDone      = false    -- grab already detected this leg
local fadMoveConn      = nil
local fadSpeedConn     = nil

local function fadStop()
    if fadMoveConn  then fadMoveConn:Disconnect();  fadMoveConn=nil  end
    if fadSpeedConn then fadSpeedConn:Disconnect();  fadSpeedConn=nil end
    fadMoving  = false
    fadWaiting = false
    fadGrabDone= false
    Enabled.FullAutoDuel = false
    if VisualSetters and VisualSetters.FullAutoDuel then VisualSetters.FullAutoDuel(false, true) end
end

local function fadMoveLoop()
    if fadMoveConn then fadMoveConn:Disconnect() end
    fadMoveConn = RunService.Stepped:Connect(function()
        if not fadMoving or fadWaiting then return end
        local c    = Player.Character if not c then return end
        local root = c:FindFirstChild("HumanoidRootPart") if not root then return end
        local wp   = fadWaypoints[fadCurrent]
        local dist = (root.Position - wp.position).Magnitude
        if dist < 5 then
            -- Grab-wait waypoints
            if (fadCurrent == 4 or fadCurrent == 6) and not fadGrabDone then
                fadWaiting = true
                root.AssemblyLinearVelocity = Vector3.new(0, root.AssemblyLinearVelocity.Y, 0)
                local c2 = Player.Character if c2 then local h=c2:FindFirstChildOfClass("Humanoid") if h then h:Move(Vector3.zero,false) end end
                return
            end
            if fadCurrent == #fadWaypoints then
                fadStop(); return
            end
            fadCurrent += 1
        else
            local dir = (wp.position - root.Position)
            local md  = Vector3.new(dir.X, 0, dir.Z).Unit
            local hum = c:FindFirstChildOfClass("Humanoid")
            if hum then hum:Move(md, false) end
            root.AssemblyLinearVelocity = Vector3.new(md.X*wp.speed, root.AssemblyLinearVelocity.Y, md.Z*wp.speed)
        end
    end)
end

local function startFullAutoDuel()
    local root = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    fadMoving   = true
    fadGrabDone = false
    fadCurrent  = 1

    -- Pick side based on which spawn is closer (mirrors Silent Hub logic)
    if (root.Position - Vector3.new(-475,-7,96)).Magnitude > (root.Position - Vector3.new(-474,-7,23)).Magnitude then
        fadWaypoints = {
            {position=Vector3.new(-475,-7,96),  speed=59},
            {position=Vector3.new(-483,-5,95),  speed=59},
            {position=Vector3.new(-487,-5,95),  speed=55},
            {position=Vector3.new(-492,-5,95),  speed=55},
            {position=Vector3.new(-473,-7,95),  speed=29},
            {position=Vector3.new(-473,-7,11),  speed=29},
        }
    else
        fadWaypoints = {
            {position=Vector3.new(-474,-7,23),  speed=55},
            {position=Vector3.new(-484,-5,24),  speed=55},
            {position=Vector3.new(-488,-5,24),  speed=55},
            {position=Vector3.new(-493,-5,25),  speed=55},
            {position=Vector3.new(-473,-7,25),  speed=29},
            {position=Vector3.new(-474,-7,112), speed=29},
        }
    end

    -- Speed watcher: WalkSpeed < 23 means a grab happened
    if fadSpeedConn then fadSpeedConn:Disconnect() end
    fadSpeedConn = RunService.Heartbeat:Connect(function()
        if not fadWaiting or fadGrabDone then return end
        local c   = Player.Character if not c then return end
        local hum = c:FindFirstChildOfClass("Humanoid") if not hum then return end
        if hum.WalkSpeed < 23 then
            task.wait(0.3)
            fadWaiting  = false
            fadGrabDone = true
            -- Advance past the grab waypoint
            if fadCurrent < #fadWaypoints then fadCurrent += 1 end
        end
    end)

    fadMoveLoop()
end

local function stopFullAutoDuel()
    fadStop()
end

local function startAntiRagdoll()
    if Connections.antiRagdoll then return end
    Connections.antiRagdoll = RunService.Heartbeat:Connect(function()
        if not Enabled.AntiRagdoll then return end
        local char=Player.Character if not char then return end
        local root=char:FindFirstChild("HumanoidRootPart")
        local hum=char:FindFirstChildOfClass("Humanoid")
        if hum then
            local s=hum:GetState()
            if s==Enum.HumanoidStateType.Physics or s==Enum.HumanoidStateType.Ragdoll or s==Enum.HumanoidStateType.FallingDown then
                hum:ChangeState(Enum.HumanoidStateType.Running)
                workspace.CurrentCamera.CameraSubject=hum
                pcall(function()
                    local pm=Player.PlayerScripts:FindFirstChild("PlayerModule")
                    if pm then require(pm:FindFirstChild("ControlModule")):Enable() end
                end)
                if root then root.Velocity=Vector3.zero; root.RotVelocity=Vector3.zero end
            end
        end
        for _,obj in ipairs(char:GetDescendants()) do
            if obj:IsA("Motor6D") and not obj.Enabled then obj.Enabled=true end
        end
    end)
end
local function stopAntiRagdoll()
    if Connections.antiRagdoll then Connections.antiRagdoll:Disconnect(); Connections.antiRagdoll=nil end
end

local function startSpeedWhileStealing()
    if Connections.speedWhileStealing then return end
    Connections.speedWhileStealing = RunService.Heartbeat:Connect(function()
        if not Enabled.SpeedWhileStealing or not Player:GetAttribute("Stealing") then return end
        local c=Player.Character if not c then return end
        local h=c:FindFirstChild("HumanoidRootPart") if not h then return end
        local md=getMovementDirection()
        if md.Magnitude > 0.1 then
            h.AssemblyLinearVelocity=Vector3.new(md.X*Values.StealingSpeedValue,h.AssemblyLinearVelocity.Y,md.Z*Values.StealingSpeedValue)
        end
    end)
end
local function stopSpeedWhileStealing()
    if Connections.speedWhileStealing then Connections.speedWhileStealing:Disconnect(); Connections.speedWhileStealing=nil end
end

-- AUTO GRAB
local ProgressBarFill, ProgressPercentLabel
local isStealing         = false
local stealStartTime     = nil
local progressConnection = nil
local StealData          = {}

local function isMyPlotByName(pn)
    local plots=workspace:FindFirstChild("Plots") if not plots then return false end
    local plot=plots:FindFirstChild(pn)           if not plot  then return false end
    local sign=plot:FindFirstChild("PlotSign")
    if sign then
        local yb=sign:FindFirstChild("YourBase")
        if yb and yb:IsA("BillboardGui") then return yb.Enabled==true end
    end
    return false
end

local function findNearestPrompt()
    local h=Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    if not h then return nil end
    local plots=workspace:FindFirstChild("Plots") if not plots then return nil end
    local np,nd,nn=nil,math.huge,nil
    for _,plot in ipairs(plots:GetChildren()) do
        if isMyPlotByName(plot.Name) then continue end
        local podiums=plot:FindFirstChild("AnimalPodiums") if not podiums then continue end
        for _,pod in ipairs(podiums:GetChildren()) do
            pcall(function()
                local base=pod:FindFirstChild("Base")
                local spawn=base and base:FindFirstChild("Spawn")
                if spawn then
                    local dist=(spawn.Position-h.Position).Magnitude
                    if dist<nd and dist<=Values.STEAL_RADIUS then
                        local att=spawn:FindFirstChild("PromptAttachment")
                        if att then
                            for _,ch in ipairs(att:GetChildren()) do
                                if ch:IsA("ProximityPrompt") then np,nd,nn=ch,dist,pod.Name; break end
                            end
                        end
                    end
                end
            end)
        end
    end
    return np,nd,nn
end

local function ResetProgressBar()
    if ProgressPercentLabel then ProgressPercentLabel.Text="0%" end
    if ProgressBarFill      then ProgressBarFill.Size=UDim2.new(0,0,1,0) end
end

local function executeSteal(prompt,name)
    if isStealing then return end
    if not StealData[prompt] then
        StealData[prompt]={hold={},trigger={},ready=true}
        pcall(function()
            if getconnections then
                for _,c in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do
                    if c.Function then table.insert(StealData[prompt].hold,c.Function) end
                end
                for _,c in ipairs(getconnections(prompt.Triggered)) do
                    if c.Function then table.insert(StealData[prompt].trigger,c.Function) end
                end
            end
        end)
    end
    local data=StealData[prompt]
    if not data.ready then return end
    data.ready=false; isStealing=true; stealStartTime=tick()
    if progressConnection then progressConnection:Disconnect() end
    progressConnection=RunService.Heartbeat:Connect(function()
        if not isStealing then progressConnection:Disconnect(); return end
        local prog=math.clamp((tick()-stealStartTime)/Values.STEAL_DURATION,0,1)
        if ProgressBarFill then ProgressBarFill.Size=UDim2.new(prog,0,1,0) end
        if ProgressPercentLabel then ProgressPercentLabel.Text=math.floor(prog*100).."%" end
    end)
    task.spawn(function()
        for _,f in ipairs(data.hold) do task.spawn(f) end
        task.wait(Values.STEAL_DURATION)
        for _,f in ipairs(data.trigger) do task.spawn(f) end
        if progressConnection then progressConnection:Disconnect() end
        ResetProgressBar(); data.ready=true; task.wait(0.3); isStealing=false
    end)
end

local function startAutoSteal()
    if Connections.autoSteal then return end
    Connections.autoSteal=RunService.Heartbeat:Connect(function()
        if not Enabled.AutoSteal or isStealing then return end
        local p,_,n=findNearestPrompt()
        if p then executeSteal(p,n) end
    end)
end
local function stopAutoSteal()
    if Connections.autoSteal then Connections.autoSteal:Disconnect(); Connections.autoSteal=nil end
    isStealing=false; ResetProgressBar()
end

local savedAnimations={}
local function startUnwalk()
    local c=Player.Character if not c then return end
    local hum=c:FindFirstChildOfClass("Humanoid")
    if hum then for _,t in ipairs(hum:GetPlayingAnimationTracks()) do t:Stop() end end
    local anim=c:FindFirstChild("Animate")
    if anim then savedAnimations.Animate=anim:Clone(); anim:Destroy() end
end
local function stopUnwalk()
    local c=Player.Character
    if c and savedAnimations.Animate then savedAnimations.Animate:Clone().Parent=c; savedAnimations.Animate=nil end
end

local originalTransparency={}; local xrayEnabled=false
local function enableOptimizer()
    if getgenv and getgenv().OPTIMIZER_ACTIVE then return end
    if getgenv then getgenv().OPTIMIZER_ACTIVE=true end
    pcall(function() settings().Rendering.QualityLevel=Enum.QualityLevel.Level01; Lighting.GlobalShadows=false; Lighting.Brightness=3; Lighting.FogEnd=9e9 end)
    pcall(function()
        for _,obj in ipairs(workspace:GetDescendants()) do
            pcall(function()
                if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then obj:Destroy()
                elseif obj:IsA("BasePart") then obj.CastShadow=false; obj.Material=Enum.Material.Plastic end
            end)
        end
    end)
    xrayEnabled=true
    pcall(function()
        for _,obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Anchored and (obj.Name:lower():find("base") or (obj.Parent and obj.Parent.Name:lower():find("base"))) then
                originalTransparency[obj]=obj.LocalTransparencyModifier; obj.LocalTransparencyModifier=0.85
            end
        end
    end)
end
local function disableOptimizer()
    if getgenv then getgenv().OPTIMIZER_ACTIVE=false end
    if xrayEnabled then
        for part,v in pairs(originalTransparency) do if part then part.LocalTransparencyModifier=v end end
        originalTransparency={}; xrayEnabled=false
    end
end

local abActive=false; local _abMoveConn,_abNdConn,_abNdHumConn,_abTarget
local abVisualSetter=nil

local function _abApplyNoDie(char)
    if _abNdConn then _abNdConn:Disconnect(); _abNdConn=nil end
    if _abNdHumConn then _abNdHumConn:Disconnect(); _abNdHumConn=nil end
    local hum=char and char:FindFirstChildOfClass("Humanoid") if not hum then return end
    pcall(function() hum.MaxHealth=math.huge end); pcall(function() hum.Health=math.huge end)
    _abNdHumConn=hum:GetPropertyChangedSignal("Health"):Connect(function()
        if not abActive then return end
        pcall(function() if hum.Health<1 then hum.Health=hum.MaxHealth end end)
    end)
    _abNdConn=RunService.Heartbeat:Connect(function()
        if not abActive then return end
        pcall(function()
            if not hum or not hum.Parent then return end
            if hum.Health<hum.MaxHealth then hum.Health=hum.MaxHealth end
            local s=hum:GetState()
            if s==Enum.HumanoidStateType.Dead or s==Enum.HumanoidStateType.Ragdoll or s==Enum.HumanoidStateType.FallingDown then
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end
        end)
    end)
end
local function _abStop()
    if _abMoveConn then _abMoveConn:Disconnect(); _abMoveConn=nil end
    if _abNdConn   then _abNdConn:Disconnect();   _abNdConn=nil   end
    if _abNdHumConn then _abNdHumConn:Disconnect(); _abNdHumConn=nil end
    _abTarget=nil
    pcall(function()
        local hum=Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.MaxHealth=100; hum:Move(Vector3.zero,false) end
    end)
end
local function _abStart()
    _abStop()
    local char=Player.Character if char then _abApplyNoDie(char) end
    _abMoveConn=RunService.Heartbeat:Connect(function()
        if not abActive then return end
        pcall(function()
            local myChar=Player.Character if not myChar then return end
            local myHRP=myChar:FindFirstChild("HumanoidRootPart")
            local myHum=myChar:FindFirstChildOfClass("Humanoid")
            if not myHRP or not myHum then return end
            local nearest,bestDist=nil,math.huge
            for _,p in ipairs(Players:GetPlayers()) do
                if p~=Player and p.Character then
                    local oh=p.Character:FindFirstChild("HumanoidRootPart")
                    if oh then local d=(myHRP.Position-oh.Position).Magnitude if d<bestDist then bestDist=d; nearest=p end end
                end
            end
            _abTarget=nearest
            if not _abTarget or not _abTarget.Character then return end
            local tHRP=_abTarget.Character:FindFirstChild("HumanoidRootPart") if not tHRP then return end
            local flat=Vector3.new((tHRP.Position-myHRP.Position).X,0,(tHRP.Position-myHRP.Position).Z)
            if flat.Magnitude<3 then myHum:Move(Vector3.zero,false); return end
            local unit=flat.Unit; myHum:Move(unit,false)
            myHRP.AssemblyLinearVelocity=Vector3.new(unit.X*Values.BoostSpeed,myHRP.AssemblyLinearVelocity.Y,unit.Z*Values.BoostSpeed)
            pcall(function() myHRP.CFrame=CFrame.new(myHRP.Position,myHRP.Position+flat) end)
        end)
    end)
end
local function abToggle()
    abActive=not abActive
    if abActive then _abStart() else _abStop() end
    if abVisualSetter then abVisualSetter(abActive) end
end
Player.CharacterAdded:Connect(function(nc)
    if not abActive then return end
    task.wait(0.5); _abApplyNoDie(nc); _abStart()
end)

-- ============================================================
-- SPEED LABEL ABOVE CHARACTER
-- ============================================================
local speedBillboard = nil
local speedTextLabel = nil

local function createSpeedLabel(char)
    if speedBillboard then speedBillboard:Destroy(); speedBillboard=nil; speedTextLabel=nil end
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local bb = Instance.new("BillboardGui")
    bb.Name = "ZAY_SpeedLabel"; bb.AlwaysOnTop = false
    bb.Size = UDim2.new(0, 120, 0, 30); bb.StudsOffset = Vector3.new(0, 3.2, 0)
    bb.MaxDistance = 60; bb.Parent = hrp
    local lbl = Instance.new("TextLabel", bb)
    lbl.Size = UDim2.new(1, 0, 1, 0); lbl.BackgroundTransparency = 1
    lbl.Text = "Speed: 0.0"; lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0); lbl.TextStrokeTransparency = 0
    lbl.Font = Enum.Font.GothamBlack; lbl.TextSize = 16
    lbl.TextXAlignment = Enum.TextXAlignment.Center
    speedBillboard = bb; speedTextLabel = lbl
end

task.spawn(function() task.wait(1); createSpeedLabel(Player.Character) end)
Player.CharacterAdded:Connect(function(char) task.wait(0.5); createSpeedLabel(char) end)

RunService.Heartbeat:Connect(function()
    if not speedTextLabel then return end
    pcall(function()
        local char = Player.Character if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart") if not hrp then return end
        local vel = hrp.AssemblyLinearVelocity
        local horizontalSpeed = Vector3.new(vel.X, 0, vel.Z).Magnitude
        speedTextLabel.Text = "Speed: " .. string.format("%.1f", horizontalSpeed)
    end)
end)

-- ============================================================
-- GUI
-- ============================================================
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local GS = isMobile and 0.85 or 1

local function onTap(btn, cb)
    if isMobile then
        btn.Activated:Connect(cb)
    else
        btn.MouseButton1Click:Connect(cb)
    end
end

local C = {
    bg         = Color3.fromRGB(14,14,14),
    bgRow      = Color3.fromRGB(24,24,24),
    white      = Color3.fromRGB(255,255,255),
    dim        = Color3.fromRGB(150,150,150),
    muted      = Color3.fromRGB(85,85,85),
    off        = Color3.fromRGB(48,48,48),
    border     = Color3.fromRGB(65,65,65),
    danger     = Color3.fromRGB(220,50,50),
    dangerDark = Color3.fromRGB(120,22,22),
    badge      = Color3.fromRGB(40,40,40),
    badgeActive= Color3.fromRGB(75,75,75),
}

local WIN_W = math.floor(360*GS)
local WIN_H = math.floor(420*GS)
local CR    = math.floor(12*GS)

local sg = Instance.new("ScreenGui")
sg.Name="ZAY_CLEAN"; sg.ResetOnSpawn=false
sg.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
sg.Parent=Player.PlayerGui

local function playSound(id,vol,spd)
    pcall(function()
        local s=Instance.new("Sound",SoundService)
        s.SoundId=id; s.Volume=vol or 0.3; s.PlaybackSpeed=spd or 1
        s:Play(); game:GetService("Debris"):AddItem(s,1)
    end)
end

local function rc(inst, r)
    local c = Instance.new("UICorner", inst); c.CornerRadius = UDim.new(0, r or CR)
end
local function st(inst, thick, col, trans)
    local s = Instance.new("UIStroke", inst)
    s.Thickness=thick or 2; s.Color=col or C.white; s.Transparency=trans or 0
    s.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
end

local main = Instance.new("Frame", sg)
main.Name="ZAY_Main"
main.Size=UDim2.new(0, WIN_W, 0, WIN_H)
main.Position=isMobile and UDim2.new(0.5,-WIN_W/2,0.5,-WIN_H/2) or UDim2.new(1,-(WIN_W+16),0,16)
main.BackgroundColor3=C.bg; main.BorderSizePixel=0; main.Active=true; main.Draggable=not isMobile
rc(main, CR); st(main, 3, C.white, 0)

if isMobile then
    local mobDragging = false
    local mobDragStart, mobFrameStart
    local _dragCBW = math.floor(22*GS)
    local titleHitbox = Instance.new("TextButton", main)
    titleHitbox.Size = UDim2.new(1, -math.floor(_dragCBW+20*GS), 0, math.floor(48*GS))
    titleHitbox.Position = UDim2.new(0,0,0,0)
    titleHitbox.BackgroundTransparency = 1; titleHitbox.Text = ""; titleHitbox.ZIndex = 20
    titleHitbox.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.Touch then
            mobDragging = true
            mobDragStart = inp.Position
            mobFrameStart = main.Position
        end
    end)
    titleHitbox.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.Touch then mobDragging = false end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if mobDragging and inp.UserInputType == Enum.UserInputType.Touch then
            local delta = inp.Position - mobDragStart
            main.Position = UDim2.new(
                mobFrameStart.X.Scale, mobFrameStart.X.Offset + delta.X,
                mobFrameStart.Y.Scale, mobFrameStart.Y.Offset + delta.Y
            )
        end
    end)
end

local TITLE_H = math.floor(48*GS)
local titleTxt = Instance.new("TextLabel", main)
titleTxt.Size=UDim2.new(1,0,0,TITLE_H); titleTxt.Position=UDim2.new(0,0,0,0)
titleTxt.BackgroundTransparency=1; titleTxt.Text="ZAY DUELS"; titleTxt.TextColor3=C.white
titleTxt.Font=Enum.Font.GothamBlack; titleTxt.TextSize=math.floor(24*GS)
titleTxt.TextXAlignment=Enum.TextXAlignment.Center; titleTxt.TextYAlignment=Enum.TextYAlignment.Center
titleTxt.ZIndex=1

local CBW = math.floor(22*GS)
local closeBtn = Instance.new("TextButton", main)
closeBtn.Size=UDim2.new(0,CBW,0,CBW)
closeBtn.Position=UDim2.new(1,-math.floor(CBW+10*GS),0,math.floor((TITLE_H-CBW)/2))
closeBtn.BackgroundColor3=C.dangerDark; closeBtn.Text="×"; closeBtn.TextColor3=C.white
closeBtn.Font=Enum.Font.GothamBold; closeBtn.TextSize=math.floor(14*GS); closeBtn.BorderSizePixel=0
rc(closeBtn, math.floor(CBW/2)); st(closeBtn, 2, C.danger, 0)

local divider = Instance.new("Frame", main)
divider.Size=UDim2.new(1,-math.floor(16*GS),0,1); divider.Position=UDim2.new(0,math.floor(8*GS),0,TITLE_H)
divider.BackgroundColor3=C.border; divider.BorderSizePixel=0

local SCROLL_Y = TITLE_H + 2
local scroll = Instance.new("ScrollingFrame", main)
scroll.Size=UDim2.new(1,0,0,WIN_H-SCROLL_Y); scroll.Position=UDim2.new(0,0,0,SCROLL_Y)
scroll.BackgroundTransparency=1; scroll.BorderSizePixel=0
scroll.ScrollBarThickness=math.floor(3*GS); scroll.ScrollBarImageColor3=C.dim
scroll.CanvasSize=UDim2.new(0,0,0,0); scroll.AutomaticCanvasSize=Enum.AutomaticSize.Y
scroll.ScrollingDirection=Enum.ScrollingDirection.Y

local layout = Instance.new("UIListLayout", scroll)
layout.SortOrder=Enum.SortOrder.LayoutOrder; layout.Padding=UDim.new(0,math.floor(3*GS))

local pad = Instance.new("UIPadding", scroll)
pad.PaddingTop=UDim.new(0,math.floor(6*GS)); pad.PaddingBottom=UDim.new(0,math.floor(10*GS))
pad.PaddingLeft=UDim.new(0,math.floor(8*GS)); pad.PaddingRight=UDim.new(0,math.floor(8*GS))

VisualSetters = {}
local SliderSetters     = {}
local waitingForKeybind = nil
local KeyBindBtns       = {}

local ROW_H = math.floor(36*GS)
local SL_H  = math.floor(52*GS)

local function createSectionHeader(order, txt)
    local w = Instance.new("Frame", scroll)
    w.Size=UDim2.new(1,0,0,math.floor(20*GS)); w.BackgroundTransparency=1; w.LayoutOrder=order
    local lbl = Instance.new("TextLabel", w)
    lbl.Size=UDim2.new(1,0,1,0); lbl.BackgroundTransparency=1; lbl.Text=txt
    lbl.TextColor3=C.muted; lbl.Font=Enum.Font.GothamBold; lbl.TextSize=math.floor(9*GS)
    lbl.TextXAlignment=Enum.TextXAlignment.Left
    local rule = Instance.new("Frame", w)
    rule.Size=UDim2.new(1,0,0,1); rule.Position=UDim2.new(0,0,1,-1)
    rule.BackgroundColor3=C.border; rule.BorderSizePixel=0
end

local KB_W = math.floor(48*GS)
local KB_H = math.floor(20*GS)

local function createKeybindBadge(parent, keybindKey)
    if not keybindKey then return nil end
    local kc0 = KEYBINDS[keybindKey]
    local btn = Instance.new("TextButton", parent)
    btn.Size             = UDim2.new(0, KB_W, 0, KB_H)
    local pillRight      = math.floor(40*GS) + math.floor(8*GS)
    btn.Position         = UDim2.new(1, -(pillRight + KB_W + math.floor(6*GS)), 0.5, -math.floor(KB_H/2))
    btn.BackgroundColor3 = C.badge
    btn.Text             = (kc0 == Enum.KeyCode.Unknown) and "—" or kc0.Name
    btn.TextColor3       = C.white
    btn.Font             = Enum.Font.GothamBold
    btn.TextSize         = math.floor(8*GS)
    btn.TextScaled       = false
    btn.TextTruncate     = Enum.TextTruncate.AtEnd
    btn.BorderSizePixel  = 0
    -- ZIndex 15: sits above the toggle click layer (ZIndex 10) so badge clicks don't trigger toggle
    btn.ZIndex           = 15
    rc(btn, math.floor(5*GS))
    st(btn, 1.5, C.dim, 0.3)
    KeyBindBtns[keybindKey] = btn
    btn.MouseButton1Click:Connect(function()
        if waitingForKeybind == keybindKey then
            waitingForKeybind = nil
      
