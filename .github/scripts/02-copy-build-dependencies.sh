#!/usr/bin/env bash

OS=${1}
GITHUB_WORKSPACE=${2}
GITHUB_REF=${3}
FORCEBUILDDEPS="1"

if [[ ! ${OS} || ! ${GITHUB_WORKSPACE} ]]; then
    echo "Error: Invalid options"
    echo "Usage: ${0} <operating system> <github workspace path>"
    exit 1
fi
echo "----------------------------------------"
echo "OS: ${OS}"
echo "----------------------------------------"

if [[ ${OS} == "arm32v7-disable-wallet" || ${OS} == "linux-disable-wallet" || ${OS} == "aarch64-disable-wallet" ]]; then
    OS=`echo ${OS} | cut -d"-" -f1`
fi

if [[ ${GITHUB_REF} =~ "release" || ${FORCEBUILDDEPS} = "1" ]]; then
    echo "----------------------------------------"
    echo "Building Dependencies for ${OS}"
    echo "----------------------------------------"

    cd depends
    if [[ ${OS} == "windows" ]]; then
        make HOST=x86_64-w64-mingw32 -j2
    elif [[ ${OS} == "osx" ]]; then
       cd ${GITHUB_WORKSPACE}
        curl -O https://bitcoincore.org/depends-sources/sdks/MacOSX10.14.sdk.tar.gz
        mkdir -p ${GITHUB_WORKSPACE}/depends/SDKs
        cd ${GITHUB_WORKSPACE}/depends/SDKs && tar -zxf ${GITHUB_WORKSPACE}/MacOSX10.14.sdk.tar.gz
        cd ${GITHUB_WORKSPACE}/depends && make HOST=x86_64-apple-darwin14 -j2
    elif [[ ${OS} == "linux" || ${OS} == "linux-disable-wallet" ]]; then
        make HOST=x86_64-linux-gnu -j2
    elif [[ ${OS} == "arm32v7" || ${OS} == "arm32v7-disable-wallet" ]]; then
        make HOST=arm-linux-gnueabihf -j2
    elif [[ ${OS} == "aarch64" || ${OS} == "aarch64-disable-wallet" ]]; then
        make HOST=aarch64-linux-gnu -j2
    fi
else
    echo "----------------------------------------"
    echo "Retrieving Dependencies for ${OS}"
    echo "----------------------------------------"

    cd /tmp
    curl -O https://meowcoin-build-resources.s3.amazonaws.com/${OS}/meowcoin-${OS}-dependencies.tar.gz
    curl -O https://meowcoin-build-resources.s3.amazonaws.com/${OS}/SHASUM
    if [[ $(sha256sum -c /tmp/SHASUM) ]]; then
        cd ${GITHUB_WORKSPACE}/depends
        tar zxvf /tmp/meowcoin-${OS}-dependencies.tar.gz
    else
        echo "SHASUM doesn't match"
        exit 1
    fi
fi
