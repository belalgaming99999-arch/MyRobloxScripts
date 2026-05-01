local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- [1] التفعيلات التلقائية (Safety & Performance)
local function InitialSettings()
    -- Dual Bypass & Anti-Kick
    local mt = getrawmetatable(game)
    local old = mt.__namecall
    setreadonly(mt, false)
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if method == "Kick" or method == "kick" then return nil end
        return old(self, ...)
    end)
    setreadonly(mt, true)
    
    -- Performance & FPS
    if setfpscap then setfpscap(999) end
    pcall(function()
        local fx = Players.LocalPlayer.PlayerScripts:FindFirstChild("EffectScripts")
        if fx and fx:FindFirstChild("ClientFX") then fx.ClientFX.Disabled = true end
    end)
end
InitialSettings()

-- [2] إعداد الواجهة
local Root = (gethui and gethui()) or CoreGui
if Root:FindFirstChild("CrystalProject") then Root.CrystalProject:Destroy() end
local CrystalGui = Instance.new("ScreenGui", Root)
CrystalGui.Name = "CrystalProject"

local Theme = {
    Bg = Color3.fromRGB(25, 35, 55),
    MainBlue = Color3.fromRGB(45, 85, 160),
    White = Color3.new(1, 1, 1),
    OffRed = Color3.fromRGB(135, 55, 55), 
    OnGreen = Color3.fromRGB(55, 120, 85),
}

local Toggles = {Parry = false, AutoCurve = false, CurveMode = false, Visualizer = false, ManualCurve = false}
local TargetPos = UDim2.new(0.05, 0, 0.25, 0)
local UI_Open, Dragging = false, false

-- القائمة الرئيسية
local Border = Instance.new("Frame", CrystalGui)
Border.Size = UDim2.new(0, 210, 0, 0)
Border.BackgroundColor3 = Theme.White
Border.Visible = false
Border.ClipsDescendants = true
Instance.new("UICorner", Border).CornerRadius = UDim.new(0, 12)

local Main = Instance.new("Frame", Border)
Main.Size = UDim2.new(1, -4, 1, -4)
Main.Position = UDim2.new(0, 2, 0, 2)
Main.BackgroundColor3 = Theme.Bg
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

-- إضافة الأزرار الخمسة
local function AddBtn(txt, key, y)
    local B = Instance.new("TextButton", Main)
    B.Size = UDim2.new(0, 190, 0, 32)
    B.Position = UDim2.new(0.5, -95, 0, y)
    B.BackgroundColor3 = Theme.OffRed
    B.Text = txt .. " [Disable]"
    B.TextColor3 = Theme.White
    B.Font = Enum.Font.GothamBold
    B.TextSize = 11
    Instance.new("UICorner", B).CornerRadius = UDim.new(0, 6)

    B.MouseButton1Click:Connect(function()
        Toggles[key] = not Toggles[key]
        B.Text = txt .. (Toggles[key] and " [Active]" or " [Disable]")
        TweenService:Create(B, TweenInfo.new(0.3), {
            BackgroundColor3 = Toggles[key] and Theme.OnGreen or Theme.OffRed
        }):Play()
    end)
end

AddBtn("Auto Parry", "Parry", 15)
AddBtn("Auto Curve", "AutoCurve", 52)
AddBtn("Curve Mode", "CurveMode", 89)
AddBtn("Distance Visualizer", "Visualizer", 126)
AddBtn("Manual Curve", "ManualCurve", 163)

-- الزر العائم ونظام الحركة
local MenuBtn = Instance.new("TextButton", CrystalGui)
MenuBtn.Size = UDim2.new(0, 52, 0, 52)
MenuBtn.Position = TargetPos
MenuBtn.BackgroundColor3 = Theme.MainBlue
MenuBtn.Text = ""
Instance.new("UICorner", MenuBtn).CornerRadius = UDim.new(0, 10)

RunService.RenderStepped:Connect(function()
    if not Dragging then MenuBtn.Position = MenuBtn.Position:Lerp(TargetPos, 0.25) end
    Border.Position = UDim2.new(MenuBtn.Position.X.Scale, MenuBtn.Position.X.Offset, MenuBtn.Position.Y.Scale, MenuBtn.Position.Y.Offset + 62)
end)

MenuBtn.MouseButton1Click:Connect(function()
    UI_Open = not UI_Open
    if UI_Open then
        Border.Visible = true
        Border:TweenSize(UDim2.new(0, 210, 0, 215), "Out", "Quint", 0.4, true)
    else
        Border:TweenSize(UDim2.new(0, 210, 0, 0), "In", "Quint", 0.3, true, function() Border.Visible = false end)
    end
end)
