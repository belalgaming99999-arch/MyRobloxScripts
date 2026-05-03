local Services = setmetatable({}, {
    __index = function(t, k) return game:GetService(k) end
})
local TS, UIS, CG, RS, LP = Services.TweenService, Services.UserInputService, Services.CoreGui, Services.ReplicatedStorage, Services.Players.LocalPlayer

local Crystal = {
    ID = "Crystal_Elite_2026",
    Config = {AutoPop = false, ConnectFour = false, Accuracy = 7},
    Theme = {
        MainBlue = Color3.fromRGB(0, 120, 255),
        Dark     = Color3.fromRGB(10, 10, 10),
        Gray     = Color3.fromRGB(35, 35, 35),
        Icon     = Color3.fromRGB(15, 15, 15),
        Off      = Color3.fromRGB(50, 50, 50),
        Slider   = Color3.fromRGB(60, 60, 60),
        White    = Color3.fromRGB(255, 255, 255),
        Font     = Enum.Font.GothamBold,
        Size     = 12
    }
}

local Existing = CG:FindFirstChild(Crystal.ID)
if Existing then Existing:Destroy() end

local UI = {}
function UI:Build(class, props, parent)
    local inst = Instance.new(class)
    for k, v in pairs(props) do inst[k] = v end
    inst.Parent = parent
    return inst
end

function UI:Tween(obj, goal, time)
    local info = TweenInfo.new(time or 0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    local tween = TS:Create(obj, info, goal)
    tween:Play()
    return tween
end

local Screen = UI:Build("ScreenGui", {Name = Crystal.ID, ZIndexBehavior = Enum.ZIndexBehavior.Sibling}, CG)

local OpenBtn = UI:Build("TextButton", {
    Size = UDim2.new(0, 110, 0, 35), Position = UDim2.new(0.5, -58, 0.16, 0),
    BackgroundColor3 = Crystal.Theme.Icon, Text = "Crystal Hub", TextColor3 = Crystal.Theme.White,
    Font = Crystal.Theme.Font, TextSize = Crystal.Theme.Size, AutoButtonColor = false, ZIndex = 10
}, Screen)
UI:Build("UICorner", {CornerRadius = UDim.new(0, 18)}, OpenBtn)
local BtnStroke = UI:Build("UIStroke", {Color = Crystal.Theme.MainBlue, Thickness = 1.5}, OpenBtn)

local Main = UI:Build("CanvasGroup", {
    Size = UDim2.new(0, 380, 0, 190), Position = UDim2.new(0.5, -190, 0.5, -95),
    BackgroundColor3 = Crystal.Theme.Dark, Visible = false, GroupTransparency = 1
}, Screen)
UI:Build("UICorner", {CornerRadius = UDim.new(0, 18)}, Main)
local MStroke = UI:Build("UIStroke", {Color = Crystal.Theme.MainBlue, Thickness = 1.5, Transparency = 1}, Main)

local function ToggleUI(state)
    local t = 0.3
    if state then
        Main.Visible = true
        UI:Tween(Main, {GroupTransparency = 0, Size = UDim2.new(0, 380, 0, 190)}, t)
        UI:Tween(MStroke, {Transparency = 0}, t)
        UI:Tween(OpenBtn, {BackgroundTransparency = 1, TextTransparency = 1}, t)
        UI:Tween(BtnStroke, {Transparency = 1}, t)
        task.delay(t, function() OpenBtn.Visible = false end)
    else
        UI:Tween(MStroke, {Transparency = 1}, t)
        local hide = UI:Tween(Main, {GroupTransparency = 1, Size = UDim2.new(0, 360, 0, 170)}, t)
        OpenBtn.Visible = true
        UI:Tween(OpenBtn, {BackgroundTransparency = 0, TextTransparency = 0}, t)
        UI:Tween(BtnStroke, {Transparency = 0}, t)
        hide.Completed:Connect(function() 
            if Main.GroupTransparency == 1 then Main.Visible = false end 
        end)
    end
end

local Header = UI:Build("Frame", {Size = UDim2.new(1, 0, 0, 38), BackgroundColor3 = Crystal.Theme.Gray}, Main)
UI:Build("UICorner", {CornerRadius = UDim.new(0, 18)}, Header)
UI:Build("Frame", {Size = UDim2.new(1, 0, 0, 15), Position = UDim2.new(0, 0, 1, -15), BackgroundColor3 = Crystal.Theme.Gray, BorderSizePixel = 0}, Header)

UI:Build("TextLabel", {
    Size = UDim2.new(1, 0, 0, 38), Text = "Crystal Hub - Mini Games", BackgroundTransparency = 1,
    TextColor3 = Crystal.Theme.White, Font = Crystal.Theme.Font, TextSize = Crystal.Theme.Size, ZIndex = 3
}, Main)

local CloseBtn = UI:Build("TextButton", {
    Size = UDim2.new(0, 35, 0, 38), Position = UDim2.new(1, -38, 0, 0), Text = "X",
    BackgroundTransparency = 1, TextColor3 = Crystal.Theme.White, Font = Crystal.Theme.Font,
    TextSize = Crystal.Theme.Size, AutoButtonColor = false, ZIndex = 3
}, Main)

local function AddToggle(name, pos, icon, var)
    local F = UI:Build("Frame", {Size = UDim2.new(0, 175, 0, 42), Position = pos, BackgroundColor3 = Crystal.Theme.Gray}, Main)
    UI:Build("UICorner", {CornerRadius = UDim.new(0, 18)}, F)
    
    local I = UI:Build("TextLabel", {
        Size = UDim2.new(0, 28, 0, 28), Position = UDim2.new(0, 8, 0.5, -14), BackgroundColor3 = Crystal.Theme.MainBlue,
        Text = icon, TextColor3 = Crystal.Theme.White, Font = Crystal.Theme.Font, TextSize = Crystal.Theme.Size
    }, F)
    UI:Build("UICorner", {CornerRadius = UDim.new(1, 0)}, I)
    
    UI:Build("TextLabel", {
        Size = UDim2.new(0, 85, 1, 0), Position = UDim2.new(0, 44, 0, 0), Text = name, BackgroundTransparency = 1,
        TextColor3 = Crystal.Theme.White, Font = Crystal.Theme.Font, TextSize = 11, TextXAlignment = "Left"
    }, F)

    local B = UI:Build("TextButton", {
        Size = UDim2.new(0, 32, 0, 16), Position = UDim2.new(1, -40, 0.5, -8), BackgroundColor3 = Crystal.Theme.Off,
        Text = "", AutoButtonColor = false
    }, F)
    UI:Build("UICorner", {CornerRadius = UDim.new(1, 0)}, B)
    
    local D = UI:Build("Frame", {Size = UDim2.new(0, 12, 0, 12), Position = UDim2.new(0, 2, 0.5, -6), BackgroundColor3 = Crystal.Theme.White}, B)
    UI:Build("UICorner", {CornerRadius = UDim.new(1, 0)}, D)

    B.MouseButton1Click:Connect(function()
        Crystal.Config[var] = not Crystal.Config[var]
        UI:Tween(B, {BackgroundColor3 = Crystal.Config[var] and Crystal.Theme.MainBlue or Crystal.Theme.Off}, 0.2)
        UI:Tween(D, {Position = Crystal.Config[var] and UDim2.new(0, 18, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)}, 0.2)
    end)
end

AddToggle("Auto Popcorn", UDim2.new(0, 10, 0, 55), "P", "AutoPop")
AddToggle("Connect Four", UDim2.new(0, 195, 0, 55), "C", "ConnectFour")

local SArea = UI:Build("Frame", {Size = UDim2.new(1, 0, 0, 75), Position = UDim2.new(0, 0, 1, -75), BackgroundColor3 = Crystal.Theme.Gray}, Main)
UI:Build("UICorner", {CornerRadius = UDim.new(0, 18)}, SArea)
UI:Build("Frame", {Size = UDim2.new(1, 0, 0, 15), BackgroundColor3 = Crystal.Theme.Gray, BorderSizePixel = 0}, SArea)

local SLbl = UI:Build("TextLabel", {
    Size = UDim2.new(1, 0, 0, 20), Position = UDim2.new(0, 0, 0, 12), Text = "Accuracy - 7",
    BackgroundTransparency = 1, TextColor3 = Crystal.Theme.White, Font = Crystal.Theme.Font, TextSize = Crystal.Theme.Size
}, SArea)

local SBar = UI:Build("Frame", {Size = UDim2.new(0, 240, 0, 6), Position = UDim2.new(0.5, -120, 0, 48), BackgroundColor3 = Crystal.Theme.Slider}, SArea)
UI:Build("UICorner", {CornerRadius = UDim.new(1, 0)}, SBar)
local SFill = UI:Build("Frame", {Size = UDim2.new(0.7, 0, 1, 0), BackgroundColor3 = Crystal.Theme.MainBlue}, SBar)
UI:Build("UICorner", {CornerRadius = UDim.new(1, 0)}, SFill)

local function Arrow(t, p, s)
    local b = UI:Build("TextButton", {
        Size = UDim2.new(0, 28, 0, 28), Position = p, BackgroundColor3 = Crystal.Theme.MainBlue,
        Text = t, TextColor3 = Crystal.Theme.White, Font = Crystal.Theme.Font, TextSize = 14, AutoButtonColor = false
    }, SArea)
    UI:Build("UICorner", {CornerRadius = UDim.new(1, 0)}, b)
    b.MouseButton1Click:Connect(function()
        Crystal.Config.Accuracy = math.clamp(Crystal.Config.Accuracy + s, 0, 10)
        SLbl.Text = "Accuracy - " .. Crystal.Config.Accuracy
        UI:Tween(SFill, {Size = UDim2.new(Crystal.Config.Accuracy/10, 0, 1, 0)}, 0.3)
    end)
end
Arrow("<", UDim2.new(0, 33, 0, 37), -1)
Arrow(">", UDim2.new(1, -61, 0, 37), 1)

OpenBtn.MouseButton1Click:Connect(function() ToggleUI(true) end)
CloseBtn.MouseButton1Click:Connect(function() ToggleUI(false) end)

local dT, dS, sP
OpenBtn.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dT, dS, sP = true, i.Position, OpenBtn.Position end end)
UIS.InputChanged:Connect(function(i) if dT and i.UserInputType == Enum.UserInputType.MouseMovement then
    local d = i.Position - dS
    UI:Tween(OpenBtn, {Position = UDim2.new(sP.X.Scale, sP.X.Offset + d.X, sP.Y.Scale, sP.Y.Offset + d.Y)}, 0.08)
end end)
UIS.InputEnded:Connect(function() dT = false end)

task.spawn(function()
    local Act = RS:WaitForChild("Shared"):WaitForChild("Remotes"):WaitForChild("Networking"):WaitForChild("RE/Minigame/MinigameGameAction")
    while task.wait() do
        if Crystal.Config.AutoPop then
            for i = 1, Crystal.Config.Accuracy do
                task.spawn(function() Act:FireServer("AttemptPop", tick() + math.random()) end)
            end
            task.wait(math.clamp(0.14 - (Crystal.Config.Accuracy * 0.01), 0.06, 0.14))
        end
        if Crystal.Config.ConnectFour then
            for _, c in ipairs({4, 3, 5, 2, 6, 1, 7}) do
                if not Crystal.Config.ConnectFour then break end
                Act:FireServer("PlaceDisc", c)
                task.wait(0.06)
            end
            task.wait(0.5)
        end
    end
end)
