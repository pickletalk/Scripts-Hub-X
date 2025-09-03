-- ========================================
-- AUTO LOCK SYSTEM & ESP
-- ========================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

-- ========================================
-- CONFIGURATION
-- ========================================

local AUTO_LOCK_ENABLED = true
local ESP_ENABLED = true
local CHECK_INTERVAL = 0.1

-- ========================================
-- ESP MODULE
-- ========================================

local ESPModule = {}
ESPModule.ESPObjects = {}

function ESPModule:CreateESP(tycoonName, part, text, color)
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Name = "ForceFieldESP_" .. tycoonName
    billboardGui.Adornee = part
    billboardGui.Size = UDim2.new(0, 100, 0, 50)
    billboardGui.StudsOffset = Vector3.new(0, 3, 0)
    billboardGui.AlwaysOnTop = true
    billboardGui.Parent = playerGui

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
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

function ESPModule:RemoveAllESP()
    for tycoonName, _ in pairs(self.ESPObjects) do
        self:RemoveESP(tycoonName)
    end
end

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
        local tycoonPath = Workspace.Map.Tycoons:FindChild(tycoonName)
        
        if tycoonPath then
            local boardPath = tycoonPath:FindChild("Tycoon")
            if boardPath then
                boardPath = boardPath:FindChild("Board")
                if boardPath then
                    boardPath = boardPath:FindChild("Board")
                    if boardPath then
                        local surfaceGui = boardPath:FindChild("SurfaceGui")
                        if surfaceGui then
                            local usernameLabel = surfaceGui:FindChild("Username")
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
    local tycoonPath = Workspace.Map.Tycoons:FindChild(tycoonName)
    if not tycoonPath then return nil end
    
    local forcefieldPath = tycoonPath:FindChild("Tycoon")
    if forcefieldPath then
        forcefieldPath = forcefieldPath:FindChild("ForcefieldFolder")
        if forcefieldPath then
            forcefieldPath = forcefieldPath:FindChild("Screen")
            if forcefieldPath then
                forcefieldPath = forcefieldPath:FindChild("Screen")
                if forcefieldPath then
                    local surfaceGui = forcefieldPath:FindChild("SurfaceGui")
                    if surfaceGui then
                        local timeLabel = surfaceGui:FindChild("Time")
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
    
    local tycoonPath = Workspace.Map.Tycoons:FindChild(self.playerTycoon)
    if not tycoonPath then return end
    
    local forcefieldButton = tycoonPath:FindChild("Tycoon")
    if forcefieldButton then
        forcefieldButton = forcefieldButton:FindChild("ForcefieldFolder")
        if forcefieldButton then
            forcefieldButton = forcefieldButton:FindChild("Buttons")
            if forcefieldButton then
                forcefieldButton = forcefieldButton:FindChild("ForceFieldBuy")
                if forcefieldButton then
                    forcefieldButton = forcefieldButton:FindChild("Forcefield")
                    if forcefieldButton and localPlayer.Character and localPlayer.Character:FindChild("HumanoidRootPart") then
                        self.isLocking = true
                        self.oldPosition = localPlayer.Character.HumanoidRootPart.CFrame
                        
                        print("[AUTO LOCK] Teleporting to forcefield button...")
                        localPlayer.Character.HumanoidRootPart.CFrame = forcefieldButton.CFrame
                        
                        wait(0.4)
                        
                        if self.oldPosition and localPlayer.Character and localPlayer.Character:FindChild("HumanoidRootPart") then
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

function AutoLockSystem:CheckAndLock()
    if not AUTO_LOCK_ENABLED or not self.playerTycoon then return end
    
    local timeText = self:GetForceFieldTime(self.playerTycoon)
    if timeText == "0s" then
        wait(0.5)
        self:TeleportToForcefield()
    end
end

-- ========================================
-- ESP SYSTEM
-- ========================================

local function UpdateESP()
    if not ESP_ENABLED then return end
    
    for i = 1, 8 do
        local tycoonName = "Tycoon" .. i
        local tycoonPath = Workspace.Map.Tycoons:FindChild(tycoonName)
        
        if tycoonPath then
            local timeText = AutoLockSystem:GetForceFieldTime(tycoonName)
            
            if timeText then
                local screenPath = tycoonPath:FindChild("Tycoon")
                if screenPath then
                    screenPath = screenPath:FindChild("ForcefieldFolder")
                    if screenPath then
                        screenPath = screenPath:FindChild("Screen")
                        if screenPath then
                            screenPath = screenPath:FindChild("Screen")
                            
                            if screenPath then
                                -- Parse time to determine color
                                local timeNumber = tonumber(timeText:match("(%d+)"))
                                local color = Color3.new(1, 1, 0) -- Yellow default
                                
                                if timeNumber and timeNumber <= 10 then
                                    color = Color3.new(1, 0, 0) -- Red
                                end
                                
                                local displayText = tycoonName .. "\n" .. timeText
                                
                                if not ESPModule.ESPObjects[tycoonName] then
                                    ESPModule:CreateESP(tycoonName, screenPath, displayText, color)
                                else
                                    ESPModule:UpdateESP(tycoonName, displayText, color)
                                end
                            end
                        end
                    end
                end
            end
        else
            -- Remove ESP if tycoon no longer exists
            ESPModule:RemoveESP(tycoonName)
        end
    end
end

-- ========================================
-- MAIN EXECUTION
-- ========================================

print("[AUTO LOCK & ESP] Initializing system...")

-- Find player tycoon on startup
spawn(function()
    while not AutoLockSystem.playerTycoon do
        AutoLockSystem:FindPlayerTycoon()
        if not AutoLockSystem.playerTycoon then
            wait(1)
        end
    end
end)

-- Main loop
spawn(function()
    while true do
        if AUTO_LOCK_ENABLED then
            AutoLockSystem:CheckAndLock()
        end
        
        if ESP_ENABLED then
            UpdateESP()
        end
        
        wait(CHECK_INTERVAL)
    end
end)
