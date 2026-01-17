-- LocalScript: TinhSuper Hub - Final fixed (size like original, wider coord, case up, reliable font)
-- Paste into StarterPlayerScripts

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- cleanup old
pcall(function()
	local old = PlayerGui:FindFirstChild("TinhSuper_Hub_UI")
	if old then old:Destroy() end
end)

-- helper setZ: set ZIndex for obj and descendants
local function setZ(root, z)
	if root and root:IsA("GuiObject") then
		root.ZIndex = z
	end
	for _,d in ipairs(root:GetDescendants()) do
		if d:IsA("GuiObject") then
			d.ZIndex = z + 1
		end
	end
end

-- ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TinhSuper_Hub_UI"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = PlayerGui

-- MAIN (layer 1) - size like original image
local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.new(0, 720, 0, 220)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Position = UDim2.new(0.5, 0, 0.35, 0) -- center-ish like image
main.BackgroundColor3 = Color3.fromRGB(126,126,126)
main.BorderSizePixel = 0
main.Parent = screenGui
Instance.new("UICorner", main).CornerRadius = UDim.new(0,18)
main.Active = true

setZ(main, 10) -- layer 1

-- Drag whole main by holding on main background
do
	local dragging = false
	local dragStart = Vector2.new()
	local startPos = main.Position
	local dragInput

	main.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = main.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	main.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if dragging and input == dragInput then
			local delta = input.Position - dragStart
			main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
end

-- ===== LAYER 2: Title / by / Case button / action buttons / X circle =====

-- Title
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(0.6, 0, 0, 36)
title.Position = UDim2.new(0, 16, 0, 8)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextSize = 28
title.Text = "TinhSuper Hub"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextXAlignment = Enum.TextXAlignment.Left
setZ(title, 20)

-- by under title (moved slightly down)
local bylabel = Instance.new("TextLabel", main)
bylabel.Size = UDim2.new(0.6, 0, 0, 18)
bylabel.Position = UDim2.new(0, 18, 0, 44) -- a bit lower than title
bylabel.BackgroundTransparency = 1
bylabel.Font = Enum.Font.SourceSans
bylabel.TextSize = 14
bylabel.Text = "by tinhsuper_gm"
bylabel.TextColor3 = Color3.fromRGB(230,230,230)
bylabel.TextXAlignment = Enum.TextXAlignment.Left
setZ(bylabel, 20)

-- "T?a Ð? C?a B?n Là:" moved up a bit, red, larger, middle-left
local coordLabelTitle = Instance.new("TextLabel", main)
coordLabelTitle.Size = UDim2.new(0.55, 0, 0, 28)
coordLabelTitle.Position = UDim2.new(0, 18, 0, 76) -- moved up
coordLabelTitle.BackgroundTransparency = 1
coordLabelTitle.Font = Enum.Font.SourceSansBold
coordLabelTitle.TextSize = 20
coordLabelTitle.Text = "T?a Ð? C?a B?n Là:"
coordLabelTitle.TextColor3 = Color3.fromRGB(220,40,40)
coordLabelTitle.TextXAlignment = Enum.TextXAlignment.Left
setZ(coordLabelTitle, 20)

-- Display area (layer 3 will go inside this frame)
local displayFrame = Instance.new("Frame", main)
displayFrame.Size = UDim2.new(0.9, 0, 0, 90) -- wide and tall
displayFrame.Position = UDim2.new(0.05, 0, 0, 108)
displayFrame.BackgroundColor3 = Color3.fromRGB(48,48,48) -- darker inner
displayFrame.BorderSizePixel = 0
Instance.new("UICorner", displayFrame).CornerRadius = UDim.new(0,12)
setZ(displayFrame, 15)

-- Coord text: hidden until check
local coordText = Instance.new("TextLabel", displayFrame)
coordText.Size = UDim2.new(1, -32, 1, -24)
coordText.Position = UDim2.new(0, 16, 0, 12)
coordText.BackgroundTransparency = 1
coordText.Font = Enum.Font.SourceSansBold
coordText.TextSize = 34
coordText.TextColor3 = Color3.fromRGB(255,255,255)
coordText.Text = "" -- empty initially
coordText.Visible = false
coordText.TextWrapped = true
coordText.TextXAlignment = Enum.TextXAlignment.Center
coordText.TextYAlignment = Enum.TextYAlignment.Center
setZ(coordText, 30)

-- Case button (layer 2) - move up a bit (1/3 from top, but higher)
local caseBtn = Instance.new("TextButton", main)
caseBtn.Size = UDim2.new(0, 220, 0, 42)
caseBtn.Position = UDim2.new(1, -246, 0, 20) -- near top-right; nhích lên
caseBtn.AnchorPoint = Vector2.new(0,0)
caseBtn.BackgroundColor3 = Color3.fromRGB(220,220,220)
caseBtn.Font = Enum.Font.SourceSans
caseBtn.TextSize = 20
caseBtn.Text = "Trý?ng H?p  ?"
caseBtn.TextColor3 = Color3.fromRGB(30,30,30)
Instance.new("UICorner", caseBtn).CornerRadius = UDim.new(0,10)
setZ(caseBtn, 22)

-- Buttons bottom: Ki?m tra (left), Sao chép (right)
local checkBtn = Instance.new("TextButton", main)
checkBtn.Size = UDim2.new(0, 260, 0, 44)
checkBtn.Position = UDim2.new(0.06, 0, 1, -60)
checkBtn.BackgroundColor3 = Color3.fromRGB(39,180,40)
checkBtn.Font = Enum.Font.SourceSansBold
checkBtn.TextSize = 20
checkBtn.Text = "Ki?m tra t?a ð?"
checkBtn.TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", checkBtn).CornerRadius = UDim.new(0,8)
setZ(checkBtn, 20)

local copyBtn = Instance.new("TextButton", main)
copyBtn.Size = UDim2.new(0, 260, 0, 44)
copyBtn.Position = UDim2.new(0.72, 0, 1, -60)
copyBtn.BackgroundColor3 = Color3.fromRGB(60,140,220)
copyBtn.Font = Enum.Font.SourceSansBold
copyBtn.TextSize = 20
copyBtn.Text = "Sao chép t?a ð?"
copyBtn.TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", copyBtn).CornerRadius = UDim.new(0,8)
setZ(copyBtn, 20)

-- Center circular X between two buttons
local centerX = Instance.new("TextButton", main)
centerX.Size = UDim2.new(0, 48, 0, 48)
centerX.Position = UDim2.new(0.5, -24, 1, -64)
centerX.BackgroundColor3 = Color3.fromRGB(245,245,245)
centerX.Font = Enum.Font.SourceSansBold
centerX.TextSize = 22
centerX.Text = "X"
centerX.TextColor3 = Color3.fromRGB(30,30,30)
Instance.new("UICorner", centerX).CornerRadius = UDim.new(1,0)
setZ(centerX, 20)

centerX.MouseButton1Click:Connect(function()
	screenGui:Destroy()
end)

-- ===== LAYER 4: Popup (Trý?ng H?p) =====
local popup = Instance.new("Frame")
popup.Name = "Popup"
popup.Parent = screenGui -- parent to ScreenGui so it overlays
popup.Size = UDim2.new(0, 220, 0, 160)
popup.BackgroundColor3 = Color3.fromRGB(245,245,245)
popup.BorderSizePixel = 0
popup.Visible = false
Instance.new("UICorner", popup).CornerRadius = UDim.new(0,10)
setZ(popup, 60)

-- create options
local options = {"CFrame", "Part", "Model", "Mouse"}
local selected = "CFrame" -- default
for i,opt in ipairs(options) do
	local btn = Instance.new("TextButton", popup)
	btn.Size = UDim2.new(1, -16, 0, 34)
	btn.Position = UDim2.new(0, 8, 0, 8 + (i-1)*38)
	btn.BackgroundColor3 = Color3.fromRGB(95,95,95)
	btn.Font = Enum.Font.SourceSans
	btn.TextSize = 16
	btn.Text = opt
	btn.TextColor3 = Color3.fromRGB(240,240,240)
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)
	btn.MouseButton1Click:Connect(function()
		selected = opt
		caseBtn.Text = opt.."  ?"
		popup.Visible = false
	end)
end

-- helper to position popup under caseBtn and align right
local function positionPopupUnderCase()
	RunService.RenderStepped:Wait() -- ensure AbsolutePosition ready
	local ddPos = caseBtn.AbsolutePosition
	local ddSize = caseBtn.AbsoluteSize
	local popupW = popup.AbsoluteSize.X
	local popupH = popup.AbsoluteSize.Y
	local px = ddPos.X + ddSize.X - popupW -- align right edge with caseBtn right
	local py = ddPos.Y + ddSize.Y + 8
	-- clamp
	local screenSize = workspace.CurrentCamera.ViewportSize
	if px < 8 then px = 8 end
	if py + popupH + 8 > screenSize.Y then
		py = ddPos.Y - popupH - 8
		if py < 8 then py = 8 end
	end
	popup.Position = UDim2.new(0, math.floor(px), 0, math.floor(py))
	setZ(popup, 60)
end

caseBtn.MouseButton1Click:Connect(function()
	popup.Visible = not popup.Visible
	if popup.Visible then positionPopupUnderCase() end
end)

-- hide popup if clicking outside
UIS.InputBegan:Connect(function(input, gp)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		if popup.Visible then
			local m = UIS:GetMouseLocation()
			local ppos = popup.AbsolutePosition
			local psize = popup.AbsoluteSize
			if not (m.X >= ppos.X and m.X <= ppos.X + psize.X and m.Y >= ppos.Y and m.Y <= ppos.Y + psize.Y) then
				local ddp = caseBtn.AbsolutePosition
				local dds = caseBtn.AbsoluteSize
				if not (m.X >= ddp.X and m.X <= ddp.X + dds.X and m.Y >= ddp.Y and m.Y <= ddp.Y + dds.Y) then
					popup.Visible = false
				end
			end
		end
	end
end)

-- ===== LOGIC: Check / Part-Model click / Mouse / Copy =====
checkBtn.MouseButton1Click:Connect(function()
	-- hide popup
	popup.Visible = false

	if selected == "CFrame" then
		local char = Player.Character
		local hrp = char and char:FindFirstChild("HumanoidRootPart")
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
		-- cleanup if gui destroyed
		screenGui.AncestryChanged:Connect(function()
			if not screenGui:IsDescendantOf(game) and conn then conn:Disconnect() end
		end)
	end
end)

copyBtn.MouseButton1Click:Connect(function()
	if coordText.Visible and coordText.Text ~= "" then
		pcall(function() setclipboard(coordText.Text) end)
	end
end)

-- centerX is close
centerX.MouseButton1Click:Connect(function()
	screenGui:Destroy()
end)

-- ensure Z ordering final
setZ(main, 10)
setZ(title, 20); setZ(bylabel, 20); setZ(coordLabelTitle, 20); setZ(caseBtn, 22)
setZ(displayFrame, 25); setZ(coordText, 30)
setZ(checkBtn, 20); setZ(copyBtn, 20); setZ(centerX, 20)
setZ(popup, 60)

-- final reposition to ensure caseBtn Y correct (slight upward nudge)
RunService.Heartbeat:Wait()
local mainAbs = main.AbsolutePosition
local mainSize = main.AbsoluteSize
-- place caseBtn ~1/3 from top (up a bit)
local caseY = mainAbs.Y + math.floor(mainSize.Y * 0.18) -- slightly higher than 1/3
caseBtn.Position = UDim2.new(0, mainAbs.X + mainSize.X - caseBtn.AbsoluteSize.X - 18 - screenGui.AbsolutePosition.X, 0, caseY - screenGui.AbsolutePosition.Y)

-- done
