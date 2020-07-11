import std.stdio;
import qte5;				// Графическая библиотека QtE5
import core.runtime;		// Обработка входных параметров

const strRed   = "background: red";

void main(string[] ards) {
	bool fDebug = true; 
	if (1 == LoadQt(dll.QtE5Widgets, fDebug)) return;
	QApplication app = new QApplication(&Runtime.cArgs.argc, Runtime.cArgs.argv, 1);
	// ---- код программы
	QFrame widget = new QFrame(null); widget.saveThis(&widget);

	widget.setWindowTitle("Привет из QtE5!");

	QVBoxLayout bl1 = new QVBoxLayout(null); // bl1.setNoDelete(true);
	widget.setLayout(bl1);

	QWidget w1 = new QWidget(widget);	w1.setStyleSheet("background: blue");
	QWidget w2 = new QWidget(widget);	w2.setStyleSheet("background: red");
	bl1.addWidget(w1);
	bl1.addWidget(w2);

	widget.listChildren();
	// ----
	widget.resize(300, 400);
	widget.show();
	// QEndApplication endApp = new QEndApplication('+', app.QtObj);
	app.exec();
}