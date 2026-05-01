local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local Root = (gethui and gethui()) or CoreGui
if Root:FindFirstChild("CrystalProject") then Root.CrystalProject:Destroy() end

local CrystalGui = Instance.new("ScreenGui", Root)
CrystalGui.Name = "CrystalProject"
CrystalGui.IgnoreGuiInset = true
CrystalGui.DisplayOrder = 1e6

local Theme = {
    Bg = Color3.fromRGB(25, 35, 55),
    MainBlue = Color3.fromRGB(45, 85, 160),
    White = Color3.new(1, 1, 1),
    OffRed = Color3.fromRGB(135, 55, 55), 
    OnGreen = Color3.fromRGB(55, 120, 85),
}

local Toggles = {State1 = false, State2 = false, State3 = false}
local TargetPos = UDim2.new(0.05, 0, 0.25, 0)
local UI_Open, Dragging = false, false

local MenuBtn = Instance.new("TextButton", CrystalGui)
MenuBtn.Size = UDim2.new(0, 52, 0, 52)
MenuBtn.Position = TargetPos
MenuBtn.BackgroundColor3 = Theme.MainBlue
MenuBtn.Text = ""
MenuBtn.AutoButtonColor = false
MenuBtn.ZIndex = 100
Instance.new("UICorner", MenuBtn).CornerRadius = UDim.new(0, 10)

for i = -1, 1 do
    local L = Instance.new("Frame", MenuBtn)
    L.Size = UDim2.new(0, 26, 0, 4)
    L.Position = UDim2.new(0.5, -13, 0.5, (i * 10) - 2)
    L.BackgroundColor3 = Theme.White
    L.ZIndex = 101
    Instance.new("UICorner", L).CornerRadius = UDim.new(1, 0)
end

local Border = Instance.new("Frame", CrystalGui)
Border.Size = UDim2.new(0, 0, 0, 0)
Border.BackgroundColor3 = Theme.White
Border.Position = UDim2.new(TargetPos.X.Scale, TargetPos.X.Offset, TargetPos.Y.Scale, TargetPos.Y.Offset + 62)
Border.ClipsDescendants = true
Border.Visible = false
Border.ZIndex = 90
Instance.new("UICorner", Border).CornerRadius = UDim.new(0, 12)

local Main = Instance.new("Frame", Border)
Main.Size = UDim2.new(1, -4, 1, -4)
Main.Position = UDim2.new(0, 2, 0, 2)
Main.BackgroundColor3 = Theme.Bg
Main.ZIndex = 91
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

local GlobalGrad = Instance.new("UIGradient", Border)
GlobalGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Theme.MainBlue),
    ColorSequenceKeypoint.new(0.5, Theme.White),
    ColorSequenceKeypoint.new(1, Theme.MainBlue)
})

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 45)
Title.Text = "Crystal Hub"
Title.TextColor3 = Theme.White
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.BackgroundTransparency = 1
Title.ZIndex = 92

local TitleGrad = Instance.new("UIGradient", Title)
TitleGrad.Color = GlobalGrad.Color

local UnderLine = Instance.new("Frame", Main)
UnderLine.Size = UDim2.new(0, 120, 0, 4)
UnderLine.Position = UDim2.new(0.5, -60, 0, 40)
UnderLine.BackgroundColor3 = Theme.White
UnderLine.ZIndex = 92
Instance.new("UICorner", UnderLine).CornerRadius = UDim.new(1, 0)

local LineGrad = Instance.new("UIGradient", UnderLine)
LineGrad.Color = GlobalGrad.Color

RunService.RenderStepped:Connect(function(dt)
    if not Dragging then 
        MenuBtn.Position = MenuBtn.Position:Lerp(TargetPos, 0.2) 
    end
    Border.Position = UDim2.new(MenuBtn.Position.X.Scale, MenuBtn.Position.X.Offset, MenuBtn.Position.Y.Scale, MenuBtn.Position.Y.Offset + 62)
    local rot = (GlobalGrad.Rotation + 180 * dt) % 360
    GlobalGrad.Rotation = rot
    TitleGrad.Rotation = rot
    LineGrad.Rotation = rot
end)

local function AddBtn(txt, key, y)
    local B = Instance.new("TextButton", Main)
    B.Size = UDim2.new(0, 180, 0, 38)
    B.Position = UDim2.new(0.5, -90, 0, y)
    B.BackgroundColor3 = Theme.OffRed
    B.Text = txt .. " [Disable]"
    B.TextColor3 = Theme.White
    B.Font = Enum.Font.GothamBold
    B.TextSize = 13
    B.ZIndex = 93
    Instance.new("UICorner", B).CornerRadius = UDim.new(0, 8)

    B.MouseButton1Click:Connect(function()
        Toggles[key] = not Toggles[key]
        B.Text = txt .. (Toggles[key] and " [Active]" or " [Disable]")
        TweenService:Create(B, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {
            BackgroundColor3 = Toggles[key] and Theme.OnGreen or Theme.OffRed
        }):Play()
    end)
end

AddBtn("Feature 1", "State1", 55)
AddBtn("Feature 2", "State2", 101)
AddBtn("Feature 3", "State3", 147)

local dStart, sPos, isDragged
MenuBtn.InputBegan:Connect(function(i)
    if (i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch) then
        Dragging = true; isDragged = false; dStart = i.Position; sPos = MenuBtn.Position
        i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then Dragging = false end end)
    end
end)

UserInputService.InputChanged:Connect(function(i)
    if Dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        local delta = i.Position - dStart
        if delta.Magnitude > 5 then isDragged = true end
        TargetPos = UDim2.new(sPos.X.Scale, sPos.X.Offset + delta.X, sPos.Y.Scale, sPos.Y.Offset + delta.Y)
    end
end)

MenuBtn.MouseButton1Click:Connect(function()
    if not isDragged then
        UI_Open = not UI_Open
        if UI_Open then
            Border.Visible = true
            Border:TweenSize(UDim2.new(0, 204, 0, 201), "Out", "Quint", 0.5, true)
        else
            Border:TweenSize(UDim2.new(0, 0, 0, 0), "In", "Quint", 0.4, true, function() Border.Visible = false end)
        end
    end
end)

