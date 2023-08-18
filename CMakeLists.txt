
cmake_minimum_required(VERSION 3.18)

# External variables
SET( SRC_ROOT ${CMAKE_CURRENT_SOURCE_DIR} CACHE PATH "PWD" )
SET( LIB_DIR "${CMAKE_CURRENT_BINARY_DIR}/lib/${CMAKE_BUILD_TYPE}")
SET( BIN_DIR "${CMAKE_CURRENT_BINARY_DIR}/bin/${CMAKE_BUILD_TYPE}")
#SET( BUILD_FOLDER ${CMAKE_CURRENT_BINARY_DIR} CACHE PATH "Build folder" )
#SET( CTEST_CPUS "8" CACHE STRING "number of jobs to run ctest in parallel" )

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_CURRENT_SOURCE_DIR}/cmake)

OPTION (RASPBERRY_PI "Raspeberri Pi Platform" OFF)

IF( WIN32 )
	MESSAGE ("-- OS Detected: Win32")
	SET_PROPERTY( GLOBAL PROPERTY USE_FOLDERS ON )
	#Configurations
	SET( CMAKE_CONFIGURATION_TYPES "Debug;Release;RelWithDebInfo" CACHE STRING "" FORCE )
	#set( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /std::c++17")
	SET (CMAKE_CXX_STANDARD 17)
	SET (CMAKE_INCLUDE_PATH ${CMAKE_INCLUDE_PATH} ${BOOST_PATH})
	SET (CMAKE_LIBRARY_PATH ${CMAKE_LIBRARY_PATH}  ${BOOST_PATH}/libs)
	add_definitions(-DWIN32=)
ELSE ()
	execute_process(
	    #COMMAND sh -c "cat /etc/os-release | grep VERSION_ID | cut -d'=' -f2 | tr -d '\"'"
		COMMAND sh -c "cat /etc/os-release | grep PRETTY_NAME | cut -d'=' -f2 | tr -d '\"'"
		#COMMAND sh -c "cat /etc/os-release | grep PRETTY_NAME"
	    OUTPUT_VARIABLE LINUX_VERSION
	    OUTPUT_STRIP_TRAILING_WHITESPACE
	)
	message ( STATUS "OS version: ${LINUX_VERSION}")
	#message ( STATUS "${CMAKE_SYSTEM_PROCESSOR}" )
	if ( ${LINUX_VERSION} MATCHES "Raspbian*" )
		# Raspberry Pi detected, do something here
		MESSAGE ( STATUS "Platform Detected: Raspberry Pi")
		#OPTION (RASPBERRY_PI "Raspeberri Pi Platform" ON)
		SET ( RASPBERRY_PI "ON" CACHE INTERNAL "" )
		mark_as_advanced(RASPBERRY_PI)
		add_definitions(-DRASPBERRY_PI=)
		file(STRINGS "/proc/cpuinfo" CPUINFO)
		#message ( STATUS "${CPUINFO}" )
		#string(REGEX MATCH "model name\s+:\s+ARMv7 Processor rev 4" RASPBERRY_PI_3 "${CPUINFO}")
		#if(RASPBERRY_PI_3)
			# Raspberry Pi 3 detected, do something here
		#	add_definitions(-DRASPBERRY_PI_3=)
		#endif()
	else ()
		MESSAGE (STATUS "OS Detected: Linux")
		#set( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std::c++17")
		add_definitions(-DUNIX=)
	endif()
	SET (CMAKE_CXX_STANDARD 17)
ENDIF( WIN32 )

set (SCC_LIBRARIES "" CACHE STRING "SCC_LIBRARIES")
set (SCC_INCLUDE_DIR "" CACHE STRING "SCC_LIBRARIES")
#set (SCC_LIBRARIES "" CACHE STRING "" FORCE)
#set (SCC_INCLUDE_DIR "" CACHE STRING "" FORCE)
#set_property(GLOBAL PROPERTY SCC_LIBRARIES "")
#set_property(GLOBAL PROPERTY SCC_INCLUDE_DIR "")

# Project Name: ${PATH}
get_filename_component(ProjectId ${CMAKE_CURRENT_SOURCE_DIR} NAME)
string(REPLACE " " "_" ProjectId ${ProjectId})
MESSAGE("-- Project: ${ProjectId}")
project(${ProjectId})
#SET( PROJECT_NAME nanana )
#PROJECT( ${PROJECT_NAME} )

MESSAGE( CHECK_START "  Setting Directories")
SET( CMAKE_LIBRARY_OUTPUT_DIRECTORY ${LIB_DIR} )
SET( CMAKE_RUNTIME_OUTPUT_DIRECTORY ${BIN_DIR} )
SET( CMAKE_BINARY_DIR ${BIN_DIR} )


#gcc version
IF( DEFINED GCC_VERSION )
    message(STATUS "gcc compiler version: ${GCC_VERSION}")
ENDIF( )

MESSAGE("")
INCLUDE(cmake/utils_libs.cmake)
INCLUDE(cmake/utils_exes.cmake)
MESSAGE( STATUS "Adding sources...")
ADD_SUBDIRECTORY( sources/ )


#EOF
