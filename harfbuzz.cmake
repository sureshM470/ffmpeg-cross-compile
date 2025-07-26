include(ExternalProject)

set(HARFBUZZ_SOURCE_DIR ${CMAKE_SOURCE_DIR}/harfbuzz)
set(HARFBUZZ_BUILD_DIR ${CMAKE_BINARY_DIR}/harfbuzz-build)
set(HARFBUZZ_INSTALL_DIR ${CMAKE_BINARY_DIR}/install)

if(ANDROID)
    set(HARFBUZZ_CONFIGURE_ENV
        CC=${ANDROID_TOOLCHAIN_ROOT}/bin/${ANDROID_TRIPLE}${ANDROID_NATIVE_API_LEVEL}-clang
        CXX=${ANDROID_TOOLCHAIN_ROOT}/bin/${ANDROID_TRIPLE}${ANDROID_NATIVE_API_LEVEL}-clang++
        AR=${CMAKE_AR}
        RANLIB=${CMAKE_RANLIB}
        STRIP=${CMAKE_STRIP}
        CFLAGS=--sysroot=${CMAKE_SYSROOT}
        CXXFLAGS=--sysroot=${CMAKE_SYSROOT}
        LDFLAGS=--sysroot=${CMAKE_SYSROOT}
        PKG_CONFIG_PATH=${HARFBUZZ_INSTALL_DIR}/lib/pkgconfig
    )
    set(HARFBUZZ_CONFIGURE_COMMAND
        meson setup --cross-file=${CMAKE_BINARY_DIR}/android-cross.txt --prefix=${HARFBUZZ_INSTALL_DIR} --buildtype=release ${HARFBUZZ_SOURCE_DIR} ${HARFBUZZ_BUILD_DIR} -Ddefault_library=static 
        -Dglib=disabled -Dicu=disabled -Dtests=disabled -Dbenchmark=disabled
    )
else()
    set(HARFBUZZ_CONFIGURE_ENV "")
    set(HARFBUZZ_CONFIGURE_COMMAND
        meson setup --prefix=${HARFBUZZ_INSTALL_DIR} --buildtype=release ${HARFBUZZ_SOURCE_DIR} ${HARFBUZZ_BUILD_DIR}
    )
endif()

ExternalProject_Add(
    harfbuzz
    SOURCE_DIR ${HARFBUZZ_SOURCE_DIR}
    BINARY_DIR ${HARFBUZZ_BUILD_DIR}
    INSTALL_DIR ${HARFBUZZ_INSTALL_DIR}
    CONFIGURE_COMMAND ${CMAKE_COMMAND} -E env ${HARFBUZZ_CONFIGURE_ENV} ${HARFBUZZ_CONFIGURE_COMMAND}
    BUILD_COMMAND ninja -C ${HARFBUZZ_BUILD_DIR}
    INSTALL_COMMAND ninja -C ${HARFBUZZ_BUILD_DIR} install
    LOG_CONFIGURE 1
    LOG_BUILD 1
    LOG_INSTALL 1
)