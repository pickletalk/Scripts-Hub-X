-- Scripts Hub X | Official Main Script (Fixed Version)

-- ================================
-- ALL VARIABLES (TOP OF SCRIPT)
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

-- Player Variables
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- User Status Variables
local OwnerUserId = "2341777244"
local PremiumUsers = {
    "1102633570", -- Pedrojay450 [PERM]
    "8860068952", -- Pedrojay450's alt (assaltanoobsbr) [PERM]
    "799427028", -- Roblox_xvt [PERM]
    "5317421108", -- kolwneje [PERM]
    "1458719572", -- wxckfeen [PERM]
    "8558295467" -- Jerdxbackup [TRIAL]
}
local StaffUserId = {
    "3882788546", -- Keanjacob5
    "799427028", -- Roblox_xvt
    "9249886989" -- ALT
}
local BlacklistUsers = {}

-- Animatronics Finder Configuration
local TARGET_ANIMATRONICS = {"Radioactive Foxy", "Freddles", "Eclipse"}
local MAX_PLOTS = 8
local MAX_PADS = 27
local STEAL_A_FREDDY_PLACE_ID = 137167142636546

-- Optimized Highlighting Configuration
local HIGHLIGHT_COLORS = {
    ["Radioactive Foxy"] = Color3.fromRGB(0, 255, 0), -- GREEN
    ["Freddles"] = Color3.fromRGB(139, 69, 19), -- BROWN
    ["Eclipse"] = Color3.fromRGB(0, 0, 0), -- BLACK
    ["Default"] = Color3.fromRGB(255, 255, 255) -- WHITE
}

-- Auto-Execute Server Hopper Variables
local TPS = TeleportService
local Api = "https://games.roblox.com/v1/games/"
local _place, _id = game.PlaceId, game.JobId
local _servers = Api.._place.."/servers/Public?sortOrder=Desc&limit=100"

-- Webhook URL
local webhookUrl = "https://discord.com/api/webhooks/1396650841045209169/Mx_0dcjOVnzp5f5zMhYM2uOBCPGt9SPr908shfLh_FGKZJ5eFc4tMsiiNNp1CGDx_M21"

-- File System Variables
local keyFileName = "Scripts_Hub_X_OFFICIAL_Key.txt"

-- Performance optimization variables
local highlightUpdateConnection = nil
local tracerUpdateConnection = nil
local characterRespawnConnection = nil

-- Global auto-execute flag that persists (only for Steal a Freddy)
if game.PlaceId == STEAL_A_FREDDY_PLACE_ID then
    if not _G.AnimatronicsFinder then
        _G.AnimatronicsFinder = {
            enabled = true,
            originalServer = _id,
            executionCount = 0,
            isRunning = false,
            foundAnimatronic = nil,
            scriptLoaded = false,
            highlightedObjects = {} -- Store highlighted objects for cleanup
        }
        print("🆕 FIRST RUN: Initializing animatronics finder for Steal a Freddy")
    else
        _G.AnimatronicsFinder.executionCount = _G.AnimatronicsFinder.executionCount + 1
        print("🔄 AUTO-EXECUTE #" .. _G.AnimatronicsFinder.executionCount .. ": Server " .. _id)
    end
end

-- ================================
-- UTILITY FUNCTIONS
-- ================================

-- Safer HTTP request function
local function safeHttpGet(url)
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)
    if success then
        return result
    else
        warn("HTTP request failed for: " .. url .. " Error: " .. tostring(result))
        return nil
    end
end

-- Server listing function
local function ListServers(cursor)
    local url = _servers .. ((cursor and "&cursor="..cursor) or "")
    local Raw = safeHttpGet(url)
    if not Raw then
        return nil
    end
    
    local success, decoded = pcall(function()
        return HttpService:JSONDecode(Raw)
    end)
    
    if success then
        return decoded
    else
        warn("Failed to decode server list JSON")
        return nil
    end
end

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

-- Function to find player's plot
local function findPlayerPlot()
    local workspace = game:GetService("Workspace")
    local plotsFolder = workspace:FindFirstChild("Plots")
    
    if not plotsFolder then
        print("Plots folder not found!")
        return nil
    end
    
    local plotValue = player:FindFirstChild("Plot")
    if not plotValue then
        print("Plot value not found in player!")
        return nil
    end
    
    local plotNumber = plotValue.Value
    print("Looking for plot " .. tostring(plotNumber) .. "...")
    
    local targetPlot = plotsFolder:FindFirstChild(tostring(plotNumber))
    if targetPlot then
        print("Found your plot: " .. tostring(plotNumber))
        return targetPlot, plotNumber
    else
        print("Plot " .. tostring(plotNumber) .. " not found!")
        return nil, plotNumber
    end
end

-- ================================
-- OPTIMIZED HIGHLIGHTING AND TRACERS FUNCTIONS
-- ================================

-- Function to create optimized highlight effect (outline only)
local function highlightAnimatronic(animatronicModel, animatronicName)
    if not animatronicModel or not animatronicModel:IsA("Model") then
        return nil
    end
    
    -- Create highlight object with optimized settings
    local highlight = Instance.new("Highlight")
    highlight.Name = "AnimatronicHighlight_" .. animatronicName
    highlight.Adornee = animatronicModel
    
    -- Set highlight color based on animatronic type
    local color = HIGHLIGHT_COLORS[animatronicName] or HIGHLIGHT_COLORS["Default"]
    highlight.OutlineColor = color
    
    -- Optimized highlight settings (outline only, no fill)
    highlight.FillTransparency = 1 -- Completely transparent fill for performance
    highlight.OutlineTransparency = 0 -- Solid outline
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    
    -- Parent to CoreGui so it's visible to the player
    highlight.Parent = CoreGui
    
    print("✨ Optimized highlight created for " .. animatronicName .. " (outline only)")
    return highlight
end

-- Function to create super thin tracer line to animatronic
local function createTracer(animatronicModel, animatronicName)
    if not animatronicModel or not animatronicModel.PrimaryPart then
        return nil
    end
    
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        return nil
    end
    
    -- Create optimized tracer beam (super thin)
    local beam = Instance.new("Beam")
    beam.Name = "AnimatronicTracer_" .. animatronicName
    
    -- Set tracer color and properties (super thin and optimized)
    local color = HIGHLIGHT_COLORS[animatronicName] or HIGHLIGHT_COLORS["Default"]
    beam.Color = ColorSequence.new(color)
    beam.Transparency = NumberSequence.new(0.3) -- Less transparent for visibility but still light
    beam.Width0 = 0.1 -- Super thin start
    beam.Width1 = 0.1 -- Super thin end
    beam.FaceCamera = true
    beam.Segments = 1 -- Minimize segments for performance
    
    -- Create attachment points
    local startAttachment = Instance.new("Attachment")
    startAttachment.Name = "TracerStart_" .. animatronicName
    startAttachment.Parent = player.Character.HumanoidRootPart
    
    local endAttachment = Instance.new("Attachment")
    endAttachment.Name = "TracerEnd_" .. animatronicName
    endAttachment.Parent = animatronicModel.PrimaryPart
    
    -- Connect beam to attachments
    beam.Attachment0 = startAttachment
    beam.Attachment1 = endAttachment
    beam.Parent = Workspace
    
    print("📍 Super thin tracer created for " .. animatronicName)
    return {
        beam = beam, 
        startAttachment = startAttachment, 
        endAttachment = endAttachment,
        animatronicModel = animatronicModel,
        animatronicName = animatronicName
    }
end

-- Optimized cleanup function with better error handling
local function cleanupHighlights()
    -- Disconnect any running connections first
    if highlightUpdateConnection then
        pcall(function()
            highlightUpdateConnection:Disconnect()
        end)
        highlightUpdateConnection = nil
    end
    
    if tracerUpdateConnection then
        pcall(function()
            tracerUpdateConnection:Disconnect()
        end)
        tracerUpdateConnection = nil
    end
    
    if characterRespawnConnection then
        pcall(function()
            characterRespawnConnection:Disconnect()
        end)
        characterRespawnConnection = nil
    end
    
    -- Clean up stored highlighted objects
    if _G.AnimatronicsFinder and _G.AnimatronicsFinder.highlightedObjects then
        for i = #_G.AnimatronicsFinder.highlightedObjects, 1, -1 do
            local obj = _G.AnimatronicsFinder.highlightedObjects[i]
            if obj then
                pcall(function()
                    if obj.beam and obj.beam.Parent then
                        obj.beam:Destroy()
                    end
                    if obj.startAttachment and obj.startAttachment.Parent then
                        obj.startAttachment:Destroy()
                    end
                    if obj.endAttachment and obj.endAttachment.Parent then
                        obj.endAttachment:Destroy()
                    end
                    if obj.Parent then
                        obj:Destroy()
                    end
                end)
            end
            _G.AnimatronicsFinder.highlightedObjects[i] = nil
        end
        print("🧹 Cleaned up all highlights and tracers")
    end
    
    -- Clean up any leftover highlights in CoreGui
    pcall(function()
        for _, child in pairs(CoreGui:GetChildren()) do
            if child:IsA("Highlight") and string.find(child.Name, "AnimatronicHighlight_") then
                child:Destroy()
            end
        end
    end)
    
    -- Clean up leftover tracers and attachments in Workspace
    pcall(function()
        for _, child in pairs(Workspace:GetChildren()) do
            if child:IsA("Beam") and string.find(child.Name, "AnimatronicTracer_") then
                child:Destroy()
            end
        end
    end)
    
    -- Clean up leftover attachments in character
    pcall(function()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            for _, child in pairs(player.Character.HumanoidRootPart:GetChildren()) do
                if child:IsA("Attachment") and string.find(child.Name, "TracerStart_") then
                    child:Destroy()
                end
            end
        end
    end)
end

-- Function to handle character respawn and reconnect tracers
local function handleCharacterRespawn()
    print("🔄 Character respawned, reconnecting tracers...")
    
    -- Wait for character to fully load
    if not player.Character then
        player.CharacterAdded:Wait()
    end
    
    local humanoidRootPart = player.Character:WaitForChild("HumanoidRootPart", 10)
    if not humanoidRootPart then
        print("❌ Failed to find HumanoidRootPart after respawn")
        return
    end
    
    -- Reconnect all tracers to new character
    if _G.AnimatronicsFinder and _G.AnimatronicsFinder.highlightedObjects then
        for _, obj in pairs(_G.AnimatronicsFinder.highlightedObjects) do
            if obj and obj.beam and obj.animatronicModel and obj.animatronicName then
                pcall(function()
                    -- Remove old start attachment if it exists
                    if obj.startAttachment and obj.startAttachment.Parent then
                        obj.startAttachment:Destroy()
                    end
                    
                    -- Create new start attachment on respawned character
                    local newStartAttachment = Instance.new("Attachment")
                    newStartAttachment.Name = "TracerStart_" .. obj.animatronicName
                    newStartAttachment.Parent = humanoidRootPart
                    
                    -- Reconnect beam
                    obj.beam.Attachment0 = newStartAttachment
                    obj.startAttachment = newStartAttachment
                    
                    print("🔗 Reconnected tracer for " .. obj.animatronicName .. " to respawned character")
                end)
            end
        end
    end
end

-- Set up character respawn handling
local function setupCharacterRespawnHandling()
    -- Clean up existing connection
    if characterRespawnConnection then
        pcall(function()
            characterRespawnConnection:Disconnect()
        end)
    end
    
    -- Connect to character respawn events
    characterRespawnConnection = player.CharacterAdded:Connect(function(character)
        -- Wait a bit for character to fully load
        spawn(function()
            wait(1)
            handleCharacterRespawn()
        end)
    end)
    
    print("👤 Character respawn handling enabled")
end

-- ================================
-- ANIMATRONICS FINDER FUNCTIONS (Steal a Freddy Only)
-- ================================

-- Function to check if a specific plot belongs to the player
local function isPlayerPlot(plotNumber)
    local playerPlot, playerPlotNumber = findPlayerPlot()
    return playerPlotNumber and plotNumber == playerPlotNumber
end

-- Optimized checkAllPlots function
local function checkAllPlots()
    print("🔍 Checking server for animatronics: " .. tostring(game.JobId) .. " (Attempt #" .. tostring(_G.AnimatronicsFinder.executionCount) .. ")")

    local plots = Workspace:FindFirstChild("Plots")
    if not plots then
        print("❌ No Plots folder found")
        return false, nil
    end

    -- Get player's plot number ONCE and normalize it to a number (avoid type mismatches)
    local playerPlotNumber = nil
    local plotValue = player:FindFirstChild("Plot")
    -- wait shortly if Plot isn't set yet (race condition)
    if not plotValue then
        for i = 1, 10 do
            wait(0.1)
            plotValue = player:FindFirstChild("Plot")
            if plotValue then break end
        end
    end

    if plotValue then
        playerPlotNumber = tonumber(plotValue.Value) or tonumber(tostring(plotValue.Value))
        print("ℹ️ Detected playerPlotNumber = " .. tostring(playerPlotNumber) .. " (type: " .. type(playerPlotNumber) .. ")")
    else
        print("⚠️ Player Plot value not found on player; continuing without skipping.")
    end

    local foundAnimatronics = {}

    for plotNum = 1, MAX_PLOTS do
        print("🔍 Checking Plot " .. plotNum .. ".")

        -- Strict skip of player's plot (only if we successfully detected the number)
        if playerPlotNumber and plotNum == playerPlotNumber then
            print("⏭️ Skipping player's plot: " .. plotNum)
        else
            local plot = plots:FindFirstChild(tostring(plotNum))
            if plot then
                print("✅ Plot " .. plotNum .. " found - Checking pads.")
                local pads = plot:FindFirstChild("Pads")
                if pads then
                    for padNum = 1, MAX_PADS do
                        local pad = pads:FindFirstChild(tostring(padNum))
                        if not pad then break end
                        local objectFolder = pad:FindFirstChild("Object")
                        if objectFolder then
                            for _, animatronic in ipairs(TARGET_ANIMATRONICS) do
                                local animatronicModel = objectFolder:FindFirstChild(animatronic)
                                if animatronicModel then
                                    print("🎯 FOUND! " .. animatronic .. " in Plot" .. plotNum .. " Pad" .. padNum)
                                    notify("Success", "Found " .. animatronic .. "!")
                                    
                                    -- Create optimized highlight for the found animatronic
                                    local highlight = highlightAnimatronic(animatronicModel, animatronic)
                                    if highlight and _G.AnimatronicsFinder then
                                        table.insert(_G.AnimatronicsFinder.highlightedObjects, highlight)
                                    end
                                    
                                    -- Create super thin tracer to the found animatronic
                                    local tracer = createTracer(animatronicModel, animatronic)
                                    if tracer and _G.AnimatronicsFinder then
                                        table.insert(_G.AnimatronicsFinder.highlightedObjects, tracer)
                                    end
                                    
                                    table.insert(foundAnimatronics, { name = animatronic, plot = plotNum, pad = padNum })
                                end
                            end
                        end
                    end

                    if #foundAnimatronics == 0 then
                        print("❌ Plot " .. plotNum .. " - No target animatronics found in any pads")
                    end
                else
                    print("❌ Plot " .. plotNum .. " - No Pads folder found")
                end
            else
                print("❌ Plot " .. plotNum .. " - Plot doesn't exist")
            end
        end
    end

    if #foundAnimatronics > 0 then
        print("🎯 Found " .. #foundAnimatronics .. " animatronic(s) total!")
        for i, found in ipairs(foundAnimatronics) do
            print("   " .. i .. ". " .. found.name .. " in Plot" .. found.plot .. " Pad" .. found.pad)
        end
        
        -- Set up character respawn handling when animatronics are found
        setupCharacterRespawnHandling()
        
        _G.AnimatronicsFinder.enabled = false
        _G.AnimatronicsFinder.foundAnimatronic = foundAnimatronics[1].name
        return true, foundAnimatronics[1].name
    end

    print("❌ No target animatronics found in server: " .. tostring(game.JobId))
    return false, nil
end

-- Optimized server joining function
local function joinRandomServer()
    print("🔄 Searching for new server...")
    notify("Server Hop", "Finding different server...")
    
    -- Clean up highlights and tracers before leaving
    cleanupHighlights()
    
    spawn(function()
        pcall(function()
            local attempts = 0
            local maxAttempts = 3
            
            local function tryJoin()
                attempts = attempts + 1
                print("🔄 Join attempt #" .. attempts)
                
                local Next
                local serversChecked = 0
                
                repeat
                    local Servers = ListServers(Next)
                    if not Servers then
                        print("❌ Failed to get server list")
                        wait(2)
                        if attempts < maxAttempts then
                            tryJoin()
                        end
                        return
                    end
                    
                    for i, v in pairs(Servers.data) do
                        serversChecked = serversChecked + 1
                        if v.playing < v.maxPlayers and v.id ~= _id then
                            print("🎯 Trying server: " .. v.id .. " (" .. v.playing .. "/" .. v.maxPlayers .. " players)")
                            
                            local s, r = pcall(function()
                                TPS:TeleportToPlaceInstance(_place, v.id, player)
                            end)
                            
                            if s then
                                print("✅ Teleporting to server: " .. v.id)
                                return
                            else
                                print("❌ Failed to join " .. v.id .. ": " .. tostring(r))
                            end
                        end
                        
                        if serversChecked > 50 then break end
                    end
                    Next = Servers.nextPageCursor
                until not Next or serversChecked > 50
                
                print("⚠️ No suitable servers found, retrying...")
                wait(3)
                if attempts < maxAttempts then
                    tryJoin()
                end
            end
            
            tryJoin()
        end)
    end)
end

-- Optimized animatronics finder execution
local function runAnimatronicsFinder()
    if _G.AnimatronicsFinder.isRunning then
        print("⚠️ Animatronics finder already running, skipping...")
        return false, nil
    end
    
    _G.AnimatronicsFinder.isRunning = true
    
    -- Wait for game to load properly
    if not game:IsLoaded() then
        print("⏳ Waiting for game to load...")
        game.Loaded:Wait()
    end
    
    -- Wait for character
    if not player.Character then
        print("⏳ Waiting for character...")
        player.CharacterAdded:Wait()
    end
    
    -- Wait for plots to load
    print("⏳ Waiting for plots to load...")
    local plotsLoaded = false
    for i = 1, 20 do
        wait(1)
        if Workspace:FindFirstChild("Plots") then
            plotsLoaded = true
            break
        end
    end
    
    if not plotsLoaded then
        print("❌ Plots didn't load in time, server hopping...")
        _G.AnimatronicsFinder.isRunning = false
        if _G.AnimatronicsFinder.enabled then
            joinRandomServer()
        end
        return false, nil
    end
    
    print("⚡ Starting optimized animatronics check in server: " .. game.JobId)
    
    local found, foundAnimatronic = checkAllPlots()
    _G.AnimatronicsFinder.isRunning = false
    
    if not found and _G.AnimatronicsFinder.enabled then
        wait(1)
        joinRandomServer()
        return false, nil
    end
    
    return found, foundAnimatronic
end

-- Auto-execute detection for server hopper
local function shouldAutoExecute()
    -- Only run auto-execute for Steal a Freddy game
    if game.PlaceId ~= STEAL_A_FREDDY_PLACE_ID then
        return false
    end
    
    if not _G.AnimatronicsFinder.enabled then
        return false
    end
    
    if game.JobId ~= _G.AnimatronicsFinder.originalServer then
        return true
    end
    
    if _G.AnimatronicsFinder.executionCount == 0 then
        return true
    end
    
    return false
end

-- Function to detect executor
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
        local success, executor = pcall(identifyexecutor)
        if success and executor then
            return executor
        end
    end
    return "Unknown"
end

-- Fixed webhook notification function
local function sendWebhookNotification(userStatus, scriptUrl)
    print("Sending webhook notification")
    
    if webhookUrl == "" then
        warn("Webhook URL is empty")
        return
    end
    
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
        local http_request_func = request or http_request or syn.request
        if http_request_func and type(http_request_func) == "function" then
            http_request_func({
                Url = webhookUrl,
                Method = "POST",
                Headers = headers,
                Body = HttpService:JSONEncode(send_data)
            })
        end
    end)
    
    if not success then
        warn("Failed to send webhook notification: " .. tostring(err))
    else
        print("Webhook notification sent successfully")
    end
end

-- ================================
-- UI AND LOADING FUNCTIONS
-- ================================

-- Error function to display custom error message
local function showError(text)
    if not playerGui then
        warn("PlayerGui not available")
        return
    end

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
                wait(1)
                copyButton.Text = "Copy Link"
                copyButton.BackgroundColor3 = Color3.fromRGB(80, 160, 255)
            end
        end)
    end)

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
        wait(0.1)
        errorTween:Play()
        wait(0.1)
        discordTween:Play()
        wait(0.1)
        copyButtonTween:Play()
    end

    playEntranceAnimations()
    wait(5)
    screenGui:Destroy()
end

local function loadLoadingScreen()
    print("Attempting to load loading screen from GitHub")
    local script = safeHttpGet("https://raw.githubusercontent.com/pickletalk/Scripts-Hub-X/main/loadingscreen.lua")
    if not script then
        warn("Failed to load loading screen")
        return false, nil
    end
    
    local success, result = pcall(function()
        return loadstring(script)()
    end)
    
    if not success then
        warn("Failed to execute loading screen: " .. tostring(result))
        return false, nil
    end
    
    if not result or type(result) ~= "table" then
        warn("Loading screen script returned invalid data")
        return false, nil
    end
    
    print("Loading screen loaded successfully")
    return true, result
end

local function loadKeySystem()
    print("Attempting to load key system from GitHub")
    local script = safeHttpGet("https://raw.githubusercontent.com/pickletalk/Scripts-Hub-X/main/keysystem.lua")
    if not script then
        warn("Failed to load key system")
        return false, nil
    end
    
    local success, result = pcall(function()
        return loadstring(script)()
    end)
    
    if not success then
        warn("Failed to execute key system: " .. tostring(result))
        return false, nil
    end
    
    if not result or type(result) ~= "table" then
        warn("Key system script returned invalid data")
        return false, nil
    end
    
    print("Key system loaded successfully")
    return true, result
end

-- Updated checkGameSupport function with owner having access to both Games and OwnerGames
local function checkGameSupport()
    print("Checking game support for PlaceID: " .. game.PlaceId)
    
    -- Get current user status first
    local userStatus = checkPremiumUser()
    print("User status: " .. userStatus)
    
    local script = safeHttpGet("https://raw.githubusercontent.com/pickletalk/Scripts-Hub-X/refs/heads/main/GameList.lua")
    if not script then
        warn("Failed to load game list")
        return false, nil
    end
    
    local success, GameData = pcall(function()
        return loadstring(script)()
    end)
    
    if not success then
        warn("Failed to execute game list: " .. tostring(GameData))
        return false, nil
    end
    
    if type(GameData) ~= "table" then
        warn("Game list returned invalid data")
        return false, nil
    end
    
    -- Convert current PlaceId to string for proper comparison (since lua table keys are usually strings)
    local currentPlaceId = tostring(game.PlaceId)
    print("🎯 Current PlaceId: " .. currentPlaceId .. " (type: " .. type(currentPlaceId) .. ")")
    
    -- Select appropriate game list based on user status
    if userStatus == "owner" then
        -- Owner gets access to BOTH Games and OwnerGames (OwnerGames takes priority)
        print("🔑 Owner detected - Checking both OwnerGames and Games lists")
        
        -- First check OwnerGames
        if GameData.OwnerGames and type(GameData.OwnerGames) == "table" then
            print("📋 Checking OwnerGames list...")
            local ownerGamesCount = 0
            for PlaceID, Execute in pairs(GameData.OwnerGames) do
                ownerGamesCount = ownerGamesCount + 1
                local stringPlaceID = tostring(PlaceID)
                print("   Comparing: '" .. stringPlaceID .. "' vs '" .. currentPlaceId .. "'")
                if stringPlaceID == currentPlaceId then
                    print("✅ Game found in OwnerGames list, script URL: " .. tostring(Execute))
                    return true, Execute
                end
            end
            print("❌ Game not found in OwnerGames (" .. ownerGamesCount .. " games checked), checking regular Games...")
        else
            print("⚠️ OwnerGames not found or invalid, checking regular Games...")
        end
        
        -- Then check regular Games as fallback
        if GameData.Games and type(GameData.Games) == "table" then
            print("📋 Checking regular Games list as fallback for owner...")
            local regularGamesCount = 0
            for PlaceID, Execute in pairs(GameData.Games) do
                regularGamesCount = regularGamesCount + 1
                local stringPlaceID = tostring(PlaceID)
                print("   Comparing: '" .. stringPlaceID .. "' vs '" .. currentPlaceId .. "'")
                if stringPlaceID == currentPlaceId then
                    print("✅ Game found in regular Games list, script URL: " .. tostring(Execute))
                    return true, Execute
                end
            end
            print("❌ Game not found in regular Games list either (" .. regularGamesCount .. " games checked)")
        else
            print("⚠️ Regular Games list not found or invalid")
        end
        
        print("❌ Game not supported in either OwnerGames or Games lists")
        return false, nil
    else
        -- Staff, Premium, and Non-Premium users get ONLY regular Games list
        if GameData.Games and type(GameData.Games) == "table" then
            print("✅ Using regular Games list for " .. userStatus .. " user")
            print("📋 Checking regular Games list...")
            
            local regularGamesCount = 0
            -- Check if current game is supported in regular Games list
            for PlaceID, Execute in pairs(GameData.Games) do
                regularGamesCount = regularGamesCount + 1
                local stringPlaceID = tostring(PlaceID)
                print("   Comparing: '" .. stringPlaceID .. "' vs '" .. currentPlaceId .. "'")
                if stringPlaceID == currentPlaceId then
                    print("✅ Game supported in Games list, script URL: " .. tostring(Execute))
                    return true, Execute
                end
            end
            print("❌ Game not found in Games list (" .. regularGamesCount .. " games checked)")
        else
            print("⚠️ Regular Games list not found or invalid")
            return false, nil
        end
        
        print("❌ Game not supported in Games list")
        return false, nil
    end
end

local function loadGameScript(scriptUrl)
    print("Attempting to load game script from URL: " .. scriptUrl)
    local script = safeHttpGet(scriptUrl)
    if not script then
        warn("Failed to load game script")
        return false
    end
    
    local success, result = pcall(function()
        return loadstring(script)()
    end)
    
    if not success then
        warn("Failed to execute game script: " .. tostring(result))
        return false
    end
    
    print("Game script loaded successfully")
    if game.PlaceId == STEAL_A_FREDDY_PLACE_ID and _G.AnimatronicsFinder then
        _G.AnimatronicsFinder.scriptLoaded = true
    end
    return true
end

-- ================================
-- USER STATUS AND AUTHENTICATION
-- ================================

function checkPremiumUser()
    local userId = tostring(player.UserId)
    print("Checking user status for UserId: " .. userId)
    
    if BlacklistUsers and table.find(BlacklistUsers, userId) then
        print("Blacklisted user detected")
        return "blacklisted"
    elseif OwnerUserId and userId == tostring(OwnerUserId) then
        print("Owner detected")
        return "owner"
    elseif StaffUserId and table.find(StaffUserId, userId) then
        print("Staff detected")
        return "staff"
    elseif PremiumUsers and table.find(PremiumUsers, userId) then
        print("Premium user verified")
        return "premium"
    end
    
    print("Non-premium user")
    return "non-premium"
end

local function createKeyFile(validKey)
    if writefile and type(writefile) == "function" then
        local success, err = pcall(function()
            writefile(keyFileName, validKey)
        end)
        if success then
            print("Key file created with valid key")
        else
            warn("Failed to create key file: " .. tostring(err))
        end
    else
        warn("writefile function not available")
    end
end

local function checkValidKey(KeySystem)
    if not isfile or not readfile or not delfile then
        warn("File system functions not available in this executor")
        return false
    end
    
    local success, exists = pcall(function()
        return isfile(keyFileName)
    end)
    
    if success and exists then
        local success2, storedKey = pcall(function()
            return readfile(keyFileName)
        end)
        
        if success2 and storedKey then
            print("Found existing key file, checking validity...")
            
            local isValid = false
            local success3, err = pcall(function()
                if KeySystem.ValidateKey and type(KeySystem.ValidateKey) == "function" then
                    isValid = KeySystem.ValidateKey(storedKey)
                elseif KeySystem.IsKeyVerified and type(KeySystem.IsKeyVerified) == "function" then
                    isValid = KeySystem.IsKeyVerified()
                end
            end)
            
            if success3 and isValid then
                print("Stored key is valid")
                return true
            else
                print("Stored key is invalid, deleting file")
                pcall(function()
                    delfile(keyFileName)
                end)
                return false
            end
        else
            warn("Failed to read key file: " .. tostring(storedKey))
            return false
        end
    else
        print("No key file found")
        return false
    end
    
    return false
end

-- ================================
-- MAIN EXECUTION FUNCTIONS
-- ================================

-- Main execution
spawn(function()
    print("🚀 Starting main execution at " .. os.date("%H:%M:%S"))
    
    -- Check user status
    local userStatus = checkPremiumUser()
    
    if userStatus == "blacklisted" then
        print("❌ Kicking blacklisted user")
        player:Kick("You are blacklisted from using this script!")
        return
    end

    -- Check game support
    local isSupported, scriptUrl = checkGameSupport()
    sendWebhookNotification(userStatus, scriptUrl)
    if not isSupported then
        showError("Game is not supported. Suggest this game on our Discord server.")
        return
    end

    -- Check if this is Steal a Freddy game and user is premium/owner/staff
    if game.PlaceId == STEAL_A_FREDDY_PLACE_ID and (userStatus == "owner" or userStatus == "staff" or userStatus == "premium") then
        print("🎮 Steal a Freddy game detected with privileged user - Running optimized animatronics finder")
        
        -- Auto-execute check
        if shouldAutoExecute() then
            print("🔄 Auto-execute: Checking for animatronics...")
            local found, foundAnimatronic = runAnimatronicsFinder()
            
            if found and foundAnimatronic then
                print("🎯 " .. foundAnimatronic .. " found!")
                
                -- Load script based on user type - ONLY if not already loaded
                if not _G.AnimatronicsFinder.scriptLoaded then
                    if userStatus == "owner" or userStatus == "staff" then
                        print("⚡ " .. userStatus .. " - Loading script immediately")
                        local scriptLoaded = loadGameScript(scriptUrl)
                        if scriptLoaded then
                            print("✅ Scripts Hub X | Complete for " .. userStatus .. " (Found: " .. foundAnimatronic .. ")")
                        else
                            print("Failed to load script after finding " .. foundAnimatronic)
                        end
                    elseif userStatus == "premium" then
                        print("🎨 Premium - Showing loading screen")
                        local success, LoadingScreen = loadLoadingScreen()
                        if success and LoadingScreen then
                            spawn(function()
                                pcall(function()
                                    if LoadingScreen.initialize then LoadingScreen.initialize() end
                                    if LoadingScreen.setLoadingText then
                                        LoadingScreen.setLoadingText("Found " .. foundAnimatronic .. "!", Color3.fromRGB(0, 255, 0))
                                    end
                                    wait(2)
                                    if LoadingScreen.setLoadingText then
                                        LoadingScreen.setLoadingText("Loading game...", Color3.fromRGB(150, 180, 200))
                                    end
                                    if LoadingScreen.animateLoadingBar then
                                        LoadingScreen.animateLoadingBar(function()
                                            if LoadingScreen.playExitAnimations then
                                                LoadingScreen.playExitAnimations(function()
                                                    local scriptLoaded = loadGameScript(scriptUrl)
                                                    if scriptLoaded then
                                                        print("✅ Scripts Hub X | Complete for Premium (Found: " .. foundAnimatronic .. ")")
                                                    end
                                                end)
                                            end
                                        end)
                                    end
                                end)
                            end)
                        else
                            local scriptLoaded = loadGameScript(scriptUrl)
                            if scriptLoaded then
                                print("✅ Scripts Hub X | Complete (no loading screen)")
                            end
                        end
                    end
                else
                    print("✅ Script already loaded, skipping duplicate load")
                end
            else
                print("❌ No animatronics found, continuing search...")
            end
        else
            -- Manual check for non-auto execute - ONLY if script not already loaded
            if not _G.AnimatronicsFinder.scriptLoaded then
                spawn(function()
                    wait(2)
                    local found, foundAnimatronic = runAnimatronicsFinder()
                    if found and foundAnimatronic then
                        print("🎯 Manual check: " .. foundAnimatronic .. " found!")
                        
                        -- Double check script wasn't loaded by another process
                        if not _G.AnimatronicsFinder.scriptLoaded then
                            if userStatus == "owner" or userStatus == "staff" then
                                local scriptLoaded = loadGameScript(scriptUrl)
                                if scriptLoaded then
                                    print("✅ Scripts Hub X | Complete for " .. userStatus)
                                end
                            elseif userStatus == "premium" then
                                local success, LoadingScreen = loadLoadingScreen()
                                if success and LoadingScreen then
                                    spawn(function()
                                        pcall(function()
                                            if LoadingScreen.initialize then LoadingScreen.initialize() end
                                            if LoadingScreen.setLoadingText then
                                                LoadingScreen.setLoadingText("Found " .. foundAnimatronic .. "!", Color3.fromRGB(0, 255, 0))
                                            end
                                            wait(2)
                                            if LoadingScreen.animateLoadingBar then
                                                LoadingScreen.animateLoadingBar(function()
                                                    if LoadingScreen.playExitAnimations then
                                                        LoadingScreen.playExitAnimations(function()
                                                            loadGameScript(scriptUrl)
                                                        end)
                                                    end
                                                end)
                                            end
                                        end)
                                    end)
                                else
                                    loadGameScript(scriptUrl)
                                end
                            end
                        else
                            print("✅ Script already loaded by another process, skipping")
                        end
                    end
                end)
            else
                print("✅ Script already loaded, skipping manual check")
            end
        end
    else
        -- Regular flow for other games or non-premium users in Steal a Freddy
        print("🎮 Regular execution flow")
        
        if userStatus == "owner" or userStatus == "staff" or userStatus == "premium" then
            if userStatus == "owner" or userStatus == "staff" then
                local scriptLoaded = loadGameScript(scriptUrl)
                if scriptLoaded then
                    print("✅ Scripts Hub X | Complete for " .. userStatus)
                end
            else -- premium
                local success, LoadingScreen = loadLoadingScreen()
                if success and LoadingScreen then
                    spawn(function()
                        pcall(function()
                            if LoadingScreen.initialize then LoadingScreen.initialize() end
                            if LoadingScreen.setLoadingText then
                                LoadingScreen.setLoadingText("Premium User Verified", Color3.fromRGB(0, 150, 0))
                            end
                            wait(2)
                            if LoadingScreen.setLoadingText then
                                LoadingScreen.setLoadingText("Loading game...", Color3.fromRGB(150, 180, 200))
                            end
                            if LoadingScreen.animateLoadingBar then
                                LoadingScreen.animateLoadingBar(function()
                                    if LoadingScreen.playExitAnimations then
                                        LoadingScreen.playExitAnimations(function()
                                            loadGameScript(scriptUrl)
                                        end)
                                    end
                                end)
                            end
                        end)
                    end)
                else
                    loadGameScript(scriptUrl)
                end
            end
        else
            -- Non-premium user - key system
            print("🔑 Non-premium user - Loading key system")
            local successKS, KeySystem = loadKeySystem()
            if not successKS or not KeySystem then
                showError("Key system failed to load")
                return
            end
            
            if checkValidKey(KeySystem) then
                print("✅ Valid key found - Loading script")
                local scriptLoaded = loadGameScript(scriptUrl)
                if scriptLoaded then
                    print("✅ Scripts Hub X | Complete for cached key user")
                else
                    showError("Valid key but script failed to load")
                end
            else
                print("🔑 No valid key - Showing key system")
                
                local keyVerified = false
                local validKey = ""
                
                pcall(function()
                    if KeySystem.ShowKeySystem and type(KeySystem.ShowKeySystem) == "function" then
                        KeySystem.ShowKeySystem()
                    else
                        showError("Key system interface failed to display")
                        return
                    end
                    
                    print("⏳ Waiting for key verification...")
                    
                    -- Wait for key verification with timeout
                    local timeout = 300 -- 5 minutes
                    local startTime = tick()
                    while not keyVerified and (tick() - startTime) < timeout do
                        if KeySystem.IsKeyVerified and type(KeySystem.IsKeyVerified) == "function" then
                            keyVerified = KeySystem.IsKeyVerified()
                        end
                        if keyVerified then
                            if KeySystem.GetEnteredKey and type(KeySystem.GetEnteredKey) == "function" then
                                validKey = KeySystem.GetEnteredKey()
                            end
                            break
                        end
                        wait(0.1)
                    end
                    
                    if KeySystem.HideKeySystem and type(KeySystem.HideKeySystem) == "function" then
                        KeySystem.HideKeySystem()
                    end
                end)
                
                if not keyVerified then
                    showError("Key verification failed or timed out")
                    return
                end
                
                if validKey ~= "" then
                    createKeyFile(validKey)
                end
                
                print("✅ Key verified - Loading script")
                local scriptLoaded = loadGameScript(scriptUrl)
                if scriptLoaded then
                    print("✅ Scripts Hub X | Complete for verified key user")
                else
                    showError("Key verified but script failed to load")
                end
            end
        end
    end
end)   
