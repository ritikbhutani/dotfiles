hl.on("hyprland.start", function()
  hl.exec_cmd("wl-paste --type text --watch cliphist store")
  hl.exec_cmd("wl-paste --type image --watch cliphist store")
  hl.exec_cmd("serpantinumd start")

  -- Personal
  hl.exec_cmd("openrgb --startminimized --server")  -- local SDK server (127.0.0.1) for theme sync
  hl.exec_cmd("$HOME/.local/bin/serp-theme-sync --wait-openrgb")  -- RGB + nvim follow the current theme
  hl.exec_cmd("$HOME/.local/bin/serp-default-wallpaper")  -- one-shot on fresh installs (~/.local/bin is not on the session PATH)
end)
