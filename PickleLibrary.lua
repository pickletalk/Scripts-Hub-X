-- Instances: 147 | Scripts: 0 | Modules: 1
local DRR = {};

-- PickleLibrary
DRR["1"] = Instance.new("ScreenGui", game:GetService("CoreGui"));
DRR["1"]["IgnoreGuiInset"] = true;
DRR["1"]["ScreenInsets"] = Enum.ScreenInsets.DeviceSafeInsets;
DRR["1"]["Name"] = [[PickleLibrary]];
DRR["1"]["ZIndexBehavior"] = Enum.ZIndexBehavior.Sibling;

-- PickleLibrary.TopBar
DRR["2"] = Instance.new("Frame", DRR["1"]);
DRR["2"]["BorderSizePixel"] = 0;
DRR["2"]["BackgroundColor3"] = Color3.fromRGB(100, 150, 255);
DRR["2"]["LayoutOrder"] = 2;
DRR["2"]["Size"] = UDim2.new(0.5404488444328308, 0, 0.1739015281200409, 0);
DRR["2"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
DRR["2"]["Position"] = UDim2.new(0.23000000417232513, 0, -0.1899999976158142, 0);
DRR["2"]["Name"] = [[TopBar]];

-- PickleLibrary.TopBar.UICorner
DRR["3"] = Instance.new("UICorner", DRR["2"]);
DRR["3"]["CornerRadius"] = UDim.new(0.10000000149011612, 0);

-- PickleLibrary.TopBar.ScrollingFrame
DRR["4"] = Instance.new("ScrollingFrame", DRR["2"]);
DRR["4"]["Active"] = true;
DRR["4"]["ScrollingDirection"] = Enum.ScrollingDirection.Y;
DRR["4"]["BorderSizePixel"] = 0;
DRR["4"]["CanvasSize"] = UDim2.new(0.10000000149011612, 0, 0, 0);
DRR["4"]["BackgroundColor3"] = Color3.fromRGB(26, 26, 36);
DRR["4"]["AutomaticCanvasSize"] = Enum.AutomaticSize.X;
DRR["4"]["BackgroundTransparency"] = 1;
DRR["4"]["Size"] = UDim2.new(0.915977954864502, 0, 0.5196850299835205, 0);
DRR["4"]["ScrollBarImageColor3"] = Color3.fromRGB(0, 0, 0);
DRR["4"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
DRR["4"]["ScrollBarThickness"] = 0;
DRR["4"]["Position"] = UDim2.new(0, 0, 0.4803149700164795, 0);

-- PickleLibrary.TopBar.ScrollingFrame.UIListLayout
DRR["5"] = Instance.new("UIListLayout", DRR["4"]);
DRR["5"]["VerticalAlignment"] = Enum.VerticalAlignment.Center;
DRR["5"]["FillDirection"] = Enum.FillDirection.Horizontal;
DRR["5"]["Padding"] = UDim.new(0.009999999776482582, 0);
DRR["5"]["SortOrder"] = Enum.SortOrder.LayoutOrder;

-- PickleLibrary.TopBar.ScrollingFrame.UIPadding
DRR["6"] = Instance.new("UIPadding", DRR["4"]);
DRR["6"]["PaddingLeft"] = UDim.new(0.014999999664723873, 0);

-- PickleLibrary.TopBar.DropShadowHolder
DRR["7"] = Instance.new("Frame", DRR["2"]);
DRR["7"]["ZIndex"] = 0;
DRR["7"]["BorderSizePixel"] = 0;
DRR["7"]["BackgroundTransparency"] = 1;
DRR["7"]["Size"] = UDim2.new(1, 0, 1, 0);
DRR["7"]["Name"] = [[DropShadowHolder]];

-- PickleLibrary.TopBar.DropShadowHolder.DropShadow
DRR["8"] = Instance.new("ImageLabel", DRR["7"]);
DRR["8"]["ZIndex"] = 0;
DRR["8"]["BorderSizePixel"] = 0;
DRR["8"]["SliceCenter"] = Rect.new(49, 49, 450, 450);
DRR["8"]["ScaleType"] = Enum.ScaleType.Slice;
DRR["8"]["ImageColor3"] = Color3.fromRGB(0, 0, 0);
DRR["8"]["ImageTransparency"] = 0.5;
DRR["8"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
DRR["8"]["Image"] = [[rbxassetid://6014261993]];
DRR["8"]["Size"] = UDim2.new(1, 47, 1, 47);
DRR["8"]["Name"] = [[DropShadow]];
DRR["8"]["BackgroundTransparency"] = 1;
DRR["8"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);

-- PickleLibrary.TopBar.UIGradient
DRR["9"] = Instance.new("UIGradient", DRR["2"]);
DRR["9"]["Rotation"] = 90;
DRR["9"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(80, 130, 220)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(120, 180, 255))};

-- PickleLibrary.TopBar.TopBar
DRR["a"] = Instance.new("Frame", DRR["2"]);
DRR["a"]["BorderSizePixel"] = 0;
DRR["a"]["BackgroundColor3"] = Color3.fromRGB(100, 150, 255);
DRR["a"]["LayoutOrder"] = 2;
DRR["a"]["Size"] = UDim2.new(0.9983566999435425, 0, 0.05511785298585892, 0);
DRR["a"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
DRR["a"]["Position"] = UDim2.new(0, 0, 0.4645671844482422, 0);
DRR["a"]["Name"] = [[TopBar]];

-- PickleLibrary.TopBar.TopBar.UIGradient
DRR["b"] = Instance.new("UIGradient", DRR["a"]);
DRR["b"]["Rotation"] = -90;
DRR["b"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(80, 130, 220)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(120, 180, 255))};

-- PickleLibrary.TopBar.ProfileMenu
DRR["c"] = Instance.new("Frame", DRR["2"]);
DRR["c"]["BorderSizePixel"] = 0;
DRR["c"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
DRR["c"]["BackgroundTransparency"] = 1;
DRR["c"]["Size"] = UDim2.new(0.9983566999435425, 0, 0.4645672142505646, 0);
DRR["c"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
DRR["c"]["Name"] = [[ProfileMenu]];

-- PickleLibrary.TopBar.ProfileMenu.PlayerProfile
DRR["d"] = Instance.new("ImageButton", DRR["c"]);
DRR["d"]["BorderSizePixel"] = 0;
DRR["d"]["AutoButtonColor"] = false;
DRR["d"]["BackgroundColor3"] = Color3.fromRGB(30, 60, 120);
DRR["d"]["Size"] = UDim2.new(0.23481373488903046, 0, 0.682426393032074, 0);
DRR["d"]["Name"] = [[PlayerProfile]];
DRR["d"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
DRR["d"]["Position"] = UDim2.new(0.015024710446596146, 0, 0.18421050906181335, 0);

-- PickleLibrary.TopBar.ProfileMenu.PlayerProfile.UICorner
DRR["e"] = Instance.new("UICorner", DRR["d"]);
DRR["e"]["CornerRadius"] = UDim.new(0.30000001192092896, 0);

-- PickleLibrary.TopBar.ProfileMenu.PlayerProfile.UIGradient
DRR["f"] = Instance.new("UIGradient", DRR["d"]);
DRR["f"]["Rotation"] = 90;
DRR["f"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(70, 120, 200)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(100, 180, 255))};

-- PickleLibrary.TopBar.ProfileMenu.PlayerProfile.ImageLabel
DRR["10"] = Instance.new("ImageLabel", DRR["d"]);
DRR["10"]["BorderSizePixel"] = 0;
DRR["10"]["BackgroundColor3"] = Color3.fromRGB(30, 60, 120);
DRR["10"]["Size"] = UDim2.new(0.16644950211048126, 0, 0.8032786846160889, 0);
DRR["10"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
DRR["10"]["Position"] = UDim2.new(0.03799999877810478, 0, 0.1420000046491623, 0);

-- PickleLibrary.TopBar.ProfileMenu.PlayerProfile.ImageLabel.UIAspectRatioConstraint
DRR["11"] = Instance.new("UIAspectRatioConstraint", DRR["10"]);
DRR["11"]["AspectRatio"] = 0.9842342734336853;

-- PickleLibrary.TopBar.ProfileMenu.PlayerProfile.ImageLabel.UICorner
DRR["12"] = Instance.new("UICorner", DRR["10"]);
DRR["12"]["CornerRadius"] = UDim.new(100, 0);

-- PickleLibrary.TopBar.ProfileMenu.PlayerProfile.ImageLabel.UIGradient
DRR["13"] = Instance.new("UIGradient", DRR["10"]);
DRR["13"]["Rotation"] = 90;
DRR["13"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(100, 150, 220)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(150, 200, 255))};

-- PickleLibrary.TopBar.ProfileMenu.PlayerProfile.TextLabel
DRR["14"] = Instance.new("TextLabel", DRR["d"]);
DRR["14"]["TextWrapped"] = true;
DRR["14"]["BorderSizePixel"] = 0;
DRR["14"]["TextScaled"] = true;
DRR["14"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
DRR["14"]["TextXAlignment"] = Enum.TextXAlignment.Left;
DRR["14"]["FontFace"] = Font.new([[rbxassetid://11702779517]], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
DRR["14"]["TextSize"] = 14;
DRR["14"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
DRR["14"]["AutomaticSize"] = Enum.AutomaticSize.X;
DRR["14"]["Size"] = UDim2.new(0.7192937135696411, 0, 0.41530051827430725, 0);
DRR["14"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
DRR["14"]["Text"] = [[PlayerName]];
DRR["14"]["BackgroundTransparency"] = 1;
DRR["14"]["Position"] = UDim2.new(0.23957718908786774, 0, 0.27320244908332825, 0);

-- PickleLibrary.TopBar.ProfileMenu.UIListLayout
DRR["15"] = Instance.new("UIListLayout", DRR["c"]);
DRR["15"]["VerticalAlignment"] = Enum.VerticalAlignment.Center;
DRR["15"]["FillDirection"] = Enum.FillDirection.Horizontal;
DRR["15"]["Padding"] = UDim.new(0.014999999664723873, 0);
DRR["15"]["SortOrder"] = Enum.SortOrder.LayoutOrder;

-- PickleLibrary.TopBar.ProfileMenu.UIPadding
DRR["16"] = Instance.new("UIPadding", DRR["c"]);
DRR["16"]["PaddingLeft"] = UDim.new(0.014000000432133675, 0);

-- PickleLibrary.TopBar.ProfileMenu.Clock
DRR["17"] = Instance.new("ImageButton", DRR["c"]);
DRR["17"]["BorderSizePixel"] = 0;
DRR["17"]["AutoButtonColor"] = false;
DRR["17"]["BackgroundColor3"] = Color3.fromRGB(30, 60, 120);
DRR["17"]["Size"] = UDim2.new(0.10328257083892822, 0, 0.682426393032074, 0);
DRR["17"]["Name"] = [[Clock]];
DRR["17"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
DRR["17"]["Position"] = UDim2.new(0.26031631231307983, 0, 0.158786803483963, 0);

-- PickleLibrary.TopBar.ProfileMenu.Clock.UICorner
DRR["18"] = Instance.new("UICorner", DRR["17"]);
DRR["18"]["CornerRadius"] = UDim.new(0.30000001192092896, 0);

-- PickleLibrary.TopBar.ProfileMenu.Clock.UIGradient
DRR["19"] = Instance.new("UIGradient", DRR["17"]);
DRR["19"]["Rotation"] = 90;
DRR["19"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(70, 120, 200)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(100, 180, 255))};

-- PickleLibrary.TopBar.ProfileMenu.Clock.TextLabel
DRR["1a"] = Instance.new("TextLabel", DRR["17"]);
DRR["1a"]["TextWrapped"] = true;
DRR["1a"]["BorderSizePixel"] = 0;
DRR["1a"]["TextScaled"] = true;
DRR["1a"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
DRR["1a"]["FontFace"] = Font.new([[rbxassetid://11702779517]], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
DRR["1a"]["TextSize"] = 14;
DRR["1a"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
DRR["1a"]["AutomaticSize"] = Enum.AutomaticSize.X;
DRR["1a"]["Size"] = UDim2.new(0.33195531368255615, 0, 0.41530051827430725, 0);
DRR["1a"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
DRR["1a"]["Text"] = [[00:00]];
DRR["1a"]["BackgroundTransparency"] = 1;
DRR["1a"]["Position"] = UDim2.new(0.21512815356254578, 0, 0.27320244908332825, 0);

-- PickleLibrary.TopBar.ProfileMenu.Title
DRR["1b"] = Instance.new("ImageButton", DRR["c"]);
DRR["1b"]["BorderSizePixel"] = 0;
DRR["1b"]["AutoButtonColor"] = false;
DRR["1b"]["BackgroundColor3"] = Color3.fromRGB(30, 60, 120);
DRR["1b"]["Size"] = UDim2.new(0.23481373488903046, 0, 0.682426393032074, 0);
DRR["1b"]["Name"] = [[Title]];
DRR["1b"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
DRR["1b"]["Position"] = UDim2.new(0.015024710446596146, 0, 0.18421050906181335, 0);

-- PickleLibrary.TopBar.ProfileMenu.Title.UICorner
DRR["1c"] = Instance.new("UICorner", DRR["1b"]);
DRR["1c"]["CornerRadius"] = UDim.new(0.30000001192092896, 0);

-- PickleLibrary.TopBar.ProfileMenu.Title.UIGradient
DRR["1d"] = Instance.new("UIGradient", DRR["1b"]);
DRR["1d"]["Rotation"] = 90;
DRR["1d"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(70, 120, 200)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(100, 180, 255))};

-- PickleLibrary.TopBar.ProfileMenu.Title.TextLabel
DRR["1e"] = Instance.new("TextLabel", DRR["1b"]);
DRR["1e"]["TextWrapped"] = true;
DRR["1e"]["BorderSizePixel"] = 0;
DRR["1e"]["TextScaled"] = true;
DRR["1e"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
DRR["1e"]["FontFace"] = Font.new([[rbxassetid://11702779517]], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
DRR["1e"]["TextSize"] = 14;
DRR["1e"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
DRR["1e"]["AutomaticSize"] = Enum.AutomaticSize.X;
DRR["1e"]["Size"] = UDim2.new(0.7192937135696411, 0, 0.41530051827430725, 0);
DRR["1e"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
DRR["1e"]["Text"] = [[PickleLibrary]];  -- Changed to PickleLibrary
DRR["1e"]["BackgroundTransparency"] = 1;
DRR["1e"]["Position"] = UDim2.new(0.13402166962623596, 0, 0.27320244908332825, 0);

-- PickleLibrary.TopBar.TopBarClose
DRR["1f"] = Instance.new("TextButton", DRR["2"]);
DRR["1f"]["Active"] = false;
DRR["1f"]["BorderSizePixel"] = 0;
DRR["1f"]["AutoButtonColor"] = false;
DRR["1f"]["BackgroundColor3"] = Color3.fromRGB(30, 60, 120);
DRR["1f"]["Selectable"] = false;
DRR["1f"]["Size"] = UDim2.new(0.08402203768491745, 0, 0.4803149402141571, 0);
DRR["1f"]["Name"] = [[TopBarClose]];
DRR["1f"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
DRR["1f"]["Text"] = [[]];
DRR["1f"]["Position"] = UDim2.new(0.915977954864502, 0, 0.5196850299835205, 0);

-- PickleLibrary.TopBar.TopBarClose.UICorner
DRR["20"] = Instance.new("UICorner", DRR["1f"]);
DRR["20"]["CornerRadius"] = UDim.new(0.20000000298023224, 0);

-- PickleLibrary.TopBar.TopBarClose.UIGradient
DRR["21"] = Instance.new("UIGradient", DRR["1f"]);
DRR["21"]["Rotation"] = 90;
DRR["21"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(70, 120, 200)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(100, 180, 255))};

-- PickleLibrary.TopBar.TopBarClose.idk
DRR["22"] = Instance.new("Frame", DRR["1f"]);
DRR["22"]["BorderSizePixel"] = 0;
DRR["22"]["BackgroundColor3"] = Color3.fromRGB(30, 60, 120);
DRR["22"]["Size"] = UDim2.new(0.2622910141944885, 0, 1, 0);
DRR["22"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
DRR["22"]["Position"] = UDim2.new(0.000002001152552111307, 0, 0, 0);
DRR["22"]["Name"] = [[idk]];

-- PickleLibrary.TopBar.TopBarClose.idk.UIGradient
DRR["23"] = Instance.new("UIGradient", DRR["22"]);
DRR["23"]["Rotation"] = 90;
DRR["23"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(70, 120, 200)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(100, 180, 255))};

-- PickleLibrary.TopBar.TopBarClose.UIAspectRatioConstraint
DRR["24"] = Instance.new("UIAspectRatioConstraint", DRR["1f"]);

-- PickleLibrary.TopBar.TopBarClose.ImageLabel
DRR["25"] = Instance.new("ImageLabel", DRR["1f"]);
DRR["25"]["BorderSizePixel"] = 0;
DRR["25"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
DRR["25"]["Image"] = [[rbxassetid://14122651741]];
DRR["25"]["LayoutOrder"] = 1;
DRR["25"]["Size"] = UDim2.new(0.5081987380981445, 0, 0.5971601009368896, 0);
DRR["25"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
DRR["25"]["BackgroundTransparency"] = 1;
DRR["25"]["Position"] = UDim2.new(0.24589963257312775, 0, 0.23339086771011353, 0);

-- PickleLibrary.TopBar.TopBarClose.ImageLabel.UIAspectRatioConstraint
DRR["26"] = Instance.new("UIAspectRatioConstraint", DRR["25"]);
DRR["26"]["AspectRatio"] = 0.9836804866790771;

-- PickleLibrary.TopBar.UIAspectRatioConstraint
DRR["27"] = Instance.new("UIAspectRatioConstraint", DRR["2"]);
DRR["27"]["AspectRatio"] = 5.724700927734375;

-- PickleLibrary.MainBar
DRR["28"] = Instance.new("Frame", DRR["1"]);
DRR["28"]["BorderSizePixel"] = 0;
DRR["28"]["BackgroundColor3"] = Color3.fromRGB(20, 40, 80);  -- Dark blue
DRR["28"]["Size"] = UDim2.new(0.5404488444328308, 0, 0.5745577812194824, 0);
DRR["28"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
DRR["28"]["Position"] = UDim2.new(0.23000000417232513, 0, -0.6119999885559082, 0);
DRR["28"]["Name"] = [[MainBar]];

-- PickleLibrary.MainBar.UICorner
DRR["29"] = Instance.new("UICorner", DRR["28"]);
DRR["29"]["CornerRadius"] = UDim.new(0.029999999329447746, 0);

-- PickleLibrary.MainBar.UIGradient
DRR["2a"] = Instance.new("UIGradient", DRR["28"]);
DRR["2a"]["Rotation"] = 90;
DRR["2a"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(30, 60, 120)),ColorSequenceKeypoint.new(0.231, Color3.fromRGB(50, 100, 180)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(100, 150, 220))};

-- PickleLibrary.MainBar.UIAspectRatioConstraint
DRR["2b"] = Instance.new("UIAspectRatioConstraint", DRR["28"]);
DRR["2b"]["AspectRatio"] = 1.7326968908309937;

-- PickleLibrary.MainBar.DropShadowHolder
DRR["2c"] = Instance.new("Frame", DRR["28"]);
DRR["2c"]["ZIndex"] = 0;
DRR["2c"]["BorderSizePixel"] = 0;
DRR["2c"]["BackgroundTransparency"] = 1;
DRR["2c"]["LayoutOrder"] = -1;
DRR["2c"]["Size"] = UDim2.new(1, 0, 1, 0);
DRR["2c"]["Name"] = [[DropShadowHolder]];

-- PickleLibrary.MainBar.DropShadowHolder.DropShadow
DRR["2d"] = Instance.new("ImageLabel", DRR["2c"]);
DRR["2d"]["ZIndex"] = 0;
DRR["2d"]["BorderSizePixel"] = 0;
DRR["2d"]["SliceCenter"] = Rect.new(49, 49, 450, 450);
DRR["2d"]["ScaleType"] = Enum.ScaleType.Slice;
DRR["2d"]["ImageColor3"] = Color3.fromRGB(0, 0, 0);
DRR["2d"]["ImageTransparency"] = 0.5;
DRR["2d"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
DRR["2d"]["Image"] = [[rbxassetid://6014261993]];
DRR["2d"]["Size"] = UDim2.new(1, 47, 1, 47);
DRR["2d"]["Name"] = [[DropShadow]];
DRR["2d"]["BackgroundTransparency"] = 1;
DRR["2d"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);

-- PickleLibrary.MainBar.Logo
DRR["2e"] = Instance.new("ImageLabel", DRR["28"]);
DRR["2e"]["BorderSizePixel"] = 0;
DRR["2e"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
DRR["2e"]["Image"] = [[rbxassetid://14133403065]];
DRR["2e"]["Size"] = UDim2.new(0.18741475045681, 0, 0.3247329592704773, 0);
DRR["2e"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
DRR["2e"]["Name"] = [[Logo]];
DRR["2e"]["BackgroundTransparency"] = 1;
DRR["2e"]["Position"] = UDim2.new(0.3991934061050415, 0, 0.33447495102882385, 0);

-- PickleLibrary.MainBar.Logo.UIGradient
DRR["2f"] = Instance.new("UIGradient", DRR["2e"]);
DRR["2f"]["Rotation"] = 90;
DRR["2f"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(100, 150, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(20, 40, 80))};

-- PickleLibrary.Folder
DRR["30"] = Instance.new("Folder", DRR["1"]);

-- ... (rest of the UI elements with similar color adjustments) ...

-- PickleLibrary.Library
DRR["93"] = Instance.new("ModuleScript", DRR["1"]);
DRR["93"]["Name"] = [[Library]];

-- Require DRR wrapper
local DRR_REQUIRE = require;
local DRR_MODULES = {};
local function require(Module:ModuleScript)
    local ModuleState = DRR_MODULES[Module];
    if ModuleState then
        if not ModuleState.Required then
            ModuleState.Required = true;
            ModuleState.Value = ModuleState.Closure();
        end
        return ModuleState.Value;
    end;
    return DRR_REQUIRE(Module);
end

DRR_MODULES[DRR["93"]] = {
Closure = function()
    local script = DRR["93"];
local UILIB = {}
local parent  = script.Parent
local reserved = parent.Folder
UILIB.__index = UILIB

local listening = false
local twServ = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local GlobalColor1 = Color3.fromRGB(30, 60, 120)  -- Dark blue
local GlobalColor2 = Color3.fromRGB(100, 200, 255) -- Light blue
local closed = false

parent.TopBar.ProfileMenu.PlayerProfile.TextLabel.Text = game:GetService("Players").LocalPlayer.DisplayName
parent.TopBar.ProfileMenu.PlayerProfile.ImageLabel.Image = game:GetService("Players"):GetUserThumbnailAsync(game.Players.LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)

function UILIB:Load(name, img, direction)
    local self = setmetatable({}, UILIB)
    task.spawn(function()
            local tw = twServ:Create(parent.MainBar, TweenInfo.new(0.4, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), { Position = UDim2.new(0.23, 0,0.212, 0) })
            local tw2 = twServ:Create(parent.TopBar, TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Position = UDim2.new(0.23, 0,0.012, 0) })
            tw:Play()
            tw.Completed:Wait()
            task.wait(0.3)
            tw2:Play()
    end)
        task.spawn(function()
         while true do
        task.wait(0.1)
        parent.TopBar.ProfileMenu.Clock.TextLabel.Text = os.date("%H:%m")
         end
        end)
    parent.TopBar.ProfileMenu.Title.TextLabel.Text = "PickleLibrary"  -- Changed to PickleLibrary
    if img then
        parent.MainBar.Logo.Image = img
    elseif img == "Default" then

    else
        parent.MainBar.Logo.Image = ""
        end

    parent.TopBar.TopBarClose.MouseButton1Click:Connect(function()
        if closed == false then
            closed = true
            local tw = twServ:Create(parent.MainBar, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Position = UDim2.new(0.23, 0,-0.612, 0) })
            local tw3 = twServ:Create(parent.TopBar.TopBarClose, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Position = UDim2.new(0.916, 0,0.95, 0) })
            local tw2 = twServ:Create(parent.TopBar, TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), { Position = UDim2.new(0.23, 0,-0.173, 0) })
            local twRotate = twServ:Create(parent.TopBar.TopBarClose.ImageLabel, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Rotation = 180 })

            tw:Play()
            tw.Completed:Wait()
            tw2:Play()
            task.wait(0.1)
            twRotate:Play()
            tw3:Play()
            
        elseif closed == true then
            closed = false
            local tw = twServ:Create(parent.MainBar, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Position = UDim2.new(0.23, 0,0.212, 0) })
            local tw3 = twServ:Create(parent.TopBar.TopBarClose, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Position = UDim2.new(0.916, 0,0.52, 0) })
            local tw2 = twServ:Create(parent.TopBar, TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), { Position = UDim2.new(0.23, 0,0.012, 0) })
            local twRotate = twServ:Create(parent.TopBar.TopBarClose.ImageLabel, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Rotation = 0 })

            tw:Play()
            tw.Completed:Wait()
            tw2:Play()
            task.wait(0.1)
            twRotate:Play()
            tw3:Play()
        end
    end)

    function self:Open()
        local tw = twServ:Create(parent.MainBar, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Position = UDim2.new(0.23, 0,0.212, 0) })
        local tw3 = twServ:Create(parent.TopBar.TopBarClose, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Position = UDim2.new(0.916, 0,0.52, 0) })
        local tw2 = twServ:Create(parent.TopBar, TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), { Position = UDim2.new(0.23, 0,0.012, 0) })
        local twRotate = twServ:Create(parent.TopBar.TopBarClose.ImageLabel, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Rotation = 0 })

        tw:Play()
        tw.Completed:Wait()
        tw2:Play()
        task.wait(0.1)
        twRotate:Play()
        tw3:Play()
    end

    function self:Close()
        local tw = twServ:Create(parent.MainBar, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Position = UDim2.new(0.23, 0,-0.612, 0) })
        local tw3 = twServ:Create(parent.TopBar.TopBarClose, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Position = UDim2.new(0.916, 0,0.95, 0) })
        local tw2 = twServ:Create(parent.TopBar, TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), { Position = UDim2.new(0.23, 0,-0.173, 0) })
        local twRotate = twServ:Create(parent.TopBar.TopBarClose.ImageLabel, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Rotation = 180 })

        tw:Play()
        tw.Completed:Wait()
        tw2:Play()
        task.wait(0.1)
        twRotate:Play()
        tw3:Play()
    end
    function self:HideCloseButton()
        DRR["1f"].Visible = false
    end
        function self:Hide()
        DDR["1"].Enabled = false
    end
    function self:Show()
        DDR["1"].Enabled = true
        end
    function self:Toggle()
        if closed == false then
            closed = true
            local tw = twServ:Create(parent.MainBar, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Position = UDim2.new(0.23, 0,-0.612, 0) })
            local tw3 = twServ:Create(parent.TopBar.TopBarClose, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Position = UDim2.new(0.916, 0,0.95, 0) })
            local tw2 = twServ:Create(parent.TopBar, TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), { Position = UDim2.new(0.23, 0,-0.173, 0) })
            local twRotate = twServ:Create(parent.TopBar.TopBarClose.ImageLabel, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Rotation = 180 })

            tw:Play()
            tw.Completed:Wait()
            tw2:Play()
            tw2.Completed:Wait()
            twRotate:Play()
            tw3:Play()
        elseif closed == true then
            closed = false
            local tw = twServ:Create(parent.MainBar, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Position = UDim2.new(0.23, 0,0.212, 0) })
            local tw3 = twServ:Create(parent.TopBar.TopBarClose, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Position = UDim2.new(0.916, 0,0.52, 0) })
            local tw2 = twServ:Create(parent.TopBar, TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), { Position = UDim2.new(0.23, 0,0.012, 0) })
            local twRotate = twServ:Create(parent.TopBar.TopBarClose.ImageLabel, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Rotation = 0 })

            tw:Play()
            tw.Completed:Wait()
            tw2:Play()
            tw2.Completed:Wait()
            twRotate:Play()
            tw3:Play()
        end
    end
    function self:SetTheme(color, color2)
        for i,v in pairs(parent:GetChildren()) do
            if v:IsA("GuiObject") then
                pcall(function()
                    if v.BackgroundColor3 == Color3.fromRGB(39, 44, 61) then
                        v.BackgroundColor3 = color
                        GlobalColor1 = color
                    elseif v.BackgroundColor3 == Color3.fromRGB(0, 255, 38) then
                        v.BackgroundColor3 = color2
                        GlobalColor2 = color2
                    end
                end)
            end
        end
    end
end

function UILIB.newTab(name, img)    
    local self = setmetatable({}, UILIB)

    local newTab = parent.Folder.TabReserved:Clone()
    newTab.Parent = parent.MainBar
    newTab.Name = name
    newTab.Visible = false

    local newTabBtn = parent.Folder.TabButtonReserved:Clone()
    newTabBtn.Parent = parent.TopBar.ScrollingFrame
    newTabBtn.Name = name or "Tab"..#parent.MainBar:GetChildren() - 4
    newTabBtn.Frame.TextLabel.Text = name
    if img then
        newTabBtn.ImageLabel.Image = img
    else
        newTabBtn.ImageLabel.Image = ""
    end
    newTabBtn.Visible = true

    newTabBtn.MouseButton1Click:Connect(function()
        for i,v in pairs(parent.TopBar.ScrollingFrame:GetChildren()) do
            if v:IsA("ImageButton") then
                local vTab = parent.MainBar:FindFirstChild(v.Name)
                if v.Name ~= name then
                    local twBtn = twServ:Create(v, TweenInfo.new(0.2), { Transparency = 0.75})

                    twBtn:Play()

                    vTab.Visible = false
                elseif v.Name == name then
                    vTab.Visible = true
                    local twBtn = twServ:Create(v, TweenInfo.new(0.2), { Transparency = 0 })

                    twBtn:Play()

                end

            end
        end
    end)

    function self.newButton(name, desc, func)
        local newbtn = reserved.Button:Clone()
        newbtn.Parent = newTab
        newbtn.Title.Text = name
        newbtn.Description.Text = desc
        newbtn.Visible = true
        newbtn.Name = name

        newbtn.MouseEnter:Connect(function()
            local twBtn = twServ:Create(newbtn, TweenInfo.new(0.2), { Transparency = 0 })

            twBtn:Play()
        end)
        newbtn.MouseLeave:Connect(function()
            local twBtn = twServ:Create(newbtn, TweenInfo.new(0.2), { Transparency = 0.4 })

            twBtn:Play()
        end)
        newbtn.MouseButton1Click:Connect(func)
    end

    function self.newLabel(text)
        local newLabel = reserved.Label:Clone()
        newLabel.Parent = newTab
        newLabel.Visible = true
        newLabel.Title.Text = text

        return newLabel.Title
    end

        function self.editLabel(newLabel, text)
        newLabel.Parent = newTab
        newLabel.Visible = true
        newLabel.Title.Text = text

        return newLabel.Title
        end

    function self.newInput(name, desc, func)
        local newInput = reserved.Textbox:Clone()
        local textbox = newInput.TextboxBar.ActualTextbox

        newInput.MouseEnter:Connect(function()
            local twBtn = twServ:Create(newInput, TweenInfo.new(0.2), { Transparency = 0 })

            twBtn:Play()
        end)
        newInput.MouseLeave:Connect(function()
            local twBtn = twServ:Create(newInput, TweenInfo.new(0.2), { Transparency = 0.4 })

            twBtn:Play()


        end)

        newInput.Visible = true
        newInput.Parent = newTab
        newInput.Title.Text = name
        newInput.Description.Text = desc
        newInput.Name = name

        textbox.FocusLost:Connect(function()
            func(textbox.Text)
        end)

    end

    function self.newKeybind(name, desc, func)
        local newKey = reserved.Keybind:Clone()


        newKey.MouseEnter:Connect(function()
            local twBtn = twServ:Create(newKey, TweenInfo.new(0.2), { Transparency = 0 })

            twBtn:Play()
        end)
        newKey.MouseLeave:Connect(function()
            local twBtn = twServ:Create(newKey, TweenInfo.new(0.2), { Transparency = 0.4 })

            twBtn:Play()
        end)
        newKey.Parent = newTab
        newKey.Title.Text = name
        newKey.Name = name
        newKey.Description.Text = desc
        newKey.Visible =  true

        local listening = false
        local a

        newKey.Bind.Button.MouseButton1Click:Connect(function()
            listening = true


            local function Loop()
                if listening then
                    newKey.Bind.Button.Text = "."
                end

                task.wait(0.5)
                if listening then
                    newKey.Bind.Button.Text = ".."
                end
                task.wait(0.5)
                if listening then
                    newKey.Bind.Button.Text = "..."
                end
                task.wait(0.5)
            end

            task.spawn(function()
                while listening do
                    Loop()
                end
            end)

            -- Connect the InputBegan event
            a = game:GetService("UserInputService").InputBegan:Connect(function(input, processed)
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    newKey.Bind.Button.Text = input.KeyCode.Name
                    listening = false
                    a:Disconnect()
                    func(input)
                elseif input.UserInputType == Enum.UserInputType.MouseButton1 or
                    input.UserInputType == Enum.UserInputType.MouseButton2 or
                    input.UserInputType == Enum.UserInputType.MouseButton3 then
                    newKey.Bind.Button.Text = input.UserInputType.Name
                    listening = false
                    a:Disconnect()
                    func(input)
                end
            end)
        end)
    end


    function self.newSlider(name, desc, max, manageSlider, func)
        local newSlider = reserved.Slider:Clone()

        newSlider.MouseEnter:Connect(function()
            local twBtn = twServ:Create(newSlider, TweenInfo.new(0.2), { Transparency = 0 })

            twBtn:Play()
        end)
        newSlider.MouseLeave:Connect(function()
            local twBtn = twServ:Create(newSlider, TweenInfo.new(0.2), { Transparency = 0.4 })

            twBtn:Play()
        end)
        newSlider.Visible = true
        newSlider.Name = name
        newSlider.Parent = newTab
        newSlider.Title.Text = name
        newSlider.Description.Text = desc

        local Mouse = game.Players.LocalPlayer:GetMouse()
        local tweenServ = twServ

        local Trigger = newSlider.ActualSlider.Trigger
        local Label = newSlider.ActualSlider.Title
        local Fill = newSlider.ActualSlider.Fill
        local Parent = newSlider.ActualSlider

        local perc
        local Percent
        local MouseDown = false
        local delayTw = 0.3

        local function Update()
            MouseDown = true
            repeat
                task.wait()
                Percent = math.clamp((Mouse.X - Parent.AbsolutePosition.X) / Parent.AbsoluteSize.X, 0, 1)
                perc = math.round(Percent * max)
                if manageSlider == false then
                    Label.Text = perc
                    func(perc)
                elseif manageSlider == true then
                    Label.Text = perc
                    func(perc, Label)
                end
                local tween = tweenServ:Create(Fill, TweenInfo.new(delayTw, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.fromScale(Percent, 1) })
                tween:Play()
            until MouseDown == false
        end

        Trigger.MouseButton1Down:Connect(Update)

        UIS.InputEnded:Connect(function(input)
            if input.UserInputType ==  Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                MouseDown = false
            end
        end)

    end
    
    function self.newToggle(title, desc, toggle, func)
        local realToggle = toggle
        local newToggle = reserved.Toggle:Clone()
        newToggle.Parent = newTab
        newToggle.Name = title
        newToggle.Visible = true
        newToggle.Title.Text = title
        newToggle.Description.Text = desc
        
        
        newToggle.MouseEnter:Connect(function()
            local twBtn = twServ:Create(newToggle, TweenInfo.new(0.2), { Transparency = 0 })

            twBtn:Play()
        end)
        newToggle.MouseLeave:Connect(function()
            local twBtn = twServ:Create(newToggle, TweenInfo.new(0.2), { Transparency = 0.4 })

            twBtn:Play()
        end)
        
        
        if realToggle == true then
            newToggle.Label.BackgroundColor3 = GlobalColor2
        elseif realToggle == false then
            newToggle.Label.BackgroundColor3 = GlobalColor1
        end
        
        
        
        newToggle.Label.Label.MouseButton1Click:Connect(function()
            
            if realToggle == true then
                realToggle = false
                local twColorOn = twServ:Create(newToggle.Label, TweenInfo.new(0.2), { BackgroundColor3 = GlobalColor1 })
                twColorOn:Play()
                
                func(realToggle)
            elseif realToggle == false then
                realToggle = true
                local twColorOn = twServ:Create(newToggle.Label, TweenInfo.new(0.2), { BackgroundColor3 = GlobalColor2 })
                twColorOn:Play()
                
                func(realToggle)
            end
        end)
        
    end
    
    function self.newDropdown(name, desc, listTable, func)
        local newdd = reserved.Dropdown:Clone()
        newdd.Visible = true
        newdd.Parent = newTab
        
        newdd.Name = name
        newdd.Title.Text = name
        newdd.Description.Text = desc
        
        for i, list in ipairs(listTable) do
            local newddbtn = reserved.DropdownButton:Clone()
            newddbtn.Visible = true
            newddbtn.Parent = newdd.Box.ScrollingFrame

            newddbtn.Name = list
            newddbtn.name.Text = list
            task.spawn(function()
                newddbtn.MouseButton1Click:Connect(function()
                    newdd.DropdownBar.Open.Text = list
                    local twPos = twServ:Create(newdd.Box, TweenInfo.new(0.15), {Size = UDim2.new(0.97, 0,0, 0)})
                    twPos:Play()
                    twPos.Completed:Wait()
                    newdd.Box.Visible = false
                    func(list)
                end)
            end)
        end        
        
        newdd.DropdownBar.Trigger.MouseButton1Click:Connect(function()
            
            
            if newdd.Box.Visible == false then
                newdd.Box.Visible = true
                local twPos = twServ:Create(newdd.Box, TweenInfo.new(0.15), {Size = UDim2.new(0.97, 0,1.696, 0)})
                twPos:Play()
            elseif newdd.Box.Visible == true then
                local twPos = twServ:Create(newdd.Box, TweenInfo.new(0.15), {Size = UDim2.new(0.97, 0,0, 0)})
                twPos:Play()
                twPos.Completed:Wait()
                newdd.Box.Visible = false
            end
        end)
    end

    return self
end

return UILIB
end;
};

return require(DRR["93"]);
