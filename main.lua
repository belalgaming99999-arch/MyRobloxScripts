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
    Bg = Color3.fromRGB(25, 35, 55),
    Main = Color3.fromRGB(45, 85, 160),
    White = Color3.new(1, 1, 1),
    Off = Color3.fromRGB(135, 55, 55), 
    On = Color3.fromRGB(55, 120, 85),
    Slider = Color3.fromRGB(40, 50, 75)
}

local Toggles = {AutoPop = false, AutoFour = false, Extra = false}
local AccuracyVal = 7 
local UI_Open, Dragging = false, false

local MenuBtn = Instance.new("TextButton", CrystalGui)
MenuBtn.Size = UDim2.new(0, 52, 0, 52)
MenuBtn.Position = UDim2.new(0.05, 0, 0.15, 0)
MenuBtn.BackgroundColor3 = Theme.Main
MenuBtn.Text = ""
MenuBtn.AutoButtonColor = false
Instance.new("UICorner", MenuBtn).CornerRadius = UDim.new(0, 10)

for i = -1, 1 do
    local L = Instance.new("Frame", MenuBtn)
    L.Size = UDim2.new(0, 26, 0, 4)
    L.Position = UDim2.new(0.5, -13, 0.5, (i * 10) - 2)
    L.BackgroundColor3 = Theme.White
    Instance.new("UICorner", L).CornerRadius = UDim.new(1, 0)
end

local Border = Instance.new("Frame", CrystalGui)
Border.Size = UDim2.new(0, 0, 0, 0)
Border.Visible = false
Border.BackgroundColor3 = Theme.White
Border.ClipsDescendants = true
Instance.new("UICorner", Border).CornerRadius = UDim.new(0, 12)

local Main = Instance.new("Frame", Border)
Main.Size = UDim2.new(1, -4, 1, -4)
Main.Position = UDim2.new(0, 2, 0, 2)
Main.BackgroundColor3 = Theme.Bg
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

local GlobalGrad = Instance.new("UIGradient", Border)
GlobalGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Theme.Main),
    ColorSequenceKeypoint.new(0.5, Theme.White),
    ColorSequenceKeypoint.new(1, Theme.Main)
})

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(0, 130, 0, 25)
Title.Position = UDim2.new(0.5, -65, 0, 12)
Title.BackgroundTransparency = 1
Title.Text = "Crystal Hub"
Title.TextColor3 = Theme.White
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
local TitleGrad = GlobalGrad:Clone()
TitleGrad.Parent = Title

local UnderLine = Instance.new("Frame", Main)
UnderLine.Size = UDim2.new(0, 120, 0, 4)
UnderLine.Position = UDim2.new(0.5, -60, 0, 40)
UnderLine.BackgroundColor3 = Theme.White
Instance.new("UICorner", UnderLine).CornerRadius = UDim.new(1, 0)
local LineGrad = GlobalGrad:Clone()
LineGrad.Parent = UnderLine

local function CreateBtn(key, y, label)
    local B = Instance.new("TextButton", Main)
    B.Size = UDim2.new(0, 180, 0, 38)
    B.Position = UDim2.new(0.5, -90, 0, y)
    B.BackgroundColor3 = Theme.Off
    B.Text = label .. " [Deactive]"
    B.TextColor3 = Theme.White
    B.Font = Enum.Font.GothamBold
    B.TextSize = 13
    B.AutoButtonColor = false
    Instance.new("UICorner", B).CornerRadius = UDim.new(0, 8)

    B.MouseButton1Click:Connect(function()
        Toggles[key] = not Toggles[key]
        B.Text = label .. (Toggles[key] and " [Active]" or " [Deactive]")
        TweenService:Create(B, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
            BackgroundColor3 = Toggles[key] and Theme.On or Theme.Off
        }):Play()
    end)
end

CreateBtn("AutoPop", 55, "Auto Pop-B")
CreateBtn("AutoFour", 101, "Auto 4-Four")
CreateBtn("Extra", 147, "Extra Feature")

local SliderContainer = Instance.new("Frame", Main)
SliderContainer.Size = UDim2.new(0, 120, 0, 30)
SliderContainer.Position = UDim2.new(0.5, -60, 0, 195)
SliderContainer.BackgroundTransparency = 1

local SliderLabel = Instance.new("TextLabel", SliderContainer)
SliderLabel.Size = UDim2.new(1, 0, 0, 20)
SliderLabel.BackgroundTransparency = 1
SliderLabel.Text = "Accessory: " .. AccuracyVal
SliderLabel.TextColor3 = Theme.White
SliderLabel.Font = Enum.Font.GothamBold
SliderLabel.TextSize = 13
local LabelGrad = GlobalGrad:Clone()
LabelGrad.Parent = SliderLabel

local SliderBg = Instance.new("Frame", SliderContainer)
SliderBg.Size = UDim2.new(1, 0, 0, 4)
SliderBg.Position = UDim2.new(0, 0, 0, 25)
SliderBg.BackgroundColor3 = Theme.Slider
Instance.new("UICorner", SliderBg).CornerRadius = UDim.new(1, 0)

local SliderFill = Instance.new("Frame", SliderBg)
SliderFill.Size = UDim2.new(AccuracyVal / 10, 0, 1, 0)
SliderFill.BackgroundColor3 = Theme.White
Instance.new("UICorner", SliderFill).CornerRadius = UDim.new(1, 0)
local FillGrad = GlobalGrad:Clone()
FillGrad.Parent = SliderFill

local Knob = Instance.new("Frame", SliderFill)
Knob.Size = UDim2.new(0, 14, 0, 14)
Knob.Position = UDim2.new(1, -7, 0.5, -7)
Knob.BackgroundColor3 = Theme.White
Knob.ZIndex = 5
Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)
local KnobGrad = GlobalGrad:Clone()
KnobGrad.Parent = Knob

local function UpdateSlider(input)
    local xPos = input.Position.X - SliderBg.AbsolutePosition.X
    local rawPos = math.clamp(xPos / SliderBg.AbsoluteSize.X, 0, 1)
    AccuracyVal = math.floor(rawPos * 10)
    SliderFill.Size = UDim2.new(AccuracyVal / 10, 0, 1, 0)
    SliderLabel.Text = "Accessory: " .. AccuracyVal
end

local Sliding = false
SliderBg.InputBegan:Connect(function(i) 
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then Sliding = true; UpdateSlider(i) end 
end)
UserInputService.InputChanged:Connect(function(i) 
    if Sliding and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then UpdateSlider(i) end 
end)
UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then Sliding = false end 
end)

local dragStart, startPos, isDragged
MenuBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        Dragging = true; isDragged = false; dragStart = input.Position; startPos = MenuBtn.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        if delta.Magnitude > 2 then isDragged = true end
        MenuBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        if Border.Visible then
            Border.Position = UDim2.new(MenuBtn.Position.X.Scale, MenuBtn.Position.X.Offset, MenuBtn.Position.Y.Scale, MenuBtn.Position.Y.Offset + 62)
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then Dragging = false end
end)

MenuBtn.MouseButton1Click:Connect(function()
    if not isDragged then
        UI_Open = not UI_Open
        if UI_Open then
            Border.Position = UDim2.new(MenuBtn.Position.X.Scale, MenuBtn.Position.X.Offset, MenuBtn.Position.Y.Scale, MenuBtn.Position.Y.Offset + 62)
            Border.Visible = true
            Border:TweenSize(UDim2.new(0, 210, 0, 250), "Out", "Quint", 0.4, true)
        else
            Border:TweenSize(UDim2.new(0, 0, 0, 0), "In", "Quint", 0.3, true, function() Border.Visible = false end)
        end
    end
end)

RunService.RenderStepped:Connect(function(dt)
    local rot = (GlobalGrad.Rotation + 150 * dt) % 360
    GlobalGrad.Rotation = rot; TitleGrad.Rotation = rot; LineGrad.Rotation = rot; LabelGrad.Rotation = rot; FillGrad.Rotation = rot; KnobGrad.Rotation = rot
end)

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
        local Remote = ReplicatedStorage:FindFirstChild("CombineMinigameAction", true)
        local ClientGlobals
        pcall(function() ClientGlobals = require(ReplicatedStorage:WaitForChild("Client"):WaitForChild("Modules"):WaitForChild("ClientGlobals")) end)
        if Remote and ClientGlobals and ClientGlobals.ActiveMinigame then
            local session = ClientGlobals.ActiveMinigame.session
            if Toggles.AutoPop then
                local PopBoard = workspace:FindFirstChild("PopcornBurstBoard", true) or workspace:FindFirstChild("SoloPopcornBurstBoard", true)
                if PopBoard then
                    for _, obj in pairs(PopBoard:GetDescendants()) do
                        if obj:IsA("MeshPart") and obj.Name == "Popcorn" then
                            local targetScale = obj:GetAttribute("TargetScale")
                            if targetScale and obj.Size.X >= (targetScale * (0.88 + (AccuracyVal * 0.011))) then
                                Remote:FireServer("AttemptPop", workspace:GetServerTimeNow())
                                task.wait(0.05)
                            end
                        end
                    end
                end
            end
            if Toggles.AutoFour and session and session.public and session.private then
                local pub, priv = session.public, session.private
                if pub.phase == "Playing" and pub.currentTurn == priv.seatIndex then
                    local move = GetBestMove(pub.grid, priv.seatIndex)
                    if move then task.wait(0.5); Remote:FireServer("DropChip", move); task.wait(1.5) end
                end
            end
        end
        RunService.Heartbeat:Wait()
    end
end)
