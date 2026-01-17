-- TinhSuper Hub - FINAL FIX FONT & LAYOUT (Delta X)
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

repeat task.wait() until Players.LocalPlayer
local plr = Players.LocalPlayer
repeat task.wait() until plr:FindFirstChildOfClass("PlayerGui")
local PlayerGui = plr:FindFirstChildOfClass("PlayerGui")

-- ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "TinhSuperHub"
gui.ResetOnSpawn = false
gui.Parent = PlayerGui

-- MAIN FRAME
local Main = Instance.new("Frame", gui)
Main.Size = UDim2.new(0, 720, 0, 260)
Main.Position = UDim2.new(0.5, 0, 0.35, 0)
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.BackgroundColor3 = Color3.fromRGB(140,140,140)
Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0,16)

-- DRAG
do
	local drag, dragStart, startPos
	Main.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			drag = true
			dragStart = i.Position
			startPos = Main.Position
			i.Changed:Connect(function()
				if i.UserInputState == Enum.UserInputState.End then
					drag = false
				end
			end)
		end
	end)
	UIS.InputChanged:Connect(function(i)
		if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = i.Position - dragStart
			Main.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)
		end
	end)
end

-- TITLE
local Title = Instance.new("TextLabel", Main)
Title.Text = "TinhSuper Hub"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 26
Title.TextColor3 = Color3.new(1,1,1)
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0,18,0,10)
Title.Size = UDim2.new(0.5,0,0,32)
Title.TextXAlignment = Left

-- BY
local By = Instance.new("TextLabel", Main)
By.Text = "by tinhsuper_gm"
By.Font = Enum.Font.Gotham
By.TextSize = 14
By.TextColor3 = Color3.fromRGB(235,235,235)
By.BackgroundTransparency = 1
By.Position = UDim2.new(0,20,0,30) -- h? xu?ng
By.Size = UDim2.new(0.5,0,0,20)
By.TextXAlignment = Left

-- COORD TITLE
local CoordTitle = Instance.new("TextLabel", Main)
CoordTitle.Text = "T?a ð? c?a b?n là:"
CoordTitle.Font = Enum.Font.GothamBold
CoordTitle.TextSize = 20
CoordTitle.TextColor3 = Color3.fromRGB(220,40,40)
CoordTitle.BackgroundTransparency = 1
CoordTitle.Position = UDim2.new(0,20,0,50) -- nhích lên
CoordTitle.Size = UDim2.new(0.6,0,0,26)
CoordTitle.TextXAlignment = Left

-- DISPLAY BG
local Display = Instance.new("Frame", Main)
Display.Size = UDim2.new(0.94,0,0,100)
Display.Position = UDim2.new(0.03,0,0,104) -- nhích lên
Display.BackgroundColor3 = Color3.fromRGB(55,55,55)
Display.BorderSizePixel = 0
Instance.new("UICorner", Display).CornerRadius = UDim.new(0,12)

local DisplayText = Instance.new("TextLabel", Display)
DisplayText.Size = UDim2.new(1,-30,1,-20)
DisplayText.Position = UDim2.new(0,15,0,10)
DisplayText.BackgroundTransparency = 1
DisplayText.Font = Enum.Font.GothamBold
DisplayText.TextSize = 28
DisplayText.TextColor3 = Color3.new(1,1,1)
DisplayText.Text = ""
DisplayText.TextWrapped = true
DisplayText.TextXAlignment = Center
DisplayText.TextYAlignment = Center

-- BUTTON CHECK
local Check = Instance.new("TextButton", Main)
Check.Text = "Ki?m tra t?a ð?"
Check.Font = Enum.Font.GothamBold
Check.TextSize = 18
Check.TextColor3 = Color3.new(1,1,1)
Check.BackgroundColor3 = Color3.fromRGB(40,180,40)
Check.Position = UDim2.new(0.08,0,1,-62)
Check.Size = UDim2.new(0,220,0,42) -- thu nh? ngang
Instance.new("UICorner", Check).CornerRadius = UDim.new(0,8)

-- BUTTON COPY
local Copy = Instance.new("TextButton", Main)
Copy.Text = "Sao chép t?a ð?"
Copy.Font = Enum.Font.GothamBold
Copy.TextSize = 18
Copy.TextColor3 = Color3.new(1,1,1)
Copy.BackgroundColor3 = Color3.fromRGB(60,140,220)
Copy.Position = UDim2.new(0.64,0,1,-62)
Copy.Size = UDim2.new(0,220,0,42) -- thu nh? ngang
Instance.new("UICorner", Copy).CornerRadius = UDim.new(0,8)

-- LOGIC
Check.MouseButton1Click:Connect(function()
	local char = plr.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if hrp then
		DisplayText.Text = string.format(
			"CFrame.new(%.2f, %.2f, %.2f)",
			hrp.Position.X,
			hrp.Position.Y,
			hrp.Position.Z
		)
	end
end)

Copy.MouseButton1Click:Connect(function()
	if setclipboard and DisplayText.Text ~= "" then
		setclipboard(DisplayText.Text)
	end
end)
