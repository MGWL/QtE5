// For MSVC set __declspec(dllexport), for MinGW do not
#ifdef _MSC_VER
    #define MSVC_API __declspec(dllexport)
#else
    #define MSVC_API
#endif

#include "qte56core.h"
#include "stdio.h"

typedef int PTRINT;
typedef struct QtRef__ { PTRINT dummy; } *QtRefH;
// ===================== QSize ====================
// 1056
extern "C" MSVC_API  QtRefH qteQSize_create1(int x, int y) { return (QtRefH)(new QSize(x, y)); }
// 1057
extern "C" MSVC_API  void qteQSize_delete1(QSize* wd) {    delete wd; }
// 1058
extern "C" MSVC_API int QSize_setXX2(QSize* wd, int arg, int pr) {
int rez = 0;
    switch ( pr ) {
        case 0:   rez = wd->height();         break;  // int|height|
        case 1:   rez = (int)wd->isEmpty();   break;  // bool|isEmpty|
        case 2:   rez = (int)wd->isNull();    break;  // bool|isNull|
        case 3:   rez = (int)wd->isValid();   break;  // bool|isValid|
        case 4:   wd->setHeight(arg);         break;  // void|setHeight|int%height
        case 5:   wd->setWidth(arg);          break;  // void|setWidth|int%width
        case 6:   wd->transpose();            break;  // void|transpose|
        case 7:   rez = wd->width();          break;  // int|width|
    }
    return rez;
}
// ===================== QPoint ====================
// 1306
extern "C" MSVC_API  QtRefH qteQPoint_create1(int x, int y) {
    return (QtRefH)(new QPoint(x, y));
}
// 1307
extern "C" MSVC_API  void qteQPoint_delete1(QPoint* wd) {
    delete wd;
}
// 1308
extern "C" MSVC_API int QPoint_setXX1(QPoint* wd, int arg, int pr) {
int rez = 0;
    switch ( pr ) {
        case 0:   rez = (int)wd->isNull();   break;  // bool|isNull|
        case 1:   rez = wd->manhattanLength();   break;  // int|manhattanLength|
        case 2:   wd->setX(arg);   break;  // void|setX|int%x
        case 3:   wd->setY(arg);   break;  // void|setY|int%y
        case 4:   rez = wd->x();   break;  // int|x|
        case 5:   rez = wd->y();   break;  // int|y|
    }
    return rez;
}
// 1309
extern "C" MSVC_API int QPoint_setXX3(QPoint* wd, QPoint* arg, int pr) {
int rez = 0;
    switch ( pr ) {
        case 0:   (*wd) += (*arg);   break;
        case 1:   (*wd) -= (*arg);   break;
    }
    return rez;
}

// =========== QRect ==========
extern "C" MSVC_API  QtRefH qteQRect_create1() {
	QtRefH q = (QtRefH)(new QRect());
    return  q;
}
extern "C" MSVC_API  void qteQRect_delete(QRect* wd) {
    delete wd;
}
extern "C" MSVC_API  QtRefH qteQRect_create2(int x, int y, int width, int height) {
    return  (QtRefH)(new QRect(x, y, width, height));
}
// Нет слотов, значит можно не обертывать

// 234
extern "C" MSVC_API int QRect_setXX1(QRect* wd, int arg, int pr) {
int rez = 0;
    switch ( pr ) {
        case 0:    rez = wd->bottom();   				break;  // int|bottom|
        case 1:    rez = wd->height();   				break;  // int|height|
        case 2:    rez = (int)wd->isEmpty();   			break;  // bool|isEmpty|
        case 3:    rez = (int)wd->isNull();   			break;  // bool|isNull|
        case 4:    rez = (int)wd->isValid();   			break;  // bool|isValid|
        case 5:    rez = wd->left();   					break;  // int|left|
        case 6:    wd->moveBottom(arg);   				break;  // void|moveBottom|int%y
        case 7:    wd->moveLeft(arg);  					break;  // void|moveLeft|int%x
        case 8:    wd->moveRight(arg);   				break;  // void|moveRight|int%x
        case 9:    wd->moveTop(arg);   					break;  // void|moveTop|int%y
        case 10:   rez = wd->right();   				break;  // int|right|
        case 11:   wd->setBottom(arg);   				break;  // void|setBottom|int%y
        case 12:   wd->setHeight(arg);   				break;  // void|setHeight|int%height
        case 13:   wd->setLeft(arg);   					break;  // void|setLeft|int%x
        case 14:   wd->setRight(arg);   				break;  // void|setRight|int%x
        case 15:   wd->setTop(arg);   					break;  // void|setTop|int%y
        case 16:   wd->setWidth(arg);   				break;  // void|setWidth|int%width
        case 17:   wd->setX(arg);   					break;  // void|setX|int%x
        case 18:   wd->setY(arg);   					break;  // void|setY|int%y
        case 19:   rez = wd->top();   					break;  // int|top|
        case 20:   rez = wd->width();   				break;  // int|width|
        case 21:   rez = wd->x();   					break;  // int|x|
        case 22:   rez = wd->y();   					break;  // int|y|
    }
    return rez;
}
extern "C" MSVC_API  void qteQRect_setXX2(QRect* wd, int x1, int y1, int x2, int y2, int pr) {
    switch ( pr ) {
    case 0:   wd->setCoords(x1, y1, x2, y2);            break;
    case 1:   wd->setRect(x1, y1, x2, y2);              break;
    }
}

// 242
extern "C" MSVC_API int QRect_setXX2(QRect* wd, int arg1, int arg2, int pr) {
	int rez = 0;
    switch ( pr ) {
        case 0:    rez = (int)wd->contains(arg1, arg2); break;  // bool|contains|int%x|int%y
        case 1:    wd->moveTo(arg1, arg2);              break;  // void|moveTo|int%x|int%y
        case 2:    wd->translate(arg1, arg2);           break;  // void|translate|int%dx|int%dy
    }
    return rez;
}

// 381
extern "C" MSVC_API int qteQObject_setName(QObject* wd, int arg, QString* qsOut, QString* qsIn, int pr) {
	int rez = 0;
	if(arg) {}
    switch ( pr ) {
        case 0:   *qsOut = wd->objectName();   break;  // QString|objectName|
        case 1:   wd->setObjectName(*qsIn);    break;  // void|setObjectName|QString%name
    }
    return rez;
}

// 382
extern "C" MSVC_API int QCoreApplication_setXX3(QCoreApplication* wd, int arg, QString* qsOut, QString* qsIn, int pr) {
    int rez = 0;
	if(arg) {}
    switch ( pr ) {
        case 0:    wd->addLibraryPath(*qsIn);           break;  // void|addLibraryPath|QString%path
        case 1:    *qsOut = wd->applicationDirPath();   break;  // QString|applicationDirPath|
        case 2:    *qsOut = wd->applicationFilePath();  break;  // QString|applicationFilePath|
        case 3:    *qsOut = wd->applicationName();      break;  // QString|applicationName|
        case 4:    *qsOut = wd->applicationVersion();   break;  // QString|applicationVersion|
        case 5:    *qsOut = wd->organizationDomain();   break;  // QString|organizationDomain|
        case 6:    *qsOut = wd->organizationName();     break;  // QString|organizationName|
        case 7:    wd->removeLibraryPath(*qsIn);        break;  // void|removeLibraryPath|QString%path
        case 8:    wd->setApplicationName(*qsIn);       break;  // void|setApplicationName|QString%application
        case 9:    wd->setApplicationVersion(*qsIn);    break;  // void|setApplicationVersion|QString%version
        case 10:   wd->setOrganizationDomain(*qsIn);    break;  // void|setOrganizationDomain|QString%orgDomain
        case 11:   wd->setOrganizationName(*qsIn);      break;  // void|setOrganizationName|QString%orgName
    }
    return rez;
}
