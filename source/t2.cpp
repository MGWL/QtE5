#include "qte5.hpp"
#include <stdio.h>

using namespace QtE5;
#ifdef __MACH__
    char* verCmp = (char*)"G++ ( CLANG ) Mac OSX C++";
#endif
#ifdef __linux__
    char* verCmp = (char*)"G++ Linux C++";
#endif
#ifdef _MSC_VER
    char* verCmp = "MS VS C++";
#endif // _MSC_VER
#ifdef __DMC__
    char* verCmp = "DMC C++";
#endif // __DMC__

char* mes = (char*)"  Привет   старая  кобыла!   ";

// ____________________________________________________________________
// Предварительное описание функции. Основное описание поставить нельзя,
// т.к. будет не виден тип MyWidget (идет ниже)
void cb_t1(void*, int);
// ------- Предварительная декларация ---------
class MyWidget : public QWidget {
	public:
		QLabel* lb;
		QByteArray* gbuf;

	~MyWidget() {
		delete lb;
	}
	MyWidget(QWidget* parent = NULL, QtE5_Const::WindowType fl = QtE5_Const::Widget) {
		resize(500, 400);		move(1, 1);
		char* soob = (char*)"<p><font size=7 color='red'><u>Привет</u> из QtE5 для C++</font></p>";

		gbuf = new QByteArray((char*)"");

		QByteArray bar(mes);
		bar.trimmed(); bar.simplified();
		bar.prepend((char*)"["); bar.append((char*)"]");

		QByteArray b2((char*)"<<---"); bar.append(&b2); bar.prepend(&b2);
		QByteArray b3(&bar);

		setWindowTitle(QString(&b3));
		

		lb = new QLabel(this);
		QString qsoob(soob); lb->setText(qsoob);
		lb->setFrameShape(QFrame::Box);

		QAction ac(this, (void*)&cb_t1, aThis(), 3);
		QPushButton kn1(QString("Кнопка оранжевая."), this);
		connect(kn1.QtObj(), (char*)"#clicked()", ac.QtObj(), (char*)"#Slot_AN()", 0);

		QAction ac2(this, (void*)&cb_t1, aThis(), 5);
		QPushButton kn2(QString("Кнопка синия."), this);
		connect(kn2.QtObj(), (char*)"#clicked()", ac2.QtObj(), (char*)"#Slot_AN()", 0);

		QBoxLayout boxl((QWidget*)this, QBoxLayout::TopToBottom);
		boxl.addWidget(lb); 	boxl.addWidget(&kn1);		boxl.addWidget(&kn2);
		
	};
	//------ Слоты -------------
	void runNumStr(int n) {
		printf("===> n = %d \n", n);
		if(n == 3) { lb->setStyleSheet(QString("background: #F79F81")); };
		if(n == 5) { 
			lb->setStyleSheet(QString("background: blue"));   
			QString nameFile("/home/gena/qte5/t2.cpp");
			QFile f(nameFile, this); 
			bool rez = f.open(QIODevice::ReadOnly);
			if(rez) {
				printf("file open ...");
				f.readAll(gbuf); printf("%s", gbuf->data());
			} else {
				printf("file NO open ...");
			}
			
		};
	};
};
// ------ Основная декларация -------------
void cb_t1(void* uk, int n)  { 	((MyWidget*)uk)->runNumStr(n); };

int main(int argc, const char* argv[]) {
	LoadQt(QtE5Widgets, true);			// Грузим QtE5
	QApplication app(argc, argv, 1);	// Старт GUI режим
	MyWidget mg; 
	mg.saveThis(&mg); 
	mg.show();
	return app.exec();
	// return 0;
}
