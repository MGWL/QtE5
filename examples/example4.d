// Example №1
// -----------
// Compile:
// dmd example4 asc1251 qte5
//
// In a search way should be QtE5Widgets32.dll/so and RunTime DLL Qt-5 dll/so


import core.runtime;
import std.stdio;
import asc1251;
import qte5;

const string strElow  = "background: #FCFDC6"; //#F8FFA1";
const string strBlue  = "background: #3F42FF"; //#F8FFA1";

// Проверка события QResizeEvent 
extern (C) void onQResizeEvent(void* ev) {
	// 1 - Схватить событие пришедшее из Qt и сохранить его в моём классе
	QResizeEvent qe = new QResizeEvent('+', ev); 
	// 2 - Выдать тип события
	writeln(toCON("Событие: ширина: "), qe.size().width, toCON("  высота: "), qe.size().heigth);
}
// Проверка события KeyPressEvent 
extern (C) void onKeyPressEvent(void* ev) {
	// 1 - Схватить событие пришедшее из Qt и сохранить его в моём классе
	QKeyEvent qe = new QKeyEvent('+', ev); 
	// 2 - Выдать тип события
	writeln(qe.type, "  -- key -> ", qe.key, "  -- count -> ", qe.count);
}
// Проверка события CloseEvent 
extern (C) void onQCloseEvent(void* ev) {
	// 1 - Схватить событие пришедшее из Qt и сохранить его в моём классе
	QEvent qe = new QKeyEvent('+', ev); 
	// 2 - Что то просто сделать, поскольку ни каких параметров там нет
	writeln(toCON("Перед закрытием окна ..."));
}

extern (C) void onKn1() {
	writeln(toCON("Нажата кнопка №1"));
	f1.change1();
}
extern (C) void onKn2() {
	writeln(toCON("Нажата кнопка №2"));
	f1.change2();
}

// Окно диалога с двумя кнопками
class Forma1: QFrame /* QFrame */ {
	QPushButton kn1, kn2;
	QBoxLayout lah, lav;
	QLabel lb1;
	// -----------------------
	this() {
 		// Вызываем родителя для создания диалога
		super(null, QtE.WindowType.Dialog);
		// setStyleSheet(strBlue); 
		setWindowTitle("Пробное окно диалога");
		// Создаём выравниватель
		lah = new QHBoxLayout();
		lav = new QVBoxLayout();
		// Создаём кнопки
		kn1 = new QPushButton("Кнопка №1\nTo change on dark blue"); kn1.setStyleSheet(strBlue);
		kn2 = new QPushButton("Кнопка №2\nTo change on dark yellow"); kn2.setStyleSheet(strElow);
		lah.addWidget(kn1).addWidget(kn2);		// Добавляем кнопки
		// Назначим кнопкам события. Let's appoint to event buttons
		QSlot slotKn1 = new QSlot(&onKn1); 
		connect(kn1.QtObj, MSS("clicked()", QSIGNAL), slotKn1.QtObj, MSS("Slot()", QSLOT));
		QSlot slotKn2 = new QSlot(&onKn2); 
		connect(kn2.QtObj, MSS("clicked()", QSIGNAL), slotKn2.QtObj, MSS("Slot()", QSLOT));
		// Создамим QLabel
		lb1 = new QLabel(null); lb1.setText("<h2>Привет из (Hello from) <font color=red size=5>Qt-5.1</font></h2>");
		lb1.setStyleSheet(strElow);
		lb1.setFrameShape(QFrame.Shape.Box);
		lav.addWidget(lb1).addLayout(lah);
		setLayout(lav);							// Добавляем выравниватель в диалог
		lah.setNoDelete(true);
		setKeyPressEvent(&onKeyPressEvent);
		setCloseEvent(&onQCloseEvent);
	}
	// Change color Forma1 for kn1
	void change1() {
		setStyleSheet(strBlue);
	}
	void change2() {
		setStyleSheet(strElow);
	}
}

Forma1 f1;

int main(string[] args) {
	bool fDebug = true; // To switch on debugging messages
	if (1 == LoadQt(dll.QtE5Widgets, fDebug)) return 1;  // Выйти,если ошибка загрузки библиотеки
	QApplication app = new QApplication(&Runtime.cArgs.argc, Runtime.cArgs.argv, 1);
	
	f1 = new Forma1(); f1.show();
	
	app.exec();
	return 0;
}
