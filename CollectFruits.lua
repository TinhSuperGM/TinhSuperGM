local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local placeId = game.PlaceId

local function MaxOptimize()
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Material = Enum.Material.SmoothPlastic
            v.Color = Color3.fromRGB(100, 100, 100)
        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Sparkles") then
            v.Enabled = false
        end
    end
end

local function SafeTween(targetCFrame)
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = LocalPlayer.Character.HumanoidRootPart
    
    local distance = (hrp.Position - targetCFrame.Position).Magnitude
    local duration = distance / 300
    
    local tween = TweenService:Create(hrp, TweenInfo.new(duration, Enum.EasingStyle.Linear), {CFrame = targetCFrame})
    tween:Play()
    tween.Completed:Wait()
end

local function SnipeFruit()
    for _, obj in pairs(Workspace:GetChildren()) do
        if obj:IsA("Model") and string.match(obj.Name, "Fruit") then
            local handle = obj:FindFirstChild("Handle") or obj:FindFirstChildWhichIsA("BasePart")
            if handle then
                print("Tìm thấy trái: " .. obj.Name .. "! Đang bay lại lụm...")
                SafeTween(handle.CFrame)
                task.wait(1.5)
                return true
            end
        end
    end
    return false
end

local function AdvancedServerHop()
    print("Đang tìm server mới để nhảy...")
    local serverList = {}
    
    local success, result = pcall(function()
        return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100"))
    end)
    
    if success and result and result.data then
        for _, server in pairs(result.data) do
            if server.playing < server.maxPlayers and server.id ~= game.JobId then
table.insert(serverList, server.id)
            end
        end
    end
    
    if #serverList > 0 then
        local randomServer = serverList[math.random(1, #serverList)]
        print("Đang delay 10s an toàn trước khi nhảy...")
        task.wait(10)
        
        pcall(function()
            TeleportService:TeleportToPlaceInstance(placeId, randomServer, LocalPlayer)
        end)
    else
        print("Không tìm thấy server phù hợp, thử lại sau 5s...")
        task.wait(5)
        AdvancedServerHop()
    end
end

MaxOptimize()
task.wait(1)

local gotFruit = SnipeFruit()
if not gotFruit then
    print("Server này không có trái nào cả.")
end

AdvancedServerHop()
