-- Scripts Hub X | Enhanced Key System with Custom Free Keys
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui", 5)

if not playerGui then
    warn("PlayerGui not found after 5 seconds")
    return {}
end

print("Enhanced Key system started, PlayerGui found")

local service = 5008
local secret = "dd2c65bc-6361-4147-9a25-246cd334eedd"
local useNonce = true
local cachedLink, cachedTime = "", 0
local verifiedKey = nil

-- Global request tracking to prevent spam
local requestSending = false

-- Custom FREE key validation patterns
local validFreeKeyPatterns = {
    "FREE_%w%w%w%w%w%w%-%w%w%w%w%w%w%-%w%w%w%w%w%w%-%w%w%w%w%w%w", -- FREE_XXXXXX-XXXXXX-XXXXXX-XXXXXX
    "FREE_[A-Z0-9][A-Z0-9][A-Z0-9][A-Z0-9][A-Z0-9][A-Z0-9]%-[A-Z0-9][A-Z0-9][A-Z0-9][A-Z0-9][A-Z0-9][A-Z0-9]%-[A-Z0-9][A-Z0-9][A-Z0-9][A-Z0-9][A-Z0-9][A-Z0-9]%-[A-Z0-9][A-Z0-9][A-Z0-9][A-Z0-9][A-Z0-9][A-Z0-9]"
}

local function lEncode(data)
    return HttpService:JSONEncode(data)
end

local function lDecode(data)
    return HttpService:JSONDecode(data)
end

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

-- Custom FREE key validation function
local function validateCustomFreeKey(key)
    -- Check if key starts with FREE_
    if not string.sub(key, 1, 5) == "FREE_" then
        return false
    end
    
    -- Check if key matches the pattern FREE_XXXXXX-XXXXXX-XXXXXX-XXXXXX
    local pattern = "^FREE_[A-Z0-9][A-Z0-9][A-Z0-9][A-Z0-9][A-Z0-9][A-Z0-9]%-[A-Z0-9][A-Z0-9][A-Z0-9][A-Z0-9][A-Z0-9][A-Z0-9]%-[A-Z0-9][A-Z0-9][A-Z0-9][A-Z0-9][A-Z0-9][A-Z0-9]%-[A-Z0-9][A-Z0-9][A-Z0-9][A-Z0-9][A-Z0-9][A-Z0-9]$"
    
    return string.match(key, pattern) ~= nil
end

local host = "https://api.platoboost.com"
local hostResponse = request({
    Url = host .. "/public/connectivity",
    Method = "GET"
})
if hostResponse.StatusCode ~= 200 and hostResponse.StatusCode ~= 429 then
    host = "https://api.platoboost.net"
end

local function cacheLink()
    print("Attempting to cache link...")
    if cachedTime + (10*60) < os.time() then
        print("Cache expired, requesting new link...")
        local success, response = pcall(function()
            return request({
                Url = host .. "/public/start",
                Method = "POST",
                Body = lEncode({
                    service = service,
                    identifier = lDigest(player.UserId)
                }),
                Headers = {
                    ["Content-Type"] = "application/json"
                }
            })
        end)
        
        if not success then
            print("Request failed: " .. tostring(response))
            return false, "Request failed: " .. tostring(response)
        end
        
        print("Response Status Code: " .. tostring(response.StatusCode))
        print("Response Body: " .. tostring(response.Body))
        
        if response.StatusCode == 200 then
            local decodeSuccess, decoded = pcall(function()
                return lDecode(response.Body)
            end)
            
            if not decodeSuccess then
                print("Failed to decode response: " .. tostring(decoded))
                return false, "Failed to decode response"
            end
            
            print("Decoded response success: " .. tostring(decoded.success))
            if decoded.success == true then
                cachedLink = decoded.data.url
                cachedTime = os.time()
                print("Successfully cached link: " .. cachedLink)
                return true, cachedLink
            else
                print("API returned error: " .. tostring(decoded.message))
                return false, decoded.message or "Unknown API error"
            end
        elseif response.StatusCode == 429 then
            return false, "You are being rate limited, please wait 20 seconds and try again."
        else
            return false, "Server returned status code: " .. tostring(response.StatusCode)
        end
    else
        print("Using cached link: " .. cachedLink)
        return true, cachedLink
    end
end

-- Forward declare UI elements
local statusLabel

local function verifyKey(key)
    if requestSending then
        if statusLabel then
            statusLabel.Text = "A request is already being sent, please slow down."
        end
        return false
    end
    
    requestSending = true
    
    -- First check if it's a custom FREE key
    if validateCustomFreeKey(key) then
        print("Custom FREE key detected: " .. key)
        verifiedKey = key
        requestSending = false
        return true, "Custom free key verified successfully"
    end
    
    local success, result = pcall(function()
        local nonce = generateNonce()
        local endpoint = host .. "/public/whitelist/" .. tostring(service) .. "?identifier=" .. lDigest(player.UserId) .. "&key=" .. key
        if useNonce then
            endpoint = endpoint .. "&nonce=" .. nonce
        end
        
        local response = request({
            Url = endpoint,
            Method = "GET"
        })
        
        if response.StatusCode == 200 then
            local decoded = lDecode(response.Body)
            if decoded.success == true then
                if decoded.data.valid == true then
                    verifiedKey = key
                    return true, "Key verified successfully"
                else
                    -- Handle API-based FREE_ keys
                    if string.sub(key, 1, 4) == "FREE_" then
                        local redeemNonce = generateNonce()
                        local redeemEndpoint = host .. "/public/redeem/" .. tostring(service)
                        local body = {
                            identifier = lDigest(player.UserId),
                            key = key
                        }
                        if useNonce then
                            body.nonce = redeemNonce
                        end
                        
                        local redeemResponse = request({
                            Url = redeemEndpoint,
                            Method = "POST",
                            Body = lEncode(body),
                            Headers = {
                                ["Content-Type"] = "application/json"
                            }
                        })
                        
                        if redeemResponse.StatusCode == 200 then
                            local redeemDecoded = lDecode(redeemResponse.Body)
                            if redeemDecoded.success == true then
                                if redeemDecoded.data.valid == true then
                                    if useNonce then
                                        if redeemDecoded.data.hash == lDigest("true" .. "-" .. redeemNonce .. "-" .. secret) then
                                            verifiedKey = key
                                            return true, "Free key redeemed successfully"
                                        else
                                            return false, "Failed to verify integrity."
                                        end
                                    else
                                        verifiedKey = key
                                        return true, "Free key redeemed successfully"
                                    end
                                else
                                    return false, "Key is invalid."
                                end
                            else
                                if string.sub(redeemDecoded.message, 1, 27) == "unique constraint violation" then
                                    return false, "You already have an active key, please wait for it to expire."
                                else
                                    return false, redeemDecoded.message
                                end
                            end
                        elseif redeemResponse.StatusCode == 429 then
                            return false, "You are being rate limited, please wait 20 seconds."
                        else
                            return false, "Server returned an invalid status code."
                        end
                    else
                        return false, "Key is invalid."
                    end
                end
            else
                return false, decoded.message
            end
        elseif response.StatusCode == 429 then
            return false, "You are being rate limited, please wait 20 seconds."
        else
            return false, "Server returned an invalid status code."
        end
    end)
    
    requestSending = false
    
    if not success then
        print("Error in verifyKey: " .. tostring(result))
        return false, "Verification failed: " .. tostring(result)
    end
    
    return result
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
statusLabel.Text = "Get FREE key from our website or buy premium!"
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

-- Get Premium Button
local getPremiumButton = Instance.new("TextButton")
getPremiumButton.Size = UDim2.new(0, 45, 0, 25)
getPremiumButton.Position = UDim2.new(0, 210, 0, 0)
getPremiumButton.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
getPremiumButton.BackgroundTransparency = 1
getPremiumButton.Text = "Premium"
getPremiumButton.TextColor3 = Color3.fromRGB(0, 0, 0)
getPremiumButton.TextSize = 8
getPremiumButton.Font = Enum.Font.GothamBold
getPremiumButton.TextTransparency = 1
getPremiumButton.Parent = buttonsFrame

local getPremiumCorner = Instance.new("UICorner")
getPremiumCorner.CornerRadius = UDim.new(0, 8)
getPremiumCorner.Parent = getPremiumButton

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
        local getPremiumTween = TweenService:Create(getPremiumButton, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
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
        getPremiumTween:Play()
        closeTween:Play()
    end)
    if not success then
        warn("Failed to show key system UI: " .. tostring(err))
        mainFrame.BackgroundTransparency = 0.2
        uiStroke.Transparency = 0
        titleLabel.TextTransparency = 0
        keyInput.BackgroundTransparency = 0.3
        keyInput.TextTransparency = 0
        statusLabel.TextTransparency = 0
        verifyButton.BackgroundTransparency = 0.3
        verifyButton.TextTransparency = 0
        getFreeKeyButton.BackgroundTransparency = 0.3
        getFreeKeyButton.TextTransparency = 0
        joinButton.BackgroundTransparency = 0.3
        joinButton.TextTransparency = 0
        getPremiumButton.BackgroundTransparency = 0.3
        getPremiumButton.TextTransparency = 0
        closeButton.BackgroundTransparency = 0.3
        closeButton.TextTransparency = 0
    end
end

local function HideKeySystem()
    print("Hiding key system UI")
    local success, err = pcall(function()
        local frameTween = TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 280, 0, 220)
        })
        local strokeTween = TweenService:Create(uiStroke, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Transparency = 1
        })
        local titleTween = TweenService:Create(titleLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            TextTransparency = 1
        })
        local inputTween = TweenService:Create(keyInput, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            BackgroundTransparency = 1,
            TextTransparency = 1
        })
        local statusTween = TweenService:Create(statusLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            TextTransparency = 1
        })
        local verifyTween = TweenService:Create(verifyButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            BackgroundTransparency = 1,
            TextTransparency = 1
        })
        local getFreeKeyTween = TweenService:Create(getFreeKeyButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            BackgroundTransparency = 1,
            TextTransparency = 1
        })
        local joinTween = TweenService:Create(joinButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            BackgroundTransparency = 1,
            TextTransparency = 1
        })
        local getPremiumTween = TweenService:Create(getPremiumButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            BackgroundTransparency = 1,
            TextTransparency = 1
        })
        local closeTween = TweenService:Create(closeButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            BackgroundTransparency = 1,
            TextTransparency = 1
        })
        
        frameTween:Play()
        strokeTween:Play()
        titleTween:Play()
        inputTween:Play()
        statusTween:Play()
        verifyTween:Play()
        getFreeKeyTween:Play()
        joinTween:Play()
        getPremiumTween:Play()
        closeTween:Play()
        
        frameTween.Completed:Connect(function()
            if screenGui and screenGui.Parent then
                screenGui:Destroy()
                print("KeySystemGUI destroyed")
            end
        end)
    end)
    if not success then
        warn("Failed to hide key system UI: " .. tostring(err))
        if screenGui and screenGui.Parent then
            screenGui:Destroy()
            print("KeySystemGUI destroyed (fallback)")
        end
    end
end

-- Button Events
getFreeKeyButton.MouseButton1Click:Connect(function()
    print("Get FREE Key button clicked")
    local success, err = pcall(function()  
        -- Open the HTML page (you'll need to host this somewhere)
        if setclipboard then
            setclipboard("https://workink.net/21Z5/ej1umc5v")
            getFreeKeyButton.Text = "Link Copied!"
            getFreeKeyButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
            statusLabel.Text = "Key generator link copied! Paste in browser."
            statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
            wait(2)
            getFreeKeyButton.Text = "Get FREE Key"
            getFreeKeyButton.BackgroundColor3 = Color3.fromRGB(76, 175, 80)
            statusLabel.Text = "Get FREE key from our website or buy premium!"
            statusLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
        else
            statusLabel.Text = "Please visit: https://workink.net/21Z5/ej1umc5v"
            statusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
        end
    end)
    if not success then
        warn("Get FREE Key button failed: " .. tostring(err))
        statusLabel.Text = "Error: " .. tostring(err)
        statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
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

getPremiumButton.MouseButton1Click:Connect(function()
    local success, err = pcall(function()
        statusLabel.Text = "Contact us on Discord to buy premium keys!"
        statusLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
        
        if setclipboard then
            setclipboard("https://discord.gg/bpsNUH5sVb")
            getPremiumButton.Text = "Link Copied!"
            wait(2)
            getPremiumButton.Text = "Premium"
            statusLabel.Text = "Get FREE key from our website or buy premium!"
            statusLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
        end
    end)
    if not success then
        warn("Get Premium button failed: " .. tostring(err))
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
            statusLabel.Text = "Key accepted! Loading..."
            statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
            isVerified = true
            wait(1)
            HideKeySystem()
        else
            statusLabel.Text = message or "Key verification failed"
            statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
            keyInput.Text = ""
            wait(3)
            statusLabel.Text = "Get FREE key from our website or buy premium!"
            statusLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
        end
    end)
    if not success then
        warn("Verify button failed: " .. tostring(err))
        statusLabel.Text = "Verification error occurred"
        statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    end
end)

-- Return the key system API
return {
    ShowKeySystem = ShowKeySystem,
    HideKeySystem = HideKeySystem,
    IsKeyVerified = function() return isVerified end,
    ValidateKey = verifyKey,
    GetEnteredKey = function() return verifiedKey end,
    getVerifiedKey = function() return verifiedKey end
}
