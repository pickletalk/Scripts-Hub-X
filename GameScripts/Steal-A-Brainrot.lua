-- ========================================
-- SHADOW HEIST TELEPORTER SCRIPT
-- ========================================
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Heist variables
local isHeistInProgress = false
local currentPlatform = nil

-- ========================================
-- SHADOW HEIST UI
-- ========================================
local playerGui = player:WaitForChild("PlayerGui")

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ShadowHeistUI"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 250, 0, 120)
mainFrame.Position = UDim2.new(1, -260, 0, 140) -- Position below the teleporter UI
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = mainFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = titleBar

local titleText = Instance.new("TextLabel")
titleText.Name = "TitleText"
titleText.Size = UDim2.new(1, -30, 1, 0)
titleText.Position = UDim2.new(0, 5, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "💰 Shadow Heist 💰"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.TextScaled = true
titleText.Font = Enum.Font.GothamBold
titleText.Parent = titleBar

local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 25, 0, 25)
closeButton.Position = UDim2.new(1, -27, 0, 2)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextScaled = true
closeButton.Font = Enum.Font.GothamBold
closeButton.BorderSizePixel = 0
closeButton.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 4)
closeCorner.Parent = closeButton

local stealButton = Instance.new("TextButton")
stealButton.Name = "StealButton"
stealButton.Size = UDim2.new(0, 220, 0, 35)
stealButton.Position = UDim2.new(0, 15, 0, 45)
stealButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
stealButton.Text = "💰 STEAL 💰"
stealButton.TextColor3 = Color3.fromRGB(255, 255, 255)
stealButton.TextScaled = true
stealButton.Font = Enum.Font.GothamBold
stealButton.BorderSizePixel = 0
stealButton.Parent = mainFrame

local stealCorner = Instance.new("UICorner")
stealCorner.CornerRadius = UDim.new(0, 6)
stealCorner.Parent = stealButton

local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "StatusLabel"
statusLabel.Size = UDim2.new(1, -20, 0, 25)
statusLabel.Position = UDim2.new(0, 10, 0, 90)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "by PickleTalk"
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = mainFrame

-- Dragging functionality
local dragging = false
local dragStart = nil
local startPos = nil

local function updateDrag(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        if dragging then
            updateDrag(input)
        end
    end
end)

-- ========================================
-- PLOT FINDING FUNCTIONS
-- ========================================
local function findPlayerPlot()
    local plotsFolder = workspace:FindFirstChild("Plots")
    if not plotsFolder then
        statusLabel.Text = "Plots folder not found!"
        wait(1.5)
        statusLabel.Text = "by PickleTalk"
        return nil
    end
    
    local playerDisplayName = player.DisplayName
    local targetPlotName = playerDisplayName .. "'s Base"
    
    statusLabel.Text = "Searching for plot..."
    
    -- Search through all UUID-named plot folders
    for _, plotFolder in pairs(plotsFolder:GetChildren()) do
        if plotFolder:IsA("Folder") then
            -- Look for PlotSign inside the UUID folder
            local plotSign = plotFolder:FindFirstChild("PlotSign")
            if plotSign then
                local surfaceGui = plotSign:FindFirstChild("SurfaceGui")
                if surfaceGui then
                    local frame = surfaceGui:FindFirstChild("Frame")
                    if frame then
                        local textLabel = frame:FindFirstChild("TextLabel")
                        if textLabel and textLabel.Text == targetPlotName then
                            statusLabel.Text = "Found plot: " .. plotFolder.Name
                            wait(1.5)
                            statusLabel.Text = "by PickleTalk"
                            return plotFolder
                        end
                    end
                end
            end
        end
    end
    
    statusLabel.Text = "Player plot not found!"
    wait(1.5)
    statusLabel.Text = "by PickleTalk"
    return nil
end

-- ========================================
-- PLATFORM FUNCTIONS
-- ========================================
local function createPlatform(position)
    local platform = Instance.new("Part")
    platform.Name = "HeistPlatform"
    platform.Size = Vector3.new(6, 0.5, 6) -- 6x0.5x6 studs
    platform.Material = Enum.Material.ForceField
    platform.BrickColor = BrickColor.new("Bright blue")
    platform.Anchored = true
    platform.CanCollide = true -- Player cannot pass through
    platform.Shape = Enum.PartType.Block
    platform.TopSurface = Enum.SurfaceType.Smooth
    platform.BottomSurface = Enum.SurfaceType.Smooth
    platform.Position = position
    platform.Transparency = 0.5 -- Make it mostly invisible but still visible
    platform.Parent = workspace
    
    return platform
end

local function movePlatformToTarget(platform, targetPosition, speed)
    if not platform or not platform.Parent then
        return
    end
    
    local startPosition = platform.Position
    local direction = (targetPosition - startPosition).Unit
    local distance = (targetPosition - startPosition).Magnitude
    local duration = distance / (speed or 50) -- Default speed of 50 studs per second
    
    local tweenInfo = TweenInfo.new(
        duration,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.InOut,
        0,
        false,
        0
    )
    
    local tween = TweenService:Create(platform, tweenInfo, {Position = targetPosition})
    tween:Play()
    
    return tween
end

-- ========================================
-- HEIST EXECUTION FUNCTIONS
-- ========================================
local function executeHeist()
    if isHeistInProgress then
        return -- Prevent double execution
    end
    
    isHeistInProgress = true
    stealButton.Text = "💰 STEALING... 💰"
    stealButton.BackgroundColor3 = Color3.fromRGB(150, 100, 0)
    
    local success, error = pcall(function()
        -- Step 1: Find player plot
        local playerPlot = findPlayerPlot()
        if not playerPlot then
            error("Player plot not found")
        end
        
        -- Step 2: Check for Map.Carpet
        local map = workspace:FindFirstChild("Map")
        if not map then
            error("Map not found")
        end
        
        local carpet = map:FindFirstChild("Carpet")
        if not carpet then
            error("Carpet not found")
        end
        
        -- Step 3: Check for DeliveryHitbox
        local deliveryHitbox = playerPlot:FindFirstChild("DeliveryHitbox")
        if not deliveryHitbox then
            error("DeliveryHitbox not found")
        end
        
        -- Step 4: Get player character
        local character = player.Character
        if not character then
            error("Character not found")
        end
        
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then
            error("HumanoidRootPart not found")
        end
        
        -- Step 5: Create platform below player
        local platformPosition = humanoidRootPart.Position + Vector3.new(0, -3, 0)
        currentPlatform = createPlatform(platformPosition)
        
        wait(0.3)
        
        -- Step 6: Calculate carpet target position
        local carpetPosition = carpet.Position
        local aboveCarpetPosition = carpetPosition + Vector3.new(0, 20, 0)
        local carpetPlatformPosition = aboveCarpetPosition + Vector3.new(0, -3, 0)
        
        -- Move platform towards carpet (this will push the player)
        local tween1 = movePlatformToTarget(currentPlatform, carpetPlatformPosition, 80)
        if tween1 then
            tween1.Completed:Wait()
        end
        
        wait(0.5)
        
        
        -- Step 7: Calculate delivery target position
        local deliveryPosition = deliveryHitbox.Position + Vector3.new(0, 5, 0)
        local deliveryPlatformPosition = deliveryPosition + Vector3.new(0, -3, 0)
        
        -- Move platform towards delivery (this will push the player)
        local tween2 = movePlatformToTarget(currentPlatform, deliveryPlatformPosition, 80)
        if tween2 then
            tween2.Completed:Wait()
        end
        
        wait(0.5)
        
        -- Step 8: Clean up platform
        if currentPlatform then
            currentPlatform:Destroy()
            currentPlatform = nil
        end
        
        -- Flash button green for success
        stealButton.BackgroundColor3 = Color3.fromRGB(0, 150, 50)
        stealButton.Text = "💰 STEAL COMPLETE! 💰"
        statusLabel.Text = "Heist successful!"
        statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        
        wait(2)
        
        -- Reset button
        stealButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        stealButton.Text = "💰 STEAL 💰"
        statusLabel.Text = "by PickleTalk"
        statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        
    end)
    
    if not success then
        -- Error handling
        statusLabel.Text = "Steal failed: " .. tostring(error)
        statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        
        -- Clean up platform on error
        if currentPlatform then
            currentPlatform:Destroy()
            currentPlatform = nil
        end
        
        -- Flash button red for failure
        stealButton.BackgroundColor3 = Color3.fromRGB(150, 30, 30)
        stealButton.Text = "💰 STEAL FAILED! 💰"
        
        wait(3)
        
        -- Reset button
        stealButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        stealButton.Text = "💰 STEAL 💰"
        statusLabel.Text = "by PickleTalk"
        statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    end
    
    isHeistInProgress = false
end

-- ========================================
-- CHARACTER HANDLING
-- ========================================
local function onCharacterAdded(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    
    -- Clean up any existing platform
    if currentPlatform then
        currentPlatform:Destroy()
        currentPlatform = nil
    end
    
    -- Reset heist state
    isHeistInProgress = false
    stealButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    stealButton.Text = "💰 STEAL 💰"
    statusLabel.Text = "by PickleTalk"
    statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
end

-- Connect character respawn handler
player.CharacterAdded:Connect(onCharacterAdded)

-- ========================================
-- UI BUTTON CONNECTIONS
-- ========================================
stealButton.MouseButton1Click:Connect(function()
    if not isHeistInProgress then
        -- Add button click animation
        local originalSize = stealButton.Size
        local clickTween = TweenService:Create(stealButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Size = UDim2.new(0, 210, 0, 33)})
        local releaseTween = TweenService:Create(stealButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Size = originalSize})
        
        clickTween:Play()
        clickTween.Completed:Connect(function()
            releaseTween:Play()
        end)
        
        executeHeist()
    end
end)

closeButton.MouseButton1Click:Connect(function()
    -- Clean up platform when closing
    if currentPlatform then
        currentPlatform:Destroy()
        currentPlatform = nil
    end
    screenGui:Destroy()
end)

-- ========================================
-- HOVER EFFECTS
-- ========================================
local function addHoverEffect(button, hoverColor, originalColor)
    button.MouseEnter:Connect(function()
        if not isHeistInProgress then
            button.BackgroundColor3 = hoverColor
        end
    end)
    
    button.MouseLeave:Connect(function()
        if not isHeistInProgress then
            button.BackgroundColor3 = originalColor
        end
    end)
end

addHoverEffect(closeButton, Color3.fromRGB(220, 70, 70), Color3.fromRGB(200, 50, 50))
addHoverEffect(stealButton, Color3.fromRGB(30, 30, 30), Color3.fromRGB(0, 0, 0))

-- ========================================
-- CLEANUP ON SCRIPT END
-- ========================================
game:BindToClose(function()
    if currentPlatform then
        currentPlatform:Destroy()
        currentPlatform = nil
    end
end)
