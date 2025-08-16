-- =========================================================
-- Steal A Brainrot GUI
-- =========================================================
local player = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.Name = "BrainrotGui"

-- Main frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 120)
frame.Position = UDim2.new(0.5, -110, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(150, 150, 150)
frame.Parent = screenGui
frame.Active = true
frame.Draggable = true

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "Steal A Brainrot"
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(220, 220, 220)
title.Parent = frame

-- Steal button
local teleportButton = Instance.new("TextButton")
teleportButton.Size = UDim2.new(0, 160, 0, 40)
teleportButton.Position = UDim2.new(0.5, -80, 0.5, -20)
teleportButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
teleportButton.BorderSizePixel = 2
teleportButton.BorderColor3 = Color3.fromRGB(150, 150, 150)
teleportButton.Text = "Steal"
teleportButton.Font = Enum.Font.SourceSansBold
teleportButton.TextSize = 18
teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportButton.Parent = frame

-- Status label
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 20)
statusLabel.Position = UDim2.new(0, 0, 1, -20)
statusLabel.BackgroundTransparency = 1
statusLabel.Font = Enum.Font.SourceSans
statusLabel.TextSize = 14
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.Text = "Ready."
statusLabel.Parent = frame

-- Credits
local credits = Instance.new("TextLabel")
credits.Size = UDim2.new(1, 0, 0, 15)
credits.Position = UDim2.new(0, 0, 1, 0)
credits.BackgroundTransparency = 1
credits.Font = Enum.Font.SourceSansItalic
credits.TextSize = 12
credits.TextColor3 = Color3.fromRGB(130, 130, 130)
credits.Text = "by PickleTalk"
credits.Parent = frame

-- =========================================================
-- Teleport to Spawnpoint + 5 studs forward
-- =========================================================
local teleporting = false

local function teleportToSpawn()
    if teleporting then return end
    teleporting = true

    local char = player.Character
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
    local hum  = char and char:FindFirstChildOfClass("Humanoid")
    local spawn = player.RespawnLocation

    if not hrp or not hum then
        statusLabel.Text = "⚠ Character not ready"
        teleporting = false; return
    end
    if not spawn then
        statusLabel.Text = "⚠ Spawn not found"
        teleporting = false; return
    end

    teleportButton.Text = "Stealing..."
    statusLabel.Text = "Moving to spawn…"

    -- 5 studs forward from spawn
    local targetPos = spawn.CFrame.Position + (spawn.CFrame.LookVector * 5)

    -- Step move
    local offset = targetPos - hrp.Position
    local dist = offset.Magnitude
    local steps = math.max(20, math.floor(dist / 2))
    local step = offset.Unit * 2

    for i = 1, steps do
        if not hrp.Parent or not hum.Parent then 
            statusLabel.Text = "⚠ Character lost"
            break 
        end
        hrp.CFrame = hrp.CFrame + step
        hum:Move(Vector3.new(step.X, 0, step.Z), true)
        task.wait(0.05)
    end

    teleportButton.Text = "Steal"
    statusLabel.Text = "✅ At spawnpoint!"
    teleporting = false
end

teleportButton.MouseButton1Click:Connect(teleportToSpawn)

-- =========================================================
-- Infinite Jump (your version with notification)
-- =========================================================
local isInfiniteJumpEnabled = false
local jumpConnections = {}

local function createJumpNotification()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = player:WaitForChild("PlayerGui")
    screenGui.Name = "InfiniteJumpNotification"

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 200, 0, 0)
    frame.Position = UDim2.new(0.5, -100, 0.9, -40)
    frame.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    frame.BorderSizePixel = 0
    frame.Parent = screenGui

    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 10)
    uiCorner.Parent = frame

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = "Infinite Jump Enabled"
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.TextSize = 16
    textLabel.Parent = frame

    local tweenIn = TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 200, 0, 40)})
    tweenIn:Play()

    task.spawn(function()
        wait(2)
        local tweenOut = TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, 200, 0, 0)})
        tweenOut:Play()
        tweenOut.Completed:Connect(function()
            wait(0.5)
            screenGui:Destroy()
        end)
    end)
end

local function connectInfiniteJump()
    return UserInputService.JumpRequest:Connect(function()
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            local hum = player.Character:FindFirstChild("Humanoid")
            local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
            if rootPart and hum and hum.Health > 0 then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end)
end

local function enableInfiniteJump()
    if isInfiniteJumpEnabled then return end
    isInfiniteJumpEnabled = true

    -- Connect now
    if player.Character then
        table.insert(jumpConnections, connectInfiniteJump())
    end

    -- Handle respawn
    player.CharacterAdded:Connect(function()
        wait(0.1)
        if isInfiniteJumpEnabled then
            table.insert(jumpConnections, connectInfiniteJump())
        end
    end)

    createJumpNotification()
end

enableInfiniteJump()

-- =========================================================
-- Smart Noclip (raycast forward, auto toggle)
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
