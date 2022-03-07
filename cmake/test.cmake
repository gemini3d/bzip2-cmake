execute_process(COMMAND ${exe} ${opt}
INPUT_FILE ${in}
OUTPUT_FILE ${new}
TIMEOUT 5
COMMAND_ERROR_IS_FATAL ANY
)

execute_process(COMMAND ${CMAKE_COMMAND} -E compare_files ${new} ${ref}
RESULT_VARIABLE ret
TIMEOUT 5
)
if(NOT ret EQUAL 0)
  message(FATAL_ERROR "files different: ${new} != ${ref}")
endif()
