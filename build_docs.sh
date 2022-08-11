#!/usr/bin/env bash
set -euo pipefail

# build doccarchive
mkdir -p docc_build
xcodebuild docbuild -scheme PhoenixLiveViewNative -destination generic/platform=iOS -derivedDataPath docc_build

# create worktree
if [ ! -d docs ]; then
	git worktree add docs docs
fi

# remove any stale files
rm -rf docs/*

xcrun docc process-archive transform-for-static-hosting docc_build/Build/Products/Debug-iphoneos/PhoenixLiveViewNative.doccarchive --output-path docs --hosting-base-path /liveview-client-swiftui

# add index page to root with redirect to package docs
cat > docs/index.html << EOF
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="refresh" content="0; url=/liveview-client-swiftui/documentation/phoenixliveviewnative">
</head>
<body>
</body>
</html>
EOF

echo -e "\x1B[1mDocs updated, commit the result in the docs/ directory.\x1B[0m"
