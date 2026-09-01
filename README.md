# CMock + Unity + CMake + CTest

Minimal example showing CMock-generated mocks used with Unity, CMake, and CTest without Ceedling.

## Requirements

- CMake >= 3.20
- C compiler
- Git
- Ruby

CMake fetches Unity and CMock with `FetchContent`.

## Build

```sh
cmake -S . -B build
cmake --build build
```

## Run tests

```sh
ctest --test-dir build --output-on-failure
```

You can also run the test executable directly:

```sh
./build/test_controller
```

On a multi-config generator, the executable may be under `build/Debug/` or `build/Release/`.

## Project structure

```text
.
├── CMakeLists.txt
├── cmake/
│   └── cmock.cmake
├── src/
│   ├── controller.c
│   ├── controller.h
│   └── sensor.h
└── test/
    └── test_controller.c
```

`controller.c` depends on `sensor_read()`. The test does not provide a production implementation of `sensor_read()`; CMock generates `mock_sensor.c` and `mock_sensor.h` from `sensor.h`.

## Adding another mocked test

```cmake
cmock_add_test(test_temperature
    SOURCES
        test/test_temperature.c
    MOCKS
        src/sensor.h
        src/clock.h
    LIBRARIES
        temperature
)
```

The helper handles:

- CMock configuration
- mock generation
- Unity runtime
- CMock runtime
- include paths
- test executable
- CTest registration

For reproducible production/CI builds, pin the `GIT_TAG` values in `CMakeLists.txt` to specific releases or commit hashes instead of tracking `master`.
