#!/usr/bin/env bash
set -euo pipefail

# build doccarchive
mkdir -p docc_build
xcodebuild docbuild -scheme PhoenixLiveViewNative -destination generic/platform=iOS -derivedDataPath docc_build

# create worktree
if [ ! -d docs ]; then
	git worktree add docs docs
fi

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


# xcodebuild docbuild does not respect DOCC_JSON_PRETTYPRINT for some reason
# so we re-format everything into a stable order as to not produce massive git diffs
# for every change
echo "Sorting JSON..."

pushd util/sort_json
cargo build --release
popd
./util/sort_json/target/release/sort_json docs


echo -e "\x1B[1mDocs updated, commit the result in the docs/ directory.\x1B[0m"
