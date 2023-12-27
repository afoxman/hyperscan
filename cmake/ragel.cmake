# function for doing all the dirty work in turning a .rl into C++
#
# On Windows, getting a working build of Ragel that runs during a build is difficult
# and it takes away the chance for repo-wide code scanners/linters to run and detect
# issues.
#
# Expand this routine to support using pre-generated .rl.cpp files which are merged into
# the repo. These are copied directly to the build output, rather than running ragel at
# build time.
#
# To generate these files on Windows, I used the Windows Subsystem for Linux (Ubuntu).
# In installed the ragel 6.10 package and ran "ragel-gen.sh" at the root of this repo
# from within the WSL shell.
#
function(ragelmaker src_rl)
    get_filename_component(src_dir ${src_rl} PATH) # old cmake needs PATH
    get_filename_component(src_file ${src_rl} NAME_WE)

    set(rl_cpp_in ${CMAKE_CURRENT_SOURCE_DIR}/${src_dir}/${src_file}.rl.cpp)
    set(rl_out ${CMAKE_CURRENT_BINARY_DIR}/${src_dir}/${src_file}.cpp)

    if(EXISTS "${rl_cpp_in}")
        message(STATUS "Using pre-generated ragel file: ${rl_cpp_in}")

        add_custom_command(
            OUTPUT ${rl_out}
            COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_CURRENT_BINARY_DIR}/${src_dir}
            COMMAND ${CMAKE_COMMAND} -E copy ${rl_cpp_in} ${rl_out}
            DEPENDS ${rl_cpp_in}
            )
    else()
        message(STATUS "Running ragel: ${CMAKE_CURRENT_SOURCE_DIR}/${src_rl}")

        if(${RAGEL} STREQUAL "RAGEL-NOTFOUND")
            message(FATAL_ERROR "Ragel state machine compiler not found")
        endif()

        add_custom_command(
            OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/${src_dir}/${src_file}.cpp
            COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_CURRENT_BINARY_DIR}/${src_dir}
            COMMAND ${RAGEL} ${CMAKE_CURRENT_SOURCE_DIR}/${src_rl} -o ${rl_out}
            DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/${src_rl}
            )
    endif()

    add_custom_target(ragel_${src_file} DEPENDS ${rl_out})
    set_source_files_properties(${rl_out} PROPERTIES GENERATED TRUE)
endfunction(ragelmaker)
