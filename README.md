# dot-zsh

## Install
```
% git clone https://github.com/gion-xy/dot-zsh .zsh
% ln -s .zsh/.zshenv
```

## Compile
```
% setopt extended_glob
% for f in ~/.zsh/.z{profile*,sh*}~*.zwc; zcompile $f
```
