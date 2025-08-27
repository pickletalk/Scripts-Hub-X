-- =========================================================
-- Steal A Brainrot (Player Spawnpoint Detection)
-- =========================================================
local player = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Function to find the player's actual spawnpoint
local function findPlayerSpawnpoint()
    local spawnCFrame = nil
    
    -- Look for the player's spawn in Teams service
    local Teams = game:GetService("Teams")
    if player.Team and player.Team.SpawnLocations then
        for _, spawn in pairs(player.Team.SpawnLocations:GetChildren()) do
            if spawn:IsA("SpawnLocation") and spawn.Enabled then
                spawnCFrame = spawn.CFrame + Vector3.new(0, spawn.Size.Y/2 + 3, 0)
                break
            end
        end
    end
    
    -- If no team spawn found, look for neutral spawns assigned to this player
    if not spawnCFrame then
        for _, spawn in pairs(workspace:GetDescendants()) do
            if spawn:IsA("SpawnLocation") and spawn.Enabled then
                -- Check if this spawn is for all players or specifically this player
                if spawn.AllowTeamChangeOnTouch == false or spawn.TeamColor == BrickColor.new("Medium stone grey") then
                    spawnCFrame = spawn.CFrame + Vector3.new(0, spawn.Size.Y/2 + 3, 0)
                    break
                end
            end
        end
    end
    
    -- Last resort: find any enabled spawn
    if not spawnCFrame then
        for _, spawn in pairs(workspace:GetDescendants()) do
            if spawn:IsA("SpawnLocation") and spawn.Enabled then
                spawnCFrame = spawn.CFrame + Vector3.new(0, spawn.Size.Y/2 + 3, 0)
                break
            end
        end
    end
    
    -- Ultimate fallback
    if not spawnCFrame then
        spawnCFrame = CFrame.new(0, 50, 0)
    end
    
    return spawnCFrame
end

-- ========================================
-- PLOT TELEPORTER UI
-- ========================================
local playerGui = player:WaitForChild("PlayerGui")

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PlotTeleporterUI"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 250, 0, 120)
mainFrame.Position = UDim2.new(1, -260, 0, 10)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = mainFrame

-- Title Bar
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
titleText.Text = "💰 SHADOW HEIST 💰"
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

local teleportButton = Instance.new("TextButton")
teleportButton.Name = "TeleportButton"
teleportButton.Size = UDim2.new(0, 220, 0, 35)
teleportButton.Position = UDim2.new(0, 15, 0, 45)
teleportButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
teleportButton.Text = "💰 STEAL 💰"
teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportButton.TextScaled = true
teleportButton.Font = Enum.Font.GothamBold
teleportButton.BorderSizePixel = 0
teleportButton.Parent = mainFrame

local teleportCorner = Instance.new("UICorner")
teleportCorner.CornerRadius = UDim.new(0, 6)
teleportCorner.Parent = teleportButton

local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "StatusLabel"
statusLabel.Size = UDim2.new(1, -20, 0, 25)
statusLabel.Position = UDim2.new(0, 10, 0, 90)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "by PickleTalk"
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = mainFrame

-- Dragging functionality
local dragging = false
local dragStart = nil
local startPos = nil

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Close button functionality
closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- =========================================================
-- Teleport to Player's Spawnpoint
-- =========================================================
local teleporting = false

local function teleportToSpawn()
    if teleporting then return end
    teleporting = true

    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")

    if not hrp or not hum then
        statusLabel.Text = "⚠ Character not ready"
        teleporting = false
        return
    end

    -- Find the player's actual spawnpoint
    local spawnCFrame = findPlayerSpawnpoint()
    
    teleportButton.Text = "💰 STEALING 💰"

    local targetPos = spawnCFrame.Position + (spawnCFrame.LookVector * 5)
    local offset = targetPos - hrp.Position
    local dist = offset.Magnitude
    local steps = math.max(20, math.floor(dist / 2))
    local step = offset.Unit * 2

    for i = 1, steps do
        if not hrp.Parent or not hum.Parent then break end
        hrp.CFrame = hrp.CFrame + step
        hum:Move(Vector3.new(step.X, 0, step.Z), true)
        task.wait(0.05)
    end

    -- Show "DONE CUH" message
    teleportButton.Text = "🎉 DONE CUH 🎉"
    
    -- Wait 1 second then revert back
    task.wait(1)
    teleportButton.Text = "💰 STEAL 💰"
    statusLabel.Text = "by PickleTalk"
    teleporting = false
end

teleportButton.MouseButton1Click:Connect(teleportToSpawn)

-- =========================================================
-- Infinite Jump
-- =========================================================
local isInfiniteJumpEnabled = false
local jumpConnections = {}

local function createJumpNotification()
    local sg = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
    sg.Name = "InfiniteJumpNotification"
    local frame = Instance.new("Frame", sg)
    frame.Size = UDim2.new(0, 200, 0, 0)
    frame.Position = UDim2.new(0.5, -100, 0.9, -40)
    frame.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    frame.BorderSizePixel = 0
    local textLabel = Instance.new("TextLabel", frame)
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = "Infinite Jump Enabled"
    textLabel.TextColor3 = Color3.new(1,1,1)
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.TextSize = 16
    local tweenIn = TweenService:Create(frame, TweenInfo.new(0.5), {Size = UDim2.new(0, 200, 0, 40)})
    tweenIn:Play()
    task.spawn(function()
        task.wait(2)
        local tweenOut = TweenService:Create(frame, TweenInfo.new(0.5), {Size = UDim2.new(0,200,0,0)})
        tweenOut:Play()
        tweenOut.Completed:Connect(function() sg:Destroy() end)
    end)
end

local function connectInfiniteJump()
    return UserInputService.JumpRequest:Connect(function()
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)
end

local function enableInfiniteJump()
    if isInfiniteJumpEnabled then return end
    isInfiniteJumpEnabled = true
    if player.Character then
        table.insert(jumpConnections, connectInfiniteJump())
    end
    player.CharacterAdded:Connect(function()
        task.wait(0.1)
        if isInfiniteJumpEnabled then
            table.insert(jumpConnections, connectInfiniteJump())
        end
    end)
    createJumpNotification()
end
enableInfiniteJump()

-- =========================================================
-- Smart Noclip (raycast forward)
-- =========================================================
local noclipActive = false
local function setCollisions(char, state)
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = state
        end
    end
end

RunService.Heartbeat:Connect(function()
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not (hrp and hum) then return end

    local dir = hum.MoveDirection
    if dir.Magnitude > 0 then
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Blacklist
        params.FilterDescendantsInstances = {char}
        local result = workspace:Raycast(hrp.Position, dir.Unit * 3, params)
        if result and result.Instance and result.Instance.CanCollide then
            if not noclipActive then
                noclipActive = true
                setCollisions(char, false)
            end
        else
            if noclipActive then
                noclipActive = false
                setCollisions(char, true)
            end
        end
    else
        if noclipActive then
            noclipActive = false
            setCollisions(char, true)
        end
    end
end)
