# Some tinkering I did for my Linux machines.

### Current setup (Arch Linux, XFCE4, X11):

This is a repository to keep track of what I've done to my system.

![](	/../main/screenshots/Screenshot_2025-12-06_09-25-18.png)

<ins>Hardware</ins>: Lexar SL300 1TB (got it on sale, lol), and whatever laptop/computer I got my hands on.

> Put the themes into _/usr/share/themes/_ and icons to _/usr/share/icons/_.

> [ There are also other systems I've had from years ago (check ![screenshots](	/../main/screenshots/)) and a dumb one (![XFWM4-Standalone](	/../main/XFWM4-Standalone/usr)). ]


- TNO* theme.
- xfce4-panel, genmon scripts* (_windowTitle.sh_, _vtec.sh_, _batteryBar.sh_, _presentationMode.sh_).
- yay + zsh + oh-my-posh (_minimal-tokyo.omp.json_*).
![](	/../main/screenshots/minimal-tokyo.png)
- ![Tela-circle-blue](https://github.com/vinceliuice/Tela-circle-icon-theme) icons.
- modified-otis-darker*.
- ![Bibata-Modern-Ice](https://github.com/ful1e5/Bibata_Cursor) mouse theme.
- ![MilkGrub](https://github.com/gemakfy/MilkGrub) theme.
- ![Librewolf/Firefox extension*](	/../main/custom-add-on(s)/Tokyo-Night-Tabs/).


### Security and efficiency:
- tlp (default=_auto_) + cpupower-gui (default=_Bottle_*) for _v-tec.sh_ (Performance/Bottle mode).
- ufw (script: _ufw-paranoid.sh_*).
- ![quicksw.sh*](	/../main/config/quickwg.sh) (quick script that depends on wireguard and proton-vpn, don't forget to put its link in _/.local/bin/_)
- I'll add more if I remember...

### Miscellaneous (chucking in some packages I use daily).
- <ins>tmatrix</ins> (I like the matrix-trilogy).
- <ins>yazi</ins> (CLI alternative to my current File Manager).
- <ins>cbonsai</ins> (to pretend I'm an old man and relax, of course).
- <ins>btop</ins>, <ins>htop</ins>, <ins>fastfetch</ins> and <ins>neofetch</ins> (why not?)
- <ins>ibus</ins>/<ins>ibus-bamboo</ins> (for certain special characters, though require a restart after every long usage: _ibus restart_).
- <ins>VMWare-Workstation</ins>/<ins>Player</ins> and <ins>Wine-Staging</ins> for Windows' games compatibility.
- <ins>LM Studio</ins> for playing with AI.
- <ins>LibreOffice</ins> (for office work, duh).
- <ins>Xtreme Download Manager</ins>.
- <ins>VLC</ins> and <ins>mpv</ins> (for playing media)
- <ins>Mousepad</ins> and <ins>VSCodium</ins>.
- <ins>GIMP</ins> for image editing and <ins>Viewnior</ins> for viewing images.

## Things to consider in the future:
- Make the repo tidier.
- Simple shell script for restoration (or just install a package for that, ya dum dum) in case of a potential system nuking.
- Removing reliance on xorg and X11 (waiting for XFCE4 to have Wayland support first).
- Try not to be an idiot and keep your head high (also, be extra careful).

> *: custom (to fit my taste, duh.)

> <sub>(syntax help: https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax)</sub>
