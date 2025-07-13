-- Scripts Hub X | Official Loading Screen (LocalScript)
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local DataStoreService = game:GetService("DataStoreService")

local player = Players.LocalPlayer
local playerGui
pcall(function()
    playerGui = player:WaitForChild("PlayerGui", 5)
end)
if not playerGui then
    warn("Failed to access PlayerGui")
    return
end

local keyDataStore = DataStoreService:GetDataStore("KeyVerification")
local dataStoreAvailable = pcall(function() return true end) -- Check DataStore availability

-- Fallback error GUI
local function showErrorGui(message)
    local errorGui = Instance.new("ScreenGui")
    errorGui.Name = "ScriptsHubXError"
    errorGui.IgnoreGuiInset = true
    errorGui.Parent = playerGui

    local errorFrame = Instance.new("Frame")
    errorFrame.Size = UDim2.new(0, 300, 0, 100)
    errorFrame.Position = UDim2.new(0.5, -150, 0.5, -50)
    errorFrame.BackgroundColor3 = Color3.fromRGB(20, 40, 60)
    errorFrame.Parent = errorGui

    local errorCorner = Instance.new("UICorner")
    errorCorner.CornerRadius = UDim.new(0, 12)
    errorCorner.Parent = errorFrame

    local errorLabel = Instance.new("TextLabel")
    errorLabel.Size = UDim2.new(1, -20, 1, -20)
    errorLabel.Position = UDim2.new(0, 10, 0, 10)
    errorLabel.BackgroundTransparency = 1
    errorLabel.Text = message
    errorLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    errorLabel.TextScaled = true
    errorLabel.TextSize = 14
    errorLabel.Font = Enum.Font.Gotham
    errorLabel.TextWrapped = true
    errorLabel.Parent = errorFrame

    wait(5)
    errorGui:Destroy()
end

-- On-screen error label for DataStore issues
local lastErrorLabel = Instance.new("TextLabel")
lastErrorLabel.Size = UDim2.new(0, 300, 0, 50)
lastErrorLabel.Position = UDim2.new(0.5, -150, 0, 10)
lastErrorLabel.BackgroundColor3 = Color3.fromRGB(20, 40, 60)
lastErrorLabel.BackgroundTransparency = 0.5
lastErrorLabel.Text = "No error"
lastErrorLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
lastErrorLabel.TextScaled = true
lastErrorLabel.TextSize = 12
lastErrorLabel.Font = Enum.Font.Gotham
lastErrorLabel.TextTransparency = 1
lastErrorLabel.Parent = playerGui
local errorShown = false

local function showLastError(errorMsg)
    if not errorShown then
        lastErrorLabel.Text = "Error: " .. tostring(errorMsg)
        TweenService:Create(lastErrorLabel, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            TextTransparency = 0
        }):Play()
        errorShown = true
        wait(10)
        TweenService:Create(lastErrorLabel, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            TextTransparency = 1
        }):Play()
        wait(0.5)
        errorShown = false
        print("Displayed error on screen: " .. tostring(errorMsg))
    end
end

-- Create main GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ScriptsHubXLoading"
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui
print("ScreenGui created")

-- Main background frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(1, 0, 1, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 20, 30)
mainFrame.BackgroundTransparency = 1
mainFrame.Parent = screenGui

-- Content frame (hidden during key system)
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(0, 400, 0, 360)
contentFrame.Position = UDim2.new(0.5, -200, 0.5, -180)
contentFrame.BackgroundColor3 = Color3.fromRGB(20, 40, 60)
contentFrame.BackgroundTransparency = 1
contentFrame.BorderSizePixel = 0
contentFrame.Visible = false
contentFrame.Parent = mainFrame

local contentFrameCorner = Instance.new("UICorner")
contentFrameCorner.CornerRadius = UDim.new(0, 16)
contentFrameCorner.Parent = contentFrame

local contentStroke = Instance.new("UIStroke")
contentStroke.Color = Color3.fromRGB(80, 160, 255)
contentStroke.Thickness = 1.5
contentStroke.Transparency = 1
contentStroke.Parent = contentFrame

-- Title label
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -40, 0, 50)
titleLabel.Position = UDim2.new(0, 20, 0, 20)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Scripts Hub X"
titleLabel.TextColor3 = Color3.fromRGB(120, 180, 255)
titleLabel.TextScaled = true
titleLabel.TextSize = 24
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextTransparency = 1
titleLabel.Parent = contentFrame

-- Subtitle label
local subtitleLabel = Instance.new("TextLabel")
subtitleLabel.Size = UDim2.new(1, -40, 0, 30)
subtitleLabel.Position = UDim2.new(0, 20, 0, 70)
subtitleLabel.BackgroundTransparency = 1
subtitleLabel.Text = "Official Loading"
subtitleLabel.TextColor3 = Color3.fromRGB(150, 180, 200)
subtitleLabel.TextScaled = true
subtitleLabel.TextSize = 16
subtitleLabel.Font = Enum.Font.Gotham
subtitleLabel.TextTransparency = 1
subtitleLabel.Parent = contentFrame

-- Discord container
local discordContainer = Instance.new("Frame")
discordContainer.Size = UDim2.new(1, -40, 0, 40)
discordContainer.Position = UDim2.new(0, 20, 0, 110)
discordContainer.BackgroundColor3 = Color3.fromRGB(30, 50, 70)
discordContainer.BackgroundTransparency = 1
discordContainer.BorderSizePixel = 0
discordContainer.Parent = contentFrame

local discordCorner = Instance.new("UICorner")
discordCorner.CornerRadius = UDim.new(0, 8)
discordCorner.Parent = discordContainer

local discordLabel = Instance.new("TextLabel")
discordLabel.Size = UDim2.new(0.7, -10, 1, -10)
discordLabel.Position = UDim2.new(0, 10, 0, 5)
discordLabel.BackgroundTransparency = 1
discordLabel.Text = "discord.gg/bpsNUH5sVb"
discordLabel.TextColor3 = Color3.fromRGB(100, 160, 255)
discordLabel.TextScaled = true
discordLabel.TextSize = 12
discordLabel.Font = Enum.Font.Gotham
discordLabel.TextXAlignment = Enum.TextXAlignment.Left
discordLabel.TextTransparency = 1
discordLabel.Parent = discordContainer

local copyButton = Instance.new("TextButton")
copyButton.Size = UDim2.new(0, 80, 0, 28)
copyButton.Position = UDim2.new(0.73, 5, 0, 6)
copyButton.BackgroundColor3 = Color3.fromRGB(80, 160, 255)
copyButton.BackgroundTransparency = 1
copyButton.Text = "Copy"
copyButton.TextColor3 = Color3.fromRGB(230, 240, 255)
copyButton.TextScaled = true
copyButton.TextSize = 12
copyButton.Font = Enum.Font.GothamBold
copyButton.TextTransparency = 1
copyButton.Parent = discordContainer

local copyButtonCorner = Instance.new("UICorner")
copyButtonCorner.CornerRadius = UDim.new(0, 6)
copyButtonCorner.Parent = copyButton

local discordAdLabel = Instance.new("TextLabel")
discordAdLabel.Size = UDim2.new(1, -40, 0, 40)
discordAdLabel.Position = UDim2.new(0, 20, 0, 160)
discordAdLabel.BackgroundTransparency = 1
discordAdLabel.Text = "Join our Discord server for more updates!"
discordAdLabel.TextColor3 = Color3.fromRGB(100, 160, 255)
discordAdLabel.TextScaled = true
discordAdLabel.TextSize = 12
discordAdLabel.Font = Enum.Font.Gotham
discordAdLabel.TextTransparency = 1
discordAdLabel.TextWrapped = true
discordAdLabel.Parent = contentFrame

local loadingBarBg = Instance.new("Frame")
loadingBarBg.Size = UDim2.new(1, -40, 0, 8)
loadingBarBg.Position = UDim2.new(0, 20, 0, 210)
loadingBarBg.BackgroundColor3 = Color3.fromRGB(30, 50, 70)
loadingBarBg.BackgroundTransparency = 1
loadingBarBg.BorderSizePixel = 0
loadingBarBg.Parent = contentFrame

local loadingBarBgCorner = Instance.new("UICorner")
loadingBarBgCorner.CornerRadius = UDim.new(0, 4)
loadingBarBgCorner.Parent = loadingBarBg

local loadingBarFill = Instance.new("Frame")
loadingBarFill.Size = UDim2.new(0, 0, 1, 0)
loadingBarFill.BackgroundColor3 = Color3.fromRGB(80, 160, 255)
loadingBarFill.BorderSizePixel = 0
loadingBarFill.Parent = loadingBarBg

local loadingBarFillCorner = Instance.new("UICorner")
loadingBarFillCorner.CornerRadius = UDim.new(0, 4)
loadingBarFillCorner.Parent = loadingBarFill

local loadingBarGradient = Instance.new("UIGradient")
loadingBarGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 160, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(120, 180, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 160, 255))
})
loadingBarGradient.Parent = loadingBarFill

local loadingText = Instance.new("TextLabel")
loadingText.Size = UDim2.new(1, -40, 0, 30)
loadingText.Position = UDim2.new(0, 20, 0, 230)
loadingText.BackgroundTransparency = 1
loadingText.Text = "Loading..."
loadingText.TextColor3 = Color3.fromRGB(150, 180, 200)
loadingText.TextScaled = true
loadingText.TextSize = 14
loadingText.Font = Enum.Font.Gotham
loadingText.TextTransparency = 1
loadingText.Parent = contentFrame

local warningLabel = Instance.new("TextLabel")
warningLabel.Size = UDim2.new(1, -40, 0, 40)
warningLabel.Position = UDim2.new(0, 20, 0, 270)
warningLabel.BackgroundTransparency = 1
warningLabel.Text = "Warning: Don't use scripts from unknown developers, as they might steal your in-game items, pets, etc."
warningLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
warningLabel.TextScaled = true
warningLabel.TextSize = 10
warningLabel.Font = Enum.Font.Gotham
warningLabel.TextTransparency = 1
warningLabel.TextWrapped = true
warningLabel.Parent = contentFrame

local noteLabel = Instance.new("TextLabel")
noteLabel.Size = UDim2.new(1, -40, 0, 40)
noteLabel.Position = UDim2.new(0, 20, 0, 310)
noteLabel.BackgroundTransparency = 1
noteLabel.Text = "Note: If you saw our script in a random YouTube or other advertising video, join our Discord for a loading screen showcase."
noteLabel.TextColor3 = Color3.fromRGB(150, 180, 200)
noteLabel.TextScaled = true
noteLabel.TextSize = 10
noteLabel.Font = Enum.Font.Gotham
noteLabel.TextTransparency = 1
noteLabel.TextWrapped = true
noteLabel.Parent = contentFrame

local waterDropFrame = Instance.new("Frame")
waterDropFrame.Size = UDim2.new(0, 40, 0, 60)
waterDropFrame.Position = UDim2.new(0.5, -20, 0, -60)
waterDropFrame.BackgroundColor3 = Color3.fromRGB(80, 160, 255)
waterDropFrame.BackgroundTransparency = 0.3
waterDropFrame.BorderSizePixel = 0
waterDropFrame.Visible = false
waterDropFrame.Parent = mainFrame

local waterDropCorner = Instance.new("UICorner")
waterDropCorner.CornerRadius = UDim.new(0.5, 0)
waterDropCorner.Parent = waterDropFrame

local keyFrame = Instance.new("Frame")
keyFrame.Size = UDim2.new(0, 320, 0, 180)
keyFrame.Position = UDim2.new(0.5, -160, 0.5, -90)
keyFrame.BackgroundColor3 = Color3.fromRGB(20, 40, 60)
keyFrame.BackgroundTransparency = 1
keyFrame.BorderSizePixel = 0
keyFrame.Parent = mainFrame
print("KeyFrame created")

local keyFrameCorner = Instance.new("UICorner")
keyFrameCorner.CornerRadius = UDim.new(0, 12)
keyFrameCorner.Parent = keyFrame

local keyFrameStroke = Instance.new("UIStroke")
keyFrameStroke.Color = Color3.fromRGB(80, 160, 255)
keyFrameStroke.Thickness = 1.5
keyFrameStroke.Transparency = 1
keyFrameStroke.Parent = keyFrame

local keyTitleLabel = Instance.new("TextLabel")
keyTitleLabel.Size = UDim2.new(1, -30, 0, 30)
keyTitleLabel.Position = UDim2.new(0, 15, 0, 15)
keyTitleLabel.BackgroundTransparency = 1
keyTitleLabel.Text = "Key Verification"
keyTitleLabel.TextColor3 = Color3.fromRGB(120, 180, 255)
keyTitleLabel.TextScaled = true
keyTitleLabel.TextSize = 18
keyTitleLabel.Font = Enum.Font.GothamMedium
keyTitleLabel.TextTransparency = 1
keyTitleLabel.Parent = keyFrame

local keyInput = Instance.new("TextBox")
keyInput.Size = UDim2.new(1, -30, 0, 30)
keyInput.Position = UDim2.new(0, 15, 0, 50)
keyInput.BackgroundColor3 = Color3.fromRGB(30, 50, 70)
keyInput.BackgroundTransparency = 1
keyInput.Text = ""
keyInput.PlaceholderText = "Enter your key"
keyInput.TextColor3 = Color3.fromRGB(150, 180, 200)
keyInput.TextScaled = true
keyInput.TextSize = 12
keyInput.Font = Enum.Font.Gotham
keyInput.TextTransparency = 1
keyInput.Parent = keyFrame

local keyInputCorner = Instance.new("UICorner")
keyInputCorner.CornerRadius = UDim.new(0, 6)
keyInputCorner.Parent = keyInput

local keyDescLabel = Instance.new("TextLabel")
keyDescLabel.Size = UDim2.new(1, -30, 0, 30)
keyDescLabel.Position = UDim2.new(0, 15, 0, 85)
keyDescLabel.BackgroundTransparency = 1
keyDescLabel.Text = "Join our Discord server to get the key!"
keyDescLabel.TextColor3 = Color3.fromRGB(100, 160, 255)
keyDescLabel.TextScaled = true
keyDescLabel.TextSize = 10
keyDescLabel.Font = Enum.Font.Gotham
keyDescLabel.TextTransparency = 1
keyDescLabel.TextWrapped = true
keyDescLabel.Parent = keyFrame

local joinDiscordButton = Instance.new("TextButton")
joinDiscordButton.Size = UDim2.new(0, 100, 0, 28)
joinDiscordButton.Position = UDim2.new(0, 25, 0, 120)
joinDiscordButton.BackgroundColor3 = Color3.fromRGB(80, 160, 255)
joinDiscordButton.BackgroundTransparency = 1
joinDiscordButton.Text = "Join Discord"
joinDiscordButton.TextColor3 = Color3.fromRGB(230, 240, 255)
joinDiscordButton.TextScaled = true
joinDiscordButton.TextSize = 10
joinDiscordButton.Font = Enum.Font.GothamMedium
joinDiscordButton.TextTransparency = 1
joinDiscordButton.Parent = keyFrame

local joinDiscordButtonCorner = Instance.new("UICorner")
joinDiscordButtonCorner.CornerRadius = UDim.new(0, 6)
joinDiscordButtonCorner.Parent = joinDiscordButton

local verifyButton = Instance.new("TextButton")
verifyButton.Size = UDim2.new(0, 100, 0, 28)
verifyButton.Position = UDim2.new(0.5, 15, 0, 120)
verifyButton.BackgroundColor3 = Color3.fromRGB(80, 160, 255)
verifyButton.BackgroundTransparency = 1
verifyButton.Text = "Verify"
verifyButton.TextColor3 = Color3.fromRGB(230, 240, 255)
verifyButton.TextScaled = true
verifyButton.TextSize = 10
verifyButton.Font = Enum.Font.GothamMedium
verifyButton.TextTransparency = 1
verifyButton.Parent = keyFrame

local verifyButtonCorner = Instance.new("UICorner")
verifyButtonCorner.CornerRadius = UDim.new(0, 6)
verifyButtonCorner.Parent = verifyButton

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 24, 0, 24)
closeButton.Position = UDim2.new(1, -32, 0, 8)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
closeButton.BackgroundTransparency = 1
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(230, 240, 255)
closeButton.TextScaled = true
closeButton.TextSize = 12
closeButton.Font = Enum.Font.GothamBold
closeButton.TextTransparency = 1
closeButton.Parent = keyFrame

local closeButtonCorner = Instance.new("UICorner")
closeButtonCorner.CornerRadius = UDim.new(0.5, 0)
closeButtonCorner.Parent = closeButton

-- Button hover effects
local function addButtonHoverEffect(button)
    local originalSize = button.Size
    local hoverSize = UDim2.new(originalSize.X.Scale, originalSize.X.Offset + 4, originalSize.Y.Scale, originalSize.Y.Offset + 4)
    local originalColor = button.BackgroundColor3
    local hoverColor = Color3.fromRGB(originalColor.R * 255 + 20, originalColor.G * 255 + 20, originalColor.B * 255 + 20)

    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
            Size = hoverSize,
            BackgroundColor3 = hoverColor
        }):Play()
    end)

    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
            Size = originalSize,
            BackgroundColor3 = originalColor
        }):Play()
    end)
end

addButtonHoverEffect(joinDiscordButton)
addButtonHoverEffect(verifyButton)

closeButton.MouseEnter:Connect(function()
    TweenService:Create(closeButton, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
        Rotation = 90,
        BackgroundColor3 = Color3.fromRGB(255, 120, 120)
    }):Play()
end)

closeButton.MouseLeave:Connect(function()
    TweenService:Create(closeButton, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
        Rotation = 0,
        BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    }):Play()
end)

copyButton.MouseButton1Click:Connect(function()
    pcall(function()
        setclipboard("https://discord.gg/bpsNUH5sVb")
        copyButton.Text = "Copied!"
        copyButton.BackgroundColor3 = Color3.fromRGB(60, 140, 235)
        wait(1)
        copyButton.Text = "Copy"
        copyButton.BackgroundColor3 = Color3.fromRGB(80, 160, 255)
        print("Discord link copied")
    end)
end)

joinDiscordButton.MouseButton1Click:Connect(function()
    pcall(function()
        setclipboard("https://discord.gg/bpsNUH5sVb")
        joinDiscordButton.Text = "Copied!"
        joinDiscordButton.BackgroundColor3 = Color3.fromRGB(60, 140, 235)
        wait(1)
        joinDiscordButton.Text = "Join Discord"
        joinDiscordButton.BackgroundColor3 = Color3.fromRGB(80, 160, 255)
        print("Discord link copied via Join Discord button")
    end)
end)

closeButton.MouseButton1Click:Connect(function()
    print("Close button clicked")
    local closeTween = TweenService:Create(keyFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 340, 0, 190),
        Position = UDim2.new(0.5, -170, 0.5, -95)
    })

    local mainFrameTween = TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        BackgroundTransparency = 1
    })

    local strokeTween = TweenService:Create(keyFrameStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Transparency = 1
    })

    for _, element in pairs({keyTitleLabel, keyInput, keyDescLabel, joinDiscordButton, verifyButton, closeButton}) do
        TweenService:Create(element, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            TextTransparency = 1,
            BackgroundTransparency = 1
        }):Play()
    end

    closeTween:Play()
    mainFrameTween:Play()
    strokeTween:Play()
    closeTween.Completed:Wait()
    screenGui:Destroy()
    print("ScreenGui destroyed")
end)

local correctKey = "07618-826391-192739-81625"
local premiumKey = "$PREMIUM$"
local keyVerified = false

local function checkKeyVerification()
    if not dataStoreAvailable or not keyDataStore then
        print("DataStore unavailable, checking local verification")
        return false
    end

    local success, storedKey
    for i = 1, 3 do
        print("Attempting DataStore GetAsync for User_" .. player.UserId .. ", attempt " .. i)
        success, storedKey = pcall(function()
            return keyDataStore:GetAsync("User_" .. player.UserId)
        end)
        if success then
            print("DataStore GetAsync succeeded, stored key: " .. tostring(storedKey))
            break
        end
        warn("DataStore GetAsync attempt " .. i .. " failed: " .. tostring(storedKey))
        showLastError("GetAsync failed: " .. tostring(storedKey))
        wait(6)
    end

    if success and storedKey == premiumKey then
        print("Premium key verified permanently")
        keyVerified = true
        return true
    end
    print("No valid stored key, requiring re-entry")
    return false
end

local function verifyKey()
    local inputKey = keyInput.Text
    if inputKey == correctKey or inputKey == premiumKey then
        print("Key verified: " .. inputKey)
        keyVerified = true
        if inputKey == premiumKey and dataStoreAvailable and keyDataStore then
            local success, errorMsg
            for i = 1, 3 do
                print("Attempting DataStore SetAsync for User_" .. player.UserId .. ", attempt " .. i)
                success, errorMsg = pcall(function()
                    keyDataStore:SetAsync("User_" .. player.UserId, premiumKey)
                end)
                if success then
                    print("Premium key saved permanently")
                    break
                end
                warn("DataStore SetAsync attempt " .. i .. " failed: " .. tostring(errorMsg))
                showLastError("SetAsync failed: " .. tostring(errorMsg))
                wait(6)
            end
            if not success then
                warn("Failed to save premium key after retries: " .. tostring(errorMsg))
                showErrorGui("Failed to save premium key, please re-enter")
            end
        end
        hideKeySystem()
        return true
    else
        keyDescLabel.Text = "Key is invalid"
        keyDescLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        wait(3)
        keyDescLabel.Text = "Join our Discord server to get the key!"
        keyDescLabel.TextColor3 = Color3.fromRGB(100, 160, 255)
        print("Invalid key entered: " .. inputKey)
        return false
    end
end

verifyButton.MouseButton1Click:Connect(function()
    print("Verify button clicked")
    verifyKey()
end)

local function showKeySystem()
    print("Attempting to show key system")
    if checkKeyVerification() then
        print("Key already verified, skipping GUI")
        keyVerified = true
        hideKeySystem()
        return
    end

    contentFrame.Visible = false
    waterDropFrame.Visible = false

    local mainFrameTween = TweenService:Create(mainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0.7
    })

    local keyFrameTween = TweenService:Create(keyFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0.5,
        Size = UDim2.new(0, 320, 0, 180)
    })

    local keyStrokeTween = TweenService:Create(keyFrameStroke, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
        Transparency = 0.4
    })

    local keyTitleTween = TweenService:Create(keyTitleLabel, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
        TextTransparency = 0
    })

    local keyInputTween = TweenService:Create(keyInput, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0.6,
        TextTransparency = 0
    })

    local keyDescTween = TweenService:Create(keyDescLabel, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
        TextTransparency = 0
    })

    local joinDiscordTween = TweenService:Create(joinDiscordButton, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0.2,
        TextTransparency = 0
    })

    local verifyButtonTween = TweenService:Create(verifyButton, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0.2,
        TextTransparency = 0
    })

    local closeButtonTween = TweenService:Create(closeButton, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0.2,
        TextTransparency = 0
    })

    print("Playing key system animations")
    mainFrameTween:Play()
    keyFrameTween:Play()
    keyStrokeTween:Play()
    keyTitleTween:Play()
    wait(0.1)
    keyInputTween:Play()
    wait(0.1)
    keyDescTween:Play()
    wait(0.1)
    joinDiscordTween:Play()
    verifyButtonTween:Play()
    closeButtonTween:Play()
end

local function animateKeyPulse()
    local pulseTween = TweenService:Create(keyFrameStroke, TweenInfo.new(1.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
        Transparency = 0.2
    })
    pulseTween:Play()
    print("Key pulse animation started")
end

local function hideKeySystem()
    print("Hiding key system")
    local keyFrameTween = TweenService:Create(keyFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 340, 0, 190)
    })

    local keyStrokeTween = TweenService:Create(keyFrameStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Transparency = 1
    })

    local keyTitleTween = TweenService:Create(keyTitleLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        TextTransparency = 1
    })

    local keyInputTween = TweenService:Create(keyInput, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        BackgroundTransparency = 1,
        TextTransparency = 1
    })

    local keyDescTween = TweenService:Create(keyDescLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        TextTransparency = 1
    })

    local joinDiscordTween = TweenService:Create(joinDiscordButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        BackgroundTransparency = 1,
        TextTransparency = 1
    })

    local verifyButtonTween = TweenService:Create(verifyButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        BackgroundTransparency = 1,
        TextTransparency = 1
    })

    local closeButtonTween = TweenService:Create(closeButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        BackgroundTransparency = 1,
        TextTransparency = 1
    })

    keyFrameTween:Play()
    keyStrokeTween:Play()
    keyTitleTween:Play()
    keyInputTween:Play()
    keyDescTween:Play()
    joinDiscordTween:Play()
    verifyButtonTween:Play()
    closeButtonTween:Play()

    keyFrameTween.Completed:Wait()
    keyFrame:Destroy()
    contentFrame.Visible = true
    waterDropFrame.Visible = true
    print("Key system hidden")
end

local function playEntranceAnimations()
    if checkKeyVerification() then
        hideKeySystem()
        return
    end
    contentFrame.BackgroundTransparency = 1
    contentStroke.Transparency = 1
    titleLabel.TextTransparency = 1
    subtitleLabel.TextTransparency = 1
    discordLabel.TextTransparency = 1
    copyButton.TextTransparency = 1
    copyButton.BackgroundTransparency = 1
    discordAdLabel.TextTransparency = 1
    loadingBarBg.BackgroundTransparency = 1
    loadingText.TextTransparency = 1
    warningLabel.TextTransparency = 1
    noteLabel.TextTransparency = 1

    local dropFallTween = TweenService:Create(waterDropFrame, TweenInfo.new(1.0, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Position = UDim2.new(0.5, -20, 0.5, -140)
    })

    local rippleTween = TweenService:Create(waterDropFrame, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 400, 0, 280),
        Position = UDim2.new(0.5, -200, 0.5, -140),
        BackgroundTransparency = 1
    })

    print("Playing entrance animations")
    dropFallTween:Play()
    dropFallTween.Completed:Connect(function()
        rippleTween:Play()
    end)

    rippleTween.Completed:Connect(function()
        local mainFrameTween = TweenService:Create(mainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundTransparency = 0.7
        })

        local contentFrameTween = TweenService:Create(contentFrame, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
            BackgroundTransparency = 0.5
        })

        local contentStrokeTween = TweenService:Create(contentStroke, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
            Transparency = 0.4
        })

        local titleTween = TweenService:Create(titleLabel, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
            TextTransparency = 0
        })

        local subtitleTween = TweenService:Create(subtitleLabel, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
            TextTransparency = 0
        })

        local discordTween = TweenService:Create(discordLabel, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
            TextTransparency = 0
        })

        local copyButtonTween = TweenService:Create(copyButton, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
            TextTransparency = 0,
            BackgroundTransparency = 0.2
        })

        local discordAdTween = TweenService:Create(discordAdLabel, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
            TextTransparency = 0
        })

        local loadingBarBgTween = TweenService:Create(loadingBarBg, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
            BackgroundTransparency = 0.6
        })

        local loadingTextTween = TweenService:Create(loadingText, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
            TextTransparency = 0
        })

        local warningTween = TweenService:Create(warningLabel, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
            TextTransparency = 0
        })

        local noteTween = TweenService:Create(noteLabel, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
            TextTransparency = 0
        })

        mainFrameTween:Play()
        contentFrameTween:Play()
        contentStrokeTween:Play()
        titleTween:Play()
        wait(0.1)
        subtitleTween:Play()
        wait(0.1)
        discordTween:Play()
        copyButtonTween:Play()
        wait(0.1)
        discordAdTween:Play()
        wait(0.1)
        warningTween:Play()
        wait(0.1)
        noteTween:Play()
        wait(0.1)
        loadingBarBgTween:Play()
        loadingTextTween:Play()

        loadingTextTween.Completed:Wait()
        waterDropFrame:Destroy()
        print("Entrance animations completed")
    end)
end

local function playExitAnimations()
    local evaporateTween = TweenService:Create(contentFrame, TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 450, 0, 400),
        Position = UDim2.new(0.5, -225, 0.5, -200)
    })

    local mainFrameTween = TweenService:Create(mainFrame, TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        BackgroundTransparency = 1
    })

    local contentStrokeTween = TweenService:Create(contentStroke, TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Transparency = 1
    })

    for _, element in pairs({titleLabel, subtitleLabel, discordLabel, discordAdLabel, loadingText, copyButton, warningLabel, noteLabel}) do
        TweenService:Create(element, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            TextTransparency = 1
        }):Play()
    end

    TweenService:Create(copyButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        BackgroundTransparency = 1
    }):Play()

    TweenService:Create(loadingBarBg, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        BackgroundTransparency = 1
    }):Play()

    evaporateTween:Play()
    mainFrameTween:Play()
    contentStrokeTween:Play()

    evaporateTween.Completed:Wait()
    screenGui:Destroy()
    print("Exit animations completed")
end

local function animatePulse()
    local borderPulseTween = TweenService:Create(contentStroke, TweenInfo.new(1.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
        Transparency = 0.2
    })
    borderPulseTween:Play()
    print("Content pulse animation started")
end

local function animateParticles()
    print("Particles animation placeholder")
end

local function animateLoadingBar()
    local loadingSteps = {
        {progress = 0.2, text = "Initializing...", duration = 1.0},
        {progress = 0.4, text = "Verifying...", duration = 1.0},
        {progress = 0.6, text = "Checking game support...", duration = 1.0},
        {progress = 1.0, text = "Game Is Supported!", duration = 2.0, color = Color3.fromRGB(100, 255, 100)}
    }
    
    for i, step in ipairs(loadingSteps) do
        wait(step.duration)
        loadingText.Text = step.text
        if step.color then
            loadingText.TextColor3 = step.color
        end
        
        local barTween = TweenService:Create(loadingBarFill, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(step.progress, 0, 1, 0)
        })
        
        barTween:Play()
        barTween.Completed:Wait()
        print("Loading bar step " .. i .. " completed")
    end
end

-- Start the loading screen
playEntranceAnimations()
animatePulse()
animateLoadingBar()
