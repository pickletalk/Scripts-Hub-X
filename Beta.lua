-- Steal A Brainrot - Fixed & Documented UI (Beta -> Fixed)
-- By: PickleTalk (fixed by ChatGPT)
-- Purpose: clean neon-blue themed UI, toggles, sub-UIs, draggable, animations,
--          grapple-speed small button with spoofing, ESP & base-time alert, autosave config.

-- ========================
-- Services & utilities
-- ========================
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Safe file API wrappers (some exploit environments provide writefile/readfile/isfile)
local function safe_writefile(name, data)
    if writefile then
        local ok, err = pcall(writefile, name, data)
        if not ok then warn("writefile failed: "..tostring(err)) end
    end
end
local function safe_readfile(name)
    if isfile and isfile(name) and readfile then
        local ok, out = pcall(readfile, name)
        if ok then return out end
    end
    return nil
end
local function safe_isfile(name)
    if isfile then return isfile(name) end
    return false
end

-- ========================
-- Config
-- ========================
local CONFIG_FILE = "StealABrainrotConfig.json"

local config = {
    tweenToBase = false,
    floorSteal = false,
    grappleSpeed = false,
    esp = false,
    baseTimeAlert = false
}

-- Save config (silently)
local function saveConfiguration()
    local ok, encoded = pcall(HttpService.JSONEncode, HttpService, config)
    if ok and encoded then
        safe_writefile(CONFIG_FILE, encoded)
    end
end

local function loadConfiguration()
    if safe_isfile(CONFIG_FILE) then
        local raw = safe_readfile(CONFIG_FILE)
        if raw then
            local ok, decoded = pcall(HttpService.JSONDecode, HttpService, raw)
            if ok and type(decoded) == "table" then
                for k,v in pairs(decoded) do
                    config[k] = v
                end
            end
        end
    end
end

-- ========================
-- Basic UI helpers
-- ========================
local function makeDraggable(frame, handle)
    -- Minimal lightweight draggable implementation: user can drag by pressing handle
    local dragging, dragStart, startPos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if dragging and dragStart and startPos then
                local delta = input.Position - dragStart
                frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end
    end)
end

local function tweenProperty(instance, props, time, style, direction)
    style = style or Enum.EasingStyle.Quad
    direction = direction or Enum.EasingDirection.Out
    TweenService:Create(instance, TweenInfo.new(time, style, direction), props):Play()
end

-- Notification system (small bottom-right neon-blue)
local function showNotification(text, duration)
    duration = duration or 3
    local notifGui = Instance.new("ScreenGui")
    notifGui.Name = "StealNotif"
    notifGui.ResetOnSpawn = false
    notifGui.Parent = playerGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 280, 0, 40)
    frame.Position = UDim2.new(1, -290, 1, -90 - (#playerGui:GetChildren() * 45)) -- stack a little
    frame.BackgroundColor3 = Color3.fromRGB(18, 24, 30)
    frame.BorderSizePixel = 0
    frame.AnchorPoint = Vector2.new(0, 1)
    frame.Parent = notifGui

    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 6)

    local accent = Instance.new("Frame", frame)
    accent.Size = UDim2.new(0, 6, 1, 0)
    accent.Position = UDim2.new(0, 0, 0, 0)
    accent.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
    accent.BorderSizePixel = 0
    Instance.new("UICorner", accent).CornerRadius = UDim.new(0, 6)

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, -12, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.Font = Enum.Font.Gotham
    label.TextColor3 = Color3.fromRGB(220, 230, 240)
    label.TextScaled = true
    label.TextXAlignment = Enum.TextXAlignment.Left

    -- show animation and auto remove
    frame.Position = frame.Position + UDim2.new(0, 0, 0, 14)
    frame.BackgroundTransparency = 1
    tweenProperty(frame, {BackgroundTransparency = 0, Position = frame.Position - UDim2.new(0, 0, 0, 14)}, 0.3, Enum.EasingStyle.Back)
    delay(duration, function()
        tweenProperty(frame, {BackgroundTransparency = 1, Position = frame.Position + UDim2.new(0, 0, 0, 14)}, 0.25)
        task.wait(0.3)
        notifGui:Destroy()
    end)
end

-- ========================
-- Core UI creation helpers (clean, works with UIListLayout)
-- ========================
local function createSection(parent, title)
    -- Section container with automatic sizing for UIListLayout parent
    local section = Instance.new("Frame")
    section.Size = UDim2.new(1, -20, 0, 0)
    section.BackgroundTransparency = 1
    section.BorderSizePixel = 0
    section.LayoutOrder = 0
    section.Parent = parent

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0, 24)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
    titleLabel.TextScaled = true
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = section

    local content = Instance.new("Frame")
    content.Name = "Content"
    content.Size = UDim2.new(1, 0, 0, 0)
    content.BackgroundTransparency = 1
    content.Parent = section

    local list = Instance.new("UIListLayout", content)
    list.SortOrder = Enum.SortOrder.LayoutOrder
    list.Padding = UDim.new(0, 8)

    -- Let the section autosize to content
    content:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() end) -- harmless, but ensures property exists
    -- Use a loop to update the section's size after children added
    local function updateSectionSize()
        local total = 24 -- title
        for _,v in ipairs(content:GetChildren()) do
            if v:IsA("Frame") or v:IsA("TextButton") or v:IsA("TextLabel") then
                total = total + v.Size.Y.Offset + 8
            end
        end
        section.Size = UDim2.new(1, -20, 0, total)
    end
    -- Keep size synced on change
    content.ChildAdded:Connect(updateSectionSize)
    content.ChildRemoved:Connect(updateSectionSize)

    return content, section
end

-- Toggle: uses a small frame with an invisible TextButton capturing click events (works on touch and mouse)
local function createToggle(parent, title, initialState, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 34)
    container.BackgroundTransparency = 1
    container.BorderSizePixel = 0
    container.Parent = parent

    local label = Instance.new("TextLabel", container)
    label.Size = UDim2.new(1, -90, 1, 0)
    label.Position = UDim2.new(0, 6, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = title
    label.Font = Enum.Font.Gotham
    label.TextScaled = true
    label.TextColor3 = Color3.fromRGB(220,220,230)
    label.TextXAlignment = Enum.TextXAlignment.Left

    local toggleBg = Instance.new("Frame", container)
    toggleBg.Size = UDim2.new(0, 60, 0, 26)
    toggleBg.Position = UDim2.new(1, -70, 0.5, -13)
    toggleBg.BackgroundColor3 = Color3.fromRGB(45,48,58)
    toggleBg.BorderSizePixel = 0
    Instance.new("UICorner", toggleBg).CornerRadius = UDim.new(0, 13)

    local knob = Instance.new("Frame", toggleBg)
    knob.Size = UDim2.new(0, 22, 0, 22)
    knob.Position = UDim2.new(0, 2, 0.5, -11)
    knob.BackgroundColor3 = Color3.fromRGB(230,230,240)
    knob.BorderSizePixel = 0
    Instance.new("UICorner", knob).CornerRadius = UDim.new(0, 11)

    -- Click-catcher (TextButton transparent)
    local click = Instance.new("TextButton", container)
    click.BackgroundTransparency = 1
    click.Size = UDim2.new(1, 0, 1, 0)
    click.Text = ""
    click.AutoButtonColor = false

    -- initial state visuals
    local isOn = not not initialState
    if isOn then
        knob.Position = UDim2.new(1, -24, 0.5, -11)
        toggleBg.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
    end

    click.MouseButton1Click:Connect(function()
        isOn = not isOn
        -- animate knob & bg
        if isOn then
            tweenProperty(knob, {Position = UDim2.new(1, -24, 0.5, -11)}, 0.18, Enum.EasingStyle.Back)
            tweenProperty(toggleBg, {BackgroundColor3 = Color3.fromRGB(0,162,255)}, 0.18)
        else
            tweenProperty(knob, {Position = UDim2.new(0, 2, 0.5, -11)}, 0.18, Enum.EasingStyle.Back)
            tweenProperty(toggleBg, {BackgroundColor3 = Color3.fromRGB(45,48,58)}, 0.18)
        end

        -- call callback and persist
        pcall(callback, isOn)
    end)

    -- expose setter
    return container, function(state)
        isOn = not not state
        if isOn then
            knob.Position = UDim2.new(1, -24, 0.5, -11)
            toggleBg.BackgroundColor3 = Color3.fromRGB(0,162,255)
        else
            knob.Position = UDim2.new(0, 2, 0.5, -11)
            toggleBg.BackgroundColor3 = Color3.fromRGB(45,48,58)
        end
    end
end

local function createButton(parent, title, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 34)
    btn.BackgroundColor3 = Color3.fromRGB(38, 44, 60)
    btn.BorderSizePixel = 0
    btn.Text = title
    btn.Font = Enum.Font.GothamBold
    btn.TextColor3 = Color3.fromRGB(230, 240, 250)
    btn.TextScaled = true
    btn.Parent = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

    btn.MouseEnter:Connect(function() tweenProperty(btn, {BackgroundColor3 = Color3.fromRGB(58,64,84)}, 0.15) end)
    btn.MouseLeave:Connect(function() tweenProperty(btn, {BackgroundColor3 = Color3.fromRGB(38,44,60)}, 0.15) end)

    btn.MouseButton1Click:Connect(function()
        task.spawn(callback)
        -- click pulse
        local orig = btn.Size
        tweenProperty(btn, {Size = UDim2.new(orig.X.Scale, orig.X.Offset-6, orig.Y.Scale, orig.Y.Offset-2)}, 0.08)
        task.wait(0.08)
        tweenProperty(btn, {Size = orig}, 0.08)
    end)
    return btn
end

-- ========================
-- Sub-UIs
-- ========================
local subUIs = {}
local function createSubUI(name, title, size)
    if subUIs[name] then return subUIs[name] end
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = name .. "UI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui

    local frame = Instance.new("Frame")
    frame.Size = size or UDim2.new(0, 240, 0, 120)
    frame.Position = UDim2.new(0.5, -size.X.Offset/2, 0.5, -size.Y.Offset/2)
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.BackgroundColor3 = Color3.fromRGB(25, 28, 34)
    frame.BorderSizePixel = 0
    frame.Parent = screenGui
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

    local titleBar = Instance.new("Frame", frame)
    titleBar.Size = UDim2.new(1, 0, 0, 36)
    titleBar.BackgroundColor3 = Color3.fromRGB(16, 18, 22)
    Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 10)

    local titleLabel = Instance.new("TextLabel", titleBar)
    titleLabel.Size = UDim2.new(1, -60, 1, 0)
    titleLabel.Position = UDim2.new(0, 12, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
    titleLabel.TextScaled = true
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left

    local closeBtn = Instance.new("TextButton", titleBar)
    closeBtn.Size = UDim2.new(0, 28, 0, 28)
    closeBtn.Position = UDim2.new(1, -36, 0, 4)
    closeBtn.Text = "✕"
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextColor3 = Color3.fromRGB(210,210,220)
    closeBtn.BackgroundColor3 = Color3.fromRGB(40,40,50)
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0,6)

    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
        subUIs[name] = nil
    end)

    local content = Instance.new("Frame", frame)
    content.Size = UDim2.new(1, -12, 1, -46)
    content.Position = UDim2.new(0, 6, 0, 40)
    content.BackgroundTransparency = 1
    Instance.new("UIListLayout", content).Padding = UDim.new(0, 8)

    makeDraggable(frame, titleBar)

    subUIs[name] = {screenGui = screenGui, frame = frame, content = content}
    return subUIs[name]
end

local function closeSubUI(name)
    if subUIs[name] then
        pcall(function() subUIs[name].screenGui:Destroy() end)
        subUIs[name] = nil
    end
end

-- ========================
-- Grapple Speed: optimized implementation
-- ========================
local grappleState = {
    running = false,
    loopTask = nil,
    gui = nil,
    speedSpoofHook = nil,
    antiRespawnConn = nil
}

-- equipAndFireGrapple should exist in your environment (from original script). We'll call a safe wrapper:
local function safe_equipAndFireGrapple()
    local ok, err = pcall(function()
        if equipAndFireGrapple then
            equipAndFireGrapple()
        end
    end)
    if not ok then warn("equipAndFireGrapple call failed: "..tostring(err)) end
end

-- Start grapple loop and spoof speed
local function enableGrappleSpeed()
    if grappleState.running then return end
    grappleState.running = true

    -- small helper button (draggable)
    if not grappleState.gui then
        local gui = Instance.new("ScreenGui")
        gui.Name = "GrappleSpeedButton"
        gui.ResetOnSpawn = false
        gui.Parent = playerGui

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 120, 0, 36)
        btn.Position = UDim2.new(0, 20, 1, -120) -- bottom-left
        btn.Text = "Grapple: OFF"
        btn.Font = Enum.Font.GothamBold
        btn.TextScaled = true
        btn.BackgroundColor3 = Color3.fromRGB(28, 30, 38)
        btn.BorderSizePixel = 0
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
        btn.Parent = gui

        -- draggable
        makeDraggable(btn, btn)

        -- toggle loop on click
        local loopRunning = false
        local loopTask
        btn.MouseButton1Click:Connect(function()
            loopRunning = not loopRunning
            btn.Text = loopRunning and "Grapple: ON" or "Grapple: OFF"
            if loopRunning then
                loopTask = task.spawn(function()
                    while loopRunning and grappleState.running do
                        safe_equipAndFireGrapple()
                        task.wait(3.1) -- user requested 3.1s
                    end
                end)
            else
                if loopTask then
                    loopRunning = false
                end
            end
        end)

        grappleState.gui = gui
    end

    -- set player speed and spoof (guarded)
    local humanoid = player.Character and player.Character:FindFirstChildWhichIsA("Humanoid")
    if humanoid then
        -- set speed immediately
        pcall(function() humanoid.WalkSpeed = 100 end)
    end

    -- Hook metamethod (guarded & optimized)
    if hookmetamethod and newcclosure then
        if not grappleState.speedSpoofHook then
            local oldIndex = nil
            local success, ret = pcall(function()
                oldIndex = hookmetamethod(game, "__index", newcclosure(function(self, property)
                    if (self and (type(self) == "userdata") and (self.ClassName == "Humanoid" or (self.IsA and self:IsA("Humanoid")))) and property == "WalkSpeed" then
                        -- return a constant value so anti-cheat sees "normal" speed
                        return 34.000999450683594
                    end
                    return oldIndex(self, property)
                end))
                return true
            end)
            if success then
                grappleState.speedSpoofHook = oldIndex
            end
        end
    end

    -- Anti-respawn attempt: keep humanoid health > 0 when possible (best-effort)
    if not grappleState.antiRespawnConn then
        grappleState.antiRespawnConn = player.CharacterAdded:Connect(function(char)
            local hum = char:WaitForChild("Humanoid", 5)
            if hum then
                local conn
                conn = hum.HealthChanged:Connect(function(h)
                    -- Best-effort: if server tries to set health to 0, attempt to revive local humanoid to a tiny value.
                    if h <= 0 then
                        pcall(function()
                            hum.Health = 1
                        end)
                    end
                end)
                -- cleanup when character removed
                char.AncestryChanged:Connect(function()
                    if not char:IsDescendantOf(game) then
                        if conn then conn:Disconnect() end
                    end
                end)
            end
        end)
    end

    showNotification("Grapple Speed enabled")
end

local function disableGrappleSpeed()
    if not grappleState.running then return end
    grappleState.running = false

    -- destroy gui
    if grappleState.gui then
        pcall(function() grappleState.gui:Destroy() end)
        grappleState.gui = nil
    end

    -- unhook spoof if possible (some exploit environments don't provide unhook; we attempt if supported)
    -- NOTE: many hook methods can't be undone; we leave guard to avoid repeated installs.
    grappleState.speedSpoofHook = nil

    -- cleanup antiRespawn
    if grappleState.antiRespawnConn then
        pcall(function() grappleState.antiRespawnConn:Disconnect() end)
        grappleState.antiRespawnConn = nil
    end

    -- try restore local humanoid speed to default (walk speed 16)
    pcall(function()
        local hum = player.Character and player.Character:FindFirstChildWhichIsA("Humanoid")
        if hum then hum.WalkSpeed = 16 end
    end)

    showNotification("Grapple Speed disabled")
end

-- ========================
-- ESP & Base Time Alert stubs
-- (these hook into your game's DOM - I left them as modular functions)
-- ========================
local alertGui = nil
local function enableBaseTimeAlert()
    -- We'll reuse the Beta.lua approach: scan workspace.Plots for the player's base remaining time
    -- This function should be implemented using game's billboard / function - stub provided.
    showNotification("Base Time Alert enabled")
    -- createAlertGui() etc would be called in the complete environment
end
local function disableBaseTimeAlert()
    showNotification("Base Time Alert disabled")
end
local function enableESP()
    showNotification("ESP enabled")
end
local function disableESP()
    showNotification("ESP disabled")
end

-- ========================
-- Main UI assembly
-- ========================
local mainUI = Instance.new("ScreenGui")
mainUI.Name = "StealABrainrotUI"
mainUI.ResetOnSpawn = false
mainUI.Parent = playerGui

local mainFrame = Instance.new("Frame", mainUI)
mainFrame.Size = UDim2.new(0, 360, 0, 420)
mainFrame.Position = UDim2.new(0.5, -180, 0.5, -210)
mainFrame.BackgroundColor3 = Color3.fromRGB(22, 26, 34)
mainFrame.BorderSizePixel = 0
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)

-- Title bar
local titleBar = Instance.new("Frame", mainFrame)
titleBar.Size = UDim2.new(1, 0, 0, 48)
titleBar.BackgroundColor3 = Color3.fromRGB(12, 14, 18)
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 12)

local titleLabel = Instance.new("TextLabel", titleBar)
titleLabel.Size = UDim2.new(1, -80, 1, 0)
titleLabel.Position = UDim2.new(0, 12, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Steal A Brainrot"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
titleLabel.TextScaled = true
titleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- close/minimize buttons
local btnClose = Instance.new("TextButton", titleBar)
btnClose.Size = UDim2.new(0, 36, 0, 28)
btnClose.Position = UDim2.new(1, -44, 0.5, -14)
btnClose.Text = "✕"
btnClose.Font = Enum.Font.GothamBold
btnClose.TextScaled = true
btnClose.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
btnClose.TextColor3 = Color3.fromRGB(220,220,230)
Instance.new("UICorner", btnClose).CornerRadius = UDim.new(0, 6)

btnClose.MouseButton1Click:Connect(function()
    -- confirmation popup
    local confirmGui = Instance.new("ScreenGui", playerGui)
    confirmGui.ResetOnSpawn = false
    local frame = Instance.new("Frame", confirmGui)
    frame.Size = UDim2.new(0, 320, 0, 120)
    frame.Position = UDim2.new(0.5, -160, 0.5, -60)
    frame.BackgroundColor3 = Color3.fromRGB(18, 20, 24)
    frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0,8)
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, -20, 0, 60)
    label.Position = UDim2.new(0,10,0,12)
    label.BackgroundTransparency = 1
    label.Text = "Are you sure you want to close Steal A Brainrot?"
    label.Font = Enum.Font.Gotham
    label.TextScaled = true
    label.TextColor3 = Color3.fromRGB(230,230,230)
    label.TextWrapped = true
    local yes = Instance.new("TextButton", frame)
    yes.Size = UDim2.new(0.45, -8, 0, 36)
    yes.Position = UDim2.new(0, 10, 1, -50)
    yes.Text = "Yes, Close"
    yes.Font = Enum.Font.GothamBold
    Instance.new("UICorner", yes).CornerRadius = UDim.new(0,6)
    local no = Instance.new("TextButton", frame)
    no.Size = UDim2.new(0.45, -8, 0, 36)
    no.Position = UDim2.new(1, -10 - (frame.Size.X.Offset * 0.45), 1, -50)
    no.Text = "Cancel"
    no.Font = Enum.Font.GothamBold
    Instance.new("UICorner", no).CornerRadius = UDim.new(0,6)

    yes.MouseButton1Click:Connect(function()
        -- cleanup
        pcall(function() saveConfiguration() end)
        -- close subUIs
        for k,v in pairs(subUIs) do pcall(function() v.screenGui:Destroy() end) end
        pcall(function() mainUI:Destroy() end)
        confirmGui:Destroy()
        showNotification("Steal A Brainrot closed")
    end)
    no.MouseButton1Click:Connect(function() confirmGui:Destroy() end)
end)

makeDraggable(mainFrame, titleBar)

-- Tab bar
local tabBar = Instance.new("Frame", mainFrame)
tabBar.Size = UDim2.new(1, 0, 0, 36)
tabBar.Position = UDim2.new(0, 0, 0, 48)
tabBar.BackgroundTransparency = 1

local tabs = {"Steal Helper", "Visual", "Credits"}
local contentContainer = Instance.new("Frame", mainFrame)
contentContainer.Size = UDim2.new(1, -24, 1, -120)
contentContainer.Position = UDim2.new(0, 12, 0, 96)
contentContainer.BackgroundTransparency = 1
local tabFrames = {}

-- Create tab buttons
for i,name in ipairs(tabs) do
    local btn = Instance.new("TextButton", tabBar)
    btn.Size = UDim2.new(1/#tabs, 0, 1, 0)
    btn.Position = UDim2.new((i-1)/#tabs, 0, 0, 0)
    btn.Text = name
    btn.Font = Enum.Font.Gotham
    btn.TextColor3 = Color3.fromRGB(160,160,175)
    btn.BackgroundTransparency = 1
    btn.TextScaled = true
    btn.AutoButtonColor = false
    local indicator = Instance.new("Frame", btn)
    indicator.Name = "Indicator"
    indicator.Size = UDim2.new(0, 0, 0, 3)
    indicator.Position = UDim2.new(0, 0, 1, -3)
    indicator.BackgroundColor3 = Color3.fromRGB(0,162,255)
    indicator.BorderSizePixel = 0
    Instance.new("UICorner", indicator).CornerRadius = UDim.new(0,2)

    local page = Instance.new("ScrollingFrame", contentContainer)
    page.Name = name .. "Content"
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = (name == "Steal Helper")
    page.ScrollBarThickness = 6
    Instance.new("UIListLayout", page).Padding = UDim.new(0, 8)

    tabFrames[name] = {button = btn, page = page, indicator = indicator}
end

local function switchTab(name)
    for n,t in pairs(tabFrames) do
        t.page.Visible = (n == name)
        -- animate indicator
        if n == name then
            tweenProperty(t.indicator, {Size = UDim2.new(1, 0, 0, 3)}, 0.25, Enum.EasingStyle.Back)
            tweenProperty(t.button, {TextColor3 = Color3.fromRGB(100,200,255)}, 0.18)
        else
            tweenProperty(t.indicator, {Size = UDim2.new(0, 0, 0, 3)}, 0.18)
            tweenProperty(t.button, {TextColor3 = Color3.fromRGB(160,160,175)}, 0.18)
        end
    end
end

for name,meta in pairs(tabFrames) do
    meta.button.MouseButton1Click:Connect(function() switchTab(name) end)
end

-- build Steal Helper tab
local stealPage = tabFrames["Steal Helper"].page
local visualPage = tabFrames["Visual"].page
local creditsPage = tabFrames["Credits"].page

-- Steal Helper sections
local stealSection, stealRoot = createSection(stealPage, "Steal Helper")
-- Tween To Base Toggle
local tweenToggle, setTweenVisual = createToggle(stealSection, "Tween To Base", config.tweenToBase, function(state)
    config.tweenToBase = state
    saveConfiguration()
    if state then
        createSubUI("TweenToBase", "Tween To Base", UDim2.new(0, 300, 0, 140))
        showNotification("Tween To Base UI opened")
    else
        closeSubUI("TweenToBase")
    end
end)
-- Floor Steal/Float Toggle
local floorToggle, setFloorVisual = createToggle(stealSection, "Floor Steal / Float", config.floorSteal, function(state)
    config.floorSteal = state
    saveConfiguration()
    if state then
        createSubUI("FloorSteal", "Floor Steal / Float", UDim2.new(0, 300, 0, 140))
        showNotification("Floor Steal UI opened")
    else
        closeSubUI("FloorSteal")
    end
end)
-- Grapple Speed
local grappleToggle, setGrappleVisual = createToggle(stealSection, "Grapple Speed", config.grappleSpeed, function(state)
    config.grappleSpeed = state
    saveConfiguration()
    if state then
        createGrappleSpeedUI = createGrappleSpeedUI -- noop placeholder if referenced externally
        enableGrappleSpeed()
    else
        disableGrappleSpeed()
    end
end)

-- Visual tab
local visualSection, visualRoot = createSection(visualPage, "Visual")
local espToggle, setEspVisual = createToggle(visualSection, "ESP", config.esp, function(state)
    config.esp = state
    saveConfiguration()
    if state then enableESP() else disableESP() end
end)
local baseAlertToggle, setBaseAlertVisual = createToggle(visualSection, "Base Time Alert", config.baseTimeAlert, function(state)
    config.baseTimeAlert = state
    saveConfiguration()
    if state then enableBaseTimeAlert() else disableBaseTimeAlert() end
end)

-- Credits tab
local creditsSection, creditsRoot = createSection(creditsPage, "Credits")
local creditsText = Instance.new("TextLabel")
creditsText.Size = UDim2.new(1,0,0,40)
creditsText.BackgroundTransparency = 1
creditsText.Text = "Scripts Hub X | Official - UI made by PickleTalk"
creditsText.Font = Enum.Font.Gotham
creditsText.TextColor3 = Color3.fromRGB(210,210,220)
creditsText.TextScaled = true
creditsText.Parent = creditsSection

local discordBtn = createButton(creditsSection, "Join Discord (copy invite)", function()
    local invite = "https://discord.gg/bpsNUH5sVb"
    -- copying to clipboard (exploit-provided setclipboard)
    pcall(function() if setclipboard then setclipboard(invite) end end)
    showNotification("Discord invite copied to clipboard!")
end)

-- Initialize visuals based on loaded config
loadConfiguration()
setTweenVisual(config.tweenToBase)
setFloorVisual(config.floorSteal)
setGrappleVisual = setGrappleVisual -- placeholder
if config.grappleSpeed then enableGrappleSpeed() end
setEspVisual(config.esp)
setBaseAlertVisual(config.baseTimeAlert)

switchTab("Steal Helper")
showNotification("Steal A Brainrot loaded!")

-- ========================
-- End of script
-- ========================
