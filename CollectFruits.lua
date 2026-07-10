-- ==========================================
-- SCRIPT NHẶT + TỰ STORE TRÁI (UPDATE 10/7/2026)
-- ==========================================

-- Thêm hàm Store Trái Ác Quỷ
local function AutoStoreFruit()
    print("Đang gửi lệnh cất trái vào kho...")
    local args = {
        [1] = "StoreFruit" -- RemoteEvent chuẩn của Blox Fruits để Store
    }
    -- Gọi tới CommF_ để cất trái
    ReplicatedStorage.Remotes.CommF_:InvokeServer(unpack(args))
end

-- Cập nhật lại hàm SnipeFruit để lụm xong là Store luôn
local function SnipeFruit()
    for _, obj in pairs(Workspace:GetChildren()) do
        if obj:IsA("Model") and string.match(obj.Name, "Fruit") then
            local handle = obj:FindFirstChild("Handle") or obj:FindFirstChildWhichIsA("BasePart")
            if handle then
                print("Tìm thấy trái: " .. obj.Name .. "! Đang lướt lại lụm...")
                SafeTween(handle.CFrame)
                task.wait(1)
                
                -- GỌI LỆNH CẤT TRÁI VÀO KHO TẠI ĐÂY
                AutoStoreFruit() 
                
                print("Đã cất trái vào kho thành công!")
                return true
            end
        end
    end
    return false
end
