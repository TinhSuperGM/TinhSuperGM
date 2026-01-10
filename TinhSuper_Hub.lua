--========================================================
-- LANGUAGE SELECT UI (ENGLISH VERSION)
--========================================================

local CoreGui = game:GetService("CoreGui")

-- 🔹 Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TinhSuper_LanguageUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- 🔹 Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 420, 0, 280)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -140)
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 16)

-- 🔹 Close Button (X)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 36, 0, 36)
CloseBtn.Position = UDim2.new(1, -46, 0, 10)
CloseBtn.Text = "✕"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 20
CloseBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
CloseBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
CloseBtn.Parent = MainFrame
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)

CloseBtn.MouseButton1Click:Connect(function()
	ScreenGui:Destroy() -- ❌ Tắt toàn bộ UI & script
end)

-- 🔹 Logo Image (CHANGE ID ANYTIME)
local Logo = Instance.new("ImageLabel")
Logo.Size = UDim2.new(0, 80, 0, 80)
Logo.Position = UDim2.new(0.5, -40, 0, 15)
Logo.BackgroundTransparency = 1
Logo.Image = "rbxassetid://91978763568989" -- 🔁 ĐỔI ID Ở ĐÂY
Logo.Parent = MainFrame

-- 🔹 Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 100)
Title.BackgroundTransparency = 1
Title.Text = "Choose Your Language"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 22
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- 🔹 Dropdown Button
local DropdownBtn = Instance.new("TextButton")
DropdownBtn.Size = UDim2.new(0.8, 0, 0, 45)
DropdownBtn.Position = UDim2.new(0.1, 0, 0, 145)
DropdownBtn.Text = "Click to select ▼"
DropdownBtn.TextSize = 18
DropdownBtn.Font = Enum.Font.Gotham
DropdownBtn.TextColor3 = Color3.fromRGB(255,255,255)
DropdownBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
DropdownBtn.Parent = MainFrame
Instance.new("UICorner", DropdownBtn).CornerRadius = UDim.new(0,12)

-- 🔹 Dropdown List
local ListFrame = Instance.new("ScrollingFrame")
ListFrame.Size = UDim2.new(0.8, 0, 0, 90)
ListFrame.Position = UDim2.new(0.1, 0, 0, 195)
ListFrame.CanvasSize = UDim2.new(0,0,0,0)
ListFrame.ScrollBarImageTransparency = 0
ListFrame.Visible = false
ListFrame.BackgroundColor3 = Color3.fromRGB(45,45,45)
ListFrame.BorderSizePixel = 0
ListFrame.Parent = MainFrame
Instance.new("UICorner", ListFrame).CornerRadius = UDim.new(0,12)

local UIList = Instance.new("UIListLayout", ListFrame)
UIList.Padding = UDim.new(0,6)

-- 🔹 RUN Button
local RunBtn = Instance.new("TextButton")
RunBtn.Size = UDim2.new(0, 120, 0, 40)
RunBtn.Position = UDim2.new(1, -140, 1, -50)
RunBtn.Text = "RUN"
RunBtn.TextSize = 18
RunBtn.Font = Enum.Font.GothamBold
RunBtn.TextColor3 = Color3.fromRGB(255,255,255)
RunBtn.BackgroundColor3 = Color3.fromRGB(70, 120, 255)
RunBtn.Parent = MainFrame
Instance.new("UICorner", RunBtn).CornerRadius = UDim.new(0,12)

--========================================================
-- LANGUAGE SCRIPTS (ADD FREELY)
--========================================================

local LanguageScripts = {
	["English"] = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/TinhSuperGM/TinhSuperGM/refs/heads/main/TinhSuper_Hub_EN.lua"))()
	end,
	["Vietnam"] = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/TinhSuperGM/TinhSuperGM/refs/heads/main/TinhSuper_Hub_VN.lua"))()
	end
}

--========================================================
-- DROPDOWN LOGIC
--========================================================

local SelectedLanguage = nil

for lang,_ in pairs(LanguageScripts) do
	local Btn = Instance.new("TextButton")
	Btn.Size = UDim2.new(1, -10, 0, 35)
	Btn.Text = lang
	Btn.Font = Enum.Font.Gotham
	Btn.TextSize = 16
	Btn.TextColor3 = Color3.fromRGB(255,255,255)
	Btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
	Btn.Parent = ListFrame
	Instance.new("UICorner", Btn).CornerRadius = UDim.new(0,8)

	Btn.MouseButton1Click:Connect(function()
		SelectedLanguage = lang
		DropdownBtn.Text = lang .. " ▼"
		ListFrame.Visible = false
	end)
end

UIList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	ListFrame.CanvasSize = UDim2.new(0,0,0,UIList.AbsoluteContentSize.Y + 10)
end)

DropdownBtn.MouseButton1Click:Connect(function()
	ListFrame.Visible = not ListFrame.Visible
end)

--========================================================
-- RUN BUTTON
--========================================================

RunBtn.MouseButton1Click:Connect(function()
	if SelectedLanguage and LanguageScripts[SelectedLanguage] then
		LanguageScripts[SelectedLanguage]()
		ScreenGui:Destroy()
	else
		warn("No language selected.")
	end
end)

--========================================================
-- END
--========================================================