
QT += quick

CONFIG += c++20

HEADERS += \
    configs_manager.h \
    ensemble.h

SOURCES += \
    main.cpp

RESOURCES += qml.qrc

DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000

include(qt_version.pri)

include(desktop_environment.pri)

