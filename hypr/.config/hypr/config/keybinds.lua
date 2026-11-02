-- Personal keybind layout (v1 muscle memory, ALT as mainMod) mapped onto serpantinum v2 commands.
-- Upstream reference: /usr/share/serpantinum/compositors/hyprland/config/keybinds.lua
local mainMod = _G.mainMod or "SUPER"
local terminal = _G.terminal or "kitty"
local browser = _G.browser or "firefox"
local fileManager = _G.fileManager or "ski"

local function shell(cmd) return hl.dsp.exec_cmd("serpantinum " .. cmd) end

-- ───────── Mouse & gestures ─────────
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- ───────── Applications ─────────
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))

-- ───────── Shell (serpantinum) ─────────
hl.bind(mainMod .. " + R", shell("msg toggle launcher"))     -- v1: rofi drun
hl.bind(mainMod .. " + C", shell("msg toggle clipboard"))
hl.bind(mainMod .. " + M", shell("msg toggle music"))
hl.bind(mainMod .. " + P", shell("msg toggle system"))       -- v1: battery popup
hl.bind(mainMod .. " + W", shell("msg toggle wallpaper"))
hl.bind(mainMod .. " + O", shell("msg toggle calendar"))
hl.bind(mainMod .. " + N", shell("msg toggle network"))
hl.bind(mainMod .. " + V", shell("msg toggle volume"))
hl.bind(mainMod .. " + G", shell("msg toggle settings"))     -- v1: guide / cheat sheet
hl.bind(mainMod .. " + A", shell("msg toggle autohide"))
hl.bind(mainMod .. " + SHIFT + R", shell("reload"))

-- ───────── System & hardware ─────────
hl.bind("XF86MonBrightnessDown", shell("brightness lower"), { locked = true })
hl.bind("XF86MonBrightnessUp", shell("brightness raise"), { locked = true })

hl.bind("Print", shell("screenshot"), { locked = true })
hl.bind("SHIFT + Print", shell("screenshot --edit"), { locked = true })
hl.bind("SUPER + Print", shell("screenshot --full"), { locked = true })
hl.bind("SUPER + SHIFT + Print", shell("screenshot --full --edit"), { locked = true })

hl.bind("XF86PowerOff", shell("lock"), { locked = true })
hl.bind("CTRL + L", shell("lock"), { locked = true })

-- ───────── Media & audio ─────────
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioMicMute", shell("volume mic-toggle"), { locked = true })
hl.bind("XF86AudioMute", shell("volume mute-toggle"), { locked = true })
hl.bind("XF86AudioLowerVolume", shell("volume lower"), { repeating = true, locked = true })
hl.bind("XF86AudioRaiseVolume", shell("volume raise"), { repeating = true, locked = true })

-- ───────── Window management ─────────
hl.bind(mainMod .. " + X", hl.dsp.window.close())
hl.bind(mainMod .. " + F", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))

hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))

hl.bind(mainMod .. " + CTRL + H", hl.dsp.window.resize({ x = -50, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + L", hl.dsp.window.resize({ x = 50, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + K", hl.dsp.window.resize({ x = 0, y = -50, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + J", hl.dsp.window.resize({ x = 0, y = 50, relative = true }), { repeating = true })

-- ───────── Workspaces (routed through the shell so the bar stays in sync) ─────────
for i = 1, 10 do
  local key = tostring(i % 10)
  hl.bind(mainMod .. " + " .. key, shell("msg workspace " .. i))
  hl.bind(mainMod .. " + SHIFT + " .. key, shell("msg workspace " .. i .. " move"))
end

hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
