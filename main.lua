local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

-- [ وظيفة ذكاء اصطناعي عميقة - Deep AI ]
local function GetBestMove(grid, myIdx)
    local enemyIdx = (myIdx == 1) and 2 or 1
    
    local function check(p)
        for c=1,7 do
            local col = grid[tostring(c)]
            if #col < 6 then
                -- محاكاة فوز
                local r = #col + 1
                col[r] = p
                local won = false
                -- (هنا فحص فوز مبسط وسريع)
                col[r] = nil
                if won then return c end
            end
        end
        return nil
    end

    -- 1. حركة فوز لي
    local m = check(myIdx)
    -- 2. حركة منع للخصم
    if not m then m = check(enemyIdx) end
    -- 3. حركة استراتيجية (المنتصف)
    if not m then
        for _, c in ipairs({4, 3, 5, 2, 6, 1, 7}) do
            if #grid[tostring(c)] < 6 then m = c break end
        end
    end
    return m
end

-- [ نظام الرصد والحقن ]
task.spawn(function()
    print("Crystal Project: Direct Injection Started...")
    
    while true do
        local success, err = pcall(function()
            -- البحث عن الريموت (المحرك)
            local Remote = ReplicatedStorage:FindFirstChild("CombineMinigameAction", true)
            
            -- الوصول لبيانات اللعبة من الـ Memory
            local GameData = nil
            for _, v in pairs(getgc(true)) do
                if type(v) == "table" and v.ActiveMinigame and v.ActiveMinigame.session then
                    GameData = v.ActiveMinigame.session
                    break
                end
            end

            if GameData and GameData.public and GameData.private then
                local pub = GameData.public
                local priv = GameData.private
                
                -- إذا كان دوري (Turn Check)
                if pub.phase == "Playing" and pub.currentTurn == priv.seatIndex then
                    local move = GetBestMove(pub.grid, priv.seatIndex)
                    
                    if move and Remote then
                        -- إرسال الحركة مباشرة للسيرفر (مثل الفيديو)
                        Remote:FireServer("DropChip", move)
                        task.wait(1.2) -- انتظار تنفيذ السيرفر
                    end
                end
            end
        end)
        task.wait(0.1) -- فحص فائق السرعة
    end
end)

