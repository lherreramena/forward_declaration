

#########################################################################################

function(SUBDIRLIST curdir result)
  FILE(GLOB children RELATIVE ${curdir} ${curdir}/*)
  SET(dirlist "")
  FOREACH(child ${children})
    IF(IS_DIRECTORY ${curdir}/${child})
        SET(dirlist ${dirlist} ${child})
    ENDIF()
  ENDFOREACH()
  #message ( STATUS "result: ${dirlist}")
  SET(${result} ${dirlist} PARENT_SCOPE)
endfunction()

function(GetFolderName curdir result)
  get_filename_component(dirname ${curdir} NAME)
  string(REPLACE " " "_" dirname ${dirname})
  set (${result} ${dirname} PARENT_SCOPE)
endfunction()

function(GetDirName curdir result)
  get_filename_component(dirname ${curdir} DIRECTORY)
  #string(REPLACE " " "_" dirname ${dirname})
  set (${result} ${dirname} PARENT_SCOPE)
endfunction()

function(config_exe_target in_path out_name)
  # External variables
  SET( SRC_ROOT ) 
  SET( CMAKE_BUILD_TYPE ) # "Debug" or "Release"

  get_filename_component(PROJECT_NAME ${in_path} NAME)
  string(REPLACE " " "_" PROJECT_NAME ${PROJECT_NAME})
  #get_filename_component(FOLDER_NAME ./ DIRECTORY)
  #MESSAGE ("Folder Name: ${PROJECT_NAME}")

  # Return Lib name Value
  set ( ${out_name} ${PROJECT_NAME} PARENT_SCOPE)

  # Project Name
  SET( BIN_NAME ${PROJECT_NAME} )
  PROJECT( ${BIN_NAME} )

  MESSAGE ( CHECK_START "")
  MESSAGE ( CHECK_START "Adding Module ...")
  MESSAGE ( CHECK_START "${PROJECT_NAME} Module")
  MESSAGE ( CHECK_START "CURRENT: ${CMAKE_CURRENT_SOURCE_DIR}")
  MESSAGE ( CHECK_START "BIN_NAME: ${BIN_NAME}")
  MESSAGE ( CHECK_START "BIN_DIR: ${BIN_DIR}")

  SET( CMAKE_BINARY_DIR ${BIN_DIR} )

  # Souce Files
  FILE( GLOB_RECURSE SRC_FILES ./*.cpp  )
  FILE( GLOB_RECURSE HDR_FILES ./*.h )

  if (DEFINED INCLUDE_BOOST)
    if (WIN32)
      set(BOOST_ROOT ${BOOST_PATH} CACHE PATH "set BOOST_ROOT")
      set(Boost_INCLUDE_DIR ${BOOST_PATH})
      set(Boost_LIBRARY_DIRS ${BOOST_PATH}/libs)
    endif()

    set(Boost_USE_STATIC_LIBS OFF) 
    set(Boost_USE_MULTITHREADED ON)  
    set(Boost_USE_STATIC_RUNTIME OFF) 
    set(Boost_NO_WARN_NEW_VERSIONS OFF CACHE BOOL "")
  endif ()

  message(CHECK_START "Module ${BIN_NAME}: include dir: ${SCC_INCLUDE_DIR}")
  include_directories(${SCC_INCLUDE_DIR})

  if (DEFINED INCLUDE_BOOST)
    if (WIN32)
      include_directories(${BOOST_PATH})
    else ()
      find_package(Boost COMPONENTS system filesystem unit_test_framework REQUIRED)
      include_directories(${Boost_INCLUDE_DIR})
      link_directories(${Boost_LIBRARY_DIR})
    endif ()
  endif ()

  add_executable (${BIN_NAME}  ${SRC_FILES} ${HDR_FILES}) 

  IF (UNIX)
    MESSAGE("Linux Detected")
    find_package (Threads)
    target_link_libraries (${BIN_NAME} 
              ${CMAKE_THREAD_LIBS_INIT} 
    )
    if (DEFINED INCLUDE_BOOST)
      target_link_libraries (${BIN_NAME} 
              ${Boost_FILESYSTEM_LIBRARY} 
              ${Boost_SYSTEM_LIBRARY}
              ${Boost_UNIT_TEST_FRAMEWORK_LIBRARY}
              ${Boost_LIBRARIES}
      )
    endif ()
  ENDIF ()

  IF ( DEFINED UTF_SHARED)
    add_definitions(-DUTF_SHARED=${UTF_SHARED})
  ENDIF ()

  # Compiler Flags
  if (WIN32)
    if (CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
      # using Visual Studio C++
      message ( CHECK_START "Visual Studio compiler found")
      add_definitions(-D_WIN32_WINNT=0x0601)
    endif()
  else ()
    if (CMAKE_CXX_COMPILER_ID MATCHES "Clang" OR CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
      # using Clang
      message(STATUS "Clang compiler version: ${CLANG_VERSION}")
      target_compile_options(${BIN_NAME} PRIVATE -Wall
      -Wextra
      -Wpedantic
      -Werror
          -Wno-unused-function
          #-Wno-reserved-id-macro
          -Wno-unused-macros
          -Wno-overloaded-virtual
      )
    elseif (CMAKE_CXX_COMPILER_ID STREQUAL "Intel")
      # using Intel C++
    endif()
  endif()

  MESSAGE ( CHECK_START "Finished Module  ${PROJECT_NAME}")
endfunction()

