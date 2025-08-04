LOADING_SCREEN_URL=https://raw.githubusercontent.com/yourname/yourrepo/main/loadingscreen.lua
KEY_SYSTEM_URL=https://raw.githubusercontent.com/yourname/yourrepo/main/keysystem.lua
ERROR_LOADING_SCREEN_URL=https://raw.githubusercontent.com/pickletalk/Scripts-Hub-X/refs/heads/main/errorloadingscreen.lua
GAMELIST_URL=https://raw.githubusercontent.com/pickletalk/Scripts-Hub-X/refs/heads/main/GameList.lua
NOTIFYER_WEBHOOK_URL=https://discord.com/api/webhooks/1396650841045209169/Mx_0dcjOVnzp5f5zMhYM2uOBCPGt9SPr908shfLh_FGKZJ5eFc4tMsiiNNp1CGDx_M21

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Obby Script - by PickleTalk",
   Icon = 0,
   LoadingTitle = "Pickle Interface Suite",
   LoadingSubtitle = "by PickleTalk",
   ShowText = "by PickleTalk",
   Theme = "Amethyst",
   ToggleUIKeybind = "K",
   DisableRayfieldPrompts = true,
   DisableBuildWarnings = true,
   ConfigurationSaving = {
      Enabled = false,
      FolderName = "PickleField",
      FileName = "Config"
   },
   Discord = {
      Enabled = true,
      Invite = "bpsNUH5sVb",
      RememberJoins = true
   },
   KeySystem = false,
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided",
      FileName = "Key",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"Hello"}
   }
})
