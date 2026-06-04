# Fedora + Sway setup on MacBook

## Packages installed

```bash
sudo dnf install kitty waybar network-manager-applet pasystray pavucontrol \
                 blueman playerctl wob brightnessctl \
                 greetd tuigreet swaylock swayidle \
                 wofi slurp wev \
                 xfce-polkit cliphist \
                 fuse fuse-libs squashfs-tools \
                 openssh-askpass \
                 jetbrains-mono-fonts-all adw-gtk3-theme papirus-icon-theme
```

---

## Keyboard cheatsheet

### Sway — Window management

| Key | Action |
|---|---|
| `Super+Return` | New terminal |
| `Super+D` | App launcher (wofi) |
| `Super+Shift+Q` | Kill window |
| `Super+Shift+C` | Reload Sway config |
| `Super+Shift+E` | Exit Sway |
| `Super+F` | Fullscreen |
| `Super+Space` | Focus floating/tiling toggle |
| `Super+Shift+Space` | Toggle floating |
| `Super+H/J/K/L` | Focus left/down/up/right |
| `Super+Left/Down/Up/Right` | Focus left/down/up/right |
| `Super+Shift+H/J/K/L` | Move window |
| `Super+Shift+Left/Down/Up/Right` | Move window |
| `Super+1–9` | Switch workspace |
| `Super+Shift+1–9` | Move window to workspace |
| `Super+Shift+R` | Resize mode |
| `Super+Shift+V` | Split vertical |
| `Super+B` | Split horizontal |
| `Super+S` | Stacking layout |
| `Super+Shift+W` | Tabbed layout |
| `Super+E` | Toggle split layout |
| `Super+A` | Focus parent |
| `Super+Minus` | Show scratchpad |
| `Super+Shift+Minus` | Move to scratchpad |

### Sway — System

| Key | Action |
|---|---|
| `Super+Ctrl+L` | Lock screen |
| `Super+Ctrl+V` | Clipboard history picker |
| `Super+Ctrl+3` | Full screenshot → `~/Pictures/` |
| `Super+Ctrl+4` | Region screenshot → `~/Pictures/` |
| `Super+Ctrl+Shift+3` | Full screenshot → clipboard |
| `Super+Ctrl+Shift+4` | Region screenshot → clipboard |

### Media keys (F-row, F1–F12 primary with fnmode=2)

| Key | Action |
|---|---|
| `F1` / `F2` | Brightness −/+ |
| `F7` / `F8` / `F9` | Prev / Play-pause / Next |
| `F10` | Mute toggle |
| `F11` / `F12` | Volume −/+ |
| `Fn+F10` | Mute mic |

### Keyboard layout switching

| Key | Action |
|---|---|
| `CapsLock` | Switch US ↔ RU |
| `Alt+Space` | Switch US ↔ RU |
| `Shift+CapsLock` | Actual CapsLock |

### Kitty terminal

| Key | Action |
|---|---|
| `Cmd+C` | Copy (Ctrl+C = SIGINT) |
| `Cmd+V` | Paste |
| `Cmd+T` | New tab |
| `Cmd+W` | Close tab |
| `Cmd+N` | New window |
| `Cmd+[` / `Cmd+]` | Prev/next tab |
| `Cmd+1–9` | Switch to tab |
| `Cmd+=` / `Cmd+-` | Font size |
| `Cmd+F` | Search scrollback |
| `Shift+PageUp/Down` | Scroll |

---

## Keyboard

### F1–F12 as default (media keys require Fn)

`/etc/modprobe.d/hid_apple.conf`:
```
options hid_apple fnmode=2
```

Apply without reboot:
```bash
echo 2 | sudo tee /sys/module/hid_apple/parameters/fnmode
```

Requires initramfs rebuild to survive reboots:
```bash
sudo dracut --force
```

## Display

### DPI / scaling

`~/.config/sway/config`:
```
output eDP-1 scale 1.5
```
Effective resolution: 1707×1067 from native 2560×1600.
Adjust to `1.25` (larger) or `1.75` (smaller) as needed.

## Touchpad

Natural scroll disabled (traditional direction), tap-to-click enabled:

`~/.config/sway/config`:
```
input type:touchpad {
    natural_scroll disabled
    tap enabled
    tap_button_map lrm
}
```

Tap gestures:
- 1 finger tap = left click
- 2 finger tap = right click
- 3 finger tap = middle click

## Status bar — Waybar

`~/.config/waybar/config` — modules:
- **Left:** workspaces, mode indicator
- **Center:** date/time
- **Right:** `CPU x%`, `RAM x.xG`, `VOL x%`, network + IP (click → nm-connection-editor), `BAT x%`, notifications, tray

`~/.config/waybar/style.css` — dark Catppuccin-inspired theme.

Notification bell: left-click toggles swaync panel, right-click toggles Do Not Disturb.
Battery shows `BAT+` when charging.

## System tray applets

Started via `exec_always` in `~/.config/sway/config` (pkill before each to avoid duplicates on reload):

| Applet | Purpose |
|---|---|
| `swaync` | Notification daemon |
| `/usr/libexec/xfce-polkit` | Polkit agent — GUI password prompts |
| `nm-applet --indicator` | Network / WiFi / VPN |
| `wl-paste --watch cliphist store` | Clipboard history daemon |
| `pasystray` | Audio volume tray icon |
| `blueman-applet` | Bluetooth |

Volume/brightness changes show a progress bar overlay via `wob`.
Media keys control any MPRIS-compatible player via `playerctl`.

## Fonts & GTK theme

- **Font:** JetBrains Mono 11 — used in Kitty, Waybar, and GTK apps
- **GTK theme:** adw-gtk3-dark — dark Adwaita for GTK3/4 apps
- **Icon theme:** Papirus-Dark

Config files: `~/.config/gtk-3.0/settings.ini`, `~/.config/gtk-4.0/settings.ini`

Applied via `gsettings` on Sway startup for apps that read dconf.

## Screen lock — swaylock + swayidle

`~/.config/swaylock/config` — Catppuccin-themed lock screen.

Idle behaviour:
- 5 min idle → lock screen
- 10 min idle → display off
- Before sleep → lock screen

## App launcher — wofi

`~/.config/wofi/config` + `~/.config/wofi/style.css`

`Super+D` opens wofi showing installed apps with icons, case-insensitive search.

## Notifications — swaync

SwayNotificationCenter runs as notification daemon. Config in `~/.config/swaync/`.
Clicking a notification focuses the sending app's window via `~/.local/bin/swaync-focus`.

## Clipboard — cliphist

`wl-paste --watch cliphist store` records all clipboard entries.
`Super+Ctrl+V` opens wofi picker — select an item to copy it back to clipboard.

## Keyboard layouts

Russian as second layout, switchable via CapsLock or Alt+Space:

`~/.config/sway/config`:
```
input type:keyboard {
    xkb_layout "us,ru"
    xkb_options "grp:caps_toggle,grp:alt_space_toggle"
}
```

`Shift+CapsLock` sends actual CapsLock.

## Display manager — greetd + tuigreet

Replaces GDM with a minimal TUI login screen.

`/etc/greetd/config.toml`:
```toml
[terminal]
vt = 1

[default_session]
command = "tuigreet --time --remember --cmd /home/alexkuklin/.local/bin/start-sway"
user = "greetd"
```

Uses a startup script `~/.local/bin/start-sway` that waits for the systemd user D-Bus socket before launching Sway, ensuring tray applets start correctly on boot. Sway config uses `exec sleep 2 && <applet>` for first boot and `exec_always pkill -x <applet>; <applet>` for config reloads.

```bash
sudo systemctl disable gdm
sudo systemctl enable greetd
```

To roll back: `sudo systemctl enable gdm && sudo systemctl disable greetd`

### Removing GNOME

`gnome-shell` is protected by default — remove the protection first:

```bash
sudo rm /etc/dnf/protected.d/fedora-workstation.conf
sudo dnf remove gnome-shell gnome-session gdm
sudo dnf autoremove
```

Note: `NetworkManager` is protected separately and remains untouched.
`blueman` may be caught by autoremove — reinstall if Bluetooth applet is missing: `sudo dnf install blueman`

## SSH agent

Managed via systemd user service for reliable startup and predictable socket path.

`~/.config/systemd/user/ssh-agent.service`:
```ini
[Unit]
Description=SSH key agent

[Service]
Type=simple
Environment=SSH_AUTH_SOCK=%t/ssh-agent.socket
ExecStart=/usr/bin/ssh-agent -D -a $SSH_AUTH_SOCK

[Install]
WantedBy=default.target
```

```bash
systemctl --user enable --now ssh-agent.service
```

`~/.bashrc` and `~/.bash_profile`:
```bash
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
```

## Hostname

Set static hostname to prevent IPv6 DHCP from overriding it:

```bash
sudo hostnamectl set-hostname mba
```

`/etc/NetworkManager/conf.d/no-hostname.conf`:
```ini
[main]
hostname-mode=none
```

## WireGuard

Keypair stored in `/etc/wireguard/private.key` and `/etc/wireguard/public.key`.
Config at `/etc/wireguard/wg0.conf` — address `192.168.10.7/24`.

```bash
sudo wg-quick up wg0       # connect
sudo wg-quick down wg0     # disconnect
sudo wg show               # status
sudo systemctl enable wg-quick@wg0  # auto-connect on boot
```

## Power button

Short press: ignored (prevents accidental shutdown).
Long press: poweroff.

`/etc/systemd/logind.conf.d/power-key.conf`:
```ini
[Login]
HandlePowerKey=ignore
HandlePowerKeyLongPress=poweroff
```

## Sway keybinding changes from defaults

| Old | New | Reason |
|---|---|---|
| `Super+V` splitv | `Super+Shift+V` | freed for clipboard picker |
| `Super+W` tabbed layout | `Super+Shift+W` | freed for Cmd+W close tab in Kitty |
| `Super+R` resize | `Super+Shift+R` | freed (reserved for future use) |
