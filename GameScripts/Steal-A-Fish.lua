-- ========================================
-- MODULES
-- ========================================
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ProximityPromptService = game:GetService("ProximityPromptService")

local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

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
                wait(0.25)
                AutoLockSystem:TeleportToForcefield()
            end
        end
        wait(0.1)
    end
end)

-- ========================================
-- FAST INTERACTION SYSTEM
-- ========================================

-- Set all existing ProximityPrompts to instant
local function SetupFastInteraction()
    for _, prompt in pairs(Workspace:GetDescendants()) do
        if prompt:IsA("ProximityPrompt") then
            prompt.HoldDuration = 0
            prompt.KeyboardKeyCode = Enum.KeyCode.E
        end
    end
end

-- Monitor new ProximityPrompts
local function MonitorNewPrompts()
    Workspace.DescendantAdded:Connect(function(descendant)
        if descendant:IsA("ProximityPrompt") then
            descendant.HoldDuration = 0
            descendant.KeyboardKeyCode = Enum.KeyCode.E
        end
    end)
end

-- ========================================
-- NOCLIP WITH RAYCAST FLOOR SYSTEM
-- ========================================

local NoClipSystem = {}
NoClipSystem.connection = nil
NoClipSystem.floorConnection = nil
NoClipSystem.lastFloorY = nil

function NoClipSystem:SetupNoclip()
    -- Disable collision for character parts
    local function disableCollision()
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.CanCollide = false
            end
        end
        
        -- Keep HumanoidRootPart collision disabled too for true noclip
        if humanoidRootPart then
            humanoidRootPart.CanCollide = false
        end
    end
    
    -- Main noclip loop
    self.connection = RunService.Stepped:Connect(function()
        disableCollision()
    end)
end

function NoClipSystem:SetupFloorRaycast()
    -- Raycast floor detection to prevent falling
    self.floorConnection = RunService.Heartbeat:Connect(function()
        if not humanoidRootPart then return end
        
        -- Create raycast params
        local raycastParams = RaycastParams.new()
        raycastParams.FilterDescendantsInstances = {character}
        raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
        
        -- Raycast downward from player position
        local raycastResult = Workspace:Raycast(
            humanoidRootPart.Position,
            Vector3.new(0, -1000, 0),
            raycastParams
        )
        
        -- If we hit a floor and player is falling below it
        if raycastResult and raycastResult.Instance then
            local floorY = raycastResult.Position.Y
            local playerY = humanoidRootPart.Position.Y
            
            -- If player is falling below the floor level, snap them to floor + 5 studs
            if playerY < floorY - 10 then
                humanoidRootPart.Position = Vector3.new(
                    humanoidRootPart.Position.X,
                    floorY + 5,
                    humanoidRootPart.Position.Z
                )
                
                -- Reset velocity to prevent continued falling
                if humanoidRootPart.AssemblyLinearVelocity.Y < 0 then
                    humanoidRootPart.AssemblyLinearVelocity = Vector3.new(
                        humanoidRootPart.AssemblyLinearVelocity.X,
                        0,
                        humanoidRootPart.AssemblyLinearVelocity.Z
                    )
                end
            end
            
            self.lastFloorY = floorY
        elseif self.lastFloorY then
            -- No floor detected but we had one before, use last known floor
            local playerY = humanoidRootPart.Position.Y
            if playerY < self.lastFloorY - 10 then
                humanoidRootPart.Position = Vector3.new(
                    humanoidRootPart.Position.X,
                    self.lastFloorY + 5,
                    humanoidRootPart.Position.Z
                )
            end
        end
    end)
end

-- ========================================
-- CHARACTER RESPAWN HANDLING
-- ========================================

local function OnCharacterAdded(newCharacter)
    character = newCharacter
    humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    humanoid = character:WaitForChild("Humanoid")
    
    -- Wait a moment for character to fully load
    wait(1)
    
    -- Restart noclip system
    NoClipSystem:SetupNoclip()
    NoClipSystem:SetupFloorRaycast()
    
    print("[NOCLIP] Reapplied to new character")
end

-- ========================================
-- INITIALIZATION
-- ========================================

-- Setup fast interaction
SetupFastInteraction()
MonitorNewPrompts()

-- Setup noclip with floor detection
NoClipSystem:SetupNoclip()
NoClipSystem:SetupFloorRaycast()

-- Handle character respawning
localPlayer.CharacterAdded:Connect(OnCharacterAdded)
