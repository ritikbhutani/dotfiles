-- 4K main display, right of the rotated 1080p side display
hl.monitor({
  output = "DP-1",
  mode = "3840x2160@60",
  position = "1080x0",
  scale = 1.0,
})

hl.monitor({
  output = "HDMI-A-1",
  mode = "1920x1080@144",
  position = "0x120",
  scale = 1.0,
  transform = 1,
})

-- Fallback for any other display that gets plugged in
hl.monitor({
  output = "",
  mode = "preferred",
  position = "auto",
  scale = 1.0,
})

hl.workspace_rule({ workspace = "1", monitor = "HDMI-A-1" })
