-- ==========================================================
-- SCRIPT ĐÃ FIX: NHẶT TRÁI + TỰ HOP VÔ HẠN + KHÔNG ĐỨNG YÊN
-- Fix lỗi: chỉ join 1 lần, server full/không có chỗ thì thử lại mãi
-- ==========================================================
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local placeId = game.PlaceId
local currentJobId = game.JobId

-- ⚙️ CẤU HÌNH – DỄ ĐIỀU CHỈNH
local CONFIG = {
    SCAN_DURATION = 12,          -- Số giây quét tìm trái TRƯỚC KHI quyết định hop
    SCAN_INTERVAL = 0.3,         -- Mỗi 0.3s quét 1 lần (nhanh hơn người chơi bình thường)
    TELEPORT_TIMEOUT = 8,        -- Tối đa 8s chờ chuyển server → quá thời gian coi như THẤT BẠI
    MAX_HOP_RETRIES = 15,        -- Tối đa 15 lần thử hop liên tục → tránh bị Roblox chặn tạm thời
    DELAY_BETWEEN_HOPS = 2.5,    -- Chờ 2.5s giữa các lần thử hop (tránh bị phát hiện spam)
    MIN_SERVER_FREE_SLOTS = 5,   -- Chỉ join server còn TỐI THIỂU 5 chỗ trống (tránh gần full bị đẩy)
    MOVE_SPEED = 450             -- Tốc độ lướt tới trái
}

-- ==========================================
-- 1. HÀM PHỔ BIẾN – GIỮ NGUYÊN + TĂNG BẢO VỆ
-- ==========================================
local function AutoSelectPirates()
    task.wait(2)
    if LocalPlayer.Team == nil then
        print("[PHE] Đang chọn Hải Tặc...")
        pcall(function()
            ReplicatedStorage.Remotes.CommF_:InvokeServer("SetTeam", "Pirates")
        end)
        task.wait(2)
    end
end

local function MaxOptimize()
    pcall(function()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Material = Enum.Material.SmoothPlastic
                v.Color = Color3.fromRGB(100, 100, 100)
            elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                v.Enabled = false
            end
        end
    end)
end

local function AutoStoreFruit()
    pcall(function()
        ReplicatedStorage.Remotes.CommF_:InvokeServer("StoreFruit")
    end)
end

-- Lấy HumanoidRootPart an toàn – tránh lỗi khi nhân vật chết/respawn
local function GetHRP()
    local char = LocalPlayer.Character
    if not char then return nil end
    return char:FindFirstChild("HumanoidRootPart")
end

-- ==========================================
-- 2. FIX HÀM TÌM TRÁI – QUÉT NHIỀU LẦN, KHÔNG CHỈ 1 LẦN
-- ==========================================
local function SnipeFruit()
    local endTime = os.clock() + CONFIG.SCAN_DURATION
    print("[TÌM TRÁI] Bắt đầu quét trong "..CONFIG.SCAN_DURATION.."s...")

    -- Quét liên tục cho đến khi hết thời gian
    while os.clock() < endTime do
        -- Duyệt tất cả đối tượng trong map
        for _, obj in pairs(Workspace:GetChildren()) do
            if obj:IsA("Model") and string.find(obj.Name, "Fruit") then
                local handle = obj:FindFirstChild("Handle") or obj:FindFirstChildWhichIsA("BasePart")
                local hrp = GetHRP()
                
                if handle and hrp and handle:IsDescendantOf(Workspace) then
                    print("[TÌM TRÁI] ✅ Phát hiện: "..obj.Name.." | Đang lướt tới...")
                    
                    -- Di chuyển tới trái
                    local distance = (hrp.Position - handle.CFrame.Position).Magnitude
                    local tween = TweenService:Create(
                        hrp,
                        TweenInfo.new(distance / CONFIG.MOVE_SPEED, Enum.EasingStyle.Linear),
                        {CFrame = handle.CFrame}
                    )
                    tween:Play()
                    tween.Completed:Wait()
                    
                    -- Chờ game nhận diện bạn chạm trái
                    task.wait(1.2)
                    AutoStoreFruit()
                    print("[TÌM TRÁI] 📦 Đã cất vào kho thành công!")
                    task.wait(1) -- Chờ game cập nhật
                    return true -- Thoát, báo có nhặt được
                end
            end
        end
        task.wait(CONFIG.SCAN_INTERVAL) -- Nghỉ ngắn giữa các lần quét
    end

    print("[TÌM TRÁI] ❌ Hết thời gian, không tìm thấy trái nào")
    return false
end

-- ==========================================
-- 3. FIX HOÀN TOÀN HÀM HOP SERVER – KHÔNG BAO GIỜ ĐỨNG YÊN
-- ==========================================
local function AdvancedServerHop()
    local retries = 0 -- Đếm số lần thử hop

    -- VÒNG LẶP VÔ HẠN: thử cho đến khi chuyển server THÀNH CÔNG
    while true do
        retries += 1
        print("\n[HOP SERVER] 🔄 Lần thử thứ "..retries.."/"..CONFIG.MAX_HOP_RETRIES)

        -- Giới hạn số lần thử liên tục → nghỉ lâu để Roblox mở chặn
        if retries > CONFIG.MAX_HOP_RETRIES then
            print("[HOP SERVER] ⚠️ Đã thử quá nhiều lần → Nghỉ 20s để tránh bị chặn...")
            task.wait(20)
            retries = 0 -- Reset đếm, thử lại từ đầu
        end

        task.wait(CONFIG.DELAY_BETWEEN_HOPS)

        -- BƯỚC 1: Lấy danh sách server từ Roblox API
        local success, result = pcall(function()
            return HttpService:JSONDecode(
                game:HttpGet(
                    "https://games.roblox.com/v1/games/"..placeId.."/servers/Public?sortOrder=Asc&limit=100",
                    true -- Bật cache ngắn
                )
            )
        end)

        if not success or not result or not result.data or #result.data == 0 then
            print("[HOP SERVER] ❌ Lỗi lấy danh sách server → Thử lại ngay")
            continue -- Quay lại đầu vòng lặp, thử lại
        end

        -- BƯỚC 2: Lọc server hợp lệ (còn chỗ, không phải server hiện tại)
        local validServers = {}
        for _, sv in pairs(result.data) do
            if 
                sv.id ~= currentJobId 
                and sv.playing <= (sv.maxPlayers - CONFIG.MIN_SERVER_FREE_SLOTS)
                and type(sv.id) == "string"
            then
                table.insert(validServers, sv.id)
            end
        end

        if #validServers == 0 then
            print("[HOP SERVER] ❌ Không tìm thấy server trống → Thử lại sau 3s")
            task.wait(3)
            continue
        end

        -- BƯỚC 3: Chọn server ngẫu nhiên & thử join
        local targetServer = validServers[math.random(1, #validServers)]
        print("[HOP SERVER] 🚀 Đang join server: "..string.sub(targetServer,1,8).."...")

        local teleportStarted = os.clock()
        local teleportSuccess = false

        -- Thực thi lệnh chuyển server
        pcall(function()
            TeleportService:TeleportToPlaceInstance(placeId, targetServer, LocalPlayer)
        end)

        -- BƯỚC 4: KIỂM TRA THỰC TẾ CÓ CHUYỂN ĐƯỢC KHÔNG (ĐÂY LÀ ĐIỂM FIX CHÍNH)
        -- Chờ tối đa TELEPORT_TIMEOUT giây → nếu vẫn ở server cũ = THẤT BẠI
        while os.clock() - teleportStarted < CONFIG.TELEPORT_TIMEOUT do
            -- Nếu JobId thay đổi = đã chuyển server thành công
            if game.JobId ~= currentJobId then
                teleportSuccess = true
                break
            end
            task.wait(0.2) -- Kiểm tra mỗi 0.2s
        end

        if teleportSuccess then
            print("[HOP SERVER] ✅ Chuyển server THÀNH CÔNG!")
            return -- Thoát hàm, script sẽ chạy lại từ đầu ở server mới
        else
            print("[HOP SERVER] ❌ Thất bại (server full/đóng/lỗi mạng) → TÌM SERVER KHÁC NGAY")
            -- KHÔNG RETURN, KHÔNG DỪNG → quay lại đầu vòng while, thử lại mãi mãi
        end
    end
end

-- ==========================================
-- 4. VÒNG LẶP CHÍNH VÔ HẠN – SCRIPT CHẠY MÃI MÃI
-- ==========================================
print("\n==========================================")
print("✅ SCRIPT ĐÃ HOẠT ĐỘNG | FIXED: KHÔNG ĐỨNG YÊN")
print("==========================================\n")

-- Chạy tối ưu & chọn phe 1 lần khi vào game
MaxOptimize()
AutoSelectPirates()
task.wait(1)

-- VÒNG LẶP VÔ HẠN: Tìm trái → Không có thì hop → Lặp lại ở server mới
while true do
    -- Cập nhật JobId hiện tại mỗi vòng
    currentJobId = game.JobId

    -- BƯỚC 1: Tìm trái trong server này
    local foundFruit = SnipeFruit()

    -- BƯỚC 2: Nếu CÓ nhặt được → tiếp tục tìm thêm trái ở CÙNG SERVER NÀY
    if foundFruit then
        print("[CHÍNH] ✅ Có trái, tiếp tục quét thêm ở server này...\n")
        task.wait(1.5)
        continue -- Quay lại tìm trái tiếp, KHÔNG HOP
    end

    -- BƯỚC 3: Nếu KHÔNG CÓ trái → HOP SERVER (chạy mãi cho đến khi vào được server mới)
    print("[CHÍNH] 🚫 Server này hết trái → Bắt đầu quy trình HOP SERVER...")
    AdvancedServerHop()

    -- Khi đến đây = đã vào được server mới → Chờ load xong rồi lặp lại từ đầu
    print("[CHÍNH] 🔄 Đã vào server mới, chờ game load...\n")
    task.wait(4) -- Chờ map load xong
    AutoSelectPirates() -- Đảm bảo có phe ở server mới
end
