-- ╔══════════════════════════════════════════════════════╗
-- ║           CYPHERX HUB — ESCAPE V3                   ║
-- ║         Rewritten for clarity & performance          ║
-- ╚══════════════════════════════════════════════════════╝

if not game:IsLoaded() then game.Loaded:Wait() end

-- ┌─────────────────────────────────┐
-- │         SERVICES                │
-- └─────────────────────────────────┘
local Players      = game:GetService("Players")
local RunService   = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UIS          = game:GetService("UserInputService")

local player    = Players.LocalPlayer
local mouse     = player:GetMouse()

-- ┌─────────────────────────────────┐
-- │         CONSTANTS               │
-- └─────────────────────────────────┘
local TWEEN_FAST   = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local TWEEN_MED    = TweenInfo.new(0.30, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local TWEEN_SLOW   = TweenInfo.new(0.45, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)

local THEME = {
    BG          = Color3.fromRGB(13, 13, 17),
    SURFACE     = Color3.fromRGB(20, 20, 27),
    ELEVATED    = Color3.fromRGB(26, 26, 34),
    BORDER      = Color3.fromRGB(38, 38, 52),
    ACCENT      = Color3.fromRGB(99, 102, 241),   -- indigo
    ACCENT_DIM  = Color3.fromRGB(60, 62, 150),
    SUCCESS     = Color3.fromRGB(34, 197, 94),
    WARN        = Color3.fromRGB(251, 146, 60),
    DANGER      = Color3.fromRGB(239, 68, 68),
    TEXT        = Color3.fromRGB(240, 240, 248),
    TEXT_DIM    = Color3.fromRGB(140, 140, 158),
    TEXT_MUTED  = Color3.fromRGB(80, 80, 100),
    WHITE       = Color3.fromRGB(255, 255, 255),
}

-- ┌─────────────────────────────────┐
-- │         HELPERS                 │
-- └─────────────────────────────────┘
local function tween(obj, goal, info)
    TweenService:Create(obj, info or TWEEN_FAST, goal):Play()
end

local function getCharacter()
    return player.Character
end

local function getHRP()
    local c = getCharacter()
    return c and c:FindFirstChild("HumanoidRootPart")
end

local function getHumanoid()
    local c = getCharacter()
    return c and c:FindFirstChildOfClass("Humanoid")
end

local function make(className, props, parent)
    local inst = Instance.new(className)
    for k, v in pairs(props) do
        inst[k] = v
    end
    if parent then inst.Parent = parent end
    return inst
end

local function corner(radius, parent)
    return make("UICorner", { CornerRadius = UDim.new(0, radius) }, parent)
end

local function stroke(color, thickness, parent)
    return make("UIStroke", { Color = color, Thickness = thickness }, parent)
end

-- ┌─────────────────────────────────┐
-- │         SCREENGUI               │
-- └─────────────────────────────────┘
local ScreenGui = make("ScreenGui", {
    Name           = "CypherX_V3",
    ResetOnSpawn   = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
})
local ok = pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not ok then ScreenGui.Parent = player:WaitForChild("PlayerGui") end

-- ┌─────────────────────────────────┐
-- │         MAIN WINDOW             │
-- └─────────────────────────────────┘
local WIN_W, WIN_H = 540, 340

local MainWindow = make("Frame", {
    Size              = UDim2.fromOffset(WIN_W, WIN_H),
    Position          = UDim2.new(0.5, -WIN_W/2, 0.5, -WIN_H/2),
    BackgroundColor3  = THEME.BG,
    BorderSizePixel   = 0,
    Active            = true,
    Draggable         = true,
    ClipsDescendants  = true,
}, ScreenGui)
corner(14, MainWindow)
stroke(THEME.BORDER, 1.5, MainWindow)

-- Subtle ambient gradient overlay
local ambientGrad = make("Frame", {
    Size             = UDim2.new(1, 0, 0.4, 0),
    BackgroundColor3 = THEME.ACCENT,
    BackgroundTransparency = 0.93,
    BorderSizePixel  = 0,
    ZIndex           = 0,
}, MainWindow)
corner(14, ambientGrad)
make("UIGradient", {
    Rotation    = 90,
    Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(1, 1),
    }),
}, ambientGrad)

-- ┌─────────────────────────────────┐
-- │         TITLE BAR               │
-- └─────────────────────────────────┘
local TitleBar = make("Frame", {
    Size             = UDim2.new(1, 0, 0, 44),
    BackgroundColor3 = THEME.SURFACE,
    BorderSizePixel  = 0,
}, MainWindow)
corner(14, TitleBar)
-- flatten bottom corners
make("Frame", {
    Size             = UDim2.new(1, 0, 0, 14),
    Position         = UDim2.new(0, 0, 1, -14),
    BackgroundColor3 = THEME.SURFACE,
    BorderSizePixel  = 0,
}, TitleBar)

-- Accent left stripe
make("Frame", {
    Size             = UDim2.new(0, 3, 0, 22),
    Position         = UDim2.new(0, 14, 0.5, -11),
    BackgroundColor3 = THEME.ACCENT,
    BorderSizePixel  = 0,
}, TitleBar)

make("TextLabel", {
    Size                = UDim2.new(1, -50, 1, 0),
    Position            = UDim2.new(0, 26, 0, 0),
    Text                = "CYPHERX HUB",
    TextColor3          = THEME.TEXT,
    Font                = Enum.Font.GothamBold,
    TextSize            = 13,
    TextXAlignment      = Enum.TextXAlignment.Left,
    BackgroundTransparency = 1,
}, TitleBar)

make("TextLabel", {
    Size                = UDim2.new(1, -50, 1, 0),
    Position            = UDim2.new(0, 120, 0, 0),
    Text                = "ESCAPE  •  V3",
    TextColor3          = THEME.TEXT_MUTED,
    Font                = Enum.Font.Gotham,
    TextSize            = 11,
    TextXAlignment      = Enum.TextXAlignment.Left,
    BackgroundTransparency = 1,
}, TitleBar)

-- Close / Minimise buttons
local function titleBtn(xOff, label, col)
    local b = make("TextButton", {
        Size             = UDim2.fromOffset(16, 16),
        Position         = UDim2.new(1, xOff, 0.5, -8),
        BackgroundColor3 = col,
        Text             = "",
        BorderSizePixel  = 0,
    }, TitleBar)
    corner(8, b)
    make("TextLabel", {
        Size                = UDim2.fromScale(1, 1),
        Text                = label,
        TextColor3          = Color3.fromRGB(30, 30, 30),
        Font                = Enum.Font.GothamBold,
        TextSize            = 9,
        BackgroundTransparency = 1,
    }, b)
    return b
end

local CloseBtn    = titleBtn(-18, "✕", Color3.fromRGB(239, 68, 68))
local MinimiseBtn = titleBtn(-40, "—", Color3.fromRGB(251, 191, 36))

-- Minimise / show toggle
local minimised = false
local ContentArea  -- forward reference, assigned below

CloseBtn.MouseButton1Click:Connect(function()
    tween(MainWindow, { Size = UDim2.fromOffset(WIN_W, 0) }, TWEEN_MED)
    task.wait(0.3)
    ScreenGui:Destroy()
end)

MinimiseBtn.MouseButton1Click:Connect(function()
    minimised = not minimised
    if minimised then
        tween(MainWindow, { Size = UDim2.fromOffset(WIN_W, 44) }, TWEEN_MED)
    else
        tween(MainWindow, { Size = UDim2.fromOffset(WIN_W, WIN_H) }, TWEEN_MED)
    end
end)

-- ┌─────────────────────────────────┐
-- │         SIDEBAR                 │
-- └─────────────────────────────────┘
local SIDEBAR_W = 135

local SideBar = make("Frame", {
    Size             = UDim2.new(0, SIDEBAR_W, 1, -44),
    Position         = UDim2.new(0, 0, 0, 44),
    BackgroundColor3 = THEME.SURFACE,
    BorderSizePixel  = 0,
}, MainWindow)

-- right separator line
make("Frame", {
    Size             = UDim2.new(0, 1, 1, 0),
    Position         = UDim2.new(1, -1, 0, 0),
    BackgroundColor3 = THEME.BORDER,
    BorderSizePixel  = 0,
}, SideBar)

-- Version badge at sidebar bottom
make("TextLabel", {
    Size                = UDim2.new(1, 0, 0, 20),
    Position            = UDim2.new(0, 0, 1, -24),
    Text                = "v3.0 • cypherx",
    TextColor3          = THEME.TEXT_MUTED,
    Font                = Enum.Font.Gotham,
    TextSize            = 9,
    BackgroundTransparency = 1,
}, SideBar)

-- ┌─────────────────────────────────┐
-- │         PAGE CONTAINER          │
-- └─────────────────────────────────┘
ContentArea = make("Frame", {
    Size             = UDim2.new(1, -SIDEBAR_W, 1, -44),
    Position         = UDim2.new(0, SIDEBAR_W, 0, 44),
    BackgroundTransparency = 1,
    ClipsDescendants = true,
}, MainWindow)

-- ┌─────────────────────────────────┐
-- │    NOTIFICATION SYSTEM          │
-- └─────────────────────────────────┘
local notifQueue   = {}
local notifRunning = false

local function showNotification(message, notifType)
    notifType = notifType or "info"
    local colors = {
        success = THEME.SUCCESS,
        warn    = THEME.WARN,
        danger  = THEME.DANGER,
        info    = THEME.ACCENT,
    }
    local icons = {
        success = "✓",
        warn    = "!",
        danger  = "✕",
        info    = "i",
    }
    local col  = colors[notifType]  or THEME.ACCENT
    local icon = icons[notifType] or "i"

    table.insert(notifQueue, { msg = message, col = col, icon = icon })
    if notifRunning then return end
    notifRunning = true

    task.spawn(function()
        while #notifQueue > 0 do
            local item = table.remove(notifQueue, 1)

            local Notif = make("Frame", {
                Size             = UDim2.fromOffset(240, 38),
                Position         = UDim2.new(1, -250, 1, 10),
                BackgroundColor3 = THEME.ELEVATED,
                BorderSizePixel  = 0,
                ZIndex           = 10,
            }, MainWindow)
            corner(8, Notif)
            stroke(item.col, 1, Notif)

            -- Icon circle
            local iconFrame = make("Frame", {
                Size             = UDim2.fromOffset(22, 22),
                Position         = UDim2.new(0, 9, 0.5, -11),
                BackgroundColor3 = item.col,
                BackgroundTransparency = 0.75,
                BorderSizePixel  = 0,
                ZIndex           = 11,
            }, Notif)
            corner(11, iconFrame)
            make("TextLabel", {
                Size                = UDim2.fromScale(1, 1),
                Text                = item.icon,
                TextColor3          = item.col,
                Font                = Enum.Font.GothamBold,
                TextSize            = 11,
                BackgroundTransparency = 1,
                ZIndex              = 12,
            }, iconFrame)

            make("TextLabel", {
                Size                = UDim2.new(1, -48, 1, 0),
                Position            = UDim2.new(0, 40, 0, 0),
                Text                = item.msg,
                TextColor3          = THEME.TEXT,
                Font                = Enum.Font.Gotham,
                TextSize            = 11,
                TextXAlignment      = Enum.TextXAlignment.Left,
                BackgroundTransparency = 1,
                TextWrapped         = true,
                ZIndex              = 11,
            }, Notif)

            -- slide in
            tween(Notif, { Position = UDim2.new(1, -250, 1, -48) }, TWEEN_MED)
            task.wait(2)
            -- slide out
            tween(Notif, { Position = UDim2.new(1, -250, 1, 10) }, TWEEN_MED)
            task.wait(0.35)
            Notif:Destroy()
            task.wait(0.1)
        end
        notifRunning = false
    end)
end

-- ┌─────────────────────────────────┐
-- │    TAB SYSTEM                   │
-- └─────────────────────────────────┘
local tabs      = {}
local pages     = {}
local activeTab = nil

local tabListLayout = make("UIListLayout", {
    SortOrder      = Enum.SortOrder.LayoutOrder,
    Padding        = UDim.new(0, 5),
    FillDirection  = Enum.FillDirection.Vertical,
}, SideBar)

local tabPadding = make("UIPadding", {
    PaddingLeft   = UDim.new(0, 8),
    PaddingRight  = UDim.new(0, 8),
    PaddingTop    = UDim.new(0, 12),
}, SideBar)

local function createTab(label, icon, order)
    -- Sidebar button
    local btn = make("TextButton", {
        Size             = UDim2.new(1, 0, 0, 34),
        BackgroundColor3 = THEME.SURFACE,
        Text             = "",
        BorderSizePixel  = 0,
        LayoutOrder      = order,
        AutoButtonColor  = false,
    }, SideBar)
    corner(7, btn)

    local iconLabel = make("TextLabel", {
        Size                = UDim2.fromOffset(20, 34),
        Position            = UDim2.new(0, 10, 0, 0),
        Text                = icon,
        TextColor3          = THEME.TEXT_DIM,
        Font                = Enum.Font.GothamBold,
        TextSize            = 14,
        BackgroundTransparency = 1,
    }, btn)

    local textLabel = make("TextLabel", {
        Size                = UDim2.new(1, -36, 1, 0),
        Position            = UDim2.new(0, 34, 0, 0),
        Text                = label,
        TextColor3          = THEME.TEXT_DIM,
        Font                = Enum.Font.GothamBold,
        TextSize            = 11,
        TextXAlignment      = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
    }, btn)

    -- Active indicator stripe
    local stripe = make("Frame", {
        Size             = UDim2.new(0, 3, 0, 18),
        Position         = UDim2.new(0, 0, 0.5, -9),
        BackgroundColor3 = THEME.ACCENT,
        BackgroundTransparency = 1,
        BorderSizePixel  = 0,
    }, btn)
    corner(2, stripe)

    -- Content page
    local page = make("Frame", {
        Size                = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Visible             = false,
        ClipsDescendants    = true,
    }, ContentArea)

    local scrollFrame = make("ScrollingFrame", {
        Size                    = UDim2.fromScale(1, 1),
        BackgroundTransparency  = 1,
        BorderSizePixel         = 0,
        CanvasSize              = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize     = Enum.AutomaticSize.Y,
        ScrollBarThickness      = 3,
        ScrollBarImageColor3    = THEME.BORDER,
    }, page)

    make("UIListLayout", {
        SortOrder      = Enum.SortOrder.LayoutOrder,
        Padding        = UDim.new(0, 8),
        FillDirection  = Enum.FillDirection.Vertical,
    }, scrollFrame)

    make("UIPadding", {
        PaddingLeft   = UDim.new(0, 12),
        PaddingRight  = UDim.new(0, 14),
        PaddingTop    = UDim.new(0, 10),
        PaddingBottom = UDim.new(0, 10),
    }, scrollFrame)

    local tabData = {
        btn         = btn,
        page        = page,
        scrollFrame = scrollFrame,
        stripe      = stripe,
        textLabel   = textLabel,
        iconLabel   = iconLabel,
    }

    local function activate()
        -- Deactivate previous
        if activeTab and activeTab ~= tabData then
            tween(activeTab.btn,      { BackgroundColor3 = THEME.SURFACE })
            tween(activeTab.textLabel,{ TextColor3 = THEME.TEXT_DIM })
            tween(activeTab.iconLabel,{ TextColor3 = THEME.TEXT_DIM })
            tween(activeTab.stripe,   { BackgroundTransparency = 1 })
            activeTab.page.Visible = false
        end
        activeTab = tabData
        tween(btn,       { BackgroundColor3 = THEME.ELEVATED })
        tween(textLabel, { TextColor3 = THEME.WHITE })
        tween(iconLabel, { TextColor3 = THEME.ACCENT })
        tween(stripe,    { BackgroundTransparency = 0 })
        page.Visible = true
    end

    btn.MouseButton1Click:Connect(activate)

    -- Hover effects
    btn.MouseEnter:Connect(function()
        if activeTab ~= tabData then
            tween(btn, { BackgroundColor3 = THEME.ELEVATED })
        end
    end)
    btn.MouseLeave:Connect(function()
        if activeTab ~= tabData then
            tween(btn, { BackgroundColor3 = THEME.SURFACE })
        end
    end)

    tabs[label]  = { data = tabData, activate = activate }
    pages[label] = scrollFrame
    return scrollFrame, activate
end

-- ┌─────────────────────────────────┐
-- │    WIDGET BUILDERS              │
-- └─────────────────────────────────┘

-- Section label
local function addSectionLabel(text, parent, order)
    local lbl = make("TextLabel", {
        Size                = UDim2.new(1, 0, 0, 20),
        Text                = text:upper(),
        TextColor3          = THEME.TEXT_MUTED,
        Font                = Enum.Font.GothamBold,
        TextSize            = 9,
        TextXAlignment      = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        LayoutOrder         = order or 0,
    }, parent)
    make("UIPadding", { PaddingLeft = UDim.new(0, 2) }, lbl)
    return lbl
end

-- Toggle row  (returns toggle button so caller can attach logic)
local function addToggle(labelText, descText, parent, order)
    local row = make("Frame", {
        Size             = UDim2.new(1, 0, 0, 52),
        BackgroundColor3 = THEME.ELEVATED,
        BorderSizePixel  = 0,
        LayoutOrder      = order or 0,
    }, parent)
    corner(8, row)

    make("TextLabel", {
        Size                = UDim2.new(0.6, 0, 0, 20),
        Position            = UDim2.new(0, 12, 0, 8),
        Text                = labelText,
        TextColor3          = THEME.TEXT,
        Font                = Enum.Font.GothamBold,
        TextSize            = 12,
        TextXAlignment      = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
    }, row)

    make("TextLabel", {
        Size                = UDim2.new(0.7, 0, 0, 16),
        Position            = UDim2.new(0, 12, 0, 28),
        Text                = descText,
        TextColor3          = THEME.TEXT_MUTED,
        Font                = Enum.Font.Gotham,
        TextSize            = 10,
        TextXAlignment      = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
    }, row)

    -- Pill toggle
    local pill = make("TextButton", {
        Size             = UDim2.fromOffset(52, 26),
        Position         = UDim2.new(1, -62, 0.5, -13),
        BackgroundColor3 = THEME.BG,
        Text             = "",
        BorderSizePixel  = 0,
        AutoButtonColor  = false,
    }, row)
    corner(13, pill)
    stroke(THEME.BORDER, 1, pill)

    local knob = make("Frame", {
        Size             = UDim2.fromOffset(18, 18),
        Position         = UDim2.new(0, 4, 0.5, -9),
        BackgroundColor3 = THEME.TEXT_MUTED,
        BorderSizePixel  = 0,
    }, pill)
    corner(9, knob)

    local enabled = false

    local function setToggle(state)
        enabled = state
        if enabled then
            tween(pill,  { BackgroundColor3 = THEME.ACCENT_DIM })
            tween(knob,  {
                BackgroundColor3 = THEME.ACCENT,
                Position         = UDim2.new(0, 30, 0.5, -9),
            })
        else
            tween(pill,  { BackgroundColor3 = THEME.BG })
            tween(knob,  {
                BackgroundColor3 = THEME.TEXT_MUTED,
                Position         = UDim2.new(0, 4, 0.5, -9),
            })
        end
    end

    pill.MouseButton1Click:Connect(function()
        setToggle(not enabled)
    end)

    return pill, function() return enabled end, setToggle
end

-- Action button (full-width, coloured)
local function addButton(labelText, descText, color, parent, order)
    local row = make("Frame", {
        Size             = UDim2.new(1, 0, 0, 52),
        BackgroundColor3 = THEME.ELEVATED,
        BorderSizePixel  = 0,
        LayoutOrder      = order or 0,
    }, parent)
    corner(8, row)

    make("TextLabel", {
        Size                = UDim2.new(0.65, 0, 0, 20),
        Position            = UDim2.new(0, 12, 0, 8),
        Text                = labelText,
        TextColor3          = THEME.TEXT,
        Font                = Enum.Font.GothamBold,
        TextSize            = 12,
        TextXAlignment      = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
    }, row)

    make("TextLabel", {
        Size                = UDim2.new(0.7, 0, 0, 16),
        Position            = UDim2.new(0, 12, 0, 28),
        Text                = descText,
        TextColor3          = THEME.TEXT_MUTED,
        Font                = Enum.Font.Gotham,
        TextSize            = 10,
        TextXAlignment      = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
    }, row)

    local btn = make("TextButton", {
        Size             = UDim2.fromOffset(72, 26),
        Position         = UDim2.new(1, -82, 0.5, -13),
        BackgroundColor3 = color or THEME.ACCENT,
        Text             = "RUN",
        TextColor3       = THEME.WHITE,
        Font             = Enum.Font.GothamBold,
        TextSize         = 10,
        BorderSizePixel  = 0,
        AutoButtonColor  = false,
    }, row)
    corner(6, btn)

    btn.MouseEnter:Connect(function()
        tween(btn, { BackgroundTransparency = 0.2 })
    end)
    btn.MouseLeave:Connect(function()
        tween(btn, { BackgroundTransparency = 0 })
    end)

    return btn
end

-- Separator
local function addSeparator(parent, order)
    local sep = make("Frame", {
        Size             = UDim2.new(1, 0, 0, 1),
        BackgroundColor3 = THEME.BORDER,
        BorderSizePixel  = 0,
        LayoutOrder      = order or 0,
    }, parent)
    return sep
end

-- ┌─────────────────────────────────┐
-- │    PAGE — AUTOFARM              │
-- └─────────────────────────────────┘
local mainPage, activateMain = createTab("Autofarm", "⚙", 1)

addSectionLabel("Movement", mainPage, 1)

-- Auto-Walk
local autoWalkPill, isAutoWalking, setAutoWalk = addToggle(
    "Smart Auto-Walk",
    "Moves character forward automatically",
    mainPage, 2
)

local walkConn
autoWalkPill.MouseButton1Click:Connect(function()
    local now = isAutoWalking()
    if now then
        -- toggled ON (pill already flipped)
        showNotification("Auto-Walk enabled", "success")
        walkConn = RunService.Heartbeat:Connect(function()
            local hum = getHumanoid()
            if hum and hum.Health > 0 then
                hum:Move(Vector3.new(0, 0, -1), true)
            end
        end)
    else
        showNotification("Auto-Walk disabled", "warn")
        if walkConn then walkConn:Disconnect(); walkConn = nil end
    end
end)

addSeparator(mainPage, 3)

-- Speed
local speedPill, isSpeedOn, setSpeed = addToggle(
    "Hyper Speed",
    "Sets WalkSpeed to 150",
    mainPage, 4
)

speedPill.MouseButton1Click:Connect(function()
    local hum = getHumanoid()
    if not hum then
        showNotification("Character not found", "danger")
        setSpeed(not isSpeedOn())  -- revert pill
        return
    end
    if isSpeedOn() then
        hum.WalkSpeed = 150
        showNotification("WalkSpeed → 150", "success")
    else
        hum.WalkSpeed = 16
        showNotification("WalkSpeed reset to 16", "warn")
    end
end)

addSeparator(mainPage, 5)

-- Jump Power
local jumpPill, isJumpOn, setJump = addToggle(
    "Super Jump",
    "Sets JumpPower to 120",
    mainPage, 6
)

jumpPill.MouseButton1Click:Connect(function()
    local hum = getHumanoid()
    if not hum then
        showNotification("Character not found", "danger")
        setJump(not isJumpOn())
        return
    end
    if isJumpOn() then
        hum.JumpPower = 120
        showNotification("JumpPower → 120", "success")
    else
        hum.JumpPower = 50
        showNotification("JumpPower reset to 50", "warn")
    end
end)

addSeparator(mainPage, 7)

addSectionLabel("Physics", mainPage, 8)

-- Noclip
local noclipPill, isNoclipOn, setNoclip = addToggle(
    "Ghost Noclip",
    "Walk through walls and obstacles",
    mainPage, 9
)

local noclipConn
noclipPill.MouseButton1Click:Connect(function()
    if isNoclipOn() then
        showNotification("Noclip activated", "success")
        noclipConn = RunService.Stepped:Connect(function()
            local c = getCharacter()
            if c then
                for _, p in ipairs(c:GetDescendants()) do
                    if p:IsA("BasePart") and p.CanCollide then
                        p.CanCollide = false
                    end
                end
            end
        end)
    else
        showNotification("Noclip deactivated", "warn")
        if noclipConn then noclipConn:Disconnect(); noclipConn = nil end
        -- Restore collisions
        local c = getCharacter()
        if c then
            for _, p in ipairs(c:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = true end
            end
        end
    end
end)

addSeparator(mainPage, 10)

-- Infinite Jump
local ijPill, isIJOn, setIJ = addToggle(
    "Infinite Jump",
    "Jump again mid-air, no limit",
    mainPage, 11
)

local ijConn
ijPill.MouseButton1Click:Connect(function()
    if isIJOn() then
        showNotification("Infinite Jump enabled", "success")
        ijConn = UIS.JumpRequest:Connect(function()
            local hum = getHumanoid()
            if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
        end)
    else
        showNotification("Infinite Jump disabled", "warn")
        if ijConn then ijConn:Disconnect(); ijConn = nil end
    end
end)

-- ┌─────────────────────────────────┐
-- │    PAGE — TELEPORTS             │
-- └─────────────────────────────────┘
local teleportPage, activateTeleport = createTab("Teleports", "📍", 2)

addSectionLabel("Stage Warps", teleportPage, 1)

-- Helper: builds a teleport button row
local function addTeleportRow(label, desc, destination, parent, order)
    local btn = addButton(label, desc, THEME.ACCENT, parent, order)
    btn.Text = "TP"
    btn.MouseButton1Click:Connect(function()
        local hrp = getHRP()
        if hrp then
            hrp.CFrame = CFrame.new(destination)
            showNotification("Warped to " .. label, "success")
        else
            showNotification("Character unavailable", "danger")
        end
    end)
    return btn
end

addTeleportRow(
    "End Stage",
    "Jump straight to the final area",
    Vector3.new(7986.58, 718.30, 5143.11),
    teleportPage, 2
)

addSeparator(teleportPage, 3)

addTeleportRow(
    "Spawn / Lobby",
    "Return to the starting point",
    Vector3.new(0, 5, 0),
    teleportPage, 4
)

addSeparator(teleportPage, 5)

addTeleportRow(
    "Stage 50",
    "Midpoint warp — Stage 50",
    Vector3.new(3200, 400, 2500),
    teleportPage, 6
)

addSeparator(teleportPage, 7)

addTeleportRow(
    "Stage 100",
    "Three-quarter warp — Stage 100",
    Vector3.new(5800, 600, 4000),
    teleportPage, 8
)

-- ┌─────────────────────────────────┐
-- │    PAGE — VISUAL                │
-- └─────────────────────────────────┘
local visualPage, activateVisual = createTab("Visual", "👁", 3)

addSectionLabel("Player Appearance", visualPage, 1)

local espPill, isESPOn, setESP = addToggle(
    "Player ESP",
    "Highlight players through walls",
    visualPage, 2
)

local espHighlights = {}
espPill.MouseButton1Click:Connect(function()
    if isESPOn() then
        showNotification("Player ESP on", "success")
        -- Add highlights to all current players
        local function addESP(p)
            if p == player then return end
            local function applyHighlight(char)
                if char then
                    local hl = make("SelectionBox", {
                        Color3          = THEME.ACCENT,
                        LineThickness   = 0.05,
                        SurfaceTransparency = 1,
                        Adornee         = char,
                        Parent          = char,
                    })
                    espHighlights[p] = hl
                end
            end
            if p.Character then applyHighlight(p.Character) end
            p.CharacterAdded:Connect(applyHighlight)
        end
        for _, p in ipairs(Players:GetPlayers()) do addESP(p) end
        Players.PlayerAdded:Connect(addESP)
    else
        showNotification("Player ESP off", "warn")
        for _, hl in pairs(espHighlights) do
            if hl and hl.Parent then hl:Destroy() end
        end
        espHighlights = {}
    end
end)

addSeparator(visualPage, 3)

local fovPill, isFOVOn, setFOV = addToggle(
    "Wide FOV",
    "Increases camera field of view to 100",
    visualPage, 4
)

fovPill.MouseButton1Click:Connect(function()
    local cam = workspace.CurrentCamera
    if isFOVOn() then
        cam.FieldOfView = 100
        showNotification("FOV → 100", "success")
    else
        cam.FieldOfView = 70
        showNotification("FOV reset to 70", "warn")
    end
end)

addSeparator(visualPage, 5)

local brtBtn = addButton(
    "Full Bright",
    "Sets ambient lighting to maximum",
    THEME.WARN,
    visualPage, 6
)
brtBtn.MouseButton1Click:Connect(function()
    local lighting = game:GetService("Lighting")
    lighting.Ambient      = Color3.fromRGB(255, 255, 255)
    lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
    lighting.Brightness   = 5
    showNotification("Fullbright applied", "success")
end)

-- ┌─────────────────────────────────┐
-- │    KEYBIND: Toggle GUI (RShift) │
-- └─────────────────────────────────┘
UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        MainWindow.Visible = not MainWindow.Visible
    end
end)

-- ┌─────────────────────────────────┐
-- │    INIT: open first tab         │
-- └─────────────────────────────────┘
activateMain()

showNotification("CypherX Hub V3 loaded  •  RShift to hide", "info")
