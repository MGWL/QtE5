#ifndef QTE5WEB_GLOBAL_H
#define QTE5WEB_GLOBAL_H

#include <QtCore/qglobal.h>

#if defined(QTE5WEB_LIBRARY)
#  define QTE5WEBSHARED_EXPORT Q_DECL_EXPORT
#else
#  define QTE5WEBSHARED_EXPORT Q_DECL_IMPORT
#endif

#endif // QTE5WEB_GLOBAL_H
