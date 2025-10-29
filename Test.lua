-- Steal A Brainrot Script - WindUI Version (IMPROVED & UNDETECTABLE)
-- by PickleTalk - Enhanced Edition v2.0
-- Features: Anti-Kick, Config System, Anti-Detection, Cyan Neon Theme

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

-- ==================== CONFIGURATION SYSTEM ====================
local ConfigData = {
    antiRagdollEnabled = false,
    antiFlingEnabled = false,
    antiKickEnabled = false,
    playerESPEnabled = false,
    baseTimeESPEnabled = false,
    ownerESPEnabled = false,
    baseTimeAlertEnabled = false,
    leaveOnStealEnabled = false,
    platformEnabled = false,
    wallTransparencyEnabled = false,
    leaveKeybind = "L",
    uiColor = {R = 0, G = 255, B = 255}, -- Cyan Neon
    uiTransparency = 0,
}

local function saveConfiguration()
    local success = pcall(function()
        local configString = HttpService:JSONEncode(ConfigData)
        writefile("StealABrainrotConfig.json", configString)
    end)
    return success
end

local function loadConfiguration()
    local success = pcall(function()
        if isfile("StealABrainrotConfig.json") then
            local configString = readfile("StealABrainrotConfig.json")
            local loadedConfig = HttpService:JSONDecode(configString)
            
            for key, value in pairs(loadedConfig) do
                if ConfigData[key] ~= nil then
                    ConfigData[key] = value
                end
            end
        end
    end)
    return success
end

-- ==================== ANTI-DETECTION UTILITIES ====================
local function getRandomOffset()
    return Vector3.new(
        (math.random(-20, 20) / 10),
        (math.random(0, 30) / 10),
        (math.random(-20, 20) / 10)
    )
end

local function getRandomWait()
    return math.random(50, 150) / 1000
end

local function smoothTeleport(targetPosition, duration)
    pcall(function()
        if not character or not character:FindFirstChild("HumanoidRootPart") then return end
        
        local hrp = character.HumanoidRootPart
        local startPos = hrp.Position
        local distance = (targetPosition - startPos).Magnitude
        
        if distance < 10 then
            hrp.CFrame = CFrame.new(targetPosition)
            return
        end
        
        local steps = math.ceil(distance / 20)
        local stepDuration = (duration or 0.5) / steps
        
        for i = 1, steps do
            local alpha = i / steps
            local intermediatePos = startPos:Lerp(targetPosition, alpha) + getRandomOffset()
            hrp.CFrame = CFrame.new(intermediatePos)
            task.wait(stepDuration)
        end
    end)
end

-- ==================== FEATURE STATE VARIABLES ====================
local antiRagdollConnections = {}
local antiRagdollMonitoringConnections = {}
local MAX_VELOCITY = 500
local MAX_ANGULAR_VELOCITY = 100
local EXTREME_VELOCITY_THRESHOLD = 1000

local grappleHookConnection = nil
local lastStealCount = 0
local isMonitoring = false
local platformEnabled = false
local currentPlatform = nil
local platformUpdateConnection = nil
local PLATFORM_OFFSET = 3.6
local originalGravity = nil
local bodyVelocity = nil
local elevationBodyVelocity = nil

local wallTransparencyEnabled = false
local originalTransparencies = {}
local TRANSPARENCY_LEVEL = 0.6
local comboFloatEnabled = false
local comboCurrentPlatform = nil
local comboPlatformUpdateConnection = nil
local comboPlayerCollisionConnection = nil
local COMBO_PLATFORM_OFFSET = 3.7

local teleportEnabled = false
local lastClickTime = 0
local DOUBLE_CLICK_PREVENTION_TIME = 1.5
local highestBrainrotData = nil
local teleportOverlay = nil
local highestValueESP = nil
local highestValueData = nil

local antiRagdollEnabled = false
local antiFlingEnabled = false
local playerESPEnabled = false
local baseTimeESPEnabled = false
local ownerESPEnabled = false
local baseTimeAlertEnabled = false
local leaveOnStealEnabled = false
local leaveKeybind = Enum.KeyCode.L

local plotDisplays = {}
local playerBaseName = LocalPlayer.DisplayName .. "'s Base"
local playerBaseTimeWarning = false
local alertGui = nil
local playerGui = player:WaitForChild("PlayerGui")

local floatUI = nil
local floorStealUI = nil

local brainrotNames = {
    "Los Tralaleritos", "Guerriro Digitale", "Las Tralaleritas", "Job Job Job Sahur",
    "Las Vaquitas Saturnitas", "Graipuss Medussi", "Noo My Hotspot", "Sahur Combinasion",
    "Pot Hotspot", "Chicleteira Bicicleteira", "Los Nooo My Hotspotsitos", "La Grande Combinasion",
    "Los Combinasionas", "Nuclearo Dinossauro", "Karkerkar combinasion", "Los Hotspotsitos",
    "Tralaledon", "Esok Sekolah", "Ketupat Kepat", "Los Bros", "La Supreme Combinasion",
    "Ketchuru and Masturu", "Garama and Madundung", "Spaghetti Tualetti", "Dragon Cannelloni",
    "Blackhole Goat", "Agarrini la Palini", "Los Spyderinis", "Fragola la la la", "Strawberry Elephant"
}

-- ==================== CORE HELPER FUNCTIONS ====================

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
        if currentPlatform then currentPlatform:Destroy() end
        currentPlatform = createPlatform()
        applySlowFall()
        updatePlatformPosition()
        task.wait(0.5)
    end
end

local function getAntiRagdollComponents()
    return pcall(function()
        return LocalPlayer.Character and 
               LocalPlayer.Character:FindFirstChild("Humanoid") and 
               LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    end)
end

local function preventRagdoll()
    pcall(function()
        if not (humanoid and humanoid.Parent) then return end
        
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
                    end
                end
            end
        end
    end)
end

local function preventFling()
    pcall(function()
        if not (rootPart and rootPart.Parent) then return end
        
        local velocity = rootPart.AssemblyLinearVelocity
        local angularVelocity = rootPart.AssemblyAngularVelocity
        
        if velocity.Magnitude > EXTREME_VELOCITY_THRESHOLD then
            rootPart.AssemblyLinearVelocity = velocity.Unit * MAX_VELOCITY
        end
        
        if angularVelocity.Magnitude > MAX_ANGULAR_VELOCITY * 2 then
            rootPart.AssemblyAngularVelocity = angularVelocity.Unit * MAX_ANGULAR_VELOCITY
        end
    end)
end

function setupAntiRagdollProtection()
    if not getAntiRagdollComponents() then return false end
    
    for _, connection in pairs(antiRagdollConnections) do
        if connection and connection.Connected then
            connection:Disconnect()
        end
    end
    antiRagdollConnections = {}
    
    table.insert(antiRagdollConnections, humanoid.StateChanged:Connect(function(_, newState)
        if newState == Enum.HumanoidStateType.Physics then
            preventRagdoll()
        end
    end))
    
    table.insert(antiRagdollConnections, humanoid:GetPropertyChangedSignal("PlatformStand"):Connect(function()
        if humanoid.PlatformStand then preventRagdoll() end
    end))
    
    table.insert(antiRagdollConnections, RunService.Heartbeat:Connect(preventRagdoll))
    
    return true
end

local function cleanupAntiRagdoll()
    for _, connection in pairs(antiRagdollConnections) do
        if connection and connection.Connected then
            connection:Disconnect()
        end
    end
    antiRagdollConnections = {}
end

local function equipGrappleHook()
    pcall(function()
        local grappleHook = player.Backpack:FindFirstChild("Grapple Hook")
        if grappleHook and character:FindFirstChild("Humanoid") then
            character.Humanoid:EquipTool(grappleHook)
        end
    end)
end

local function unEquipGrappleHook()
    pcall(function()
        local grappleHook = player.Backpack:FindFirstChild("Grapple Hook")
        if grappleHook and character:FindFirstChild("Humanoid") then
            character.Humanoid:UnequipTool(grappleHook)
        end
    end)
end

local function fireGrappleHook()
    pcall(function()
        ReplicatedStorage.Packages.Net["RE/UseItem"]:FireServer(0.08707536856333414)
    end)
end

local function equipAndFireGrapple()
    fireGrappleHook()
    task.wait(getRandomWait())
    equipGrappleHook()
end

local function equipQuantumCloner()
    return pcall(function()
        local qc = player.Backpack:FindFirstChild("Quantum Cloner")
        if qc and character:FindFirstChild("Humanoid") then
            character.Humanoid:EquipTool(qc)
            return true
        end
        return false
    end)
end

local function fireQuantumCloner()
    pcall(function()
        ReplicatedStorage.Packages.Net["RE/UseItem"]:FireServer()
    end)
end

local function fireQuantumClonerTeleport()
    pcall(function()
        ReplicatedStorage.Packages.Net["RE/QuantumCloner/OnTeleport"]:FireServer()
    end)
end

local function getStealCount()
    return pcall(function()
        local stealsObj = LocalPlayer.leaderstats.Steals
        return tonumber(stealsObj.Value) or 0
    end) and stealsObj.Value or 0
end

local function kickPlayer()
    if antiKickEnabled then return end
    pcall(function() LocalPlayer:Kick("Steal Success!!!!!") end)
end

local function monitorSteals()
    if isMonitoring then return end
    isMonitoring = true
    lastStealCount = getStealCount()
    
    task.spawn(function()
        while isMonitoring and leaveOnStealEnabled do
            task.wait(0.1)
            local current = getStealCount()
            if current > lastStealCount then
                isMonitoring = false
                task.wait(0.1)
                kickPlayer()
                break
            end
            lastStealCount = current
        end
    end)
end

local function parsePrice(priceText)
    if not priceText or priceText == "" or priceText == "N/A" then return 0 end
    
    local cleanPrice = priceText:gsub("[,$]", ""):upper()
    local number = tonumber(cleanPrice:match("%d*%.?%d+"))
    if not number then return 0 end
    
    if cleanPrice:find("T") then return number * 1e12
    elseif cleanPrice:find("B") then return number * 1e9
    elseif cleanPrice:find("M") then return number * 1e6
    elseif cleanPrice:find("K") then return number * 1e3
    end
    
    return number
end

local function findHighestBrainrot()
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return nil end
    
    local highest = {value = 0}
    
    for _, plot in pairs(plots:GetChildren()) do
        local podiums = plot:FindFirstChild("AnimalPodiums")
        if podiums then
            for i = 1, 30 do
                pcall(function()
                    local podium = podiums:FindFirstChild(tostring(i))
                    local overhead = podium.Base.Spawn.Attachment.AnimalOverhead
                    local priceLabel = overhead.Generation
                    
                    if priceLabel.Text ~= "" and priceLabel.Text ~= "N/A" then
                        local value = parsePrice(priceLabel.Text)
                        if value > highest.value then
                            local tpPart = podium.Base.Decorations.Part
                            highest = {
                                plot = plot,
                                plotName = plot.Name,
                                podiumNumber = i,
                                price = priceLabel.Text,
                                priceValue = value,
                                teleportPart = tpPart,
                                position = tpPart.Position,
                                rarity = overhead.Rarity.Text,
                                mutation = overhead.Mutation.Text,
                                value = value
                            }
                        end
                    end
                end)
            end
        end
    end
    
    return highest.value > 0 and highest or nil
end

local function createPlatform()
    local platform = Instance.new("Part")
    platform.Name = "PlayerPlatform"
    platform.Size = Vector3.new(8, 0.5, 8)
    platform.Material = Enum.Material.Neon
    platform.Color = Color3.fromRGB(0, 255, 255) -- Cyan
    platform.Anchored = true
    platform.CanCollide = true
    platform.Transparency = 1
    platform.Parent = workspace
    
    local light = Instance.new("PointLight", platform)
    light.Color = Color3.fromRGB(0, 255, 255)
    light.Brightness = 1
    light.Range = 10
    
    return platform
end

local function updatePlatformPosition()
    pcall(function()
        if platformEnabled and currentPlatform and character:FindFirstChild("HumanoidRootPart") then
            local pos = character.HumanoidRootPart.Position
            currentPlatform.Position = Vector3.new(pos.X, pos.Y - PLATFORM_OFFSET, pos.Z)
        end
    end)
end

local function applySlowFall()
    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe or input.KeyCode ~= Enum.KeyCode.Space or not platformEnabled then return end
        equipAndFireGrapple()
        task.wait(0.1)
        if platformEnabled then
            humanoid.Jump = true
            equipAndFireGrapple()
            unEquipGrappleHook()
        end
    end)
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
    end
end

local function enableWallTransparency()
    if wallTransparencyEnabled then return end
    wallTransparencyEnabled = true
    
    originalTransparencies = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name == "structure base home" then
            originalTransparencies[obj] = {transparency = obj.Transparency, canCollide = obj.CanCollide}
            obj.Transparency = TRANSPARENCY_LEVEL
            obj.CanCollide = false
        end
    end
    
    comboCurrentPlatform = createPlatform()
    comboPlatformUpdateConnection = RunService.Heartbeat:Connect(function()
        pcall(function()
            if comboFloatEnabled and comboCurrentPlatform and character:FindFirstChild("HumanoidRootPart") then
                local pos = character.HumanoidRootPart.Position
                comboCurrentPlatform.Position = Vector3.new(pos.X, pos.Y - COMBO_PLATFORM_OFFSET, pos.Z)
            end
        end)
    end)
    
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
    
    for obj, data in pairs(originalTransparencies) do
        if obj and obj.Parent then
            obj.Transparency = data.transparency
            obj.CanCollide = data.canCollide
        end
    end
    originalTransparencies = {}
    
    if comboPlatformUpdateConnection then
        comboPlatformUpdateConnection:Disconnect()
        comboPlatformUpdateConnection = nil
    end
    
    if comboCurrentPlatform then
        comboCurrentPlatform:Destroy()
        comboCurrentPlatform = nil
    end
    
    if grappleHookConnection then
        task.cancel(grappleHookConnection)
        grappleHookConnection = nil
    end
end

local function createTeleportOverlay()
    if teleportOverlay then teleportOverlay:Destroy() end
    
    local sg = Instance.new("ScreenGui")
    sg.Name = "TeleportOverlay"
    sg.Parent = playerGui
    sg.ResetOnSpawn = false
    
    local frame = Instance.new("Frame", sg)
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.new(0, 0, 0)
    frame.BackgroundTransparency = 0.5
    frame.BorderSizePixel = 0
    
    local loadingFrame = Instance.new("Frame", frame)
    loadingFrame.Size = UDim2.new(0, 400, 0, 200)
    loadingFrame.Position = UDim2.new(0.5, -200, 0.5, -100)
    loadingFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    loadingFrame.BorderSizePixel = 0
    Instance.new("UICorner", loadingFrame).CornerRadius = UDim.new(0, 12)
    
    local title = Instance.new("TextLabel", loadingFrame)
    title.Size = UDim2.new(1, -20, 0, 50)
    title.Position = UDim2.new(0, 10, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = "TELEPORTING TO HIGHEST BRAINROT!"
    title.TextColor3 = Color3.fromRGB(0, 255, 255)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    
    local status = Instance.new("TextLabel", loadingFrame)
    status.Size = UDim2.new(1, -20, 0, 30)
    status.Position = UDim2.new(0, 10, 0, 70)
    status.BackgroundTransparency = 1
    status.Text = "Scanning..."
    status.TextColor3 = Color3.new(1, 1, 1)
    status.TextScaled = true
    status.Font = Enum.Font.Gotham
    
    local barBG = Instance.new("Frame", loadingFrame)
    barBG.Size = UDim2.new(0.8, 0, 0, 8)
    barBG.Position = UDim2.new(0.1, 0, 0, 120)
    barBG.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    barBG.BorderSizePixel = 0
    Instance.new("UICorner", barBG).CornerRadius = UDim.new(0, 4)
    
    local progress = Instance.new("Frame", barBG)
    progress.Size = UDim2.new(0, 0, 1, 0)
    progress.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
    progress.BorderSizePixel = 0
    Instance.new("UICorner", progress).CornerRadius = UDim.new(0, 4)
    
    local info = Instance.new("TextLabel", loadingFrame)
    info.Size = UDim2.new(1, -20, 0, 40)
    info.Position = UDim2.new(0, 10, 0, 140)
    info.BackgroundTransparency = 1
    info.Text = ""
    info.TextColor3 = Color3.fromRGB(0, 255, 0)
    info.TextScaled = true
    info.Font = Enum.Font.GothamBold
    
    teleportOverlay = sg
    return {overlay = sg, statusLabel = status, progressBar = progress, brainrotInfo = info}
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
                task.wait(0.1)
                    
                if not teleportEnabled then
                    removeTeleportOverlay()
                    return
                end
        
                local startTime = tick()
                while tick() - startTime < 0.9 do
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

-- ==================== ESP & VISUAL FUNCTIONS ====================

local function createPlayerESP(playerObj, head)
    if not playerESPEnabled or not head then return end
    
    pcall(function()
        local existingESP = head:FindFirstChild("PlayerESP")
        if existingESP then existingESP:Destroy() end
        
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "PlayerESP"
        billboard.Parent = head
        billboard.Size = UDim2.new(0, 90, 0, 33)
        billboard.StudsOffset = Vector3.new(0, 2, 0)
        billboard.AlwaysOnTop = true
        
        local label = Instance.new("TextLabel", billboard)
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = playerObj.DisplayName
        label.TextColor3 = Color3.fromRGB(0, 255, 255)
        label.TextScaled = true
        label.TextStrokeTransparency = 0.3
        label.Font = Enum.Font.SourceSansBold
    end)
end

local function createPlayerDisplay(playerObj)
    if playerObj == LocalPlayer or not playerESPEnabled then return end
    
    pcall(function()
        local function setupESP(char)
            task.wait(0.5)
            local head = char:FindFirstChild("Head")
            if head then createPlayerESP(playerObj, head) end
        end
        
        if playerObj.Character then
            setupESP(playerObj.Character)
        end
        
        playerObj.CharacterAdded:Connect(setupESP)
    end)
end

local function createPermanentPlayerESP(playerObj)
    if not ownerESPEnabled or playerObj == LocalPlayer then return end
    
    pcall(function()
        local char = playerObj.Character
        if not char then return end
        
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        
        local existingHighlight = hrp:FindFirstChild("PermanentHighlight")
        if existingHighlight then existingHighlight:Destroy() end
        
        local highlight = Instance.new("Highlight")
        highlight.Name = "PermanentHighlight"
        highlight.Parent = hrp
        highlight.FillColor = Color3.fromRGB(0, 255, 255)
        highlight.OutlineColor = Color3.fromRGB(0, 200, 200)
        highlight.FillTransparency = 0.6
        highlight.OutlineTransparency = 0
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    end)
end

local function initializePermanentESP()
    if not ownerESPEnabled then return end
    
    for _, playerObj in pairs(Players:GetPlayers()) do
        if playerObj ~= LocalPlayer then
            createPermanentPlayerESP(playerObj)
        end
    end
end

local function createHighestValueESP(brainrotData)
    if not brainrotData or not brainrotData.teleportPart then return end
    
    pcall(function()
        -- Remove old ESP
        if highestValueESP then
            if highestValueESP.highlight then highestValueESP.highlight:Destroy() end
            if highestValueESP.nameLabel then highestValueESP.nameLabel:Destroy() end
            if highestValueESP.tracer then
                if highestValueESP.tracer.beam then highestValueESP.tracer.beam:Destroy() end
                if highestValueESP.tracer.attachment0 then highestValueESP.tracer.attachment0:Destroy() end
                if highestValueESP.tracer.attachment1 then highestValueESP.tracer.attachment1:Destroy() end
            end
        end
        
        local espContainer = {}
        local part = brainrotData.teleportPart
        
        -- Highlight
        local highlight = Instance.new("Highlight", part)
        highlight.FillColor = Color3.fromRGB(0, 255, 255)
        highlight.OutlineColor = Color3.fromRGB(0, 255, 255)
        highlight.FillTransparency = 0.7
        highlight.OutlineTransparency = 0
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        espContainer.highlight = highlight
        
        -- Billboard
        local billboard = Instance.new("BillboardGui", part)
        billboard.Size = UDim2.new(0, 180, 0, 80)
        billboard.StudsOffset = Vector3.new(0, 8, 0)
        billboard.AlwaysOnTop = true
        
        local container = Instance.new("Frame", billboard)
        container.Size = UDim2.new(1, 0, 1, 0)
        container.BackgroundTransparency = 1
        
        local titleLabel = Instance.new("TextLabel", container)
        titleLabel.Size = UDim2.new(1, 0, 0.5, 0)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = "HIGHEST VALUE"
        titleLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
        titleLabel.TextStrokeTransparency = 0
        titleLabel.TextScaled = true
        titleLabel.Font = Enum.Font.GothamBold
        
        local priceLabel = Instance.new("TextLabel", container)
        priceLabel.Size = UDim2.new(1, 0, 0.3, 0)
        priceLabel.Position = UDim2.new(0, 0, 0.5, 0)
        priceLabel.BackgroundTransparency = 1
        priceLabel.Text = brainrotData.price or ""
        priceLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        priceLabel.TextStrokeTransparency = 0
        priceLabel.TextScaled = true
        priceLabel.Font = Enum.Font.GothamBold
        
        espContainer.nameLabel = billboard
        
        -- Tracer
        local camera = workspace.CurrentCamera
        if camera then
            local att0 = Instance.new("Attachment", camera)
            local att1 = Instance.new("Attachment", part)
            
            local beam = Instance.new("Beam", workspace.Terrain)
            beam.Attachment0 = att0
            beam.Attachment1 = att1
            beam.Width0 = 0.3
            beam.Width1 = 0.3
            beam.Color = ColorSequence.new(Color3.fromRGB(0, 255, 255))
            beam.Transparency = NumberSequence.new(0.2)
            beam.FaceCamera = true
            beam.LightEmission = 1
            
            espContainer.tracer = {beam = beam, attachment0 = att0, attachment1 = att1}
        end
        
        highestValueESP = espContainer
        highestValueData = brainrotData
    end)
end

local function updateHighestValueESP()
    local newHighest = findHighestBrainrot()
    if newHighest and (not highestValueData or newHighest.priceValue > highestValueData.priceValue) then
        createHighestValueESP(newHighest)
    end
end

local function removeHighestValueESP()
    if highestValueESP then
        pcall(function()
            if highestValueESP.highlight then highestValueESP.highlight:Destroy() end
            if highestValueESP.nameLabel then highestValueESP.nameLabel:Destroy() end
            if highestValueESP.tracer then
                if highestValueESP.tracer.beam then highestValueESP.tracer.beam:Destroy() end
                if highestValueESP.tracer.attachment0 then highestValueESP.tracer.attachment0:Destroy() end
                if highestValueESP.tracer.attachment1 then highestValueESP.tracer.attachment1:Destroy() end
            end
        end)
        highestValueESP = nil
        highestValueData = nil
    end
end

-- ==================== ALERT & PLOT FUNCTIONS ====================

local function createAlertGui()
    if alertGui or not baseTimeAlertEnabled then return end
    
    pcall(function()
        local sg = Instance.new("ScreenGui")
        sg.Parent = playerGui
        sg.Name = "AlertGui"
        sg.ResetOnSpawn = false
        
        local frame = Instance.new("Frame", sg)
        frame.Size = UDim2.new(0, 300, 0, 80)
        frame.Position = UDim2.new(0.5, -150, 0.1, 0)
        frame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        frame.BorderSizePixel = 0
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
        
        local label = Instance.new("TextLabel", frame)
        label.Size = UDim2.new(1, -10, 1, -10)
        label.Position = UDim2.new(0, 5, 0, 5)
        label.BackgroundTransparency = 1
        label.Text = "BASE TIME WARNING"
        label.TextColor3 = Color3.new(1, 1, 1)
        label.TextScaled = true
        label.TextStrokeTransparency = 0
        label.Font = Enum.Font.GothamBold
        
        local tween = TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), 
            {BackgroundColor3 = Color3.fromRGB(150, 0, 0)})
        tween:Play()
        
        alertGui = {screenGui = sg, textLabel = label, tween = tween}
    end)
end

local function updateAlertGui(timeText)
    if alertGui and baseTimeAlertEnabled then
        pcall(function()
            alertGui.textLabel.Text = "BASE UNLOCKING IN " .. timeText
        end)
    end
end

local function removeAlertGui()
    if alertGui then
        pcall(function()
            if alertGui.tween then alertGui.tween:Cancel() end
            alertGui.screenGui:Destroy()
        end)
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
    if secondsOnly then return tonumber(secondsOnly) end
    
    return nil
end

local function createOrUpdatePlotDisplay(plot)
    if not baseTimeESPEnabled or not plot or not plot.Parent then return end
    
    pcall(function()
        local plotName = plot.Name
        local plotSignText = ""
        
        local signPath = plot:FindFirstChild("PlotSign")
        if signPath and signPath:FindFirstChild("SurfaceGui") then
            local surfaceGui = signPath.SurfaceGui
            if surfaceGui:FindFirstChild("Frame") and surfaceGui.Frame:FindFirstChild("TextLabel") then
                plotSignText = surfaceGui.Frame.TextLabel.Text
            end
        end
        
        if plotSignText == "Empty Base" or plotSignText == "" then
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
        
        -- Check for player's own base time warning
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
                if playerBaseTimeWarning then removeAlertGui() end
            end
        end
        
        local displayPart = plot:FindFirstChild("PlotSign")
        if not displayPart then return end
        
        if not plotDisplays[plotName] then
            local billboard = Instance.new("BillboardGui", displayPart)
            billboard.Name = "PlotESP"
            billboard.Size = UDim2.new(0, 150, 0, 60)
            billboard.StudsOffset = Vector3.new(0, 8, 0)
            billboard.AlwaysOnTop = true
            
            local frame = Instance.new("Frame", billboard)
            frame.Size = UDim2.new(1, 0, 1, 0)
            frame.BackgroundTransparency = 0.7
            frame.BackgroundColor3 = Color3.new(0, 0, 0)
            frame.BorderSizePixel = 0
            Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 4)
            
            local signLabel = Instance.new("TextLabel", frame)
            signLabel.Size = UDim2.new(1, -4, 0.6, 0)
            signLabel.Position = UDim2.new(0, 2, 0, 2)
            signLabel.BackgroundTransparency = 1
            signLabel.Text = plotSignText
            signLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
            signLabel.TextScaled = true
            signLabel.TextStrokeTransparency = 0.3
            signLabel.Font = Enum.Font.GothamBold
            
            local timeLabel = Instance.new("TextLabel", frame)
            timeLabel.Size = UDim2.new(1, -4, 0.4, 0)
            timeLabel.Position = UDim2.new(0, 2, 0.6, 0)
            timeLabel.BackgroundTransparency = 1
            timeLabel.Text = plotTimeText
            timeLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
            timeLabel.TextScaled = true
            timeLabel.TextStrokeTransparency = 0.3
            timeLabel.Font = Enum.Font.Gotham
            
            plotDisplays[plotName] = {gui = billboard, signLabel = signLabel, timeLabel = timeLabel, plot = plot}
        else
            if plotDisplays[plotName].signLabel then
                plotDisplays[plotName].signLabel.Text = plotSignText
            end
            if plotDisplays[plotName].timeLabel then
                plotDisplays[plotName].timeLabel.Text = plotTimeText
            end
        end
    end)
end

local function updateAllPlots()
    if not baseTimeESPEnabled then return end
    
    pcall(function()
        local plots = workspace:FindFirstChild("Plots")
        if not plots then return end
        
        for _, plot in pairs(plots:GetChildren()) do
            if plot:IsA("Model") or plot:IsA("Folder") then
                createOrUpdatePlotDisplay(plot)
            end
        end
        
        -- Cleanup removed plots
        for plotName, display in pairs(plotDisplays) do
            if not plots:FindFirstChild(plotName) then
                if display.gui then display.gui:Destroy() end
                plotDisplays[plotName] = nil
            end
        end
    end)
end

-- ==================== NO JUMP DELAY ====================

local jumpDelayConnections = {}

local function setupNoJumpDelay(char)
    if jumpDelayConnections[char] then
        for _, conn in pairs(jumpDelayConnections[char]) do
            if conn and conn.Connected then conn:Disconnect() end
        end
    end
    
    jumpDelayConnections[char] = {}
    local hum = char:WaitForChild("Humanoid")
    
    table.insert(jumpDelayConnections[char], hum.StateChanged:Connect(function(_, newState)
        if newState == Enum.HumanoidStateType.Landed then
            task.spawn(function()
                task.wait()
                if hum and hum.Parent then
                    hum:ChangeState(Enum.HumanoidStateType.Running)
                end
            end)
        end
    end))
end

local function removeJumpDelay()
    if player.Character then
        setupNoJumpDelay(player.Character)
    end
    
    player.CharacterAdded:Connect(function(char)
        task.wait(0.5)
        setupNoJumpDelay(char)
    end)
end

-- ==================== FLOAT & FLOOR STEAL UI ====================

local function createFloatUI()
    if floatUI then floatUI:Destroy() end
    
    local sg = Instance.new("ScreenGui")
    sg.Name = "FloatUI"
    sg.Parent = playerGui
    sg.ResetOnSpawn = false
    
    local frame = Instance.new("Frame", sg)
    frame.Size = UDim2.new(0, 280, 0, 120)
    frame.Position = UDim2.new(0.5, -140, 0.3, -60)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)
    
    local titleBar = Instance.new("Frame", frame)
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    titleBar.BorderSizePixel = 0
    Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 12)
    
    local title = Instance.new("TextLabel", titleBar)
    title.Size = UDim2.new(1, -80, 1, 0)
    title.Position = UDim2.new(0, 15, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "Float Settings"
    title.TextColor3 = Color3.fromRGB(0, 255, 255)
    title.TextSize = 16
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    
    local closeBtn = Instance.new("TextButton", titleBar)
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -35, 0, 5)
    closeBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.new(1, 1, 1)
    closeBtn.TextSize = 18
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.BorderSizePixel = 0
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)
    
    closeBtn.MouseButton1Click:Connect(function()
        sg:Destroy()
        floatUI = nil
    end)
    
    local toggleFrame = Instance.new("Frame", frame)
    toggleFrame.Size = UDim2.new(1, -20, 0, 50)
    toggleFrame.Position = UDim2.new(0, 10, 0, 55)
    toggleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    toggleFrame.BorderSizePixel = 0
    Instance.new("UICorner", toggleFrame).CornerRadius = UDim.new(0, 10)
    
    local label = Instance.new("TextLabel", toggleFrame)
    label.Size = UDim2.new(1, -70, 1, 0)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = "Enable Float"
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextSize = 14
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local toggleBtn = Instance.new("TextButton", toggleFrame)
    toggleBtn.Size = UDim2.new(0, 50, 0, 30)
    toggleBtn.Position = UDim2.new(1, -60, 0.5, -15)
    toggleBtn.BackgroundColor3 = platformEnabled and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(60, 60, 65)
    toggleBtn.Text = ""
    toggleBtn.BorderSizePixel = 0
    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1, 0)
    
    local circle = Instance.new("Frame", toggleBtn)
    circle.Size = UDim2.new(0, 22, 0, 22)
    circle.Position = platformEnabled and UDim2.new(1, -26, 0.5, -11) or UDim2.new(0, 4, 0.5, -11)
    circle.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    circle.BorderSizePixel = 0
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)
    
    toggleBtn.MouseButton1Click:Connect(function()
        platformEnabled = not platformEnabled
        
        if platformEnabled then
            TweenService:Create(toggleBtn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(0, 255, 255)}):Play()
            TweenService:Create(circle, TweenInfo.new(0.3), {Position = UDim2.new(1, -26, 0.5, -11)}):Play()
            enablePlatform()
            WindUI:Notify({Title = "Float ON", Content = "Platform activated!", Icon = "check", Duration = 2})
        else
            TweenService:Create(toggleBtn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(60, 60, 65)}):Play()
            TweenService:Create(circle, TweenInfo.new(0.3), {Position = UDim2.new(0, 4, 0.5, -11)}):Play()
            disablePlatform()
            WindUI:Notify({Title = "Float OFF", Content = "Platform deactivated!", Icon = "x", Duration = 2})
        end
    end)
    
    -- Dragging
    local dragging, dragStart, startPos = false, nil, nil
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    
    titleBar.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    floatUI = sg
end

local function createFloorStealUI()
    if floorStealUI then floorStealUI:Destroy() end
    
    local sg = Instance.new("ScreenGui")
    sg.Name = "FloorStealUI"
    sg.Parent = playerGui
    sg.ResetOnSpawn = false
    
    local frame = Instance.new("Frame", sg)
    frame.Size = UDim2.new(0, 280, 0, 120)
    frame.Position = UDim2.new(0.5, -140, 0.4, -60)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)
    
    local titleBar = Instance.new("Frame", frame)
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    titleBar.BorderSizePixel = 0
    Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 12)
    
    local title = Instance.new("TextLabel", titleBar)
    title.Size = UDim2.new(1, -80, 1, 0)
    title.Position = UDim2.new(0, 15, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "Floor Steal Settings"
    title.TextColor3 = Color3.fromRGB(255, 120, 0)
    title.TextSize = 16
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    
    local closeBtn = Instance.new("TextButton", titleBar)
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -35, 0, 5)
    closeBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.new(1, 1, 1)
    closeBtn.TextSize = 18
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.BorderSizePixel = 0
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)
    
    closeBtn.MouseButton1Click:Connect(function()
        sg:Destroy()
        floorStealUI = nil
    end)
    
    local toggleFrame = Instance.new("Frame", frame)
    toggleFrame.Size = UDim2.new(1, -20, 0, 50)
    toggleFrame.Position = UDim2.new(0, 10, 0, 55)
    toggleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    toggleFrame.BorderSizePixel = 0
    Instance.new("UICorner", toggleFrame).CornerRadius = UDim.new(0, 10)
    
    local label = Instance.new("TextLabel", toggleFrame)
    label.Size = UDim2.new(1, -70, 1, 0)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = "Enable Floor Steal"
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextSize = 14
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local toggleBtn = Instance.new("TextButton", toggleFrame)
    toggleBtn.Size = UDim2.new(0, 50, 0, 30)
    toggleBtn.Position = UDim2.new(1, -60, 0.5, -15)
    toggleBtn.BackgroundColor3 = wallTransparencyEnabled and Color3.fromRGB(255, 120, 0) or Color3.fromRGB(60, 60, 65)
    toggleBtn.Text = ""
    toggleBtn.BorderSizePixel = 0
    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1, 0)
    
    local circle = Instance.new("Frame", toggleBtn)
    circle.Size = UDim2.new(0, 22, 0, 22)
    circle.Position = wallTransparencyEnabled and UDim2.new(1, -26, 0.5, -11) or UDim2.new(0, 4, 0.5, -11)
    circle.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    circle.BorderSizePixel = 0
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)
    
    toggleBtn.MouseButton1Click:Connect(function()
        wallTransparencyEnabled = not wallTransparencyEnabled
        
        if wallTransparencyEnabled then
            TweenService:Create(toggleBtn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(255, 120, 0)}):Play()
            TweenService:Create(circle, TweenInfo.new(0.3), {Position = UDim2.new(1, -26, 0.5, -11)}):Play()
            enableWallTransparency()
            WindUI:Notify({Title = "Floor Steal ON", Content = "Walls are now transparent!", Icon = "check", Duration = 2})
        else
            TweenService:Create(toggleBtn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(60, 60, 65)}):Play()
            TweenService:Create(circle, TweenInfo.new(0.3), {Position = UDim2.new(0, 4, 0.5, -11)}):Play()
            disableWallTransparency()
            WindUI:Notify({Title = "Floor Steal OFF", Content = "Walls restored!", Icon = "x", Duration = 2})
        end
    end)
    
    -- Dragging
    local dragging, dragStart, startPos = false, nil, nil
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    
    titleBar.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    floorStealUI = sg
end

-- ==================== WINDUI SETUP ====================
setupAntiKick()
loadConfiguration()

local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

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
local MainTab = Window:Tab({Title = "Main", Icon = "flame", Desc = "Main features"})
local PlayerTab = Window:Tab({Title = "Player", Icon = "user", Desc = "Player modifications"})
local VisualsTab = Window:Tab({Title = "Visuals", Icon = "eye", Desc = "ESP features"})
local UtilitiesTab = Window:Tab({Title = "Utilities", Icon = "wrench", Desc = "Utility features"})
local SettingsTab = Window:Tab({Title = "Settings", Icon = "settings", Desc = "Configuration"})
local ServerTab = Window:Tab({Title = "Server", Icon = "server", Desc = "Server info"})
local CreditsTab = Window:Tab({Title = "Credits", Icon = "heart", Desc = "Credits"})

-- MAIN TAB
MainTab:Button({
    Title = "Float",
    Desc = "Floating platform controls",
    Icon = "layers",
    Callback = function() createFloatUI() end
})

MainTab:Button({
    Title = "Floor Steal",
    Desc = "Floor stealing controls",
    Icon = "box",
    Callback = function() createFloorStealUI() end
})

MainTab:Button({
    Title = "Teleport to Highest",
    Desc = "Smart teleport (undetectable)",
    Icon = "zap",
    Callback = function() executeTeleportToHighestBrainrot() end
})

-- PLAYER TAB
PlayerTab:Toggle({
    Title = "Anti Ragdoll",
    Desc = "Prevents ragdolling",
    Value = ConfigData.antiRagdollEnabled,
    Callback = function(v)
        antiRagdollEnabled = v
        ConfigData.antiRagdollEnabled = v
        if v then 
            setupAntiRagdollProtection()
            WindUI:Notify({Title = "Anti Ragdoll ON", Content = "Protected from ragdoll!", Icon = "shield", Duration = 2})
        else 
            cleanupAntiRagdoll()
            WindUI:Notify({Title = "Anti Ragdoll OFF", Content = "Protection disabled!", Icon = "shield-off", Duration = 2})
        end
    end
})

PlayerTab:Toggle({
    Title = "Anti Fling",
    Desc = "Prevents velocity flinging",
    Value = ConfigData.antiFlingEnabled,
    Callback = function(v)
        antiFlingEnabled = v
        ConfigData.antiFlingEnabled = v
        if v then
            RunService.Heartbeat:Connect(function()
                if antiFlingEnabled then preventFling() end
            end)
            WindUI:Notify({Title = "Anti Fling ON", Content = "Protected from fling!", Icon = "shield", Duration = 2})
        else
            WindUI:Notify({Title = "Anti Fling OFF", Content = "Protection disabled!", Icon = "shield-off", Duration = 2})
        end
    end
})

-- VISUALS TAB
VisualsTab:Toggle({
    Title = "Player ESP",
    Desc = "Show player names above heads",
    Value = ConfigData.playerESPEnabled,
    Callback = function(v)
        playerESPEnabled = v
        ConfigData.playerESPEnabled = v
        
        if playerESPEnabled then
            for _, playerObj in pairs(Players:GetPlayers()) do
                if playerObj ~= LocalPlayer then
                    createPlayerDisplay(playerObj)
                end
            end
            WindUI:Notify({Title = "Player ESP ON", Content = "Players are now visible!", Icon = "users", Duration = 2})
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
            WindUI:Notify({Title = "Player ESP OFF", Content = "ESP disabled!", Icon = "users", Duration = 2})
        end
    end
})

VisualsTab:Toggle({
    Title = "Base Time ESP",
    Desc = "Show base time remaining on plots",
    Value = ConfigData.baseTimeESPEnabled,
    Callback = function(v)
        baseTimeESPEnabled = v
        ConfigData.baseTimeESPEnabled = v
        
        if baseTimeESPEnabled then
            updateAllPlots()
            WindUI:Notify({Title = "Base Time ESP ON", Content = "Base times visible!", Icon = "clock", Duration = 2})
        else
            for _, display in pairs(plotDisplays) do
                if display.gui then display.gui:Destroy() end
            end
            plotDisplays = {}
            WindUI:Notify({Title = "Base Time ESP OFF", Content = "ESP disabled!", Icon = "clock", Duration = 2})
        end
    end
})

VisualsTab:Toggle({
    Title = "Owner ESP",
    Desc = "Highlight all player bodies",
    Value = ConfigData.ownerESPEnabled,
    Callback = function(v)
        ownerESPEnabled = v
        ConfigData.ownerESPEnabled = v
        
        if ownerESPEnabled then
            initializePermanentESP()
            WindUI:Notify({Title = "Owner ESP ON", Content = "Players highlighted!", Icon = "user-check", Duration = 2})
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
            WindUI:Notify({Title = "Owner ESP OFF", Content = "Highlights removed!", Icon = "user-x", Duration = 2})
        end
    end
})

VisualsTab:Toggle({
    Title = "Base Time Alert",
    Desc = "Alert when YOUR base time is low (≤10s)",
    Value = ConfigData.baseTimeAlertEnabled,
    Callback = function(v)
        baseTimeAlertEnabled = v
        ConfigData.baseTimeAlertEnabled = v
        
        if not baseTimeAlertEnabled then
            removeAlertGui()
            WindUI:Notify({Title = "Time Alert OFF", Content = "Alerts disabled!", Icon = "bell-off", Duration = 2})
        else
            WindUI:Notify({Title = "Time Alert ON", Content = "You'll be alerted when base time is low!", Icon = "bell", Duration = 2})
        end
    end
})

VisualsTab:Toggle({
    Title = "Highest Value ESP",
    Desc = "Show highest value brainrot with tracer",
    Value = false,
    Callback = function(v)
        if v then
            updateHighestValueESP()
            task.spawn(function()
                while v do
                    task.wait(20)
                    updateHighestValueESP()
                end
            end)
            WindUI:Notify({Title = "Value ESP ON", Content = "Tracking highest brainrot!", Icon = "target", Duration = 2})
        else
            removeHighestValueESP()
            WindUI:Notify({Title = "Value ESP OFF", Content = "Tracking stopped!", Icon = "x", Duration = 2})
        end
    end
})

-- UTILITIES TAB
UtilitiesTab:Toggle({
    Title = "Anti Kick",
    Desc = "Hooks ALL kick methods",
    Value = ConfigData.antiKickEnabled,
    Callback = function(v)
        antiKickEnabled = v
        ConfigData.antiKickEnabled = v
        WindUI:Notify({
            Title = antiKickEnabled and "Anti Kick ON" or "Anti Kick OFF",
            Content = antiKickEnabled and "Protected from kicks!" or "Protection disabled",
            Icon = "shield",
            Duration = 2
        })
    end
})

UtilitiesTab:Toggle({
    Title = "Leave On Steal",
    Desc = "Auto leave after stealing",
    Value = ConfigData.leaveOnStealEnabled,
    Callback = function(v)
        leaveOnStealEnabled = v
        ConfigData.leaveOnStealEnabled = v
        if v then monitorSteals() end
    end
})

UtilitiesTab:Keybind({
    Title = "Leave Keybind",
    Value = Enum.KeyCode[ConfigData.leaveKeybind] or Enum.KeyCode.L,
    Callback = function(key)
        leaveKeybind = key
        ConfigData.leaveKeybind = key.Name
    end
})

UtilitiesTab:Button({
    Title = "Leave Game Now",
    Icon = "log-out",
    Callback = function() kickPlayer() end
})

-- SETTINGS TAB
SettingsTab:Section({Title = "Configuration", Icon = "save"})

SettingsTab:Button({
    Title = "Save Config",
    Desc = "Save current settings",
    Icon = "download",
    Callback = function()
        if saveConfiguration() then
            WindUI:Notify({Title = "Saved!", Content = "Config saved successfully", Icon = "check", Duration = 2})
        end
    end
})

SettingsTab:Button({
    Title = "Load Config",
    Desc = "Load saved settings",
    Icon = "upload",
    Callback = function()
        if loadConfiguration() then
            WindUI:Notify({Title = "Loaded!", Content = "Config loaded successfully", Icon = "check", Duration = 2})
        end
    end
})

SettingsTab:Button({
    Title = "Reset Config",
    Desc = "Reset to defaults",
    Icon = "rotate-ccw",
    Callback = function()
        ConfigData = {
            antiRagdollEnabled = false,
            antiFlingEnabled = false,
            antiKickEnabled = false,
            playerESPEnabled = false,
            baseTimeESPEnabled = false,
            ownerESPEnabled = false,
            baseTimeAlertEnabled = false,
            leaveOnStealEnabled = false,
            platformEnabled = false,
            wallTransparencyEnabled = false,
            leaveKeybind = "L",
            uiColor = {R = 0, G = 255, B = 255},
            uiTransparency = 0,
        }
        saveConfiguration()
        WindUI:Notify({Title = "Reset!", Content = "Config reset to defaults", Icon = "refresh-cw", Duration = 2})
    end
})

SettingsTab:Section({Title = "UI Customization", Icon = "palette"})

SettingsTab:ColorPicker({
    Title = "UI Color",
    Desc = "Change accent color",
    Value = Color3.new(0, 1, 1),
    Callback = function(color)
        ConfigData.uiColor = {R = color.R * 255, G = color.G * 255, B = color.B * 255}
    end
})

-- SERVER TAB
local playerCountLabel
local highestBrainrotLabel

ServerTab:Paragraph({
    Title = "Place ID",
    Desc = tostring(game.PlaceId),
    Image = "hash",
    ImageSize = 20,
    Color = Color3.fromRGB(0, 255, 255)
})

ServerTab:Paragraph({
    Title = "Job ID",
    Desc = tostring(game.JobId),
    Image = "server",
    ImageSize = 20,
    Color = Color3.fromRGB(0, 255, 255)
})

playerCountLabel = ServerTab:Paragraph({
    Title = "Players in Server",
    Desc = #Players:GetPlayers() .. " / " .. Players.MaxPlayers,
    Image = "users",
    ImageSize = 20,
    Color = Color3.fromRGB(0, 255, 255)
})

highestBrainrotLabel = ServerTab:Paragraph({
    Title = "Highest Value Brainrot",
    Desc = "Scanning...",
    Image = "trophy",
    ImageSize = 20,
    Color = Color3.fromRGB(255, 215, 0)
})

ServerTab:Button({
    Title = "Copy Job ID",
    Desc = "Copy server Job ID to clipboard",
    Icon = "copy",
    Callback = function()
        setclipboard(tostring(game.JobId))
        WindUI:Notify({Title = "Copied!", Content = "Job ID copied to clipboard", Icon = "check", Duration = 2})
    end
})

ServerTab:Button({
    Title = "Rejoin This Server",
    Desc = "Rejoin the current server",
    Icon = "refresh-cw",
    Callback = function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
    end
})

ServerTab:Button({
    Title = "Server Hop",
    Desc = "Find and join a different server",
    Icon = "shuffle",
    Callback = function()
        WindUI:Notify({Title = "Server Hopping", Content = "Finding new server...", Icon = "loader", Duration = 2})
        
        local success, result = pcall(function()
            local servers = game:GetService("HttpService"):JSONDecode(
                game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")
            )
            
            if servers and servers.data then
                for _, server in pairs(servers.data) do
                    if server.id ~= game.JobId and server.playing < server.maxPlayers then
                        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, server.id, player)
                        return
                    end
                end
            end
        end)
        
        if not success then
            WindUI:Notify({Title = "Error", Content = "Failed to find another server", Icon = "x", Duration = 2})
        end
    end
})

-- Server info update loop
task.spawn(function()
    while true do
        task.wait(5)
        
        pcall(function()
            playerCountLabel.Desc = #Players:GetPlayers() .. " / " .. Players.MaxPlayers
        end)
        
        local highest = findHighestBrainrot()
        if highest then
            pcall(function()
                highestBrainrotLabel.Desc = highest.price .. " | " .. highest.plotName .. " #" .. highest.podiumNumber .. " | " .. highest.rarity
            end)
        else
            pcall(function()
                highestBrainrotLabel.Desc = "No brainrots found in server"
            end)
        end
    end
end)

-- CREDITS TAB
CreditsTab:Paragraph({
    Title = "Steal A Brainrot",
    Desc = "Enhanced Undetectable v2.0",
    Image = "code",
    ImageSize = 24,
    Color = Color3.fromRGB(0, 255, 255)
})

CreditsTab:Paragraph({
    Title = "Developer",
    Desc = "by PickleTalk | Scripts Hub X",
    Image = "user",
    ImageSize = 20,
    Color = Color3.fromRGB(0, 255, 255)
})

CreditsTab:Paragraph({
    Title = "Discord",
    Desc = "https://discord.gg/bpsNUH5sVb",
    Image = "message-circle",
    ImageSize = 20,
    Color = Color3.fromRGB(88, 101, 242),
    Buttons = {
        {
            Title = "Copy Link",
            Icon = "copy",
            Variant = "Primary",
            Callback = function()
                setclipboard("https://discord.gg/bpsNUH5sVb")
                WindUI:Notify({Title = "Copied!", Content = "Discord link copied", Icon = "check", Duration = 2})
            end
        }
    }
})

-- Initialize
player.CharacterAdded:Connect(onCharacterAdded)

-- Player ESP Handlers
Players.PlayerAdded:Connect(function(newPlayer)
    newPlayer.CharacterAdded:Connect(function(char)
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
        playerObj.CharacterAdded:Connect(function(char)
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
    pcall(function()
        if leavingPlayer.Character then
            local head = leavingPlayer.Character:FindFirstChild("Head")
            if head then
                local esp = head:FindFirstChild("PlayerESP")
                if esp then esp:Destroy() end
            end
            
            local hrp = leavingPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local highlight = hrp:FindFirstChild("PermanentHighlight")
                if highlight then highlight:Destroy() end
            end
        end
    end)
end)

-- Plot monitoring
local plots = workspace:FindFirstChild("Plots")
if plots then
    plots.ChildAdded:Connect(function(child)
        if (child:IsA("Model") or child:IsA("Folder")) and baseTimeESPEnabled then
            task.wait(0.5)
            createOrUpdatePlotDisplay(child)
        end
    end)
end

-- Periodic plot updates
task.spawn(function()
    while true do
        task.wait(0.5)
        if baseTimeESPEnabled then
            pcall(updateAllPlots)
        end
    end
end)

-- Anti-ragdoll initialization
if LocalPlayer.Character and ConfigData.antiRagdollEnabled then
    task.wait(0.5)
    antiRagdollEnabled = true
    setupAntiRagdollProtection()
end

-- Sentry bullet monitoring
pcall(function()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj.Name == "SentryBullet" and obj:IsA("BasePart") then
            pcall(function()
                obj.CanTouch = false
                obj.CanCollide = false
            end)
        end
    end
    
    workspace.DescendantAdded:Connect(function(descendant)
        if descendant.Name == "SentryBullet" and descendant:IsA("BasePart") then
            task.wait()
            pcall(function()
                descendant.CanTouch = false
                descendant.CanCollide = false
            end)
        end
    end)
end)

-- No jump delay
removeJumpDelay()

-- Auto-save every minute
task.spawn(function()
    while true do
        task.wait(60)
        pcall(saveConfiguration)
    end
end)

-- Leave keybind handler
UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == leaveKeybind then
        kickPlayer()
    end
end)

-- Character cleanup
player.CharacterRemoving:Connect(function()
    platformEnabled = false
    wallTransparencyEnabled = false
    comboFloatEnabled = false
    teleportEnabled = false
    
    if currentPlatform then currentPlatform:Destroy() end
    if comboCurrentPlatform then comboCurrentPlatform:Destroy() end
    if grappleHookConnection then task.cancel(grappleHookConnection) end
    if teleportOverlay then removeTeleportOverlay() end
end)

-- Success notification
WindUI:Notify({
    Title = "✓ Script Loaded!",
    Content = "Steal A Brainrot V1 Loaded!",
    Icon = "check-circle",
    Duration = 4
})
