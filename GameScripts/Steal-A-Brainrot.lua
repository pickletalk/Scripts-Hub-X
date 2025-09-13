-- ========================================
-- PLATFORM ELEVATOR SCRIPT
-- ========================================
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Platform variables
local platformEnabled = false
local currentPlatform = nil
local platformUpdateConnection = nil
local elevationStartY = nil
local isElevating = false
local elevationTween = nil

-- Elevation settings
local ELEVATION_HEIGHT = 80 -- studs
local ELEVATION_TIME = 2.5 -- seconds

-- ========================================
-- PLATFORM UI
-- ========================================
local playerGui = player:WaitForChild("PlayerGui")

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PlatformUI"
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
titleText.Text = "🔷 by PickleTalk 🔷"
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

local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0, 220, 0, 35)
toggleButton.Position = UDim2.new(0, 15, 0, 45)
toggleButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
toggleButton.Text = "🔷 ENABLE PLATFORM 🔷"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextScaled = true
toggleButton.Font = Enum.Font.GothamBold
toggleButton.BorderSizePixel = 0
toggleButton.Parent = mainFrame

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 6)
toggleCorner.Parent = toggleButton

local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "StatusLabel"
statusLabel.Size = UDim2.new(1, -20, 0, 25)
statusLabel.Position = UDim2.new(0, 10, 0, 90)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Platform: OFF"
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
-- PLATFORM FUNCTIONS
-- ========================================
local function createPlatform()
    local platform = Instance.new("Part")
    platform.Name = "PlayerPlatform"
    platform.Size = Vector3.new(6, 0.5, 6) -- 6x0.5x6 studs
    platform.Material = Enum.Material.Neon
    platform.BrickColor = BrickColor.new("Bright blue") -- Blue color
    platform.Anchored = true
    platform.CanCollide = true -- Player cannot pass through
    platform.Shape = Enum.PartType.Block
    platform.TopSurface = Enum.SurfaceType.Smooth
    platform.BottomSurface = Enum.SurfaceType.Smooth
    platform.Parent = workspace
    
    -- Add some visual effects
    local pointLight = Instance.new("PointLight")
    pointLight.Color = Color3.fromRGB(0, 162, 255)
    pointLight.Brightness = 1
    pointLight.Range = 10
    pointLight.Parent = platform
    
    return platform
end

local function updatePlatformPosition()
    if not platformEnabled or not currentPlatform or not player.Character or isElevating then
        return
    end
    
    local character = player.Character
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    
    if humanoidRootPart then
        -- Position platform 4 studs below the player (only X and Z, keep current Y)
        local playerPosition = humanoidRootPart.Position
        local platformPosition = Vector3.new(playerPosition.X, currentPlatform.Position.Y, playerPosition.Z)
        
        currentPlatform.Position = platformPosition
    end
end

local function startElevation()
    if not currentPlatform or not player.Character or isElevating then
        return
    end
    
    local character = player.Character
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    
    if not humanoidRootPart then return end
    
    isElevating = true
    
    -- Set starting position
    local playerPosition = humanoidRootPart.Position
    elevationStartY = playerPosition.Y - 6 -- 4 studs below player
    local targetY = elevationStartY + ELEVATION_HEIGHT
    
    -- Set initial platform position
    currentPlatform.Position = Vector3.new(playerPosition.X, elevationStartY, playerPosition.Z)
    
    -- Create elevation tween
    local tweenInfo = TweenInfo.new(
        ELEVATION_TIME,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out,
        0,
        false,
        0
    )
    
    elevationTween = TweenService:Create(currentPlatform, tweenInfo, {
        Position = Vector3.new(currentPlatform.Position.X, targetY, currentPlatform.Position.Z)
    })
    
    -- Update status
    statusLabel.Text = "Platform: ELEVATING"
    statusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    
    -- Start tween
    elevationTween:Play()
    
    -- Handle completion
    elevationTween.Completed:Connect(function()
        isElevating = false
        statusLabel.Text = "Platform: ELEVATED!"
        statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        print("Platform: Elevation complete - 40 studs reached!")
    end)
    
    print("Platform: Starting elevation - 40 studs in 1.5 seconds")
end

local function enablePlatform()
    if platformEnabled then return end
    
    platformEnabled = true
    
    -- Create the platform
    currentPlatform = createPlatform()
    
    -- Start elevation immediately
    task.wait(0.1) -- Small delay to ensure platform is created
    startElevation()
    
    -- Start the update loop (for X and Z positioning only)
    platformUpdateConnection = RunService.Heartbeat:Connect(updatePlatformPosition)
    
    -- Update UI
    toggleButton.BackgroundColor3 = Color3.fromRGB(0, 150, 50)
    toggleButton.Text = "🔷 DISABLE PLATFORM 🔷"
    
    print("Platform: ENABLED")
end

local function disablePlatform()
    if not platformEnabled then return end
    
    platformEnabled = false
    isElevating = false
    
    -- Stop any ongoing elevation
    if elevationTween then
        elevationTween:Cancel()
        elevationTween = nil
    end
    
    -- Disconnect the update loop
    if platformUpdateConnection then
        platformUpdateConnection:Disconnect()
        platformUpdateConnection = nil
    end
    
    -- Remove the platform
    if currentPlatform then
        currentPlatform:Destroy()
        currentPlatform = nil
    end
    
    -- Reset variables
    elevationStartY = nil
    
    -- Update UI
    toggleButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    toggleButton.Text = "🔷 ENABLE PLATFORM 🔷"
    statusLabel.Text = "Platform: OFF"
    statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    
    print("Platform: DISABLED")
end

local function togglePlatform()
    if platformEnabled then
        disablePlatform()
    else
        enablePlatform()
    end
end

-- ========================================
-- CHARACTER HANDLING
-- ========================================
local function onCharacterAdded(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    
    -- If platform was enabled, recreate it for the new character
    if platformEnabled then
        task.wait(1) -- Wait for character to fully load
        
        -- Stop any ongoing elevation
        if elevationTween then
            elevationTween:Cancel()
        end
        isElevating = false
        
        -- Remove old platform if it exists
        if currentPlatform then
            currentPlatform:Destroy()
        end
        
        -- Create new platform and start elevation
        currentPlatform = createPlatform()
        task.wait(0.1)
        startElevation()
    end
end

-- Connect character respawn handler
player.CharacterAdded:Connect(onCharacterAdded)

-- ========================================
-- UI BUTTON CONNECTIONS
-- ========================================
toggleButton.MouseButton1Click:Connect(function()
    -- Add button click animation
    local originalSize = toggleButton.Size
    local clickTween = TweenService:Create(toggleButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Size = UDim2.new(0, 210, 0, 33)})
    local releaseTween = TweenService:Create(toggleButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Size = originalSize})
    
    clickTween:Play()
    clickTween.Completed:Connect(function()
        releaseTween:Play()
    end)
    
    togglePlatform()
end)

closeButton.MouseButton1Click:Connect(function()
    -- Disable platform when closing
    if platformEnabled then
        disablePlatform()
    end
    screenGui:Destroy()
end)

-- ========================================
-- HOVER EFFECTS
-- ========================================
local function addHoverEffect(button, hoverColor, originalColor)
    button.MouseEnter:Connect(function()
        if button == toggleButton then
            -- Different hover color based on state
            if platformEnabled then
                button.BackgroundColor3 = Color3.fromRGB(50, 180, 80)
            else
                button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            end
        else
            button.BackgroundColor3 = hoverColor
        end
    end)
    
    button.MouseLeave:Connect(function()
        if button == toggleButton then
            -- Restore color based on state
            if platformEnabled then
                button.BackgroundColor3 = Color3.fromRGB(0, 150, 50)
            else
                button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            end
        else
            button.BackgroundColor3 = originalColor
        end
    end)
end

addHoverEffect(closeButton, Color3.fromRGB(220, 70, 70), Color3.fromRGB(200, 50, 50))
addHoverEffect(toggleButton, Color3.fromRGB(30, 30, 30), Color3.fromRGB(0, 0, 0))

-- ========================================
-- CLEANUP ON SCRIPT END
-- ========================================
game:BindToClose(function()
    if platformEnabled then
        disablePlatform()
    end
end)
