import qte5;
import core.runtime;     // Обработка входных параметров
import std.stdio;

const strElow  = "background: #F8FFA1";
const strGreen = "background: #F79F81";

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
//	QTextEdit	edTextEdit;		// Сам редактор для проверки
	QPushButton kn1, kn2;
	QAction acKn1, acKn2;
	QLineEdit lineEdit;			// Строка строчного редактора
	// ______________________________________________________________
	// Конструктор по умолчанию
	this(QWidget parent, QtE.WindowType fl) { //-> Базовый конструктор
		super(parent, fl);
		// Горизонтальный и вертикальный выравниватели
		vblAll  = new  QVBoxLayout(this);		// Главный выравниватель
		hb2  	= new  QHBoxLayout(this);		// Горизонтальный выравниватель
		// Изготавливаем редактор
		lineEdit = new QLineEdit(this); 
		lineEdit.setText("Привет ребята ...");
		lineEdit.setReadOnly(true);
		// Кнопки
		kn1  = new QPushButton("Укажите имя файла:", this);
		kn2  = new QPushButton("Вторая кнопка",  this); 
		acKn1 = new QAction(null, &onKn1, aThis); connects(kn1, "clicked()", acKn1, "Slot()");
		acKn2 = new QAction(null, &onKn2, aThis); connects(kn2, "clicked()", acKn2, "Slot()");
		// Кнопки в выравниватель
		hb2.addWidget(kn1).addWidget(kn2);
		// Раскрасим кнопки
		kn1. setStyleSheet(strElow);
		kn2. setStyleSheet(strGreen);
		vblAll.addWidget(lineEdit).addLayout(hb2);
		resize(300, 100); 
		setWindowTitle("Проверка QTextEdit");
		setLayout(vblAll);
	}
	// ______________________________________________________________
	void runKn1() { //-> Обработка кнопки №1
		writeln("this is Button 1");
		// Запросить файл для редактирования и открыть редактор
		QFileDialog fileDlg = new QFileDialog('+', null);
		string cmd = fileDlg.getOpenFileNameSt("Open file ...", "", "*.d *.ini *.txt");
		if(cmd != "") lineEdit.setText(cmd);
	}
	// ______________________________________________________________
	void runKn2() { //-> Обработка кнопки №2
		writeln("this is Button 2");
	}
}

// ____________________________________________________________________
int main(string[] args) {
	bool fDebug = true; if (1 == LoadQt(dll.QtE5Widgets, fDebug)) return 1;
	QApplication  app = new QApplication(&Runtime.cArgs.argc, Runtime.cArgs.argv, 1);
	CTest ct = new CTest(null, QtE.WindowType.Window); ct.show().saveThis(&ct);
	return app.exec();
}