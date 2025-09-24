-- Scripts Hub X | Enhanced Key System with 24h Expiration
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui", 5)

if not playerGui then
    warn("PlayerGui not found after 5 seconds")
    return {}
end

print("Enhanced Key system started with 24h expiration")

-- Key Storage and Expiration System
local keyStorageKey = "ScriptsHubX_KeyData_" .. tostring(player.UserId)
local verifiedKey = nil
local keyExpirationTime = 24 * 60 * 60 -- 24 hours in seconds

-- Global request tracking to prevent spam
local requestSending = false

-- Custom FREE key validation function with improved error handling
local function validateCustomFreeKey(key)
    if not key or key == "" then
        return false, "Please enter a key."
    end
    
    -- Check if key starts with FREE_
    if string.sub(key, 1, 5) ~= "FREE_" then
        return false, "Invalid key format. Key must start with 'FREE_'"
    end
    
    -- Check if key matches the pattern FREE_XXXXXX-XXXXXX-XXXXXX-XXXXXX
    local pattern = "^FREE_[A-Z0-9][A-Z0-9][A-Z0-9][A-Z0-9][A-Z0-9][A-Z0-9]%-[A-Z0-9][A-Z0-9][A-Z0-9][A-Z0-9][A-Z0-9][A-Z0-9]%-[A-Z0-9][A-Z0-9][A-Z0-9][A-Z0-9][A-Z0-9][A-Z0-9]%-[A-Z0-9][A-Z0-9][A-Z0-9][A-Z0-9][A-Z0-9][A-Z0-9]$"
    
    if not string.match(key, pattern) then
        return false, "Invalid key format. Please get a new key from our website."
    end
    
    return true, "Key format is valid"
end

-- Save key with timestamp to prevent re-verification
local function saveKeyData(key)
    local keyData = {
        key = key,
        timestamp = os.time(),
        userId = player.UserId
    }
    
    local success, err = pcall(function()
        if writefile then
            writefile(keyStorageKey .. ".json", HttpService:JSONEncode(keyData))
        end
    end)
    
    if success then
        print("Key data saved successfully")
    else
        warn("Failed to save key data: " .. tostring(err))
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
        print("No valid key data found")
        return nil
    end
    
    -- Check if key is expired (24 hours)
    local currentTime = os.time()
    local keyAge = currentTime - result.timestamp
    
    if keyAge >= keyExpirationTime then
        print("Stored key has expired (24+ hours old)")
        -- Delete expired key file
        pcall(function()
            if delfile and isfile and isfile(keyStorageKey .. ".json") then
                delfile(keyStorageKey .. ".json")
            end
        end)
        return nil
    end
    
    -- Validate key format
    local isValid, message = validateCustomFreeKey(result.key)
    if isValid and result.userId == player.UserId then
        local hoursLeft = math.floor((keyExpirationTime - keyAge) / 3600)
        local minutesLeft = math.floor(((keyExpirationTime - keyAge) % 3600) / 60)
        print("Valid key found! Expires in " .. hoursLeft .. "h " .. minutesLeft .. "m")
        return result
    else
        print("Stored key is invalid or belongs to different user")
        return nil
    end
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

local function verifyKey(key)
    if requestSending then
        if statusLabel then
            statusLabel.Text = "Please wait, verification in progress..."
            statusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
        end
        return false, "Please wait"
    end
    
    requestSending = true
    
    -- Validate custom FREE key
    local isValid, message = validateCustomFreeKey(key)
    
    if isValid then
        verifiedKey = key
        saveKeyData(key) -- Save key with timestamp
        requestSending = false
        return true, "Key verified successfully! Valid for 24 hours."
    else
        requestSending = false
        return false, message
    end
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "KeySystemGUI"
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui
print("KeySystemGUI created")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 280, 0, 220)
mainFrame.Position = UDim2.new(0.5, -140, 0.5, -110)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BackgroundTransparency = 1
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 15)
uiCorner.Parent = mainFrame

local uiStroke = Instance.new("UIStroke")
uiStroke.Color = Color3.fromRGB(0, 100, 200)
uiStroke.Thickness = 1.5
uiStroke.Transparency = 1
uiStroke.Parent = mainFrame

-- Close Button (X)
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
titleLabel.Text = "🔐 Key System"
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
keyInput.PlaceholderText = "Enter Key Here"
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
statusLabel.Size = UDim2.new(1, -30, 0, 30)
statusLabel.Position = UDim2.new(0, 15, 0, 90)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Get FREE key from our website! Valid for 24 hours."
statusLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
statusLabel.TextSize = 10
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextWrapped = true
statusLabel.TextTransparency = 1
statusLabel.Parent = mainFrame

-- Buttons Frame
local buttonsFrame = Instance.new("Frame")
buttonsFrame.Size = UDim2.new(1, -30, 0, 30)
buttonsFrame.Position = UDim2.new(0, 15, 0, 130)
buttonsFrame.BackgroundTransparency = 1
buttonsFrame.Parent = mainFrame

-- Verify Button
local verifyButton = Instance.new("TextButton")
verifyButton.Size = UDim2.new(0, 50, 0, 25)
verifyButton.Position = UDim2.new(0, 5, 0, 0)
verifyButton.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
verifyButton.BackgroundTransparency = 1
verifyButton.Text = "Verify"
verifyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
verifyButton.TextSize = 10
verifyButton.Font = Enum.Font.GothamBold
verifyButton.TextTransparency = 1
verifyButton.Parent = buttonsFrame

local verifyCorner = Instance.new("UICorner")
verifyCorner.CornerRadius = UDim.new(0, 8)
verifyCorner.Parent = verifyButton

-- Get FREE Key Button
local getFreeKeyButton = Instance.new("TextButton")
getFreeKeyButton.Size = UDim2.new(0, 70, 0, 25)
getFreeKeyButton.Position = UDim2.new(0, 65, 0, 0)
getFreeKeyButton.BackgroundColor3 = Color3.fromRGB(76, 175, 80)
getFreeKeyButton.BackgroundTransparency = 1
getFreeKeyButton.Text = "Get FREE Key"
getFreeKeyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
getFreeKeyButton.TextSize = 9
getFreeKeyButton.Font = Enum.Font.GothamBold
getFreeKeyButton.TextTransparency = 1
getFreeKeyButton.Parent = buttonsFrame

local getFreeKeyCorner = Instance.new("UICorner")
getFreeKeyCorner.CornerRadius = UDim.new(0, 8)
getFreeKeyCorner.Parent = getFreeKeyButton

-- Join Discord Button
local joinButton = Instance.new("TextButton")
joinButton.Size = UDim2.new(0, 55, 0, 25)
joinButton.Position = UDim2.new(0, 145, 0, 0)
joinButton.BackgroundColor3 = Color3.fromRGB(114, 137, 218)
joinButton.BackgroundTransparency = 1
joinButton.Text = "Discord"
joinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
joinButton.TextSize = 9
joinButton.Font = Enum.Font.GothamBold
joinButton.TextTransparency = 1
joinButton.Parent = buttonsFrame

local joinCorner = Instance.new("UICorner")
joinCorner.CornerRadius = UDim.new(0, 8)
joinCorner.Parent = joinButton

-- Check Key Button
local checkKeyButton = Instance.new("TextButton")
checkKeyButton.Size = UDim2.new(0, 45, 0, 25)
checkKeyButton.Position = UDim2.new(0, 210, 0, 0)
checkKeyButton.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
checkKeyButton.BackgroundTransparency = 1
checkKeyButton.Text = "Check Key"
checkKeyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
checkKeyButton.TextSize = 8
checkKeyButton.Font = Enum.Font.GothamBold
checkKeyButton.TextTransparency = 1
checkKeyButton.Parent = buttonsFrame

local checkKeyCorner = Instance.new("UICorner")
checkKeyCorner.CornerRadius = UDim.new(0, 8)
checkKeyCorner.Parent = checkKeyButton

local isVerified = false

local function ShowKeySystem()
    print("Showing key system UI")
    local success, err = pcall(function()
        local frameTween = TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundTransparency = 0.2
        })
        local strokeTween = TweenService:Create(uiStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Transparency = 0
        })
        local titleTween = TweenService:Create(titleLabel, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            TextTransparency = 0
        })
        local inputTween = TweenService:Create(keyInput, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundTransparency = 0.3,
            TextTransparency = 0
        })
        local statusTween = TweenService:Create(statusLabel, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            TextTransparency = 0
        })
        local verifyTween = TweenService:Create(verifyButton, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundTransparency = 0.3,
            TextTransparency = 0
        })
        local getFreeKeyTween = TweenService:Create(getFreeKeyButton, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundTransparency = 0.3,
            TextTransparency = 0
        })
        local joinTween = TweenService:Create(joinButton, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundTransparency = 0.3,
            TextTransparency = 0
        })
        local checkKeyTween = TweenService:Create(checkKeyButton, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundTransparency = 0.3,
            TextTransparency = 0
        })
        local closeTween = TweenService:Create(closeButton, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundTransparency = 0.3,
            TextTransparency = 0
        })
        
        frameTween:Play()
        strokeTween:Play()
        titleTween:Play()
        inputTween:Play()
        statusTween:Play()
        verifyTween:Play()
        getFreeKeyTween:Play()
        joinTween:Play()
        checkKeyTween:Play()
        closeTween:Play()
    end)
    if not success then
        warn("Failed to show key system UI: " .. tostring(err))
    end
end

local function HideKeySystem()
    print("Hiding key system UI")
    local success, err = pcall(function()
        local frameTween = TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            BackgroundTransparency = 1
        })
        frameTween.Completed:Connect(function()
            if screenGui and screenGui.Parent then
                screenGui:Destroy()
                print("KeySystemGUI destroyed")
            end
        end)
        frameTween:Play()
    end)
    if not success then
        warn("Failed to hide key system UI: " .. tostring(err))
    end
end

-- Button Events
getFreeKeyButton.MouseButton1Click:Connect(function()
    print("Get FREE Key button clicked")
    local success, err = pcall(function()
        statusLabel.Text = "Opening key generator..."
        statusLabel.TextColor3 = Color3.fromRGB(76, 175, 80)
        
        if setclipboard then
            setclipboard("https://workink.net/21Z5/ej1umc5v")
            getFreeKeyButton.Text = "Link Copied!"
            getFreeKeyButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
            statusLabel.Text = "Key generator link copied! Paste in browser."
            statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
            wait(2)
            getFreeKeyButton.Text = "Get FREE Key"
            getFreeKeyButton.BackgroundColor3 = Color3.fromRGB(76, 175, 80)
            statusLabel.Text = "Get FREE key from our website! Valid for 24 hours."
            statusLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
        else
            statusLabel.Text = "Visit: workink.net/21Z5/ej1umc5v"
            statusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
        end
    end)
    if not success then
        warn("Get FREE Key button failed: " .. tostring(err))
    end
end)

joinButton.MouseButton1Click:Connect(function()
    local success, err = pcall(function()
        if setclipboard then
            setclipboard("https://discord.gg/bpsNUH5sVb")
            joinButton.Text = "Copied!"
            joinButton.BackgroundColor3 = Color3.fromRGB(67, 56, 202)
            wait(1)
            joinButton.Text = "Discord"
            joinButton.BackgroundColor3 = Color3.fromRGB(114, 137, 218)
        end
    end)
    if not success then
        warn("Join Discord button failed: " .. tostring(err))
    end
end)

checkKeyButton.MouseButton1Click:Connect(function()
    local keyData = loadKeyData()
    if keyData then
        local currentTime = os.time()
        local keyAge = currentTime - keyData.timestamp
        local hoursLeft = math.floor((keyExpirationTime - keyAge) / 3600)
        local minutesLeft = math.floor(((keyExpirationTime - keyAge) % 3600) / 60)
        
        statusLabel.Text = "✅ Key valid! Expires in " .. hoursLeft .. "h " .. minutesLeft .. "m"
        statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    else
        statusLabel.Text = "❌ No valid key found. Get a new key!"
        statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
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
            statusLabel.Text = "Please enter a key."
            statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
            return
        end
        
        statusLabel.Text = "Verifying key..."
        statusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
        
        local verified, message = verifyKey(keyInput.Text)
        if verified then
            statusLabel.Text = "✅ " .. message
            statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
            isVerified = true
            wait(1.5)
            HideKeySystem()
        else
            statusLabel.Text = "❌ " .. message
            statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
            keyInput.Text = ""
            wait(4)
            statusLabel.Text = "Get FREE key from our website! Valid for 24 hours."
            statusLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
        end
    end)
    if not success then
        warn("Verify button failed: " .. tostring(err))
    end
end)

-- Return the key system API
return {
    ShowKeySystem = ShowKeySystem,
    HideKeySystem = HideKeySystem,
    IsKeyVerified = function() return isVerified or checkExistingKey() end,
    ValidateKey = verifyKey,
    GetEnteredKey = function() return verifiedKey end,
    getVerifiedKey = function() return verifiedKey end,
    CheckExistingKey = checkExistingKey
}
