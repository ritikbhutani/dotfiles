-- BenQ EW3270U 31.5" 4K (139 PPI). Scale 4/3 -> 2880x1620 logical: slightly smaller UI than
-- the MSI 1080p (1.5 matched it exactly but felt too big). Valid steps: 1.25, 1.333333, 1.5.
hl.monitor({
  output = "DP-1",
  mode = "3840x2160@60",
  position = "1080x150", -- vertically centred against the 1920-tall portrait screen
  scale = 1.333333,
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
