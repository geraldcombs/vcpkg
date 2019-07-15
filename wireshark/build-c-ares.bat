set CARES_VERSION=1.15.0
vcpkg remove c-ares:x86-windows c-ares:x64-windows
vcpkg install c-ares:x86-windows c-ares:x64-windows
vcpkg export c-ares:x86-windows --output=c-ares-%CARES_VERSION%-win32ws --zip
vcpkg export c-ares:x64-windows --output=c-ares-%CARES_VERSION%-win64ws --zip
