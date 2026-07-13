-- HOOK NÂNG CẤP: Bắt toàn bộ Upvalue & Dispatcher
local full_log = {}

local function add_log(text)
    local line = string.format("[%s] %s", os.date("%H:%M:%S"), text)
    table.insert(full_log, line)
    print(line)
end

-- Tạo GUI xem log
pcall(function()
    local Gui = Instance.new("ScreenGui")
    Gui.Name = "LuraphHookLog"
    Gui.Parent = game.CoreGui
    Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 600, 0, 450)
    Frame.Position = UDim2.new(0.01,0,0.01,0)
    Frame.BackgroundColor3 = Color3.fromRGB(15,15,15)
    Frame.ClipsDescendants = true
    Frame.Parent = Gui

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1,0,0,35)
    Title.BackgroundColor3 = Color3.fromRGB(35,35,35)
    Title.Text = "📋 LOG CHI TIẾT LURAPH VM"
    Title.TextColor3 = Color3.new(1,1,1)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 15
    Title.Parent = Frame

    LogText = Instance.new("TextBox")
    LogText.Size = UDim2.new(1,-10,1,-45)
    LogText.Position = UDim2.new(0,5,0,40)
    LogText.BackgroundTransparency = 1
    LogText.TextColor3 = Color3.new(0.95,0.95,0.95)
    LogText.Font = Enum.Font.Code
    LogText.TextSize = 10
    LogText.TextXAlignment = Enum.TextXAlignment.Left
    LogText.TextYAlignment = Enum.TextYAlignment.Top
    LogText.MultiLine = true
    LogText.TextWrapped = true
    LogText.Parent = Frame
end)

add_log("=== BẮT ĐẦU PHÂN TÍCH CHI TIẾT ===")

-- Hook setfenv + trích xuất đầy đủ Upvalue
local original_setfenv = setfenv
getgenv().setfenv = function(f, env)
    if type(f) == "function" then
        add_log("\n[HOOK] === KHỞI TẠO HÀM VM ===")
        add_log(string.format("  Địa chỉ hàm: %s", tostring(f)))
        add_log(string.format("  Môi trường áp dụng: %s", tostring(env)))

        -- Quét toàn bộ Upvalue kể cả ẩn danh
        local i = 1
        while true do
            local name, val = debug.getupvalue(f, i)
            if not name then break end
            add_log(string.format("\n  • Upvalue #%d: Tên = %s", i, name or "ẨN DANH"))
            add_log(string.format("    Loại: %s | Giá trị: %s", type(val), tostring(val)))
            
            -- Nếu là bảng (hằng số/opcode)
            if type(val) == "table" then
                add_log("    --- NỘI DUNG BẢNG ---")
                for k, v in pairs(val) do
                    add_log(string.format("      [%s] = %s", tostring(k), tostring(v)))
                end
            end
            i += 1
        end
    end
    return original_setfenv(f, env)
end

-- Hook toàn bộ hàm bit32 để bắt mọi phép tính trạng thái
local original_bit32 = table.clone(bit32)
getgenv().bit32 = setmetatable({}, {
    __index = function(t, k)
        return function(...)
            local res = original_bit32[k](...)
            local args = {...}
            -- Ghi log phép tính liên quan đến số lớn > 0xFFFF
            if k == "bxor" and #args >=2 then
                local a, b = args[1], args[2]
                if type(a)=="number" and type(b)=="number" and (a>0xFFFF or b>0xFFFF) then
                    add_log(string.format("[DISPATCHER] %s(%#X, %#X) = %#X", k, a, b, res))
                end
            end
            return res
        end
    end
})

-- Chờ đủ 15 giây để chạy hết logic
add_log("\n⏳ Đang chờ thực thi toàn bộ logic...")
task.wait(15)

-- Cập nhật GUI & kết thúc
if LogText then LogText.Text = table.concat(full_log, "\n") end
add_log("\n✅ HOÀN THÀNH! Bôi đen toàn bộ log → Ctrl+C → Lưu thành runtime_log.txt")
add_log("Tổng số dòng log: "..#full_log)
