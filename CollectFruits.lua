-- ==========================================
-- SCRIPT HOP SERVER SIÊU BỀN (TỰ QUÉT ĐẾN KHI VÀO ĐƯỢC)
-- ==========================================

local function AdvancedServerHop()
    print("Đang quét server mới...")
    task.wait(3) -- Delay 3s theo ý ní
    
    local success, result = pcall(function()
        return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100"))
    end)
    
    if not success or not result or not result.data then
        print("Lỗi API, đang thử lại sau 2s...")
        task.wait(2)
        return AdvancedServerHop() -- Tự gọi lại hàm để quét tiếp
    end
    
    -- Danh sách server lọc theo độ trống
    local validServers = {}
    for _, server in pairs(result.data) do
        if server.playing < (server.maxPlayers - 4) and server.id ~= game.JobId then
            table.insert(validServers, server.id)
        end
    end
    
    if #validServers > 0 then
        -- Random lấy 1 cái trong danh sách server ngon
        local randomServer = validServers[math.random(1, #validServers)]
        print("Đang cố gắng join server: " .. randomServer)
        
        -- Dùng pcall để nếu join lỗi thì nó vẫn chạy tiếp hàm dưới
        local successJoin, err = pcall(function()
            TeleportService:TeleportToPlaceInstance(placeId, randomServer, LocalPlayer)
        end)
        
        if not successJoin then
            print("Join lỗi (" .. tostring(err) .. "), đang tìm server thay thế...")
            task.wait(2)
            return AdvancedServerHop() -- Ép nó tìm server khác ngay
        end
    else
        print("Không có server đủ trống, đang thử lại sau 2s...")
        task.wait(2)
        AdvancedServerHop()
    end
end
