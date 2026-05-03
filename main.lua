local Services = setmetatable({}, {
    __index = function(t, k) return game:GetService(k) end
})
local TS, UIS, CG, RS = Services.TweenService, Services.UserInputService, Services.CoreGui, Services.ReplicatedStorage

local Crystal = {
    ID = "C_" .. math.random(100, 999),
    Settings = {AutoPop = false, ConnectFour = false, Accuracy = 7},
    Theme = {
        MainBlue = Color3.fromRGB(0, 120, 255),
        DarkBg = Color3.fromRGB(10, 10, 10),
        GrayPanel = Color3.fromRGB(35, 35, 35),
        IconBg = Color3.fromRGB(15, 15, 15),
        ToggleOff = Color3.fromRGB(50, 50, 50),
        SliderBar = Color3.fromRGB(60, 60, 60),
        Text = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBold,
        FontSize = 12
    }
}

local UI = {}
function UI:Create(class, props)
    local inst = Instance.new(class)
    for k, v in pairs(props) do inst[k] = v end
    return inst
end

function UI:Animate(obj, info, goal)
    TS:Create(obj, TweenInfo.new(unpack(info)), goal):Play()
end

local Screen = UI:Create("ScreenGui", {Name = Crystal.ID, Parent = CG})

local Icon = UI:Create("TextButton", {
    Size = UDim2.new(0, 110, 0, 35), Position = UDim2.new(0.5, -55, 0.15, 0),
    BackgroundColor3 = Crystal.Theme.IconBg, Text = "Crystal Hub",
    TextColor3 = Crystal.Theme.Text, Font = Crystal.Theme.Font, TextSize = Crystal.Theme.FontSize,
    AutoButtonColor = false, Parent = Screen, ZIndex = 10
})
UI:Create("UICorner", {CornerRadius = UDim.new(0, 18), Parent = Icon})
UI:Create("UIStroke", {Color = Crystal.Theme.MainBlue, Thickness = 1.5, Parent = Icon})

local Main = UI:Create("CanvasGroup", {
    Size = UDim2.new(0, 380, 0, 190), BackgroundColor3 = Crystal.Theme.DarkBg,
    Visible = false, GroupTransparency = 1, Parent = Screen
})
UI:Create("UICorner", {CornerRadius = UDim.new(0, 18), Parent = Main})
local MStroke = UI:Create("UIStroke", {Color = Crystal.Theme.MainBlue, Thickness = 1.5, Transparency = 1, Parent = Main})

local Header = UI:Create("Frame", {Size = UDim2.new(1, 0, 0, 38), BackgroundColor3 = Crystal.Theme.GrayPanel, Parent = Main})
UI:Create("UICorner", {CornerRadius = UDim.new(0, 18), Parent = Header})
UI:Create("Frame", {Size = UDim2.new(1, 0, 0, 10), Position = UDim2.new(0, 0, 1, -10), BackgroundColor3 = Crystal.Theme.GrayPanel, BorderSizePixel = 0, Parent = Header})

local Title = UI:Create("TextLabel", {
    Size = UDim2.new(1, 0, 0, 38), Text = "Crystal Hub - Mini Games", BackgroundTransparency = 1,
    TextColor3 = Crystal.Theme.Text, Font = Crystal.Theme.Font, TextSize = Crystal.Theme.FontSize, Parent = Main, ZIndex = 3
})

local Close = UI:Create("TextButton", {
    Size = UDim2.new(0, 35, 0, 38), Position = UDim2.new(1, -38, 0, 0), Text = "X",
    BackgroundTransparency = 1, TextColor3 = Crystal.Theme.Text, Font = Crystal.Theme.Font,
    TextSize = Crystal.Theme.FontSize, AutoButtonColor = false, Parent = Main, ZIndex = 3
})

local function NewToggle(name, pos, icon, var)
    local F = UI:Create("Frame", {Size = UDim2.new(0, 175, 0, 42), Position = pos, BackgroundColor3 = Crystal.Theme.GrayPanel, Parent = Main})
    UI:Create("UICorner", {CornerRadius = UDim.new(0, 18), Parent = F})
    
    local I = UI:Create("TextLabel", {
        Size = UDim2.new(0, 28, 0, 28), Position = UDim2.new(0, 8, 0.5, -14), BackgroundColor3 = Crystal.Theme.MainBlue,
        Text = icon, TextColor3 = Crystal.Theme.Text, Font = Crystal.Theme.Font, TextSize = Crystal.Theme.FontSize, Parent = F
    })
    UI:Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = I})
    
    local L = UI:Create("TextLabel", {
        Size = UDim2.new(0, 85, 1, 0), Position = UDim2.new(0, 44, 0, 0), Text = name, BackgroundTransparency = 1,
        TextColor3 = Crystal.Theme.Text, Font = Crystal.Theme.Font, TextSize = 11, TextXAlignment = "Left", Parent = F
    })

    local B = UI:Create("TextButton", {
        Size = UDim2.new(0, 32, 0, 16), Position = UDim2.new(1, -40, 0.5, -8), BackgroundColor3 = Crystal.Theme.ToggleOff,
        Text = "", AutoButtonColor = false, Parent = F
    })
    UI:Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = B})
    
    local D = UI:Create("Frame", {Size = UDim2.new(0, 12, 0, 12), Position = UDim2.new(0, 2, 0.5, -6), BackgroundColor3 = Crystal.Theme.Text, Parent = B})
    UI:Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = D})

    B.MouseButton1Click:Connect(function()
        Crystal.Settings[var] = not Crystal.Settings[var]
        UI:Animate(B, {0.25, Enum.EasingStyle.Quart}, {BackgroundColor3 = Crystal.Settings[var] and Crystal.Theme.MainBlue or Crystal.Theme.ToggleOff})
        UI:Animate(D, {0.25, Enum.EasingStyle.Back}, {Position = Crystal.Settings[var] and UDim2.new(0, 18, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)})
    end)
end

NewToggle("Auto Popcorn", UDim2.new(0, 10, 0, 55), "P", "AutoPop")
NewToggle("Connect Four", UDim2.new(0, 195, 0, 55), "C", "ConnectFour")

local SArea = UI:Create("Frame", {Size = UDim2.new(1, 0, 0, 75), Position = UDim2.new(0, 0, 1, -75), BackgroundColor3 = Crystal.Theme.GrayPanel, Parent = Main})
UI:Create("UICorner", {CornerRadius = UDim.new(0, 18), Parent = SArea})
UI:Create("Frame", {Size = UDim2.new(1, 0, 0, 10), BackgroundColor3 = Crystal.Theme.GrayPanel, BorderSizePixel = 0, Parent = SArea})

local SLbl = UI:Create("TextLabel", {
    Size = UDim2.new(1, 0, 0, 20), Position = UDim2.new(0, 0, 0, 12), Text = "Accuracy - 7",
    BackgroundTransparency = 1, TextColor3 = Crystal.Theme.Text, Font = Crystal.Theme.Font, TextSize = Crystal.Theme.FontSize, Parent = SArea
})

local SFill = UI:Create("Frame", {
    Size = UDim2.new(0.7, 0, 1, 0), BackgroundColor3 = Crystal.Theme.MainBlue, 
    Parent = UI:Create("Frame", {Size = UDim2.new(0, 240, 0, 6), Position = UDim2.new(0.5, -120, 0, 48), BackgroundColor3 = Crystal.Theme.SliderBar, Parent = SArea})
})
UI:Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = SFill.Parent})
UI:Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = SFill})

local function Arrow(t, p, s)
    local b = UI:Create("TextButton", {
        Size = UDim2.new(0, 28, 0, 28), Position = p, BackgroundColor3 = Crystal.Theme.MainBlue,
        Text = t, TextColor3 = Crystal.Theme.Text, Font = Crystal.Theme.Font, TextSize = 14,
        AutoButtonColor = false, Parent = SArea
    })
    UI:Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = b})
    b.MouseButton1Click:Connect(function()
        Crystal.Settings.Accuracy = math.clamp(Crystal.Settings.Accuracy + s, 1, 10)
        SLbl.Text = "Accuracy - " .. Crystal.Settings.Accuracy
        UI:Animate(SFill, {0.4, Enum.EasingStyle.Quart}, {Size = UDim2.new(Crystal.Settings.Accuracy/10, 0, 1, 0)})
    end)
end
Arrow("<", UDim2.new(0, 33, 0, 37), -1)
Arrow(">", UDim2.new(1, -61, 0, 37), 1)

local function View(state)
    local t = {0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out}
    if state then
        Main.Position = UDim2.new(Icon.Position.X.Scale, Icon.Position.X.Offset - 135, Icon.Position.Y.Scale, Icon.Position.Y.Offset + 48)
        Icon.Visible = false; Main.Visible = true
        UI:Animate(Main, t, {GroupTransparency = 0, Size = UDim2.new(0, 380, 0, 190)})
        UI:Animate(MStroke, t, {Transparency = 0})
    else
        UI:Animate(MStroke, t, {Transparency = 1})
        local h = TS:Create(Main, TweenInfo.new(0.4), {GroupTransparency = 1, Size = UDim2.new(0, 360, 0, 170)})
        h:Play(); h.Completed:Connect(function() Main.Visible = false; Icon.Visible = true end)
    end
end

Icon.MouseButton1Click:Connect(function() View(true) end)
Close.MouseButton1Click:Connect(function() View(false) end)

local dT, dS, sP
Icon.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dT, dS, sP = true, i.Position, Icon.Position end end)
UIS.InputChanged:Connect(function(i) if dT and i.UserInputType == Enum.UserInputType.MouseMovement then
    local d = i.Position - dS
    Icon.Position = UDim2.new(sP.X.Scale, sP.X.Offset + d.X, sP.Y.Scale, sP.Y.Offset + d.Y)
end end)
UIS.InputEnded:Connect(function() dT = false end)

task.spawn(function()
    local Net = RS:WaitForChild("Shared"):WaitForChild("Remotes"):WaitForChild("Networking")
    local Act = Net:WaitForChild("RE/Minigame/MinigameGameAction")
    while task.wait() do
        if Crystal.Settings.AutoPop then
            for i = 1, Crystal.Settings.Accuracy do
                task.spawn(function() Act:FireServer("AttemptPop", tick() + math.random()) end)
            end
            task.wait(math.clamp(0.14 - (Crystal.Settings.Accuracy * 0.01), 0.06, 0.14))
        end
        if Crystal.Settings.ConnectFour then
            for _, c in ipairs({4, 3, 5, 2, 6, 1, 7}) do
                if not Crystal.Settings.ConnectFour then break end
                Act:FireServer("PlaceDisc", c)
                task.wait(0.06)
            end
            task.wait(0.5)
        end
    end
end)

