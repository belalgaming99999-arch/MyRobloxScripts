-- Crystal Hub | Blade Ball Edition (v2026)
-- Anti-Kick & Professional Auto Parry Integrated

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Debris = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- [1] نظام الحماية المتقدم (Bypass & Anti-Kick)
-- هذا الجزء يمنع السيرفر من طردك عند تفعيل السكريبت
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if method == "Kick" or method == "kick" then
        return nil -- إيقاف أي محاولة طرد
    end
    if self.Name == "ClientFX" and method == "FireServer" then
        return nil -- منع إرسال بيانات المؤثرات المشبوهة
    end
    return oldNamecall(self, ...)
end)
setreadonly(mt, true)

-- [2] إعداد الواجهة (Crystal Hub UI)
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

local Toggles = {AutoParry = false, SkinChanger = false, NoRender = false}
local TargetPos = UDim2.new(0.05, 0, 0.25, 0)
local UI_Open, Dragging = false, false

-- [3] منطق الصد التلقائي (Auto Parry Logic)
local function GetBall()
    local balls = workspace:FindFirstChild("Balls")
    if not balls then return nil end
    for _, v in pairs(balls:GetChildren()) do
        if v:GetAttribute("realBall") or (v:IsA("BasePart") and v.Name == "Ball") then
            return v
        end
    end
    return nil
end

local function ExecuteParry()
    if not Toggles.AutoParry then return end
    local ball = GetBall()
    if not ball then return end

    local char = Players.LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    local distance = (char.HumanoidRootPart.Position - ball.Position).Magnitude
    local velocity = ball.Velocity.Magnitude
    local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() / 1000
    
    -- حساب التنبؤ (نفس الملف الأصلي)
    local prediction = distance / (velocity > 0 and velocity or 1)
    
    if prediction <= (0.18 + ping) then
        local parryRemote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("Parry")
        if parryRemote then
            parryRemote:FireServer()
        end
    end
end

-- [4] بناء الأزرار والواجهة
local MenuBtn = Instance.new("TextButton", CrystalGui)
MenuBtn.Size = UDim2.new(0, 52, 0, 52)
MenuBtn.Position = TargetPos
MenuBtn.BackgroundColor3 = Theme.MainBlue
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
Instance.new("UICorner", Border).CornerRadius = UDim.new(0, 12)

local Main = Instance.new("Frame", Border)
Main.Size = UDim2.new(1, -4, 1, -4)
Main.Position = UDim2.new(0, 2, 0, 2)
Main.BackgroundColor3 = Theme.Bg
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

local GlobalGrad = Instance.new("UIGradient", Border)
GlobalGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Theme.MainBlue),
    ColorSequenceKeypoint.new(0.5, Theme.White),
    ColorSequenceKeypoint.new(1, Theme.MainBlue)
})

-- وظيفة إضافة الأزرار
local function AddBtn(txt, key, y, callback)
    local B = Instance.new("TextButton", Main)
    B.Size = UDim2.new(0, 180, 0, 38)
    B.Position = UDim2.new(0.5, -90, 0, y)
    B.BackgroundColor3 = Theme.OffRed
    B.Text = txt .. " [Disable]"
    B.TextColor3 = Theme.White
    B.Font = Enum.Font.GothamBold
    B.TextSize = 13
    Instance.new("UICorner", B).CornerRadius = UDim.new(0, 8)

    B.MouseButton1Click:Connect(function()
        Toggles[key] = not Toggles[key]
        B.Text = txt .. (Toggles[key] and " [Active]" or " [Disable]")
        TweenService:Create(B, TweenInfo.new(0.3), {BackgroundColor3 = Toggles[key] and Theme.OnGreen or Theme.OffRed}):Play()
        if callback then callback(Toggles[key]) end
    end)
end

AddBtn("Auto Parry", "AutoParry", 55)
AddBtn("Skin Changer", "SkinChanger", 101, function(s) getgenv().skinChangerEnabled = s end)
AddBtn("No Render", "NoRender", 147, function(s) 
    pcall(function() Players.LocalPlayer.PlayerScripts.EffectScripts.ClientFX.Disabled = s end)
end)

-- حلقات التحديث
RunService.PostSimulation:Connect(ExecuteParry)
RunService.RenderStepped:Connect(function(dt)
    if not Dragging then MenuBtn.Position = MenuBtn.Position:Lerp(TargetPos, 0.25) end
    Border.Position = UDim2.new(MenuBtn.Position.X.Scale, MenuBtn.Position.X.Offset, MenuBtn.Position.Y.Scale, MenuBtn.Position.Y.Offset + 62)
    GlobalGrad.Rotation = (GlobalGrad.Rotation + 150 * dt) % 360
end)

-- نظام السحب والفتح (Drag & Open)
local dStart, sPos, isDragged
MenuBtn.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = true; isDragged = false; dStart = i.Position; sPos = MenuBtn.Position end end)
UserInputService.InputChanged:Connect(function(i) if Dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
    local delta = i.Position - dStart
    if delta.Magnitude > 2 then isDragged = true end
    TargetPos = UDim2.new(sPos.X.Scale, sPos.X.Offset + delta.X, sPos.Y.Scale, sPos.Y.Offset + delta.Y)
end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = false end end)
MenuBtn.MouseButton1Click:Connect(function()
    if not isDragged then
        UI_Open = not UI_Open
        if UI_Open then Border.Visible = true; Border:TweenSize(UDim2.new(0, 204, 0, 201), "Out", "Quint", 0.4, true)
        else Border:TweenSize(UDim2.new(0, 0, 0, 0), "In", "Quint", 0.3, true, function() Border.Visible = false end) end
    end
end)
