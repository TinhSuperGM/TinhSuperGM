--// TinhSuper Hub - Coordinate Picker (FINAL)
--// by tinhsuper_gm

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Clean old
pcall(function()
	if PlayerGui:FindFirstChild("TinhSuperHub") then
		PlayerGui.TinhSuperHub:Destroy()
	end
end)

-- ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "TinhSuperHub"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = PlayerGui

-- Main Frame
local Main = Instance.new("Frame", gui)
Main.Size = UDim2.new(0, 780, 0, 270)
Main.Position = UDim2.new(0.5, 0, 0.38, 0)
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.BackgroundColor3 = Color3.fromRGB(140,140,140)
Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0,18)

-- Drag
do
	local dragging, dragStart, startPos
	Main.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = i.Position
			startPos = Main.Position
		end
	end)
	Main.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
	UIS.InputChanged:Connect(function(i)
		if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
			local delta = i.Position - dragStart
			Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
end

-- Title
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, -30, 32)
Title.Position = UDim2.new(0, 15, 0, 10)
Title.BackgroundTransparency = 1
Title.Text = "TinhSuper Hub"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 26
Title.TextXAlignment = Left
Title.TextColor3 = Color3.new(1,1,1)

local By = Instance.new("TextLabel", Main)
By.Size = UDim2.new(1, -30, 20)
By.Position = UDim2.new(0, 15, 0, 42)
By.BackgroundTransparency = 1
By.Text = "by tinhsuper_gm"
By.Font = Enum.Font.Gotham
By.TextSize = 14
By.TextXAlignment = Left
By.TextColor3 = Color3.fromRGB(230,230,230)

-- Case Button
local CaseBtn = Instance.new("TextButton", Main)
CaseBtn.Size = UDim2.new(0, 260, 36)
CaseBtn.Position = UDim2.new(1, -280, 0, 26)
CaseBtn.Text = "Trý?ng H?p  ?"
CaseBtn.Font = Enum.Font.Gotham
CaseBtn.TextSize = 18
CaseBtn.TextColor3 = Color3.fromRGB(30,30,30)
CaseBtn.BackgroundColor3 = Color3.fromRGB(230,230,230)
CaseBtn.BorderSizePixel = 0
Instance.new("UICorner", CaseBtn).CornerRadius = UDim.new(0,8)

-- Red label
local Info = Instance.new("TextLabel", Main)
Info.Size = UDim2.new(0.6, 0, 24)
Info.Position = UDim2.new(0, 20, 0, 82)
Info.BackgroundTransparency = 1
Info.Text = "T?a ð? c?a b?n là:"
Info.Font = Enum.Font.GothamBold
Info.TextSize = 20
Info.TextColor3 = Color3.fromRGB(220,40,40)
Info.TextXAlignment = Left

-- Display
local Display = Instance.new("Frame", Main)
Display.Size = UDim2.new(1, -40, 110)
Display.Position = UDim2.new(0, 20, 0, 115)
Display.BackgroundColor3 = Color3.fromRGB(35,35,35)
Display.BorderSizePixel = 0
Instance.new("UICorner", Display).CornerRadius = UDim.new(0,10)

local Coord = Instance.new("TextLabel", Display)
Coord.Size = UDim2.new(1, -20, 1, -20)
Coord.Position = UDim2.new(0, 10, 0, 10)
Coord.BackgroundTransparency = 1
Coord.Font = Enum.Font.GothamBold
Coord.TextSize = 30
Coord.TextWrapped = true
Coord.TextColor3 = Color3.new(1,1,1)
Coord.Text = ""
Coord.Visible = false

-- Buttons
local Check = Instance.new("TextButton", Main)
Check.Size = UDim2.new(0, 300, 48)
Check.Position = UDim2.new(0, 20, 1, -60)
Check.Text = "Ki?m tra t?a ð?"
Check.Font = Enum.Font.GothamBold
Check.TextSize = 20
Check.TextColor3 = Color3.new(1,1,1)
Check.BackgroundColor3 = Color3.fromRGB(40,170,70)
Check.BorderSizePixel = 0
Instance.new("UICorner", Check).CornerRadius = UDim.new(0,8)

local Copy = Instance.new("TextButton", Main)
Copy.Size = UDim2.new(0, 300, 48)
Copy.Position = UDim2.new(1, -320, 1, -60)
Copy.Text = "Sao chép t?a ð?"
Copy.Font = Enum.Font.GothamBold
Copy.TextSize = 20
Copy.TextColor3 = Color3.new(1,1,1)
Copy.BackgroundColor3 = Color3.fromRGB(60,130,210)
Copy.BorderSizePixel = 0
Instance.new("UICorner", Copy).CornerRadius = UDim.new(0,8)

-- Center X (ONLY CLOSE)
local Close = Instance.new("TextButton", Main)
Close.Size = UDim2.new(0, 46, 46)
Close.Position = UDim2.new(0.5, -23, 1, -63)
Close.Text = "X"
Close.Font = Enum.Font.GothamBold
Close.TextSize = 22
Close.TextColor3 = Color3.fromRGB(30,30,30)
Close.BackgroundColor3 = Color3.fromRGB(245,245,245)
Close.BorderSizePixel = 0
Instance.new("UICorner", Close).CornerRadius = UDim.new(1,0)

-- Popup
local Popup = Instance.new("Frame", gui)
Popup.Size = UDim2.new(0, 230, 160)
Popup.BackgroundColor3 = Color3.fromRGB(250,250,250)
Popup.BorderSizePixel = 0
Popup.Visible = false
Popup.ZIndex = 100
Instance.new("UICorner", Popup).CornerRadius = UDim.new(0,10)

local function popupPos()
	local p, s = CaseBtn.AbsolutePosition, CaseBtn.AbsoluteSize
	Popup.Position = UDim2.fromOffset(p.X + s.X - 230, p.Y + s.Y + 6)
end

local Selected = "CFrame"

local options = {"CFrame","Part","Model","Mouse"}
for i,v in ipairs(options) do
	local b = Instance.new("TextButton", Popup)
	b.Size = UDim2.new(1, -16, 32)
	b.Position = UDim2.new(0, 8, 0, 8 + (i-1)*36)
	b.Text = v
	b.Font = Enum.Font.Gotham
	b.TextSize = 16
	b.TextColor3 = Color3.fromRGB(30,30,30)
	b.BackgroundColor3 = Color3.fromRGB(255,255,255)
	b.BorderSizePixel = 0
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,6)
	b.ZIndex = 101

	b.MouseButton1Click:Connect(function()
		Selected = v
		CaseBtn.Text = v.."  ?"
		Popup.Visible = false
	end)
end

CaseBtn.MouseButton1Click:Connect(function()
	Popup.Visible = not Popup.Visible
	if Popup.Visible then popupPos() end
end)

-- Logic
local currentText

local function setText(t)
	Coord.Text = t or ""
	Coord.Visible = t ~= nil
	currentText = t
end

Check.MouseButton1Click:Connect(function()
	local char = Player.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if Selected == "CFrame" and hrp then
		setText(string.format("CFrame.new(%.3f, %.3f, %.3f)", hrp.Position.X, hrp.Position.Y, hrp.Position.Z))
	elseif Selected == "Mouse" then
		local m = Player:GetMouse()
		setText(tostring(m.Hit))
	else
		setText("Click vào world ð? ch?n "..Selected)
	end
end)

Copy.MouseButton1Click:Connect(function()
	if currentText then
		pcall(function() setclipboard(currentText) end)
	end
end)

Close.MouseButton1Click:Connect(function()
	gui:Destroy()
end)
