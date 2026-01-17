-- LocalScript (dán vào StarterPlayerScripts ho?c nõi ch?y client)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- T?o ScreenGui (không dùng CoreGui)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TinhSuperHubGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

-- Styles / size
local center = UDim2.new(0.5, 0, 0.35, 0)
local frameSize = UDim2.new(0, 720, 0, 220)

-- Main frame (n?n t?ng)
local main = Instance.new("Frame")
main.Name = "MainFrame"
main.BackgroundColor3 = Color3.fromRGB(128,128,128)
main.BorderSizePixel = 0
main.Size = frameSize
main.Position = center - UDim2.new(0.5, 0, 0.5, 0)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Parent = screenGui
main.Active = true -- important for dragging

-- Title area
local titleFrame = Instance.new("Frame")
titleFrame.Name = "TitleFrame"
titleFrame.Size = UDim2.new(1, 0, 0, 36)
titleFrame.BackgroundTransparency = 1
titleFrame.Parent = main

local titleLabel = Instance.new("TextLabel")
titleLabel.Parent = titleFrame
titleLabel.Size = UDim2.new(0.6, -10, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 24
titleLabel.TextColor3 = Color3.fromRGB(255,255,255)
titleLabel.Text = "TinhSuper Hub [T?a Ð?]"
titleLabel.TextXAlignment = Enum.TextXAlignment.Left

local byLabel = Instance.new("TextLabel")
byLabel.Parent = titleFrame
byLabel.Size = UDim2.new(0.4, -10, 1, 0)
byLabel.Position = UDim2.new(0.6, 10, 0, 0)
byLabel.BackgroundTransparency = 1
byLabel.Font = Enum.Font.SourceSans
byLabel.TextSize = 14
byLabel.TextColor3 = Color3.fromRGB(230,230,230)
byLabel.TextXAlignment = Enum.TextXAlignment.Right
byLabel.Text = "by tinhsuper_gm"

-- "T?a Ð? c?a b?n là:"
local labelTop = Instance.new("TextLabel")
labelTop.Parent = main
labelTop.Size = UDim2.new(0.3, 0, 0, 26)
labelTop.Position = UDim2.new(0.03, 0, 0.2, 0)
labelTop.BackgroundTransparency = 1
labelTop.Font = Enum.Font.SourceSansBold
labelTop.TextSize = 20
labelTop.TextColor3 = Color3.fromRGB(255, 60, 60)
labelTop.Text = "T?a Ð? C?a B?n Là:"
labelTop.TextXAlignment = Enum.TextXAlignment.Left

-- Dropdown (Trý?ng H?p \/)
local dropdown = Instance.new("Frame")
dropdown.Parent = main
dropdown.Size = UDim2.new(0.35, 0, 0, 28)
dropdown.Position = UDim2.new(0.67, 0, 0.12, 0)
dropdown.BackgroundColor3 = Color3.fromRGB(200,200,200)
dropdown.BorderSizePixel = 0

local dropdownBtn = Instance.new("TextButton")
dropdownBtn.Parent = dropdown
dropdownBtn.Size = UDim2.new(1, -6, 1, 0)
dropdownBtn.Position = UDim2.new(0, 3, 0, 0)
dropdownBtn.BackgroundTransparency = 1
dropdownBtn.Font = Enum.Font.SourceSans
dropdownBtn.TextSize = 18
dropdownBtn.TextColor3 = Color3.fromRGB(40,40,40)
dropdownBtn.Text = "Trý?ng H?p \/"
dropdownBtn.TextXAlignment = Enum.TextXAlignment.Left

-- Options container (hidden by default)
local optionsFrame = Instance.new("Frame")
optionsFrame.Parent = dropdown
optionsFrame.Size = UDim2.new(1, 0, 0, 0)
optionsFrame.Position = UDim2.new(0, 0, 1, 2)
optionsFrame.BackgroundColor3 = Color3.fromRGB(240,240,240)
optionsFrame.BorderSizePixel = 0
optionsFrame.ClipsDescendants = true
optionsFrame.Visible = false

local optionNames = {"Nhân v?t", "Part", "Model", "Mouse"}
local currentSelection = optionNames[1]
dropdownBtn.Text = "Trý?ng H?p \/ - "..currentSelection

-- create option buttons
for i,name in ipairs(optionNames) do
    local btn = Instance.new("TextButton")
    btn.Name = "Option_"..name
    btn.Parent = optionsFrame
    btn.Size = UDim2.new(1, 0, 0, 28)
    btn.Position = UDim2.new(0, 0, 0, (i-1)*28)
    btn.BackgroundTransparency = 1
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 16
    btn.TextColor3 = Color3.fromRGB(40,40,40)
    btn.Text = name
    btn.MouseButton1Click:Connect(function()
        currentSelection = name
        dropdownBtn.Text = "Trý?ng H?p \/ - "..currentSelection
        optionsFrame.Visible = false
        optionsFrame.Size = UDim2.new(1,0,0,0)
    end)
end
-- adjust optionsFrame canvas size when toggled
local function toggleOptions()
    if optionsFrame.Visible then
        optionsFrame.Visible = false
        optionsFrame.Size = UDim2.new(1, 0, 0, 0)
    else
        optionsFrame.Visible = true
        optionsFrame.Size = UDim2.new(1, 0, 0, 28 * #optionNames)
    end
end
dropdownBtn.MouseButton1Click:Connect(toggleOptions)

-- Big display where coordinates show
local displayFrame = Instance.new("Frame")
displayFrame.Parent = main
displayFrame.Size = UDim2.new(0.94, 0, 0.48, 0)
displayFrame.Position = UDim2.new(0.03, 0, 0.35, 0)
displayFrame.BackgroundColor3 = Color3.fromRGB(50,50,50)
displayFrame.BorderSizePixel = 0

local coordLabel = Instance.new("TextLabel")
coordLabel.Parent = displayFrame
coordLabel.Size = UDim2.new(1, -20, 1, -20)
coordLabel.Position = UDim2.new(0, 10, 0, 10)
coordLabel.BackgroundTransparency = 1
coordLabel.Font = Enum.Font.SourceSansBold
coordLabel.TextSize = 28
coordLabel.TextColor3 = Color3.fromRGB(255,255,255)
coordLabel.TextWrapped = true
coordLabel.RichText = false
coordLabel.Text = "( T?a ð? ? ðây )"
coordLabel.TextXAlignment = Enum.TextXAlignment.Center
coordLabel.TextYAlignment = Enum.TextYAlignment.Center

-- Buttons: Ki?m tra t?a ð?, Sao chép t?a ð?, X (close)
local checkBtn = Instance.new("TextButton")
checkBtn.Parent = main
checkBtn.Size = UDim2.new(0.26, 0, 0, 36)
checkBtn.Position = UDim2.new(0.05, 0, 0.82, 0)
checkBtn.BackgroundColor3 = Color3.fromRGB(40,180,40)
checkBtn.Font = Enum.Font.SourceSansBold
checkBtn.TextSize = 18
checkBtn.TextColor3 = Color3.fromRGB(255,255,255)
checkBtn.Text = "Ki?m tra t?a ð?"

local copyBtn = Instance.new("TextButton")
copyBtn.Parent = main
copyBtn.Size = UDim2.new(0.26, 0, 0, 36)
copyBtn.Position = UDim2.new(0.36, 0, 0.82, 0)
copyBtn.BackgroundColor3 = Color3.fromRGB(60,140,220)
copyBtn.Font = Enum.Font.SourceSansBold
copyBtn.TextSize = 18
copyBtn.TextColor3 = Color3.fromRGB(255,255,255)
copyBtn.Text = "Sao chép t?a ð?"
copyBtn.AutoButtonColor = true

local closeBtn = Instance.new("TextButton")
closeBtn.Parent = main
closeBtn.Size = UDim2.new(0, 36, 0, 36)
closeBtn.Position = UDim2.new(0.935, 0, 0.02, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(200,80,80)
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 20
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.Text = "X"

-- Info label (small)
local infoLabel = Instance.new("TextLabel")
infoLabel.Parent = main
infoLabel.Size = UDim2.new(0.6, 0, 0, 20)
infoLabel.Position = UDim2.new(0.05, 0, 0.06, 0)
infoLabel.BackgroundTransparency = 1
infoLabel.Font = Enum.Font.SourceSans
infoLabel.TextSize = 14
infoLabel.TextColor3 = Color3.fromRGB(230,230,230)
infoLabel.Text = "Ch?n trý?ng h?p r?i nh?n 'Ki?m tra t?a ð?'. V?i Part/Model, click world ð? ch?n target."

-- Dragging logic for main frame via pressing anywhere on main (or we can restrict to titleFrame)
do
    local dragging = false
    local dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
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
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            update(input)
        end
    end)
end

-- State
local currentCoordinateText = nil
local awaitingClick = false
local tempMouseConnection = nil

-- Utility: format vector3 or cframe nicely
local function formatVec(v)
    if typeof(v) == "Vector3" then
        return string.format("Vector3.new(%.3f, %.3f, %.3f)", v.X, v.Y, v.Z)
    elseif typeof(v) == "CFrame" then
        local p = v.Position
        return string.format("CFrame.new(%.3f, %.3f, %.3f)", p.X, p.Y, p.Z)
    else
        return tostring(v)
    end
end

-- Get player's HRP safely
local function getPlayerHRP()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
    return hrp
end

-- Function to set coordinate text on UI
local function setCoordinateText(text)
    if not text or text == "" then
        coordLabel.Text = "( T?a ð? ? ðây )"
        currentCoordinateText = nil
    else
        coordLabel.Text = text
        currentCoordinateText = text
    end
end

setCoordinateText(nil) -- initial

-- Helper to stop awaiting click
local function stopAwaitingClick()
    awaitingClick = false
    if tempMouseConnection then
        tempMouseConnection:Disconnect()
        tempMouseConnection = nil
    end
end

-- Clicking in world to select Part/Model
local function awaitClickForTarget(mode)
    -- mode: "Part" or "Model"
    local mouse = LocalPlayer:GetMouse()
    awaitingClick = true
    setCoordinateText("( Ðang ch? b?n click vào world ð? ch?n "..mode.." )")

    tempMouseConnection = mouse.Button1Down:Connect(function()
        if not awaitingClick then return end
        local target = mouse.Target
        if target and target:IsA("BasePart") then
            if mode == "Part" then
                -- directly use part's CFrame
                local cf = target.CFrame
                setCoordinateText(formatVec(cf))
            else
                -- Model: try to find model ancestor
                local model = target:FindFirstAncestorOfClass("Model")
                if model then
                    -- try HumanoidRootPart or PrimaryPart
                    local hrp = model:FindFirstChild("HumanoidRootPart") or model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
                    if hrp then
                        setCoordinateText(formatVec(hrp.CFrame))
                    else
                        -- fallback to target position
                        setCoordinateText(formatVec(target.Position))
                    end
                else
                    setCoordinateText("( Không t?m th?y Model, dùng Part )\n"..formatVec(target.CFrame))
                end
            end
        else
            setCoordinateText("(Click không h?p l?, th? l?i)")
        end
        stopAwaitingClick()
    end)
end

-- Ki?m tra t?a ð? button behavior
checkBtn.MouseButton1Click:Connect(function()
    -- ensure no concurrent awaiting
    stopAwaitingClick()

    local selection = currentSelection
    if selection == "Nhân v?t" then
        local hrp = getPlayerHRP()
        if hrp then
            setCoordinateText(formatVec(hrp.CFrame))
        else
            setCoordinateText("( Không t?m th?y HumanoidRootPart )")
        end
    elseif selection == "Mouse" then
        local mouse = LocalPlayer:GetMouse()
        local hit = mouse.Hit
        if hit then
            setCoordinateText(formatVec(hit))
        else
            setCoordinateText("( Không l?y ðý?c mouse.Hit )")
        end
    elseif selection == "Part" then
        awaitClickForTarget("Part")
    elseif selection == "Model" then
        awaitClickForTarget("Model")
    else
        setCoordinateText("( L?a ch?n không h?p l? )")
    end
end)

-- Sao chép t?a ð?
copyBtn.MouseButton1Click:Connect(function()
    if not currentCoordinateText then
        -- show small prompt
        coordLabel.Text = "( Chýa có t?a ð? ð? sao chép )"
        return
    end
    local ok, err = pcall(function()
        setclipboard(currentCoordinateText)
    end)
    if ok then
        coordLabel.Text = "( Ð? sao chép vào clipboard )\n"..currentCoordinateText
    else
        coordLabel.Text = "( Không th? sao chép: "..tostring(err)..")"
    end
end)

-- Close logic
local function closeUI()
    stopAwaitingClick()
    -- cleanup GUI
    if screenGui and screenGui.Parent then
        screenGui:Destroy()
    end
end

closeBtn.MouseButton1Click:Connect(closeUI)

-- Also close if player leaves / dies? (optional)
LocalPlayer.AncestryChanged:Connect(function()
    if not LocalPlayer:IsDescendantOf(game) then
        closeUI()
    end
end)

-- Safety: if new selection while awaiting, cancel awaiting
dropdownBtn.MouseButton1Click:Connect(function()
    -- toggling options; if changing option while awaiting, stop awaiting
    stopAwaitingClick()
end)

-- End of script