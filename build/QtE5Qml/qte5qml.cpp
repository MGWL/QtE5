#include "qte5qml.h"

// For MSVC set __declspec(dllexport), for MinGW do not
#ifdef _MSC_VER
    #define MSVC_API __declspec(dllexport)
#else
    #define MSVC_API
#endif

// ===================== QJSEngine ====================
// 454
extern "C" MSVC_API QJSEngine* QJSEngine_create1(QObject* parent) {
    return new QJSEngine(parent);
}
// 455
extern "C" MSVC_API void QJSEngine_delete1(QJSEngine* wd) {
    if(wd->parent() == NULL) delete wd;
}
// 458
extern "C" MSVC_API void QJSEngine_evaluate(QJSEngine* wd, QString* qs, QString* qfile, int lineNumer) {
    if(!qfile) {
        if(lineNumer == 1)  wd->evaluate(*qs);
    }
}

// ===================== QQmlEngine ====================
// 456
extern "C" MSVC_API QQmlEngine* QQmlEngine_create1(QObject* parent) {
    return new QQmlEngine(parent);
}
// 457
extern "C" MSVC_API void QQmlEngine_delete1(QQmlEngine* wd) {
    if(wd->parent() == NULL) delete wd;
}

// ===================== QQmlApplicationEngine ====================
// 451
extern "C" MSVC_API QQmlApplicationEngine* QQmlApplicationEngine_create1(QObject* parent) {
    return new QQmlApplicationEngine(parent);
}
// 452
extern "C" MSVC_API void QQmlApplicationEngine_delete1(QQmlApplicationEngine* wd) {
    if(wd->parent() == NULL) delete wd;
}
// 453
extern "C" MSVC_API void QQmlApplicationEngine_load1(QQmlApplicationEngine* wd, QString* qs) {
    wd->load(*qs);
}
// 459 - эксперементальный метод
// ________________________________
extern "C" MSVC_API void QQmlApplicationEngine_setContextProperty1(QQmlApplicationEngine* wd, QString* qs, QObject* adr) {
    wd->rootContext()->setContextProperty(*qs, adr);
}
// ===================== QQmlContext ====================
// 464
extern "C" MSVC_API   QQmlContext* qteQQmlContext_create1(QQmlEngine* parent) {
     return parent->rootContext();
}
// 467
extern "C" MSVC_API   QQmlContext* qteQQmlContext_create2(QQmlEngine* parent, QObject* adr) {
     return new QQmlContext(parent, adr);
}

// 465
extern "C" MSVC_API void qteQQmlContext_delete1(QQmlContext* wd) {
    delete wd;
}
// 466
extern "C" MSVC_API void qteQQmlContext_setContextProperty(QQmlContext* wd, QString* qs, QObject* adr) {
    wd->setContextProperty(*qs, adr);
}

