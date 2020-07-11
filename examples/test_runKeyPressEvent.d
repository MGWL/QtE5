// проверка некоторых виджетов в qte5
import core.runtime;
import std.stdio;
import asc1251;
import qte5;

// const string strElow  = "background: #FCFDC6"; //#F8FFA1";
const string strElow  = "background: #F8FFA1";

// Проверка события KeyPressEvent 
bool onChar(void* ev) {
	// 1 - Схватить событие пришедшее из Qt и сохранить его в моём классе
	QKeyEvent qe = new QKeyEvent('+', ev); 
	// 2 - Выдать тип события
	writeln(qe.type, "  -- key -> ", qe.key, "  -- count -> ", qe.count);
	if(qe.key == 65) return false;
	return true;
}
extern (C) {
	void test2(CTest1* uk, int n)	{ (*uk).test(); }
	void* onKeyPressEvent(CTest1* uk, void* ev)        { return (*uk).runKeyPressEvent(ev); }
}

class CTest1 : QWidget {
	QHBoxLayout layH;
	QVBoxLayout layV;
	QPushButton pb1, pb2, pb3;
	QAction        ac1, ac2, ac3;
	QPlainTextEdit te1;
	
	this() {
		super(null);
		// Изготовим 3 кнопки
		ac1    = new QAction(this, &test2, aThis);
		pb1   = new QPushButton("Кнопка №1",  this); 
		connects(pb1, "clicked()", ac1, "Slot_AN()");

		pb1.setToolTip("Просто кнопка №1").setToolTipDuration(3000);
		pb1.setMaximumWidth(100);
		
		pb2 = new QPushButton("Кнопка №2");  pb2.setStyleSheet(strElow);
		pb3 = new QPushButton("Кнопка №3");  pb3.setStyleSheet(strElow);
		// Горизонтальный выравниватель для них
		layH = new QHBoxLayout(null); 
		layH.addWidget(pb1).addWidget(pb2).addWidget(pb3);
		// layH.setMargin(50);
		// Окно редактора
		te1 = new QPlainTextEdit(this);  
		te1.setKeyPressEvent(&onKeyPressEvent,  aThis);

   		// Вертикальный выравниватель
		layV = new QVBoxLayout(null); 
		layV.addWidget(te1);  layV.addLayout(layH);
		// Всё в окно
		setLayout(layV);
	}
	void test() {
		writeln("--TEST--");
	}
	// ______________________________________________________________
	void* runKeyPressEvent(void* ev) { //-> Обработка события нажатия кнопки
		sQKeyEvent qe = sQKeyEvent(ev); 
		// 2 - Выдать тип события
		writeln(qe.type, "  -- key -> ", qe.key, "  -- count -> ", qe.count);
		if(qe.key == QtE.Key.Key_A) writeln("--A--");
		
		return ev;	// Вернуть событие в C++ Qt для дальнейшей обработки
	}
}


int main(string[] args) {
	bool fDebug = true; // To switch on debugging messages
	if (1 == LoadQt(dll.QtE5Widgets, fDebug)) return 1;  // Выйти,если ошибка загрузки библиотеки
	QApplication app = new QApplication(&Runtime.cArgs.argc, Runtime.cArgs.argv, 1);

	CTest1 w1 = new CTest1(); w1.saveThis(&w1);
	w1.show();
	
	app.exec();
	return 0;
}