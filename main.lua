local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- [[ إنشاء نافذة Crystal Hub ]]
local Window = Rayfield:CreateWindow({
   Name = "Crystal Hub | Loading...",
   LoadingTitle = "Crystal Hub Premium",
   LoadingSubtitle = "by BodyAlaa",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "CrystalConfigs"
   },
   Theme = "Ocean",
})

-- [[ وظيفة تحديث الـ FPS والـ Ping الحقيقي بالتنسيق المطلوب ]]
task.spawn(function()
    local RunService = game:GetService("RunService")
    local Stats = game:GetService("Stats")
    
    while task.wait(0.5) do -- يتحدث مرتين في الثانية لضمان الدقة
        -- حساب الفريمات الحقيقية
        local fps = math.floor(1 / RunService.RenderStepped:Wait())
        -- حساب البنج الحقيقي
        local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        
        -- التنسيق اللي طلبته: الرقم وبعده الكلمة
        -- النتيجة هتكون مثلاً: 60 Fps | 45 Ms
        Window:SetTitle("Crystal Hub | " .. fps .. " Fps | " .. ping .. " Ms")
    end
end)

-- [[ الأقسام والأزرار (نفس الترتيب السابق) ]]
local CombatTab = Window:CreateTab("Combat", 4483345998)

CombatTab:CreateToggle({
   Name = "Bat Aimbot",
   CurrentValue = false,
   Callback = function(Value) _G.Aimbot = Value end,
})

local PlayerTab = Window:CreateTab("Player", 4483345998)
PlayerTab:CreateSection("Speed Customizer")

PlayerTab:CreateSlider({
   Name = "Going Speed",
   Range = {16, 500},
   Increment = 1,
   CurrentValue = 59,
   Callback = function(v) game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v end,
})

-- يمكنك إضافة بقية الأزرار هنا...
Rayfield:LoadConfiguration()
