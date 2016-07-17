/****************************************************************************
** Meta object code from reading C++ file 'web_socket_client.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.7.0)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../src/app_gui/web_socket_client.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'web_socket_client.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.7.0. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
struct qt_meta_stringdata_web_socket_client_t {
    QByteArrayData data[15];
    char stringdata0[173];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_web_socket_client_t, stringdata0) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_web_socket_client_t qt_meta_stringdata_web_socket_client = {
    {
QT_MOC_LITERAL(0, 0, 17), // "web_socket_client"
QT_MOC_LITERAL(1, 18, 7), // "OpenPDF"
QT_MOC_LITERAL(2, 26, 0), // ""
QT_MOC_LITERAL(3, 27, 14), // "signal_setPage"
QT_MOC_LITERAL(4, 42, 18), // "connection_success"
QT_MOC_LITERAL(5, 61, 7), // "connect"
QT_MOC_LITERAL(6, 69, 11), // "onConnected"
QT_MOC_LITERAL(7, 81, 15), // "onBinaryMessage"
QT_MOC_LITERAL(8, 97, 13), // "onTextMessage"
QT_MOC_LITERAL(9, 111, 8), // "sendFile"
QT_MOC_LITERAL(10, 120, 8), // "filename"
QT_MOC_LITERAL(11, 129, 14), // "registerMaster"
QT_MOC_LITERAL(12, 144, 12), // "download_pdf"
QT_MOC_LITERAL(13, 157, 7), // "getPage"
QT_MOC_LITERAL(14, 165, 7) // "setPage"

    },
    "web_socket_client\0OpenPDF\0\0signal_setPage\0"
    "connection_success\0connect\0onConnected\0"
    "onBinaryMessage\0onTextMessage\0sendFile\0"
    "filename\0registerMaster\0download_pdf\0"
    "getPage\0setPage"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_web_socket_client[] = {

 // content:
       7,       // revision
       0,       // classname
       0,    0, // classinfo
      12,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       3,       // signalCount

 // signals: name, argc, parameters, tag, flags
       1,    1,   74,    2, 0x06 /* Public */,
       3,    1,   77,    2, 0x06 /* Public */,
       4,    0,   80,    2, 0x06 /* Public */,

 // slots: name, argc, parameters, tag, flags
       5,    1,   81,    2, 0x0a /* Public */,
       6,    0,   84,    2, 0x0a /* Public */,
       7,    1,   85,    2, 0x0a /* Public */,
       8,    1,   88,    2, 0x0a /* Public */,
       9,    1,   91,    2, 0x0a /* Public */,
      11,    1,   94,    2, 0x0a /* Public */,
      12,    1,   97,    2, 0x0a /* Public */,
      13,    0,  100,    2, 0x0a /* Public */,
      14,    1,  101,    2, 0x0a /* Public */,

 // signals: parameters
    QMetaType::Void, QMetaType::QString,    2,
    QMetaType::Void, QMetaType::Int,    2,
    QMetaType::Void,

 // slots: parameters
    QMetaType::Void, QMetaType::QString,    2,
    QMetaType::Void,
    QMetaType::Void, QMetaType::QByteArray,    2,
    QMetaType::Void, QMetaType::QString,    2,
    QMetaType::Void, QMetaType::QString,   10,
    QMetaType::Void, QMetaType::QString,    2,
    QMetaType::Void, QMetaType::QString,   10,
    QMetaType::Void,
    QMetaType::Void, QMetaType::Int,    2,

       0        // eod
};

void web_socket_client::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        web_socket_client *_t = static_cast<web_socket_client *>(_o);
        Q_UNUSED(_t)
        switch (_id) {
        case 0: _t->OpenPDF((*reinterpret_cast< QString(*)>(_a[1]))); break;
        case 1: _t->signal_setPage((*reinterpret_cast< int(*)>(_a[1]))); break;
        case 2: _t->connection_success(); break;
        case 3: _t->connect((*reinterpret_cast< QString(*)>(_a[1]))); break;
        case 4: _t->onConnected(); break;
        case 5: _t->onBinaryMessage((*reinterpret_cast< QByteArray(*)>(_a[1]))); break;
        case 6: _t->onTextMessage((*reinterpret_cast< QString(*)>(_a[1]))); break;
        case 7: _t->sendFile((*reinterpret_cast< QString(*)>(_a[1]))); break;
        case 8: _t->registerMaster((*reinterpret_cast< QString(*)>(_a[1]))); break;
        case 9: _t->download_pdf((*reinterpret_cast< QString(*)>(_a[1]))); break;
        case 10: _t->getPage(); break;
        case 11: _t->setPage((*reinterpret_cast< int(*)>(_a[1]))); break;
        default: ;
        }
    } else if (_c == QMetaObject::IndexOfMethod) {
        int *result = reinterpret_cast<int *>(_a[0]);
        void **func = reinterpret_cast<void **>(_a[1]);
        {
            typedef void (web_socket_client::*_t)(QString );
            if (*reinterpret_cast<_t *>(func) == static_cast<_t>(&web_socket_client::OpenPDF)) {
                *result = 0;
                return;
            }
        }
        {
            typedef void (web_socket_client::*_t)(int );
            if (*reinterpret_cast<_t *>(func) == static_cast<_t>(&web_socket_client::signal_setPage)) {
                *result = 1;
                return;
            }
        }
        {
            typedef void (web_socket_client::*_t)();
            if (*reinterpret_cast<_t *>(func) == static_cast<_t>(&web_socket_client::connection_success)) {
                *result = 2;
                return;
            }
        }
    }
}

const QMetaObject web_socket_client::staticMetaObject = {
    { &QObject::staticMetaObject, qt_meta_stringdata_web_socket_client.data,
      qt_meta_data_web_socket_client,  qt_static_metacall, Q_NULLPTR, Q_NULLPTR}
};


const QMetaObject *web_socket_client::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *web_socket_client::qt_metacast(const char *_clname)
{
    if (!_clname) return Q_NULLPTR;
    if (!strcmp(_clname, qt_meta_stringdata_web_socket_client.stringdata0))
        return static_cast<void*>(const_cast< web_socket_client*>(this));
    return QObject::qt_metacast(_clname);
}

int web_socket_client::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 12)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 12;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 12)
            *reinterpret_cast<int*>(_a[0]) = -1;
        _id -= 12;
    }
    return _id;
}

// SIGNAL 0
void web_socket_client::OpenPDF(QString _t1)
{
    void *_a[] = { Q_NULLPTR, const_cast<void*>(reinterpret_cast<const void*>(&_t1)) };
    QMetaObject::activate(this, &staticMetaObject, 0, _a);
}

// SIGNAL 1
void web_socket_client::signal_setPage(int _t1)
{
    void *_a[] = { Q_NULLPTR, const_cast<void*>(reinterpret_cast<const void*>(&_t1)) };
    QMetaObject::activate(this, &staticMetaObject, 1, _a);
}

// SIGNAL 2
void web_socket_client::connection_success()
{
    QMetaObject::activate(this, &staticMetaObject, 2, Q_NULLPTR);
}
QT_END_MOC_NAMESPACE
