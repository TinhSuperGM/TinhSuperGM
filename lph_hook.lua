-- HOOK LURAPH v14.5.2 | PHIÊN BẢN GHI LOG ĐA PHƯƠNG ÁN
-- Hỗ trợ mọi executor: ghi file, hiển thị GUI, chép bộ nhớ, gửi webhook

-- ================= CẤU HÌNH =================
local FILE_NAME = "lph_log_result.txt"
local WEBHOOK_URL = "" -- Dán link webhook Discord vào đây nếu muốn gửi qua mạng
local SHOW_GUI = true -- Hiển thị cửa sổ xem log ngay trong game
local AUTO_COPY = true -- Tự động chép toàn bộ log vào bộ nhớ đệm khi kết thúc
-- ==============================================

-- Lưu dữ liệu tạm trong bộ nhớ
local full_log = {}
local transitions = {}

-- === HÀM GHI LOG TỔNG HỢP ===
local function add_log(text)
    local line = string.format("[%s] %s", os.date("%H:%M:%S"), text)
    table.insert(full_log, line)
    print(line) -- Luôn in ra console để kiểm tra nhanh

    -- 1. Ghi ra file nếu executor hỗ trợ
    if pcall(writefile, FILE_NAME, table.concat(full_log, "\n")) then
        -- Ghi thành công
    end

    -- 2. Gửi qua webhook nếu có cấu hình
    if WEBHOOK_URL ~= "" and #full_log % 10 == 0 then -- Gửi mỗi 10 dòng để không bị chặn
        task.spawn(function()
            pcall(game.HttpService.PostAsync, game.HttpService, WEBHOOK_URL, game.HttpService:JSONEncode({
                content = "```"..table.concat(full_log, "\n").."```"
            }))
        end)
    end

    -- 3. Cập nhật giao diện nếu đang bật
    if SHOW_GUI and LogText then
        LogText.Text = table.concat(full_log, "\n")
    end
end

-- === TẠO GIAO DIỆN XEM LOG NGAY TRONG GAME ===
if SHOW_GUI then
    pcall(function()
        local Gui = Instance.new("ScreenGui")
        Gui.Name = "LuraphHookLog"
        Gui.Parent = game.CoreGui
        Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

        local Frame = Instance.new("Frame")
        Frame.Size = UDim2.new(0, 550, 0, 400)
        Frame.Position = UDim2.new(0.02, 0, 0.02, 0)
        Frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
        Frame.BorderSizePixel = 0
        Frame.ClipsDescendants = true
        Frame.Parent = Gui

        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(1,0,0,32)
        Title.BackgroundColor3 = Color3.fromRGB(40,40,40)
        Title.Text = "📋 NHẬT KÝ PHÂN TÍCH LURAPH"
        Title.TextColor3 = Color3.new(1,1,1)
        Title.Font = Enum.Font.GothamBold
        Title.TextSize = 14
        Title.Parent = Frame

        LogText = Instance.new("TextBox")
        LogText.Size = UDim2.new(1,-10,1,-42)
        LogText.Position = UDim2.new(0,5,0,37)
        LogText.BackgroundTransparency = 1
        LogText.TextColor3 = Color3.new(0.9,0.9,0.9)
        LogText.Font = Enum.Font.Code
        LogText.TextSize = 11
        LogText.TextXAlignment = Enum.TextXAlignment.Left
        LogText.TextYAlignment = Enum.TextYAlignment.Top
        LogText.MultiLine = true
        LogText.TextWrapped = true
        LogText.Parent = Frame
    end)
end

-- === BẮT ĐẦU HOOK ===
add_log("=== BẮT ĐẦU PHÂN TÍCH LURAPH v14.5.2 ===")

-- Hook setfenv bắt khởi tạo hàm ảo & Upvalues
local original_setfenv = setfenv
getgenv().setfenv = function(f, env)
    if type(f) == "function" then
        add_log("\n[HOOK] Phát hiện khởi tạo hàm VM!")
        
        local i = 1
        while true do
            local name, val = debug.getupvalue(f, i)
            if not name then break end
            
            add_log(string.format("  Upvalue #%d: %s = %s", i, name or "Ẩn danh", tostring(val)))
            
            if type(val) == "table" then
                add_log("    -> Nội dung bảng:")
                for k, v in pairs(val) do
                    add_log(string.format("       [%s] = %s", tostring(k), tostring(v)))
                end
            end
            i += 1
        end
    end
    return original_setfenv(f, env)
end

-- Hook bit32.bxor bắt chuyển trạng thái Dispatcher
local original_bxor = bit32.bxor
getgenv().bit32.bxor = function(a, b)
    local res = original_bxor(a, b)
    if type(a) == "number" and type(b) == "number" and (a > 0xFFFF or b > 0xFFFF) then
        add_log(string.format("[TRẠNG THÁI] %#X ^ %#X => %#X", a, b, res))
        table.insert(transitions, {from = a, to = res})
    end
    return res
end

-- === KẾT THÚC & LƯU DỮ LIỆU ===
task.wait(8) -- Chờ đủ thời gian chạy toàn bộ logic

add_log("\n=== TỔNG HỢP KẾT QUẢ ===")
add_log(string.format("Tổng số dòng log: %d", #full_log))
add_log(string.format("Số bước chuyển trạng thái: %d", #transitions))

-- Tự động chép vào bộ nhớ đệm
if AUTO_COPY then
    pcall(setclipboard, table.concat(full_log, "\n"))
    add_log("✅ ĐÃ CHÉP TOÀN BỘ LOG VÀO BỘ NHỚ ĐỆM! Dán ra Notepad để xem nhé.")
end

-- Lưu lần cuối để đảm bảo không mất dữ liệu
pcall(writefile, FILE_NAME, table.concat(full_log, "\n"))
add_log(string.format("✅ ĐÃ LƯU FILE: %s (nếu được hỗ trợ)", FILE_NAME))
add_log("=== HOÀN THÀNH ===")
