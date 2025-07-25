loadstring(game:HttpGet("https://raw.githubusercontent.com/gumanba/Scripts/main/StealaFreddy"))()

-- Infinite Jump Script
-- by pickletalk

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Configuration
local player = Players.LocalPlayer
local isInfiniteJumpEnabled = false

local function getOriginalJumpPower()
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    return humanoid.JumpPower
end

local function createNotification()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    screenGui.Name = "InfiniteJumpNotification"

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 200, 0, 0) -- Start with zero height
    frame.Position = UDim2.new(0.5, -100, 0.9, -40) -- Adjusted position for upward growth
    frame.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    frame.BorderSizePixel = 0
    frame.Parent = screenGui

    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 10) -- Smooth edges with 10px radius
    uiCorner.Parent = frame

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = "Successful Infinite Jump"
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.TextSize = 16
    textLabel.Parent = frame

    -- Grow upward animation
    local tweenIn = TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 200, 0, 40)})
    tweenIn:Play()

    -- Destroy after 1 second of visibility + 1 second shrink animation
    wait(1)
    local tweenOut = TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, 200, 0, 0)})
    tweenOut:Play()
    tweenOut.Completed:Connect(function()
        wait(0.5) -- Wait for shrink to complete
        screenGui:Destroy()
    end)
end

local function enableInfiniteJump(toggle)
    if isInfiniteJumpEnabled == toggle then
        return -- No action if state matches
    end

    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    local originalJumpPower = getOriginalJumpPower()
    local JUMP_POWER = originalJumpPower -- Use game's original jump power as base

    if toggle then
        isInfiniteJumpEnabled = true
        local connection
        connection = UserInputService.JumpRequest:Connect(function()
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
                if rootPart then
                    local bodyVelocity = Instance.new("BodyVelocity")
                    bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
                    bodyVelocity.Velocity = Vector3.new(0, JUMP_POWER, 0)
                    bodyVelocity.Parent = rootPart
                    game:GetService("Debris"):AddItem(bodyVelocity, 0.2)
                end
            end
        end)
        
        -- Ensure infinite jump persists on character removal
        local characterRemovedConnection = player.CharacterRemoving:Connect(function()
            if connection then
                connection:Disconnect()
            end
        end)
        
        -- Reconnect on character respawn
        player.CharacterAdded:Connect(function(newCharacter)
            character = newCharacter
            humanoid = character:WaitForChild("Humanoid")
            originalJumpPower = getOriginalJumpPower()
            JUMP_POWER = originalJumpPower
            if isInfiniteJumpEnabled then
                connection = UserInputService.JumpRequest:Connect(function()
                    if player.Character and player.Character:FindFirstChild("Humanoid") then
                        local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
                        if rootPart then
                            local bodyVelocity = Instance.new("BodyVelocity")
                            bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
                            bodyVelocity.Velocity = Vector3.new(0, JUMP_POWER, 0)
                            bodyVelocity.Parent = rootPart
                            game:GetService("Debris"):AddItem(bodyVelocity, 0.2)
                        end
                    end
                end)
                characterRemovedConnection:Disconnect()
                characterRemovedConnection = player.CharacterRemoving:Connect(function()
                    if connection then
                        connection:Disconnect()
                    end
                end)
            end
        end)
        
        -- Show notification when enabled
        createNotification()
    else
        isInfiniteJumpEnabled = false

        for _, connection in pairs(getconnections(UserInputService.JumpRequest)) do
            if connection.Function then
                connection:Disable()
            end
        end
        humanoid.JumpPower = originalJumpPower -- Restore original jump power
        if player.Character then
            local humanoid = player.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.JumpPower = originalJumpPower
            end
        end
    end
end

enableInfiniteJump(not isInfiniteJumpEnabled)

-- Draggable UI for Steal A Freddy (Roblox)
-- Place ID: 137167142636546

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Saved position storage
local savedPosition = nil

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PositionSaverUI"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 250, 0, 140)
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
titleText.Text = "by pickletalk"
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

-- Save Position Button
local saveButton = Instance.new("TextButton")
saveButton.Name = "SaveButton"
saveButton.Size = UDim2.new(0, 110, 0, 30)
saveButton.Position = UDim2.new(0, 10, 0, 40)
saveButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
saveButton.Text = "Save Position"
saveButton.TextColor3 = Color3.fromRGB(255, 255, 255)
saveButton.TextScaled = true
saveButton.Font = Enum.Font.Gotham
saveButton.BorderSizePixel = 0
saveButton.Parent = mainFrame

local saveCorner = Instance.new("UICorner")
saveCorner.CornerRadius = UDim.new(0, 6)
saveCorner.Parent = saveButton

-- Teleport Button
local teleportButton = Instance.new("TextButton")
teleportButton.Name = "TeleportButton"
teleportButton.Size = UDim2.new(0, 110, 0, 30)
teleportButton.Position = UDim2.new(0, 130, 0, 40)
teleportButton.BackgroundColor3 = Color3.fromRGB(150, 50, 150)
teleportButton.Text = "Teleport"
teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportButton.TextScaled = true
teleportButton.Font = Enum.Font.Gotham
teleportButton.BorderSizePixel = 0
teleportButton.Parent = mainFrame

local teleportCorner = Instance.new("UICorner")
teleportCorner.CornerRadius = UDim.new(0, 6)
teleportCorner.Parent = teleportButton

-- Position Display
local positionLabel = Instance.new("TextLabel")
positionLabel.Name = "PositionLabel"
positionLabel.Size = UDim2.new(1, -20, 0, 25)
positionLabel.Position = UDim2.new(0, 10, 0, 80)
positionLabel.BackgroundTransparency = 1
positionLabel.Text = "Current: X=0, Y=0, Z=0"
positionLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
positionLabel.TextScaled = true
positionLabel.Font = Enum.Font.Gotham
positionLabel.TextXAlignment = Enum.TextXAlignment.Left
positionLabel.Parent = mainFrame

-- Saved Position Display
local savedLabel = Instance.new("TextLabel")
savedLabel.Name = "SavedLabel"
savedLabel.Size = UDim2.new(1, -20, 0, 25)
savedLabel.Position = UDim2.new(0, 10, 0, 105)
savedLabel.BackgroundTransparency = 1
savedLabel.Text = "Saved: None"
savedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
savedLabel.TextScaled = true
savedLabel.Font = Enum.Font.Gotham
savedLabel.TextXAlignment = Enum.TextXAlignment.Left
savedLabel.Parent = mainFrame

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

-- Save Position Function
local function savePosition()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local rootPart = player.Character.HumanoidRootPart
        savedPosition = rootPart.CFrame
        
        local pos = savedPosition.Position
        savedLabel.Text = string.format("Saved: X=%.1f, Y=%.1f, Z=%.1f", pos.X, pos.Y, pos.Z)
        
        -- Visual feedback
        local originalColor = saveButton.BackgroundColor3
        saveButton.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
        wait(0.2)
        saveButton.BackgroundColor3 = originalColor
        
        print("Position saved!")
    else
        print("Cannot save position - character not found!")
    end
end

-- Teleport Function with Improved Anti-Cheat Bypass
local function teleportToSaved()
    if savedPosition and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local rootPart = player.Character.HumanoidRootPart
        local humanoid = player.Character:FindFirstChild("Humanoid")
        
        local currentPos = rootPart.Position
        local targetPos = savedPosition.Position
        local distance = (currentPos - targetPos).Magnitude
        
        print("Distance to target: " .. math.floor(distance) .. " studs")
        
        -- Enable noclip for all movement
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
                wait(0.5) -- Wait a bit before re-enabling collision
                if player.Character then
                    for _, part in pairs(player.Character:GetChildren()) do
                        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                            part.CanCollide = true
                        end
                    end
                end
            end)
        end
        
        -- Method 1: Short distance tween with noclip
        if distance <= 100 then
            enableNoclip()
            
            local tweenInfo = TweenInfo.new(
                math.max(0.3, distance / 200), -- Faster for short distances
                Enum.EasingStyle.Sine,
                Enum.EasingDirection.InOut
            )
            local tween = TweenService:Create(rootPart, tweenInfo, {CFrame = savedPosition})
            
            tween:Play()
            tween.Completed:Connect(function()
                disableNoclip()
            end)
            
        -- Method 2: Long distance - Multiple waypoint system
        else
            enableNoclip()
            
            -- Calculate waypoints to avoid straight-line detection
            local waypoints = {}
            local numWaypoints = math.min(math.floor(distance / 150), 4) -- Max 4 waypoints
            
            for i = 1, numWaypoints do
                local progress = i / (numWaypoints + 1)
                local lerpedPos = currentPos:lerp(targetPos, progress)
                
                -- Add slight random offset to avoid straight line
                local randomOffset = Vector3.new(
                    math.random(-20, 20),
                    math.random(-10, 30), -- Slightly upward bias
                    math.random(-20, 20)
                )
                
                table.insert(waypoints, lerpedPos + randomOffset)
            end
            
            -- Add final target
            table.insert(waypoints, targetPos)
            
            -- Move through waypoints
            local currentWaypoint = 1
            local function moveToNextWaypoint()
                if currentWaypoint > #waypoints then
                    -- Final positioning
                    local finalTween = TweenService:Create(rootPart, TweenInfo.new(0.2), {CFrame = savedPosition})
                    finalTween:Play()
                    finalTween.Completed:Connect(function()
                        disableNoclip()
                    end)
                    return
                end
                
                local targetWaypoint = waypoints[currentWaypoint]
                local waypointDistance = (rootPart.Position - targetWaypoint).Magnitude
                local speed = math.max(100, math.min(waypointDistance * 3, 400)) -- Dynamic speed
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
            teleportButton.BackgroundColor3 = Color3.fromRGB(255, 100, 255)
            wait(0.3)
            teleportButton.BackgroundColor3 = originalColor
        end)
        
        print("Moving to saved position with noclip...")
    else
        if not savedPosition then
            print("No saved position!")
        else
            print("Cannot teleport - character not found!")
        end
    end
end

-- Button connections
saveButton.MouseButton1Click:Connect(savePosition)
teleportButton.MouseButton1Click:Connect(teleportToSaved)

-- Close button
closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Update position display
local function updatePositionDisplay()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local pos = player.Character.HumanoidRootPart.Position
        positionLabel.Text = string.format("Current: X=%.1f, Y=%.1f, Z=%.1f", pos.X, pos.Y, pos.Z)
    else
        positionLabel.Text = "Current: Character not found"
    end
end

-- Connect position update
RunService.Heartbeat:Connect(updatePositionDisplay)

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
addHoverEffect(saveButton, Color3.fromRGB(70, 170, 70), Color3.fromRGB(50, 150, 50))
addHoverEffect(teleportButton, Color3.fromRGB(170, 70, 170), Color3.fromRGB(150, 50, 150))
addHoverEffect(closeButton, Color3.fromRGB(220, 70, 70), Color3.fromRGB(200, 50, 50))
