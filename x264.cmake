include(ExternalProject)

set(X264_SOURCE_DIR ${CMAKE_SOURCE_DIR}/x264)
set(X264_BUILD_DIR ${CMAKE_BINARY_DIR}/x264-build)
set(X264_INSTALL_DIR ${CMAKE_BINARY_DIR}/install)

if(ANDROID)
    if(ANDROID_ABI STREQUAL "x86")
        set(X264_EXTRA_FLAGS --disable-asm)
    else()
        set(X264_EXTRA_FLAGS "")
    endif()

    set(X264_CONFIGURE_ENV
        CC=${ANDROID_TOOLCHAIN_ROOT}/bin/${ANDROID_TRIPLE}${ANDROID_NATIVE_API_LEVEL}-clang
        CXX=${ANDROID_TOOLCHAIN_ROOT}/bin/${ANDROID_TRIPLE}${ANDROID_NATIVE_API_LEVEL}-clang++
        AR=${CMAKE_AR}
        RANLIB=${CMAKE_RANLIB}
        STRIP=${CMAKE_STRIP}
        CFLAGS=--sysroot=${CMAKE_SYSROOT}
    )
    set(X264_CONFIGURE_COMMAND
        ${X264_SOURCE_DIR}/configure
        --host=${ANDROID_TRIPLE}
        --with-sysroot=${CMAKE_SYSROOT}
        --prefix=${X264_INSTALL_DIR}
        --enable-pic
        --enable-static
        --disable-shared
        ${X264_EXTRA_FLAGS}
    )
else()
    set(X264_CONFIGURE_ENV "")
    set(X264_CONFIGURE_COMMAND 
        ${X264_SOURCE_DIR}/configure 
        --prefix=${X264_INSTALL_DIR} 
        --enable-static 
        --disable-cli)
endif()

ExternalProject_Add(
    x264
    SOURCE_DIR ${X264_SOURCE_DIR}
    BINARY_DIR ${X264_BUILD_DIR}
    INSTALL_DIR ${X264_INSTALL_DIR}
    CONFIGURE_COMMAND ${CMAKE_COMMAND} -E env ${X264_CONFIGURE_ENV}  ${X264_CONFIGURE_COMMAND}
    BUILD_COMMAND make -j
    INSTALL_COMMAND make install
    LOG_CONFIGURE 1
    LOG_BUILD 1
    LOG_INSTALL 1
)