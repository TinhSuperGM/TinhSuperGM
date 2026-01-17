-- TinhSuper Hub - FINAL (Last version)
-- Read all previous messages: this script includes all fixes:
-- * Delta X / loadstring-safe bootstrap
-- * Uses PlayerGui (not CoreGui)
-- * Uses Gotham / GothamBold for Vietnamese compatibility
-- * No setZ(table) misuse
-- * Single Mouse instance, single active click connection
-- * Drag implemented via UserInputService (not deprecated Draggable)
-- * Dropdown is overlayed on ScreenGui and positioned aligned-right below CaseBtn
-- * Coord only shown after pressing "Kiểm tra tọa độ"
-- * Copy guarded with pcall and setclipboard check
-- * No RenderStepped:Wait() that blocks; uses Heartbeat as needed

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

-- ===== BOOTSTRAP (safe for loadstring / Delta X) =====
while not Players.LocalPlayer do task.wait() end
local LocalPlayer = Players.LocalPlayer

-- wait for PlayerGui (robust)
local PlayerGui
repeat
	PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
	task.wait()
until PlayerGui

-- wait for camera
repeat task.wait() until Workspace.CurrentCamera

-- small safety delay for replication on some exploits
task.wait(0.12)

-- ===== helper setZ (robust) =====
local function setZ(obj, z)
	if type(obj) == "table" then
		for _, v in ipairs(obj) do
			setZ(v, z)
		end
		return
	end
	if obj and obj.IsA and obj:IsA("GuiObject") then
		obj.ZIndex = z
		for _, d in ipairs(obj:GetDescendants()) do
			if d:IsA("GuiObject") then
				-- keep children slightly above to avoid overlap issues
				d.ZIndex = z + 1
			end
		end
	end
end

-- ===== ScreenGui (parent to PlayerGui) =====
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TinhSuperHub_Final"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
ScreenGui.Enabled = true
ScreenGui.Parent = PlayerGui

-- remove older instance if exists (safety)
pcall(function()
	local old = PlayerGui:FindFirstChild("TinhSuperHub_Final")
	if old and old ~= ScreenGui then old:Destroy() end
end)

-- Single Mouse instance
local Mouse = LocalPlayer:GetMouse()

-- active click connection for Part/Model selecting
local activeClickConn = nil

-- ===== LAYER 1: Main background (draggable via UIS) =====
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 760, 0, 300) -- slightly larger to comfortably fit elements
Main.Position = UDim2.new(0.5, 0, 0.35, 0)
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.BackgroundColor3 = Color3.fromRGB(126,126,126)
Main.BorderSizePixel = 0
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0,18)
setZ(Main, 10)

-- Drag (UserInputService) - supports mouse & touch
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

-- ===== LAYER 2: Title & small texts & buttons =====
-- Title
local Title = Instance.new("TextLabel", Main)
Title.Name = "Title"
Title.Size = UDim2.new(0.6, 0, 0, 36)
Title.Position = UDim2.new(0, 16, 0, 10)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 28
Title.Text = "TinhSuper Hub"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.TextXAlignment = Enum.TextXAlignment.Left
setZ(Title, 20)

-- By (closer under title)
local By = Instance.new("TextLabel", Main)
By.Name = "By"
By.Size = UDim2.new(0.6, 0, 0, 18)
By.Position = UDim2.new(0, 18, 0, 34) -- moved closer to Title (was 48 before)
By.BackgroundTransparency = 1
By.Font = Enum.Font.Gotham
By.TextSize = 14
By.Text = "by tinhsuper_gm"
By.TextColor3 = Color3.fromRGB(230,230,230)
By.TextXAlignment = Enum.TextXAlignment.Left
setZ(By, 20)

-- Coord title (moved up)
local CoordTitle = Instance.new("TextLabel", Main)
CoordTitle.Name = "CoordTitle"
CoordTitle.Size = UDim2.new(0.55, 0, 0, 28)
CoordTitle.Position = UDim2.new(0, 18, 0, 70) -- nudged up to avoid overlap
CoordTitle.BackgroundTransparency = 1
CoordTitle.Font = Enum.Font.GothamBold
CoordTitle.TextSize = 20
CoordTitle.Text = "Your coordinates are:"
CoordTitle.TextColor3 = Color3.fromRGB(220,40,40)
CoordTitle.TextXAlignment = Enum.TextXAlignment.Left
setZ(CoordTitle, 20)

-- Case button (right, 1/3 from top slightly up)
local CaseBtn = Instance.new("TextButton", Main)
CaseBtn.Name = "CaseBtn"
CaseBtn.Size = UDim2.new(0, 220, 0, 42)
CaseBtn.Position = UDim2.new(1, -260, 0, 18) -- top-right nudged up
CaseBtn.BackgroundColor3 = Color3.fromRGB(230,230,230)
CaseBtn.Font = Enum.Font.Gotham
CaseBtn.TextSize = 18
CaseBtn.Text = "Mode  ▾"
CaseBtn.TextColor3 = Color3.fromRGB(30,30,30)
CaseBtn.BorderSizePixel = 0
Instance.new("UICorner", CaseBtn).CornerRadius = UDim.new(0,10)
setZ(CaseBtn, 22)

-- Buttons (smaller width as requested)
local CheckBtn = Instance.new("TextButton", Main)
CheckBtn.Name = "CheckBtn"
CheckBtn.Size = UDim2.new(0, 220, 0, 42) -- reduced width
CheckBtn.Position = UDim2.new(0.06, 0, 1, -66)
CheckBtn.BackgroundColor3 = Color3.fromRGB(39,180,40)
CheckBtn.Font = Enum.Font.GothamBold
CheckBtn.TextSize = 18
CheckBtn.Text = "Check coordinates"
CheckBtn.TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", CheckBtn).CornerRadius = UDim.new(0,8)
setZ(CheckBtn, 20)

local CopyBtn = Instance.new("TextButton", Main)
CopyBtn.Name = "CopyBtn"
CopyBtn.Size = UDim2.new(0, 220, 0, 42) -- reduced width
CopyBtn.Position = UDim2.new(1, -260, 1, -66) -- mirror on right
CopyBtn.BackgroundColor3 = Color3.fromRGB(60,140,220)
CopyBtn.Font = Enum.Font.GothamBold
CopyBtn.TextSize = 18
CopyBtn.Text = "Copy coordinates"
CopyBtn.TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", CopyBtn).CornerRadius = UDim.new(0,8)
setZ(CopyBtn, 20)

-- Center close circle (X)
local CloseCircle = Instance.new("TextButton", Main)
CloseCircle.Name = "CloseCircle"
CloseCircle.Size = UDim2.new(0, 48, 0, 48)
CloseCircle.Position = UDim2.new(0.5, -24, 1, -70)
CloseCircle.BackgroundColor3 = Color3.fromRGB(245,245,245)
CloseCircle.Font = Enum.Font.GothamBold
CloseCircle.TextSize = 20
CloseCircle.Text = "X"
CloseCircle.TextColor3 = Color3.fromRGB(30,30,30)
CloseCircle.BorderSizePixel = 0
Instance.new("UICorner", CloseCircle).CornerRadius = UDim.new(1,0)
setZ(CloseCircle, 20)
CloseCircle.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)

-- ===== LAYER 3: Display Coord (moved up to avoid touching coord title) =====
local DisplayBg = Instance.new("Frame", Main)
DisplayBg.Name = "DisplayBg"
DisplayBg.Size = UDim2.new(0.94, 0, 0, 100) -- slightly taller for larger coord text
DisplayBg.Position = UDim2.new(0.03, 0, 0, 102) -- nudged up
DisplayBg.BackgroundColor3 = Color3.fromRGB(48,48,48)
DisplayBg.BorderSizePixel = 0
Instance.new("UICorner", DisplayBg).CornerRadius = UDim.new(0,12)
setZ(DisplayBg, 15)

local CoordText = Instance.new("TextLabel", DisplayBg)
CoordText.Name = "CoordText"
CoordText.Size = UDim2.new(1, -32, 1, -24)
CoordText.Position = UDim2.new(0, 16, 0, 12)
CoordText.BackgroundTransparency = 1
CoordText.Font = Enum.Font.GothamBold
CoordText.TextSize = 30
CoordText.TextColor3 = Color3.fromRGB(255,255,255)
CoordText.Text = ""
CoordText.Visible = false -- remains hidden until Check
CoordText.TextWrapped = true
CoordText.TextXAlignment = Enum.TextXAlignment.Center
CoordText.TextYAlignment = Enum.TextYAlignment.Center
setZ(CoordText, 30)

-- ===== LAYER 4: Dropdown Popup (overlay) =====
local Popup = Instance.new("Frame", ScreenGui)
Popup.Name = "CasePopup"
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
	opt.Font = Enum.Font.Gotham
	opt.TextSize = 16
	opt.Text = name
	opt.TextColor3 = Color3.fromRGB(245,245,245)
	Instance.new("UICorner", opt).CornerRadius = UDim.new(0,6)
	opt.ZIndex = 61

	opt.MouseButton1Click:Connect(function()
		SelectedCase = name
		CaseBtn.Text = name.."  ▾"
		Popup.Visible = false
	end)
end

-- helper position popup under CaseBtn aligned right (uses Heartbeat if needed)
local function positionPopupUnderCase()
	if CaseBtn.AbsoluteSize.X == 0 then
		RunService.Heartbeat:Wait()
	end
	local ddPos = CaseBtn.AbsolutePosition
	local ddSize = CaseBtn.AbsoluteSize
	local popupW = Popup.AbsoluteSize.X
	local popupH = Popup.AbsoluteSize.Y
	local px = ddPos.X + ddSize.X - popupW -- align right
	local py = ddPos.Y + ddSize.Y + 8
	local screenW, screenH = Workspace.CurrentCamera.ViewportSize.X, Workspace.CurrentCamera.ViewportSize.Y
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
UIS.InputBegan:Connect(function(input)
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

-- ===== Logic: Check / Part-Model selection / Mouse / Copy =====
local LastCoord = ""

-- cleanup active click conn when ScreenGui removed
ScreenGui.AncestryChanged:Connect(function()
	if not ScreenGui:IsDescendantOf(game) then
		if activeClickConn then
			activeClickConn:Disconnect()
			activeClickConn = nil
		end
	end
end)

local function awaitClickAndSetCoord(kind)
	-- ensure single connection
	if activeClickConn then
		activeClickConn:Disconnect()
		activeClickConn = nil
	end

	CoordText.Text = "(Click vào world để chọn "..kind..")"
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
			if activeClickConn then activeClickConn:Disconnect(); activeClickConn = nil end
		else
			CoordText.Text = "(Click không hợp lệ, thử lại)"
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
			CoordText.Text = "(Không tìm thấy nhân vật)"
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
			CoordText.Text = "(Không lấy được mouse.Hit)"
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

-- final Z ordering (per-object)
setZ(Main, 10)
setZ({Title, By, CoordTitle, CaseBtn, CheckBtn, CopyBtn, CloseCircle}, 20)
setZ(DisplayBg, 25)
setZ(CoordText, 30)
setZ(Popup, 60)

print("[TinhSuperHub] Final loaded - fonts:Gotham, safe for Delta X/loadstring")
