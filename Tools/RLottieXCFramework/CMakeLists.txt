cmake_minimum_required( VERSION 3.3 )

#declare project
project( rlottie VERSION 0.0.1 LANGUAGES C CXX ASM)

if (NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE MinSizeRel)
endif()

set(BUILD_SHARED_LIBS ON)

include_directories(
    "${CMAKE_SOURCE_DIR}/inc" 
    "${CMAKE_SOURCE_DIR}/src/vector" 
    "${CMAKE_SOURCE_DIR}/src/vector/pixman" 
    "${CMAKE_SOURCE_DIR}/src/vector/freetype"
)

file(GLOB_RECURSE SOURCES "inc/**/*.h" "src/**/*.h" "src/**/*.cpp" "config/**/*.h")
list(FILTER SOURCES EXCLUDE REGEX "src/vector/stb/.*$")
list(FILTER SOURCES EXCLUDE REGEX "src/vector/vdrawhelper_neon.cpp$")
list(FILTER SOURCES EXCLUDE REGEX "src/lottie/rapidjson/msinttypes/.*$")

add_library( rlottie ${SOURCES} )
set_target_properties(rlottie PROPERTIES PREFIX "")

add_library(rlottie::rlottie ALIAS rlottie)

set_target_properties( rlottie PROPERTIES DEFINE_SYMBOL LOT_BUILD )

option(LOTTIE_MODULE "Enable LOTTIE MODULE SUPPORT" ON)
option(LOTTIE_THREAD "Enable LOTTIE THREAD SUPPORT" ON)
option(LOTTIE_CACHE "Enable LOTTIE CACHE SUPPORT" ON)
option(LOTTIE_TEST "Build LOTTIE AUTOTESTS" OFF)

CONFIGURE_FILE(${CMAKE_CURRENT_LIST_DIR}/cmake/config.h.in config.h)

target_include_directories(rlottie PRIVATE "${CMAKE_CURRENT_BINARY_DIR}")

target_compile_options(
    rlottie
    PUBLIC
    PRIVATE
    -std=c++14
    -fno-exceptions
    -fno-unwind-tables
    -fno-asynchronous-unwind-tables
    -fno-rtti
    -Wall
    -Werror
    -Wextra
    -Wnon-virtual-dtor
    -Woverloaded-virtual
    -Wno-unused-parameter
    -fvisibility=hidden
    -Wno-sign-compare
    [=[-Dpixman_region_selfcheck(x)=1]=]
    -DLOTTIE_DISABLE_ARM_NEON=1
    -DLOTTIE_THREAD_SAFE=1
    -DLOTTIE_IMAGE_MODULE_DISABLED=1
)

set( CMAKE_THREAD_PREFER_PTHREAD TRUE )
find_package( Threads )

target_link_libraries(rlottie PUBLIC "${CMAKE_THREAD_LIBS_INIT}")

if (LOTTIE_MODULE)
    target_link_libraries(rlottie PRIVATE ${CMAKE_DL_LIBS})
endif()

if(APPLE)
    target_link_libraries(rlottie PUBLIC "-Wl, -undefined error")
else()
    target_link_libraries(rlottie PUBLIC "-Wl,--no-undefined")
endif()

if (NOT LIB_INSTALL_DIR)
    set (LIB_INSTALL_DIR "/usr/local/lib")
endif (NOT LIB_INSTALL_DIR)

SET(PREFIX ${CMAKE_INSTALL_PREFIX})
SET(EXEC_DIR ${PREFIX})
SET(LIBDIR ${LIB_INSTALL_DIR})
SET(INCDIR ${PREFIX}/include)

CONFIGURE_FILE(${PROJECT_NAME}.pc.in ${PROJECT_NAME}.pc)
INSTALL(FILES ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}.pc DESTINATION ${LIB_INSTALL_DIR}/pkgconfig)

install(
    FILES
    inc/rlottie.h
    inc/rlottie_capi.h
    inc/rlottiecommon.h
    DESTINATION ${LIB_INSTALL_DIR}/include
)

install(
    TARGETS rlottie EXPORT rlottie-targets
    LIBRARY     DESTINATION    ${LIB_INSTALL_DIR}
    ARCHIVE     DESTINATION    ${LIB_INSTALL_DIR}
    INCLUDES    DESTINATION    include
)

install(
    EXPORT rlottie-targets
    FILE          rlottieTargets.cmake
    NAMESPACE     rlottie::
    DESTINATION   ${LIB_INSTALL_DIR}/cmake/rlottie
)


include(CMakePackageConfigHelpers)
write_basic_package_version_file(
    ${CMAKE_CURRENT_BINARY_DIR}/rlottieConfigVersion.cmake
    VERSION ${PROJECT_VERSION}
    COMPATIBILITY AnyNewerVersion
)

configure_package_config_file(${CMAKE_CURRENT_LIST_DIR}/cmake/rlottieConfig.cmake.in
    ${CMAKE_CURRENT_BINARY_DIR}/rlottieConfig.cmake
    INSTALL_DESTINATION ${LIB_INSTALL_DIR}/cmake/rlottie
)

install(
    FILES
    ${CMAKE_CURRENT_BINARY_DIR}/rlottieConfig.cmake
    ${CMAKE_CURRENT_BINARY_DIR}/rlottieConfigVersion.cmake
    DESTINATION ${LIB_INSTALL_DIR}/cmake/rlottie
)

export(EXPORT rlottie-targets FILE ${CMAKE_CURRENT_BINARY_DIR}/rlottieTargets.cmake NAMESPACE rlottie::)

export(PACKAGE rlottie)

