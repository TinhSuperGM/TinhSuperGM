-- ==========================================================
-- SCRIPT ANTI-BAN PREMIUM (FIX SẠCH LỖI NIL VALUE)
-- ==========================================================

-- Đợi game load xong hoàn toàn trước khi chạy bất cứ thứ gì
if not game:IsLoaded() then game.Loaded:Wait() end

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
if not LocalPlayer.Character then LocalPlayer.CharacterAdded:Wait() end

local placeId = game.PlaceId
local BlacklistedServers = {}
local NoClipConnection = nil

-- Danh sách trái Whitelist chuẩn
local FruitList = {
    "rocket", "spin", "blade", "spring", "bomb", "smoke", "spike", "flame", "ice", "sand",
    "dark", "eagle", "diamond", "light", "rubber", "ghost", "magma", "quake", "buddha", 
    "love", "creation", "spider", "sound", "phoenix", "portal", "lightning", "pain", 
    "blizzard", "gravity", "mammoth", "trex", "t-rex", "dough", "shadow", "venom", 
    "gas", "spirit", "tiger", "yeti", "kitsune", "control", "dragon"
}

-- 1. Hàm tự chọn phe Hải Tặc an toàn
local function AutoSelectPirates()
    if LocalPlayer.Team == nil or LocalPlayer.Team.Name ~= "Pirates" then
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        local commF = remotes and remotes:FindFirstChild("CommF_")
        if commF then
            pcall(function()
                commF:InvokeServer("SetTeam", "Pirates")
            end)
        end
    end
end

-- 2. Cất trái vào kho
local function AutoStoreFruit()
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    local commF = remotes and remotes:FindFirstChild("CommF_")
    if commF then
        pcall(function()
            commF:InvokeServer("StoreFruit")
        end)
    end
end

-- 3. NoClip ẩn đi xuyên tường
local function StartNoClip()
    if NoClipConnection then NoClipConnection:Disconnect() end
    NoClipConnection = RunService.Stepped:Connect(function()
        if LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end)
end

local function StopNoClip()
    if NoClipConnection then
        NoClipConnection:Disconnect()
        NoClipConnection = nil
    end
end

-- 4. Hàm di chuyển an toàn tốc độ 140
local function SafeTweenToFruit(targetCFrame)
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local distance = (hrp.Position - targetCFrame.Position).Magnitude
    StartNoClip()
    
    local tweenInfo = TweenInfo.new(distance / 140, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
    
    tween:Play()
    tween.Completed:Wait()
    StopNoClip()
end

-- 5. Quét tìm trái ác quỷ
local function SnipeFruit()
    local descendants = Workspace:GetDescendants()
    for _, obj in pairs(descendants) do
        if obj and obj:IsA("Model") and obj.Name then
            local objName = string.lower(obj.Name)
            local isFruit = false
            
            for _, fruitName in pairs(FruitList) do
                if string.find(objName, fruitName) then 
                    isFruit = true 
                    break 
                end
            end

            if isFruit then
                local handle = obj:FindFirstChild("Handle") or obj:FindFirstChildWhichIsA("BasePart")
                local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if handle and hrp then
                    local distance = (hrp.Position - handle.CFrame.Position).Magnitude
                    if distance < 6000 then
                        SafeTweenToFruit(handle.CFrame)
                        task.wait(1.5)
                        AutoStoreFruit()
                        return true
                    end
                end
            end
        end
    end
    return false
end

-- 6. BẤT TỬ HOP SERVER
local function AdvancedServerHop()
    pcall(function() collectgarbage("collect") end)
    task.wait(3)
    
    local success, result = pcall(function() 
        return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100")) 
    end)
    
    if not success or not result or not result.data then 
        task.wait(1) 
        return AdvancedServerHop() 
    end
    
    local validServers = {}
    for _, server in pairs(result.data) do
        if server.playing and server.maxPlayers and server.playing < (server.maxPlayers - 5) and server.id ~= game.JobId and not BlacklistedServers[server.id] then
            table.insert(validServers, server.id)
        end
    end
    
    if #validServers > 0 then
        local randomServer = validServers[math.random(1, #validServers)]
        local joinSuccess, err = pcall(function() 
            TeleportService:TeleportToPlaceInstance(placeId, randomServer, LocalPlayer) 
        end)
        
        if not joinSuccess or string.find(tostring(err), "773") or string.find(tostring(err), "Full") then 
            BlacklistedServers[randomServer] = true 
            task.wait(0.5) 
            return AdvancedServerHop() 
        end
    else
        BlacklistedServers = {}
        task.wait(1) 
        AdvancedServerHop()
    end
end

-- ==========================================
-- CHẠY QUY TRÌNH CHUẨN (TUYỆT ĐỐI KHÔNG DÙNG TASK.DEFER LỖI BIẾN)
-- ==========================================
task.wait(1)
pcall(AutoSelectPirates)
task.wait(1)
pcall(SnipeFruit)
task.wait(1)
AdvancedServerHop()
