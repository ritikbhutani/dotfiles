# dotfiles

GNU Stow packages for my Arch + Hyprland setup, built on [Serpantinum](https://github.com/ilyamiro/serpantinum) v2.

```sh
cd ~/dev/dotfiles
stow -t ~ hypr kitty nvim zsh bash starship tmux serpantinum-extras
sudo stow -t / bin
systemctl --user enable --now serp-theme-sync.path
```

`.stowrc` sets `--no-folding`, so only tracked files are linked. Files the shell generates at runtime (kitty `colors.conf`, nvim `matugen_colors.lua`) stay as real files outside the repo.

| Package | What |
| --- | --- |
| `hypr` | Hyprland Lua config (0.57+). Serpantinum's upstream config, plus personal monitors, ALT-based keybinds, look and autostart |
| `serpantinum-extras` | `serp-theme-sync` + systemd path unit: on every Serpantinum palette change, re-runs my matugen config (nvim colours + RGB colour) and sets the theme's primary accent on all OpenRGB devices via OpenRGB's local SDK server (`openrgb --server`, started from hypr autostart). `serp-default-wallpaper`: sets the default wallpapers once per machine on first login (images ship in the ansible repo, `pacman/files/wallpapers/`) |
| `kitty` | Serpantinum default + `background_opacity 0.85`; colours come from Serpantinum's `colors.conf` |
| `nvim` | Neovim config; live-reloads `matugen_colors.lua` |
| `zsh` | `.zshrc` (+ `fetch` themed from Serpantinum's palette) and `user_aliases.zsh` |
| `bash`, `starship`, `tmux` | Shell bits |
| `bin` | Scripts stowed to `/usr/local` |

Not tracked, because Serpantinum owns them: `~/.config/serpantinum/settings.json` (holds geolocation), cava and fastfetch.

## Serpantinum

Installed as a pacman package from `~/src/serpantinum/packaging/aur/serpantinum-git`. The local PKGBUILD pins a release tag, sets `!debug`, and drops Ski's `FileManager1` D-Bus service so nautilus stays the file manager. To update, bump the tag and run `makepkg -si`. Don't use the curl installer.

The old Waybar/hyprpaper/wofi rice lives on the `archive/waybar-rice` branch.
