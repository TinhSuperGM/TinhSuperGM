--// TinhSuper Hub - Coordinate UI (FINAL ADJUSTED)
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local Player = Players.LocalPlayer

pcall(function()
	Player.PlayerGui:FindFirstChild("TinhSuper_Coord_UI"):Destroy()
end)

local Gui = Instance.new("ScreenGui", Player.PlayerGui)
Gui.Name = "TinhSuper_Coord_UI"
Gui.IgnoreGuiInset = true
Gui.ResetOnSpawn = false

--======================
-- L?P 1 - N?N (DRAG)
--======================
local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.fromScale(0.72, 0.46)
Main.Position = UDim2.fromScale(0.14, 0.24)
Main.BackgroundColor3 = Color3.fromRGB(60,60,60)
Main.BorderSizePixel = 0
Main.Active = true
Main.ZIndex = 10
Instance.new("UICorner", Main).CornerRadius = UDim.new(0,18)

-- Drag UI
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
-- HEADER
--======================
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.fromScale(0.5, 0.1)
Title.Position = UDim2.fromScale(0.03, 0.04)
Title.BackgroundTransparency = 1
Title.Text = "TinhSuper Hub"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 26
Title.TextXAlignment = Left
Title.TextColor3 = Color3.new(1,1,1)
Title.ZIndex = 20

local Credit = Instance.new("TextLabel", Main)
Credit.Size = UDim2.fromScale(0.5, 0.06)
Credit.Position = UDim2.fromScale(0.03, 0.145) -- ? xu?ng thêm
Credit.BackgroundTransparency = 1
Credit.Text = "by tinhsuper_gm"
Credit.Font = Enum.Font.GothamMedium
Credit.TextSize = 14
Credit.TextXAlignment = Left
Credit.TextColor3 = Color3.fromRGB(210,210,210)
Credit.ZIndex = 20

--======================
-- LABEL T?A Ð? (Ð?)
--======================
local Info = Instance.new("TextLabel", Main)
Info.Size = UDim2.fromScale(0.45, 0.1)
Info.Position = UDim2.fromScale(0.03, 0.32) -- ? lên
Info.BackgroundTransparency = 1
Info.Text = "T?a ð? c?a b?n là:"
Info.Font = Enum.Font.GothamBold
Info.TextSize = 22
Info.TextXAlignment = Left
Info.TextColor3 = Color3.fromRGB(220,40,40)
Info.ZIndex = 20

--======================
-- KHUNG T?A Ð? (R?NG)
--======================
local CoordBox = Instance.new("Frame", Main)
CoordBox.Size = UDim2.fromScale(0.7, 0.18) -- ? r?ng sang ph?i
CoordBox.Position = UDim2.fromScale(0.03, 0.44)
CoordBox.BackgroundColor3 = Color3.fromRGB(92,92,92)
CoordBox.BorderSizePixel = 0
CoordBox.ZIndex = 15
Instance.new("UICorner", CoordBox).CornerRadius = UDim.new(0,12)

local CoordText = Instance.new("TextLabel", CoordBox)
CoordText.Size = UDim2.fromScale(0.96, 0.9)
CoordText.Position = UDim2.fromScale(0.02, 0.05)
CoordText.BackgroundTransparency = 1
CoordText.Font = Enum.Font.GothamBold
CoordText.TextSize = 20
CoordText.TextWrapped = true
CoordText.TextXAlignment = Left
CoordText.Text = ""
CoordText.TextColor3 = Color3.new(1,1,1)
CoordText.ZIndex = 20

--======================
-- TRÝ?NG H?P (BÊN PH?I)
--======================
local CaseBtn = Instance.new("TextButton", Main)
CaseBtn.Size = UDim2.fromScale(0.28, 0.1)
CaseBtn.Position = UDim2.fromScale(0.69, 0.33)
CaseBtn.Text = "Trý?ng H?p"
CaseBtn.Font = Enum.Font.GothamBold
CaseBtn.TextSize = 18
CaseBtn.BackgroundColor3 = Color3.fromRGB(85,85,85)
CaseBtn.TextColor3 = Color3.new(1,1,1)
CaseBtn.ZIndex = 20
Instance.new("UICorner", CaseBtn)

-- Popup
local Popup = Instance.new("Frame", Main)
Popup.Size = UDim2.fromScale(0.28, 0.32)
Popup.Position = UDim2.fromScale(0.69, 0.44)
Popup.BackgroundColor3 = Color3.fromRGB(80,80,80)
Popup.Visible = false
Popup.ZIndex = 50
Instance.new("UICorner", Popup)

local cases = {"CFrame","Part","Model","Mouse"}
local Selected = "CFrame"

for i,v in ipairs(cases) do
	local b = Instance.new("TextButton", Popup)
	b.Size = UDim2.fromScale(1, 0.25)
	b.Position = UDim2.fromScale(0, (i-1)*0.25)
	b.Text = v
	b.Font = Enum.Font.Gotham
	b.TextSize = 16
	b.BackgroundColor3 = Color3.fromRGB(95,95,95)
	b.TextColor3 = Color3.new(1,1,1)
	b.ZIndex = 55
	b.MouseButton1Click:Connect(function()
		Selected = v
		CaseBtn.Text = v
		Popup.Visible = false
	end)
end

CaseBtn.MouseButton1Click:Connect(function()
	Popup.Visible = not Popup.Visible
end)

--======================
-- NÚT DÝ?I
--======================
local Check = Instance.new("TextButton", Main)
Check.Size = UDim2.fromScale(0.32, 0.12)
Check.Position = UDim2.fromScale(0.05, 0.78)
Check.Text = "Ki?m Tra T?a Ð?"
Check.Font = Enum.Font.GothamBold
Check.TextSize = 18
Check.BackgroundColor3 = Color3.fromRGB(45,170,80)
Check.TextColor3 = Color3.new(1,1,1)
Check.ZIndex = 20
Instance.new("UICorner", Check)

local Copy = Instance.new("TextButton", Main)
Copy.Size = UDim2.fromScale(0.32, 0.12)
Copy.Position = UDim2.fromScale(0.63, 0.78)
Copy.Text = "Sao chép t?a ð?"
Copy.Font = Enum.Font.GothamBold
Copy.TextSize = 18
Copy.BackgroundColor3 = Color3.fromRGB(70,130,210)
Copy.TextColor3 = Color3.new(1,1,1)
Copy.ZIndex = 20
Instance.new("UICorner", Copy)

local Close = Instance.new("TextButton", Main)
Close.Size = UDim2.fromScale(0.1, 0.12)
Close.Position = UDim2.fromScale(0.45, 0.78)
Close.Text = "X"
Close.Font = Enum.Font.GothamBold
Close.TextSize = 20
Close.BackgroundColor3 = Color3.fromRGB(200,70,70)
Close.TextColor3 = Color3.new(1,1,1)
Close.ZIndex = 20
Instance.new("UICorner", Close).CornerRadius = UDim.new(1,0)

Close.MouseButton1Click:Connect(function()
	Gui:Destroy()
end)

--======================
-- LOGIC
--======================
Check.MouseButton1Click:Connect(function()
	local hrp = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
	if hrp then
		CoordText.Text = string.format(
			"CFrame.new(%.2f, %.2f, %.2f)",
			hrp.Position.X,
			hrp.Position.Y,
			hrp.Position.Z
		)
	end
end)

Copy.MouseButton1Click:Connect(function()
	if CoordText.Text ~= "" and setclipboard then
		setclipboard(CoordText.Text)
	end
end)
