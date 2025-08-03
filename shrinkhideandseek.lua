-- Load UI

local PickleLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/pickletalk/Scripts-Hub-X/refs/heads/main/PickleLibrary.lua"))()

local window = PickleLibrary:Load("Shrink Hide And Seek", "Default")
local tab = window.newTab("Scripts")
local window = Color3.fromRGB(30, 60, 120)
local tab = Color3.fromRGB(20, 40, 80)

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

-- Infinite Jump
tab.newButton("Inf Jump", "Inf Jump Enabled!", function(toggle)
        enableInfiniteJump(not isInfiniteJumpEnabled)
end)

-- ESP Button
tab.newButton("Esp", "Prints ESP Enabled!", function() loadstring(game:HttpGet('https://raw.githubusercontent.com/Lucasfin000/SpaceHub/main/UESP'))()

    print('ESP Enabled!')

end)

-- Noclip toggle logic

local noclipConnection

tab.newToggle("NoClip", "Toggle! (prints the state)", true, function(toggleState)

    local player = game.Players.LocalPlayer

    local runService = game:GetService("RunService")

    if toggleState then

        print("On")

        -- Enable noclip

        noclipConnection = runService.Stepped:Connect(function()

            local character = player.Character

            if character then

                for _, part in pairs(character:GetDescendants()) do

                    if part:IsA("BasePart") and part.CanCollide then

                        part.CanCollide = false

                    end

                end

            end

        end)

    else

        print("Off")

        -- Disable noclip

        if noclipConnection then

            noclipConnection:Disconnect()

            noclipConnection = nil

        end

        local character = player.Character

        if character then

            for _, part in pairs(character:GetDescendants()) do

                if part:IsA("BasePart") then

                    part.CanCollide = true

                end

            end

        end

    end

end)

-- Slider

tab.newSlider("WalkSpeed", "Normal: WalkSpeed Roblox normal = 16", 100, false, function(speed)

    local player = game.Players.LocalPlayer

    local character = player.Character or player.CharacterAdded:Wait()

    local humanoid = character:FindFirstChildOfClass("Humanoid")

    if humanoid then

        humanoid.WalkSpeed = speed

        print("WalkSpeed set to:", speed)

    end

end)
