local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local StarterPlayer = game:GetService("StarterPlayer")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
local LocalPlayer = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Platform variables
local platformEnabled = false
local currentPlatform = nil
local platformUpdateConnection = nil
local PLATFORM_OFFSET = 3.563

-- Wall transparency variables
local wallTransparencyEnabled = false
local originalTransparencies = {}
local TRANSPARENCY_LEVEL = 0.5
local playerCollisionConnection = nil

-- Combo Float + Wall variables
local comboFloatEnabled = false
local comboCurrentPlatform = nil
local comboPlatformUpdateConnection = nil
local comboPlayerCollisionConnection = nil
local COMBO_PLATFORM_OFFSET = 3.563

-- ESP variables
local plotDisplays = {}
local playerBaseName = LocalPlayer.DisplayName .. "'s Base"
local playerBaseTimeWarning = false
local alertGui = nil

-- More reasonable thresholds that don't interfere with normal gameplay
local MAX_VELOCITY = 30  -- Increased to allow for normal fast movement and cabling
local MAX_ANGULAR_VELOCITY = 10  -- Increased for normal rotation
local POSITION_RESET_THRESHOLD = 50  -- Much higher to allow cabling/teleportation
local SAFE_POSITION_UPDATE_INTERVAL = 0.5

local lastSafePosition = nil
local lastSafeTime = tick()
local currentBodyObjects = {}

local connections = {}

-- Animal ESP variables
local espTargetNames = {
    "Noobini Pizzanini", "Los Tralaleritos", "Las Tralaleritas", "Graipuss Medussi",
    "La Grande Combinasion", "Nuclearo Dinossauro", "Garama and Madundung", "Pot Hotspot",
    "Las Vaquitas Saturnitas", "Chicleteira Bicicleteira", "Dragon Cannelloni", "Los Combinasionas",
    "Karkerkar Kurkur", "Los Hotspotsitos", "Esok Sekolah", "Blackhole Goat", "Dul Dul Dul",
    "Tortuginni Dragonfruitini", "Chimpanzini Spiderini", "Los Matteos", "Nooo My Hotspot",
    "Sammyini Spyderini", "La Supreme Combinasion", "Ketupat Kepat", "Los Orcalitos",
    "Urubini Flamenguini", "Tralalita Tralala", "Orcalero Orcala", "Bulbito Bandito Traktorito",
    "Piccione Macchina", "Trippi Troppi Troppa Trippa", "Los Tungtungtungcitos"
}

local espTargetLookup = {}
for _, name in pairs(espTargetNames) do
    espTargetLookup[name] = true
end

local animalESPDisplays = {}
local animalESPEnabled = true

local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PlatformUI"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 280, 0, 150)
mainFrame.Position = UDim2.new(1, -290, 0, 140)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = mainFrame

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
titleText.Text = "🔷 FLOAT + WALLS 🔷"
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

local floatButton = Instance.new("TextButton")
floatButton.Name = "FloatButton"
floatButton.Size = UDim2.new(0, 130, 0, 35)
floatButton.Position = UDim2.new(0, 10, 0, 45)
floatButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
floatButton.Text = "🔷 ENABLE FLOATING 🔷"
floatButton.TextColor3 = Color3.fromRGB(255, 255, 255)
floatButton.TextScaled = true
floatButton.Font = Enum.Font.GothamBold
floatButton.BorderSizePixel = 0
floatButton.Parent = mainFrame

local floatCorner = Instance.new("UICorner")
floatCorner.CornerRadius = UDim.new(0, 6)
floatCorner.Parent = floatButton

local wallButton = Instance.new("TextButton")
wallButton.Name = "WallButton"
wallButton.Size = UDim2.new(0, 130, 0, 35)
wallButton.Position = UDim2.new(0, 150, 0, 45)
wallButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
wallButton.Text = "🔷 WALL TRANSPARENT 🔷"
wallButton.TextColor3 = Color3.fromRGB(255, 255, 255)
wallButton.TextScaled = true
wallButton.Font = Enum.Font.GothamBold
wallButton.BorderSizePixel = 0
wallButton.Parent = mainFrame

local wallCorner = Instance.new("UICorner")
wallCorner.CornerRadius = UDim.new(0, 6)
wallCorner.Parent = wallButton

local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "StatusLabel"
statusLabel.Size = UDim2.new(1, -20, 0, 25)
statusLabel.Position = UDim2.new(0, 10, 0, 90)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Float: OFF | Walls: OFF"
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = mainFrame

local creditLabel = Instance.new("TextLabel")
creditLabel.Name = "CreditLabel"
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

local function enablePlatform()
    if platformEnabled then return end
    
    platformEnabled = true
    currentPlatform = createPlatform()
    
    platformUpdateConnection = RunService.Heartbeat:Connect(updatePlatformPosition)
    updatePlatformPosition()
    
    floatButton.BackgroundColor3 = Color3.fromRGB(0, 150, 50)
    floatButton.Text = "🔷 DISABLE FLOATING 🔷"
    
    local wallStatus = wallTransparencyEnabled and "ON" or "OFF"
    statusLabel.Text = "Float: ON | Walls: " .. wallStatus
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
    
    floatButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    floatButton.Text = "🔷 ENABLE FLOATING 🔷"
    
    local wallStatus = wallTransparencyEnabled and "ON" or "OFF"
    statusLabel.Text = "Float: OFF | Walls: " .. wallStatus
end

local function storeOriginalTransparencies()
    originalTransparencies = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Parent ~= player.Character and obj.Name ~= "PlayerPlatform" and obj.Name ~= "ComboPlayerPlatform" then
            local name = obj.Name:lower()
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

local function createComboPlatform()
    local platform = Instance.new("Part")
    platform.Name = "ComboPlayerPlatform"
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
    
    wallButton.BackgroundColor3 = Color3.fromRGB(150, 50, 0)
    wallButton.Text = "🔷 DISABLE WALLS 🔷"
    
    local floatStatus = platformEnabled and "ON" or "OFF"
    statusLabel.Text = "Float: " .. floatStatus .. " | Walls: ON"
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
    
    -- Restore normal player collision state
    if player.Character then
        local head = player.Character:FindFirstChild("Head")
        if head then
            head.CanCollide = false -- Default Roblox state for head
        end
    end
    
    wallButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    wallButton.Text = "🔷 WALL TRANSPARENT 🔷"
    
    local floatStatus = platformEnabled and "ON" or "OFF"
    statusLabel.Text = "Float: " .. floatStatus .. " | Walls: OFF"
end

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

function createPlayerESP(player, head)
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

local function createAnimalESP(object, name)
    if not object or not object.Parent or not animalESPEnabled then return end
    
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
    textLabel.TextColor3 = Color3.fromRGB(255, 100, 255)
    textLabel.TextScaled = true
    textLabel.TextStrokeTransparency = 0
    textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    textLabel.Font = Enum.Font.SourceSansBold
    
    return billboardGui
end

local function scanForTargetAnimals()
    for _, descendant in pairs(workspace:GetDescendants()) do
        if descendant:IsA("Model") and espTargetLookup[descendant.Name] then
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
                    end
                end
            end
        end
    end
    
    for objId, display in pairs(animalESPDisplays) do
        if not display.object or not display.object.Parent or not display.part or not display.part.Parent then
            if display.gui then
                display.gui:Destroy()
            end
            animalESPDisplays[objId] = nil
        end
    end
end

local function initializeAnimalESP()
    task.wait(2)
    scanForTargetAnimals()
    
    workspace.DescendantAdded:Connect(function(descendant)
        if descendant:IsA("Model") and espTargetLookup[descendant.Name] then
            task.wait(0.5)
            
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
                    end
                end
            end
        end
    end)
    
    task.spawn(function()
        while animalESPEnabled do
            task.wait(5)
            pcall(scanForTargetAnimals)
        end
    end)
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
    
    if platformEnabled then
        task.wait(1)
        
        if currentPlatform then
            currentPlatform:Destroy()
        end
        
        currentPlatform = createPlatform()
        updatePlatformPosition()
    end
end

player.CharacterAdded:Connect(onCharacterAdded)

for _, playerObj in pairs(Players:GetPlayers()) do
    if playerObj ~= LocalPlayer then
        createPlayerDisplay(playerObj)
        playerObj.CharacterAdded:Connect(function()
            task.wait(0.5)
            createPlayerDisplay(playerObj)
        end)
    end
end

Players.PlayerAdded:Connect(function(playerObj)
    if playerObj ~= LocalPlayer then
        createPlayerDisplay(playerObj)
        playerObj.CharacterAdded:Connect(function()
            task.wait(0.5)
            createPlayerDisplay(playerObj)
        end)
    end
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
    screenGui:Destroy()
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

addHoverEffect(closeButton, Color3.fromRGB(220, 70, 70), Color3.fromRGB(200, 50, 50))
addHoverEffect(floatButton, Color3.fromRGB(30, 30, 30), Color3.fromRGB(0, 0, 0))
addHoverEffect(wallButton, Color3.fromRGB(30, 30, 30), Color3.fromRGB(0, 0, 0))

game:BindToClose(function()
    if platformEnabled then
        disablePlatform()
    end
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

task.spawn(initializeAnimalESP)
removeJumpDelay()

-- Whitelist for legitimate game mechanics
local ALLOWED_REMOTES = {
    "cable", "grapple", "hook", "swing", "teleport", "dash", "boost", 
    "jump", "fly", "speed", "move", "transport", "travel", "warp"
}

local ALLOWED_SCRIPTS = {
    "cable", "grapple", "hook", "swing", "teleport", "dash", "boost",
    "jump", "fly", "speed", "move", "transport", "travel", "movement"
}

local function isAllowedName(name, allowedList)
    local lowerName = name:lower()
    for _, allowed in pairs(allowedList) do
        if lowerName:find(allowed) then
            return true
        end
    end
    return false
end

local function isRagdollRelated(name)
    local lowerName = name:lower()
    -- Only target specifically ragdoll and fling related items
    return (lowerName:find("ragdoll") or lowerName:find("fling")) and
           not isAllowedName(name, ALLOWED_SCRIPTS)
end

local function destroyScript(script)
    if script and script.Parent then
        pcall(function()
            script.Disabled = true
            script:Destroy()
        end)
        return true
    end
    return false
end

local function destroyRemoteEvent(remote)
    -- Only destroy if it's specifically ragdoll/fling related and not whitelisted
    if remote and isRagdollRelated(remote.Name) and not isAllowedName(remote.Name, ALLOWED_REMOTES) then
        pcall(function()
            if remote:IsA("RemoteEvent") then
                remote.FireServer = function() end
                -- Disconnect connections more safely
                pcall(function()
                    for _, connection in pairs(getconnections(remote.OnClientEvent)) do
                        connection:Disconnect()
                    end
                end)
            elseif remote:IsA("RemoteFunction") then
                remote.InvokeServer = function() return end
                remote.OnClientInvoke = function() return end
            end
        end)
    end
end

local function destroyRagdollSystems()
    -- Only target specific ragdoll paths, not all systems
    local ragdollPaths = {
        {ReplicatedStorage, {"Packages", "Ragdoll"}},
        {ReplicatedStorage, {"Controllers", "RagdollController"}},
        {StarterPlayer, {"StarterCharacterScripts", "RagdollClient"}},
        {StarterPlayer, {"StarterPlayerScripts", "RagdollController"}},
    }
    
    for _, pathData in pairs(ragdollPaths) do
        pcall(function()
            local current = pathData[1]
            for i = 2, #pathData do
                current = current:FindFirstChild(pathData[i])
                if not current then break end
            end
            
            if current and isRagdollRelated(current.Name) then
                if current:IsA("Script") or current:IsA("LocalScript") or current:IsA("ModuleScript") then
                    destroyScript(current)
                elseif current:IsA("RemoteEvent") or current:IsA("RemoteFunction") then
                    destroyRemoteEvent(current)
                else
                    -- Only destroy ragdoll-related scripts in folders
                    for _, child in pairs(current:GetDescendants()) do
                        if (child:IsA("Script") or child:IsA("LocalScript") or child:IsA("ModuleScript")) 
                           and isRagdollRelated(child.Name) then
                            destroyScript(child)
                        elseif (child:IsA("RemoteEvent") or child:IsA("RemoteFunction")) 
                               and isRagdollRelated(child.Name) then
                            destroyRemoteEvent(child)
                        end
                    end
                end
            end
        end)
    end
end

local function cleanupBodyObjects(character)
    if currentBodyObjects[character] then
        for _, obj in pairs(currentBodyObjects[character]) do
            pcall(function() obj:Destroy() end)
        end
        currentBodyObjects[character] = nil
    end
end

local function setupAntiRagdollFling(character)
    if not character then return end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not rootPart then return end
    
    -- Clean up any existing body objects
    cleanupBodyObjects(character)
    currentBodyObjects[character] = {}
    
    -- Only create body objects when needed (not constantly active)
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(0, 0, 0)  -- Start disabled
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = rootPart
    currentBodyObjects[character][#currentBodyObjects[character] + 1] = bodyVelocity
    
    local bodyAngularVelocity = Instance.new("BodyAngularVelocity")
    bodyAngularVelocity.MaxTorque = Vector3.new(0, 0, 0)  -- Start disabled
    bodyAngularVelocity.AngularVelocity = Vector3.new(0, 0, 0)
    bodyAngularVelocity.Parent = rootPart
    currentBodyObjects[character][#currentBodyObjects[character] + 1] = bodyAngularVelocity
    
    local bodyPosition = Instance.new("BodyPosition")
    bodyPosition.MaxForce = Vector3.new(0, 0, 0)  -- Start disabled
    bodyPosition.Position = rootPart.Position
    bodyPosition.P = 5000  -- Lower values for less interference
    bodyPosition.D = 500
    bodyPosition.Parent = rootPart
    currentBodyObjects[character][#currentBodyObjects[character] + 1] = bodyPosition
    
    lastSafePosition = rootPart.Position
    lastSafeTime = tick()
    
    -- Only prevent specific ragdoll states, not normal physics
    local stateConnection = humanoid.StateChanged:Connect(function(old, new)
        -- Only interfere with obvious ragdoll states
        if new == Enum.HumanoidStateType.Physics and old ~= Enum.HumanoidStateType.Jumping then
            task.wait(0.1)  -- Small delay to allow legitimate physics
            if humanoid and humanoid.Parent and humanoid.Health > 0 then
                humanoid:ChangeState(Enum.HumanoidStateType.Running)
            end
        end
    end)
    
    -- Prevent platform stand only if it's not legitimate
    local lastPlatformStandTime = 0
    local platformConnection = humanoid:GetPropertyChangedSignal("PlatformStand"):Connect(function()
        if humanoid.PlatformStand then
            local currentTime = tick()
            -- Allow brief platform stand for legitimate mechanics
            if currentTime - lastPlatformStandTime > 0.5 then
                task.wait(0.2)  -- Give time for legitimate uses
                if humanoid.PlatformStand and humanoid.Health > 0 then
                    humanoid.PlatformStand = false
                end
            end
            lastPlatformStandTime = currentTime
        end
    end)
    
    -- Main protection - only activate when detecting actual exploits
    local velocityConnection = RunService.Heartbeat:Connect(function()
        if not rootPart or not rootPart.Parent or not humanoid or not humanoid.Parent then 
            return 
        end
        
        local velocity = rootPart.Velocity
        local angularVelocity = rootPart.RotVelocity
        local position = rootPart.Position
        local currentTime = tick()
        
        -- Only interfere with extreme velocities (likely exploits)
        local velocityMagnitude = velocity.Magnitude
        if velocityMagnitude > MAX_VELOCITY then
            -- Check if this might be legitimate (like cabling)
            local isLikelyLegitimate = false
            
            -- Allow high velocity if it's in a reasonable direction (not random)
            local velocityDirection = velocity.Unit
            if math.abs(velocityDirection.Y) < 0.8 then  -- Not purely vertical fling
                isLikelyLegitimate = true
            end
            
            -- Allow high velocity for short bursts (cabling, teleports, etc.)
            if velocityMagnitude < MAX_VELOCITY * 3 then  -- Not extremely high
                isLikelyLegitimate = true
            end
            
            if not isLikelyLegitimate then
                bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
                bodyVelocity.Velocity = velocity.Unit * MAX_VELOCITY
            else
                bodyVelocity.MaxForce = Vector3.new(0, 0, 0)
            end
        else
            bodyVelocity.MaxForce = Vector3.new(0, 0, 0)
        end
        
        -- Angular velocity control - only for extreme spinning
        if angularVelocity.Magnitude > MAX_ANGULAR_VELOCITY then
            bodyAngularVelocity.MaxTorque = Vector3.new(4000, 4000, 4000)
            bodyAngularVelocity.AngularVelocity = angularVelocity.Unit * MAX_ANGULAR_VELOCITY
        else
            bodyAngularVelocity.MaxTorque = Vector3.new(0, 0, 0)
        end
        
        -- Position control - very lenient to allow cabling and teleportation
        if lastSafePosition then
            local distanceFromSafe = (position - lastSafePosition).Magnitude
            
            -- Only reset position for extreme teleportation (obvious exploits)
            if distanceFromSafe > POSITION_RESET_THRESHOLD then
                -- Check if this might be legitimate movement
                local isLikelyExploit = true
                
                -- Allow teleportation if velocity suggests legitimate movement
                if velocityMagnitude > 50 and velocityMagnitude < MAX_VELOCITY then
                    isLikelyExploit = false
                end
                
                -- Allow if the movement is reasonable (not instant across map)
                if distanceFromSafe < POSITION_RESET_THRESHOLD * 2 then
                    isLikelyExploit = false
                end
                
                if isLikelyExploit then
                    bodyPosition.MaxForce = Vector3.new(4000, 4000, 4000)
                    bodyPosition.Position = lastSafePosition
                    
                    -- Only emergency teleport for extreme cases
                    if distanceFromSafe > POSITION_RESET_THRESHOLD * 5 then
                        rootPart.CFrame = CFrame.new(lastSafePosition)
                    end
                else
                    -- Update safe position if movement seems legitimate
                    lastSafePosition = position
                    lastSafeTime = currentTime
                    bodyPosition.MaxForce = Vector3.new(0, 0, 0)
                end
            else
                bodyPosition.MaxForce = Vector3.new(0, 0, 0)
                
                -- Regular safe position updates
                if currentTime - lastSafeTime > SAFE_POSITION_UPDATE_INTERVAL then
                    lastSafePosition = position
                    lastSafeTime = currentTime
                end
            end
        end
        
        -- Void protection - more lenient
        if position.Y < -500 then
            if lastSafePosition and lastSafePosition.Y > -100 then
                rootPart.CFrame = CFrame.new(lastSafePosition + Vector3.new(0, 5, 0))
            end
        end
    end)
    
    -- Joint protection - only for Motor6D joints
    local jointProtection = {}
    local function protectJoints()
        for _, joint in pairs(character:GetDescendants()) do
            if joint:IsA("Motor6D") and joint.Part0 and joint.Part1 then
                jointProtection[joint] = {
                    C0 = joint.C0,
                    C1 = joint.C1,
                    Part0 = joint.Part0,
                    Part1 = joint.Part1,
                    Parent = joint.Parent
                }
                
                joint.AncestryChanged:Connect(function()
                    if not joint.Parent and character.Parent and jointProtection[joint] then
                        -- Longer delay to allow legitimate joint removal
                        task.wait(0.5)
                        if character.Parent and humanoid and humanoid.Parent and humanoid.Health > 0 then
                            pcall(function()
                                joint.Parent = jointProtection[joint].Parent
                                joint.Part0 = jointProtection[joint].Part0
                                joint.Part1 = jointProtection[joint].Part1
                                joint.C0 = jointProtection[joint].C0
                                joint.C1 = jointProtection[joint].C1
                            end)
                        end
                    end
                end)
            end
        end
    end
    
    protectJoints()
    
    -- Only remove obviously malicious scripts
    for _, script in pairs(character:GetDescendants()) do
        if script:IsA("Script") or script:IsA("LocalScript") then
            if isRagdollRelated(script.Name) then
                destroyScript(script)
            end
        end
    end
    
    -- Monitor for new ragdoll objects - be more selective
    local descendantConnection = character.DescendantAdded:Connect(function(descendant)
        if descendant:IsA("Script") or descendant:IsA("LocalScript") then
            if isRagdollRelated(descendant.Name) then
                task.wait(0.2)
                destroyScript(descendant)
            end
        elseif descendant:IsA("BodyVelocity") or descendant:IsA("BodyPosition") or 
               descendant:IsA("BodyAngularVelocity") or descendant:IsA("BodyForce") then
            -- Check if it's one of our protection objects
            local isOurObject = false
            if currentBodyObjects[character] then
                for _, obj in pairs(currentBodyObjects[character]) do
                    if obj == descendant then
                        isOurObject = true
                        break
                    end
                end
            end
            
            -- Only destroy if it's not ours and seems malicious
            if not isOurObject and not isAllowedName(descendant.Name, ALLOWED_SCRIPTS) then
                -- Give time for legitimate body objects to be used
                task.wait(1)
                pcall(function()
                    if descendant.Parent then
                        descendant:Destroy()
                    end
                end)
            end
        end
    end)
    
    connections[#connections + 1] = stateConnection
    connections[#connections + 1] = platformConnection
    connections[#connections + 1] = velocityConnection
    connections[#connections + 1] = descendantConnection
end

local function cleanupConnections()
    for _, connection in pairs(connections) do
        pcall(function()
            if connection and connection.Connected then
                connection:Disconnect()
            end
        end)
    end
    connections = {}
end

local function onCharacterAdded(character)
    task.wait(0.3)  -- Reduced wait time
    setupAntiRagdollFling(character)
    
    -- Less aggressive post-setup cleanup
    task.wait(2)
    pcall(function()
        for _, script in pairs(character:GetDescendants()) do
            if script:IsA("LocalScript") or script:IsA("Script") then
                if isRagdollRelated(script.Name) then
                    destroyScript(script)
                end
            end
        end
    end)
end

local function onCharacterRemoving(character)
    cleanupConnections()
    cleanupBodyObjects(character)
end

-- Connect character events
LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
LocalPlayer.CharacterRemoving:Connect(onCharacterRemoving)

if LocalPlayer.Character then
    onCharacterAdded(LocalPlayer.Character)
end

-- Initial cleanup - more selective
destroyRagdollSystems()

-- Less frequent monitoring to reduce performance impact
task.spawn(function()
    while true do
        pcall(destroyRagdollSystems)
        task.wait(5)  -- Increased interval
    end
end)

-- More selective monitoring of new objects
ReplicatedStorage.DescendantAdded:Connect(function(descendant)
    if isRagdollRelated(descendant.Name) and not isAllowedName(descendant.Name, ALLOWED_REMOTES) then
        task.wait(0.2)
        if descendant:IsA("Script") or descendant:IsA("LocalScript") or descendant:IsA("ModuleScript") then
            destroyScript(descendant)
        elseif descendant:IsA("RemoteEvent") or descendant:IsA("RemoteFunction") then
            destroyRemoteEvent(descendant)
        end
    end
end)

StarterPlayer.DescendantAdded:Connect(function(descendant)
    if isRagdollRelated(descendant.Name) and not isAllowedName(descendant.Name, ALLOWED_SCRIPTS) then
        task.wait(0.2)
        if descendant:IsA("Script") or descendant:IsA("LocalScript") then
            destroyScript(descendant)
        end
    end
end)

-- Cleanup global variable
_G.AntiRagdollFling = nil

print("Cable-Friendly Anti-Ragdoll script loaded! Cabling and normal movement preserved.")
