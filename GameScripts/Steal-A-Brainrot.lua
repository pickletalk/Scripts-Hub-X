local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local StarterPlayer = game:GetService("StarterPlayer")
local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")
local TeleportService = game:GetService("TeleportService")

local player = Players.LocalPlayer
local LocalPlayer = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Bypassed
local grappleHookConnection = nil

-- Platform variables
local platformEnabled = false
local currentPlatform = nil
local platformUpdateConnection = nil
local PLATFORM_OFFSET = 3.62
-- Variables for slow fall
local SLOW_FALL_SPEED = -0.45 
local originalGravity = nil
local bodyVelocity = nil
local elevationBodyVelocity = nil

-- Wall transparency variables
local wallTransparencyEnabled = false
local originalTransparencies = {}
local TRANSPARENCY_LEVEL = 0.6
local playerCollisionConnection = nil

-- Combo Float + Wall variables
local comboFloatEnabled = false
local comboCurrentPlatform = nil
local comboPlatformUpdateConnection = nil
local comboPlayerCollisionConnection = nil
local COMBO_PLATFORM_OFFSET = 3.7

-- Steal variables (replaced tween to base variables)
local stealEnabled = false
local stealGrappleConnection = nil
local lastClickTime = 0
local DOUBLE_CLICK_PREVENTION_TIME = 1.5

-- ESP variables
local plotDisplays = {}
local playerBaseName = LocalPlayer.DisplayName .. "'s Base"
local playerBaseTimeWarning = false
local alertGui = nil

local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "im"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Name = "the"
mainFrame.Size = UDim2.new(0, 280, 0, 150)
mainFrame.Position = UDim2.new(1, -290, 0, 140)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = mainFrame

local titleBar = Instance.new("Frame")
titleBar.Name = "best"
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = titleBar

local titleText = Instance.new("TextLabel")
titleText.Name = "ever"
titleText.Size = UDim2.new(1, -30, 1, 0)
titleText.Position = UDim2.new(0, 5, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "💰 Steal A Brainrot 💰"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.TextScaled = true
titleText.Font = Enum.Font.GothamBold
titleText.Parent = titleBar

local closeButton = Instance.new("TextButton")
closeButton.Name = "lol"
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

local floatButton = Instance.new("TextButton")
floatButton.Name = "can't"
floatButton.Size = UDim2.new(0, 130, 0, 35)
floatButton.Position = UDim2.new(0, 10, 0, 45)
floatButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
floatButton.Text = "🚹 FLOAT 🚹"
floatButton.TextColor3 = Color3.fromRGB(255, 255, 255)
floatButton.TextScaled = true
floatButton.Font = Enum.Font.GothamBold
floatButton.BorderSizePixel = 0
floatButton.Parent = mainFrame

local floatCorner = Instance.new("UICorner")
floatCorner.CornerRadius = UDim.new(0, 6)
floatCorner.Parent = floatButton

local wallButton = Instance.new("TextButton")
wallButton.Name = "detect"
wallButton.Size = UDim2.new(0, 130, 0, 35)
wallButton.Position = UDim2.new(0, 150, 0, 45)
wallButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
wallButton.Text = "💰 FLOOR STEAL 💰"
wallButton.TextColor3 = Color3.fromRGB(255, 255, 255)
wallButton.TextScaled = true
wallButton.Font = Enum.Font.GothamBold
wallButton.BorderSizePixel = 0
wallButton.Parent = mainFrame

local wallCorner = Instance.new("UICorner")
wallCorner.CornerRadius = UDim.new(0, 6)
wallCorner.Parent = wallButton

-- STEAL BUTTON (renamed from stealButton)
local stealButton = Instance.new("TextButton")
stealButton.Name = "💰"
stealButton.Size = UDim2.new(1, -20, 0, 25)
stealButton.Position = UDim2.new(0, 10, 0, 90)
stealButton.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
stealButton.Text = "👻 INVISIBLE 👻"
stealButton.TextColor3 = Color3.fromRGB(0, 0, 0)
stealButton.TextScaled = true
stealButton.Font = Enum.Font.GothamBold
stealButton.BorderSizePixel = 0
stealButton.Parent = mainFrame

local stealCorner = Instance.new("UICorner")
stealCorner.CornerRadius = UDim.new(0, 6)
stealCorner.Parent = stealButton

local creditLabel = Instance.new("TextLabel")
creditLabel.Name = "😆"
creditLabel.Size = UDim2.new(1, -20, 0, 20)
creditLabel.Position = UDim2.new(0, 10, 0, 120)
creditLabel.BackgroundTransparency = 1
creditLabel.Text = "by PickleTalk"
creditLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
creditLabel.TextScaled = true
creditLabel.Font = Enum.Font.Gotham
creditLabel.TextXAlignment = Enum.TextXAlignment.Left
creditLabel.Parent = mainFrame

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

-- Grapple Hook Functions (shared by all features)
local function equipGrappleHook()
    local backpack = player:FindFirstChild("Backpack")
    local character = player.Character
    
    if backpack and character then
        local grappleHook = backpack:FindFirstChild("Grapple Hook")
        if grappleHook and grappleHook:IsA("Tool") then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid:EquipTool(grappleHook)
            end
        end
    end
end

local function fireGrappleHook()
    local args = {0.08707536856333414}
    
    local success, error = pcall(function()
        ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Net"):WaitForChild("RE/UseItem"):FireServer(unpack(args))
    end)
    
    if not success then
        warn("Failed to fire grapple hook: " .. tostring(error))
    end
end

local function equipAndFireGrapple()
    fireGrappleHook()
    equipGrappleHook()
end

-- NEW TASER GUN FUNCTIONS
local function equipTaserGun()
    local backpack = player:FindFirstChild("Backpack")
    local character = player.Character
    
    if backpack and character then
        local taserGun = backpack:FindFirstChild("Taser Gun")
        if taserGun and taserGun:IsA("Tool") then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid:EquipTool(taserGun)
                print("✅ Equipped Taser Gun")
                return true
            end
        else
            warn("❌ Taser Gun not found in backpack")
            return false
        end
    end
    return false
end

-- Find Player's Plot Function
local function findPlayerPlot()
    local plots = workspace:FindFirstChild("Plots")
    if not plots then 
        warn("❌ Plots folder not found in workspace")
        return nil 
    end
    
    for _, plot in pairs(plots:GetChildren()) do
        if plot:IsA("Model") or plot:IsA("Folder") then
            local plotSignText = ""
            local signPath = plot:FindFirstChild("PlotSign")
            
            if signPath and signPath:FindFirstChild("SurfaceGui") then
                local surfaceGui = signPath.SurfaceGui
                if surfaceGui:FindFirstChild("Frame") and surfaceGui.Frame:FindFirstChild("TextLabel") then
                    plotSignText = surfaceGui.Frame.TextLabel.Text
                end
            end
            
            if plotSignText == playerBaseName then
                local mainRoot = plot:FindFirstChild("MainRoot")
                if mainRoot then
                    print("✅ Found player plot with MainRoot: " .. plot.Name)
                    return mainRoot
                else
                    warn("⚠️ Player plot found but MainRoot missing: " .. plot.Name)
                end
            end
        end
    end
    
    warn("❌ Player plot not found. Expected plot name: " .. playerBaseName)
    return nil
end

-- Replace the createInvisibleESP() function with this fixed version
local function createInvisibleESP(player)
    if not player.Character or not player.Character:FindFirstChild("Head") or not player.Character:FindFirstChild("HumanoidRootPart") then
        return
    end
    
    local head = player.Character.Head
    local humanoidRootPart = player.Character.HumanoidRootPart
    
    -- Remove existing invisible ESP only
    local existingESP = head:FindFirstChild("InvisibleESP")
    if existingESP then
        existingESP:Destroy()
    end
    
    -- Create new invisible ESP
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Name = "InvisibleESP"
    billboardGui.Parent = head
    billboardGui.Size = UDim2.new(0, 120, 0, 40)
    billboardGui.StudsOffset = Vector3.new(0, 3, 0)
    billboardGui.AlwaysOnTop = true
    
    local frame = Instance.new("Frame")
    frame.Parent = billboardGui
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 0.3
    frame.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    frame.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner")
    corner.Parent = frame
    corner.CornerRadius = UDim.new(0, 8)
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Parent = frame
    textLabel.Size = UDim2.new(1, -4, 1, -4)
    textLabel.Position = UDim2.new(0, 2, 0, 2)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = player.DisplayName .. "\n👻 INVISIBLE"
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.TextScaled = true
    textLabel.TextStrokeTransparency = 0
    textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    textLabel.Font = Enum.Font.SourceSansBold
    
    -- Remove existing highlight
    local existingHighlight = humanoidRootPart:FindFirstChild("InvisibleHighlight")
    if existingHighlight then
        existingHighlight:Destroy()
    end
    
    -- Create highlight effect for HumanoidRootPart
    local highlight = Instance.new("Highlight")
    highlight.Name = "InvisibleHighlight"
    highlight.Parent = humanoidRootPart
    highlight.FillColor = Color3.fromRGB(0, 255, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
end

-- Replace the detachFromHumanoidRootPart() function with this comprehensive version
local function detachFromHumanoidRootPart()
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        warn("❌ Character or HumanoidRootPart not found")
        return
    end
    
    local humanoidRootPart = character.HumanoidRootPart
    local detachedParts = {}
    
    print("🔧 Detaching ALL parts from HumanoidRootPart...")
    
    -- Function to make part noclip and fall
    local function makePartFall(part)
        if part and part:IsA("BasePart") then
            part.CanCollide = false
            part.Anchored = false
            
            -- Add BodyVelocity to make it fall faster
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
            bodyVelocity.Velocity = Vector3.new(0, -100, 0) -- Very fast downward velocity
            bodyVelocity.Parent = part
            
            -- Destroy the BodyVelocity after a short time to let physics take over
            game:GetService("Debris"):AddItem(bodyVelocity, 2)
            
            table.insert(detachedParts, part)
            print("💨 Made part fall: " .. part.Name)
        end
    end
    
    -- Detach ALL joints connected to HumanoidRootPart (including Motor6D, Weld, WeldConstraint, etc.)
    for _, joint in pairs(humanoidRootPart:GetChildren()) do
        if joint:IsA("JointInstance") or joint:IsA("Constraint") then
            local connectedPart = nil
            
            -- Handle different joint types
            if joint:IsA("Motor6D") or joint:IsA("Weld") then
                if joint.Part0 == humanoidRootPart then
                    connectedPart = joint.Part1
                elseif joint.Part1 == humanoidRootPart then
                    connectedPart = joint.Part0
                end
            elseif joint:IsA("WeldConstraint") then
                if joint.Part0 == humanoidRootPart then
                    connectedPart = joint.Part1
                elseif joint.Part1 == humanoidRootPart then
                    connectedPart = joint.Part0
                end
            end
            
            if connectedPart and connectedPart ~= humanoidRootPart then
                print("🔗 Detaching: " .. connectedPart.Name)
                joint:Destroy()
                makePartFall(connectedPart)
            end
        end
    end
    
    -- Find and detach ALL accessories, tools, and attachments
    for _, child in pairs(character:GetChildren()) do
        if child:IsA("Accessory") or child:IsA("Tool") or child:IsA("Hat") then
            print("👒 Detaching accessory/tool: " .. child.Name)
            
            -- Find all parts in the accessory/tool
            for _, part in pairs(child:GetDescendants()) do
                if part:IsA("BasePart") then
                    -- Remove any welds/joints connecting to the character
                    for _, weld in pairs(part:GetChildren()) do
                        if weld:IsA("JointInstance") or weld:IsA("Constraint") then
                            weld:Destroy()
                        end
                    end
                    
                    -- Detach from character and make it fall
                    child.Parent = workspace
                    makePartFall(part)
                end
            end
        end
    end
    
    -- Detach any loose parts that might be welded to the character
    for _, descendant in pairs(character:GetDescendants()) do
        if descendant:IsA("BasePart") and descendant.Parent ~= character and descendant ~= humanoidRootPart then
            -- Check if it's attached to HumanoidRootPart somehow
            for _, joint in pairs(descendant:GetChildren()) do
                if joint:IsA("JointInstance") or joint:IsA("Constraint") then
                    local isConnectedToHRP = false
                    
                    if joint:IsA("Motor6D") or joint:IsA("Weld") then
                        isConnectedToHRP = (joint.Part0 == humanoidRootPart or joint.Part1 == humanoidRootPart)
                    elseif joint:IsA("WeldConstraint") then
                        isConnectedToHRP = (joint.Part0 == humanoidRootPart or joint.Part1 == humanoidRootPart)
                    end
                    
                    if isConnectedToHRP then
                        print("🔗 Found and detaching loose part: " .. descendant.Name)
                        joint:Destroy()
                        descendant.Parent = workspace
                        makePartFall(descendant)
                    end
                end
            end
        end
    end
    
    -- Handle any anchored parts attached to the player
    for _, descendant in pairs(workspace:GetDescendants()) do
        if descendant:IsA("BasePart") and descendant.Anchored then
            -- Check if it has any connection to our character
            for _, joint in pairs(descendant:GetChildren()) do
                if joint:IsA("JointInstance") or joint:IsA("Constraint") then
                    local isConnectedToPlayer = false
                    
                    if joint:IsA("Motor6D") or joint:IsA("Weld") then
                        isConnectedToPlayer = (joint.Part0 and joint.Part0.Parent == character) or 
                                            (joint.Part1 and joint.Part1.Parent == character)
                    elseif joint:IsA("WeldConstraint") then
                        isConnectedToPlayer = (joint.Part0 and joint.Part0.Parent == character) or 
                                            (joint.Part1 and joint.Part1.Parent == character)
                    end
                    
                    if isConnectedToPlayer then
                        print("⚓ Detaching anchored part: " .. descendant.Name)
                        joint:Destroy()
                        makePartFall(descendant)
                    end
                end
            end
        end
    end
    
    -- Ensure HumanoidRootPart stays functional for movement
    humanoidRootPart.CanCollide = false -- Keep noclip for player
    humanoidRootPart.Anchored = false
    
    -- Make sure humanoid stays functional
    local humanoid = character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.PlatformStand = false
        humanoid.Sit = false
    end
    
    print("✅ Detached " .. #detachedParts .. " parts from HumanoidRootPart")
    print("👻 Player is now invisible and can move freely!")
end

-- Add this NEW function for permanent player ESP (always-on green ESP)
local function createPermanentPlayerESP(player)
    if not player.Character or not player.Character:FindFirstChild("Head") or not player.Character:FindFirstChild("HumanoidRootPart") then
        return
    end
    
    local head = player.Character.Head
    local humanoidRootPart = player.Character.HumanoidRootPart
    
    -- Remove existing permanent ESP
    local existingESP = head:FindFirstChild("PermanentESP")
    if existingESP then
        existingESP:Destroy()
    end
    
    local existingHighlight = humanoidRootPart:FindFirstChild("PermanentHighlight")
    if existingHighlight then
        existingHighlight:Destroy()
    end
    
    -- Create permanent ESP billboard
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Name = "PermanentESP"
    billboardGui.Parent = head
    billboardGui.Size = UDim2.new(0, 100, 0, 35)
    billboardGui.StudsOffset = Vector3.new(0, 4, 0)
    billboardGui.AlwaysOnTop = true
    
    local frame = Instance.new("Frame")
    frame.Parent = billboardGui
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 0.4
    frame.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    frame.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner")
    corner.Parent = frame
    corner.CornerRadius = UDim.new(0, 6)
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Parent = frame
    textLabel.Size = UDim2.new(1, -4, 1, -4)
    textLabel.Position = UDim2.new(0, 2, 0, 2)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = player.DisplayName
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.TextScaled = true
    textLabel.TextStrokeTransparency = 0
    textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    textLabel.Font = Enum.Font.SourceSansBold
    
    -- Create permanent highlight effect
    local highlight = Instance.new("Highlight")
    highlight.Name = "PermanentHighlight"
    highlight.Parent = humanoidRootPart
    highlight.FillColor = Color3.fromRGB(0, 255, 0)
    highlight.OutlineColor = Color3.fromRGB(0, 150, 0)
    highlight.FillTransparency = 0.7
    highlight.OutlineTransparency = 0.3
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
end

-- Add this function to initialize permanent ESP for all existing players
local function initializePermanentESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            createPermanentPlayerESP(player)
        end
    end
end

-- Replace the executeSteal() function with this fixed version
local function executeSteal()
    local currentTime = tick()
    
    -- Double click prevention
    if currentTime - lastClickTime < DOUBLE_CLICK_PREVENTION_TIME then
        print("⏳ Please wait " .. math.ceil(DOUBLE_CLICK_PREVENTION_TIME - (currentTime - lastClickTime)) .. " seconds")
        return
    end
    
    lastClickTime = currentTime
    
    if stealEnabled then
        -- Disable invisible mode
        print("👁️ Disabling invisible mode...")
        stealEnabled = false
        stealButton.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
        stealButton.Text = "👻 INVISIBLE 👻"
        
        -- Remove invisible ESP (but keep permanent ESP)
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("Head") then
                local existingESP = player.Character.Head:FindFirstChild("InvisibleESP")
                if existingESP then
                    existingESP:Destroy()
                end
            end
        end
        
        return
    end
    
    -- Enable invisible mode
    print("👻 Enabling invisible mode...")
    stealEnabled = true
    stealButton.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
    stealButton.Text = "👁️ VISIBLE 👁️"
    
    -- Create invisible ESP for all players
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") and player.Character:FindFirstChild("HumanoidRootPart") then
            createInvisibleESP(player)
        end
    end
    
    -- Detach everything from local player's HumanoidRootPart
    detachFromHumanoidRootPart()
end

local function createPlatform()
    local platform = Instance.new("Part")
    platform.Name = "😆"
    platform.Size = Vector3.new(8, 0.5, 8)
    platform.Material = Enum.Material.Neon
    platform.BrickColor = BrickColor.new("Bright blue")
    platform.Anchored = true
    platform.CanCollide = true
    platform.Shape = Enum.PartType.Block
    platform.TopSurface = Enum.SurfaceType.Smooth
    platform.BottomSurface = Enum.SurfaceType.Smooth
    platform.Parent = workspace
    platform.Transparency = 1
    
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
        local platformPosition = Vector3.new(
            playerPosition.X, 
            playerPosition.Y - PLATFORM_OFFSET, 
            playerPosition.Z
        )
        currentPlatform.Position = platformPosition
    end
end

local function applySlowFall()
    -- This function now does nothing - just keeps the grapple hook functionality
    if not player.Character then return end
    
    local character = player.Character
    local humanoid = character:FindFirstChild("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not rootPart then return end
    
    -- Double tap detection variables
    local lastTapTime = 0
    local DOUBLE_TAP_DELAY = 0.3
    
    local function performJump()
        if humanoid then
            -- First equip and fire grapple hook
            equipAndFireGrapple()
            
            -- Small delay then jump
            task.spawn(function()
                task.wait(0.1)
                if platformEnabled and humanoid then
                    -- Force jump
                    humanoid.Jump = true
                    equipAndFireGrapple()
                end
            end)
        end
    end
    
    -- Handle jump input (space bar)
    UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
        if gameProcessedEvent then return end
        
        if input.KeyCode == Enum.KeyCode.Space and platformEnabled then
            local currentTime = tick()
            
            -- Check for double tap
            if currentTime - lastTapTime <= DOUBLE_TAP_DELAY then
                -- Double tap detected - perform enhanced jump with grapple
                performJump()
            end
            
            lastTapTime = currentTime
        end
    end)
end

local function createComboPlatform()
    local platform = Instance.new("Part")
    platform.Name = "😆"
    platform.Size = Vector3.new(8, 1.5, 8)
    platform.Material = Enum.Material.Neon
    platform.BrickColor = BrickColor.new("Bright blue")
    platform.Anchored = true
    platform.CanCollide = true
    platform.Shape = Enum.PartType.Block
    platform.TopSurface = Enum.SurfaceType.Smooth
    platform.BottomSurface = Enum.SurfaceType.Smooth
    platform.Parent = workspace
    platform.Transparency = 1
    
    local pointLight = Instance.new("PointLight")
    pointLight.Color = Color3.fromRGB(0, 162, 255)
    pointLight.Brightness = 1
    pointLight.Range = 15
    pointLight.Parent = platform
    
    return platform
end

local function updateComboPlatformPosition()
    if not comboFloatEnabled or not comboCurrentPlatform or not player.Character then
        return
    end
    
    local character = player.Character
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    
    if humanoidRootPart then
        local playerPosition = humanoidRootPart.Position
        local platformPosition = Vector3.new(
            playerPosition.X, 
            playerPosition.Y - COMBO_PLATFORM_OFFSET, 
            playerPosition.Z
        )
        comboCurrentPlatform.Position = platformPosition
    end
end

local function storeOriginalTransparencies()
    originalTransparencies = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Parent ~= player.Character and obj.Name ~= "PlayerPlatform" and obj.Name ~= "ComboPlayerPlatform" then
            local name = obj.Name
            if name == "structure base home" then
                originalTransparencies[obj] = {
                    transparency = obj.Transparency,
                    canCollide = obj.CanCollide
                }
            end
        end
    end
    print("Stored transparency for " .. #originalTransparencies .. " parts")
end

local function makeWallsTransparent(transparent)
    local count = 0
    for obj, data in pairs(originalTransparencies) do
        if obj and obj.Parent and data then
            if transparent then
                obj.Transparency = TRANSPARENCY_LEVEL
                obj.CanCollide = false
                count = count + 1
            else
                obj.Transparency = data.transparency
                obj.CanCollide = data.canCollide
            end
        end
    end
    print((transparent and "Made transparent: " or "Restored: ") .. count .. " parts")
end

local function forcePlayerHeadCollision()
    if player.Character then
        local head = player.Character:FindFirstChild("Head")
        if head then
            head.CanCollide = true
        end
        -- Also ensure other body parts maintain collision
        local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            humanoidRootPart.CanCollide = true
        end
        local torso = player.Character:FindFirstChild("Torso") or player.Character:FindFirstChild("UpperTorso")
        if torso then
            torso.CanCollide = true
        end
    end
end

local function enablePlatform()
    if platformEnabled then return end
    
    platformEnabled = true
    currentPlatform = createPlatform()
    
    -- Apply slow fall effect
    applySlowFall()
    
    platformUpdateConnection = RunService.Heartbeat:Connect(updatePlatformPosition)
    updatePlatformPosition()

    -- Start the continuous loop for both equipping and firing
    if not grappleHookConnection then
        grappleHookConnection = task.spawn(function()
            while platformEnabled do
                task.wait(2)
                equipAndFireGrapple()
            end
        end)
        print("- Continuously firing grapple hook RemoteEvent every 3 seconds")
    end
    
    floatButton.BackgroundColor3 = Color3.fromRGB(0, 150, 50)
    floatButton.Text = "🚹 FLOAT 🚹"
end

local function disablePlatform()
    if not platformEnabled then return end

    platformEnabled = false
    
    -- Remove platform update connection
    if platformUpdateConnection then
        platformUpdateConnection:Disconnect()
        platformUpdateConnection = nil
    end
    
    if currentPlatform then
        currentPlatform:Destroy()
        currentPlatform = nil
    end
    
    -- STOP GRAPPLE HOOK LOOP
    if grappleHookConnection then
        task.cancel(grappleHookConnection)
        grappleHookConnection = nil
        print("🎣 Grapple Hook fire loop stopped!")
        equipAndFireGrapple()
        wait(0.5)
        equipAndFireGrapple()
    end
    
    floatButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    floatButton.Text = "🚹 FLOAT 🚹"
end

local function enableWallTransparency()
    if wallTransparencyEnabled then return end
    
    print("Enabling wall transparency...")
    wallTransparencyEnabled = true
    comboFloatEnabled = true
    
    storeOriginalTransparencies()
    makeWallsTransparent(true)
    
    -- Create and manage platform
    comboCurrentPlatform = createComboPlatform()
    comboPlatformUpdateConnection = RunService.Heartbeat:Connect(updateComboPlatformPosition)
    updateComboPlatformPosition()
    
    -- Force player collision more aggressively
    comboPlayerCollisionConnection = RunService.Heartbeat:Connect(function()
        forcePlayerHeadCollision()
    end)
    
    -- Also set initial collision state
    forcePlayerHeadCollision()

    -- Start the continuous loop for both equipping and firing
    if not grappleHookConnection then
        grappleHookConnection = task.spawn(function()
            while wallTransparencyEnabled do
                task.wait(1.5)
                equipAndFireGrapple()
            end
        end)
        print("- Continuously firing grapple hook RemoteEvent every 1.5 seconds")
    end
    
    wallButton.BackgroundColor3 = Color3.fromRGB(150, 50, 0)
    wallButton.Text = "💰 FLOOR STEAL 💰"
end

local function disableWallTransparency()
    if not wallTransparencyEnabled then return end
    
    print("Disabling wall transparency...")
    wallTransparencyEnabled = false
    comboFloatEnabled = false
    
    makeWallsTransparent(false)
    originalTransparencies = {}
    
    -- Stop platform updates and remove platform
    if comboPlatformUpdateConnection then
        comboPlatformUpdateConnection:Disconnect()
        comboPlatformUpdateConnection = nil
    end
    
    if comboCurrentPlatform then
        comboCurrentPlatform:Destroy()
        comboCurrentPlatform = nil
    end
    
    -- Stop head collision enforcement
    if comboPlayerCollisionConnection then
        comboPlayerCollisionConnection:Disconnect()
        comboPlayerCollisionConnection = nil
    end
    
    -- STOP GRAPPLE HOOK LOOP
    if grappleHookConnection then
        task.cancel(grappleHookConnection)
        grappleHookConnection = nil
        print("🎣 Grapple Hook fire loop stopped!")
    end
    
    -- Restore normal player collision state
    if player.Character then
        local head = player.Character:FindFirstChild("Head")
        if head then
            head.CanCollide = false -- Default Roblox state for head
        end
    end
    
    wallButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    wallButton.Text = "💰 FLOOR STEAL 💰"
end

-- ESP Functions
local function createAlertGui()
    if alertGui then return end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    screenGui.Name = "😆"
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

function createPlayerESP(player, head)
    local existingGui = head:FindFirstChild("PlayerESP")
    if existingGui then
        existingGui:Destroy()
    end
    
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Name = "😆"
    billboardGui.Parent = head
    billboardGui.Size = UDim2.new(0, 90, 0, 33)
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
    textLabel.Font = Enum.Font.SourceSans
end

local function createPlayerDisplay(player)
    if player == LocalPlayer then return end
    
    local character = player.Character
    if not character then
        player.CharacterAdded:Connect(function(char)
            character = char
            task.wait(0.5)
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

local function createOrUpdatePlotDisplay(plot)
    if not plot or not plot.Parent then return end
    
    local plotName = plot.Name
    
    local plotSignText = ""
    local signPath = plot:FindFirstChild("PlotSign")
    if signPath and signPath:FindFirstChild("SurfaceGui") then
        local surfaceGui = signPath.SurfaceGui
        if surfaceGui:FindFirstChild("Frame") and surfaceGui.Frame:FindFirstChild("TextLabel") then
            plotSignText = surfaceGui.Frame.TextLabel.Text
        end
    end
    
    if plotSignText == "Empty Base" or plotSignText == "" or plotSignText == "Empty's Base" then
        if plotDisplays[plotName] and plotDisplays[plotName].gui then
            plotDisplays[plotName].gui:Destroy()
            plotDisplays[plotName] = nil
        end
        return
    end
    
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
    
    local displayPart = plot:FindFirstChild("PlotSign")
    if not displayPart then
        for _, child in pairs(plot:GetChildren()) do
            if child:IsA("Part") or child:IsA("MeshPart") then
                displayPart = child
                break
            end
        end
    end
    
    if not displayPart then return end
    
    if not plotDisplays[plotName] then
        local existingBillboard = displayPart:FindFirstChild("PlotESP")
        if existingBillboard then
            existingBillboard:Destroy()
        end
        
        local billboardGui = Instance.new("BillboardGui")
        billboardGui.Name = "😆"
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
            pcall(function()
                createOrUpdatePlotDisplay(plot)
            end)
        end
    end
    
    for plotName, display in pairs(plotDisplays) do
        if not plots:FindFirstChild(plotName) then
            if display.gui then
                display.gui:Destroy()
            end
            plotDisplays[plotName] = nil
        end
    end
end

local jumpDelayConnections = {}

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

local function setupNoJumpDelay(character)
    cleanupJumpDelayConnections(character)
    
    local humanoid = character:WaitForChild("Humanoid")
    if not humanoid then return end
    
    jumpDelayConnections[character] = {}

    local stateConnection = humanoid.StateChanged:Connect(function(oldState, newState)
        if newState == Enum.HumanoidStateType.Landed then
            task.spawn(function()
                task.wait()
                if humanoid and humanoid.Parent then
                    humanoid:ChangeState(Enum.HumanoidStateType.Running)
                end
            end)
        end
    end)
    
    jumpDelayConnections[character][#jumpDelayConnections[character] + 1] = stateConnection
    
    local cleanupConnection = character.AncestryChanged:Connect(function()
        if not character.Parent then
            cleanupJumpDelayConnections(character)
        end
    end)
    
    jumpDelayConnections[character][#jumpDelayConnections[character] + 1] = cleanupConnection
end

local function removeJumpDelay()
    if player.Character and player.Character.Parent then
        setupNoJumpDelay(player.Character)
    end
    
    local characterAddedConnection = player.CharacterAdded:Connect(function(character)
        task.wait(0.5)
        if character and character.Parent then
            setupNoJumpDelay(character)
        end
    end)
    
    local characterRemovingConnection = player.CharacterRemoving:Connect(function(character)
        cleanupJumpDelayConnections(character)
    end)
end

local function onCharacterAdded(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    
    -- Reset all velocity variables
    originalGravity = nil
    bodyVelocity = nil
    elevationBodyVelocity = nil

    if platformEnabled then
        task.wait(1)
        
        if currentPlatform then
            currentPlatform:Destroy()
        end
        
        currentPlatform = createPlatform()
        applySlowFall()
        updatePlatformPosition()
        
        task.wait(0.5)
    end
end

-- Button Functions
floatButton.MouseButton1Click:Connect(function()
    local originalSize = floatButton.Size
    local clickTween = TweenService:Create(floatButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Size = UDim2.new(0, 125, 0, 33)})
    local releaseTween = TweenService:Create(floatButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Size = originalSize})
    
    clickTween:Play()
    clickTween.Completed:Connect(function()
        releaseTween:Play()
    end)
    
    if platformEnabled then
        disablePlatform()
    else
        enablePlatform()
    end
end)

wallButton.MouseButton1Click:Connect(function()
    local originalSize = wallButton.Size
    local clickTween = TweenService:Create(wallButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Size = UDim2.new(0, 125, 0, 33)})
    local releaseTween = TweenService:Create(wallButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Size = originalSize})
    
    clickTween:Play()
    clickTween.Completed:Connect(function()
        releaseTween:Play()
    end)
    
    if wallTransparencyEnabled then
        disableWallTransparency()
    else
        enableWallTransparency()
    end
end)

-- STEAL BUTTON FUNCTIONALITY (Modified from tween functionality)
stealButton.MouseButton1Click:Connect(function()
    if stealEnabled then
        -- Stop steal process if already running
        if stealGrappleConnection then
            task.cancel(stealGrappleConnection)
            stealGrappleConnection = nil
        end
        
        stealEnabled = false
        stealButton.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
        stealButton.Text = "💰 STEAL 💰"
        
        print("✅ Steal process stopped")
    else
        -- Start steal process
        print("💰 Steal button clicked - starting steal process")
        executeSteal()
    end
end)

-- Button hover effects
stealButton.MouseEnter:Connect(function()
    if not stealEnabled then
        stealButton.BackgroundColor3 = Color3.fromRGB(255, 235, 20)
    end
end)

stealButton.MouseLeave:Connect(function()
    if not stealEnabled then
        stealButton.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
    end
end)

closeButton.MouseButton1Click:Connect(function()
    if platformEnabled then
        disablePlatform()
    end
    if wallTransparencyEnabled then
        disableWallTransparency()
    end
    if alertGui then
        removeAlertGui()
    end
    
    -- Clean up all connections and objects
    if currentPlatform then currentPlatform:Destroy() end
    if comboCurrentPlatform then comboCurrentPlatform:Destroy() end
    if platformUpdateConnection then platformUpdateConnection:Disconnect() end
    if comboPlatformUpdateConnection then comboPlatformUpdateConnection:Disconnect() end
    if playerCollisionConnection then playerCollisionConnection:Disconnect() end
    if grappleHookConnection then task.cancel(grappleHookConnection) end
    if stealGrappleConnection then task.cancel(stealGrappleConnection) end
    
    removeSlowFall()
    
    screenGui:Destroy()
    
    print("❌ Script closed and cleaned up")
end)

local function addHoverEffect(button, hoverColor, originalColor)
    button.MouseEnter:Connect(function()
        if button == floatButton then
            if platformEnabled then
                button.BackgroundColor3 = Color3.fromRGB(50, 180, 80)
            else
                button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            end
        elseif button == wallButton then
            if wallTransparencyEnabled then
                button.BackgroundColor3 = Color3.fromRGB(180, 80, 30)
            else
                button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            end
        else
            button.BackgroundColor3 = hoverColor
        end
    end)
    
    button.MouseLeave:Connect(function()
        if button == floatButton then
            if platformEnabled then
                button.BackgroundColor3 = Color3.fromRGB(0, 150, 50)
            else
                button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            end
        elseif button == wallButton then
            if wallTransparencyEnabled then
                button.BackgroundColor3 = Color3.fromRGB(150, 50, 0)
            else
                button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            end
        else
            button.BackgroundColor3 = originalColor
        end
    end)
end

-- Emergency stop function (press ESC while stealing)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.Escape and stealEnabled then
        print("🛑 Emergency stop activated!")
        
        if stealGrappleConnection then
            task.cancel(stealGrappleConnection)
            stealGrappleConnection = nil
        end
        
        stealEnabled = false
        stealButton.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
        stealButton.Text = "💰 STEAL 💰"
    end
end)

-- Character respawn handling
player.CharacterRemoving:Connect(function()
    platformEnabled = false
    wallTransparencyEnabled = false
    comboFloatEnabled = false
    stealEnabled = false
    
    if currentPlatform then currentPlatform:Destroy() end
    if comboCurrentPlatform then comboCurrentPlatform:Destroy() end
    if grappleHookConnection then task.cancel(grappleHookConnection) end
    if stealGrappleConnection then task.cancel(stealGrappleConnection) end
    
    -- Reset button states
    floatButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    floatButton.Text = "🚹 FLOAT 🚹"
    wallButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    wallButton.Text = "💰 FLOOR STEAL 💰"
    stealButton.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
    stealButton.Text = "👻 INVISIBLE 👻"
end)

player.CharacterAdded:Connect(onCharacterAdded)

-- Initialize ESP
for _, playerObj in pairs(Players:GetPlayers()) do
    if playerObj ~= LocalPlayer then
        createPlayerDisplay(playerObj)
        playerObj.CharacterAdded:Connect(function()
            task.wait(0.5)
            createPlayerDisplay(playerObj)
        end)
    end
end

initializePermanentESP()

Players.PlayerAdded:Connect(function(newPlayer)
    newPlayer.CharacterAdded:Connect(function(character)
        task.wait(1) -- Wait for character to fully load
        createPermanentPlayerESP(newPlayer)
        
        -- Also create invisible ESP if invisible mode is active
        if stealEnabled and character:FindFirstChild("Head") and character:FindFirstChild("HumanoidRootPart") then
            createInvisibleESP(newPlayer)
        end
    end)
end)

-- Handle player respawning
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        player.CharacterAdded:Connect(function(character)
            task.wait(1) -- Wait for character to fully load
            createPermanentPlayerESP(player)
            
            -- Also create invisible ESP if invisible mode is active
            if stealEnabled and character:FindFirstChild("Head") and character:FindFirstChild("HumanoidRootPart") then
                createInvisibleESP(player)
            end
        end)
    end
end

-- Clean up highlights when players leave
Players.PlayerRemoving:Connect(function(leavingPlayer)
    if leavingPlayer.Character then
        local head = leavingPlayer.Character:FindFirstChild("Head")
        local hrp = leavingPlayer.Character:FindFirstChild("HumanoidRootPart")
        
        if head then
            local permanentESP = head:FindFirstChild("PermanentESP")
            local invisibleESP = head:FindFirstChild("InvisibleESP")
            if permanentESP then permanentESP:Destroy() end
            if invisibleESP then invisibleESP:Destroy() end
        end
        
        if hrp then
            local permanentHighlight = hrp:FindFirstChild("PermanentHighlight")
            local invisibleHighlight = hrp:FindFirstChild("InvisibleHighlight")
            if permanentHighlight then permanentHighlight:Destroy() end
            if invisibleHighlight then invisibleHighlight:Destroy() end
        end
    end
end)

Players.PlayerAdded:Connect(function(playerObj)
    if playerObj ~= LocalPlayer then
        createPlayerDisplay(playerObj)
        playerObj.CharacterAdded:Connect(function()
            task.wait(0.5)
            createPlayerDisplay(playerObj)
        end)
    end
end)

-- Handle new players for invisible ESP
Players.PlayerAdded:Connect(function(newPlayer)
    newPlayer.CharacterAdded:Connect(function(character)
        task.wait(1)
        if stealEnabled and character:FindFirstChild("Head") and character:FindFirstChild("HumanoidRootPart") then
            createInvisibleESP(newPlayer)
        end
    end)
end)

updateAllPlots()

local plots = workspace:FindFirstChild("Plots")
if plots then
    plots.ChildAdded:Connect(function(child)
        if child:IsA("Model") or child:IsA("Folder") then
            task.wait(0.5)
            createOrUpdatePlotDisplay(child)
        end
    end)
end

task.spawn(function()
    while true do
        task.wait(0.5)
        pcall(updateAllPlots)
    end
end)

addHoverEffect(closeButton, Color3.fromRGB(220, 70, 70), Color3.fromRGB(200, 50, 50))
addHoverEffect(floatButton, Color3.fromRGB(30, 30, 30), Color3.fromRGB(0, 0, 0))
addHoverEffect(wallButton, Color3.fromRGB(30, 30, 30), Color3.fromRGB(0, 0, 0))

game:BindToClose(function()
    if wallTransparencyEnabled then
        disableWallTransparency()
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

removeJumpDelay()

print("✅ Steal A Brainrot Script Loaded Successfully!")
print("💰 STEAL button: Equip Taser Gun → Fire at self → Teleport to MainRoot")
print("🚹 FLOAT button: Platform with slow fall and grapple hook")
print("💰 FLOOR STEAL button: Wall transparency with platform and grapple hook")
print("📱 ESP: Player names and plot information displayed")
