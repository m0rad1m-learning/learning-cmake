# Set a default build type if none was specified
if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
    message(STATUS "Setting build type to 'RelWithDebInfo' as non was specified.")
    set(CMAKE_BUILD_TYPE
        RelWithDebInfo
        CACHE STRING "Choose the type of build." FORCE)
    # Set the possible values of the build type for cmake-gui, ccmake
    set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Debug" "Release" "MinSizeRel" "RelWithDebInfo")
endif()

# Use ccache if available
find_program(CCACHE ccache)
if(CCACHE)
    message("-- Using ccache")
    set(CMAKE_CXX_COMPILE_LAUNCHER ${CCACHE})
else()
    message("-- ccache not found, cannot use")
endif()

# Generate compile commands.json to make it easier to work with clang based tools
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

option(ENABLE_IPO "Enable Interprocedural Optimization, aka Link Time Optimization (LTO)" ON)

if(ENABLE_IPO)
    include(CheckIPOSupported)
    check_ipo_supported(RESULT result OUTPUT output)
    if(result)
        message("IPO is supported: |${output}|, result: |${result}|")
        set(CMAKE_INTERPROCEDURAL_OPTIMIZATION TRUE)
    else()
        message(SEND_ERROR "IPO is not supported: |${output}|, result: |${result}|")
    endif()
endif()