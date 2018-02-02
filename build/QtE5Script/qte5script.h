#ifndef QTE5SCRIPT_H
#define QTE5SCRIPT_H
#include "qte5script_global.h"

//----  Мои дополнительные определения ---
#include <QtScript>

typedef int PTRINT;
typedef unsigned int PTRUINT;

typedef struct QtRef__ { PTRINT dummy; } *QtRefH;

extern "C" typedef void (*ExecZIM_v__i)(int);
extern "C" typedef void  (*ExecZIM_v__b)(bool);
extern "C" typedef void  (*ExecZIM_v__i)(int);
extern "C" typedef void  (*ExecZIM_v__v)(void);

extern "C" typedef void  (*ExecZIM_v__vp_n_i)(void*, int, int);
extern "C" typedef void  (*ExecZIM_v__vp_n_b)(void*, int, bool);
extern "C" typedef void  (*ExecZIM_v__vp_n)(void*, int);


extern "C" typedef void  (*ExecZIM_v__vp)(void*);

extern "C" typedef void  (*ExecZIM_v__vp_vp)(void*, void*);
extern "C" typedef void  (*ExecZIM_v__vp_vp_vp)(void*, void*, void*);

extern "C" typedef bool  (*ExecZIM_b__vp)(void*);
extern "C" typedef void* (*ExecZIM_vp__vp_vp)(void*, void*);
extern "C" typedef void* (*ExecZIM_vp__vp)(void*);



#endif // QTE5SCRIPT_H
