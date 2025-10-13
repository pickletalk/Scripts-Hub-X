-- Grow A Garden Auto Farm Script with Speed Changer
-- By PickleTalk | Scripts Hub X

-- ============================================
-- SPEED SPOOF SYSTEM
-- ============================================
local WalkSpeedSpoof = getgenv().WalkSpeedSpoof
local Disable = WalkSpeedSpoof and WalkSpeedSpoof.Disable
if Disable then
    Disable()
end

local cloneref = cloneref or function(...)
    return ...
end

local WalkSpeedSpoof = {}

local Players = cloneref(game:GetService("Players"))
if not Players.LocalPlayer then
    Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
end
local lp = cloneref(Players.LocalPlayer)

local split = string.split

local GetDebugIdHandler = Instance.new("BindableFunction")
local TempHumanoid = Instance.new("Humanoid")

local cachedhumanoids = {}

local CurrentHumanoid
local newindexhook
local indexhook

function GetDebugIdHandler.OnInvoke(obj: Instance): string
    return obj:GetDebugId()
end

local function GetDebugId(obj: Instance): string
    return GetDebugIdHandler:Invoke(obj)
end

local function GetWalkSpeed(obj: any): number
    TempHumanoid.WalkSpeed = obj
    return TempHumanoid.WalkSpeed
end

function cachedhumanoids:cacheHumanoid(DebugId: string,Humanoid: Humanoid)
    cachedhumanoids[DebugId] = {
        currentindex = indexhook(Humanoid,"WalkSpeed"),
        lastnewindex = nil
    }
    return self[DebugId]
end

indexhook = hookmetamethod(game,"__index",function(self,index)
    if not checkcaller() and typeof(self) == "Instance" then
        if self:IsA("Humanoid") then
            local DebugId = GetDebugId(self)
            local cached = cachedhumanoids[DebugId]

            if self:IsDescendantOf(lp.Character) or cached then
                if type(index) == "string" then
                    local cleanindex = split(index,"\0")[1]

                    if cleanindex == "WalkSpeed" then
                        if not cached then
                            cached = cachedhumanoids:cacheHumanoid(DebugId,self)
                        end

                        if not (CurrentHumanoid and CurrentHumanoid:IsDescendantOf(game)) then
                            CurrentHumanoid = cloneref(self)
                        end

                        return cached.lastnewindex or cached.currentindex
                    end
                end
            end
        end
    end

    return indexhook(self,index)
end)

newindexhook = hookmetamethod(game,"__newindex",function(self,index,newindex)
    if not checkcaller() and typeof(self) == "Instance" then
        if self:IsA("Humanoid") then
            local DebugId = GetDebugId(self)
            local cached = cachedhumanoids[DebugId]

            if self:IsDescendantOf(lp.Character) or cached then
                if type(index) == "string" then
                    local cleanindex = split(index,"\0")[1]

                    if cleanindex == "WalkSpeed" then
                        if not cached then
                            cached = cachedhumanoids:cacheHumanoid(DebugId,self)
                        end

                        if not (CurrentHumanoid and CurrentHumanoid:IsDescendantOf(game)) then
                            CurrentHumanoid = cloneref(self)
                        end
                        cached.lastnewindex = GetWalkSpeed(newindex)
                        return CurrentHumanoid.WalkSpeed
                    end
                end
            end
        end
    end
    
    return newindexhook(self,index,newindex)
end)

function WalkSpeedSpoof:Disable()
    WalkSpeedSpoof:RestoreWalkSpeed()
    hookmetamethod(game,"__index",indexhook)
    hookmetamethod(game,"__newindex",newindexhook)
    GetDebugIdHandler:Destroy()
    TempHumanoid:Destroy()
    table.clear(WalkSpeedSpoof)
    getgenv().WalkSpeedSpoof = nil
end

function WalkSpeedSpoof:GetHumanoid()
    return CurrentHumanoid or (function()
        local char = lp.Character
        local Humanoid = char and char:FindFirstChildWhichIsA("Humanoid") or nil
        
        if Humanoid then
            cachedhumanoids:cacheHumanoid(Humanoid:GetDebugId(),Humanoid)
            return cloneref(Humanoid)
        end
    end)()
end

function WalkSpeedSpoof:SetWalkSpeed(speed)
    local Humanoid = WalkSpeedSpoof:GetHumanoid()

    if Humanoid then
        local connections = {}
        local function AddConnectionsFromSignal(Signal)
            for i,v in getconnections(Signal) do
                if v.State then
                    v:Disable()
                    table.insert(connections,v)
                end
            end
        end
        AddConnectionsFromSignal(Humanoid.Changed)
        AddConnectionsFromSignal(Humanoid:GetPropertyChangedSignal("WalkSpeed"))
        Humanoid.WalkSpeed = speed
        for i,v in connections do
            v:Enable()
        end
    end
end

function WalkSpeedSpoof:RestoreWalkSpeed()
    local Humanoid = WalkSpeedSpoof:GetHumanoid()
    
    if Humanoid then
        local cached = cachedhumanoids[Humanoid:GetDebugId()]

        if cached then
            WalkSpeedSpoof:SetWalkSpeed(cached.lastnewindex or cached.currentindex)
        end
    end
end

getgenv().WalkSpeedSpoof = WalkSpeedSpoof

-- ============================================
-- SPEED CHANGER STATE
-- ============================================
local speedEnabled = false
local currentSpeedValue = 100 -- Default speed value when enabled

-- ============================================
-- SERVICES
-- ============================================
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Remote Events
local BuyGearStock = ReplicatedStorage.GameEvents.BuyGearStock
local BuySeedStock = ReplicatedStorage.GameEvents.BuySeedStock
local BuyPetEgg = ReplicatedStorage.GameEvents.BuyPetEgg

-- Item Lists
local gearItems = {
    "Watering Can", "Trading Ticket", "Trowel", "Recall Wrench", "Basic Sprinkler",
    "Advanced Sprinkler", "Medium Toy", "Medium Treat", "Godly Sprinkler",
    "Magnifying Glass", "Master Sprinkler", "Cleaning Spray", "Cleansing Pet Shard",
    "Favorite Tool", "Harvest Tool", "Friendship Pot", "Grandmaster Sprinkler", "Levelup Lollipop"
}

local seedItems = {
    "Carrot", "Strawberry", "Blueberry", "Orange Tulip", "Tomato", "Corn", "Daffodil",
    "Watermelon", "Pumpkin", "Apple", "Bamboo", "Coconut", "Cactus", "Dragon Fruit",
    "Mango", "Grape", "Mushroom", "Pepper", "Cacao", "Beanstalk", "Ember Lily",
    "Sugar Apple", "Burning Bud", "Giant Pinecone", "Elder Strawberry", "Romanesco",
    "Crimson Thorn", "Great Pumpkin"
}

local eggItems = {
    "Common Egg", "Uncommon Egg", "Rare Egg", "Legendary Egg", "Mythical Egg",
    "Jungle Egg", "Bug Egg"
}

-- BASELINE: What player had BEFORE farming started
local baselineItemCounts = {
    Gears = {},
    Seeds = {},
    Eggs = {}
}

-- CURRENT SESSION GAINS: Items gained during this farming session
local itemCounts = {
    Gears = {},
    Seeds = {},
    Eggs = {}
}

local uiLabels = {
    Gears = {},
    Seeds = {},
    Eggs = {}
}

local isMinimized = false

-- Initialize/reset item counts to 0
local function resetItemCounts()
    for _, item in ipairs(gearItems) do
        itemCounts.Gears[item] = 0
    end
    for _, item in ipairs(seedItems) do
        itemCounts.Seeds[item] = 0
    end
    for _, item in ipairs(eggItems) do
        itemCounts.Eggs[item] = 0
    end
end

-- Initialize baseline counts to 0
local function initializeBaselineCounts()
    for _, item in ipairs(gearItems) do
        baselineItemCounts.Gears[item] = 0
    end
    for _, item in ipairs(seedItems) do
        baselineItemCounts.Seeds[item] = 0
    end
    for _, item in ipairs(eggItems) do
        baselineItemCounts.Eggs[item] = 0
    end
end

resetItemCounts()
initializeBaselineCounts()

-- ============================================
-- CHAT COMMAND SYSTEM
-- ============================================
local function handleSpeedCommand(args)
    if #args < 1 then
        print("[SPEED] Usage: .speed [number/on/off]")
        return
    end
    
    local command = string.lower(args[1])
    
    if command == "on" then
        if not speedEnabled then
            speedEnabled = true
            WalkSpeedSpoof:SetWalkSpeed(currentSpeedValue)
            print("[SPEED] Speed changer enabled! Speed set to " .. currentSpeedValue)
        else
            print("[SPEED] Speed changer is already enabled!")
        end
        
    elseif command == "off" then
        if speedEnabled then
            speedEnabled = false
            WalkSpeedSpoof:RestoreWalkSpeed()
            print("[SPEED] Speed changer disabled! Speed restored to normal.")
        else
            print("[SPEED] Speed changer is already disabled!")
        end
        
    else
        -- Try to parse as number
        local speedValue = tonumber(command)
        if speedValue then
            currentSpeedValue = speedValue
            speedEnabled = true
            WalkSpeedSpoof:SetWalkSpeed(speedValue)
            print("[SPEED] Speed set to " .. speedValue .. " and enabled!")
        else
            print("[SPEED] Invalid command! Use: .speed [number/on/off]")
        end
    end
end

local function parseChatCommand(message)
    -- Check if message starts with "."
    if string.sub(message, 1, 1) ~= "." then
        return
    end
    
    -- Remove the "." prefix
    local commandString = string.sub(message, 2)
    
    -- Split by spaces
    local parts = {}
    for word in string.gmatch(commandString, "[^%s]+") do
        table.insert(parts, word)
    end
    
    if #parts < 1 then
        return
    end
    
    local commandName = string.lower(parts[1])
    local args = {}
    for i = 2, #parts do
        table.insert(args, parts[i])
    end
    
    -- Handle commands
    if commandName == "speed" then
        handleSpeedCommand(args)
    end
end

-- Listen to chat messages
player.Chatted:Connect(function(message)
    parseChatCommand(message)
end)

-- ============================================
-- UI CREATION
-- ============================================
local function createUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "GardenAutoFarmUI"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 300, 0, 370)
    mainFrame.Position = UDim2.new(0.5, -150, 0.5, -185)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = mainFrame
    
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 40)
    header.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    header.BorderSizePixel = 0
    header.Parent = mainFrame
    
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 10)
    headerCorner.Parent = header
    
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -45, 0, 20)
    title.Position = UDim2.new(0, 10, 0, 5)
    title.BackgroundTransparency = 1
    title.Text = "🌱 Auto Farm Logs"
    title.TextColor3 = Color3.fromRGB(100, 255, 100)
    title.TextSize = 16
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = header
    
    local subtitle = Instance.new("TextLabel")
    subtitle.Name = "Subtitle"
    subtitle.Size = UDim2.new(1, -45, 0, 15)
    subtitle.Position = UDim2.new(0, 10, 0, 22)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "By PickleTalk"
    subtitle.TextColor3 = Color3.fromRGB(150, 150, 150)
    subtitle.TextSize = 11
    subtitle.Font = Enum.Font.Gotham
    subtitle.TextXAlignment = Enum.TextXAlignment.Left
    subtitle.Parent = header
    
    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Name = "MinimizeButton"
    minimizeBtn.Size = UDim2.new(0, 28, 0, 28)
    minimizeBtn.Position = UDim2.new(1, -34, 0, 6)
    minimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    minimizeBtn.Text = "−"
    minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    minimizeBtn.TextSize = 18
    minimizeBtn.Font = Enum.Font.GothamBold
    minimizeBtn.Parent = header
    
    local minimizeBtnCorner = Instance.new("UICorner")
    minimizeBtnCorner.CornerRadius = UDim.new(0, 6)
    minimizeBtnCorner.Parent = minimizeBtn
    
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "ContentFrame"
    contentFrame.Size = UDim2.new(1, -16, 1, -48)
    contentFrame.Position = UDim2.new(0, 8, 0, 44)
    contentFrame.BackgroundTransparency = 1
    contentFrame.BorderSizePixel = 0
    contentFrame.Parent = mainFrame
    
    local function createColumn(sectionName, items, xOffset)
        local column = Instance.new("Frame")
        column.Name = sectionName .. "Column"
        column.Size = UDim2.new(0, 90, 1, 0)
        column.Position = UDim2.new(0, xOffset, 0, 0)
        column.BackgroundTransparency = 1
        column.Parent = contentFrame
        
        local columnTitle = Instance.new("TextLabel")
        columnTitle.Name = "ColumnTitle"
        columnTitle.Size = UDim2.new(1, 0, 0, 20)
        columnTitle.BackgroundTransparency = 1
        columnTitle.Text = sectionName .. ":"
        columnTitle.TextColor3 = Color3.fromRGB(100, 255, 100)
        columnTitle.TextSize = 13
        columnTitle.Font = Enum.Font.GothamBold
        columnTitle.TextXAlignment = Enum.TextXAlignment.Center
        columnTitle.Parent = column
        
        local itemsScroll = Instance.new("ScrollingFrame")
        itemsScroll.Name = "ItemsScroll"
        itemsScroll.Size = UDim2.new(1, 0, 1, -22)
        itemsScroll.Position = UDim2.new(0, 0, 0, 22)
        itemsScroll.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        itemsScroll.BorderSizePixel = 0
        itemsScroll.ScrollBarThickness = 3
        itemsScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
        itemsScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
        itemsScroll.Parent = column
        
        local scrollCorner = Instance.new("UICorner")
        scrollCorner.CornerRadius = UDim.new(0, 6)
        scrollCorner.Parent = itemsScroll
        
        local itemsContainer = Instance.new("Frame")
        itemsContainer.Name = "ItemsContainer"
        itemsContainer.Size = UDim2.new(1, -4, 0, 0)
        itemsContainer.Position = UDim2.new(0, 2, 0, 2)
        itemsContainer.BackgroundTransparency = 1
        itemsContainer.Parent = itemsScroll
        
        local listLayout = Instance.new("UIListLayout")
        listLayout.SortOrder = Enum.SortOrder.LayoutOrder
        listLayout.Padding = UDim.new(0, 2)
        listLayout.Parent = itemsContainer
        
        listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            itemsContainer.Size = UDim2.new(1, -4, 0, listLayout.AbsoluteContentSize.Y + 4)
        end)
        
        for _, itemName in ipairs(items) do
            local itemLabel = Instance.new("TextLabel")
            itemLabel.Name = itemName
            itemLabel.Size = UDim2.new(1, 0, 0, 18)
            itemLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
            itemLabel.BorderSizePixel = 0
            itemLabel.Text = itemName .. " (0)"
            itemLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            itemLabel.TextSize = 9
            itemLabel.Font = Enum.Font.Gotham
            itemLabel.TextXAlignment = Enum.TextXAlignment.Left
            itemLabel.TextTruncate = Enum.TextTruncate.AtEnd
            itemLabel.Parent = itemsContainer
            
            local padding = Instance.new("UIPadding")
            padding.PaddingLeft = UDim.new(0, 4)
            padding.Parent = itemLabel
            
            local itemCorner = Instance.new("UICorner")
            itemCorner.CornerRadius = UDim.new(0, 3)
            itemCorner.Parent = itemLabel
            
            uiLabels[sectionName][itemName] = itemLabel
        end
        
        return column
    end
    
    createColumn("Seeds", seedItems, 0)
    createColumn("Gears", gearItems, 95)
    createColumn("Eggs", eggItems, 190)
    
    local function toggleMinimize()
        isMinimized = not isMinimized
        
        local targetSize
        local targetText
        local targetColor
        
        if isMinimized then
            targetSize = UDim2.new(0, 300, 0, 40)
            targetText = "+"
            targetColor = Color3.fromRGB(100, 255, 100)
            contentFrame.Visible = false
        else
            targetSize = UDim2.new(0, 300, 0, 370)
            targetText = "−"
            targetColor = Color3.fromRGB(255, 100, 100)
            contentFrame.Visible = true
        end
        
        local tween = TweenService:Create(
            mainFrame,
            TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
            {Size = targetSize}
        )
        tween:Play()
        
        minimizeBtn.Text = targetText
        minimizeBtn.BackgroundColor3 = targetColor
    end
    
    minimizeBtn.MouseButton1Click:Connect(toggleMinimize)
    
    local dragging = false
    local dragInput, dragStart, startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        local targetPos = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X, 
            startPos.Y.Scale, 
            startPos.Y.Offset + delta.Y
        )
        
        TweenService:Create(
            mainFrame,
            TweenInfo.new(0.1, Enum.EasingStyle.Linear),
            {Position = targetPos}
        ):Play()
    end
    
    header.InputBegan:Connect(function(input)
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
    
    header.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
    
    screenGui.Parent = playerGui
    return screenGui
end

local function updateUILabel(category, itemName, gainedCount)
    pcall(function()
        if uiLabels[category] and uiLabels[category][itemName] then
            local label = uiLabels[category][itemName]
            label.Text = itemName .. " (" .. gainedCount .. ")"
            
            -- Flash green if items were gained
            if gainedCount > 0 then
                local originalColor = label.BackgroundColor3
                label.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
                TweenService:Create(label, TweenInfo.new(0.4), {BackgroundColor3 = originalColor}):Play()
            end
        end
    end)
end

-- Reset all UI labels to 0
local function resetUILabels()
    pcall(function()
        for category, items in pairs(uiLabels) do
            for itemName, label in pairs(items) do
                label.Text = itemName .. " (0)"
            end
        end
    end)
end

-- Extract count from item name (e.g., "Carrot x5" returns 5)
local function getItemCount(itemName, baseItemName)
    -- Check if item name starts with base name
    if string.sub(itemName, 1, #baseItemName) == baseItemName then
        -- Try to extract number after "x"
        local count = string.match(itemName, "x%s*(%d+)")
        if count then
            return tonumber(count)
        end
        -- If no "x" found, it might be just the item with count 1
        return 1
    end
    return 0
end

-- Get current backpack item counts
local function getCurrentBackpackCounts()
    local counts = {
        Gears = {},
        Seeds = {},
        Eggs = {}
    }
    
    -- Initialize all to 0
    for _, item in ipairs(gearItems) do
        counts.Gears[item] = 0
    end
    for _, item in ipairs(seedItems) do
        counts.Seeds[item] = 0
    end
    for _, item in ipairs(eggItems) do
        counts.Eggs[item] = 0
    end
    
    pcall(function()
        local backpack = player:FindFirstChild("Backpack")
        if not backpack then 
            return 
        end
        
        -- Count all items in backpack
        for _, child in ipairs(backpack:GetChildren()) do
            -- Check seeds
            for _, seedName in ipairs(seedItems) do
                local count = getItemCount(child.Name, seedName)
                if count > 0 then
                    counts.Seeds[seedName] = counts.Seeds[seedName] + count
                end
            end
            
            -- Check gears
            for _, gearName in ipairs(gearItems) do
                local count = getItemCount(child.Name, gearName)
                if count > 0 then
                    counts.Gears[gearName] = counts.Gears[gearName] + count
                end
            end
            
            -- Check eggs
            for _, eggName in ipairs(eggItems) do
                local count = getItemCount(child.Name, eggName)
                if count > 0 then
                    counts.Eggs[eggName] = counts.Eggs[eggName] + count
                end
            end
        end
    end)
    
    return counts
end

-- Save baseline backpack state on first execution
local function saveBaselineBackpack()
    pcall(function()
        local currentCounts = getCurrentBackpackCounts()
        
        -- Copy current counts to baseline
        for category, items in pairs(currentCounts) do
            for itemName, count in pairs(items) do
                baselineItemCounts[category][itemName] = count
                if count > 0 then
                    print("[BASELINE] " .. category .. " - " .. itemName .. ": " .. count)
                end
            end
        end
    end)
end

-- Calculate items gained during farming session
local function calculateGainedItems()
    pcall(function()
        local currentCounts = getCurrentBackpackCounts()
        
        -- Calculate difference for each item
        for category, items in pairs(currentCounts) do
            for itemName, currentCount in pairs(items) do
                local baselineCount = baselineItemCounts[category][itemName] or 0
                local gainedCount = currentCount - baselineCount
                
                -- Only update if positive (we gained items)
                if gainedCount >= 0 then
                    itemCounts[category][itemName] = gainedCount
                    updateUILabel(category, itemName, gainedCount)
                end
            end
        end
    end)
end

-- Auto farm loop using Heartbeat
local function startAutoFarm()
    pcall(function()
        RunService.Heartbeat:Connect(function()
            -- Reset UI display to 0
            resetUILabels()
            
            -- Fire all seeds at once (no delay)
            for _, seedName in ipairs(seedItems) do
                pcall(function()
                    BuySeedStock:FireServer("Shop", seedName)
                end)
            end
            
            -- Fire all gears at once (no delay)
            for _, gearName in ipairs(gearItems) do
                pcall(function()
                    BuyGearStock:FireServer(gearName)
                end)
            end
            
            -- Fire all eggs at once (no delay)
            for _, eggName in ipairs(eggItems) do
                pcall(function()
                    BuyPetEgg:FireServer(eggName)
                end)
            end
            
            -- Check backpack and calculate gained items
            calculateGainedItems()
        end)
    end)
end

-- ============================================
-- INITIALIZATION
-- ============================================

-- Create UI
pcall(function()
    createUI()
end)

-- Wait a moment for backpack to load
wait(0.5)

-- Save baseline backpack state on first execution
saveBaselineBackpack()

-- Start auto farm
spawn(function()
    startAutoFarm()
end)
