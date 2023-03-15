#!/usr/bin/env bash
set -euo pipefail

if [ ! -f "Package.swift" ]; then
	echo -e "\x1B[1;31mThis script must be run from the repository root (contains Package.swift).\x1B[0m"
	exit 1
fi

verbose=0

while getopts "v" opt; do
	case "$opt" in
		v)
			verbose=1
			;;
	esac
done

[[ "$verbose" == "1" ]] && output="/dev/tty" || output="/dev/null"

# build doccarchive
echo "Building docs..."
mkdir -p docc_build
# build the docs once to get the symbol graph.
xcodebuild docbuild -scheme LiveViewNative -destination generic/platform=iOS -derivedDataPath docc_build -toolchain swift &> $output
# generate the documentation extensions.
xcrun -toolchain swift swift package plugin --allow-writing-to-package-directory generate-documentation-extensions &> $output || :
# build the docs again with the extensions.
xcodebuild docbuild -scheme LiveViewNative -destination generic/platform=iOS -derivedDataPath docc_build -toolchain swift &> $output

# create worktree
if [ ! -d docs ]; then
	git worktree add docs docs
fi

echo "Generating static files..."
xcrun docc process-archive transform-for-static-hosting docc_build/Build/Products/Debug-iphoneos/LiveViewNative.doccarchive --output-path docs #--hosting-base-path /liveview-client-swiftui &> $output

# add index page to root with redirect to package docs
cat > docs/index.html << EOF
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="refresh" content="0; url=/liveview-client-swiftui/documentation/liveviewnative">
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
cargo build --release &> $output
./target/release/sort_json ../../docs
popd

echo "Generating tutorial repo..."

pushd util/generate_tutorial_repo
cargo build &> $output
[[ "$verbose" == "1" ]] && flags="-v" || flags=""
./target/debug/generate_tutorial_repo --repo ../../tutorial --package ../.. $flags
popd

echo -e "\x1B[1mDocs updated, commit the result in the docs/ directory.\x1B[0m"
echo -e "\x1B[1mTutorial repo updated, force-push the result in the tutorial/ directory.\x1B[0m"
