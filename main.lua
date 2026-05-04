local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")

local Root = (gethui and gethui()) or (get_hidden_gui and get_hidden_gui()) or CoreGui
if Root:FindFirstChild("CrystalProject") then
    Root:FindFirstChild("CrystalProject"):Destroy()
end

local CrystalGui = Instance.new("ScreenGui", Root)
CrystalGui.Name = "CrystalProject"
CrystalGui.IgnoreGuiInset = true
CrystalGui.DisplayOrder = 9e9

local Theme = {
    Bg = Color3.fromRGB(15, 15, 25),
    Main = Color3.fromRGB(0, 150, 255),
    White = Color3.new(1, 1, 1),
    Off = Color3.fromRGB(50, 50, 60), 
    On = Color3.fromRGB(0, 255, 150)
}

local Toggles = {AutoFour = false}
local UI_Open, Dragging = false, false

-- [ واجهة المستخدم ]
local MenuBtn = Instance.new("TextButton", CrystalGui)
MenuBtn.Size = UDim2.new(0, 55, 0, 55)
MenuBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
MenuBtn.BackgroundColor3 = Theme.Main
MenuBtn.Text = "ULTRA AI"
MenuBtn.TextColor3 = Theme.White
MenuBtn.Font = Enum.Font.GothamBold
MenuBtn.TextSize = 10
Instance.new("UICorner", MenuBtn)

local Border = Instance.new("Frame", CrystalGui)
Border.Size = UDim2.new(0, 0, 0, 0)
Border.Visible = false
Border.BackgroundColor3 = Theme.Bg
Border.ClipsDescendants = true
Instance.new("UICorner", Border)

local Main = Instance.new("Frame", Border)
Main.Size = UDim2.new(1, -4, 1, -4)
Main.Position = UDim2.new(0, 2, 0, 2)
Main.BackgroundColor3 = Theme.Bg
Instance.new("UICorner", Main)

local function CreateBtn(key, y, label)
    local B = Instance.new("TextButton", Main)
    B.Size = UDim2.new(0, 180, 0, 45)
    B.Position = UDim2.new(0.5, -90, 0, y)
    B.BackgroundColor3 = Theme.Off
    B.Text = label
    B.TextColor3 = Theme.White
    B.Font = Enum.Font.GothamBold
    Instance.new("UICorner", B)

    B.MouseButton1Click:Connect(function()
        Toggles[key] = not Toggles[key]
        B.BackgroundColor3 = Toggles[key] and Theme.On or Theme.Off
        B.Text = label .. (Toggles[key] and " [ACTIVE]" or " [OFF]")
    end)
end

CreateBtn("AutoFour", 40, "Ultra Smart AI 4")

-- [[ محرك الذكاء الاصطناعي العنيف ]]

local function GetCell(grid, c, r)
    if c < 1 or c > 7 or r < 1 or r > 6 then return nil end
    return grid[tostring(c)][r]
end

-- فحص الفوز الفوري أو التهديدات
local function EvaluateMove(grid, c, player)
    local col = grid[tostring(c)]
    if #col >= 6 then return -1 end
    local r = #col + 1
    col[r] = player
    
    local isWin = false
    local directions = {{1,0}, {0,1}, {1,1}, {1,-1}}
    for _, dir in pairs(directions) do
        local count = 1
        for i = 1, 3 do if GetCell(grid, c + (dir[1]*i), r + (dir[2]*i)) == player then count = count + 1 else break end end
        for i = 1, 3 do if GetCell(grid, c - (dir[1]*i), r - (dir[2]*i)) == player then count = count + 1 else break end end
        if count >= 4 then isWin = true break end
    end
    
    col[r] = nil
    return isWin and 100 or 0
end

-- فحص العمق لمنع الفخاخ (Anti-Trap System)
local function IsSafe(grid, c, myIdx, enemyIdx)
    local col = grid[tostring(c)]
    if #col >= 5 then return true end -- إذا كان العمود سيمتلئ لا يمكن للخصم اللعب فوقي
    
    local r = #col + 1
    col[r] = myIdx -- حركتي
    local enemyCanWin = EvaluateMove(grid, c, enemyIdx) -- هل حركته القادمة فوقي ستكسبه؟
    col[r] = nil
    
    return enemyCanWin == 0
end

-- [[ حلقة الذكاء التلقائي ]]
task.spawn(function()
    while true do
        pcall(function()
            local ClientGlobals = require(ReplicatedStorage:FindFirstChild("ClientGlobals", true) or ReplicatedStorage:WaitForChild("ClientGlobals", true))
            local Remote = ReplicatedStorage:FindFirstChild("CombineMinigameAction", true)
            
            if ClientGlobals and ClientGlobals.ActiveMinigame and Toggles.AutoFour then
                local s = ClientGlobals.ActiveMinigame.session
                if s and s.public and s.private then
                    local pub = s.public
                    local mySeat = s.private.seatIndex
                    local enemySeat = (mySeat == 1) and 2 or 1
                    
                    if pub.phase == "Playing" and pub.currentTurn == mySeat then
                        local bestMove = nil
                        
                        -- 1. ابحث عن حركة تنهي اللعبة فوراً (هجوم)
                        for c = 1, 7 do
                            if EvaluateMove(pub.grid, c, mySeat) > 0 then
                                bestMove = c; break
                            end
                        end
                        
                        -- 2. إذا لا يوجد، ابحث عن حركة تمنع الخصم من الفوز فوراً (دفاع)
                        if not bestMove then
                            for c = 1, 7 do
                                if EvaluateMove(pub.grid, c, enemySeat) > 0 then
                                    bestMove = c; break
                                end
                            end
                        end
                        
                        -- 3. إذا لم يوجد تهديد، العب بذكاء استراتيجي (المركز أولاً + الأمان)
                        if not bestMove then
                            local strategy = {4, 3, 5, 2, 6, 1, 7}
                            for _, c in ipairs(strategy) do
                                if #pub.grid[tostring(c)] < 6 and IsSafe(pub.grid, c, mySeat, enemySeat) then
                                    bestMove = c; break
                                end
                            end
                        end
                        
                        -- 4. حركة اضطرارية (إذا كانت كل الحركات تؤدي لفخ)
                        if not bestMove then
                            for c = 1, 7 do if #pub.grid[tostring(c)] < 6 then bestMove = c break end end
                        end

                        if bestMove then
                            task.wait(0.2) -- استجابة عدوانية وسريعة جداً
                            Remote:FireServer("DropChip", bestMove)
                            task.wait(1.5)
                        end
                    end
                end
            end
        end)
        task.wait(0.1)
    end
end)

-- [ منطق الـ UI ]
local goalPos = MenuBtn.Position
MenuBtn.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then Dragging = true end end)
UserInputService.InputChanged:Connect(function(i) if Dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then goalPos = UDim2.new(0, i.Position.X - 25, 0, i.Position.Y - 25) end end)
UserInputService.InputEnded:Connect(function() Dragging = false end)
RunService.Heartbeat:Connect(function() MenuBtn.Position = MenuBtn.Position:Lerp(goalPos, 0.2) if Border.Visible then Border.Position = UDim2.new(MenuBtn.Position.X.Scale, MenuBtn.Position.X.Offset, MenuBtn.Position.Y.Scale, MenuBtn.Position.Y.Offset + 60) end end)
MenuBtn.MouseButton1Click:Connect(function() UI_Open = not UI_Open Border.Visible = true Border:TweenSize(UI_Open and UDim2.new(0, 210, 0, 120) or UDim2.new(0, 0, 0, 0), "Out", "Quint", 0.3, true, function() if not UI_Open then Border.Visible = false end end) end)
