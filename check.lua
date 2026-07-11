-- ==========================================================
-- SCANNER: QUÉT & IN DỮ LIỆU RA CONSOLE
-- HTTP bị chặn → không gửi Discord, chỉ hiển thị trực tiếp
-- ==========================================================

if not game:IsLoaded() then
    print("⏳ Đang chờ game tải xong...")
    game.Loaded:Wait()
end

local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MAX_ITEMS = 30

-- === Quét danh sách RemoteFunction / RemoteEvent ===
local function ScanRemotes()
    print("\n========== 📋 DANH SÁCH REMOTE ==========")
    local count = 0
    local function Scan(parent)
        if not parent or count >= MAX_ITEMS then return end
        for _, child in ipairs(parent:GetChildren()) do
            if child:IsA("RemoteFunction") or child:IsA("RemoteEvent") then
                print(string.format("• %s | Loại: %s | Đường dẫn: %s",
                    child.Name, child.ClassName, child:GetFullName()))
                count += 1
            elseif child:IsA("Folder") then
                Scan(child)
            end
        end
    end
    Scan(ReplicatedStorage)
    print("==========================================\n")
end

-- === Quét Trái Ác Quỷ theo cấu trúc đúng ===
local function ScanFruits()
    print("\n========== 🍎 DANH SÁCH TRÁI ÁC QUỶ ==========")
    local chars = Workspace:FindFirstChild("Characters")
    if not chars then
        print("❌ Không tìm thấy thư mục Characters")
        return
    end

    local count = 0
    for _, group in ipairs(chars:GetChildren()) do
        if count >= MAX_ITEMS then break end
        for _, obj in ipairs(group:GetDescendants()) do
            if obj:IsA("Model") and string.find(string.lower(obj.Name), "fruit") then
                local part = obj:FindFirstChild("Fruit") or obj:FindFirstChild("Handle") or obj:FindFirstChildWhichIsA("BasePart")
                if part then
                    print(string.format(
                        "• Tên: %s\n  Đường dẫn: %s\n  Tọa độ: (%.1f, %.1f, %.1f)\n  Kích thước: (%.1f, %.1f, %.1f)\n",
                        obj.Name,
                        obj:GetFullName(),
                        part.Position.X, part.Position.Y, part.Position.Z,
                        part.Size.X, part.Size.Y, part.Size.Z
                    ))
                    count += 1
                end
            end
        end
    end
    print("==============================================\n")
end

-- === Chạy quét ===
task.spawn(function()
    print("🔍 Bắt đầu quét dữ liệu...")
    task.wait(2)
    ScanRemotes()
    task.wait(1)
    ScanFruits()
    print("✅ Hoàn tất quét! Xem chi tiết ở trên.")
end)
