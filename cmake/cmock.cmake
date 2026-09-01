function(cmock_add_test TEST_NAME)
    cmake_parse_arguments(
        TEST
        ""
        ""
        "SOURCES;MOCKS;LIBRARIES"
        ${ARGN}
    )

    if(NOT TEST_SOURCES)
        message(FATAL_ERROR
            "cmock_add_test(${TEST_NAME}): SOURCES is required")
    endif()

    set(MOCK_DIR
        "${CMAKE_CURRENT_BINARY_DIR}/mocks/${TEST_NAME}"
    )

    set(CMOCK_CONFIG
        "${MOCK_DIR}/cmock.yml"
    )

    file(MAKE_DIRECTORY "${MOCK_DIR}")

    file(GENERATE
        OUTPUT "${CMOCK_CONFIG}"
        CONTENT
"---
:cmock:
  :mock_path: ${MOCK_DIR}
  :mock_prefix: mock_
  :plugins: []
"
    )

    set(MOCK_SOURCES "")

    foreach(MOCK IN LISTS TEST_MOCKS)
        get_filename_component(MOCK_NAME
            "${MOCK}"
            NAME_WE
        )

        set(MOCK_C
            "${MOCK_DIR}/mock_${MOCK_NAME}.c"
        )

        set(MOCK_H
            "${MOCK_DIR}/mock_${MOCK_NAME}.h"
        )

        add_custom_command(
            OUTPUT
                "${MOCK_C}"
                "${MOCK_H}"

            COMMAND
                ${CMAKE_COMMAND} -E make_directory
                "${MOCK_DIR}"

            COMMAND
                ${CMAKE_COMMAND} -E env
                "UNITY_DIR=${unity_SOURCE_DIR}"
                "${Ruby_EXECUTABLE}"
                "${cmock_SOURCE_DIR}/lib/cmock.rb"
                "-o${CMOCK_CONFIG}"
                "${CMAKE_CURRENT_SOURCE_DIR}/${MOCK}"

            DEPENDS
                "${CMAKE_CURRENT_SOURCE_DIR}/${MOCK}"
                "${CMOCK_CONFIG}"

            VERBATIM
        )

        list(APPEND MOCK_SOURCES "${MOCK_C}")
    endforeach()

    add_executable("${TEST_NAME}"
        ${TEST_SOURCES}
        ${MOCK_SOURCES}
        "${cmock_SOURCE_DIR}/src/cmock.c"
        "${unity_SOURCE_DIR}/src/unity.c"
    )

    target_include_directories("${TEST_NAME}" PRIVATE
        "${CMAKE_CURRENT_SOURCE_DIR}/src"
        "${MOCK_DIR}"
        "${unity_SOURCE_DIR}/src"
        "${cmock_SOURCE_DIR}/src"
    )

    target_link_libraries("${TEST_NAME}" PRIVATE
        ${TEST_LIBRARIES}
    )

    add_test(
        NAME "${TEST_NAME}"
        COMMAND "${TEST_NAME}"
    )
endfunction()
