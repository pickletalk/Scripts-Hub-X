-- ========================================
-- MAIN SERVICES AND VARIABLES
-- ========================================
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- ========================================
-- INFINITE JUMP SCRIPT
-- ========================================
local isInfiniteJumpEnabled = false
local jumpConnections = {}

local function createJumpNotification()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = player:WaitForChild("PlayerGui")
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

    spawn(function()
        wait(2)
        local tweenOut = TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, 200, 0, 0)})
        tweenOut:Play()
        tweenOut.Completed:Connect(function()
            wait(0.5)
            screenGui:Destroy()
        end)
    end)
end

local function connectInfiniteJump()
    local connection = UserInputService.JumpRequest:Connect(function()
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            local jumpHumanoid = player.Character:FindFirstChild("Humanoid")
            local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
            
            if rootPart and jumpHumanoid and jumpHumanoid.Health > 0 then
                jumpHumanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
                jumpHumanoid:SetStateEnabled(Enum.HumanoidStateType.Flying, false)
                
                jumpHumanoid:ChangeState(Enum.HumanoidStateType.Landed)
                
                spawn(function()
                    wait()
                    jumpHumanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    
                    wait(0.1)
                    jumpHumanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
                    jumpHumanoid:SetStateEnabled(Enum.HumanoidStateType.Flying, true)
                end)
            end
        end
    end)
    
    table.insert(jumpConnections, connection)
    return connection
end

local function enableInfiniteJump()
    if isInfiniteJumpEnabled then return end
    
    isInfiniteJumpEnabled = true
    
    -- Connect for current character
    if player.Character then
        connectInfiniteJump()
    end
    
    -- Handle character respawning
    local characterConnection = player.CharacterAdded:Connect(function(newCharacter)
        if isInfiniteJumpEnabled then
            wait(0.1)
            connectInfiniteJump()
        end
    end)
    
    table.insert(jumpConnections, characterConnection)
    createJumpNotification()
end

-- Enable infinite jump
enableInfiniteJump()

-- ========================================
-- SHOP TELEPORTER
-- ========================================
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
mainFrame.Position = UDim2.new(1, -260, 0, 10)
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
titleText.Text = "💰 SHADOW HEIST 💰"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.TextScaled = false
titleText.TextSize = 14
titleText.Font = Enum.Font.GothamBold
titleText.Parent = titleBar

local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 25, 0, 25)
closeButton.Position = UDim2.new(1, -27, 0, 2)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextScaled = false
closeButton.TextSize = 18
closeButton.Font = Enum.Font.GothamBold
closeButton.BorderSizePixel = 0
closeButton.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 4)
closeCorner.Parent = closeButton

local teleportButton = Instance.new("TextButton")
teleportButton.Name = "TeleportButton"
teleportButton.Size = UDim2.new(0, 220, 0, 35)
teleportButton.Position = UDim2.new(0, 15, 0, 45)
teleportButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
teleportButton.Text = "💰 STEAL 💰"
teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportButton.TextScaled = false
teleportButton.TextSize = 18
teleportButton.Font = Enum.Font.GothamBold
teleportButton.BorderSizePixel = 0
teleportButton.Parent = mainFrame

local teleportCorner = Instance.new("UICorner")
teleportCorner.CornerRadius = UDim.new(0, 6)
teleportCorner.Parent = teleportButton

local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "StatusLabel"
statusLabel.Size = UDim2.new(1, -20, 0, 25)
statusLabel.Position = UDim2.new(0, 10, 0, 90)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "by PickleTalk"
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.TextScaled = false
statusLabel.TextSize = 12
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = mainFrame

-- PC and Mobile compatible dragging functionality
local dragging = false
local dragStart = nil
local startPos = nil

local function updateDrag(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

-- PC and Mobile dragging support
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

-- Mobile-specific touch handling for better responsiveness
UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch and dragging then
        updateDrag(input)
    end
end)

-- Additional mobile support for button interactions
local function setupMobileButton(button)
    -- Make button more responsive on mobile
    button.MouseButton1Click:Connect(function()
        -- Visual feedback for mobile users
        local originalSize = button.Size
        local originalColor = button.BackgroundColor3
        
        -- Quick press animation
        button.Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset - 2, originalSize.Y.Scale, originalSize.Y.Offset - 2)
        wait(0.05)
        button.Size = originalSize
    end)
end

-- Apply mobile optimizations to buttons
setupMobileButton(teleportButton)

-- Shop teleporter function
local function teleportToShop()
    local root
    local startCF

    spawn(function()
        local ok, err = pcall(function()
            teleportButton.Text = "⚡ STEALING... ⚡"

            root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if not root then 
                teleportButton.Text = "❌ NO CHARACTER ❌"
                wait(1)
                teleportButton.Text = "💰 STEAL 💰"
                return
            end
            
            startCF = root.CFrame

            -- Check if shop exists
            local workspaceService = game:GetService("Workspace")
            local shops = workspaceService:FindFirstChild("Shops")
            if not shops then 
                teleportButton.Text = "❌ SHOPS NOT FOUND ❌"
                wait(1)
                teleportButton.Text = "💰 STEAL 💰"
                return
            end
            
            local outlawShop = shops:FindFirstChild("OutlawGeneralStore1")
            if not outlawShop then 
                teleportButton.Text = "❌ SHOP NOT FOUND ❌"
                wait(1)
                teleportButton.Text = "💰 STEAL 💰"
                return
            end

            -- Get shop position
            local shopPosition
            if outlawShop:IsA("Model") and outlawShop.PrimaryPart then
                shopPosition = outlawShop.PrimaryPart.Position
            elseif outlawShop:IsA("Part") then
                shopPosition = outlawShop.Position
            else
                local firstPart = outlawShop:FindFirstChildOfClass("Part")
                if firstPart then
                    shopPosition = firstPart.Position
                else
                    teleportButton.Text = "❌ NO SHOP POSITION ❌"
                    wait(1)
                    teleportButton.Text = "💰 STEAL 💰"
                    return
                end
            end

            -- Loop teleporting to shop for 1 second
            local loopStart = tick()
            while tick() - loopStart < 1 do
                root.CFrame = CFrame.new(shopPosition + Vector3.new(0, 5, 0))
                wait(0.1) -- Small delay between teleports
            end

            -- Teleport back to original position
            root.CFrame = startCF

            teleportButton.Text = "✅ DONE ✅"
            wait(1)
            teleportButton.Text = "💰 STEAL 💰"
        end)

        if not ok then
            print("Teleport error:", err)
            teleportButton.Text = "❌ ERROR ❌"
            wait(1)
            teleportButton.Text = "💰 STEAL 💰"
        end
    end)
end

-- Button connections with PC/Mobile support
teleportButton.MouseButton1Click:Connect(teleportToShop)

-- Mobile touch support for teleport button
teleportButton.TouchTap:Connect(teleportToShop)

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Mobile touch support for close button
closeButton.TouchTap:Connect(function()
    screenGui:Destroy()
end)

-- PC/Mobile compatible hover effects
local function addHoverEffect(button, hoverColor, originalColor)
    -- PC hover support
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = hoverColor
    end)
    
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = originalColor
    end)
    
    -- Mobile touch feedback
    button.TouchTap:Connect(function()
        -- Quick color flash for mobile feedback
        button.BackgroundColor3 = hoverColor
        spawn(function()
            wait(0.1)
            button.BackgroundColor3 = originalColor
        end)
    end)
end

addHoverEffect(closeButton, Color3.fromRGB(220, 70, 70), Color3.fromRGB(200, 50, 50))

-- Mobile-specific UI optimizations
local function optimizeForMobile()
    -- Detect if user is on mobile
    if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
        print("[UI] Mobile device detected - applying mobile optimizations")
        
        -- Make buttons slightly larger for easier tapping on mobile
        teleportButton.Size = UDim2.new(0, 230, 0, 40)
        closeButton.Size = UDim2.new(0, 30, 0, 30)
        closeButton.Position = UDim2.new(1, -32, 0, 0)
        
        -- Increase text size slightly for mobile readability
        teleportButton.TextSize = 20
        titleText.TextSize = 16
        closeButton.TextSize = 20
        
        -- Make the main frame slightly larger for mobile
        mainFrame.Size = UDim2.new(0, 260, 0, 130)
        mainFrame.Position = UDim2.new(1, -270, 0, 10)
    else
        print("[UI] PC/Desktop device detected - using standard sizing")
    end
end

-- Apply mobile optimizations
optimizeForMobile()

-- ========================================
-- FAST INTERACTION FOR WESTBOUND (MOBILE OPTIMIZED)
-- ========================================
print("[Westbound Fast Interaction] Loading mobile-optimized interaction system...")

-- Function to modify proximity prompts for instant interaction
local function modifyProximityPrompt(prompt)
    if not prompt or not prompt:IsA("ProximityPrompt") then
        return
    end
    
    -- Store original values
    local originalHoldDuration = prompt.HoldDuration
    local originalMaxActivationDistance = prompt.MaxActivationDistance
    
    -- Set to instant interaction
    prompt.HoldDuration = 0
    prompt.MaxActivationDistance = math.max(prompt.MaxActivationDistance, 20) -- Increase range for mobile
    
    -- Make sure it's easily accessible on mobile
    prompt.RequiresLineOfSight = false
    prompt.Style = Enum.ProximityPromptStyle.Default
    
    -- Create persistent connection to prevent reset
    local connection = prompt:GetPropertyChangedSignal("HoldDuration"):Connect(function()
        if prompt.HoldDuration ~= 0 then
            prompt.HoldDuration = 0
        end
    end)
    
    -- Also monitor MaxActivationDistance changes
    local distanceConnection = prompt:GetPropertyChangedSignal("MaxActivationDistance"):Connect(function()
        if prompt.MaxActivationDistance < 20 then
            prompt.MaxActivationDistance = 20
        end
    end)
    
    print("[Westbound Fast Interaction] Modified prompt:", prompt.Parent.Name or "Unnamed")
end

-- Function to handle ClickDetectors (common in Westbound)
local function modifyClickDetector(detector)
    if not detector or not detector:IsA("ClickDetector") then
        return
    end
    
    -- Increase click distance for mobile users
    detector.MaxActivationDistance = math.max(detector.MaxActivationDistance, 25)
    
    -- Monitor for changes
    local connection = detector:GetPropertyChangedSignal("MaxActivationDistance"):Connect(function()
        if detector.MaxActivationDistance < 25 then
            detector.MaxActivationDistance = 25
        end
    end)
    
    print("[Westbound Fast Interaction] Modified ClickDetector:", detector.Parent.Name or "Unnamed")
end

-- Function to scan and modify all interactive objects
local function scanAndModifyInteractables(container)
    -- Handle ProximityPrompts
    for _, descendant in pairs(container:GetDescendants()) do
        if descendant:IsA("ProximityPrompt") then
            modifyProximityPrompt(descendant)
        elseif descendant:IsA("ClickDetector") then
            modifyClickDetector(descendant)
        end
    end
end

-- Function to handle new objects being added
local function onDescendantAdded(descendant)
    if descendant:IsA("ProximityPrompt") then
        wait(0.1) -- Small delay for initialization
        modifyProximityPrompt(descendant)
    elseif descendant:IsA("ClickDetector") then
        wait(0.1)
        modifyClickDetector(descendant)
    end
end

-- Continuous monitoring for Westbound-specific interactions
local function continuousWestboundMonitor()
    spawn(function()
        while true do
            wait(1) -- Check every second
            
            -- Monitor all proximity prompts
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("ProximityPrompt") then
                    if obj.HoldDuration > 0 then
                        obj.HoldDuration = 0
                    end
                    if obj.MaxActivationDistance < 20 then
                        obj.MaxActivationDistance = 20
                    end
                    obj.RequiresLineOfSight = false
                elseif obj:IsA("ClickDetector") then
                    if obj.MaxActivationDistance < 25 then
                        obj.MaxActivationDistance = 25
                    end
                end
            end
            
            -- Also check player's character
            if player.Character then
                for _, obj in pairs(player.Character:GetDescendants()) do
                    if obj:IsA("ProximityPrompt") and obj.HoldDuration > 0 then
                        obj.HoldDuration = 0
                        obj.MaxActivationDistance = 20
                    elseif obj:IsA("ClickDetector") and obj.MaxActivationDistance < 25 then
                        obj.MaxActivationDistance = 25
                    end
                end
            end
        end
    end)
end

-- Mobile-specific optimizations for Westbound
local function mobileOptimizations()
    -- Increase GUI interaction range for mobile
    local UserInputService = game:GetService("UserInputService")
    
    if UserInputService.TouchEnabled then
        print("[Westbound Fast Interaction] Mobile device detected - applying mobile optimizations")
        
        -- Monitor for GUI interactions and make them more accessible
        spawn(function()
            while true do
                wait(0.5)
                
                -- Find shop interfaces, interaction GUIs, etc.
                local playerGui = player:WaitForChild("PlayerGui")
                
                for _, gui in pairs(playerGui:GetDescendants()) do
                    if gui:IsA("Frame") or gui:IsA("TextButton") or gui:IsA("ImageButton") then
                        -- Make buttons easier to press on mobile
                        if gui.Size.X.Offset > 0 and gui.Size.X.Offset < 50 then
                            gui.Size = UDim2.new(gui.Size.X.Scale, math.max(gui.Size.X.Offset, 60), gui.Size.Y.Scale, gui.Size.Y.Offset)
                        end
                        if gui.Size.Y.Offset > 0 and gui.Size.Y.Offset < 50 then
                            gui.Size = UDim2.new(gui.Size.X.Scale, gui.Size.X.Offset, gui.Size.Y.Scale, math.max(gui.Size.Y.Offset, 60))
                        end
                    end
                end
            end
        end)
    end
end

-- Handle character respawning
local function onCharacterAddedForInteraction(character)
    wait(1) -- Wait for character to fully load
    scanAndModifyInteractables(character)
    print("[Westbound Fast Interaction] Applied to new character!")
end

-- Main initialization for Westbound Fast Interaction
local function initializeWestboundFastInteraction()
    print("[Westbound Fast Interaction] Initializing for Westbound game...")
    
    -- Scan entire workspace initially
    scanAndModifyInteractables(workspace)
    
    -- Connect to new objects being added
    workspace.DescendantAdded:Connect(onDescendantAdded)
    
    -- Handle character respawning
    player.CharacterAdded:Connect(onCharacterAddedForInteraction)
    
    -- If character already exists, process it
    if player.Character then
        onCharacterAddedForInteraction(player.Character)
    end
    
    -- Start continuous monitoring
    continuousWestboundMonitor()
    
    -- Apply mobile optimizations
    mobileOptimizations()
    
    print("[Westbound Fast Interaction] System loaded! All interactions should be instant and mobile-optimized.")
    print("[Westbound Fast Interaction] Interaction ranges increased for mobile users.")
end

-- Start the Westbound Fast Interaction system
initializeWestboundFastInteraction()

-- Additional Westbound-specific interaction fixes
spawn(function()
    while true do
        wait(1) -- Check every 2 seconds for common Westbound interactions
        
        -- Look for common Westbound interaction objects
        local commonInteractionNames = {
            "Shop", "Store", "Merchant", "Vendor", "Chest", "Container", 
            "Door", "Gate", "Lever", "Button", "Switch", "Terminal",
            "Bank", "Saloon", "General", "Gunsmith", "Stable"
        }
        
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Model") or obj:IsA("Part") then
                for _, interactionName in pairs(commonInteractionNames) do
                    if string.find(obj.Name:lower(), interactionName:lower()) then
                        -- Look for interaction components in this object
                        for _, child in pairs(obj:GetDescendants()) do
                            if child:IsA("ProximityPrompt") then
                                child.HoldDuration = 0
                                child.MaxActivationDistance = 25
                                child.RequiresLineOfSight = false
                            elseif child:IsA("ClickDetector") then
                                child.MaxActivationDistance = 30
                            end
                        end
                    end
                end
            end
        end
    end
end)
