
QT += quick

CONFIG += c++20

HEADERS += \
    configs_manager.h \
    ensemble.h

SOURCES += \
    main.cpp

RESOURCES += qml.qrc

include(qt_version.pri)

include(desktop_environment.pri)

