VERSION=1.0.2.0
rm -rf ./release-linux
mkdir release-linux

cp ./src/meowcoind ./release-linux/
cp ./src/meowcoin-cli ./release-linux/
cp ./src/qt/meowcoin-qt ./release-linux/
cp ./MEOWCOINCOIN_small.png ./release-linux/

cd ./release-linux/
strip meowcoind
strip meowcoin-cli
strip meowcoin-qt

#==========================================================
# prepare for packaging deb file.

mkdir meowcoincoin-$VERSION
cd meowcoincoin-$VERSION
mkdir -p DEBIAN
echo 'Package: meowcoincoin
Version: '$VERSION'
Section: base 
Priority: optional 
Architecture: all 
Depends:
Maintainer: Meowcoin
Description: Meowcoin coin wallet and service.
' > ./DEBIAN/control
mkdir -p ./usr/local/bin/
cp ../meowcoind ./usr/local/bin/
cp ../meowcoin-cli ./usr/local/bin/
cp ../meowcoin-qt ./usr/local/bin/

# prepare for desktop shortcut
mkdir -p ./usr/share/icons/
cp ../MEOWCOINCOIN_small.png ./usr/share/icons/
mkdir -p ./usr/share/applications/
echo '
#!/usr/bin/env xdg-open

[Desktop Entry]
Version=1.0
Type=Application
Terminal=false
Exec=/usr/local/bin/meowcoin-qt
Name=meowcoincoin
Comment= meowcoin coin wallet
Icon=/usr/share/icons/MEOWCOINCOIN_small.png
' > ./usr/share/applications/meowcoincoin.desktop

cd ../
# build deb file.
dpkg-deb --build meowcoincoin-$VERSION

#==========================================================
# build rpm package
rm -rf ~/rpmbuild/
mkdir -p ~/rpmbuild/{RPMS,SRPMS,BUILD,SOURCES,SPECS,tmp}

cat <<EOF >~/.rpmmacros
%_topdir   %(echo $HOME)/rpmbuild
%_tmppath  %{_topdir}/tmp
EOF

#prepare for build rpm package.
rm -rf meowcoincoin-$VERSION
mkdir meowcoincoin-$VERSION
cd meowcoincoin-$VERSION

mkdir -p ./usr/bin/
cp ../meowcoind ./usr/bin/
cp ../meowcoin-cli ./usr/bin/
cp ../meowcoin-qt ./usr/bin/

# prepare for desktop shortcut
mkdir -p ./usr/share/icons/
cp ../MEOWCOINCOIN_small.png ./usr/share/icons/
mkdir -p ./usr/share/applications/
echo '
[Desktop Entry]
Version=1.0
Type=Application
Terminal=false
Exec=/usr/bin/meowcoin-qt
Name=meowcoincoin
Comment= meowcoin coin wallet
Icon=/usr/share/icons/MEOWCOINCOIN_small.png
' > ./usr/share/applications/meowcoincoin.desktop
cd ../

# make tar ball to source folder.
tar -zcvf meowcoincoin-$VERSION.tar.gz ./meowcoincoin-$VERSION
cp meowcoincoin-$VERSION.tar.gz ~/rpmbuild/SOURCES/

# build rpm package.
cd ~/rpmbuild

cat <<EOF > SPECS/meowcoincoin.spec
# Don't try fancy stuff like debuginfo, which is useless on binary-only
# packages. Don't strip binary too
# Be sure buildpolicy set to do nothing

Summary: Meowcoin wallet rpm package
Name: meowcoincoin
Version: $VERSION
Release: 1
License: MIT
SOURCE0 : %{name}-%{version}.tar.gz
URL: https://www.meowcoincoin.net/

BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root

%description
%{summary}

%prep
%setup -q

%build
# Empty section.

%install
rm -rf %{buildroot}
mkdir -p  %{buildroot}

# in builddir
cp -a * %{buildroot}


%clean
rm -rf %{buildroot}


%files
/usr/share/applications/meowcoincoin.desktop
/usr/share/icons/MEOWCOINCOIN_small.png
%defattr(-,root,root,-)
%{_bindir}/*

%changelog
* Tue Aug 24 2021  Meowcoin Project Team.
- First Build

EOF

rpmbuild -ba SPECS/meowcoincoin.spec



