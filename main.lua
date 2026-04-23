-- [[ Crystal Hub - Fixed Order & Design ]] --

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Player = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

local CrystalPurple = Color3.fromRGB(120, 0, 255)
local CornerRadius = UDim.new(0, 15)

local Toggles = {
    Esp = false, BatAimbot = false, StealNearest = false,
    AutoMedusa = false, AntiFling = false, AntiRagdoll = false,
    NoWalk = false, InfJump = false, Spin = false, Optimizer = false,
    LeftSteal = false, RightSteal = false
}

-- تنظيف الشاشة
for _, child in pairs(CoreGui:GetChildren()) do
    if child:IsA("ScreenGui") and child.Name:find("Crystal") then child:Destroy() end
end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "Crystal_V3_Fixed"

-- ========== SPEED DISPLAY (أبيض) ==========
local speedBillboard = Instance.new("BillboardGui")
speedBillboard.Size = UDim2.new(0, 100, 0, 30); speedBillboard.StudsOffset = Vector3.new(0, 3.5, 0); speedBillboard.AlwaysOnTop = true
local speedLabel = Instance.new("TextLabel", speedBillboard)
speedLabel.Size = UDim2.new(1, 0, 1, 0); speedLabel.BackgroundTransparency = 1; speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.Font = Enum.Font.GothamBold; speedLabel.TextSize = 14; speedLabel.Text = "Speed: 0.0"

local function attachSpeed(char)
    local hrp = char:WaitForChild("HumanoidRootPart")
    speedBillboard.Adornee = hrp; speedBillboard.Parent = hrp
end
if Player.Character then attachSpeed(Player.Character) end
Player.CharacterAdded:Connect(attachSpeed)

-- ========== GUI ELEMENTS ==========

local MainMenu = Instance.new("Frame", ScreenGui)
MainMenu.Size = UDim2.new(0, 160, 0, 420); MainMenu.Position = UDim2.new(-0.7, 0, 0.3, 0)
MainMenu.BackgroundColor3 = Color3.fromRGB(0, 0, 0); MainMenu.BackgroundTransparency = 0.5
Instance.new("UICorner", MainMenu).CornerRadius = CornerRadius
Instance.new("UIStroke", MainMenu).Color = CrystalPurple

local SubMenu = Instance.new("Frame", ScreenGui)
SubMenu.Size = UDim2.new(0, 140, 0, 100); SubMenu.Visible = false
SubMenu.BackgroundColor3 = Color3.fromRGB(0, 0, 0); SubMenu.BackgroundTransparency = 0.3
Instance.new("UICorner", SubMenu).CornerRadius = CornerRadius
Instance.new("UIStroke", SubMenu).Color = CrystalPurple

-- الترتيب الرأسي
local UIList = Instance.new("UIListLayout", MainMenu); UIList.Padding = UDim.new(0, 7); UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
Instance.new("UIPadding", MainMenu).PaddingTop = UDim.new(0, 12)

local SubList = Instance.new("UIListLayout", SubMenu); SubList.Padding = UDim.new(0, 7); SubList.HorizontalAlignment = Enum.HorizontalAlignment.Center
Instance.new("UIPadding", SubMenu).PaddingTop = UDim.new(0, 12)

-- وظيفة الأزرار
local function CreateBtn(txt, parent, size, toggleKey, action)
    local btn = Instance.new("TextButton", parent)
    btn.Size = size or UDim2.new(0, 140, 0, 36); btn.BackgroundColor3 = Color3.fromRGB(0,0,0); btn.BackgroundTransparency = 0.2
    btn.Text = txt; btn.TextColor3 = Color3.fromRGB(255, 255, 255); btn.Font = Enum.Font.GothamBold; btn.TextSize = 10
    Instance.new("UICorner", btn).CornerRadius = CornerRadius
    Instance.new("UIStroke", btn).Color = CrystalPurple

    btn.MouseButton1Click:Connect(function()
        if toggleKey then
            Toggles[toggleKey] = not Toggles[toggleKey]
            btn.BackgroundColor3 = Toggles[toggleKey] and CrystalPurple or Color3.fromRGB(0,0,0)
            btn.BackgroundTransparency = Toggles[toggleKey] and 0 or 0.2
        end
        if action then action() end
    end)
    return btn
end

local function Row(p)
    local f = Instance.new("Frame", p); f.Size = UDim2.new(0, 140, 0, 32); f.BackgroundTransparency = 1
    local l = Instance.new("UIListLayout", f); l.FillDirection = Enum.FillDirection.Horizontal; l.Padding = UDim.new(0, 8); l.HorizontalAlignment = Enum.HorizontalAlignment.Center
    return f
end

-- [[ الترتيب الصحيح الآن ]] --

-- 1. زر الـ ESP (أول واحد فوق)
CreateBtn("Esp Player", MainMenu, nil, "Esp")

-- 2. بقية الأزرار والصفوف
local R1 = Row(MainMenu); 
CreateBtn("Bat Aimbot", R1, UDim2.new(0, 66, 1, 0), "BatAimbot")
CreateBtn("Steal Nearest", R1, UDim2.new(0, 66, 1, 0), "StealNearest")

local R2 = Row(MainMenu); 
CreateBtn("Auto Medusa", R2, UDim2.new(0, 66, 1, 0), "AutoMedusa")
CreateBtn("Auto Play", R2, UDim2.new(0, 66, 1, 0), nil, function()
    SubMenu.Visible = not SubMenu.Visible
    SubMenu.Position = UDim2.new(MainMenu.Position.X.Scale, MainMenu.Position.X.Offset + 170, MainMenu.Position.Y.Scale, MainMenu.Position.Y.Offset + 100)
end)

local R3 = Row(MainMenu); 
CreateBtn("Anti Fling", R3, UDim2.new(0, 66, 1, 0), "AntiFling")
CreateBtn("Anti Ragdoll", R3, UDim2.new(0, 66, 1, 0), "AntiRagdoll")

local R4 = Row(MainMenu); 
CreateBtn("No Walk", R4, UDim2.new(0, 66, 1, 0), "NoWalk")
CreateBtn("Infinite Jump", R4, UDim2.new(0, 66, 1, 0), "InfJump")

local R5 = Row(MainMenu); 
CreateBtn("Spin Player", R5, UDim2.new(0, 66, 1, 0), "Spin")
CreateBtn("Optimizer", R5, UDim2.new(0, 66, 1, 0), "Optimizer")

-- أزرار القائمة الفرعية
CreateBtn("Left Path", SubMenu, UDim2.new(0, 120, 0, 30), "LeftSteal")
CreateBtn("Right Path", SubMenu, UDim2.new(0, 120, 0, 30), "RightSteal")

-- ========== الأيقونة والسحب الذكي ==========
local SideButton = Instance.new("TextButton", ScreenGui)
SideButton.Size = UDim2.new(0, 60, 0, 60); SideButton.Position = UDim2.new(1, -75, 0.3, 0)
SideButton.BackgroundColor3 = CrystalPurple; SideButton.Text = ""
Instance.new("UICorner", SideButton).CornerRadius = CornerRadius

local menuOpen = false
local dragStartPos = nil

local function MakeDraggable(gui)
    local dragging, dragStart, startPos
    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = gui.Position; dragStartPos = input.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    gui.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
            if dragStartPos and (input.Position - dragStartPos).Magnitude < 5 then
                menuOpen = not menuOpen
                MainMenu:TweenPosition(UDim2.new(menuOpen and 0.05 or -0.7, 0, 0.3, 0), "Out", "Quart", 0.4, true)
                if not menuOpen then SubMenu.Visible = false end
            end
        end
    end)
end
MakeDraggable(SideButton)
