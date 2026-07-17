-- // CONFIG SYSTEM RESET
local KeySystem = false -- Đã tắt Key System cho bạn

-- // MAIN SCRIPT (CONVERTED TO RAYFIELD UI FOR STABILITY)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "TinhSuper Hub | Aura Simulator",
   LoadingTitle = "TinhSuper Hub",
   LoadingSubtitle = "by tinhsuper_gm",
   ConfigurationSaving = {
      Enabled = false
   },
   Discord = {
      Enabled = false
   },
   KeySystem = false
})

-- // SERVICES & VARIABLES
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local Replicated = game:GetService("ReplicatedStorage")

local StartF = Replicated:WaitForChild("StartF")
local StopF = Replicated:WaitForChild("StopF")
local StartE = Replicated:WaitForChild("StartE")
local StopE = Replicated:WaitForChild("StopE")
local Reb = Replicated:WaitForChild("Reb")

local Leaderstats = LP:WaitForChild("leaderstats")
local AVal = Leaderstats:FindFirstChild("Aura")
local RVal = Leaderstats:FindFirstChild("Rebirths")
local EVal = LP:FindFirstChild("Energy", true)
local NRC = LP:FindFirstChild("NextRebirthCost", true)
local MEVal = LP:FindFirstChild("MaxEnergy", true)

-- // FLAGS FOR TOGGLES
local flags = {
    autoAura = false,
    autoEnergy = false,
    autoReb = false,
    rLock = false,
    rMax = false
}

-- // FARM TAB
local FarmTab = Window:CreateTab("Farm Tab", 4483362458) -- Main Icon

local StatsSection = FarmTab:CreateSection("Stats")
local AuraLabel = FarmTab:CreateLabel("Aura: 0")
local RebirthsLabel = FarmTab:CreateLabel("Rebirths: 0")
local EnergyLabel = FarmTab:CreateLabel("Energy: 0 / 0")
local RebirthCostLabel = FarmTab:CreateLabel("Next Rebirth Cost: 0")

local FarmSection = FarmTab:CreateSection("Auto Farm")

local ToggleAura = FarmTab:CreateToggle({
   Name = "Auto Farm Aura",
   CurrentValue = false,
   Flag = "Toggle1",
   Callback = function(v)
      flags.autoAura = v
      if v then StartF:FireServer() else StopF:FireServer() end
   end,
})

local ToggleEnergy = FarmTab:CreateToggle({
   Name = "Auto Farm Energy",
   CurrentValue = false,
   Flag = "Toggle2",
   Callback = function(v)
      flags.autoEnergy = v
      if v then StartE:FireServer() else StopE:FireServer() end
   end,
})

local ToggleReb = FarmTab:CreateToggle({
   Name = "Auto Rebirth",
   CurrentValue = false,
   Flag = "Toggle3",
   Callback = function(v)
      flags.autoReb = v
   end,
})

local ToggleLock = FarmTab:CreateToggle({
   Name = "Rebirth Lock",
   CurrentValue = false,
   Flag = "Toggle4",
   Callback = function(v)
      flags.rLock = v
   end,
})

local ToggleMax = FarmTab:CreateToggle({
   Name = "Rebirth At Max Energy",
   CurrentValue = false,
   Flag = "Toggle5",
   Callback = function(v)
      flags.rMax = v
   end,
})

-- // UTILS (FORMAT NUMBERS)
local function N(v) return tonumber(v) or 0 end
local function fmt(n)
    n = N(n)
    if n >= 1e15 then return string.format("%.2fQ", n/1e15) end
    if n >= 1e12 then return string.format("%.2fT", n/1e12) end
    if n >= 1e9 then return string.format("%.2fB", n/1e9) end
    if n >= 1e6 then return string.format("%.2fM", n/1e6) end
    if n >= 1e3 then return string.format("%.2fK", n/1e3) end
    return tostring(math.floor(n))
end

local function updE(v)
    local mx = MEVal and N(MEVal.Value) or 0
    EnergyLabel:Set("Energy: " .. fmt(v) .. " / " .. fmt(mx))
end

local function eval()
    if not flags.autoReb then return end
    local aura = N(AVal and AVal.Value or 0)
    local cost = N(NRC and NRC.Value or 0)
    local en = N(EVal and EVal.Value or 0)
    local mx = N(MEVal and MEVal.Value or 0)
    
    if flags.rLock then return end
    if aura < cost then return end
    
    if flags.rMax then
        if en >= mx then
            Reb:FireServer()
        end
    else
        Reb:FireServer()
    end
end

-- // LISTENERS (AUTO UPDATE UI)
EVal.Changed:Connect(function(v)
	updE(v)
	eval()
end)
AVal.Changed:Connect(function(v)
	AuraLabel:Set("Aura: " .. fmt(v))
	eval()
end)
NRC.Changed:Connect(function(v)
	RebirthCostLabel:Set("Next Rebirth Cost: " .. fmt(v))
	eval()
end)
if RVal then
	RVal.Changed:Connect(function(v)
		RebirthsLabel:Set("Rebirths: " .. tostring(math.floor(N(v))))
	end)
end
if MEVal then
	MEVal.Changed:Connect(function()
		updE(EVal.Value)
	end)
end

-- Initial display sync
AuraLabel:Set("Aura: " .. fmt(AVal.Value))
updE(EVal.Value)
RebirthCostLabel:Set("Next Rebirth Cost: " .. fmt(NRC.Value))
if RVal then RebirthsLabel:Set("Rebirths: " .. tostring(math.floor(N(RVal.Value)))) end
