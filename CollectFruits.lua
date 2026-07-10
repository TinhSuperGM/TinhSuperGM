-- ==========================================
-- SCRIPT NHẶT TRÁI + TỰ JOIN HẢI TẶC + HOP 3S
-- ĐÃ TỐI ƯU CHO DELTA X MOBILE / CLOUD VSPHONE
-- ==========================================

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local placeId = game.PlaceId

-- 1. Tự động chọn phe Hải Tặc (Vào phát chiến luôn)
local function AutoSelectPirates()
    if LocalPlayer.Team == nil then
        print("Đang tự động chọn phe Hải Tặc...")
        local success, err = pcall(function()
            -- Sử dụng RemoteEvent gốc của Blox Fruits để chọn phe Pirates
            ReplicatedStorage.Remotes.CommF_:InvokeServer("SetTeam", "Pirates")
        end)
        if not success then
            -- Phương pháp dự phòng nếu cấu trúc Remote thay đổi ở một số Sea
            pcall(function()
                ReplicatedStorage.Remotes.SetTeam:FireServer("Pirates")
            end)
        end
        task.wait(1) -- Chờ nhân vật hồi sinh ra map ổn định
    end
end

-- 2. Tối ưu hóa đồ họa (Khối xám siêu mượt)
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

-- 3. Hàm di chuyển mượt bằng Tween nhặt trái
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
                print("Tìm thấy trái: " .. obj.Name .. "! Đang bay lại lụm...")
                SafeTween(handle.CFrame)
                task.wait(1)
                return true
            end
        end
    end
    return false
end

-- 5. Server Hop siêu tốc (Delay 3s - Vào phát ăn ngay)
local function AdvancedServerHop()
    print("Đang delay 3s siêu tốc trước khi quét server...")
    task.wait(3)
    
    print("Đang tìm server trống để vào phát ăn ngay...")
    local serverList = {}
    
    local success, result = pcall(function()
        return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100"))
    end)
    
    if success and result and result.data then
        for _, server in pairs(result.data) do
            if server.playing < (server.maxPlayers - 3) and server.id ~= game.JobId then
                table.insert(serverList, server.id)
            end
        end
    end
    
    if #serverList > 0 then
        local randomServer = serverList[math.random(1, #serverList)]
        print("Đã chọn được server trống! Đang nhảy qua...")
        
        pcall(function()
            TeleportService:TeleportToPlaceInstance(placeId, randomServer, LocalPlayer)
        end)
    else
        print("Chưa tìm thấy server đủ trống, đang quét lại sau 1s...")
        task.wait(1)
        AdvancedServerHop()
    end
end

-- ==========================================
-- KÍCH HOẠT HỆ THỐNG
-- ==========================================
MaxOptimize()
AutoSelectPirates()
task.wait(0.5)

local gotFruit = SnipeFruit()
if not gotFruit then
    print("Không có trái, tiến hành đổi server tốc độ cao...")
end

AdvancedServerHop()
