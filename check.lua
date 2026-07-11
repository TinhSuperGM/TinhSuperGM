-- ==========================================================
-- SCANNER V3: QUÉT & GỬI DỮ LIỆU ĐẾN DISCORD
-- ==========================================================

-- Bật quyền TRƯỚC KHI làm gì khác
local HttpService = game:GetService("HttpService")
HttpService.HttpEnabled = true

if not game:IsLoaded() then
    print("⏳ Đang chờ game tải xong...")
    game.Loaded:Wait()
end

-- === CẤU HÌNH ===
local DISCORD_WEBHOOK = "https://discord.com/api/webhooks/1525298599985020958/FBV9Cuc_Se2A0qvikp-hn7Sqmq2dMlUHy0QS9U0v7kQPjJOluFAzmPiTCEBylKmDjhqB" -- ⚠️ THAY BẰNG LINK CỦA BẠN
local MAX_ITEMS = 30
local DELAY_BETWEEN_SEND = 2 -- giây

-- === Hàm gửi dữ liệu an toàn ===
local function SendEmbed(title, content)
    if not content or content == "" then
        print("ℹ️ Bỏ qua: " .. title .. " (không có dữ liệu)")
        return false
    end

    -- Cắt xuống dưới 1900 ký tự, đúng giới hạn Discord
    if #content > 1900 then
        content = content:sub(1, 1900) .. "\n... [cắt ngắn]"
    end

    local payload = {
        username = "Blox Fruits Scanner",
        embeds = {{
            title = title,
            description = "```\n" .. content .. "\n```",
            color = 3066993 -- Màu xanh lá dễ nhìn
        }}
    }

    local ok, err = pcall(function()
        return HttpService:PostAsync(
            DISCORD_WEBHOOK,
            HttpService:JSONEncode(payload),
            Enum.HttpContentType.ApplicationJson
        )
    end)

    if ok then
        print("✅ Đã gửi thành công: " .. title)
        return true
    else
        print("❌ Gửi thất bại: " .. title .. " | Lỗi: " .. tostring(err))
        return false
    end
end

-- === Quét Trái theo đường dẫn đúng từ log ===
local function ScanFruits()
    local res = "🍎 DANH SÁCH TRÁI:\n"
    local count = 0
    local chars = Workspace:FindFirstChild("Characters")
    if not chars then return "❌ Không tìm thấy thư mục Characters" end

    for _, group in ipairs(chars:GetChildren()) do
        if count >= MAX_ITEMS then break end
        for _, obj in ipairs(group:GetDescendants()) do
            if obj:IsA("Model") and string.find(string.lower(obj.Name), "fruit") then
                local part = obj:FindFirstChild("Fruit") or obj:FindFirstChild("Handle") or obj:FindFirstChildWhichIsA("BasePart")
                if part then
                    res = res .. string.format(
                        "• %s\n  Đường dẫn: %s\n  Tọa độ: %.1f, %.1f, %.1f\n\n",
                        obj.Name,
                        obj:GetFullName(),
                        part.Position.X, part.Position.Y, part.Position.Z
                    )
                    count += 1
                end
            end
        end
    end
    return res ~= "" and res or "Không tìm thấy trái trong lần quét này"
end

-- === Quét Remote ===
local function ScanRemotes()
    local res = "🔌 REMOTE FUNCTION/EVENT:\n"
    local count = 0
    local rs = ReplicatedStorage

    local function Scan(parent)
        if not parent or count >= MAX_ITEMS then return end
        for _, c in ipairs(parent:GetChildren()) do
            if c:IsA("RemoteFunction") or c:IsA("RemoteEvent") then
                res = res .. string.format("• %s | %s\n", c.Name, c.ClassName)
                count += 1
            elseif c:IsA("Folder") then
                Scan(c)
            end
        end
    end

    Scan(rs)
    return res
end

-- === Chạy tất cả ===
task.spawn(function()
    print("🔍 Bắt đầu quét dữ liệu...")
    task.wait(2)

    SendEmbed("🔌 DANH SÁCH REMOTE", ScanRemotes())
    task.wait(DELAY_BETWEEN_SEND)

    SendEmbed("🍎 THÔNG TIN TRÁI ÁC QUỶ", ScanFruits())
    task.wait(DELAY_BETWEEN_SEND)

    SendEmbed("✅ TRẠNG THÁI", "Quét & gửi dữ liệu hoàn tất!")
    print("✅ Toàn bộ quá trình kết thúc")
end)
