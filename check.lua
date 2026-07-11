-- ==========================================================
-- SCANNER V2: QUÉT DỮ LIỆU & GỬI ĐẾN DISCORD (ĐÃ SỬA LỖI)
-- ==========================================================

if not game:IsLoaded() then game.Loaded:Wait() end

-- === CẤU HÌNH ===
local DISCORD_WEBHOOK = "https://discord.com/api/webhooks/1525298599985020958/FBV9Cuc_Se2A0qvikp-hn7Sqmq2dMlUHy0QS9U0v7kQPjJOluFAzmPiTCEBylKmDjhqB" -- ⚠️ THAY BẰNG LINK WEBHOOK CỦA BẠN
local HttpService = game:GetService("HttpService")
HttpService.HttpEnabled = true -- ✅ BẬT QUYỀN GỬI DỮ LIỆU

-- === Hàm gửi dữ liệu ===
local function SendToDiscord(tieuDe, noiDung)
    if not noiDung or noiDung == "" then
        print("⚠️ Không có dữ liệu để gửi: " .. tieuDe)
        return
    end

    -- Cắt ngắn nếu quá giới hạn Discord
    if #noiDung > 1950 then
        noiDung = noiDung:sub(1, 1950) .. "\n... [Đã cắt ngắn]"
    end

    local duLieu = {
        username = "Blox Fruits Scanner",
        embeds = {{
            title = tieuDe,
            description = "```\n" .. noiDung .. "\n```",
            color = 0x0099FF
        }}
    }

    local thanhCong, loi = pcall(function()
        return HttpService:PostAsync(
            DISCORD_WEBHOOK,
            HttpService:JSONEncode(duLieu),
            Enum.HttpContentType.ApplicationJson
        )
    end)

    if thanhCong then
        print("✅ Đã gửi: " .. tieuDe)
    else
        print("❌ Lỗi gửi: " .. tieuDe .. " | Chi tiết: " .. tostring(loi))
    end
end

-- === Quét đúng vị trí Trái theo cấu trúc thực tế ===
local function QuetDoiTuongTrai()
    local ketQua = "🍎 DANH SÁCH TRÁI ÁC QUỶ:\n"
    local Workspace = game:GetService("Workspace")
    local dem = 0

    -- Theo log, trái nằm trong Workspace.Characters
    local thuMucTrai = Workspace:FindFirstChild("Characters")
    if not thuMucTrai then
        return "❌ Không tìm thấy thư mục Characters"
    end

    for _, nhom in ipairs(thuMucTrai:GetChildren()) do
        if dem >= 50 then break end

        -- Tìm các đối tượng có chứa "Fruit" trong tên
        for _, doiTuong in ipairs(nhom:GetDescendants()) do
            if doiTuong:IsA("Model") and string.find(string.lower(doiTuong.Name), "fruit") then
                local phanChinh = doiTuong:FindFirstChild("Fruit") or doiTuong:FindFirstChild("Handle") or doiTuong:FindFirstChildWhichIsA("BasePart")
                if phanChinh then
                    ketQua = ketQua .. string.format(
                        "• %s\n  Đường dẫn: %s\n  Tọa độ: (%.1f, %.1f, %.1f)\n\n",
                        doiTuong.Name,
                        doiTuong:GetFullName(),
                        phanChinh.Position.X, phanChinh.Position.Y, phanChinh.Position.Z
                    )
                    dem = dem + 1
                end
            end
        end
    end

    return ketQua ~= "" and ketQua or "Không tìm thấy trái nào trong lần quét này"
end

-- === Quét RemoteFunction/Event ===
local function QuetRemote()
    local ketQua = "🔌 DANH SÁCH REMOTE:\n"
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local dem = 0

    local function TimRemote(cha)
        if not cha or dem >= 50 then return end
        for _, con in ipairs(cha:GetChildren()) do
            if con:IsA("RemoteFunction") or con:IsA("RemoteEvent") then
                ketQua = ketQua .. string.format("• %s | Loại: %s\n", con.Name, con.ClassName)
                dem = dem + 1
            elseif con:IsA("Folder") then
                TimRemote(con)
            end
        end
    end

    TimRemote(ReplicatedStorage)
    return ketQua
end

-- === CHẠY QUÉT ===
task.spawn(function()
    print("🔍 Bắt đầu quét dữ liệu...")
    task.wait(2)

    SendToDiscord("🔌 DANH SÁCH REMOTE", QuetRemote())
    task.wait(1.5)

    SendToDiscord("🍎 THÔNG TIN TRÁI ÁC QUỶ", QuetDoiTuongTrai())
    task.wait(1.5)

    SendToDiscord("✅ TRẠNG THÁI", "Hoàn tất quét dữ liệu thành công!")
    print("✅ Đã hoàn thành tất cả thao tác")
end)
