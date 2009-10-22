# - Find HDF5, a library for reading and writing self describing array data.
#
FIND_PATH(HDF5_INCLUDE_DIR hdf5.h)

FIND_LIBRARY(HDF5_CORE_LIBRARY NAMES hdf5 hdf5dll )
FIND_LIBRARY(HDF5_HL_LIBRARY NAMES hdf5_hl hdf5_hldll )

SET(HDF5_VERSION_MAJOR 1)
SET(HDF5_VERSION_MINOR 8)

set(HDF5_SUFFICIENT_VERSION FALSE)
set(HDF5_COMPILED FALSE)
TRY_RUN(HDF5_SUFFICIENT_VERSION HDF5_COMPILED
        ${CMAKE_BINARY_DIR} ${PROJECT_SOURCE_DIR}/config/checkHDF5version.c
        COMPILE_DEFINITIONS "-I${HDF5_INCLUDE_DIR} -DMIN_MAJOR=${HDF5_VERSION_MAJOR} -DMIN_MINOR=${HDF5_VERSION_MINOR}") 
        
if(HDF5_COMPILED AND ${HDF5_SUFFICIENT_VERSION} EQUAL 0)
    MESSAGE(STATUS 
           "Checking HDF5 version (at least ${HDF5_VERSION_MAJOR}.${HDF5_VERSION_MINOR}): ok")
    set(HDF5_SUFFICIENT_VERSION TRUE)
else()
    MESSAGE( STATUS "HDF5: need at least version ${HDF5_VERSION_MAJOR}.${HDF5_VERSION_MINOR}" )
    set(HDF5_SUFFICIENT_VERSION FALSE)
endif()

set(HDF5_USES_ZLIB FALSE)
set(HDF5_COMPILED FALSE)
TRY_RUN(HDF5_USES_ZLIB HDF5_COMPILED
        ${CMAKE_BINARY_DIR} ${PROJECT_SOURCE_DIR}/config/checkHDF5usesCompression.c
        COMPILE_DEFINITIONS "-I${HDF5_INCLUDE_DIR} -DH5_SOMETHING=H5_HAVE_FILTER_DEFLATE") 
        
if(HDF5_COMPILED AND ${HDF5_USES_ZLIB} EQUAL 0)
    FIND_LIBRARY(HDF5_Z_LIBRARY NAMES z zlib1 )
    set(HDF5_ZLIB_OK ${HDF5_Z_LIBRARY})
else()
    set(HDF5_ZLIB_OK TRUE)
    set(HDF5_Z_LIBRARY "")
endif()

set(HDF5_USES_SZLIB FALSE)
set(HDF5_COMPILED FALSE)
TRY_RUN(HDF5_USES_SZLIB HDF5_COMPILED
        ${CMAKE_BINARY_DIR} ${PROJECT_SOURCE_DIR}/config/checkHDF5usesCompression.c
        COMPILE_DEFINITIONS "-I${HDF5_INCLUDE_DIR} -DH5_SOMETHING=H5_HAVE_FILTER_SZIP") 
        
if(HDF5_COMPILED AND ${HDF5_USES_SZLIB} EQUAL 0)
    FIND_LIBRARY(HDF5_SZ_LIBRARY NAMES sz  szlibdll )
    set(HDF5_SZLIB_OK ${HDF5_SZ_LIBRARY})
else()
    set(HDF5_SZLIB_OK TRUE)
    set(HDF5_SZ_LIBRARY "")
endif()

# handle the QUIETLY and REQUIRED arguments and set HDF5_FOUND to TRUE if 
# all listed variables are TRUE
INCLUDE(FindPackageHandleStandardArgs)

FIND_PACKAGE_HANDLE_STANDARD_ARGS(HDF5 DEFAULT_MSG HDF5_CORE_LIBRARY 
        HDF5_HL_LIBRARY HDF5_ZLIB_OK HDF5_SZLIB_OK HDF5_INCLUDE_DIR HDF5_SUFFICIENT_VERSION)
        
IF(HDF5_FOUND)
    SET(HDF5_LIBRARIES ${HDF5_CORE_LIBRARY} ${HDF5_HL_LIBRARY} ${HDF5_Z_LIBRARY} ${HDF5_SZ_LIBRARY})
ELSE()
    SET(HDF5_CORE_LIBRARY HDF5_CORE_LIBRARY-NOTFOUND)
    SET(HDF5_HL_LIBRARY   HDF5_HL_LIBRARY-NOTFOUND)
    SET(HDF5_Z_LIBRARY    HDF5_Z_LIBRARY-NOTFOUND)
    SET(HDF5_SZ_LIBRARY   HDF5_SZ_LIBRARY-NOTFOUND)
ENDIF(HDF5_FOUND)
    
