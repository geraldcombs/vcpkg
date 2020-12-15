# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/pool
    REF boost-1.74.0
    SHA512 893fb1a56a42217d9480ed44786839510b8689f188708fc6c43b0888651cf0315e1100027bd11872805ac1f75fdad7ba736e966ccb8b069e9c8780e13bfbff82
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
