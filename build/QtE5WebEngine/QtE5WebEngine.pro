#-------------------------------------------------
#
# Project created by QtCreator 2018-01-29T13:38:02
#
#-------------------------------------------------

QT       += core gui webenginewidgets

TARGET = QtE5WebEngine
TEMPLATE = lib

DEFINES += QTE5WEBENGINE_LIBRARY

SOURCES += qte5webengine.cpp

HEADERS += qte5webengine.h\
        qte5webengine_global.h

unix {
    target.path = /usr/lib
    INSTALLS += target
}
