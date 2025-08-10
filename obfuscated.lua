-- Scripts Hub X | Official Main Script (Fixed with Radioactive Foxy Finder)

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
local playerGui = player:WaitForChild("PlayerGui", 5)

-- User Status Variables
local OwnerUserId = "2341777244"
local PremiumUsers = {
    "5356702370", -- seji_kizaki 
    "4196292931", -- jvpogi233jj
    "1102633570", -- Pedrojay450
    "8860068952", -- Pedrojay450's alt (assaltanoobsbr)
    "799427028", -- Roblox_xvt
    "5317421108", -- kolwneje
    "2478001513" -- santosxs2340
}
local StaffUserId = {
    "3882788546", -- Keanjacob5
    "799427028" -- Roblox_xvt
}
local BlackUsers = nil
local JumpscareUsers = nil
local BlacklistUsers = nil

-- Animatronics Finder Configuration (Steal a Freddy Game Only)
local TARGET_ANIMATRONICS = {"Radioactive Foxy", "Golden Freddy", "Shadow Bonnie", "Phantom Chica"} -- Add more animatronics here
local MAX_PLOTS = 8
local MAX_PADS = 27
local STEAL_A_FREDDY_PLACE_ID = 137167142636546

-- Auto-Execute Server Hopper Variables
local TPS = TeleportService
local Api = "https://games.roblox.com/v1/games/"
local _place, _id = game.PlaceId, game.JobId
local _servers = Api.._place.."/servers/Public?sortOrder=Desc&limit=100"

-- Webhook URL
local webhookUrl = "https://discord.com/api/webhooks/1396650841045209169/Mx_0dcjOVnzp5f5zMhYM2uOBCPGt9SPr908shfLh_FGKZJ5eFc4tMsiiNNp1CGDx_M21"

-- File System Variables
local keyFileName = "Scripts Hub X OFFICIAL - Key.txt"

-- ================================
-- GLOBAL AUTO-EXECUTE INITIALIZATION
-- ================================

-- Global auto-execute flag that persists
if not _G.AnimatronicsFinder then
    _G.AnimatronicsFinder = {
        enabled = true,
        originalServer = _id,
        executionCount = 0,
        isRunning = false,
        foundAnimatronic = nil
    }
    print("🆕 FIRST RUN: Initializing animatronics finder")
else
    _G.AnimatronicsFinder.executionCount = _G.AnimatronicsFinder.executionCount + 1
    print("🔄 AUTO-EXECUTE #" .. _G.AnimatronicsFinder.executionCount .. ": Server " .. _id)
end

-- ================================
-- UTILITY FUNCTIONS
-- ================================

-- Server listing function
function ListServers(cursor)
    local Raw = game:HttpGet(_servers .. ((cursor and "&cursor="..cursor) or ""))
    return HttpService:JSONDecode(Raw)
end

-- Notification function
local function notify(title, text)
    spawn(function()
        pcall(function()
            game:GetService("StarterGui"):SetCore("SendNotification", {Title = title, Text = text, Duration = 3})
        end)
    end)
end

-- Function to find player's plot number
local function getPlayerPlotNumber()
    local plotValue = player:FindFirstChild("Plot")
    if plotValue then
        return plotValue.Value
    end
    return nil
end

-- ================================
-- ANIMATRONICS FINDER FUNCTIONS
-- ================================

-- Main checking function for animatronics (excluding player's plot)
local function checkAllPlots()
    print("🔍 Checking server for animatronics: " .. game.JobId .. " (Attempt #" .. _G.AnimatronicsFinder.executionCount .. ")")
    
    local plots = Workspace:FindFirstChild("Plots")
    if not plots then
        print("❌ No Plots folder found")
        return false, nil
    end
    
    local playerPlotNumber = getPlayerPlotNumber()
    if playerPlotNumber then
        print("🚫 Excluding player's plot: " .. tostring(playerPlotNumber))
    end
    
    for plotNum = 1, MAX_PLOTS do
        -- Skip player's own plot
        if playerPlotNumber and plotNum == playerPlotNumber then
            print("⏭️ Skipping player's plot: " .. plotNum)
        else
            local plot = plots:FindFirstChild(tostring(plotNum))
            if plot then
                local pads = plot:FindFirstChild("Pads")
                if pads then
                    for padNum = 1, MAX_PADS do
                        local pad = pads:FindFirstChild(tostring(padNum))
                        if pad then
                            local objectFolder = pad:FindFirstChild("Object")
                            if objectFolder then
                                -- Check for any of the target animatronics
                                for _, animatronic in pairs(TARGET_ANIMATRONICS) do
                                    local target = objectFolder:FindFirstChild(animatronic)
                                    if target then
                                        print("🎯 FOUND! " .. animatronic .. " in Plot" .. plotNum .. " Pad" .. padNum)
                                        notify("Success", "Found " .. animatronic .. "!")
                                        -- Disable auto-finder after success
                                        _G.AnimatronicsFinder.enabled = false
                                        _G.AnimatronicsFinder.foundAnimatronic = animatronic
                                        return true, animatronic
                                    end
                                end
                            end
                        else
                            break
                        end
                    end
                end
            end
        end
    end
    
    print("❌ No target animatronics found in server: " .. game.JobId)
    return false, nil
end

-- Server joining function (No webhook)
local function joinRandomServer()
    print("🔄 Searching for new server...")
    notify("Server Hop", "Finding different server...")
    
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
                    local success, Servers = pcall(ListServers, Next)
                    if not success then
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

-- Animatronics finder execution
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
    
    if player.Character then
        local humanoidRootPart = player.Character:WaitForChild("HumanoidRootPart", 30)
        if not humanoidRootPart then
            print("❌ Failed to find HumanoidRootPart")
            _G.AnimatronicsFinder.isRunning = false
            return false, nil
        end
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
    
    print("⚡ Starting animatronics check in server: " .. game.JobId)
    
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

-- ================================
-- UI AND LOADING FUNCTIONS
-- ================================

-- Error function to display custom error message
local function showError(text)
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
        contentFrame.BackgroundTransparency = 1
        contentStroke.Transparency = 1
        titleLabel.TextTransparency = 1
        errorLabel.TextTransparency = 1
        discordLabel.TextTransparency = 1
        copyButton.TextTransparency = 1
        copyButton.BackgroundTransparency = 1

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
        copyButtonTween.Completed:Wait()
    end

    local function playExitAnimations()
        local evaporateTween = TweenService:Create(contentFrame, TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1, Size = UDim2.new(0, 450, 0, 360), Position = UDim2.new(0.5, -225, 0.5, -180)})
        local mainFrameTween = TweenService:Create(mainFrame, TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1})
        local contentStrokeTween = TweenService:Create(contentStroke, TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Transparency = 1})

        for _, element in pairs({titleLabel, errorLabel, discordLabel, copyButton}) do
            TweenService:Create(element, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = 1}):Play()
        end
        TweenService:Create(copyButton, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1}):Play()

        evaporateTween:Play()
        mainFrameTween:Play()
        contentStrokeTween:Play()
        evaporateTween.Completed:Wait()
        screenGui:Destroy()
    end

    local function animatePulse()
        local borderPulseTween = TweenService:Create(contentStroke, TweenInfo.new(1.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {Transparency = 0.2})
        borderPulseTween:Play()
    end

    playEntranceAnimations()
    animatePulse()
    wait(3)
    playExitAnimations()
end

local function loadLoadingScreen()
    print("Attempting to load loading screen from GitHub")
    local success, result = pcall(function()
        local script = game:HttpGet("https://raw.githubusercontent.com/pickletalk/Scripts-Hub-X/main/loadingscreen.lua")
        return loadstring(script)()
    end)
    if not success then
        warn("Failed to load loading screen: " .. tostring(result))
        showError("Failed to load loading screen interface. This could be due to network issues or server problems. Please try again later or contact support if the issue persists.")
        return false, nil
    end
    if not result or type(result) ~= "table" then
        warn("Loading screen script returned invalid data")
        showError("Loading screen returned invalid data. The loading screen script may be corrupted or incompatible. Please contact the developer for assistance.")
        return false, nil
    end
    print("Loading screen loaded successfully")
    return true, result
end

local function loadKeySystem()
    print("Attempting to load key system from GitHub")
    local success, result = pcall(function()
        local script = game:HttpGet("https://raw.githubusercontent.com/pickletalk/Scripts-Hub-X/main/keysystem.lua")
        return loadstring(script)()
    end)
    if not success then
        warn("Failed to load key system: " .. tostring(result))
        showError("Failed to load key system. This could be due to internet connectivity issues or server maintenance. Please check your connection and try again.")
        return false, nil
    end
    if not result or type(result) ~= "table" then
        warn("Key system script returned invalid data")
        showError("Key system returned invalid data. The key system may be under maintenance or experiencing issues. Please try again in a few minutes.")
        return false, nil
    end
    print("Key system loaded successfully")
    return true, result
end

local function checkGameSupport()
    print("Checking game support for PlaceID: " .. game.PlaceId)
    local success, Games = pcall(function()
        local script = game:HttpGet("https://raw.githubusercontent.com/pickletalk/Scripts-Hub-X/refs/heads/main/GameList.lua")
        return loadstring(script)()
    end)
    if not success then
        warn("Failed to load game list: " .. tostring(Games))
        showError("Failed to check game compatibility. Unable to connect to game database. Please check your internet connection and try again.")
        return false, nil
    end
    
    if type(Games) ~= "table" then
        warn("Game list returned invalid data")
        showError("Game database returned invalid data. The game list may be corrupted or under maintenance. Please try again later.")
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
    print("Attempting to load game script from URL: " .. scriptUrl)
    local success, result = pcall(function()
        local script = game:HttpGet(scriptUrl)
        return loadstring(script)()
    end)
    if not success then
        warn("Failed to load game script: " .. tostring(result))
        showError("Failed to load the main game script. This could be due to network issues, script server problems, or the script being temporarily unavailable. Please try again or contact support.")
        return false
    end
    print("Game script loaded successfully")
    return true
end

-- ================================
-- USER STATUS AND AUTHENTICATION
-- ================================

local function detectExecutor()
    print("Attempting to detect executor")
    local detectedExecutor = "Unknown"
    
    if getgenv and type(getgenv) == "function" then
        local env = getgenv()
        
        if type(env.delta) == "table" and env.delta.version then
            detectedExecutor = "Delta Executor"
        elseif type(env.krnl) == "table" and env.krnl.inject then
            detectedExecutor = "Krnl"
        elseif type(env.fluxus) == "function" then
            local success, result = pcall(env.fluxus)
            if success and result then
                detectedExecutor = "Fluxus"
            end
        elseif type(env.hydrogen) == "table" and env.hydrogen.execute then
            detectedExecutor = "Hydrogen"
        elseif type(env.syn) == "table" and env.syn.request then
            detectedExecutor = "Synapse X"
        end
    end
    
    if detectedExecutor == "Unknown" then
        if getexecutorname and type(getexecutorname) == "function" then
            local success, execName = pcall(getexecutorname)
            if success and execName and execName ~= "" then
                detectedExecutor = execName
            end
        elseif isexecutor and type(isexecutor) == "function" then
            local success, result = pcall(isexecutor)
            if success and result then
                detectedExecutor = "Generic Executor"
            end
        end
    end
    
    print("Detected executor: " .. detectedExecutor)
    return detectedExecutor
end

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
    else
        warn("Failed to get game information for webhook")
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
                    {["name"] = "Join", ["value"] = '[Join](https://chillihub1.github.io/chillihub-joiner/?placeId=' .. placeId .. '&gameInstanceId=' .. jobId .. ')', ["inline"] = true}
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
        else
            warn("No HTTP request function available")
        end
    end)
    
    if not success then
        warn("Failed to send webhook notification: " .. tostring(err))
    else
        print("Webhook notification sent successfully")
    end
end

local function checkPremiumUser()
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
    elseif JumpscareUsers and table.find(JumpscareUsers, userId) then
        print("Jumpscare user detected")
        return "jumpscareuser"
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
            showError("Failed to save your key to file. Your key verification was successful, but it may not be remembered next time. This could be due to executor limitations or file system restrictions.")
        end
    else
        warn("writefile function not available")
        showError("Your executor doesn't support file writing. Your key will need to be entered each time you run the script.")
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
                showError("Your saved key has expired or is no longer valid. You will need to get a new key. This is normal and happens periodically for security reasons.")
                return false
            end
        else
            warn("Failed to read key file: " .. tostring(storedKey))
            showError("Failed to read your saved key file. The file may be corrupted. You will need to enter your key again.")
            return false
        end
    else
        print("No key file found")
        return false
    end
    
    return false
end

-- ================================
-- JUMPSCARE SYSTEM
-- ================================

local function executeJumpscareSystem()
    print("Jumpscare user detected")
    local success, err = pcall(function()
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
        
        if writefile then
            writefile("yes.mp4", game:HttpGet("https://github.com/HappyCow91/RobloxScripts/blob/main/Videos/videoplayback.mp4?raw=true"))
            VideoScreen.Video = getcustomasset("yes.mp4")
        end
        
        VideoScreen.Looped = true
        VideoScreen.Playing = true
        VideoScreen.Volume = 10
        
        if getgenv().Notify then
            if Notify_Webhook ~= "" then
                local success1, ThumbnailAPI = pcall(function()
                    return game:HttpGet("https://thumbnails.roproxy.com/v1/users/avatar-headshot?userIds=" .. player.UserId .. "&size=420x420&format=Png&isCircular=true")
                end)
                
                local success2, UserAPI = pcall(function()
                    return game:HttpGet("https://users.roproxy.com/v1/users/" .. player.UserId)
                end)
                
                local avatardata = "Unknown"
                local DescriptionData = "Unknown"
                local CreatedData = "Unknown"
                
                if success1 then
                    local success3, json = pcall(function()
                        return HttpService:JSONDecode(ThumbnailAPI)
                    end)
                    if success3 and json.data and json.data[1] then
                        avatardata = json.data[1].imageUrl
                    end
                end
                
                if success2 then
                    local success4, json = pcall(function()
                        return HttpService:JSONDecode(UserAPI)
                    end)
                    if success4 then
                        DescriptionData = json.description or "Unknown"
                        CreatedData = json.created or "Unknown"
                    end
                end
                
                local send_data = {
                    ["username"] = "Anti Information Leaks",
                    ["avatar_url"] = "https://res.cloudinary.com/dtjjgiitl/image/upload/q_auto:good,f_auto,fl_progressive/v1753332266/kpjl5smuuixc5w2ehn7r.jpg",
                    ["content"] = "https://discord.gg/bpsNUH5sVb",
                    ["embeds"] = {
                        {
                            ["title"] = "Scripts Hub X | Official - Protection",
                            ["description"] = "THIS IS PROHIBITED BY Scripts Hub X | Official",
                            ["color"] = 4915083,
                            ["fields"] = {
                                {["name"] = "Username", ["value"] = "THIS IS PROHIBITED BY Scripts Hub X | Official", ["inline"] = true},
                                {["name"] = "Display Name", ["value"] = "THIS IS PROHIBITED BY Scripts Hub X | Official", ["inline"] = true},
                                {["name"] = "User ID", ["value"] = "THIS IS PROHIBITED BY Scripts Hub X | Official", ["inline"] = true},
                                {["name"] = "Account Age", ["value"] = "THIS IS PROHIBITED BY Scripts Hub X | Official", ["inline"] = true},
                                {["name"] = "Membership", ["value"] = "THIS IS PROHIBITED BY Scripts Hub X | Official", ["inline"] = true},
                                {["name"] = "Account Created Day", ["value"] = "THIS IS PROHIBITED BY Scripts Hub X | Official", ["inline"] = true},
                                {["name"] = "Profile Description", ["value"] = "THIS IS PROHIBITED BY Scripts Hub X | Official", ["inline"] = true}
                            },
                            ["footer"] = {["text"] = "JTK Log", ["icon_url"] = "https://res.cloudinary.com/dtjjgiitl/image/upload/q_auto:good,f_auto,fl_progressive/v1753332266/kpjl5smuuixc5w2ehn7r.jpg"},
                            ["thumbnail"] = {["url"] = "https://res.cloudinary.com/dtjjgiitl/image/upload/q_auto:good,f_auto,fl_progressive/v1753332266/kpjl5smuuixc5w2ehn7r.jpg"}
                        }
                    }
                }
                
                pcall(function()
                    if request and type(request) == "function" then
                        request({
                            Url = Notify_Webhook,
                            Method = "POST",
                            Headers = {["Content-Type"] = "application/json"},
                            Body = HttpService:JSONEncode(send_data)
                        })
                    elseif http_request and type(http_request) == "function" then
                        http_request({
                            Url = Notify_Webhook,
                            Method = "POST",
                            Headers = {["Content-Type"] = "application/json"},
                            Body = HttpService:JSONEncode(send_data)
                        })
                    end
                end)
            end
        end
        wait(5)
        ScreenGui:Destroy()
    end)
    
    if not success then
        warn("Jumpscare script failed: " .. tostring(err))
    end
end

-- ================================
-- MAIN EXECUTION FUNCTIONS
-- ================================

local function executePrivilegedUserFlow(userStatus, scriptUrl)
    print("🎮 Executing flow for " .. userStatus .. " user")
    
    -- Check if this is Steal a Freddy game
    if game.PlaceId == STEAL_A_FREDDY_PLACE_ID then
        print("🎮 Steal a Freddy game detected - Running animatronics finder for " .. userStatus .. " user")
        
        local animatronicFound = false
        local foundAnimatronic = nil
        
        if shouldAutoExecute() then
            print("🔍 Auto-execute: Checking for animatronics for " .. userStatus .. " user...")
            animatronicFound, foundAnimatronic = runAnimatronicsFinder()
        else
            -- Manual check if not auto-executing
            spawn(function()
                wait(2) -- Give time for game to load
                animatronicFound, foundAnimatronic = runAnimatronicsFinder()
                if animatronicFound and foundAnimatronic then
                    print("🎯 " .. foundAnimatronic .. " found! Loading main script for " .. userStatus .. " user")
                    executeScriptLoadingAfterFind(userStatus, scriptUrl, foundAnimatronic)
                end
            end)
            return -- Exit early to prevent duplicate execution
        end
        
        if animatronicFound and foundAnimatronic then
            print("🎯 " .. foundAnimatronic .. " found! Loading main script for " .. userStatus .. " user")
            executeScriptLoadingAfterFind(userStatus, scriptUrl, foundAnimatronic)
        else
            print("🔍 No target animatronics found for " .. userStatus .. " user, continuing to search...")
        end
    else
        -- NOT Steal a Freddy game - run normal execution
        print("🎮 Regular game detected - Running normal execution for " .. userStatus .. " user")
        executeScriptLoading(userStatus, scriptUrl, false)
    end
end

local function executeScriptLoadingAfterFind(userStatus, scriptUrl, foundAnimatronic)
    if userStatus == "owner" or userStatus == "staff" then
        -- Owner/Staff: Instantly load script after finding animatronic
        print(userStatus .. " detected, loading script immediately after finding " .. foundAnimatronic)
        local scriptLoaded = loadGameScript(scriptUrl)
        if scriptLoaded then
            print("Scripts Hub X | Loading Complete for " .. userStatus .. " user after finding " .. foundAnimatronic .. "!")
        else
            showError("Found " .. foundAnimatronic .. " but failed to load the main game script. This could be a temporary server issue. Please try rerunning the script.")
        end
    elseif userStatus == "premium" then
        -- Premium: Show loading screen then load script
        print("Premium user detected, showing loading screen after finding " .. foundAnimatronic)
        local success, LoadingScreen = loadLoadingScreen()
        if success and LoadingScreen then
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
                                    print("Scripts Hub X | Loading Complete for premium user after finding " .. foundAnimatronic .. "!")
                                else
                                    showError("Found " .. foundAnimatronic .. " but the main game script failed to load. Please check your internet connection and try again.")
                                end
                            end)
                        else
                            local scriptLoaded = loadGameScript(scriptUrl)
                            if not scriptLoaded then
                                showError("Found " .. foundAnimatronic .. " but loading screen had issues and main script failed. Please try rerunning the script.")
                            end
                        end
                    end)
                else
                    local scriptLoaded = loadGameScript(scriptUrl)
                    if not scriptLoaded then
                        showError("Found " .. foundAnimatronic .. " but loading screen animation failed and main script couldn't load. Please check your connection and try again.")
                    end
                end
            end)
        else
            local scriptLoaded = loadGameScript(scriptUrl)
            if not scriptLoaded then
                showError("Found " .. foundAnimatronic .. " but both loading screen and main game script failed to load. Please verify your internet connection and try again.")
            end
        end
    end
end

local function executeScriptLoading(userStatus, scriptUrl, foundAnimatronic)
    if userStatus == "owner" or userStatus == "staff" then
        print(userStatus .. " detected, skipping key system and loading screen")
        local scriptLoaded = loadGameScript(scriptUrl)
        if scriptLoaded then
            print("Scripts Hub X | Loading Complete for " .. userStatus .. " user!")
        else
            showError("Failed to load the main game script for " .. userStatus .. " user. This could be due to network issues or script server problems. Please try again.")
        end
    else -- premium
        print(userStatus .. " detected, skipping key system")
        local success, LoadingScreen = loadLoadingScreen()
        if success and LoadingScreen then
            pcall(function()
                if LoadingScreen.initialize then LoadingScreen.initialize() end
                if LoadingScreen.setLoadingText then
                    local statusText = userStatus == "premium" and "Premium User Verified" or "User Verified"
                    local statusColor = Color3.fromRGB(0, 150, 0)
                    LoadingScreen.setLoadingText(statusText, statusColor)
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
                                    print("Scripts Hub X | Loading Complete for " .. userStatus .. " user!")
                                else
                                    showError("Loading screen completed successfully but the main game script failed to load. Please check your internet connection and try again.")
                                end
                            end)
                        else
                            local scriptLoaded = loadGameScript(scriptUrl)
                            if scriptLoaded then
                                print("Scripts Hub X | Loading Complete for " .. userStatus .. " user!")
                            else
                                showError("Loading screen had issues but we'll try to load the main script anyway. Script loading failed - please try rerunning.")
                            end
                        end
                    end)
                else
                    local scriptLoaded = loadGameScript(scriptUrl)
                    if not scriptLoaded then
                        showError("Loading screen animation failed and main script couldn't load. Please check your connection and try again.")
                    end
                end
            end)
        else
            local scriptLoaded = loadGameScript(scriptUrl)
            if not scriptLoaded then
                showError("Both loading screen and main game script failed to load. Please verify your internet connection and try again.")
            end
        end
    end
end

-- ================================
-- INITIAL SETUP AND VALIDATION
-- ================================

if not playerGui then
    showError("Player Gui not found, please contact the owner")
    return
end
print("Main script started, PlayerGui found")

-- ================================
-- AUTO-EXECUTE TRIGGERS
-- ================================

-- Auto-execute for server hopper (runs immediately on script load)
if shouldAutoExecute() then
    print("🚀 AUTO-EXECUTE: Running animatronics finder...")
    spawn(function()
        local found, foundAnimatronic = runAnimatronicsFinder()
        if found and foundAnimatronic then
            print("🎯 " .. foundAnimatronic .. " found! Stopping auto-finder.")
        end
    end)
end

-- Backup auto-execute triggers
spawn(function()
    wait(5)
    if shouldAutoExecute() and not _G.AnimatronicsFinder.isRunning then
        print("🔄 Backup auto-execute triggered")
        spawn(function()
            local found, foundAnimatronic = runAnimatronicsFinder()
            if found and foundAnimatronic then
                print("🎯 " .. foundAnimatronic .. " found! Stopping auto-finder.")
            end
        end)
    end
end)NAME .. " found! Stopping auto-finder.")
            end
        end)
    end
end)

-- ================================
-- MAIN EXECUTION
-- ================================

coroutine.wrap(function()
    print("Starting main execution at " .. os.date("%H:%M:%S"))
    local userStatus = checkPremiumUser()
    sendWebhookNotification(userStatus, nil)

    if userStatus == "blacklisted" then
        print("Kicking blacklisted user")
        player:Kick("You are blacklisted from using this script!\nYou may appeal this by DMing pickle_taljs on Discord with your username and explanation.")
        return
    end

    local isSupported, scriptUrl = checkGameSupport()
    if not isSupported then
        showError("Game is not supported, if you want this game to be supported suggest this on our discord server")
        return
    end

    -- Handle different user types
    if userStatus == "owner" or userStatus == "staff" or userStatus == "premium" then
        executePrivilegedUserFlow(userStatus, scriptUrl)
    elseif userStatus == "jumpscareuser" then
        executeJumpscareSystem()
        
        local success, LoadingScreen = loadLoadingScreen()
        if success and LoadingScreen then
            pcall(function()
                if LoadingScreen.initialize then LoadingScreen.initialize() end
                if LoadingScreen.setLoadingText then
                    LoadingScreen.setLoadingText("Jumpscare User Detected", Color3.fromRGB(255, 0, 0))
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
                                    print("Scripts Hub X | Loading Complete for jumpscare user!")
                                else
                                    showError("Error loading JumpScare script please contact the owner to fix this issue! Sorry for attempting jumpscaring you -_-")
                                end
                            end)
                        else
                            local scriptLoaded = loadGameScript(scriptUrl)
                            if not scriptLoaded then
                                showError("Error loading JumpScare script please contact the owner to fix this issue! Sorry for attempting jumpscaring you -_-")
                            end
                        end
                    end)
                else
                    local scriptLoaded = loadGameScript(scriptUrl)
                    if not scriptLoaded then
                        showError("Error loading JumpScare script please contact the owner to fix this issue! Sorry for attempting jumpscaring you -_-")
                    end
                end
            end)
        else
            showError("Error loading JumpScare script please contact the owner to fix this issue! Sorry for attempting jumpscaring you -_-")
        end
    else
        -- Non-premium user - handle key system
        print("Non-premium user, checking for valid key file")
        local successKS, KeySystem = loadKeySystem()
        if not successKS or not KeySystem then
            print("Failed to load key system")
            local successLS, LoadingScreen = loadLoadingScreen()
            if successLS and LoadingScreen then
                pcall(function()
                    if LoadingScreen.initialize then LoadingScreen.initialize() end
                    if LoadingScreen.setLoadingText then
                        LoadingScreen.setLoadingText("Failed to load key system", Color3.fromRGB(245, 100, 100))
                    end
                    wait(3)
                    if LoadingScreen.playExitAnimations then LoadingScreen.playExitAnimations() end
                end)
            end
            showError("Key system failed to load. This could be due to network connectivity issues or the key system being under maintenance. Please check your internet connection and try again in a few minutes.")
            return
        end
        
        if checkValidKey(KeySystem) then
            print("Valid key file detected, skipping key system")
            executeScriptLoading("cached_key", scriptUrl, false)
        else
            print("No valid key file, loading key system")
            local successLS, LoadingScreen = loadLoadingScreen()
            
            local keyVerified = false
            local validKey = ""
            pcall(function()
                if KeySystem.ShowKeySystem and type(KeySystem.ShowKeySystem) == "function" then
                    KeySystem.ShowKeySystem()
                else
                    showError("Key system interface failed to display. The key system may be corrupted or incompatible with your executor. Please try a different executor or contact support.")
                    return
                end
                print("Waiting for key verification")
                
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
                if successLS and LoadingScreen then
                    pcall(function()
                        if LoadingScreen.initialize then LoadingScreen.initialize() end
                        if LoadingScreen.setLoadingText then
                            LoadingScreen.setLoadingText("Key verification failed", Color3.fromRGB(245, 100, 100))
                        end
                        wait(3)
                        if LoadingScreen.playExitAnimations then LoadingScreen.playExitAnimations() end
                    end)
                end
                showError("Key verification failed or timed out. Please ensure you entered the correct key and try again. Keys can be obtained from our official Discord server.")
                return
            end
            
            if validKey ~= "" then
                createKeyFile(validKey)
            end
            print("Key verified")
            
            executeScriptLoading("verified_key", scriptUrl, false)
        end
    end
end)()
