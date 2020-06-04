
project(EigenCs LANGUAGES CXX CSharp)
cmake_minimum_required(VERSION 3.8)

include_directories(eigen)
include_directories(eigen/Eigen)
include_directories(${CMAKE_CURRENT_SOURCE_DIR})

# SWIG setup
find_package(SWIG REQUIRED)
cmake_policy(SET CMP0078 NEW)
cmake_policy(SET CMP0086 NEW)
include(${SWIG_USE_FILE})
set (UseSWIG_MODULE_VERSION 2)
set (UseSWIG_TARGET_NAME_PREFERENCE STANDARD)

# Eigen bindings
set_property(SOURCE eigen.i PROPERTY CPLUSPLUS ON)
set_property(SOURCE eigen.i PROPERTY COMPILE_OPTIONS -namespace Eigen)
swig_add_library(EigenNative
	TYPE SHARED
	LANGUAGE csharp
	SOURCES
		eigen.i
)
set_property(TARGET EigenNative PROPERTY SWIG_COMPILE_OPTIONS -cpperraswarn)
get_property(eigen_wrapper_files TARGET EigenNative PROPERTY SWIG_SUPPORT_FILES)
get_property(eigen_wrapper_files_directory TARGET EigenNative PROPERTY SWIG_SUPPORT_FILES_DIRECTORY)
add_library(Eigen SHARED
	${eigen_wrapper_files}
	${eigen_wrapper_files_directory}/Vector2f.cs
	${eigen_wrapper_files_directory}/Vector3f.cs
	${eigen_wrapper_files_directory}/Vector4f.cs
	${eigen_wrapper_files_directory}/VectorXf.cs
	${eigen_wrapper_files_directory}/Matrix2f.cs
	${eigen_wrapper_files_directory}/Matrix3f.cs
	${eigen_wrapper_files_directory}/Matrix4f.cs
	${eigen_wrapper_files_directory}/MatrixXf.cs
)

# Native library and bindings
add_library(ExampleNative STATIC
	example.cpp
	example.h
)

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
