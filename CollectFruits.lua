-- ==========================================================
-- SCRIPT FULL: NHẶT TRÁI + TỰ JOIN HẢI TẶC + BẤT TỬ HOP SERVER
-- ==========================================================

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local placeId = game.PlaceId

-- 1. Hàm chọn phe Hải Tặc thông minh (Chỉ gọi khi cần)
local function AutoSelectPirates()
    -- Chờ menu chọn phe xuất hiện
    task.wait(2) 
    if LocalPlayer.Team == nil then
        print("Đang ép hệ thống chọn phe Hải Tặc...")
        pcall(function()
            ReplicatedStorage.Remotes.CommF_:InvokeServer("SetTeam", "Pirates")
        end)
        task.wait(2) -- Đợi game load xong model sau khi chọn phe
    end
end

-- 2. Tối ưu đồ họa
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

-- 3. Cất trái vào kho
local function AutoStoreFruit()
    pcall(function()
        ReplicatedStorage.Remotes.CommF_:InvokeServer("StoreFruit")
    end)
end

-- 4. Quét và nhặt trái
local function SnipeFruit()
    for _, obj in pairs(Workspace:GetChildren()) do
        if obj:IsA("Model") and string.match(obj.Name, "Fruit") then
            local handle = obj:FindFirstChild("Handle") or obj:FindFirstChildWhichIsA("BasePart")
            if handle then
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    print("Tìm thấy trái! Đang lướt tới...")
                    local hrp = LocalPlayer.Character.HumanoidRootPart
                    local tween = TweenService:Create(hrp, TweenInfo.new((hrp.Position - handle.CFrame.Position).Magnitude/350, Enum.EasingStyle.Linear), {CFrame = handle.CFrame})
                    tween:Play()
                    tween.Completed:Wait()
                    task.wait(1.5)
                    AutoStoreFruit()
                    print("Đã cất trái vào kho!")
                    return true
                end
            end
        end
    end
    return false
end

-- 5. BẤT TỬ HOP SERVER (Đệ quy tự tìm server thay thế)
local function AdvancedServerHop()
    print("Đang delay 3s trước khi nhảy...")
    task.wait(3)
    
    local success, result = pcall(function()
        return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100"))
    end)
    
    if not success or not result or not result.data then
        task.wait(2)
        return AdvancedServerHop()
    end
    
    local validServers = {}
    for _, server in pairs(result.data) do
        if server.playing < (server.maxPlayers - 4) and server.id ~= game.JobId then
            table.insert(validServers, server.id)
        end
    end
    
    if #validServers > 0 then
        local randomServer = validServers[math.random(1, #validServers)]
        print("Đang join server: " .. randomServer)
        
        local joinSuccess = pcall(function()
            TeleportService:TeleportToPlaceInstance(placeId, randomServer, LocalPlayer)
        end)
        
        if not joinSuccess then
            print("Join thất bại, đang tìm server khác ngay...")
            task.wait(1)
            AdvancedServerHop()
        end
    else
        print("Không có server trống, thử lại sau 2s...")
        task.wait(2)
        AdvancedServerHop()
    end
end

-- ==========================================
-- KÍCH HOẠT
-- ==========================================
MaxOptimize()
AutoSelectPirates()
task.wait(1)

if not SnipeFruit() then
    print("Không có trái, nhảy server!")
end

AdvancedServerHop()
