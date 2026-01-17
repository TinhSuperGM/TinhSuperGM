-- LocalScript: TinhSuper Hub - FINAL (fonts Gotham, size fixed, 4 layers)
-- Paste into StarterPlayer -> StarterPlayerScripts

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- cleanup old
pcall(function()
	local old = PlayerGui:FindFirstChild("TinhSuper_Final")
	if old then old:Destroy() end
end)

-- helper: set Z index recursively
local function setZ(obj, z)
	if obj and obj:IsA("GuiObject") then obj.ZIndex = z end
	for _,d in ipairs(obj:GetDescendants()) do
		if d:IsA("GuiObject") then d.ZIndex = z + 1 end
	end
end

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TinhSuper_Final"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = PlayerGui

-- ========== LAYER 1: MAIN BACKGROUND (DRAGGABLE) ==========
local Main = Instance.new("Frame", ScreenGui)
Main.Name = "Main"
Main.Size = UDim2.new(0, 760, 0, 300)       -- width like original, taller
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.Position = UDim2.new(0.5, 0, 0.35, 0)
Main.BackgroundColor3 = Color3.fromRGB(126,126,126)
Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0,18)
Main.Active = true
setZ(Main, 10)

-- Drag whole Main by holding on background (mouse & touch)
do
	local dragging = false
	local dragStart = Vector2.new()
	local startPos = Main.Position
	local dragInput

	Main.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = Main.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	Main.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if dragging and input == dragInput then
			local delta = input.Position - dragStart
			Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
end

-- ========== LAYER 2: TITLES, BUTTONS, X CIRCLE ==========
-- Title
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(0.6, 0, 0, 36)
Title.Position = UDim2.new(0, 16, 0, 8)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 28
Title.Text = "TinhSuper Hub"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.TextXAlignment = Enum.TextXAlignment.Left
setZ(Title, 20)

-- by under title (slightly lower)
local By = Instance.new("TextLabel", Main)
By.Size = UDim2.new(0.6, 0, 0, 18)
By.Position = UDim2.new(0, 18, 0, 46)
By.BackgroundTransparency = 1
By.Font = Enum.Font.Gotham
By.TextSize = 14
By.Text = "by tinhsuper_gm"
By.TextColor3 = Color3.fromRGB(230,230,230)
By.TextXAlignment = Enum.TextXAlignment.Left
setZ(By, 20)

-- "T?a Ð? C?a B?n Là:" (red, moved up)
local LabelCoord = Instance.new("TextLabel", Main)
LabelCoord.Size = UDim2.new(0.55, 0, 0, 28)
LabelCoord.Position = UDim2.new(0, 18, 0, 76)
LabelCoord.BackgroundTransparency = 1
LabelCoord.Font = Enum.Font.GothamBold
LabelCoord.TextSize = 20
LabelCoord.Text = "T?a Ð? C?a B?n Là:"
LabelCoord.TextColor3 = Color3.fromRGB(220,40,40)
LabelCoord.TextXAlignment = Enum.TextXAlignment.Left
setZ(LabelCoord, 20)

-- Display frame background (layer 3 will be inside)
local DisplayBg = Instance.new("Frame", Main)
DisplayBg.Size = UDim2.new(0.94, 0, 0, 110) -- wider & taller
DisplayBg.Position = UDim2.new(0.03, 0, 0, 108)
DisplayBg.BackgroundColor3 = Color3.fromRGB(48,48,48)
DisplayBg.BorderSizePixel = 0
Instance.new("UICorner", DisplayBg).CornerRadius = UDim.new(0,12)
setZ(DisplayBg, 15)

-- Coord text (hidden until Check)
local CoordText = Instance.new("TextLabel", DisplayBg)
CoordText.Size = UDim2.new(1, -32, 1, -24)
CoordText.Position = UDim2.new(0, 16, 0, 12)
CoordText.BackgroundTransparency = 1
CoordText.Font = Enum.Font.GothamBold
CoordText.TextSize = 34
CoordText.TextColor3 = Color3.fromRGB(255,255,255)
CoordText.Text = "" -- empty initially
CoordText.Visible = false
CoordText.TextWrapped = true
CoordText.TextXAlignment = Enum.TextXAlignment.Center
CoordText.TextYAlignment = Enum.TextYAlignment.Center
setZ(CoordText, 30)

-- Case button (right, nhích lên)
local CaseBtn = Instance.new("TextButton", Main)
CaseBtn.Size = UDim2.new(0, 220, 0, 42)
CaseBtn.Position = UDim2.new(1, -246, 0, 20) -- top-right, upward
CaseBtn.BackgroundColor3 = Color3.fromRGB(220,220,220)
CaseBtn.Font = Enum.Font.Gotham
CaseBtn.TextSize = 20
CaseBtn.Text = "Trý?ng H?p  ?"
CaseBtn.TextColor3 = Color3.fromRGB(30,30,30)
CaseBtn.BorderSizePixel = 0
Instance.new("UICorner", CaseBtn).CornerRadius = UDim.new(0,10)
setZ(CaseBtn, 22)

-- Buttons bottom: Check (left), Copy (right)
local CheckBtn = Instance.new("TextButton", Main)
CheckBtn.Size = UDim2.new(0, 260, 0, 44)
CheckBtn.Position = UDim2.new(0.06, 0, 1, -66)
CheckBtn.BackgroundColor3 = Color3.fromRGB(39,180,40)
CheckBtn.Font = Enum.Font.GothamBold
CheckBtn.TextSize = 20
CheckBtn.Text = "Ki?m tra t?a ð?"
CheckBtn.TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", CheckBtn).CornerRadius = UDim.new(0,8)
setZ(CheckBtn, 20)

local CopyBtn = Instance.new("TextButton", Main)
CopyBtn.Size = UDim2.new(0, 260, 0, 44)
CopyBtn.Position = UDim2.new(0.72, 0, 1, -66)
CopyBtn.BackgroundColor3 = Color3.fromRGB(60,140,220)
CopyBtn.Font = Enum.Font.GothamBold
CopyBtn.TextSize = 20
CopyBtn.Text = "Sao chép t?a ð?"
CopyBtn.TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", CopyBtn).CornerRadius = UDim.new(0,8)
setZ(CopyBtn, 20)

-- Center circular X between buttons
local CloseCircle = Instance.new("TextButton", Main)
CloseCircle.Size = UDim2.new(0, 48, 0, 48)
CloseCircle.Position = UDim2.new(0.5, -24, 1, -70)
CloseCircle.BackgroundColor3 = Color3.fromRGB(245,245,245)
CloseCircle.Font = Enum.Font.GothamBold
CloseCircle.TextSize = 22
CloseCircle.Text = "X"
CloseCircle.TextColor3 = Color3.fromRGB(30,30,30)
CloseCircle.BorderSizePixel = 0
Instance.new("UICorner", CloseCircle).CornerRadius = UDim.new(1,0)
setZ(CloseCircle, 20)

CloseCircle.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)

-- ========== LAYER 4: POPUP (Trý?ng H?p) ==========
local Popup = Instance.new("Frame", ScreenGui) -- parent to ScreenGui for overlay
Popup.Size = UDim2.new(0, 220, 0, 160)
Popup.BackgroundColor3 = Color3.fromRGB(245,245,245)
Popup.BorderSizePixel = 0
Popup.Visible = false
Instance.new("UICorner", Popup).CornerRadius = UDim.new(0,10)
setZ(Popup, 60)

local options = {"CFrame","Part","Model","Mouse"}
local selected = "CFrame"
for i,opt in ipairs(options) do
	local btn = Instance.new("TextButton", Popup)
	btn.Size = UDim2.new(1, -16, 0, 34)
	btn.Position = UDim2.new(0, 8, 0, 8 + (i-1)*38)
	btn.BackgroundColor3 = Color3.fromRGB(95,95,95)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 16
	btn.Text = opt
	btn.TextColor3 = Color3.fromRGB(240,240,240)
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)
	btn.ZIndex = 61
	btn.MouseButton1Click:Connect(function()
		selected = opt
		CaseBtn.Text = opt.."  ?"
		Popup.Visible = false
	end)
end

-- position popup under CaseBtn, align right
local function positionPopup()
	RunService.RenderStepped:Wait()
	local ddPos = CaseBtn.AbsolutePosition
	local ddSize = CaseBtn.AbsoluteSize
	local popupW = Popup.AbsoluteSize.X
	local popupH = Popup.AbsoluteSize.Y
	local px = ddPos.X + ddSize.X - popupW -- align right edge
	local py = ddPos.Y + ddSize.Y + 8
	local screenSize = workspace.CurrentCamera.ViewportSize
	if px < 8 then px = 8 end
	if py + popupH + 8 > screenSize.Y then
		py = ddPos.Y - popupH - 8
		if py < 8 then py = 8 end
	end
	Popup.Position = UDim2.new(0, math.floor(px), 0, math.floor(py))
	setZ(Popup, 60)
end

CaseBtn.MouseButton1Click:Connect(function()
	Popup.Visible = not Popup.Visible
	if Popup.Visible then positionPopup() end
end)

-- hide popup on outside click
UIS.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		if Popup.Visible then
			local mouse = UIS:GetMouseLocation()
			local ppos, psize = Popup.AbsolutePosition, Popup.AbsoluteSize
			if not (mouse.X >= ppos.X and mouse.X <= ppos.X + psize.X and mouse.Y >= ppos.Y and mouse.Y <= ppos.Y + psize.Y) then
				local ddp, dds = CaseBtn.AbsolutePosition, CaseBtn.AbsoluteSize
				if not (mouse.X >= ddp.X and mouse.X <= ddp.X + dds.X and mouse.Y >= ddp.Y and mouse.Y <= ddp.Y + dds.Y) then
					Popup.Visible = false
				end
			end
		end
	end
end)

-- ========== LOGIC: Check / Part-Model Click / Mouse / Copy ==========
CheckBtn.MouseButton1Click:Connect(function()
	Popup.Visible = false
	if selected == "CFrame" then
		local hrp = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
		if hrp then
			local p = hrp.Position
			coordText.Text = string.format("CFrame.new(%.3f, %.3f, %.3f)", p.X, p.Y, p.Z)
			coordText.Visible = true
		else
			coordText.Text = "(Không t?m th?y nhân v?t)"
			coordText.Visible = true
		end
	elseif selected == "Mouse" then
		local m = Player:GetMouse()
		if m and m.Hit then
			local p = m.Hit.Position
			coordText.Text = string.format("Vector3.new(%.3f, %.3f, %.3f)", p.X, p.Y, p.Z)
			coordText.Visible = true
		else
			coordText.Text = "(Không l?y ðý?c mouse.Hit)"
			coordText.Visible = true
		end
	elseif selected == "Part" or selected == "Model" then
		coordText.Text = "(Click vào world ð? ch?n "..selected..")"
		coordText.Visible = true
		local m = Player:GetMouse()
		local conn
		conn = m.Button1Down:Connect(function()
			local target = m.Target
			if target and target:IsA("BasePart") then
				if selected == "Part" then
					coordText.Text = string.format("CFrame.new(%.3f, %.3f, %.3f)", target.Position.X, target.Position.Y, target.Position.Z)
				else
					local model = target:FindFirstAncestorOfClass("Model")
					local posPart = model and (model:FindFirstChild("HumanoidRootPart") or model.PrimaryPart) or target
					coordText.Text = string.format("CFrame.new(%.3f, %.3f, %.3f)", posPart.Position.X, posPart.Position.Y, posPart.Position.Z)
				end
			else
				coordText.Text = "(Click không h?p l?, th? l?i)"
			end
			coordText.Visible = true
			if conn then conn:Disconnect() end
		end)
		-- cleanup on gui destroy
		ScreenGui.AncestryChanged:Connect(function()
			if not ScreenGui:IsDescendantOf(game) and conn then conn:Disconnect() end
		end)
	end
end)

CopyBtn.MouseButton1Click:Connect(function()
	if coordText.Visible and coordText.Text ~= "" then
		pcall(function() setclipboard(coordText.Text) end)
	end
end)

-- final Z order enforcement
setZ(main, 10)
setZ(title, 20); setZ(bylabel, 20); setZ(LabelCoord, 20)
setZ(DisplayBg, 25); setZ(CoordText, 30)
setZ(CaseBtn, 22); setZ(CheckBtn, 20); setZ(CopyBtn, 20); setZ(CloseCircle, 20)
setZ(Popup, 60)

-- final small reposition: nudge CaseBtn slightly up (pixel)
RunService.Heartbeat:Wait()
local mainAbs = main.AbsolutePosition
local mainSize = main.AbsoluteSize
local caseY = mainAbs.Y + math.floor(mainSize.Y * 0.12)
caseBtnPositionX = mainAbs.X + mainSize.X - CaseBtn.AbsoluteSize.X - 18
CaseBtn.Position = UDim2.new(0, caseBtnPositionX - ScreenGui.AbsolutePosition.X, 0, caseY - ScreenGui.AbsolutePosition.Y)
