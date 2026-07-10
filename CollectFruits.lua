-- ==========================================================
-- SCRIPT FULL CHUẨN: NHẶT TRÁI (WHITELIST) + HẢI TẶC + BẤT TỬ HOP 3S
-- ==========================================================

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local placeId = game.PlaceId

-- DANH SÁCH TRÁI CHÍNH XÁC (Tuyệt đối không nhầm NPC Dealer)
local FruitList = {
    "rocket", "spin", "blade", "spring", "bomb", "smoke", "spike", "flame", "ice", "sand",
    "dark", "eagle", "diamond", "light", "rubber", "ghost", "magma", "quake", "buddha", 
    "love", "creation", "spider", "sound", "phoenix", "portal", "lightning", "pain", 
    "blizzard", "gravity", "mammoth", "trex", "t-rex", "dough", "shadow", "venom", 
    "gas", "spirit", "tiger", "yeti", "kitsune", "control", "dragon"
}

local BlacklistedServers = {}

-- Hàm bọc lỗi an toàn cho Remote
local function SafeInvoke(remote, ...)
    local success, result = pcall(function()
        return remote:InvokeServer(...)
    end)
    if not success then
        warn("Bỏ qua lỗi từ Remote: " .. tostring(result))
        return nil
    end
    return result
end

-- 1. Hàm tự chọn phe Hải Tặc (Chống đơ menu)
local function AutoSelectPirates()
    task.wait(2)
    if LocalPlayer.Team == nil or LocalPlayer.Team.Name ~= "Pirates" then
        print("Đang ép hệ thống chọn phe Hải Tặc...")
        local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
        if remote then
            SafeInvoke(remote, "SetTeam", "Pirates")
        end
        task.wait(2)
    end
end

-- 2. Tối ưu đồ họa khối xám mượt mà cho Cloud
local function MaxOptimize()
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("BasePart") then 
            v.Material = Enum.Material.SmoothPlastic 
            v.Color = Color3.fromRGB(100, 100, 100)
        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then 
            v.Enabled = false 
        end
    end
end

-- 3. Cất trái vào kho an toàn
local function AutoStoreFruit()
    local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
    if remote then
        print("Đang tiến hành cất trái vào kho...")
        SafeInvoke(remote, "StoreFruit")
    end
end

-- 4. Quét sâu tìm trái ác quỷ theo Whitelist
local function SnipeFruit()
    print("Đang quét tìm trái ác quỷ...")
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") then
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
                if handle and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = LocalPlayer.Character.HumanoidRootPart
                    local distance = (hrp.Position - handle.CFrame.Position).Magnitude
                    
                    if distance < 5000 then
                        print("Tìm thấy trái xịn: " .. obj.Name .. "! Đang bay tới lụm...")
                        local tween = TweenService:Create(hrp, TweenInfo.new(distance/350, Enum.EasingStyle.Linear), {CFrame = handle.CFrame})
                        tween:Play() 
                        tween.Completed:Wait()
                        task.wait(1.5) -- Chờ nhặt hẳn lên tay
                        AutoStoreFruit()
                        print("Đã cất két an toàn!")
                        return true
                    end
                end
            end
        end
    end
    print("Không tìm thấy trái nào ở server này.")
    return false
end

-- 5. BẤT TỬ HOP SERVER (Lọc trống > 5 chỗ, né lỗi 773/GameFull)
local function AdvancedServerHop()
    collectgarbage("collect") -- Giải phóng RAM cho Cloud
    print("Đang delay đúng 3s tốc độ cao trước khi đổi vùng...")
    task.wait(3)
    
    local success, result = pcall(function() 
        return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100")) 
    end)
    
    if not success or not result or not result.data then 
        print("Lỗi API kết nối, đang quét lại...")
        task.wait(1) 
        return AdvancedServerHop() 
    end
    
    local validServers = {}
    for _, server in pairs(result.data) do
        if server.playing < (server.maxPlayers - 5) and server.id ~= game.JobId and not BlacklistedServers[server.id] then
            table.insert(validServers, server.id)
        end
    end
    
    if #validServers > 0 then
        local randomServer = validServers[math.random(1, #validServers)]
        print("Đang tiến hành chuyển tới server: " .. randomServer)
        
        local joinSuccess, err = pcall(function() 
            TeleportService:TeleportToPlaceInstance(placeId, randomServer, LocalPlayer) 
        end)
        
        if not joinSuccess or string.find(tostring(err), "773") or string.find(tostring(err), "Full") then 
            print("Server bị full/lỗi kẹt, ghi vào sổ đen và đổi mục tiêu...")
            BlacklistedServers[randomServer] = true 
            task.wait(0.5) 
            return AdvancedServerHop() 
        end
    else
        print("Tất cả các server đều full, đang làm mới danh sách...")
        BlacklistedServers = {}
        task.wait(1) 
        AdvancedServerHop()
    end
end

-- ==========================================
-- QUY TRÌNH KÍCH HOẠT VÒNG LẶP KHÉP KÍN
-- ==========================================
pcall(function()
    MaxOptimize()
    AutoSelectPirates()
    task.wait(1)
    
    -- Chạy quét trái trước
    SnipeFruit()
    
    -- Quét xong (Dù có trái hay không) thì lập tức Hop server sau 3s
    AdvancedServerHop()
end)
