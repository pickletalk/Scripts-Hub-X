loadstring(game:HttpGet("https://raw.githubusercontent.com/gumanba/Scripts/main/StealaFreddy"))()


-- Infinite Jump Script (Fixed - Natural Jump Height)
-- by pickletalk

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Configuration
local player = Players.LocalPlayer
local isInfiniteJumpEnabled = false
local connections = {}

local function createNotification()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    screenGui.Name = "InfiniteJumpNotification"

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 200, 0, 0)
    frame.Position = UDim2.new(0.5, -100, 0.9, -40)
    frame.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    frame.BorderSizePixel = 0
    frame.Parent = screenGui

    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 10)
    uiCorner.Parent = frame

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = "Infinite Jump Enabled"
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.TextSize = 16
    textLabel.Parent = frame

    local tweenIn = TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 200, 0, 40)})
    tweenIn:Play()

    wait(1)
    local tweenOut = TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, 200, 0, 0)})
    tweenOut:Play()
    tweenOut.Completed:Connect(function()
        wait(0.5)
        screenGui:Destroy()
    end)
end

local function connectInfiniteJump()
    local connection = UserInputService.JumpRequest:Connect(function()
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            local humanoid = player.Character:FindFirstChild("Humanoid")
            local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
            
            if rootPart and humanoid and humanoid.Health > 0 then
                -- Temporarily set the humanoid state to allow jumping from any state
                humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
                humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying, false)
                
                -- Force the humanoid to think it's on the ground so it can jump naturally
                humanoid:ChangeState(Enum.HumanoidStateType.Landed)
                
                -- Wait a tiny bit then allow the jump to happen naturally
                wait()
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                
                -- Re-enable the states after a short delay
                wait(0.1)
                humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
                humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying, true)
            end
        end
    end)
    
    table.insert(connections, connection)
    return connection
end

local function enableInfiniteJump(toggle)
    if isInfiniteJumpEnabled == toggle then
        return
    end

    if toggle then
        isInfiniteJumpEnabled = true
        
        -- Connect for current character
        connectInfiniteJump()
        
        -- Handle character respawning
        local characterConnection = player.CharacterAdded:Connect(function(newCharacter)
            if isInfiniteJumpEnabled then
                wait(0.1)
                connectInfiniteJump()
            end
        end)
        
        table.insert(connections, characterConnection)
        
        -- Show notification when enabled
        createNotification()
    else
        isInfiniteJumpEnabled = false
        
        -- Disconnect all connections
        for _, connection in pairs(connections) do
            if connection then
                connection:Disconnect()
            end
        end
        connections = {}
    end
end

-- Enable infinite jump
enableInfiniteJump(true)

-- Draggable UI for Plot Teleporter (Roblox)
-- Place ID: 137167142636546

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PlotTeleporterUI"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 250, 0, 120)
mainFrame.Position = UDim2.new(0, 100, 0, 100)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Add corner radius
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = mainFrame

-- Title Bar (for dragging)
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = titleBar

-- Title Text
local titleText = Instance.new("TextLabel")
titleText.Name = "TitleText"
titleText.Size = UDim2.new(1, -30, 1, 0)
titleText.Position = UDim2.new(0, 5, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "Plot Teleporter"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.TextScaled = true
titleText.Font = Enum.Font.GothamBold
titleText.Parent = titleBar

-- Close Button
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

-- Teleport to Plot Button
local teleportButton = Instance.new("TextButton")
teleportButton.Name = "TeleportButton"
teleportButton.Size = UDim2.new(0, 220, 0, 35)
teleportButton.Position = UDim2.new(0, 15, 0, 45)
teleportButton.BackgroundColor3 = Color3.fromRGB(50, 150, 200)
teleportButton.Text = "Teleport to My Plot"
teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportButton.TextScaled = true
teleportButton.Font = Enum.Font.GothamBold
teleportButton.BorderSizePixel = 0
teleportButton.Parent = mainFrame

local teleportCorner = Instance.new("UICorner")
teleportCorner.CornerRadius = UDim.new(0, 6)
teleportCorner.Parent = teleportButton

-- Status Display
local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "StatusLabel"
statusLabel.Size = UDim2.new(1, -20, 0, 25)
statusLabel.Position = UDim2.new(0, 10, 0, 90)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Ready to teleport"
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

-- Find Player's Plot Function
local function findPlayerPlot()
    local workspace = game:GetService("Workspace")
    local plotsFolder = workspace:FindFirstChild("Plots")
    
    if not plotsFolder then
        statusLabel.Text = "Plots folder not found!"
        return nil
    end
    
    -- Get player's plot value
    local plotValue = player:FindFirstChild("Plot")
    if not plotValue then
        statusLabel.Text = "Plot value not found in player!"
        return nil
    end
    
    local plotNumber = plotValue.Value
    statusLabel.Text = "Looking for plot " .. tostring(plotNumber) .. "..."
    
    -- Find the specific plot by number/name
    local targetPlot = plotsFolder:FindFirstChild(tostring(plotNumber))
    if targetPlot then
        statusLabel.Text = "Found your plot: " .. tostring(plotNumber)
        return targetPlot
    else
        statusLabel.Text = "Plot " .. tostring(plotNumber) .. " not found!"
        return nil
    end
end

-- Teleport Function with Anti-Cheat Bypass
local function teleportToPlot()
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        statusLabel.Text = "Character not found!"
        return
    end
    
    local playerPlot = findPlayerPlot()
    if not playerPlot then
        return
    end
    
    -- Look for the teleport destination
    local collectZone = playerPlot:FindFirstChild("CollectZone")
    if not collectZone then
        statusLabel.Text = "CollectZone not found in plot!"
        return
    end
    
    local collectPart = collectZone:FindFirstChild("Collect")
    if not collectPart then
        statusLabel.Text = "Collect part not found in CollectZone!"
        return
    end
    
    -- Get teleport position
    local targetPosition = collectPart.Position + Vector3.new(0, 5, 0) -- Teleport slightly above
    local targetCFrame = CFrame.new(targetPosition)
    
    local rootPart = player.Character.HumanoidRootPart
    local currentPos = rootPart.Position
    local distance = (currentPos - targetPosition).Magnitude
    
    statusLabel.Text = "Teleporting... (" .. math.floor(distance) .. " studs)"
    
    -- Enable noclip for movement
    local function enableNoclip()
        for _, part in pairs(player.Character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
    
    -- Disable noclip
    local function disableNoclip()
        spawn(function()
            wait(0.5)
            if player.Character then
                for _, part in pairs(player.Character:GetChildren()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.CanCollide = true
                    end
                end
            end
        end)
    end
    
    enableNoclip()
    
    -- Teleport method based on distance
    if distance <= 100 then
        -- Short distance tween
        local tweenInfo = TweenInfo.new(
            math.max(0.3, distance / 200),
            Enum.EasingStyle.Sine,
            Enum.EasingDirection.InOut
        )
        local tween = TweenService:Create(rootPart, tweenInfo, {CFrame = targetCFrame})
        
        tween:Play()
        tween.Completed:Connect(function()
            disableNoclip()
            statusLabel.Text = "Teleported successfully!"
        end)
    else
        -- Long distance waypoint system
        local waypoints = {}
        local numWaypoints = math.min(math.floor(distance / 150), 4)
        
        for i = 1, numWaypoints do
            local progress = i / (numWaypoints + 1)
            local lerpedPos = currentPos:lerp(targetPosition, progress)
            
            local randomOffset = Vector3.new(
                math.random(-20, 20),
                math.random(-10, 30),
                math.random(-20, 20)
            )
            
            table.insert(waypoints, lerpedPos + randomOffset)
        end
        
        table.insert(waypoints, targetPosition)
        
        local currentWaypoint = 1
        local function moveToNextWaypoint()
            if currentWaypoint > #waypoints then
                local finalTween = TweenService:Create(rootPart, TweenInfo.new(0.2), {CFrame = targetCFrame})
                finalTween:Play()
                finalTween.Completed:Connect(function()
                    disableNoclip()
                    statusLabel.Text = "Teleported successfully!"
                end)
                return
            end
            
            local targetWaypoint = waypoints[currentWaypoint]
            local waypointDistance = (rootPart.Position - targetWaypoint).Magnitude
            local speed = math.max(100, math.min(waypointDistance * 3, 400))
            local time = waypointDistance / speed
            
            local tweenInfo = TweenInfo.new(
                math.max(0.1, time),
                Enum.EasingStyle.Sine,
                Enum.EasingDirection.InOut
            )
            
            local waypointCFrame = CFrame.new(targetWaypoint, targetWaypoint + (targetWaypoint - rootPart.Position).Unit)
            local tween = TweenService:Create(rootPart, tweenInfo, {CFrame = waypointCFrame})
            
            tween:Play()
            tween.Completed:Connect(function()
                currentWaypoint = currentWaypoint + 1
                moveToNextWaypoint()
            end)
        end
        
        moveToNextWaypoint()
    end
    
    -- Visual feedback
    spawn(function()
        local originalColor = teleportButton.BackgroundColor3
        teleportButton.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
        wait(0.3)
        teleportButton.BackgroundColor3 = originalColor
    end)
end

-- Button connections
teleportButton.MouseButton1Click:Connect(teleportToPlot)

-- Close button
closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Button hover effects
local function addHoverEffect(button, hoverColor, originalColor)
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = hoverColor
    end)
    
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = originalColor
    end)
end

-- Add hover effects
addHoverEffect(teleportButton, Color3.fromRGB(70, 170, 220), Color3.fromRGB(50, 150, 200))
addHoverEffect(closeButton, Color3.fromRGB(220, 70, 70), Color3.fromRGB(200, 50, 50))

print("Plot Teleporter loaded! Click the button to teleport to your owned plot.")

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Variables
local GodModeEnabled = false
local OriginalMaxHealth = 100
local HealthConnection = nil

-- Helper Functions
local function getHumanoid()
    local character = LocalPlayer.Character
    if character then
        return character:FindFirstChild("Humanoid")
    end
    return nil
end

-- God Mode Functions
local function enableGodMode()
    local humanoid = getHumanoid()
    if not humanoid then 
        print("No humanoid found!")
        return 
    end
    
    -- Store original max health
    if not GodModeEnabled then
        OriginalMaxHealth = humanoid.MaxHealth
        print("Stored original health:", OriginalMaxHealth)
    end
    
    -- Set the flag first
    GodModeEnabled = true
    
    -- Set health to infinite
    humanoid.MaxHealth = math.huge
    humanoid.Health = math.huge
    
    -- Create connection to maintain infinite health
    if HealthConnection then
        HealthConnection:Disconnect()
    end
    
    HealthConnection = humanoid.HealthChanged:Connect(function(health)
        if GodModeEnabled and health < math.huge then
            humanoid.Health = math.huge
        end
    end)
    
    print("God Mode enabled")
end

local function disableGodMode()
    GodModeEnabled = false
    
    local humanoid = getHumanoid()
    if humanoid then
        humanoid.MaxHealth = OriginalMaxHealth
        humanoid.Health = OriginalMaxHealth
        print("God Mode disabled, health restored to:", OriginalMaxHealth)
    end
    
    if HealthConnection then
        HealthConnection:Disconnect()
        HealthConnection = nil
    end
end

-- Wait for character to load before enabling
if LocalPlayer.Character then
    enableGodMode()
else
    LocalPlayer.CharacterAdded:Connect(function()
        wait(0.5) -- Small delay to ensure humanoid is loaded
        enableGodMode()
    end)
end

-- Handle respawning
LocalPlayer.CharacterAdded:Connect(function()
    wait(0.5)
    if GodModeEnabled then
        enableGodMode()
    end
end)
racter:FindFirstChild("Humanoid")
    end
    return nil
end

-- God Mode Functions
local function enableGodMode()
    local humanoid = getHumanoid()
    if not humanoid then 
        print("No humanoid found!")
        return 
    end
    
    -- Store original max health
    if not GodModeEnabled then
        OriginalMaxHealth = humanoid.MaxHealth
        print("Stored original health:", OriginalMaxHealth)
    end
    
    -- Set the flag first
    GodModeEnabled = true
    
    -- Set health to infinite
    humanoid.MaxHealth = math.huge
    humanoid.Health = math.huge
    
    -- Create connection to maintain infinite health
    if HealthConnection then
        HealthConnection:Disconnect()
    end
    
    HealthConnection = humanoid.HealthChanged:Connect(function(health)
        if GodModeEnabled and health < math.huge then
            humanoid.Health = math.huge
        end
    end)
    
    print("God Mode enabled")
end

local function disableGodMode()
    GodModeEnabled = false
    
    local humanoid = getHumanoid()
    if humanoid then
        humanoid.MaxHealth = OriginalMaxHealth
        humanoid.Health = OriginalMaxHealth
        print("God Mode disabled, health restored to:", OriginalMaxHealth)
    end
    
    if HealthConnection then
        HealthConnection:Disconnect()
        HealthConnection = nil
    end
end

-- Wait for character to load before enabling
if LocalPlayer.Character then
    enableGodMode()
else
    LocalPlayer.CharacterAdded:Connect(function()
        wait(0.5) -- Small delay to ensure humanoid is loaded
        enableGodMode()
    end)
end

-- Handle respawning
LocalPlayer.CharacterAdded:Connect(function()
    wait(0.5)
    if GodModeEnabled then
        enableGodMode()
    end
end)
