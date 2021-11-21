# Попытка получить единый РАСШИРЕННЫЙ файл для 5 версии QtE56Widgets

equals(QT_MAJOR_VERSION, 5): QT += core
equals(QT_MAJOR_VERSION, 6): QT += core

TEMPLATE = lib
linux:!macx {
	TARGET   = QtE56core64
}
win32:equals(QT_MAJOR_VERSION, 6) {
    TARGET   = QtE56core64
}
win32:equals(QT_MAJOR_VERSION, 5) {
    TARGET   = QtE56core32
}
CONFIG  += c++11

DEFINES += QTE56WIDGETS_LIBRARY

SOURCES += qte56core.cpp

HEADERS += qte56core.h

