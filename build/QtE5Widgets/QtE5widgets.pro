#-------------------------------------------------
#
# Project created by QtCreator 2016-02-20T11:02:48
#
#-------------------------------------------------

QT       += widgets

TARGET = QtE5Widgets
TEMPLATE = lib

DEFINES += QTE5WIDGETS_LIBRARY

SOURCES += qte5widgets.cpp

HEADERS += qte5widgets.h\
        qte5widgets_global.h

unix {
    target.path = /usr/lib
    INSTALLS += target
}
