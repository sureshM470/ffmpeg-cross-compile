# FFmpeg Cross Compilation Superbuild

This project provides a CMake-based superbuild for FFmpeg and popular codecs/libraries (x264, x265, libvpx, fdk-aac, freetype, harfbuzz, lame) for both native and Android platforms.

---

## Prerequisites

- **CMake** >= 3.15
- **Git** (for submodules or ExternalProject)
- **Python** (for libvpx build)
- **YASM** (for x86/x86_64 libvpx)
- **Android NDK** (for cross-compiling to Android)
- **Autotools** (`autoconf`, `automake`, `libtool`, `m4`) for some libraries (e.g., fdk-aac)
- **pkg-config**

---

### Installing Prerequisites (Ubuntu/Debian example)

```sh
sudo apt-get update
sudo apt-get install cmake git python3 yasm pkg-config autoconf automake libtool m4
```

For Android cross-compilation, [download the Android NDK](https://developer.android.com/ndk/downloads) and set `ANDROID_NDK_HOME` accordingly.

- On Fedora/RHEL, use `dnf` instead of `apt-get`.
- On Arch, use `pacman`.

---

## Getting the Source

Clone this repo and its submodules (if any):

```sh
git clone <repo-url>
cd FFmpegCompile
git submodule update --init --recursive
```

---

## Native Build (Linux)

*This will build FFmpeg and all libraries to run on your current Linux machine (not for Android or other platforms).*

Run these commands from the root of the repository (where `CMakeLists.txt` is located):

```sh
mkdir build-native
cd build-native
cmake ..
make -j$(nproc)
```

The resulting FFmpeg and libraries will be installed in `build-native/install`.

---

## Android Cross-Compilation

### 1. Set up your environment

- Download and extract the Android NDK (r21 or newer recommended).
- In this project, you’ll find a file named `env.sh.example`.  
  Copy it to `env.sh` and edit it to set your NDK path:
  ```sh
  cp env.sh.example env.sh
  # Edit env.sh and set ANDROID_NDK_HOME to your NDK path
  ```
- Load the environment variables in your terminal (from the project root):
  ```sh
  source env.sh
  ```

> The `env.sh.example` file is provided by this project to help you set environment variables like `ANDROID_NDK_HOME` easily.

### 2. Run the setup script

From the root of the repository, simply run:

```sh
bash setup_android_build.sh
```

This script will:
- Create a separate build directory for each Android ABI (`arm64-v8a`, `armeabi-v7a`, `x86`, `x86_64`).
- Run CMake in each directory with the correct toolchain and ABI settings.
- (You can uncomment the `cmake --build .` line in the script to automatically start building after configuration.)

**What the script does:**
- For each ABI, it creates a directory like `build-android-arm64-v8a`.
- It runs CMake with the appropriate `-DANDROID_ABI` and toolchain file.
- You can then build for a specific ABI by running `make -j$(nproc)` inside the corresponding build directory.
- **The resulting FFmpeg and libraries for each ABI will be installed in the `install` subdirectory of that build folder** (e.g., `build-android-arm64-v8a/install`).

**Example:**
```sh
cd build-android-arm64-v8a
make -j$(nproc)
# Libraries and binaries will be in build-android-arm64-v8a/install
```

---

*If you want to customize which ABIs are built, edit the `ABI` list in `setup_android_build.sh`.*

---

## Features

- One-command build for FFmpeg and major codecs
- Supports native Linux and Android (all major ABIs)
- Modular: easily enable/disable components
- Automated dependency fetching (git submodules/ExternalProject)
- Well-documented and easy to extend

---

## Enabling/Disabling Components

You can enable or disable libraries via CMake options:

```sh
cmake .. -DENABLE_LIBX264=ON -DENABLE_LIBX265=OFF ...
```

You can also edit the `setup_android_build.sh` script to add or override CMake flags for all Android builds.  
For example, you can append extra `-D` options to the `cmake ..` command inside the script to enable or disable specific components globally.

---

## FFmpeg Licensing Notes

- If you enable both `--enable-libfdk-aac` and `--enable-gpl` (e.g., for x264/x265), FFmpeg will be built with `--enable-nonfree` and **cannot be redistributed**.
- See [FFmpeg Licensing](https://ffmpeg.org/legal.html) for details.

---

## Disclaimer

This project provides build scripts and instructions only.  
**You are responsible for complying with the licenses of FFmpeg and all third-party libraries you choose to build.**  
Redistribution of binaries built with certain options (such as `--enable-nonfree`) may be prohibited.  
See the official documentation and licenses of each library for details.

---

## Troubleshooting

- If you see errors about missing `configure` scripts, run `./autogen.sh` or `autoreconf -fi` in the affected library directory.
- For x86/x86_64, ensure `yasm` is installed.
- For Android, ensure all toolchain paths and sysroots are correct.

---

## Adding New Libraries

- Add a new `<lib>.cmake` file.
- Add an option in `CMakeLists.txt`.
- Include the new file and update `FFmpeg.cmake` as needed.

---

## Credits

- [FFmpeg](https://ffmpeg.org/)
- [x264](https://www.videolan.org/developers/x264.html)
- [x265](https://bitbucket.org/multicoreware/x265_git)
- [libvpx](https://chromium.googlesource.com/webm/libvpx/)
- [fdk-aac](https://github.com/mstorsjo/fdk-aac)
- [freetype](https://freetype.org/)
- [harfbuzz](https://github.com/harfbuzz/harfbuzz)
- [lame](https://lame.sourceforge.io/)

---

## License

See individual library licenses for details.

---

## Example Usage

After building, you can use the resulting FFmpeg binary like this:

```sh
./build-native/install/bin/ffmpeg -version
./build-android-arm64-v8a/install/bin/ffmpeg -version
```

---

## Maintainer

Created and maintained by [Suresh Manepalli](https://sureshm470.github.io/) ([GitHub](https://github.com/sureshm470)).

For questions, suggestions, or contributions, please open an issue or pull request on GitHub.

---