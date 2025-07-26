include(ExternalProject)

set(FREETYPE_SOURCE_DIR ${CMAKE_SOURCE_DIR}/freetype)
set(FREETYPE_BUILD_DIR ${CMAKE_BINARY_DIR}/freetype-build)
set(FREETYPE_INSTALL_DIR ${CMAKE_BINARY_DIR}/install)

if(ANDROID)
    set(FREETYPE_CONFIGURE_ENV
        CC=${ANDROID_TOOLCHAIN_ROOT}/bin/${ANDROID_TRIPLE}${ANDROID_NATIVE_API_LEVEL}-clang
        CXX=${ANDROID_TOOLCHAIN_ROOT}/bin/${ANDROID_TRIPLE}${ANDROID_NATIVE_API_LEVEL}-clang++
        AR=${CMAKE_AR}
        RANLIB=${CMAKE_RANLIB}
        STRIP=${CMAKE_STRIP}
        CFLAGS=--sysroot=${CMAKE_SYSROOT}
    )
    set(FREETYPE_CONFIGURE_COMMAND
        ${FREETYPE_SOURCE_DIR}/configure
        --host=${ANDROID_TRIPLE}
        --with-sysroot=${CMAKE_SYSROOT}
        --prefix=${FREETYPE_INSTALL_DIR}
        --enable-static
        --disable-shared
        --with-zlib
        --without-brotli
        --without-png
    )
else()
    set(FREETYPE_CONFIGURE_ENV "")
    set(FREETYPE_CONFIGURE_COMMAND
        ${FREETYPE_SOURCE_DIR}/configure
        --prefix=${FREETYPE_INSTALL_DIR}
        --enable-static
        --disable-shared
    )
endif()

ExternalProject_Add(
    freetype
    SOURCE_DIR ${FREETYPE_SOURCE_DIR}
    BINARY_DIR ${FREETYPE_BUILD_DIR}
    INSTALL_DIR ${FREETYPE_INSTALL_DIR}
    UPDATE_COMMAND bash -c "cd ${FREETYPE_SOURCE_DIR} && ./autogen.sh"
    CONFIGURE_COMMAND ${CMAKE_COMMAND} -E env ${FREETYPE_CONFIGURE_ENV} ${FREETYPE_CONFIGURE_COMMAND}
    BUILD_COMMAND make -j
    INSTALL_COMMAND make install
    LOG_CONFIGURE 1
    LOG_BUILD 1
    LOG_INSTALL 1
)