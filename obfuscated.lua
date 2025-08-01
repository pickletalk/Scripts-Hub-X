-- Scripts Hub X | Official Main Script - Complete Version with Error Detection
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local MarketplaceService = game:GetService("MarketplaceService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui", 5)
if not playerGui then
    warn("PlayerGui not found after 5 seconds")
    return
end
print("Main script started, PlayerGui found")

-- Global error detection flag
local hasErrorOccurred = false
local errorDetectionSystem = nil

-- Load error detection system first
local function loadErrorDetection()
    print("Loading error detection system...")
    local success, ErrorSystem = pcall(function()
        local script = game:HttpGet("https://raw.githubusercontent.com/pickletalk/Scripts-Hub-X/main/error.lua", true)
        return loadstring(script)()
    end)
    if success and ErrorSystem then
        print("Error detection system loaded successfully")
        errorDetectionSystem = ErrorSystem
        return true
    else
        warn("Failed to load error detection system: " .. tostring(ErrorSystem))
        return false
    end
end

-- Enhanced error handling wrapper
local function safeExecute(funcName, func, ...)
    local success, result = pcall(func, ...)
    if not success then
        warn("[ERROR] " .. funcName .. " failed: " .. tostring(result))
        hasErrorOccurred = true
        
        -- If error detection system is available, use it
        if errorDetectionSystem and errorDetectionSystem.createErrorGUI then
            errorDetectionSystem.createErrorGUI(funcName:lower(), "Function '" .. funcName .. "' failed: " .. tostring(result))
        end
        
        return false, result
    end
    return true, result
end

-- UserIds
local OwnerUserId = nil
local PremiumUsers = {
    "5356702370"
}
local StaffUserId = {
    "2784109194", -- giweyi
    "8342200727", -- Chloe_Zoom28
    "3882788546" -- keanjacob5
}
local BlackUsers = {
    "1234567890"
}
local JumpscareUsers = {
    "8469418817",
    "3882788546"
}
local BlacklistUsers = nil
local keyFileName = "Scripts Hub X OFFICIAL - Key.txt"

-- File-based key management functions
local function saveKeyToFile(key)
    return safeExecute("SaveKeyToFile", function()
        writefile(keyFileName, key)
        print("Key saved to file: " .. keyFileName)
        return true
    end)
end

local function loadKeyFromFile()
    return safeExecute("LoadKeyFromFile", function()
        if isfile(keyFileName) then
            local key = readfile(keyFileName)
            if key and key ~= "" then
                print("Key loaded from file: " .. keyFileName)
                return key
            end
        end
        print("No valid key file found or failed to read")
        return nil
    end)
end

local function deleteKeyFile()
    return safeExecute("DeleteKeyFile", function()
        if isfile(keyFileName) then
            delfile(keyFileName)
        end
        print("Key file deleted: " .. keyFileName)
        return true
    end)
end

local host = "https://api.platoboost.com"
local hostResponse
pcall(function()
    hostResponse = game:HttpGet(host .. "/public/connectivity")
end)
if not hostResponse then
    host = "https://api.platoboost.net"
end

-- Verify key with server function (complete implementation)
local function verifyKeyWithServer(key, silent)
    return safeExecute("VerifyKeyWithServer", function()
        silent = silent or false
        print("Verifying key with server: " .. tostring(key))
        
        local service = 5008
        local secret = "dd2c65bc-6361-4147-9a25-246cd334eedd"
        local useNonce = true
        
        local function lDigest(input)
            local inputStr = tostring(input)
            local hash = {}
            for i = 1, #inputStr do
                table.insert(hash, string.byte(inputStr, i))
            end
            local hashHex = ""
            for _, byte in ipairs(hash) do
                hashHex = hashHex .. string.format("%02x", byte)
            end
            return hashHex
        end
        
        local function generateNonce()
            local str = ""
            for _ = 1, 16 do
                str = str .. string.char(math.floor(math.random() * (122 - 97 + 1)) + 97)
            end
            return str
        end
        
        local endpoint = host .. "/public/whitelist/" .. tostring(service) .. "?identifier=" .. lDigest(player.UserId) .. "&key=" .. key
        if useNonce then
            local nonce = generateNonce()
            endpoint = endpoint .. "&nonce=" .. nonce
        end
        
        local response = game:HttpGet(endpoint)
        
        if response then
            local decoded = HttpService:JSONDecode(response)
            if decoded.success == true then
                if decoded.data.valid == true then
                    -- Key is valid, save it to file
                    saveKeyToFile(key)
                    print("Key verification successful")
                    return true
                else
                    -- Key is not valid, try FREE_ key redemption
                    if string.sub(key, 1, 4) == "FREE_" then
                        local nonce = generateNonce()
                        local endpoint = host .. "/public/redeem/" .. tostring(service)
                        local body = {
                            identifier = lDigest(player.UserId),
                            key = key
                        }
                        if useNonce then
                            body.nonce = nonce
                        end
                        
                        local response = game:HttpGet(endpoint, true, {
                            ["Content-Type"] = "application/json"
                        }, HttpService:JSONEncode(body))
                        
                        if response then
                            local decoded = HttpService:JSONDecode(response)
                            if decoded.success == true then
                                if decoded.data.valid == true then
                                    if useNonce then
                                        if decoded.data.hash == lDigest("true" .. "-" .. nonce .. "-" .. secret) then
                                            -- Key redeemed successfully, save it
                                            saveKeyToFile(key)
                                            print("Key redemption successful")
                                            return true
                                        else
                                            if not silent then
                                                warn("Failed to verify integrity.")
                                            end
                                            deleteKeyFile() -- Delete invalid key file
                                            return false
                                        end
                                    else
                                        saveKeyToFile(key)
                                        print("Key redemption successful")
                                        return true
                                    end
                                else
                                    if not silent then
                                        warn("Key is invalid.")
                                    end
                                    deleteKeyFile() -- Delete invalid key file
                                    return false
                                end
                            else
                                if string.sub(decoded.message, 1, 27) == "unique constraint violation" then
                                    if not silent then
                                        warn("You already have an active key, please wait for it to expire.")
                                    end
                                    return false
                                else
                                    if not silent then
                                        warn(decoded.message)
                                    end
                                    deleteKeyFile() -- Delete invalid key file
                                    return false
                                end
                            end
                        else
                            if not silent then
                                warn("Server connection failed.")
                            end
                            deleteKeyFile() -- Delete invalid key file
                            return false
                        end
                    else
                        if not silent then
                            warn("Key is invalid.")
                        end
                        deleteKeyFile() -- Delete invalid key file
                        return false
                    end
                end
            else
                if not silent then
                    warn(decoded.message)
                end
                deleteKeyFile() -- Delete invalid key file
                return false
            end
        else
            if not silent then
                warn("Server connection failed.")
            end
            deleteKeyFile() -- Delete invalid key file
            return false
        end
    end)
end

-- Check stored key function
local function checkStoredKey()
    local success, storedKey = loadKeyFromFile()
    if success and storedKey and storedKey ~= "" then
        print("Found stored key, verifying...")
        local verifySuccess, isValid = verifyKeyWithServer(storedKey, true) -- Silent verification
        if verifySuccess and isValid then
            print("Stored key is valid")
            return true
        else
            print("Stored key is invalid, deleting file")
            deleteKeyFile()
            return false
        end
    end
    print("No stored key found")
    return false
end

-- Load scripts from GitHub with enhanced error handling
local function loadLoadingScreen()
    print("Attempting to load loading screen from GitHub")
    return safeExecute("LoadLoadingScreen", function()
        local script = game:HttpGet("https://raw.githubusercontent.com/pickletalk/Scripts-Hub-X/main/loadingscreen.lua", true)
        local LoadingScreen = loadstring(script)()
        
        if not LoadingScreen or 
           not LoadingScreen.playEntranceAnimations or 
           not LoadingScreen.animateLoadingBar or 
           not LoadingScreen.playExitAnimations or 
           not LoadingScreen.setLoadingText or 
           not LoadingScreen.initialize then
            error("Loading screen script missing required functions")
        end
        
        print("Loading screen loaded successfully")
        return LoadingScreen
    end)
end

local function loadKeySystem()
    print("Attempting to load key system from GitHub")
    return safeExecute("LoadKeySystem", function()
        local script = game:HttpGet("https://raw.githubusercontent.com/pickletalk/Scripts-Hub-X/main/keysystem.lua", true)
        local KeySystem = loadstring(script)()
        
        if not KeySystem or 
           not KeySystem.ShowKeySystem or 
           not KeySystem.IsKeyVerified or 
           not KeySystem.HideKeySystem or 
           not KeySystem.verifyKey then
            error("Key system missing required functions")
        end
        
        print("Key system loaded successfully")
        return KeySystem
    end)
end

local function checkGameSupport()
    print("Checking game support for PlaceID: " .. game.PlaceId)
    return safeExecute("CheckGameSupport", function()
        local script = game:HttpGet("https://raw.githubusercontent.com/pickletalk/Scripts-Hub-X/refs/heads/main/GameList.lua", true)
        local Games = loadstring(script)()
        
        for PlaceID, Execute in pairs(Games) do
            if PlaceID == game.PlaceId then
                print("Game supported, script URL: " .. Execute)
                return true, Execute
            end
        end
        
        print("Game not supported")
        return false, nil
    end)
end

local function loadGameScript(scriptUrl)
    print("Attempting to load game script from URL: " .. scriptUrl)
    return safeExecute("LoadGameScript", function()
        local result = loadstring(game:HttpGet(scriptUrl, true))()
        print("Game script loaded successfully")
        return result
    end)
end

local function showErrorNotification()
    print("Showing error notification")
    return safeExecute("ShowErrorNotification", function()
        local script = game:HttpGet("https://raw.githubusercontent.com/pickletalk/Scripts-Hub-X/refs/heads/main/errorloadingscreen.lua", true)
        return loadstring(script)()
    end)
end

local function loadBlackUI()
    print("Loading black UI")
    return safeExecute("LoadBlackUI", function()
        local script = game:HttpGet("https://raw.githubusercontent.com/pickletalk/Scripts-Hub-X/refs/heads/main/blackui.lua", true)
        local BlackUI = loadstring(script)()
        print("Black UI loaded successfully")
        return BlackUI
    end)
end

local function applyBlackSkin()
    return safeExecute("ApplyBlackSkin", function()
        print("Applying black skin effect")
        local character = player.Character or player.CharacterAdded:Wait()
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.BrickColor = BrickColor.new("Really black")
            elseif part:IsA("Decal") and part.Name == "face" then
                part.Transparency = 1
            end
        end
    end)
end

local function loadBackgroundMusic()
    return safeExecute("LoadBackgroundMusic", function()
        print("Loading background music")
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://115881128226372"
        sound.Parent = SoundService
        sound.Looped = true
        sound.Volume = 0.5
        sound:Play()
        print("Background music loaded and playing")
        return sound
    end)
end

local function detectExecutor()
    return safeExecute("DetectExecutor", function()
        print("Attempting to detect executor")
        local detectedExecutor = "Unknown"
        local env = getfenv(0)
        
        -- Check for common executor signatures
        if typeof(env.delta) == "table" and env.delta.version then
            detectedExecutor = "Delta Executor"
        elseif typeof(env.krnl) == "table" and env.krnl.inject then
            detectedExecutor = "Krnl"
        elseif typeof(env.fluxus) == "function" and env.fluxus() then
            detectedExecutor = "Fluxus"
        elseif typeof(env.hydrogen) == "table" and env.hydrogen.execute then
            detectedExecutor = "Hydrogen"
        elseif typeof(env.syn) == "table" and env.syn.request then
            detectedExecutor = "Synapse X"
        elseif typeof(env.getexecutorname) == "function" then
            local execName = env.getexecutorname()
            if execName and execName ~= "" then
                detectedExecutor = execName
            end
        elseif typeof(env.isexecutor) == "function" and env.isexecutor() then
            detectedExecutor = "Generic Executor"
        end
        
        print("Detected executor: " .. detectedExecutor)
        return detectedExecutor
    end)
end

local function sendWebhookNotification(userStatus, scriptUrl)
    return safeExecute("SendWebhookNotification", function()
        print("Sending webhook notification")
        local webhookUrl = "https://discord.com/api/webhooks/1396650841045209169/Mx_0dcjOVnzp5f5zMhYM2uOBCPGt9SPr908shfLh_FGKZJ5eFc4tMsiiNNp1CGDx_M21"
        if webhookUrl == "" then
            warn("Webhook URL is empty")
            return
        end
        
        local gameName = "Unknown"
        local success, productInfo = pcall(function()
            return MarketplaceService:GetProductInfo(game.PlaceId)
        end)
        if success then
            gameName = productInfo.Name
        end
        
        local userId = tostring(player.UserId)
        local detectedExecutorSuccess, detectedExecutor = detectExecutor()
        if not detectedExecutorSuccess then
            detectedExecutor = "Unknown"
        end
        
        local send_data = {
            ["username"] = "Script Execution Log",
            ["avatar_url"] = "https://res.cloudinary.com/dtjjgiitl/image/upload/q_auto:good,f_auto,fl_progressive/v1753332266/kpjl5smuuixc5w2ehn7r.jpg",
            ["content"] = "Scripts Hub X | Official - Logging",
            ["embeds"] = {
                {
                    ["title"] = "Script Execution Details",
                    ["description"] = "**Game**: " .. gameName .. "\n**Game ID**: " .. game.PlaceId .. "\n**Profile**: https://www.roblox.com/users/" .. player.UserId .. "/profile",
                    ["color"] = 4915083,
                    ["fields"] = {
                        {["name"] = "Display Name", ["value"] = player.DisplayName, ["inline"] = true},
                        {["name"] = "Username", ["value"] = player.Name, ["inline"] = true},
                        {["name"] = "User ID", ["value"] = tostring(player.UserId), ["inline"] = true},
                        {["name"] = "Executor", ["value"] = detectedExecutor, ["inline"] = true},
                        {["name"] = "User Type", ["value"] = userStatus, ["inline"] = true},
                        {["name"] = "Job Id", ["value"] = game.JobId, ["inline"] = true},
                        {["name"] = "Join Script", ["value"] = "game:GetService(\"TeleportService\"):TeleportToPlaceInstance(" .. game.PlaceId .. ",\"" .. game.JobId .. "\",game.Players.LocalPlayer)"
                    },
                    ["footer"] = {["text"] = "Scripts Hub X | Official", ["icon_url"] = "https://res.cloudinary.com/dtjjgiitl/image/upload/q_auto:good,f_auto,fl_progressive/v1753332266/kpjl5smuuixc5w2ehn7r.jpg"},
                    ["thumbnail"] = {["url"] = "https://thumbnails.roproxy.com/v1/users/avatar-headshot?userIds=" .. player.UserId .. "&size=420x420&format=Png&isCircular=true"}
                }
            }
        }
        local headers = {["Content-Type"] = "application/json"}
        request({
            Url = webhookUrl,
            Method = "POST",
            Headers = headers,
            Body = HttpService:JSONEncode(send_data)
        })
        print("Webhook notification sent successfully")
    end)
end

local function checkPremiumUser()
    return safeExecute("CheckPremiumUser", function()
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
        elseif BlackUsers and table.find(BlackUsers, userId) then
            print("Black user detected")
            return "blackuser"
        elseif JumpscareUsers and table.find(JumpscareUsers, userId) then
            print("Jumpscare user detected")
            return "jumpscareuser"
        elseif PremiumUsers and table.find(PremiumUsers, userId) then
            print("Premium user verified")
            return "premium"
        end
        
        print("Checking platoboost whitelist for UserId: " .. userId)
        local success, response = pcall(function()
            return game:HttpGet("https://api.platoboost.com/whitelist?userId=" .. userId, true)
        end)
        if success and response and response:lower():find("true") then
            print("Platoboost whitelisted user detected")
            return "platoboost_whitelisted"
        end
        
        print("Non-premium user")
        return "non-premium"
    end)
end

-- UI Detection and Error Fallback System
local function detectAndHandleUIErrors()
    print("Starting UI detection and error handling...")
    
    -- Wait for potential UI elements to load
    wait(3)
    
    local hasAnyUI = false
    local detectedUIs = {}
    
    -- Check for any UI elements that should exist
    for _, gui in pairs(playerGui:GetChildren()) do
        if gui.Name == "KeySystemGUI" then
            table.insert(detectedUIs, "KeySystem")
            hasAnyUI = true
        elseif gui.Name == "LoadingScreenGUI" then
            table.insert(detectedUIs, "LoadingScreen")
            hasAnyUI = true
        elseif gui.Name == "ErrorNotification" then
            table.insert(detectedUIs, "ErrorNotification")
            hasAnyUI = true
        end
    end
    
    print("Detected UIs: " .. table.concat(detectedUIs, ", "))
    
    -- If no UI was detected and we had errors, run error detection
    if not hasAnyUI and hasErrorOccurred then
        print("No UI detected and errors occurred - running error detection system")
        if errorDetectionSystem and errorDetectionSystem.runErrorDetection then
            errorDetectionSystem.runErrorDetection()
        else
            -- Fallback: Try to load error system again
            local success = loadErrorDetection()
            if success and errorDetectionSystem then
                errorDetectionSystem.runErrorDetection()
            else
                -- Last resort: Show basic error
                warn("Complete system failure - no error detection available")
                player:Kick("Scripts Hub X encountered a critical error. Please rejoin and try again.")
            end
        end
        return false
    end
    
    return true
end

-- Enhanced jumpscare function with error handling
local function executeJumpscareSequence()
    return safeExecute("ExecuteJumpscareSequence", function()
        print("Jumpscare user detected")
        if getgenv().jumpscare_jeffwuz_loaded and not _G.jumpscarefucking123 then
            warn("Jumpscare already loading")
            return
        end
        getgenv().jumpscare_jeffwuz_loaded = true
        getgenv().Notify = false
        local Notify_Webhook = "https://discord.com/api/webhooks/1390952057296519189/n0SJoYfZq0PD4-vphnZw2d5RTesGZvkLSWm6RX_sBbCZC2QXxVdGQ5q7N338mZ4m9j5E"
        
        if not getcustomasset then
            game:Shutdown()
            return
        end
        
        local ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Parent = CoreGui
        ScreenGui.IgnoreGuiInset = true
        ScreenGui.Name = "JeffTheKillerWuzHere"
        
        local VideoScreen = Instance.new("VideoFrame")
        VideoScreen.Parent = ScreenGui
        VideoScreen.Size = UDim2.new(1, 0, 1, 0)
        
        writefile("yes.mp4", game:HttpGet("https://github.com/HappyCow91/RobloxScripts/blob/main/Videos/videoplayback.mp4?raw=true", true))
        VideoScreen.Video = getcustomasset("yes.mp4")
        VideoScreen.Looped = true
        VideoScreen.Playing = true
        VideoScreen.Volume = 10
        
        if getgenv().Notify then
            if Notify_Webhook ~= "" then
                local ThumbnailAPI = game:HttpGet("https://thumbnails.roproxy.com/v1/users/avatar-headshot?userIds=" .. player.UserId .. "&size=420x420&format=Png&isCircular=true", true)
                local json = HttpService:JSONDecode(ThumbnailAPI)
                local avatardata = json.data[1].imageUrl
                local UserAPI = game:HttpGet("https://users.roproxy.com/v1/users/" .. player.UserId, true)
                local json = HttpService:JSONDecode(UserAPI)
                local DescriptionData = json.description
                local CreatedData = json.created
                
                local send_data = {
                    ["username"] = "Anti Information Leaks",
                    ["avatar_url"] = "https://res.cloudinary.com/dtjjgiitl/image/upload/q_auto:good,f_auto,fl_progressive/v1753332266/kpjl5smuuixc5w2ehn7r.jpg",
                    ["content"] = "https://discord.gg/bpsNUH5sVb",
                    ["embeds"] = {
                        {
                            ["title"] = "Scripts Hub X | Official - Protection",
                            ["description"] = "THIS IS PROBIHIDENED BY Scripts Hub X | Official",
                            ["color"] = 4915083,
                            ["fields"] = {
                                {["name"] = "Username", ["value"] = "THIS IS PROBIHIDENED BY Scripts Hub X | Official", ["inline"] = true},
                                {["name"] = "Display Name", ["value"] = "THIS IS PROBIHIDENED BY Scripts Hub X | Official", ["inline"] = true},
                                {["name"] = "User ID", ["value"] = "THIS IS PROBIHIDENED BY Scripts Hub X | Official", ["inline"] = true},
                                {["name"] = "Account Age", ["value"] = "THIS IS PROBIHIDENED BY Scripts Hub X | Official", ["inline"] = true},
                                {["name"] = "Membership", ["value"] = "THIS IS PROBIHIDENED BY Scripts Hub X | Official", ["inline"] = true},
                                {["name"] = "Account Created Day", ["value"] = "THIS IS PROBIHIDENED BY Scripts Hub X | Official", ["inline"] = true},
                                {["name"] = "Profile Description", ["value"] = "THIS IS PROBIHIDENED BY Scripts Hub X | Official", ["inline"] = true}
                            },
                            ["footer"] = {["text"] = "JTK Log", ["icon_url"] = "https://res.cloudinary.com/dtjjgiitl/image/upload/q_auto:good,f_auto,fl_progressive/v1753332266/kpjl5smuuixc5w2ehn7r.jpg"},
                            ["thumbnail"] = {["url"] = "https://res.cloudinary.com/dtjjgiitl/image/upload/q_auto:good,f_auto,fl_progressive/v1753332266/kpjl5smuuixc5w2ehn7r.jpg"}
                        }
                    }
                }
                request({
                    Url = Notify_Webhook,
                    Method = "POST",
                    Headers = {["Content-Type"] = "application/json"},
                    Body = HttpService:JSONEncode(send_data)
                })
            end
        end
        wait(5)
        ScreenGui:Destroy()
    end)
end

-- Main execution with comprehensive error handling
coroutine.wrap(function()
    print("Starting main execution at " .. os.date("%H:%M:%S"))
    
    -- Load error detection system first
    loadErrorDetection()
    
    local userStatusSuccess, userStatus = checkPremiumUser()
    if not userStatusSuccess then
        userStatus = "unknown"
    end
    
    sendWebhookNotification(userStatus, nil)

    if userStatus == "blacklisted" then
        print("Kicking blacklisted user")
        player:Kick("You are blacklisted from using this script!\nYou may appeal this by DMing pickle_talks on Discord with your username and explanation.")
        return
    end

    local isSupportedSuccess, isSupported, scriptUrl = checkGameSupport()
    if not isSupportedSuccess or not isSupported then
        print("Game not supported or check failed")
        local loadingSuccess, LoadingScreen = loadLoadingScreen()
        if loadingSuccess and LoadingScreen then
            pcall(function()
                LoadingScreen.initialize()
                LoadingScreen.setLoadingText("Game not supported", Color3.fromRGB(245, 100, 100))
                wait(3)
                LoadingScreen.playExitAnimations()
            end)
        end
        showErrorNotification()
        return
    end

    if userStatus == "owner" or userStatus == "staff" then
        print(userStatus == "owner" and "Owner detected, loading script directly" or "Staff detected, loading script directly")
        local scriptLoadedSuccess, scriptLoaded = loadGameScript(scriptUrl)
        if scriptLoadedSuccess then
            print("Scripts Hub X | Loading Complete for " .. userStatus .. "!")
        else
            showErrorNotification()
        end
        
    elseif userStatus == "blackuser" then
        print("Black user detected")
        applyBlackSkin()
        local blackUISuccess, BlackUI = loadBlackUI()
        if blackUISuccess and BlackUI then
            pcall(function()
                BlackUI.showBlackUI()
                wait(3)
                BlackUI.hideBlackUI()
            end)
        end
        
        local backgroundMusicSuccess, backgroundMusic = loadBackgroundMusic()
        local loadingSuccess, LoadingScreen = loadLoadingScreen()
        
        if loadingSuccess and LoadingScreen then
            pcall(function()
                LoadingScreen.initialize()
                LoadingScreen.setLoadingText("Black User Detected", Color3.fromRGB(0, 0, 0))
                wait(2)
                LoadingScreen.setLoadingText("Loading game...", Color3.fromRGB(150, 180, 200))
                LoadingScreen.animateLoadingBar(function()
                    LoadingScreen.playExitAnimations(function()
                        if backgroundMusicSuccess and backgroundMusic then
                            backgroundMusic:Stop()
                            backgroundMusic:Destroy()
                        end
                        local scriptLoadedSuccess, scriptLoaded = loadGameScript(scriptUrl)
                        if scriptLoadedSuccess then
                            print("Scripts Hub X | Loading Complete for black user!")
                        else
                            showErrorNotification()
                        end
                    end)
                end)
            end)
        else
            if backgroundMusicSuccess and backgroundMusic then
                backgroundMusic:Stop()
                backgroundMusic:Destroy()
            end
            showErrorNotification()
        end
        
    elseif userStatus == "jumpscareuser" then
        executeJumpscareSequence()
        
        local loadingSuccess, LoadingScreen = loadLoadingScreen()
        if loadingSuccess and LoadingScreen then
            pcall(function()
                LoadingScreen.initialize()
                LoadingScreen.setLoadingText("Jumpscare User Detected", Color3.fromRGB(255, 0, 0))
                wait(2)
                LoadingScreen.setLoadingText("Loading game...", Color3.fromRGB(150, 180, 200))
                LoadingScreen.animateLoadingBar(function()
                    LoadingScreen.playExitAnimations(function()
                        local scriptLoadedSuccess, scriptLoaded = loadGameScript(scriptUrl)
                        if scriptLoadedSuccess then
                            print("Scripts Hub X | Loading Complete for jumpscare user!")
                        else
                            showErrorNotification()
                        end
                    end)
                end)
            end)
        else
            showErrorNotification()
        end
        
    elseif userStatus == "platoboost_whitelisted" or userStatus == "premium" then
        print("Platoboost whitelisted or premium user detected, skipping key system")
        local loadingSuccess, LoadingScreen = loadLoadingScreen()
        if loadingSuccess and LoadingScreen then
            pcall(function()
                LoadingScreen.initialize()
                LoadingScreen.setLoadingText(userStatus == "premium" and "Premium User Verified" or "Platoboost Whitelisted", Color3.fromRGB(0, 150, 0))
                wait(2)
                LoadingScreen.setLoadingText("Loading game...", Color3.fromRGB(150, 180, 200))
                LoadingScreen.animateLoadingBar(function()
                    LoadingScreen.playExitAnimations(function()
                        local scriptLoadedSuccess, scriptLoaded = loadGameScript(scriptUrl)
                        if scriptLoadedSuccess then
                            print("Scripts Hub X | Loading Complete for " .. userStatus .. " user!")
                        else
                            showErrorNotification()
                        end
                    end)
                end)
            end)
        else
            local scriptLoadedSuccess, scriptLoaded = loadGameScript(scriptUrl)
            if scriptLoadedSuccess then
                print("Scripts Hub X | Loading Complete for " .. userStatus .. " user!")
            else
                showErrorNotification()
            end
        end
        
    else
        print("Non-premium user, checking for stored key first")
        
        -- Check stored key first
        if checkStoredKey() then
            print("Valid stored key found, loading game directly")
            local loadingSuccess, LoadingScreen = loadLoadingScreen()
            if loadingSuccess and LoadingScreen then
                pcall(function()
                    LoadingScreen.initialize()
                    LoadingScreen.setLoadingText("Key Verified (Cached)", Color3.fromRGB(0, 150, 0))
                    wait(2)
                    LoadingScreen.setLoadingText("Loading game...", Color3.fromRGB(150, 180, 200))
                    LoadingScreen.animateLoadingBar(function()
                        LoadingScreen.playExitAnimations(function()
                            local scriptLoadedSuccess, scriptLoaded = loadGameScript(scriptUrl)
                            if scriptLoadedSuccess then
                                print("Scripts Hub X | Loading Complete for cached key user!")
                            else
                                showErrorNotification()
                            end
                        end)
                    end)
                end)
            else
                local scriptLoadedSuccess, scriptLoaded = loadGameScript(scriptUrl)
                if scriptLoadedSuccess then
                    print("Scripts Hub X | Loading Complete for cached key user!")
                else
                    showErrorNotification()
                end
            end
        else
            print("No valid stored key, loading key system")
            local keySystemSuccess, KeySystem = loadKeySystem()
            local loadingSuccess, LoadingScreen = loadLoadingScreen()
            
            if not keySystemSuccess or not KeySystem then
                print("Failed to load key system")
                if loadingSuccess and LoadingScreen then
                    pcall(function()
                        LoadingScreen.initialize()
                        LoadingScreen.setLoadingText("Failed to load key system", Color3.fromRGB(245, 100, 100))
                        wait(3)
                        LoadingScreen.playExitAnimations()
                    end)
                end
                showErrorNotification()
                return
            end
            
            local keyVerified = false
            pcall(function()
                print("Showing key system UI")
                KeySystem.ShowKeySystem()
                print("Waiting for key verification")
                local startTime = tick()
                while not KeySystem.IsKeyVerified() do
                    wait(0.1)
                    if tick() - startTime > 300 then -- 5 minutes timeout
                        warn("Key verification timed out")
                        KeySystem.HideKeySystem()
                        if loadingSuccess and LoadingScreen then
                            pcall(function()
                                LoadingScreen.initialize()
                                LoadingScreen.setLoadingText("Key verification timed out", Color3.fromRGB(245, 100, 100))
                                wait(3)
                                LoadingScreen.playExitAnimations()
                            end)
                        end
                        break
                    end
                end
                keyVerified = KeySystem.IsKeyVerified()
                if keyVerified then
                    KeySystem.HideKeySystem()
                    local key = KeySystem.GetKey()
                    if key and key ~= "" then
                        saveKeyToFile(key)
                        print("Key saved after verification")
                    end
                    if loadingSuccess and LoadingScreen then
                        pcall(function()
                            LoadingScreen.initialize()
                            LoadingScreen.setLoadingText("Key Verified", Color3.fromRGB(0, 150, 0))
                            wait(2)
                            LoadingScreen.setLoadingText("Loading game...", Color3.fromRGB(150, 180, 200))
                            LoadingScreen.animateLoadingBar(function()
                                LoadingScreen.playExitAnimations(function()
                                    local scriptLoadedSuccess, scriptLoaded = loadGameScript(scriptUrl)
                                    if scriptLoadedSuccess then
                                        print("Scripts Hub X | Loading Complete for non-premium user!")
                                    else
                                        showErrorNotification()
                                    end
                                end)
                            end)
                        end)
                    else
                        local scriptLoadedSuccess, scriptLoaded = loadGameScript(scriptUrl)
                        if scriptLoadedSuccess then
                            print("Scripts Hub X | Loading Complete for non-premium user!")
                        else
                            showErrorNotification()
                        end
                    end
                else
                    if loadingSuccess and LoadingScreen then
                        pcall(function()
                            LoadingScreen.initialize()
                            LoadingScreen.setLoadingText("Key verification failed or timed out", Color3.fromRGB(245, 100, 100))
                            wait(3)
                            LoadingScreen.playExitAnimations()
                        end)
                    end
                end
            end)
            
            if not keyVerified then
                deleteKeyFile()
            end
        end
    end
    
    -- Final UI detection and error handling
    detectAndHandleUIErrors()
end)()
