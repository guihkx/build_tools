function(deploy_init)
    set(X_PROJECT_ARCH "x86")
    message(STATUS CMAKE_SYSTEM_PROCESSOR: ${CMAKE_SYSTEM_PROCESSOR})
    if ("${CMAKE_SYSTEM_PROCESSOR}" STREQUAL "x86_64")
        set(X_PROJECT_ARCH "amd64")
    endif()

    if (WIN32)
        if ("${CMAKE_SYSTEM_PROCESSOR}" STREQUAL "x86_64")
            set(X_PROJECT_OSNAME "win64")
        else()
            set(X_PROJECT_OSNAME "win32")
        endif()

        if(MSVC)
            if(${MSVC_VERSION} EQUAL 1800)
                set(X_PROJECT_OSNAME "winxp")
            endif()
        endif()
    endif()
    if (CMAKE_SYSTEM_NAME MATCHES "Linux")
        execute_process (
            COMMAND bash -c ". /etc/os-release; echo -n $NAME"
            OUTPUT_VARIABLE X_OS_NAME
        )
        execute_process (
            COMMAND bash -c ". /etc/os-release; echo -n $VERSION_ID"
            OUTPUT_VARIABLE X_OS_VERSION
        )

        set(X_PROJECT_OSNAME ${X_OS_NAME}_${X_OS_VERSION})
        message(STATUS X_OS_NAME: ${X_OS_NAME})
        message(STATUS X_OS_VERSION: ${X_OS_VERSION})
        message(STATUS X_PROJECT_OSNAME: ${X_PROJECT_OSNAME})

        if (EXISTS "/etc/debian_version")
            file (STRINGS "/etc/debian_version" X_DEBIAN_VERSION)
            message(STATUS "X_DEBIAN_VERSION: ${X_DEBIAN_VERSION}")
            if (X_DEBIAN_VERSION MATCHES "squeeze")
                set(X_DEBIAN_VERSION "6")
            elseif (X_DEBIAN_VERSION MATCHES "squeeze")
                set(X_DEBIAN_VERSION "7")
            elseif (X_DEBIAN_VERSION MATCHES "squeeze")
                set(X_DEBIAN_VERSION "8")
            elseif (X_DEBIAN_VERSION MATCHES "squeeze")
                set(X_DEBIAN_VERSION "9")
            elseif (X_DEBIAN_VERSION MATCHES "squeeze")
                set(X_DEBIAN_VERSION "10")
            elseif (X_DEBIAN_VERSION MATCHES "squeeze")
                set(X_DEBIAN_VERSION "11")
            elseif (X_DEBIAN_VERSION MATCHES "bookworm")
                set(X_DEBIAN_VERSION "12")
            else()
                set(X_DEBIAN_VERSION "11")
            endif()

            set(X_DEBIAN_VERSION ${X_DEBIAN_VERSION})

            message(STATUS "X_DEBIAN_VERSION: ${X_DEBIAN_VERSION}")
            message(STATUS "CMAKE_SYSTEM_NAME: ${CMAKE_SYSTEM_NAME}")
        endif()
    endif()

    if(APPLE)
        set (CMAKE_OSX_ARCHITECTURES x86_64) # TODO
        add_compile_options(-Wno-deprecated-declarations)
        add_compile_options(-Wno-switch)
    endif()

    #set(CPACK_SOURCE_GENERATOR "ZIP")
    set(CPACK_INCLUDE_TOPLEVEL_DIRECTORY OFF)
    set(CPACK_OUTPUT_FILE_PREFIX packages)
    set(CPACK_RESOURCE_FILE_LICENSE "${PROJECT_SOURCE_DIR}/../LICENSE")
    set(CPACK_RESOURCE_FILE_README "${PROJECT_SOURCE_DIR}/../README.md")
    file (STRINGS "${PROJECT_SOURCE_DIR}/../release_version.txt" CPACK_PACKAGE_VERSION)
    set(CPACK_PACKAGE_NAME ${X_PROJECTNAME})
    set(CPACK_PACKAGE_INSTALL_DIRECTORY ${X_PROJECTNAME})
    set(CPACK_PACKAGE_INSTALL_REGISTRY_KEY ${X_PROJECTNAME})
    set(CPACK_PACKAGE_VENDOR ${X_COMPANYNAME})
    set(CPACK_PACKAGE_DESCRIPTION ${X_DESCRIPTION})
    set(CPACK_PACKAGE_HOMEPAGE_URL ${X_HOMEPAGE})

    if (CMAKE_SYSTEM_NAME MATCHES "Linux")
        set(CPACK_DEBIAN_PACKAGE_MAINTAINER ${X_MAINTAINER})
        set(CPACK_PACKAGE_FILE_NAME "${CPACK_PACKAGE_NAME}_${CPACK_PACKAGE_VERSION}_${X_PROJECT_OSNAME}_${X_PROJECT_ARCH}")
        message(STATUS CPACK_DEBIAN_PACKAGE_NAME: ${CPACK_DEBIAN_PACKAGE_NAME})
    endif()

    if (WIN32)
        set(CPACK_PACKAGE_FILE_NAME "${CPACK_PACKAGE_NAME}_${X_PROJECT_OSNAME}_portable_${CPACK_PACKAGE_VERSION}")
    endif()

    if (CMAKE_SYSTEM_NAME MATCHES "Linux")
        # Qt5
        if (NOT "${Qt5Core_VERSION}" STREQUAL "")
            if (X_DEBIAN_VERSION LESS 11)
                list(APPEND X_DEBIAN_PACKAGE_DEPENDS "qt5-default")
            endif()
            list(APPEND X_DEBIAN_PACKAGE_DEPENDS "libqt5core5a")
            list(APPEND X_DEBIAN_PACKAGE_DEPENDS "libqt5dbus5") # TODO Check
        endif()
        if (NOT "${Qt5Gui_VERSION}" STREQUAL "")
            list(APPEND X_DEBIAN_PACKAGE_DEPENDS "libqt5gui5")
        endif()
        if (NOT "${Qt5Widgets_VERSION}" STREQUAL "")
            list(APPEND X_DEBIAN_PACKAGE_DEPENDS "libqt5widgets5")
        endif()
        if (NOT "${Qt5Svg_VERSION}" STREQUAL "")
            list(APPEND X_DEBIAN_PACKAGE_DEPENDS "libqt5svg5")
        endif()
        if (NOT "${Qt5Sql_VERSION}" STREQUAL "")
            list(APPEND X_DEBIAN_PACKAGE_DEPENDS "libqt5sql5")
        endif()
        if (NOT "${Qt5OpenGL_VERSION}" STREQUAL "")
            list(APPEND X_DEBIAN_PACKAGE_DEPENDS "libqt5opengl5")
        endif()
        if (NOT "${Qt5Network_VERSION}" STREQUAL "")
            list(APPEND X_DEBIAN_PACKAGE_DEPENDS "libqt5network5")
        endif()
        if (NOT "${Qt5Script_VERSION}" STREQUAL "")
            list(APPEND X_DEBIAN_PACKAGE_DEPENDS "libqt5script5")
        endif()
        if (NOT "${Qt5ScriptTools_VERSION}" STREQUAL "")
            list(APPEND X_DEBIAN_PACKAGE_DEPENDS "libqt5scripttools5")
        endif()
        # Qt6
        if (NOT "${Qt6Core_VERSION}" STREQUAL "")
            list(APPEND X_DEBIAN_PACKAGE_DEPENDS "libqt6core6")
        endif()
        if (NOT "${Qt6Gui_VERSION}" STREQUAL "")
            list(APPEND X_DEBIAN_PACKAGE_DEPENDS "libqt6gui6")
        endif()
        if (NOT "${Qt6Widgets_VERSION}" STREQUAL "")
            list(APPEND X_DEBIAN_PACKAGE_DEPENDS "libqt6widgets6")
        endif()
        if (NOT "${Qt6Sql_VERSION}" STREQUAL "")
            list(APPEND X_DEBIAN_PACKAGE_DEPENDS "libqt6sql6")
        endif()
        if (NOT "${Qt6Network_VERSION}" STREQUAL "")
            list(APPEND X_DEBIAN_PACKAGE_DEPENDS "libqt6network6")
        endif()

        string(REPLACE ";" ", " CPACK_DEBIAN_PACKAGE_DEPENDS "${X_DEBIAN_PACKAGE_DEPENDS}")
        message(STATUS CPACK_DEBIAN_PACKAGE_DEPENDS: ${CPACK_DEBIAN_PACKAGE_DEPENDS})
    endif()

    include(CPack)

    if(WIN32)
        configure_file("${PROJECT_SOURCE_DIR}/../res/resource.rc.in" "${PROJECT_SOURCE_DIR}/../res/resource.rc" @ONLY)
    endif()
#    get_cmake_property(_variableNames VARIABLES)
#    list (SORT _variableNames)
#    foreach (_variableName ${_variableNames})
#        message(STATUS "${_variableName}=${${_variableName}}")
#    endforeach()
endfunction()

function(deploy_msvc)
    message(STATUS ${MSVC_TOOLSET_VERSION})
    if(MSVC)
        if(${MSVC_TOOLSET_VERSION} GREATER_EQUAL 142)
            set(VC_REDIST_DIR $ENV{VCToolsRedistDir}$ENV{Platform}/Microsoft.VC${MSVC_TOOLSET_VERSION}.CRT)
            string(REPLACE "\\" "/" VC_REDIST_DIR ${VC_REDIST_DIR})
            message(STATUS ${VC_REDIST_DIR})

            install (FILES "${VC_REDIST_DIR}/msvcp140.dll" DESTINATION "./" OPTIONAL)
            install (FILES "${VC_REDIST_DIR}/msvcp140_1.dll" DESTINATION "./" OPTIONAL)
            #install (FILES "${VC_REDIST_DIR}/msvcp140_2.dll" DESTINATION "./" OPTIONAL)
            install (FILES "${VC_REDIST_DIR}/vcruntime140.dll" DESTINATION "./"  OPTIONAL)
            install (FILES "${VC_REDIST_DIR}/vcruntime140_1.dll" DESTINATION "./" OPTIONAL)
        endif()
    endif()
endfunction()

function(deploy_qt)
    message(STATUS qt_version_${QT_VERSION_MAJOR})
    if (WIN32)
        string(REPLACE "\\" "/" CMAKE_PREFIX_PATH ${CMAKE_PREFIX_PATH})
        # Qt5
        if (NOT "${Qt5Core_VERSION}" STREQUAL "")
            install (FILES "${CMAKE_PREFIX_PATH}/bin/Qt5Core.dll" DESTINATION "./" OPTIONAL)
        endif()
        if (NOT "${Qt5Gui_VERSION}" STREQUAL "")
            install (FILES "${CMAKE_PREFIX_PATH}/bin/Qt5Gui.dll" DESTINATION "./" OPTIONAL)
            install (FILES "${CMAKE_PREFIX_PATH}/plugins/platforms/qwindows.dll" DESTINATION platforms OPTIONAL)
            install (FILES "${CMAKE_PREFIX_PATH}/plugins/imageformats/qjpeg.dll" DESTINATION imageformats OPTIONAL)
            install (FILES "${CMAKE_PREFIX_PATH}/plugins/imageformats/qtiff.dll" DESTINATION imageformats OPTIONAL)
            install (FILES "${CMAKE_PREFIX_PATH}/plugins/imageformats/qico.dll" DESTINATION imageformats OPTIONAL)
            install (FILES "${CMAKE_PREFIX_PATH}/plugins/imageformats/qgif.dll" DESTINATION imageformats OPTIONAL)
        endif()
        if (NOT "${Qt5Widgets_VERSION}" STREQUAL "")
            install (FILES "${CMAKE_PREFIX_PATH}/bin/Qt5Widgets.dll" DESTINATION "./" OPTIONAL)
        endif()
        if (NOT "${Qt5OpenGL_VERSION}" STREQUAL "")
            install (FILES "${CMAKE_PREFIX_PATH}/bin/Qt5OpenGL.dll" DESTINATION "./" OPTIONAL)
        endif()
        if (NOT "${Qt5Svg_VERSION}" STREQUAL "")
            install (FILES "${CMAKE_PREFIX_PATH}/bin/Qt5Svg.dll" DESTINATION "./" OPTIONAL)
        endif()
        if (NOT "${Qt5Sql_VERSION}" STREQUAL "")
            install (FILES "${CMAKE_PREFIX_PATH}/bin/Qt5Sql.dll" DESTINATION "./" OPTIONAL)
            install (FILES "${CMAKE_PREFIX_PATH}/plugins/sqldrivers/qsqlite.dll" DESTINATION sqldrivers OPTIONAL)
        endif()
        if (NOT "${Qt5Network_VERSION}" STREQUAL "")
            install (FILES "${CMAKE_PREFIX_PATH}/bin/Qt5Network.dll" DESTINATION "./" OPTIONAL)
        endif()
        if (NOT "${Qt5Script_VERSION}" STREQUAL "")
            install (FILES "${CMAKE_PREFIX_PATH}/bin/Qt5Script.dll" DESTINATION "./" OPTIONAL)
        endif()
        if (NOT "${Qt5ScriptTools_VERSION}" STREQUAL "")
            install (FILES "${CMAKE_PREFIX_PATH}/bin/Qt5ScriptTools.dll" DESTINATION "./" OPTIONAL)
        endif()
        #Qt6
        if (NOT "${Qt6Core_VERSION}" STREQUAL "")
            install (FILES "${CMAKE_PREFIX_PATH}/bin/Qt6Core.dll" DESTINATION "./" OPTIONAL)
        endif()
        if (NOT "${Qt6Gui_VERSION}" STREQUAL "")
            install (FILES "${CMAKE_PREFIX_PATH}/bin/Qt6Gui.dll" DESTINATION "./" OPTIONAL)
            install (FILES "${CMAKE_PREFIX_PATH}/plugins/platforms/qwindows.dll" DESTINATION platforms OPTIONAL)
            install (FILES "${CMAKE_PREFIX_PATH}/plugins/imageformats/qjpeg.dll" DESTINATION imageformats OPTIONAL)
            install (FILES "${CMAKE_PREFIX_PATH}/plugins/imageformats/qsvg.dll" DESTINATION imageformats OPTIONAL)
            install (FILES "${CMAKE_PREFIX_PATH}/plugins/imageformats/qico.dll" DESTINATION imageformats OPTIONAL)
            install (FILES "${CMAKE_PREFIX_PATH}/plugins/imageformats/qgif.dll" DESTINATION imageformats OPTIONAL)
        endif()
        if (NOT "${Qt6Widgets_VERSION}" STREQUAL "")
            install (FILES "${CMAKE_PREFIX_PATH}/bin/Qt6Widgets.dll" DESTINATION "./" OPTIONAL)
        endif()
        if (NOT "${Qt6OpenGL_VERSION}" STREQUAL "")
            install (FILES "${CMAKE_PREFIX_PATH}/bin/Qt6OpenGL.dll" DESTINATION "./" OPTIONAL)
        endif()
        if (NOT "${Qt6Svg_VERSION}" STREQUAL "")
            install (FILES "${CMAKE_PREFIX_PATH}/bin/Qt6Svg.dll" DESTINATION "./" OPTIONAL)
        endif()
        if (NOT "${Qt6Sql_VERSION}" STREQUAL "")
            install (FILES "${CMAKE_PREFIX_PATH}/bin/Qt6Sql.dll" DESTINATION "./")
            install (FILES "${CMAKE_PREFIX_PATH}/plugins/sqldrivers/qsqlite.dll" DESTINATION sqldrivers OPTIONAL)
        endif()
        if (NOT "${Qt6Network_VERSION}" STREQUAL "")
            install (FILES "${CMAKE_PREFIX_PATH}/bin/Qt6Network.dll" DESTINATION "./" OPTIONAL)
        endif()
        if (NOT "${Qt6Qml_VERSION}" STREQUAL "")
            install (FILES "${CMAKE_PREFIX_PATH}/bin/Qt6Qml.dll" DESTINATION "./" OPTIONAL)
        endif()
    endif()
endfunction()
