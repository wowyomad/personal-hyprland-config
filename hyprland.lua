-- #######################################################################################
-- HYPRLAND LUA CONFIGURATION
-- Replaces ~/.config/hypr/hyprland.conf -> ~/.config/hypr/hyprland.lua
-- #######################################################################################
local zoom = require("util.zoom")
-- ---------------------------------------------------------------------------------------
-- VARIABLES
-- ---------------------------------------------------------------------------------------
local terminal = "kitty"
local fileManager = "dolphin"
local menu = "wofi --show drun"

-- Define Modifiers for easy referencing
local main = "SUPER"
local mainShift = "SUPER + SHIFT"
local mainAlt = "SUPER + ALT"
local mainCtrl = "SUPER + CTRL"

-- ---------------------------------------------------------------------------------------
-- EXECUTIVES & AUTOSTART
-- ---------------------------------------------------------------------------------------

hl.on("hyprland.start", function()
    hl.exec_cmd('gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"')
    hl.exec_cmd("copyq --start-server")
    hl.exec_cmd("kdeconnectd")
    hl.exec_cmd("kdeconnect-indicator")
    hl.exec_cmd("wayle shell &")
    hl.exec_cmd("gnome-keyring-daemon --start --components=secrets &")
    hl.exec_cmd("dbus-update-activation-environment --systemd --all")
    hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &")
    hl.exec_cmd("hypridle &")
    hl.exec_cmd("vicinae server &")
    hl.exec_cmd("swayosd-server &")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("steam")
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
end)

-- ---------------------------------------------------------------------------------------
-- ENVIRONMENT VARIABLES
-- ---------------------------------------------------------------------------------------
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("XDG_MENU_PREFIX", "plasma-")
hl.env("PATH", os.getenv("PATH") .. ":" .. os.getenv("HOME") .. "/.local/share/goverlay/fgmod")
hl.env("VK_DRIVER_FILES", "/usr/share/vulkan/icd.d/radeon_icd.json")
hl.env("AMDVLK_FILES", "/usr/share/vulkan/icd.d/amd_icd64.json:/usr/share/vulkan/icd.d/amd_icd32.json")
hl.env("SSH_AUTH_SOCK", os.getenv("XDG_RUNTIME_DIR") .. "/keyring/ssh")
hl.env("QT_QPA_PLATFORM", "wayland")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-- ---------------------------------------------------------------------------------------
-- MONITORS
-- ---------------------------------------------------------------------------------------
local mon		= "DP-1"
local res		= "3440x1440"
local defaultHz		= 155
local overclockHz	= 144

hl.monitor({
    output = "DP-1",
    mode = "3440x1440@155",
    position = "0x0",
    scale = "1"
})

hl.bind("CTRL + F12", function()
    local currentHz = hl.get_monitor(mon).refresh_rate
    local targetHz = (math.abs(currentHz - defaultHz) < 1) and overclockHz or defaultHz

    hl.monitor({ output = mon, mode = res .. "@" .. targetHz })

    hl.notification.create({
        text	= "Refresh rate: " .. targetHz .. "Hz",
	duration = 1200,
    })
end, { locked = true })

-- ---------------------------------------------------------------------------------------
-- WORKSPACES
-- ---------------------------------------------------------------------------------------
hl.workspace_rule({ workspace = "1", monitor = "DP-1", default_name = "main@200" })
hl.workspace_rule({ workspace = "2", monitor = "DP-1" })
hl.workspace_rule({ workspace = "3", monitor = "DP-1" })
hl.workspace_rule({ workspace = "0", monitor = "DP-1", default_name = "docs@60" })
hl.workspace_rule({ workspace = "f[1]", gaps_out = 4, gaps_in = 0 })

-- ---------------------------------------------------------------------------------------
-- CONFIGURATION SETTINGS
-- ---------------------------------------------------------------------------------------
hl.config({
    general = {
        gaps_in = 5,
        gaps_out = { 2, 20, 20, 20 },
        border_size = 3,
        col = {
            active_border = { colors = {"rgba(33ccffee)", "rgba(00ff99ee)"}, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },
        resize_on_border = false,
        allow_tearing = true,
        layout = "dwindle"
    },
    render = {
        direct_scanout = 0
    },
    decoration = {
        rounding = 10,
        rounding_power = 2,
        active_opacity = 1.0,
        inactive_opacity = 1.0,
        shadow = {
            enabled = true,
            range = 4,
            render_power = 3,
            color = 0xee1a1a1a -- Formatted to match official hex style
        },
        blur = {
            enabled = true,
            size = 3,
            passes = 1,
            vibrancy = 0.1696
        }
    },
    animations = {
        enabled = true,
    },
    dwindle = {
        preserve_split = true
    },
    master = {
        new_status = "master"
    },
    binds = {
        scroll_event_delay = 0,
	pass_mouse_when_bound = false,
    },
    misc = {
        on_focus_under_fullscreen = 1,
        middle_click_paste = false,
        force_default_wallpaper = -1,
        disable_hyprland_logo = false,
        vrr = 2
    },
    debug = {
        vfr = true
    },
    cursor = {
        zoom_disable_aa = true,
        no_hardware_cursors = false,
        no_break_fs_vrr = true
    },
    input = {
        kb_layout = "us, ru",
        kb_options = "grp:mainAlt_shift_toggle",
        follow_mouse = 1,
        sensitivity = 0.0,
        touchpad = {
            natural_scroll = false
        }
    },
    xwayland = {
        force_zero_scaling = true
    }
})

-- ---------------------------------------------------------------------------------------
-- CURVES & ANIMATIONS (Updated to correct table syntax)
-- ---------------------------------------------------------------------------------------
hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},   {0.32, 1} } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05},{0.36, 1} } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},      {1, 1}    } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},  {0.75, 1} } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},   {0.1, 1}  } })

hl.animation({ leaf = "global",        enabled = true, speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn",     enabled = true, speed = 4.1,  bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true, speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true, speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true, speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true, speed = 1,    bezier = "easeOutQuint", style = "slide" })
hl.animation({ leaf = "workspacesIn",  enabled = true, speed = 3,    bezier = "easeOutQuint", style = "slide" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 3,    bezier = "easeOutQuint", style = "slide" })
hl.animation({ leaf = "zoomFactor",    enabled = true, speed = 7,    bezier = "quick" })

-- Gestures and Devices
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
hl.device({ name = "epic-mouse-v1", sensitivity = -0.5})

-- ---------------------------------------------------------------------------------------
-- WINDOW RULES
-- ---------------------------------------------------------------------------------------
hl.window_rule({ match = { class = "(.*copyq)$" }, float = true, center = true })
hl.window_rule({ match = { class = "org.kde.plasma.emojier" }, float = true, center = true, size = "800 600" })

-- Games Variable
local games = "^(steam_app_.*|Deadlock)$"
hl.window_rule({ match = { class = games }, workspace = "4 silent" })
hl.window_rule({ match = { class = games }, fullscreen = true })
hl.window_rule({ match = { class = games }, immediate = true })

-- Tiled window borders
hl.window_rule({ match = { float = false }, border_size = 3, border_color = "rgb(11AAFF)" })

-- Fullscreen window when multiple tiled windows
hl.window_rule({ match = { fullscreen = true, workspace = "w[t2]" }, border_size = 3, border_color = "rgb(22ff99)" })

-- Fullscreen window when single tiled window
hl.window_rule({ match = { fullscreen = true, workspace = "w[t1]" }, border_size = 3, border_color = "rgb(333366)" })

-- App Specific
hl.window_rule({ match = { class = "^([Ss]team)$" }, workspace = "3 silent" })
hl.window_rule({ match = { class = "^(brave-browser)$" }, no_vrr = true })
hl.window_rule({ match = { class = "^(steam)$" }, no_vrr = true })

-- Suppressions and Fixes
hl.window_rule({ name = "suppress-maximize", match = { class = ".*" }, suppress_event = "maximize" })
-- hl.window_rule({ name = "suppress-fullscreen", match = { class = ".*" }, suppress_event = "fullscreen" })
hl.window_rule({ 
    name = "fix-xwayland-drags",
    match = { class = "^$", title = "^$", xwayland = true, float = true, fullscreen = false, pin = true }, 
    no_focus = true 
})

-- ---------------------------------------------------------------------------------------
-- KEYBINDINGS (Migrated to Official Dispatcher namespaces)
-- ---------------------------------------------------------------------------------------
-- Core bindings
hl.bind(main .. " + Q", hl.dsp.exec_cmd(terminal))
hl.bind(main .. " + C", hl.dsp.window.close())
hl.bind("ALT + F4", hl.dsp.exec_cmd("hyprctl dispatch forcekillactive")) -- Fallback to ensure force
hl.bind(mainShift .. " + C", hl.dsp.exec_cmd("hyprctl dispatch forcekillactive")) 
hl.bind(main .. " + M", hl.dsp.exec_cmd("wlogout"))
hl.bind(main .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(main .. " + F", hl.dsp.window.float({ action = "toggle" }))
hl.bind(main .. " + R", hl.dsp.exec_cmd(menu))
hl.bind(main .. " + P", hl.dsp.window.pseudo())
hl.bind(main .. " + T", hl.dsp.layout("togglesplit"))
hl.bind(main .. " + D", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle"} ))
hl.bind(mainShift .. " + D", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle"}))

-- Custom app bindings
hl.bind(main .. " + N", hl.dsp.exec_cmd("swaync-client -t -sw"))
hl.bind(main .. " + B", hl.dsp.exec_cmd("brave"))
hl.bind(main .. " + J", hl.dsp.exec_cmd("jiffy"))
hl.bind(main .. " + V", hl.dsp.exec_cmd("copyq toggle"))
hl.bind(main .. " + Grave", hl.dsp.exec_cmd("vicinae toggle"))

-- Screenshots
hl.bind("Print", hl.dsp.exec_cmd("sh -c 'pgrep -x slurp || (TARGET=\"$HOME/Pictures/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png\"; grim -g \"$(slurp)\" \"$TARGET\" && wl-copy < \"$TARGET\")'"))

-- Zoom bindings
hl.bind(mainShift .. " + mouse_down", zoom.zoom_in)
hl.bind(mainShift .. " + mouse_up", zoom.zoom_out)

-- Audio Custom Binds
hl.bind("ALT + M", hl.dsp.exec_cmd("swayosd-client --output-volume mute-toggle"))
hl.bind("ALT + Up", hl.dsp.exec_cmd("wayle audio output-volume $(wayle audio output-volume | awk '{print $2}' | tr -d '%' | awk '{print $1 + 5}')"), { repeating = true })
hl.bind("ALT + Down", hl.dsp.exec_cmd("wayle audio output-volume $(wayle audio output-volume | awk '{print $2}' | tr -d '%' | awk '{print $1 - 5}')"), { repeating = true })

-- Move Focus
hl.bind(main .. " + h", hl.dsp.focus({ direction = "l" }))
hl.bind(main .. " + l", hl.dsp.focus({ direction = "r" }))
hl.bind(main .. " + k", hl.dsp.focus({ direction = "u" }))
hl.bind(main .. " + j", hl.dsp.focus({ direction = "d" }))
hl.bind("ALT + Tab", hl.dsp.window.cycle_next())

-- Swap Window
hl.bind(mainShift .. " + H", hl.dsp.window.swap({ direction = "l" }))
hl.bind(mainShift .. " + L", hl.dsp.window.swap({ direction = "r" }))
hl.bind(mainShift .. " + K", hl.dsp.window.swap({ direction = "u" }))
hl.bind(mainShift .. " + J", hl.dsp.window.swap({ direction = "d" }))
hl.bind(main .. " + W", hl.dsp.layout("swapnext"))

-- Move Window
hl.bind(mainAlt .. " + H", hl.dsp.window.move({ direction = "l" }))
hl.bind(mainAlt .. " + L", hl.dsp.window.move({ direction = "r" }))
hl.bind(mainAlt .. " + K", hl.dsp.window.move({ direction = "u" }))
hl.bind(mainAlt .. " + J", hl.dsp.window.move({ direction = "d" }))
hl.bind(main .. " + R", hl.dsp.layout("rollnext"))

-- ---------------------------------------------------------------------------------------
-- WORKSPACE BINDINGS
-- ---------------------------------------------------------------------------------------
-- Standard numbers
for i = 1, 9 do
    hl.bind(main .. " + " .. i, hl.dsp.focus({ workspace = i }))
    hl.bind(mainShift .. " + " .. i, hl.dsp.window.move({ workspace = i, silent = true }))
end
hl.bind(main .. " + 0", hl.dsp.focus({ workspace = 10 }))
hl.bind(mainShift .. " + 0", hl.dsp.window.move({ workspace = 10, silent = true }))

-- Numpad keys
local kp_binds = {
    KP_End = 1, KP_Down = 2, KP_Next = 3, KP_Left = 4, KP_Begin = 5,
    KP_Right = 6, KP_Home = 7, KP_Up = 8, KP_Prior = 9, KP_Insert = 10
}
for key, ws in pairs(kp_binds) do
    hl.bind(main .. " + " .. key, hl.dsp.focus({ workspace = ws }))
    hl.bind(mainShift .. " + " .. key, hl.dsp.window.move({ workspace = ws, silent = true }))
end

-- Special Workspace
hl.bind(main .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainShift .. " + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll Workspaces
hl.bind(main .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(main .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(main .. " + TAB", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainShift .. " + TAB", hl.dsp.focus({ workspace = "e-1" }))

-- ---------------------------------------------------------------------------------------
-- MOUSE BINDINGS
-- ---------------------------------------------------------------------------------------
hl.bind(main .. " + mouse:274", hl.dsp.window.close())
hl.bind(main .. " + mouse:272", hl.dsp.window.drag(), { mouse = true }) 
hl.bind(main .. " + mouse:273", hl.dsp.window.resize(), { mouse = true }) 

-- ---------------------------------------------------------------------------------------
-- MULTIMEDIA KEYS
-- ---------------------------------------------------------------------------------------
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- ---------------------------------------------------------------------------------------
-- SUBMAPS
-- ---------------------------------------------------------------------------------------
hl.bind(mainShift .. " + R", hl.dsp.submap("resize"))
hl.define_submap("resize", function()
    local moveOut = 50
    local moveIn = -50

    hl.bind("l", hl.dsp.exec_cmd("hyprctl dispatch resizeactive " .. moveOut .. " 0"), { repeating = true })
    hl.bind("h", hl.dsp.exec_cmd("hyprctl dispatch resizeactive " .. moveIn .. " 0"), { repeating = true })
    hl.bind("k", hl.dsp.exec_cmd("hyprctl dispatch resizeactive 0 " .. moveIn), { repeating = true })
    hl.bind("j", hl.dsp.exec_cmd("hyprctl dispatch resizeactive 0 " .. moveOut), { repeating = true })
    
    hl.bind("equal", hl.dsp.layout("mfact exact 0.5"))
    hl.bind("escape", hl.dsp.submap("reset"))
end)
