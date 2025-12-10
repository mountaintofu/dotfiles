# Some tinkering I did for my Linux machine(s).

### Current setup (Arch Linux, XFCE4, X11):

> Hardware: <ins>Lexar SL300 1TB</ins> (got it on sale, lol), and whatever laptop/computer I got my hands on.\
\
_"/usr/share/themes/"_ and _"/usr/share/icons/"_ are where to put themes and icons in (use *sudo* if needed).\
\
There are also other systems I've had on USBs and microSDs from years back (already disposed of for storage, check ![screenshots](	/../main/screenshots/)) and a dumb one (![XFWM4-Standalone](	/../main/XFWM4-Standalone/usr)).

<p align="center">
<img height="192" width="341" src="https://github.com/mountaintofu/dotfiles/blob/main/screenshots/Screenshot_2025-12-11_01-11-12.png" hspace="10"/>
<img height="192" width="341" src="https://github.com/mountaintofu/dotfiles/blob/main/screenshots/Screenshot_2025-12-06_09-25-18.png" hspace="10"/>
<img height="192" width="341" src="https://github.com/mountaintofu/dotfiles/blob/main/screenshots/Screenshot_2025-12-11_00-55-23.png" hspace="10"/>
<img height="192" width="341" src="https://github.com/mountaintofu/dotfiles/blob/main/screenshots/Screenshot_2025-12-11_00-59-25.png" hspace="10"/>

</p>

This is a somewhat comprehensive tutorial repository to keep track of what I've done to my system, I guess. Copy whatever you want.
- ![TNO](	/../main/xfce4-themes/themes/TNO.zip)* "gapped"-theme.
> There are gaps between windows. Window-tiling are stock, binded in "Keyboard Shortcut":
  
- <ins>xfce4-panel</ins>, custom <ins>genmon</ins> scripts. (![windowTitle.sh](	/../main/config/genmon/windowTitle.sh), ![vtec.sh](	/../main/config/genmon/vtec.sh), ![batteryBar.sh](	/../main/config/genmon/batteryBar.sh), ![presentationMode.sh](	/../main/config/genmon/presentationMode.sh).)
  
- "xfce4-terminal --drop-down" + <ins>yay</ins> + <ins>zsh</ins> + <ins>oh-my-posh</ins>. (![minimal-tokyo.omp.json](	/../main/config/minimal-tokyo.omp.json)*.)
![](	/../main/screenshots/minimal-tokyo.png)

- ![Tela-circle-blue](https://github.com/vinceliuice/Tela-circle-icon-theme) icons.
  
- ![modified-otis-darker](	/../main/xfce4-themes/themes/modified-otis-darker/)*.
  
- ![Bibata-Modern-Ice](https://github.com/ful1e5/Bibata_Cursor) mouse theme.
  
- ![MilkGrub](https://github.com/gemakfy/MilkGrub) theme.
> Theme ![collections](https://github.com/Jacksaur/Gorgeous-GRUB/tree/main) (Gorgeous-GRUB).\
> ![Installation](https://github.com/Jacksaur/Gorgeous-GRUB/blob/main/Installation.md) and 2nd ![link](	/../main/grub-themes/Installation.md).
  
- ![Librewolf/Firefox extension](	/../main/custom-add-on(s)/Tokyo-Night-Tabs/)*.


### Security and efficiency:
- <ins>tlp</ins> (default=_auto_) + <ins>cpupower-gui</ins>.
> default=![Bottle](	/../main/config/cpupower_gui/cpg-Bottle.profile) (510 MHz/CPU, powersaving) for ![vtec.sh](	/../main/config/genmon/vtec.sh).

- <ins>ufw</ins>.
> configuration script: ![ufw-paranoid.sh](	/../main/config/ufw-paranoid.sh)*. (Require *sudo*.)

- ![quickwg.sh](	/../main/config/quickwg.sh)* (require *sudo*.) 
> depends on <ins>WireGuard</ins> (available on _AUR_) and <ins>Proton VPN</ins> (just create an account and check for WG's config files there, remember to extend the files year-long expiration dates), don't forget to put its/quicksw.sh link in _"/.local/bin/"_.

- I'll add more if I remember...


### Miscellaneous (chucking in some packages I installed).
- <ins>tmatrix</ins>. (I like the matrix-trilogy.)
  
- <ins>yazi</ins>. (CLI alternative to Thunar.)
  
- <ins>cbonsai</ins>.
> to pretend I'm an old man sipping tea and relax, of course.
  
- <ins>btop</ins>, <ins>fastfetch</ins> 
> "/$HOME/.config/fastfetch/![ascii.txt](	/../main/config/fastfetch/ascii.txt)", "![config.jsonc](	/../main/config/fastfetch/config.jsonc)") and <ins>neofetch</ins> ("/$HOME/.config/neofetch/![config.conf](	/../main/config/neofetch/config.conf)".
  
- <ins>IBus</ins>/<ins>IBus-Bamboo</ins>
> (for certain special characters, though require a restart after every long usage: _ibus restart_). Keyboard shortcut: Alt + X.
  
- <ins>VMWare-Workstation</ins>/<ins>Player</ins> and <ins>Wine-Staging</ins> (![installation](https://wiki.archlinux.org/title/Wine#Installation)) for Windows' games compatibility.
  
- <ins>LM Studio</ins> for playing with AI.
> Currently using:
> + Deepseek R1 0528 Qwen3 8B Q8_0.
> + Qwen3 4B Thinking 2507 Q4_K_H.
> + Qwen2.5 Coder 7B Instruct Q4_K_M.
> + Qwen2.5 Coder 14B Q4_K_M.
  
- <ins>LibreOffice</ins>.
  
- <ins>Xtreme Download Manager</ins>.
  
- <ins>VLC</ins> and <ins>mpv</ins> (for playing media.)
  
- <ins>Mousepad</ins> and <ins>VSCodium</ins>.
  
- <ins>GIMP</ins> for image editing and <ins>Viewnior</ins> for viewing images.


## Things to consider in the future:
- Make the repo tidier.
- Simple shell script for restoration (or just install a package for that, ya dum dum) in case of a potential system nuking.
- Removing reliance on xorg and X11 (waiting for XFCE4 to have full Wayland support first).
- Try not to be an idiot and keep your head high (also, be extra careful).

> ### Keyboard Shortcuts:
> - Tile Left: Alt + Left
> - Tile Right: Alt + Right
> - Tile Up(Wide): Alt + Up
> - Tile Down(Wide): Alt + Down
> - Tile Up(Left): Alt + ;
> - Tile Up(Right): Alt + '
> - Tile Down(Left): Alt + ,
> - Tile Down(Right): Alt + .
> - Fullscreen: Alt + /
> - *IBus* shortcut (IBus Preference/Keyboard Shortcut): SUPER/"Windows Key" + Z.
>
> *: customed to fit my tastes and needs, duh.\
<sub>(syntax help: https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax)</sub>
