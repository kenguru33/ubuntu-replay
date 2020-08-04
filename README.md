# Replay Ubuntu 20.04 LTS

Tested with Ubuntu 20.04 LTS

### Key feutures:

- Traditional Gnome setup. (Toolbar, No icons on desktop etc...)
- Installing extra packages (git, curl, vim, Chome, Visual Studio code, nodejs etc...)
- Nice shell setup with Oh-My-Zsh shell. (pure prompt, syntaxhighligthing plugin)
- Replace snap packages. (If snap package found in ubuntu repoitory, it wil be replaced. If not, leave snap package installed)
- Some nice Gnome extension (Caffeine, Sound output input selector, Clipboard indicator etc...)
- Desktop polish (custom desktop background, select default dark mode etc.)
- Configure npm properly. No need to use sudo for global installs.
- Configure git with credential helper using libsecret.

See manifest.sh for more details.

### Installation

Just copy and paste this in a terminal windows:

```console
wget -qO- https://raw.githubusercontent.com/kenguru33/ubuntu-replay/master/main.sh | bash -s
```

Also it is recommended to make sure your system is fully udatated before replaying your Ubuntu installation. 
