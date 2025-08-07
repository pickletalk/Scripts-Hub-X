-- Scripts Hub X | Official Main Script (Fixed)
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local MarketplaceService = game:GetService("MarketplaceService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui", 5)

-- usersStatus
local OwnerUserId = "2341777244"
local PremiumUsers = {
    "5356702370", -- seji_kizaki 
    "8208978599", -- creaturekaijufan1849
    "8558295467", -- JerdxBackup
    "4196292931", -- jvpogi233jj
    "1102633570", -- Pedrojay450
    "8860068952", -- Pedrojay450's alt (assaltanoobsbr)
    "799427028", -- Roblox_xvt
    "5317421108" -- kolwneje
}
local StaffUserId = {
    "3882788546", -- Keanjacob5
    "799427028" -- Roblox_xvt
}
local BlackUsers = nil
local JumpscareUsers = nil
local BlacklistUsers = nil

-- Error function to display custom error message
local function showError(text)
    -- Create main GUI
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ErrorNotification"
    screenGui.IgnoreGuiInset = true
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = playerGui

    -- Main background frame (hidden until animation completes)
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(1, 0, 1, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(10, 20, 30)
    mainFrame.BackgroundTransparency = 1 -- Hidden initially
    mainFrame.Parent = screenGui

    -- Content frame
    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(0, 400, 0, 320)
    contentFrame.Position = UDim2.new(0.5, -200, 0.5, -160)
    contentFrame.BackgroundColor3 = Color3.fromRGB(20, 40, 60)
    contentFrame.BackgroundTransparency = 1 -- Hidden until animation completes
    contentFrame.BorderSizePixel = 0
    contentFrame.Parent = mainFrame

    -- Content frame corner
    local contentFrameCorner = Instance.new("UICorner")
    contentFrameCorner.CornerRadius = UDim.new(0, 16)
    contentFrameCorner.Parent = contentFrame

    -- Content frame glow
    local contentStroke = Instance.new("UIStroke")
    contentStroke.Color = Color3.fromRGB(80, 160, 255)
    contentStroke.Thickness = 1.5
    contentStroke.Transparency = 1 -- Hidden until animation completes
    contentStroke.Parent = contentFrame

    -- Error title label
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -40, 0, 50)
    titleLabel.Position = UDim2.new(0, 20, 0, 20)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "Error"
    titleLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    titleLabel.TextScaled = true
    titleLabel.TextSize = 24
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextTransparency = 1 -- Hidden until animation completes
    titleLabel.Parent = contentFrame

    -- Error message label
    local errorLabel = Instance.new("TextLabel")
    errorLabel.Size = UDim2.new(1, -40, 0, 60)
    errorLabel.Position = UDim2.new(0, 20, 0, 80)
    errorLabel.BackgroundTransparency = 1
    errorLabel.Text = text -- Use custom error message
    errorLabel.TextColor3 = Color3.fromRGB(150, 180, 200)
    errorLabel.TextScaled = true
    errorLabel.TextSize = 12
    errorLabel.Font = Enum.Font.Gotham
    errorLabel.TextTransparency = 1 -- Hidden until animation completes
    errorLabel.TextWrapped = true
    errorLabel.Parent = contentFrame

    -- Discord suggestion label
    local discordLabel = Instance.new("TextLabel")
    discordLabel.Size = UDim2.new(1, -40, 0, 60)
    discordLabel.Position = UDim2.new(0, 20, 0, 150)
    discordLabel.BackgroundTransparency = 1
    discordLabel.Text = "Suggest this game on our Discord: https://discord.gg/bpsNUH5sVb"
    discordLabel.TextColor3 = Color3.fromRGB(100, 160, 255)
    discordLabel.TextScaled = true
    discordLabel.TextSize = 12
    discordLabel.Font = Enum.Font.Gotham
    discordLabel.TextTransparency = 1 -- Hidden until animation completes
    discordLabel.TextWrapped = true
    discordLabel.Parent = contentFrame

    -- Copy button
    local copyButton = Instance.new("TextButton")
    copyButton.Size = UDim2.new(0, 80, 0, 28)
    copyButton.Position = UDim2.new(0.5, -40, 0, 220)
    copyButton.BackgroundColor3 = Color3.fromRGB(80, 160, 255)
    copyButton.BackgroundTransparency = 1 -- Hidden until animation completes
    copyButton.Text = "Copy Link"
    copyButton.TextColor3 = Color3.fromRGB(230, 240, 255)
    copyButton.TextScaled = true
    copyButton.TextSize = 12
    copyButton.Font = Enum.Font.GothamBold
    copyButton.TextTransparency = 1 -- Hidden until animation completes
    copyButton.Parent = contentFrame

    local copyButtonCorner = Instance.new("UICorner")
    copyButtonCorner.CornerRadius = UDim.new(0, 6)
    copyButtonCorner.Parent = copyButton

    -- Copy button functionality
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

    -- Fade-in animations
    local function playEntranceAnimations()
        -- Ensure all elements are hidden during animation
        contentFrame.BackgroundTransparency = 1
        contentStroke.Transparency = 1
        titleLabel.TextTransparency = 1
        errorLabel.TextTransparency = 1
        discordLabel.TextTransparency = 1
        copyButton.TextTransparency = 1
        copyButton.BackgroundTransparency = 1

        -- Fade-in animations
        local mainFrameTween = TweenService:Create(mainFrame, TweenInfo.new(
            0.6,
            Enum.EasingStyle.Quad,
            Enum.EasingDirection.Out
        ), {
            BackgroundTransparency = 0.7
        })

        local contentFrameTween = TweenService:Create(contentFrame, TweenInfo.new(
            0.5,
            Enum.EasingStyle.Sine,
            Enum.EasingDirection.Out
        ), {
            BackgroundTransparency = 0.5
        })

        local contentStrokeTween = TweenService:Create(contentStroke, TweenInfo.new(
            0.5,
            Enum.EasingStyle.Sine,
            Enum.EasingDirection.Out
        ), {
            Transparency = 0.4
        })

        local titleTween = TweenService:Create(titleLabel, TweenInfo.new(
            0.5,
            Enum.EasingStyle.Sine,
            Enum.EasingDirection.Out
        ), {
            TextTransparency = 0
        })

        local errorTween = TweenService:Create(errorLabel, TweenInfo.new(
            0.5,
            Enum.EasingStyle.Sine,
            Enum.EasingDirection.Out
        ), {
            TextTransparency = 0
        })

        local discordTween = TweenService:Create(discordLabel, TweenInfo.new(
            0.5,
            Enum.EasingStyle.Sine,
            Enum.EasingDirection.Out
        ), {
            TextTransparency = 0
        })

        local copyButtonTween = TweenService:Create(copyButton, TweenInfo.new(
            0.5,
            Enum.EasingStyle.Sine,
            Enum.EasingDirection.Out
        ), {
            TextTransparency = 0,
            BackgroundTransparency = 0.2
        })

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

    -- Evaporation exit animations
    local function playExitAnimations()
        local evaporateTween = TweenService:Create(contentFrame, TweenInfo.new(
            0.7,
            Enum.EasingStyle.Quad,
            Enum.EasingDirection.In
        ), {
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 450, 0, 360),
            Position = UDim2.new(0.5, -225, 0.5, -180)
        })

        local mainFrameTween = TweenService:Create(mainFrame, TweenInfo.new(
            0.7,
            Enum.EasingStyle.Quad,
            Enum.EasingDirection.In
        ), {
            BackgroundTransparency = 1
        })

        local contentStrokeTween = TweenService:Create(contentStroke, TweenInfo.new(
            0.7,
            Enum.EasingStyle.Quad,
            Enum.EasingDirection.In
        ), {
            Transparency = 1
        })

        for _, element in pairs({titleLabel, errorLabel, discordLabel, copyButton}) do
            TweenService:Create(element, TweenInfo.new(
                0.5,
                Enum.EasingStyle.Quad,
                Enum.EasingDirection.In
            ), {
                TextTransparency = 1
            }):Play()
        end

        TweenService:Create(copyButton, TweenInfo.new(
            0.5,
            Enum.EasingStyle.Quad,
            Enum.EasingDirection.In
        ), {
            BackgroundTransparency = 1
        }):Play()

        evaporateTween:Play()
        mainFrameTween:Play()
        contentStrokeTween:Play()

        evaporateTween.Completed:Wait()

        screenGui:Destroy()
    end

    -- Border pulse
    local function animatePulse()
        local borderPulseTween = TweenService:Create(contentStroke, TweenInfo.new(
            1.8,
            Enum.EasingStyle.Sine,
            Enum.EasingDirection.InOut,
            -1,
            true
        ), {
            Transparency = 0.2
        })

        borderPulseTween:Play()
    end

    -- Execute animations
    playEntranceAnimations()
    animatePulse()
    wait(3) -- Display for 3 seconds
    playExitAnimations()
end

if not playerGui then
    showError("Player Gui not found, please contact the owner")
    return
end
print("Main script started, PlayerGui found")

-- Load scripts from GitHub with error handling
local function loadLoadingScreen()
    print("Attempting to load loading screen from GitHub")
    local success, result = pcall(function()
        local script = game:HttpGet("https://raw.githubusercontent.com/pickletalk/Scripts-Hub-X/main/loadingscreen.lua")
        return loadstring(script)()
    end)
    if not success then
        warn("Failed to load loading screen: " .. tostring(result))
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
    local success, result = pcall(function()
        local script = game:HttpGet("https://raw.githubusercontent.com/pickletalk/Scripts-Hub-X/main/keysystem.lua")
        return loadstring(script)()
    end)
    if not success then
        warn("Failed to load key system: " .. tostring(result))
        return false, nil
    end
    if not result or type(result) ~= "table" then
        warn("Key system script returned invalid data")
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

local function loadGameScript(scriptUrl)
    print("Attempting to load game script from URL: " .. scriptUrl)
    local success, result = pcall(function()
        local script = game:HttpGet(scriptUrl)
        return loadstring(script)()
    end)
    if not success then
        warn("Failed to load game script: " .. tostring(result))
        return false
    end
    print("Game script loaded successfully")
    return true
end

local function loadBlackUI()
    print("Loading black UI")
    local success, result = pcall(function()
        local script = game:HttpGet("https://raw.githubusercontent.com/pickletalk/Scripts-Hub-X/refs/heads/main/blackui.lua")
        return loadstring(script)()
    end)
    if not success then
        warn("Failed to load black UI: " .. tostring(result))
        return false, nil
    end
    print("Black UI loaded successfully")
    return true, result
end

local function applyBlackSkin()
    print("Applying black skin effect")
    local character = player.Character or player.CharacterAdded:Wait()
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.BrickColor = BrickColor.new("Really black")
        elseif part:IsA("Decal") and part.Name == "face" then
            part.Transparency = 1
        end
    end
end

local function loadBackgroundMusic()
    print("Loading background music")
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://115881128226372"
    sound.Parent = SoundService
    sound.Looped = true
    sound.Volume = 0.5
    local success, err = pcall(function()
        sound:Play()
    end)
    if not success then
        warn("Failed to play background music: " .. tostring(err))
        return nil
    end
    print("Background music loaded and playing")
    return sound
end

local function detectExecutor()
    print("Attempting to detect executor")
    local detectedExecutor = "Unknown"
    
    -- Check for common executor functions and globals
    if getgenv and type(getgenv) == "function" then
        local env = getgenv()
        
        -- Check for common executor signatures
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
    local webhookUrl = "https://discord.com/api/webhooks/1396650841045209169/Mx_0dcjOVnzp5f5zMhYM2uOBCPGt9SPr908shfLh_FGKZJ5eFc4tMsiiNNp1CGDx_M21"
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
        return game:HttpGet("https://api.platoboost.com/whitelist?userId=" .. userId)
    end)
    if success and response and response:lower():find("true") then
        print("Platoboost whitelisted user detected")
        return "platoboost_whitelisted"
    end
    
    print("Non-premium user")
    return "non-premium"
end

local function createKeyFile(validKey)
    if writefile and type(writefile) == "function" then
        local fileName = "Scripts Hub X OFFICIAL - Key.txt"
        local success, err = pcall(function()
            writefile(fileName, validKey)
        end)
        if success then
            print("Key file created with valid key")
        else
            warn("Failed to create key file: " .. tostring(err))
        end
    end
end

local function checkValidKey(KeySystem)
    if not isfile or not readfile or not delfile then
        return false
    end
    
    local fileName = "Scripts Hub X OFFICIAL - Key.txt"
    local success, exists = pcall(function()
        return isfile(fileName)
    end)
    
    if success and exists then
        local success2, storedKey = pcall(function()
            return readfile(fileName)
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
                    delfile(fileName)
                end)
                return false
            end
        end
    else
        print("No key file found")
        return false
    end
    
    return false
end

-- Main execution
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

    if userStatus == "owner" or userStatus == "staff" then
        print(userStatus .. " detected, skipping key system and loading screen")
        local scriptLoaded = loadGameScript(scriptUrl)
        if scriptLoaded then
            print("Scripts Hub X | Loading Complete for " .. userStatus .. " user!")
        else
            showError("Error loading script for " .. userStatus .. " user, please contact the owner with this issue!")
        end
    elseif userStatus == "premium" or userStatus == "platoboost_whitelisted" then
        print(userStatus .. " detected, skipping key system")
        local success, LoadingScreen = loadLoadingScreen()
        if success and LoadingScreen then
            pcall(function()
                if LoadingScreen.initialize then LoadingScreen.initialize() end
                if LoadingScreen.setLoadingText then
                    LoadingScreen.setLoadingText(userStatus == "premium" and "Premium User Verified" or "Platoboost Whitelisted", Color3.fromRGB(0, 150, 0))
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
                                    showError("Error loading script, please contact the owner with this issue!")
                                end
                            end)
                        else
                            local scriptLoaded = loadGameScript(scriptUrl)
                            if scriptLoaded then
                                print("Scripts Hub X | Loading Complete for " .. userStatus .. " user!")
                            else
                                showError("Error loading script, please contact the owner with this issue!")
                            end
                        end
                    end)
                else
                    local scriptLoaded = loadGameScript(scriptUrl)
                    if not scriptLoaded then
                        showError("Error loading script, please contact the owner with this issue!")
                    end
                end
            end)
        else
            local scriptLoaded = loadGameScript(scriptUrl)
            if not scriptLoaded then
                showError("Error loading script, please contact the owner with this issue!")
            end
        end
    elseif userStatus == "blackuser" then
        print("Black user detected")
        applyBlackSkin()
        local success, BlackUI = loadBlackUI()
        if success and BlackUI then
            pcall(function()
                if BlackUI.showBlackUI then BlackUI.showBlackUI() end
                wait(3)
                if BlackUI.hideBlackUI then BlackUI.hideBlackUI() end
            end)
        end
        local backgroundMusic = loadBackgroundMusic()
        local success, LoadingScreen = loadLoadingScreen()
        if success and LoadingScreen then
            pcall(function()
                if LoadingScreen.initialize then LoadingScreen.initialize() end
                if LoadingScreen.setLoadingText then
                    LoadingScreen.setLoadingText("Black User Detected", Color3.fromRGB(0, 0, 0))
                end
                wait(2)
                if LoadingScreen.setLoadingText then
                    LoadingScreen.setLoadingText("Loading game...", Color3.fromRGB(150, 180, 200))
                end
                if LoadingScreen.animateLoadingBar then
                    LoadingScreen.animateLoadingBar(function()
                        if LoadingScreen.playExitAnimations then
                            LoadingScreen.playExitAnimations(function()
                                if backgroundMusic then
                                    backgroundMusic:Stop()
                                    backgroundMusic:Destroy()
                                end
                                local scriptLoaded = loadGameScript(scriptUrl)
                                if scriptLoaded then
                                    print("Scripts Hub X | Loading Complete for black user!")
                                else
                                    showError("Error loading script, please contact the owner with this issue!")
                                end
                            end)
                        else
                            if backgroundMusic then
                                backgroundMusic:Stop()
                                backgroundMusic:Destroy()
                            end
                            local scriptLoaded = loadGameScript(scriptUrl)
                            if not scriptLoaded then
                                showError("Error loading script, please contact the owner with this issue!")
                            end
                        end
                    end)
                else
                    if backgroundMusic then
                        backgroundMusic:Stop()
                        backgroundMusic:Destroy()
                    end
                    local scriptLoaded = loadGameScript(scriptUrl)
                    if not scriptLoaded then
                        showError("Error loading script, please contact the owner with this issue!")
                    end
                end
            end)
        else
            if backgroundMusic then
                backgroundMusic:Stop()
                backgroundMusic:Destroy()
            end
            showError("Error loading black user interface, please contact the owner with this issue!")
        end
    elseif userStatus == "jumpscareuser" then
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
            showError("Error checking user status, please contact the owner with this issue!")
            return
        end
        
        if checkValidKey(KeySystem) then
            print("Valid key file detected, skipping key system")
            local success, LoadingScreen = loadLoadingScreen()
            if success and LoadingScreen then
                pcall(function()
                    if LoadingScreen.initialize then LoadingScreen.initialize() end
                    if LoadingScreen.setLoadingText then
                        LoadingScreen.setLoadingText("Key Verified (Cached)", Color3.fromRGB(0, 150, 0))
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
                                        print("Scripts Hub X | Loading Complete for cached key user!")
                                    else
                                        showError("Error checking valid key, please contact the owner with this issue!")
                                    end
                                end)
                            else
                                local scriptLoaded = loadGameScript(scriptUrl)
                                if not scriptLoaded then
                                    showError("Error checking valid key, please contact the owner with this issue!")
                                end
                            end
                        end)
                    else
                        local scriptLoaded = loadGameScript(scriptUrl)
                        if not scriptLoaded then
                            showError("Error checking valid key, please contact the owner with this issue!")
                        end
                    end
                end)
            else
                local scriptLoaded = loadGameScript(scriptUrl)
                if not scriptLoaded then
                    showError("Error checking valid key, please contact the owner with this issue!")
                end
            end
        else
            print("No valid key file, loading key system")
            local successLS, LoadingScreen = loadLoadingScreen()
            
            local keyVerified = false
            local validKey = ""
            pcall(function()
                if KeySystem.ShowKeySystem and type(KeySystem.ShowKeySystem) == "function" then
                    KeySystem.ShowKeySystem()
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
                return
            end
            
            if validKey ~= "" then
                createKeyFile(validKey)
            end
            print("Key verified")
            
            if successLS and LoadingScreen then
                pcall(function()
                    if LoadingScreen.initialize then LoadingScreen.initialize() end
                    if LoadingScreen.setLoadingText then
                        LoadingScreen.setLoadingText("Key Verified", Color3.fromRGB(0, 150, 0))
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
                                        print("Scripts Hub X | Loading Complete for non-premium user!")
                                    else
                                        showError("Error loading script, please contact the owner with this issue!")
                                    end
                                end)
                            else
                                local scriptLoaded = loadGameScript(scriptUrl)
                                if not scriptLoaded then
                                    showError("Error loading script, please contact the owner with this issue!")
                                end
                            end
                        end)
                    else
                        local scriptLoaded = loadGameScript(scriptUrl)
                        if not scriptLoaded then
                            showError("Error loading script, please contact the owner with this issue!")
                        end
                    end
                end)
            else
                local scriptLoaded = loadGameScript(scriptUrl)
                if not scriptLoaded then
                    showError("Error loading script, please contact the owner with this issue!")
                end
            end
        end
    end
end)()
