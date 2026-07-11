-- ==========================================================
-- SCANNER DATA: QUÉT CẤU TRÚC GAME & GỬI LÊN DISCORD WEBHOOK
-- Chạy 1 lần, tự tắt sau khi gửi xong
-- ==========================================================

if not game:IsLoaded() then game.Loaded:Wait() end

-- === CẤU HÌNH ===
local DISCORD_WEBHOOK = "https://discord.com/api/webhooks/1525298599985020958/FBV9Cuc_Se2A0qvikp-hn7Sqmq2dMlUHy0QS9U0v7kQPjJOluFAzmPiTCEBylKmDjhqB" -- << THAY BẰNG LINK WEBHOOK CỦA BẠN
local MAX_DEPTH = 3 -- Độ sâu quét thư mục (không quá sâu để tránh quá tải)
local MAX_ITEMS_PER_TYPE = 50 -- Giới hạn số lượng đối tượng gửi để không quá dài

-- === Dịch vụ ===
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

-- === Hàm gửi dữ liệu lên Discord ===
local function SendToDiscord(title, content)
    -- Cắt ngắn nếu quá 1900 ký tự (giới hạn Discord)
    if #content > 1900 then
        content = content:sub(1, 1900) .. "\n... [Đã cắt ngắn do quá dài]"
    end

    local payload = {
        username = "Blox Fruits Scanner",
        embeds = {{
            title = title,
            description = "```\n" .. content .. "\n```",
            color = 3447003 -- Màu xanh dương
        }}
    }

    pcall(function()
        HttpService:PostAsync(
            DISCORD_WEBHOOK,
            HttpService:JSONEncode(payload),
            Enum.HttpContentType.ApplicationJson
        )
        print("✅ Đã gửi: " .. title)
    end)
end

-- === Quét cấu trúc thư mục & đối tượng ===
local function ScanInstance(instance, depth, prefix)
    depth = depth or 0
    prefix = prefix or ""
    if depth > MAX_DEPTH then return "" end

    local result = ""
    for _, child in ipairs(instance:GetChildren()) do
        result = result .. prefix .. "- " .. child.Name .. " (" .. child.ClassName .. ")\n"
        -- Chỉ đi sâu nếu là thư mục/đối tượng chứa
        if child:IsA("Folder") or child:IsA("Model") or child:IsA("ReplicatedStorage") then
            result = result .. ScanInstance(child, depth + 1, prefix .. "  ")
        end
    end
    return result
end

-- === Quét tìm tất cả đối tượng liên quan đến Trái ===
local function ScanFruits()
    local result = "📦 DANH SÁCH ĐỐI TƯỢNG LIÊN QUAN TRÁI:\n"
    local count = 0

    for _, obj in ipairs(Workspace:GetDescendants()) do
        if count >= MAX_ITEMS_PER_TYPE then break end
        local name = string.lower(obj.Name)
        if string.find(name, "fruit") or string.find(name, "trái") or string.find(name, "devil") then
            local handle = obj:FindFirstChild("Handle") or obj:FindFirstChildWhichIsA("BasePart")
            result = result .. string.format(
                "• %s | Loại: %s | Vị trí: (%.1f, %.1f, %.1f) | Kích thước: (%.1f, %.1f, %.1f)\n",
                obj.Name,
                obj.ClassName,
                handle and handle.Position.X or 0,
                handle and handle.Position.Y or 0,
                handle and handle.Position.Z or 0,
                handle and handle.Size.X or 0,
                handle and handle.Size.Y or 0,
                handle and handle.Size.Z or 0
            )
            count = count + 1
        end
    end
    return result
end

-- === Quét tất cả RemoteFunction/RemoteEvent ===
local function ScanRemotes()
    local result = "🔌 DANH SÁCH REMOTE FUNCTION/EVENT:\n"
    local count = 0

    local function ScanRemotesIn(parent)
        if not parent or count >= MAX_ITEMS_PER_TYPE then return end
        for _, obj in ipairs(parent:GetChildren()) do
            if obj:IsA("RemoteFunction") or obj:IsA("RemoteEvent") then
                result = result .. string.format("• %s | Loại: %s | Đường dẫn: %s\n",
                    obj.Name, obj.ClassName, obj:GetFullName())
                count = count + 1
            elseif obj:IsA("Folder") or obj:IsA("ReplicatedStorage") then
                ScanRemotesIn(obj)
            end
        end
    end

    ScanRemotesIn(ReplicatedStorage)
    return result
end

-- === CHẠY QUÉT TẤT CẢ & GỬI ===
task.spawn(function()
    print("🔍 Bắt đầu quét dữ liệu game...")
    task.wait(2)

    -- 1. Quét cấu trúc thư mục chính
    SendToDiscord("📂 CẤU TRÚC REPLICATED STORAGE", ScanInstance(ReplicatedStorage))
    task.wait(1)

    -- 2. Quét danh sách Remote
    SendToDiscord("🔌 DANH SÁCH REMOTE", ScanRemotes())
    task.wait(1)

    -- 3. Quét đối tượng liên quan trái
    SendToDiscord("🍎 ĐỐI TƯỢNG LIÊN QUAN TRÁI", ScanFruits())
    task.wait(1)

    -- 4. Thông báo hoàn thành
    SendToDiscord("✅ TRẠNG THÁI", "Đã quét & gửi toàn bộ dữ liệu thành công! Script tự kết thúc.")
    print("✅ Hoàn tất quá trình quét & gửi dữ liệu.")
end)
