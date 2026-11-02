-- BenQ EW3270U 31.5" 4K (139 PPI). Scale 1.5 -> 2560x1440 logical, matching the
-- MSI's ~91 PPI at scale 1 so UI is the same physical size on both screens.
hl.monitor({
  output = "DP-1",
  mode = "3840x2160@60",
  position = "1080x240", -- vertically centred against the 1920-tall portrait screen
  scale = 1.5,
})

-- MSI G242 23.9" 1080p, rotated to portrait (1080x1920 logical), left of the 4K
hl.monitor({
  output = "HDMI-A-1",
  mode = "1920x1080@144",
  position = "0x0",
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
