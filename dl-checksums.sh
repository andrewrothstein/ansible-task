#!/usr/bin/env sh
set -e
DIR=~/Downloads
MIRROR=https://github.com/go-task/task/releases/download

dl() {
    local app=$1
    local ver=$2
    local lchecksums=$3
    local os=$4
    local arch=$5
    local archive_type=${6:-tar.gz}
    local platform="${os}_${arch}"
    # https://github.com/go-task/task/releases/download/v3.18.0/task_darwin_amd64.tar.gz
    local file="${app}_${platform}.${archive_type}"
    local url="$MIRROR/v$ver/$file"
    printf "    # %s\n" $url
    printf "    %s: sha256:%s\n" $platform $(grep $file $lchecksums | awk '{print $1}')
}

dl_ver() {
    local app=$1
    local ver=$2
    # https://github.com/go-task/task/releases/download/v3.18.0/task_checksums.txt
    local url="$MIRROR/v$ver/task_checksums.txt"
    local lchecksums="$DIR/${app}_${ver}_checksums.txt"
    if [ ! -e $lchecksums ];
    then
        curl -sSLf -o $lchecksums $url
    fi

    printf "  # %s\n" $url
    printf "  '%s':\n" $ver

    dl $app $ver $lchecksums darwin amd64
    dl $app $ver $lchecksums darwin arm64
    dl $app $ver $lchecksums linux 386
    dl $app $ver $lchecksums linux amd64
    dl $app $ver $lchecksums linux arm64
}

dl_ver task ${1:-3.26.0}
