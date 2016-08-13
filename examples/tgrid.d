import std.stdio;
import qte5;				// Графическая библиотека QtE5
import core.runtime;		// Обработка входных параметров

const strRed   = "background: red";
const strBlue   = "background: blue";
const strGreen   = "background: green";

class CTestGrid: QWidget {
	// ___________________________________
	this(QWidget parent) {
		super(parent); resize(800, 300);
		setWindowTitle("Демо QGridLayout");
		QGridLayout grl = new QGridLayout(this);
		QWidget w1 = new QWidget(this); w1.setStyleSheet(strGreen);
		// вставляем в 0 столбец и 0 строку
		grl.addWidget(w1, 0, 0);
		QWidget w2 = new QWidget(this); w2.setStyleSheet(strBlue);
		// вставляем в 1 столбец и 0 строку
		grl.addWidget(w2, 0, 1);
		QWidget w3 = new QWidget(this); w3.setStyleSheet(strRed);
		// вставляем в 0 столбец и 1 строку, но растягиваем на 1 колонку вправо
		grl.addWidget(w3, 1, 0, 1, 0);

		QPushButton b1 = new QPushButton("Кнопка №1", this);
		QPushButton b2 = new QPushButton("Кнопка №2", this);

		// Так как при вставке вновь создаваемого выравнивателя с параметром this
		// возникает ошибка: попытка вставить layout в widget уже имеющий layout,
		// то вставляем его без родителя с признаком не уничтожать.
		// До выхода из программы он будет болтаться в хипе
		QVBoxLayout vb = new QVBoxLayout(null); vb.setNoDelete(true);

		vb.addWidget(b1); vb.addWidget(b2);
		// Вставка Layout в Layout, с выравниванием влево
 		grl.addLayout(vb, 2,0, QtE.AlignmentFlag.AlignLeft);
		// grl.addLayout(vb, 2,0, QtE.AlignmentFlag.AlignRight);
		setLayout(grl);
	}
}

void main(string[] ards) {
	bool fDebug = true; 
	if (1 == LoadQt(dll.QtE5Widgets, fDebug)) return;
	QApplication app = new QApplication(&Runtime.cArgs.argc, Runtime.cArgs.argv, 1);
	// ---- код программы
	CTestGrid tg = new CTestGrid(null); tg.saveThis(&tg);
	tg.show();
	// ----
	app.exec();
}