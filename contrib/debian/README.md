
Debian
====================
This directory contains files used to package meowd/meow-qt
for Debian-based Linux systems. If you compile meowd/meow-qt yourself, there are some useful files here.

## meow: URI support ##


meow-qt.desktop  (Gnome / Open Desktop)
To install:

	sudo desktop-file-install meow-qt.desktop
	sudo update-desktop-database

If you build yourself, you will either need to modify the paths in
the .desktop file or copy or symlink your meow-qt binary to `/usr/bin`
and the `../../share/pixmaps/meow128.png` to `/usr/share/pixmaps`

meow-qt.protocol (KDE)

