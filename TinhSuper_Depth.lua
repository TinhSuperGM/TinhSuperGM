--// TinhSuper Coordinate UI
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local Player = Players.LocalPlayer

--// ScreenGui
local ScreenGui = Instance.new("ScreenGui", Player.PlayerGui)
ScreenGui.Name = "TinhSuper_Coord_UI"
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false

--======================
-- L?P 1 - N?N (DRAG)
--======================
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.fromScale(0.7, 0.45)
Main.Position = UDim2.fromScale(0.15, 0.25)
Main.BackgroundColor3 = Color3.fromRGB(55,55,55)
Main.BorderSizePixel = 0
Main.ZIndex = 10
Main.Active = true

local Corner = Instance.new("UICorner", Main)
Corner.CornerRadius = UDim.new(0,16)

-- Drag
do
	local dragging, dragStart, startPos
	Main.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = i.Position
			startPos = Main.Position
		end
	end)
	UIS.InputChanged:Connect(function(i)
		if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = i.Position - dragStart
			Main.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)
		end
	end)
	UIS.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)
end

--======================
-- L?P 2 - CH? & NÚT
--======================
local function label(text, size, posY)
	local l = Instance.new("TextLabel", Main)
	l.Size = UDim2.fromScale(1, size)
	l.Position = UDim2.fromScale(0, posY)
	l.BackgroundTransparency = 1
	l.Text = text
	l.TextColor3 = Color3.fromRGB(255,255,255)
	l.Font = Enum.Font.GothamBold
	l.TextScaled = true
	l.ZIndex = 20
	return l
end

label("TinhSuper Hub", 0.12, 0.05)

local Credit = label("by tinhsuper_gm", 0.07, 0.17)
Credit.Font = Enum.Font.Gotham

-- Trý?ng h?p
local CaseBtn = Instance.new("TextButton", Main)
CaseBtn.Size = UDim2.fromScale(0.35, 0.1)
CaseBtn.Position = UDim2.fromScale(0.05, 0.3)
CaseBtn.Text = "Trý?ng H?p"
CaseBtn.Font = Enum.Font.GothamBold
CaseBtn.TextScaled = true
CaseBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
CaseBtn.TextColor3 = Color3.new(1,1,1)
CaseBtn.ZIndex = 20
Instance.new("UICorner", CaseBtn)

label("T?a ð? c?a b?n là:", 0.08, 0.45)

--======================
-- L?P 3 - T?A Ð?
--======================
local CoordLabel = label("", 0.1, 0.55)

--======================
-- NÚT
--======================
local CheckBtn = Instance.new("TextButton", Main)
CheckBtn.Size = UDim2.fromScale(0.35, 0.12)
CheckBtn.Position = UDim2.fromScale(0.05, 0.75)
CheckBtn.Text = "Ki?m Tra T?a Ð?"
CheckBtn.Font = Enum.Font.GothamBold
CheckBtn.TextScaled = true
CheckBtn.BackgroundColor3 = Color3.fromRGB(40,160,80)
CheckBtn.TextColor3 = Color3.new(1,1,1)
CheckBtn.ZIndex = 20
Instance.new("UICorner", CheckBtn)

local CopyBtn = Instance.new("TextButton", Main)
CopyBtn.Size = UDim2.fromScale(0.35, 0.12)
CopyBtn.Position = UDim2.fromScale(0.6, 0.75)
CopyBtn.Text = "Sao chép t?a ð?"
CopyBtn.Font = Enum.Font.GothamBold
CopyBtn.TextScaled = true
CopyBtn.BackgroundColor3 = Color3.fromRGB(70,130,200)
CopyBtn.TextColor3 = Color3.new(1,1,1)
CopyBtn.ZIndex = 20
Instance.new("UICorner", CopyBtn)

-- X tr?n gi?a
local Close = Instance.new("TextButton", Main)
Close.Size = UDim2.fromScale(0.1,0.12)
Close.Position = UDim2.fromScale(0.45,0.75)
Close.Text = "X"
Close.Font = Enum.Font.GothamBold
Close.TextScaled = true
Close.BackgroundColor3 = Color3.fromRGB(200,70,70)
Close.TextColor3 = Color3.new(1,1,1)
Close.ZIndex = 20
Instance.new("UICorner", Close).CornerRadius = UDim.new(1,0)

Close.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)

--======================
-- L?P 4 - POPUP TRÝ?NG H?P
--======================
local Popup = Instance.new("Frame", Main)
Popup.Size = UDim2.fromScale(0.35, 0.28)
Popup.Position = UDim2.fromScale(0.42, 0.3)
Popup.BackgroundColor3 = Color3.fromRGB(70,70,70)
Popup.Visible = false
Popup.ZIndex = 50
Instance.new("UICorner", Popup)

local cases = {"CFrame","Part","Model","Mouse"}
for i,v in ipairs(cases) do
	local b = Instance.new("TextButton", Popup)
	b.Size = UDim2.fromScale(1, 0.25)
	b.Position = UDim2.fromScale(0, (i-1)*0.25)
	b.Text = v
	b.Font = Enum.Font.GothamBold
	b.TextScaled = true
	b.BackgroundColor3 = Color3.fromRGB(90,90,90)
	b.TextColor3 = Color3.new(1,1,1)
	b.ZIndex = 55
	b.MouseButton1Click:Connect(function()
		CaseBtn.Text = v
		Popup.Visible = false
	end)
end

CaseBtn.MouseButton1Click:Connect(function()
	Popup.Visible = not Popup.Visible
end)

--======================
-- LOGIC T?A Ð?
--======================
CheckBtn.MouseButton1Click:Connect(function()
	local hrp = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	local cf = hrp.CFrame
	CoordLabel.Text = string.format(
		"%.2f, %.2f, %.2f",
		cf.X, cf.Y, cf.Z
	)
end)

CopyBtn.MouseButton1Click:Connect(function()
	if setclipboard then
		setclipboard(CoordLabel.Text)
	end
end)
