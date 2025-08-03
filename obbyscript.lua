local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Fluent " .. Fluent.Version,
    SubTitle = "by dawid",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false, -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.LeftControl -- Used when theres no MinimizeKeybind
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "layers" }),
    Player = Window:AddTab({ Title = "Player", Icon = "person-standing" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

-- Infinite Jump Script
-- by pickletalk

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Configuration
local player = Players.LocalPlayer
local isInfiniteJumpEnabled = false

local function getOriginalJumpPower()
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    return humanoid.JumpPower
end

local function createNotification()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    screenGui.Name = "InfiniteJumpNotification"

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 200, 0, 0) -- Start with zero height
    frame.Position = UDim2.new(0.5, -100, 0.9, -40) -- Adjusted position for upward growth
    frame.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    frame.BorderSizePixel = 0
    frame.Parent = screenGui

    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 10) -- Smooth edges with 10px radius
    uiCorner.Parent = frame

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = "Successful Infinite Jump"
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.TextSize = 16
    textLabel.Parent = frame

    -- Grow upward animation
    local tweenIn = TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 200, 0, 40)})
    tweenIn:Play()

    -- Destroy after 1 second of visibility + 1 second shrink animation
    wait(1)
    local tweenOut = TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, 200, 0, 0)})
    tweenOut:Play()
    tweenOut.Completed:Connect(function()
        wait(0.5) -- Wait for shrink to complete
        screenGui:Destroy()
    end)
end

local function enableInfiniteJump(toggle)
    if isInfiniteJumpEnabled == toggle then
        return -- No action if state matches
    end

    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    local originalJumpPower = getOriginalJumpPower()
    local JUMP_POWER = originalJumpPower -- Use game's original jump power as base

    if toggle then
        isInfiniteJumpEnabled = true
        local connection
        connection = UserInputService.JumpRequest:Connect(function()
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
                if rootPart then
                    local bodyVelocity = Instance.new("BodyVelocity")
                    bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
                    bodyVelocity.Velocity = Vector3.new(0, JUMP_POWER, 0)
                    bodyVelocity.Parent = rootPart
                    game:GetService("Debris"):AddItem(bodyVelocity, 0.2)
                end
            end
        end)
        
        -- Ensure infinite jump persists on character removal
        local characterRemovedConnection = player.CharacterRemoving:Connect(function()
            if connection then
                connection:Disconnect()
            end
        end)
        
        -- Reconnect on character respawn
        player.CharacterAdded:Connect(function(newCharacter)
            character = newCharacter
            humanoid = character:WaitForChild("Humanoid")
            originalJumpPower = getOriginalJumpPower()
            JUMP_POWER = originalJumpPower
            if isInfiniteJumpEnabled then
                connection = UserInputService.JumpRequest:Connect(function()
                    if player.Character and player.Character:FindFirstChild("Humanoid") then
                        local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
                        if rootPart then
                            local bodyVelocity = Instance.new("BodyVelocity")
                            bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
                            bodyVelocity.Velocity = Vector3.new(0, JUMP_POWER, 0)
                            bodyVelocity.Parent = rootPart
                            game:GetService("Debris"):AddItem(bodyVelocity, 0.2)
                        end
                    end
                end)
                characterRemovedConnection:Disconnect()
                characterRemovedConnection = player.CharacterRemoving:Connect(function()
                    if connection then
                        connection:Disconnect()
                    end
                end)
            end
        end)
        
        -- Show notification when enabled
        createNotification()
    else
        isInfiniteJumpEnabled = false

        for _, connection in pairs(getconnections(UserInputService.JumpRequest)) do
            if connection.Function then
                connection:Disable()
            end
        end
        humanoid.JumpPower = originalJumpPower -- Restore original jump power
        if player.Character then
            local humanoid = player.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.JumpPower = originalJumpPower
            end
        end
    end
end

Tabs.Main:AddButton({
    Title = "Inf Junp",
    Description = "Infinite Jump",
    Callback = function(toggle)
        enableInfiniteJump(toggle)
      createNotification()
    end
})

local Slider = Tabs.Player:AddSlider("Slider", 
{
    Title = "Player Speed",
    Description = "Makes Player Set Their Speed",
    Default = 16,
    Min = 16,
    Max = 100,
    Rounding = 1,
    Callback = function(Value)
        if Humanoid then
            Humanoid.WalkSpeed = Value
        end
    end
})

-- Handle character respawns
Player.CharacterAdded:Connect(function(newCharacter)
    Character = newCharacter
    Humanoid = newCharacter:WaitForChild("Humanoid")
    -- Apply current speed when new character spawns
    Humanoid.WalkSpeed = Slider:GetValue()
end)
