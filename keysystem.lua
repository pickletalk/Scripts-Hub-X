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
mainFrame.Size = UDim2.new(0, 300, 0, 200)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BackgroundTransparency = 1
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 10)
uiCorner.Parent = mainFrame

local uiStroke = Instance.new("UIStroke")
uiStroke.Color = Color3.fromRGB(0, 170, 255)
uiStroke.Thickness = 2
uiStroke.Transparency = 1
uiStroke.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -20, 0, 40)
titleLabel.Position = UDim2.new(0, 10, 0, 10)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Key System"
titleLabel.TextColor3 = Color3.fromRGB(0, 170, 255)
titleLabel.TextSize = 20
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextTransparency = 1
titleLabel.Parent = mainFrame

local keyInput = Instance.new("TextBox")
keyInput.Size = UDim2.new(1, -40, 0, 40)
keyInput.Position = UDim2.new(0, 20, 0, 60)
keyInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
keyInput.BackgroundTransparency = 1
keyInput.PlaceholderText = "Enter Key Here"
keyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
keyInput.TextSize = 14
keyInput.Font = Enum.Font.SourceSans
keyInput.TextTransparency = 1
keyInput.Parent = mainFrame

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 5)
inputCorner.Parent = keyInput

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -40, 0, 40)
statusLabel.Position = UDim2.new(0, 20, 0, 110)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Join our Discord for a key!"
statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
statusLabel.TextSize = 14
statusLabel.Font = Enum.Font.SourceSans
statusLabel.TextWrapped = true
statusLabel.TextTransparency = 1
statusLabel.Parent = mainFrame

local buttonsFrame = Instance.new("Frame")
buttonsFrame.Size = UDim2.new(1, -40, 0, 40)
buttonsFrame.Position = UDim2.new(0, 20, 0, 160)
buttonsFrame.BackgroundTransparency = 1
buttonsFrame.Parent = mainFrame

local verifyButton = Instance.new("TextButton")
verifyButton.Size = UDim2.new(0.48, -5, 1, 0)
verifyButton.Position = UDim2.new(0, 0, 0, 0)
verifyButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
verifyButton.BackgroundTransparency = 1
verifyButton.Text = "Verify"
verifyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
verifyButton.TextSize = 14
verifyButton.Font = Enum.Font.SourceSansBold
verifyButton.TextTransparency = 1
verifyButton.Parent = buttonsFrame

local verifyCorner = Instance.new("UICorner")
verifyCorner.CornerRadius = UDim.new(0, 5)
verifyCorner.Parent = verifyButton

local joinButton = Instance.new("TextButton")
joinButton.Size = UDim2.new(0.48, -5, 1, 0)
joinButton.Position = UDim2.new(0.52, 0, 0, 0)
joinButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
joinButton.BackgroundTransparency = 1
joinButton.Text = "Get Key"
joinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
joinButton.TextSize = 14
joinButton.Font = Enum.Font.SourceSansBold
joinButton.TextTransparency = 1
joinButton.Parent = buttonsFrame

local joinCorner = Instance.new("UICorner")
joinCorner.CornerRadius = UDim.new(0, 5)
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
    local joinTween = TweenService:Create(joinButton, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
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
    joinTween:Play()
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
    local joinTween = TweenService:Create(joinButton, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        BackgroundTransparency = 1,
        TextTransparency = 1
    })

    frameTween:Play()
    strokeTween:Play()
    titleTween:Play()
    inputTween:Play()
    statusTween:Play()
    verifyTween:Play()
    joinTween:Play()

    frameTween.Completed:Wait()
    screenGui:Destroy()
end

local isVerified = false
local savedUsers = {}
local webhookUrl = "https://discord.com/api/webhooks/1393833582031536129/Y_A6sApiNPXAqZC04-Cd4hezGxmk3Kn7a67zb007JxzgZWD5TyQqkhOphoduI4BMV5aD"
local discordInvite = "https://discord.gg/bpsNUH5sVb" -- Replace with your actual invite link

-- Load saved users from file
local function loadSavedUsers()
    local success, data = pcall(function()
        return readfile("savedusers.txt") or ""
    end)
    if success and data ~= "" then
        for line in data:gmatch("[^\r\n]+") do
            local userId, key, expiry = line:match("(%d+),([^,]+),(%d+)")
            if userId and key and expiry then
                savedUsers[userId] = {key = key, expiry = tonumber(expiry)}
            end
        end
    end
end

-- Save user to file
local function saveUser(userId, key)
    local expiry = os.time() + 48 * 3600 -- 48 hours from now
    savedUsers[userId] = {key = key, expiry = expiry}
    local fileContent = ""
    for id, info in pairs(savedUsers) do
        fileContent = fileContent .. id .. "," .. info.key .. "," .. info.expiry .. "\n"
    end
    writefile("savedusers.txt", fileContent)
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
        game:HttpPost(webhookUrl, message)
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
        statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end

joinButton.MouseButton1Click:Connect(function()
    game:HttpGet(discordInvite) -- Redirect to Discord invite
    local randomKey = generateRandomKey()
    sendWebhookMessage(username, randomKey)
    saveUser(userId, randomKey)
    statusLabel.Text = "Check Discord for your key!"
    statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    wait(2)
    statusLabel.Text = "Join our Discord for a key!"
    statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
end)

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
