include(ExternalProject)

set(LAME_VERSION 3.100)
set(LAME_TARBALL lame-${LAME_VERSION}.tar.gz)
set(LAME_URL https://downloads.sourceforge.net/project/lame/lame/${LAME_VERSION}/${LAME_TARBALL})
set(LAME_SOURCE_DIR ${CMAKE_SOURCE_DIR}/lame)
set(LAME_BUILD_DIR ${CMAKE_BINARY_DIR}/lame-build)
set(LAME_INSTALL_DIR ${CMAKE_BINARY_DIR}/install)

if(ANDROID)
    set(LAME_CONFIGURE_ENV
        CC=${ANDROID_TOOLCHAIN_ROOT}/bin/${ANDROID_TRIPLE}${ANDROID_NATIVE_API_LEVEL}-clang
        CXX=${ANDROID_TOOLCHAIN_ROOT}/bin/${ANDROID_TRIPLE}${ANDROID_NATIVE_API_LEVEL}-clang++
        AR=${CMAKE_AR}
        RANLIB=${CMAKE_RANLIB}
        STRIP=${CMAKE_STRIP}
        CFLAGS=--sysroot=${CMAKE_SYSROOT}
    )
    set(LAME_CONFIGURE_COMMAND
        ${LAME_SOURCE_DIR}/configure
        --host=${ANDROID_TRIPLE}
        --with-sysroot=${CMAKE_SYSROOT}
        --prefix=${LAME_INSTALL_DIR}
        --enable-static
        --disable-shared
    )
else()
    set(LAME_CONFIGURE_ENV "")
    set(LAME_CONFIGURE_COMMAND
        ${LAME_SOURCE_DIR}/configure
        --prefix=${LAME_INSTALL_DIR}
        --enable-static
        --disable-shared
    )
endif()

set(LAME_INSTALL_COMMAND
    make install
    COMMAND ${CMAKE_COMMAND} -E make_directory ${LAME_INSTALL_DIR}/lib/pkgconfig
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_SOURCE_DIR}/libmp3lame.pc ${LAME_INSTALL_DIR}/lib/pkgconfig/libmp3lame.pc
)

ExternalProject_Add(
    lame
    URL ${LAME_URL}
    DOWNLOAD_DIR ${CMAKE_SOURCE_DIR}
    SOURCE_DIR ${LAME_SOURCE_DIR}
    BINARY_DIR ${LAME_BUILD_DIR}
    INSTALL_DIR ${LAME_INSTALL_DIR}
    CONFIGURE_COMMAND ${CMAKE_COMMAND} -E env ${LAME_CONFIGURE_ENV} ${LAME_CONFIGURE_COMMAND}
    BUILD_COMMAND make -j
    INSTALL_COMMAND ${LAME_INSTALL_COMMAND}
    LOG_CONFIGURE 1
    LOG_BUILD 1
    LOG_INSTALL 1
    DOWNLOAD_EXTRACT_TIMESTAMP true
)