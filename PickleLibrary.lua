local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local function new(c,p)
    local i = Instance.new(c)
    if p then
        for k,v in pairs(p) do
            if k == "Parent" then
                i.Parent = v
            else
                pcall(function() i[k] = v end)
            end
        end
    end
    return i
end
local FileIO = {}
FileIO.exists = function(path)
    if type(isfile) == "function" then return isfile(path) end
    local ok = pcall(function() return readfile(path) end)
    return ok
end
FileIO.read = function(path)
    if type(readfile) == "function" then return readfile(path) end
    local ok,res = pcall(function() return readfile(path) end)
    if ok then return res end
    return nil
end
FileIO.write = function(path,data)
    if type(writefile) == "function" then return writefile(path,data) end
    local ok = pcall(function() return writefile(path,data) end)
    return ok
end
FileIO.mkdir = function(path)
    if type(makefolder) == "function" then pcall(function() makefolder(path) end) end
end
local function tween(obj,props,time,style,dir)
    local ok,t = pcall(function()
        local info = TweenInfo.new(time or 0.18, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out)
        return TweenService:Create(obj, info, props)
    end)
    if ok and t then t:Play() end
    return t
end
local Rainbow = {h = 0, speed = 90}
function Rainbow:step(dt)
    self.h = (self.h + (self.speed * (dt or 0))) % 360
    local H = self.h/360
    local S,V = 1,1
    local i = math.floor(H * 6)
    local f = H * 6 - i
    local p = V * (1 - S)
    local q = V * (1 - f * S)
    local t = V * (1 - (1 - f) * S)
    i = i % 6
    local r,g,b
    if i == 0 then r,g,b = V,t,p
    elseif i == 1 then r,g,b = q,V,p
    elseif i == 2 then r,g,b = p,V,t
    elseif i == 3 then r,g,b = p,q,V
    elseif i == 4 then r,g,b = t,p,V
    else r,g,b = V,p,q end
    return Color3.new(r,g,b)
end
local Pickle = {}
function Pickle.CreateWindow(opts)
    opts = opts or {}
    local title = opts.Title or "Pickle UI"
    local folder = opts.ConfigFolder or ("Pickle_" .. title:gsub("%W",""))
    local file = opts.ConfigFile or (title .. ".json")
    local rainbowEnabled = (opts.UseRainbow == nil) and true or opts.UseRainbow
    local startVisible = (opts.StartVisible == nil) and true or opts.StartVisible
    FileIO.mkdir(folder)
    local configPath = folder .. '/' .. file
    local screen = new('ScreenGui',{Parent = LocalPlayer:WaitForChild('PlayerGui'), ResetOnSpawn = false})
    local container = new('Frame',{Parent = screen, Size = UDim2.new(0,640,0,420), Position = UDim2.new(0.5,-320,0.5,-210), BackgroundTransparency = 1, ZIndex = 1})
    container.AnchorPoint = Vector2.new(0.5,0.5)
    local shadow = new('ImageLabel',{Parent = container, Size = UDim2.new(1,28,1,28), Position = UDim2.new(0,-14,0,-14), BackgroundTransparency = 1, Image = "rbxassetid://5055479980", ScaleType = Enum.ScaleType.Slice, SliceCenter = Rect.new(10,10,118,118), ZIndex = 0})
    shadow.ImageColor3 = Color3.new(0,0,0)
    shadow.ImageTransparency = 0.82
    local main = new('Frame',{Parent = container, Size = UDim2.new(1,0,1,0), Position = UDim2.new(0,0,0,0), BackgroundColor3 = Color3.fromRGB(30,30,30), BorderSizePixel = 0, ZIndex = 2})
    local mainCorner = new('UICorner',{Parent = main, CornerRadius = UDim.new(0,12)})
    local mainStroke = new('UIStroke',{Parent = main, Thickness = 1, Transparency = 0.9, Color = Color3.fromRGB(0,0,0)})
    local titleBar = new('Frame',{Parent = main, Size = UDim2.new(1,0,0,48), BackgroundColor3 = Color3.fromRGB(22,22,22), BorderSizePixel = 0, ZIndex = 3})
    local titleCorner = new('UICorner',{Parent = titleBar, CornerRadius = UDim.new(0,10)})
    local titleLabel = new('TextLabel',{Parent = titleBar, Text = title, Size = UDim2.new(1,-160,1,0), Position = UDim2.new(0,16,0,0), BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(245,245,245), Font = Enum.Font.GothamBold, TextSize = 18, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 4})
    local controlHolder = new('Frame',{Parent = titleBar, Size = UDim2.new(0,140,1,0), Position = UDim2.new(1,-152,0,0), BackgroundTransparency = 1, ZIndex = 4})
    local btnMin = new('ImageButton',{Parent = controlHolder, Size = UDim2.new(0,36,0,36), Position = UDim2.new(0,8,0,6), BackgroundColor3 = Color3.fromRGB(28,28,28), BorderSizePixel = 0, AutoButtonColor = false, ZIndex = 5})
    local minCorner = new('UICorner',{Parent = btnMin, CornerRadius = UDim.new(0,10)})
    local minIcon = new('TextLabel',{Parent = btnMin, Text = '▁', Size = UDim2.new(1,1,1,0), BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(230,230,230), Font = Enum.Font.Gotham, TextSize = 20})
    local btnClose = new('ImageButton',{Parent = controlHolder, Size = UDim2.new(0,36,0,36), Position = UDim2.new(0,52,0,6), BackgroundColor3 = Color3.fromRGB(28,28,28), BorderSizePixel = 0, AutoButtonColor = false, ZIndex = 5})
    local closeCorner = new('UICorner',{Parent = btnClose, CornerRadius = UDim.new(0,10)})
    local closeIcon = new('TextLabel',{Parent = btnClose, Text = '✕', Size = UDim2.new(1,1,1,0), BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(240,240,240), Font = Enum.Font.Gotham, TextSize = 16})
    local btnRainbow = new('ImageButton',{Parent = controlHolder, Size = UDim2.new(0,36,0,36), Position = UDim2.new(0,96,0,6), BackgroundColor3 = Color3.fromRGB(18,18,18), BorderSizePixel = 0, AutoButtonColor = false, ZIndex = 5})
    local rainCorner = new('UICorner',{Parent = btnRainbow, CornerRadius = UDim.new(0,10)})
    local rainIcon = new('TextLabel',{Parent = btnRainbow, Text = '♻', Size = UDim2.new(1,1,1,0), BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(240,240,240), Font = Enum.Font.Gotham, TextSize = 14})
    local leftPane = new('Frame',{Parent = main, Size = UDim2.new(0,180,1,-48), Position = UDim2.new(0,0,0,48), BackgroundColor3 = Color3.fromRGB(38,38,38), BorderSizePixel = 0, ZIndex = 3})
    local leftCorner = new('UICorner',{Parent = leftPane, CornerRadius = UDim.new(0,12)})
    local leftStroke = new('UIStroke',{Parent = leftPane, Thickness = 1, Color = Color3.fromRGB(0,0,0), Transparency = 0.85})
    local rightPane = new('Frame',{Parent = main, Size = UDim2.new(1,-180,1,-48), Position = UDim2.new(0,180,0,48), BackgroundTransparency = 1, ZIndex = 3})
    local tabList = new('ScrollingFrame',{Parent = leftPane, Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, ScrollBarThickness = 6})
    tabList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    local tabLayout = new('UIListLayout',{Parent = tabList})
    tabLayout.Padding = UDim.new(0,10)
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    local contentHolder = new('Frame',{Parent = rightPane, Size = UDim2.new(1,0,1,0), BackgroundColor3 = Color3.fromRGB(44,44,44), BorderSizePixel = 0})
    local contentCorner = new('UICorner',{Parent = contentHolder, CornerRadius = UDim.new(0,12)})
    local contentPadding = new('UIPadding',{Parent = contentHolder, PaddingTop = UDim.new(0,12), PaddingLeft = UDim.new(0,12), PaddingRight = UDim.new(0,12)})
    local tabs = {}
    local currentPage = nil
    local dragging, dragStart, startPos
    titleBar.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = i.Position
            startPos = container.Position
            i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    titleBar.InputChanged:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseMovement then
            if dragging and dragStart and startPos then
                local delta = i.Position - dragStart
                container.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end
    end)
    local visible = startVisible
    local minimized = false
    local function openAnimate()
        container.Visible = true
        container.Size = UDim2.new(0,640,0,420)
        container.Position = UDim2.new(0.5,-320,0.5,-210)
        tween(container, {Position = UDim2.new(0.5,-320,0.5,-210), Size = UDim2.new(0,640,0,420)}, 0.36, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        for i,v in pairs(container:GetDescendants()) do if v:IsA('GuiObject') then tween(v, {BackgroundTransparency = math.clamp(v.BackgroundTransparency - 0.02,0,1)}, 0.18) end end
    end
    local function closeAnimate()
        tween(container, {Size = UDim2.new(0,420,0,260), Position = UDim2.new(0.5,-210,0.5,-130)}, 0.26, Enum.EasingStyle.Circular, Enum.EasingDirection.In)
        delay(0.26, function() container.Visible = false end)
    end
    local function minimizeAnimate(s)
        minimized = s
        if s then
            tween(container, {Size = UDim2.new(0,640,0,60)}, 0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
            tween(contentHolder, {BackgroundTransparency = 0.95}, 0.28)
        else
            tween(container, {Size = UDim2.new(0,640,0,420)}, 0.34, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
            tween(contentHolder, {BackgroundTransparency = 0}, 0.34)
        end
    end
    btnClose.MouseButton1Click:Connect(function()
        visible = not visible
        if visible then openAnimate() else closeAnimate() end
        tween(btnClose, {Size = UDim2.new(0,34,0,34)}, 0.06)
        delay(0.06, function() tween(btnClose, {Size = UDim2.new(0,36,0,36)}, 0.12) end)
    end)
    btnMin.MouseButton1Click:Connect(function()
        minimizeAnimate(not minimized)
        tween(btnMin, {Rotation = minimized and 0 or 180}, 0.18)
    end)
    btnRainbow.MouseButton1Click:Connect(function()
        rainbowEnabled = not rainbowEnabled
        tween(btnRainbow, {Size = UDim2.new(0,34,0,34)}, 0.08)
        delay(0.08, function() tween(btnRainbow, {Size = UDim2.new(0,36,0,36)}, 0.12) end)
    end)
    spawn(function()
        local last = tick()
        while screen and screen.Parent do
            local now = tick()
            local dt = now - last
            last = now
            if rainbowEnabled then
                local c = Rainbow:step(dt)
                titleBar.BackgroundColor3 = c:lerp(Color3.fromRGB(24,24,24), 0.68)
                btnClose.BackgroundColor3 = c:lerp(Color3.fromRGB(18,18,18), 0.5)
                btnMin.BackgroundColor3 = c:lerp(Color3.fromRGB(18,18,18), 0.6)
                btnRainbow.BackgroundColor3 = c:lerp(Color3.fromRGB(14,14,14), 0.5)
            else
                titleBar.BackgroundColor3 = Color3.fromRGB(22,22,22)
            end
            RunService.Heartbeat:Wait()
        end
    end)
    local function CreateTab(name)
        local btn = new('TextButton',{Parent = tabList, Size = UDim2.new(1,-24,0,44), BackgroundColor3 = Color3.fromRGB(26,26,26), BorderSizePixel = 0, Text = name, TextColor3 = Color3.fromRGB(230,230,230), Font = Enum.Font.GothamSemibold, TextSize = 15, AutoButtonColor = false})
        local btnCorner = new('UICorner',{Parent = btn, CornerRadius = UDim.new(0,10)})
        local btnStroke = new('UIStroke',{Parent = btn, Thickness = 1, Color = Color3.fromRGB(0,0,0), Transparency = 0.85})
        btn.MouseEnter:Connect(function() tween(btn, {BackgroundColor3 = Color3.fromRGB(36,36,36)}, 0.12) end)
        btn.MouseLeave:Connect(function() tween(btn, {BackgroundColor3 = Color3.fromRGB(26,26,26)}, 0.12) end)
        local page = new('Frame',{Parent = contentHolder, Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Visible = false})
        local pagePad = new('UIPadding',{Parent = page, PaddingTop = UDim.new(0,8), PaddingLeft = UDim.new(0,6), PaddingRight = UDim.new(0,6)})
        local layout = new('UIListLayout',{Parent = page}); layout.Padding = UDim.new(0,12)
        btn.MouseButton1Click:Connect(function()
            tween(btn, {Size = UDim2.new(1,-22,0,42)}, 0.08)
            delay(0.08, function() tween(btn, {Size = UDim2.new(1,-24,0,44)}, 0.12, Enum.EasingStyle.Elastic) end)
            for _,t in pairs(tabs) do t.page.Visible = false end
            page.Position = UDim2.new(0,40,0,0)
            page.Visible = true
            tween(page, {Position = UDim2.new(0,0,0,0)}, 0.28, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
            currentPage = page
        end)
        local tabObj = {name = name, button = btn, page = page}
        tabs[#tabs+1] = tabObj
        if #tabs == 1 then btn:CaptureMouse(); btn.MouseButton1Click() end
        return tabObj
    end
    local function CreateSection(tab, title)
        local sec = new('Frame',{Parent = tab.page, Size = UDim2.new(1,0,0,120), BackgroundTransparency = 1})
        local secTitle = new('TextLabel',{Parent = sec, Text = title, Size = UDim2.new(1,0,0,22), BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(235,235,235), Font = Enum.Font.GothamBold, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left})
        local holder = new('Frame',{Parent = sec, Size = UDim2.new(1,0,1,-28), Position = UDim2.new(0,0,0,28), BackgroundTransparency = 1})
        local layout = new('UIListLayout',{Parent = holder}); layout.Padding = UDim.new(0,8)
        return holder
    end
    local Bindings = {}
    UserInputService.InputBegan:Connect(function(i,gp)
        if gp then return end
        if i.UserInputType == Enum.UserInputType.Keyboard then
            local k = tostring(i.KeyCode)
            k = k:gsub("Enum.KeyCode.","")
            local list = Bindings[k]
            if list then
                for _,cb in pairs(list) do pcall(cb) end
            end
        end
    end)
    local function AddButton(parent,label,callback)
        local btn = new('TextButton',{Parent = parent, Size = UDim2.new(1,0,0,36), BackgroundColor3 = Color3.fromRGB(30,30,30), BorderSizePixel = 0, Text = label, TextColor3 = Color3.fromRGB(240,240,240), Font = Enum.Font.Gotham, TextSize = 14, AutoButtonColor = false})
        local corner = new('UICorner',{Parent = btn, CornerRadius = UDim.new(0,10)})
        local stroke = new('UIStroke',{Parent = btn, Thickness = 1, Color = Color3.fromRGB(0,0,0), Transparency = 0.9})
        btn.MouseEnter:Connect(function() tween(btn, {BackgroundColor3 = Color3.fromRGB(44,44,44)}, 0.12) end)
        btn.MouseLeave:Connect(function() tween(btn, {BackgroundColor3 = Color3.fromRGB(30,30,30)}, 0.12) end)
        btn.MouseButton1Click:Connect(function()
            tween(btn, {Position = UDim2.new(btn.Position.X.Scale, btn.Position.X.Offset, btn.Position.Y.Scale, btn.Position.Y.Offset + 6)}, 0.06)
            delay(0.06, function() tween(btn, {Position = UDim2.new(btn.Position.X.Scale, btn.Position.X.Offset, btn.Position.Y.Scale, btn.Position.Y.Offset - 6)}, 0.18, Enum.EasingStyle.Elastic) end)
            if callback then pcall(callback) end
        end)
        return btn
    end
    local function AddToggle(parent,label,default,callback)
        default = default == true
        local frame = new('Frame',{Parent = parent, Size = UDim2.new(1,0,0,36), BackgroundTransparency = 1})
        local lbl = new('TextLabel',{Parent = frame, Text = label, Size = UDim2.new(1,-84,1,0), BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(235,235,235), Font = Enum.Font.Gotham, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left})
        local box = new('ImageButton',{Parent = frame, Size = UDim2.new(0,64,0,28), Position = UDim2.new(1,-70,0,4), BackgroundColor3 = default and Color3.fromRGB(88,180,90) or Color3.fromRGB(36,36,36), AutoButtonColor = false, BorderSizePixel = 0})
        local corner = new('UICorner',{Parent = box, CornerRadius = UDim.new(0,8)})
        local label = new('TextLabel',{Parent = box, Size = UDim2.new(1,1,1,0), BackgroundTransparency = 1, Text = default and 'On' or 'Off', Font = Enum.Font.Gotham, TextSize = 13, TextColor3 = Color3.fromRGB(245,245,245)})
        local state = default
        box.MouseButton1Click:Connect(function()
            state = not state
            label.Text = state and 'On' or 'Off'
            tween(box, {BackgroundColor3 = state and Color3.fromRGB(88,180,90) or Color3.fromRGB(36,36,36)}, 0.14)
            if callback then pcall(callback, state) end
        end)
        return {get = function() return state end, set = function(v) if v ~= state then box:CaptureMouse(); box.MouseButton1Click() end end}
    end
    local function AddSlider(parent,label,min,max,default,callback)
        min = min or 0
        max = max or 100
        default = default or min
        local frame = new('Frame',{Parent = parent, Size = UDim2.new(1,0,0,56), BackgroundTransparency = 1})
        local lbl = new('TextLabel',{Parent = frame, Text = label .. ' (' .. tostring(default) .. ')', Size = UDim2.new(1,0,0,18), BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(235,235,235), Font = Enum.Font.Gotham, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left})
        local barBg = new('Frame',{Parent = frame, Size = UDim2.new(1,0,0,12), Position = UDim2.new(0,0,0,32), BackgroundColor3 = Color3.fromRGB(34,34,34), BorderSizePixel = 0})
        local bar = new('Frame',{Parent = barBg, Size = UDim2.new((default-min)/(max-min),0,1,0), BackgroundColor3 = Color3.fromRGB(160,160,160), BorderSizePixel = 0})
        local corner = new('UICorner',{Parent = barBg, CornerRadius = UDim.new(0,8)})
        local dragging = false
        barBg.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                local conn
                conn = UserInputService.InputChanged:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseMovement then
                        local rel = math.clamp((UserInputService:GetMouseLocation().X - barBg.AbsolutePosition.X)/barBg.AbsoluteSize.X, 0, 1)
                        tween(bar, {Size = UDim2.new(rel,0,1,0)}, 0.06)
                        local value = min + (max-min) * rel
                        lbl.Text = label .. ' (' .. tostring(math.floor(value)) .. ')'
                        if callback then pcall(callback, value) end
                    end
                end)
                local endConn
                endConn = UserInputService.InputEnded:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                        conn:Disconnect()
                        endConn:Disconnect()
                    end
                end)
            end
        end)
        return {get = function() return min + (max-min) * bar.Size.X.Scale end, set = function(v) local r = math.clamp((v-min)/(max-min),0,1); bar.Size = UDim2.new(r,0,1,0); lbl.Text = label .. ' (' .. tostring(math.floor(v)) .. ')' end}
    end
    local function AddKeybind(parent,label,default,callback)
        default = default or 'Unknown'
        local frame = new('Frame',{Parent = parent, Size = UDim2.new(1,0,0,36), BackgroundTransparency = 1})
        local lbl = new('TextLabel',{Parent = frame, Text = label, Size = UDim2.new(1,-120,1,0), BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(235,235,235), Font = Enum.Font.Gotham, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left})
        local keyBtn = new('TextButton',{Parent = frame, Size = UDim2.new(0,104,0,28), Position = UDim2.new(1,-112,0,4), BackgroundColor3 = Color3.fromRGB(36,36,36), BorderSizePixel = 0, AutoButtonColor = false})
        local corner = new('UICorner',{Parent = keyBtn, CornerRadius = UDim.new(0,8)})
        local keyLabel = new('TextLabel',{Parent = keyBtn, Text = default, Size = UDim2.new(1,1,1,0), BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(238,238,238), Font = Enum.Font.Gotham, TextSize = 13})
        local listening = false
        keyBtn.MouseButton1Click:Connect(function()
            listening = true
            keyLabel.Text = 'Press a key'
        end)
        UserInputService.InputBegan:Connect(function(i,gp)
            if gp then return end
            if listening and i.UserInputType == Enum.UserInputType.Keyboard then
                local k = tostring(i.KeyCode):gsub('Enum.KeyCode.','')
                keyLabel.Text = k
                listening = false
                if not Bindings[k] then Bindings[k] = {} end
                table.insert(Bindings[k], callback)
            end
        end)
        return {get = function() return keyLabel.Text end, set = function(k) keyLabel.Text = k end}
    end
    local function SaveConfig(tbl)
        local ok,enc = pcall(function() return HttpService:JSONEncode(tbl) end)
        if ok then FileIO.write(configPath,enc) end
    end
    local function LoadConfig()
        if FileIO.exists(configPath) then
            local txt = FileIO.read(configPath)
            local ok,dec = pcall(function() return HttpService:JSONDecode(txt) end)
            if ok then return dec end
        end
        return {}
    end
    local API = {}
    API.ScreenGui = screen
    API.CreateTab = CreateTab
    API.CreateSection = CreateSection
    API.AddButton = AddButton
    API.AddToggle = AddToggle
    API.AddSlider = AddSlider
    API.AddKeybind = AddKeybind
    API.SaveConfig = SaveConfig
    API.LoadConfig = LoadConfig
    API.SetRainbow = function(b) rainbowEnabled = b end
    API.SetRainbowSpeed = function(s) Rainbow.speed = s end
    API.Minimize = function(b) minimizeAnimate(b) end
    API.Open = function() visible = true; openAnimate() end
    API.Close = function() visible = false; closeAnimate() end
    API.Destroy = function() screen:Destroy() end
    return API
end
return Pickle
