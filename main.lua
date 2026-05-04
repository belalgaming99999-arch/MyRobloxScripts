-- [[ Crystal Hub - Master AI Edition ]] --
-- [[ Designed for Connect 4 & Popcorn Minigames ]] --

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")

-- [ تنظيف النسخ القديمة ]
local Root = (gethui and gethui()) or (get_hidden_gui and get_hidden_gui()) or CoreGui
if Root:FindFirstChild("CrystalProject") then Root:FindFirstChild("CrystalProject"):Destroy() end

local CrystalGui = Instance.new("ScreenGui", Root)
CrystalGui.Name = "CrystalProject"
CrystalGui.IgnoreGuiInset = true

local Theme = {
    Bg = Color3.fromRGB(15, 15, 20),
    Main = Color3.fromRGB(0, 140, 255),
    White = Color3.new(1, 1, 1),
    On = Color3.fromRGB(0, 220, 100),
    Off = Color3.fromRGB(220, 50, 50),
    Text = Color3.fromRGB(240, 240, 240)
}

local Toggles = {AutoFour = false, AutoPop = false}
local Accuracy = 0.88 -- دقة الفشار

-- [[ واجهة المستخدم الاحترافية ]]
local MainFrame = Instance.new("Frame", CrystalGui)
MainFrame.Size = UDim2.new(0, 220, 0, 260)
MainFrame.Position = UDim2.new(0.5, -110, 0.5, -130)
MainFrame.BackgroundColor3 = Theme.Bg
MainFrame.BorderSizePixel = 0
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

local Stroke = Instance.new("UIStroke", MainFrame)
Stroke.Color = Theme.Main
Stroke.Thickness = 2

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "CRYSTAL AI MASTER"
Title.TextColor3 = Theme.Main
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.BackgroundTransparency = 1

local function CreateToggle(key, text, y)
    local Btn = Instance.new("TextButton", MainFrame)
    Btn.Size = UDim2.new(0, 180, 0, 45)
    Btn.Position = UDim2.new(0.5, -90, 0, y)
    Btn.BackgroundColor3 = Theme.Off
    Btn.Text = text .. " [OFF]"
    Btn.TextColor3 = Theme.White
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 12
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)

    Btn.MouseButton1Click:Connect(function()
        Toggles[key] = not Toggles[key]
        Btn.Text = text .. (Toggles[key] and " [ACTIVE]" or " [OFF]")
        TweenService:Create(Btn, TweenInfo.new(0.3), {BackgroundColor3 = Toggles[key] and Theme.On or Theme.Off}):Play()
    end)
end

CreateToggle("AutoFour", "AUTO CONNECT 4", 60)
CreateToggle("AutoPop", "AUTO POPCORN", 115)

-- [[ محرك الذكاء الاصطناعي - AI ENGINE ]]

local function GetCell(grid, c, r)
    if c < 1 or c > 7 or r < 1 or r > 6 then return nil end
    return grid[tostring(c)][r]
end

local function AnalyzeMove(grid, c, player)
    local col = grid[tostring(c)]
    if #col >= 6 then return false end
    local r = #col + 1
    col[r] = player
    
    local isWin = false
    local directions = {{1,0}, {0,1}, {1,1}, {1,-1}}
    for _, d in pairs(directions) do
        local count = 1
        for i=1,3 do if GetCell(grid, c+(d[1]*i), r+(d[2]*i)) == player then count = count+1 else break end end
        for i=1,3 do if GetCell(grid, c-(d[1]*i), r-(d[2]*i)) == player then count = count+1 else break end end
        if count >= 4 then isWin = true break end
    end
    col[r] = nil
    return isWin
end

-- [[ حلقة التشغيل والحقن المباشر ]]
task.spawn(function()
    while true do
        local success, err = pcall(function()
            local Remote = ReplicatedStorage:FindFirstChild("CombineMinigameAction", true)
            local ClientGlobals = nil
            
            -- البحث في الذاكرة عن بيانات اللعبة (مثل الفيديو)
            for _, v in pairs(getgc(true)) do
                if type(v) == "table" and v.ActiveMinigame and v.ActiveMinigame.session then
                    ClientGlobals = v.ActiveMinigame
                    break
                end
            end

            if ClientGlobals and Remote then
                local s = ClientGlobals.session
                
                -- [1] ذكاء Connect 4
                if Toggles.AutoFour and s.public and s.private then
                    local pub = s.public
                    local mySeat = s.private.seatIndex
                    local enemy = (mySeat == 1) and 2 or 1
                    
                    if pub.phase == "Playing" and pub.currentTurn == mySeat then
                        local bestMove = nil
                        
                        -- هجوم: هل يمكنني الفوز؟
                        for c=1,7 do if AnalyzeMove(pub.grid, c, mySeat) then bestMove = c break end end
                        -- دفاع: هل سيفوز الخصم؟
                        if not bestMove then
                            for c=1,7 do if AnalyzeMove(pub.grid, c, enemy) then bestMove = c break end end
                        end
                        -- استراتيجية: المنتصف أولاً مع فحص الأمان
                        if not bestMove then
                            for _, c in ipairs({4, 3, 5, 2, 6, 1, 7}) do
                                if #pub.grid[tostring(c)] < 6 then bestMove = c break end
                            end
                        end
                        
                        if bestMove then
                            task.wait(0.2) -- استجابة سريعة جداً
                            Remote:FireServer("DropChip", bestMove)
                            task.wait(1.5)
                        end
                    end
                end

                -- [2] ذكاء الفشار
                if Toggles.AutoPop then
                    local Board = workspace:FindFirstChild("PopcornBurstBoard", true)
                    if Board then
                        for _, p in pairs(Board:GetDescendants()) do
                            if p.Name == "Popcorn" and p.Transparency < 0.1 then
                                local target = p:GetAttribute("TargetScale")
                                if target and p.Size.X >= (target * Accuracy) then
                                    Remote:FireServer("AttemptPop", workspace:GetServerTimeNow())
                                end
                            end
                        end
                    end
                end
            end
        end)
        task.wait(0.1)
    end
end)

-- [ نظام سحب القائمة ]
local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = MainFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end end)

print("Crystal AI Loaded Successfully!")
