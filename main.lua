local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")

-- UI for Mobile (To see results without Console)
local Screen = Instance.new("ScreenGui", CoreGui)
Screen.Name = "CrystalDecoder"

local LogFrame = Instance.new("ScrollingFrame", Screen)
LogFrame.Size = UDim2.new(0.5, 0, 0.4, 0)
LogFrame.Position = UDim2.new(0.25, 0, 0.05, 0)
LogFrame.BackgroundColor3 = Color3.new(0, 0, 0)
LogFrame.BackgroundTransparency = 0.5
LogFrame.CanvasSize = UDim2.new(0, 0, 10, 0)

local UIList = Instance.new("UIListLayout", LogFrame)
UIList.SortOrder = Enum.SortOrder.LayoutOrder

local function Log(text)
    local l = Instance.new("TextLabel", LogFrame)
    l.Size = UDim2.new(1, 0, 0, 20)
    l.Text = " > " .. text
    l.TextColor3 = Color3.new(0, 1, 0)
    l.BackgroundTransparency = 1
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.TextScaled = true
    LogFrame.CanvasPosition = Vector2.new(0, 9999)
end

-- Decoding & Hooking Logic
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if (method == "FireServer" or method == "InvokeServer") then
        local remoteName = tostring(self.Name)
        
        -- Bypass Filters: Look for anything related to games/popcorn/wins
        -- This captures the "Raw" data before the server sees it
        if not string.find(remoteName:lower(), "move") and not string.find(remoteName:lower(), "chat") then
            
            Log("DETECTED: " .. remoteName)
            
            for i, arg in ipairs(args) do
                local argType = typeof(arg)
                local data = tostring(arg)
                
                if argType == "Instance" then
                    data = arg:GetFullName()
                elseif argType == "table" then
                    data = "{Table Data Content}" -- Can't easily stringify tables on mobile
                end
                
                Log("  Arg["..i.."]: " .. data .. " ("..argType..")")
            end
        end
    end
    return oldNamecall(self, ...)
end)

Log("CRYSTAL DECODER ACTIVE")
Log("Run Mystrix and click Popcorn now...")
