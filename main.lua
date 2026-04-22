local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- إنشاء النافذة
local Window = Rayfield:CreateWindow({
   Name = "Nova Hub | Calculating...",
   LoadingTitle = "Nova Hub Premium",
   LoadingSubtitle = "by BodyAlaa",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "NovaData"
   },
   Theme = "Ocean",
})

-- [[ وظيفة تحديث الـ FPS والـ Ping في الوقت الفعلي ]]
task.spawn(function()
    local RunService = game:GetService("RunService")
    local Stats = game:GetService("Stats")
    
    while task.wait(0.5) do -- يتحدث مرتين في الثانية ليكون دقيقاً جداً
        local fps = math.floor(1 / RunService.RenderStepped:Wait())
        local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        
        -- تحديث العنوان فوراً
        Window:SetTitle("Nova Hub | " .. fps .. " FPS | " .. ping .. " ms")
    end
end)

-- [[ 1. قسم Combat ]]
local CombatTab = Window:CreateTab("Combat", 4483345998)

CombatTab:CreateToggle({
   Name = "Bat Aimbot",
   CurrentValue = false,
   Callback = function(Value) _G.Aimbot = Value end,
})

CombatTab:CreateToggle({
   Name = "Auto Steal Nearest",
   CurrentValue = false,
   Callback = function(Value) _G.AutoSteal = Value end,
})

CombatTab:CreateToggle({
   Name = "Auto Play",
   CurrentValue = false,
   Callback = function(Value) _G.AutoPlay = Value end,
})

-- [[ 2. قسم Player ]]
local PlayerTab = Window:CreateTab("Player", 4483345998)

PlayerTab:CreateSection("Speed Customizer")

PlayerTab:CreateSlider({
   Name = "Going Speed",
   Range = {16, 500},
   Increment = 1,
   CurrentValue = 59,
   Callback = function(v) game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v end,
})

PlayerTab:CreateSlider({
   Name = "Return Speed",
   Range = {16, 500},
   Increment = 1,
   CurrentValue = 30,
   Callback = function(v) _G.ReturnSpeed = v end,
})

PlayerTab:CreateSlider({
   Name = "Jump Power",
   Range = {50, 500},
   Increment = 1,
   CurrentValue = 60,
   Callback = function(v) game.Players.LocalPlayer.Character.Humanoid.JumpPower = v end,
})

-- [[ 3. قسم Settings ]]
local SettingsTab = Window:CreateTab("Settings", 4483345998)

SettingsTab:CreateSlider({
   Name = "Medusa Radius",
   Range = {0, 100},
   Increment = 1,
   CurrentValue = 18,
   Callback = function(v) _G.Radius = v end,
})

-- [[ نظام الحركة والضرب الخلفي ]]
local TS = game:GetService("TweenService")
local lp = game.Players.LocalPlayer

task.spawn(function()
    while task.wait() do
        if _G.Aimbot then
            local target = nil
            local dist = math.huge
            for _, v in pairs(game.Players:GetPlayers()) do
                if v ~= lp and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    local d = (v.Character.HumanoidRootPart.Position - lp.Character.HumanoidRootPart.Position).Magnitude
                    if d < dist then dist = d; target = v end
                end
            end
            
            if target then
                local followPos = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                TS:Create(lp.Character.HumanoidRootPart, TweenInfo.new(0.1, Enum.EasingStyle.Linear), {CFrame = followPos}):Play()
                
                local tool = lp.Character:FindFirstChildOfClass("Tool") or lp.Backpack:FindFirstChildOfClass("Tool")
                if tool then
                    lp.Character.Humanoid:EquipTool(tool)
                    tool:Activate()
                end
            end
        end
    end
end)

Rayfield:LoadConfiguration()
            end
        end
    end
end)

Rayfield:LoadConfiguration()
