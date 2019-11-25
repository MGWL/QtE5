#ifndef QTE5QSC_GLOBAL_H
#define QTE5QSC_GLOBAL_H

#include <QtCore/qglobal.h>

#if defined(QTEQSC_LIBRARY)
#  define QTE5WEBSHARED_EXPORT Q_DECL_EXPORT
#else
#  define QTE5WEBSHARED_EXPORT Q_DECL_IMPORT
#endif

#endif // QTE5QSC_GLOBAL_H
