import core.runtime;
import std.stdio;
import qte5;

	
extern (C) {
	void  onKn(CEditWin* uk, int n) { (*uk).runKn(n); }
}
	
class CEditWin: QWidget { //=> Окно редактора D кода
	QTableWidget 	te_list;                   	// Вывод результата
	QVBoxLayout	vblAll;			// Общий вертикальный выравниватель
	QTableWidgetItem tbNameFile;
	QAction[2] acKn;					// Событие для кнопок
	QHBoxLayout laKn;				// Выравниватель для кнопок
	QPushButton[2] knKn;      		// 2 кнопоки
	QIcon ik;

	this(QWidget parent, QtE.WindowType fl) { //-> Базовый конструктор
		super(parent, fl);
		resize(500, 300);
		laKn = new QHBoxLayout(null);
		
		acKn[0] = new QAction(this, &onKn, aThis, 0);
		acKn[1] = new QAction(this, &onKn, aThis, 1);
		
		knKn[0] = new QPushButton("№ 1", this);
		knKn[1] = new QPushButton("№ 2", this);

		connects(knKn[0], "clicked()", acKn[0], "Slot_v__A_N_v()");
		connects(knKn[1], "clicked()", acKn[1], "Slot_v__A_N_v()");

		ik = new QIcon(); ik.addFile("ICONS/ArrowDownGreen.ico");
		
		laKn.addWidget(knKn[0]).addWidget(knKn[1]);
		vblAll  = new  QVBoxLayout(null);		// Главный выравниватель
		te_list     = new QTableWidget(this);
		te_list.setColumnCount(4); // Четыре колонки
		te_list.setRowCount(4);
		
		// te_list.insertRow(0);
		
		tbNameFile = new QTableWidgetItem(0);
		tbNameFile.setText("Привет");
		te_list.setItem(0, 0, tbNameFile);
		
		
		vblAll.addWidget(te_list).addLayout(laKn);
		setLayout(vblAll);
	}
	//_____________________________________________
	void runKn(int n) {
		if(n == 0) {
			tbNameFile.setText("Это другой Привет");
			writeln("flags = ", tbNameFile.flags());
			tbNameFile.setFlags(QtE.ItemFlag.ItemIsSelectable);
			tbNameFile.setIcon(ik);
		}
		if(n == 1) {
			QTableWidgetItem twi = te_list.item(0, 1);
			twi.setSelected(true);
			writeln(twi.isSelected, "  ", twi.text!string());
		}
	}
}
	
int main(string[] args) {
	QApplication app;
	CEditWin ce;

	// Загрузка графической библиотеки
	if (1 == LoadQt(dll.QtE5Widgets, true)) return 1;  // Выйти,если ошибка загрузки библиотеки
	app = new QApplication(&Runtime.cArgs.argc, Runtime.cArgs.argv, 1);
	// --------------
	ce = new CEditWin(null, QtE.WindowType.Window); ce.saveThis(&ce);
	ce.show();
	// --------------
	app.exec();
	return 0;
}