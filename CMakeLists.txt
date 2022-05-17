# set minimum cmake version
cmake_minimum_required(VERSION 3.1)

if(${CMAKE_VERSION} VERSION_LESS 3.12)
    cmake_policy(VERSION ${CMAKE_MAJOR_VERSION}.${CMAKE_MINOR_VERSION})
else()
    cmake_policy(VERSION 3.20)
endif()

###############################
### PROJECT DEFINITION
###############################

# project name and language
project(MyProject
    VERSION 1.0
    DESCRIPTION "My first CMake project"
    LANGUAGES C)

###############################
### JUST FOR INFO
###############################

message("-------------------------")
message("### NEW BUILD STARTS NOW")
message ("------------------------")

# learning variables
set(hello "World")
message("-- Hello ${hello}")
# predefined varialbes
message("-- Build folder is ${PROJECT_BINARY_DIR}")
message("-- Source folder is ${PROJECT_SOURCE_DIR}")
message("-- CMakeList folder is ${CMAKE_CURRENT_LIST_DIR}")


###############################
### Advanced stuff
###############################

include(cmake/StandardProjectSettings.cmake)

# Link this 'library to set the c(++) standard / compile-time option requested
add_library(project_options INTERFACE)
target_compile_features(project_options INTERFACE cxx_std_17)

# Link this 'library to use the warnings specified in 'CompilerWarnings.cmake
add_library(project_warnings INTERFACE)
# Standard compiler warnings
include(cmake/CompilerWarnings.cmake)
set_project_warnings(project_warnings)

# enable doxygen
include(cmake/Doxygen.cmake)
enable_doxygen()

# Allow for static analysis options
include(cmake/StaticAnalyzers.cmake)


###############################
### SET, OPTIONS AND DEPENDENT OPTIONS 
###############################

# # Set a variable, which will en- or disable compiler warnings (see section on 'Compiler Warnings')
# set(COMPILER_WARINGS OFF)
# message(STATUS "-- Compiler warning variable is now switched to: ${COMPILER_WARINGS}")

# # The CMake built-in module 'CMakeDependentOption' allows using dependent options, so options that are only show if other options are ON
# include(CMakeDependentOption)

# # second option depends on the value of the first
# cmake_dependent_option(
#   WALL_COMPILER_WARINGS "Compile with option 'Wall'" ON
#   "COMPILER_WARNINGS" ON
#   )

# # third option depends on the value of the first
# cmake_dependent_option(
#    WEXTRA_COMPILER_WARINGS "Compile with option 'Wextra'" OFF
#   "COMPILER_WARNINGS" ON
#   )

# # No clue what that is doing....
# set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS ON)



###############################
### LIBRARY MANAGEMENT
###############################

# A library is a package of code that is meant to be reused by many programs. 

# There are two types of libraries:
# 1) Shared libraries are .so (or in Windows .dll, or in OS X .dylib) files. 
#    All the code relating to the library is in this file, and it is referenced
#    by programs using it at run-time. A program using a shared library only
#    makes reference to the code that it uses in the shared library.
# 2) Static libraries are .a (or in Windows .lib) files. All the code relating
#    to the library is in this file, and it is directly linked into the program
#    at compile time. A program using a static library takes copies of the code
#    that it uses from the static library and makes it part of the program. 
#    [Windows also has .lib files which are used to reference .dll files, but 
#    they act the same way as the first one].

### OPTION 1: Create a library and add source files directly without specificying the type
# add_library(calculator
#    library/calc.c
#    library/calc.h
#    library/advanced_calc.h
#    library/advanced_calc.c


### OPTION 2: First create a list and later add the to the library, e.g. when some other operations should be done on the list before adding
#list(APPEND 
#    calculator
#    library/simple_calc.h
#    library/simple_calc.c
#    library/advanced_calc.h
#    library/advanced_calc.c)

# ... do something with the list

# add_library(myLibraries SHARED ${calculator})


### OPTION 3: a) Define a variable, which determines the type of the library
# First define the library, and later add the sources to the library   
set(MAKE_SHARED_LIBRARY ON)

# b) Create the library based, on the value of the variable
if(MAKE_SHARED_LIBRARY)
    message(STATUS "Build shared library")
    add_library(calculator SHARED)
else()
    message(STATUS "Build static library")
    add_library(calculator STATIC)
endif()

# c) Add the actual source files to the defined library from above
target_sources(calculator
    PRIVATE
    library/simple_calc.h
    library/simple_calc.c
    library/advanced_calc.h
    library/advanced_calc.c)


###############################
### COMPILER SETTINGS
###############################

# if(COMPILER_WARINGS)
#     message(STATUS "Compile sources with 'Wall' compiler warnings? ${WALL_COMPILER_WARINGS}")
#     message(STATUS "Compile sources with 'Wextra' compiler warnings? ${WEXTRA_COMPILER_WARINGS}")


#     #b.1) if the dependent option WALL_COMPILER_WARINGS is on, add this compiler options to the compiler command
#     if(WALL_COMPILER_WARINGS)
#         add_compile_options(-Wall)
#     endif()

#     #b.2) if the dependent option WEXTRA_COMPILER_WARINGS is on, add this compiler options to the compiler command
#     if(WEXTRA_COMPILER_WARINGS)
#     add_compile_options(-Wextra)
#     endif()   
# endif()


# # Regradless of hwo the added the calculator library in the previous section (SHARED vs. STATIC), wish to compile the library with the optimization flag: -O3
# target_compile_options(calculator
# PRIVATE
# -O3)


# # Yet for some library source files, the optimization flag should be lower
# list(
#     APPEND sources_with_lower_optimization
#     library/advanced_calc.c)

# # We use the IN LISTS foreach syntax to set source properties
# message(STATUS "Setting source properties using IN LISTS syntax:")
# foreach(_source IN LISTS sources_with_lower_optimization)
#   set_source_files_properties(${_source} PROPERTIES COMPILE_FLAGS -O2)
#   message(STATUS "Appending -O2 flag for ${_source}")
# endforeach()

# # We demonstrate the plain foreach syntax to query source properties
# # which requires to expand the contents of the variable
# message(STATUS "Querying sources properties using plain syntax:")
# foreach(_source ${sources_with_lower_optimization})
#   get_source_file_property(_flags ${_source} COMPILE_FLAGS)
#   message(STATUS "Source ${_source} has the following extra COMPILE_FLAGS: ${_flags}")
# endforeach()





###############################
### DEBUGGING 
###############################

# The CMake built-in module 'CMakePrintHelpers' makes it easier to print variables and their names
include(CMakePrintHelpers)

# E.g. by using the 'cmake_print_variables' function
# 1) Printing default variables
cmake_print_variables(CMAKE_C_COMPILER CMAKE_MAJOR_VERSION DOES_NOT_EXIST)
# 1) Printing my defined variables -> MAKE_SHARED_LIBRARY="ON"
cmake_print_variables(MAKE_SHARED_LIBRARY)



###############################
### BUILD EXECUTABLE 
###############################

# d) Build the executyble and add the libraries
add_executable(MyFirstProgramBuildByCMake src/main.c)
target_link_libraries(MyFirstProgramBuildByCMake PRIVATE calculator)