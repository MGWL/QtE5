# Попытка получить единый РАСШИРЕННЫЙ файл для 5 версии QtE56Widgets

equals(QT_MAJOR_VERSION, 5): QT += widgets gui designer
equals(QT_MAJOR_VERSION, 6): QT += widgets gui core5compat designer

TEMPLATE = lib
linux:!macx {
	TARGET   = QtE56Widgets64
}
win32:equals(QT_MAJOR_VERSION, 6) {
    TARGET   = QtE56Widgets64
}
win32:equals(QT_MAJOR_VERSION, 5) {
    TARGET   = QtE56Widgets32
}
CONFIG  += c++11

DEFINES += QTE56WIDGETS_LIBRARY

SOURCES += qte56widgets.cpp

HEADERS += qte56widgets.h

