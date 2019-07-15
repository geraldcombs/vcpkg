set BROTLI_VERSION=1.0.2-4
vcpkg remove brotli:x86-windows brotli:x64-windows
vcpkg install brotli:x86-windows brotli:x64-windows
vcpkg export brotli:x86-windows --output=brotli-%BROTLI_VERSION%-win32ws --zip
vcpkg export brotli:x64-windows --output=brotli-%BROTLI_VERSION%-win64ws --zip
