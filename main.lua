-- Toàn bộ code đã sửa lỗi link Orion Library
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/jensonhirst/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "Wraithh Hub", HidePremium = false, SaveConfig = true, ConfigFolder = "OrionTest"})

-- Variables
local autotap = false
local autojem = false
local autoreb = false
local autolucky = false
local autohat = false
local selectedegg = nil
local selectedjem = nil
local selectedreb = nil
local selectedlucky = nil
local rebirthamount = 0

-- Functions
function tap()
    while autotap do
        local args = { [1] = "Tap" }
        game:GetService("ReplicatedStorage").Events.Tap:FireServer(unpack(args))
        task.wait()
    end
end

function jem()
    while autojem do
        local args = { [1] = selectedjem }
        game:GetService("ReplicatedStorage").Events.ClaimChest:FireServer(unpack(args))
        task.wait()
    end
end

function reb()
    while autoreb do
        local args = { [1] = selectedreb }
        game:GetService("ReplicatedStorage").Events.Rebirth:FireServer(unpack(args))
        task.wait()
    end
end

function lucky()
    while autolucky do
        local args = { [1] = selectedlucky }
        game:GetService("ReplicatedStorage").Events.LuckyBlock:FireServer(unpack(args))
        task.wait()
    end
end

function hat()
    while autohat do
        local args = { [1] = selectedegg }
        game:GetService("ReplicatedStorage").Events.OpenEgg:FireServer(unpack(args))
        task.wait()
    end
end

-- Tabs
local FarmTab = Window:MakeTab({
    Name = "Auto Farm",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local EggTab = Window:MakeTab({
    Name = "Auto Eggs",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local MiscTab = Window:MakeTab({
    Name = "Misc",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- UI Elements: Farm Tab
FarmTab:AddToggle({
    Name = "Auto Tap",
    Default = false,
    Callback = function(Value)
        autotap = Value
        tap()
    end
})

FarmTab:AddDropdown({
    Name = "Select Chest",
    Default = "None",
    Options = {"Jem Chest", "Gold Chest", "Diamond Chest"},
    Callback = function(Value)
        selectedjem = Value
    end
})

FarmTab:AddToggle({
    Name = "Auto Chest",
    Default = false,
    Callback = function(Value)
        autojem = Value
        jem()
    end
})

FarmTab:AddDropdown({
    Name = "Select Rebirth",
    Default = "None",
    Options = {"1 Rebirth", "5 Rebirths", "10 Rebirths", "50 Rebirths", "100 Rebirths"},
    Callback = function(Value)
        selectedreb = Value
    end
})

FarmTab:AddToggle({
    Name = "Auto Rebirth",
    Default = false,
    Callback = function(Value)
        autoreb = Value
        reb()
    end
})

-- UI Elements: Egg Tab
EggTab:AddDropdown({
    Name = "Select Egg",
    Default = "None",
    Options = {"Common Egg", "Uncommon Egg", "Rare Egg", "Epic Egg", "Legendary Egg"},
    Callback = function(Value)
        selectedegg = Value
    end
})

EggTab:AddToggle({
    Name = "Auto Open Egg",
    Default = false,
    Callback = function(Value)
        autohat = Value
        hat()
    end
})

-- UI Elements: Misc Tab
MiscTab:AddDropdown({
    Name = "Select Lucky Block",
    Default = "None",
    Options = {"Lucky Block 1", "Lucky Block 2", "Lucky Block 3"},
    Callback = function(Value)
        selectedlucky = Value
    end
})

MiscTab:AddToggle({
    Name = "Auto Lucky Block",
    Default = false,
    Callback = function(Value)
        autolucky = Value
        lucky()
    end
})
