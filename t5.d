import core.runtime;
import std.stdio;
import asc1251;
import qte5;

const string strElow  = "background: #FCFDC6"; //#F8FFA1";
const string strBlue  = "background: #3F42FF"; //#F8FFA1";

// Обработка кнопки Поиска
extern (C) void onKnFind(int n) {
	writeln("--1--> ", n);
	
}

QWidget qw2;

int main(string[] args) {
	bool fDebug = true;
	if (1 == LoadQt(dll.QtE5Widgets, fDebug)) return 1;  // Выйти,если ошибка загрузки библиотеки
	QApplication app = new QApplication(&Runtime.cArgs.argc, Runtime.cArgs.argv, 1);
	
	QWidget qw1 = new QWidget();  
	qw1.setWindowTitle("Полный путь приложения: [" ~ app.appFilePath!string() ~ "]").show();
	qw1.setNoDelete(true);
	
	qw2 = new QWidget(null, QtE.WindowType.Dialog);
	qw2.setWindowTitle("Это окно диалога ...").setStyleSheet(strElow); 
	
	writeln( app.appFilePath!string() );
	
	QPushButton button = new QPushButton("Это обычная кнопка №5"w);
	button
		.setText(cast(char[])"Проба Ёлки объекты!")
		.setStyleSheet(strBlue)
		.setToolTip("Нажми меня и получишь результат.")
		;
	
	writeln(toCON(button.text!string()));
	
	// Привяжем кнопку
	QSlot slotKnFind = new QSlot(); // slotKnFind.setNoDelete(true);
	slotKnFind.setSlotN(&onKnFind, 5);  // Установить обработчик на Кнопку
	slotKnFind.connect(button.QtObj, MSS("clicked()", QSIGNAL), slotKnFind.QtObj, MSS("SlotN()", QSLOT), 1);
	slotKnFind.connect(button.QtObj, MSS("clicked()", QSIGNAL), qw2.QtObj, MSS("show()", QSLOT), 1);
	// slotKnFind.connect(button.QtObj, MSS("clicked()", QSIGNAL), app.QtObj, MSS("quit()", QSLOT), 1);
	
	// qw1.setNoDelete(true);
	// qw2.setNoDelete(true);
	// button.setNoDelete(true);
	// slotKnFind.setNoDelete(true);
	// app.setNoDelete(true);
	
	
	
	button.show();
	app.exec();
	return 0;
}
