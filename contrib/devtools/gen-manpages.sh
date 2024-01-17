#!/bin/sh

TOPDIR=${TOPDIR:-$(git rev-parse --show-toplevel)}
SRCDIR=${SRCDIR:-$TOPDIR/src}
MANDIR=${MANDIR:-$TOPDIR/doc/man}

MEOWCOIND=${MEOWCOIND:-$SRCDIR/meowcoind}
MEOWCOINCLI=${MEOWCOINCLI:-$SRCDIR/meowcoin-cli}
MEOWCOINTX=${MEOWCOINTX:-$SRCDIR/meowcoin-tx}
MEOWCOINQT=${MEOWCOINQT:-$SRCDIR/qt/meowcoin-qt}

[ ! -x $MEOWCOIND ] && echo "$MEOWCOIND not found or not executable." && exit 1

# The autodetected version git tag can screw up manpage output a little bit
MEWCVER=($($MEOWCOINCLI --version | head -n1 | awk -F'[ -]' '{ print $6, $7 }'))

# Create a footer file with copyright content.
# This gets autodetected fine for meowcoind if --version-string is not set,
# but has different outcomes for meowcoin-qt and meowcoin-cli.
echo "[COPYRIGHT]" > footer.h2m
$MEOWCOIND --version | sed -n '1!p' >> footer.h2m

for cmd in $MEOWCOIND $MEOWCOINCLI $MEOWCOINTX $MEOWCOINQT; do
  cmdname="${cmd##*/}"
  help2man -N --version-string=${MEWCVER[0]} --include=footer.h2m -o ${MANDIR}/${cmdname}.1 ${cmd}
  sed -i "s/\\\-${MEWCVER[1]}//g" ${MANDIR}/${cmdname}.1
done

rm -f footer.h2m
