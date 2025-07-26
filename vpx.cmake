include(ExternalProject)

set(LIBVPX_SOURCE_DIR ${CMAKE_SOURCE_DIR}/libvpx)
set(LIBVPX_BUILD_DIR ${CMAKE_BINARY_DIR}/libvpx-build)
set(LIBVPX_INSTALL_DIR ${CMAKE_BINARY_DIR}/install)

if(ANDROID)
    if(ANDROID_ABI STREQUAL "armeabi-v7a")
        set(LIBVPX_TARGET "armv7-android-gcc")
        set(LIBVPX_AS "${ANDROID_TOOLCHAIN_ROOT}/bin/${ANDROID_TRIPLE}${ANDROID_NATIVE_API_LEVEL}-clang")
    elseif(ANDROID_ABI STREQUAL "arm64-v8a")
        set(LIBVPX_TARGET "arm64-android-gcc")
        set(LIBVPX_AS "${ANDROID_TOOLCHAIN_ROOT}/bin/${ANDROID_TRIPLE}${ANDROID_NATIVE_API_LEVEL}-clang")
    elseif(ANDROID_ABI STREQUAL "x86")
        set(LIBVPX_TARGET "x86-android-gcc")
        set(LIBVPX_AS "") # Do not set AS for x86
    elseif(ANDROID_ABI STREQUAL "x86_64")
        set(LIBVPX_TARGET "x86_64-android-gcc")
        set(LIBVPX_AS "") # Do not set AS for x86_64
    else()
        message(FATAL_ERROR "Unsupported ANDROID_ABI for libvpx: ${ANDROID_ABI}")
    endif()

    set(LIBVPX_CONFIGURE_ENV
        CC=${ANDROID_TOOLCHAIN_ROOT}/bin/${ANDROID_TRIPLE}${ANDROID_NATIVE_API_LEVEL}-clang
        CXX=${ANDROID_TOOLCHAIN_ROOT}/bin/${ANDROID_TRIPLE}${ANDROID_NATIVE_API_LEVEL}-clang++
        AR=${CMAKE_AR}
        RANLIB=${CMAKE_RANLIB}
        STRIP=${CMAKE_STRIP}
        CFLAGS=--sysroot=${CMAKE_SYSROOT}
        CXXFLAGS=--sysroot=${CMAKE_SYSROOT}
        LDFLAGS=--sysroot=${CMAKE_SYSROOT}
        $<$<BOOL:${LIBVPX_AS}>:AS=${LIBVPX_AS}>
    )
    set(LIBVPX_CONFIGURE_COMMAND
        ${LIBVPX_SOURCE_DIR}/configure
        --target=${LIBVPX_TARGET}
        --prefix=${LIBVPX_INSTALL_DIR}
        --disable-examples
        --disable-unit-tests
        --enable-pic
        --enable-static
        --disable-shared
    )
else()
    set(LIBVPX_CONFIGURE_ENV "")
    set(LIBVPX_CONFIGURE_COMMAND
        ${LIBVPX_SOURCE_DIR}/configure
        --prefix=${LIBVPX_INSTALL_DIR}
        --enable-pic
        --enable-static
        --disable-shared
        --disable-examples
        --disable-unit-tests
    )
endif()

ExternalProject_Add(
    vpx
    SOURCE_DIR ${LIBVPX_SOURCE_DIR}
    BINARY_DIR ${LIBVPX_BUILD_DIR}
    INSTALL_DIR ${LIBVPX_INSTALL_DIR}
    CONFIGURE_COMMAND ${CMAKE_COMMAND} -E env ${LIBVPX_CONFIGURE_ENV} ${LIBVPX_CONFIGURE_COMMAND}
    BUILD_COMMAND make -j
    INSTALL_COMMAND make install
    LOG_CONFIGURE 1
    LOG_BUILD 1
    LOG_INSTALL 1
)