hl.on("hyprland.start", function()
  hl.exec_cmd("wl-paste --type text --watch cliphist store")
  hl.exec_cmd("wl-paste --type image --watch cliphist store")
  hl.exec_cmd("serpantinumd start")

  -- Personal
  hl.exec_cmd("openrgb --startminimized")
  hl.exec_cmd("$HOME/.local/bin/serp-default-wallpaper")  -- one-shot on fresh installs (~/.local/bin is not on the session PATH)
end)
