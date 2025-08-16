-- Steal A Brainrot: UI + Teleporter + Infinite Jump + Fast Interaction (short delay) + Auto Noclip
-- by PickleTalk

if not game:IsLoaded() then game.Loaded:Wait() end

local Players        = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService   = game:GetService("TweenService")
local RunService     = game:GetService("RunService")
local player         = Players.LocalPlayer

-- =========================================================
-- UI
-- =========================================================
local function safeGuiParent()
    local ok, res = pcall(function()
        if gethui then return gethui() end
        return game:GetService("CoreGui")
    end)
    if ok and res then return res end
    return player:WaitForChild("PlayerGui")
end

local parentGui = safeGuiParent()
local old = parentGui:FindFirstChild("PlotTeleporterUI")
if old then old:Destroy() end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PlotTeleporterUI"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = parentGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 120)
mainFrame.Position = UDim2.new(1, -260, 0, 10)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(100, 100, 100)
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
titleBar.BorderSizePixel = 2
titleBar.BorderColor3 = Color3.fromRGB(120, 120, 120)
titleBar.Parent = mainFrame
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 8)

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -30, 1, 0)
titleText.Position = UDim2.new(0, 5, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "Steal A Brainrot"
titleText.TextColor3 = Color3.fromRGB(220, 220, 220)
titleText.TextScaled = true
titleText.Font = Enum.Font.GothamBold
titleText.Parent = titleBar

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 25, 0, 25)
closeButton.Position = UDim2.new(1, -27, 0, 2)
closeButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
closeButton.BorderSizePixel = 2
closeButton.BorderColor3 = Color3.fromRGB(120, 120, 120)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(200, 200, 200)
closeButton.TextScaled = true
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = titleBar
Instance.new("UICorner", closeButton).CornerRadius = UDim.new(0, 4)

local teleportButton = Instance.new("TextButton")
teleportButton.Size = UDim2.new(0, 220, 0, 35)
teleportButton.Position = UDim2.new(0, 15, 0, 45)
teleportButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
teleportButton.BorderSizePixel = 2
teleportButton.BorderColor3 = Color3.fromRGB(120, 120, 120)
teleportButton.Text = "Steal"
teleportButton.TextColor3 = Color3.fromRGB(220, 220, 220)
teleportButton.TextScaled = true
teleportButton.Font = Enum.Font.GothamBold
teleportButton.Parent = mainFrame
Instance.new("UICorner", teleportButton).CornerRadius = UDim.new(0, 6)

local rgbOverlay = Instance.new("Frame")
rgbOverlay.Size = UDim2.new(1, 0, 1, 0)
rgbOverlay.BackgroundTransparency = 0.88
rgbOverlay.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
rgbOverlay.ZIndex = teleportButton.ZIndex + 1
rgbOverlay.Parent = teleportButton
Instance.new("UICorner", rgbOverlay).CornerRadius = UDim.new(0, 6)

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 25)
statusLabel.Position = UDim2.new(0, 10, 0, 90)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "by PickleTalk"
statusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = mainFrame

-- subtle/dark RGB shimmer
task.spawn(function()
    local t = 0
    while rgbOverlay and rgbOverlay.Parent do
        t += 0.03
        local r = (math.sin(t) * 0.5 + 0.5) * 25 + 15
        local g = (math.sin(t + 2) * 0.5 + 0.5) * 25 + 15
        local b = (math.sin(t + 4) * 0.5 + 0.5) * 25 + 15
        rgbOverlay.BackgroundColor3 = Color3.fromRGB(r, g, b)
        task.wait(0.05)
    end
end)

-- Drag
local dragging, dragStart, startPos
local function updateDrag(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
titleBar.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        updateDrag(input)
    end
end)

-- =========================================================
-- Plot search (flexible)
-- =========================================================
local plotIds = {
    "eace968c-881f-43f9-9c0b-b2fc25f3f8ec",
    "d7f59025-991d-4538-b499-bfe00c5a309b",
    "b5c3542d-a60a-438c-9317-daea42823f20",
    "af81bdb9-a235-4a49-a95f-76706e1195fd",
    "a130a38a-aa6d-44d1-a55d-bcc77332824b",
    "84042e01-722c-45ea-908d-a11b849b883e",
    "97e28a62-36f2-49c9-aabb-6e5578b2f96c",
    "80ef716c-dc18-4151-b8ef-2b57e4dd86a0"
}

local function getPlayerPlot()
    local plots = workspace:WaitForChild("Plots")
    for _, id in ipairs(plotIds) do
        local plot = plots:FindFirstChild(id)
        if plot then
            local sign = plot:FindFirstChild("PlotSign")
            if sign then
                local gui = sign:FindFirstChild("SurfaceGui")
                if gui then
                    local textLabel
                    for _, d in ipairs(gui:GetDescendants()) do
                        if d:IsA("TextLabel") then textLabel = d break end
                    end
                    if textLabel then
                        local txt = tostring(textLabel.Text or "")
                        if txt:find(player.DisplayName, 1, true) then
                            return plot
                        end
                    end
                end
            end
        end
    end
    return nil
end

-- =========================================================
-- Teleport (fragmented movement)
-- =========================================================
local teleporting = false

local function tweenTeleport()
    if teleporting then return end
    teleporting = true

    local char = player.Character
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
    local hum  = char and char:FindFirstChildOfClass("Humanoid")
    local plot = getPlayerPlot()

    if not hrp or not hum then
        statusLabel.Text = "⚠ Character not ready"
        teleporting = false; return
    end
    if not plot then
        statusLabel.Text = "⚠ No plot found"
        teleporting = false; return
    end

    local deliveryHitbox = plot:FindFirstChild("DeliveryHitbox")
    if not deliveryHitbox then
        statusLabel.Text = "⚠ DeliveryHitbox missing"
        teleporting = false; return
    end

    teleportButton.Text = "Stealing..."
    statusLabel.Text = "Moving to plot…"

    local targetPos = deliveryHitbox.Position + Vector3.new(0, 3, 0)
    local offset = targetPos - hrp.Position
    local dist = offset.Magnitude
    local steps = math.max(20, math.floor(dist / 3))
    local step = offset.Unit * 3

    for i = 1, steps do
        if not hrp.Parent or not hum.Parent then statusLabel.Text = "⚠ Character lost"; break end
        hrp.CFrame = hrp.CFrame + step
        hum:Move(Vector3.new(step.X, 0, step.Z), true) -- look active to server
        task.wait(0.05)
    end

    teleportButton.Text = "Steal"
    statusLabel.Text = "✅ Arrived!"
    teleporting = false
end

-- =========================================================
-- Infinite Jump (always on)
-- =========================================================
do
    UserInputService.JumpRequest:Connect(function()
        local c = player.Character
        local hum = c and c:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health > 0 then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)
end

-- =========================================================
-- Fast Interaction (SHORT delay, not instant)
-- =========================================================
local desiredHold = 0.1  -- short delay instead of zero

local function setPromptShortHold(prompt)
    if not (prompt and prompt:IsA("ProximityPrompt")) then return end
    if prompt.HoldDuration ~= desiredHold then
        prompt.HoldDuration = desiredHold
    end
    prompt.Style = Enum.ProximityPromptStyle.Default
    prompt:GetPropertyChangedSignal("HoldDuration"):Connect(function()
        if prompt.HoldDuration ~= desiredHold then
            prompt.HoldDuration = desiredHold
        end
    end)
end

-- initial scan
task.spawn(function()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") then
            setPromptShortHold(obj)
        end
    end
end)

-- keep up with new prompts (lightweight)
workspace.DescendantAdded:Connect(function(obj)
    if obj:IsA("ProximityPrompt") then
        task.wait(0.1)
        setPromptShortHold(obj)
    end
end)

-- periodic sanity check (low frequency to avoid cost)
task.spawn(function()
    while true do
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("ProximityPrompt") and obj.HoldDuration ~= desiredHold then
                obj.HoldDuration = desiredHold
            end
        end
        task.wait(1.0)
    end
end)

-- =========================================================
-- Auto Noclip while pushing into walls (client-side only)
-- =========================================================
local noClipUntil = 0
local NOCOLLIDE_WINDOW = 0.35  -- how long to keep collisions off after a detected push
local RAY_LENGTH = 3

local function setCharacterCollide(char, enabled)
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = enabled
        end
    end
end

RunService.Heartbeat:Connect(function()
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not (hum and hrp) then return end

    -- detect "pushing into something" in move direction
    local dir = hum.MoveDirection
    if dir.Magnitude > 0 then
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Blacklist
        params.FilterDescendantsInstances = {char}
        local hit = workspace:Raycast(hrp.Position, dir.Unit * RAY_LENGTH, params)
        if hit and hit.Instance and hit.Instance.CanCollide then
            noClipUntil = tick() + NOCOLLIDE_WINDOW
        end
    end

    local shouldNoClip = tick() < noClipUntil
    setCharacterCollide(char, not shouldNoClip)
end)

-- =========================================================
-- Wire UI
-- =========================================================
teleportButton.MouseButton1Click:Connect(tweenTeleport)
closeButton.MouseButton1Click:Connect(function() screenGui:Destroy() end)

-- small status hint so you know helpers are live
statusLabel.Text = "Fast Interact + Noclip + InfJump ready"
wait(1)
statusLabel.Text = "by PickleTalk"
