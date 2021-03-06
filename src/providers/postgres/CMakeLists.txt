########################################################
# Files

SET(PG_SRCS
  qgspostgresprovider.cpp
  qgspostgresconn.cpp
  qgspostgresconnpool.cpp
  qgspostgresdataitems.cpp
  qgspostgresfeatureiterator.cpp
  qgspostgrestransaction.cpp
  qgspgsourceselect.cpp
  qgspgnewconnection.cpp
  qgspgtablemodel.cpp
  qgscolumntypethread.cpp
  qgspostgresexpressioncompiler.cpp
)

SET(PG_MOC_HDRS
  qgscolumntypethread.h
  qgspgnewconnection.h
  qgspgsourceselect.h
  qgspgtablemodel.h
  qgspostgresconn.h
  qgspostgresconnpool.h
  qgspostgresdataitems.h
  qgspostgresprovider.h
  qgspostgrestransaction.h

)

SET(PG_HDRS
  qgspostgresexpressioncompiler.h
)

########################################################
# Build

QT5_WRAP_CPP(PG_MOC_SRCS ${PG_MOC_HDRS})

INCLUDE_DIRECTORIES(
  ../../core
  ../../core/auth
  ../../core/geometry
  ${CMAKE_BINARY_DIR}/src/core
  ${CMAKE_BINARY_DIR}/src/gui
)
INCLUDE_DIRECTORIES(SYSTEM
  ${POSTGRES_INCLUDE_DIR}
  ${GEOS_INCLUDE_DIR}
  ${QSCINTILLA_INCLUDE_DIR}
  ${QCA_INCLUDE_DIR}
  ${QTKEYCHAIN_INCLUDE_DIR}
)
INCLUDE_DIRECTORIES(
  ../../core
  ../../gui
  ../../gui/auth
  ../../ui
  ${CMAKE_CURRENT_BINARY_DIR}/../../ui
)

ADD_LIBRARY (postgresprovider_a STATIC ${PG_SRCS} ${PG_HDRS} ${PG_MOC_SRCS})
ADD_LIBRARY (postgresprovider MODULE ${PG_SRCS} ${PG_HDRS} ${PG_MOC_SRCS})

TARGET_LINK_LIBRARIES (postgresprovider_a
  ${POSTGRES_LIBRARY}
  qgis_core
  qgis_gui
)
TARGET_LINK_LIBRARIES (postgresprovider
  ${POSTGRES_LIBRARY}
  qgis_core
  qgis_gui
)

# clang-tidy
IF(CLANG_TIDY_EXE)
  SET_TARGET_PROPERTIES(
    postgresprovider PROPERTIES
    CXX_CLANG_TIDY "${DO_CLANG_TIDY}"
  )
ENDIF(CLANG_TIDY_EXE)

########################################################
# Install

INSTALL(TARGETS postgresprovider
  RUNTIME DESTINATION ${QGIS_PLUGIN_DIR}
  LIBRARY DESTINATION ${QGIS_PLUGIN_DIR})
