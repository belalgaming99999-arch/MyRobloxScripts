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
    Bg = Color3.fromRGB(15, 20, 35),
    Accent = Color3.fromRGB(45, 120, 255),
    White = Color3.new(1, 1, 1),
    Red = Color3.fromRGB(200, 60, 60), 
    Green = Color3.fromRGB(60, 200, 110)
}

local Toggles = {State1 = false, State2 = false, State3 = false}
local TargetPos = UDim2.new(0.05, 0, 0.25, 0)
local UI_Open, Dragging = false, false

local function MainLogic(key)
    task.spawn(function()
        while Toggles[key] do
            task.wait(1)
        end
    end)
end

local MenuBtn = Instance.new("TextButton", CrystalGui)
MenuBtn.Size = UDim2.new(0, 52, 0, 52)
MenuBtn.Position = TargetPos
MenuBtn.BackgroundColor3 = Theme.Accent
MenuBtn.Text = ""
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
Border.BackgroundColor3 = Theme.White
Border.Visible = false
Border.ClipsDescendants = true
Instance.new("UICorner", Border).CornerRadius = UDim.new(0, 12)

local Main = Instance.new("Frame", Border)
Main.Size = UDim2.new(1, -4, 1, -4)
Main.Position = UDim2.new(0, 2, 0, 2)
Main.BackgroundColor3 = Theme.Bg
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

local Grad = Instance.new("UIGradient", Border)
Grad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Theme.Accent), 
    ColorSequenceKeypoint.new(0.5, Theme.White), 
    ColorSequenceKeypoint.new(1, Theme.Accent)
})

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 45)
Title.Text = "Crystal Hub"
Title.TextColor3 = Theme.White
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.BackgroundTransparency = 1

RunService.RenderStepped:Connect(function(dt)
    if not Dragging then 
        MenuBtn.Position = MenuBtn.Position:Lerp(TargetPos, 0.2) 
    end
    Border.Position = UDim2.new(MenuBtn.Position.X.Scale, MenuBtn.Position.X.Offset, MenuBtn.Position.Y.Scale, MenuBtn.Position.Y.Offset + 62)
    Grad.Rotation = (Grad.Rotation + 150 * dt) % 360
end)

local function AddBtn(txt, key, y)
    local B = Instance.new("TextButton", Main)
    B.Size = UDim2.new(0, 180, 0, 38)
    B.Position = UDim2.new(0.5, -90, 0, y)
    B.BackgroundColor3 = Theme.Red
    B.Text = txt .. " [Disable]"
    B.TextColor3 = Theme.White
    B.Font = Enum.Font.GothamBold
    B.TextSize = 13
    Instance.new("UICorner", B).CornerRadius = UDim.new(0, 8)

    B.MouseButton1Click:Connect(function()
        Toggles[key] = not Toggles[key]
        B.Text = txt .. (Toggles[key] and " [Active]" or " [Disable]")
        TweenService:Create(B, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {
            BackgroundColor3 = Toggles[key] and Theme.Green or Theme.Red
        }):Play()
        if Toggles[key] then MainLogic(key) end
    end)
end

AddBtn("Feature 1", "State1", 55)
AddBtn("Feature 2", "State2", 101)
AddBtn("Feature 3", "State3", 147)

local dStart, sPos
MenuBtn.InputBegan:Connect(function(i)
    if (i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch) then
        Dragging = true; dStart = i.Position; sPos = MenuBtn.Position
        i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then Dragging = false end end)
    end
end)

UserInputService.InputChanged:Connect(function(i)
    if Dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        local delta = i.Position - dStart
        TargetPos = UDim2.new(sPos.X.Scale, sPos.X.Offset + delta.X, sPos.Y.Scale, sPos.Y.Offset + delta.Y)
    end
end)

MenuBtn.MouseButton1Click:Connect(function()
    UI_Open = not UI_Open
    if UI_Open then
        Border.Visible = true
        Border:TweenSize(UDim2.new(0, 204, 0, 201), "Out", "Quint", 0.5, true)
    else
        Border:TweenSize(UDim2.new(0, 0, 0, 0), "In", "Quint", 0.4, true, function() Border.Visible = false end)
    end
end)
