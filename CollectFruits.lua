if not game:IsLoaded() then game.Loaded:Wait() end

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local placeId = game.PlaceId
local BlacklistedServers = {}
local NoClipConnection = nil
local ApiErrorCount = 0

local FruitPriority = {
    ["gravity"] = 5, ["mammoth"] = 5, ["trex"] = 5, ["t-rex"] = 5, ["dough"] = 5,
    ["shadow"] = 5, ["venom"] = 5, ["gas"] = 5, ["spirit"] = 5, ["tiger"] = 5,
    ["yeti"] = 5, ["kitsune"] = 5, ["control"] = 5, ["dragon"] = 5,
    ["quake"] = 4, ["buddha"] = 4, ["love"] = 4, ["creation"] = 4, ["spider"] = 4,
    ["sound"] = 4, ["phoenix"] = 4, ["portal"] = 4, ["lightning"] = 4, ["pain"] = 4,
    ["blizzard"] = 4,
    ["light"] = 3, ["rubber"] = 3, ["ghost"] = 3, ["magma"] = 3,
    ["flame"] = 2, ["ice"] = 2, ["sand"] = 2, ["dark"] = 2, ["eagle"] = 2, ["diamond"] = 2,
    ["rocket"] = 1, ["spin"] = 1, ["blade"] = 1, ["spring"] = 1, ["bomb"] = 1, ["smoke"] = 1, ["spike"] = 1
}

local function GetCommF()
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    if remotes then
        local exact = remotes:FindFirstChild("CommF_")
        if exact then return exact end
        for _, obj in pairs(remotes:GetChildren()) do
            if obj:IsA("RemoteFunction") then return obj end
        end
    end
    return nil
end

local function AutoSelectPirates()
    local attempts = 0
    while (LocalPlayer.Team == nil or LocalPlayer.Team.Name ~= "Pirates") and attempts < 10 do
        attempts = attempts + 1
        print("Đang quét dữ liệu và ép chọn phe Hải Tặc (Lần " .. attempts .. ")...")
        
        pcall(function()
            local commF = GetCommF()
            if commF then
                task.wait(0.2 + math.random() * 0.3)
                commF:InvokeServer("SetTeam", "Pirates")
            end
            
            local playerGui = LocalPlayer:FindFirstChildWhichIsA("PlayerGui")
            local mainGui = playerGui and playerGui:FindFirstChild("Main")
            local chooseTeam = mainGui and mainGui:FindFirstChild("ChooseTeam")
            if chooseTeam and chooseTeam.Visible then
                chooseTeam.Visible = false
            end
        end)
        task.wait(1.5)
    end
end

local function AutoStoreFruit()
    pcall(function()
        local commF = GetCommF()
        if commF then
            task.wait(0.3 + math.random() * 0.4)
            commF:InvokeServer("StoreFruit")
            print("Đã thực thi cất giấu trái ác quỷ vào kho.")
        end
    end)
end

local function StartNoClip()
    if NoClipConnection then NoClipConnection:Disconnect() end
    NoClipConnection = RunService.Stepped:Connect(function()
        if LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end)
end

local function StopNoClip()
    if NoClipConnection then NoClipConnection:Disconnect() NoClipConnection = nil end
    pcall(function()
        if LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = true end
            end
        end
    end)
end

local function SafeMoveTo(targetCFrame)
    local character = LocalPlayer.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = character and character:FindFirstChildWhichIsA("Humanoid")
    
    if not hrp or not humanoid or humanoid.Health <= 0 then return end
    
    StartNoClip()
    humanoid:ChangeState(Enum.HumanoidStateType.Physics)
    
    local speed = 125 
    while (hrp.Position - targetCFrame.Position).Magnitude > 5 do
        if not LocalPlayer.Character or not hrp:IsDescendantOf(LocalPlayer.Character) or humanoid.Health <= 0 then 
            break 
        end
        
        local currentPos = hrp.Position
        local targetPos = targetCFrame.Position
        local direction = (targetPos - currentPos).Unit
        local distance = (targetPos - currentPos).Magnitude
        
        local step = math.min(distance, speed * RunService.Heartbeat:Wait())
        hrp.CFrame = CFrame.new(currentPos + direction * step)
        hrp.Velocity = Vector3.new(0, 0, 0)
    end
    
    if hrp and humanoid and humanoid.Health > 0 then
        hrp.CFrame = targetCFrame
        task.wait(0.2)
        humanoid:ChangeState(Enum.HumanoidStateType.Running)
    end
    StopNoClip()
end

local function SnipeFruit()
    local startTime = tick()
    
    while true do
        if tick() - startTime > 60 then
            print("Đã hết 60s thời gian vàng tại server này. Rút lui!")
            break
        end

        local character = LocalPlayer.Character
        local humanoid = character and character:FindFirstChildWhichIsA("Humanoid")
        if not character or not humanoid or humanoid.Health <= 0 then
            task.wait(2)
            continue
        end

        local fruitsFound = {}
        local allObjects = Workspace:GetDescendants()
        
        for _, obj in pairs(allObjects) do
            if obj:IsA("Model") and not Players:GetPlayerFromCharacter(obj) then
                local objName = string.lower(obj.Name)
                
                if string.find(objName, "fruit") or string.find(objName, "trái") or FruitPriority[objName] then
                    local currentPriority = 0
                    
                    for fruitName, priority do
                        if string.find(objName, fruitName) then 
                            currentPriority = priority 
                            break 
                        end
                    end
                    
                    if currentPriority == 0 and (obj:FindFirstChild("Handle") or obj:FindFirstChildWhichIsA("BasePart")) then
                        currentPriority = 1
                    end
                    
                    if currentPriority > 0 then
                        local handle = obj:FindFirstChild("Handle") or obj:FindFirstChildWhichIsA("BasePart")
                        if handle then
                            table.insert(fruitsFound, {
                                model = obj,
                                handle = handle,
                                priority = currentPriority
                            })
                        end
                    end
                end
            end
        end
        
        if #fruitsFound == 0 then 
            print("Không phát hiện bất kỳ trái ác quỷ nào ẩn giấu trên server này.")
            break 
        end
        
        table.sort(fruitsFound, function(a, b)
            return a.priority > b.priority
        end)
        
        local target = fruitsFound[1]
        print("Tiến hành thu hoạch mục tiêu: " .. target.model.Name .. " [Mức ưu tiên: " .. target.priority .. "]")
        SafeMoveTo(target.handle.CFrame)
        
        task.wait(1 + math.random() * 0.5) 
        AutoStoreFruit()
        task.wait(1 + math.random() * 0.5)
    end
end

local function TryServerHop()
    local waitTime = 3 + (ApiErrorCount * 3)
    if waitTime > 15 then waitTime = 15 end
    task.wait(waitTime)
    
    local oldJobId = game.JobId
    print("Đang truy xuất cổng dữ liệu danh sách máy chủ công khai...")
    
    local success, result = pcall(function() 
        return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100")) 
    end)
    
    if success and result and result.data and type(result.data) == "table" then 
        ApiErrorCount = 0 
        local validServers = {}
        
        for _, server in pairs(result.data) do
            if server.playing and server.maxPlayers and server.playing < (server.maxPlayers - 5) and server.id ~= oldJobId and not BlacklistedServers[server.id] then
                table.insert(validServers, server.id)
            end
        end
        
        if #validServers > 0 then
            local randomServer = validServers[math.random(1, #validServers)]
            print("Tìm thấy vùng trống lý tưởng. Thực thi Teleport tới: " .. randomServer)
            
            StopNoClip()
            local joinSuccess, err = pcall(function() 
                TeleportService:TeleportToPlaceInstance(placeId, randomServer, LocalPlayer) 
            end)
            
            task.wait(10)
            
            if game.JobId == oldJobId then
                print("[TELEPORT FAIL] Lệnh thực thi thành công nhưng bị kẹt lại máy chủ cũ! Ghi danh sách đen và hủy...")
                BlacklistedServers[randomServer] = true
                return false
            else
                return true
            end
        else
            print("Toàn bộ danh sách server bị nghẽn hoặc đầy. Đang làm mới bộ nhớ ghi chú...")
            BlacklistedServers = {}
            return false
        end
    else
        ApiErrorCount = ApiErrorCount + 1
        print("[API ERROR] Tần suất yêu cầu quá cao hoặc nghẽn mạng (Lỗi lần: " .. ApiErrorCount .. "). Lùi nhịp nghỉ...")
        return false
    end
end

task.spawn(function()
    while true do
        print("[MASTER ENGINE V3] Khởi động guồng quay chu kỳ mới...")
        
        pcall(AutoSelectPirates)
        task.wait(0.5)
        
        pcall(SnipeFruit)
        task.wait(0.5)
        
        print("[MASTER ENGINE V3] Tiến hành kích hoạt quy trình Hop Server có kiểm định...")
        local hopSuccess = TryServerHop()
        
        if not hopSuccess then
            print("[MASTER RESCUE] Hệ thống phát hiện đổi server thất bại hoặc nghẽn API! Giải phóng RAM và chạy lại vòng quay...")
            pcall(function() collectgarbage("collect") end)
            task.wait(2)
        end
    end
end)
