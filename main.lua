-- [[ GEMINI ELITE - REAL TIME TOGGLE ]] --

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- تنظيف أي نسخ قديمة
if CoreGui:FindFirstChild("GeminiPro") then CoreGui:FindFirstChild("GeminiPro"):Destroy() end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "GeminiPro"

-- تصميم الواجهة الاحترافية
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 200, 0, 100)
MainFrame.Position = UDim2.new(0.5, -100, 0.1, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame)

local Stroke = Instance.new("UIStroke", MainFrame)
Stroke.Color = Color3.fromRGB(0, 170, 255)
Stroke.Thickness = 2

-- زر الإغلاق النهائي (X)
local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Size = UDim2.new(0, 24, 0, 24)
CloseBtn.Position = UDim2.new(1, -28, 0, 4)
CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", CloseBtn)

-- زر التشغيل/الإيقاف المباشر
local ToggleBtn = Instance.new("TextButton", MainFrame)
ToggleBtn.Size = UDim2.new(0, 170, 0, 45)
ToggleBtn.Position = UDim2.new(0.5, -85, 0, 40)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
ToggleBtn.Text = "AUTO PLAY: OFF"
ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 13
Instance.new("UICorner", ToggleBtn)

-- متغيرات التحكم
local IsActive = false
local ScriptRunning = true
local lastTurnId = -1

-- [ محرك الذكاء الاصطناعي الخبير ]
local function AnalyzeBoard(session)
    local grid = session.public.grid
    local myIdx = session.private.seatIndex
    local enemyIdx = (myIdx == 1) and 2 or 1
    
    local function checkWin(c, r, p)
        local dirs = {{1,0}, {0,1}, {1,1}, {1,-1}}
        for _, d in pairs(dirs) do
            local count = 1
            for i=1,3 do
                local nr, nc = r+(d[2]*i), c+(d[1]*i)
                if grid[tostring(nc)] and grid[tostring(nc)][nr] == p then count = count+1 else break end
            end
            for i=1,3 do
                local nr, nc = r-(d[2]*i), c-(d[1]*i)
                if grid[tostring(nc)] and grid[tostring(nc)][nr] == p then count = count+1 else break end
            end
            if count >= 4 then return true end
        end
        return false
    end

    local defense, setup = nil, nil
    for c = 1, 7 do
        local col = grid[tostring(c)]
        if #col < 6 then
            local r = #col + 1
            if checkWin(c, r, myIdx) then return c end -- أولوية الفوز
            if not defense and checkWin(c, r, enemyIdx) then defense = c end -- أولوية المنع
            if not setup and checkWin(c, r, myIdx) then setup = c end
        end
    end
    return defense or setup or 4
end

-- التحكم بالزر
ToggleBtn.MouseButton1Click:Connect(function()
    IsActive = not IsActive
    ToggleBtn.Text = IsActive and "AUTO PLAY: ON ✅" or "AUTO PLAY: OFF ❌"
    ToggleBtn.BackgroundColor3 = IsActive and Color3.fromRGB(0, 180, 100) or Color3.fromRGB(40, 40, 50)
    print("AI State: " .. (IsActive and "Active" or "Paused"))
end)

-- الإغلاق النهائي
CloseBtn.MouseButton1Click:Connect(function()
    ScriptRunning = false
    ScreenGui:Destroy()
end)

-- حلقة المراقبة والتشغيل (متوافقة مع Delta)
task.spawn(function()
    while ScriptRunning do
        if IsActive then
            pcall(function()
                local Globals = require(ReplicatedStorage:FindFirstChild("ClientGlobals", true))
                local s = Globals.ActiveMinigame and Globals.ActiveMinigame.session
                
                if s and s.public and s.public.phase == "Playing" then
                    if s.public.currentTurn == s.private.seatIndex then
                        -- حساب إجمالي الحركات للتأكد من الدور الجديد
                        local currentMoves = 0
                        for _, col in pairs(s.public.grid) do currentMoves = currentMoves + #col end
                        
                        if currentMoves ~= lastTurnId then
                            local move = AnalyzeBoard(s)
                            local remote = ReplicatedStorage:FindFirstChild("CombineMinigameAction", true)
                            
                            if move and remote then
                                task.wait(0.25) -- وقت تفكير سريع
                                remote:FireServer("DropChip", move)
                                lastTurnId = currentMoves
                            end
                        end
                    end
                else
                    lastTurnId = -1
                end
            end)
        end
        task.wait(0.3)
    end
end)
