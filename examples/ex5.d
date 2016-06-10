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
	QTextEdit	edTextEdit;		// Сам редактор для проверки
	QPushButton kn1, kn2;
	QAction acKn1, acKn2, acDes1, acDes2;
	QLineEdit lineEdit;			// Строка строчного редактора
	QFrame view;
	~this() {
		// printf("--20--\n"); stdout.flush();
	}
	// ______________________________________________________________
	// Конструктор по умолчанию
	this(QWidget parent, QtE.WindowType fl) { //-> Базовый конструктор
		super(parent, fl);
		// Горизонтальный и вертикальный выравниватели
		vblAll  = new  QVBoxLayout(null);		// Главный выравниватель
		hb2  	= new  QHBoxLayout(null);		// Горизонтальный выравниватель
		// Изготавливаем редактор
		edTextEdit = new QTextEdit(this);
		vblAll.addWidget(edTextEdit);
		lineEdit = new QLineEdit(this);  lineEdit.setNoDelete(true);
		lineEdit.setText("Привет ребята ...");
		lineEdit.setReadOnly(true);
		// Область изображения
		view = new QFrame(this); 
		view.setMinimumHeight(200); 
setFrameShape( QFrame.Shape.Box );
		view.setFrameShape( QFrame.Shape.Box );
		view.setFrameShadow( QFrame.Shadow.Raised );
		// view.setStyleSheet("background: Red");
		// Кнопки
		kn1  = new QPushButton("Укажите имя файла:", this);
		kn2  = new QPushButton("Вторая кнопка",  this); 
		acKn1 = new QAction(this, &onKn1, aThis); connects(kn1, "clicked()", acKn1, "Slot()");
		acKn2 = new QAction(this, &onKn2, aThis); connects(kn2, "clicked()", acKn2, "Slot()");
		// Кнопки в выравниватель
		hb2.addWidget(kn1).addWidget(kn2);
		vblAll.addWidget(lineEdit).addWidget(view).addLayout(hb2);
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
		writeln("this is Button 2");
	}
	
}
// ____________________________________________________________________
int main(string[] args) {
	bool fDebug = true; if (1 == LoadQt(dll.QtE5Widgets, fDebug)) return 1;
	QApplication  app = new QApplication(&Runtime.cArgs.argc, Runtime.cArgs.argv, 1);
	
	CTest ct = new CTest(null, QtE.WindowType.Window); ct.show().saveThis(&ct);

	QEndApplication endApp = new QEndApplication('+', app.QtObj);
	return app.exec();
}