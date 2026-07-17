-- // SIMPLE ONE-TIME KEY SYSTEM
local KeySystem = false
local Link = "https://link-center.net/4897030/PafiPJSQbAjr"
local Password = "thanks123aura"

if KeySystem then
    local Players = game:GetService("Players")
    local LP = Players.LocalPlayer
    local StarterGui = game:GetService("StarterGui")
    
    local Correct = false
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = LP:WaitForChild("PlayerGui")
    
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 380, 0, 220)
    Frame.Position = UDim2.new(0.5, -190, 0.5, -110)
    Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Frame.BorderSizePixel = 0
    Frame.Parent = ScreenGui
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 50)
    Title.BackgroundTransparency = 1
    Title.Text = "Wraithh Farm Key System"
    Title.TextColor3 = Color3.fromRGB(255, 80, 80)
    Title.TextScaled = true
    Title.Font = Enum.Font.GothamBold
    Title.Parent = Frame
    
    local Desc = Instance.new("TextLabel")
    Desc.Size = UDim2.new(1, 0, 0, 40)
    Desc.Position = UDim2.new(0, 0, 0, 50)
    Desc.BackgroundTransparency = 1
    Desc.Text = "Complete the link then paste the password"
    Desc.TextColor3 = Color3.fromRGB(200, 200, 200)
    Desc.TextScaled = true
    Desc.Font = Enum.Font.Gotham
    Desc.Parent = Frame
    
    local Input = Instance.new("TextBox")
    Input.Size = UDim2.new(0.9, 0, 0, 45)
    Input.Position = UDim2.new(0.05, 0, 0.45, 0)
    Input.PlaceholderText = "Paste Password Here"
    Input.Text = ""
    Input.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Input.TextColor3 = Color3.new(1,1,1)
    Input.TextScaled = true
    Input.Font = Enum.Font.Gotham
    Input.BorderSizePixel = 0
    Input.Parent = Frame
    
    local Submit = Instance.new("TextButton")
    Submit.Size = UDim2.new(0.45, 0, 0, 40)
    Submit.Position = UDim2.new(0.05, 0, 0.75, 0)
    Submit.BackgroundColor3 = Color3.fromRGB(60, 170, 80)
    Submit.Text = "Submit"
    Submit.TextColor3 = Color3.new(1,1,1)
    Submit.TextScaled = true
    Submit.Font = Enum.Font.GothamBold
    Submit.BorderSizePixel = 0
    Submit.Parent = Frame
    
    local CopyLink = Instance.new("TextButton")
    CopyLink.Size = UDim2.new(0.45, 0, 0, 40)
    CopyLink.Position = UDim2.new(0.5, 0, 0.75, 0)
    CopyLink.BackgroundColor3 = Color3.fromRGB(60, 120, 200)
    CopyLink.Text = "Copy Link"
    CopyLink.TextColor3 = Color3.new(1,1,1)
    CopyLink.TextScaled = true
    CopyLink.Font = Enum.Font.GothamBold
    CopyLink.BorderSizePixel = 0
    CopyLink.Parent = Frame
    
    local function notify(t, m)
        StarterGui:SetCore("SendNotification", {Title = t, Text = m, Duration = 3})
    end
    
    CopyLink.MouseButton1Click:Connect(function()
        setclipboard(Link)
        notify("Copied", "Link copied to clipboard")
    end)
    
    Submit.MouseButton1Click:Connect(function()
        if Input.Text == Password then
            Correct = true
            notify("Success", "Correct password! Loading script...")
            ScreenGui:Destroy()
        else
            notify("Wrong", "Incorrect password, try again")
            Input.Text = ""
        end
    end)
    
    Input.FocusLost:Connect(function(enter)
        if enter then Submit.MouseButton1Click:Fire() end
    end)
    
    repeat task.wait() until Correct
end

-- // MAIN SCRIPT STARTS HERE
local loadlib = loadstring(game:HttpGet("https://raw.githubusercontent.com/wraithh-scripts/Library/main/v3.0.lua"))()
local Window = loadlib:CreateWindow({
    Name = "TinhSuper Hub",
    LoadingTitle = "TinhSuper Hub",
    LoadingSubtitle = "by tinhsuper_gm",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "TinhSuper Hub",
        FileName = "Aura."
    },
    Discord = {
        Enabled = true,
        Invite = "XDEemWjV2N",
        RememberJoins = true
    },
    KeySystem = false
})

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("RunService")
local TS = game:GetService("TweenService")
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

-- // TABS
local FarmTab = Window:CreateTab({
    Name = "Farm Tab",
    Icon = "home",
    ImageSource = "Feather",
    ShowTitle = true
})

local StatsSection = FarmTab:CreateSection("Stats")
local AuraLabel = StatsSection:CreateLabel("Aura: 0")
local RebirthsLabel = StatsSection:CreateLabel("Rebirths: 0")
local EnergyLabel = StatsSection:CreateLabel("Energy: 0 / 0")
local RebirthCostLabel = StatsSection:CreateLabel("Next Rebirth Cost: 0")

local FarmSection = FarmTab:CreateSection("Auto Farm")
local autoAura = FarmSection:CreateToggle({
    Name = "Auto Farm Aura",
    CurrentValue = false,
    Flag = "autoAura",
    Callback = function(v)
        if v then StartF:FireServer() else StopF:FireServer() end
    end
})

local autoEnergy = FarmSection:CreateToggle({
    Name = "Auto Farm Energy",
    CurrentValue = false,
    Flag = "autoEnergy",
    Callback = function(v)
        if v then StartE:FireServer() else StopE:FireServer() end
    end
})

local autoReb = FarmSection:CreateToggle({
    Name = "Auto Rebirth",
    CurrentValue = false,
    Flag = "autoReb"
})

local rLock = FarmSection:CreateToggle({
    Name = "Rebirth Lock",
    CurrentValue = false,
    Flag = "rLock"
})

local rMax = FarmSection:CreateToggle({
    Name = "Rebirth At Max Energy",
    CurrentValue = false,
    Flag = "rMax"
})

-- // UTIL
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
    if not autoReb.CurrentValue then return end
    local aura = N(AVal and AVal.Value or 0)
    local cost = N(NRC and NRC.Value or 0)
    local en = N(EVal and EVal.Value or 0)
    local mx = N(MEVal and MEVal.Value or 0)
    
    if rLock.CurrentValue then return end
    if aura < cost then return end
    
    if rMax.CurrentValue then
        if en >= mx then
            Reb:FireServer()
        end
    else
        Reb:FireServer()
    end
end

-- // LISTENERS
EVal.Changed:Connect(function(v)
	updE(v)
	eval()
end)
AVal.Changed:Connect(function(v)
	AuraLabel:Set("Aura: " .. fmt(v))
	eval()
end)
NRC.Changed:Connect(function(v)
	rMax = false
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

local ThemeTab = Window:CreateTab({
	Name = "Theme Tab",
	Icon = "palette",
	ImageSource = "Material",
	ShowTitle = true
})

ThemeTab:BuildThemeSection()

local ConfigTab = Window:CreateTab({
	Name = "Config Tab",
	Icon = "settings",
	ImageSource = "Material",
	ShowTitle = true
})

ConfigTab:BuildConfigSection()
