-- LocalScript (dán vào StarterPlayerScripts)
-- TinhSuper Hub - Full version theo yêu c?u: centered, popup priority, header-drag, hidden placeholder

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TinhSuperHubGui"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = PlayerGui

-- Main frame (rounded)
local main = Instance.new("Frame")
main.Name = "MainFrame"
main.Size = UDim2.new(0, 780, 0, 260)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Position = UDim2.new(0.5, 0, 0.35, 0) -- centered horizontally, slightly up vertically
main.BackgroundColor3 = Color3.fromRGB(126,126,126)
main.BorderSizePixel = 0
main.ZIndex = 2
main.Parent = screenGui
local mainCorner = Instance.new("UICorner", main)
mainCorner.CornerRadius = UDim.new(0, 18)

-- Header (draggable)
local header = Instance.new("Frame", main)
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 56)
header.Position = UDim2.new(0, 0, 0, 0)
header.BackgroundTransparency = 0.8
header.BackgroundColor3 = Color3.fromRGB(110,110,110)
header.BorderSizePixel = 0
header.ZIndex = 3
local headerCorner = Instance.new("UICorner", header)
headerCorner.CornerRadius = UDim.new(0, 16)

-- Title & by
local titleLabel = Instance.new("TextLabel", header)
titleLabel.Size = UDim2.new(0.5, -20, 1, 0)
titleLabel.Position = UDim2.new(0, 16, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 26
titleLabel.TextColor3 = Color3.fromRGB(250,250,250)
titleLabel.Text = "TinhSuper Hub"
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.ZIndex = 4

local byLabel = Instance.new("TextLabel", header)
byLabel.Size = UDim2.new(0.3, -16, 1, 0)
byLabel.Position = UDim2.new(0.5, 0, 0, 0)
byLabel.BackgroundTransparency = 1
byLabel.Font = Enum.Font.SourceSans
byLabel.TextSize = 14
byLabel.TextColor3 = Color3.fromRGB(230,230,230)
byLabel.Text = "by tinhsuper_gm"
byLabel.TextXAlignment = Enum.TextXAlignment.Left
byLabel.ZIndex = 4

-- Dropdown button (shows "Trý?ng H?p ?" initially)
local dropdownBtn = Instance.new("TextButton", header)
dropdownBtn.Name = "DropdownBtn"
dropdownBtn.Size = UDim2.new(0, 280, 0, 36)
dropdownBtn.Position = UDim2.new(1, -320, 0, 10)
dropdownBtn.BackgroundColor3 = Color3.fromRGB(220,220,220)
dropdownBtn.BorderSizePixel = 0
dropdownBtn.Font = Enum.Font.SourceSans
dropdownBtn.TextSize = 18
dropdownBtn.TextColor3 = Color3.fromRGB(30,30,30)
dropdownBtn.TextXAlignment = Enum.TextXAlignment.Left
dropdownBtn.Text = "Trý?ng H?p  ?" -- initial label shown
dropdownBtn.ZIndex = 6
local dropdownCorner = Instance.new("UICorner", dropdownBtn)
dropdownCorner.CornerRadius = UDim.new(0, 8)

-- Close X (header)
local closeBtn = Instance.new("TextButton", header)
closeBtn.Name = "CloseBtn"
closeBtn.Size = UDim2.new(0, 44, 0, 36)
closeBtn.Position = UDim2.new(1, -48, 0, 10)
closeBtn.BackgroundColor3 = Color3.fromRGB(190,60,60)
closeBtn.BorderSizePixel = 0
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 20
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.Text = "X"
closeBtn.ZIndex = 7
local closeCorner = Instance.new("UICorner", closeBtn)
closeCorner.CornerRadius = UDim.new(0,6)

-- Top-left label "T?a Ð? C?a B?n Là:"
local labelTop = Instance.new("TextLabel", main)
labelTop.Size = UDim2.new(0.4, 0, 0, 28)
labelTop.Position = UDim2.new(0.04, 0, 0.22, 0)
labelTop.BackgroundTransparency = 1
labelTop.Font = Enum.Font.SourceSansBold
labelTop.TextSize = 20
labelTop.TextColor3 = Color3.fromRGB(220,50,50)
labelTop.Text = "T?a Ð? C?a B?n Là:"
labelTop.TextXAlignment = Enum.TextXAlignment.Left
labelTop.ZIndex = 2

-- Big dark display for coordinate (initially HIDDEN)
local displayFrame = Instance.new("Frame", main)
displayFrame.Size = UDim2.new(0.92, 0, 0.46, 0)
displayFrame.Position = UDim2.new(0.04, 0, 0.35, 0)
displayFrame.BackgroundColor3 = Color3.fromRGB(38,38,38)
displayFrame.BorderSizePixel = 0
displayFrame.ZIndex = 2
local displayCorner = Instance.new("UICorner", displayFrame)
displayCorner.CornerRadius = UDim.new(0, 10)

local coordLabel = Instance.new("TextLabel", displayFrame)
coordLabel.Size = UDim2.new(1, -20, 1, -20)
coordLabel.Position = UDim2.new(0, 10, 0, 10)
coordLabel.BackgroundTransparency = 1
coordLabel.Font = Enum.Font.GothamBold
coordLabel.TextSize = 34
coordLabel.TextColor3 = Color3.fromRGB(255,255,255)
coordLabel.TextWrapped = true
coordLabel.Text = "" -- initially empty (important)
coordLabel.Visible = false -- invisible until user checks
coordLabel.TextXAlignment = Enum.TextXAlignment.Center
coordLabel.TextYAlignment = Enum.TextYAlignment.Center
coordLabel.ZIndex = 3

-- Buttons bottom
local checkBtn = Instance.new("TextButton", main)
checkBtn.Size = UDim2.new(0, 260, 0, 44)
checkBtn.Position = UDim2.new(0.06, 0, 0.82, 0)
checkBtn.BackgroundColor3 = Color3.fromRGB(39,171,63)
checkBtn.Font = Enum.Font.SourceSansBold
checkBtn.TextSize = 20
checkBtn.TextColor3 = Color3.fromRGB(255,255,255)
checkBtn.Text = "Ki?m tra t?a ð?"
checkBtn.ZIndex = 3
local checkCorner = Instance.new("UICorner", checkBtn)
checkCorner.CornerRadius = UDim.new(0,6)

local copyBtn = Instance.new("TextButton", main)
copyBtn.Size = UDim2.new(0, 300, 0, 44)
copyBtn.Position = UDim2.new(0.35, 0, 0.82, 0)
copyBtn.BackgroundColor3 = Color3.fromRGB(64,134,206)
copyBtn.Font = Enum.Font.SourceSansBold
copyBtn.TextSize = 20
copyBtn.TextColor3 = Color3.fromRGB(255,255,255)
copyBtn.Text = "Sao chép t?a ð?"
copyBtn.ZIndex = 3
local copyCorner = Instance.new("UICorner", copyBtn)
copyCorner.CornerRadius = UDim.new(0,6)

-- small decorative circle in center bottom
local midX = Instance.new("TextLabel", main)
midX.Size = UDim2.new(0, 42, 0, 42)
midX.Position = UDim2.new(0.495, -21, 0.75, -21)
midX.BackgroundColor3 = Color3.fromRGB(240,240,240)
midX.BorderSizePixel = 0
midX.Font = Enum.Font.SourceSansBold
midX.Text = "?"
midX.TextSize = 22
midX.TextColor3 = Color3.fromRGB(30,30,30)
local midXcorner = Instance.new("UICorner", midX)
midXcorner.CornerRadius = UDim.new(0, 21)
midX.ZIndex = 2

-- Popup small options (parent = screenGui to stay above)
local popup = Instance.new("Frame")
popup.Name = "PopupOptions"
popup.Size = UDim2.new(0, 260, 0, 180)
popup.Position = UDim2.new(0, 0, 0, 0)
popup.BackgroundColor3 = Color3.fromRGB(245,245,245)
popup.BorderSizePixel = 0
popup.ZIndex = 250
popup.Visible = false
popup.Parent = screenGui
local popupCorner = Instance.new("UICorner", popup)
popupCorner.CornerRadius = UDim.new(0,10)

local popupTitle = Instance.new("TextLabel", popup)
popupTitle.Size = UDim2.new(1, -16, 0, 32)
popupTitle.Position = UDim2.new(0,8,0,8)
popupTitle.BackgroundTransparency = 1
popupTitle.Font = Enum.Font.SourceSansBold
popupTitle.TextSize = 16
popupTitle.TextColor3 = Color3.fromRGB(60,60,60)
popupTitle.Text = "Ch?n Trý?ng H?p"
popupTitle.TextXAlignment = Enum.TextXAlignment.Left
popupTitle.ZIndex = 251

-- Options list and state
local options = {"CFrame", "Nhân v?t", "Part", "Model", "Mouse"}
local selectedOption = "CFrame" -- default if user doesn't change (but dropdown shows "Trý?ng H?p ?" at start)
local function updateDropdownTextFromSelection()
    -- after user selects, replace "Trý?ng H?p" with chosen option + arrow
    dropdownBtn.Text = selectedOption .. "  ?"
end

-- create options in popup
local function makeOptionButton(name, idx)
    local btn = Instance.new("TextButton", popup)
    btn.Size = UDim2.new(1, -16, 0, 30)
    btn.Position = UDim2.new(0,8,0, 8 + 32 + (idx-1) * 34)
    btn.BackgroundColor3 = Color3.fromRGB(255,255,255)
    btn.BorderSizePixel = 0
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 16
    btn.TextColor3 = Color3.fromRGB(40,40,40)
    btn.Text = name
    btn.ZIndex = 251
    local c = Instance.new("UICorner", btn)
    c.CornerRadius = UDim.new(0,6)
    btn.MouseButton1Click:Connect(function()
        selectedOption = name
        updateDropdownTextFromSelection()
        popup.Visible = false
    end)
    return btn
end
for i,name in ipairs(options) do
    makeOptionButton(name,i)
end

-- Utility/state
local currentCoordinateText = nil
local awaitingClick = false
local tempMouseConnection = nil

local function formatVecOrCFrame(v)
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
        coordLabel.Text = ""
        coordLabel.Visible = false
        currentCoordinateText = nil
    else
        coordLabel.Text = text
        coordLabel.Visible = true
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

-- Await click to choose Part/Model
local function awaitClickForTarget(mode)
    stopAwaitingClick()
    local mouse = LocalPlayer:GetMouse()
    awaitingClick = true
    setCoordinateText("( Ðang ch? b?n click vào world ð? ch?n "..mode.." )")
    tempMouseConnection = mouse.Button1Down:Connect(function()
        if not awaitingClick then return end
        local target = mouse.Target
        if target and target:IsA("BasePart") then
            if mode == "Part" then
                setCoordinateText(formatVecOrCFrame(target.CFrame))
            else -- Model
                local model = target:FindFirstAncestorOfClass("Model")
                if model then
                    local hrp = model:FindFirstChild("HumanoidRootPart") or model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
                    if hrp then
                        setCoordinateText(formatVecOrCFrame(hrp.CFrame))
                    else
                        setCoordinateText(formatVecOrCFrame(target.Position))
                    end
                else
                    setCoordinateText("(Không t?m th?y Model, dùng Part)\n" .. formatVecOrCFrame(target.CFrame))
                end
            end
        else
            setCoordinateText("(Click không h?p l?, th? l?i)")
        end
        stopAwaitingClick()
    end)
end

-- Position popup relative to dropdownBtn (avoid offscreen)
local function positionPopupUnderDropdown()
    -- ensure AbsolutePosition/Size are ready
    local ddPos = dropdownBtn.AbsolutePosition
    local ddSize = dropdownBtn.AbsoluteSize
    local screenSize = UserInputService:GetScreenSize()
    local px = ddPos.X
    local py = ddPos.Y + ddSize.Y + 6
    local popupW = popup.Size.X.Offset
    local popupH = popup.Size.Y.Offset

    -- if overflow right, shift left
    if px + popupW + 8 > screenSize.X then
        px = math.max(8, screenSize.X - popupW - 8)
    end
    -- if overflow bottom, position above
    if py + popupH + 8 > screenSize.Y then
        py = ddPos.Y - popupH - 6
        if py < 8 then py = 8 end
    end

    popup.Position = UDim2.new(0, math.floor(px), 0, math.floor(py))
    popup.ZIndex = 300
    for _,c in ipairs(popup:GetDescendants()) do
        if c:IsA("GuiObject") then
            c.ZIndex = 301
        end
    end
end

-- Dropdown click toggle
dropdownBtn.MouseButton1Click:Connect(function()
    popup.Visible = not popup.Visible
    if popup.Visible then
        -- default display if selection hasn't been changed yet: keep "Trý?ng H?p ?" until user selects
        positionPopupUnderDropdown()
    end
    stopAwaitingClick()
end)

-- Hide popup if click outside
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        if popup.Visible then
            local m = UserInputService:GetMouseLocation()
            local absPos = popup.AbsolutePosition
            local absSize = popup.AbsoluteSize
            local inside = m.X >= absPos.X and m.X <= absPos.X + absSize.X and m.Y >= absPos.Y and m.Y <= absPos.Y + absSize.Y
            if not inside then
                -- also check dropdownBtn click
                local ddPos = dropdownBtn.AbsolutePosition
                local ddSize = dropdownBtn.AbsoluteSize
                local clickedDD = m.X >= ddPos.X and m.X <= ddPos.X + ddSize.X and m.Y >= ddPos.Y and m.Y <= ddPos.Y + ddSize.Y
                if not clickedDD then
                    popup.Visible = false
                end
            end
        end
    end
end)

-- Check button behavior
checkBtn.MouseButton1Click:Connect(function()
    stopAwaitingClick()
    -- If user never picked an option (dropdown still "Trý?ng H?p ?"), treat as CFrame default
    local sel = selectedOption or "CFrame"
    if sel == "CFrame" or sel == "Nhân v?t" then
        local hrp = getPlayerHRP()
        if hrp then
            setCoordinateText(formatVecOrCFrame(hrp.CFrame))
        else
            setCoordinateText("(Không t?m th?y HumanoidRootPart)")
        end
    elseif sel == "Mouse" then
        local mouse = LocalPlayer:GetMouse()
        local hit = mouse.Hit
        if hit then
            setCoordinateText(formatVecOrCFrame(hit))
        else
            setCoordinateText("(Không l?y ðý?c mouse.Hit)")
        end
    elseif sel == "Part" then
        awaitClickForTarget("Part")
    elseif sel == "Model" then
        awaitClickForTarget("Model")
    else
        local hrp = getPlayerHRP()
        if hrp then
            setCoordinateText(formatVecOrCFrame(hrp.CFrame))
        else
            setCoordinateText("(L?a ch?n không h?p l?)")
        end
    end
end)

-- Copy button
copyBtn.MouseButton1Click:Connect(function()
    if not currentCoordinateText then
        -- show a brief message in coord area (becomes visible)
        setCoordinateText("( Chýa có t?a ð? ð? sao chép )")
        -- auto-hide after 1.2s
        delay(1.2, function() setCoordinateText(nil) end)
        return
    end
    local ok, err = pcall(function()
        setclipboard(currentCoordinateText)
    end)
    if ok then
        setCoordinateText("( Ð? sao chép vào clipboard )\n" .. currentCoordinateText)
    else
        setCoordinateText("( Không th? sao chép: " .. tostring(err) .. ")")
    end
end)

-- Close logic
closeBtn.MouseButton1Click:Connect(function()
    stopAwaitingClick()
    if screenGui and screenGui.Parent then
        screenGui:Destroy()
    end
end)

-- Drag header only (safe with rounded corners)
do
    local dragging = false
    local dragStart = Vector2.new()
    local startPos = main.Position
    local dragInput

    header.InputBegan:Connect(function(input)
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

    header.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            if popup.Visible then
                positionPopupUnderDropdown()
            end
        end
    end)
end

-- Cleanup when player leaves
LocalPlayer.AncestryChanged:Connect(function()
    if not LocalPlayer:IsDescendantOf(game) then
        if screenGui and screenGui.Parent then screenGui:Destroy() end
    end
end)