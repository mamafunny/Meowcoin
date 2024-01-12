
Debian
====================
This directory contains files used to package meowcoind/meowcoin-qt
for Debian-based Linux systems. If you compile meowcoind/meowcoin-qt yourself, there are some useful files here.

## meowcoin: URI support ##


meowcoin-qt.desktop  (Gnome / Open Desktop)
To install:

	sudo desktop-file-install meowcoin-qt.desktop
	sudo update-desktop-database

If you build yourself, you will either need to modify the paths in
the .desktop file or copy or symlink your meowcoin-qt binary to `/usr/bin`
and the `../../share/pixmaps/meow128.png` to `/usr/share/pixmaps`

meowcoin-qt.protocol (KDE)

