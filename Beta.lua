-- Steal A Brainrot Script - WindUI Version
-- by PickleTalk

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local LocalPlayer = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Anti-ragdoll protection variables
local antiRagdollConnections = {}
local antiRagdollMonitoringConnections = {}
local MAX_VELOCITY = 500
local MAX_ANGULAR_VELOCITY = 100
local EXTREME_VELOCITY_THRESHOLD = 1000

-- Feature state variables
local grappleHookConnection = nil
local lastStealCount = 0
local isMonitoring = false
local platformEnabled = false
local currentPlatform = nil
local platformUpdateConnection = nil
local PLATFORM_OFFSET = 3.6
local SLOW_FALL_SPEED = -0.45 
local originalGravity = nil
local bodyVelocity = nil
local elevationBodyVelocity = nil
local wallTransparencyEnabled = false
local originalTransparencies = {}
local TRANSPARENCY_LEVEL = 0.6
local playerCollisionConnection = nil
local comboFloatEnabled = false
local comboCurrentPlatform = nil
local comboPlatformUpdateConnection = nil
local comboPlayerCollisionConnection = nil
local COMBO_PLATFORM_OFFSET = 3.7
local teleportEnabled = false
local teleportGrappleConnection = nil
local lastClickTime = 0
local DOUBLE_CLICK_PREVENTION_TIME = 1.5
local highestBrainrotData = nil
local teleportOverlay = nil
local highestValueESP = nil
local highestValueData = nil
local espUpdateConnection = nil
local tracerUpdateConnection = nil

-- WindUI specific variables
local antiRagdollEnabled = false
local antiFlingEnabled = false
local playerESPEnabled = false
local baseTimeESPEnabled = false
local ownerESPEnabled = false
local baseTimeAlertEnabled = false
local leaveOnStealEnabled = false
local leaveKeybind = Enum.KeyCode.L

local brainrotNames = {
    "Los Tralaleritos", "Guerriro Digitale", "Las Tralaleritas", "Job Job Job Sahur",
    "Las Vaquitas Saturnitas", "Graipuss Medussi", "Noo My Hotspot", "Sahur Combinasion",
    "Pot Hotspot", "Chicleteira Bicicleteira", "Los Nooo My Hotspotsitos", "La Grande Combinasion",
    "Los Combinasionas", "Nuclearo Dinossauro", "Karkerkar combinasion", "Los Hotspotsitos",
    "Tralaledon", "Esok Sekolah", "Ketupat Kepat", "Los Bros", "La Supreme Combinasion",
    "Ketchuru and Masturu", "Garama and Madundung", "Spaghetti Tualetti", "Dragon Cannelloni",
    "Blackhole Goat", "Agarrini la Palini", "Los Spyderinis", "Fragola la la la", "Strawberry Elephant"
}

local brainrotLookup = {}
for _, name in pairs(brainrotNames) do
    brainrotLookup[name] = true
end

local plotDisplays = {}
local playerBaseName = LocalPlayer.DisplayName .. "'s Base"
local playerBaseTimeWarning = false
local alertGui = nil

local playerGui = player:WaitForChild("PlayerGui")

-- HELPER FUNCTIONS (Keep all original functions)

local function onCharacterAdded(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")

    task.wait(0.5)
    if antiRagdollEnabled then
        setupAntiRagdollProtection()
    end
    
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

local function getAntiRagdollComponents()
    local success, result = pcall(function()
        if not LocalPlayer.Character then
            return false
        end
        
        local char = LocalPlayer.Character
        local hum = char:FindFirstChild("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        
        return char and hum and root
    end)
    
    return success and result
end

local function preventRagdoll()
    if not (humanoid and humanoid.Parent) then
        return
    end
    
    pcall(function()
        humanoid.PlatformStand = false
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
        
        if humanoid:GetState() == Enum.HumanoidStateType.Physics then
            humanoid:ChangeState(Enum.HumanoidStateType.Running)
        end
        
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") and part ~= rootPart then
                for _, joint in pairs(part:GetChildren()) do
                    if joint:IsA("Motor6D") and joint.Part0 and joint.Part1 then
                        joint.Enabled = true
                        if not joint.Part0.Anchored and not joint.Part1.Anchored then
                            joint.C0 = joint.C0
                            joint.C1 = joint.C1
                        end
                    end
                end
            end
        end
    end)
end

local function preventFling()
    if not (rootPart and rootPart.Parent) then
        return
    end
    
    pcall(function()
        local velocity = rootPart.AssemblyLinearVelocity
        local angularVelocity = rootPart.AssemblyAngularVelocity
        
        if velocity.Magnitude > EXTREME_VELOCITY_THRESHOLD then
            rootPart.AssemblyLinearVelocity = velocity.Unit * MAX_VELOCITY
            print("Detected extreme velocity fling: " .. math.floor(velocity.Magnitude) .. " studs/s")
        end
        
        if angularVelocity.Magnitude > MAX_ANGULAR_VELOCITY * 2 then
            rootPart.AssemblyAngularVelocity = angularVelocity.Unit * MAX_ANGULAR_VELOCITY
        end
    end)
end

local function disableSentryBulletTouch(sentryBullet)
    pcall(function()
        if not sentryBullet or not sentryBullet.Parent then
            return
        end
        
        local touchInterest = sentryBullet:FindFirstChild("TouchInterest")
        if touchInterest then
            touchInterest:Destroy()
        end
        
        if sentryBullet:IsA("BasePart") then
            sentryBullet.CanTouch = false
        end
        
        sentryBullet.CanCollide = false
        
        pcall(function()
            sentryBullet.CollisionGroup = "SentryBulletDisabled"
        end)
    end)
end

local function monitorSentryBullets()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj.Name == "SentryBullet" and obj:IsA("BasePart") then
            disableSentryBulletTouch(obj)
        end
    end
    
    local connection = workspace.DescendantAdded:Connect(function(descendant)
        if descendant.Name == "SentryBullet" and descendant:IsA("BasePart") then
            task.wait()
            disableSentryBulletTouch(descendant)
        end
    end)
    
    table.insert(antiRagdollMonitoringConnections, connection)
end

function setupAntiRagdollProtection()
    if not getAntiRagdollComponents() then
        return false
    end
    
    print("Setting up anti-ragdoll protection...")
    
    for _, connection in pairs(antiRagdollConnections) do
        if connection and connection.Connected then
            connection:Disconnect()
        end
    end
    antiRagdollConnections = {}
    
    local stateConnection = humanoid.StateChanged:Connect(function(oldState, newState)
        if newState == Enum.HumanoidStateType.Physics then
            preventRagdoll()
        end
    end)
    table.insert(antiRagdollConnections, stateConnection)
    
    local platformConnection = humanoid:GetPropertyChangedSignal("PlatformStand"):Connect(function()
        if humanoid.PlatformStand then
            preventRagdoll()
        end
    end)
    table.insert(antiRagdollConnections, platformConnection)
    
    local heartbeatRagdoll = RunService.Heartbeat:Connect(function()
        preventRagdoll()
    end)
    table.insert(antiRagdollConnections, heartbeatRagdoll)
    
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            local touchConnection = part.Touched:Connect(function(hit)
                if hit.Name == "SentryBullet" then
                    return
                end
            end)
            table.insert(antiRagdollConnections, touchConnection)
        end
    end
    
    print("Anti-ragdoll protection active")
    return true
end

local function cleanupAntiRagdoll()
    for _, connection in pairs(antiRagdollConnections) do
        if connection and connection.Connected then
            connection:Disconnect()
        end
    end
    antiRagdollConnections = {}
    
    for _, connection in pairs(antiRagdollMonitoringConnections) do
        if connection and connection.Connected then
            connection:Disconnect()
        end
    end
    antiRagdollMonitoringConnections = {}
end

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

local function unEquipGrappleHook()
    local backpack = player:FindFirstChild("Backpack")
    local character = player.Character
    
    if backpack and character then
        local grappleHook = backpack:FindFirstChild("Grapple Hook")
        if grappleHook and grappleHook:IsA("Tool") then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid:UnequipTool(grappleHook)
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

local function equipQuantumCloner()
    local backpack = player:FindFirstChild("Backpack")
    local character = player.Character
    
    if backpack and character then
        local quantumCloner = backpack:FindFirstChild("Quantum Cloner")
        if quantumCloner and quantumCloner:IsA("Tool") then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid:EquipTool(quantumCloner)
                print("Equipped Quantum Cloner")
                return true
            end
        else
            warn("Quantum Cloner not found in backpack")
            return false
        end
    end
    return false
end

local function fireQuantumCloner()
    local success, error = pcall(function()
        ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Net"):WaitForChild("RE/UseItem"):FireServer()
    end)
    
    if not success then
        warn("Failed to fire Quantum Cloner: " .. tostring(error))
    end
end

local function fireQuantumClonerTeleport()
    local success, error = pcall(function()
        ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Net"):WaitForChild("RE/QuantumCloner/OnTeleport"):FireServer()
    end)
    
    if not success then
        warn("Failed to fire Quantum Cloner teleport: " .. tostring(error))
    end
end

local function getStealCount()
    local success, result = pcall(function()
        if not LocalPlayer then
            return 0
        end
        
        local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
        if not leaderstats then
            warn("Leaderstats not found for LocalPlayer")
            return 0
        end
        
        local stealsObject = leaderstats:FindFirstChild("Steals")
        if not stealsObject then
            warn("Steals stat not found in leaderstats")
            return 0
        end
        
        local stealValue
        if stealsObject:IsA("IntValue") or stealsObject:IsA("NumberValue") then
            stealValue = stealsObject.Value
        elseif stealsObject:IsA("StringValue") then
            stealValue = tonumber(stealsObject.Value) or 0
        else
            if stealsObject.Text then
                stealValue = tonumber(stealsObject.Text) or 0
            else
                stealValue = tonumber(tostring(stealsObject.Value)) or 0
            end
        end
        
        return stealValue
    end)
    
    if success then
        return result
    else
        warn("Error getting steal count: " .. tostring(result))
        return 0
    end
end

local function kickPlayer()
    local success, error = pcall(function()
        LocalPlayer:Kick("Steal Success!!!!!")
    end)
    
    if not success then
        warn("Failed to kick player: " .. tostring(error))
        game:Shutdown()
    end
end

local function monitorSteals()
    if isMonitoring then
        return
    end
    
    isMonitoring = true
    print("Starting steal monitoring...")
    
    lastStealCount = getStealCount()
    print("Initial steal count: " .. tostring(lastStealCount))
    
    task.spawn(function()
        while isMonitoring and leaveOnStealEnabled do
            task.wait(0.1)
            
            local currentStealCount = getStealCount()
            
            if currentStealCount > lastStealCount then
                print("Steal detected! Count increased from " .. 
                      tostring(lastStealCount) .. " to " .. tostring(currentStealCount))
                
                isMonitoring = false
                task.wait(0.1)
                kickPlayer()
                break
            end
            
            lastStealCount = currentStealCount
        end
    end)
end

local function stopMonitoring()
    isMonitoring = false
    print("Steal monitoring stopped")
end

local function waitForLeaderstats()
    print("Waiting for leaderstats to load...")
    
    if not LocalPlayer then
        Players.PlayerAdded:Wait()
        LocalPlayer = Players.LocalPlayer
    end
    
    local leaderstats = LocalPlayer:WaitForChild("leaderstats", 30)
    if not leaderstats then
        warn("Leaderstats failed to load within 30 seconds")
        return false
    end
    
    local stealsObject = leaderstats:WaitForChild("Steals", 10)
    if not stealsObject then
        warn("Steals stat failed to load within 10 seconds")
        return false
    end
    
    print("Leaderstats loaded successfully")
    return true
end

local function parsePrice(priceText)
    if not priceText or priceText == "" or priceText == "N/A" then
        return 0
    end
    
    local cleanPrice = priceText:gsub("[,$]", ""):upper()
    
    local number = tonumber(cleanPrice:match("%d*%.?%d+"))
    if not number then return 0 end
    
    if cleanPrice:find("T") then
        return number * 1000000000000
    elseif cleanPrice:find("B") then
        return number * 1000000000
    elseif cleanPrice:find("M") then
        return number * 1000000
    elseif cleanPrice:find("K") then
        return number * 1000
    elseif cleanPrice:find("S") then
        return number
    end
    
    return number
end

local function findHighestBrainrot()
    local plots = workspace:FindFirstChild("Plots")
    if not plots then 
        warn("Plots folder not found in workspace")
        return nil 
    end
    
    local highestBrainrot = nil
    local highestValue = 0
    
    for _, plot in pairs(plots:GetChildren()) do
        if plot:IsA("Model") or plot:IsA("Folder") then
            local plotName = plot.Name
            
            local animalPodiums = plot:FindFirstChild("AnimalPodiums")
            if animalPodiums then
                for i = 1, 30 do
                    local podium = animalPodiums:FindFirstChild(tostring(i))
                    if podium then
                        local base = podium:FindFirstChild("Base")
                        if base then
                            local spawn = base:FindFirstChild("Spawn")
                            if spawn then
                                local attachment = spawn:FindFirstChild("Attachment")
                                if attachment then
                                    local animalOverhead = attachment:FindFirstChild("AnimalOverhead")
                                    if animalOverhead then
                                        local priceLabel = animalOverhead:FindFirstChild("Generation")
                                        if priceLabel and priceLabel.Text and priceLabel.Text ~= "" and priceLabel.Text ~= "N/A" then
                                            local priceValue = parsePrice(priceLabel.Text)
                                            
                                            if priceValue > highestValue then
                                                local decorations = base:FindFirstChild("Decorations")
                                                if decorations then
                                                    local teleportPart = decorations:FindFirstChild("Part")
                                                    if teleportPart then
                                                        highestValue = priceValue
                                                        highestBrainrot = {
                                                            plot = plot,
                                                            plotName = plotName,
                                                            podiumNumber = i,
                                                            price = priceLabel.Text,
                                                            priceValue = priceValue,
                                                            teleportPart = teleportPart,
                                                            position = teleportPart.Position,
                                                            rarity = animalOverhead:FindFirstChild("Rarity") and animalOverhead.Rarity.Text or "Unknown",
                                                            mutation = animalOverhead:FindFirstChild("Mutation") and animalOverhead.Mutation.Text or "None"
                                                        }
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    
    return highestBrainrot
end

local function createHighestValueESP(brainrotData)
    if not brainrotData or not brainrotData.teleportPart then return end
    
    if highestValueESP then
        if highestValueESP.highlight then highestValueESP.highlight:Destroy() end
        if highestValueESP.nameLabel then highestValueESP.nameLabel:Destroy() end
        if highestValueESP.tracer then 
            if highestValueESP.tracer.beam then highestValueESP.tracer.beam:Destroy() end
            if highestValueESP.tracer.attachment0 then highestValueESP.tracer.attachment0:Destroy() end
            if highestValueESP.tracer.attachment1 then highestValueESP.tracer.attachment1:Destroy() end
        end
        if highestValueESP.structureHighlight then highestValueESP.structureHighlight:Destroy() end
    end
    
    local espContainer = {}
    
    local highlight = Instance.new("Highlight")
    highlight.Parent = brainrotData.teleportPart
    highlight.FillColor = Color3.fromRGB(255, 215, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
    highlight.FillTransparency = 0.7
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    espContainer.highlight = highlight
    
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Parent = brainrotData.teleportPart
    billboardGui.Size = UDim2.new(0, 180, 0, 80)
    billboardGui.StudsOffset = Vector3.new(0, 8, 0)
    billboardGui.AlwaysOnTop = true
    
    local containerFrame = Instance.new("Frame")
    containerFrame.Parent = billboardGui
    containerFrame.Size = UDim2.new(1, 0, 1, 0)
    containerFrame.BackgroundTransparency = 1
    
    local mutationLabel = Instance.new("TextLabel")
    mutationLabel.Parent = containerFrame
    mutationLabel.Size = UDim2.new(1, 0, 0.15, 0)
    mutationLabel.Position = UDim2.new(0, 0, 0, 0)
    mutationLabel.BackgroundTransparency = 1
    mutationLabel.Text = brainrotData.mutation or ""
    mutationLabel.TextColor3 = Color3.new(1, 1, 1)
    mutationLabel.TextStrokeTransparency = 0
    mutationLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    mutationLabel.TextScaled = true
    mutationLabel.TextSize = 8
    mutationLabel.Font = Enum.Font.SourceSans
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Parent = containerFrame
    nameLabel.Size = UDim2.new(1, 0, 0.4, 0)
    nameLabel.Position = UDim2.new(0, 0, 0.15, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = "HIGHEST VALUE BRAINROT"
    nameLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    nameLabel.TextScaled = true
    nameLabel.TextSize = 14
    nameLabel.Font = Enum.Font.SourceSansBold
    
    local moneyLabel = Instance.new("TextLabel")
    moneyLabel.Parent = containerFrame
    moneyLabel.Size = UDim2.new(1, 0, 0.25, 0)
    moneyLabel.Position = UDim2.new(0, 0, 0.55, 0)
    moneyLabel.BackgroundTransparency = 1
    moneyLabel.Text = brainrotData.price or ""
    moneyLabel.TextColor3 = Color3.new(0, 1, 0)
    moneyLabel.TextStrokeTransparency = 0
    moneyLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    moneyLabel.TextScaled = true
    moneyLabel.TextSize = 10
    moneyLabel.Font = Enum.Font.SourceSans
    
    local rarityLabel = Instance.new("TextLabel")
    rarityLabel.Parent = containerFrame
    rarityLabel.Size = UDim2.new(1, 0, 0.2, 0)
    rarityLabel.Position = UDim2.new(0, 0, 0.8, 0)
    rarityLabel.BackgroundTransparency = 1
    rarityLabel.Text = brainrotData.rarity or ""
    rarityLabel.TextScaled = true
    rarityLabel.TextSize = 8
    rarityLabel.Font = Enum.Font.SourceSans
    
    if brainrotData.rarity == "Secret" then
        rarityLabel.TextColor3 = Color3.new(0, 0, 0)
        rarityLabel.TextStrokeTransparency = 0
        rarityLabel.TextStrokeColor3 = Color3.new(1, 1, 1)
    elseif brainrotData.rarity == "Brainrot God" then
        task.spawn(function()
            local hue = 0
            while rarityLabel and rarityLabel.Parent do
                hue = (hue + 0.01) % 1
                rarityLabel.TextColor3 = Color3.fromHSV(hue, 1, 1)
                task.wait(0.1)
            end
        end)
        rarityLabel.TextStrokeTransparency = 0
        rarityLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    else
        rarityLabel.TextColor3 = Color3.new(1, 1, 1)
        rarityLabel.TextStrokeTransparency = 0
        rarityLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    end
    
    espContainer.nameLabel = billboardGui
    
    local camera = workspace.CurrentCamera
    if camera then
        local attachment0 = Instance.new("Attachment")
        attachment0.Name = "TracerCameraAttachment"
        attachment0.Parent = camera
        attachment0.Position = Vector3.new(0, 0, 0)
        
        local attachment1 = Instance.new("Attachment")
        attachment1.Name = "TracerTargetAttachment"
        attachment1.Parent = brainrotData.teleportPart
        attachment1.Position = Vector3.new(0, 0, 0)
        
        local beam = Instance.new("Beam")
        beam.Name = "HighestBrainrotTracer"
        beam.Parent = workspace.Terrain
        beam.Attachment0 = attachment0
        beam.Attachment1 = attachment1
        beam.Width0 = 0.3
        beam.Width1 = 0.3
        beam.Color = ColorSequence.new(Color3.fromRGB(255, 255, 0))
        beam.Transparency = NumberSequence.new(0.2)
        beam.FaceCamera = true
        beam.LightEmission = 1
        beam.LightInfluence = 0
        beam.Texture = "rbxasset://textures/ui/VR/LaserBeam.png"
        beam.TextureMode = Enum.TextureMode.Static
        beam.TextureLength = 1
        beam.ZOffset = 0
        
        espContainer.tracer = {
            beam = beam, 
            attachment0 = attachment0, 
            attachment1 = attachment1
        }
    end
    
    local structureBaseHome = brainrotData.plot:FindFirstChild("structure base home")
    if structureBaseHome then
        local structureHighlight = Instance.new("Highlight")
        structureHighlight.Parent = structureBaseHome
        structureHighlight.FillColor = Color3.fromRGB(255, 215, 0)
        structureHighlight.OutlineColor = Color3.fromRGB(255, 255, 0)
        structureHighlight.FillTransparency = 0.8
        structureHighlight.OutlineTransparency = 0.2
        structureHighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        espContainer.structureHighlight = structureHighlight
    end
    
    highestValueESP = espContainer
    highestValueData = brainrotData
end

local function updateHighestValueESP()
    local newHighestBrainrot = findHighestBrainrot()
    
    if newHighestBrainrot and (not highestValueData or 
        newHighestBrainrot.priceValue > highestValueData.priceValue or
        newHighestBrainrot.plotName ~= highestValueData.plotName or
        newHighestBrainrot.podiumNumber ~= highestValueData.podiumNumber) then
        
        createHighestValueESP(newHighestBrainrot)
    end
end

local function removeHighestValueESP()
    if highestValueESP then
        if highestValueESP.highlight then highestValueESP.highlight:Destroy() end
        if highestValueESP.nameLabel then highestValueESP.nameLabel:Destroy() end
        if highestValueESP.tracer then 
            if highestValueESP.tracer.beam then highestValueESP.tracer.beam:Destroy() end
            if highestValueESP.tracer.attachment0 then highestValueESP.tracer.attachment0:Destroy() end
            if highestValueESP.tracer.attachment1 then highestValueESP.tracer.attachment1:Destroy() end
        end
        if highestValueESP.structureHighlight then highestValueESP.structureHighlight:Destroy() end
        highestValueESP = nil
        highestValueData = nil
    end
end

local function createTeleportOverlay()
    if teleportOverlay then
        teleportOverlay:Destroy()
    end
    
    teleportOverlay = Instance.new("ScreenGui")
    teleportOverlay.Name = "TeleportOverlay"
    teleportOverlay.Parent = playerGui
    teleportOverlay.ResetOnSpawn = false
    
    local overlayFrame = Instance.new("Frame")
    overlayFrame.Size = UDim2.new(1, 0, 1, 0)
    overlayFrame.Position = UDim2.new(0, 0, 0, 0)
    overlayFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    overlayFrame.BackgroundTransparency = 0.5
    overlayFrame.BorderSizePixel = 0
    overlayFrame.Parent = teleportOverlay
    
    local loadingFrame = Instance.new("Frame")
    loadingFrame.Size = UDim2.new(0, 400, 0, 200)
    loadingFrame.Position = UDim2.new(0.5, -200, 0.5, -100)
    loadingFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    loadingFrame.BorderSizePixel = 0
    loadingFrame.Parent = overlayFrame
    
    local loadingCorner = Instance.new("UICorner")
    loadingCorner.CornerRadius = UDim.new(0, 12)
    loadingCorner.Parent = loadingFrame
    
    local loadingTitle = Instance.new("TextLabel")
    loadingTitle.Size = UDim2.new(1, -20, 0, 50)
    loadingTitle.Position = UDim2.new(0, 10, 0, 10)
    loadingTitle.BackgroundTransparency = 1
    loadingTitle.Text = "TELEPORTING TO HIGHEST BRAINROT!"
    loadingTitle.TextColor3 = Color3.fromRGB(255, 215, 0)
    loadingTitle.TextScaled = true
    loadingTitle.Font = Enum.Font.GothamBold
    loadingTitle.Parent = loadingFrame
    
    local loadingStatus = Instance.new("TextLabel")
    loadingStatus.Size = UDim2.new(1, -20, 0, 30)
    loadingStatus.Position = UDim2.new(0, 10, 0, 70)
    loadingStatus.BackgroundTransparency = 1
    loadingStatus.Text = "Scanning for highest value brainrot..."
    loadingStatus.TextColor3 = Color3.fromRGB(255, 255, 255)
    loadingStatus.TextScaled = true
    loadingStatus.Font = Enum.Font.Gotham
    loadingStatus.Parent = loadingFrame
    
    local loadingBar = Instance.new("Frame")
    loadingBar.Size = UDim2.new(0.8, 0, 0, 8)
    loadingBar.Position = UDim2.new(0.1, 0, 0, 120)
    loadingBar.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    loadingBar.BorderSizePixel = 0
    loadingBar.Parent = loadingFrame
    
    local loadingBarCorner = Instance.new("UICorner")
    loadingBarCorner.CornerRadius = UDim.new(0, 4)
    loadingBarCorner.Parent = loadingBar
    
    local loadingProgress = Instance.new("Frame")
    loadingProgress.Size = UDim2.new(0, 0, 1, 0)
    loadingProgress.Position = UDim2.new(0, 0, 0, 0)
    loadingProgress.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
    loadingProgress.BorderSizePixel = 0
    loadingProgress.Parent = loadingBar
    
    local loadingProgressCorner = Instance.new("UICorner")
    loadingProgressCorner.CornerRadius = UDim.new(0, 4)
    loadingProgressCorner.Parent = loadingProgress
    
    local brainrotInfo = Instance.new("TextLabel")
    brainrotInfo.Size = UDim2.new(1, -20, 0, 40)
    brainrotInfo.Position = UDim2.new(0, 10, 0, 140)
    brainrotInfo.BackgroundTransparency = 1
    brainrotInfo.Text = ""
    brainrotInfo.TextColor3 = Color3.fromRGB(0, 255, 0)
    brainrotInfo.TextScaled = true
    brainrotInfo.Font = Enum.Font.GothamBold
    brainrotInfo.Parent = loadingFrame
    
    return {
        overlay = teleportOverlay,
        statusLabel = loadingStatus,
        progressBar = loadingProgress,
        brainrotInfo = brainrotInfo
    }
end

local function removeTeleportOverlay()
    if teleportOverlay then
        teleportOverlay:Destroy()
        teleportOverlay = nil
    end
end

local function executeTeleportToHighestBrainrot()
    local currentTime = tick()
    
    if currentTime - lastClickTime < DOUBLE_CLICK_PREVENTION_TIME then
        return
    end
    
    lastClickTime = currentTime
    
    if teleportEnabled then
        teleportEnabled = false
        removeTeleportOverlay()
        return
    end
    
    teleportEnabled = true
    
    local overlay = createTeleportOverlay()
    
    task.spawn(function()
        overlay.statusLabel.Text = "Scanning for highest value brainrot..."
        TweenService:Create(overlay.progressBar, TweenInfo.new(0.5), {Size = UDim2.new(0.2, 0, 1, 0)}):Play()
        
        if not teleportEnabled then
            removeTeleportOverlay()
            return
        end
        
        highestBrainrotData = findHighestBrainrot()
        
        if not highestBrainrotData then
            overlay.statusLabel.Text = "No brainrots found!"
            task.wait(2)
            teleportEnabled = false
            removeTeleportOverlay()
            return
        end
        
        overlay.statusLabel.Text = "Found highest brainrot!"
        overlay.brainrotInfo.Text = "Plot: " .. highestBrainrotData.plotName .. " | Slot: " .. highestBrainrotData.podiumNumber .. "\nPrice: " .. highestBrainrotData.price .. " | Rarity: " .. highestBrainrotData.rarity
        TweenService:Create(overlay.progressBar, TweenInfo.new(0.5), {Size = UDim2.new(0.4, 0, 1, 0)}):Play()
        task.wait(0.5)
            
        if not teleportEnabled then
            removeTeleportOverlay()
            return
        end

        TweenService:Create(overlay.progressBar, TweenInfo.new(0.5), {Size = UDim2.new(0.6, 0, 1, 0)}):Play()
        
        local equipped = equipQuantumCloner()
        if not equipped then
            overlay.statusLabel.Text = "Quantum Cloner not found!"
            task.wait(2)
            teleportEnabled = false
            removeTeleportOverlay()
            return
        end
        
        if not teleportEnabled then
            removeTeleportOverlay()
            return
        end

        overlay.statusLabel.Text = "Teleporting to highest brainrot..."
        TweenService:Create(overlay.progressBar, TweenInfo.new(0.5), {Size = UDim2.new(0.9, 0, 1, 0)}):Play()
        
        if highestBrainrotData.teleportPart then
            local character = player.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local targetPosition = highestBrainrotData.teleportPart.Position + Vector3.new(0, 5, 0)

                fireQuantumCloner()
                    
                if not teleportEnabled then
                    removeTeleportOverlay()
                    return
                end
        
                local startTime = tick()
                while tick() - startTime < 0.8 do
                    character.HumanoidRootPart.CFrame = CFrame.new(targetPosition)
                    fireQuantumClonerTeleport()
                    RunService.Heartbeat:Wait()
                end
        
                if not teleportEnabled then
                    removeTeleportOverlay()
                    return
                end
            end
        else
            overlay.statusLabel.Text = "Teleport position not found!"
            task.wait(2)
        end
        
        overlay.statusLabel.Text = "Teleport completed!"
        TweenService:Create(overlay.progressBar, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 1, 0)}):Play()
        task.wait(1)
        
        teleportEnabled = false
        removeTeleportOverlay()
    end)
end

local function createPermanentPlayerESP(playerObj)
    if not playerObj.Character or not playerObj.Character:FindFirstChild("HumanoidRootPart") then
        return
    end
    
    if not ownerESPEnabled then return end
    
    local humanoidRootPart = playerObj.Character.HumanoidRootPart
    
    local existingHighlight = humanoidRootPart:FindFirstChild("PermanentHighlight")
    if existingHighlight then
        existingHighlight:Destroy()
    end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "PermanentHighlight"
    highlight.Parent = humanoidRootPart
    highlight.FillColor = Color3.fromRGB(0, 255, 0)
    highlight.OutlineColor = Color3.fromRGB(0, 200, 0)
    highlight.FillTransparency = 0.6
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
end

local function initializePermanentESP()
    if not ownerESPEnabled then return end
    
    for _, playerObj in pairs(Players:GetPlayers()) do
        if playerObj ~= LocalPlayer and playerObj.Character then
            createPermanentPlayerESP(playerObj)
        end
    end
end

local function createPlatform()
    local platform = Instance.new("Part")
    platform.Name = "PlayerPlatform"
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
    if not player.Character then return end
    
    local character = player.Character
    local humanoid = character:FindFirstChild("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not rootPart then return end
    
    local lastTapTime = 0
    local DOUBLE_TAP_DELAY = 0.3
    
    local function performJump()
        if humanoid then
            equipAndFireGrapple()
            
            task.spawn(function()
                task.wait(0.1)
                if platformEnabled and humanoid then
                    humanoid.Jump = true
                    equipAndFireGrapple()
                    unEquipGrappleHook()
                end
            end)
        end
    end
    
    UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
        if gameProcessedEvent then return end
        
        if input.KeyCode == Enum.KeyCode.Space and platformEnabled then
            local currentTime = tick()
            
            if currentTime - lastTapTime <= DOUBLE_TAP_DELAY then
                performJump()
            end
            
            lastTapTime = currentTime
        end
    end)
end

local function removeSlowFall()
    if originalGravity and player.Character then
        local character = player.Character
        local humanoid = character:FindFirstChild("Humanoid")
        
        if humanoid then
            if bodyVelocity then
                bodyVelocity:Destroy()
                bodyVelocity = nil
            end
            if elevationBodyVelocity then
                elevationBodyVelocity:Destroy()
                elevationBodyVelocity = nil
            end
        end
    end
    originalGravity = nil
end

local function createComboPlatform()
    local platform = Instance.new("Part")
    platform.Name = "ComboPlatform"
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
end

local function makeWallsTransparent(transparent)
    for obj, data in pairs(originalTransparencies) do
        if obj and obj.Parent and data then
            if transparent then
                obj.Transparency = TRANSPARENCY_LEVEL
                obj.CanCollide = false
            else
                obj.Transparency = data.transparency
                obj.CanCollide = data.canCollide
            end
        end
    end
end

local function forcePlayerHeadCollision()
    if player.Character then
        local head = player.Character:FindFirstChild("Head")
        if head then
            head.CanCollide = true
        end
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
    
    applySlowFall()
    
    platformUpdateConnection = RunService.Heartbeat:Connect(updatePlatformPosition)
    updatePlatformPosition()

    if not grappleHookConnection then
        grappleHookConnection = task.spawn(function()
            while platformEnabled do
                task.wait(2)
                equipAndFireGrapple()
                task.wait(0.1)
                unEquipGrappleHook()
            end
        end)
    end
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
    
    if grappleHookConnection then
        task.cancel(grappleHookConnection)
        grappleHookConnection = nil
        equipAndFireGrapple()
        task.wait(0.5)
        equipAndFireGrapple()
    end
end

local function enableWallTransparency()
    if wallTransparencyEnabled then return end
    
    wallTransparencyEnabled = true
    comboFloatEnabled = true
    
    storeOriginalTransparencies()
    makeWallsTransparent(true)
    
    comboCurrentPlatform = createComboPlatform()
    comboPlatformUpdateConnection = RunService.Heartbeat:Connect(updateComboPlatformPosition)
    updateComboPlatformPosition()
    
    comboPlayerCollisionConnection = RunService.Heartbeat:Connect(function()
        forcePlayerHeadCollision()
    end)
    
    forcePlayerHeadCollision()

    if not grappleHookConnection then
        grappleHookConnection = task.spawn(function()
            while wallTransparencyEnabled do
                task.wait(1.5)
                equipAndFireGrapple()
                task.wait(0.1)
                unEquipGrappleHook()
            end
        end)
    end
end

local function disableWallTransparency()
    if not wallTransparencyEnabled then return end
    
    wallTransparencyEnabled = false
    comboFloatEnabled = false
    
    makeWallsTransparent(false)
    originalTransparencies = {}
    
    if comboPlatformUpdateConnection then
        comboPlatformUpdateConnection:Disconnect()
        comboPlatformUpdateConnection = nil
    end
    
    if comboCurrentPlatform then
        comboCurrentPlatform:Destroy()
        comboCurrentPlatform = nil
    end
    
    if comboPlayerCollisionConnection then
        comboPlayerCollisionConnection:Disconnect()
        comboPlayerCollisionConnection = nil
    end
    
    if grappleHookConnection then
        task.cancel(grappleHookConnection)
        grappleHookConnection = nil
    end
    
    if player.Character then
        local head = player.Character:FindFirstChild("Head")
        if head then
            head.CanCollide = false
        end
    end
end

local function createAlertGui()
    if alertGui then return end
    if not baseTimeAlertEnabled then return end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    screenGui.Name = "AlertGui"
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
    textLabel.Text = "BASE TIME WARNING"
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
    if not alertGui or not baseTimeAlertEnabled then return end
    alertGui.textLabel.Text = "BASE UNLOCKING IN " .. timeText
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

function createPlayerESP(playerObj, head)
    if not playerESPEnabled then return end
    
    local existingGui = head:FindFirstChild("PlayerESP")
    if existingGui then
        existingGui:Destroy()
    end
    
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Name = "PlayerESP"
    billboardGui.Parent = head
    billboardGui.Size = UDim2.new(0, 90, 0, 33)
    billboardGui.StudsOffset = Vector3.new(0, 2, 0)
    billboardGui.AlwaysOnTop = true
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Parent = billboardGui
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = playerObj.DisplayName
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.TextScaled = true
    textLabel.TextStrokeTransparency = 0.3
    textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    textLabel.Font = Enum.Font.SourceSans
end

local function createPlayerDisplay(playerObj)
    if playerObj == LocalPlayer then return end
    if not playerESPEnabled then return end
    
    local character = playerObj.Character
    if not character then
        playerObj.CharacterAdded:Connect(function(char)
            character = char
            task.wait(0.5)
            local head = character:FindFirstChild("Head")
            if head and playerESPEnabled then
                createPlayerESP(playerObj, head)
            end
        end)
        return
    end
    
    local head = character:FindFirstChild("Head")
    if head then
        createPlayerESP(playerObj, head)
    else
        character.ChildAdded:Connect(function(child)
            if child.Name == "Head" and playerESPEnabled then
                createPlayerESP(playerObj, child)
            end
        end)
    end
end

local function createOrUpdatePlotDisplay(plot)
    if not baseTimeESPEnabled then return end
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
            if not playerBaseTimeWarning and baseTimeAlertEnabled then
                createAlertGui()
                playerBaseTimeWarning = true
            end
            if baseTimeAlertEnabled then
                updateAlertGui(plotTimeText)
            end
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
        if plotDisplays[plotName].signLabel then
            plotDisplays[plotName].signLabel.Text = plotSignText
        end
        if plotDisplays[plotName].timeLabel then
            plotDisplays[plotName].timeLabel.Text = plotTimeText
        end
    end
end

local function updateAllPlots()
    if not baseTimeESPEnabled then return end
    
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
    
    player.CharacterAdded:Connect(function(character)
        task.wait(0.5)
        if character and character.Parent then
            setupNoJumpDelay(character)
        end
    end)
    
    player.CharacterRemoving:Connect(function(character)
        cleanupJumpDelayConnections(character)
    end)
end

-- UI Storage
local floatUI = nil
local floorStealUI = nil

-- Function to create draggable Float UI
local function createFloatUI()
    if floatUI then
        floatUI:Destroy()
    end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "FloatUI"
    screenGui.Parent = playerGui
    screenGui.ResetOnSpawn = false
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 280, 0, 120)
    mainFrame.Position = UDim2.new(0.5, -140, 0.3, -60)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 12)
    mainCorner.Parent = mainFrame
    
    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 12)
    titleCorner.Parent = titleBar
    
    local titleFix = Instance.new("Frame")
    titleFix.Size = UDim2.new(1, 0, 0, 12)
    titleFix.Position = UDim2.new(0, 0, 1, -12)
    titleFix.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    titleFix.BorderSizePixel = 0
    titleFix.Parent = titleBar
    
    local titleText = Instance.new("TextLabel")
    titleText.Name = "TitleText"
    titleText.Size = UDim2.new(1, -80, 1, 0)
    titleText.Position = UDim2.new(0, 15, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = "Float Settings"
    titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleText.TextSize = 16
    titleText.Font = Enum.Font.GothamBold
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Parent = titleBar
    
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -35, 0, 5)
    closeButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    closeButton.Text = "✕"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextSize = 18
    closeButton.Font = Enum.Font.GothamBold
    closeButton.BorderSizePixel = 0
    closeButton.Parent = titleBar
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 8)
    closeCorner.Parent = closeButton
    
    -- Toggle Container
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, -20, 0, 50)
    toggleFrame.Position = UDim2.new(0, 10, 0, 55)
    toggleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    toggleFrame.BorderSizePixel = 0
    toggleFrame.Parent = mainFrame
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 10)
    toggleCorner.Parent = toggleFrame
    
    local toggleLabel = Instance.new("TextLabel")
    toggleLabel.Size = UDim2.new(1, -70, 1, 0)
    toggleLabel.Position = UDim2.new(0, 15, 0, 0)
    toggleLabel.BackgroundTransparency = 1
    toggleLabel.Text = "Enable Float"
    toggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleLabel.TextSize = 14
    toggleLabel.Font = Enum.Font.Gotham
    toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    toggleLabel.Parent = toggleFrame
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "ToggleButton"
    toggleButton.Size = UDim2.new(0, 50, 0, 30)
    toggleButton.Position = UDim2.new(1, -60, 0.5, -15)
    toggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
    toggleButton.Text = ""
    toggleButton.BorderSizePixel = 0
    toggleButton.Parent = toggleFrame
    
    local toggleButtonCorner = Instance.new("UICorner")
    toggleButtonCorner.CornerRadius = UDim.new(1, 0)
    toggleButtonCorner.Parent = toggleButton
    
    local toggleCircle = Instance.new("Frame")
    toggleCircle.Name = "Circle"
    toggleCircle.Size = UDim2.new(0, 22, 0, 22)
    toggleCircle.Position = UDim2.new(0, 4, 0.5, -11)
    toggleCircle.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    toggleCircle.BorderSizePixel = 0
    toggleCircle.Parent = toggleButton
    
    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(1, 0)
    circleCorner.Parent = toggleCircle
    
    -- Toggle State
    local isEnabled = platformEnabled
    
    local function updateToggleVisuals()
        if isEnabled then
            TweenService:Create(toggleButton, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(0, 200, 100)}):Play()
            TweenService:Create(toggleCircle, TweenInfo.new(0.3), {Position = UDim2.new(1, -26, 0.5, -11)}):Play()
        else
            TweenService:Create(toggleButton, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(60, 60, 65)}):Play()
            TweenService:Create(toggleCircle, TweenInfo.new(0.3), {Position = UDim2.new(0, 4, 0.5, -11)}):Play()
        end
    end
    
    updateToggleVisuals()
    
    toggleButton.MouseButton1Click:Connect(function()
        isEnabled = not isEnabled
        updateToggleVisuals()
        
        if isEnabled then
            enablePlatform()
            WindUI:Notify({
                Title = "Float Enabled",
                Content = "Floating platform activated!",
                Icon = "check",
                Duration = 2
            })
        else
            disablePlatform()
            WindUI:Notify({
                Title = "Float Disabled",
                Content = "Floating platform deactivated!",
                Icon = "x",
                Duration = 2
            })
        end
    end)
    
    -- Close button functionality
    closeButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
        floatUI = nil
    end)
    
    closeButton.MouseEnter:Connect(function()
        closeButton.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
    end)
    
    closeButton.MouseLeave:Connect(function()
        closeButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    end)
    
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
    
    floatUI = screenGui
end

-- Function to create draggable Floor Steal UI
local function createFloorStealUI()
    if floorStealUI then
        floorStealUI:Destroy()
    end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "FloorStealUI"
    screenGui.Parent = playerGui
    screenGui.ResetOnSpawn = false
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 280, 0, 120)
    mainFrame.Position = UDim2.new(0.5, -140, 0.4, -60)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 12)
    mainCorner.Parent = mainFrame
    
    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 12)
    titleCorner.Parent = titleBar
    
    local titleFix = Instance.new("Frame")
    titleFix.Size = UDim2.new(1, 0, 0, 12)
    titleFix.Position = UDim2.new(0, 0, 1, -12)
    titleFix.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    titleFix.BorderSizePixel = 0
    titleFix.Parent = titleBar
    
    local titleText = Instance.new("TextLabel")
    titleText.Name = "TitleText"
    titleText.Size = UDim2.new(1, -80, 1, 0)
    titleText.Position = UDim2.new(0, 15, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = "Floor Steal Settings"
    titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleText.TextSize = 16
    titleText.Font = Enum.Font.GothamBold
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Parent = titleBar
    
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -35, 0, 5)
    closeButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    closeButton.Text = "✕"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextSize = 18
    closeButton.Font = Enum.Font.GothamBold
    closeButton.BorderSizePixel = 0
    closeButton.Parent = titleBar
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 8)
    closeCorner.Parent = closeButton
    
    -- Toggle Container
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, -20, 0, 50)
    toggleFrame.Position = UDim2.new(0, 10, 0, 55)
    toggleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    toggleFrame.BorderSizePixel = 0
    toggleFrame.Parent = mainFrame
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 10)
    toggleCorner.Parent = toggleFrame
    
    local toggleLabel = Instance.new("TextLabel")
    toggleLabel.Size = UDim2.new(1, -70, 1, 0)
    toggleLabel.Position = UDim2.new(0, 15, 0, 0)
    toggleLabel.BackgroundTransparency = 1
    toggleLabel.Text = "Enable Floor Steal"
    toggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleLabel.TextSize = 14
    toggleLabel.Font = Enum.Font.Gotham
    toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    toggleLabel.Parent = toggleFrame
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "ToggleButton"
    toggleButton.Size = UDim2.new(0, 50, 0, 30)
    toggleButton.Position = UDim2.new(1, -60, 0.5, -15)
    toggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
    toggleButton.Text = ""
    toggleButton.BorderSizePixel = 0
    toggleButton.Parent = toggleFrame
    
    local toggleButtonCorner = Instance.new("UICorner")
    toggleButtonCorner.CornerRadius = UDim.new(1, 0)
    toggleButtonCorner.Parent = toggleButton
    
    local toggleCircle = Instance.new("Frame")
    toggleCircle.Name = "Circle"
    toggleCircle.Size = UDim2.new(0, 22, 0, 22)
    toggleCircle.Position = UDim2.new(0, 4, 0.5, -11)
    toggleCircle.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    toggleCircle.BorderSizePixel = 0
    toggleCircle.Parent = toggleButton
    
    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(1, 0)
    circleCorner.Parent = toggleCircle
    
    -- Toggle State
    local isEnabled = wallTransparencyEnabled
    
    local function updateToggleVisuals()
        if isEnabled then
            TweenService:Create(toggleButton, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(255, 120, 0)}):Play()
            TweenService:Create(toggleCircle, TweenInfo.new(0.3), {Position = UDim2.new(1, -26, 0.5, -11)}):Play()
        else
            TweenService:Create(toggleButton, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(60, 60, 65)}):Play()
            TweenService:Create(toggleCircle, TweenInfo.new(0.3), {Position = UDim2.new(0, 4, 0.5, -11)}):Play()
        end
    end
    
    updateToggleVisuals()
    
    toggleButton.MouseButton1Click:Connect(function()
        isEnabled = not isEnabled
        updateToggleVisuals()
        
        if isEnabled then
            enableWallTransparency()
            WindUI:Notify({
                Title = "Floor Steal Enabled",
                Content = "Floor stealing mode activated!",
                Icon = "check",
                Duration = 2
            })
        else
            disableWallTransparency()
            WindUI:Notify({
                Title = "Floor Steal Disabled",
                Content = "Floor stealing mode deactivated!",
                Icon = "x",
                Duration = 2
            })
        end
    end)
    
    -- Close button functionality
    closeButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
        floorStealUI = nil
    end)
    
    closeButton.MouseEnter:Connect(function()
        closeButton.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
    end)
    
    closeButton.MouseLeave:Connect(function()
        closeButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    end)
    
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
    
    floorStealUI = screenGui
end

-- Load WindUI Library
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

-- Create Window
local Window = WindUI:CreateWindow({
    Title = "Steal A Brainrot",
    Icon = "home",
    Author = "by PickleTalk",
    Folder = "StealABrainrotConfig",
    Size = UDim2.fromOffset(550, 450),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 170,
})

-- Create Tabs
local MainTab = Window:Tab({
    Title = "Main",
    Icon = "flame",
    Desc = "Main stealing features"
})

local PlayerTab = Window:Tab({
    Title = "Player",
    Icon = "user",
    Desc = "Player modifications"
})

local VisualsTab = Window:Tab({
    Title = "Visuals",
    Icon = "eye",
    Desc = "ESP and visual aids"
})

local UtilitiesTab = Window:Tab({
    Title = "Utilities",
    Icon = "wrench",
    Desc = "Utility features"
})

local ServerTab = Window:Tab({
    Title = "Server",
    Icon = "server",
    Desc = "Server information"
})

local CreditsTab = Window:Tab({
    Title = "Credits",
    Icon = "heart",
    Desc = "Script information"
})

-- MAIN TAB
MainTab:Button({
    Title = "Float",
    Desc = "Open floating platform controls",
    Icon = "layers",
    Callback = function()
        createFloatUI()
    end
})

MainTab:Button({
    Title = "Floor Steal",
    Desc = "Open floor stealing controls",
    Icon = "box",
    Callback = function()
        createFloorStealUI()
    end
})

MainTab:Button({
    Title = "Teleport to Highest Brainrot",
    Icon = "zap",
    Callback = function()
        executeTeleportToHighestBrainrot()
    end
})

-- PLAYER TAB
PlayerTab:Toggle({
    Title = "Anti Ragdoll",
    Desc = "Prevents ragdolling",
    Value = false,
    Callback = function(value)
        antiRagdollEnabled = value
        
        if antiRagdollEnabled then
            setupAntiRagdollProtection()
            WindUI:Notify({
                Title = "Anti Ragdoll Enabled",
                Content = "You are now protected from ragdolling!",
                Icon = "shield",
                Duration = 2
            })
        else
            cleanupAntiRagdoll()
            WindUI:Notify({
                Title = "Anti Ragdoll Disabled",
                Content = "Anti ragdoll protection disabled!",
                Icon = "shield-off",
                Duration = 2
            })
        end
    end
})

PlayerTab:Toggle({
    Title = "Anti Fling",
    Desc = "Prevents fast velocity flinging",
    Value = false,
    Callback = function(value)
        antiFlingEnabled = value
        
        if antiFlingEnabled then
            local flingConnection = RunService.Heartbeat:Connect(function()
                if antiFlingEnabled then
                    preventFling()
                end
            end)
            
            WindUI:Notify({
                Title = "Anti Fling Enabled",
                Content = "You are now protected from flinging!",
                Icon = "shield",
                Duration = 2
            })
        else
            WindUI:Notify({
                Title = "Anti Fling Disabled",
                Content = "Anti fling protection disabled!",
                Icon = "shield-off",
                Duration = 2
            })
        end
    end
})

-- VISUALS TAB
VisualsTab:Toggle({
    Title = "Player ESP",
    Desc = "Show player names above heads",
    Value = false,
    Callback = function(value)
        playerESPEnabled = value
        
        if playerESPEnabled then
            for _, playerObj in pairs(Players:GetPlayers()) do
                if playerObj ~= LocalPlayer then
                    createPlayerDisplay(playerObj)
                end
            end
            WindUI:Notify({
                Title = "Player ESP Enabled",
                Content = "Player names are now visible!",
                Icon = "users",
                Duration = 2
            })
        else
            for _, playerObj in pairs(Players:GetPlayers()) do
                if playerObj ~= LocalPlayer and playerObj.Character then
                    local head = playerObj.Character:FindFirstChild("Head")
                    if head then
                        local esp = head:FindFirstChild("PlayerESP")
                        if esp then esp:Destroy() end
                    end
                end
            end
            WindUI:Notify({
                Title = "Player ESP Disabled",
                Content = "Player ESP disabled!",
                Icon = "users",
                Duration = 2
            })
        end
    end
})

VisualsTab:Toggle({
    Title = "Base Time ESP",
    Desc = "Show base time remaining",
    Value = false,
    Callback = function(value)
        baseTimeESPEnabled = value
        
        if baseTimeESPEnabled then
            updateAllPlots()
            WindUI:Notify({
                Title = "Base Time ESP Enabled",
                Content = "Base time information visible!",
                Icon = "clock",
                Duration = 2
            })
        else
            for _, display in pairs(plotDisplays) do
                if display.gui then
                    display.gui:Destroy()
                end
            end
            plotDisplays = {}
            WindUI:Notify({
                Title = "Base Time ESP Disabled",
                Content = "Base time ESP disabled!",
                Icon = "clock",
                Duration = 2
            })
        end
    end
})

VisualsTab:Toggle({
    Title = "Owner ESP",
    Desc = "Highlight player HumanoidRootPart",
    Value = false,
    Callback = function(value)
        ownerESPEnabled = value
        
        if ownerESPEnabled then
            initializePermanentESP()
            WindUI:Notify({
                Title = "Owner ESP Enabled",
                Content = "Player highlights activated!",
                Icon = "user-check",
                Duration = 2
            })
        else
            for _, playerObj in pairs(Players:GetPlayers()) do
                if playerObj ~= LocalPlayer and playerObj.Character then
                    local hrp = playerObj.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local highlight = hrp:FindFirstChild("PermanentHighlight")
                        if highlight then highlight:Destroy() end
                    end
                end
            end
            WindUI:Notify({
                Title = "Owner ESP Disabled",
                Content = "Owner ESP disabled!",
                Icon = "user-x",
                Duration = 2
            })
        end
    end
})

VisualsTab:Toggle({
    Title = "Base Time Alert",
    Desc = "Alert when base time is low",
    Value = false,
    Callback = function(value)
        baseTimeAlertEnabled = value
        
        if not baseTimeAlertEnabled then
            removeAlertGui()
            WindUI:Notify({
                Title = "Base Time Alert Disabled",
                Content = "Time alerts disabled!",
                Icon = "bell-off",
                Duration = 2
            })
        else
            WindUI:Notify({
                Title = "Base Time Alert Enabled",
                Content = "You will be alerted when base time is low!",
                Icon = "bell",
                Duration = 2
            })
        end
    end
})

-- UTILITIES TAB
UtilitiesTab:Toggle({
    Title = "Leave On Steal",
    Desc = "Auto leave when you steal something",
    Value = false,
    Callback = function(value)
        leaveOnStealEnabled = value
        
        if leaveOnStealEnabled then
            if waitForLeaderstats() then
                monitorSteals()
                WindUI:Notify({
                    Title = "Leave On Steal Enabled",
                    Content = "Will leave when steal count increases!",
                    Icon = "log-out",
                    Duration = 2
                })
            end
        else
            stopMonitoring()
            WindUI:Notify({
                Title = "Leave On Steal Disabled",
                Content = "Auto leave disabled!",
                Icon = "log-out",
                Duration = 2
            })
        end
    end
})

UtilitiesTab:Keybind({
    Title = "Leave Keybind",
    Value = Enum.KeyCode.L,
    Callback = function(key)
        leaveKeybind = key
        WindUI:Notify({
            Title = "Keybind Changed",
            Content = "Leave keybind set to: " .. key.Name,
            Icon = "keyboard",
            Duration = 2
        })
    end
})

UtilitiesTab:Button({
    Title = "Leave Game",
    Icon = "log-out",
    Callback = function()
        kickPlayer()
    end
})

-- SERVER TAB
local placeIdLabel = ServerTab:Paragraph({
    Title = "Place ID",
    Desc = tostring(game.PlaceId),
    Image = "hash",
    ImageSize = 20,
    Color = Color3.fromHex("#30ff6a")
})

local jobIdLabel = ServerTab:Paragraph({
    Title = "Job ID",
    Desc = tostring(game.JobId),
    Image = "server",
    ImageSize = 20,
    Color = Color3.fromHex("#30ff6a")
})

local playerCountLabel = ServerTab:Paragraph({
    Title = "Players",
    Desc = #Players:GetPlayers() .. " / " .. Players.MaxPlayers,
    Image = "users",
    ImageSize = 20,
    Color = Color3.fromHex("#30ff6a")
})

local highestBrainrotLabel = ServerTab:Paragraph({
    Title = "Highest Brainrot",
    Desc = "Scanning...",
    Image = "trophy",
    ImageSize = 20,
    Color = Color3.fromHex("#FFD700")
})

task.spawn(function()
    while true do
        task.wait(5)
        
        pcall(function()
            playerCountLabel.Desc = #Players:GetPlayers() .. " / " .. Players.MaxPlayers
        end)
        
        local highest = findHighestBrainrot()
        if highest then
            pcall(function()
                highestBrainrotLabel.Desc = highest.price .. " | " .. highest.plotName .. " #" .. highest.podiumNumber
            end)
        else
            pcall(function()
                highestBrainrotLabel.Desc = "None found"
            end)
        end
    end
end)

-- CREDITS TAB
CreditsTab:Paragraph({
    Title = "Scripts Hub X | Official",
    Desc = "by PickleTalk",
    Image = "code",
    ImageSize = 24,
    Color = Color3.fromHex("#30ff6a")
})

CreditsTab:Paragraph({
    Title = "Discord Server",
    Desc = "https://discord.gg/bpsNUH5sVb",
    Image = "message-circle",
    ImageSize = 20,
    Color = Color3.fromHex("#5865F2"),
    Buttons = {
        {
            Title = "Copy Link",
            Icon = "copy",
            Variant = "Tertiary",
            Callback = function()
                setclipboard("https://discord.gg/bpsNUH5sVb")
                WindUI:Notify({
                    Title = "Copied!",
                    Content = "Discord link copied to clipboard",
                    Icon = "check",
                    Duration = 2
                })
            end
        }
    }
})

-- Initialize
player.CharacterRemoving:Connect(function()
    platformEnabled = false
    wallTransparencyEnabled = false
    comboFloatEnabled = false
    teleportEnabled = false
    
    if currentPlatform then currentPlatform:Destroy() end
    if comboCurrentPlatform then comboCurrentPlatform:Destroy() end
    if grappleHookConnection then task.cancel(grappleHookConnection) end
    if teleportGrappleConnection then task.cancel(teleportGrappleConnection) end
    if teleportOverlay then removeTeleportOverlay() end
end)

player.CharacterAdded:Connect(onCharacterAdded)

Players.PlayerAdded:Connect(function(newPlayer)
    newPlayer.CharacterAdded:Connect(function(character)
        task.wait(1)
        if ownerESPEnabled then
            createPermanentPlayerESP(newPlayer)
        end
        if playerESPEnabled then
            createPlayerDisplay(newPlayer)
        end
    end)
end)

for _, playerObj in pairs(Players:GetPlayers()) do
    if playerObj ~= LocalPlayer then
        playerObj.CharacterAdded:Connect(function(character)
            task.wait(1)
            if ownerESPEnabled then
                createPermanentPlayerESP(playerObj)
            end
            if playerESPEnabled then
                createPlayerDisplay(playerObj)
            end
        end)
    end
end

Players.PlayerRemoving:Connect(function(leavingPlayer)
    if leavingPlayer.Character then
        local head = leavingPlayer.Character:FindFirstChild("Head")
        local hrp = leavingPlayer.Character:FindFirstChild("HumanoidRootPart")
        
        if head then
            local permanentESP = head:FindFirstChild("PermanentESP")
            if permanentESP then permanentESP:Destroy() end
        end
        
        if hrp then
            local permanentHighlight = hrp:FindFirstChild("PermanentHighlight")
            if permanentHighlight then permanentHighlight:Destroy() end
            removeHighestValueESP()
        end
    end
end)

local plots = workspace:FindFirstChild("Plots")
if plots then
    plots.ChildAdded:Connect(function(child)
        if (child:IsA("Model") or child:IsA("Folder")) and baseTimeESPEnabled then
            task.wait(0.5)
            createOrUpdatePlotDisplay(child)
        end
    end)
end

task.spawn(function()
    while true do
        task.wait(0.5)
        if baseTimeESPEnabled then
            pcall(updateAllPlots)
        end
    end
end)

task.spawn(function()
    task.wait(1)
    updateHighestValueESP()
    
    espUpdateConnection = task.spawn(function()
        while true do
            task.wait(20)
            updateHighestValueESP()
        end
    end)
end)

monitorSentryBullets()

if LocalPlayer.Character then
    task.wait(0.5)
    if antiRagdollEnabled then
        setupAntiRagdollProtection()
    end
end

removeJumpDelay()

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then return end
    
    if input.KeyCode == leaveKeybind then
        kickPlayer()
    end
end)
