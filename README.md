# Replay Ubuntu 19.04 setup.

Tested with Ubuntu 19.04

### Key feutures:

- Traditional Gnomme setup. (Toolbar, No icons on desktop etc...)
- Installing extra packages (git, curl, vim, Chome, Visual Studio code, nodejs etc...)
- Nice shell setup with Oh-My-Zsh shell. (pure prompt, syntaxhighligthing plugin)
- Replace snap packages. (If snap package found in ubuntu repoitory, it wil be replaced. If not, leave snap package installed)
- Some nice Gnome extension (Caffeine, Sound output input selector, Clipboard indicator etc...)
- Desktop polish (custom desktop background, select default dark mode etc.)

See manifest.sh for more details.

### Installation

Just copy and paste this in a terminal windows:

```console
wget -qO- https://raw.githubusercontent.com/kenguru33/ubuntu-replay/master/main.sh | bash -s
```

Also it is recommended to make sure your system is fully udatated before replaying your Ubuntu installation. 