#!/bin/bash
set -e

if [ -z "$ANDROID_NDK_HOME" ]; then
  echo "Please set ANDROID_NDK_HOME in your environment."
  exit 1
fi

for ABI in arm64-v8a armeabi-v7a x86 x86_64; do
  BUILD_DIR=build-android-$ABI
  mkdir -p $BUILD_DIR
  cd $BUILD_DIR
  cmake .. \
    -DANDROID_ABI=$ABI \
    -DANDROID_PLATFORM=android-21 \
    -DCMAKE_TOOLCHAIN_FILE="$ANDROID_NDK_HOME/build/cmake/android.toolchain.cmake"
  # cmake --build .
  cd ..
done