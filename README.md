## Some tinkering I did for my Linux machines.

### <ins>Current setup</ins> (Arch Linux, XFCE4, X11):

This is a repository to keep track of what I've done to my system.

![](	/../main/screenshots/Screenshot_2025-12-06_09-25-18.png)

Put the themes into _/usr/share/themes/_ and icons to _/usr/share/icons/_.

[There are also other systems I've had from years ago (check ![screenshots](	/../main/screenshots/)) and a dumb one (![XFWM4-Standalone](	/../main/XFWM4-Standalone/usr)).]


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
- tmatrix (I like the matrix-trilogy).
- yazi (CLI alternative to my current File Manager).
- cbonsai (to pretend I'm an old man and relax, of course).
- _btop_, _htop_, _fastfetch_ and _neofetch_ (why not?)
- ibus/ibus-bamboo (for certain special characters, though require a restart after every long usage: _ibus restart_).
- VMWare-Workstation/Player and Wine-Staging for Windows' games compatibility.
- LM Studio for playing with AI.
- LibreOffice (for office work, duh).
- Xtreme Download Manager
- VLC and mpv (for playing media)
- mousepad and VSCodium.
- GIMP for image editing and Viewnior for viewing images.

## Things to consider in the future:
- Make the repo tidier.
- Simple shell script for restoration (or just install a package for that, ya dum dum) in case of a potential system nuking.
- Removing reliance on xorg and X11 (waiting for XFCE4 to have Wayland support first).
- Try not to be an idiot and keep your head high (also, be extra careful).

<br/>
*: custom (to fit my taste, duh.)<br/>

<sub>(syntax help: https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax)</sub>
