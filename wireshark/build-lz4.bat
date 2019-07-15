set LZ4_VERSION=1.8.3
vcpkg remove lz4:x86-windows lz4:x64-windows
vcpkg install lz4:x86-windows lz4:x64-windows
vcpkg export lz4:x86-windows --output=lz4-%LZ4_VERSION%-win32ws --zip
vcpkg export lz4:x64-windows --output=lz4-%LZ4_VERSION%-win64ws --zip
