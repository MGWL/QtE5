#-------------------------------------------------
#
# Project created by QtCreator 2018-01-19T08:26:58
#
#-------------------------------------------------

QT += widgets
# CONFIG  += qscintilla2

TEMPLATE = lib
TARGET = QtE5Qscintilla
INCLUDEPATH += Qt4Qt5
LIBS += -L"$$_PRO_FILE_PWD_" -lqscintilla2_qt5

DEFINES += QTE5QSCINTILLA_LIBRARY
# The following define makes your compiler emit warnings if you use
# any feature of Qt which has been marked as deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS
# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        qte5Qsci.cpp

HEADERS += \
        qte5Qsci.h \
        qte5Qsci_global.h  

unix {
    target.path = /usr/lib
    INSTALLS += target
}
