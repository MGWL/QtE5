#include "qte5.hpp"
#include <stdio.h>

using namespace QtE5;

// ____________________________________________________________________
// Предварительное описание функции. Основное описание поставить нельзя,
// т.к. будет не виден тип MyWidget (идет ниже)
void cb_t1(void*, int);
// ------- Предварительная декларация ---------
class MyWidget : QWidget {
	public:	
	QLabel* lb;
	
	~MyWidget() {
		delete lb;
	}
	MyWidget(QWidget* parent = NULL, QtE5_Const::WindowType fl = QtE5_Const::Widget) {
		char* soob = "<p><font size=7 color='red'><u>Привет</u> из QtE5 для DMC C++</font></p>";
		QString qsoob(soob);
		resize(500, 400);
		move(1, 1);
		setWindowTitle(QString("Заголовок окна ..."));
//		QLabel lb(this);
		lb = new QLabel(this);
		lb->setText(qsoob); //lb.setStyleSheet(QString("background: #F79F81"));
		// lb.move(30, 30); 
		//lb.setLineWidth(3);
		lb->setFrameShape(QFrame::Box);
		
		QAction ac(this, &cb_t1, aThis(), 3);
		QPushButton kn1(QString("Кнопка оранжевая."), this);
		connect(kn1.QtObj(), "#clicked()", ac.QtObj(), "#Slot_AN()", 0);

		QAction ac2(this, &cb_t1, aThis(), 5);
		QPushButton kn2(QString("Кнопка синия."), this);
		connect(kn2.QtObj(), "#clicked()", ac2.QtObj(), "#Slot_AN()", 0);
		
		QBoxLayout boxl((QWidget*)this, QBoxLayout::Direction::TopToBottom);
		boxl.addWidget(lb);
		boxl.addWidget(&kn1);
		boxl.addWidget(&kn2);
		kn2.setText(&QString("[ Я изменённая синия кнопка ]"));
		
	};
	//------ Слоты -------------
	void runNumStr(int n) {		
		printf("===> n = %d \n", n);
		if(n == 3) {
			lb->setStyleSheet(QString("background: #F79F81"));
		};
		if(n == 5) {
			lb->setStyleSheet(QString("background: blue"));
		};
	};
};
// ------ Основная декларация -------------
void cb_t1(void* uk, int n)  { 	((MyWidget*)uk)->runNumStr(n); };



int main(int argc, char** argv) {
	LoadQt(QtE5Widgets, true);			// Грузим QtE5
	QApplication app(argc, argv, 1);	// Старт GUI режим

	MyWidget mg; mg.saveThis(&mg); mg.show();
	return app.exec();
}
