include(ExternalProject)

set(FFMPEG_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/ffmpeg)
set(FFMPEG_BUILD_DIR ${CMAKE_CURRENT_BINARY_DIR}/ffmpeg-build)
set(FFMPEG_INSTALL_DIR ${CMAKE_CURRENT_BINARY_DIR}/install)

set(FFMPEG_COMMON_FLAGS
    --enable-static
    --disable-shared
    # --disable-programs
    --disable-doc
    --enable-avformat
    --enable-avcodec
    --enable-avutil
    --enable-avfilter
    --enable-swscale
    --enable-swresample
)

# Collect configure flags and dependencies based on options
set(FFMPEG_CONFIGURE_FLAGS
    --prefix=${FFMPEG_INSTALL_DIR}
    --extra-cflags="-I${FFMPEG_INSTALL_DIR}/include"
    "--extra-ldflags=-L${FFMPEG_INSTALL_DIR}/lib ${EXTRA_LDFLAGS}"
    ${FFMPEG_COMMON_FLAGS}
)

set(FFMPEG_DEPENDS)

if(ENABLE_LIBX264)
    list(APPEND FFMPEG_CONFIGURE_FLAGS --enable-libx264)
    list(APPEND FFMPEG_DEPENDS x264)
endif()

if(ENABLE_LIBX265)
    list(APPEND FFMPEG_CONFIGURE_FLAGS --enable-libx265)
    list(APPEND FFMPEG_DEPENDS x265)
endif()

if(ENABLE_LIBX264 OR ENABLE_LIBX265)
    list(APPEND FFMPEG_CONFIGURE_FLAGS --enable-gpl)
endif()

if(ENABLE_LIBMP3LAME)
    list(APPEND FFMPEG_CONFIGURE_FLAGS --enable-libmp3lame)
    list(APPEND FFMPEG_DEPENDS lame)
endif()

if(ENABLE_LIBFREETYPE)
    list(APPEND FFMPEG_CONFIGURE_FLAGS --enable-libfreetype)
    list(APPEND FFMPEG_DEPENDS freetype)
endif()

if(ENABLE_LIBHARFBUZZ)
    list(APPEND FFMPEG_CONFIGURE_FLAGS --enable-libharfbuzz)
    list(APPEND FFMPEG_DEPENDS harfbuzz)
endif()

if(ENABLE_LIBVPX)
    list(APPEND FFMPEG_CONFIGURE_FLAGS --enable-libvpx)
    list(APPEND FFMPEG_DEPENDS vpx)
endif()

if(ENABLE_LIBFDKAAC)
    list(APPEND FFMPEG_CONFIGURE_FLAGS --enable-libfdk-aac)
    list(APPEND FFMPEG_DEPENDS fdk-aac)
endif()

if(ENABLE_LIBFDKAAC AND FFMPEG_CONFIGURE_FLAGS MATCHES "--enable-gpl")
    list(APPEND FFMPEG_CONFIGURE_FLAGS --enable-nonfree)
endif()

if(ANDROID)
    if(ANDROID_ARCH STREQUAL "x86")
        list(APPEND FFMPEG_CONFIGURE_FLAGS --disable-asm)
    endif()
    list(APPEND FFMPEG_CONFIGURE_FLAGS 
        --enable-cross-compile
        --target-os=android
        --arch=${ANDROID_ARCH}
        --cross-prefix=${ANDROID_TOOLCHAIN_ROOT}/bin/${ANDROID_TRIPLE}${ANDROID_NATIVE_API_LEVEL}-
        --sysroot=${CMAKE_SYSROOT}
        --ar=${CMAKE_AR}
        --nm=${CMAKE_NM}
        --strip=${CMAKE_STRIP}
        --ranlib=${CMAKE_RANLIB}
        --pkg-config=pkg-config
    )
    set(PKG_CFG ${FFMPEG_INSTALL_DIR}/lib/pkgconfig:${FFMPEG_INSTALL_DIR}/lib/x86_64-linux-gnu/pkgconfig:${CMAKE_BINARY_DIR}/install/lib/pkgconfig)
    set(FFMPEG_CONFIGURE_ENV
        PKG_CONFIG_PATH=${PKG_CFG}
        CC=${ANDROID_TOOLCHAIN_ROOT}/bin/${ANDROID_TRIPLE}${ANDROID_NATIVE_API_LEVEL}-clang
        CXX=${ANDROID_TOOLCHAIN_ROOT}/bin/${ANDROID_TRIPLE}${ANDROID_NATIVE_API_LEVEL}-clang++
        AR=${CMAKE_AR}
        NM=${CMAKE_NM}
        LD=${CMAKE_LINKER}
        AS=${CMAKE_ASM_COMPILER}
        STRIP=${CMAKE_STRIP}
    )
else()
    set(FFMPEG_CONFIGURE_ENV 
        PKG_CONFIG_PATH=${FFMPEG_INSTALL_DIR}/lib/pkgconfig:${FFMPEG_INSTALL_DIR}/lib/x86_64-linux-gnu/pkgconfig:${CMAKE_BINARY_DIR}/install/lib/pkgconfig
    )
endif()

set(FFMPEG_CONFIGURE_COMMAND ${CMAKE_COMMAND} -E env ${FFMPEG_CONFIGURE_ENV} ${FFMPEG_SOURCE_DIR}/configure ${FFMPEG_CONFIGURE_FLAGS})

ExternalProject_Add(
    ffmpeg
    SOURCE_DIR ${FFMPEG_SOURCE_DIR}
    BINARY_DIR ${FFMPEG_BUILD_DIR}
    INSTALL_DIR ${FFMPEG_INSTALL_DIR}
    CONFIGURE_COMMAND ${FFMPEG_CONFIGURE_COMMAND}
    BUILD_COMMAND make -j
    INSTALL_COMMAND make install
    DEPENDS ${FFMPEG_DEPENDS}
    # LOG_CONFIGURE 1
    # LOG_BUILD 1
    # LOG_INSTALL 1
)