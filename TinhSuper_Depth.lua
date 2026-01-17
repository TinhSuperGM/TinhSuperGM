-- LocalScript: TinhSuper Hub - Final (layers, positions, fonts)
-- Paste vào StarterPlayerScripts

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- remove old if exists
pcall(function()
	local old = PlayerGui:FindFirstChild("TinhSuper_FinalUI")
	if old then old:Destroy() end
end)

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TinhSuper_FinalUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = PlayerGui

-- helper to set ZIndex for object + descendants
local function setZ(root, z)
	if root and root:IsA("GuiObject") then
		root.ZIndex = z
	end
	for _,c in ipairs(root:GetDescendants()) do
		if c:IsA("GuiObject") then
			c.ZIndex = z + 0 -- keep same for now; we'll call per-layer with appropriate z
		end
	end
end

-- =====================
-- LAYER 1: N?N XÁM (DRAGGABLE)
-- =====================
local Main = Instance.new("Frame")
Main.Name = "Layer1_Main"
Main.Size = UDim2.new(0, 900, 0, 360)              -- wide enough
Main.Position = UDim2.new(0, 60, 0, 60)            -- initial top-left-ish
Main.AnchorPoint = Vector2.new(0,0)
Main.BackgroundColor3 = Color3.fromRGB(58,58,58)   -- outer darker grey
Main.BorderSizePixel = 0
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0,14)
Main.Active = true

-- drag (drag whole Main by mouse or touch)
do
	local dragging = false
	local dragStartPos
	local startPos
	Main.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStartPos = input.Position
			startPos = Main.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	Main.InputChanged:Connect(function(input)
		-- noop (we rely on global InputChanged below)
	end)
	UIS.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStartPos
			Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
end

-- set layer 1 Z
setZ(Main, 10)

-- =====================
-- LAYER 2: CH? & NÚT (Title, by, Trý?ng H?p, Ki?m Tra, Sao chép, X circle)
-- =====================

-- Title (top-left)
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Parent = Main
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 28
Title.Text = "TinhSuper Hub"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Position = UDim2.new(0, 18, 0, 14)
Title.Size = UDim2.new(0.5, -36, 0, 36)

-- by (just below title, moved down a bit)
local By = Instance.new("TextLabel")
By.Name = "By"
By.Parent = Main
By.BackgroundTransparency = 1
By.Font = Enum.Font.Gotham
By.TextSize = 14
By.Text = "by tinhsuper_gm"
By.TextColor3 = Color3.fromRGB(210,210,210)
By.TextXAlignment = Enum.TextXAlignment.Left
By.Position = UDim2.new(0, 18, 0, 52) -- slightly below Title (moved down)
By.Size = UDim2.new(0.5, -36, 0, 22)

-- "T?a ð? c?a b?n là:" moved up a bit, larger, red, middle-left
local LabelCoord = Instance.new("TextLabel")
LabelCoord.Name = "LabelCoord"
LabelCoord.Parent = Main
LabelCoord.BackgroundTransparency = 1
LabelCoord.Font = Enum.Font.GothamBold
LabelCoord.TextSize = 20
LabelCoord.Text = "T?a ð? c?a b?n là:"
LabelCoord.TextColor3 = Color3.fromRGB(220,40,40)
LabelCoord.TextXAlignment = Enum.TextXAlignment.Left
-- positioned somewhat center-left (up a bit)
LabelCoord.Position = UDim2.new(0, 18, 0, 100) -- moved up relative to previous
LabelCoord.Size = UDim2.new(0.5, -36, 0, 28)

-- Case button (1/3 from top, on the right)
local CaseBtn = Instance.new("TextButton")
CaseBtn.Name = "CaseBtn"
CaseBtn.Parent = Main
CaseBtn.Font = Enum.Font.GothamBold
CaseBtn.TextSize = 16
CaseBtn.Text = "Trý?ng H?p  ?"
CaseBtn.TextColor3 = Color3.new(1,1,1)
CaseBtn.BackgroundColor3 = Color3.fromRGB(86,86,86)
CaseBtn.BorderSizePixel = 0
CaseBtn.AutoButtonColor = true
CaseBtn.Position = UDim2.new(1, -260, 0, math.floor(Main.AbsoluteSize.Y * 0.33) - 10) -- we'll reposition after render
CaseBtn.Size = UDim2.new(0, 220, 0, 34)
Instance.new("UICorner", CaseBtn).CornerRadius = UDim.new(0,8)

-- Ki?m Tra (left bottom)
local CheckBtn = Instance.new("TextButton")
CheckBtn.Name = "CheckBtn"
CheckBtn.Parent = Main
CheckBtn.Font = Enum.Font.GothamBold
CheckBtn.TextSize = 18
CheckBtn.Text = "Ki?m tra t?a ð?"
CheckBtn.TextColor3 = Color3.new(1,1,1)
CheckBtn.BackgroundColor3 = Color3.fromRGB(36,160,72)
CheckBtn.BorderSizePixel = 0
CheckBtn.Size = UDim2.new(0, 300, 0, 46)
CheckBtn.Position = UDim2.new(0, 18, 1, -78)
Instance.new("UICorner", CheckBtn).CornerRadius = UDim.new(0,8)

-- Sao chép (right bottom) - mirrored position
local CopyBtn = Instance.new("TextButton")
CopyBtn.Name = "CopyBtn"
CopyBtn.Parent = Main
CopyBtn.Font = Enum.Font.GothamBold
CopyBtn.TextSize = 18
CopyBtn.Text = "Sao chép t?a ð?"
CopyBtn.TextColor3 = Color3.new(1,1,1)
CopyBtn.BackgroundColor3 = Color3.fromRGB(60,128,204)
CopyBtn.BorderSizePixel = 0
CopyBtn.Size = UDim2.new(0, 300, 0, 46)
CopyBtn.Position = UDim2.new(1, -318, 1, -78) -- placed to right, symmetric to CheckBtn
Instance.new("UICorner", CopyBtn).CornerRadius = UDim.new(0,8)

-- X circular between the two buttons
local CloseCircle = Instance.new("TextButton")
CloseCircle.Name = "CloseCircle"
CloseCircle.Parent = Main
CloseCircle.Font = Enum.Font.GothamBold
CloseCircle.TextSize = 20
CloseCircle.Text = "X"
CloseCircle.TextColor3 = Color3.fromRGB(30,30,30)
CloseCircle.BackgroundColor3 = Color3.fromRGB(245,245,245)
CloseCircle.BorderSizePixel = 0
CloseCircle.Size = UDim2.new(0,54,0,54)
-- place center between CheckBtn and CopyBtn
CloseCircle.Position = UDim2.new(0.5, -27, 1, -86)
Instance.new("UICorner", CloseCircle).CornerRadius = UDim.new(1,0)

-- no top-right X; ensure none created

-- set Layer 2 Z
setZ(Title, 20)
setZ(By, 20)
setZ(LabelCoord, 20)
setZ(CaseBtn, 20)
setZ(CheckBtn, 20)
setZ(CopyBtn, 20)
setZ(CloseCircle, 20)

-- =====================
-- LAYER 3: T?A Ð? HI?N TH? (KHÔNG HI?N CH? TRÝ?C)
-- =====================
local CoordFrame = Instance.new("Frame")
CoordFrame.Name = "Layer3_CoordFrame"
CoordFrame.Parent = Main
CoordFrame.Size = UDim2.new(0.68, 0, 0, 120) -- wide to the right (bigger)
CoordFrame.Position = UDim2.new(0, 18, 0, 132) -- just below LabelCoord, expands right
CoordFrame.BackgroundColor3 = Color3.fromRGB(95,95,95) -- lighter grey than outer
CoordFrame.BorderSizePixel = 0
Instance.new("UICorner", CoordFrame).CornerRadius = UDim.new(0,10)

local CoordText = Instance.new("TextLabel")
CoordText.Name = "CoordText"
CoordText.Parent = CoordFrame
CoordText.Size = UDim2.new(1, -20, 1, -20)
CoordText.Position = UDim2.new(0, 10, 0, 10)
CoordText.BackgroundTransparency = 1
CoordText.Font = Enum.Font.GothamBold
CoordText.TextSize = 20
CoordText.TextColor3 = Color3.fromRGB(255,255,255)
CoordText.TextXAlignment = Enum.TextXAlignment.Left
CoordText.TextYAlignment = Enum.TextYAlignment.Top
CoordText.TextWrapped = true
CoordText.Text = ""         -- initially empty
CoordText.Visible = false   -- hidden until check
CoordText.ZIndex = 30

-- set Layer 3 Z
setZ(CoordFrame, 30)
setZ(CoordText, 30)

-- =====================
-- LAYER 4: POPUP (Trý?ng H?p) - initially hidden, positioned under CaseBtn, aligned right
-- =====================
local Popup = Instance.new("Frame")
Popup.Name = "Layer4_Popup"
Popup.Parent = ScreenGui   -- parent to ScreenGui so it can be above Main easily
Popup.Size = UDim2.new(0, 220, 0, 160)
Popup.BackgroundColor3 = Color3.fromRGB(80,80,80)
Popup.BorderSizePixel = 0
Popup.Visible = false
Instance.new("UICorner", Popup).CornerRadius = UDim.new(0,10)

-- create option buttons inside popup
local options = {"CFrame","Part","Model","Mouse"}
for i,opt in ipairs(options) do
	local b = Instance.new("TextButton")
	b.Name = "Opt_"..opt
	b.Parent = Popup
	b.Size = UDim2.new(1, -16, 0, 34)
	b.Position = UDim2.new(0, 8, 0, 8 + (i-1)*38)
	b.BackgroundColor3 = Color3.fromRGB(100,100,100)
	b.Font = Enum.Font.Gotham
	b.TextSize = 16
	b.TextColor3 = Color3.fromRGB(245,245,245)
	b.Text = opt
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,6)
	b.ZIndex = 50

	b.MouseButton1Click:Connect(function()
		-- set selection, update CaseBtn text and hide popup
		CaseBtn.Text = opt.."  ?"
		Popup.Visible = false
		Selected = opt
	end)
end

-- helper: position popup under CaseBtn and aligned right with CaseBtn
local function positionPopup()
	-- wait one frame to ensure AbsolutePosition available
	RunService.RenderStepped:Wait()
	local ddPos = CaseBtn.AbsolutePosition
	local ddSize = CaseBtn.AbsoluteSize
	local popupW = Popup.AbsoluteSize.X
	local popupH = Popup.AbsoluteSize.Y
	-- align right edge of popup with right edge of CaseBtn
	local px = ddPos.X + ddSize.X - popupW
	local py = ddPos.Y + ddSize.Y + 8
	-- clamp to screen bounds
	local screenW, screenH = workspace.CurrentCamera.ViewportSize.X, workspace.CurrentCamera.ViewportSize.Y
	if px < 8 then px = 8 end
	if py + popupH + 8 > screenH then
		py = ddPos.Y - popupH - 8
		if py < 8 then py = 8 end
	end
	Popup.Position = UDim2.new(0, math.floor(px), 0, math.floor(py))
	Popup.ZIndex = 60
	for _,c in ipairs(Popup:GetDescendants()) do
		if c:IsA("GuiObject") then c.ZIndex = 61 end
	end
end

-- toggle popup on CaseBtn click
CaseBtn.MouseButton1Click:Connect(function()
	Popup.Visible = not Popup.Visible
	if Popup.Visible then positionPopup() end
end)

-- hide popup when clicking outside
UIS.InputBegan:Connect(function(input, gameProcessed)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		if Popup.Visible then
			local m = UIS:GetMouseLocation()
			local pp = Popup.AbsolutePosition
			local ps = Popup.AbsoluteSize
			if not (m.X >= pp.X and m.X <= pp.X + ps.X and m.Y >= pp.Y and m.Y <= pp.Y + ps.Y) then
				-- also skip clicks on CaseBtn (it toggles)
				local ddp = CaseBtn.AbsolutePosition
				local dds = CaseBtn.AbsoluteSize
				if not (m.X >= ddp.X and m.X <= ddp.X + dds.X and m.Y >= ddp.Y and m.Y <= ddp.Y + dds.Y) then
					Popup.Visible = false
				end
			end
		end
	end
end)

-- =====================
-- LOGIC: Check / Copy / Close
-- =====================

-- selection default
local Selected = "CFrame"

-- when pressing Check: show coord (or show message to click if Part/Model/Mouse)
CheckBtn.MouseButton1Click:Connect(function()
	-- hide popup if open
	Popup.Visible = false

	if Selected == "CFrame" then
		local char = Player.Character
		local hrp = char and char:FindFirstChild("HumanoidRootPart")
		if hrp then
			local p = hrp.Position
			local s = string.format("CFrame.new(%.3f, %.3f, %.3f)", p.X, p.Y, p.Z)
			CoordText.Text = s
			CoordText.Visible = true
		else
			CoordText.Text = "(Không t?m th?y nhân v?t)"
			CoordText.Visible = true
		end
	elseif Selected == "Mouse" then
		local m = Player:GetMouse()
		if m and m.Hit then
			local p = m.Hit.Position
			local s = string.format("Vector3.new(%.3f, %.3f, %.3f)", p.X, p.Y, p.Z)
			CoordText.Text = s
			CoordText.Visible = true
		else
			CoordText.Text = "(Không l?y ðý?c mouse.Hit)"
			CoordText.Visible = true
		end
	elseif Selected == "Part" or Selected == "Model" then
		CoordText.Text = "(Click vào world ð? ch?n "..Selected..")"
		CoordText.Visible = true
		-- wait for user's click and capture
		local m = Player:GetMouse()
		local conn
		conn = m.Button1Down:Connect(function()
			local target = m.Target
			if target and target:IsA("BasePart") then
				if Selected == "Part" then
					local s = string.format("CFrame.new(%.3f, %.3f, %.3f)", target.Position.X, target.Position.Y, target.Position.Z)
					CoordText.Text = s
					CoordText.Visible = true
				else -- Model
					local model = target:FindFirstAncestorOfClass("Model")
					if model then
						local hrp = model:FindFirstChild("HumanoidRootPart") or model.PrimaryPart or target
						local s = string.format("CFrame.new(%.3f, %.3f, %.3f)", hrp.Position.X, hrp.Position.Y, hrp.Position.Z)
						CoordText.Text = s
						CoordText.Visible = true
					else
						CoordText.Text = "(Không t?m th?y Model)"
						CoordText.Visible = true
					end
				end
			else
				CoordText.Text = "(Click không h?p l?, th? l?i)"
				CoordText.Visible = true
			end
			if conn then conn:Disconnect() end
		end)
		-- ensure we disconnect if UI closed
		ScreenGui.AncestryChanged:Connect(function()
			if not ScreenGui:IsDescendantOf(game) and conn then conn:Disconnect() end
		end)
	end
end)

-- Copy
CopyBtn.MouseButton1Click:Connect(function()
	if CoordText.Visible and CoordText.Text ~= "" and CoordText.Text ~= "(Click vào world ð? ch?n Part)" then
		pcall(function() setclipboard(CoordText.Text) end)
	end
end)

-- Close circle
CloseCircle.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)

-- Ensure Z order: set layers
setZ(Main, 10)          -- layer 1
-- Layer 2 elements: give higher Z
for _,obj in ipairs({Title, By, LabelCoord, CaseBtn, CheckBtn, CopyBtn, CloseCircle}) do
	setZ(obj, 20)
end
-- Layer 3 (coord)
setZ(CoordFrame, 30)
setZ(CoordText, 30)
-- Layer 4 popup highest
setZ(Popup, 60)

-- reposition CaseBtn based on actual Main size (to get 1/3 position)
RunService.Heartbeat:Wait()
local mainHeight = Main.AbsoluteSize.Y
local y = math.floor(Main.AbsolutePosition.Y + mainHeight * 0.33 - CaseBtn.AbsoluteSize.Y/2)
-- set using absolute offset relative to screen (we prefer using pixel to ensure visual match)
local ddX = Main.AbsolutePosition.X + Main.AbsoluteSize.X - 260
local ddY = y
CaseBtn.Position = UDim2.new(0, ddX - ScreenGui.AbsolutePosition.X, 0, ddY - ScreenGui.AbsolutePosition.Y)
-- reposition popup initially to be ready (if user opens)
positionPopup = positionPopup -- ensure function exists in scope
-- done
