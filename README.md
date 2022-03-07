# BZip2 CMake

[![ci](https://github.com/gemini3d/bzip2-cmake/actions/workflows/ci.yml/badge.svg)](https://github.com/gemini3d/bzip2-cmake/actions/workflows/ci.yml)

CMake for BZip2 works better than Makefile across compilers and computing platforms.

```sh
cmake -B build
cmake --build build

# optional
ctest --test-dir build

cmake --install build
```

We use CMake FetchContent to retrieve BZip2 source from host website, building it unmodified except addition of CMake.
