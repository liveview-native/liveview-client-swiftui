#!/usr/bin/env bash

git clone git@github.com:liveview-native/liveview-client-swiftui.git --branch swift-docc-render --single-branch swift-docc-render
mkdir -p docc_build

. $(brew --prefix nvm)/nvm.sh

git clone git@github.com:apple/swift-docc-render.git docc_build/swift-docc-render
(cd docc_build/swift-docc-render && nvm install && npm install && VUE_APP_HLJS_LANGUAGES=elixir npm run build)

mv docc_build/swift-docc-render/dist/* swift-docc-render
COMMIT=$(cd docc_build/swift-docc-render && git rev-parse HEAD)
(cd swift-docc-render && git add . && git commit -m "Build https://github.com/apple/swift-docc-render/commit/${COMMIT}")