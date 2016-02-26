import core.runtime;
import std.stdio;
import asc1251;
import qte5;

int main(string[] args) {
	bool fDebug = true;
	if (1 == LoadQt(dll.QtE5Widgets, fDebug)) return 1;  // Выйти,если ошибка загрузки библиотеки
	QApplication app = new QApplication(&Runtime.cArgs.argc, Runtime.cArgs.argv, 1);
/* 	
	QWidget qw1 = new QWidget();  qw1.show(); qw1.setWindowTitle("Привет из Qt-5");
	QWidget qw2 = new QWidget(qw1, QtE.WindowType.Dialog);  qw2.setWindowTitle("Привет из Qt-5 №2");
	qw2.show();

	QPalette qp = new QPalette(); delete qp;

 */	
	QWidget qw1 = new QWidget();  
	qw1.setWindowTitle("Полный путь приложения: [" ~ app.appFilePath() ~ "]").show();
	
	app.exec();
	return 0;
}
