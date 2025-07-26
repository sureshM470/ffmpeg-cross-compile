cmake_minimum_required(VERSION 3.15)
project(FFmpegSuperbuild C CXX)

option(ENABLE_LIBX264 "Enable libx264 support" ON)
option(ENABLE_LIBX265 "Enable libx265 support" ON)
option(ENABLE_LIBMP3LAME "Enable libmp3lame support" ON)
option(ENABLE_LIBFREETYPE "Enable libfreetype support" ON)
option(ENABLE_LIBHARFBUZZ "Enable libharfbuzz support" ${ENABLE_LIBFREETYPE})
option(ENABLE_LIBVPX "Enable libvpx support" ON)
option(ENABLE_LIBFDKAAC "Enable fdk-aac support" ON)

set(EXTRA_LDFLAGS "" CACHE STRING "Extra linker flags for all external projects")

if(ANDROID)
    message("Configuring for Android platform: " ${CMAKE_ANDROID_ARCH_ABI})
    message("API Level: " ${ANDROID_NATIVE_API_LEVEL})
    message("NDK: " ${CMAKE_ANDROID_NDK})
    message("toolchain: " ${ANDROID_TOOLCHAIN_ROOT})
    message("Sysroot: " ${CMAKE_SYSROOT})
    message("CMake CC: " ${CMAKE_C_COMPILER})
    message("CMake CXX: " ${CMAKE_CXX_COMPILER})
    message("CMake AR: " ${CMAKE_AR})
    message("CMake NM: " ${CMAKE_NM})
    message("CMake Linker: " ${CMAKE_LINKER})
    message("CMake ASM Compiler: " ${CMAKE_ASM_COMPILER})
    message("CMake Strip: " ${CMAKE_STRIP})

    if(ANDROID_ABI STREQUAL "arm64-v8a")
        set(ANDROID_ARCH aarch64)
        set(ANDROID_TRIPLE aarch64-linux-android)
    elseif(ANDROID_ABI STREQUAL "armeabi-v7a")
        set(ANDROID_ARCH arm)
        set(ANDROID_TRIPLE armv7a-linux-androideabi)
    elseif(ANDROID_ABI STREQUAL "x86")
        set(ANDROID_ARCH x86)
        set(ANDROID_TRIPLE i686-linux-android)
    elseif(ANDROID_ABI STREQUAL "x86_64")
        set(ANDROID_ARCH x86_64)
        set(ANDROID_TRIPLE x86_64-linux-android)
    else()
        message(FATAL_ERROR "Unsupported Android ABI: ${CMAKE_ANDROID_ARCH_ABI}")
    endif()

    # for meson cross file , made for harfbuzz and others if needed
    # Set these variables according to your build environment and ABI
    set(ANDROID_CPU_FAMILY "aarch64")
    set(ANDROID_CPU "aarch64")
    set(ANDROID_SYSROOT "${CMAKE_SYSROOT}")
    set(ANDROID_CC "${ANDROID_TOOLCHAIN_ROOT}/bin/${ANDROID_TRIPLE}${ANDROID_NATIVE_API_LEVEL}-clang")
    set(ANDROID_CXX "${ANDROID_TOOLCHAIN_ROOT}/bin/${ANDROID_TRIPLE}${ANDROID_NATIVE_API_LEVEL}-clang++")
    set(ANDROID_AR "${ANDROID_TOOLCHAIN_ROOT}/bin/llvm-ar")
    set(ANDROID_STRIP "${ANDROID_TOOLCHAIN_ROOT}/bin/llvm-strip")

    # Generate the cross file
    configure_file(
        ${CMAKE_SOURCE_DIR}/android-cross.txt.in
        ${CMAKE_BINARY_DIR}/android-cross.txt
        @ONLY
    )
else ()
    message("Configuring for native platform")
endif()


if(ENABLE_LIBFREETYPE)
    include(freetype.cmake)
endif()

if(ENABLE_LIBHARFBUZZ)
    include(harfbuzz.cmake)
endif()

if(ENABLE_LIBMP3LAME)
    include(lame.cmake)
endif()

if(ENABLE_LIBX264)
    include(x264.cmake)
endif()

if(ENABLE_LIBX265)
    include(x265.cmake)
endif()

if(ENABLE_LIBVPX)
    include(vpx.cmake)
endif()

if(ENABLE_LIBFDKAAC)
    include(fdk-aac.cmake)
endif()

include(FFmpeg.cmake)