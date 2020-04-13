        IF(CROSS)
                SET(WINDRES ${CMAKE_RC_COMPILER})
        ELSE(CROSS)
                SET(WINDRES windres.exe)
        ENDIF(CROSS)
include(admTimeStamp)
#
MACRO(WINDRESIFY input icon src lib)
        # add icon and version info
        SET(FILEVERSION_STRING "${AVIDEMUX_VERSION}")
        SET(PRODUCTVERSION_STRING "${AVIDEMUX_VERSION}")
        STRING(REPLACE "." "," FILEVERSION ${FILEVERSION_STRING})
        STRING(REPLACE "." "," PRODUCTVERSION ${PRODUCTVERSION_STRING})
        ADM_TIMESTAMP(date)
        SET(PRODUCTVERSION "${PRODUCTVERSION},${date}")
        SET(FILEVERSION "${FILEVERSION},${date}")

        IF (ADM_CPU_X86_64)
	        SET(WIN_RES_TARGET "pe-x86-64")
        ELSE (ADM_CPU_X86_64)
	        SET(WIN_RES_TARGET "pe-i386")
        ENDIF (ADM_CPU_X86_64)

        #SET(AVIDEMUX_ICON "adm.ico")
        #SET(FULL_PATH "${CMAKE_CURRENT_SOURCE_DIR}//avidemux/common/xpm/${AVIDEMUX_ICON}")
        # Convert to native absolute path
        SET(FULL_PATH "${icon}")
        get_filename_component(abs "${FULL_PATH}" ABSOLUTE)
        file(TO_NATIVE_PATH ${abs} ICON_PATH)
        # replace c:\foo by c:\\foo
        STRING(REPLACE "\\" "\\\\" ICON_PATH ${ICON_PATH})
        
        CONFIGURE_FILE(${input} ${CMAKE_CURRENT_BINARY_DIR}/admWin.rc IMMEDIATE)

        # Hack : We use mingw windres rather than visual one, the latest does not work for some reasons
        if (MINGW)
	        SET(ADM_WIN_RES "adm.obj")
	        SET( ${src} ${ADM_WIN_RES})
	        ADD_CUSTOM_COMMAND(OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/${ADM_WIN_RES} COMMAND ${WINDRES} -F ${WIN_RES_TARGET} -i ${CMAKE_CURRENT_BINARY_DIR}/admWin.rc -o ${CMAKE_CURRENT_BINARY_DIR}/${ADM_WIN_RES} -O coff --define VS_VERSION_INFO=1)
        else (MINGW) # MSVC
        	SET(ADM_WIN_RES "adm.res")
	        SET(${lib} ${CMAKE_CURRENT_BINARY_DIR}/${ADM_WIN_RES} )
	        ADD_CUSTOM_COMMAND(OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/${ADM_WIN_RES} COMMAND ${WINDRES} -F ${WIN_RES_TARGET} -i ${CMAKE_CURRENT_BINARY_DIR}/admWin.rc -o ${CMAKE_CURRENT_BINARY_DIR}/${ADM_WIN_RES} -O res --define VS_VERSION_INFO=1 --preprocessor=gccwr.exe --preprocessor-arg="-E" --preprocessor-arg="-xc-header" --preprocessor-arg="-DRC_INVOKED" )            
        endif (MINGW)
ENDMACRO(WINDRESIFY input icon src lib)
