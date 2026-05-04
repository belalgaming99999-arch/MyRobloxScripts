-- [[ Crystal Hub - Four in a Row MASTER AI ]] --
-- مبرمج بناءً على هيكل اللعبة الأصلي لضمان التوافق التام

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- استخراج المتغيرات بنفس أسماء ملف اللعبة الأصلي
local r_ClientGlobals = require(ReplicatedStorage.Client.Modules.ClientGlobals)
local r_Remotes = require(ReplicatedStorage.Shared.Remotes)
local l_ActiveMinigame = r_ClientGlobals.ActiveMinigame
local l_MinigameGameAction = r_Remotes.MinigameGameAction

-- [ إعداد الواجهة ] --
if CoreGui:FindFirstChild("PS99_AI") then CoreGui:FindFirstChild("PS99_AI"):Destroy() end
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "PS99_AI"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 180, 0, 80)
Main.Position = UDim2.new(0.5, -90, 0.2, 0)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Instance.new("UICorner", Main)

local Btn = Instance.new("TextButton", Main)
Btn.Size = UDim2.new(0, 150, 0, 40)
Btn.Position = UDim2.new(0.5, -75, 0.5, -20)
Btn.Text = "AUTO PLAY: OFF"
Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
Btn.TextColor3 = Color3.new(1, 1, 1)
Btn.Font = Enum.Font.GothamBold
Instance.new("UICorner", Btn)

local IsActive = false
Btn.MouseButton1Click:Connect(function()
    IsActive = not IsActive
    Btn.Text = IsActive and "AI: ACTIVE ✅" or "AI: OFF ❌"
    Btn.BackgroundColor3 = IsActive and Color3.fromRGB(0, 150, 80) or Color3.fromRGB(40, 40, 45)
end)

-- [ محرك الذكاء الاصطناعي ] --
local function GetBestMove(grid, myIdx)
    local enemyIdx = (myIdx == 1) and 2 or 1
    
    local function checkMove(c, p)
        local col = grid[tostring(c)] or {}
        if #col >= 6 then return false end
        local r = #col + 1
        
        -- منطق فحص الـ 4 المتصلة (أفقي، رأسي، قطري)
        local dirs = {{1,0}, {0,1}, {1,1}, {1,-1}}
        for _, d in pairs(dirs) do
            local count = 1
            for i=1, 3 do
                local nr, nc = r+(d[2]*i), c+(d[1]*i)
                local targetCol = grid[tostring(nc)]
                if targetCol and targetCol[nr] == p then count = count + 1 else break end
            end
            for i=1, 3 do
                local nr, nc = r-(d[2]*i), c-(d[1]*i)
                local targetCol = grid[tostring(nc)]
                if targetCol and targetCol[nr] == p then count = count + 1 else break end
            end
            if count >= 4 then return true end
        end
        return false
    end

    -- 1. ابحث عن حركة فوز لي
    for c = 1, 7 do if checkMove(c, myIdx) then return c end end
    -- 2. امنع فوز الخصم
    for c = 1, 7 do if checkMove(c, enemyIdx) then return c end end
    -- 3. حركات استراتيجية (الوسط أفضل)
    local strategy = {4, 3, 5, 2, 6, 1, 7}
    for _, c in ipairs(strategy) do
        local col = grid[tostring(c)] or {}
        if #col < 6 then return c end
    end
end

-- [ التشغيل التلقائي ] --
local lastTurnProcessed = -1

RunService.Heartbeat:Connect(function()
    if not IsActive then return end
    
    pcall(function()
        local session = l_ActiveMinigame.session
        if session and session.public and session.public.phase == "Playing" then
            local myIdx = session.private.seatIndex
            local currentTurn = session.public.currentTurn
            local grid = session.public.grid
            
            -- التأكد أن الدور دوري
            if currentTurn == myIdx then
                -- حساب إجمالي الحركات لمعرفة هل تغير الدور أم لا
                local totalMoves = 0
                for _, col in pairs(grid) do totalMoves = totalMoves + #col end
                
                if totalMoves ~= lastTurnProcessed then
                    local move = GetBestMove(grid, myIdx)
                    if move then
                        task.wait(0.5) -- تأخير بسيط للواقعية
                        l_MinigameGameAction:FireServer("DropChip", move)
                        lastTurnProcessed = totalMoves
                    end
                end
            end
        else
            lastTurnProcessed = -1
        end
    end)
end)

