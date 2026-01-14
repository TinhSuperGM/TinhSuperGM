--[[ 
    TinhSuper Hub [Hop]
    Multi Mode Hop via API
    PlayerGui UI - No CoreGui
]]

-- ================== CONFIG ==================
local API_URL = "https://hello-api-h2rj.onrender.com/jobid"
local CHECK_DELAY = 0.5

-- ================== SERVICES ==================
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ================== GLOBAL ==================
getgenv().TSH_AutoHop = false
getgenv().TSH_Mode = nil
getgenv().TSH_LastJobId = ""

-- ================== API ==================
local function GetJobId(mode)
    local ok, res = pcall(function()
        return game:HttpGet(API_URL)
    end)
    if not ok then return nil end

    local data
    ok, data = pcall(function()
        return HttpService:JSONDecode(res)
    end)
    if not ok or not data[mode] then return nil end

    return tostring(data[mode].jobId or "")
end

-- ================== UI ==================
local Gui = Instance.new("ScreenGui", PlayerGui)
Gui.Name = "TinhSuperHubHop"
Gui.ResetOnSpawn = false

local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.fromScale(0.35, 0.4)
Main.Position = UDim2.fromScale(0.33, 0.3)
Main.BackgroundColor3 = Color3.fromRGB(25,25,25)
Main.Active = true
Main.Draggable = true
Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0,12)

-- Title
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.fromScale(1,0.15)
Title.BackgroundTransparency = 1
Title.Text = "🌌 TinhSuper Hub [Hop]"
Title.Font = Enum.Font.GothamBold
Title.TextColor3 = Color3.new(1,1,1)
Title.TextScaled = true

-- Status
local Status = Instance.new("TextLabel", Main)
Status.Position = UDim2.fromScale(0,0.15)
Status.Size = UDim2.fromScale(1,0.12)
Status.BackgroundTransparency = 1
Status.Text = "Status: OFF"
Status.Font = Enum.Font.Gotham
Status.TextColor3 = Color3.fromRGB(200,200,200)
Status.TextScaled = true

-- ================== BUTTON CREATOR ==================
local function CreateButton(text, yPos, mode)
    local btn = Instance.new("TextButton", Main)
    btn.Position = UDim2.fromScale(0.1, yPos)
    btn.Size = UDim2.fromScale(0.8, 0.11)
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextScaled = true
    btn.TextColor3 = Color3.new(1,1,1)
    btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
    btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)

    btn.MouseButton1Click:Connect(function()
        getgenv().TSH_AutoHop = true
        getgenv().TSH_Mode = mode
        getgenv().TSH_LastJobId = ""
        Status.Text = "Mode: "..mode.." | Waiting JobId..."
    end)
end

-- ================== BUTTONS ==================
CreateButton("🌕 FULL MOON", 0.30, "moon")
CreateButton("⚔️ SWORD",     0.43, "sword")
CreateButton("🏝️ ISLAND",    0.56, "island")
CreateButton("👑 BOSS",      0.69, "boss")
CreateButton("🔥 HAKI",      0.82, "haki")

-- ================== LOOP ==================
task.spawn(function()
    while task.wait(CHECK_DELAY) do
        if not getgenv().TSH_AutoHop or not getgenv().TSH_Mode then
            continue
        end

        local jobId = GetJobId(getgenv().TSH_Mode)

        if jobId ~= "" and jobId ~= getgenv().TSH_LastJobId then
            getgenv().TSH_LastJobId = jobId
            Status.Text = "Hop → "..getgenv().TSH_Mode

            TeleportService:TeleportToPlaceInstance(
                game.PlaceId,
                jobId,
                LocalPlayer
            )

            task.wait(5)
        end
    end
end)

warn("[TinhSuper Hub] Loaded successfully!")
