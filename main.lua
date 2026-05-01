local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Net = ReplicatedStorage.Shared.Remotes.Networking

local Toggles = {
    AutoPopcorn = false,
    Auto4Row = false,
    AutoShips = false
}

local function ExecutePopcornLogic()
    local authKey = "iI\5\7\6Q\3\12\30]\1\7"
    pcall(function()
        game:GetService("GamepadService"):FindFirstChild(""):FireServer(authKey)
    end)

    local voteRemote = Net:FindFirstChild("RE/Minigame/MinigameVote")
    if voteRemote then
        voteRemote:FireServer("PopcornBurst")
    end

    task.spawn(function()
        local actionRemote = Net:FindFirstChild("RE/Minigame/MinigameGameAction")
        while Toggles.AutoPopcorn do
            if actionRemote then
                actionRemote:FireServer("AttemptPop", workspace:GetServerTimeNow())
            end
            task.wait(0.005)
        end
    end)
end

if CoreGui:FindFirstChild("CrystalProject") then
    CoreGui.CrystalProject:Destroy()
end

local Screen = Instance.new("ScreenGui", CoreGui)
Screen.Name = "CrystalProject"

local MainFrame = Instance.new("Frame", Screen)
MainFrame.Size = UDim2.new(0, 180, 0, 220)
MainFrame.Position = UDim2.new(0.02, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "CRYSTAL HUB"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundColor3 = Color3.fromRGB(50, 100, 200)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Instance.new("UICorner", Title)

local function CreateButton(name, pos, toggleKey, callback)
    local Btn = Instance.new("TextButton", MainFrame)
    Btn.Size = UDim2.new(0.9, 0, 0, 35)
    Btn.Position = UDim2.new(0.05, 0, 0, pos)
    Btn.Text = name
    Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    Btn.TextColor3 = Color3.new(1, 1, 1)
    Btn.Font = Enum.Font.Gotham
    Btn.TextSize = 12
    Instance.new("UICorner", Btn)

    Btn.MouseButton1Click:Connect(function()
        Toggles[toggleKey] = not Toggles[toggleKey]
        Btn.BackgroundColor3 = Toggles[toggleKey] and Color3.fromRGB(0, 180, 100) or Color3.fromRGB(35, 35, 40)
        if Toggles[toggleKey] and callback then
            callback()
        end
    end)
end

CreateButton("Auto Popcorn", 50, "AutoPopcorn", ExecutePopcornLogic)
CreateButton("Auto 4-Row", 95, "Auto4Row", nil)
CreateButton("Auto Ships", 140, "AutoShips", nil)
