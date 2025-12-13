# .files

Personal Linux configuration files and setup documentation.

## Current Setup

| **Component** | **Details** |
|---|---|
| **OS** | Arch Linux |
| **DE** | XFCE4 |
| **Display Server** | X11 |
| **Hardware** | Lexar SL300 1TB (portable setup) |

<p align="center">
  <img height="192" width="341" src="screenshots/Screenshot_2025-12-11_01-11-12.png" style="margin: 0 10px;"/>
  <img height="192" width="341" src="screenshots/Screenshot_2025-12-06_09-25-18.png" style="margin: 0 10px;"/>
  <img height="192" width="341" src="screenshots/Screenshot_2025-12-11_00-55-23.png" style="margin: 0 10px;"/>
  <img height="192" width="341" src="screenshots/Screenshot_2025-12-11_00-59-25.png" style="margin: 0 10px;"/>
</p>

---

## Installation Notes

System directories (may require `sudo`):
- `/usr/share/sounds/`
- `/usr/share/themes/`
- `/usr/share/icons/`

User scripts:
- `~/.local/bin/`

> Refer to the [Arch Wiki](https://wiki.archlinux.org/title/Main_page) for more information.
>
> See [screenshots](screenshots/) for previous setups. [XFWM4-Standalone](theme-files/XFWM4-Standalone/usr) is experimental.

---

## Theming

### Display Manager
- LightDM.

### Autostart
- [autoScaler.sh](config/autoScaler.sh) — Fetches screen resolution and scales proportionally.
- Blueman Applet — For wireless audio usage.
- IBus — Special characters input.
- `cpupower-gui` profile: Bottle* - Throttling CPUs for battery-saving purposes.
- Libinput Gestures — Touchscreen compatibility.

### Window Manager
- [TNO](theme-files/xfce4-themes/themes/TNO.zip)* — Custom theme with gaps between windows.
- Window tiling uses stock XFCE bindings (see [Keyboard Shortcuts](#keyboard-shortcuts)).

### Panel
![Panel Preview](screenshots/Screenshot_2025-12-11_13-49-41.png)

Customized **xfce4-panel** with **genmon** scripts:
- [windowTitle.sh](config/genmon/windowTitle.sh) — Display current window.
- [vtec.sh](config/genmon/vtec.sh)* — Set the scaling frequencies and governor of a CPU.
- [batteryBar.sh](config/genmon/batteryBar.sh)* — Displaying battery's capacity and various information.
- [presentationMode.sh](config/genmon/presentationMode.sh)* — XFCE4's presentation mode toggle.

### Terminal
- **xfce4-terminal** in drop-down mode (see [Keyboard Shortcuts](#keyboard-shortcuts)).
- **yay** + **zsh** + **oh-my-posh**.
- Custom prompt: [minimal-tokyo.omp.json](config/minimal-tokyo.omp.json)*.

![Terminal Preview](screenshots/minimal-tokyo.png)

### Icons & Cursors
- [Tela-circle-blue](https://github.com/vinceliuice/Tela-circle-icon-theme) icons.
- [Bibata-Modern-Ice](https://github.com/ful1e5/Bibata_Cursor) cursor.

### Audio
- `pipewire` defaults.
- KDE [ocean-sound-theme](https://github.com/KDE/ocean-sound-theme).
  > Enable via: *Appearance → Settings → Enable event sounds*.

### GRUB
- [MilkGrub](https://github.com/gemakfy/MilkGrub) theme.
- Theme collection: [Gorgeous-GRUB](https://github.com/Jacksaur/Gorgeous-GRUB).
- Installation: [Guide](https://github.com/Jacksaur/Gorgeous-GRUB/blob/main/Installation.md) | [Local copy](theme-files/grub-themes/Installation.md).

### Browser Extension
- [Tokyo Night Tabs](theme-files/custom-browser-add-on(s)/Tokyo-Night-Tabs/)* — LibreWolf/Firefox extension.

---

## Security & Efficiency

### Browser Setup
Use `[package]-bin` for faster installation.

**LibreWolf**
- uBlock Origin ([settings](config/my-ublock-backup_2025-12-13_00.10.00.txt))*.
  > Alternatively `AdNauseum` ([settings](config/AdNauseam_Settings_Export_12.13.2025.1.43.10AM.json)*).\
  Use **only** one or the other.
- Privacy Badger.
- CanvasBlocker.
- `media.peerconnection.enabled = false` (in `about:config`).
- `firejail` sandbox (alternative to `tor-browser-bin`).
  > Wrapper script: [parawolf.sh](config/parawolf.sh)*. Add symlink to `~/.local/bin/`.

**Tor Browser**
- Stock only, meant for *users* to look identical.
  > More plugins → more fingerprint. Not ideal.

### VPN
- [quickwg.sh](config/quickwg.sh)* — WireGuard wrapper for Proton VPN.
  > Requires **wireguard-tools** and a **Proton VPN** account.\
  Download config files from the Proton VPN dashboard. Add symlink to `~/.local/bin/`.\
  ⚠️ **Usage of both (VPN and `tor`) will compromise anonymity.**

### Automatic MAC Changing
- **macchanger**.
  > Prompted upon installation. See the [guide](https://wiki.archlinux.org/title/MAC_address_spoofing#macchanger_2) if needed.

### Firewall
- **ufw** — Configuration: [ufw-paranoid.sh](config/ufw-paranoid.sh)*.

### Disk Encryption
- LUKS encryption: [Arch Wiki Guide](https://wiki.archlinux.org/title/Dm-crypt/Encrypting_an_entire_system#LUKS_on_a_partition).
  > ⚠️ **Must be configured before system installation.**\
  Use [archinstall](https://archinstall.archlinux.page/) for easy setup. [Connect to the internet](https://wiki.archlinux.org/title/Installation_guide#Connect_to_the_internet) first.

### Power Management
- **tlp** (default: auto) + **cpupower-gui**.
  > Default `cpupower-gui` profile: Bottle* (510 MHz/CPU, powersave) for [vtec.sh](config/genmon/vtec.sh)*.

---

## Applications

### CLI Tools
| Package | Description |
|---------|-------------|
| **tmatrix** | Matrix rain animation |
| **yazi** | Terminal file manager (Thunar alternative) |
| **cbonsai** | Bonsai tree generator |
| **btop** | System monitor |
| **fastfetch** | System info ([ascii.txt](config/fastfetch/ascii.txt), [config.jsonc](config/fastfetch/config.jsonc)) |
| **neofetch** | System info ([config.conf](config/neofetch/config.conf)) |

### Input Method
- **IBus** / **IBus-Bamboo** — Special character input.
  > May require a restart after extended use: `ibus restart`.

### Compatibility
| Package | Purpose |
|---------|---------|
| **VMware Workstation/Player** | Virtual machines |
| **Wine-Staging** | Windows compatibility ([guide](https://wiki.archlinux.org/title/Wine#Installation)) |
| **Flashpoint** | Flash game archive ([guide](https://flashpointarchive.org/datahub/Linux_Support)) |

### AI
- **LM Studio** — Local LLM inference.
  > Models: DeepSeek-R1-Qwen3-8B, Qwen3-4B-Thinking, Qwen2.5-Coder-7B/14B.

### Productivity
| Package | Purpose |
|---------|---------|
| **LibreOffice** | Office suite |
| **Xtreme Download Manager** | Download manager |
| **VLC** / **mpv** | Media players |
| **Mousepad** / **VSCodium** | Text editors |
| **GIMP** / **Viewnior** | Image editing/viewing |

---

## Keyboard Shortcuts

| Action | Keybind |
|--------|---------|
| Tile left | `Alt + ←` |
| Tile right | `Alt + →` |
| Tile up (wide) | `Alt + ↑` |
| Tile down (wide) | `Alt + ↓` |
| Tile up-left | `Alt + ;` |
| Tile up-right | `Alt + '` |
| Tile down-left | `Alt + ,` |
| Tile down-right | `Alt + .` |
| Fullscreen | `Alt + /` |
| `xfce4-terminal --drop-down` | `Super + Z` |
| Next input method (`ibus-setup`) | `Alt + X` |

---

## TODO

- [ ] Create restoration script
- [ ] Migrate to Wayland (pending XFWM4 support)

---

<sub>\* Custom configs tailored to me, duh.</sub>
