#include "qte5script.h"

// For MSVC set __declspec(dllexport), for MinGW do not
#ifdef _MSC_VER
    #define MSVC_API __declspec(dllexport)
#else
    #define MSVC_API
#endif

#define sizeTabCallDlang 100

struct CallRecord {
    void* adrObj;           // Адрес объекта
    void* adrMet;           // Адрес метода
};

CallRecord tabCallDlang[sizeTabCallDlang];

// ===================== QScriptEngine ====================
// 351
extern "C" MSVC_API QScriptEngine* QScriptEngine_create1(QObject* parent) {
    for(int i = 0; i != sizeTabCallDlang; i++) {
        tabCallDlang[i].adrMet = NULL;
        tabCallDlang[i].adrObj = NULL;
    }

    QScriptEngine* se = new QScriptEngine(parent);
    return se;
}
// 352
extern "C" MSVC_API void QScriptEngine_delete1(QScriptEngine* wd) {
    if(wd->parent() == NULL) delete wd;
}
// 353
extern "C" MSVC_API  void QScriptEngine_evaluate(QScriptValue* sv, QScriptEngine* se, QString* program, QString* fileName, int lineNumer)
{
    *sv = se->evaluate(  (const QString &)*program, (const QString &)*fileName, lineNumer);
}
// ===================== QScriptValue ====================

// 367
extern "C" MSVC_API QScriptValue* QScriptValue_createBool(void* parent, bool b) {
    if(parent != NULL) {} // обман компилятора ... от unused var
    return new QScriptValue(b);
}

// 366
extern "C" MSVC_API QScriptValue* QScriptValue_createInteger(void* parent, int n) {
    if(parent != NULL) {} // обман компилятора ... от unused var
    return new QScriptValue(n);
}

// 365
extern "C" MSVC_API QScriptValue* QScriptValue_createQstring(void* parent, QString* qs) {
    if(parent != NULL) {} // обман компилятора ... от unused var
    return new QScriptValue(*qs);
}

// 354
extern "C" MSVC_API QScriptValue* QScriptValue_create1(void* parent) {
    if(parent != NULL) {} // обман компилятора ... от unused var
    return new QScriptValue();
}
// 355
extern "C" MSVC_API void QScriptValue_delete1(QScriptValue* wd) {
    delete wd;
}
// 356
extern "C" MSVC_API int QScriptValue_toInt32(QScriptValue* sv) {
    return sv->toInt32();
}
// 357
extern "C" MSVC_API  void QScriptValue_toString(QScriptValue* sv, QString* qs) {
    *qs = sv->toString();
}
// 358
extern "C" MSVC_API  void QScriptEngine_newQObject(QScriptValue* sv, QScriptEngine* se, QObject* qob)
{
    *sv = se->newQObject(qob);
}
// 359
extern "C" MSVC_API  void QScriptEngine_globalObject(QScriptValue* sv, QScriptEngine* se)
{
    *sv = se->globalObject();
}
// 360
extern "C" MSVC_API  void QScriptValue_setProperty(QScriptValue* glob, QScriptValue* sv, QString* qs)
{
    glob->setProperty(*qs, *sv);
}

// [Указатель на объект], [указатель на QScriptContext], [указатель на QScriptValue]
extern "C" typedef void (*ExecZIM_v__vp_vp_vp)(void*, void*, void*);

static QScriptValue getSetFoo(QScriptContext *context, QScriptEngine *engine)
{
    //bool f = false;
    QScriptValue callee = context->callee();
    int nom = context->argument(0).toInteger();

    void* aMet;
    void* aObj;

    aMet = tabCallDlang[nom].adrMet;
    aObj = *(void**)tabCallDlang[nom].adrObj;
    // printf("qarg = %s   sig = %s\n", (const char*)qarg.toStdString().c_str(), tabCallDlang[i].sig);

    // QString qs = context->argument(1).toString();
    ((ExecZIM_v__vp_vp_vp)aMet)(aObj, context, &(callee));
    //callee.setProperty("value", QScriptValue(engine, *qsRez));
    return callee.property("value");
    if(engine == NULL) {}
    return callee;
}
// 361
extern "C" MSVC_API  void QScriptEngine_callFunDlang(QScriptEngine* engine)
{
//    QScriptValue object = engine->newObject();
    engine->globalObject().setProperty("callFunDlang", engine->newFunction(getSetFoo));
}
// 362
// Установить делегат (ссылка на метод объекта D) по номеру nom
extern "C" MSVC_API  void QScriptEngine_setFunDlang(void* adrObj, void* adrMet, int nom)
{
    tabCallDlang[nom].adrMet = adrMet;
    tabCallDlang[nom].adrObj = adrObj;
}
// ===================== QScriptContext ====================
// 363
// Установить делегат (ссылка на метод объекта D) по номеру nom
extern "C" MSVC_API  int QScriptContext_argumentCount(QScriptContext* sc)
{
    return sc->argumentCount();
}
// 364
extern "C" MSVC_API  void QScriptContext_argument(QScriptContext* sc, QScriptValue* sv, int nom)
{
    *sv = sc->argument(nom);
}
