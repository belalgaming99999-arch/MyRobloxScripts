local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local UnderLine = Instance.new("Frame")
local EspBtn = Instance.new("TextButton")
local PopBtn = Instance.new("TextButton")
local MenuButton = Instance.new("TextButton")

ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

MenuButton.Name = "CrystalMenuBtn"
MenuButton.Parent = ScreenGui
MenuButton.Size = UDim2.new(0, 55, 0, 55)
MenuButton.Position = UDim2.new(0.05, 0, 0.15, 0)
MenuButton.BackgroundColor3 = Color3.fromRGB(45, 85, 160)
MenuButton.BorderSizePixel = 0
Instance.new("UICorner", MenuButton).CornerRadius = UDim.new(0, 14)

for i = -1, 1 do
    local line = Instance.new("Frame")
    line.Parent = MenuButton
    line.Size = UDim2.new(0, 28, 0, 4)
    line.Position = UDim2.new(0.5, -14, 0.5, i * 9)
    line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
end

MainFrame.Name = "CrystalHub"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 30, 45)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Visible = false
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame.Position = MenuButton.Position
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "Crystal Hub"
Title.TextColor3 = Color3.fromRGB(45, 85, 160)
Title.BackgroundTransparency = 1
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold

UnderLine.Parent = MainFrame
UnderLine.BackgroundColor3 = Color3.fromRGB(45, 85, 160)
UnderLine.Position = UDim2.new(0.5, -45, 0, 36)
UnderLine.Size = UDim2.new(0, 90, 0, 2)

EspBtn.Name = "EspBombBtn"
EspBtn.Parent = MainFrame
EspBtn.Position = UDim2.new(0.1, 0, 0.35, 0)
EspBtn.Size = UDim2.new(0.8, 0, 0, 40)
EspBtn.BackgroundColor3 = Color3.fromRGB(140, 50, 50)
EspBtn.Text = "Esp Bomb Disable"
EspBtn.TextColor3 = Color3.fromRGB(240, 240, 240)
EspBtn.Font = Enum.Font.GothamBold
EspBtn.TextSize = 14
Instance.new("UICorner", EspBtn).CornerRadius = UDim.new(0, 10)

PopBtn.Name = "AutoPopBtn"
PopBtn.Parent = MainFrame
PopBtn.Position = UDim2.new(0.1, 0, 0.55, 0)
PopBtn.Size = UDim2.new(0.8, 0, 0, 40)
PopBtn.BackgroundColor3 = Color3.fromRGB(140, 50, 50)
PopBtn.Text = "Auto Pop Disable"
PopBtn.TextColor3 = Color3.fromRGB(240, 240, 240)
PopBtn.Font = Enum.Font.GothamBold
PopBtn.TextSize = 14
Instance.new("UICorner", PopBtn).CornerRadius = UDim.new(0, 10)

MenuButton.MouseButton1Click:Connect(function()
    if not MainFrame.Visible then
        MainFrame.Visible = true
        MainFrame:TweenSizeAndPosition(UDim2.new(0, 190, 0, 200), UDim2.new(MenuButton.Position.X.Scale, MenuButton.Position.X.Offset, MenuButton.Position.Y.Scale, MenuButton.Position.Y.Offset + 65), "Out", "Back", 0.3)
    else
        MainFrame:TweenSizeAndPosition(UDim2.new(0, 0, 0, 0), MenuButton.Position, "In", "Back", 0.2, true, function() MainFrame.Visible = false end)
    end
end)

task.spawn(function()
    local lastBombScan = 0
    local espActive = false
    local activeFrames = {}
    
    EspBtn.MouseButton1Click:Connect(function()
        espActive = not espActive
        EspBtn.Text = espActive and "Esp Bomb Active" or "Esp Bomb Disable"
        EspBtn.BackgroundColor3 = espActive and Color3.fromRGB(50, 120, 80) or Color3.fromRGB(140, 50, 50)
        if not espActive then
            for _, frame in pairs(activeFrames) do
                if frame and frame.Parent then frame:Destroy() end
            end
            activeFrames = {}
        end
    end)
    
    game:GetService("RunService").Heartbeat:Connect(function()
        if not espActive then return end
        if tick() - lastBombScan < 0.1 then return end
        lastBombScan = tick()
        
        for _, frame in pairs(activeFrames) do
            if frame and frame.Parent then frame:Destroy() end
        end
        activeFrames = {}
        
        for _, model in pairs(workspace:GetDescendants()) do
            if model:IsA("Model") and model.Name == "Candy Bomb" then
                for _, part in pairs(model:GetDescendants()) do
                    if part:IsA("BasePart") then
                        local color = part.Color
                        local isBomb = false
                        
                        if part.Name:lower():find("bomb") then
                            isBomb = true
                        end
                        if color.R > 0.6 and color.G < 0.3 and color.B < 0.3 then
                            isBomb = true
                        end
                        if part:FindFirstChildWhichIsA("Texture") and part.Texture:find("bomb") then
                            isBomb = true
                        end
                        if part:FindFirstChildWhichIsA("Decal") and part.Decal:find("bomb") then
                            isBomb = true
                        end
                        
                        if isBomb and part.Size.Magnitude < 10 then
                            local billboard = Instance.new("BillboardGui")
                            billboard.Name = "BombFrame"
                            billboard.AlwaysOnTop = true
                            billboard.Size = UDim2.new(0, part.Size.X * 1.2, 0, part.Size.Y * 1.2)
                            billboard.StudsOffset = Vector3.new(0, 0.5, 0)
                            billboard.MaxDistance = 100
                            billboard.Parent = part
                            
                            local frame = Instance.new("Frame")
                            frame.Size = UDim2.new(1, 0, 1, 0)
                            frame.BackgroundTransparency = 0.6
                            frame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                            frame.BorderSizePixel = 3
                            frame.BorderColor3 = Color3.fromRGB(255, 255, 255)
                            frame.Parent = billboard
                            
                            local stroke = Instance.new("UIStroke")
                            stroke.Color = Color3.fromRGB(255, 255, 255)
                            stroke.Thickness = 3
                            stroke.Parent = frame
                            
                            Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 0.1)
                            
                            table.insert(activeFrames, billboard)
                        end
                    end
                end
            end
        end
    end)
end)

task.spawn(function()
    local lastPopScan = 0
    local popActive = false
    
    local function getPopcornValue(part)
        for _, child in pairs(part:GetChildren()) do
            if child:IsA("BillboardGui") or child:IsA("SurfaceGui") then
                for _, element in pairs(child:GetDescendants()) do
                    if element:IsA("TextLabel") and element.Text then
                        local num = tonumber(element.Text:match("%d+"))
                        if num then return num end
                    end
                end
            end
        end
        local num = tonumber(part.Name:match("%d+"))
        return num or 0
    end
    
    PopBtn.MouseButton1Click:Connect(function()
        popActive = not popActive
        PopBtn.Text = popActive and "Auto Pop Active" or "Auto Pop Disable"
        PopBtn.BackgroundColor3 = popActive and Color3.fromRGB(50, 120, 80) or Color3.fromRGB(140, 50, 50)
    end)
    
    game:GetService("RunService").Heartbeat:Connect(function()
        if not popActive then return end
        if tick() - lastPopScan < 0.1 then return end
        lastPopScan = tick()
        
        local bestPart = nil
        local bestValue = 0
        
        for _, model in pairs(workspace:GetDescendants()) do
            if model:IsA("Model") and model.Name == "Popcorn Burst" then
                for _, part in pairs(model:GetDescendants()) do
                    if part:IsA("BasePart") and part.Transparency < 0.5 and part.Size.Magnitude > 0.3 then
                        local value = getPopcornValue(part)
                        if value > bestValue then
                            bestValue = value
                            bestPart = part
                        end
                    end
                end
            end
        end
        
        if bestPart then
            local character = LocalPlayer.Character
            if character then
                local hrp = character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    firetouchinterest(hrp, bestPart, 0)
                    firetouchinterest(hrp, bestPart, 1)
                end
            end
        end
    end)
end)
