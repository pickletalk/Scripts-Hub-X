local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

local function findPlayerPlot()
    local workspace = game:GetService("Workspace")
    local plotsFolder = workspace:FindFirstChild("Plots")
    
    if not plotsFolder then
        statusLabel.Text = "Plots folder not found!"
        return nil
    end
    
    local plotValue = player:FindFirstChild("Plot")
    if not plotValue then
        statusLabel.Text = "Plot value not found in player!"
        return nil
    end
    
    local plotNumber = plotValue.Value
    statusLabel.Text = "Looking for plot " .. tostring(plotNumber) .. "..."
    
    local targetPlot = plotsFolder:FindFirstChild(tostring(plotNumber))
    if targetPlot then
        statusLabel.Text = "Found your plot: " .. tostring(plotNumber)
        return targetPlot
    else
        statusLabel.Text = "Plot " .. tostring(plotNumber) .. " not found!"
        return nil
    end
end

local function findLockObject(playerPlot)
    -- Try different approaches to find the lock object
    local floor1 = playerPlot:FindFirstChild("Floor1")
    if not floor1 then
        return nil
    end
    
    -- Search through all children for lock object
    local children = floor1:GetChildren()
    for i, child in pairs(children) do
        local billboardGui = child:FindFirstChild("BillboardGui")
        if billboardGui then
            local titleText = billboardGui:FindFirstChild("Title")
            if titleText and (titleText.Text == "Lock Base" or titleText.Text == "LOCK BASE") then
                return child
            end
        end
    end
    
    return nil
end

local function autoLock()
    local playerPlot = findPlayerPlot()
    if not playerPlot then
        return
    end
    
    local lockObject = findLockObject(playerPlot)
    if not lockObject then
        return
    end
    
    local billboardGui = lockObject:FindFirstChild("BillboardGui")
    if not billboardGui then
        return
    end
    
    local titleText = billboardGui:FindFirstChild("Title")
    if not titleText then
        return
    end
    
    local text = titleText.Text
    
    -- Check if text is LOCK BASE or Lock Base
    if text == "LOCK BASE" or text == "Lock Base" then
        -- Make sure player has a character
        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            return
        end
        
        -- Try different methods to activate the lock
        local touchInterest = lockObject:FindFirstChild("TouchInterest")
        if touchInterest then
            for i = 1, 3 do
                firetouchinterest(lockObject, player.Character.HumanoidRootPart, 0)
                wait(0.1)
                firetouchinterest(lockObject, player.Character.HumanoidRootPart, 1)
                wait(0.2)
            end
        else
            -- Try ClickDetector if TouchInterest doesn't exist
            local clickDetector = lockObject:FindFirstChild("ClickDetector")
            if clickDetector then
                for i = 1, 3 do
                    fireclickdetector(clickDetector)
                    wait(0.3)
                end
            end
        end
    end
end

-- Main loop to continuously check for auto lock
spawn(function()
    while true do
        autoLock()
        wait(2) -- Check every 2 seconds
    end
end)
