local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")

-- الحصول على ريموتات اللعبة والموديلات
local RemotesModule = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Remotes"))
local GameRemote = RemotesModule.CombineMinigameAction
local ClientGlobals = require(ReplicatedStorage:WaitForChild("Client"):WaitForChild("Modules"):WaitForChild("ClientGlobals"))

-- البحث عن أفضل "حاوية" تظهر فوق كل شيء
local Root = (gethui and gethui()) or CoreGui
if Root:FindFirstChild("CrystalGodMode") then Root:FindFirstChild("CrystalGodMode"):Destroy() end

local CrystalGui = Instance.new("ScreenGui")
CrystalGui.Name = "CrystalGodMode"
CrystalGui.Parent = Root
CrystalGui.DisplayOrder = 2147483647 -- أقصى رقم ممكن في روبلوكس للظهور فوق الكل
CrystalGui.IgnoreGuiInset = true

local Theme = {
    Bg = Color3.fromRGB(15, 15, 25),
    Main = Color3.fromRGB(50, 150, 255),
    White = Color3.new(1, 1, 1),
    Off = Color3.fromRGB(30, 30, 40), 
    On = Color3.fromRGB(50, 150, 255),
    Slider = Color3.fromRGB(45, 45, 55)
}

local Toggles = {AutoPop = false, AutoFour = false, Extra = false}
local AccuracyVal = 0.988 
local UI_Open = false 

-- [ أيقونة الفتح - ستظهر فوق أي شيء مهما كان ]
local MenuBtn = Instance.new("TextButton")
MenuBtn.Parent = CrystalGui
MenuBtn.Size = UDim2.new(0, 52, 0, 52)
MenuBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
MenuBtn.BackgroundColor3 = Theme.Main
MenuBtn.Text = ""
MenuBtn.ZIndex = 100
Instance.new("UICorner", MenuBtn).CornerRadius = UDim.new(0, 12)

local Border = Instance.new("Frame")
Border.Parent = CrystalGui
Border.Size = UDim2.new(0, 0, 0, 0)
Border.Position = UDim2.new(0.05, 0, 0.2, 60)
Border.BackgroundColor3 = Theme.White
Border.Visible = false
Border.ClipsDescendants = true
Border.ZIndex = 98
Instance.new("UICorner", Border).CornerRadius = UDim.new(0, 12)

local Main = Instance.new("Frame")
Main.Parent = Border
Main.Size = UDim2.new(1, -4, 1, -4)
Main.Position = UDim2.new(0, 2, 0, 2)
Main.BackgroundColor3 = Theme.Bg
Main.ZIndex = 99
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

local GlobalGrad = Instance.new("UIGradient")
GlobalGrad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Theme.Main), ColorSequenceKeypoint.new(0.5, Theme.White), ColorSequenceKeypoint.new(1, Theme.Main)})
GlobalGrad.Parent = Border

-- [ وظيفة إنشاء الأزرار ]
local function CreateBtn(key, y, label)
    local B = Instance.new("TextButton")
    B.Parent = Main
    B.Size = UDim2.new(0, 180, 0, 38)
    B.Position = UDim2.new(0.5, -90, 0, y)
    B.BackgroundColor3 = Theme.Off
    B.Text = label or ""
    B.TextColor3 = Theme.White
    B.Font = Enum.Font.GothamBold
    B.TextSize = 13
    B.ZIndex = 100
    Instance.new("UICorner", B).CornerRadius = UDim.new(0, 8)
    
    B.MouseButton1Down:Connect(function()
        Toggles[key] = not Toggles[key]
        TweenService:Create(B, TweenInfo.new(0.3), {BackgroundColor3 = Toggles[key] and Theme.On or Theme.Off}):Play()
    end)
end

-- الأزرار بنفس الترتيب والأسماء المطلوبة
CreateBtn("AutoPop", 40, "Auto Pop-B")
CreateBtn("AutoFour", 85, "Auto 4-Four")
CreateBtn("Extra", 130, "") 

-- [ السلايدر الاحترافي ]
local SliderContainer = Instance.new("Frame")
SliderContainer.Parent = Main
SliderContainer.Size = UDim2.new(0, 140, 0, 4)
SliderContainer.Position = UDim2.new(0.5, -70, 0, 190)
SliderContainer.BackgroundColor3 = Theme.Slider
SliderContainer.ZIndex = 100
Instance.new("UICorner", SliderContainer)

local SliderFill = Instance.new("Frame")
SliderFill.Parent = SliderContainer
SliderFill.Size = UDim2.new(0.9, 0, 1, 0)
SliderFill.BackgroundColor3 = Theme.White
SliderFill.ZIndex = 101
Instance.new("UICorner", SliderFill)

-- [ منطق الفتح الذهبي ]
MenuBtn.MouseButton1Down:Connect(function()
    UI_Open = not UI_Open
    if UI_Open then
        Border.Visible = true
        Border:TweenSize(UDim2.new(0, 210, 0, 230), "Out", "Quint", 0.4, true)
    else
        Border:TweenSize(UDim2.new(0, 0, 0, 0), "In", "Quint", 0.3, true, function() 
            if not UI_Open then Border.Visible = false end 
        end)
    end
end)

RunService.RenderStepped:Connect(function(dt)
    GlobalGrad.Rotation = (GlobalGrad.Rotation + 150 * dt) % 360
end)

-----------------------------------------------------------
-- محرك الفوز (Logic)
-----------------------------------------------------------
local function GetBestMove(grid, myIndex)
    local opp = (myIndex == 1) and 2 or 1
    local g = {}
    for c=1,7 do g[c]={} local d=grid[tostring(c)] or {} for r=1,6 do g[c][r]=d[r] end end
    local function win(b, p)
        for r=1,6 do for c=1,4 do if b[c][r]==p and b[c+1][r]==p and b[c+2][r]==p and b[c+3][r]==p then return true end end end
        for c=1,7 do for r=1,3 do if b[c][r]==p and b[c][r+1]==p and b[c][r+2]==p and b[c][r+3]==p then return true end end end
        for c=1,4 do for r=1,3 do if b[c][r]==p and b[c+1][r+1]==p and b[c+2][r+2]==p and b[c+3][r+3]==p then return true end end end
        for c=1,4 do for r=4,6 do if b[c][r]==p and b[c+1][r-1]==p and b[c+2][r-2]==p and b[c+3][r-3]==p then return true end end end
        return false
    end
    for c=1,7 do
        local r; for row=1,6 do if not g[c][row] then r=row break end end
        if r then g[c][r]=myIndex if win(g, myIndex) then return c end g[c][r]=nil end
    end
    for c=1,7 do
        local r; for row=1,6 do if not g[c][row] then r=row break end end
        if r then g[c][r]=opp if win(g, opp) then return c end g[c][r]=nil end
    end
    for _, c in ipairs({4,3,5,2,6,1,7}) do if #grid[tostring(c)] < 6 then return c end end
end

task.spawn(function()
    while true do
        local Active = ClientGlobals.ActiveMinigame
        if Active and Active.session then
            if Toggles.AutoPop then
                local B = workspace:FindFirstChild("PopcornBurstBoard", true) or workspace:FindFirstChild("SoloPopcornBurstBoard", true)
                if B then
                    for _, p in pairs(B:GetDescendants()) do
                        if p.Name == "Popcorn" and p:IsA("MeshPart") then
                            local ts = p:GetAttribute("TargetScale")
                            if ts and p.Size.X >= (ts * AccuracyVal) then
                                GameRemote:FireServer("AttemptPop", workspace:GetServerTimeNow())
                                task.wait(0.05)
                            end
                        end
                    end
                end
            end
            if Toggles.AutoFour then
                local pub, priv = Active.session.public, Active.session.private
                if pub and pub.phase == "Playing" and pub.currentTurn == priv.seatIndex then
                    local m = GetBestMove(pub.grid, priv.seatIndex)
                    if m then task.wait(0.4) GameRemote:FireServer("DropChip", m) task.wait(1.5) end
                end
            end
        end
        RunService.Heartbeat:Wait()
    end
end)

