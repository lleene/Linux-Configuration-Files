#!/bin/bash
# List of packages installed ontop of Fedora29WS

dnf install inkscape ntfs-3g xfreerdp valgrind transmission libcxx libcxxabi gparted texlive-scheme-basic texstudio krita cmake freetype-devel fontconfig-devel xclip latexmk mupdf powerline powerline-fonts qt5-devel xorg-x11-fonts* ImageMagick kicad w3m libnsl cmake ncdu mediawriter clang llvm texlive-was texlive-subfigure texlive-lipsum hunspell-en-GB mupdf texlive-epstopdf texlive-textpos texlive-isodate texlive-qrcode texlive-a0poster texlive-mdframed texlive-algorithm2e texlive-ifoffpage texlive-datetime texlive-lastpage flex bison npm atom

systemctl enable sshd

# Setup atom-editor with current settings
# apm list --installed --bare > atom-package.list
# cp ~/.atom/config.cson ~/Git_Projects/Linux-Configuration-Files/atom-config.cson
# apm install --packages-file atom-package.list
# cp ~/Git_Projects/Linux-Configuration-Files/atom-config.cson ~/.atom/config.cson
