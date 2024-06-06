 #!/usr/bin/env bash

 # Execute this file to install the meowcoin cli tools into your path on OS X

 CURRENT_LOC="$( cd "$(dirname "$0")" ; pwd -P )"
 LOCATION=${CURRENT_LOC%Meowcoin-Qt.app*}

 # Ensure that the directory to symlink to exists
 sudo mkdir -p /usr/local/bin

 # Create symlinks to the cli tools
 sudo ln -s ${LOCATION}/Meowcoin-Qt.app/Contents/MacOS/meowcoind /usr/local/bin/meowcoind
 sudo ln -s ${LOCATION}/Meowcoin-Qt.app/Contents/MacOS/meowcoin-cli /usr/local/bin/meowcoin-cli
