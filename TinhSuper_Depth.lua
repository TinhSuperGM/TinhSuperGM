-- LocalScript: TinhSuper Hub - FINAL FIXED
-- Paste into StarterPlayer -> StarterPlayerScripts

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Cleanup old
pcall(function()
	local old = PlayerGui:FindFirstChild("TinhSuperHub_Final")
	if old then old:Destroy() end
end)

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TinhSuperHub_Final"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Single Mouse instance (use everywhere)
local Mouse = LocalPlayer:GetMouse()

-- Active click connection for selecting Part/Model (only one at a time)
local activeClickConn = nil

-- Helper: set ZIndex for GuiObject or table of GuiObjects
local function setZ(root, z)
	if type(root) == "table" then
		for _,obj in ipairs(root) do
			setZ(obj, z)
		end
		return
	end
	if root and root:IsA and root:IsA("GuiObject") then
		root.ZIndex = z
		for _, d in ipairs(root:GetDescendants()) do
			if d:IsA("GuiObject") then
				d.ZIndex = z + 1
			end
		end
	end
end

-- ===== LAYER 1: MAIN BACKGROUND (DRAGGABLE) =====
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 720, 0, 260)      -- size like original
Main.Position = UDim2.new(0.5, 0, 0.35, 0)
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.BackgroundColor3 = Color3.fromRGB(126,126,126)
Main.BorderSizePixel = 0
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 16)
setZ(Main, 10)

-- Drag (UserInputService, supports touch & mouse)
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
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
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

-- ===== LAYER 2: TITLES / BY / CASE BUTTON / ACTION BUTTONS / CLOSE =====
-- Title
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(0.6, 0, 0, 34)
Title.Position = UDim2.new(0, 16, 0, 8)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 26
Title.Text = "TinhSuper Hub"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.TextXAlignment = Enum.TextXAlignment.Left
setZ(Title, 20)

-- by tinhsuper_gm (below title, slightly down)
local By = Instance.new("TextLabel", Main)
By.Size = UDim2.new(0.6, 0, 0, 18)
By.Position = UDim2.new(0, 18, 0, 46)
By.BackgroundTransparency = 1
By.Font = Enum.Font.SourceSans
By.TextSize = 14
By.Text = "by tinhsuper_gm"
By.TextColor3 = Color3.fromRGB(230,230,230)
By.TextXAlignment = Enum.TextXAlignment.Left
setZ(By, 20)

-- "T?a ð? c?a b?n là:" (red, larger, moved up)
local CoordTitle = Instance.new("TextLabel", Main)
CoordTitle.Size = UDim2.new(0.55, 0, 0, 28)
CoordTitle.Position = UDim2.new(0, 18, 0, 76)
CoordTitle.BackgroundTransparency = 1
CoordTitle.Font = Enum.Font.SourceSansBold
CoordTitle.TextSize = 20
CoordTitle.Text = "T?a ð? c?a b?n là:"
CoordTitle.TextColor3 = Color3.fromRGB(220,40,40)
CoordTitle.TextXAlignment = Enum.TextXAlignment.Left
setZ(CoordTitle, 20)

-- Case button (right, ~1/3 from top but nudged up)
local CaseBtn = Instance.new("TextButton", Main)
CaseBtn.Size = UDim2.new(0, 220, 0, 40)
CaseBtn.Position = UDim2.new(1, -246, 0, 20) -- top-right, slightly up
CaseBtn.BackgroundColor3 = Color3.fromRGB(230,230,230)
CaseBtn.Font = Enum.Font.SourceSans
CaseBtn.TextSize = 18
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
CheckBtn.Font = Enum.Font.SourceSansBold
CheckBtn.TextSize = 18
CheckBtn.Text = "Ki?m tra t?a ð?"
CheckBtn.TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", CheckBtn).CornerRadius = UDim.new(0,8)
setZ(CheckBtn, 20)

local CopyBtn = Instance.new("TextButton", Main)
CopyBtn.Size = UDim2.new(0, 260, 0, 44)
CopyBtn.Position = UDim2.new(0.72, 0, 1, -66)
CopyBtn.BackgroundColor3 = Color3.fromRGB(60,140,220)
CopyBtn.Font = Enum.Font.SourceSansBold
CopyBtn.TextSize = 18
CopyBtn.Text = "Sao chép t?a ð?"
CopyBtn.TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", CopyBtn).CornerRadius = UDim.new(0,8)
setZ(CopyBtn, 20)

-- Circular Close (center between the two buttons)
local CloseCircle = Instance.new("TextButton", Main)
CloseCircle.Size = UDim2.new(0, 48, 0, 48)
CloseCircle.Position = UDim2.new(0.5, -24, 1, -72)
CloseCircle.BackgroundColor3 = Color3.fromRGB(245,245,245)
CloseCircle.Font = Enum.Font.SourceSansBold
CloseCircle.TextSize = 20
CloseCircle.Text = "X"
CloseCircle.TextColor3 = Color3.fromRGB(30,30,30)
CloseCircle.BorderSizePixel = 0
Instance.new("UICorner", CloseCircle).CornerRadius = UDim.new(1,0)
setZ(CloseCircle, 20)
CloseCircle.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- ===== LAYER 3: DISPLAY COORD (hidden until check) =====
local DisplayBg = Instance.new("Frame", Main)
DisplayBg.Size = UDim2.new(0.94, 0, 0, 110) -- wider to the right
DisplayBg.Position = UDim2.new(0.03, 0, 0, 108)
DisplayBg.BackgroundColor3 = Color3.fromRGB(48,48,48) -- lighter/darker contrast
DisplayBg.BorderSizePixel = 0
Instance.new("UICorner", DisplayBg).CornerRadius = UDim.new(0,12)
setZ(DisplayBg, 15)

local CoordText = Instance.new("TextLabel", DisplayBg)
CoordText.Size = UDim2.new(1, -32, 1, -24)
CoordText.Position = UDim2.new(0, 16, 0, 12)
CoordText.BackgroundTransparency = 1
CoordText.Font = Enum.Font.SourceSansBold
CoordText.TextSize = 30
CoordText.TextColor3 = Color3.fromRGB(255,255,255)
CoordText.Text = ""
CoordText.Visible = false
CoordText.TextWrapped = true
CoordText.TextXAlignment = Enum.TextXAlignment.Center
CoordText.TextYAlignment = Enum.TextYAlignment.Center
setZ(CoordText, 30)

-- ===== LAYER 4: DROPDOWN POPUP (parent=ScreenGui so it overlays) =====
local Popup = Instance.new("Frame", ScreenGui)
Popup.Size = UDim2.new(0, 220, 0, 160)
Popup.BackgroundColor3 = Color3.fromRGB(245,245,245)
Popup.BorderSizePixel = 0
Popup.Visible = false
Instance.new("UICorner", Popup).CornerRadius = UDim.new(0,10)
setZ(Popup, 60)

local options = {"CFrame", "Part", "Model", "Mouse"}
local SelectedCase = "CFrame"

for i, name in ipairs(options) do
	local opt = Instance.new("TextButton", Popup)
	opt.Size = UDim2.new(1, -16, 0, 34)
	opt.Position = UDim2.new(0, 8, 0, 8 + (i-1)*38)
	opt.BackgroundColor3 = Color3.fromRGB(95,95,95)
	opt.Font = Enum.Font.SourceSans
	opt.TextSize = 16
	opt.Text = name
	opt.TextColor3 = Color3.fromRGB(245,245,245)
	Instance.new("UICorner", opt).CornerRadius = UDim.new(0,6)
	opt.ZIndex = 61

	opt.MouseButton1Click:Connect(function()
		SelectedCase = name
		CaseBtn.Text = name.."  ?"
		Popup.Visible = false
	end)
end

-- helper to position popup under CaseBtn aligned right
local function positionPopupUnderCase()
	-- removed RenderStepped:Wait() to avoid unnecessary frame wait
	local ddPos = CaseBtn.AbsolutePosition
	local ddSize = CaseBtn.AbsoluteSize
	local popupW = Popup.AbsoluteSize.X
	local popupH = Popup.AbsoluteSize.Y
	local px = ddPos.X + ddSize.X - popupW -- align right
	local py = ddPos.Y + ddSize.Y + 8
	local screenW, screenH = workspace.CurrentCamera.ViewportSize.X, workspace.CurrentCamera.ViewportSize.Y
	if px < 8 then px = 8 end
	if py + popupH + 8 > screenH then
		py = ddPos.Y - popupH - 8
		if py < 8 then py = 8 end
	end
	Popup.Position = UDim2.new(0, math.floor(px), 0, math.floor(py))
	setZ(Popup, 60)
end

CaseBtn.MouseButton1Click:Connect(function()
	Popup.Visible = not Popup.Visible
	if Popup.Visible then positionPopupUnderCase() end
end)

-- close popup when clicking outside
UIS.InputBegan:Connect(function(input, gp)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		if Popup.Visible then
			local m = UIS:GetMouseLocation()
			local ppos = Popup.AbsolutePosition
			local psize = Popup.AbsoluteSize
			if not (m.X >= ppos.X and m.X <= ppos.X + psize.X and m.Y >= ppos.Y and m.Y <= ppos.Y + psize.Y) then
				local ddp, dds = CaseBtn.AbsolutePosition, CaseBtn.AbsoluteSize
				if not (m.X >= ddp.X and m.X <= ddp.X + dds.X and m.Y >= ddp.Y and m.Y <= ddp.Y + dds.Y) then
					Popup.Visible = false
				end
			end
		end
	end
end)

-- ===== LOGIC: Check / Part-Model click / Mouse / Copy =====
local LastCoord = ""

-- cleanup active click conn when ScreenGui removed (single handler)
ScreenGui.AncestryChanged:Connect(function()
	if not ScreenGui:IsDescendantOf(game) then
		if activeClickConn then
			activeClickConn:Disconnect()
			activeClickConn = nil
		end
	end
end)

-- Wait for mouse clicks for Part/Model selection when needed
local function awaitClickAndSetCoord(kind)
	-- ensure we don't have an existing active connection
	if activeClickConn then
		activeClickConn:Disconnect()
		activeClickConn = nil
	end

	CoordText.Text = "(Click vào world ð? ch?n "..kind..")"
	CoordText.Visible = true

	activeClickConn = Mouse.Button1Down:Connect(function()
		local target = Mouse.Target
		if target and target:IsA("BasePart") then
			if kind == "Part" then
				LastCoord = string.format("CFrame.new(%.3f, %.3f, %.3f)", target.Position.X, target.Position.Y, target.Position.Z)
			else -- Model
				local model = target:FindFirstAncestorOfClass("Model")
				local p = model and (model:FindFirstChild("HumanoidRootPart") or model.PrimaryPart) or target
				LastCoord = string.format("CFrame.new(%.3f, %.3f, %.3f)", p.Position.X, p.Position.Y, p.Position.Z)
			end
			CoordText.Text = LastCoord
			CoordText.Visible = true
			if activeClickConn then
				activeClickConn:Disconnect()
				activeClickConn = nil
			end
		else
			CoordText.Text = "(Click không h?p l?, th? l?i)"
			CoordText.Visible = true
		end
	end)
end

CheckBtn.MouseButton1Click:Connect(function()
	Popup.Visible = false
	if SelectedCase == "CFrame" then
		local char = LocalPlayer.Character
		local hrp = char and char:FindFirstChild("HumanoidRootPart")
		if hrp then
			LastCoord = string.format("CFrame.new(%.3f, %.3f, %.3f)", hrp.Position.X, hrp.Position.Y, hrp.Position.Z)
			CoordText.Text = LastCoord
			CoordText.Visible = true
		else
			CoordText.Text = "(Không t?m th?y nhân v?t)"
			CoordText.Visible = true
		end
	elseif SelectedCase == "Mouse" then
		local m = Mouse
		if m and m.Hit then
			local p = m.Hit.Position
			LastCoord = string.format("Vector3.new(%.3f, %.3f, %.3f)", p.X, p.Y, p.Z)
			CoordText.Text = LastCoord
			CoordText.Visible = true
		else
			CoordText.Text = "(Không l?y ðý?c mouse.Hit)"
			CoordText.Visible = true
		end
	elseif SelectedCase == "Part" or SelectedCase == "Model" then
		awaitClickAndSetCoord(SelectedCase)
	end
end)

CopyBtn.MouseButton1Click:Connect(function()
	if LastCoord ~= "" and setclipboard then
		pcall(function() setclipboard(LastCoord) end)
	end
end)

-- final Z enforcement (per-element)
setZ(Main, 10)
setZ(Title, 20); setZ(By, 20); setZ(CoordTitle, 20); setZ(CaseBtn, 22)
setZ(CheckBtn, 20); setZ(CopyBtn, 20); setZ(CloseCircle, 20)
setZ(DisplayBg, 25)
setZ(CoordText, 30)
setZ(Popup, 60)

print("[TinhSuperHub] UI loaded (FINAL FIXED)")
