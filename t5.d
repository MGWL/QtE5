import core.runtime;
import std.stdio;
import qte5;

int main(string[] args) {
	bool fDebug = true;
	if (1 == LoadQt(dll.QtE5Widgets, fDebug)) return 1;  // Выйти,если ошибка загрузки библиотеки
	QApplication app = new QApplication(&Runtime.cArgs.argc, Runtime.cArgs.argv, 1);
	writeln(app.sizeOfQtObj);
	app.aboutQt();
	// app.exec();

	return 0;
}