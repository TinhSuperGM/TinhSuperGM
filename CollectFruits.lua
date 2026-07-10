-- ==========================================
-- SCRIPT NHẶT TRÁI + HOP SERVER SIÊU TỐI GIẢN
-- BY TÍNH & GEMINI (NO UI - SIÊU NHẸ CHO CỤ CỐ)
-- ==========================================

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local placeId = game.PlaceId

-- 1. Tối ưu hóa đồ họa độc quyền cho Cụ Cố (Khối xám + Màn hình đen ngầm)
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

-- 2. Hàm di chuyển mượt bằng Tween để né Anti-cheat
local function SafeTween(targetCFrame)
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = LocalPlayer.Character.HumanoidRootPart
    
    -- Tính toán thời gian lướt dựa trên khoảng cách (Tốc độ ~ 300 studs/s)
    local distance = (hrp.Position - targetCFrame.Position).Magnitude
    local duration = distance / 300
    
    local tween = TweenService:Create(hrp, TweenInfo.new(duration, Enum.EasingStyle.Linear), {CFrame = targetCFrame})
    tween:Play()
    tween.Completed:Wait()
end

-- 3. Quét chính xác vị trí Trái Ác Quỷ trong Blox Fruits
local function SnipeFruit()
    for _, obj in pairs(Workspace:GetChildren()) do
        -- Blox Fruits đặt tên Model trái cây spawn tự nhiên là "Fruit "
        if obj:IsA("Model") and string.match(obj.Name, "Fruit") then
            local handle = obj:FindFirstChild("Handle") or obj:FindFirstChildWhichIsA("BasePart")
            if handle then
                print("Tìm thấy trái: " .. obj.Name .. "! Đang bay lại lụm...")
                SafeTween(handle.CFrame)
                task.wait(1.5) -- Chờ hệ thống xử lý nhặt vào túi đồ
                return true
            end
        end
    end
    return false
end

-- 4. Server Hop thông minh (Không trùng server cũ)
local function AdvancedServerHop()
    print("Đang tìm server mới để nhảy...")
    local serverList = {}
    
    local success, result = pcall(function()
        return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100"))
    end)
    
    if success and result and result.data then
        for _, server in pairs(result.data) do
            if server.playing < server.maxPlayers and server.id ~= game.JobId then
table.insert(serverList, server.id)
            end
        end
    end
    
    if #serverList > 0 then
        -- Chọn ngẫu nhiên một server trong danh sách hợp lệ
        local randomServer = serverList[math.random(1, #serverList)]
        print("Đang delay 10s an toàn trước khi nhảy...")
        task.wait(10)
        
        pcall(function()
            TeleportService:TeleportToPlaceInstance(placeId, randomServer, LocalPlayer)
        end)
    else
        print("Không tìm thấy server phù hợp, thử lại sau 5s...")
        task.wait(5)
        AdvancedServerHop()
    end
end

-- ==========================================
-- KÍCH HOẠT HỆ THỐNG
-- ==========================================
MaxOptimize()
task.wait(1)

local gotFruit = SnipeFruit()
if not gotFruit then
    print("Server này không có trái nào cả.")
end

AdvancedServerHop()
