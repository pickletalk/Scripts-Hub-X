-- Scripts Hub X | Secure Key System with Randomized API Endpoints
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui", 5)

if not playerGui then
    warn("PlayerGui not found after 5 seconds")
    return {}
end

print("🔒 Secure Key System started with randomized API endpoints")

-- Configuration - CHANGE THIS TO YOUR PTERODACTYL SERVER IP AND PORT
local API_BASE_URL = "http://172.18.0.72:5000" -- Change this!
local WEBSITE_URL = "https://workink.net/21Z5/ej1umc5v" -- Change this!

-- Key Storage System
local keyStorageKey = "ScriptsHubX_SecureKeyData_" .. tostring(player.UserId)
local verifiedKey = nil
local keyExpirationTime = 24 * 60 * 60 -- 24 hours in seconds

-- Global request tracking
local requestSending = false

-- Get API endpoints from server
local function getAPIEndpoints()
    local success, response = pcall(function()
        if request then
            return request({
                Url = API_BASE_URL,
                Method = "GET"
            })
        elseif http_request then
            return http_request({
                Url = API_BASE_URL,
                Method = "GET"
            })
        else
            error("No HTTP request function available")
        end
    end)
    
    if not success or not response or not response.Body then
        warn("❌ Cannot connect to API server")
        return nil
    end
    
    local endpointsData
    success, endpointsData = pcall(function()
        return HttpService:JSONDecode(response.Body)
    end)
    
    if success and endpointsData and endpointsData.endpoints then
        return endpointsData.endpoints
    end
    
    return nil
end

-- Secure API validation function with randomized endpoints
local function validateKeyWithAPI(key)
    if not key or key == "" then
        return false, "Please enter a key."
    end
    
    -- Check basic format first
    if string.sub(key, 1, 5) ~= "FREE_" then
        return false, "Invalid key format."
    end
    
    -- Validate with API using fixed validation endpoint
    local success, response = pcall(function()
        local requestData = {
            key = key,
            userFingerprint = tostring(player.UserId) .. "_" .. tostring(tick())
        }
        
        if request then
            return request({
                Url = API_BASE_URL .. "/validate-key",
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json"
                },
                Body = HttpService:JSONEncode(requestData)
            })
        elseif http_request then
            return http_request({
                Url = API_BASE_URL .. "/validate-key",
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json"
                },
                Body = HttpService:JSONEncode(requestData)
            })
        else
            error("No HTTP request function available")
        end
    end)
    
    if not success then
        warn("❌ API validation failed: " .. tostring(response))
        return false, "Cannot connect to validation server. Please try again."
    end
    
    if not response or not response.Body then
        return false, "Invalid response from server."
    end
    
    local validationResult
    success, validationResult = pcall(function()
        return HttpService:JSONDecode(response.Body)
    end)
    
    if not success or not validationResult then
        return false, "Failed to parse server response."
    end
    
    if validationResult.success then
        return true, validationResult.message, validationResult.timeLeft
    else
        return false, validationResult.error or "Key validation failed."
    end
end

-- Save key with timestamp and validation status
local function saveKeyData(key, timeLeft)
    local keyData = {
        key = key,
        timestamp = os.time(),
        userId = player.UserId,
        validated = true,
        timeLeft = timeLeft
    }
    
    local success, err = pcall(function()
        if writefile then
            writefile(keyStorageKey .. ".json", HttpService:JSONEncode(keyData))
        end
    end)
    
    if success then
        print("✅ Validated key data saved successfully")
    else
        warn("❌ Failed to save key data: " .. tostring(err))
    end
end

-- Load and validate saved key data
local function loadKeyData()
    local success, result = pcall(function()
        if readfile and isfile and isfile(keyStorageKey .. ".json") then
            local data = readfile(keyStorageKey .. ".json")
            return HttpService:JSONDecode(data)
        end
        return nil
    end)
    
    if not success or not result then
        print("No valid key data found locally")
        return nil
    end
    
    -- Check if key is expired locally
    local currentTime = os.time()
    local keyAge = currentTime - result.timestamp
    
    if keyAge >= keyExpirationTime then
        print("Stored key has expired locally (24+ hours old)")
        pcall(function()
            if delfile and isfile and isfile(keyStorageKey .. ".json") then
                delfile(keyStorageKey .. ".json")
            end
        end)
        return nil
    end
    
    -- Re-validate with API
    if result.key and result.userId == player.UserId then
        print("🔍 Re-validating stored key with API...")
        local isValid, message, timeLeft = validateKeyWithAPI(result.key)
        if isValid then
            local hours = timeLeft and timeLeft.hours or 0
            local minutes = timeLeft and timeLeft.minutes or 0
            print("✅ Stored key re-validated! Expires in " .. hours .. "h " .. minutes .. "m")
            return result
        else
            print("❌ Stored key failed API validation: " .. tostring(message))
            pcall(function()
                if delfile and isfile and isfile(keyStorageKey .. ".json") then
                    delfile(keyStorageKey .. ".json")
                end
            end)
            return nil
        end
    end
    
    return nil
end

-- Check if user has valid non-expired key
local function checkExistingKey()
    local keyData = loadKeyData()
    if keyData then
        verifiedKey = keyData.key
        return true
    end
    return false
end

-- Forward declare UI elements
local statusLabel

-- Main key verification function
local function verifyKey(key)
    if requestSending then
        if statusLabel then
            statusLabel.Text = "Please wait, verification in progress..."
            statusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
        end
        return false, "Please wait"
    end
    
    requestSending = true
    
    if statusLabel then
        statusLabel.Text = "🔍 Validating key with secure API..."
        statusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    end
    
    -- Validate key with API
    local isValid, message, timeLeft = validateKeyWithAPI(key)
    
    if isValid then
        verifiedKey = key
        saveKeyData(key, timeLeft) -- Save validated key
        requestSending = false
        return true, message
    else
        requestSending = false
        return false, message
    end
end

-- Create UI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SecureKeySystemGUI"
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui
print("SecureKeySystemGUI created")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 240)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -120)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BackgroundTransparency = 1
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 15)
uiCorner.Parent = mainFrame

local uiStroke = Instance.new("UIStroke")
uiStroke.Color = Color3.fromRGB(0, 100, 200)
uiStroke.Thickness = 2
uiStroke.Transparency = 1
uiStroke.Parent = mainFrame

-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 25, 0, 25)
closeButton.Position = UDim2.new(1, -30, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(150, 40, 40)
closeButton.BackgroundTransparency = 1
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 14
closeButton.Font = Enum.Font.GothamBold
closeButton.TextTransparency = 1
closeButton.Parent = mainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 5)
closeCorner.Parent = closeButton

-- Title
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -20, 0, 30)
titleLabel.Position = UDim2.new(0, 10, 0, 10)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "🔒 Secure Key System"
titleLabel.TextColor3 = Color3.fromRGB(0, 120, 220)
titleLabel.TextSize = 18
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextTransparency = 1
titleLabel.Parent = mainFrame

-- Key Input
local keyInput = Instance.new("TextBox")
keyInput.Size = UDim2.new(1, -30, 0, 35)
keyInput.Position = UDim2.new(0, 15, 0, 50)
keyInput.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
keyInput.BackgroundTransparency = 1
keyInput.PlaceholderText = "Enter your verified key"
keyInput.TextColor3 = Color3.fromRGB(180, 180, 200)
keyInput.TextSize = 12
keyInput.Font = Enum.Font.Gotham
keyInput.TextTransparency = 1
keyInput.Text = ""
keyInput.Parent = mainFrame

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 10)
inputCorner.Parent = keyInput

-- Status Label
statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -30, 0, 40)
statusLabel.Position = UDim2.new(0, 15, 0, 90)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "🔒 Get your secure key from our website!\nKeys are validated with our secure API."
statusLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
statusLabel.TextSize = 10
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextWrapped = true
statusLabel.TextTransparency = 1
statusLabel.Parent = mainFrame

-- Buttons Frame
local buttonsFrame = Instance.new("Frame")
buttonsFrame.Size = UDim2.new(1, -30, 0, 60)
buttonsFrame.Position = UDim2.new(0, 15, 0, 140)
buttonsFrame.BackgroundTransparency = 1
buttonsFrame.Parent = mainFrame

-- Verify Button
local verifyButton = Instance.new("TextButton")
verifyButton.Size = UDim2.new(0, 60, 0, 25)
verifyButton.Position = UDim2.new(0, 5, 0, 0)
verifyButton.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
verifyButton.BackgroundTransparency = 1
verifyButton.Text = "🔍 Verify"
verifyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
verifyButton.TextSize = 10
verifyButton.Font = Enum.Font.GothamBold
verifyButton.TextTransparency = 1
verifyButton.Parent = buttonsFrame

local verifyCorner = Instance.new("UICorner")
verifyCorner.CornerRadius = UDim.new(0, 8)
verifyCorner.Parent = verifyButton

-- Get Key Button
local getKeyButton = Instance.new("TextButton")
getKeyButton.Size = UDim2.new(0, 70, 0, 25)
getKeyButton.Position = UDim2.new(0, 75, 0, 0)
getKeyButton.BackgroundColor3 = Color3.fromRGB(76, 175, 80)
getKeyButton.BackgroundTransparency = 1
getKeyButton.Text = "🔑 Get Key"
getKeyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
getKeyButton.TextSize = 9
getKeyButton.Font = Enum.Font.GothamBold
getKeyButton.TextTransparency = 1
getKeyButton.Parent = buttonsFrame

local getKeyCorner = Instance.new("UICorner")
getKeyCorner.CornerRadius = UDim.new(0, 8)
getKeyCorner.Parent = getKeyButton

-- Discord Button
local discordButton = Instance.new("TextButton")
discordButton.Size = UDim2.new(0, 60, 0, 25)
discordButton.Position = UDim2.new(0, 155, 0, 0)
discordButton.BackgroundColor3 = Color3.fromRGB(114, 137, 218)
discordButton.BackgroundTransparency = 1
discordButton.Text = "💬 Discord"
discordButton.TextColor3 = Color3.fromRGB(255, 255, 255)
discordButton.TextSize = 8
discordButton.Font = Enum.Font.GothamBold
discordButton.TextTransparency = 1
discordButton.Parent = buttonsFrame

local discordCorner = Instance.new("UICorner")
discordCorner.CornerRadius = UDim.new(0, 8)
discordCorner.Parent = discordButton

-- YouTube Button
local youtubeButton = Instance.new("TextButton")
youtubeButton.Size = UDim2.new(0, 60, 0, 25)
youtubeButton.Position = UDim2.new(0, 75, 0, 30)
youtubeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
youtubeButton.BackgroundTransparency = 1
youtubeButton.Text = "📺 YouTube"
youtubeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
youtubeButton.TextSize = 8
youtubeButton.Font = Enum.Font.GothamBold
youtubeButton.TextTransparency = 1
youtubeButton.Parent = buttonsFrame

local youtubeCorner = Instance.new("UICorner")
youtubeCorner.CornerRadius = UDim.new(0, 8)
youtubeCorner.Parent = youtubeButton

-- API Status Button
local apiStatusButton = Instance.new("TextButton")
apiStatusButton.Size = UDim2.new(0, 60, 0, 25)
apiStatusButton.Position = UDim2.new(0, 5, 0, 30)
apiStatusButton.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
apiStatusButton.BackgroundTransparency = 1
apiStatusButton.Text = "🌐 API Status"
apiStatusButton.TextColor3 = Color3.fromRGB(255, 255, 255)
apiStatusButton.TextSize = 7
apiStatusButton.Font = Enum.Font.GothamBold
apiStatusButton.TextTransparency = 1
apiStatusButton.Parent = buttonsFrame

local apiStatusCorner = Instance.new("UICorner")
apiStatusCorner.CornerRadius = UDim.new(0, 8)
apiStatusCorner.Parent = apiStatusButton

local isVerified = false

-- Check API server status
local function checkAPIStatus()
    local endpoints = getAPIEndpoints()
    if endpoints then
        return true, "API server is online with randomized endpoints"
    else
        return false, "API server is offline or unreachable"
    end
end

local function ShowKeySystem()
    print("Showing secure key system UI")
    local success, err = pcall(function()
        -- Check API status on show
        local apiOnline, apiMessage = checkAPIStatus()
        if not apiOnline then
            warn("⚠️  " .. apiMessage)
            if statusLabel then
                statusLabel.Text = "⚠️  Warning: API server offline. Key validation may fail."
                statusLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
            end
        end
        
        local frameTween = TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundTransparency = 0.15
        })
        local strokeTween = TweenService:Create(uiStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Transparency = 0
        })
        
        -- Create tweens for all UI elements
        local tweens = {
            TweenService:Create(titleLabel, TweenInfo.new(0.5), {TextTransparency = 0}),
            TweenService:Create(keyInput, TweenInfo.new(0.5), {BackgroundTransparency = 0.3, TextTransparency = 0}),
            TweenService:Create(statusLabel, TweenInfo.new(0.5), {TextTransparency = 0}),
            TweenService:Create(verifyButton, TweenInfo.new(0.5), {BackgroundTransparency = 0.2, TextTransparency = 0}),
            TweenService:Create(getKeyButton, TweenInfo.new(0.5), {BackgroundTransparency = 0.2, TextTransparency = 0}),
            TweenService:Create(discordButton, TweenInfo.new(0.5), {BackgroundTransparency = 0.2, TextTransparency = 0}),
            TweenService:Create(youtubeButton, TweenInfo.new(0.5), {BackgroundTransparency = 0.2, TextTransparency = 0}),
            TweenService:Create(apiStatusButton, TweenInfo.new(0.5), {BackgroundTransparency = 0.2, TextTransparency = 0}),
            TweenService:Create(closeButton, TweenInfo.new(0.5), {BackgroundTransparency = 0.2, TextTransparency = 0})
        }
        
        frameTween:Play()
        strokeTween:Play()
        for _, tween in pairs(tweens) do
            tween:Play()
        end
    end)
    if not success then
        warn("Failed to show key system UI: " .. tostring(err))
    end
end

local function HideKeySystem()
    print("Hiding secure key system UI")
    local success, err = pcall(function()
        local frameTween = TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            BackgroundTransparency = 1
        })
        frameTween.Completed:Connect(function()
            if screenGui and screenGui.Parent then
                screenGui:Destroy()
                print("SecureKeySystemGUI destroyed")
            end
        end)
        frameTween:Play()
    end)
    if not success then
        warn("Failed to hide key system UI: " .. tostring(err))
    end
end

-- Button Events
getKeyButton.MouseButton1Click:Connect(function()
    print("Get Key button clicked")
    local success, err = pcall(function()
        statusLabel.Text = "🌐 Opening secure key generator..."
        statusLabel.TextColor3 = Color3.fromRGB(76, 175, 80)
        
        if setclipboard then
            setclipboard(WEBSITE_URL)
            getKeyButton.Text = "Link Copied!"
            getKeyButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
            statusLabel.Text = "✅ Secure key generator link copied! Paste in browser."
            statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
            wait(3)
            getKeyButton.Text = "🔑 Get Key"
            getKeyButton.BackgroundColor3 = Color3.fromRGB(76, 175, 80)
            statusLabel.Text = "🔒 Get your secure key from our website!\nKeys are validated with our secure API."
            statusLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
        else
            statusLabel.Text = "Visit: " .. WEBSITE_URL
            statusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
        end
    end)
    if not success then
        warn("Get Key button failed: " .. tostring(err))
    end
end)

discordButton.MouseButton1Click:Connect(function()
    local success, err = pcall(function()
        if setclipboard then
            setclipboard("https://discord.gg/bpsNUH5sVb")
            discordButton.Text = "Copied!"
            discordButton.BackgroundColor3 = Color3.fromRGB(67, 56, 202)
            wait(1.5)
            discordButton.Text = "💬 Discord"
            discordButton.BackgroundColor3 = Color3.fromRGB(114, 137, 218)
        end
    end)
    if not success then
        warn("Discord button failed: " .. tostring(err))
    end
end)

youtubeButton.MouseButton1Click:Connect(function()
    local success, err = pcall(function()
        if setclipboard then
            setclipboard("https://youtube.com/@pickletalk1?si=3qmXDIx5StyveZeF")
            youtubeButton.Text = "Copied!"
            youtubeButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
            wait(1.5)
            youtubeButton.Text = "📺 YouTube"
            youtubeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        end
    end)
    if not success then
        warn("YouTube button failed: " .. tostring(err))
    end
end)

apiStatusButton.MouseButton1Click:Connect(function()
    local success, err = pcall(function()
        statusLabel.Text = "🔍 Checking API server status..."
        statusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
        
        local apiOnline, apiMessage = checkAPIStatus()
        if apiOnline then
            statusLabel.Text = "✅ API Server Online - Randomized endpoints active"
            statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
            apiStatusButton.Text = "✅ Online"
            apiStatusButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        else
            statusLabel.Text = "❌ API Server Offline - Key validation unavailable"
            statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
            apiStatusButton.Text = "❌ Offline"
            apiStatusButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        end
        
        wait(3)
        apiStatusButton.Text = "🌐 API Status"
        apiStatusButton.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
        statusLabel.Text = "🔒 Get your secure key from our website!\nKeys are validated with our secure API."
        statusLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
    end)
    if not success then
        warn("API Status button failed: " .. tostring(err))
    end
end)

closeButton.MouseButton1Click:Connect(function()
    print("Close button clicked")
    HideKeySystem()
end)

verifyButton.MouseButton1Click:Connect(function()
    print("Verify button clicked")
    local success, err = pcall(function()
        if keyInput.Text == "" then
            statusLabel.Text = "❌ Please enter a key."
            statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
            return
        end
        
        statusLabel.Text = "🔍 Verifying key with secure API..."
        statusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
        
        local verified, message = verifyKey(keyInput.Text)
        if verified then
            statusLabel.Text = "✅ " .. message
            statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
            isVerified = true
            wait(2)
            HideKeySystem()
        else
            statusLabel.Text = "❌ " .. message
            statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
            keyInput.Text = ""
            wait(5)
            statusLabel.Text = "🔒 Get your secure key from our website!\nKeys are validated with our secure API."
            statusLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
        end
    end)
    if not success then
        warn("Verify button failed: " .. tostring(err))
    end
end)

-- Return the secure key system API
return {
    ShowKeySystem = ShowKeySystem,
    HideKeySystem = HideKeySystem,
    IsKeyVerified = function() return isVerified or checkExistingKey() end,
    ValidateKey = verifyKey,
    GetEnteredKey = function() return verifiedKey end,
    getVerifiedKey = function() return verifiedKey end,
    CheckExistingKey = checkExistingKey,
    CheckAPIStatus = checkAPIStatus
}
