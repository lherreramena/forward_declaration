

#message ( STATUS "Getting subdirs")
SUBDIRLIST( ${CMAKE_CURRENT_SOURCE_DIR} SUBDIRS )
#message ( STATUS "Subdirs: ${SUBDIRS}")
FOREACH(subdir ${SUBDIRS})
    message( STATUS "Adding Libraries under '${subdir}'...")
    ADD_SUBDIRECTORY(${subdir})
ENDFOREACH()

