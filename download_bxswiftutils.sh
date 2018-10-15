#/usr/bin/env bash
set -x
set -e

function download_for_platform
{
  platform=$1
  pushd "Frameworks/$platform"
  curl -OL "https://github.com/boinx/BXSwiftUtils/releases/download/$_tag/BXSwiftUtils-$platform.framework.zip"
  unzip -o *.zip
  popd
}

# Find out the latest tag that was released on Github, because the tag needs to be inserted into the download URls.
_tag=$(curl -s https://api.github.com/repos/boinx/BXSwiftUtils/releases/latest | jq -r '.tag_name')

# Download frameworks for both macOS and iOS.
download_for_platform "macOS"
download_for_platform "iOS"

