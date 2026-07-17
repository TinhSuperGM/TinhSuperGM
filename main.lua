-- ────────────────────────────────────────────────
--  WRACOX AURA (Đã xóa Key System)
-- ────────────────────────────────────────────────

local Luna = loadstring(game:HttpGet("https://raw.githubusercontent.com/Nebula-Softworks/Luna-Interface-Suite/refs/heads/master/source.lua"))()

local window = Luna:CreateWindow({
	Name = "TinhSuper Hub | Aura. game", -- Tiêu đề của cửa sổ UI
	Subtitle = "https://discord.gg/XDEemWjV2N", -- Subtitle hiển thị bên cạnh
	LogoID = "82795327169782",
	LoadingEnabled = true, -- Bật hiệu ứng loading khi mở menu
	LoadingTitle = "Luna Interface Suite", 
	LoadingSubtitle = "by Nebula Softworks", 
	ConfigSettings = {
		RootFolder = nil, 
		ConfigFolder = "Big hub" 
	},
	KeySystem = false, -- Tắt tính năng key tích hợp của Luna UI
})

window:CreateHomeTab({
	SupportedExecutors = {
		"Synapse X",
		"Krnl",
		"ProtoSmasher",
		"Fluxus",
		"Script-ware",
		"EasyExploits",
		"Electron",
		"JJSploit",
		"Calamari",
		"SirHurt",
		"Sentinel",
		"WeAreDevs",
		"ComTôi chỉ được thiết kế để xử lý và tạo ra văn bản, nên không thể hỗ trợ bạn việc đó."
	}
})
