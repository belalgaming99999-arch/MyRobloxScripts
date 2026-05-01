-- Crystal Mobile Spy (Ultra-Light Edition)
-- This version will NOT interfere with your touch or game UI

local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    -- نظام الفلترة الذكي عشان ميعملش Lag للموبايل
    if (method == "FireServer" or method == "InvokeServer") and not checkcaller() then
        local name = self.Name:lower()
        
        -- تجاهل كل الحاجات اللي بتقل اللمس (الحركة، الكاميرا، نبضات القلب)
        local ignore = {"move", "cam", "step", "heartbeat", "ping", "unit", "look"}
        local isJunk = false
        for _, word in ipairs(ignore) do
            if name:find(word) then isJunk = true break end
        end
        
        if not isJunk then
            -- طباعة البيانات في الـ Log فقط (عشان ميعطلش اللمس بشاشات زيادة)
            print("\n[🎯 DETECTED]: " .. self.Name)
            if args[1] then
                print(" > Arg[1]: " .. tostring(args[1]))
            end
        end
    end
    
    return oldNamecall(self, ...)
end)

-- كود إضافي لضمان إن اللمس شغال (Bypass Gui Priority)
game:GetService("UserInputService").ModalEnabled = false

print("✅ Spy Active! Touch is 100% Natural.")
print("Open your Executor Log/Console to see the data.")
