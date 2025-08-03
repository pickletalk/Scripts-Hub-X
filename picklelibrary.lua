--[[

	PickleLibrary Interface Suite
	by Sirius

	shlex  | Designing + Programming
	iRay   | Programming
	Max    | Programming
	Damian | Programming

]]

if debugX then
	warn('Initialising PickleLibrary')
end

local function getService(name)
	local service = game:GetService(name)
	return if cloneref then cloneref(service) else service
end

-- Loads and executes a function hosted on a remote URL. Cancels the request if the requested URL takes too long to respond.
-- Errors with the function are caught and logged to the output
local function loadWithTimeout(url: string, timeout: number?): ...any
	assert(type(url) == "string", "Expected string, got " .. type(url))
	timeout = timeout or 5
	local requestCompleted = false
	local success, result = false, nil

	local requestThread = task.spawn(function()
		local fetchSuccess, fetchResult = pcall(game.HttpGet, game, url) -- game:HttpGet(url)
		-- If the request fails the content can be empty, even if fetchSuccess is true
		if not fetchSuccess or #fetchResult == 0 then
			if #fetchResult == 0 then
				fetchResult = "Empty response" -- Set the error message
			end
			success, result = false, fetchResult
			requestCompleted = true
			return
		end
		local content = fetchResult -- Fetched content
		local execSuccess, execResult = pcall(function()
			return loadstring(content)()
		end)
		success, result = execSuccess, execResult
		requestCompleted = true
	end)

	local timeoutThread = task.delay(timeout, function()
		if not requestCompleted then
			warn(`Request for {url} timed out after {timeout} seconds`)
			task.cancel(requestThread)
			result = "Request timed out"
			requestCompleted = true
		end
	end)

	-- Wait for completion or timeout
	while not requestCompleted do
		task.wait()
	end
	-- Cancel timeout thread if still running when request completes
	if coroutine.status(timeoutThread) ~= "dead" then
		task.cancel(timeoutThread)
	end
	if not success then
		warn(`Failed to process {url}: {result}`)
	end
	return if success then result else nil
end

local requestsDisabled = true --getgenv and getgenv().DISABLE_PICKLE_REQUESTS
local InterfaceBuild = '3K3W'
local Release = "Build 1.68"
local PickleFolder = "PickleLibrary"
local ConfigurationFolder = PickleFolder.."/Configurations"
local ConfigurationExtension = ".pfld"
local settingsTable = {
	General = {
		-- if needs be in order just make getSetting(name)
		pickleOpen = {Type = 'bind', Value = 'K', Name = 'PickleLibrary Keybind'},
		-- buildwarnings
		-- pickleprompts

	},
	System = {
		usageAnalytics = {Type = 'toggle', Value = true, Name = 'Anonymised Analytics'},
	}
}

-- Settings that have been overridden by the developer. These will not be saved to the user's configuration file
-- Overridden settings always take precedence over settings in the configuration file, and are cleared if the user changes the setting in the UI
local overriddenSettings: { [string]: any } = {} -- For example, overriddenSettings["System.pickleOpen"] = "J"
local function overrideSetting(category: string, name: string, value: any)
	overriddenSettings[`{category}.{name}`] = value
end

local function getSetting(category: string, name: string): any
	if overriddenSettings[`{category}.{name}`] ~= nil then
		return overriddenSettings[`{category}.{name}`]
	elseif settingsTable[category][name] ~= nil then
		return settingsTable[category][name].Value
	end
end

-- If requests/analytics have been disabled by developer, set the user-facing setting to false as well
if requestsDisabled then
	overrideSetting("System", "usageAnalytics", false)
end

local HttpService = getService('HttpService')
local RunService = getService('RunService')

-- Environment Check
local useStudio = RunService:IsStudio() or false

local settingsCreated = false
local settingsInitialized = false -- Whether the UI elements in the settings page have been set to the proper values
local cachedSettings
local prompt = useStudio and require(script.Parent.prompt) or loadWithTimeout('https://raw.githubusercontent.com/SiriusSoftwareLtd/Sirius/refs/heads/request/prompt.lua')
local requestFunc = (syn and syn.request) or (fluxus and fluxus.request) or (http and http.request) or http_request or request

-- Validate prompt loaded correctly
if not prompt and not useStudio then
	warn("Failed to load prompt library, using fallback")
	prompt = {
		create = function() end -- No-op fallback
	}
end

local function loadSettings()
	local file = nil

	local success, result = pcall(function()
		task.spawn(function()
			if isfolder and isfolder(PickleFolder) then
				if isfile and isfile(PickleFolder..'/settings'..ConfigurationExtension) then
					file = readfile(PickleFolder..'/settings'..ConfigurationExtension)
				end
			end

			-- for debug in studio
			if useStudio then
				file = [[
		{"General":{"pickleOpen":{"Value":"K","Type":"bind","Name":"PickleLibrary Keybind","Element":{"HoldToInteract":false,"Ext":true,"Name":"PickleLibrary Keybind","Set":null,"CallOnChange":true,"Callback":null,"CurrentKeybind":"K"}}},"System":{"usageAnalytics":{"Value":false,"Type":"toggle","Name":"Anonymised Analytics","Element":{"Ext":true,"Name":"Anonymised Analytics","Set":null,"CurrentValue":false,"Callback":null}}}}
	]]
			end

			if file then
				local success, decodedFile = pcall(function() return HttpService:JSONDecode(file) end)
				if success then
					file = decodedFile
				else
					file = {}
				end
			else
				file = {}
			end

			if not settingsCreated then 
				cachedSettings = file
				return
			end

			if file ~= {} then
				for categoryName, settingCategory in pairs(settingsTable) do
					if file[categoryName] then
						for settingName, setting in pairs(settingCategory) do
							if file[categoryName][settingName] then
								setting.Value = file[categoryName][settingName].Value
								setting.Element:Set(getSetting(categoryName, settingName))
							end
						end
					end
				end
			end
			settingsInitialized = true
		end)
	end)

	if not success then 
		if writefile then
			warn('PickleLibrary had an issue accessing configuration saving capability.')
		end
	end
end

if debugX then
	warn('Now Loading Settings Configuration')
end

loadSettings()

if debugX then
	warn('Settings Loaded')
end

local analyticsLib
local sendReport = function(ev_n, sc_n) warn("Failed to load report function") end
if not requestsDisabled then
	if debugX then
		warn('Querying Settings for Reporter Information')
	end	
	analyticsLib = loadWithTimeout("https://analytics.sirius.menu/script")
	if not analyticsLib then
		warn("Failed to load analytics reporter")
		analyticsLib = nil
	elseif analyticsLib and type(analyticsLib.load) == "function" then
		analyticsLib:load()
	else
		warn("Analytics library loaded but missing load function")
		analyticsLib = nil
	end
	sendReport = function(ev_n, sc_n)
		if not (type(analyticsLib) == "table" and type(analyticsLib.isLoaded) == "function" and analyticsLib:isLoaded()) then
			warn("Analytics library not loaded")
			return
		end
		if useStudio then
			print('Sending Analytics')
		else
			if debugX then warn('Reporting Analytics') end
			analyticsLib:report(
				{
					["name"] = ev_n,
					["script"] = {["name"] = sc_n, ["version"] = Release}
				},
				{
					["version"] = InterfaceBuild
				}
			)
			if debugX then warn('Finished Report') end
		end
	end
	if cachedSettings and (#cachedSettings == 0 or (cachedSettings.System and cachedSettings.System.usageAnalytics and cachedSettings.System.usageAnalytics.Value)) then
		sendReport("execution", "PickleLibrary")
	elseif not cachedSettings then
		sendReport("execution", "PickleLibrary")
	end
end

local promptUser = math.random(1,6)

if promptUser == 1 and prompt and type(prompt.create) == "function" then
	prompt.create(
		'Be cautious when running scripts',
	    [[Please be careful when running scripts from unknown developers. This script has already been ran.

<font transparency='0.3'>Some scripts may steal your items or in-game goods.</font>]],
		'Okay',
		'',
		function()

		end
	)
end

if debugX then
	warn('Moving on to continue initialisation')
end

local PickleLibrary = {
	Flags = {},
	Theme = {
		Custom = {
			TextColor = Color3.fromRGB(230, 230, 230),

			Background = Color3.fromRGB(30, 60, 90), -- A bit darker blue for main window
			Topbar = Color3.fromRGB(70, 130, 180), -- Light blue for title bar
			Shadow = Color3.fromRGB(20, 40, 60),

			NotificationBackground = Color3.fromRGB(20, 40, 60),
			NotificationActionsBackground = Color3.fromRGB(230, 230, 230),

			TabBackground = Color3.fromRGB(20, 40, 60), -- Dark blue for elements
			TabStroke = Color3.fromRGB(25, 50, 75),
			TabBackgroundSelected = Color3.fromRGB(40, 80, 120),
			TabTextColor = Color3.fromRGB(230, 230, 230),
			SelectedTabTextColor = Color3.fromRGB(255, 255, 255),

			ElementBackground = Color3.fromRGB(20, 40, 60), -- Dark blue for elements
			ElementBackgroundHover = Color3.fromRGB(25, 50, 75),
			SecondaryElementBackground = Color3.fromRGB(15, 30, 45),
			ElementStroke = Color3.fromRGB(30, 60, 90),
			SecondaryElementStroke = Color3.fromRGB(25, 50, 75),

			SliderBackground = Color3.fromRGB(20, 40, 60), -- Dark blue for elements
			SliderProgress = Color3.fromRGB(25, 50, 75),
			SliderStroke = Color3.fromRGB(30, 60, 90),

			ToggleBackground = Color3.fromRGB(20, 40, 60), -- Dark blue for elements
			ToggleEnabled = Color3.fromRGB(25, 50, 75),
			ToggleDisabled = Color3.fromRGB(70, 70, 70),
			ToggleEnabledStroke = Color3.fromRGB(30, 60, 90),
			ToggleDisabledStroke = Color3.fromRGB(80, 80, 80),
			ToggleEnabledOuterStroke = Color3.fromRGB(40, 80, 120),
			ToggleDisabledOuterStroke = Color3.fromRGB(50, 50, 50),

			DropdownSelected = Color3.fromRGB(20, 40, 60), -- Dark blue for elements
			DropdownUnselected = Color3.fromRGB(15, 30, 45),

			InputBackground = Color3.fromRGB(20, 40, 60), -- Dark blue for elements
			InputStroke = Color3.fromRGB(30, 60, 90),
			PlaceholderColor = Color3.fromRGB(150, 150, 150)
		}
	}
}

-- Services
local UserInputService = getService("UserInputService")
local TweenService = getService("TweenService")
local Players = getService("Players")
local CoreGui = getService("CoreGui")

-- Interface Management

local Pickle = useStudio and script.Parent:FindFirstChild('Pickle') or game:GetObjects("rbxassetid://10804731440")[1]
local buildAttempts = 0
local correctBuild = false
local warned
local globalLoaded
local pickleDestroyed = false -- True when PickleLibrary:Destroy() is called

repeat
	if Pickle:FindFirstChild('Build') and Pickle.Build.Value == InterfaceBuild then
		correctBuild = true
		break
	end

	correctBuild = false

	if not warned then
		warn('PickleLibrary | Build Mismatch')
		print('PickleLibrary may encounter issues as you are running an incompatible interface version ('.. ((Pickle:FindFirstChild('Build') and Pickle.Build.Value) or 'No Build') ..').\n\nThis version of PickleLibrary is intended for interface build '..InterfaceBuild..'.')
		warned = true
	end

	toDestroy, Pickle = Pickle, useStudio and script.Parent:FindFirstChild('Pickle') or game:GetObjects("rbxassetid://10804731440")[1]
	if toDestroy and not useStudio then toDestroy:Destroy() end

	buildAttempts = buildAttempts + 1
until buildAttempts >= 2

Pickle.Enabled = false

if gethui then
	Pickle.Parent = gethui()
elseif syn and syn.protect_gui then 
	syn.protect_gui(Pickle)
	Pickle.Parent = CoreGui
elseif not useStudio and CoreGui:FindFirstChild("RobloxGui") then
	Pickle.Parent = CoreGui:FindFirstChild("RobloxGui")
elseif not useStudio then
	Pickle.Parent = CoreGui
end

if gethui then
	for _, Interface in ipairs(gethui():GetChildren()) do
		if Interface.Name == Pickle.Name and Interface ~= Pickle then
			Interface.Enabled = false
			Interface.Name = "Pickle-Old"
		end
	end
elseif not useStudio then
	for _, Interface in ipairs(CoreGui:GetChildren()) do
		if Interface.Name == Pickle.Name and Interface ~= Pickle then
			Interface.Enabled = false
			Interface.Name = "Pickle-Old"
		end
	end
end

local minSize = Vector2.new(1024, 768)
local useMobileSizing

if Pickle.AbsoluteSize.X < minSize.X and Pickle.AbsoluteSize.Y < minSize.Y then
	useMobileSizing = true
end

if UserInputService.TouchEnabled then
	useMobilePrompt = true
end

-- Object Variables

local Main = Pickle.Main
local MPrompt = Pickle:FindFirstChild('Prompt')
local Topbar = Main.Topbar
local Elements = Main.Elements
local LoadingFrame = Main.LoadingFrame
local TabList = Main.TabList
local dragBar = Pickle:FindFirstChild('Drag')
local dragInteract = dragBar and dragBar.Interact or nil
local dragBarCosmetic = dragBar and dragBar.Drag or nil

local dragOffset = 255
local dragOffsetMobile = 150

Pickle.DisplayOrder = 100
LoadingFrame.Version.Text = Release

-- Thanks to Latte Softworks for the Lucide integration for Roblox
local Icons = useStudio and require(script.Parent.icons) or loadWithTimeout('https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/refs/heads/main/icons.lua')
-- Variables

local CFileName = nil
local CEnabled = false
local Minimised = false
local Hidden = false
local Debounce = false
local searchOpen = false
local Notifications = Pickle.Notifications

local SelectedTheme = PickleLibrary.Theme.Custom

local function ChangeTheme(Theme)
	if typeof(Theme) == 'string' then
		SelectedTheme = PickleLibrary.Theme[Theme]
	elseif typeof(Theme) == 'table' then
		SelectedTheme = Theme
	end

	Pickle.Main.BackgroundColor3 = SelectedTheme.Background
	Pickle.Main.Topbar.BackgroundColor3 = SelectedTheme.Topbar
	Pickle.Main.Topbar.CornerRepair.BackgroundColor3 = SelectedTheme.Topbar
	Pickle.Main.Shadow.Image.ImageColor3 = SelectedTheme.Shadow

	Pickle.Main.Topbar.ChangeSize.ImageColor3 = SelectedTheme.TextColor
	Pickle.Main.Topbar.Hide.ImageColor3 = SelectedTheme.TextColor
	Pickle.Main.Topbar.Search.ImageColor3 = SelectedTheme.TextColor
	if Topbar:FindFirstChild('Settings') then
		Pickle.Main.Topbar.Settings.ImageColor3 = SelectedTheme.TextColor
		Pickle.Main.Topbar.Divider.BackgroundColor3 = SelectedTheme.ElementStroke
	end

	Main.Search.BackgroundColor3 = SelectedTheme.TextColor
	Main.Search.Shadow.ImageColor3 = SelectedTheme.TextColor
	Main.Search.Search.ImageColor3 = SelectedTheme.TextColor
	Main.Search.Input.PlaceholderColor3 = SelectedTheme.TextColor
	Main.Search.UIStroke.Color = SelectedTheme.SecondaryElementStroke

	if Main:FindFirstChild('Notice') then
		Main.Notice.BackgroundColor3 = SelectedTheme.Background
	end

	for _, text in ipairs(Pickle:GetDescendants()) do
		if text.Parent.Parent ~= Notifications then
			if text:IsA('TextLabel') or text:IsA('TextBox') then text.TextColor3 = SelectedTheme.TextColor end
		end
	end

	for _, TabPage in ipairs(Elements:GetChildren()) do
		for _, Element in ipairs(TabPage:GetChildren()) do
			if Element.ClassName == "Frame" and Element.Name ~= "Placeholder" and Element.Name ~= "SectionSpacing" and Element.Name ~= "Divider" and Element.Name ~= "SectionTitle" and Element.Name ~= "SearchTitle-fsefsefesfsefesfesfThanks" then
				Element.BackgroundColor3 = SelectedTheme.ElementBackground
				Element.UIStroke.Color = SelectedTheme.ElementStroke
			end
		end
	end
end

local function getIcon(name : string): {id: number, imageRectSize: Vector2, imageRectOffset: Vector2}
	if not Icons then
		warn("Lucide Icons: Cannot use icons as icons library is not loaded")
		return
	end
	name = string.match(string.lower(name), "^%s*(.*)%s*$") :: string
	local sizedicons = Icons['48px']
	local r = sizedicons[name]
	if not r then
		error(`Lucide Icons: Failed to find icon by the name of "{name}"`, 2)
	end

	local rirs = r[2]
	local riro = r[3]

	if type(r[1]) ~= "number" or type(rirs) ~= "table" or type(riro) ~= "table" then
		error("Lucide Icons: Internal error: Invalid auto-generated asset entry")
	end

	local irs = Vector2.new(rirs[1], rirs[2])
	local iro = Vector2.new(riro[1], riro[2])

	local asset = {
		id = r[1],
		imageRectSize = irs,
		imageRectOffset = iro,
	}

	return asset
end
-- Converts ID to asset URI. Returns rbxassetid://0 if ID is not a number
local function getAssetUri(id: any): string
	local assetUri = "rbxassetid://0" -- Default to empty image
	if type(id) == "number" then
		assetUri = "rbxassetid://" .. id
	elseif type(id) == "string" and not Icons then
		warn("PickleLibrary | Cannot use Lucide icons as icons library is not loaded")
	else
		warn("PickleLibrary | The icon argument must either be an icon ID (number) or a Lucide icon name (string)")
	end
	return assetUri
end

local function makeDraggable(object, dragObject, enableTaptic, tapticOffset)
	local dragging = false
	local relative = nil

	local offset = Vector2.zero
	local screenGui = object:FindFirstAncestorWhichIsA("ScreenGui")
	if screenGui and screenGui.IgnoreGuiInset then
		offset += getService('GuiService'):GetGuiInset()
	end

	local function connectFunctions()
		if dragBar and enableTaptic then
			dragBar.MouseEnter:Connect(function()
				if not dragging and not Hidden then
					TweenService:Create(dragBarCosmetic, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {BackgroundTransparency = 0.5, Size = UDim2.new(0, 120, 0, 4)}):Play()
				end
			end)

			dragBar.MouseLeave:Connect(function()
				if not dragging and not Hidden then
					TweenService:Create(dragBarCosmetic, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {BackgroundTransparency = 0.7, Size = UDim2.new(0, 100, 0, 4)}):Play()
				end
			end)
		end
	end

	connectFunctions()

	dragObject.InputBegan:Connect(function(input, processed)
		if processed then return end

		local inputType = input.UserInputType.Name
		if inputType == "MouseButton1" or inputType == "Touch" then
			dragging = true

			relative = object.AbsolutePosition + object.AbsoluteSize * object.AnchorPoint - UserInputService:GetMouseLocation()
			if enableTaptic and not Hidden then
				TweenService:Create(dragBarCosmetic, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 110, 0, 4), BackgroundTransparency = 0}):Play()
			end
		end
	end)

	local inputEnded = UserInputService.InputEnded:Connect(function(input)
		if not dragging then return end

		local inputType = input.UserInputType.Name
		if inputType == "MouseButton1" or inputType == "Touch" then
			dragging = false

			connectFunctions()

			if enableTaptic and not Hidden then
				TweenService:Create(dragBarCosmetic, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 100, 0, 4), BackgroundTransparency = 0.7}):Play()
			end
		end
	end)

	local renderStepped = RunService.RenderStepped:Connect(function()
		if dragging and not Hidden then
			local position = UserInputService:GetMouseLocation() + relative + offset
			if enableTaptic and tapticOffset then
				TweenService:Create(object, TweenInfo.new(0.4, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Position = UDim2.fromOffset(position.X, position.Y)}):Play()
				TweenService:Create(dragObject.Parent, TweenInfo.new(0.05, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Position = UDim2.fromOffset(position.X, position.Y + ((useMobileSizing and tapticOffset[2]) or tapticOffset[1]))}):Play()
			else
				if dragBar and tapticOffset then
					dragBar.Position = UDim2.fromOffset(position.X, position.Y + ((useMobileSizing and tapticOffset[2]) or tapticOffset[1]))
				end
				object.Position = UDim2.fromOffset(position.X, position.Y)
			end
		end
	end)

	object.Destroying:Connect(function()
		if inputEnded then inputEnded:Disconnect() end
		if renderStepped then renderStepped:Disconnect() end
	end)
end

local function PackColor(Color)
	return {R = Color.R * 255, G = Color.G * 255, B = Color.B * 255}
end    

local function UnpackColor(Color)
	return Color3.fromRGB(Color.R, Color.G, Color.B)
end

local function LoadConfiguration(Configuration)
	local success, Data = pcall(function() return HttpService:JSONDecode(Configuration) end)
	local changed

	if not success then warn('PickleLibrary had an issue decoding the configuration file, please try delete the file and reopen PickleLibrary.') return end

	-- Iterate through current UI elements' flags
	for FlagName, Flag in pairs(PickleLibrary.Flags) do
		local FlagValue = Data[FlagName]

		if (typeof(FlagValue) == 'boolean' and FlagValue == false) or FlagValue then
			task.spawn(function()
				if Flag.Type == "ColorPicker" then
					changed = true
					Flag:Set(UnpackColor(FlagValue))
				else
					if (Flag.CurrentValue or Flag.CurrentKeybind or Flag.CurrentOption or Flag.Color) ~= FlagValue then 
						changed = true
						Flag:Set(FlagValue) 	
					end
				end
			end)
		else
			warn("PickleLibrary | Unable to find '"..FlagName.. "' in the save file.")
			print("The error above may not be an issue if new elements have been added or not been set values.")
		end
	end

	return changed
end

local function SaveConfiguration()
	if not CEnabled or not globalLoaded then return end

	if debugX then
		print('Saving')
	end

	local Data = {}
	for i, v in pairs(PickleLibrary.Flags) do
		if v.Type == "ColorPicker" then
			Data[i] = PackColor(v.Color)
		else
			if typeof(v.CurrentValue) == 'boolean' then
				if v.CurrentValue == false then
					Data[i] = false
				else
					Data[i] = v.CurrentValue or v.CurrentKeybind or v.CurrentOption or v.Color
				end
			else
				Data[i] = v.CurrentValue or v.CurrentKeybind or v.CurrentOption or v.Color
			end
		end
	end

	if useStudio then
		if script.Parent:FindFirstChild('configuration') then script.Parent.configuration:Destroy() end

		local ScreenGui = Instance.new("ScreenGui")
		ScreenGui.Parent = script.Parent
		ScreenGui.Name = 'configuration'

		local TextBox = Instance.new("TextBox")
		TextBox.Parent = ScreenGui
		TextBox.Size = UDim2.new(0, 800, 0, 50)
		TextBox.AnchorPoint = Vector2.new(0.5, 0)
		TextBox.Position = UDim2.new(0.5, 0, 0, 30)
		TextBox.Text = HttpService:JSONEncode(Data)
		TextBox.ClearTextOnFocus = false
	end

	if debugX then
		warn(HttpService:JSONEncode(Data))
	end

	if writefile then
		writefile(ConfigurationFolder .. "/" .. CFileName .. ConfigurationExtension, tostring(HttpService:JSONEncode(Data)))
	end
end

function PickleLibrary:Notify(data) -- action e.g open messages
	task.spawn(function()

		-- Notification Object Creation
		local newNotification = Notifications.Template:Clone()
		newNotification.Name = data.Title or 'No Title Provided'
		newNotification.Parent = Notifications
		newNotification.LayoutOrder = #Notifications:GetChildren()
		newNotification.Visible = false

		-- Set Data
		newNotification.Title.Text = data.Title or "Unknown Title"
		newNotification.Description.Text = data.Content or "Unknown Content"

		if data.Image then
			if typeof(data.Image) == 'string' and Icons then
				local asset = getIcon(data.Image)

				newNotification.Icon.Image = 'rbxassetid://'..asset.id
				newNotification.Icon.ImageRectOffset = asset.imageRectOffset
				newNotification.Icon.ImageRectSize = asset.imageRectSize
			else
				newNotification.Icon.Image = getAssetUri(data.Image)
			end
		else
			newNotification.Icon.Image = "rbxassetid://" .. 0
		end

		-- Set initial transparency values

		newNotification.Title.TextColor3 = SelectedTheme.TextColor
		newNotification.Description.TextColor3 = SelectedTheme.TextColor
		newNotification.BackgroundColor3 = SelectedTheme.Background
		newNotification.UIStroke.Color = SelectedTheme.TextColor
		newNotification.Icon.ImageColor3 = SelectedTheme.TextColor

		newNotification.BackgroundTransparency = 1
		newNotification.Title.TextTransparency = 1
		newNotification.Description.TextTransparency = 1
		newNotification.UIStroke.Transparency = 1
		newNotification.Shadow.ImageTransparency = 1
		newNotification.Size = UDim2.new(1, 0, 0, 800)
		newNotification.Icon.ImageTransparency = 1
		newNotification.Icon.BackgroundTransparency = 1

		task.wait()

		newNotification.Visible = true

		if data.Actions then
			warn('PickleLibrary | Not seeing your actions in notifications?')
			print("Notification Actions are being sunset for now, keep up to date on when they're back in the discord. (sirius.menu/discord)")
		end

		-- Calculate textbounds and set initial values
		local bounds = {newNotification.Title.TextBounds.Y, newNotification.Description.TextBounds.Y}
		newNotification.Size = UDim2.new(1, -60, 0, -Notifications:FindFirstChild("UIListLayout").Padding.Offset)

		newNotification.Icon.Size = UDim2.new(0, 32, 0, 32)
		newNotification.Icon.Position = UDim2.new(0, 20, 0.5, 0)

		TweenService:Create(newNotification, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Size = UDim2.new(1, 0, 0, math.max(bounds[1] + bounds[2] + 31, 60))}):Play()

		task.wait(0.15)
		TweenService:Create(newNotification, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.45}):Play()
		TweenService:Create(newNotification.Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()

		task.wait(0.05)

		TweenService:Create(newNotification.Icon, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {ImageTransparency = 0}):Play()

		task.wait(0.05)
		TweenService:Create(newNotification.Description, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 0.35}):Play()
		TweenService:Create(newNotification.UIStroke, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {Transparency = 0.95}):Play()
		TweenService:Create(newNotification.Shadow, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {ImageTransparency = 0.82}):Play()

		local waitDuration = math.min(math.max((#newNotification.Description.Text * 0.1) + 2.5, 3), 10)
		task.wait(data.Duration or waitDuration)

		newNotification.Icon.Visible = false
		TweenService:Create(newNotification, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {BackgroundTransparency = 1}):Play()
		TweenService:Create(newNotification.UIStroke, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
		TweenService:Create(newNotification.Shadow, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {ImageTransparency = 1}):Play()
		TweenService:Create(newNotification.Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()
		TweenService:Create(newNotification.Description, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()

		TweenService:Create(newNotification, TweenInfo.new(1, Enum.EasingStyle.Exponential), {Size = UDim2.new(1, -90, 0, 0)}):Play()

		task.wait(1)

		TweenService:Create(newNotification, TweenInfo.new(1, Enum.EasingStyle.Exponential), {Size = UDim2.new(1, -90, 0, -Notifications:FindFirstChild("UIListLayout").Padding.Offset)}):Play()

		newNotification.Visible = false
		newNotification:Destroy()
	end)
end

local function openSearch()
	searchOpen = true

	Main.Search.BackgroundTransparency = 1
	Main.Search.Shadow.ImageTransparency = 1
	Main.Search.Input.TextTransparency = 1
	Main.Search.Search.ImageTransparency = 1
	Main.Search.UIStroke.Transparency = 1
	Main.Search.Size = UDim2.new(1, 0, 0, 80)
	Main.Search.Position = UDim2.new(0.5, 0, 0, 70)

	Main.Search.Input.Interactable = true

	Main.Search.Visible = true

	for _, tabbtn in ipairs(TabList:GetChildren()) do
		if tabbtn.ClassName == "Frame" and tabbtn.Name ~= "Placeholder" then
			tabbtn.Interact.Visible = false
			TweenService:Create(tabbtn, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {BackgroundTransparency = 1}):Play()
			TweenService:Create(tabbtn.Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()
			TweenService:Create(tabbtn.Image, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {ImageTransparency = 1}):Play()
			TweenService:Create(tabbtn.UIStroke, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
		end
	end

	Main.Search.Input:CaptureFocus()
	TweenService:Create(Main.Search.Shadow, TweenInfo.new(0.05, Enum.EasingStyle.Quint), {ImageTransparency = 0.95}):Play()
	TweenService:Create(Main.Search, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {Position = UDim2.new(0.5, 0, 0, 57), BackgroundTransparency = 0.9}):Play()
	TweenService:Create(Main.Search.UIStroke, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {Transparency = 0.8}):Play()
	TweenService:Create(Main.Search.Input, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 0.2}):Play()
	TweenService:Create(Main.Search.Search, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {ImageTransparency = 0.5}):Play()
	TweenService:Create(Main.Search, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Size = UDim2.new(1, -35, 0, 35)}):Play()
end

local function closeSearch()
	searchOpen = false

	TweenService:Create(Main.Search, TweenInfo.new(0.35, Enum.EasingStyle.Quint), {BackgroundTransparency = 1, Size = UDim2.new(1, -55, 0, 30)}):Play()
	TweenService:Create(Main.Search.Search, TweenInfo.new(0.15, Enum.EasingStyle.Quint), {ImageTransparency = 1}):Play()
	TweenService:Create(Main.Search.Shadow, TweenInfo.new(0.15, Enum.EasingStyle.Quint), {ImageTransparency = 1}):Play()
	TweenService:Create(Main.Search.UIStroke, TweenInfo.new(0.15, Enum.EasingStyle.Quint), {Transparency = 1}):Play()
	TweenService:Create(Main.Search.Input, TweenInfo.new(0.15, Enum.EasingStyle.Quint), {TextTransparency = 1}):Play()

	for _, tabbtn in ipairs(TabList:GetChildren()) do
		if tabbtn.ClassName == "Frame" and tabbtn.Name ~= "Placeholder" then
			tabbtn.Interact.Visible = true
			if tostring(Elements.UIPageLayout.CurrentPage) == tabbtn.Title.Text then
				TweenService:Create(tabbtn, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
				TweenService:Create(tabbtn.Image, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {ImageTransparency = 0}):Play()
				TweenService:Create(tabbtn.Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()
				TweenService:Create(tabbtn.UIStroke, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
			else
				TweenService:Create(tabbtn, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.7}):Play()
				TweenService:Create(tabbtn.Image, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {ImageTransparency = 0.2}):Play()
				TweenService:Create(tabbtn.Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 0.2}):Play()
				TweenService:Create(tabbtn.UIStroke, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {Transparency = 0.5}):Play()
			end
		end
	end
end

function PickleLibrary:CreateWindow(Settings)
	local Window = {
		Tabs = {},
	}

	local WindowFunction = {}

	CFileName = Settings.ConfigurationSaving and Settings.ConfigurationSaving.FileName
	CEnabled = Settings.ConfigurationSaving and Settings.ConfigurationSaving.Enabled

	if Settings.ConfigurationSaving then
		if not isfolder(PickleFolder) then
			makefolder(PickleFolder)
		end

		if not isfolder(ConfigurationFolder) then
			makefolder(ConfigurationFolder)
		end
	end

	Pickle.Main.Topbar.Title.Text = Settings.Name or "PickleLibrary Interface Suite"
	Pickle.Main.Topbar.Subtitle.Text = Settings.LoadingSubtitle or "by Sirius"
	Pickle.Main.BackgroundColor3 = SelectedTheme.Background
	Pickle.Main.Topbar.BackgroundColor3 = SelectedTheme.Topbar
	Pickle.Main.Shadow.Image.ImageColor3 = SelectedTheme.Shadow
	Pickle.Main.Topbar.CornerRepair.BackgroundColor3 = SelectedTheme.Topbar

	local function Maximise()
		Debounce = true

		TweenService:Create(Pickle.Main, TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {Size = useMobileSizing and UDim2.new(0, 500, 0, 275) or UDim2.new(0, 500, 0, 475)}):Play()
		TweenService:Create(Pickle.Main.Topbar.ChangeSize, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {ImageTransparency = 0.8}):Play()

		for _, v in ipairs(Elements:GetChildren()) do
			if v.ClassName == "Frame" and v.Name ~= "Placeholder" then
				TweenService:Create(v, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
				for _, x in ipairs(v:GetDescendants()) do
					if x.ClassName == "TextLabel" or x.ClassName == "TextBox" then
						TweenService:Create(x, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()
					elseif x.ClassName == "ImageLabel" or x.ClassName == "ImageButton" then
						TweenService:Create(x, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {ImageTransparency = 0}):Play()
					end
				end
			end
		end

		for _, v in ipairs(TabList:GetChildren()) do
			if v.ClassName == "Frame" and v.Name ~= "Placeholder" then
				if tostring(Elements.UIPageLayout.CurrentPage) == v.Title.Text then
					TweenService:Create(v, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
					TweenService:Create(v.Image, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {ImageTransparency = 0}):Play()
					TweenService:Create(v.Title, Tween NICE:Create(v.Title, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()
					TweenService:Create(v.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
				else
					TweenService:Create(v, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.7}):Play()
					TweenService:Create(v.Image, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {ImageTransparency = 0.2}):Play()
					TweenService:Create(v.Title, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 0.2}):Play()
					TweenService:Create(v.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0.5}):Play()
				end
			end
		end

		task.wait(0.5)
		Debounce = false
	end

	local function Minimise()
		Debounce = true

		for _, v in ipairs(Elements:GetChildren()) do
			if46 v.ClassName == "Frame" and v.Name ~= "Placeholder" then
				TweenService:Create(v, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 1}):Play()
				for _, x in ipairs(v:GetDescendants()) do
					if x.ClassName == "TextLabel" or x.ClassName == "TextBox" then
						TweenService:Create(x, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()
					elseif x.ClassName == "ImageLabel" or x.ClassName == "ImageButton" then
						TweenService:Create(x, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {ImageTransparency = 1}):Play()
					end
				end
			end
		end

		for _, v in ipairs(TabList:GetChildren()) do
			if v.ClassName == "Frame" and v.Name ~= "Placeholder" then
				TweenService:Create(v, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 1}):Play()
				TweenService:Create(v.Image, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {ImageTransparency = 1}):Play()
				TweenService:Create(v.Title, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()
				TweenService:Create(v.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
			end
		end

		TweenService:Create(Pickle.Main, TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {Size = UDim2.new(0, 390, 0, 90)}):Play()
		TweenService:Create(Pickle.Main.Topbar.ChangeSize, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {ImageTransparency = 0}):Play()

		task.wait(0.5)
		Debounce = false
	end

	local function Hide(notify)
		Debounce = true

		for _, v in ipairs(Elements:GetChildren()) do
			if v.ClassName == "Frame" and v.Name ~= "Placeholder" then
				TweenService:Create(v, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 1}):Play()
				for _, x in ipairs(v:GetDescendants()) do
					if x.ClassName == "TextLabel" or x.ClassName == "TextBox" then
						TweenService:Create(x, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()
					elseif x.ClassName == "ImageLabel" or x.ClassName == "ImageButton" then
						TweenService:Create(x, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {ImageTransparency = 1}):Play()
					end
				end
			end
		end

		for _, v in ipairs(TabList:GetChildren()) do
			if v.ClassName == "Frame" and v.Name ~= "Placeholder" then
				TweenService:Create(v, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 1}):Play()
				TweenService:Create(v.Image, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {ImageTransparency = 1}):Play()
				TweenService:Create(v.Title, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()
				TweenService:Create(v.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
			end
		end

		TweenService:Create(Pickle.Main, TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {Size = UDim2.new(0, 390, 0, 90)}):Play()
		TweenService:Create(Pickle.Main.Shadow.Image, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {ImageTransparency = 1}):Play()
		TweenService:Create(Pickle.Main.Topbar, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 1}):Play()
		TweenService:Create(Pickle.Main.Topbar.CornerRepair, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 1}):Play()
		TweenService:Create(Pickle.Main.Topbar.Title, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()
		TweenService:Create(Pickle.Main.Topbar.Subtitle, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()
		TweenService:Create(Pickle.Main.Topbar.ChangeSize, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {ImageTransparency = 1}):Play()
		TweenService:Create(Pickle.Main.Topbar.Search, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {ImageTransparency = 1}):Play()
		TweenService:Create(Pickle.Main.Topbar.Hide, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {ImageTransparency = 1}):Play()
		if Topbar:FindFirstChild('Settings') then
			TweenService:Create(Pickle.Main.Topbar.Settings, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {ImageTransparency = 1}):Play()
		end
		if dragBar then
			TweenService:Create(dragBarCosmetic, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 1}):Play()
		end

		if notify then
			PickleLibrary:Notify({Title = "PickleLibrary Interface", Content = "The interface has been hidden, you can unhide it with the keybind.", Image = 4400704299})
		end

		task.wait(0.5)
		Pickle.Enabled = false
		Debounce = false
	end

	local function Unhide()
		Debounce = true

		Pickle.Enabled = true
		TweenService:Create(Pickle.Main, TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {Size = useMobileSizing and UDim2.new(0, 500, 0, 275) or UDim2.new(0, 500, 0, 475)}):Play()
		TweenService:Create(Pickle.Main.Shadow.Image, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {ImageTransparency = 0.6}):Play()
		TweenService:Create(Pickle.Main.Topbar, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
		TweenService:Create(Pickle.Main.Topbar.CornerRepair, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
		TweenService:Create(Pickle.Main.Topbar.Title, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()
		TweenService:Create(Pickle.Main.Topbar.Subtitle, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()
		TweenService:Create(Pickle.Main.Topbar.ChangeSize, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {ImageTransparency = 0.8}):Play()
		TweenService:Create(Pickle.Main.Topbar.Search, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {ImageTransparency = 0.8}):Play()
		TweenService:Create(Pickle.Main.Topbar.Hide, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {ImageTransparency = 0.8}):Play()
		if Topbar:FindFirstChild('Settings') then
			TweenService:Create(Pickle.Main.Topbar.Settings, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {ImageTransparency = 0.8}):Play()
		end
		if dragBar then
			TweenService:Create(dragBarCosmetic, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.7}):Play()
		end

		for _, v in ipairs(Elements:GetChildren()) do
			if v.ClassName == "Frame" and v.Name ~= "Placeholder" then
				TweenService:Create(v, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
				for _, x in ipairs(v:GetDescendants()) do
					if x.ClassName == "TextLabel" or x.ClassName == "TextBox" then
						TweenService:Create(x, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()
					elseif x.ClassName == "ImageLabel" or x.ClassName == "ImageButton" then
						TweenService:Create(x, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {ImageTransparency = 0}):Play()
					end
				end
			end
		end

		for _, v in ipairs(TabList:GetChildren()) do
			if v.ClassName == "Frame" and v.Name ~= "Placeholder" then
				if tostring(Elements.UIPageLayout.CurrentPage) == v.Title.Text then
					TweenService:Create(v, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
					TweenService:Create(v.Image, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {ImageTransparency = 0}):Play()
					TweenService:Create(v.Title, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()
					TweenService:Create(v.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
				else
					TweenService:Create(v, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.7}):Play()
					TweenService:Create(v.Image, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {ImageTransparency = 0.2}):Play()
					TweenService:Create(v.Title, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 0.2}):Play()
					TweenService:Create(v.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0.5}):Play()
				end
			end
		end

		task.wait(0.5)
		Debounce = false
	end

	function Window:CreateTab(Name, Image)
		local Tab = {
			Elements = {},
		}

		local TabButton = TabList.Template:Clone()
		TabButton.Name = Name
		TabButton.Title.Text = Name
		TabButton.Parent = TabList
		TabButton.BackgroundColor3 = SelectedTheme.TabBackground
		TabButton.UIStroke.Color = SelectedTheme.TabStroke
		TabButton.Visible = true

		if Image then
			if typeof(Image) == 'string' then
				local asset = getIcon(Image)
				TabButton.Image.Image = 'rbxassetid://'..asset.id
				TabButton.Image.ImageRectOffset = asset.imageRectOffset
				TabButton.Image.ImageRectSize = asset.imageRectSize
			else
				TabButton.Image.Image = getAssetUri(Image)
			end
		else
			TabButton.Image.Image = "rbxassetid://0"
		end

		local TabPage = Elements.Template:Clone()
		TabPage.Name = Name
		TabPage.Visible = false
		TabPage.Parent = Elements

		TabButton.Interact.MouseButton1Click:Connect(function()
			for _, OtherTabButton in ipairs(TabList:GetChildren()) do
				if OtherTabButton.Name ~= "Template" and OtherTabButton.ClassName == "Frame" and OtherTabButton ~= TabButton and OtherTabButton.Name ~= "Placeholder" then
					TweenService:Create(OtherTabButton, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = SelectedTheme.TabBackground}):Play()
					TweenService:Create(OtherTabButton.Title, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextColor3 = SelectedTheme.TabTextColor}):Play()
					TweenService:Create(OtherTabButton.Image, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {ImageColor3 = SelectedTheme.TabTextColor}):Play()
					TweenService:Create(OtherTabButton, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.7}):Play()
					TweenService:Create(OtherTabButton.Title, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 0.2}):Play()
					TweenService:Create(OtherTabButton.Image, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {ImageTransparency = 0.2}):Play()
					TweenService:Create(OtherTabButton.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0.5}):Play()
				end
			end

			TweenService:Create(TabButton, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = SelectedTheme.TabBackgroundSelected}):Play()
			TweenService:Create(TabButton.Title, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextColor3 = SelectedTheme.SelectedTabTextColor}):Play()
			TweenService:Create(TabButton.Image, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {ImageColor3 = SelectedTheme.SelectedTabTextColor}):Play()
			TweenService:Create(TabButton, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
			TweenService:Create(TabButton.Title, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()
			TweenService:Create(TabButton.Image, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {ImageTransparency = 0}):Play()
			TweenService:Create(TabButton.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()

			Elements.UIPageLayout:JumpTo(TabPage)
		end)

		function Tab:CreateSection(SectionName)
			local Section = Elements.Template.SectionTitle:Clone()
			Section.Title.Text = SectionName
			Section.Name = SectionName
			Section.Parent = TabPage
			Section.Visible = true
			return Section
		end

		function Tab:CreateButton(ButtonSettings)
			local Button = Elements.Template.Button:Clone()
			Button.Name = ButtonSettings.Name
			Button.Title.Text = ButtonSettings.Name
			Button.Parent = TabPage
			Button.Visible = true

			Button.BackgroundTransparency = 1
			Button.UIStroke.Transparency = 1
			Button.Title.TextTransparency = 1

			TweenService:Create(Button, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
			TweenService:Create(Button.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0}):Play()
			TweenService:Create(Button.Title, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()

			Button.Interact.MouseButton1Click:Connect(function()
				local Success, Response = pcall(ButtonSettings.Callback)
				if not Success then
					TweenService:Create(Button, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(85, 0, 0)}):Play()
					TweenService:Create(Button.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
					Button.Title.Text = "Callback Error"
					print("PickleLibrary | "..ButtonSettings.Name.." Callback Error " ..tostring(Response))
					warn('Check docs.sirius.menu for help with PickleLibrary specific development.')
					task.wait(0.5)
					Button.Title.Text = ButtonSettings.Name
					TweenService:Create(Button, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = SelectedTheme.ElementBackground}):Play()
					TweenService:Create(Button.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Transparency = 0}):Play()
				end
			end)

			Button.MouseEnter:Connect(function()
				TweenService:Create(Button, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = SelectedTheme.ElementBackgroundHover}):Play()
			end)

			Button.MouseLeave:Connect(function()
				TweenService:Create(Button, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = SelectedTheme.ElementBackground}):Play()
			end)

			return ButtonSettings
		end

		function Tab:CreateLabel(LabelText, Image, Color, Error)
			local Label = Elements.Template.Label:Clone()
			Label.Name = LabelText
			Label.Title.Text = LabelText
			Label.Parent = TabPage
			Label.Visible = true

			Label.BackgroundTransparency = 1
			Label.UIStroke.Transparency = 1
			Label.Title.TextTransparency = 1

			if Image then
				if typeof(Image) == 'string' then
					local asset = getIcon(Image)
					Label.Image.Image = 'rbxassetid://'..asset.id
					Label.Image.ImageRectOffset = asset.imageRectOffset
					Label.Image.ImageRectSize = asset.imageRectSize
				else
					Label.Image.Image = getAssetUri(Image)
				end
			end

			if Color then
				Label.Title.TextColor3 = Color
			end

			if Error then
				Label.UIStroke.Enabled = true
			end

			TweenService:Create(Label, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
			TweenService:Create(Label.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0}):Play()
			TweenService:Create(Label.Title, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()
			TweenService:Create(Label.Image, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {ImageTransparency = 0}):Play()

			function Label:Set(NewText)
				Label.Title.Text = NewText
				Label.Name = NewText
			end

			return Label
		end

		function Tab:CreateParagraph(ParagraphSettings)
			local Paragraph = Elements.Template.Paragraph:Clone()
			Paragraph.Name = ParagraphSettings.Title
			Paragraph.Title.Text = ParagraphSettings.Title
			Paragraph.Content.Text = ParagraphSettings.Content
			Paragraph.Parent = TabPage
			Paragraph.Visible = true

			Paragraph.BackgroundTransparency = 1
			Paragraph.UIStroke.Transparency = 1
			Paragraph.Title.TextTransparency = 1
			Paragraph.Content.TextTransparency = 1

			TweenService:Create(Paragraph, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
			TweenService:Create(Paragraph.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0}):Play()
			TweenService:Create(Paragraph.Title, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()
			TweenService:Create(Paragraph.Content, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()

			function Paragraph:Set(NewParagraphSettings)
				Paragraph.Title.Text = NewParagraphSettings.Title
				Paragraph.Content.Text = NewParagraphSettings.Content
				Paragraph.Name = NewParagraphSettings.Title
			end

			return Paragraph
		end

		function Tab:CreateInput(InputSettings)
			local Input = Elements.Template.Input:Clone()
			Input.Name = InputSettings.Name
			Input.Title.Text = InputSettings.Name
			Input.Visible = true
			Input.Parent = TabPage

			Input.BackgroundTransparency = 1
			Input.UIStroke.Transparency = 1
			Input.Title.TextTransparency = 1

			Input.InputFrame.BackgroundColor3 = SelectedTheme.InputBackground
			Input.InputFrame.UIStroke.Color = SelectedTheme.InputStroke
			Input.InputFrame.InputBox.PlaceholderColor3 = SelectedTheme.PlaceholderColor
			Input.InputFrame.InputBox.Text = InputSettings.CurrentValue or ""
			Input.InputFrame.InputBox.PlaceholderText = InputSettings.PlaceholderText or ""

			TweenService:Create(Input, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
			TweenService:Create(Input.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0}):Play()
			TweenService:Create(Input.Title, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()

			Input.MouseEnter:Connect(function()
				TweenService:Create(Input, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = SelectedTheme.ElementBackgroundHover}):Play()
			end)

			Input.MouseLeave:Connect(function()
				TweenService:Create(Input, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = SelectedTheme.ElementBackground}):Play()
			end)

			Input.InputFrame.InputBox.FocusLost:Connect(function(EnterPressed)
				if InputSettings.RemoveTextAfterFocusLost and not EnterPressed then
					Input.InputFrame.InputBox.Text = ""
				end
				local Success, Response = pcall(function()
					InputSettings.Callback(Input.InputFrame.InputBox.Text)
				end)
				if not Success then
					TweenService:Create(Input, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(85, 0, 0)}):Play()
					TweenService:Create(Input.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
					Input.Title.Text = "Callback Error"
					print("PickleLibrary | "..InputSettings.Name.." Callback Error " ..tostring(Response))
					warn('Check docs.sirius.menu for help with PickleLibrary specific development.')
					task.wait(0.5)
					Input.Title.Text = InputSettings.Name
					TweenService:Create(Input, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = SelectedTheme.ElementBackground}):Play()
					TweenService:Create(Input.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Transparency = 0}):Play()
				end
				InputSettings.CurrentValue = Input.InputFrame.InputBox.Text
				if not InputSettings.Ext then
					SaveConfiguration()
				end
			end)

			function InputSettings:Set(NewText)
				Input.InputFrame.InputBox.Text = NewText
				InputSettings.CurrentValue = NewText
				local Success, Response = pcall(function()
					InputSettings.Callback(NewText)
				end)
				if not Success then
					TweenService:Create(Input, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(85, 0, 0)}):Play()
					TweenService:Create(Input.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
					Input.Title.Text = "Callback Error"
					print("PickleLibrary | "..InputSettings.Name.." Callback Error " ..tostring(Response))
					warn('Check docs.sirius.menu for help with PickleLibrary specific development.')
					task.wait(0.5)
					Input.Title.Text = InputSettings.Name
					TweenService:Create(Input, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = SelectedTheme.ElementBackground}):Play()
					TweenService:Create(Input.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Transparency = 0}):Play()
				end
				if not InputSettings.Ext then
					SaveConfiguration()
				end
			end

			if Settings.ConfigurationSaving then
				if Settings.ConfigurationSaving.Enabled and InputSettings.Flag then
					PickleLibrary.Flags[InputSettings.Flag] = InputSettings
				end
			end

			Pickle.Main:GetPropertyChangedSignal('BackgroundColor3'):Connect(function()
				Input.InputFrame.BackgroundColor3 = SelectedTheme.InputBackground
				Input.InputFrame.UIStroke.Color = SelectedTheme.InputStroke
				Input.InputFrame.InputBox.PlaceholderColor3 = SelectedTheme.PlaceholderColor
			end)

			return InputSettings
		end

		function Tab:CreateDropdown(DropdownSettings)
			local Dropdown = Elements.Template.Dropdown:Clone()
			Dropdown.Name = DropdownSettings.Name
			Dropdown.Title.Text = DropdownSettings.Name
			Dropdown.Visible = true
			Dropdown.Parent = TabPage

			Dropdown.BackgroundTransparency = 1
			Dropdown.UIStroke.Transparency = 1
			Dropdown.Title.TextTransparency = 1

			if DropdownSettings.MultipleOptions then
				DropdownSettings.CurrentOption = DropdownSettings.CurrentOption or {}
			else
				DropdownSettings.CurrentOption = DropdownSettings.CurrentOption or {DropdownSettings.Options[1]}
			end

			local function RefreshTitle()
				if DropdownSettings.MultipleOptions then
					local OptionsText = ""
					for i, Option in ipairs(DropdownSettings.CurrentOption) do
						OptionsText = OptionsText .. Option
						if i < #DropdownSettings.CurrentOption then
							OptionsText = OptionsText .. ", "
						end
					end
					Dropdown.DropdownFrame.Button.Text = OptionsText
				else
					Dropdown.DropdownFrame.Button.Text = DropdownSettings.CurrentOption[1]
				end
			end

			RefreshTitle()

			for _, Option in ipairs(DropdownSettings.Options) do
				local OptionButton = Dropdown.DropdownFrame.DropdownList.Template:Clone()
				OptionButton.Name = Option
				OptionButton.Title.Text = Option
				OptionButton.Parent = Dropdown.DropdownFrame.DropdownList
				OptionButton.Visible = true

				OptionButton.BackgroundTransparency = 1
				OptionButton.UIStroke.Transparency = 1
				OptionButton.Title.TextTransparency = 1

				TweenService:Create(OptionButton, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
				TweenService:Create(OptionButton.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0}):Play()
				TweenService:Create(OptionButton.Title, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()

				OptionButton.MouseButton1Click:Connect(function()
					if DropdownSettings.MultipleOptions then
						if table.find(DropdownSettings.CurrentOption, Option) then
							table.remove(DropdownSettings.CurrentOption, table.find(DropdownSettings.CurrentOption, Option))
						else
							table.insert(DropdownSettings.CurrentOption, Option)
						end
					else
						DropdownSettings.CurrentOption = {Option}
						TweenService:Create(Dropdown.DropdownFrame.DropdownList, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Size = UDim2.new(1, 0, 0, 0)}):Play()
						TweenService:Create(Dropdown.DropdownFrame, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {BackgroundTransparency = 1}):Play()
						TweenService:Create(Dropdown.DropdownFrame.UIStroke, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
						TweenService:Create(Dropdown.DropdownFrame.Button, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()
						Dropdown.DropdownFrame.Visible = false
					end
					RefreshTitle()
					local Success, Response = pcall(function()
						DropdownSettings.Callback(DropdownSettings.CurrentOption)
					end)
					if not Success then
						TweenService:Create(Dropdown, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(85, 0, 0)}):Play()
						TweenService:Create(Dropdown.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
						Dropdown.Title.Text = "Callback Error"
						print("PickleLibrary | "..DropdownSettings.Name.." Callback Error " ..tostring(Response))
						warn('Check docs.sirius.menu for help with PickleLibrary specific development.')
						task.wait(0.5)
						Dropdown.Title.Text = DropdownSettings.Name
						TweenService:Create(Dropdown, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = SelectedTheme.ElementBackground}):Play()
						TweenService:Create(Dropdown.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Transparency = 0}):Play()
					end
					if not DropdownSettings.Ext then
						SaveConfiguration()
					end
				end)
			end

			Dropdown.MouseEnter:Connect(function()
				TweenService:Create(Dropdown, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = SelectedTheme.ElementBackgroundHover}):Play()
			end)

			Dropdown.MouseLeave:Connect(function()
				TweenService:Create(Dropdown, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = SelectedTheme.ElementBackground}):Play()
			end)

			Dropdown.DropdownFrame.Button.MouseButton1Click:Connect(function()
				if Dropdown.DropdownFrame.Visible then
					TweenService:Create(Dropdown.DropdownFrame.DropdownList, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Size = UDim2.new(1, 0, 0, 0)}):Play()
					TweenService:Create(Dropdown.DropdownFrame, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {BackgroundTransparency = 1}):Play()
					TweenService:Create(Dropdown.DropdownFrame.UIStroke, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
					TweenService:Create(Dropdown.DropdownFrame.Button, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()
					Dropdown.DropdownFrame.Visible = false
				else
					Dropdown.DropdownFrame.Visible = true
					TweenService:Create(Dropdown.DropdownFrame, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
					TweenService:Create(Dropdown.DropdownFrame.UIStroke, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Transparency = 0}):Play()
					TweenService:Create(Dropdown.DropdownFrame.Button, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()
					TweenService:Create(Dropdown.DropdownFrame.DropdownList, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Size = UDim2.new(1, 0, 0, math.min(Dropdown.DropdownFrame.DropdownList.UIListLayout.AbsoluteContentSize.Y, 150))}):Play()
				end
			end)

			function DropdownSettings:Set(NewOption)
				if DropdownSettings.MultipleOptions then
					DropdownSettings.CurrentOption = NewOption
				else
					DropdownSettings.CurrentOption = {NewOption}
				end
				RefreshTitle()
				local Success, Response = pcall(function()
					DropdownSettings.Callback(DropdownSettings.CurrentOption)
				end)
				if not Success then
					TweenService:Create(Dropdown, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(85, 0, 0)}):Play()
					TweenService:Create(Dropdown.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
					Dropdown.Title.Text = "Callback Error"
					print("PickleLibrary | "..DropdownSettings.Name.." Callback Error " ..tostring(Response))
					warn('Check docs.sirius.menu for help with PickleLibrary specific development.')
					task.wait(0.5)
					Dropdown.Title.Text = DropdownSettings.Name
					TweenService:Create(Dropdown, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = SelectedTheme.ElementBackground}):Play()
					TweenService:Create(Dropdown.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Transparency = 0}):Play()
				end
				if not DropdownSettings.Ext then
					SaveConfiguration()
				end
			end

			TweenService:Create(Dropdown, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
			TweenService:Create(Dropdown.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0}):Play()
			TweenService:Create(Dropdown.Title, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()
			TweenService:Create(Dropdown.DropdownFrame, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 1}):Play()
			TweenService:Create(Dropdown.DropdownFrame.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
			TweenService:Create(Dropdown.DropdownFrame.Button, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()

			if Settings.ConfigurationSaving then
				if Settings.ConfigurationSaving.Enabled and DropdownSettings.Flag then
					PickleLibrary.Flags[DropdownSettings.Flag] = DropdownSettings
				end
			end

			Pickle.Main:GetPropertyChangedSignal('BackgroundColor3'):Connect(function()
				Dropdown.DropdownFrame.BackgroundColor3 = SelectedTheme.DropdownUnselected
				Dropdown.DropdownFrame.UIStroke.Color = SelectedTheme.ElementStroke
				for _, OptionButton in ipairs(Dropdown.DropdownFrame.DropdownList:GetChildren()) do
					if OptionButton.ClassName == "Frame" and OptionButton.Name ~= "Template" then
						OptionButton.BackgroundColor3 = SelectedTheme.DropdownUnselected
						OptionButton.UIStroke.Color = SelectedTheme.ElementStroke
					end
				end
			end)

			return DropdownSettings
		end

		function Tab:CreateToggle(ToggleSettings)
			local Toggle = Elements.Template.Toggle:Clone()
			Toggle.Name = ToggleSettings.Name
			Toggle.Title.Text = ToggleSettings.Name
			Toggle.Visible = true
			Toggle.Parent = TabPage

			Toggle.BackgroundTransparency = 1
			Toggle.UIStroke.Transparency = 1
			Toggle.Title.TextTransparency = 1
			Toggle.Switch.BackgroundTransparency = 1
			Toggle.Switch.UIStroke.Transparency = 1
			Toggle.Switch.Knob.BackgroundTransparency = 1
			Toggle.Switch.Knob.UIStroke.Transparency = 1

			Toggle.Switch.BackgroundColor3 = SelectedTheme.ToggleBackground
			Toggle.Switch.UIStroke.Color = SelectedTheme.ToggleDisabledStroke
			Toggle.Switch.Knob.BackgroundColor3 = ToggleSettings.CurrentValue and SelectedTheme.ToggleEnabled or SelectedTheme.ToggleDisabled
			Toggle.Switch.Knob.UIStroke.Color = ToggleSettings.CurrentValue and SelectedTheme.ToggleEnabledStroke or SelectedTheme.ToggleDisabledStroke

			TweenService:Create(Toggle, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
			TweenService:Create(Toggle.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0}):Play()
			Toggle.Title.TextTransparency = 0
			TweenService:Create(Toggle.Switch, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
			TweenService:Create(Toggle.Switch.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0}):Play()
			TweenService:Create(Toggle.Switch.Knob, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
			TweenService:Create(Toggle.Switch.Knob.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0}):Play()

			Toggle.MouseEnter:Connect(function()
				TweenService:Create(Toggle, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = SelectedTheme.ElementBackgroundHover}):Play()
			end)

			Toggle.MouseLeave:Connect(function()
				TweenService:Create(Toggle, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = SelectedTheme.ElementBackground}):Play()
			end)

			Toggle.Interact.MouseButton1Click:Connect(function()
				ToggleSettings.CurrentValue = not ToggleSettings.CurrentValue
				TweenService:Create(Toggle.Switch.Knob, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {Position = ToggleSettings.CurrentValue and UDim2.new(1, -20, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)}):Play()
				TweenService:Create(Toggle.Switch.Knob, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {BackgroundColor3 = ToggleSettings.CurrentValue and SelectedTheme.ToggleEnabled or SelectedTheme.ToggleDisabled}):Play()
				TweenService:Create(Toggle.Switch.Knob.UIStroke, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {Color = ToggleSettings.CurrentValue and SelectedTheme.ToggleEnabledStroke or SelectedTheme.ToggleDisabledStroke}):Play()
				local Success, Response = pcall(function()
					ToggleSettings.Callback(ToggleSettings.CurrentValue)
				end)
				if not Success then
					TweenService:Create(Toggle, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(85, 0, 0)}):Play()
					TweenService:Create(Toggle.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
					Toggle.Title.Text = "Callback Error"
					print("PickleLibrary | "..ToggleSettings.Name.." Callback Error " ..tostring(Response))
					warn('Check docs.sirius.menu for help with PickleLibrary specific development.')
					task.wait(0.5)
					Toggle.Title.Text = ToggleSettings.Name
					TweenService:Create(Toggle, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = SelectedTheme.ElementBackground}):Play()
					TweenService:Create(Toggle.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Transparency = 0}):Play()
				end
				if not ToggleSettings.Ext then
					SaveConfiguration()
				end
			end)

			function ToggleSettings:Set(NewToggleValue)
				ToggleSettings.CurrentValue = NewToggleValue
				TweenService:Create(Toggle.Switch.Knob, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {Position = ToggleSettings.CurrentValue and UDim2.new(1, -20, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)}):Play()
				TweenService:Create(Toggle.Switch.Knob, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {BackgroundColor3 = ToggleSettings.CurrentValue and SelectedTheme.ToggleEnabled or SelectedTheme.ToggleDisabled}):Play()
				TweenService:Create(Toggle.Switch.Knob.UIStroke, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {Color = ToggleSettings.CurrentValue and SelectedTheme.ToggleEnabledStroke or SelectedTheme.ToggleDisabledStroke}):Play()
				local Success, Response = pcall(function()
					ToggleSettings.Callback(ToggleSettings.CurrentValue)
				end)
				if not Success then
					TweenService:Create(Toggle, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(85, 0, 0)}):Play()
					TweenService:Create(Toggle.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
					Toggle.Title.Text = "Callback Error"
					print("PickleLibrary | "..ToggleSettings.Name.." Callback Error " ..tostring(Response))
					warn('Check docs.sirius.menu for help with PickleLibrary specific development.')
					task.wait(0.5)
					Toggle.Title.Text = ToggleSettings.Name
					TweenService:Create(Toggle, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = SelectedTheme.ElementBackground}):Play()
					TweenService:Create(Toggle.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Transparency = 0}):Play()
				end
				if not ToggleSettings.Ext then
					SaveConfiguration()
				end
			end

			if Settings.ConfigurationSaving then
				if Settings.ConfigurationSaving.Enabled and ToggleSettings.Flag then
					PickleLibrary.Flags[ToggleSettings.Flag] = ToggleSettings
				end
			end

			Pickle.Main:GetPropertyChangedSignal('BackgroundColor3'):Connect(function()
				Toggle.Switch.BackgroundColor3 = SelectedTheme.ToggleBackground
				Toggle.Switch.UIStroke.Color = SelectedTheme.ToggleDisabledStroke
				Toggle.Switch.Knob.BackgroundColor3 = ToggleSettings.CurrentValue and SelectedTheme.ToggleEnabled or SelectedTheme.ToggleDisabled
				Toggle.Switch.Knob.UIStroke.Color = ToggleSettings.CurrentValue and SelectedTheme.ToggleEnabledStroke or SelectedTheme.ToggleDisabledStroke
			end)

			return ToggleSettings
		end

		function Tab:CreateSlider(SliderSettings)
			local Slider = Elements.Template.Slider:Clone()
			Slider.Name = SliderSettings.Name
			Slider.Title.Text = SliderSettings.Name
			Slider.Visible = true
			Slider.Parent = TabPage

			Slider.BackgroundTransparency = 1
			Slider.UIStroke.Transparency = 1
			Slider.Title.TextTransparency = 1

			Slider.SliderFrame.BackgroundColor3 = SelectedTheme.SliderBackground
			Slider.SliderFrame.UIStroke.Color = SelectedTheme.SliderStroke
			Slider.SliderFrame.SliderBar.BackgroundColor3 = SelectedTheme.SliderProgress

			local function UpdateSlider()
				local Percent = (SliderSettings.CurrentValue - SliderSettings.Range[1]) / (SliderSettings.Range[2] - SliderSettings.Range[1])
				Slider.SliderFrame.SliderBar.Size = UDim2.new(Percent, 0, 1, 0)
				Slider.SliderFrame.Value.Text = tostring(SliderSettings.CurrentValue)
			end

			UpdateSlider()

			Slider.SliderFrame.Interact.MouseButton1Down:Connect(function()
				local MouseMove, MouseKill
				MouseMove = UserInputService.InputChanged:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
						local MouseLocation = UserInputService:GetMouseLocation()
						local Relative = (MouseLocation - Slider.SliderFrame.AbsolutePosition).X
						local Percent = math.clamp(Relative / Slider.SliderFrame.AbsoluteSize.X, 0, 1)
						SliderSettings.CurrentValue = math.floor(((SliderSettings.Range[2] - SliderSettings.Range[1]) * Percent) + SliderSettings.Range[1])
						UpdateSlider()
						local Success, Response = pcall(function()
							SliderSettings.Callback(SliderSettings.CurrentValue)
						end)
						if not Success then
							TweenService:Create(Slider, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(85, 0, 0)}):Play()
							TweenService:Create(Slider.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
							Slider.Title.Text = "Callback Error"
							print("PickleLibrary | "..SliderSettings.Name.." Callback Error " ..tostring(Response))
							warn('Check docs.sirius.menu for help with PickleLibrary specific development.')
							task.wait(0.5)
							Slider.Title.Text = SliderSettings.Name
							TweenService:Create(Slider, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = SelectedTheme.ElementBackground}):Play()
							TweenService:Create(Slider.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Transparency = 0}):Play()
						end
						if not SliderSettings.Ext then
							SaveConfiguration()
						end
					end
				end)
				MouseKill = UserInputService.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						MouseMove:Disconnect()
						MouseKill:Disconnect()
					end
				end)
			end)

			function SliderSettings:Set(NewValue)
				SliderSettings.CurrentValue = math.clamp(math.floor(NewValue), SliderSettings.Range[1], SliderSettings.Range[2])
				UpdateSlider()
				local Success, Response = pcall(function()
					SliderSettings.Callback(SliderSettings.CurrentValue)
				end)
				if not Success then
					TweenService:Create(Slider, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(85, 0, 0)}):Play()
					TweenService:Create(Slider.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
					Slider.Title.Text = "Callback Error"
					print("PickleLibrary | "..SliderSettings.Name.." Callback Error " ..tostring(Response))
					warn('Check docs.sirius.menu for help with PickleLibrary specific development.')
					task.wait(0.5)
					Slider.Title.Text = SliderSettings.Name
					TweenService:Create(Slider, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = SelectedTheme.ElementBackground}):Play()
					TweenService:Create(Slider.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Transparency = 0}):Play()
				end
				if not SliderSettings.Ext then
					SaveConfiguration()
				end
			end

			TweenService:Create(Slider, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
			TweenService:Create(Slider.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0}):Play()
			TweenService:Create(Slider.Title, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()

			if Settings.ConfigurationSaving then
				if Settings.ConfigurationSaving.Enabled and SliderSettings.Flag then
					PickleLibrary.Flags[SliderSettings.Flag] = SliderSettings
				end
			end

			Pickle.Main:GetPropertyChangedSignal('BackgroundColor3'):Connect(function()
				Slider.SliderFrame.BackgroundColor3 = SelectedTheme.SliderBackground
				Slider.SliderFrame.UIStroke.Color = SelectedTheme.SliderStroke
				Slider.SliderFrame.SliderBar.BackgroundColor3 = SelectedTheme.SliderProgress
			end)

			return SliderSettings
		end

		function Tab:CreateKeybind(KeybindSettings)
			local Keybind = Elements.Template.Keybind:Clone()
			Keybind.Name = KeybindSettings.Name
			Keybind.Title.Text = KeybindSettings.Name
			Keybind.Visible = true
			Keybind.Parent = TabPage

			Keybind.BackgroundTransparency = 1
			Keybind.UIStroke.Transparency = 1
			Keybind.Title.TextTransparency = 1
			Keybind.KeybindFrame.BackgroundTransparency = 1
			Keybind.KeybindFrame.UIStroke.Transparency = 1
			Keybind.KeybindFrame.Keybind.TextTransparency = 1

			Keybind.KeybindFrame.Keybind.Text = KeybindSettings.CurrentKeybind or "None"
			Keybind.KeybindFrame.Size = UDim2.new(0, Keybind.KeybindFrame.Keybind.TextBounds.X + 24, 0, 30)

			Keybind.MouseEnter:Connect(function()
				TweenService:Create(Keybind, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = SelectedTheme.ElementBackgroundHover}):Play()
			end)

			Keybind.MouseLeave:Connect(function()
				TweenService:Create(Keybind, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = SelectedTheme.ElementBackground}):Play()
			end)

			local KeyPressed
			KeyPressed = UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
				if KeybindSettings.HoldToInteract and not gameProcessedEvent and Keybind.KeybindFrame.Keybind.Text == "..." then
					local Key = input.KeyCode.Name ~= "Unknown" and input.KeyCode.Name or input.UserInputType.Name
					if KeybindSettings.CurrentKeybind ~= Key then
						KeybindSettings.CurrentKeybind = Key
						Keybind.KeybindFrame.Keybind.Text = Key
						Keybind.KeybindFrame.Size = UDim2.new(0, Keybind.KeybindFrame.Keybind.TextBounds.X + 24, 0, 30)
						local Success, Response = pcall(function()
							KeybindSettings.Callback(KeybindSettings.CurrentKeybind)
						end)
						if not Success then
							TweenService:Create(Keybind, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(85, 0, 0)}):Play()
							TweenService:Create(Keybind.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
							Keybind.Title.Text = "Callback Error"
							print("PickleLibrary | "..KeybindSettings.Name.." Callback Error " ..tostring(Response))
							warn('Check docs.sirius.menu for help with PickleLibrary specific development.')
							task.wait(0.5)
							Keybind.Title.Text = KeybindSettings.Name
							TweenService:Create(Keybind, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = SelectedTheme.ElementBackground}):Play()
							TweenService:Create(Keybind.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Transparency = 0}):Play()
						end
						if not KeybindSettings.Ext then
							SaveConfiguration()
						end
					end
				end
			end)

			Keybind.KeybindFrame.Interact.MouseButton1Click:Connect(function()
				Keybind.KeybindFrame.Keybind.Text = "..."
				Keybind.KeybindFrame.Size = UDim2.new(0, Keybind.KeybindFrame.Keybind.TextBounds.X + 24, 0, 30)
				local InputBegan
				InputBegan = UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
					if not gameProcessedEvent then
						local Key = input.KeyCode.Name ~= "Unknown" and input.KeyCode.Name or input.UserInputType.Name
						if not KeybindSettings.HoldToInteract then
							KeybindSettings.CurrentKeybind = Key
							Keybind.KeybindFrame.Keybind.Text = Key
							Keybind.KeybindFrame.Size = UDim2.new(0, Keybind.KeybindFrame.Keybind.TextBounds.X + 24, 0, 30)
							local Success, Response = pcall(function()
								KeybindSettings.Callback(KeybindSettings.CurrentKeybind)
							end)
							if not Success then
								TweenService:Create(Keybind, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(85, 0, 0)}):Play()
								TweenService:Create(Keybind.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
								Keybind.Title.Text = "Callback Error"
								print("PickleLibrary | "..KeybindSettings.Name.." Callback Error " ..tostring(Response))
								warn('Check docs.sirius.menu for help with PickleLibrary specific development.')
								task.wait(0.5)
								Keybind.Title.Text = KeybindSettings.Name
								TweenService:Create(Keybind, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = SelectedTheme.ElementBackground}):Play()
								TweenService:Create(Keybind.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Transparency = 0}):Play()
							end
							if not KeybindSettings.Ext then
								SaveConfiguration()
							end
							InputBegan:Disconnect()
						end
					end
				end)
			end)

			function KeybindSettings:Set(NewKeybind)
				KeybindSettings.CurrentKeybind = NewKeybind
				Keybind.KeybindFrame.Keybind.Text = NewKeybind
				Keybind.KeybindFrame.Size = UDim2.new(0, Keybind.KeybindFrame.Keybind.TextBounds.X + 24, 0, 30)
				local Success, Response = pcall(function()
					KeybindSettings.Callback(KeybindSettings.CurrentKeybind)
				end)
				if not Success then
					TweenService:Create(Keybind, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(85, 0, 0)}):Play()
					TweenService:Create(Keybind.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
					Keybind.Title.Text = "Callback Error"
					print("PickleLibrary | "..KeybindSettings.Name.." Callback Error " ..tostring(Response))
					warn('Check docs.sirius.menu for help with PickleLibrary specific development.')
					task.wait(0.5)
					Keybind.Title.Text = KeybindSettings.Name
					TweenService:Create(Keybind, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = SelectedTheme.ElementBackground}):Play()
					TweenService:Create(Keybind.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Transparency = 0}):Play()
				end
				if not KeybindSettings.Ext then
					SaveConfiguration()
				end
			end

			TweenService:Create(Keybind, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
			TweenService:Create(Keybind.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0}):Play()
			TweenService:Create(Keybind.Title, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()
			TweenService:Create(Keybind.KeybindFrame, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
			TweenService:Create(Keybind.KeybindFrame.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0}):Play()
			TweenService:Create(Keybind.KeybindFrame.Keybind, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()

			if Settings.ConfigurationSaving then
				if Settings.ConfigurationSaving.Enabled and KeybindSettings.Flag then
					PickleLibrary.Flags[KeybindSettings.Flag] = KeybindSettings
				end
			end

			Pickle.Main:GetPropertyChangedSignal('BackgroundColor3'):Connect(function()
				Keybind.KeybindFrame.BackgroundColor3 = SelectedTheme.InputBackground
				Keybind.KeybindFrame.UIStroke.Color = SelectedTheme.InputStroke
			end)

			return KeybindSettings
		end

		function Tab:CreateColorPicker(ColorPickerSettings)
			local ColorPicker = Elements.Template.ColorPicker:Clone()
			ColorPicker.Name = ColorPickerSettings.Name
			ColorPicker.Title.Text = ColorPickerSettings.Name
			ColorPicker.Visible = true
			ColorPicker.Parent = TabPage

			ColorPicker.BackgroundTransparency = 1
			ColorPicker.UIStroke.Transparency = 1
			ColorPicker.Title.TextTransparency = 1

			ColorPicker.ColorFrame.BackgroundColor3 = ColorPickerSettings.Color
			ColorPicker.ColorFrame.UIStroke.Color = SelectedTheme.ElementStroke

			local function UpdateColor()
				ColorPicker.ColorFrame.BackgroundColor3 = ColorPickerSettings.Color
				local Success, Response = pcall(function()
					ColorPickerSettings.Callback(ColorPickerSettings.Color)
				end)
				if not Success then
					TweenService:Create(ColorPicker, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(85, 0, 0)}):Play()
					TweenService:Create(ColorPicker.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
					ColorPicker.Title.Text = "Callback Error"
					print("PickleLibrary | "..ColorPickerSettings.Name.." Callback Error " ..tostring(Response))
					warn('Check docs.sirius.menu for help with PickleLibrary specific development.')
					task.wait(0.5)
					ColorPicker.Title.Text = ColorPickerSettings.Name
					TweenService:Create(ColorPicker, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = SelectedTheme.ElementBackground}):Play()
					TweenService:Create(ColorPicker.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Transparency = 0}):Play()
				end
				if not ColorPickerSettings.Ext then
					SaveConfiguration()
				end
			end

			ColorPicker.ColorFrame.Interact.MouseButton1Click:Connect(function()
				local ColorPickerUI = MPrompt.ColorPicker:Clone()
				ColorPickerUI.Parent = Pickle
				ColorPickerUI.Visible = true
				ColorPickerUI.BackgroundTransparency = 1
				ColorPickerUI.Picker.BackgroundTransparency = 1
				ColorPickerUI.Picker.UIStroke.Transparency = 1
				ColorPickerUI.Picker.Hue.BackgroundTransparency = 1
				ColorPickerUI.Picker.Saturation.BackgroundTransparency = 1
				ColorPickerUI.Picker.RGB.BackgroundTransparency = 1
				ColorPickerUI.Picker.RGB.RInput.TextTransparency = 1
				ColorPickerUI.Picker.RGB.GInput.TextTransparency = 1
				ColorPickerUI.Picker.RGB.BInput.TextTransparency = 1

				local H, S, V = ColorPickerSettings.Color:ToHSV()
				ColorPickerUI.Picker.Hue.Slider.Position = UDim2.new(0, 0, 1 - H, 0)
				ColorPickerUI.Picker.Saturation.Slider.Position = UDim2.new(S, 0, 1 - V, 0)
				ColorPickerUI.Picker.RGB.RInput.Text = math.floor(ColorPickerSettings.Color.R * 255)
				ColorPickerUI.Picker.RGB.GInput.Text = math.floor(ColorPickerSettings.Color.G * 255)
				ColorPickerUI.Picker.RGB.BInput.Text = math.floor(ColorPickerSettings.Color.B * 255)

				TweenService:Create(ColorPickerUI, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.5}):Play()
				TweenService:Create(ColorPickerUI.Picker, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
				TweenService:Create(ColorPickerUI.Picker.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0}):Play()
				TweenService:Create(ColorPickerUI.Picker.Hue, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
				TweenService:Create(ColorPickerUI.Picker.Saturation, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
				TweenService:Create(ColorPickerUI.Picker.RGB, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
				TweenService:Create(ColorPickerUI.Picker.RGB.RInput, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()
				TweenService:Create(ColorPickerUI.Picker.RGB.GInput, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()
				TweenService:Create(ColorPickerUI.Picker.RGB.BInput, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()

				local function UpdateFromInputs()
					local R = tonumber(ColorPickerUI.Picker.RGB.RInput.Text) or 0
					local G = tonumber(ColorPickerUI.Picker.RGB.GInput.Text) or 0
					local B = tonumber(ColorPickerUI.Picker.RGB.BInput.Text) or 0
					R = math.clamp(R, 0, 255)
					G = math.clamp(G, 0, 255)
					B = math.clamp(B, 0, 255)
					ColorPickerSettings.Color = Color3.fromRGB(R, G, B)
					H, S, V = ColorPickerSettings.Color:ToHSV()
					ColorPickerUI.Picker.Hue.Slider.Position = UDim2.new(0, 0, 1 - H, 0)
					ColorPickerUI.Picker.Saturation.Slider.Position = UDim2.new(S, 0, 1 - V, 0)
					UpdateColor()
				end

				ColorPickerUI.Picker.Hue.Interact.MouseButton1Down:Connect(function()
					local MouseMove, MouseKill
					MouseMove = UserInputService.InputChanged:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
							local MouseLocation = UserInputService:GetMouseLocation()
							local Percent = math.clamp((MouseLocation.Y - ColorPickerUI.Picker.Hue.AbsolutePosition.Y) / ColorPickerUI.Picker.Hue.AbsoluteSize.Y, 0, 1)
							H = 1 - Percent
							ColorPickerSettings.Color = Color3.fromHSV(H, S, V)
							ColorPickerUI.Picker.Saturation.Slider.Position = UDim2.new(S, 0, 1 - V, 0)
							ColorPickerUI.Picker.RGB.RInput.Text = math.floor(ColorPickerSettings.Color.R * 255)
							ColorPickerUI.Picker.RGB.GInput.Text = math.floor(ColorPickerSettings.Color.G * 255)
							ColorPickerUI.Picker.RGB.BInput.Text = math.floor(ColorPickerSettings.Color.B * 255)
							UpdateColor()
						end
					end)
					MouseKill = UserInputService.InputEnded:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
							MouseMove:Disconnect()
							MouseKill:Disconnect()
						end
					end)
				end)

				ColorPickerUI.Picker.Saturation.Interact.MouseButton1Down:Connect(function()
					local MouseMove, MouseKill
					MouseMove = UserInputService.InputChanged:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
							local MouseLocation = UserInputService:GetMouseLocation()
							local XPercent = math.clamp((MouseLocation.X - ColorPickerUI.Picker.Saturation.AbsolutePosition.X) / ColorPickerUI.Picker.Saturation.AbsoluteSize.X, 0, 1)
							local YPercent = math.clamp((MouseLocation.Y - ColorPickerUI.Picker.Saturation.AbsolutePosition.Y) / ColorPickerUI.Picker.Saturation.AbsoluteSize.Y, 0, 1)
							S = XPercent
							V = 1 - YPercent
							ColorPickerSettings.Color = Color3.fromHSV(H, S, V)
							ColorPickerUI.Picker.RGB.RInput.Text = math.floor(ColorPickerSettings.Color.R * 255)
							ColorPickerUI.Picker.RGB.GInput.Text = math.floor(ColorPickerSettings.Color.G * 255)
							ColorPickerUI.Picker.RGB.BInput.Text = math.floor(ColorPickerSettings.Color.B * 255)
							UpdateColor()
						end
					end)
					MouseKill = UserInputService.InputEnded:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
							MouseMove:Disconnect()
							MouseKill:Disconnect()
						end
					end)
				end)

				ColorPickerUI.Picker.RGB.RInput.FocusLost:Connect(UpdateFromInputs)
				ColorPickerUI.Picker.RGB.GInput.FocusLost:Connect(UpdateFromInputs)
				ColorPickerUI.Picker.RGB.BInput.FocusLost:Connect(UpdateFromInputs)

				ColorPickerUI.Picker.Close.Interact.MouseButton1Click:Connect(function()
					TweenService:Create(ColorPickerUI, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 1}):Play()
					TweenService:Create(ColorPickerUI.Picker, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 1}):Play()
					TweenService:Create(ColorPickerUI.Picker.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
					TweenService:Create(ColorPickerUI.Picker.Hue, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 1}):Play()
					TweenService:Create(ColorPickerUI.Picker.Saturation, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 1}):Play()
					TweenService:Create(ColorPickerUI.Picker.RGB, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 1}):Play()
					TweenService:Create(ColorPickerUI.Picker.RGB.RInput, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()
					TweenService:Create(ColorPickerUI.Picker.RGB.GInput, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()
					TweenService:Create(ColorPickerUI.Picker.RGB.BInput, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()
					task.wait(0.7)
					ColorPickerUI:Destroy()
				end)
			end)

			function ColorPickerSettings:Set(NewColor)
				ColorPickerSettings.Color = NewColor
				UpdateColor()
			end

			TweenService:Create(ColorPicker, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
			TweenService:Create(ColorPicker.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0}):Play()
			TweenService:Create(ColorPicker.Title, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()

			if Settings.ConfigurationSaving then
				if Settings.ConfigurationSaving.Enabled and ColorPickerSettings.Flag then
					PickleLibrary.Flags[ColorPickerSettings.Flag] = ColorPickerSettings
				end
			end

			Pickle.Main:GetPropertyChangedSignal('BackgroundColor3'):Connect(function()
				ColorPicker.ColorFrame.UIStroke.Color = SelectedTheme.ElementStroke
			end)

			return ColorPickerSettings
		end

		function Tab:CreateDivider()
			local Divider = Elements.Template.Divider:Clone()
			Divider.Visible = true
			Divider.Parent = TabPage
			Divider.BackgroundTransparency = 1
			TweenService:Create(Divider, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
			return Divider
		end

		function Tab:CreateSpacing()
			local Spacing = Elements.Template.SectionSpacing:Clone()
			Spacing.Visible = true
			Spacing.Parent = TabPage
			return Spacing
		end

		TabPage.Visible = (#TabList:GetChildren() - 1) == 1
		table.insert(Window.Tabs, Tab)
		return Tab
	end

	function Window:CreateSettingsTab(SettingsTabSettings)
		local SettingsTab = Window:CreateTab(SettingsTabSettings.Name or "Settings", SettingsTabSettings.Image or 3926305904)
		local SettingsSection = SettingsTab:CreateSection("PickleLibrary Settings")
		local KeybindSettings = SettingsTab:CreateKeybind({
			Name = settingsTable.General.pickleOpen.Name,
			CurrentKeybind = getSetting("General", "pickleOpen"),
			HoldToInteract = settingsTable.General.pickleOpen.HoldToInteract or false,
			Flag = "PickleOpenBind",
			Ext = true,
			Callback = function(Key)
				settingsTable.General.pickleOpen.Value = Key
				if not settingsInitialized then return end
				local Data = {}
				for categoryName, settingCategory in pairs(settingsTable) do
					Data[categoryName] = {}
					for settingName, setting in pairs(settingCategory) do
						Data[categoryName][settingName] = {
							Value = setting.Value,
							Type = setting.Type,
							Name = setting.Name,
							Element = setting.Element
						}
					end
				end
				if writefile then
					if not isfolder(PickleFolder) then
						makefolder(PickleFolder)
					end
					writefile(PickleFolder..'/settings'..ConfigurationExtension, HttpService:JSONEncode(Data))
				end
			end,
		})
		settingsTable.General.pickleOpen.Element = KeybindSettings

		local AnalyticsToggle = SettingsTab:CreateToggle({
			Name = settingsTable.System.usageAnalytics.Name,
			CurrentValue = getSetting("System", "usageAnalytics"),
			Flag = "AnalyticsToggle",
			Ext = true,
			Callback = function(Value)
				if requestsDisabled then
					PickleLibrary:Notify({
						Title = "PickleLibrary Analytics",
						Content = "Analytics cannot be enabled as requests have been disabled by the developer.",
						Duration = 5
					})
					AnalyticsToggle:Set(false)
					return
				end
				settingsTable.System.usageAnalytics.Value = Value
				if not settingsInitialized then return end
				local Data = {}
				for categoryName, settingCategory in pairs(settingsTable) do
					Data[categoryName] = {}
					for settingName, setting in pairs(settingCategory) do
						Data[categoryName][settingName] = {
							Value = setting.Value,
							Type = setting.Type,
							Name = setting.Name,
							Element = setting.Element
						}
					end
				end
				if writefile then
					if not isfolder(PickleFolder) then
						makefolder(PickleFolder)
					end
					writefile(PickleFolder..'/settings'..ConfigurationExtension, HttpService:JSONEncode(Data))
				end
				if Value then
					sendReport("execution", "PickleLibrary")
				end
			end,
		})
		settingsTable.System.usageAnalytics.Element = AnalyticsToggle

		if not settingsCreated then
			settingsCreated = true
			loadSettings()
		end
		return SettingsTab
	end

	Pickle.Main.Topbar.ChangeSize.MouseButton1Click:Connect(function()
		if not Debounce then
			if Minimised then
				Maximise()
			else
				Minimise()
			end
			Minimised = not Minimised
		end
	end)

	Pickle.Main.Topbar.Search.MouseButton1Click:Connect(function()
		if not Debounce then
			if searchOpen then
				closeSearch()
			else
				openSearch()
			end
		end
	end)

	Pickle.Main.Topbar.Hide.MouseButton1Click:Connect(function()
		if not Debounce then
			Hidden = true
			Hide(true)
		end
	end)

	Pickle.Main.Search.Input:GetPropertyChangedSignal("Text"):Connect(function()
		local searchText = string.lower(Pickle.Main.Search.Input.Text)
		for _, tab in ipairs(Window.Tabs) do
			for _, element in ipairs(tab.Elements) do
				if element:IsA("Frame") and element.Name ~= "SectionTitle" and element.Name ~= "SectionSpacing" and element.Name ~= "Divider" then
					if string.find(string.lower(element.Name), searchText) then
						element.Visible = true
					else
						element.Visible = false
					end
				end
			end
		end
	end)

	Pickle.Main.Search.Input.FocusLost:Connect(function()
		if searchOpen then
			closeSearch()
		end
	end)

	local KeybindConnection
	KeybindConnection = UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
		if not gameProcessedEvent and not pickleDestroyed then
			local Key = input.KeyCode.Name ~= "Unknown" and input.KeyCode.Name or input.UserInputType.Name
			if Key == getSetting("General", "pickleOpen") then
				if Hidden then
					Hidden = false
					Unhide()
				else
					Hidden = true
					Hide(true)
				end
			end
		end
	end)

	if dragBar and dragInteract then
		makeDraggable(Pickle.Main, dragInteract, true, {dragOffset, dragOffsetMobile})
	end

	function Window:Destroy()
		Pickle:Destroy()
		if KeybindConnection then
			KeybindConnection:Disconnect()
		end
		pickleDestroyed = true
	end

	function Window:LoadConfiguration()
		if CEnabled and isfile and isfile(ConfigurationFolder .. "/" .. CFileName .. ConfigurationExtension) then
			local FileContents = readfile(ConfigurationFolder .. "/" .. CFileName .. ConfigurationExtension)
			local Changed = LoadConfiguration(FileContents)
			if Changed then
				PickleLibrary:Notify({
					Title = "Configuration Loaded",
					Content = "The configuration file was loaded successfully.",
					Duration = 5
				})
			end
		end
	end

	Pickle.Enabled = true
	TweenService:Create(Pickle.Main.Shadow.Image, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {ImageTransparency = 0.6}):Play()
	TweenService:Create(Pickle.Main, TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {Size = useMobileSizing and UDim2.new(0, 500, 0, 275) or UDim2.new(0, 500, 0, 475)}):Play()
	TweenService:Create(Pickle.Main.Topbar, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
	TweenService:Create(Pickle.Main.Topbar.CornerRepair, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
	TweenService:Create(Pickle.Main.Topbar.Title, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()
	TweenService:Create(Pickle.Main.Topbar.Subtitle, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()
	TweenService:Create(Pickle.Main.Topbar.ChangeSize, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {ImageTransparency = 0.8}):Play()
	TweenService:Create(Pickle.Main.Topbar.Search, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {ImageTransparency = 0.8}):Play()
	TweenService:Create(Pickle.Main.Topbar.Hide, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {ImageTransparency = 0.8}):Play()
	if dragBar then
		TweenService:Create(dragBarCosmetic, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.7}):Play()
	end

	task.wait(0.5)
	Pickle.Main.LoadingFrame.Visible = false
	for _, v in ipairs(Elements:GetChildren()) do
		if v.ClassName == "Frame" and v.Name ~= "Placeholder" then
			TweenService:Create(v, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
			for _, x in ipairs(v:GetDescendants()) do
				if x.ClassName == "TextLabel" or x.ClassName == "TextBox" then
					TweenService:Create(x, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()
				elseif x.ClassName == "ImageLabel" or x.ClassName == "ImageButton" then
					TweenService:Create(x, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {ImageTransparency = 0}):Play()
				end
			end
		end
	end

	for _, v in ipairs(TabList:GetChildren()) do
		if v.ClassName == "Frame" and v.Name ~= "Placeholder" and v.Name ~= "Template" then
			if tostring(Elements.UIPageLayout.CurrentPage) == v.Title.Text then
				TweenService:Create(v, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
				TweenService:Create(v.Image, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {ImageTransparency = 0}):Play()
				TweenService:Create(v.Title, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()
				TweenService:Create(v.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
			else
				TweenService:Create(v, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.7}):Play()
				TweenService:Create(v.Image, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {ImageTransparency = 0.2}):Play()
				TweenService:Create(v.Title, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 0.2}):Play()
				TweenService:Create(v.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0.5}):Play()
			end
		end
	end

	if Topbar:FindFirstChild('Settings') then
		TweenService:Create(Pickle.Main.Topbar.Settings, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {ImageTransparency = 0.8}):Play()
	end

	if not requestsDisabled and not globalLoaded then
		sendReport("execution", "PickleLibrary")
	end
	globalLoaded = true

	return Window
end

return PickleLibrary 
