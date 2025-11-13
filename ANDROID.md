```sh
export JAVA_HOME="/Applications/Android Studio.app/Contents/jbr/Contents/Home"
swiftly run +main-snapshot-2025-10-16 swift package resolve
rm -rf .build/checkouts/swift-java/Samples
./.build/checkouts/swift-java/gradlew --project-dir .build/checkouts/swift-java :SwiftKitCore:publishToMavenLocal
```

You need a `libc_v8.so` and `liblightpanda.so` in `jniLibs/arm64-v8a`.

If the Kotlin package is not updating to changes in the Swift code, delete the `.so`:

```
rm .build/aarch64-unknown-linux-android28/debug/libLightpandaClient.so
```