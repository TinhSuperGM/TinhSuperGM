-- ==========================================================
-- SCRIPT FULL: NHẶT TRÁI (WHITE-LIST) + HẢI TẶC + BẤT TỬ HOP
-- ==========================================================

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local placeId = game.PlaceId

-- DANH SÁCH TRÁI CHÍNH XÁC (Để lọc không nhầm NPC)
local FruitList = {
    "rocket", "spin", "blade", "spring", "bomb", "smoke", "spike", "flame", "ice", "sand",
    "dark", "eagle", "diamond", "light", "rubber", "ghost", "magma", "quake", "buddha", 
    "love", "creation", "spider", "sound", "phoenix", "portal", "lightning", "pain", 
    "blizzard", "gravity", "mammoth", "trex", "t-rex", "dough", "shadow", "venom", 
    "gas", "spirit", "tiger", "yeti", "kitsune", "control", "dragon"
}

local BlacklistedServers = {}

local function AutoSelectPirates()
    task.wait(2)
    if LocalPlayer.Team == nil then
        pcall(function() ReplicatedStorage.Remotes.CommF_:InvokeServer("SetTeam", "Pirates") end)
        task.wait(2)
    end
end

local function MaxOptimize()
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("BasePart") then v.Material = Enum.Material.SmoothPlastic v.Color = Color3.fromRGB(100, 100, 100)
        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then v.Enabled = false end
    end
end

local function AutoStoreFruit()
    pcall(function() ReplicatedStorage.Remotes.CommF_:InvokeServer("StoreFruit") end)
end

local function SnipeFruit()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") then
            local objName = string.lower(obj.Name)
            -- Kiểm tra xem tên model có nằm trong list trái không
            local isFruit = false
            for _, fruitName in pairs(FruitList) do
                if string.find(objName, fruitName) then isFruit = true break end
            end

            if isFruit then
                local handle = obj:FindFirstChild("Handle") or obj:FindFirstChildWhichIsA("BasePart")
                if handle and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = LocalPlayer.Character.HumanoidRootPart
                    local tween = TweenService:Create(hrp, TweenInfo.new((hrp.Position - handle.CFrame.Position).Magnitude/350, Enum.EasingStyle.Linear), {CFrame = handle.CFrame})
                    tween:Play() tween.Completed:Wait()
                    task.wait(1.5)
                    AutoStoreFruit()
                    return true
                end
            end
        end
    end
    return false
end

local function AdvancedServerHop()
    collectgarbage("collect")
    task.wait(3)
    local success, result = pcall(function() return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100")) end)
    
    if not success or not result or not result.data then task.wait(2) return AdvancedServerHop() end
    
    local validServers = {}
    for _, server in pairs(result.data) do
        if server.playing < (server.maxPlayers - 5) and server.id ~= game.JobId and not BlacklistedServers[server.id] then
            table.insert(validServers, server.id)
        end
    end
    
    if #validServers > 0 then
        local randomServer = validServers[math.random(1, #validServers)]
        local joinSuccess, err = pcall(function() TeleportService:TeleportToPlaceInstance(placeId, randomServer, LocalPlayer) end)
        if not joinSuccess or string.find(tostring(err), "773") then BlacklistedServers[randomServer] = true task.wait(1) return AdvancedServerHop() end
    else
        BlacklistedServers = {}
        task.wait(2) AdvancedServerHop()
    end
end

MaxOptimize()
AutoSelectPirates()
task.wait(1)
if not SnipeFruit() then AdvancedServerHop() end
