--[[ 
    TinhSuper Hub [Hop]
    Auto Join Server Full Moon (via API JobId)
    Không dùng CoreGui
    Made for Roblox Exploit
]]

-- ================== CONFIG ==================
local API_URL = "https://tinh-api.onrender.com/jobid" -- API của bạn
local CHECK_DELAY = 2 -- giây giữa mỗi lần check API

-- ================== SERVICES ==================
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ================== GLOBAL ==================
getgenv().TSH_AutoHop = false
getgenv().TSH_LastJobId = ""

-- ================== API FUNCTION ==================
local function GetLatestJobId()
    local success, response = pcall(function()
        return game:HttpGet(API_URL)
    end)

    if not success then
        warn("[TinhSuper] Không gọi được API")
        return nil
    end

    local data
    success, data = pcall(function()
        return HttpService:JSONDecode(response)
    end)

    if not success or not data or not data.jobId then
        return nil
    end

    return tostring(data.jobId)
end

-- ================== UI CREATE ==================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TinhSuperHubHop"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.fromScale(0.28, 0.22)
Main.Position = UDim2.fromScale(0.36, 0.38)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true

local UICorner = Instance.new("UICorner", Main)
UICorner.CornerRadius = UDim.new(0, 12)

-- ================== TITLE ==================
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.fromScale(1, 0.25)
Title.BackgroundTransparency = 1
Title.Text = "🌕 TinhSuper Hub [Hop]"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextScaled = true

-- ================== STATUS ==================
local Status = Instance.new("TextLabel", Main)
Status.Position = UDim2.fromScale(0, 0.28)
Status.Size = UDim2.fromScale(1, 0.18)
Status.BackgroundTransparency = 1
Status.Text = "Status: OFF"
Status.TextColor3 = Color3.fromRGB(200, 200, 200)
Status.Font = Enum.Font.Gotham
Status.TextScaled = true

-- ================== BUTTON ==================
local Button = Instance.new("TextButton", Main)
Button.Position = UDim2.fromScale(0.15, 0.55)
Button.Size = UDim2.fromScale(0.7, 0.3)
Button.Text = "AUTO JOIN FULL MOON: OFF"
Button.Font = Enum.Font.GothamBold
Button.TextScaled = true
Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Button.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
Button.BorderSizePixel = 0

local BtnCorner = Instance.new("UICorner", Button)
BtnCorner.CornerRadius = UDim.new(0, 10)

-- ================== TOGGLE LOGIC ==================
local function SetState(state)
    getgenv().TSH_AutoHop = state

    if state then
        Button.Text = "AUTO JOIN FULL MOON: ON"
        Button.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        Status.Text = "Status: Running..."
    else
        Button.Text = "AUTO JOIN FULL MOON: OFF"
        Button.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
        Status.Text = "Status: OFF"
    end
end

Button.MouseButton1Click:Connect(function()
    SetState(not getgenv().TSH_AutoHop)
end)

-- ================== MAIN LOOP ==================
task.spawn(function()
    while task.wait(CHECK_DELAY) do
        if not getgenv().TSH_AutoHop then
            continue
        end

        local jobId = GetLatestJobId()

        if jobId and jobId ~= "" and jobId ~= getgenv().TSH_LastJobId then
            getgenv().TSH_LastJobId = jobId
            Status.Text = "Hop to new server..."

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
