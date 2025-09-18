-- ========================================
-- PLATFORM UNDER FEET + ESP SCRIPT (FIXED)
-- ========================================
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local LocalPlayer = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")
local HttpService = game:GetService("HttpService")

-- Platform variables
local platformEnabled = false
local currentPlatform = nil
local platformUpdateConnection = nil
local PLATFORM_OFFSET = 3.563 -- Distance below player's feet (in studs)

-- ESP variables
local plotDisplays = {}
local playerBaseName = LocalPlayer.DisplayName .. "'s Base"
local playerBaseTimeWarning = false
local alertGui = nil

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
mainFrame.Position = UDim2.new(1, -260, 0, 140)
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
titleText.Text = "🔷 FLOAT 🔷"
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
toggleButton.Text = "🔷 ENABLE FLOATING 🔷"
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
-- PLATFORM FUNCTIONS
-- ========================================
local function createPlatform()
    local platform = Instance.new("Part")
    platform.Name = "PlayerPlatform"
    platform.Size = Vector3.new(8, 0.5, 8) -- Smaller platform that fits under player
    platform.Material = Enum.Material.Neon
    platform.BrickColor = BrickColor.new("Bright blue")
    platform.Anchored = true
    platform.CanCollide = true
    platform.Shape = Enum.PartType.Block
    platform.TopSurface = Enum.SurfaceType.Smooth
    platform.BottomSurface = Enum.SurfaceType.Smooth
    platform.Parent = workspace
    platform.Transparency = 1 -- Slightly visible so player can see it
    
    local pointLight = Instance.new("PointLight")
    pointLight.Color = Color3.fromRGB(0, 162, 255)
    pointLight.Brightness = 1
    pointLight.Range = 10
    pointLight.Parent = platform
    
    return platform
end

local function updatePlatformPosition()
    if not platformEnabled or not currentPlatform or not player.Character then
        return
    end
    
    local character = player.Character
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    
    if humanoidRootPart then
        local playerPosition = humanoidRootPart.Position
        -- Position platform directly under player's feet
        local platformPosition = Vector3.new(
            playerPosition.X, 
            playerPosition.Y - PLATFORM_OFFSET, 
            playerPosition.Z
        )
        currentPlatform.Position = platformPosition
    end
end

local function enablePlatform()
    if platformEnabled then return end
    
    platformEnabled = true
    currentPlatform = createPlatform()
    
    -- Start updating platform position immediately
    platformUpdateConnection = RunService.Heartbeat:Connect(updatePlatformPosition)
    
    -- Update platform position once immediately
    updatePlatformPosition()
    
    toggleButton.BackgroundColor3 = Color3.fromRGB(0, 150, 50)
    toggleButton.Text = "🔷 DISABLE FLOATING 🔷"
    
    print("Platform: ENABLED - Platform will follow under your feet")
end

local function disablePlatform()
    if not platformEnabled then return end
    
    platformEnabled = false
    
    if platformUpdateConnection then
        platformUpdateConnection:Disconnect()
        platformUpdateConnection = nil
    end
    
    if currentPlatform then
        currentPlatform:Destroy()
        currentPlatform = nil
    end
    
    toggleButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    toggleButton.Text = "🔷 ENABLE FLOATING 🔷"
    
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
-- ESP FUNCTIONS
-- ========================================

-- Function to create alert GUI for base time warning
local function createAlertGui()
    if alertGui then return end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    screenGui.Name = "BaseTimeAlert"
    screenGui.ResetOnSpawn = false
    
    local frame = Instance.new("Frame")
    frame.Parent = screenGui
    frame.Size = UDim2.new(0, 300, 0, 80)
    frame.Position = UDim2.new(0.5, -150, 0.1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    frame.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner")
    corner.Parent = frame
    corner.CornerRadius = UDim.new(0, 8)
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Parent = frame
    textLabel.Size = UDim2.new(1, -10, 1, -10)
    textLabel.Position = UDim2.new(0, 5, 0, 5)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = "⚠️ BASE TIME WARNING ⚠️"
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.TextScaled = true
    textLabel.TextStrokeTransparency = 0
    textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    textLabel.Font = Enum.Font.SourceSansBold
    
    local tween = TweenService:Create(
        frame,
        TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {BackgroundColor3 = Color3.fromRGB(150, 0, 0)}
    )
    tween:Play()
    
    alertGui = {
        screenGui = screenGui,
        textLabel = textLabel,
        tween = tween
    }
end

local function updateAlertGui(timeText)
    if not alertGui then return end
    alertGui.textLabel.Text = "⚠️ BASE UNLOCKING IN " .. timeText .. " ⚠️"
end

local function removeAlertGui()
    if alertGui then
        if alertGui.tween then
            alertGui.tween:Cancel()
        end
        alertGui.screenGui:Destroy()
        alertGui = nil
        playerBaseTimeWarning = false
    end
end

local function parseTimeToSeconds(timeText)
    if not timeText or timeText == "" then return nil end
    
    local minutes, seconds = timeText:match("(%d+):(%d+)")
    if minutes and seconds then
        return tonumber(minutes) * 60 + tonumber(seconds)
    end
    
    local secondsOnly = timeText:match("(%d+)s")
    if secondsOnly then
        return tonumber(secondsOnly)
    end
    
    local minutesOnly = timeText:match("(%d+)m")
    if minutesOnly then
        return tonumber(minutesOnly) * 60
    end
    
    return nil
end

local function createPlayerDisplay(player)
    if player == LocalPlayer then return end
    
    -- Wait for character with timeout
    local character = player.Character
    if not character then
        player.CharacterAdded:Connect(function(char)
            character = char
            task.wait(0.5) -- Give time for character to load
            local head = character:FindFirstChild("Head")
            if head then
                createPlayerESP(player, head)
            end
        end)
        return
    end
    
    local head = character:FindFirstChild("Head")
    if head then
        createPlayerESP(player, head)
    else
        character.ChildAdded:Connect(function(child)
            if child.Name == "Head" then
                createPlayerESP(player, child)
            end
        end)
    end
end

function createPlayerESP(player, head)
    -- Remove existing ESP if present
    local existingGui = head:FindFirstChild("PlayerESP")
    if existingGui then
        existingGui:Destroy()
    end
    
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Name = "PlayerESP"
    billboardGui.Parent = head
    billboardGui.Size = UDim2.new(0, 90, 0, 33) -- Made smaller
    billboardGui.StudsOffset = Vector3.new(0, 2, 0)
    billboardGui.AlwaysOnTop = true
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Parent = billboardGui
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = player.DisplayName
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.TextScaled = true
    textLabel.TextStrokeTransparency = 0.3
    textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    textLabel.Font = Enum.Font.SourceSans -- Changed from SourceSansBold to make it less prominent
end

local function createOrUpdatePlotDisplay(plot)
    if not plot or not plot.Parent then return end
    
    local plotName = plot.Name
    
    -- Get plot sign text
    local plotSignText = ""
    local signPath = plot:FindFirstChild("PlotSign")
    if signPath and signPath:FindFirstChild("SurfaceGui") then
        local surfaceGui = signPath.SurfaceGui
        if surfaceGui:FindFirstChild("Frame") and surfaceGui.Frame:FindFirstChild("TextLabel") then
            plotSignText = surfaceGui.Frame.TextLabel.Text
        end
    end
    
    -- Skip empty bases
    if plotSignText == "Empty Base" or plotSignText == "" or plotSignText == "Empty's Base" then
        if plotDisplays[plotName] and plotDisplays[plotName].gui then
            plotDisplays[plotName].gui:Destroy()
            plotDisplays[plotName] = nil
        end
        return
    end
    
    -- Get remaining time
    local plotTimeText = ""
    local purchasesPath = plot:FindFirstChild("Purchases")
    if purchasesPath and purchasesPath:FindFirstChild("PlotBlock") then
        local plotBlock = purchasesPath.PlotBlock
        if plotBlock:FindFirstChild("Main") and plotBlock.Main:FindFirstChild("BillboardGui") then
            local billboardGui = plotBlock.Main.BillboardGui
            if billboardGui:FindFirstChild("RemainingTime") then
                plotTimeText = billboardGui.RemainingTime.Text
            end
        end
    end
    
    -- Handle player base time warning
    if plotSignText == playerBaseName then
        local remainingSeconds = parseTimeToSeconds(plotTimeText)
        
        if remainingSeconds and remainingSeconds <= 10 and remainingSeconds > 0 then
            if not playerBaseTimeWarning then
                createAlertGui()
                playerBaseTimeWarning = true
            end
            updateAlertGui(plotTimeText)
        elseif remainingSeconds and remainingSeconds > 10 then
            if playerBaseTimeWarning then
                removeAlertGui()
            end
        elseif not remainingSeconds or remainingSeconds <= 0 then
            if playerBaseTimeWarning then
                removeAlertGui()
            end
        end
    end
    
    -- Find display part
    local displayPart = plot:FindFirstChild("PlotSign")
    if not displayPart then
        -- Try to find any part in the plot
        for _, child in pairs(plot:GetChildren()) do
            if child:IsA("Part") or child:IsA("MeshPart") then
                displayPart = child
                break
            end
        end
    end
    
    if not displayPart then return end
    
    -- Create or update display
    if not plotDisplays[plotName] then
        -- Remove any existing billboard first
        local existingBillboard = displayPart:FindFirstChild("PlotESP")
        if existingBillboard then
            existingBillboard:Destroy()
        end
        
        local billboardGui = Instance.new("BillboardGui")
        billboardGui.Name = "PlotESP"
        billboardGui.Parent = displayPart
        billboardGui.Size = UDim2.new(0, 150, 0, 60)
        billboardGui.StudsOffset = Vector3.new(0, 8, 0)
        billboardGui.AlwaysOnTop = true
        
        local frame = Instance.new("Frame")
        frame.Parent = billboardGui
        frame.Size = UDim2.new(1, 0, 1, 0)
        frame.BackgroundTransparency = 0.7
        frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        frame.BorderSizePixel = 0
        
        local corner = Instance.new("UICorner")
        corner.Parent = frame
        corner.CornerRadius = UDim.new(0, 4)
        
        local signLabel = Instance.new("TextLabel")
        signLabel.Parent = frame
        signLabel.Size = UDim2.new(1, -4, 0.6, 0)
        signLabel.Position = UDim2.new(0, 2, 0, 2)
        signLabel.BackgroundTransparency = 1
        signLabel.Text = plotSignText
        signLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        signLabel.TextScaled = true
        signLabel.TextStrokeTransparency = 0.3
        signLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        signLabel.Font = Enum.Font.SourceSansBold
        
        local timeLabel = Instance.new("TextLabel")
        timeLabel.Parent = frame
        timeLabel.Size = UDim2.new(1, -4, 0.4, 0)
        timeLabel.Position = UDim2.new(0, 2, 0.6, 0)
        timeLabel.BackgroundTransparency = 1
        timeLabel.Text = plotTimeText
        timeLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
        timeLabel.TextScaled = true
        timeLabel.TextStrokeTransparency = 0.3
        timeLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        timeLabel.Font = Enum.Font.SourceSans
        
        plotDisplays[plotName] = {
            gui = billboardGui,
            signLabel = signLabel,
            timeLabel = timeLabel,
            plot = plot
        }
    else
        -- Update existing display
        if plotDisplays[plotName].signLabel then
            plotDisplays[plotName].signLabel.Text = plotSignText
        end
        if plotDisplays[plotName].timeLabel then
            plotDisplays[plotName].timeLabel.Text = plotTimeText
        end
    end
end

local function updateAllPlots()
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return end
    
    for _, plot in pairs(plots:GetChildren()) do
        if plot:IsA("Model") or plot:IsA("Folder") then
            pcall(function() -- Wrap in pcall to prevent errors
                createOrUpdatePlotDisplay(plot)
            end)
        end
    end
    
    -- Clean up displays for removed plots
    for plotName, display in pairs(plotDisplays) do
        if not plots:FindFirstChild(plotName) then
            if display.gui then
                display.gui:Destroy()
            end
            plotDisplays[plotName] = nil
        end
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
        
        if currentPlatform then
            currentPlatform:Destroy()
        end
        
        currentPlatform = createPlatform()
        updatePlatformPosition() -- Position it immediately
    end
end

player.CharacterAdded:Connect(onCharacterAdded)

-- ========================================
-- INITIALIZE ESP
-- ========================================

-- Setup player ESP for existing players
for _, playerObj in pairs(Players:GetPlayers()) do
    if playerObj ~= LocalPlayer then
        createPlayerDisplay(playerObj)
        playerObj.CharacterAdded:Connect(function()
            task.wait(0.5)
            createPlayerDisplay(playerObj)
        end)
    end
end

-- Setup player ESP for new players
Players.PlayerAdded:Connect(function(playerObj)
    if playerObj ~= LocalPlayer then
        createPlayerDisplay(playerObj)
        playerObj.CharacterAdded:Connect(function()
            task.wait(0.5)
            createPlayerDisplay(playerObj)
        end)
    end
end)

-- Initialize plot ESP
updateAllPlots()

-- Monitor for new plots
local plots = workspace:FindFirstChild("Plots")
if plots then
    plots.ChildAdded:Connect(function(child)
        if child:IsA("Model") or child:IsA("Folder") then
            task.wait(0.5)
            createOrUpdatePlotDisplay(child)
        end
    end)
end

-- Update plots continuously
task.spawn(function()
    while true do
        task.wait(0.5) -- Increased interval to reduce lag
        pcall(updateAllPlots)
    end
end)

-- ========================================
-- UI BUTTON CONNECTIONS
-- ========================================
toggleButton.MouseButton1Click:Connect(function()
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
    if platformEnabled then
        disablePlatform()
    end
    if alertGui then
        removeAlertGui()
    end
    screenGui:Destroy()
end)

-- ========================================
-- HOVER EFFECTS
-- ========================================
local function addHoverEffect(button, hoverColor, originalColor)
    button.MouseEnter:Connect(function()
        if button == toggleButton then
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
-- CLEANUP
-- ========================================
game:BindToClose(function()
    if platformEnabled then
        disablePlatform()
    end
    if alertGui then
        removeAlertGui()
    end
end)

Players.PlayerRemoving:Connect(function(playerObj)
    if playerObj == LocalPlayer then
        removeAlertGui()
    end
end)

-- ========================================
-- SCRIPT HOOKS (ADD TO END OF EXISTING CODE)
-- ========================================
-- Hook variables
local originalIndex
local hookedScripts = {
    [game:GetService("ReplicatedStorage").Items["Body Swap Potion"].BodySwapScript] = true,
    [game:GetService("ReplicatedStorage").Controllers.SpeedController] = true,
    [game:GetService("ReplicatedStorage").Controllers.CharacterController] = true,
    [game:GetService("ReplicatedStorage").Controllers.BackpackController] = true,
    [game:GetService("ReplicatedStorage").Controllers.PlayerController] = true
}

-- Index hook function
local function hookIndex()
    if originalIndex then return end -- Prevent double hooking
    
    originalIndex = getrawmetatable(game).__index
    
    local function customIndex(self, key)
        -- Check if this is one of our target scripts
        if hookedScripts[self] then
            -- Block access to critical properties/methods that would allow script execution
            if key == "Disabled" or key == "Source" or key == "Parent" or 
               key == "Archivable" or key == "Changed" or key == "ChildAdded" or
               key == "ChildRemoved" or key == "DescendantAdded" or key == "DescendantRemoving" or
               key == "AncestryChanged" or key == "AttributeChanged" then
                -- Return dummy values or nil to prevent script functionality
                if key == "Disabled" then
                    return true -- Make script think it's disabled
                elseif key == "Source" then
                    return "" -- Empty source
                elseif key == "Parent" then
                    return nil -- No parent
                else
                    return nil
                end
            end
        end
        
        -- For non-hooked scripts or non-blocked properties, use original index
        return originalIndex(self, key)
    end
    
    -- Set the custom index metamethod
    getrawmetatable(game).__index = customIndex
    
    print("Script hooks: ENABLED - Target scripts have been hooked")
end

-- Additional script disabling method
local function disableTargetScripts()
    pcall(function()
        -- Try to directly disable the scripts if possible
        for script, _ in pairs(hookedScripts) do
            if script and script.Parent then
                pcall(function()
                    script.Disabled = true
                    script.Parent = nil -- Remove from parent to prevent execution
                end)
            end
        end
    end)
end

-- Connection prevention for RemoteEvents/RemoteFunctions
local function preventConnections()
    -- Hook RemoteEvent connections
    local originalConnect = Instance.new("RemoteEvent").OnServerEvent.Connect
    local originalConnectClient = Instance.new("RemoteEvent").OnClientEvent.Connect
    
    -- Hook RemoteFunction calls
    local originalInvoke
    pcall(function()
        originalInvoke = Instance.new("RemoteFunction").OnServerInvoke
    end)
    
    -- Override connection methods for our target scripts
    local function hookedConnect(self, func)
        local source = debug.getinfo(2, "S").source
        -- Check if the connection is coming from one of our hooked scripts
        for script, _ in pairs(hookedScripts) do
            if script and tostring(script):find(tostring(source)) then
                -- Return a dummy connection that does nothing
                return {
                    Disconnect = function() end,
                    disconnect = function() end
                }
            end
        end
        -- Allow normal connections for other scripts
        return originalConnect(self, func)
    end
    
    -- Apply connection hooks
    getrawmetatable(game).__index = function(self, key)
        if key == "Connect" or key == "connect" then
            return hookedConnect
        end
        return originalIndex(self, key)
    end
end

-- Execute all hooks
local function executeHooks()
    -- Disable scripts directly first
    disableTargetScripts()
    
    -- Apply index hooks
    hookIndex()
    
    -- Prevent new connections
    preventConnections()
    
    -- Additional safety: Monitor and re-disable if scripts try to re-enable
    task.spawn(function()
        while true do
            task.wait(1)
            pcall(function()
                for script, _ in pairs(hookedScripts) do
                    if script and script.Parent and not script.Disabled then
                        script.Disabled = true
                    end
                end
            end)
        end
    end)
    
    print("All script hooks: EXECUTED - Target scripts are now hooked and disabled")
end

-- Execute the hooks immediately
executeHooks()

-- ========================================
-- NO JUMP DELAY FEATURE
-- ========================================

-- Variables for jump delay removal
local jumpDelayConnections = {}

-- Function to clean up old connections
local function cleanupJumpDelayConnections(character)
    if jumpDelayConnections[character] then
        for _, connection in pairs(jumpDelayConnections[character]) do
            if connection and connection.Connected then
                connection:Disconnect()
            end
        end
        jumpDelayConnections[character] = nil
    end
end

-- Function to setup no jump delay for a character
local function setupNoJumpDelay(character)
    -- Clean up any existing connections for this character
    cleanupJumpDelayConnections(character)
    
    -- Wait for humanoid to load
    local humanoid = character:WaitForChild("Humanoid")
    if not humanoid then return end
    
    -- Initialize connections table for this character
    jumpDelayConnections[character] = {}

    -- Remove jump delay by monitoring state changes
    local stateConnection = humanoid.StateChanged:Connect(function(oldState, newState)
        -- When player lands, immediately allow jumping again
        if newState == Enum.HumanoidStateType.Landed then
            task.spawn(function()
                task.wait() -- Wait one frame
                if humanoid and humanoid.Parent then
                    humanoid:ChangeState(Enum.HumanoidStateType.Running)
                end
            end)
        end
    end)
    
    -- Store the connection
    jumpDelayConnections[character][#jumpDelayConnections[character] + 1] = stateConnection
    
    -- Clean up connections when character is removed
    local cleanupConnection = character.AncestryChanged:Connect(function()
        if not character.Parent then
            cleanupJumpDelayConnections(character)
        end
    end)
    
    jumpDelayConnections[character][#jumpDelayConnections[character] + 1] = cleanupConnection
    
    print("No Jump Delay: Applied to character -", character.Name)
end

-- Function to remove jump delay
local function removeJumpDelay()
    -- Apply to current character if it exists
    if player.Character and player.Character.Parent then
        setupNoJumpDelay(player.Character)
    end
    
    -- Apply to future characters
    local characterAddedConnection = player.CharacterAdded:Connect(function(character)
        -- Wait a moment for character to fully load
        task.wait(0.5)
        if character and character.Parent then
            setupNoJumpDelay(character)
        end
    end)
    
    -- Handle character respawn/removal
    local characterRemovingConnection = player.CharacterRemoving:Connect(function(character)
        cleanupJumpDelayConnections(character)
    end)
    
    print("No Jump Delay: ENABLED - Jump delay removal system initialized")
end

-- Execute immediately
removeJumpDelay()

-- ========================================
-- ANIMAL ESP FEATURE (FIXED)
-- ========================================

-- Target animal names (just the names, not full paths)
local espTargetNames = {
    "Noobini Pizzanini",
    "Los Tralaleritos",
    "Las Tralaleritas", 
    "Graipuss Medussi",
    "La Grande Combinasion",
    "Nuclearo Dinossauro",
    "Garama and Madundung",
    "Pot Hotspot",
    "Las Vaquitas Saturnitas",
    "Chicleteira Bicicleteira",
    "Dragon Cannelloni",
    "Los Combinasionas",
    "Karkerkar Kurkur",
    "Los Hotspotsitos",
    "Esok Sekolah",
    "Blackhole Goat",
    "Dul Dul Dul",
    "Tortuginni Dragonfruitini",
    "Chimpanzini Spiderini",
    "Los Matteos",
    "Nooo My Hotspot",
    "Sammyini Spyderini",
    "La Supreme Combinasion",
    "Ketupat Kepat",
    "Los Orcalitos",
    "Urubini Flamenguini",
    "Tralalita Tralala",
    "Orcalero Orcala",
    "Bulbito Bandito Traktorito",
    "Piccione Macchina",
    "Trippi Troppi Troppa Trippa",
    "Los Tungtungtungcitos"
}

-- Convert to lookup table for faster searching
local espTargetLookup = {}
for _, name in pairs(espTargetNames) do
    espTargetLookup[name] = true
end

-- Variables for animal ESP
local animalESPDisplays = {}
local animalESPEnabled = true

-- Function to create ESP for an animal/object
local function createAnimalESP(object, name)
    if not object or not object.Parent or not animalESPEnabled then return end
    
    -- Remove existing ESP if present
    for _, child in pairs(object:GetChildren()) do
        if child.Name == "AnimalESP" then
            child:Destroy()
        end
    end
    
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Name = "AnimalESP"
    billboardGui.Parent = object
    billboardGui.Size = UDim2.new(0, 120, 0, 35)
    billboardGui.StudsOffset = Vector3.new(0, 5, 0)
    billboardGui.AlwaysOnTop = true
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Parent = billboardGui
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = name
    textLabel.TextColor3 = Color3.fromRGB(255, 100, 255) -- Pink color
    textLabel.TextScaled = true
    textLabel.TextStrokeTransparency = 0
    textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    textLabel.Font = Enum.Font.SourceSansBold
    
    return billboardGui
end

-- Function to scan ALL descendants for target animals
local function scanForTargetAnimals()
    local found = 0
    
    for _, descendant in pairs(workspace:GetDescendants()) do
        if descendant:IsA("Model") and espTargetLookup[descendant.Name] then
            local objId = tostring(descendant)
            
            if not animalESPDisplays[objId] then
                -- Try to find the best part for ESP
                local targetPart = descendant:FindFirstChild("HumanoidRootPart") or 
                                 descendant:FindFirstChild("Torso") or 
                                 descendant:FindFirstChild("Head") or
                                 descendant:FindFirstChildOfClass("Part") or
                                 descendant:FindFirstChildOfClass("MeshPart")
                
                if targetPart then
                    local espGui = createAnimalESP(targetPart, descendant.Name)
                    if espGui then
                        animalESPDisplays[objId] = {
                            gui = espGui,
                            object = descendant,
                            part = targetPart
                        }
                        found = found + 1
                        print("✅ Animal ESP: Found", descendant.Name, "at", targetPart:GetFullName())
                    end
                end
            end
        end
    end
    
    -- Clean up dead references
    for objId, display in pairs(animalESPDisplays) do
        if not display.object or not display.object.Parent or not display.part or not display.part.Parent then
            if display.gui then
                display.gui:Destroy()
            end
            animalESPDisplays[objId] = nil
        end
    end
    
    if found > 0 then
        print("🔍 Animal ESP: Scan complete - Found", found, "new animals")
    end
end

-- Function to initialize animal ESP
local function initializeAnimalESP()
    print("🚀 Animal ESP: Starting system...")
    
    -- Wait for workspace to load
    task.wait(3)
    
    -- Do initial scan
    scanForTargetAnimals()
    
    -- Monitor for new descendants
    workspace.DescendantAdded:Connect(function(descendant)
        if descendant:IsA("Model") and espTargetLookup[descendant.Name] then
            task.wait(0.5) -- Wait for model to fully load
            
            local objId = tostring(descendant)
            if not animalESPDisplays[objId] then
                local targetPart = descendant:FindFirstChild("HumanoidRootPart") or 
                                 descendant:FindFirstChild("Torso") or 
                                 descendant:FindFirstChild("Head") or
                                 descendant:FindFirstChildOfClass("Part") or
                                 descendant:FindFirstChildOfClass("MeshPart")
                
                if targetPart then
                    local espGui = createAnimalESP(targetPart, descendant.Name)
                    if espGui then
                        animalESPDisplays[objId] = {
                            gui = espGui,
                            object = descendant,
                            part = targetPart
                        }
                        print("✅ Animal ESP: New animal detected -", descendant.Name)
                    end
                end
            end
        end
    end)
    
    -- Periodic re-scan every 10 seconds
    task.spawn(function()
        while animalESPEnabled do
            task.wait(3)
            pcall(scanForTargetAnimals)
        end
    end)
    
    print("✅ Animal ESP: System initialized - Monitoring", #espTargetNames, "animal types")
end

-- Execute immediately
task.spawn(initializeAnimalESP)

-- Platform Float and Wall Transparency Script
-- Place this in StarterGui or StarterPlayerScripts
-- Configuration
local FLOAT_SPEED = 16 -- horizontal speed
local TRANSPARENCY_LEVEL = 0.4 -- how transparent walls become (0 = invisible, 1 = opaque)
local TRANSITION_TIME = 0.5 -- time for smooth transitions
local FLOAT_TOTAL_RANGE = 10 -- total vertical range in studs (kept to 10 as requested)
local FLOAT_RANGE_BELOW = FLOAT_TOTAL_RANGE / 2
local FLOAT_RANGE_ABOVE = FLOAT_TOTAL_RANGE / 2

-- State variables
local isFloating = false
local floatConnection = nil
local originalTransparencies = {}
local bodyPosition = nil
local bodyAngularVelocity = nil
local startingPosition = nil
local targetHeight = nil

-- Create a very small UI, placed just under the top center of the screen
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FloatGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Name = "FloatFrame"
frame.Size = UDim2.new(0, 64, 0, 24) -- small
frame.Position = UDim2.new(0.5, -32, 0, 6) -- top center, 6px from top
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BackgroundTransparency = 0.25
frame.BorderSizePixel = 0
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 6)
corner.Parent = frame

local button = Instance.new("TextButton")
button.Name = "FloatButton"
button.Size = UDim2.new(1, -4, 1, -4)
button.Position = UDim2.new(0, 2, 0, 2)
button.BackgroundTransparency = 1 -- invisible background, keep UI minimal
button.Text = "F"
button.TextColor3 = Color3.fromRGB(240, 240, 240)
button.TextScaled = false
button.Font = Enum.Font.GothamBold
button.TextSize = 14
button.BorderSizePixel = 0
button.Parent = frame

-- Helper: count entries in originalTransparencies
local function countSavedParts()
    local n = 0
    for _ in pairs(originalTransparencies) do n = n + 1 end
    return n
end

-- Store original transparencies and collision settings for likely walls/buildings
local function storeOriginalTransparencies()
    originalTransparencies = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local name = obj.Name:lower()
            local parentName = (obj.Parent and obj.Parent.Name or ""):lower()
            local isWallPart = name:find("wall") or name:find("roof") or name:find("ceiling") or name:find("floor") or name:find("building") or name:find("house") or parentName:find("building") or parentName:find("house") or parentName:find("wall")

            local size = obj.Size
            local isLargePart = (size.X > 10 or size.Y > 10 or size.Z > 10) and obj.Material ~= Enum.Material.Grass

            if isWallPart or isLargePart then
                originalTransparencies[obj] = {
                    transparency = obj.Transparency,
                    canCollide = obj.CanCollide,
                    part = obj
                }
            end
        end
    end
end

-- Make walls transparent and toggle collisions
local function makeWallsTransparent(transparent)
    for obj, data in pairs(originalTransparencies) do
        if obj and obj.Parent and data then
            local targetTransparency = transparent and TRANSPARENCY_LEVEL or data.transparency
            local targetCollision = transparent and false or data.canCollide

            local ok, tween = pcall(function()
                return TweenService:Create(obj, TweenInfo.new(TRANSITION_TIME, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = targetTransparency})
            end)
            if ok and tween then tween:Play() end

            obj.CanCollide = targetCollision
        end
    end
end

-- Enable floating using BodyPosition on HumanoidRootPart
local function enableFloat()
    local character = player.Character
    if not character then return end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not rootPart then return end

    startingPosition = rootPart.Position
    targetHeight = startingPosition.Y - FLOAT_RANGE_BELOW

    bodyPosition = Instance.new("BodyPosition")
    bodyPosition.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    bodyPosition.Position = Vector3.new(startingPosition.X, targetHeight, startingPosition.Z)
    bodyPosition.D = 1000
    bodyPosition.P = 3000
    bodyPosition.Parent = rootPart

    bodyAngularVelocity = Instance.new("BodyAngularVelocity")
    bodyAngularVelocity.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
    bodyAngularVelocity.AngularVelocity = Vector3.new(0, 0, 0)
    bodyAngularVelocity.Parent = rootPart

    -- Use delta from Heartbeat to move smoothly
    floatConnection = RunService.Heartbeat:Connect(function(delta)
        if not rootPart or not bodyPosition then return end

        local moveVector = humanoid.MoveDirection
        local camera = workspace.CurrentCamera
        if not camera then return end

        -- vertical input: Q up, E down
        local verticalInput = 0
        if UserInputService:IsKeyDown(Enum.KeyCode.Q) then
            verticalInput = 1
        elseif UserInputService:IsKeyDown(Enum.KeyCode.E) then
            verticalInput = -1
        end

        if verticalInput ~= 0 then
            local newHeight = targetHeight + (verticalInput * FLOAT_SPEED * delta)
            local minHeight = startingPosition.Y - FLOAT_RANGE_BELOW
            local maxHeight = startingPosition.Y + FLOAT_RANGE_ABOVE
            targetHeight = math.clamp(newHeight, minHeight, maxHeight)
        end

        -- horizontal movement relative to camera
        local relativeMovement = Vector3.new(0, 0, 0)
        if moveVector.Magnitude > 0 then
            relativeMovement = camera.CFrame:VectorToWorldSpace(Vector3.new(moveVector.X, 0, moveVector.Z))
        end

        local currentPos = rootPart.Position
        local targetPos = Vector3.new(
            currentPos.X + relativeMovement.X * FLOAT_SPEED * delta,
            targetHeight,
            currentPos.Z + relativeMovement.Z * FLOAT_SPEED * delta
        )

        bodyPosition.Position = targetPos
    end)
end

-- Disable floating and clean up
local function disableFloat()
    if floatConnection then
        floatConnection:Disconnect()
        floatConnection = nil
    end

    if bodyPosition then
        bodyPosition:Destroy()
        bodyPosition = nil
    end
    if bodyAngularVelocity then
        bodyAngularVelocity:Destroy()
        bodyAngularVelocity = nil
    end

    startingPosition = nil
    targetHeight = nil
end

-- Toggle float mode
local function toggleFloat()
    isFloating = not isFloating

    if isFloating then
        storeOriginalTransparencies()
        enableFloat()
        makeWallsTransparent(true)
        button.Text = "X"
        button.TextColor3 = Color3.fromRGB(220, 80, 80)
        print("Float enabled. Wall parts saved:", countSavedParts())
    else
        disableFloat()
        makeWallsTransparent(false)
        button.Text = "F"
        button.TextColor3 = Color3.fromRGB(240, 240, 240)
        print("Float disabled.")
    end
end

-- Button click
button.MouseButton1Click:Connect(toggleFloat)

-- Handle character respawn
player.CharacterAdded:Connect(function()
    isFloating = false
    button.Text = "F"
    button.TextColor3 = Color3.fromRGB(240, 240, 240)

    if floatConnection then
        floatConnection:Disconnect()
        floatConnection = nil
    end

    bodyPosition = nil
    bodyAngularVelocity = nil
    startingPosition = nil
    targetHeight = nil

    makeWallsTransparent(false)
end)

-- Keyboard shortcut: F toggles
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.F then
        toggleFloat()
    end
end)

print("Platform Float script loaded. Press F or click the small UI to toggle.")
print("Controls: WASD to move, Q up, E down. Total float range:", FLOAT_TOTAL_RANGE, "studs")
