-- سكربت استخراج أكواد ومسارات لعبة الفشار
local function ScanGame()
    print("--- Start Crystal Scanner ---")
    local foundCount = 0
    
    -- البحث في ReplicatedStorage (حيث توجد معظم ملفات الأوامر والريموتس)
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("ModuleScript") or v:IsA("RemoteEvent") then
            if v.Name:find("Popcorn") or v.Name:find("Minigame") or v.Name:find("Action") then
                print("Found Asset: " .. v.Name .. " | Path: " .. v:GetFullName())
                foundCount = foundCount + 1
                
                -- إذا كان ملف كود، سنحاول استخراج محتوياته (اختياري حسب الصلاحيات)
                if v:IsA("ModuleScript") then
                    warn("Analyze this Module for logic: " .. v.Name)
                end
            end
        end
    end
    
    if foundCount == 0 then
        print("No direct names found, scanning for Grid/Slot logic...")
        -- بحث بديل عن طريق بنية المربعات
        for _, v in pairs(workspace:GetDescendants()) do
            if v.Name == "Grid" or v.Name == "Slots" then
                warn("Game Grid Found at: " .. v:GetFullName())
            end
        end
    end
    print("--- Scan Complete: " .. foundCount .. " assets found ---")
end

ScanGame()
