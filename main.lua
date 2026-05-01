local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- تنظيف النسخ القديمة
local function CleanUI()
    for _, child in ipairs(CoreGui:GetChildren()) do
        if child.Name == "CrystalMobileSpy" then
            child:Destroy()
        end
    end
end
CleanUI()

-- إنشاء الواجهة
local Screen = Instance.new("ScreenGui", CoreGui)
Screen.Name = "CrystalMobileSpy"

local MainFrame = Instance.new("Frame", Screen)
MainFrame.Size = UDim2.new(0, 220, 0, 250)
MainFrame.Position = UDim2.new(0.5, -110, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- تفعيل السحب للموبايل
Instance.new("UICorner", MainFrame)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "Crystal Spy (Draggable)"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundColor3 = Color3.fromRGB(45, 85, 160)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Instance.new("UICorner", Title)

local LogFrame = Instance.new("ScrollingFrame", MainFrame)
LogFrame.Size = UDim2.new(0.9, 0, 0.75, 0)
LogFrame.Position = UDim2.new(0.05, 0, 0.18, 0)
LogFrame.BackgroundTransparency = 1
LogFrame.CanvasSize = UDim2.new(0, 0, 20, 0)
LogFrame.ScrollBarThickness = 2

local UIList = Instance.new("UIListLayout", LogFrame)
UIList.SortOrder = Enum.SortOrder.LayoutOrder

local function Log(text)
    local l = Instance.new("TextLabel", LogFrame)
    l.Size = UDim2.new(1, 0, 0, 25)
    l.Text = " > " .. text
    l.TextColor3 = Color3.fromRGB(0, 255, 150)
    l.BackgroundTransparency = 1
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Font = Enum.Font.Code
    l.TextSize = 12
    l.TextWrapped = true
    LogFrame.CanvasPosition = Vector2.new(0, 99999)
end

-- كود صيد التفعيلات بدون تهنيج
local old
old = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if (method == "FireServer" or method == "InvokeServer") then
        local name = self.Name
        local nLower = name:lower()
        
        -- فلتر لتنظيف الزحمة (تجاهل الحركة والكاميرا)
        if not nLower:find("move") and not nLower:find("cam") and not nLower:find("ping") then
            Log("Remote: " .. name)
            -- عرض أول argument لأنه غالباً بيكون فيه اسم الطبق أو القيمة
            if args[1] then
                Log("  Arg[1]: " .. tostring(args[1]))
            end
        end
    end
    return old(self, ...)
end)

Log("Ready! Drag window from Title.")
