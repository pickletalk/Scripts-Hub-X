-- Scripts Hub X | Key System
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local HttpService = game:GetService("HttpService")
local userId = player.UserId
local username = player.Name

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "KeySystemGUI"
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 250) -- Increased height for buttons
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -125)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25) -- Darker, cleaner background
mainFrame.BackgroundTransparency = 1
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 12) -- Slightly larger radius for elegance
uiCorner.Parent = mainFrame

local uiStroke = Instance.new("UIStroke")
uiStroke.Color = Color3.fromRGB(0, 150, 255) -- Softer blue
uiStroke.Thickness = 2
uiStroke.Transparency = 1
uiStroke.Parent = mainFrame

-- Close Button (X)
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50) -- Red for close
closeButton.BackgroundTransparency = 1
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 16
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextTransparency = 1
closeButton.Parent = mainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 5)
closeCorner.Parent = closeButton

-- Title
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -20, 0, 40)
titleLabel.Position = UDim2.new(0, 10, 0, 10)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Key System"
titleLabel.TextColor3 = Color3.fromRGB(0, 150, 255)
titleLabel.TextSize = 20
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextTransparency = 1
titleLabel.Parent = mainFrame

-- Key Input
local keyInput = Instance.new("TextBox")
keyInput.Size = UDim2.new(1, -40, 0, 40)
keyInput.Position = UDim2.new(0, 20, 0, 60)
keyInput.BackgroundColor3 = Color3.fromRGB(35, 35, 35) -- Darker input
keyInput.BackgroundTransparency = 1
keyInput.PlaceholderText = "Enter Key Here"
keyInput.TextColor3 = Color3.fromRGB(200, 200, 200) -- Lighter text
keyInput.TextSize = 14
keyInput.Font = Enum.Font.SourceSans
keyInput.TextTransparency = 1
keyInput.Parent = mainFrame

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 8) -- Softer corners
inputCorner.Parent = keyInput

-- Status Label
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -40, 0, 40)
statusLabel.Position = UDim2.new(0, 20, 0, 110)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Join our Discord for a key!"
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.TextSize = 12
statusLabel.Font = Enum.Font.SourceSans
statusLabel.TextWrapped = true
statusLabel.TextTransparency = 1
statusLabel.Parent = mainFrame

-- Buttons Frame
local buttonsFrame = Instance.new("Frame")
buttonsFrame.Size = UDim2.new(1, -40, 0, 80) -- Increased for three buttons
buttonsFrame.Position = UDim2.new(0, 20, 0, 160)
buttonsFrame.BackgroundTransparency = 1
buttonsFrame.Parent = mainFrame

-- Verify Button
local verifyButton = Instance.new("TextButton")
verifyButton.Size = UDim2.new(0, 90, 0, 30)
verifyButton.Position = UDim2.new(0, 0, 0, 0)
verifyButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
verifyButton.BackgroundTransparency = 1
verifyButton.Text = "Verify"
verifyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
verifyButton.TextSize = 14
verifyButton.Font = Enum.Font.SourceSansBold
verifyButton.TextTransparency = 1
verifyButton.Parent = buttonsFrame

local verifyCorner = Instance.new("UICorner")
verifyCorner.CornerRadius = UDim.new(0, 8)
verifyCorner.Parent = verifyButton

-- Get Key Button
local getKeyButton = Instance.new("TextButton")
getKeyButton.Size = UDim2.new(0, 90, 0, 30)
getKeyButton.Position = UDim2.new(0, 100, 0, 0)
getKeyButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
getKeyButton.BackgroundTransparency = 1
getKeyButton.Text = "Get Key"
getKeyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
getKeyButton.TextSize = 14
getKeyButton.Font = Enum.Font.SourceSansBold
getKeyButton.TextTransparency = 1
getKeyButton.Parent = buttonsFrame

local getKeyCorner = Instance.new("UICorner")
getKeyCorner.CornerRadius = UDim.new(0, 8)
getKeyCorner.Parent = getKeyButton

-- Join Discord Button
local joinButton = Instance.new("TextButton")
joinButton.Size = UDim2.new(0, 90, 0, 30)
joinButton.Position = UDim2.new(0, 200, 0, 0)
joinButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
joinButton.BackgroundTransparency = 1
joinButton.Text = "Join Discord"
joinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
joinButton.TextSize = 14
joinButton.Font = Enum.Font.SourceSansBold
joinButton.TextTransparency = 1
joinButton.Parent = buttonsFrame

local joinCorner = Instance.new("UICorner")
joinCorner.CornerRadius = UDim.new(0, 8)
joinCorner.Parent = joinButton

local function ShowKeySystem()
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
    local getKeyTween = TweenService:Create(getKeyButton, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0.3,
        TextTransparency = 0
    })
    local joinTween = TweenService:Create(joinButton, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
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
    wait(0.1)
    inputTween:Play()
    wait(0.1)
    statusTween:Play()
    wait(0.1)
    verifyTween:Play()
    getKeyTween:Play()
    joinTween:Play()
    closeTween:Play()
end

local function HideKeySystem()
    local frameTween = TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        BackgroundTransparency = 1
    })
    local strokeTween = TweenService:Create(uiStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Transparency = 1
    })
    local titleTween = TweenService:Create(titleLabel, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        TextTransparency = 1
    })
    local inputTween = TweenService:Create(keyInput, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        BackgroundTransparency = 1,
        TextTransparency = 1
    })
    local statusTween = TweenService:Create(statusLabel, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        TextTransparency = 1
    })
    local verifyTween = TweenService:Create(verifyButton, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        BackgroundTransparency = 1,
        TextTransparency = 1
    })
    local getKeyTween = TweenService:Create(getKeyButton, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        BackgroundTransparency = 1,
        TextTransparency = 1
    })
    local joinTween = TweenService:Create(joinButton, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        BackgroundTransparency = 1,
        TextTransparency = 1
    })
    local closeTween = TweenService:Create(closeButton, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        BackgroundTransparency = 1,
        TextTransparency = 1
    })

    frameTween:Play()
    strokeTween:Play()
    titleTween:Play()
    inputTween:Play()
    statusTween:Play()
    verifyTween:Play()
    getKeyTween:Play()
    joinTween:Play()
    closeTween:Play()

    frameTween.Completed:Wait()
    screenGui:Destroy()
end

local isVerified = false
local savedUsers = {}
local webhookUrl = "https://discord.com/api/webhooks/1393833582031536129/Y_A6sApiNPXAqZC04-Cd4hezGxmk3Kn7a67zb007JxzgZWD5TyQqkhOphoduI4BMV5aD"
local discordInvite = "https://discord.gg/bpsNUH5sVb" -- Replace with your actual invite link
local savedUsersUrl = "https://raw.githubusercontent.com/pickletalk/Scripts-Hub-X/refs/heads/main/savedusers.txt" -- Replace with your Raw URL

-- Load saved users from GitHub Raw
local function loadSavedUsers()
    local success, response = pcall(function()
        return game:HttpGet(savedUsersUrl)
    end)
    if success and response ~= "" then
        for line in response:gmatch("[^\r\n]+") do
            local userId, key, expiry = line:match("(%d+),([^,]+),(%d+)")
            if userId and key and expiry then
                savedUsers[userId] = {key = key, expiry = tonumber(expiry)}
            end
        end
    end
end

-- Save user to GitHub (placeholder; requires write endpoint)
local function saveUser(userId, key)
    local expiry = os.time() + 48 * 3600 -- 48 hours from now
    savedUsers[userId] = {key = key, expiry = expiry}
    local fileContent = ""
    for id, info in pairs(savedUsers) do
        fileContent = fileContent .. id .. "," .. info.key .. "," .. info.expiry .. "\n"
    end
    -- Placeholder: Replace with your write endpoint
    local success, err = pcall(function()
        game:HttpPost("https://your-write-endpoint.com/update", "file=savedusers.txt&content=" .. HttpService:UrlEncode(fileContent))
    end)
    if not success then
        warn("Failed to save user: " .. tostring(err))
    end
end

-- Generate random key
local function generateRandomKey()
    local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local key = "Key="
    for i = 1, 8 do
        key = key .. chars:sub(math.random(1, #chars), math.random(1, #chars))
    end
    return key
end

-- Send webhook message
local function sendWebhookMessage(username, key)
    local message = username .. " here's your " .. key
    local success, err = pcall(function()
        local response = game:HttpPost(webhookUrl, message, nil, false) -- Force HTTP
        if not success then
            warn("Webhook failed: " .. tostring(err) .. " Response: " .. tostring(response))
        end
    end)
    if not success then
        warn("Failed to send webhook: " .. tostring(err))
    end
end

-- Check if user has valid key
local function checkUserKey(userId, inputKey)
    local userData = savedUsers[userId]
    if userData and userData.key == inputKey and userData.expiry > os.time() then
        return true
    end
    return false
end

local function VerifyKey()
    local inputKey = keyInput.Text:upper()
    if checkUserKey(userId, inputKey) then
        statusLabel.Text = "Key accepted! Loading..."
        statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        isVerified = true
        wait(1)
        HideKeySystem()
    else
        statusLabel.Text = "Invalid key! Try again."
        statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        keyInput.Text = ""
        wait(2)
        statusLabel.Text = "Join our Discord for a key!"
        statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    end
end

getKeyButton.MouseButton1Click:Connect(function()
    game:HttpGet(discordInvite) -- Redirect to Discord
    local randomKey = generateRandomKey()
    sendWebhookMessage(username, randomKey)
    saveUser(userId, randomKey)
    statusLabel.Text = "Check Discord for your key!"
    statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    wait(2)
    statusLabel.Text = "Join our Discord for a key!"
    statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
end)

joinButton.MouseButton1Click:Connect(function()
    setclipboard(discordInvite)
    joinButton.Text = "Copied!"
    joinButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255) -- Lighter blue
    wait(1)
    joinButton.Text = "Join Discord"
    joinButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
end)

closeButton.MouseButton1Click:Connect(HideKeySystem)

verifyButton.MouseButton1Click:Connect(VerifyKey)

loadSavedUsers()

-- Check if user already has a valid key on load
if savedUsers[userId] and savedUsers[userId].expiry > os.time() then
    isVerified = true
    HideKeySystem()
end

return {
    ShowKeySystem = ShowKeySystem,
    HideKeySystem = HideKeySystem,
    IsKeyVerified = function() return isVerified end
}
