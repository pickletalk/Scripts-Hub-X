local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Obby Script",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "Pickle Interface Suite",
   LoadingSubtitle = "by PickleTalk",
   ShowText = "by PickleTalk", -- for mobile users to unhide rayfield, change if you'd like
   Theme = "Amethyst", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   ToggleUIKeybind = "K", -- The keybind to toggle the UI visibility (string like "K" or Enum.KeyCode)

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "idk"
   },

   Discord = {
      Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "https://discord.gg/bpsNUH5sVb", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },

   KeySystem = false, -- Set this to true to use our key system
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
      FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

local Main = Window:CreateTab("Main", "layers")
local Player = Window:CreateTab("Player", "person-standing")

local Button = Main:CreateButton({
   Name = "Inf Jump",
   Callback = function(toggle)
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

       enableInfiniteJump(not isInfiniteJumpEnabled)
   end,
})

Rayfield:LoadConfiguration()
