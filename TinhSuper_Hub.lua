--==================================================
-- TinhSuper Hub | Language Selector
--==================================================

local CoreGui = game:GetService("CoreGui")

-- Remove old UI if exists
pcall(function()
	CoreGui.TinhSuper_LanguageUI:Destroy()
end)

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TinhSuper_LanguageUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- Main Frame
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 460, 0, 280)
Main.Position = UDim2.new(0.5, -230, 0.5, -140)
Main.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Main.BorderSizePixel = 0
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 16)

--==================================================
-- HEADER
--==================================================

-- Logo
local Logo = Instance.new("ImageLabel")
Logo.Size = UDim2.new(0, 46, 0, 46)
Logo.Position = UDim2.new(0, 15, 0, 15)
Logo.BackgroundTransparency = 1
Logo.Image = "rbxassetid://91978763568989" -- 🔁 ĐỔI ID LOGO TẠI ĐÂY
Logo.Parent = Main

-- Title
local Title = Instance.new("TextLabel")
Title.Position = UDim2.new(0, 70, 0, 15)
Title.Size = UDim2.new(1, -140, 0, 26)
Title.BackgroundTransparency = 1
Title.Text = "TinhSuper Hub"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.TextXAlignment = Left
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.Parent = Main

-- Subtitle
local SubTitle = Instance.new("TextLabel")
SubTitle.Position = UDim2.new(0, 70, 0, 42)
SubTitle.Size = UDim2.new(1, -140, 0, 18)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "by tinhsuper_gm"
SubTitle.Font = Enum.Font.Gotham
SubTitle.TextSize = 14
SubTitle.TextXAlignment = Left
SubTitle.TextColor3 = Color3.fromRGB(170,170,170)
SubTitle.Parent = Main

-- Close (X)
local Close = Instance.new("TextButton")
Close.Size = UDim2.new(0, 30, 0, 30)
Close.Position = UDim2.new(1, -45, 0, 15)
Close.BackgroundTransparency = 1
Close.Text = "X"
Close.Font = Enum.Font.GothamBold
Close.TextSize = 20
Close.TextColor3 = Color3.fromRGB(255,80,80)
Close.Parent = Main

Close.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)

--==================================================
-- BODY
--==================================================

-- Choose text
local Choose = Instance.new("TextLabel")
Choose.Size = UDim2.new(1, 0, 0, 30)
Choose.Position = UDim2.new(0, 0, 0, 90)
Choose.BackgroundTransparency = 1
Choose.Text = "Choose Your Language"
Choose.Font = Enum.Font.GothamBold
Choose.TextSize = 22
Choose.TextColor3 = Color3.fromRGB(255,255,255)
Choose.Parent = Main

-- Dropdown Button
local DropBtn = Instance.new("TextButton")
DropBtn.Size = UDim2.new(0.75, 0, 0, 42)
DropBtn.Position = UDim2.new(0.125, 0, 0, 130)
DropBtn.Text = "Click to select ▼"
DropBtn.Font = Enum.Font.Gotham
DropBtn.TextSize = 18
DropBtn.TextColor3 = Color3.fromRGB(255,255,255)
DropBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
DropBtn.Parent = Main
Instance.new("UICorner", DropBtn).CornerRadius = UDim.new(0, 12)

-- Dropdown List
local List = Instance.new("ScrollingFrame")
List.Size = UDim2.new(0.75, 0, 0, 90)
List.Position = UDim2.new(0.125, 0, 0, 180)
List.CanvasSize = UDim2.new(0,0,0,0)
List.ScrollBarImageTransparency = 0
List.Visible = false
List.BackgroundColor3 = Color3.fromRGB(45,45,45)
List.BorderSizePixel = 0
List.Parent = Main
Instance.new("UICorner", List).CornerRadius = UDim.new(0, 12)

local Layout = Instance.new("UIListLayout", List)
Layout.Padding = UDim.new(0,6)

-- RUN Button
local Run = Instance.new("TextButton")
Run.Size = UDim2.new(0, 140, 0, 44)
Run.Position = UDim2.new(1, -160, 1, -60)
Run.Text = "RUN"
Run.Font = Enum.Font.GothamBold
Run.TextSize = 18
Run.TextColor3 = Color3.fromRGB(255,255,255)
Run.BackgroundColor3 = Color3.fromRGB(70,120,255)
Run.Parent = Main
Instance.new("UICorner", Run).CornerRadius = UDim.new(0, 14)

--==================================================
-- LANGUAGE SCRIPTS
--==================================================

local LanguageScripts = {
	["English"] = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/TinhSuperGM/TinhSuperGM/refs/heads/main/TinhSuper_Hub_EN_R.lua"))()
	end,
	["Vietnam"] = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/TinhSuperGM/TinhSuperGM/refs/heads/main/TinhSuper_Hub_VN_R.lua"))()
	end
}

--==================================================
-- DROPDOWN LOGIC
--==================================================

local SelectedLang = nil

for name,func in pairs(LanguageScripts) do
	local Btn = Instance.new("TextButton")
	Btn.Size = UDim2.new(1, -10, 0, 34)
	Btn.Text = name
	Btn.Font = Enum.Font.Gotham
	Btn.TextSize = 16
	Btn.TextColor3 = Color3.fromRGB(255,255,255)
	Btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
	Btn.Parent = List
	Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)

	Btn.MouseButton1Click:Connect(function()
		SelectedLang = name
		DropBtn.Text = name .. " ▼"
		List.Visible = false
	end)
end

Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	List.CanvasSize = UDim2.new(0,0,0,Layout.AbsoluteContentSize.Y + 10)
end)

DropBtn.MouseButton1Click:Connect(function()
	List.Visible = not List.Visible
end)

--==================================================
-- RUN LOGIC (DESTROY UI FIRST)
--==================================================

Run.MouseButton1Click:Connect(function()
	if SelectedLang and LanguageScripts[SelectedLang] then
		ScreenGui:Destroy() -- ❗ UI MẤT NGAY
		task.wait()
		LanguageScripts[SelectedLang]() -- chạy loadstring
	end
end)