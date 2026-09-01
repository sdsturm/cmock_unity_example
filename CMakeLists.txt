cmake_minimum_required(VERSION 3.20)

project(cmock_cmake_example C)

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)

include(CTest)
include(FetchContent)

find_package(Ruby REQUIRED)

FetchContent_Declare(
    unity
    GIT_REPOSITORY https://github.com/ThrowTheSwitch/Unity.git
    GIT_TAG master
)

FetchContent_Declare(
    cmock
    GIT_REPOSITORY https://github.com/ThrowTheSwitch/CMock.git
    GIT_TAG master
)

FetchContent_MakeAvailable(unity cmock)

add_library(controller
    src/controller.c
)

target_include_directories(controller PUBLIC
    src
)

include(cmake/cmock.cmake)

cmock_add_test(test_controller
    SOURCES
        test/test_controller.c
    MOCKS
        src/sensor.h
    LIBRARIES
        controller
)
