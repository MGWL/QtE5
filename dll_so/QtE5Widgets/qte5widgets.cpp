#include "qte5widgets.h"

#include <QApplication>

typedef int PTRINT;
typedef unsigned int PTRUINT;

typedef struct QApplication__ { PTRINT dummy; } *QApplicationH;

extern "C" QApplicationH qteQApplication_create1(int* argc, char *argv[], int AnParam3) {
    return (QApplicationH)new QApplication(*argc, argv, AnParam3);
}
extern "C" void qteQApplication_delete1(QApplicationH app) {
    delete (QApplication*)app;
}
extern "C" int qteQApplication_sizeof(QApplicationH app) {
    return sizeof(*(QApplication*)app);
}
