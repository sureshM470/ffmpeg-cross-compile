include(ExternalProject)

set(FDKAAC_SOURCE_DIR ${CMAKE_SOURCE_DIR}/fdk-aac)
set(FDKAAC_BUILD_DIR ${CMAKE_BINARY_DIR}/fdk-aac-build)
set(FDKAAC_INSTALL_DIR ${CMAKE_BINARY_DIR}/install)

if(ANDROID)
    set(FDKAAC_CONFIGURE_ENV
        CC=${ANDROID_TOOLCHAIN_ROOT}/bin/${ANDROID_TRIPLE}${ANDROID_NATIVE_API_LEVEL}-clang
        CXX=${ANDROID_TOOLCHAIN_ROOT}/bin/${ANDROID_TRIPLE}${ANDROID_NATIVE_API_LEVEL}-clang++
        AR=${CMAKE_AR}
        RANLIB=${CMAKE_RANLIB}
        STRIP=${CMAKE_STRIP}
        CFLAGS=--sysroot=${CMAKE_SYSROOT}
        CXXFLAGS=--sysroot=${CMAKE_SYSROOT}
        LDFLAGS=--sysroot=${CMAKE_SYSROOT}
    )
    set(FDKAAC_CONFIGURE_COMMAND
        ${FDKAAC_SOURCE_DIR}/configure
        --host=${ANDROID_TRIPLE}
        --prefix=${FDKAAC_INSTALL_DIR}
        --enable-static
        --disable-shared
        --with-pic
    )
else()
    set(FDKAAC_CONFIGURE_ENV "")
    set(FDKAAC_CONFIGURE_COMMAND
        ${FDKAAC_SOURCE_DIR}/configure
        --prefix=${FDKAAC_INSTALL_DIR}
        --enable-static
        --disable-shared
        --with-pic
    )
endif()

ExternalProject_Add(
    fdk-aac
    SOURCE_DIR ${FDKAAC_SOURCE_DIR}
    BINARY_DIR ${FDKAAC_BUILD_DIR}
    INSTALL_DIR ${FDKAAC_INSTALL_DIR}
    UPDATE_COMMAND cd ${FDKAAC_SOURCE_DIR} && ./autogen.sh
    CONFIGURE_COMMAND ${CMAKE_COMMAND} -E env ${FDKAAC_CONFIGURE_ENV} ${FDKAAC_CONFIGURE_COMMAND}
    BUILD_COMMAND make -j
    INSTALL_COMMAND make install
    LOG_CONFIGURE 1
    LOG_BUILD 1
    LOG_INSTALL 1
)