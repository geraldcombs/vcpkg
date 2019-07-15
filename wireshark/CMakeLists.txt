# XXX Still not sure if this is better or worse than a simple batch script.

cmake_minimum_required(VERSION 3.0)

project(wireshark-vcpkg-export NONE)

find_program(VCPKG_EXECUTABLE vcpkg
    PATHS "${CMAKE_SOURCE_DIR}/.."
    NO_DEFAULT_PATH
)
find_program(PATCH_EXECUTABLE patch)
find_program(7Z_EXECUTABLE 7z)

set(BUNDLE_PACKAGES
    # Individual in-use vcpkg ports
    # brotli
    # c-ares
    # lz4

    # Bundle vcpkg ports
    glib # Build-Depends: zlib, pcre, libffi, gettext, libiconv
    libxml2 # Build-Depends: zlib, libiconv, liblzma
    zlib

    # Available vcpkg ports
    # libmaxminddb
    # nghttp2
    # snappy

    # Problematic vcpkg ports
    # libssh # Build-Depends: zlib, openssl

    # Not in vcpkg
    # bcg729
    # gnutls
    # smi
    # sbc
    # spandsp
    # krb5 / kfw / heimdal
    )

set(BUNDLE_X64_PACKAGES)
set(BUNDLE_X86_PACKAGES)
foreach (_pkg ${BUNDLE_PACKAGES})
    list(APPEND BUNDLE_X64_PACKAGES "${_pkg}:x64-windows")
    list(APPEND BUNDLE_X86_PACKAGES "${_pkg}:x86-windows")
endforeach(_pkg)

string(TIMESTAMP BUNDLE_WIN64_DIR "vcpkg-export-%Y%m%d-win64ws")
string(TIMESTAMP BUNDLE_WIN32_DIR "vcpkg-export-%Y%m%d-win32ws")

set(EXTRA_DIST CMakeLists.txt README.Wireshark fixup-g-minint.patch)

macro(add_bundle_commands arch)
    if (${arch} STREQUAL x64)
        set (_dir_var BUNDLE_WIN64_DIR)
        set (_pkg_var BUNDLE_X64_PACKAGES)
    elseif(${arch} STREQUAL x86)
        set (_dir_var BUNDLE_WIN32_DIR)
        set (_pkg_var BUNDLE_X86_PACKAGES)
    else()
        message(FATAL_ERROR "Unknown architecture: ${arch}")
    endif()

    set(_rel_extra_dist)
    foreach(_dist_file ${EXTRA_DIST})
        list(APPEND _rel_extra_dist "wireshark/${_dist_file}")
    endforeach(_dist_file ${EXTRA_DIST})

    add_custom_command(
        OUTPUT "${${_dir_var}}"
        COMMAND "${VCPKG_EXECUTABLE}" remove ${${_pkg_var}}
        COMMAND "${VCPKG_EXECUTABLE}" install ${${_pkg_var}}
        COMMAND "${VCPKG_EXECUTABLE}" export ${${_pkg_var}}
            --output="${${_dir_var}}" --raw
        # Not needed for GLib 2.60 and later.
        COMMAND "${PATCH_EXECUTABLE}"
            -d "${${_dir_var}}/installed/${arch}-windows/include"
            -p1
            < ${CMAKE_SOURCE_DIR}/fixup-g-minint.patch
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
            ${_rel_extra_dist}
            "${${_dir_var}}"
        WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}/.."
    )

    add_custom_command(
        OUTPUT "${${_dir_var}}.zip"
        COMMAND "${7Z_EXECUTABLE}" a -tzip "${${_dir_var}}.zip" "${${_dir_var}}"
        DEPENDS "${${_dir_var}}"
        WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}/.."
    )

    add_custom_target("create-bundle-${arch}" DEPENDS "${${_dir_var}}.zip")
    add_dependencies(create-bundle "create-bundle-${arch}")
endmacro(add_bundle_commands)

add_custom_target(create-bundle ALL)

add_bundle_commands(x64)
add_bundle_commands(x86)