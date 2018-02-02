import std.stdio;
import qte5;				// Графическая библиотека QtE5
import core.runtime;		// Обработка входных параметров

const strGreen = "background: #F79F81";


extern (C) {
	void onClic(CFormaMain* uk, int n)      { (*uk).runClic(); }
}
// __________________________________________________________________
class CFormaMain: QMainWindow { //=> Основной MAIN класс приложения
	QWidget			w1;
	QVBoxLayout		vblAll;						// Общий вертикальный выравниватель
	QHBoxLayout		hb2;						// Горизонтальный выравниватель
	QLineEdit		leUrl;
	QPushButton		knLoadHtml;
	QWebEngView		wv;
	QUrl 			qurla;
	QAction 		acClick;
	
	// ______________________________________________________________
	this(QWidget parent) { //-> Базовый конструктор
		super(parent);
		resize(900, 700);
		setWindowTitle("MicroBrouser on D + Qt-5 + QtE5");
		
		wv = new QWebEngView(this); wv.setStyleSheet(strGreen);
		w1 = new QWidget(this);
		qurla = new QUrl();

		vblAll  = new  QVBoxLayout(null);		// Главный выравниватель
		hb2  	= new  QHBoxLayout(null);		// Горизонтальный выравниватель

		leUrl = new QLineEdit(this); // leFind.setAlignment(QtE.AlignmentFlag.AlignCenter);
		leUrl.setStyleSheet(strGreen);
		knLoadHtml = new QPushButton("Load URL", this); knLoadHtml.setStyleSheet(strGreen);
		
		hb2.addWidget(leUrl).addWidget(knLoadHtml);
		vblAll.addWidget(wv).addLayout(hb2);
		w1.setLayout(vblAll);	

		acClick = new QAction(this, &onClic, aThis);
		connects(knLoadHtml, "clicked()", acClick, "Slot_v__A_N_v()");
		
		setCentralWidget(w1);
	}
	void runClic() {
		qurla.setUrl(leUrl.text!string());
		wv.load(qurla);
	}
}

int main(string[] ards) {
	if (1 == LoadQt(dll.QtE5Widgets + dll.QtE5WebEng, true)) return 1;
	QApplication app = new QApplication(&Runtime.cArgs.argc, Runtime.cArgs.argv, 1);
	
	scope CFormaMain w1 = new CFormaMain(null); w1.show().saveThis(&w1);
	
    return app.exec();
}
