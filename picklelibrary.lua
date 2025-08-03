--[[
	PickleLibrary Interface Suite
	by Pickle (Adapted for PickleLibrary)

	pickle  | Solo Developer 
]]

if debugX then
	warn('Initialising PickleLibrary')
end

local function getService(name)
	local service = game:GetService(name)
	return if cloneref then cloneref(service) else service
end

local function loadWithTimeout(url: string, timeout: number?): ...any
	assert(type(url) == "string", "Expected string, got " .. type(url))
	timeout = timeout or 5
	local requestCompleted = false
	local success, result = false, nil

	local requestThread = task.spawn(function()
		local fetchSuccess, fetchResult = pcall(game.HttpGet, game, url)
		if not fetchSuccess or #fetchResult == 0 then
			if #fetchResult == 0 then
				fetchResult = "Empty response"
			end
			success, result = false, fetchResult
			requestCompleted = true
			return
		end
		local content = fetchResult
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

	while not requestCompleted do
		task.wait()
	end
	if coroutine.status(timeoutThread) ~= "dead" then
		task.cancel(timeoutThread)
	end
	if not success then
		warn(`Failed to process {url}: {result}`)
	end
	return if success then result else nil
end

local requestsDisabled = true
local InterfaceBuild = '3K3W'
local Release = "Build 1.68"
local PickleFolder = "PickleLibrary"
local ConfigurationFolder = PickleFolder.."/Configurations"
local ConfigurationExtension = ".pld"
local settingsTable = {
	General = {
		pickleOpen = {Type = 'bind', Value = 'K', Name = 'PickleLibrary Keybind'},
	},
	System = {
		usageAnalytics = {Type = 'toggle', Value = true, Name = 'Anonymised Analytics'},
	}
}

local overriddenSettings: { [string]: any } = {}
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

if requestsDisabled then
	overrideSetting("System", "usageAnalytics", false)
end

local HttpService = getService('HttpService')
local RunService = getService('RunService')
local useStudio = RunService:IsStudio() or false

local settingsCreated = false
local settingsInitialized = false
local cachedSettings
local prompt = nil
local requestFunc = (syn and syn.request) or (fluxus and fluxus.request) or (http and http.request) or http_request or request

if not prompt then
	prompt = {
		create = function() end
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
								if setting.Element then
									setting.Element:Set(getSetting(categoryName, settingName))
								end
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
local sendReport = function(ev_n, sc_n) 
	if debugX then
		warn("Analytics disabled or failed to load")
	end
end

local UserInputService = getService("UserInputService")
local TweenService = getService("TweenService")
local Players = getService("Players")
local CoreGui = getService("CoreGui")

local function createPickleGUI()
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "Pickle"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.IgnoreGuiInset = true
	
	local Main = Instance.new("Frame")
	Main.Name = "Main"
	-- Match RayfieldLibrary size: 430x225
	Main.Size = UDim2.new(0, 430, 0, 225)
	Main.Position = UDim2.new(0.5, -215, 0.5, -112.5)
	Main.BackgroundColor3 = Color3.fromRGB(25, 40, 60) -- Changed to a darker blue theme
	Main.BorderSizePixel = 0
	Main.Parent = ScreenGui
	
	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 5)
	Corner.Parent = Main
	
	local Shadow = Instance.new("Frame")
	Shadow.Name = "Shadow"
	Shadow.Size = UDim2.new(1, 10, 1, 10)
	Shadow.Position = UDim2.new(0, -5, 0, -5)
	Shadow.BackgroundTransparency = 1
	Shadow.Parent = Main
	
	local ShadowImage = Instance.new("ImageLabel")
	ShadowImage.Name = "Image"
	ShadowImage.Size = UDim2.new(1, 0, 1, 0)
	ShadowImage.BackgroundTransparency = 1
	ShadowImage.Image = "rbxassetid://1316045217"
	ShadowImage.ImageColor3 = Color3.fromRGB(0, 0, 0)
	ShadowImage.ImageTransparency = 0.8
	ShadowImage.ScaleType = Enum.ScaleType.Slice
	ShadowImage.SliceCenter = Rect.new(10, 10, 118, 118)
	ShadowImage.Parent = Shadow
	
	local Topbar = Instance.new("Frame")
	Topbar.Name = "Topbar"
	Topbar.Size = UDim2.new(1, 0, 0, 30)
	Topbar.BackgroundColor3 = Color3.fromRGB(35, 55, 80) -- Darker topbar color
	Topbar.BorderSizePixel = 0
	Topbar.Parent = Main
	
	local TopbarCorner = Instance.new("UICorner")
	TopbarCorner.CornerRadius = UDim.new(0, 5)
	TopbarCorner.Parent = Topbar
	
	local CornerRepair = Instance.new("Frame")
	CornerRepair.Name = "CornerRepair"
	CornerRepair.Size = UDim2.new(1, 0, 0, 5)
	CornerRepair.Position = UDim2.new(0, 0, 1, -5)
	CornerRepair.BackgroundColor3 = Color3.fromRGB(35, 55, 80)
	CornerRepair.BorderSizePixel = 0
	CornerRepair.Parent = Topbar
	
	local Title = Instance.new("TextLabel")
	Title.Name = "Title"
	Title.Size = UDim2.new(1, -100, 1, 0)
	Title.Position = UDim2.new(0, 10, 0, 0)
	Title.BackgroundTransparency = 1
	Title.Text = "NewFieldLibrary" -- Changed name
	Title.TextColor3 = Color3.fromRGB(200, 220, 255) -- Lighter text for contrast
	Title.TextSize = 16
	Title.Font = Enum.Font.GothamBold
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.Parent = Topbar
	
	local Icon = Instance.new("ImageLabel")
	Icon.Name = "Icon"
	Icon.Size = UDim2.new(0, 24, 0, 24)
	Icon.Position = UDim2.new(0, 5, 0, 3)
	Icon.BackgroundTransparency = 1
	Icon.Image = ""
	Icon.Parent = Topbar
	
	local Minimize = Instance.new("ImageButton")
	Minimize.Name = "Minimize"
	Minimize.Size = UDim2.new(0, 20, 0, 20)
	Minimize.Position = UDim2.new(1, -40, 0, 5)
	Minimize.BackgroundTransparency = 1
	Minimize.Image = "rbxassetid://6031094678" -- Minimize icon
	Minimize.ImageColor3 = Color3.fromRGB(200, 220, 255)
	Minimize.Parent = Topbar
	
	local Hide = Instance.new("ImageButton")
	Hide.Name = "Hide"
	Hide.Size = UDim2.new(0, 20, 0, 20)
	Hide.Position = UDim2.new(1, -20, 0, 5)
	Hide.BackgroundTransparency = 1
	Hide.Image = "rbxassetid://6031094678" -- Hide icon (same as minimize for now)
	Hide.ImageColor3 = Color3.fromRGB(200, 220, 255)
	Hide.Parent = Topbar
	
	local TabList = Instance.new("Frame")
	TabList.Name = "TabList"
	TabList.Size = UDim2.new(0, 120, 1, -30)
	TabList.Position = UDim2.new(0, 0, 0, 30)
	TabList.BackgroundTransparency = 1
	TabList.Parent = Main
	
	local TabListLayout = Instance.new("UIListLayout")
	TabListLayout.Padding = UDim.new(0, 2)
	TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	TabListLayout.Parent = TabList
	
	local TabListPadding = Instance.new("UIPadding")
	TabListPadding.PaddingTop = UDim.new(0, 5)
	TabListPadding.PaddingLeft = UDim.new(0, 5)
	TabListPadding.Parent = TabList
	
	local TabTemplate = Instance.new("TextButton")
	TabTemplate.Name = "Template"
	TabTemplate.Size = UDim2.new(1, -10, 0, 25)
	TabTemplate.BackgroundColor3 = Color3.fromRGB(30, 50, 70)
	TabTemplate.BackgroundTransparency = 0.8
	TabTemplate.BorderSizePixel = 0
	TabTemplate.Text = "Tab"
	TabTemplate.TextColor3 = Color3.fromRGB(200, 220, 255)
	TabTemplate.TextSize = 14
	TabTemplate.Font = Enum.Font.Gotham
	TabTemplate.TextXAlignment = Enum.TextXAlignment.Center
	TabTemplate.Visible = false
	TabTemplate.Parent = TabList
	
	local TabTemplateCorner = Instance.new("UICorner")
	TabTemplateCorner.CornerRadius = UDim.new(0, 3)
	TabTemplateCorner.Parent = TabTemplate
	
	local Elements = Instance.new("Frame")
	Elements.Name = "Elements"
	Elements.Size = UDim2.new(1, -120, 1, -30)
	Elements.Position = UDim2.new(0, 120, 0, 30)
	Elements.BackgroundTransparency = 1
	Elements.Parent = Main
	
	local ElementsLayout = Instance.new("UIPageLayout")
	ElementsLayout.Name = "UIPageLayout"
	ElementsLayout.SortOrder = Enum.SortOrder.LayoutOrder
	ElementsLayout.TweenTime = 0.3
	ElementsLayout.EasingStyle = Enum.EasingStyle.Quad
	ElementsLayout.Parent = Elements
	
	local SearchFrame = Instance.new("Frame")
	SearchFrame.Name = "Search"
	SearchFrame.Size = UDim2.new(1, -55, 0, 25)
	SearchFrame.Position = UDim2.new(0.5, 0, 0, 40)
	SearchFrame.BackgroundColor3 = Color3.fromRGB(35, 55, 80)
	SearchFrame.BackgroundTransparency = 0.5
	SearchFrame.BorderSizePixel = 0
	SearchFrame.Visible = false
	SearchFrame.Parent = Main
	
	local SearchCorner = Instance.new("UICorner")
	SearchCorner.CornerRadius = UDim.new(0, 3)
	SearchCorner.Parent = SearchFrame
	
	local SearchStroke = Instance.new("UIStroke")
	SearchStroke.Name = "UIStroke"
	SearchStroke.Color = Color3.fromRGB(40, 60, 90)
	SearchStroke.Transparency = 0.5
	SearchStroke.Parent = SearchFrame
	
	local SearchShadow = Instance.new("ImageLabel")
	SearchShadow.Name = "Shadow"
	SearchShadow.Size = UDim2.new(1, 10, 1, 10)
	SearchShadow.Position = UDim2.new(0, -5, 0, -5)
	SearchShadow.BackgroundTransparency = 1
	SearchShadow.Image = "rbxassetid://1316045217"
	SearchShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
	SearchShadow.ImageTransparency = 0.9
	SearchShadow.ScaleType = Enum.ScaleType.Slice
	SearchShadow.SliceCenter = Rect.new(10, 10, 118, 118)
	SearchShadow.Parent = SearchFrame
	
	local SearchInput = Instance.new("TextBox")
	SearchInput.Name = "Input"
	SearchInput.Size = UDim2.new(1, -30, 1, 0)
	SearchInput.Position = UDim2.new(0, 5, 0, 0)
	SearchInput.BackgroundTransparency = 1
	SearchInput.Text = ""
	SearchInput.PlaceholderText = "Search..."
	SearchInput.PlaceholderColor3 = Color3.fromRGB(150, 170, 200)
	SearchInput.TextColor3 = Color3.fromRGB(200, 220, 255)
	SearchInput.TextSize = 14
	SearchInput.Font = Enum.Font.Gotham
	SearchInput.TextXAlignment = Enum.TextXAlignment.Left
	SearchInput.Parent = SearchFrame
	
	local SearchIcon = Instance.new("ImageLabel")
	SearchIcon.Name = "Search"
	SearchIcon.Size = UDim2.new(0, 20, 0, 20)
	SearchIcon.Position = UDim2.new(1, -25, 0.5, -10)
	SearchIcon.BackgroundTransparency = 1
	SearchIcon.Image = "rbxassetid://6031154871"
	SearchIcon.ImageColor3 = Color3.fromRGB(200, 220, 255)
	SearchIcon.Parent = SearchFrame
	
	local LoadingFrame = Instance.new("Frame")
	LoadingFrame.Name = "LoadingFrame"
	LoadingFrame.Size = UDim2.new(0, 200, 0, 100)
	LoadingFrame.Position = UDim2.new(0.5, -100, 0.5, -50)
	LoadingFrame.BackgroundColor3 = Color3.fromRGB(25, 40, 60)
	LoadingFrame.BackgroundTransparency = 1
	LoadingFrame.BorderSizePixel = 0
	LoadingFrame.Visible = false
	LoadingFrame.Parent = ScreenGui
	
	local LoadingCorner = Instance.new("UICorner")
	LoadingCorner.CornerRadius = UDim.new(0, 5)
	LoadingCorner.Parent = LoadingFrame
	
	local LoadingStroke = Instance.new("UIStroke")
	LoadingStroke.Name = "UIStroke"
	LoadingStroke.Color = Color3.fromRGB(40, 60, 90)
	LoadingStroke.Transparency = 1
	LoadingStroke.Parent = LoadingFrame
	
	local LoadingTitle = Instance.new("TextLabel")
	LoadingTitle.Name = "Title"
	LoadingTitle.Size = UDim2.new(1, 0, 0, 30)
	LoadingTitle.Position = UDim2.new(0, 0, 0, 20)
	LoadingTitle.BackgroundTransparency = 1
	LoadingTitle.Text = "Loading..."
	LoadingTitle.TextColor3 = Color3.fromRGB(200, 220, 255)
	LoadingTitle.TextSize = 18
	LoadingTitle.Font = Enum.Font.GothamBold
	LoadingTitle.TextTransparency = 1
	LoadingTitle.Parent = LoadingFrame
	
	local LoadingSubtitle = Instance.new("TextLabel")
	LoadingSubtitle.Name = "Subtitle"
	LoadingSubtitle.Size = UDim2.new(1, 0, 0, 20)
	LoadingSubtitle.Position = UDim2.new(0, 0, 0, 50)
	LoadingSubtitle.BackgroundTransparency = 1
	LoadingSubtitle.Text = "Please wait..."
	LoadingSubtitle.TextColor3 = Color3.fromRGB(150, 170, 200)
	LoadingSubtitle.TextSize = 14
	LoadingSubtitle.Font = Enum.Font.Gotham
	LoadingSubtitle.TextTransparency = 1
	LoadingSubtitle.Parent = LoadingFrame
	
	local LoadingVersion = Instance.new("TextLabel")
	LoadingVersion.Name = "Version"
	LoadingVersion.Size = UDim2.new(1, 0, 0, 20)
	LoadingVersion.Position = UDim2.new(0, 0, 0, 70)
	LoadingVersion.BackgroundTransparency = 1
	LoadingVersion.Text = Release
	LoadingVersion.TextColor3 = Color3.fromRGB(150, 170, 200)
	LoadingVersion.TextSize = 12
	LoadingVersion.Font = Enum.Font.Gotham
	LoadingVersion.TextTransparency = 1
	LoadingVersion.Parent = LoadingFrame
	
	local Notifications = Instance.new("Frame")
	Notifications.Name = "Notifications"
	Notifications.Size = UDim2.new(0, 250, 1, 0)
	Notifications.Position = UDim2.new(1, -260, 0, 10)
	Notifications.BackgroundTransparency = 1
	Notifications.Parent = ScreenGui
	
	local NotificationsLayout = Instance.new("UIListLayout")
	NotificationsLayout.Padding = UDim.new(0, 5)
	NotificationsLayout.SortOrder = Enum.SortOrder.LayoutOrder
	NotificationsLayout.VerticalAlignment = Enum.VerticalAlignment.Top
	NotificationsLayout.Parent = Notifications
	
	local NotificationTemplate = Instance.new("Frame")
	NotificationTemplate.Name = "Template"
	NotificationTemplate.Size = UDim2.new(1, 0, 0, 50)
	NotificationTemplate.BackgroundColor3 = Color3.fromRGB(25, 40, 60)
	NotificationTemplate.BackgroundTransparency = 1
	NotificationTemplate.BorderSizePixel = 0
	NotificationTemplate.Visible = false
	NotificationTemplate.Parent = Notifications
	
	local NotificationCorner = Instance.new("UICorner")
	NotificationCorner.CornerRadius = UDim.new(0, 5)
	NotificationCorner.Parent = NotificationTemplate
	
	local NotificationStroke = Instance.new("UIStroke")
	NotificationStroke.Name = "UIStroke"
	NotificationStroke.Color = Color3.fromRGB(40, 60, 90)
	NotificationStroke.Transparency = 1
	NotificationStroke.Parent = NotificationTemplate
	
	local NotificationShadow = Instance.new("ImageLabel")
	NotificationShadow.Name = "Shadow"
	NotificationShadow.Size = UDim2.new(1, 10, 1, 10)
	NotificationShadow.Position = UDim2.new(0, -5, 0, -5)
	NotificationShadow.BackgroundTransparency = 1
	NotificationShadow.Image = "rbxassetid://1316045217"
	NotificationShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
	NotificationShadow.ImageTransparency = 1
	NotificationShadow.ScaleType = Enum.ScaleType.Slice
	NotificationShadow.SliceCenter = Rect.new(10, 10, 118, 118)
	NotificationShadow.Parent = NotificationTemplate
	
	local NotificationIcon = Instance.new("ImageLabel")
	NotificationIcon.Name = "Icon"
	NotificationIcon.Size = UDim2.new(0, 24, 0, 24)
	NotificationIcon.Position = UDim2.new(0, 10, 0.5, -12)
	NotificationIcon.BackgroundTransparency = 1
	NotificationIcon.ImageTransparency = 1
	NotificationIcon.Parent = NotificationTemplate
	
	local NotificationTitle = Instance.new("TextLabel")
	NotificationTitle.Name = "Title"
	NotificationTitle.Size = UDim2.new(1, -60, 0, 20)
	NotificationTitle.Position = UDim2.new(0, 40, 0, 5)
	NotificationTitle.BackgroundTransparency = 1
	NotificationTitle.Text = "Notification"
	NotificationTitle.TextColor3 = Color3.fromRGB(200, 220, 255)
	NotificationTitle.TextSize = 14
	NotificationTitle.Font = Enum.Font.GothamBold
	NotificationTitle.TextXAlignment = Enum.TextXAlignment.Left
	NotificationTitle.TextTransparency = 1
	NotificationTitle.Parent = NotificationTemplate
	
	local NotificationDescription = Instance.new("TextLabel")
	NotificationDescription.Name = "Description"
	NotificationDescription.Size = UDim2.new(1, -60, 0, 20)
	NotificationDescription.Position = UDim2.new(0, 40, 0, 25)
	NotificationDescription.BackgroundTransparency = 1
	NotificationDescription.Text = "Description"
	NotificationDescription.TextColor3 = Color3.fromRGB(150, 170, 200)
	NotificationDescription.TextSize = 12
	NotificationDescription.Font = Enum.Font.Gotham
	NotificationDescription.TextXAlignment = Enum.TextXAlignment.Left
	NotificationDescription.TextTransparency = 1
	NotificationDescription.Parent = NotificationTemplate
	
	return ScreenGui
end

local Pickle = createPickleGUI()
local buildAttempts = 0
local correctBuild = true
local warned = false
local globalLoaded = false
local pickleDestroyed = false

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
else
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
local useMobileSizing = false
if Pickle.AbsoluteSize.X < minSize.X and Pickle.AbsoluteSize.Y < minSize.Y then
	useMobileSizing = true
end
local useMobilePrompt = false
if UserInputService.TouchEnabled then
	useMobilePrompt = true
end

local Main = Pickle.Main
local MPrompt = Pickle:FindFirstChild('Prompt')
local Topbar = Main.Topbar
local Elements = Main.Elements
local LoadingFrame = Pickle.LoadingFrame
local TabList = Main.TabList
local dragBar = Pickle:FindFirstChild('Drag')
local dragInteract = dragBar and dragBar.Interact or Topbar
local dragBarCosmetic = dragBar and dragBar.Drag or nil
local dragOffset = 255
local dragOffsetMobile = 150
Pickle.DisplayOrder = 100
LoadingFrame.Version.Text = Release

local function getIcon(name: string)
	return {
		id = 0,
		imageRectSize = Vector2.new(24, 24),
		imageRectOffset = Vector2.new(0, 0)
	}
end

local CFileName = nil
local CEnabled = false
local Minimised = false
local Hidden = false
local Debounce = false
local searchOpen = false
local Notifications = Pickle.Notifications
local SelectedTheme = {
	TextColor = Color3.fromRGB(200, 220, 255),
	Background = Color3.fromRGB(25, 40, 60),
	Topbar = Color3.fromRGB(35, 55, 80),
	Shadow = Color3.fromRGB(20, 30, 40),
	NotificationBackground = Color3.fromRGB(25, 40, 60),
	NotificationActionsBackground = Color3.fromRGB(35, 55, 80),
	TabBackground = Color3.fromRGB(30, 50, 70),
	TabStroke = Color3.fromRGB(40, 60, 90),
	TabBackgroundSelected = Color3.fromRGB(45, 70, 100),
	TabTextColor = Color3.fromRGB(150, 170, 200),
	SelectedTabTextColor = Color3.fromRGB(200, 220, 255),
	ElementBackground = Color3.fromRGB(30, 50, 70),
	ElementBackgroundHover = Color3.fromRGB(35, 55, 80),
	SecondaryElementBackground = Color3.fromRGB(25, 45, 65),
	ElementStroke = Color3.fromRGB(40, 60, 90),
	SecondaryElementStroke = Color3.fromRGB(35, 55, 80),
	SliderBackground = Color3.fromRGB(40, 60, 90),
	SliderProgress = Color3.fromRGB(45, 70, 100),
	SliderStroke = Color3.fromRGB(50, 75, 110),
	ToggleBackground = Color3.fromRGB(30, 50, 70),
	ToggleEnabled = Color3.fromRGB(45, 70, 100),
	ToggleDisabled = Color3.fromRGB(35, 55, 80),
	ToggleEnabledStroke = Color3.fromRGB(50, 75, 110),
	ToggleDisabledStroke = Color3.fromRGB(40, 60, 90),
	ToggleEnabledOuterStroke = Color3.fromRGB(40, 60, 90),
	ToggleDisabledOuterStroke = Color3.fromRGB(30, 50, 70),
	DropdownSelected = Color3.fromRGB(35, 55, 80),
	DropdownUnselected = Color3.fromRGB(30, 50, 70),
	InputBackground = Color3.fromRGB(30, 50, 70),
	InputStroke = Color3.fromRGB(40, 60, 90),
	PlaceholderColor = Color3.fromRGB(150, 170, 200)
}

local PickleLibrary = {
	Flags = {},
	Theme = {
		PickleTheme = SelectedTheme
	}
}

local function ChangeTheme(Theme)
	if typeof(Theme) == 'string' then
		SelectedTheme = PickleLibrary.Theme[Theme] or PickleLibrary.Theme.PickleTheme
	elseif typeof(Theme) == 'table' then
		SelectedTheme = Theme
	end
	
	Main.BackgroundColor3 = SelectedTheme.Background
	Topbar.BackgroundColor3 = SelectedTheme.Topbar
	Topbar.CornerRepair.BackgroundColor3 = SelectedTheme.Topbar
	Main.Shadow.Image.ImageColor3 = SelectedTheme.Shadow
	Topbar.Minimize.ImageColor3 = SelectedTheme.TextColor
	Topbar.Hide.ImageColor3 = SelectedTheme.TextColor
	
	for _, text in ipairs(Pickle:GetDescendants()) do
		if text.Parent.Parent ~= Notifications then
			if text:IsA('TextLabel') or text:IsA('TextBox') then 
				text.TextColor3 = SelectedTheme.TextColor 
			end
		end
	end
end

local function getAssetUri(id: any): string
	local assetUri = "rbxassetid://0"
	if type(id) == "number" then
		assetUri = "rbxassetid://" .. id
	elseif type(id) == "string" then
		assetUri = "rbxassetid://0"
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
	
	dragObject.InputBegan:Connect(function(input, processed)
		if processed then return end
		local inputType = input.UserInputType.Name
		if inputType == "MouseButton1" or inputType == "Touch" then
			dragging = true
			relative = object.AbsolutePosition + object.AbsoluteSize * object.AnchorPoint - UserInputService:GetMouseLocation()
		end
	end)
	
	local inputEnded = UserInputService.InputEnded:Connect(function(input)
		if not dragging then return end
		local inputType = input.UserInputType.Name
		if inputType == "MouseButton1" or inputType == "Touch" then
			dragging = false
		end
	end)
	
	local renderStepped = RunService.RenderStepped:Connect(function()
		if dragging and not Hidden then
			local position = UserInputService:GetMouseLocation() + relative + offset
			object.Position = UDim2.fromOffset(position.X, position.Y)
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
	local changed = false
	if not success then 
		warn('PickleLibrary had an issue decoding the configuration file, please try delete the file and reopen PickleLibrary.') 
		return false
	end
	
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
	
	if debugX then
		warn(HttpService:JSONEncode(Data))
	end
	if writefile then
		writefile(ConfigurationFolder .. "/" .. CFileName .. ConfigurationExtension, tostring(HttpService:JSONEncode(Data)))
	end
end

function PickleLibrary:Notify(data)
	task.spawn(function()
		local newNotification = Notifications.Template:Clone()
		newNotification.Name = data.Title or 'No Title Provided'
		newNotification.Parent = Notifications
		newNotification.LayoutOrder = #Notifications:GetChildren()
		newNotification.Visible = false
		newNotification.Title.Text = data.Title or "Unknown Title"
		newNotification.Description.Text = data.Content or "Unknown Content"
		
		if data.Image then
			newNotification.Icon.Image = getAssetUri(data.Image)
		else
			newNotification.Icon.Image = "rbxassetid://0"
		end
		
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
		newNotification.Icon.ImageTransparency = 1
		
		task.wait()
		newNotification.Visible = true
		
		local bounds = {newNotification.Title.TextBounds.Y, newNotification.Description.TextBounds.Y}
		newNotification.Size = UDim2.new(1, 0, 0, math.max(bounds[1] + bounds[2] + 29, 50))
		
		TweenService:Create(newNotification, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundTransparency = 0.6}):Play()
		TweenService:Create(newNotification.Title, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {TextTransparency = 0}):Play()
		task.wait(0.05)
		TweenService:Create(newNotification.Icon, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {ImageTransparency = 0}):Play()
		task.wait(0.05)
		TweenService:Create(newNotification.Description, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {TextTransparency = 0.4}):Play()
		TweenService:Create(newNotification.UIStroke, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Transparency = 0.9}):Play()
		TweenService:Create(newNotification.Shadow, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {ImageTransparency = 0.85}):Play()
		
		local waitDuration = math.min(math.max((#newNotification.Description.Text * 0.1) + 2.5, 3), 10)
		task.wait(data.Duration or waitDuration)
		
		TweenService:Create(newNotification, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundTransparency = 1}):Play()
		TweenService:Create(newNotification.UIStroke, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Transparency = 1}):Play()
		TweenService:Create(newNotification.Shadow, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {ImageTransparency = 1}):Play()
		TweenService:Create(newNotification.Title, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {TextTransparency = 1}):Play()
		TweenService:Create(newNotification.Description, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {TextTransparency = 1}):Play()
		TweenService:Create(newNotification.Icon, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {ImageTransparency = 1}):Play()
		
		task.wait(0.5)
		newNotification:Destroy()
	end)
end

function PickleLibrary:LoadConfiguration()
	if CEnabled and CFileName and isfile and isfile(ConfigurationFolder .. "/" .. CFileName .. ConfigurationExtension) then
		local configData = readfile(ConfigurationFolder .. "/" .. CFileName .. ConfigurationExtension)
		return LoadConfiguration(configData)
	end
	return false
end

function PickleLibrary:CreateWindow(Settings)
	local Window = {}
	CFileName = Settings.ConfigurationSaving and Settings.ConfigurationSaving.FileName or nil
	CEnabled = Settings.ConfigurationSaving and Settings.ConfigurationSaving.Enabled or false
	
	if Settings.ConfigurationSaving and Settings.ConfigurationSaving.FolderName then
		ConfigurationFolder = Settings.ConfigurationSaving.FolderName
	end
	
	Topbar.Title.Text = Settings.Name or "NewFieldLibrary Interface"
	LoadingFrame.Title.Text = Settings.LoadingTitle or "NewFieldLibrary Interface Suite"
	LoadingFrame.Subtitle.Text = Settings.LoadingSubtitle or "by Sirius"
	
	if Settings.Icon then
		Topbar.Icon.Image = getAssetUri(Settings.Icon)
	end
	
	if Settings.Theme then
		ChangeTheme(Settings.Theme)
	end
	
	if Settings.ConfigurationSaving and Settings.ConfigurationSaving.Enabled then
		if makefolder and not isfolder(ConfigurationFolder) then
			makefolder(ConfigurationFolder)
		end
	end
	
	if Settings.Discord and Settings.Discord.Enabled and Settings.Discord.Invite then
		if not Settings.Discord.RememberJoins or not (isfile and isfile("PickleLibrary/DiscordJoin")) then
			if writefile then
				writefile("PickleLibrary/DiscordJoin", "Joined")
			end
			PickleLibrary:Notify({
				Title = "Join our Discord!",
				Content = "Join our Discord server to stay updated and get support: " .. Settings.Discord.Invite,
				Duration = 10
			})
		end
	end
	
	-- Minimize button functionality
	Minimize.MouseButton1Click:Connect(function()
		Minimised = not Minimised
		if Minimised then
			TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 430, 0, 30)}):Play()
			Elements.Visible = false
			TabList.Visible = false
		else
			TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 430, 0, 225)}):Play()
			Elements.Visible = true
			TabList.Visible = true
		end
	end)
	
	-- Hide button functionality
	Hide.MouseButton1Click:Connect(function()
		Hidden = not Hidden
		if Hidden then
			Main.Visible = false
			Hide.Rotation = 180
		else
			Main.Visible = true
			Hide.Rotation = 0
		end
	end)
	
	makeDraggable(Pickle, Topbar, true, {dragOffset, dragOffsetMobile})
	
	Pickle.Enabled = true
	LoadingFrame.Visible = true
	
	TweenService:Create(LoadingFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundTransparency = 0}):Play()
	TweenService:Create(LoadingFrame.UIStroke, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Transparency = 0}):Play()
	TweenService:Create(LoadingFrame.Title, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {TextTransparency = 0}):Play()
	TweenService:Create(LoadingFrame.Subtitle, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {TextTransparency = 0}):Play()
	TweenService:Create(LoadingFrame.Version, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {TextTransparency = 0}):Play()
	
	task.wait(0.5)
	
	TweenService:Create(LoadingFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 0, 0, 0)}):Play()
	TweenService:Create(LoadingFrame.UIStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {Transparency = 1}):Play()
	TweenService:Create(LoadingFrame.Title, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {TextTransparency = 1}):Play()
	TweenService:Create(LoadingFrame.Subtitle, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {TextTransparency = 1}):Play()
	TweenService:Create(LoadingFrame.Version, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {TextTransparency = 1}):Play()
	
	task.wait(0.5)
	LoadingFrame.Visible = false
	globalLoaded = true
	
	Window.Name = Settings.Name or "NewFieldLibrary Interface"
	Window.CurrentTab = nil
	
	function Window:CreateTab(TabSettings)
		local Tab = {}
		local TabButton = TabList.Template:Clone()
		TabButton.Name = TabSettings.Name
		TabButton.Text = TabSettings.Name
		TabButton.BackgroundTransparency = 0.8
		TabButton.TextColor3 = SelectedTheme.TabTextColor
		
		if TabSettings.Image then
			TabButton.Image = getAssetUri(TabSettings.Image)
		end
		
		TabButton.Parent = TabList
		TabButton.Visible = true
		
		local TabPage = Instance.new("ScrollingFrame")
		TabPage.Name = TabSettings.Name
		TabPage.Size = UDim2.new(1, 0, 1, 0)
		TabPage.BackgroundTransparency = 1
		TabPage.BorderSizePixel = 0
		TabPage.ScrollBarThickness = 4
		TabPage.ScrollBarImageColor3 = SelectedTheme.ElementStroke
		TabPage.CanvasSize = UDim2.new(0, 0, 0, 0)
		TabPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
		TabPage.Parent = Elements
		
		local Layout = Instance.new("UIListLayout")
		Layout.Name = "UIListLayout"
		Layout.Padding = UDim.new(0, 5)
		Layout.SortOrder = Enum.SortOrder.LayoutOrder
		Layout.Parent = TabPage
		
		local Padding = Instance.new("UIPadding")
		Padding.Name = "UIPadding"
		Padding.PaddingTop = UDim.new(0, 5)
		Padding.PaddingLeft = UDim.new(0, 5)
		Padding.PaddingRight = UDim.new(0, 10)
		Padding.Parent = TabPage
		
		TabButton.MouseButton1Click:Connect(function()
			if Window.CurrentTab then
				TweenService:Create(Window.CurrentTab.Button, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundTransparency = 0.8, TextTransparency = 0.2}):Play()
				Window.CurrentTab.Page.Visible = false
			end
			
			Window.CurrentTab = Tab
			TweenService:Create(TabButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundTransparency = 0, TextColor3 = SelectedTheme.SelectedTabTextColor}):Play()
			TabPage.Visible = true
			Elements.UIPageLayout:JumpTo(TabPage)
			SaveConfiguration()
		end)
		
		if #TabList:GetChildren() == 2 then
			TabButton.MouseButton1Click:Fire()
		end
		
		Tab.Button = TabButton
		Tab.Page = TabPage
		
		function Tab:CreateSection(SectionSettings)
			local Section = {}
			
			local SectionTitle = Instance.new("TextLabel")
			SectionTitle.Name = "SectionTitle"
			SectionTitle.Size = UDim2.new(1, -10, 0, 25)
			SectionTitle.BackgroundTransparency = 1
			SectionTitle.Text = SectionSettings.Name or "New Section"
			SectionTitle.TextColor3 = SelectedTheme.TextColor
			SectionTitle.TextSize = 16
			SectionTitle.Font = Enum.Font.GothamBold
			SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
			SectionTitle.Parent = TabPage
			
			TweenService:Create(SectionTitle, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {TextTransparency = 0}):Play()
			
			function Section:CreateButton(ButtonSettings)
				local Button = {}
				
				local ButtonFrame = Instance.new("Frame")
				ButtonFrame.Name = "Button"
				ButtonFrame.Size = UDim2.new(1, -10, 0, 30)
				ButtonFrame.BackgroundColor3 = SelectedTheme.ElementBackground
				ButtonFrame.BorderSizePixel = 0
				ButtonFrame.Parent = TabPage
				
				local ButtonCorner = Instance.new("UICorner")
				ButtonCorner.CornerRadius = UDim.new(0, 3)
				ButtonCorner.Parent = ButtonFrame
				
				local ButtonStroke = Instance.new("UIStroke")
				ButtonStroke.Name = "UIStroke"
				ButtonStroke.Thickness = 1
				ButtonStroke.Color = SelectedTheme.ElementStroke
				ButtonStroke.Parent = ButtonFrame
				
				local ButtonInteract = Instance.new("TextButton")
				ButtonInteract.Name = "Interact"
				ButtonInteract.Size = UDim2.new(1, 0, 1, 0)
				ButtonInteract.BackgroundTransparency = 1
				ButtonInteract.Text = ButtonSettings.Name or "New Button"
				ButtonInteract.TextColor3 = SelectedTheme.TextColor
				ButtonInteract.TextSize = 14
				ButtonInteract.Font = Enum.Font.Gotham
				ButtonInteract.Parent = ButtonFrame
				
				ButtonInteract.MouseEnter:Connect(function()
					TweenService:Create(ButtonFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = SelectedTheme.ElementBackgroundHover}):Play()
				end)
				
				ButtonInteract.MouseLeave:Connect(function()
					TweenService:Create(ButtonFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = SelectedTheme.ElementBackground}):Play()
				end)
				
				ButtonInteract.MouseButton1Click:Connect(function()
					if ButtonSettings.Callback then 
						ButtonSettings.Callback() 
					end
				end)
				
				TweenService:Create(ButtonFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Size = UDim2.new(1, -10, 0, 30), BackgroundTransparency = 0}):Play()
				
				Button.Frame = ButtonFrame
				Button.Type = "Button"
				if ButtonSettings.Name then
					PickleLibrary.Flags[ButtonSettings.Name] = Button
				end
				
				return Button
			end
			
			function Section:CreateToggle(ToggleSettings)
				local Toggle = {}
				
				local ToggleFrame = Instance.new("Frame")
				ToggleFrame.Name = "Toggle"
				ToggleFrame.Size = UDim2.new(1, -10, 0, 30)
				ToggleFrame.BackgroundColor3 = SelectedTheme.ElementBackground
				ToggleFrame.BorderSizePixel = 0
				ToggleFrame.Parent = TabPage
				
				local ToggleCorner = Instance.new("UICorner")
				ToggleCorner.CornerRadius = UDim.new(0, 3)
				ToggleCorner.Parent = ToggleFrame
				
				local ToggleStroke = Instance.new("UIStroke")
				ToggleStroke.Name = "UIStroke"
				ToggleStroke.Thickness = 1
				ToggleStroke.Color = SelectedTheme.ElementStroke
				ToggleStroke.Parent = ToggleFrame
				
				local ToggleLabel = Instance.new("TextLabel")
				ToggleLabel.Name = "Label"
				ToggleLabel.Size = UDim2.new(1, -40, 1, 0)
				ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
				ToggleLabel.BackgroundTransparency = 1
				ToggleLabel.Text = ToggleSettings.Name or "New Toggle"
				ToggleLabel.TextColor3 = SelectedTheme.TextColor
				ToggleLabel.TextSize = 14
				ToggleLabel.Font = Enum.Font.Gotham
				ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
				ToggleLabel.Parent = ToggleFrame
				
				local ToggleSwitch = Instance.new("Frame")
				ToggleSwitch.Name = "Switch"
				ToggleSwitch.Size = UDim2.new(0, 20, 0, 20)
				ToggleSwitch.Position = UDim2.new(1, -25, 0.5, -10)
				ToggleSwitch.BackgroundColor3 = SelectedTheme.ToggleBackground
				ToggleSwitch.BorderSizePixel = 0
				ToggleSwitch.Parent = ToggleFrame
				
				local SwitchCorner = Instance.new("UICorner")
				SwitchCorner.CornerRadius = UDim.new(0, 3)
				SwitchCorner.Parent = ToggleSwitch
				
				local ToggleIndicator = Instance.new("Frame")
				ToggleIndicator.Name = "Indicator"
				ToggleIndicator.Size = UDim2.new(0, 14, 0, 14)
				ToggleIndicator.Position = UDim2.new(0, 3, 0, 3)
				ToggleIndicator.BackgroundColor3 = SelectedTheme.ToggleDisabled
				ToggleIndicator.BorderSizePixel = 0
				ToggleIndicator.Parent = ToggleSwitch
				
				local IndicatorCorner = Instance.new("UICorner")
				IndicatorCorner.CornerRadius = UDim.new(0, 2)
				IndicatorCorner.Parent = ToggleIndicator
				
				local ToggleInteract = Instance.new("TextButton")
				ToggleInteract.Name = "Interact"
				ToggleInteract.Size = UDim2.new(1, 0, 1, 0)
				ToggleInteract.BackgroundTransparency = 1
				ToggleInteract.Text = ""
				ToggleInteract.Parent = ToggleFrame
				
				Toggle.CurrentValue = ToggleSettings.CurrentValue or false
				Toggle.Type = "Toggle"
				
				function Toggle:Set(Value)
					Toggle.CurrentValue = Value
					if Value then
						TweenService:Create(ToggleIndicator, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = SelectedTheme.ToggleEnabled, Position = UDim2.new(0, 3, 0, 3)}):Play()
					else
						TweenService:Create(ToggleIndicator, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = SelectedTheme.ToggleDisabled, Position = UDim2.new(0, 3, 0, 3)}):Play()
					end
					SaveConfiguration()
				end
				
				ToggleInteract.MouseButton1Click:Connect(function()
					local newValue = not Toggle.CurrentValue
					Toggle:Set(newValue)
					if ToggleSettings.Callback then 
						ToggleSettings.Callback(newValue) 
					end
				end)
				
				Toggle:Set(Toggle.CurrentValue)
				
				TweenService:Create(ToggleFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Size = UDim2.new(1, -10, 0, 30), BackgroundTransparency = 0}):Play()
				
				Toggle.Frame = ToggleFrame
				if ToggleSettings.Name then
					PickleLibrary.Flags[ToggleSettings.Name] = Toggle
				end
				
				return Toggle
			end
			
			function Section:CreateSlider(SliderSettings)
				local Slider = {}
				
				local SliderFrame = Instance.new("Frame")
				SliderFrame.Name = "Slider"
				SliderFrame.Size = UDim2.new(1, -10, 0, 50)
				SliderFrame.BackgroundColor3 = SelectedTheme.ElementBackground
				SliderFrame.BorderSizePixel = 0
				SliderFrame.Parent = TabPage
				
				local SliderCorner = Instance.new("UICorner")
				SliderCorner.CornerRadius = UDim.new(0, 3)
				SliderCorner.Parent = SliderFrame
				
				local SliderStroke = Instance.new("UIStroke")
				SliderStroke.Name = "UIStroke"
				SliderStroke.Thickness = 1
				SliderStroke.Color = SelectedTheme.ElementStroke
				SliderStroke.Parent = SliderFrame
				
				local SliderLabel = Instance.new("TextLabel")
				SliderLabel.Name = "Label"
				SliderLabel.Size = UDim2.new(1, -60, 0, 20)
				SliderLabel.Position = UDim2.new(0, 10, 0, 5)
				SliderLabel.BackgroundTransparency = 1
				SliderLabel.Text = SliderSettings.Name or "New Slider"
				SliderLabel.TextColor3 = SelectedTheme.TextColor
				SliderLabel.TextSize = 14
				SliderLabel.Font = Enum.Font.Gotham
				SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
				SliderLabel.Parent = SliderFrame
				
				local SliderValue = Instance.new("TextLabel")
				SliderValue.Name = "Value"
				SliderValue.Size = UDim2.new(0, 50, 0, 20)
				SliderValue.Position = UDim2.new(1, -55, 0, 5)
				SliderValue.BackgroundTransparency = 1
				SliderValue.Text = tostring(SliderSettings.CurrentValue or SliderSettings.Default or 0)
				SliderValue.TextColor3 = SelectedTheme.TextColor
				SliderValue.TextSize = 14
				SliderValue.Font = Enum.Font.Gotham
				SliderValue.TextXAlignment = Enum.TextXAlignment.Right
				SliderValue.Parent = SliderFrame
				
				local SliderBar = Instance.new("Frame")
				SliderBar.Name = "Bar"
				SliderBar.Size = UDim2.new(1, -20, 0, 5)
				SliderBar.Position = UDim2.new(0, 10, 0, 30)
				SliderBar.BackgroundColor3 = SelectedTheme.SliderBackground
				SliderBar.BorderSizePixel = 0
				SliderBar.Parent = SliderFrame
				
				local BarCorner = Instance.new("UICorner")
				BarCorner.CornerRadius = UDim.new(0, 2)
				BarCorner.Parent = SliderBar
				
				local SliderProgress = Instance.new("Frame")
				SliderProgress.Name = "Progress"
				SliderProgress.Size = UDim2.new(0, 0, 1, 0)
				SliderProgress.BackgroundColor3 = SelectedTheme.SliderProgress
				SliderProgress.BorderSizePixel = 0
				SliderProgress.Parent = SliderBar
				
				local ProgressCorner = Instance.new("UICorner")
				ProgressCorner.CornerRadius = UDim.new(0, 2)
				ProgressCorner.Parent = SliderProgress
				
				Slider.CurrentValue = SliderSettings.CurrentValue or SliderSettings.Default or 0
				Slider.Min = SliderSettings.Min or 0
				Slider.Max = SliderSettings.Max or 100
				Slider.Type = "Slider"
				
				local dragging = false
				
				function Slider:Set(Value)
					Slider.CurrentValue = math.clamp(Value, Slider.Min, Slider.Max)
					local percentage = (Slider.CurrentValue - Slider.Min) / (Slider.Max - Slider.Min)
					TweenService:Create(SliderProgress, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Size = UDim2.new(percentage, 0, 1, 0)}):Play()
					SliderValue.Text = tostring(Slider.CurrentValue)
					SaveConfiguration()
				end
				
				SliderBar.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						dragging = true
					end
				end)
				
				SliderBar.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						dragging = false
					end
				end)
				
				RunService.RenderStepped:Connect(function()
					if dragging then
						local mousePos = UserInputService:GetMouseLocation()
						local barAbsPos = SliderBar.AbsolutePosition
						local barAbsSize = SliderBar.AbsoluteSize
						local newValue = math.clamp((mousePos.X - barAbsPos.X) / barAbsSize.X, 0, 1) * (Slider.Max - Slider.Min) + Slider.Min
						newValue = math.floor(newValue + 0.5)
						if Slider.CurrentValue ~= newValue then
							Slider:Set(newValue)
							if SliderSettings.Callback then 
								SliderSettings.Callback(newValue) 
							end
						end
					end
				end)
				
				Slider:Set(Slider.CurrentValue)
				
				TweenService:Create(SliderFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Size = UDim2.new(1, -10, 0, 50), BackgroundTransparency = 0}):Play()
				
				Slider.Frame = SliderFrame
				if SliderSettings.Name then
					PickleLibrary.Flags[SliderSettings.Name] = Slider
				end
				
				return Slider
			end
			
			function Section:CreateDropdown(DropdownSettings)
				local Dropdown = {}
				
				local DropdownFrame = Instance.new("Frame")
				DropdownFrame.Name = "Dropdown"
				DropdownFrame.Size = UDim2.new(1, -10, 0, 30)
				DropdownFrame.BackgroundColor3 = SelectedTheme.ElementBackground
				DropdownFrame.BorderSizePixel = 0
				DropdownFrame.Parent = TabPage
				
				local DropdownCorner = Instance.new("UICorner")
				DropdownCorner.CornerRadius = UDim.new(0, 3)
				DropdownCorner.Parent = DropdownFrame
				
				local DropdownStroke = Instance.new("UIStroke")
				DropdownStroke.Name = "UIStroke"
				DropdownStroke.Thickness = 1
				DropdownStroke.Color = SelectedTheme.ElementStroke
				DropdownStroke.Parent = DropdownFrame
				
				local DropdownLabel = Instance.new("TextLabel")
				DropdownLabel.Name = "Label"
				DropdownLabel.Size = UDim2.new(1, -40, 1, 0)
				DropdownLabel.Position = UDim2.new(0, 10, 0, 0)
				DropdownLabel.BackgroundTransparency = 1
				DropdownLabel.Text = (DropdownSettings.Name or "New Dropdown") .. ": " .. (DropdownSettings.CurrentOption or (DropdownSettings.Options and DropdownSettings.Options[1]) or "None")
				DropdownLabel.TextColor3 = SelectedTheme.TextColor
				DropdownLabel.TextSize = 14
				DropdownLabel.Font = Enum.Font.Gotham
				DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
				DropdownLabel.Parent = DropdownFrame
				
				local DropdownArrow = Instance.new("ImageLabel")
				DropdownArrow.Name = "Arrow"
				DropdownArrow.Size = UDim2.new(0, 16, 0, 16)
				DropdownArrow.Position = UDim2.new(1, -26, 0.5, -8)
				DropdownArrow.BackgroundTransparency = 1
				DropdownArrow.Image = "rbxassetid://6031090990"
				DropdownArrow.ImageColor3 = SelectedTheme.TextColor
				DropdownArrow.Parent = DropdownFrame
				
				local DropdownList = Instance.new("Frame")
				DropdownList.Name = "List"
				DropdownList.Size = UDim2.new(1, -10, 0, 0)
				DropdownList.Position = UDim2.new(0, 5, 0, 35)
				DropdownList.BackgroundColor3 = SelectedTheme.DropdownUnselected
				DropdownList.BorderSizePixel = 0
				DropdownList.Visible = false
				DropdownList.Parent = DropdownFrame
				
				local ListCorner = Instance.new("UICorner")
				ListCorner.CornerRadius = UDim.new(0, 3)
				ListCorner.Parent = DropdownList
				
				local DropdownLayout = Instance.new("UIListLayout")
				DropdownLayout.Name = "UIListLayout"
				DropdownLayout.Padding = UDim.new(0, 2)
				DropdownLayout.SortOrder = Enum.SortOrder.LayoutOrder
				DropdownLayout.Parent = DropdownList
				
				local DropdownPadding = Instance.new("UIPadding")
				DropdownPadding.Name = "UIPadding"
				DropdownPadding.PaddingTop = UDim.new(0, 5)
				DropdownPadding.PaddingBottom = UDim.new(0, 5)
				DropdownPadding.PaddingLeft = UDim.new(0, 5)
				DropdownPadding.PaddingRight = UDim.new(0, 5)
				DropdownPadding.Parent = DropdownList
				
				local DropdownInteract = Instance.new("TextButton")
				DropdownInteract.Name = "Interact"
				DropdownInteract.Size = UDim2.new(1, 0, 0, 30)
				DropdownInteract.BackgroundTransparency = 1
				DropdownInteract.Text = ""
				DropdownInteract.Parent = DropdownFrame
				
				local options = DropdownSettings.Options or {}
				Dropdown.CurrentOption = DropdownSettings.CurrentOption or options[1] or ""
				Dropdown.Type = "Dropdown"
				
				function Dropdown:Set(Value)
					Dropdown.CurrentOption = Value
					DropdownLabel.Text = (DropdownSettings.Name or "New Dropdown") .. ": " .. Value
					if DropdownSettings.Callback then 
						DropdownSettings.Callback(Value) 
					end
					SaveConfiguration()
				end
				
				DropdownInteract.MouseButton1Click:Connect(function()
					DropdownList.Visible = not DropdownList.Visible
					if DropdownList.Visible then
						TweenService:Create(DropdownFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Size = UDim2.new(1, -10, 0, 40 + (#options * 20))}):Play()
						TweenService:Create(DropdownArrow, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Rotation = 180}):Play()
						TweenService:Create(DropdownList, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Size = UDim2.new(1, -10, 0, #options * 20), BackgroundColor3 = SelectedTheme.DropdownSelected}):Play()
					else
						TweenService:Create(DropdownFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Size = UDim2.new(1, -10, 0, 30)}):Play()
						TweenService:Create(DropdownArrow, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Rotation = 0}):Play()
						TweenService:Create(DropdownList, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Size = UDim2.new(1, -10, 0, 0), BackgroundColor3 = SelectedTheme.DropdownUnselected}):Play()
					end
				end)
				
				for i, option in ipairs(options) do
					local OptionButton = Instance.new("TextButton")
					OptionButton.Name = "Option" .. i
					OptionButton.Size = UDim2.new(1, 0, 0, 18)
					OptionButton.BackgroundTransparency = 1
					OptionButton.Text = option
					OptionButton.TextColor3 = SelectedTheme.TextColor
					OptionButton.TextSize = 13
					OptionButton.Font = Enum.Font.Gotham
					OptionButton.TextXAlignment = Enum.TextXAlignment.Left
					OptionButton.Parent = DropdownList
					
					OptionButton.MouseButton1Click:Connect(function()
						Dropdown:Set(option)
						DropdownList.Visible = false
						TweenService:Create(DropdownFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Size = UDim2.new(1, -10, 0, 30)}):Play()
						TweenService:Create(DropdownArrow, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Rotation = 0}):Play()
						TweenService:Create(DropdownList, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Size = UDim2.new(1, -10, 0, 0)}):Play()
					end)
				end
				
				TweenService:Create(DropdownFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Size = UDim2.new(1, -10, 0, 30), BackgroundTransparency = 0}):Play()
				
				Dropdown.Frame = DropdownFrame
				if DropdownSettings.Name then
					PickleLibrary.Flags[DropdownSettings.Name] = Dropdown
				end
				
				return Dropdown
			end
			
			function Section:CreateInput(InputSettings)
				local Input = {}
				
				local InputFrame = Instance.new("Frame")
				InputFrame.Name = "Input"
				InputFrame.Size = UDim2.new(1, -10, 0, 30)
				InputFrame.BackgroundColor3 = SelectedTheme.ElementBackground
				InputFrame.BorderSizePixel = 0
				InputFrame.Parent = TabPage
				
				local InputCorner = Instance.new("UICorner")
				InputCorner.CornerRadius = UDim.new(0, 3)
				InputCorner.Parent = InputFrame
				
				local InputStroke = Instance.new("UIStroke")
				InputStroke.Name = "UIStroke"
				InputStroke.Thickness = 1
				InputStroke.Color = SelectedTheme.ElementStroke
				InputStroke.Parent = InputFrame
				
				local InputLabel = Instance.new("TextLabel")
				InputLabel.Name = "Label"
				InputLabel.Size = UDim2.new(0.5, -5, 1, 0)
				InputLabel.Position = UDim2.new(0, 10, 0, 0)
				InputLabel.BackgroundTransparency = 1
				InputLabel.Text = InputSettings.Name or "New Input"
				InputLabel.TextColor3 = SelectedTheme.TextColor
				InputLabel.TextSize = 14
				InputLabel.Font = Enum.Font.Gotham
				InputLabel.TextXAlignment = Enum.TextXAlignment.Left
				InputLabel.Parent = InputFrame
				
				local InputBox = Instance.new("TextBox")
				InputBox.Name = "Box"
				InputBox.Size = UDim2.new(0.5, -10, 0, 20)
				InputBox.Position = UDim2.new(0.5, 5, 0.5, -10)
				InputBox.BackgroundColor3 = SelectedTheme.InputBackground
				InputBox.BorderSizePixel = 0
				InputBox.Text = InputSettings.Default or ""
				InputBox.TextColor3 = SelectedTheme.TextColor
				InputBox.PlaceholderText = InputSettings.Placeholder or "Enter text"
				InputBox.PlaceholderColor3 = SelectedTheme.PlaceholderColor
				InputBox.TextSize = 13
				InputBox.Font = Enum.Font.Gotham
				InputBox.ClearTextOnFocus = false
				InputBox.Parent = InputFrame
				
				local BoxCorner = Instance.new("UICorner")
				BoxCorner.CornerRadius = UDim.new(0, 3)
				BoxCorner.Parent = InputBox
				
				local BoxStroke = Instance.new("UIStroke")
				BoxStroke.Name = "UIStroke"
				BoxStroke.Thickness = 1
				BoxStroke.Color = SelectedTheme.InputStroke
				BoxStroke.Parent = InputBox
				
				Input.CurrentValue = InputSettings.Default or ""
				Input.Type = "Input"
				
				function Input:Set(Value)
					Input.CurrentValue = Value
					InputBox.Text = Value
					if InputSettings.Callback then 
						InputSettings.Callback(Value, false) 
					end
					SaveConfiguration()
				end
				
				InputBox.FocusLost:Connect(function(enterPressed)
					Input.CurrentValue = InputBox.Text
					if InputSettings.Callback then 
						InputSettings.Callback(InputBox.Text, enterPressed) 
					end
					SaveConfiguration()
				end)
				
				TweenService:Create(InputFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Size = UDim2.new(1, -10, 0, 30), BackgroundTransparency = 0}):Play()
				
				Input.Frame = InputFrame
				if InputSettings.Name then
					PickleLibrary.Flags[InputSettings.Name] = Input
				end
				
				return Input
			end
			
			function Section:CreateColorPicker(ColorPickerSettings)
				local ColorPicker = {}
				
				local ColorPickerFrame = Instance.new("Frame")
				ColorPickerFrame.Name = "ColorPicker"
				ColorPickerFrame.Size = UDim2.new(1, -10, 0, 30)
				ColorPickerFrame.BackgroundColor3 = SelectedTheme.ElementBackground
				ColorPickerFrame.BorderSizePixel = 0
				ColorPickerFrame.Parent = TabPage
				
				local ColorPickerCorner = Instance.new("UICorner")
				ColorPickerCorner.CornerRadius = UDim.new(0, 3)
				ColorPickerCorner.Parent = ColorPickerFrame
				
				local ColorPickerStroke = Instance.new("UIStroke")
				ColorPickerStroke.Name = "UIStroke"
				ColorPickerStroke.Thickness = 1
				ColorPickerStroke.Color = SelectedTheme.ElementStroke
				ColorPickerStroke.Parent = ColorPickerFrame
				
				local ColorPickerLabel = Instance.new("TextLabel")
				ColorPickerLabel.Name = "Label"
				ColorPickerLabel.Size = UDim2.new(1, -40, 1, 0)
				ColorPickerLabel.Position = UDim2.new(0, 10, 0, 0)
				ColorPickerLabel.BackgroundTransparency = 1
				ColorPickerLabel.Text = ColorPickerSettings.Name or "New ColorPicker"
				ColorPickerLabel.TextColor3 = SelectedTheme.TextColor
				ColorPickerLabel.TextSize = 14
				ColorPickerLabel.Font = Enum.Font.Gotham
				ColorPickerLabel.TextXAlignment = Enum.TextXAlignment.Left
				ColorPickerLabel.Parent = ColorPickerFrame
				
				local ColorPreview = Instance.new("Frame")
				ColorPreview.Name = "Preview"
				ColorPreview.Size = UDim2.new(0, 20, 0, 20)
				ColorPreview.Position = UDim2.new(1, -25, 0.5, -10)
				ColorPreview.BackgroundColor3 = ColorPickerSettings.Default or Color3.fromRGB(255, 255, 255)
				ColorPreview.BorderSizePixel = 0
				ColorPreview.Parent = ColorPickerFrame
				
				local PreviewCorner = Instance.new("UICorner")
				PreviewCorner.CornerRadius = UDim.new(0, 3)
				PreviewCorner.Parent = ColorPreview
				
				local ColorPickerInteract = Instance.new("TextButton")
				ColorPickerInteract.Name = "Interact"
				ColorPickerInteract.Size = UDim2.new(1, 0, 1, 0)
				ColorPickerInteract.BackgroundTransparency = 1
				ColorPickerInteract.Text = ""
				ColorPickerInteract.Parent = ColorPickerFrame
				
				ColorPicker.Color = ColorPickerSettings.Default or Color3.fromRGB(255, 255, 255)
				ColorPicker.Type = "ColorPicker"
				
				function ColorPicker:Set(Value)
					ColorPicker.Color = Value
					ColorPreview.BackgroundColor3 = Value
					if ColorPickerSettings.Callback then 
						ColorPickerSettings.Callback(Value) 
					end
					SaveConfiguration()
				end
				
				local colors = {
					Color3.fromRGB(255, 0, 0),
					Color3.fromRGB(0, 255, 0),
					Color3.fromRGB(0, 0, 255),
					Color3.fromRGB(255, 255, 0),
					Color3.fromRGB(255, 0, 255),
					Color3.fromRGB(0, 255, 255),
					Color3.fromRGB(255, 255, 255),
					Color3.fromRGB(0, 0, 0)
				}
				local currentColorIndex = 1
				
				ColorPickerInteract.MouseButton1Click:Connect(function()
					currentColorIndex = currentColorIndex + 1
					if currentColorIndex > #colors then
						currentColorIndex = 1
					end
					ColorPicker:Set(colors[currentColorIndex])
				end)
				
				TweenService:Create(ColorPickerFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Size = UDim2.new(1, -10, 0, 30), BackgroundTransparency = 0}):Play()
				
				ColorPicker.Frame = ColorPickerFrame
				if ColorPickerSettings.Name then
					PickleLibrary.Flags[ColorPickerSettings.Name] = ColorPicker
				end
				
				return ColorPicker
			end
			
			return Section
		end
		
		return Tab
	end
	
	return Window
end

UserInputService.InputBegan:Connect(function(input, processed)
	if not processed and input.KeyCode == Enum.KeyCode[getSetting("General", "pickleOpen")] then
		if Pickle then
			Pickle.Enabled = not Pickle.Enabled
		end
	end
end)

function PickleLibrary:Destroy()
	if pickleDestroyed then return end
	pickleDestroyed = true
	Pickle:Destroy()
end

return PickleLibrary
