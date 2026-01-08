-- Fallback UI (TinhSuper) - paste lên GitHub và loadstring
-- Tùy chỉnh nhanh: chỉnh các biến phía dưới nếu cần
local TITLE_TEXT = "TinhSuper VN Hub [Beta]"
local AUTHOR_TEXT = "by tinhsuper_gm"
local MESSAGE_TEXT = "Xin Lỗi Bạn, Công Cụ Của Chúng Tôi đang Có Một Số Lỗi Khiến UI Không Hiển Thị Bình Thường.\nChúng Tôi Sẽ Cố Gắng Khắc Phục Nhanh Nhất Có Thể."
local BACK_TEXT = "Back"

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- tránh tạo 2 GUI
if PlayerGui:FindFirstChild("TinhSuper_FallbackUI") then
	return
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TinhSuper_FallbackUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui
screenGui.DisplayOrder = 9999

-- Full black rounded background container
local container = Instance.new("Frame")
container.Name = "Container"
container.AnchorPoint = Vector2.new(0.5, 0.5)
container.Size = UDim2.new(0.95, 0, 0.9, 0)
container.Position = UDim2.new(0.5, 0, 0.5, 0)
container.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
container.BackgroundTransparency = 0
container.BorderSizePixel = 0
container.Parent = screenGui

local containerCorner = Instance.new("UICorner")
containerCorner.CornerRadius = UDim.new(0, 36)
containerCorner.Parent = container

-- Slight padding frame to allow inner rounding offset (gives the big rounded look)
local innerPadding = Instance.new("Frame")
innerPadding.Name = "InnerPadding"
innerPadding.AnchorPoint = Vector2.new(0.5, 0.5)
innerPadding.Size = UDim2.new(1, -40, 1, -40)
innerPadding.Position = UDim2.new(0.5, 0, 0.5, 0)
innerPadding.BackgroundTransparency = 1
innerPadding.Parent = container

-- Title (top-left)
local title = Instance.new("TextLabel")
title.Name = "Title"
title.BackgroundTransparency = 1
title.Position = UDim2.new(0, 24, 0, 18)
title.Size = UDim2.new(0.6, 0, 0, 34)
title.Text = TITLE_TEXT
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(255, 95, 150) -- pink
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextYAlignment = Enum.TextYAlignment.Center
title.ClipsDescendants = true
title.Parent = innerPadding

-- Author / byline (small, to the right of title)
local byline = Instance.new("TextLabel")
byline.Name = "Byline"
byline.BackgroundTransparency = 1
byline.Position = UDim2.new(0, 24, 0, 18 + 34)
byline.Size = UDim2.new(0.6, 0, 0, 18)
byline.Text = AUTHOR_TEXT
byline.Font = Enum.Font.Gotham
byline.TextSize = 14
byline.TextColor3 = Color3.fromRGB(170, 170, 170)
byline.TextXAlignment = Enum.TextXAlignment.Left
byline.TextYAlignment = Enum.TextYAlignment.Top
byline.Parent = innerPadding

-- Center rounded message bubble
local bubble = Instance.new("Frame")
bubble.Name = "MessageBubble"
bubble.AnchorPoint = Vector2.new(0.5, 0.5)
bubble.Size = UDim2.new(0.65, 0, 0.45, 0)
bubble.Position = UDim2.new(0.5, 0, 0.47, 0)
bubble.BackgroundColor3 = Color3.fromRGB(115, 115, 115) -- gray
bubble.BorderSizePixel = 0
bubble.Parent = innerPadding

local bubbleCorner = Instance.new("UICorner")
bubbleCorner.CornerRadius = UDim.new(0, 40)
bubbleCorner.Parent = bubble

-- Inner padding for bubble text to avoid touching edges
local bubblePadding = Instance.new("Frame")
bubblePadding.BackgroundTransparency = 1
bubblePadding.Size = UDim2.new(1, -40, 1, -40)
bubblePadding.Position = UDim2.new(0, 20, 0, 20)
bubblePadding.Parent = bubble

-- Message label
local message = Instance.new("TextLabel")
message.Name = "MessageText"
message.BackgroundTransparency = 1
message.Size = UDim2.new(1, 0, 1, 0)
message.Text = MESSAGE_TEXT
message.Font = Enum.Font.GothamBold
message.TextColor3 = Color3.fromRGB(255, 200, 50) -- vàng tươi
message.TextScaled = true
message.TextWrapped = true
message.TextYAlignment = Enum.TextYAlignment.Center
message.TextXAlignment = Enum.TextXAlignment.Center
message.Parent = bubblePadding

-- Back button (bottom-right)
local backBtn = Instance.new("TextButton")
backBtn.Name = "BackButton"
backBtn.AnchorPoint = Vector2.new(1, 1)
backBtn.Size = UDim2.new(0, 120, 0, 56)
backBtn.Position = UDim2.new(1, -28, 1, -28)
backBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
backBtn.BorderSizePixel = 0
backBtn.Text = BACK_TEXT
backBtn.Font = Enum.Font.GothamBold
backBtn.TextSize = 22
backBtn.TextColor3 = Color3.fromRGB(245, 245, 245)
backBtn.Parent = innerPadding

local backCorner = Instance.new("UICorner")
backCorner.CornerRadius = UDim.new(0, 14)
backCorner.Parent = backBtn

-- White stroke around Back text for the "outlined" effect
local backStroke = Instance.new("UIStroke")
backStroke.Thickness = 4
backStroke.Transparency = 0.6
backStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
backStroke.Parent = backBtn

-- Optional small note (bottom-left) - e.g. support link
local note = Instance.new("TextLabel")
note.Name = "Note"
note.BackgroundTransparency = 1
note.Position = UDim2.new(0, 24, 1, -48)
note.Size = UDim2.new(0.6, 0, 0, 36)
note.Text = "UI đang hỏng — Vui lòng kiểm tra GitHub/Discord để cập nhật."
note.Font = Enum.Font.Gotham
note.TextSize = 16
note.TextColor3 = Color3.fromRGB(200, 200, 200)
note.TextXAlignment = Enum.TextXAlignment.Left
note.Parent = innerPadding

-- function: center-scale for small screens
local function scaleForSmallScreens()
	local screenX = workspace.CurrentCamera.ViewportSize.X
	if screenX < 1000 then
		bubble.Size = UDim2.new(0.85, 0, 0.5, 0)
		container.Size = UDim2.new(0.98, 0, 0.95, 0)
		backBtn.Size = UDim2.new(0, 100, 0, 48)
	end
end
scaleForSmallScreens()

-- Tween intro
local TweenService = game:GetService("TweenService")
container.AnchorPoint = Vector2.new(0.5, 0.5)
container.Position = UDim2.new(0.5, 0, 1.2, 0)
local tweenInfo = TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
TweenService:Create(container, tweenInfo, {Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()

-- Back button close behavior
backBtn.MouseButton1Click:Connect(function()
	-- small hide tween
	local t = TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
	TweenService:Create(container, t, {Position = UDim2.new(0.5, 0, 1.2, 0)}):Play()
	wait(0.36)
	if screenGui and screenGui.Parent then
		screenGui:Destroy()
	end
end)

-- Allow pressing ESC to close
local userInputService = game:GetService("UserInputService")
local escConn
escConn = userInputService.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.KeyCode == Enum.KeyCode.Escape then
		if screenGui and screenGui.Parent then
			screenGui:Destroy()
		end
		if escConn then escConn:Disconnect() end
	end
end)