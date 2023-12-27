# Useful commands for building this fork

## Command Shell Prep

```
vcvars64
```

## Normal Builds

```
cmake -G Ninja -B build\x64\debug -S . -DBUILD_STATIC_AND_SHARED=1 -DCMAKE_BUILD_TYPE=Debug
ninja -C build\x64\debug
cmake -G Ninja -B build\x64\release -S . -DBUILD_STATIC_AND_SHARED=1 -DCMAKE_BUILD_TYPE=Release
ninja -C build\x64\release
cmake -G Ninja -B build\x64\minsizerel -S . -DBUILD_STATIC_AND_SHARED=1 -DCMAKE_BUILD_TYPE=MinSizeRel
ninja -C build\x64\minsizerel

build\x64\debug\bin\unit-hyperscan.exe
build\x64\release\bin\unit-hyperscan.exe
build\x64\minsizerel\bin\unit-hyperscan.exe
```

## AVX2 Builds

```
cmake -G Ninja -B build\x64-avx2\debug -S . -DBUILD_STATIC_AND_SHARED=1 -DCMAKE_BUILD_TYPE=Debug -DCMAKE_C_FLAGS=/arch:AVX2 -DCMAKE_CXX_FLAGS=/arch:AVX2
ninja -C build\x64-avx2\debug
cmake -G Ninja -B build\x64-avx2\release -S . -DBUILD_STATIC_AND_SHARED=1 -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_FLAGS=/arch:AVX2 -DCMAKE_CXX_FLAGS=/arch:AVX2
ninja -C build\x64-avx2\release
cmake -G Ninja -B build\x64-avx2\minsizerel -S . -DBUILD_STATIC_AND_SHARED=1 -DCMAKE_BUILD_TYPE=MinSizeRel -DCMAKE_C_FLAGS=/arch:AVX2 -DCMAKE_CXX_FLAGS=/arch:AVX2
ninja -C build\x64-avx2\minsizerel

build\x64-avx2\debug\bin\unit-hyperscan.exe
build\x64-avx2\release\bin\unit-hyperscan.exe
build\x64-avx2\minsizerel\bin\unit-hyperscan.exe
```
