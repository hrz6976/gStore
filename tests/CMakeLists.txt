set(LIB_TESTS
        # Conan Deps
        Boost::system
        Boost::regex
        Boost::thread
        minizip::minizip
        OpenSSL::SSL
        OpenSSL::Crypto
        indicators::indicators
        rapidjson
        log4cplus::log4cplus
        CURL::libcurl
        Backward::Backward
        libdwarf::libdwarf
        libelf::libelf
        # System Deps
        OpenMP::OpenMP_CXX
        ${LIB_JEMALLOC}
        ${LIB_READLINE}
        Threads::Threads
        # Unmanaged Deps
        antlr4-runtime
        workflow
)

# set definition if has debug info
if (CMAKE_BUILD_TYPE MATCHES "Deb")
    LIST(APPEND LIB_TESTS
        libdwarf::libdwarf
        libelf::libelf
    )
endif ()

set(OBJ_TESTS
        $<TARGET_OBJECTS:gstore_stringindex>
        $<TARGET_OBJECTS:gstore_parser>
        $<TARGET_OBJECTS:gstore_server>
        $<TARGET_OBJECTS:gstore_database>
        $<TARGET_OBJECTS:gstore_util>
        $<TARGET_OBJECTS:gstore_topk>
        $<TARGET_OBJECTS:gstore_query>
        $<TARGET_OBJECTS:gstore_trie>
        $<TARGET_OBJECTS:gstore_kvstore>
)

add_executable(update_test update_test.cpp ${OBJ_TESTS})
target_link_libraries(update_test ${LIB_TESTS})

add_executable(dataset_test dataset_test.cpp ${OBJ_TESTS})
target_link_libraries(dataset_test ${LIB_TESTS})

add_executable(transaction_test transaction_test.cpp ${OBJ_TESTS})
target_link_libraries(transaction_test ${LIB_TESTS})

add_executable(run_transaction run_transaction.cpp ${OBJ_TESTS} $<TARGET_OBJECTS:gstore_connector>)
target_link_libraries(run_transaction ${LIB_TESTS})

add_executable(workload workload.cpp ${OBJ_TESTS})
target_link_libraries(workload ${LIB_TESTS})

add_executable(debug_test debug_test.cpp ${OBJ_TESTS})
target_link_libraries(debug_test ${LIB_TESTS})

add_executable(gtest gtest.cpp ${OBJ_TESTS})
target_link_libraries(gtest ${LIB_TESTS})

get_directory_property(gstore_tests DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} BUILDSYSTEM_TARGETS)
foreach (test ${gstore_tests})
    add_dependencies(${test} prepare)
    install(TARGETS ${test} DESTINATION ${GSTORE_TEST_DIR})
endforeach ()