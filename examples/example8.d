import qte5;
import core.runtime;     // Обработка входных параметров
import std.stdio;

// =================================================================
// Форма: Проверка QTextEdit
// =================================================================
extern (C) {
	void onKn1(CTest* uk) { (*uk).runKn1(); }
	void onKn2(CTest* uk) { (*uk).runKn2(); }
}
class CTest : QWidget {
	QVBoxLayout	vblAll;			// Общий вертикальный выравниватель
	QHBoxLayout	hb2;			// Горизонтальный выравниватель
	QTextEdit	edTextEdit;		// Сам редактор для проверки
	QPushButton kn1, kn2;
	QAction acKn1, acKn2;
	QTimer timer1;
	// ______________________________________________________________
	// Конструктор по умолчанию
	this(QWidget parent, QtE.WindowType fl) { //-> Базовый конструктор
		super(parent, fl);
		// Горизонтальный и вертикальный выравниватели
		vblAll  = new  QVBoxLayout(this);		// Главный выравниватель
		hb2  	= new  QHBoxLayout(this);		// Горизонтальный выравниватель
		// Изготавливаем редактор
		edTextEdit = new QTextEdit(this);
		vblAll.addWidget(edTextEdit);
		// Кнопки
		kn1  = new QPushButton("Первая кнопка:", this);
		kn2  = new QPushButton("Вторая кнопка",  this); 
		acKn1 = new QAction(null, &onKn1, aThis); connects(kn1, "clicked()", acKn1, "Slot()");
		acKn2 = new QAction(null, &onKn2, aThis); connects(kn2, "clicked()", acKn2, "Slot()");
		// Кнопки в выравниватель
		hb2.addWidget(kn1).addWidget(kn2);
		vblAll.addLayout(hb2);
		resize(700, 500); setWindowTitle("Проверка QTextEdit");
		setLayout(vblAll);
		// Проверка QTimer
		timer1 = new QTimer(this);
	}
	// ______________________________________________________________
	void runKn1() { //-> Обработка кнопки №1
		edTextEdit.setPlainText("Привет ребята!\nПоздравляю с праздником Победы!");
		writeln("this is Button 1");
	}
	// ______________________________________________________________
	void runKn2() { //-> Обработка кнопки №2
		// edTextEdit.insertPlainText("Проверка вставки текста!\n------1------\n----2------");
		edTextEdit.selectionChanged();
		writeln("this is Button 2");
	}
}

// ____________________________________________________________________
int main(string[] args) {
	bool fDebug = true; if (1 == LoadQt(dll.QtE5Widgets, fDebug)) return 1;
	QApplication  app = new QApplication(&Runtime.cArgs.argc, Runtime.cArgs.argv, 1);

	CTest fMain = new CTest(null, QtE.WindowType.Window);
	fMain.show().saveThis(&fMain);
	
	return app.exec();
}