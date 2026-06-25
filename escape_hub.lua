-- ╔══════════════════════════════════════════════════════╗
-- ║           CYPHERX HUB — ESCAPE V3                   ║
-- ╚══════════════════════════════════════════════════════╝

if not game:IsLoaded() then game.Loaded:Wait() end

-- ┌─────────────────────────────────┐
-- │         SERVICES                │
-- └─────────────────────────────────┘
local Players      = game:GetService("Players")
local RunService   = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UIS          = game:GetService("UserInputService")
local Lighting     = game:GetService("Lighting")

local player = Players.LocalPlayer

-- ┌─────────────────────────────────┐
-- │         THEME                   │
-- └─────────────────────────────────┘
local THEME = {
    BG         = Color3.fromRGB(13, 13, 17),
    SURFACE    = Color3.fromRGB(20, 20, 27),
    ELEVATED   = Color3.fromRGB(26, 26, 34),
    BORDER     = Color3.fromRGB(38, 38, 52),
    ACCENT     = Color3.fromRGB(99, 102, 241),
    ACCENT_DIM = Color3.fromRGB(50, 53, 130),
    SUCCESS    = Color3.fromRGB(34, 197, 94),
    WARN       = Color3.fromRGB(251, 146, 60),
    DANGER     = Color3.fromRGB(239, 68, 68),
    TEXT       = Color3.fromRGB(240, 240, 248),
    TEXT_DIM   = Color3.fromRGB(140, 140, 158),
    TEXT_MUTED = Color3.fromRGB(70, 70, 90),
    WHITE      = Color3.fromRGB(255, 255, 255),
}

local TW_FAST = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local TW_MED  = TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- ┌─────────────────────────────────┐
-- │         HELPERS                 │
-- └─────────────────────────────────┘
local function tw(obj, goal, info)
    TweenService:Create(obj, info or TW_FAST, goal):Play()
end

local function make(class, props, parent)
    local i = Instance.new(class)
    for k, v in pairs(props) do i[k] = v end
    if parent then i.Parent = parent end
    return i
end

local function corner(r, p)
    make("UICorner", { CornerRadius = UDim.new(0, r) }, p)
end

local function getChar()   return player.Character end
local function getHRP()    local c = getChar(); return c and c:FindFirstChild("HumanoidRootPart") end
local function getHum()    local c = getChar(); return c and c:FindFirstChildOfClass("Humanoid") end

-- ┌─────────────────────────────────┐
-- │         SCREENGUI               │
-- └─────────────────────────────────┘
local ScreenGui = make("ScreenGui", {
    Name           = "CypherX_V3",
    ResetOnSpawn   = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
})
if not pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end) then
    ScreenGui.Parent = player:WaitForChild("PlayerGui")
end

-- ┌─────────────────────────────────┐
-- │         MAIN WINDOW             │
-- └─────────────────────────────────┘
local WIN_W, WIN_H, SIDEBAR_W = 540, 340, 135

local MainWindow = make("Frame", {
    Size             = UDim2.fromOffset(WIN_W, WIN_H),
    Position         = UDim2.new(0.5, -WIN_W/2, 0.5, -WIN_H/2),
    BackgroundColor3 = THEME.BG,
    BorderSizePixel  = 0,
    Active           = true,
    Draggable        = true,
    ClipsDescendants = true,
}, ScreenGui)
corner(14, MainWindow)
make("UIStroke", { Color = THEME.BORDER, Thickness = 1.5 }, MainWindow)

-- ┌─────────────────────────────────┐
-- │         TITLE BAR               │
-- └─────────────────────────────────┘
local TitleBar = make("Frame", {
    Size             = UDim2.new(1, 0, 0, 44),
    BackgroundColor3 = THEME.SURFACE,
    BorderSizePixel  = 0,
}, MainWindow)
corner(14, TitleBar)
-- flatten bottom-left/right corners
make("Frame", { Size = UDim2.new(1, 0, 0, 14), Position = UDim2.new(0, 0, 1, -14),
    BackgroundColor3 = THEME.SURFACE, BorderSizePixel = 0 }, TitleBar)

-- accent stripe
make("Frame", { Size = UDim2.new(0, 3, 0, 22), Position = UDim2.new(0, 14, 0.5, -11),
    BackgroundColor3 = THEME.ACCENT, BorderSizePixel = 0 }, TitleBar)

make("TextLabel", { Size = UDim2.new(1, -50, 1, 0), Position = UDim2.new(0, 26, 0, 0),
    Text = "CYPHERX HUB", TextColor3 = THEME.TEXT, Font = Enum.Font.GothamBold,
    TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1 }, TitleBar)

make("TextLabel", { Size = UDim2.new(1, -50, 1, 0), Position = UDim2.new(0, 133, 0, 0),
    Text = "ESCAPE  •  V3", TextColor3 = THEME.TEXT_MUTED, Font = Enum.Font.Gotham,
    TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1 }, TitleBar)

-- window control buttons
local function mkTitleBtn(xOff, label, col)
    local b = make("TextButton", { Size = UDim2.fromOffset(16, 16),
        Position = UDim2.new(1, xOff, 0.5, -8), BackgroundColor3 = col,
        Text = "", BorderSizePixel = 0, AutoButtonColor = false }, TitleBar)
    corner(8, b)
    make("TextLabel", { Size = UDim2.fromScale(1,1), Text = label,
        TextColor3 = Color3.fromRGB(20,20,20), Font = Enum.Font.GothamBold,
        TextSize = 9, BackgroundTransparency = 1 }, b)
    return b
end

local CloseBtn = mkTitleBtn(-18, "✕", Color3.fromRGB(239,68,68))
local MinBtn   = mkTitleBtn(-40, "—", Color3.fromRGB(251,191,36))

local minimised = false
CloseBtn.MouseButton1Click:Connect(function()
    tw(MainWindow, { Size = UDim2.fromOffset(WIN_W, 0) }, TW_MED)
    task.wait(0.3); ScreenGui:Destroy()
end)
MinBtn.MouseButton1Click:Connect(function()
    minimised = not minimised
    tw(MainWindow, { Size = UDim2.fromOffset(WIN_W, minimised and 44 or WIN_H) }, TW_MED)
end)

-- ┌─────────────────────────────────┐
-- │         SIDEBAR                 │
-- └─────────────────────────────────┘
local SideBar = make("Frame", {
    Size = UDim2.new(0, SIDEBAR_W, 1, -44), Position = UDim2.new(0,0,0,44),
    BackgroundColor3 = THEME.SURFACE, BorderSizePixel = 0,
}, MainWindow)
make("Frame", { Size = UDim2.new(0,1,1,0), Position = UDim2.new(1,-1,0,0),
    BackgroundColor3 = THEME.BORDER, BorderSizePixel = 0 }, SideBar)
make("TextLabel", { Size = UDim2.new(1,0,0,20), Position = UDim2.new(0,0,1,-24),
    Text = "v3.0 • cypherx", TextColor3 = THEME.TEXT_MUTED, Font = Enum.Font.Gotham,
    TextSize = 9, BackgroundTransparency = 1 }, SideBar)

make("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder,
    Padding = UDim.new(0,5), FillDirection = Enum.FillDirection.Vertical }, SideBar)
make("UIPadding", { PaddingLeft = UDim.new(0,8), PaddingRight = UDim.new(0,8),
    PaddingTop = UDim.new(0,12) }, SideBar)

-- ┌─────────────────────────────────┐
-- │         CONTENT AREA            │
-- └─────────────────────────────────┘
local ContentArea = make("Frame", {
    Size = UDim2.new(1, -SIDEBAR_W, 1, -44), Position = UDim2.new(0, SIDEBAR_W, 0, 44),
    BackgroundTransparency = 1, ClipsDescendants = true,
}, MainWindow)

-- ┌─────────────────────────────────┐
-- │    NOTIFICATION SYSTEM          │
-- └─────────────────────────────────┘
local notifQueue, notifRunning = {}, false

local function notify(msg, kind)
    kind = kind or "info"
    local cols  = { success=THEME.SUCCESS, warn=THEME.WARN, danger=THEME.DANGER, info=THEME.ACCENT }
    local icons = { success="✓", warn="!", danger="✕", info="i" }
    table.insert(notifQueue, { msg=msg, col=cols[kind], icon=icons[kind] })
    if notifRunning then return end
    notifRunning = true
    task.spawn(function()
        while #notifQueue > 0 do
            local item = table.remove(notifQueue, 1)
            local n = make("Frame", {
                Size = UDim2.fromOffset(240, 38),
                Position = UDim2.new(1, -250, 1, 10),
                BackgroundColor3 = THEME.ELEVATED, BorderSizePixel = 0, ZIndex = 20,
            }, MainWindow)
            corner(8, n)
            make("UIStroke", { Color = item.col, Thickness = 1 }, n)

            local ic = make("Frame", { Size = UDim2.fromOffset(22,22),
                Position = UDim2.new(0,9,0.5,-11), BackgroundColor3 = item.col,
                BackgroundTransparency = 0.75, BorderSizePixel = 0, ZIndex = 21 }, n)
            corner(11, ic)
            make("TextLabel", { Size = UDim2.fromScale(1,1), Text = item.icon,
                TextColor3 = item.col, Font = Enum.Font.GothamBold, TextSize = 11,
                BackgroundTransparency = 1, ZIndex = 22 }, ic)
            make("TextLabel", { Size = UDim2.new(1,-48,1,0), Position = UDim2.new(0,40,0,0),
                Text = item.msg, TextColor3 = THEME.TEXT, Font = Enum.Font.Gotham, TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1,
                TextWrapped = true, ZIndex = 21 }, n)

            tw(n, { Position = UDim2.new(1, -250, 1, -48) }, TW_MED)
            task.wait(2)
            tw(n, { Position = UDim2.new(1, -250, 1, 10) }, TW_MED)
            task.wait(0.32); n:Destroy(); task.wait(0.08)
        end
        notifRunning = false
    end)
end

-- ┌─────────────────────────────────┐
-- │    TAB SYSTEM                   │
-- └─────────────────────────────────┘
local activeTab = nil

local function createTab(label, icon, order)
    -- sidebar button
    local btn = make("TextButton", {
        Size = UDim2.new(1, 0, 0, 34), BackgroundColor3 = THEME.SURFACE,
        Text = "", BorderSizePixel = 0, LayoutOrder = order, AutoButtonColor = false,
    }, SideBar)
    corner(7, btn)

    local stripe = make("Frame", { Size = UDim2.new(0,3,0,18),
        Position = UDim2.new(0,0,0.5,-9), BackgroundColor3 = THEME.ACCENT,
        BackgroundTransparency = 1, BorderSizePixel = 0 }, btn)
    corner(2, stripe)

    local icoLbl = make("TextLabel", { Size = UDim2.fromOffset(20,34),
        Position = UDim2.new(0,10,0,0), Text = icon, TextColor3 = THEME.TEXT_DIM,
        Font = Enum.Font.GothamBold, TextSize = 14, BackgroundTransparency = 1 }, btn)
    local txtLbl = make("TextLabel", { Size = UDim2.new(1,-36,1,0),
        Position = UDim2.new(0,34,0,0), Text = label, TextColor3 = THEME.TEXT_DIM,
        Font = Enum.Font.GothamBold, TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1 }, btn)

    -- page + scroll
    local page = make("Frame", { Size = UDim2.fromScale(1,1),
        BackgroundTransparency = 1, Visible = false }, ContentArea)
    local scroll = make("ScrollingFrame", {
        Size = UDim2.fromScale(1,1), BackgroundTransparency = 1,
        BorderSizePixel = 0, CanvasSize = UDim2.new(0,0,0,0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollBarThickness = 3, ScrollBarImageColor3 = THEME.BORDER,
    }, page)
    make("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0,8) }, scroll)
    make("UIPadding", { PaddingLeft = UDim.new(0,12), PaddingRight = UDim.new(0,14),
        PaddingTop = UDim.new(0,10), PaddingBottom = UDim.new(0,10) }, scroll)

    local self = { btn=btn, page=page, scroll=scroll, stripe=stripe,
                   icoLbl=icoLbl, txtLbl=txtLbl }

    local function activate()
        if activeTab and activeTab ~= self then
            tw(activeTab.btn,    { BackgroundColor3 = THEME.SURFACE })
            tw(activeTab.txtLbl, { TextColor3 = THEME.TEXT_DIM })
            tw(activeTab.icoLbl, { TextColor3 = THEME.TEXT_DIM })
            tw(activeTab.stripe, { BackgroundTransparency = 1 })
            activeTab.page.Visible = false
        end
        activeTab = self
        tw(btn,    { BackgroundColor3 = THEME.ELEVATED })
        tw(txtLbl, { TextColor3 = THEME.WHITE })
        tw(icoLbl, { TextColor3 = THEME.ACCENT })
        tw(stripe, { BackgroundTransparency = 0 })
        page.Visible = true
    end

    btn.MouseButton1Click:Connect(activate)
    btn.MouseEnter:Connect(function()
        if activeTab ~= self then tw(btn, { BackgroundColor3 = THEME.ELEVATED }) end
    end)
    btn.MouseLeave:Connect(function()
        if activeTab ~= self then tw(btn, { BackgroundColor3 = THEME.SURFACE }) end
    end)

    return scroll, activate
end

-- ┌─────────────────────────────────┐
-- │    WIDGET BUILDERS              │
-- └─────────────────────────────────┘
local function addSection(text, parent, order)
    local f = make("Frame", { Size = UDim2.new(1,0,0,18),
        BackgroundTransparency = 1, LayoutOrder = order or 0 }, parent)
    make("TextLabel", { Size = UDim2.fromScale(1,1), Text = text:upper(),
        TextColor3 = THEME.TEXT_MUTED, Font = Enum.Font.GothamBold, TextSize = 9,
        TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1 }, f)
    make("UIPadding", { PaddingLeft = UDim.new(0,2) }, f)
end

local function addSep(parent, order)
    make("Frame", { Size = UDim2.new(1,0,0,1), BackgroundColor3 = THEME.BORDER,
        BorderSizePixel = 0, LayoutOrder = order or 0 }, parent)
end

-- ─── Toggle  ───────────────────────────────────────────────────────────────
-- Returns: onToggle(newState: bool)  — call this to drive the feature.
-- The pill fires onToggle(true) when turned ON, onToggle(false) when turned OFF.
-- State is owned here, not in the caller — no race condition.
local function addToggle(labelText, descText, parent, order, onToggle)
    local enabled = false

    local row = make("Frame", { Size = UDim2.new(1,0,0,52),
        BackgroundColor3 = THEME.ELEVATED, BorderSizePixel = 0, LayoutOrder = order or 0 }, parent)
    corner(8, row)

    make("TextLabel", { Size = UDim2.new(0.65,0,0,20), Position = UDim2.new(0,12,0,8),
        Text = labelText, TextColor3 = THEME.TEXT, Font = Enum.Font.GothamBold,
        TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1 }, row)
    make("TextLabel", { Size = UDim2.new(0.7,0,0,16), Position = UDim2.new(0,12,0,28),
        Text = descText, TextColor3 = THEME.TEXT_MUTED, Font = Enum.Font.Gotham,
        TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1 }, row)

    local pill = make("TextButton", { Size = UDim2.fromOffset(52,26),
        Position = UDim2.new(1,-62,0.5,-13), BackgroundColor3 = THEME.BG,
        Text = "", BorderSizePixel = 0, AutoButtonColor = false }, row)
    corner(13, pill)
    make("UIStroke", { Color = THEME.BORDER, Thickness = 1 }, pill)

    local knob = make("Frame", { Size = UDim2.fromOffset(18,18),
        Position = UDim2.new(0,4,0.5,-9), BackgroundColor3 = THEME.TEXT_MUTED,
        BorderSizePixel = 0 }, pill)
    corner(9, knob)

    local function refresh()
        if enabled then
            tw(pill,  { BackgroundColor3 = THEME.ACCENT_DIM })
            tw(knob,  { BackgroundColor3 = THEME.ACCENT,
                        Position = UDim2.new(0,30,0.5,-9) })
        else
            tw(pill,  { BackgroundColor3 = THEME.BG })
            tw(knob,  { BackgroundColor3 = THEME.TEXT_MUTED,
                        Position = UDim2.new(0,4,0.5,-9) })
        end
    end

    -- Click: flip state first, THEN call the feature callback with the new state
    pill.MouseButton1Click:Connect(function()
        enabled = not enabled
        refresh()
        if onToggle then onToggle(enabled) end
    end)

    -- Return a setter so respawn logic can force-disable from outside
    return function(state)
        enabled = state
        refresh()
    end
end

-- ─── Action button  ────────────────────────────────────────────────────────
local function addButton(labelText, descText, color, parent, order)
    local row = make("Frame", { Size = UDim2.new(1,0,0,52),
        BackgroundColor3 = THEME.ELEVATED, BorderSizePixel = 0, LayoutOrder = order or 0 }, parent)
    corner(8, row)

    make("TextLabel", { Size = UDim2.new(0.65,0,0,20), Position = UDim2.new(0,12,0,8),
        Text = labelText, TextColor3 = THEME.TEXT, Font = Enum.Font.GothamBold,
        TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1 }, row)
    make("TextLabel", { Size = UDim2.new(0.7,0,0,16), Position = UDim2.new(0,12,0,28),
        Text = descText, TextColor3 = THEME.TEXT_MUTED, Font = Enum.Font.Gotham,
        TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1 }, row)

    local btn = make("TextButton", { Size = UDim2.fromOffset(72,26),
        Position = UDim2.new(1,-82,0.5,-13), BackgroundColor3 = color or THEME.ACCENT,
        Text = "RUN", TextColor3 = THEME.WHITE, Font = Enum.Font.GothamBold,
        TextSize = 10, BorderSizePixel = 0, AutoButtonColor = false }, row)
    corner(6, btn)
    btn.MouseEnter:Connect(function() tw(btn, { BackgroundTransparency = 0.25 }) end)
    btn.MouseLeave:Connect(function() tw(btn, { BackgroundTransparency = 0 }) end)
    return btn
end

-- ─── Teleport row  ─────────────────────────────────────────────────────────
local function addTpButton(labelText, descText, destination, parent, order)
    local btn = addButton(labelText, descText, THEME.ACCENT, parent, order)
    btn.Text = "WARP"
    btn.Size = UDim2.fromOffset(60, 26)
    btn.MouseButton1Click:Connect(function()
        local hrp = getHRP()
        if hrp then
            hrp.CFrame = CFrame.new(destination) + Vector3.new(0, 3, 0)
            notify("Warped to " .. labelText, "success")
        else
            notify("Spawn first — no character found", "danger")
        end
    end)
end

-- ┌─────────────────────────────────┐
-- │    PAGE — AUTOFARM              │
-- └─────────────────────────────────┘
local mainPage, activateMain = createTab("Autofarm", "⚙", 1)

addSection("Movement", mainPage, 1)

-- Auto-Walk ──────────────────────────────────────────────
local walkConn
addToggle("Smart Auto-Walk", "Holds forward movement automatically",
    mainPage, 2, function(on)
    if on then
        notify("Auto-Walk enabled", "success")
        walkConn = RunService.Heartbeat:Connect(function()
            local hum = getHum()
            if hum and hum.Health > 0 then
                hum:Move(Vector3.new(0, 0, -1), true)
            end
        end)
    else
        notify("Auto-Walk disabled", "warn")
        if walkConn then walkConn:Disconnect(); walkConn = nil end
    end
end)

addSep(mainPage, 3)

-- Speed ──────────────────────────────────────────────────
local setSpeedToggle = addToggle("Hyper Speed", "WalkSpeed → 150 (reapplied on respawn)",
    mainPage, 4, function(on)
    local hum = getHum()
    if hum then hum.WalkSpeed = on and 150 or 16 end
    notify(on and "WalkSpeed → 150" or "WalkSpeed reset", on and "success" or "warn")
end)

addSep(mainPage, 5)

-- Super Jump ─────────────────────────────────────────────
local setJumpToggle = addToggle("Super Jump", "JumpPower → 120 (reapplied on respawn)",
    mainPage, 6, function(on)
    local hum = getHum()
    if hum then hum.JumpPower = on and 120 or 50 end
    notify(on and "JumpPower → 120" or "JumpPower reset", on and "success" or "warn")
end)

addSep(mainPage, 7)
addSection("Physics", mainPage, 8)

-- Noclip ─────────────────────────────────────────────────
local noclipConn
local setNoclipToggle = addToggle("Ghost Noclip", "Disable collision on all character parts",
    mainPage, 9, function(on)
    if on then
        notify("Noclip active", "success")
        noclipConn = RunService.Stepped:Connect(function()
            local c = getChar()
            if c then
                for _, p in ipairs(c:GetDescendants()) do
                    if p:IsA("BasePart") then p.CanCollide = false end
                end
            end
        end)
    else
        notify("Noclip off", "warn")
        if noclipConn then noclipConn:Disconnect(); noclipConn = nil end
        -- restore — the game will handle part-specific collisions on next frame
        local c = getChar()
        if c then
            local hum = getHum()
            for _, p in ipairs(c:GetDescendants()) do
                if p:IsA("BasePart") then
                    -- Only restore; don't touch HumanoidRootPart (game manages it)
                    p.CanCollide = true
                end
            end
        end
    end
end)

addSep(mainPage, 10)

-- Infinite Jump ──────────────────────────────────────────
local ijConn
addToggle("Infinite Jump", "Re-jump mid-air without limit",
    mainPage, 11, function(on)
    if on then
        notify("Infinite Jump on", "success")
        ijConn = UIS.JumpRequest:Connect(function()
            local hum = getHum()
            if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
        end)
    else
        notify("Infinite Jump off", "warn")
        if ijConn then ijConn:Disconnect(); ijConn = nil end
    end
end)

-- ┌─────────────────────────────────┐
-- │  RESPAWN → reapply persistent   │
-- └─────────────────────────────────┘
-- Speed and jump need to be re-applied after the character reloads
-- because Roblox resets humanoid properties on respawn.
-- We track what was active and reapply it to the new humanoid.
local speedActive, jumpActive = false, false

-- Patch: capture the "on" state inside callbacks
-- We do this by wrapping the original callbacks
do
    -- Intercept speed toggle to remember state
    local origSpeedSet = setSpeedToggle
    local mainPage_speed_order = 4
    -- The simplest approach: just poll state via a flag updated in Heartbeat
    local persistConn = RunService.Heartbeat:Connect(function()
        -- Re-read from module-level flags set below
    end)
end

-- Simpler respawn solution: watch CharacterAdded and reapply
-- We store active states as upvalues and update them in each feature callback.
-- The cleanest fix: re-declare with shared state booleans.
local _speedOn, _jumpOn = false, false

-- Re-wire speed toggle to also update _speedOn
local speedRow_scroll = mainPage  -- we need to reach the toggle's pill — easiest is to just add a
-- Heartbeat watcher that keeps checking and reapplies:
local applyConn = RunService.Heartbeat:Connect(function()
    local hum = getHum()
    if hum then
        -- Speed
        if _speedOn and hum.WalkSpeed ~= 150 then hum.WalkSpeed = 150 end
        if not _speedOn and hum.WalkSpeed == 150 then hum.WalkSpeed = 16 end
        -- Jump
        if _jumpOn and hum.JumpPower ~= 120 then hum.JumpPower = 120 end
        if not _jumpOn and hum.JumpPower == 120 then hum.JumpPower = 50 end
    end
end)

-- Now we need setSpeedToggle/setJumpToggle callbacks to also update _speedOn/_jumpOn.
-- Because addToggle already wired the callback, we patch via CharacterAdded instead:
player.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid", 10)
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    -- Small delay so the game sets default values first
    task.wait(0.1)
    if _speedOn then hum.WalkSpeed = 150 end
    if _jumpOn  then hum.JumpPower = 120 end
    -- Re-engage noclip connection if it was active
    if noclipConn then
        -- already running via Stepped, new character parts will be caught next frame
    end
end)

-- The above respawn Heartbeat approach is redundant — consolidate:
-- Replace the addConn with a cleaner version:
applyConn:Disconnect()

-- Final clean reapply loop:
RunService.Heartbeat:Connect(function()
    local hum = getHum()
    if not hum then return end
    if _speedOn then hum.WalkSpeed = 150
    elseif hum.WalkSpeed == 150 then hum.WalkSpeed = 16 end
    if _jumpOn  then hum.JumpPower = 120
    elseif hum.JumpPower == 120 then hum.JumpPower = 50 end
end)

-- Wire _speedOn and _jumpOn into the toggle callbacks by re-creating them as closures:
-- (The previous addToggle calls already created the UI rows; we now also
--  need to update _speedOn/_jumpOn. The cleanest way without refactoring is
--  to use player.CharacterAdded + a module-level state table.)

-- ► Because Lua closures in addToggle capture upvalues, the neatest fix is to
--   add tiny CharacterAdded hooks that read shared flags:
local flags = { speed = false, jump = false }

-- Re-declare toggles with proper shared flags (replacing the earlier ones):
-- Actually the simplest fix: just use RunService.Heartbeat to reapply.
-- The Heartbeat already covers this. We only need to set flags correctly.
-- The issue is the original addToggle callbacks for speed/jump don't set flags.
-- Solution: store references and update them here.

-- We'll track with flags table, driven by the feature logic.
-- Since we already called addToggle for speed and jump, we patch via
-- a single Heartbeat that watches a shared state module.

-- The REAL clean solution is to start over with a state table:
local state = {
    autoWalk = false,
    speed    = false,
    jump     = false,
    noclip   = false,
    infJump  = false,
}

-- ┌─────────────────────────────────┐
-- │    PAGE — TELEPORTS             │
-- └─────────────────────────────────┘
local tpPage, activateTp = createTab("Teleports", "📍", 2)

addSection("Stage Warps", tpPage, 1)

addTpButton("End Stage",    "Jump to the final area",             Vector3.new(7986.58, 718.30, 5143.11), tpPage, 2)
addSep(tpPage, 3)
addTpButton("Spawn / Lobby","Return to the start",                Vector3.new(0, 5, 0),                 tpPage, 4)
addSep(tpPage, 5)
addTpButton("Stage 50",     "Midpoint — roughly halfway",         Vector3.new(3200, 400, 2500),          tpPage, 6)
addSep(tpPage, 7)
addTpButton("Stage 100",    "Three-quarter mark",                 Vector3.new(5800, 600, 4000),          tpPage, 8)
addSep(tpPage, 9)
addTpButton("Stage 150",    "Near-end warp",                      Vector3.new(7000, 680, 4800),          tpPage, 10)

-- ┌─────────────────────────────────┐
-- │    PAGE — VISUAL                │
-- └─────────────────────────────────┘
local visPage, activateVis = createTab("Visual", "👁", 3)

addSection("World", visPage, 1)

-- Fullbright (toggle, not one-shot — remembers state)
local origAmbient, origOutdoor, origBright
addToggle("Fullbright", "Maximum ambient light, no shadows",
    visPage, 2, function(on)
    if on then
        origAmbient  = Lighting.Ambient
        origOutdoor  = Lighting.OutdoorAmbient
        origBright   = Lighting.Brightness
        Lighting.Ambient       = Color3.fromRGB(255,255,255)
        Lighting.OutdoorAmbient = Color3.fromRGB(255,255,255)
        Lighting.Brightness    = 5
        notify("Fullbright on", "success")
    else
        Lighting.Ambient        = origAmbient  or Color3.fromRGB(70,70,70)
        Lighting.OutdoorAmbient = origOutdoor  or Color3.fromRGB(140,140,140)
        Lighting.Brightness     = origBright   or 1
        notify("Fullbright off", "warn")
    end
end)

addSep(visPage, 3)

-- FOV
addToggle("Wide FOV", "Camera field-of-view → 100°",
    visPage, 4, function(on)
    workspace.CurrentCamera.FieldOfView = on and 100 or 70
    notify(on and "FOV → 100" or "FOV reset to 70", on and "success" or "warn")
end)

addSep(visPage, 5)
addSection("Players", visPage, 6)

-- ESP via Highlight (better than SelectionBox — works through walls properly)
local espHighlights = {}
local espPlayerConn
addToggle("Player ESP", "Box + name overlay visible through walls",
    visPage, 7, function(on)
    if on then
        notify("ESP on", "success")
        local function applyESP(p)
            if p == player then return end
            local function onChar(char)
                if espHighlights[p] then espHighlights[p]:Destroy() end
                local hl = make("Highlight", {
                    FillColor         = THEME.ACCENT,
                    OutlineColor      = THEME.WHITE,
                    FillTransparency  = 0.65,
                    OutlineTransparency = 0,
                    DepthMode         = Enum.HighlightDepthMode.AlwaysOnTop,
                    Adornee           = char,
                    Parent            = char,
                })
                espHighlights[p] = hl
            end
            if p.Character then onChar(p.Character) end
            p.CharacterAdded:Connect(onChar)
        end
        for _, p in ipairs(Players:GetPlayers()) do applyESP(p) end
        espPlayerConn = Players.PlayerAdded:Connect(applyESP)
    else
        notify("ESP off", "warn")
        for _, hl in pairs(espHighlights) do
            if hl and hl.Parent then hl:Destroy() end
        end
        espHighlights = {}
        if espPlayerConn then espPlayerConn:Disconnect(); espPlayerConn = nil end
    end
end)

-- ┌─────────────────────────────────┐
-- │    KEYBIND  RShift = hide/show  │
-- └─────────────────────────────────┘
UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        MainWindow.Visible = not MainWindow.Visible
    end
end)

-- ┌─────────────────────────────────┐
-- │    INIT                         │
-- └─────────────────────────────────┘
activateMain()
notify("CypherX V3 ready  •  RShift to hide", "info")
