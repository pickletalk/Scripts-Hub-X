-- ================================
-- Scripts Hub X | Official (Fixed Version)
-- ================================

-- Services
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local MarketplaceService = game:GetService("MarketplaceService")
local TeleportService = game:GetService("TeleportService")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui", 5)

-- UserIds
local OwnerUserId = "2341777244"
local PremiumUsers = {
	"1102633570", -- Pedrojay450 [PERM]
	"8860068952", -- Pedrojay450's alt (assaltanoobsbr) [PERM]
	"799427028", -- Roblox_xvt [PERM]
	"5317421108", -- kolwneje [PERM]
	"1458719572", -- wxckfeen [PERM]
	"8931026465", -- genderwillnottell [PERM]
	"679713988" -- LautyyPc [PERM]
}

local StaffUserId = {
	"3882788546", -- Keanjacob5
	"799427028", -- Roblox_xvt
	"9249886989", -- ALT
	"2726723958" -- mhicel235TOH
}

local BlacklistUsers = {
	"716599904", -- ImRottingInHell [PERM]
	"229691" -- ravyn [PERM]
}

-- Webhook URL
local webhookUrl = "https://discord.com/api/webhooks/1416367485803827230/4OLebMf0rtkCajS5S5lmo99iXe0v6v5B1gn_lPDAzz_MQtj0-HabA9wa2PF-5QBNUmgi"

-- Notification function
local function notify(title, text)
	spawn(function()
		pcall(function()
			game:GetService("StarterGui"):SetCore("SendNotification", {
				Title = title, 
				Text = text, 
				Duration = 3
			})
		end)
	end)
end

-- Executor detection function
local function detectExecutor()
	if syn and syn.request then
		return "Synapse X"
	elseif KRNL_LOADED then
		return "KRNL"
	elseif getgenv and getgenv().isfluxus then
		return "Fluxus"
	elseif getgenv and getgenv().scriptware then
		return "Script-Ware"
	elseif getgenv and getgenv().protosmasher then
		return "ProtoSmasher"
	elseif getgenv and getgenv().sirhurt then
		return "SirHurt"
	elseif getgenv and getgenv().sentinellib then
		return "Sentinel"
	elseif getgenv and getgenv().vega then
		return "Vega X"
	elseif getgenv and getgenv().oxygen then
		return "Oxygen U"
	elseif getgenv and getgenv().comet then
		return "Comet"
	elseif getgenv and getgenv().nihon then
		return "Nihon"
	elseif getgenv and getgenv().delta then
		return "Delta"
	elseif getgenv and getgenv().evon then
		return "Evon"
	elseif getgenv and getgenv().electron then
		return "Electron"
	elseif identifyexecutor then
		local executor = identifyexecutor()
		if executor then
			return executor
		end
	end
	return "Unknown"
end

-- Webhook notification function
local function sendWebhookNotification(userStatus, scriptUrl)
	pcall(function()
		print("Sending webhook notification")
		
		local gameName = "Unknown"
		local success, productInfo = pcall(function()
			return MarketplaceService:GetProductInfo(game.PlaceId)
		end)
		if success and productInfo and productInfo.Name then
			gameName = productInfo.Name
		end
		
		local userId = tostring(player.UserId)
		local detectedExecutor = detectExecutor()
		local placeId = tostring(game.PlaceId)
		local jobId = game.JobId or "Can't detect JobId"
		
		local send_data = {
			["username"] = "Script Execution Log",
			["avatar_url"] = "https://res.cloudinary.com/dtjjgiitl/image/upload/q_auto:good,f_auto,fl_progressive/v1753332266/kpjl5smuuixc5w2ehn7r.jpg",
			["content"] = "Scripts Hub X | Official - Logging",
			["embeds"] = {
				{
					["title"] = "Script Execution Details",
					["description"] = "**Game**: " .. gameName .. "\n**Game ID**: " .. game.PlaceId .. "\n**Profile**: https://www.roblox.com/users/" .. player.UserId .. "/profile",
					["color"] = 2123412,
					["fields"] = {
						{["name"] = "Display Name", ["value"] = player.DisplayName, ["inline"] = true},
						{["name"] = "Username", ["value"] = player.Name, ["inline"] = true},
						{["name"] = "User ID", ["value"] = tostring(player.UserId), ["inline"] = true},
						{["name"] = "Executor", ["value"] = detectedExecutor, ["inline"] = true},
						{["name"] = "User Type", ["value"] = userStatus, ["inline"] = true},
						{["name"] = "Job Id", ["value"] = game.JobId, ["inline"] = true},
						{["name"] = "Join Script", ["value"] = 'game:GetService("TeleportService"):TeleportToPlaceInstance(' .. placeId .. ', "' .. jobId .. '", game.Players.LocalPlayer)', ["inline"] = true},
						{["name"] = "Join Link", ["value"] = '[Join To The Server](https://pickletalk.netlify.app/?placeId=' .. placeId .. '&gameInstanceId=' .. jobId .. ')', ["inline"] = true}
					},
					["footer"] = {["text"] = "Scripts Hub X | Official", ["icon_url"] = "https://res.cloudinary.com/dtjjgiitl/image/upload/q_auto:good,f_auto,fl_progressive/v1753332266/kpjl5smuuixc5w2ehn7r.jpg"},
					["thumbnail"] = {["url"] = "https://thumbnails.roproxy.com/v1/users/avatar-headshot?userIds=" .. player.UserId .. "&size=420x420&format=Png&isCircular=true"}
				}
			}
		}
		
		local headers = {["Content-Type"] = "application/json"}
		local success, err = pcall(function()
			if request and type(request) == "function" then
				request({
					Url = webhookUrl,
					Method = "POST",
					Headers = headers,
					Body = HttpService:JSONEncode(send_data)
				})
			elseif http_request and type(http_request) == "function" then
				http_request({
					Url = webhookUrl,
					Method = "POST",
					Headers = headers,
					Body = HttpService:JSONEncode(send_data)
				})
			end
		end)
		
		if success then
			print("Webhook notification sent successfully")
		else
			warn("Failed to send webhook notification: " .. tostring(err))
		end
	end)
end

-- Error display function
local function showError(text)
	pcall(function()
		local screenGui = Instance.new("ScreenGui")
		screenGui.Name = "ErrorNotification"
		screenGui.IgnoreGuiInset = true
		screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		screenGui.Parent = playerGui

		local mainFrame = Instance.new("Frame")
		mainFrame.Size = UDim2.new(1, 0, 1, 0)
		mainFrame.BackgroundColor3 = Color3.fromRGB(10, 20, 30)
		mainFrame.BackgroundTransparency = 1
		mainFrame.Parent = screenGui

		local contentFrame = Instance.new("Frame")
		contentFrame.Size = UDim2.new(0, 400, 0, 320)
		contentFrame.Position = UDim2.new(0.5, -200, 0.5, -160)
		contentFrame.BackgroundColor3 = Color3.fromRGB(20, 40, 60)
		contentFrame.BackgroundTransparency = 1
		contentFrame.BorderSizePixel = 0
		contentFrame.Parent = mainFrame

		local contentFrameCorner = Instance.new("UICorner")
		contentFrameCorner.CornerRadius = UDim.new(0, 16)
		contentFrameCorner.Parent = contentFrame

		local contentStroke = Instance.new("UIStroke")
		contentStroke.Color = Color3.fromRGB(80, 160, 255)
		contentStroke.Thickness = 1.5
		contentStroke.Transparency = 1
		contentStroke.Parent = contentFrame

		local titleLabel = Instance.new("TextLabel")
		titleLabel.Size = UDim2.new(1, -40, 0, 50)
		titleLabel.Position = UDim2.new(0, 20, 0, 20)
		titleLabel.BackgroundTransparency = 1
		titleLabel.Text = "Error"
		titleLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
		titleLabel.TextScaled = true
		titleLabel.TextSize = 24
		titleLabel.Font = Enum.Font.GothamBold
		titleLabel.TextTransparency = 1
		titleLabel.Parent = contentFrame

		local errorLabel = Instance.new("TextLabel")
		errorLabel.Size = UDim2.new(1, -40, 0, 60)
		errorLabel.Position = UDim2.new(0, 20, 0, 80)
		errorLabel.BackgroundTransparency = 1
		errorLabel.Text = text
		errorLabel.TextColor3 = Color3.fromRGB(150, 180, 200)
		errorLabel.TextScaled = true
		errorLabel.TextSize = 12
		errorLabel.Font = Enum.Font.Gotham
		errorLabel.TextTransparency = 1
		errorLabel.TextWrapped = true
		errorLabel.Parent = contentFrame

		local discordLabel = Instance.new("TextLabel")
		discordLabel.Size = UDim2.new(1, -40, 0, 60)
		discordLabel.Position = UDim2.new(0, 20, 0, 150)
		discordLabel.BackgroundTransparency = 1
		discordLabel.Text = "Suggest this game on our Discord: https://discord.gg/bpsNUH5sVb"
		discordLabel.TextColor3 = Color3.fromRGB(100, 160, 255)
		discordLabel.TextScaled = true
		discordLabel.TextSize = 12
		discordLabel.Font = Enum.Font.Gotham
		discordLabel.TextTransparency = 1
		discordLabel.TextWrapped = true
		discordLabel.Parent = contentFrame

		local copyButton = Instance.new("TextButton")
		copyButton.Size = UDim2.new(0, 80, 0, 28)
		copyButton.Position = UDim2.new(0.5, -40, 0, 220)
		copyButton.BackgroundColor3 = Color3.fromRGB(80, 160, 255)
		copyButton.BackgroundTransparency = 1
		copyButton.Text = "Copy Link"
		copyButton.TextColor3 = Color3.fromRGB(230, 240, 255)
		copyButton.TextScaled = true
		copyButton.TextSize = 12
		copyButton.Font = Enum.Font.GothamBold
		copyButton.TextTransparency = 1
		copyButton.Parent = contentFrame

		local copyButtonCorner = Instance.new("UICorner")
		copyButtonCorner.CornerRadius = UDim.new(0, 6)
		copyButtonCorner.Parent = copyButton

		copyButton.MouseButton1Click:Connect(function()
			pcall(function()
				if setclipboard then
					setclipboard("https://discord.gg/bpsNUH5sVb")
					copyButton.Text = "Copied!"
					copyButton.BackgroundColor3 = Color3.fromRGB(60, 140, 235)
					task.wait(1)
					copyButton.Text = "Copy Link"
					copyButton.BackgroundColor3 = Color3.fromRGB(80, 160, 255)
				end
			end)
		end)

		-- Animation function
		local function playEntranceAnimations()
			local mainFrameTween = TweenService:Create(mainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.7})
			local contentFrameTween = TweenService:Create(contentFrame, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {BackgroundTransparency = 0.5})
			local contentStrokeTween = TweenService:Create(contentStroke, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Transparency = 0.4})
			local titleTween = TweenService:Create(titleLabel, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {TextTransparency = 0})
			local errorTween = TweenService:Create(errorLabel, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {TextTransparency = 0})
			local discordTween = TweenService:Create(discordLabel, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {TextTransparency = 0})
			local copyButtonTween = TweenService:Create(copyButton, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {TextTransparency = 0, BackgroundTransparency = 0.2})

			mainFrameTween:Play()
			contentFrameTween:Play()
			contentStrokeTween:Play()
			titleTween:Play()
			task.wait(0.1)
			errorTween:Play()
			task.wait(0.1)
			discordTween:Play()
			task.wait(0.1)
			copyButtonTween:Play()
		end

		playEntranceAnimations()
		task.wait(5)
		screenGui:Destroy()
	end)
end

-- Game support check function
local function checkGameSupport()
	print("Checking game support for PlaceID: " .. game.PlaceId)
	
	local success, Games = pcall(function()
		local script = game:HttpGet("https://raw.githubusercontent.com/pickletalk/Scripts-Hub-X/refs/heads/main/GameList.lua")
		return loadstring(script)()
	end)
	
	if not success then
		warn("Failed to load game list: " .. tostring(Games))
		return false, nil
	end
	
	if type(Games) ~= "table" then
		warn("Game list returned invalid data")
		return false, nil
	end
	
	for PlaceID, Execute in pairs(Games) do
		if PlaceID == game.PlaceId then
			print("Game supported, script URL: " .. Execute)
			return true, Execute
		end
	end
	
	print("Game not supported")
	return false, nil
end

-- Game script loading function (FIXED)
local function loadGameScript(scriptUrl)
	print("Loading game script from URL: " .. scriptUrl)
	
	local success, result = pcall(function()
		local scriptContent = game:HttpGet(scriptUrl)
		if not scriptContent or scriptContent == "" then
			error("Script content is empty or nil")
		end
		
		-- Compile the script
		local compiledScript, compileErr = loadstring(scriptContent)
		if not compiledScript then
			error("Failed to compile script: " .. tostring(compileErr))
		end
		
		-- Execute the script
		local executeResult = compiledScript()
		return executeResult
	end)
	
	if not success then
		warn("Failed to load/execute game script: " .. tostring(result))
		return false, tostring(result)
	end
	
	print("✅ Game script loaded and executed successfully")
	return true, nil
end

-- User status check function
local function checkUserStatus()
	local userId = tostring(player.UserId)
	print("Checking user status for UserId: " .. userId)
	
	-- Check blacklist first
	if BlacklistUsers and table.find(BlacklistUsers, userId) then
		print("Blacklisted user detected")
		return "blacklisted"
	end
	
	-- Check owner
	if OwnerUserId and userId == tostring(OwnerUserId) then
		print("Owner detected")
		return "owner"
	end
	
	-- Check staff
	if StaffUserId and table.find(StaffUserId, userId) then
		print("Staff detected")
		return "staff"
	end
	
	-- Check premium
	if PremiumUsers and table.find(PremiumUsers, userId) then
		print("Premium user detected")
		return "premium"
	end
	
	print("Regular user detected")
	return "regular"
end

-- ================================
-- MAIN EXECUTION (SIMPLIFIED)
-- ================================

spawn(function()
	print("🚀 Starting Scripts Hub X...")
	
	-- Check user status
	local userStatus = checkUserStatus()
	
	-- Handle blacklisted users
	if userStatus == "blacklisted" then
		player:Kick("You are blacklisted from using this script!")
		return
	end
	
	-- Check game support
	local isSupported, scriptUrl = checkGameSupport()
	
	-- Send webhook notification
	sendWebhookNotification(userStatus, scriptUrl or "No script URL")
	
	-- Handle unsupported games
	if not isSupported then
		print("❌ Game not supported")
		showError("Game is not supported. Suggest this game on our Discord server.")
		return
	end
	
	-- Load and execute the game script
	print("🎮 Loading game script...")
	local success, errorMsg = loadGameScript(scriptUrl)
	
	if success then
		print("✅ Scripts Hub X | Complete for " .. userStatus .. " user")
		notify("Scripts Hub X", "Script loaded successfully!")
	else
		print("❌ Script failed to load: " .. tostring(errorMsg))
	end
end)
