// Файл example1.d - example Hello world!
// -------- compile ---------
// dmd example1 qte5

import qte5;
import core.runtime;

int main(string[] args) {
	// Load library QtE5
	if (1 == LoadQt(dll.QtE5Widgets, true)) return 1;
	// Create app
	QApplication app = new QApplication(&Runtime.cArgs.argc, Runtime.cArgs.argv, 1);
	// Create Label widget
	QLabel lb = new QLabel(null);
	// Add in it text (support  HTML)
	lb.setWindowTitle("Example №1");
	lb.setText("<h1 align='center'>Привет мир!</h1><h1 align='center'>Hello world!</h1>").show();
	app.exec();
	return 0;
}