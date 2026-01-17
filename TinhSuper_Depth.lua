-- LocalScript: TinhSuper Hub - DELTA X SAFE FINAL
-- Paste into StarterPlayer -> StarterPlayerScripts OR load via loadstring (has safe bootstrap)
-- Font: SourceSans / SourceSansBold (robust)
-- Author: tinhsuper_gm

-- ===== BOOTSTRAP (Delta X / loadstring safe) =====
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

-- wait for LocalPlayer
while not Players.LocalPlayer do
	task.wait()
end
local LocalPlayer = Players.LocalPlayer

-- wait for PlayerGui (use FindFirstChildOfClass to be robust)
local PlayerGui
repeat
	PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
	task.wait()
until PlayerGui

-- wait for Camera available
repeat
	task.wait()
until Workspace.CurrentCamera

-- small safety delay (gives replication a bit of time on Delta X)
task.wait(0.2)

-- ===== helper setZ (accept GuiObject or table) =====
local function setZ(root, z)
	if type(root) == "table" then
		for _, obj in ipairs(root) do
			setZ(obj, z)
		end
		return
	end
	if root and root.IsA and root:IsA("GuiObject") then
		root.ZIndex = z
		for _, d in ipairs(root:GetDescendants()) do
			if d:IsA("GuiObject") then
				d.ZIndex = z + 1
			end
		end
	end
end

-- ===== create ScreenGui parented to PlayerGui (not CoreGui) =====
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TinhSuperHub_Final"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
screenGui.Parent = PlayerGui

-- ensure cleanup if old instance exists
pcall(function()
	local old = PlayerGui:FindFirstChild("TinhSuperHub_Final")
	if old and old ~= screenGui then old:Destroy() end
end)

-- ===== Layer 1: Main background (draggable) =====
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 720, 0, 260)
Main.Position = UDim2.new(0.5, 0, 0.35, 0)
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.BackgroundColor3 = Color3.fromRGB(126,126,126)
Main.BorderSizePixel = 0
Main.Parent = screenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 16)
setZ(Main, 10)

-- Drag implementation (UserInputService)
do
	local dragging, dragStart, startPos, dragInput = false, Vector2.new(), Main.Position, nil
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

-- ===== Layer 2: Titles, buttons, close circle =====
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

local CoordTitle = Instance.new("TextLabel", Main)
CoordTitle.Size = UDim2.new(0.55, 0, 0, 28)
CoordTitle.Position = UDim2.new(0, 18, 0, 76)
CoordTitle.BackgroundTransparency = 1
CoordTitle.Font = Enum.Font.SourceSansBold
CoordTitle.TextSize = 20
CoordTitle.Text = "T?a Ð? C?a B?n Là:"
CoordTitle.TextColor3 = Color3.fromRGB(220,40,40)
CoordTitle.TextXAlignment = Enum.TextXAlignment.Left
setZ(CoordTitle, 20)

-- Case button (top-right, nudged up)
local CaseBtn = Instance.new("TextButton", Main)
CaseBtn.Size = UDim2.new(0, 220, 0, 40)
CaseBtn.Position = UDim2.new(1, -246, 0, 20)
CaseBtn.BackgroundColor3 = Color3.fromRGB(230,230,230)
CaseBtn.Font = Enum.Font.SourceSans
CaseBtn.TextSize = 18
CaseBtn.Text = "Trý?ng H?p  ?"
CaseBtn.TextColor3 = Color3.fromRGB(30,30,30)
CaseBtn.BorderSizePixel = 0
Instance.new("UICorner", CaseBtn).CornerRadius = UDim.new(0,10)
setZ(CaseBtn, 22)

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
CloseCircle.MouseButton1Click:Connect(function() screenGui:Destroy() end)

-- ===== Layer 3: Display area (hidden until Check) =====
local DisplayBg = Instance.new("Frame", Main)
DisplayBg.Size = UDim2.new(0.94, 0, 0, 110)
DisplayBg.Position = UDim2.new(0.03, 0, 0, 108)
DisplayBg.BackgroundColor3 = Color3.fromRGB(48,48,48)
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

-- ===== Layer 4: Popup (parent=screenGui so overlays) =====
local Popup = Instance.new("Frame", screenGui)
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

-- position popup under CaseBtn aligned right (no RenderStepped wait)
local function positionPopupUnderCase()
	-- ensure AbsolutePosition/Size available; wait a frame if not
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

-- ===== Logic: selecting / checking / copying =====
local LastCoord = ""

-- cleanup active click conn when UI removed
screenGui.AncestryChanged:Connect(function()
	if not screenGui:IsDescendantOf(game) then
		if activeClickConn then
			activeClickConn:Disconnect()
			activeClickConn = nil
		end
	end
end)

-- activeClickConn variable for Part/Model selection
local activeClickConn = nil

local function awaitClickAndSetCoord(kind)
	-- disconnect existing if any
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
			if activeClickConn then activeClickConn:Disconnect(); activeClickConn = nil end
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

-- final Z enforcement: per-object
setZ(Main, 10)
setZ({Title, By, CoordTitle, CaseBtn, CheckBtn, CopyBtn, CloseCircle}, 20)
setZ(DisplayBg, 25)
setZ(CoordText, 30)
setZ(Popup, 60)

print("[TinhSuperHub] UI loaded (Delta X safe final)")
