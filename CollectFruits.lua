-- ==========================================================
-- SCRIPT THỰC CHIẾN: ANTI-CHEAT BYPASS + NHẶT SẠCH TRÁI + FIX LỖI PHE
-- ==========================================================

if not game:IsLoaded() then game.Loaded:Wait() end

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
if not LocalPlayer.Character then LocalPlayer.CharacterAdded:Wait() end

local placeId = game.PlaceId
local BlacklistedServers = {}
local NoClipConnection = nil

-- DANH SÁCH TRÁI CHUẨN KÈM BỘ LỌC
local FruitList = {
    "rocket", "spin", "blade", "spring", "bomb", "smoke", "spike", "flame", "ice", "sand",
    "dark", "eagle", "diamond", "light", "rubber", "ghost", "magma", "quake", "buddha", 
    "love", "creation", "spider", "sound", "phoenix", "portal", "lightning", "pain", 
    "blizzard", "gravity", "mammoth", "trex", "t-rex", "dough", "shadow", "venom", 
    "gas", "spirit", "tiger", "yeti", "kitsune", "control", "dragon"
}

-- 1. Vòng lặp ép chọn phe Hải Tặc bằng được
local function AutoSelectPirates()
    local attempts = 0
    while (LocalPlayer.Team == nil or LocalPlayer.Team.Name ~= "Pirates") and attempts < 10 do
        attempts = attempts + 1
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        local commF = remotes and remotes:FindFirstChild("CommF_")
        if commF then
            pcall(function()
                commF:InvokeServer("SetTeam", "Pirates")
            end)
        end
        task.wait(1)
    end
end

-- 2. Cất trái vào kho
local function AutoStoreFruit()
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    local commF = remotes and remotes:FindFirstChild("CommF_")
    if commF then
        pcall(function() commF:InvokeServer("StoreFruit") end)
    end
end

-- 3. NoClip ẩn xuyên vật thể khi di chuyển
local function StartNoClip()
    if NoClipConnection then NoClipConnection:Disconnect() end
    NoClipConnection = RunService.Stepped:Connect(function()
        if LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end)
end

local function StopNoClip()
    if NoClipConnection then NoClipConnection:Disconnect() NoClipConnection = nil end
end

-- 4. Cơ chế di chuyển bypass Anti-Cheat (CFrame Step + Giả lập Physics)
local function SafeMoveTo(targetCFrame)
    local character = LocalPlayer.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = character and character:FindFirstChildWhichIsA("Humanoid")
    if not hrp or not humanoid then return end
    
    StartNoClip()
    -- Đổi trạng thái nhân vật sang Physics để bypass bộ quét vị trí của Blox Fruits
    humanoid:ChangeState(Enum.HumanoidStateType.Physics)
    
    local speed = 135 -- Tốc độ di chuyển an toàn tuyệt đối chống bị kick
    while (hrp.Position - targetCFrame.Position).Magnitude > 5 do
        if not LocalPlayer.Character or not hrp:IsDescendantOf(LocalPlayer.Character) then break end
        
        local currentPos = hrp.Position
        local targetPos = targetCFrame.Position
        local direction = (targetPos - currentPos).Unit
        local distance = (targetPos - currentPos).Magnitude
        
        -- Di chuyển từng bước nhỏ dựa trên DeltaTime (Heartbeat)
        local step = math.min(distance, speed * RunService.Heartbeat:Wait())
        hrp.CFrame = CFrame.new(currentPos + direction * step)
        
        -- Triệt tiêu hoàn toàn vận tốc để chống lỗi cao độ/văng ngược
        hrp.Velocity = Vector3.new(0, 0, 0)
    end
    
    hrp.CFrame = targetCFrame
    task.wait(0.2)
    humanoid:ChangeState(Enum.HumanoidStateType.Running)
    StopNoClip()
end

-- 5. Hàm quét nhặt SẠCH TOÀN BỘ TRÁI trên server trước khi Hop
local function SnipeFruit()
    print("Đang quét tìm toàn bộ trái ác quỷ hợp lệ...")
    local pickedAny = false
    
    while true do
        local targetFruit = nil
        -- CHỈ QUÉT CÁC VẬT THỂ NẰM TRỰC TIẾP TRONG WORKSPACE (Né hoàn toàn map/NPC kẹt)
        local children = Workspace:GetChildren()
        
        for _, obj in pairs(children) do
            if obj:IsA("Model") and obj.Parent == Workspace and not Players:GetPlayerFromCharacter(obj) then
                local objName = string.lower(obj.Name)
                local isFruit = false
                
                for _, fruitName in pairs(FruitList) do
                    if string.find(objName, fruitName) then isFruit = true break end
                end
                
                if isFruit then
                    local handle = obj:FindFirstChild("Handle") or obj:FindFirstChildWhichIsA("BasePart")
                    if handle then
                        targetFruit = obj
                        break
                    end
                end
            end
        end
        
        -- Nếu tìm thấy trái, tiến hành xử lý lụm rồi lặp tiếp để check trái khác
        if targetFruit then
            pickedAny = true
            local handle = targetFruit:FindFirstChild("Handle") or targetFruit:FindFirstChildWhichIsA("BasePart")
            print("Phát hiện trái xịn: " .. targetFruit.Name .. ". Đang tiến hành gom...")
            SafeMoveTo(handle.CFrame)
            task.wait(1)
            AutoStoreFruit()
            task.wait(1)
        else
            -- Không còn trái nào trực tiếp ngoài Workspace nữa thì dừng loop
            break
        end
    end
    
    return pickedAny
end

-- 6. BẤT TỬ HOP SERVER (Dọn rác RAM Cloud)
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
-- CHẠY QUY TRÌNH CHUẨN THỰC CHIẾN
-- ==========================================
task.wait(0.5)
pcall(AutoSelectPirates)
task.wait(0.5)
pcall(SnipeFruit)
task.wait(0.5)
AdvancedServerHop()
