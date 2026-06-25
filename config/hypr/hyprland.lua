-- hyprland.lua
-- Hyprland Lua configuration (0.47+)
-- Converted from hyprland.conf
-- Refer to: https://wiki.hyprland.org/Configuring/

--------------------
--- SOURCE FILES ---
--------------------
-- Note: sourced files must be Lua (.lua) in Lua config mode.
-- Convert mocha.conf and monitors.conf separately.
require("mocha")
require("monitors")


--------------------
--- MONITORS -------
--------------------
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })


-------------------
--- AUTOSTART -----
-------------------
hl.on("hyprland.start", function()
    hl.exec_cmd("uwsm app -s s -- ashell")
    hl.exec_cmd("uwsm app -s s -- swayosd-server")
    hl.exec_cmd("uwsm app -s s -- hypridle")
    hl.exec_cmd("uwsm app -s s -- vicinae server")
    hl.exec_cmd("uwsm app -t service -p Restart=always -p RestartSec=1 -- wpaperd")
    hl.exec_cmd("hyprctl setcursor catppuccin-mocha-flamingo-cursors 32")
end)


----------------------------
--- ENVIRONMENT VARIABLES ---
----------------------------
hl.env("XCURSOR_SIZE",                     "32")
hl.env("HYPRCURSOR_SIZE",                  "32")
hl.env("XCURSOR_THEME",                    "catppuccin-mocha-flamingo-cursors")
hl.env("HYPRCURSOR_THEME",                 "catppuccin-mocha-flamingo-cursors")
hl.env("QT_QPA_PLATFORM",                  "wayland")
hl.env("QT_QPA_PLATFORMTHEME",             "qt5ct")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR",      "1")
-- hl.env("QT_STYLE_OVERRIDE",             "kvantum")


-------------------
--- LOOK AND FEEL -
-------------------
hl.config({
    general = {
        gaps_in     = 5,
        gaps_out    = 5,
        border_size = 2,

        -- Colors sourced from mocha.lua globals (e.g. peachAlpha = "fab387")
        -- Suffix "ee" = 93% opacity, "aa" = 67% opacity
        col = {
            active_border   = { colors = { "rgba(" .. peachAlpha .. "ee)", "rgba(" .. flamingoAlpha .. "ee)" }, angle = 45 },
            inactive_border = "rgba(" .. overlay0Alpha .. "aa)",
        },

        resize_on_border = true,
        allow_tearing    = false,
        layout           = "dwindle",
    },

    decoration = {
        rounding       = 5,
        rounding_power = 2,
        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = "rgba(1a1a1aee)",
        },

        blur = {
            enabled   = true,
            size      = 3,
            passes    = 1,
            vibrancy  = 0.1696,
        },
    },

    dwindle = {
        preserve_split = true,
    },

    misc = {
        disable_hyprland_logo = true,
    },

    input = {
        kb_layout  = "us,cz",
        kb_variant = "",
        kb_model   = "",
        kb_options = "grp:alt_shift_toggle",
        kb_rules   = "",

        follow_mouse  = 1,
        sensitivity   = 0,
        accel_profile = "flat",

        touchpad = {
            natural_scroll = false,
        },
    },

    xwayland = {
        force_zero_scaling = true,
    },

    animations = {
        enabled = true,
    },
})

-------------------
--- ANIMATIONS ----
-------------------
--           NAME,             X0,   Y0,    X1,   Y1
hl.curve("easeOutQuint",   { type = "bezier", points = { { 0.23, 1    }, { 0.32, 1    } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1    } } })
hl.curve("linear",         { type = "bezier", points = { { 0,    0    }, { 1,    1    } } })
hl.curve("almostLinear",   { type = "bezier", points = { { 0.5,  0.5  }, { 0.75, 1    } } })
hl.curve("quick",          { type = "bezier", points = { { 0.15, 0    }, { 0.1,  1    } } })

--             NAME,              ON,  SPEED,  CURVE,           [STYLE]
hl.animation({ leaf = "border",        enabled = true,  speed = 5.39, bezier = "easeOutQuint"  })
hl.animation({ leaf = "windows",       enabled = true,  speed = 4.79, bezier = "easeOutQuint"  })
hl.animation({ leaf = "windowsIn",     enabled = true,  speed = 4.1,  bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true,  speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true,  speed = 1.73, bezier = "almostLinear"  })
hl.animation({ leaf = "fadeOut",       enabled = true,  speed = 1.46, bezier = "almostLinear"  })
hl.animation({ leaf = "fade",          enabled = true,  speed = 3.03, bezier = "quick"         })
hl.animation({ leaf = "layers",        enabled = true,  speed = 3.81, bezier = "easeOutQuint"  })
hl.animation({ leaf = "layersIn",      enabled = true,  speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true,  speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true,  speed = 1.79, bezier = "almostLinear"  })
hl.animation({ leaf = "fadeLayersOut", enabled = true,  speed = 1.39, bezier = "almostLinear"  })
hl.animation({ leaf = "workspaces",    enabled = true,  speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = true,  speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true,  speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor",    enabled = true,  speed = 7,    bezier = "quick"         })


-------------------
--- KEYBINDINGS ---
-------------------
local mainMod = "SUPER"

hl.bind(mainMod .. " + SHIFT + Return", hl.dsp.exec_cmd("alacritty"))
hl.bind(mainMod .. " + SHIFT + C",      hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + Q",      hl.dsp.exit())
hl.bind(mainMod .. " + SHIFT + Space",  hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + SHIFT + F",      hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + P",              hl.dsp.exec_cmd("vicinae toggle"))
hl.bind("ALT + L",                      hl.dsp.exec_cmd("loginctl lock-session"))
hl.bind("Print",                        hl.dsp.exec_cmd("wayshot -g"))
hl.bind(mainMod .. " + O",              hl.dsp.layout("togglesplit"))

-- Move focus (vim-style)
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left"  }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down"  }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up"    }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))

-- Move windows
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "left"  }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "down"  }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "up"    }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "right" }))

-- Switch workspaces with mainMod + [0-9]
for i = 1, 10 do
    local key = i % 10  -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i, on_current_monitor = true }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i, follow = false }))
end

-- Scroll through workspaces
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1", on_current_monitor = true }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1", on_current_monitor = true }))

-- Move/resize windows with mouse
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys (repeating + lock-screen aware)
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("ashell msg volume-up"),       { repeating = true, locked = true })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("ashell msg volume-down"),       { repeating = true, locked = true })
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("ashell msg volume-toggle-mute"), { repeating = true, locked = true })
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("ashell msg microphone-toggle-mute"),  { repeating = true, locked = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("ashell msg brightness-up"),          { repeating = true, locked = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("ashell msg brightness-down"),          { repeating = true, locked = true })

-- Media control (lock-screen aware)
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("swayosd-client --playerctl next"),        { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("swayosd-client --playerctl pause"),       { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("swayosd-client --playerctl play-pause"),  { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("swayosd-client --playerctl prev"),        { locked = true })


------------------------------
--- WINDOWS AND WORKSPACES ---
------------------------------

-- Ignore maximize requests from all apps
hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})

-- Fix some dragging issues with XWayland
hl.window_rule({
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus = true,
})
