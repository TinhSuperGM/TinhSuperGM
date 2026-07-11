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

local function AutoSelectPirates()
    while LocalPlayer.Team == nil or LocalPlayer.Team.Name ~= "Pirates" do
        print("Đang ép hệ thống chọn phe Hải Tặc...")
        pcall(function()
            ReplicatedStorage.Remotes.CommF_:InvokeServer("SetTeam", "Pirates")
            
            local playerGui = LocalPlayer:FindFirstChildWhichIsA("PlayerGui")
            if playerGui then
                local mainGui = playerGui:FindFirstChild("Main")
                local chooseTeam = mainGui and mainGui:FindFirstChild("ChooseTeam")
                if chooseTeam and chooseTeam.Visible then
                    chooseTeam.Visible = false
                end
            end
        end)
        task.wait(1.5)
    end
    print("Chọn phe Hải Tặc thành công! Chờ nhân vật hồi sinh...")
    if not LocalPlayer.Character then LocalPlayer.CharacterAdded:Wait() end
    task.wait(1)
end

local function AutoStoreFruit()
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    local commF = remotes and remotes:FindFirstChild("CommF_")
    if commF then
        pcall(function() commF:InvokeServer("StoreFruit") end)
    end
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
end

local function SafeMoveTo(targetCFrame)
    local character = LocalPlayer.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = character and character:FindFirstChildWhichIsA("Humanoid")
    if not hrp or not humanoid then return end
    
    StartNoClip()
    humanoid:ChangeState(Enum.HumanoidStateType.Physics)
    
    local speed = 250
    while (hrp.Position - targetCFrame.Position).Magnitude > 5 do
        if not LocalPlayer.Character or not hrp:IsDescendantOf(LocalPlayer.Character) then break end
        
        local currentPos = hrp.Position
        local targetPos = targetCFrame.Position
        local direction = (targetPos - currentPos).Unit
        local distance = (targetPos - currentPos).Magnitude
        
        local step = math.min(distance, speed * RunService.Heartbeat:Wait())
        hrp.CFrame = CFrame.new(currentPos + direction * step)
        
        hrp.Velocity = Vector3.new(0, 0, 0)
    end
    
    hrp.CFrame = targetCFrame
    task.wait(0.2)
    humanoid:ChangeState(Enum.HumanoidStateType.Running)
    StopNoClip()
end

local function SnipeFruit()
    local startTime = tick()
    print("Bắt đầu quy trình quét tìm trái ác quỷ...")
    
    while true do
        if tick() - startTime > 60 then
            print("Đã hết 60 giây quy định! Tự động kích hoạt chuyển vùng để tối ưu hóa thời gian...")
            break
        end

        local fruitsFound = {}
        local children = Workspace:GetChildren()
        
        for _, obj in pairs(children) do
            if obj:IsA("Model") and obj.Parent == Workspace and not Players:GetPlayerFromCharacter(obj) then
                local objName = string.lower(obj.Name)
                local currentPriority = 0
                
                for fruitName, priority in pairs(FruitPriority) do
                    if string.find(objName, fruitName) then 
                        currentPriority = priority 
                        break 
                    end
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
        
        if #fruitsFound == 0 then 
            print("Sạch bóng trái ác quỷ trên server hiện tại.")
            break 
        end
        
        table.sort(fruitsFound, function(a, b)
            return a.priority > b.priority
        end)
        
        local target = fruitsFound[1]
        print("Phát hiện mục tiêu VIP: " .. target.model.Name .. " [Hạng " .. target.priority .. "]. Tiến hành xử lý...")
        SafeMoveTo(target.handle.CFrame)
        task.wait(1)
        AutoStoreFruit()
        task.wait(1)
    end
end

local function AdvancedServerHop()
    pcall(function() collectgarbage("collect") end)
    
    while true do
        print("Đang quét tìm kiếm server phù hợp...")
        task.wait(3)
        
        local success, result = pcall(function() 
            return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100")) 
        end)
        
        if success and result and result.data then 
            local validServers = {}
            for _, server in pairs(result.data) do
                if server.playing and server.maxPlayers and server.playing < (server.maxPlayers - 5) and server.id ~= game.JobId and not BlacklistedServers[server.id] then
                    table.insert(validServers, server.id)
                end
            end
            
            if #validServers > 0 then
                local randomServer = validServers[math.random(1, #validServers)]
                print("Đang tiến hành nhảy vùng tới server: " .. randomServer)
                
                local joinSuccess, err = pcall(function() 
                    TeleportService:TeleportToPlaceInstance(placeId, randomServer, LocalPlayer) 
                end)
                
                if not joinSuccess or string.find(tostring(err), "773") or string.find(tostring(err), "Full") then 
                    print("Server kẹt hoặc đầy, ghi vào danh sách đen...")
                    BlacklistedServers[randomServer] = true 
                else
                    task.wait(5)
                end
            else
                print("Không tìm được server lý tưởng, làm sạch bộ nhớ danh sách đen...")
                BlacklistedServers = {}
            end
        else
            print("Lỗi API kết nối mạng Roblox, thử lại sau một nhịp...")
            task.wait(1)
        end
    end
end
task.wait(0.5)
AutoSelectPirates()
task.wait(0.5)
pcall(SnipeFruit)
task.wait(0.5)
AdvancedServerHop()
