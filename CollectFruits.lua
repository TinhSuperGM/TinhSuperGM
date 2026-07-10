-- ==========================================
-- SCRIPT NHẶT TRÁI + AUTO JOIN PAI-RẮT + HOP 3S
-- FIX LỖI HTTP CONNECTFAIL & GAMEFULL CHO CLOUD
-- ==========================================

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local placeId = game.PlaceId

-- 1. Hàm tự động chọn phe Hải Tặc cực mạnh
local function AutoSelectPirates()
    if LocalPlayer.Team == nil or LocalPlayer.Team.Name ~= "Pirates" then
        print("Đang ép hệ thống chọn phe Hải Tặc...")
        pcall(function()
            ReplicatedStorage.Remotes.CommF_:InvokeServer("SetTeam", "Pirates")
        end)
        task.wait(1.5)
    end
end

-- 2. Tối ưu đồ họa khối xám
local function MaxOptimize()
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Material = Enum.Material.SmoothPlastic
            v.Color = Color3.fromRGB(100, 100, 100)
        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Sparkles") then
            v.Enabled = false
        end
    end
end

-- 3. Hàm Tween nhặt trái
local function SafeTween(targetCFrame)
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = LocalPlayer.Character.HumanoidRootPart
    local distance = (hrp.Position - targetCFrame.Position).Magnitude
    local duration = distance / 350
    local tween = TweenService:Create(hrp, TweenInfo.new(duration, Enum.EasingStyle.Linear), {CFrame = targetCFrame})
    tween:Play()
    tween.Completed:Wait()
end

-- 4. Quét vị trí Trái Ác Quỷ
local function SnipeFruit()
    for _, obj in pairs(Workspace:GetChildren()) do
        if obj:IsA("Model") and string.match(obj.Name, "Fruit") then
            local handle = obj:FindFirstChild("Handle") or obj:FindFirstChildWhichIsA("BasePart")
            if handle then
                print("Tìm thấy trái: " .. obj.Name .. "! Đang lướt lại lụm...")
                SafeTween(handle.CFrame)
                task.wait(1)
                return true
            end
        end
    end
    return false
end

-- 5. Server Hop siêu tốc 3s (Có chống lỗi ConnectFail và GameFull)
local function AdvancedServerHop()
    print("Đang delay đúng 3s tốc độ cao...")
    task.wait(3) -- Đã đưa chính xác về 3 giây cho ní
    
    print("Đang gọi API lấy danh sách server công khai...")
    local serverList = {}
    
    local success, result = pcall(function()
        return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100"))
    end)
    
    -- Xử lý nếu gọi API lỗi (ConnectFail)
    if not success or not result or not result.data then
        print("Lỗi kết nối API (ConnectFail). Đang quét lại ngay lập tức...")
        task.wait(1)
        return AdvancedServerHop()
    end
    
    -- Lọc lấy danh sách các server cực kỳ vắng
    for _, server in pairs(result.data) do
        -- Ép điều kiện server phải trống ít nhất 4 chỗ để đảm bảo "vào phát ăn ngay"
        if server.playing < (server.maxPlayers - 4) and server.id ~= game.JobId then
            table.insert(serverList, server.id)
        end
    end
    
    if #serverList > 0 then
        local randomServer = serverList[math.random(1, #serverList)]
        print("Đã tìm được server bao vắng! Xuất kích chuyển vùng...")
        
        pcall(function()
            TeleportService:TeleportToPlaceInstance(placeId, randomServer, LocalPlayer)
        end)
    else
        print("Không có server nào đủ trống, đang tìm lại sau 1s...")
        task.wait(1)
        AdvancedServerHop()
    end
end

-- ==========================================
-- CHẠY TIẾN TRÌNH KHÉP KÍN
-- ==========================================
MaxOptimize()
AutoSelectPirates()
task.wait(0.5)

local gotFruit = SnipeFruit()
if not gotFruit then
    print("Không tìm thấy trái nào ở server này.")
end

AdvancedServerHop()
