#!/usr/bin/env bash
set -euo pipefail

mkdir -p docc_build
xcodebuild docbuild -scheme PhoenixLiveViewNative -destination generic/platform=iOS -derivedDataPath docc_build

xcrun docc process-archive transform-for-static-hosting docc_build/Build/Products/Debug-iphoneos/PhoenixLiveViewNative.doccarchive --output-path docc_out --hosting-base-path liveview-client-swiftui
