-- ========================================
-- MODULES
-- ========================================
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

-- ========================================
-- AUTO LOCK SYSTEM
-- ========================================

local AutoLockSystem = {}
AutoLockSystem.playerTycoon = nil
AutoLockSystem.oldPosition = nil
AutoLockSystem.isLocking = false

function AutoLockSystem:FindPlayerTycoon()
    local username = localPlayer.Name
    
    for i = 1, 8 do
        local tycoonName = "Tycoon" .. i
        local tycoonPath = Workspace.Map.Tycoons:FindFirstChild(tycoonName)
        
        if tycoonPath then
            local tycoonFolder = tycoonPath:FindFirstChild("Tycoon")
            if tycoonFolder then
                local board = tycoonFolder:FindFirstChild("Board")
                if board then
                    local boardPart = board:FindFirstChild("Board")
                    if boardPart then
                        local surfaceGui = boardPart:FindFirstChild("SurfaceGui")
                        if surfaceGui then
                            local usernameLabel = surfaceGui:FindFirstChild("Username")
                            if usernameLabel and usernameLabel.Text == username then
                                self.playerTycoon = tycoonName
                                print("[AUTO LOCK] Found player tycoon:", tycoonName)
                                return tycoonName
                            end
                        end
                    end
                end
            end
        end
    end
    
    return nil
end

function AutoLockSystem:GetForceFieldTime(tycoonName)
    local tycoonPath = Workspace.Map.Tycoons:FindFirstChild(tycoonName)
    if not tycoonPath then return nil end
    
    local tycoonFolder = tycoonPath:FindFirstChild("Tycoon")
    if tycoonFolder then
        local forcefieldFolder = tycoonFolder:FindFirstChild("ForcefieldFolder")
        if forcefieldFolder then
            local screen = forcefieldFolder:FindFirstChild("Screen")
            if screen then
                local screenPart = screen:FindFirstChild("Screen")
                if screenPart then
                    local surfaceGui = screenPart:FindFirstChild("SurfaceGui")
                    if surfaceGui then
                        local timeLabel = surfaceGui:FindFirstChild("Time")
                        if timeLabel then
                            return timeLabel.Text
                        end
                    end
                end
            end
        end
    end
    
    return nil
end

function AutoLockSystem:TeleportToForcefield()
    if not self.playerTycoon or self.isLocking then return end
    
    local tycoonPath = Workspace.Map.Tycoons:FindFirstChild(self.playerTycoon)
    if not tycoonPath then return end
    
    local tycoonFolder = tycoonPath:FindFirstChild("Tycoon")
    if tycoonFolder then
        local forcefieldFolder = tycoonFolder:FindFirstChild("ForcefieldFolder")
        if forcefieldFolder then
            local buttons = forcefieldFolder:FindFirstChild("Buttons")
            if buttons then
                local forceFieldBuy = buttons:FindFirstChild("ForceFieldBuy")
                if forceFieldBuy then
                    local forcefield = forceFieldBuy:FindFirstChild("Forcefield")
                    if forcefield and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        self.isLocking = true
                        self.oldPosition = localPlayer.Character.HumanoidRootPart.CFrame
                        
                        print("[AUTO LOCK] Teleporting to forcefield button...")
                        -- Teleport 6 studs above the target
                        local targetCFrame = forcefield.CFrame + Vector3.new(0, 4, 0)
                        localPlayer.Character.HumanoidRootPart.CFrame = targetCFrame
                        
                        wait(0.4)
                        
                        if self.oldPosition and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            print("[AUTO LOCK] Teleporting back to original position...")
                            localPlayer.Character.HumanoidRootPart.CFrame = self.oldPosition
                        end
                        
                        self.isLocking = false
                    end
                end
            end
        end
    end
end

-- Find player tycoon
spawn(function()
    while not AutoLockSystem.playerTycoon do
        AutoLockSystem:FindPlayerTycoon()
        if not AutoLockSystem.playerTycoon then
            wait(1)
        end
    end
end)

-- Main auto lock loop
spawn(function()
    while true do
        if AutoLockSystem.playerTycoon then
            local timeText = AutoLockSystem:GetForceFieldTime(AutoLockSystem.playerTycoon)
            if timeText == "0s" then
                wait(0.3)
                AutoLockSystem:TeleportToForcefield()
            end
        end
        wait(0.1)
    end
end)

-- ========================================
-- ESP SYSTEM
-- ========================================

local ESPModule = {}
ESPModule.ESPObjects = {}

function ESPModule:CreateESP(tycoonName, part, text, color)
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Name = "ForceFieldESP_" .. tycoonName
    billboardGui.Adornee = part
    billboardGui.Size = UDim2.new(1, 0, 0.5, 0)
    billboardGui.StudsOffset = Vector3.new(0, 3, 0)
    billboardGui.AlwaysOnTop = true
    billboardGui.Parent = part

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 0.5, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text
    textLabel.TextColor3 = color
    textLabel.TextScaled = true
    textLabel.TextStrokeTransparency = 0
    textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    textLabel.Font = Enum.Font.GothamBold
    textLabel.Parent = billboardGui

    self.ESPObjects[tycoonName] = {
        gui = billboardGui,
        label = textLabel
    }

    return billboardGui, textLabel
end

function ESPModule:UpdateESP(tycoonName, text, color)
    local espObj = self.ESPObjects[tycoonName]
    if espObj and espObj.label then
        espObj.label.Text = text
        espObj.label.TextColor3 = color
    end
end

function ESPModule:RemoveESP(tycoonName)
    local espObj = self.ESPObjects[tycoonName]
    if espObj and espObj.gui then
        espObj.gui:Destroy()
        self.ESPObjects[tycoonName] = nil
    end
end

local function GetForceFieldTime(tycoonName)
    local tycoonPath = Workspace.Map.Tycoons:FindFirstChild(tycoonName)
    if not tycoonPath then return nil end
    
    local tycoonFolder = tycoonPath:FindFirstChild("Tycoon")
    if tycoonFolder then
        local forcefieldFolder = tycoonFolder:FindFirstChild("ForcefieldFolder")
        if forcefieldFolder then
            local screen = forcefieldFolder:FindFirstChild("Screen")
            if screen then
                local screenPart = screen:FindFirstChild("Screen")
                if screenPart then
                    local surfaceGui = screenPart:FindFirstChild("SurfaceGui")
                    if surfaceGui then
                        local timeLabel = surfaceGui:FindFirstChild("Time")
                        if timeLabel then
                            return timeLabel.Text, screenPart
                        end
                    end
                end
            end
        end
    end
    
    return nil, nil
end

local function UpdateESP()
    for i = 1, 8 do
        local tycoonName = "Tycoon" .. i
        local timeText, screenPart = GetForceFieldTime(tycoonName)
        
        if timeText and screenPart then
            -- Parse time to determine color
            local timeNumber = string.match(timeText, "(%d+)")
            timeNumber = tonumber(timeNumber)
            
            local color = Color3.new(1, 1, 0) -- Yellow default
            
            if timeNumber and timeNumber <= 10 then
                color = Color3.new(1, 0, 0) -- Red
            end
            
            local displayText = i .. "\n" .. timeText
            
            if not ESPModule.ESPObjects[tycoonName] then
                ESPModule:CreateESP(tycoonName, screenPart, displayText, color)
            else
                ESPModule:UpdateESP(tycoonName, displayText, color)
            end
        else
            -- Remove ESP if no time found
            if ESPModule.ESPObjects[tycoonName] then
                ESPModule:RemoveESP(tycoonName)
            end
        end
    end
end

-- Main ESP loop
spawn(function()
    while true do
        UpdateESP()
        wait(0.1)
    end
end)

print("[AUTO LOCK & ESP] System loaded!")
