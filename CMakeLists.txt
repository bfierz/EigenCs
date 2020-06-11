
project(EigenCs LANGUAGES CXX CSharp)
cmake_minimum_required(VERSION 3.8)

# Download automatically, you can also just copy the conan.cmake file
if(NOT EXISTS "${CMAKE_BINARY_DIR}/conan.cmake")
	message(STATUS "Downloading conan.cmake from https://github.com/conan-io/cmake-conan")
	file(DOWNLOAD "https://github.com/conan-io/cmake-conan/raw/v0.14/conan.cmake" "${CMAKE_BINARY_DIR}/conan.cmake")
endif()
include(${CMAKE_BINARY_DIR}/conan.cmake)
conan_cmake_run(
	REQUIRES
		swig/4.0.2@
		eigen/3.3.7@
	BASIC_SETUP
	CMAKE_TARGETS
)
foreach(TGT ${CONAN_TARGETS})
	set_target_properties(${TGT}
		PROPERTIES
			MAP_IMPORTED_CONFIG_MINSIZEREL Release
			MAP_IMPORTED_CONFIG_RELWITHDEBINFO Release
)
endforeach()

include_directories(${CMAKE_CURRENT_SOURCE_DIR})

# SWIG setup
set(SWIG_EXECUTABLE "${CONAN_BIN_DIRS_SWIG_RELEASE}/swig.exe" CACHE FILEPATH "SWIG executable")
find_package(SWIG REQUIRED)
cmake_policy(SET CMP0078 NEW)
cmake_policy(SET CMP0086 NEW)
include(${SWIG_USE_FILE})
set (UseSWIG_MODULE_VERSION 2)
set (UseSWIG_TARGET_NAME_PREFERENCE STANDARD)

# Eigen bindings
set_property(SOURCE eigen.i PROPERTY CPLUSPLUS ON)
set_property(SOURCE eigen.i PROPERTY USE_TARGET_INCLUDE_DIRECTORIES TRUE)
set_property(SOURCE eigen.i PROPERTY COMPILE_OPTIONS -namespace Eigen)
swig_add_library(EigenNative
	TYPE SHARED
	LANGUAGE csharp
	SOURCES
		eigen.i
)
target_link_libraries(EigenNative CONAN_PKG::eigen)

set_property(TARGET EigenNative PROPERTY SWIG_COMPILE_OPTIONS -cpperraswarn)
get_property(eigen_wrapper_files TARGET EigenNative PROPERTY SWIG_SUPPORT_FILES)
get_property(eigen_wrapper_files_directory TARGET EigenNative PROPERTY SWIG_SUPPORT_FILES_DIRECTORY)
list(APPEND eigen_wrapper_files
	"${eigen_wrapper_files_directory}/Vector2f.cs"
	"${eigen_wrapper_files_directory}/Vector3f.cs"
	"${eigen_wrapper_files_directory}/Vector4f.cs"
	"${eigen_wrapper_files_directory}/VectorXf.cs"
	"${eigen_wrapper_files_directory}/Matrix2f.cs"
	"${eigen_wrapper_files_directory}/Matrix3f.cs"
	"${eigen_wrapper_files_directory}/Matrix4f.cs"
	"${eigen_wrapper_files_directory}/MatrixXf.cs"
)
set_source_files_properties(${eigen_wrapper_files} PROPERTIES GENERATED TRUE)
message(STATUS ${eigen_wrapper_files})
add_library(Eigen SHARED
	${eigen_wrapper_files}
)
target_link_libraries(Eigen EigenNative)

# Native library and bindings
add_library(ExampleNative STATIC
	example.cpp
	example.h
)
target_link_libraries(ExampleNative CONAN_PKG::eigen)

set_property(SOURCE example.i PROPERTY CPLUSPLUS ON)
swig_add_library(ExampleBindings
	TYPE MODULE
	LANGUAGE csharp
	SOURCES
		example.i
)
set_property(TARGET ExampleBindings PROPERTY SWIG_COMPILE_OPTIONS -cpperraswarn)
target_link_libraries(ExampleBindings ExampleNative)
get_property(example_wrapper_files TARGET ExampleBindings PROPERTY SWIG_SUPPORT_FILES)

# Managed example
add_executable(Example
	example.cs
	${example_wrapper_files}
)
target_link_libraries(Example Eigen)
add_dependencies(Example ExampleBindings)
