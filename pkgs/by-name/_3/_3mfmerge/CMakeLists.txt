cmake_minimum_required(VERSION 3.14...3.20)

project(3mfmerge)

# Set output directories
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR}/bin$<0:>)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR}/bin$<0:>)

# Set C++ standard
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# Include lib3mf headers
include_directories("@lib3mfDev@/include/lib3mf/Bindings/Cpp")

# Define the executable
add_executable(${PROJECT_NAME} 3mfmerge.cpp)

# Link against lib3mf
target_link_libraries(${PROJECT_NAME} PRIVATE 3mf)
