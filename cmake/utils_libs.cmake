

#########################################################################################

function(config_lib_target in_path out_name)
  # External variables
  SET( SRC_ROOT ) 
  SET( CMAKE_BUILD_TYPE ) # "Debug" or "Release"

  #get_filename_component(FOLDER_NAME ./ DIRECTORY)
  #MESSAGE ("Folder Name: ${FOLDER_NAME}")
  get_filename_component(PROJECT_NAME ${in_path} NAME)
  string(REPLACE " " "_" PROJECT_NAME ${PROJECT_NAME})

  # Return Lib name Value
  set ( ${out_name} ${PROJECT_NAME} PARENT_SCOPE)

  # Project Name
  SET( LIB_NAME ${PROJECT_NAME} )
  SET ( LIB_DIR ${CMAKE_CURRENT_SOURCE_DIR})
  #PROJECT( ${LIB_NAME} )
  
  list (APPEND SCC_LIBRARIES ${LIB_NAME})
  list (APPEND SCC_INCLUDE_DIR ${CMAKE_CURRENT_SOURCE_DIR})

  MESSAGE ( CHECK_START "")
  MESSAGE ( CHECK_START "Adding Module ...")
  MESSAGE ( CHECK_START "${PROJECT_NAME} Module")
  MESSAGE ( CHECK_START "CURRENT: ${CMAKE_CURRENT_SOURCE_DIR}")
  MESSAGE ( CHECK_START "LIB_NAME: ${${out_name}}")
  MESSAGE ( CHECK_START "LIB_DIR: ${LIB_DIR}")
  message(CHECK_START "Module ${LIB_NAME}: include dir: ${SCC_INCLUDE_DIR}")

  #SET( CMAKE_BINARY_DIR ${BIN_DIR} )

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


    if (WIN32)
      include_directories(${BOOST_PATH})
    else ()
      find_package(Boost COMPONENTS system filesystem unit_test_framework REQUIRED)
      include_directories(${Boost_INCLUDE_DIR})
      link_directories(${Boost_LIBRARY_DIR})
    endif ()
  endif ()

  add_library (${LIB_NAME} SHARED ${SRC_FILES} ${HDR_FILES}) 

  target_include_directories(${LIB_NAME} PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})

  IF (UNIX)
    MESSAGE("Linux Detected")
    find_package (Threads)
    target_link_libraries (${LIB_NAME} 
              ${CMAKE_THREAD_LIBS_INIT} 
    )
    if (DEFINED INCLUDE_BOOST)
      target_link_libraries (${LIB_NAME} 
              ${Boost_FILESYSTEM_LIBRARY} 
              ${Boost_SYSTEM_LIBRARY}
              ${Boost_UNIT_TEST_FRAMEWORK_LIBRARY}
              ${Boost_LIBRARIES}
      )
    endif ()
  ENDIF ()

  #IF (UNIX)
  #  MESSAGE("Linux Detected")
  #  find_package (Threads)
  #  target_link_libraries (${LIB_NAME}_test 
  #            ${CMAKE_THREAD_LIBS_INIT} 
  #            ${Boost_FILESYSTEM_LIBRARY} 
  #            ${Boost_SYSTEM_LIBRARY}
  #            ${Boost_UNIT_TEST_FRAMEWORK_LIBRARY}
  #            ${Boost_LIBRARIES}
  #  )
  #ENDIF ()

  IF ( DEFINED UTF_SHARED)
    add_definitions(-DUTF_SHARED=${UTF_SHARED})
  ENDIF ()

  # Compiler Flags
  if (WIN32)
    set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS ON)
    if (CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
      # using Visual Studio C++
      message ( CHECK_START "Visual Studio compiler found")
      add_definitions(-D_WIN32_WINNT=0x0601)
    endif()
  else ()
    if (CMAKE_CXX_COMPILER_ID MATCHES "Clang" OR CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
      # using Clang
      message(STATUS "Clang compiler version: ${CLANG_VERSION}")
      target_compile_options(${LIB_NAME} PRIVATE -Wall
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

  MESSAGE ( CHECK_START "Finished Module ${PROJECT_NAME}")
endfunction()