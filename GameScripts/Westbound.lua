-- Westbound Game Cheat Script
-- Features: Godmode, Noclip, Speed, Infinite Jump, Invisibility, Respawn Handler

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Cheat Configuration
local config = {
    godMode = true,
    noClip = true,
    speed = 60,
    infiniteJump = true,
    invisible = true,
    enabled = true
}

-- State Variables
local connections = {}
local originalValues = {}
local jumpCount = 0
local maxJumps = math.huge

-- Store original values
originalValues.walkSpeed = humanoid.WalkSpeed
originalValues.jumpPower = humanoid.JumpPower
originalValues.health = humanoid.MaxHealth

-- Godmode Function
local function enableGodMode()
    if not config.godMode then return end
    
    humanoid.MaxHealth = math.huge
    humanoid.Health = math.huge
    
    -- Prevent damage
    connections.godMode = humanoid.HealthChanged:Connect(function()
        if humanoid.Health < humanoid.MaxHealth then
            humanoid.Health = humanoid.MaxHealth
        end
    end)
end

-- Noclip Function
local function enableNoClip()
    if not config.noClip then return end
    
    connections.noClip = RunService.Stepped:Connect(function()
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") and part ~= rootPart then
                part.CanCollide = false
            end
        end
        rootPart.CanCollide = false
    end)
end

-- Speed Boost Function
local function enableSpeedBoost()
    if not config.speed then return end
    humanoid.WalkSpeed = config.speed
end

-- Infinite Jump Function
local function enableInfiniteJump()
    if not config.infiniteJump then return end
    
    connections.infiniteJump = UserInputService.JumpRequest:Connect(function()
        if config.infiniteJump then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)
    
    -- Alternative jump method
    connections.jumpInput = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Enum.KeyCode.Space and config.infiniteJump then
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
            bodyVelocity.Velocity = Vector3.new(0, 50, 0)
            bodyVelocity.Parent = rootPart
            
            game:GetService("Debris"):AddItem(bodyVelocity, 0.1)
        end
    end)
end

-- Invisibility Function
local function enableInvisibility()
    if not config.invisible then return end
    
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") and part ~= rootPart then
            part.Transparency = 1
        elseif part:IsA("Accessory") then
            part.Handle.Transparency = 1
        end
    end
    
    -- Make face invisible
    local head = character:FindFirstChild("Head")
    if head then
        local face = head:FindFirstChild("face")
        if face then
            face.Transparency = 1
        end
    end
end

-- Visibility Function (to toggle back)
local function disableInvisibility()
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") and part ~= rootPart then
            part.Transparency = 0
        elseif part:IsA("Accessory") then
            part.Handle.Transparency = 0
        end
    end
    
    local head = character:FindFirstChild("Head")
    if head then
        local face = head:FindFirstChild("face")
        if face then
            face.Transparency = 0
        end
    end
end

-- Character Respawn Handler
local function setupRespawnHandler()
    player.CharacterAdded:Connect(function(newCharacter)
        character = newCharacter
        humanoid = character:WaitForChild("Humanoid")
        rootPart = character:WaitForChild("HumanoidRootPart")
        
        -- Wait a moment for character to fully load
        wait(1)
        
        -- Re-apply all cheats
        if config.enabled then
            enableAllCheats()
        end
    end)
end

-- Enable All Cheats Function
function enableAllCheats()
    -- Clear existing connections
    for _, connection in pairs(connections) do
        if connection then
            connection:Disconnect()
        end
    end
    connections = {}
    
    -- Enable features
    if config.godMode then enableGodMode() end
    if config.noClip then enableNoClip() end
    if config.speed then enableSpeedBoost() end
    if config.infiniteJump then enableInfiniteJump() end
    if config.invisible then enableInvisibility() end
    
    print("Westbound cheats enabled!")
end

-- Disable All Cheats Function
function disableAllCheats()
    -- Disconnect all connections
    for _, connection in pairs(connections) do
        if connection then
            connection:Disconnect()
        end
    end
    connections = {}
    
    -- Restore original values
    humanoid.WalkSpeed = originalValues.walkSpeed
    humanoid.JumpPower = originalValues.jumpPower
    humanoid.MaxHealth = originalValues.health
    humanoid.Health = originalValues.health
    
    -- Restore visibility
    disableInvisibility()
    
    -- Re-enable collision
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            part.CanCollide = true
        end
    end
    
    print("Westbound cheats disabled!")
end

-- Toggle Functions
local function toggleGodMode()
    config.godMode = not config.godMode
    print("Godmode:", config.godMode and "ON" or "OFF")
    if config.enabled then enableAllCheats() end
end

local function toggleNoClip()
    config.noClip = not config.noClip
    print("Noclip:", config.noClip and "ON" or "OFF")
    if config.enabled then enableAllCheats() end
end

local function toggleInvisibility()
    config.invisible = not config.invisible
    print("Invisibility:", config.invisible and "ON" or "OFF")
    if config.enabled then 
        if config.invisible then
            enableInvisibility()
        else
            disableInvisibility()
        end
    end
end

local function toggleInfiniteJump()
    config.infiniteJump = not config.infiniteJump
    print("Infinite Jump:", config.infiniteJump and "ON" or "OFF")
    if config.enabled then enableAllCheats() end
end

-- Anti-Detection (Basic)
local function setupAntiDetection()
    -- Hide script presence
    connections.antiDetection = RunService.Heartbeat:Connect(function()
        -- Basic anti-detection measures
        if humanoid.WalkSpeed ~= config.speed and config.enabled then
            humanoid.WalkSpeed = config.speed
        end
    end)
end

enableAllCheats()

-- Handle character updates
if character then
    enableAllCheats()
else
    player.CharacterAdded:Connect(function()
        wait(1)
        enableAllCheats()
    end)
end
