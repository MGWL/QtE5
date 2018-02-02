import std.stdio;
import qte5;				// Графическая библиотека QtE5
import core.runtime;		// Обработка входных параметров

void main(string[] ards) {
	if (1 == LoadQt(dll.QtE5Widgets + dll.QtE5WebEng, true)) return;
	QApplication app = new QApplication(&Runtime.cArgs.argc, Runtime.cArgs.argv, 1);
	// ---- код программы
	QWebEngView wv = new QWebEngView(null);
	wv.resize(600,400);
	QUrl qurla = new QUrl(); 
	qurla.setUrl("http://forum.dlang.org/group/announce");
	// qurla.setUrl("http://old.centr-kachestvo.ru");
	wv.load(qurla);
	wv.show();
	// ----
	app.exec();
}
