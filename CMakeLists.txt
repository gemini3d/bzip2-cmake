cmake_minimum_required(VERSION 3.14...3.23)

project(bzip2
LANGUAGES C
VERSION 1.0.8.0
)

enable_testing()

include(FetchContent)

include(cmake/options.cmake)

FetchContent_Declare(bzp
URL https://sourceware.org/pub/bzip2/bzip2-1.0.8.tar.gz
URL_HASH SHA256=ab5a03176ee106d3f0fa90e381da478ddae405918153cca248e682cd0c4a2269
UPDATE_DISCONNECTED true
)

FetchContent_Populate(bzp)

add_library(bz2
${bzp_SOURCE_DIR}/blocksort.c
${bzp_SOURCE_DIR}/huffman.c
${bzp_SOURCE_DIR}/crctable.c
${bzp_SOURCE_DIR}/randtable.c
${bzp_SOURCE_DIR}/compress.c
${bzp_SOURCE_DIR}/decompress.c
${bzp_SOURCE_DIR}/bzlib.c
)
target_compile_definitions(bz2 PRIVATE -D_FILE_OFFSET_BITS=64)
set_target_properties(bz2 PROPERTIES
POSITION_INDEPENDENT_CODE true
VERSION ${PROJECT_VERSION}
)

install(TARGETS bz2)
install(FILES ${bzp_SOURCE_DIR}/bzlib.h TYPE INCLUDE)


if(BUILD_UTILS)
  add_executable(bzip2 ${bzp_SOURCE_DIR}/bzip2.c)
  target_link_libraries(bzip2 PRIVATE bz2)

  add_test(NAME bzip_cmp1
  COMMAND ${CMAKE_COMMAND}
    -Dopt=-1
    -Dexe:FILEPATH=$<TARGET_FILE:bzip2>
    -Din:FILEPATH=${bzp_SOURCE_DIR}/sample1.ref
    -Dnew:FILEPATH=${CMAKE_CURRENT_BINARY_DIR}/sample1.rb2
    -Dref:FILEPATH=${bzp_SOURCE_DIR}/sample1.bz2
    -P ${CMAKE_CURRENT_SOURCE_DIR}/cmake/test.cmake
  )

  add_test(NAME bzip_cmp2
  COMMAND ${CMAKE_COMMAND}
    -Dopt=-2
    -Dexe:FILEPATH=$<TARGET_FILE:bzip2>
    -Din:FILEPATH=${bzp_SOURCE_DIR}/sample2.ref
    -Dnew:FILEPATH=${CMAKE_CURRENT_BINARY_DIR}/sample2.rb2
    -Dref:FILEPATH=${bzp_SOURCE_DIR}/sample2.bz2
    -P ${CMAKE_CURRENT_SOURCE_DIR}/cmake/test.cmake
  )

  set_tests_properties(bzip_cmp1 bzip_cmp2 PROPERTIES
  TIMEOUT 10
  )

  add_executable(bzip2recover ${bzp_SOURCE_DIR}/bzip2recover.c)

  install(TARGETS bzip2 bzip2recover)
endif()
