cmake_minimum_required(VERSION 2.8)

config_exe_target(${CMAKE_CURRENT_SOURCE_DIR} BIN_NAME)

GetDirName(${CMAKE_CURRENT_SOURCE_DIR} PARENT_DIR)
SUBDIRLIST( ${PARENT_DIR}/libs SUBDIRS )
#message ( STATUS "Subdirs: ${SUBDIRS}")
#target_include_directories(${BIN_NAME} PRIVATE ${PARENT_DIR}/libs)

set (LIBS_TARGET "")
FOREACH(subdir ${SUBDIRS})
    #ADD_SUBDIRECTORY(${subdir})
    MESSAGE (CHECK_START "Adding Include to: ${subdir}")
    #target_include_directories(${BIN_NAME} PRIVATE ${PARENT_DIR}/libs/${subdir})
	#target_link_libraries (${BIN_NAME} ${subdir})
	list (APPEND LIBS_TARGET ${subdir})
ENDFOREACH()

message ( CHECK_START "Target List: ${LIBS_TARGET}" )
target_link_libraries ( ${BIN_NAME} ${LIBS_TARGET} )
#target_include_directories(${BIN_NAME} PRIVATE )

MESSAGE ( CHECK_START "Exe Target: ${BIN_NAME}")
