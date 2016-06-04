import qte5;
import core.runtime;     // Обработка входных параметров
import std.stdio;

// =================================================================
// Форма: Проверка QTextEdit
// =================================================================
extern (C) {
	void onKn1(CTest* uk) { (*uk).runKn1(); }
	void onKn2(CTest* uk) { (*uk).runKn2(); }
	void onD(CTest* uk, int n, int ab)   { (*uk).D(ab, n); }
}

class CTest : QFrame {
	QVBoxLayout	vblAll;			// Общий вертикальный выравниватель
	QHBoxLayout	hb2;			// Горизонтальный выравниватель
	QPlainTextEdit	edTextEdit;		// Сам редактор для проверки
	QPushButton kn1, kn2;
	QAction acKn1, acKn2, acDes1, acDes2;
	QLineEdit lineEdit;			// Строка строчного редактора
	~this() {
		// printf("--20--\n"); stdout.flush();
	}
	// ______________________________________________________________
	// Конструктор по умолчанию
	this(QWidget parent, QtE.WindowType fl) { //-> Базовый конструктор
		super(parent, fl);
		// Горизонтальный и вертикальный выравниватели
		vblAll  = new  QVBoxLayout();		// Главный выравниватель
		hb2  	= new  QHBoxLayout();		// Горизонтальный выравниватель
		vblAll.setNoDelete(true);
		hb2.setNoDelete(true);
		// Изготавливаем редактор
		edTextEdit = new QPlainTextEdit(this);
		vblAll.addWidget(edTextEdit);
		lineEdit = new QLineEdit(this);  lineEdit.setNoDelete(true);
		lineEdit.setText("Привет ребята ...");
		lineEdit.setReadOnly(true);
		// Кнопки
		kn1  = new QPushButton("Укажите имя файла:", this);
		kn2  = new QPushButton("Вторая кнопка",  this); 
		acKn1 = new QAction(this, &onKn1, aThis); connects(kn1, "clicked()", acKn1, "Slot()");
		acKn2 = new QAction(this, &onKn2, aThis); connects(kn2, "clicked()", acKn2, "Slot()");
		// Кнопки в выравниватель
		hb2.addWidget(kn1).addWidget(kn2);
		vblAll.addWidget(lineEdit).addLayout(hb2);
		resize(700, 500); setWindowTitle("Проверка QTextEdit");
		setLayout(vblAll);
}
 
 	// ______________________________________________________________
	void D(int ab, int n) {
		writeln(n, "--------------------------------D---------------------->", ab);
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
		QTextOption textOption = new QTextOption();
		writeln("--1--> ", textOption.QtObj);
		textOption.setWrapMode(QTextOption.WrapMode.NoWrap);
		edTextEdit.setWordWrapMode(textOption);
		writeln("this is Button 2");
	}
	
}
// ____________________________________________________________________
int main(string[] args) {
	bool fDebug = true; if (1 == LoadQt(dll.QtE5Widgets, fDebug)) return 1;
	QApplication  app = new QApplication(&Runtime.cArgs.argc, Runtime.cArgs.argv, 1);
	
	CTest ct = new CTest(null, QtE.WindowType.Window); ct.show().saveThis(&ct);
//	printf("--2--\n"); stdout.flush();
	// CTest ct1 = new CTest(null, QtE.WindowType.Window); ct1.show().saveThis(&ct1);
//	ct.listChildren();
//	printf("--3--\n"); stdout.flush();
	int rez = app.exec();
//	printf("--4--\n"); stdout.flush();
	QEndApplication endApp = new QEndApplication('+', app.QtObj);
	return rez;
}