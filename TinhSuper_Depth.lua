-- LocalScript: Dán vào StarterPlayerScripts
-- TinhSuper Hub - Hiện giữa màn hình, PlayerGui (không dùng CoreGui)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TinhSuperHubGui"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true -- tránh bị topbar/mobile dịch GUI
screenGui.Parent = PlayerGui

-- Main frame (centered)
local main = Instance.new("Frame")
main.Name = "MainFrame"
main.Size = UDim2.new(0, 720, 0, 220)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Position = UDim2.new(0.5, 0, 0.35, 0) -- CHÍNH GIỮA (x trung tâm, y hơi trên)
main.BackgroundColor3 = Color3.fromRGB(128,128,128)
main.BorderSizePixel = 0
main.Active = true -- cần để kéo
main.Parent = screenGui

-- Title row
local titleFrame = Instance.new("Frame", main)
titleFrame.Size = UDim2.new(1,0,0,36)
titleFrame.BackgroundTransparency = 1

local titleLabel = Instance.new("TextLabel", titleFrame)
titleLabel.Size = UDim2.new(0.6, -10, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 24
titleLabel.TextColor3 = Color3.fromRGB(255,255,255)
titleLabel.Text = "TinhSuper Hub"
titleLabel.TextXAlignment = Enum.TextXAlignment.Left

local byLabel = Instance.new("TextLabel", titleFrame)
byLabel.Size = UDim2.new(0.4, -10, 1, 0)
byLabel.Position = UDim2.new(0.6, 10, 0, 0)
byLabel.BackgroundTransparency = 1
byLabel.Font = Enum.Font.SourceSans
byLabel.TextSize = 14
byLabel.TextColor3 = Color3.fromRGB(230,230,230)
byLabel.TextXAlignment = Enum.TextXAlignment.Right
byLabel.Text = "by tinhsuper_gm"

-- Info top text
local infoLabel = Instance.new("TextLabel", main)
infoLabel.Size = UDim2.new(0.6, 0, 0, 20)
infoLabel.Position = UDim2.new(0.05, 0, 0.06, 0)
infoLabel.BackgroundTransparency = 1
infoLabel.Font = Enum.Font.SourceSans
infoLabel.TextSize = 14
infoLabel.TextColor3 = Color3.fromRGB(230,230,230)
infoLabel.Text = "Kiểm tra tọa độ."

-- "Tọa Độ Của Bạn Là:" label
local labelTop = Instance.new("TextLabel", main)
labelTop.Size = UDim2.new(0.3, 0, 0, 26)
labelTop.Position = UDim2.new(0.03, 0, 0.2, 0)
labelTop.BackgroundTransparency = 1
labelTop.Font = Enum.Font.SourceSansBold
labelTop.TextSize = 20
labelTop.TextColor3 = Color3.fromRGB(255,60,60)
labelTop.Text = "Tọa Độ Của Bạn Là:"
labelTop.TextXAlignment = Enum.TextXAlignment.Left

-- Dropdown area (Trường Hợp \/)
local dropdown = Instance.new("Frame", main)
dropdown.Size = UDim2.new(0.35, 0, 0, 28)
dropdown.Position = UDim2.new(0.67, 0, 0.12, 0)
dropdown.BackgroundColor3 = Color3.fromRGB(200,200,200)
dropdown.BorderSizePixel = 0

local dropdownBtn = Instance.new("TextButton", dropdown)
dropdownBtn.Size = UDim2.new(1, -6, 1, 0)
dropdownBtn.Position = UDim2.new(0, 3, 0, 0)
dropdownBtn.BackgroundTransparency = 1
dropdownBtn.Font = Enum.Font.SourceSans
dropdownBtn.TextSize = 18
dropdownBtn.TextColor3 = Color3.fromRGB(40,40,40)
dropdownBtn.Text = "Trường Hợp \/"

local optionsFrame = Instance.new("Frame", dropdown)
optionsFrame.Size = UDim2.new(1, 0, 0, 0)
optionsFrame.Position = UDim2.new(0,0,1,2)
optionsFrame.BackgroundColor3 = Color3.fromRGB(240,240,240)
optionsFrame.BorderSizePixel = 0
optionsFrame.ClipsDescendants = true
optionsFrame.Visible = false

local optionNames = {"Nhân vật", "Part", "Model", "Mouse"}
local currentSelection = optionNames[1]
dropdownBtn.Text = "Trường Hợp \/ - "..currentSelection

for i,name in ipairs(optionNames) do
    local btn = Instance.new("TextButton", optionsFrame)
    btn.Name = "Option_"..name
    btn.Size = UDim2.new(1, 0, 0, 28)
    btn.Position = UDim2.new(0,0,0,(i-1)*28)
    btn.BackgroundTransparency = 1
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 16
    btn.TextColor3 = Color3.fromRGB(40,40,40)
    btn.Text = name
    btn.MouseButton1Click:Connect(function()
        currentSelection = name
        dropdownBtn.Text = "Trường Hợp \/ - "..currentSelection
        optionsFrame.Visible = false
        optionsFrame.Size = UDim2.new(1,0,0,0)
    end)
end

local function toggleOptions()
    if optionsFrame.Visible then
        optionsFrame.Visible = false
        optionsFrame.Size = UDim2.new(1,0,0,0)
    else
        optionsFrame.Visible = true
        optionsFrame.Size = UDim2.new(1,0,0,28 * #optionNames)
    end
end
dropdownBtn.MouseButton1Click:Connect(function()
    toggleOptions()
end)

-- Big display for coordinates
local displayFrame = Instance.new("Frame", main)
displayFrame.Size = UDim2.new(0.94, 0, 0.48, 0)
displayFrame.Position = UDim2.new(0.03, 0, 0.35, 0)
displayFrame.BackgroundColor3 = Color3.fromRGB(50,50,50)
displayFrame.BorderSizePixel = 0

local coordLabel = Instance.new("TextLabel", displayFrame)
coordLabel.Size = UDim2.new(1, -20, 1, -20)
coordLabel.Position = UDim2.new(0,10,0,10)
coordLabel.BackgroundTransparency = 1
coordLabel.Font = Enum.Font.SourceSansBold
coordLabel.TextSize = 28
coordLabel.TextColor3 = Color3.fromRGB(255,255,255)
coordLabel.TextWrapped = true
coordLabel.Text = "( Tọa độ ở đây )"
coordLabel.TextXAlignment = Enum.TextXAlignment.Center
coordLabel.TextYAlignment = Enum.TextYAlignment.Center

-- Buttons
local checkBtn = Instance.new("TextButton", main)
checkBtn.Size = UDim2.new(0.26, 0, 0, 36)
checkBtn.Position = UDim2.new(0.05, 0, 0.82, 0)
checkBtn.BackgroundColor3 = Color3.fromRGB(40,180,40)
checkBtn.Font = Enum.Font.SourceSansBold
checkBtn.TextSize = 18
checkBtn.TextColor3 = Color3.fromRGB(255,255,255)
checkBtn.Text = "Kiểm tra tọa độ"

local copyBtn = Instance.new("TextButton", main)
copyBtn.Size = UDim2.new(0.26, 0, 0, 36)
copyBtn.Position = UDim2.new(0.36, 0, 0.82, 0)
copyBtn.BackgroundColor3 = Color3.fromRGB(60,140,220)
copyBtn.Font = Enum.Font.SourceSansBold
copyBtn.TextSize = 18
copyBtn.TextColor3 = Color3.fromRGB(255,255,255)
copyBtn.Text = "Sao chép tọa độ"

local closeBtn = Instance.new("TextButton", main)
closeBtn.Size = UDim2.new(0,36,0,36)
closeBtn.Position = UDim2.new(0.935,0,0.02,0)
closeBtn.BackgroundColor3 = Color3.fromRGB(200,80,80)
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 20
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.Text = "X"

-- Dragging logic (kéo toàn bộ main bằng giữ chuột trên main)
do
    local dragging = false
    local dragStart
    local startPos
    local dragInput

    main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    main.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- Utilities
local currentCoordinateText = nil
local awaitingClick = false
local tempMouseConnection = nil

local function formatVec(v)
    if typeof(v) == "CFrame" then
        local p = v.Position
        return string.format("CFrame.new(%.3f, %.3f, %.3f)", p.X, p.Y, p.Z)
    elseif typeof(v) == "Vector3" then
        return string.format("Vector3.new(%.3f, %.3f, %.3f)", v.X, v.Y, v.Z)
    else
        return tostring(v)
    end
end

local function setCoordinateText(text)
    if not text or text == "" then
        coordLabel.Text = "( Tọa độ ở đây )"
        currentCoordinateText = nil
    else
        coordLabel.Text = text
        currentCoordinateText = text
    end
end

setCoordinateText(nil)

local function stopAwaitingClick()
    awaitingClick = false
    if tempMouseConnection then
        tempMouseConnection:Disconnect()
        tempMouseConnection = nil
    end
end

local function getPlayerHRP()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
    return hrp
end

-- Await click to choose Part or Model
local function awaitClickForTarget(mode)
    local mouse = LocalPlayer:GetMouse()
    awaitingClick = true
    setCoordinateText("( Đang chờ bạn click vào world để chọn "..mode.." )")

    tempMouseConnection = mouse.Button1Down:Connect(function()
        if not awaitingClick then return end
        local target = mouse.Target
        if target and target:IsA("BasePart") then
            if mode == "Part" then
                setCoordinateText(formatVec(target.CFrame))
            else -- Model
                local model = target:FindFirstAncestorOfClass("Model")
                if model then
                    local hrp = model:FindFirstChild("HumanoidRootPart") or model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
                    if hrp then
                        setCoordinateText(formatVec(hrp.CFrame))
                    else
                        setCoordinateText(formatVec(target.Position))
                    end
                else
                    setCoordinateText("(Không tìm thấy Model, dùng Part)\n"..formatVec(target.CFrame))
                end
            end
        else
            setCoordinateText("(Click không hợp lệ, thử lại)")
        end
        stopAwaitingClick()
    end)
end

-- Check button behavior
checkBtn.MouseButton1Click:Connect(function()
    stopAwaitingClick()

    if currentSelection == "Nhân vật" then
        local hrp = getPlayerHRP()
        if hrp then
            setCoordinateText(formatVec(hrp.CFrame))
        else
            setCoordinateText("(Không tìm thấy HumanoidRootPart)")
        end
    elseif currentSelection == "Mouse" then
        local mouse = LocalPlayer:GetMouse()
        local hit = mouse.Hit
        if hit then
            setCoordinateText(formatVec(hit))
        else
            setCoordinateText("(Không lấy được mouse.Hit)")
        end
    elseif currentSelection == "Part" then
        awaitClickForTarget("Part")
    elseif currentSelection == "Model" then
        awaitClickForTarget("Model")
    else
        setCoordinateText("(Lựa chọn không hợp lệ)")
    end
end)

-- Copy to clipboard (chỉ khi có tọa độ)
copyBtn.MouseButton1Click:Connect(function()
    if not currentCoordinateText then
        coordLabel.Text = "( Chưa có tọa độ để sao chép )"
        return
    end
    local ok, err = pcall(function()
        setclipboard(currentCoordinateText)
    end)
    if ok then
        coordLabel.Text = "( Đã sao chép vào clipboard )\n"..currentCoordinateText
    else
        coordLabel.Text = "( Không thể sao chép: "..tostring(err)..")"
    end
end)

-- Close / cleanup
local function closeUI()
    stopAwaitingClick()
    if screenGui and screenGui.Parent then
        screenGui:Destroy()
    end
end
closeBtn.MouseButton1Click:Connect(closeUI)

-- Ensure awaiting canceled if dropdown toggled
dropdownBtn.MouseButton1Click:Connect(function()
    stopAwaitingClick()
end)

-- If player leaves / GUI removed, cleanup
LocalPlayer.AncestryChanged:Connect(function()
    if not LocalPlayer:IsDescendantOf(game) then
        closeUI()
    end
end)

-- End of script
