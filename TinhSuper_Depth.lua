-- LocalScript: TinhSuper Hub - Adjusted (smaller UI, reliable font, wider coord, case up)
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- remove previous
pcall(function()
	local old = PlayerGui:FindFirstChild("TinhSuper_Coord_UI")
	if old then old:Destroy() end
end)

-- ScreenGui
local Gui = Instance.new("ScreenGui")
Gui.Name = "TinhSuper_Coord_UI"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.Parent = PlayerGui

-- helper setZ
local function setZ(obj, z)
	if obj:IsA("GuiObject") then obj.ZIndex = z end
	for _,d in ipairs(obj:GetDescendants()) do
		if d:IsA("GuiObject") then d.ZIndex = z + 1 end
	end
end

-- ========== LAYER 1: N?N (NH? HÕN) ==========
local Main = Instance.new("Frame")
Main.Name = "Layer1_Main"
Main.Size = UDim2.new(0, 640, 0, 260)       -- smaller
Main.Position = UDim2.new(0, 80, 0, 60)
Main.BackgroundColor3 = Color3.fromRGB(58,58,58)
Main.BorderSizePixel = 0
Main.Parent = Gui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0,12)
Main.Active = true

-- drag whole Main (mouse + touch)
do
	local dragging = false
	local dragStart, startPos
	Main.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = Main.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	UIS.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
end
setZ(Main, 10)

-- ========== LAYER 2: CH? & NÚT ==========
-- Title (top-left)
local Title = Instance.new("TextLabel", Main)
Title.Name = "Title"
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.SourceSansBold        -- reliable font
Title.TextSize = 22
Title.Text = "TinhSuper Hub"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Position = UDim2.new(0, 14, 0, 10)
Title.Size = UDim2.new(0.6, 0, 0, 28)

-- by under title, moved down a bit
local By = Instance.new("TextLabel", Main)
By.Name = "By"
By.BackgroundTransparency = 1
By.Font = Enum.Font.SourceSans
By.TextSize = 13
By.Text = "by tinhsuper_gm"
By.TextColor3 = Color3.fromRGB(210,210,210)
By.TextXAlignment = Enum.TextXAlignment.Left
By.Position = UDim2.new(0, 14, 0, 40)
By.Size = UDim2.new(0.6, 0, 0, 18)

-- "T?a ð? c?a b?n là:" moved up a bit (bigger, red)
local LabelCoord = Instance.new("TextLabel", Main)
LabelCoord.Name = "LabelCoord"
LabelCoord.BackgroundTransparency = 1
LabelCoord.Font = Enum.Font.SourceSansBold
LabelCoord.TextSize = 18
LabelCoord.Text = "T?a ð? c?a b?n là:"
LabelCoord.TextColor3 = Color3.fromRGB(220,40,40)
LabelCoord.TextXAlignment = Enum.TextXAlignment.Left
LabelCoord.Position = UDim2.new(0, 14, 0, 70) -- moved up
LabelCoord.Size = UDim2.new(0.6, 0, 0, 22)

-- Case button: placed on right, 1/3 but moved slightly up
local CaseBtn = Instance.new("TextButton", Main)
CaseBtn.Name = "CaseBtn"
CaseBtn.Font = Enum.Font.SourceSansBold
CaseBtn.TextSize = 15
CaseBtn.Text = "Trý?ng H?p  ?"
CaseBtn.TextColor3 = Color3.new(1,1,1)
CaseBtn.BackgroundColor3 = Color3.fromRGB(86,86,86)
CaseBtn.BorderSizePixel = 0
CaseBtn.Size = UDim2.new(0, 180, 0, 34)
-- position: right, ~1/3 from top but slightly up
CaseBtn.Position = UDim2.new(1, -200, 0, 64)
Instance.new("UICorner", CaseBtn).CornerRadius = UDim.new(0,8)

-- Ki?m tra button (left bottom)
local CheckBtn = Instance.new("TextButton", Main)
CheckBtn.Name = "CheckBtn"
CheckBtn.Font = Enum.Font.SourceSansBold
CheckBtn.TextSize = 16
CheckBtn.Text = "Ki?m tra t?a ð?"
CheckBtn.TextColor3 = Color3.new(1,1,1)
CheckBtn.BackgroundColor3 = Color3.fromRGB(36,160,72)
CheckBtn.BorderSizePixel = 0
CheckBtn.Size = UDim2.new(0, 240, 0, 44)
CheckBtn.Position = UDim2.new(0, 14, 1, -68)
Instance.new("UICorner", CheckBtn).CornerRadius = UDim.new(0,8)

-- Copy button (right bottom)
local CopyBtn = Instance.new("TextButton", Main)
CopyBtn.Name = "CopyBtn"
CopyBtn.Font = Enum.Font.SourceSansBold
CopyBtn.TextSize = 16
CopyBtn.Text = "Sao chép t?a ð?"
CopyBtn.TextColor3 = Color3.new(1,1,1)
CopyBtn.BackgroundColor3 = Color3.fromRGB(60,128,204)
CopyBtn.BorderSizePixel = 0
CopyBtn.Size = UDim2.new(0, 240, 0, 44)
CopyBtn.Position = UDim2.new(1, -254, 1, -68)
Instance.new("UICorner", CopyBtn).CornerRadius = UDim.new(0,8)

-- X circle in middle
local CloseCircle = Instance.new("TextButton", Main)
CloseCircle.Name = "CloseCircle"
CloseCircle.Font = Enum.Font.SourceSansBold
CloseCircle.TextSize = 18
CloseCircle.Text = "X"
CloseCircle.TextColor3 = Color3.fromRGB(30,30,30)
CloseCircle.BackgroundColor3 = Color3.fromRGB(245,245,245)
CloseCircle.BorderSizePixel = 0
CloseCircle.Size = UDim2.new(0,46,0,46)
CloseCircle.Position = UDim2.new(0.5, -23, 1, -76)
Instance.new("UICorner", CloseCircle).CornerRadius = UDim.new(1,0)

-- set Layer 2 Z
setZ(Title, 20); setZ(By, 20); setZ(LabelCoord, 20)
setZ(CaseBtn, 20); setZ(CheckBtn,20); setZ(CopyBtn,20); setZ(CloseCircle,20)

-- ========== LAYER 3: KHUNG T?A Ð? (R?NG HÕN SANG PH?I) ==========
local CoordFrame = Instance.new("Frame", Main)
CoordFrame.Name = "Layer3_CoordFrame"
CoordFrame.Size = UDim2.new(0.9, 0, 0, 78)   -- wider to the right (0.9 of main width)
CoordFrame.Position = UDim2.new(0, 14, 0, 98) -- below LabelCoord
CoordFrame.BackgroundColor3 = Color3.fromRGB(95,95,95) -- lighter than outer
CoordFrame.BorderSizePixel = 0
Instance.new("UICorner", CoordFrame).CornerRadius = UDim.new(0,8)
CoordFrame.ZIndex = 30

local CoordText = Instance.new("TextLabel", CoordFrame)
CoordText.Name = "CoordText"
CoordText.Size = UDim2.new(1, -20, 1, -20)
CoordText.Position = UDim2.new(0, 10, 0, 10)
CoordText.BackgroundTransparency = 1
CoordText.Font = Enum.Font.SourceSansBold
CoordText.TextSize = 16
CoordText.TextColor3 = Color3.fromRGB(255,255,255)
CoordText.TextXAlignment = Enum.TextXAlignment.Left
CoordText.TextYAlignment = Enum.TextYAlignment.Top
CoordText.TextWrapped = true
CoordText.Text = ""
CoordText.Visible = false
setZ(CoordFrame, 30); setZ(CoordText, 30)

-- ========== LAYER 4: POPUP (Trý?ng H?p) ==========
local Popup = Instance.new("Frame")
Popup.Name = "Layer4_Popup"
Popup.Parent = Gui -- as overlay so it's always above Main
Popup.Size = UDim2.new(0, 180, 0, 150)
Popup.BackgroundColor3 = Color3.fromRGB(80,80,80)
Popup.BorderSizePixel = 0
Popup.Visible = false
Instance.new("UICorner", Popup).CornerRadius = UDim.new(0,8)

-- options
local options = {"CFrame","Part","Model","Mouse"}
local Selected = "CFrame"
for i,opt in ipairs(options) do
	local b = Instance.new("TextButton", Popup)
	b.Size = UDim2.new(1, -16, 0, 32)
	b.Position = UDim2.new(0, 8, 0, 8 + (i-1)*36)
	b.BackgroundColor3 = Color3.fromRGB(100,100,100)
	b.Font = Enum.Font.SourceSans
	b.TextSize = 14
	b.Text = opt
	b.TextColor3 = Color3.fromRGB(245,245,245)
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,6)
	b.MouseButton1Click:Connect(function()
		Selected = opt
		CaseBtn.Text = opt.."  ?"
		Popup.Visible = false
	end)
end

-- helper to position popup under CaseBtn aligned right
local function positionPopup()
	RunService.RenderStepped:Wait()
	local ddPos = CaseBtn.AbsolutePosition
	local ddSize = CaseBtn.AbsoluteSize
	local popupW = Popup.AbsoluteSize.X
	local popupH = Popup.AbsoluteSize.Y
	local px = ddPos.X + ddSize.X - popupW -- align right edge
	local py = ddPos.Y + ddSize.Y + 6
	local screenW, screenH = workspace.CurrentCamera.ViewportSize.X, workspace.CurrentCamera.ViewportSize.Y
	if px < 8 then px = 8 end
	if py + popupH + 8 > screenH then
		py = ddPos.Y - popupH - 6
		if py < 8 then py = 8 end
	end
	Popup.Position = UDim2.new(0, math.floor(px), 0, math.floor(py))
	setZ(Popup, 40)
end

CaseBtn.MouseButton1Click:Connect(function()
	Popup.Visible = not Popup.Visible
	if Popup.Visible then positionPopup() end
end)

UIS.InputBegan:Connect(function(input, gp)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		if Popup.Visible then
			local mouse = UIS:GetMouseLocation()
			local ppos = Popup.AbsolutePosition
			local psize = Popup.AbsoluteSize
			if not (mouse.X >= ppos.X and mouse.X <= ppos.X + psize.X and mouse.Y >= ppos.Y and mouse.Y <= ppos.Y + psize.Y) then
				local ddp = CaseBtn.AbsolutePosition
				local dds = CaseBtn.AbsoluteSize
				if not (mouse.X >= ddp.X and mouse.X <= ddp.X + dds.X and mouse.Y >= ddp.Y and mouse.Y <= ddp.Y + dds.Y) then
					Popup.Visible = false
				end
			end
		end
	end
end)

-- ========== LOGIC: Check / Copy / Close ==========
CheckBtn.MouseButton1Click:Connect(function()
	Popup.Visible = false
	if Selected == "CFrame" then
		local hrp = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
		if hrp then
			CoordText.Text = string.format("CFrame.new(%.3f, %.3f, %.3f)", hrp.Position.X, hrp.Position.Y, hrp.Position.Z)
			CoordText.Visible = true
		else
			CoordText.Text = "(Không t?m th?y nhân v?t)"
			CoordText.Visible = true
		end
	elseif Selected == "Mouse" then
		local m = Player:GetMouse()
		if m and m.Hit then
			local p = m.Hit.Position
			CoordText.Text = string.format("Vector3.new(%.3f, %.3f, %.3f)", p.X, p.Y, p.Z)
			CoordText.Visible = true
		else
			CoordText.Text = "(Không l?y ðý?c mouse.Hit)"
			CoordText.Visible = true
		end
	else -- Part / Model
		CoordText.Text = "(Click vào world ð? ch?n "..Selected..")"
		CoordText.Visible = true
		local m = Player:GetMouse()
		local conn
		conn = m.Button1Down:Connect(function()
			local target = m.Target
			if target and target:IsA("BasePart") then
				if Selected == "Part" then
					CoordText.Text = string.format("CFrame.new(%.3f, %.3f, %.3f)", target.Position.X, target.Position.Y, target.Position.Z)
				else
					local model = target:FindFirstAncestorOfClass("Model")
					local partForPos = model and (model:FindFirstChild("HumanoidRootPart") or model.PrimaryPart) or target
					CoordText.Text = string.format("CFrame.new(%.3f, %.3f, %.3f)", partForPos.Position.X, partForPos.Position.Y, partForPos.Position.Z)
				end
			else
				CoordText.Text = "(Click không h?p l?, th? l?i)"
			end
			CoordText.Visible = true
			if conn then conn:Disconnect() end
		end)
		-- cleanup if GUI destroyed
		Gui.AncestryChanged:Connect(function()
			if not Gui:IsDescendantOf(game) and conn then conn:Disconnect() end
		end)
	end
end)

CopyBtn.MouseButton1Click:Connect(function()
	if CoordText.Visible and CoordText.Text ~= "" then
		pcall(function() setclipboard(CoordText.Text) end)
	end
end)

CloseCircle.MouseButton1Click:Connect(function()
	Gui:Destroy()
end)

-- initial Z layers
setZ(Main, 10)
setZ(Title, 20); setZ(By, 20); setZ(LabelCoord, 20)
setZ(CaseBtn, 20); setZ(CheckBtn,20); setZ(CopyBtn,20); setZ(CloseCircle,20)
setZ(CoordFrame, 30); setZ(CoordText, 30)
setZ(Popup, 40)
