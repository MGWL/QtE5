//------------------------------
// Консоль для forthD на QtE5
// MGW 19.03.2016 22:32:10
//------------------------------

import asc1251;			// Поддержка cp1251 в консоли
import std.getopt;		// Раазбор аргументов коммандной строки
import std.stdio;
// import forth;			// Сам forth написан на 32 разрядном D (asm)
import qte5;
import core.runtime;     // Обработка входных параметров
import std.string: strip;

const strElow  = "background: #F8FFA1";

extern (C) {
    void on_knEval(FormaMain* uk) { (*uk).EvalString();    }
    void on_knLoad(FormaMain* uk) { (*uk).IncludedFile();  }
    void on_knHelp(FormaMain* uk) { (*uk).Help();          }
	void on_returnPress() { /* formaMain.Cr();  */    }
	
	int on_fromForth() { writeln("... from Forth"); return 6; }
	int on_type(char* adr) { 
		int i;
		char kol = *adr; for(i = 0; i != kol; i++) write(*(adr + 1 + i)); 
		stdout.flush();
		return i;
	}
	// Проверка события KeyPressEvent 
	void* onChar(FormaMain* uk, void* ev) {
		// Вызвать метод FormaMain.workPress(из_С++__KeyEvent*)
		// Этот обработчик, просто транзитом передаёт всё дальше
		// return возвратит KeyEvent* обратно в C++, для дальнейшей обработки
		return (*uk).workPress(ev);
	}
}

string helps() { 
	return	toCON(
"Использование консоли для forthD: 
--------------------------------
Запуск:
console5_forthd [-d, -e, -i] ...
");
}
 
// Форма для работы  
class FormaMain: QMainWindow {
	QFrame			frAll;			// Общий фрейм для всей формы
	QHBoxLayout 	hblKeys;		// Выравниватель для кнопок горизонтальный
	QVBoxLayout 	vblAll;			// Общий вертикальный выравниватель
    QLineEdit		leCmdStr;		// Строка команды
	QPlainTextEdit	teLog;			// Окно лога
	QPushButton		knEval,	knHelp,	knLoad;
	QStatusBar      stBar;			// Строка сообщений
	QWidget         mainWid;

	QToolBar tb;
	QMenu   menu1, menu2;
	QMenuBar mb1;
	
	QFrame wdhelp;

	this() {
		mainWid = new QWidget(this);
		// Горизонтальный выравниватель для кнопок
		vblAll  = new  QVBoxLayout();			// Главный выравниватель
		hblKeys = new  QHBoxLayout();			// Выравниватель для кнопок
		leCmdStr = new QLineEdit(null);			// Строка команды

		knEval = new QPushButton("Eval(string)");
		knHelp = new QPushButton("Помощь");
		knLoad = new QPushButton("INCLUDED string");
		teLog = new QPlainTextEdit(null); 		teLog.setKeyPressEvent(&onChar, aThis);
		
		wdhelp = new QFrame(this, QtE.WindowType.Popup);
			QFrame zz = new QFrame(wdhelp);
		zz.setFrameShape(QFrame.Shape.Box);
		zz.setFrameShadow(QFrame.Shadow.Sunken);
		
		stBar = new QStatusBar(null);
		// Вставляем кнопки в горизонтальный выравниватель
		hblKeys.addWidget(knEval).addWidget(knLoad).addWidget(knHelp);
		// Вставляем всё в вертикальный выравниватель
		vblAll.addWidget(teLog).addWidget(leCmdStr).addLayout(hblKeys);
		mainWid.setLayout(vblAll);
		
		setCentralWidget(mainWid);
		setWindowTitle("--- Консоль forthD на QtE5 ---");
        resize(700, 400);
		
		// В конструкторе 2 адреса. Второй адрес this нашего экземпляра
		QSlot slotKnEval = new QSlot(&on_knEval, aThis);
		// связываем кнопку с нашим слотом и обработчиком
		connect(knEval.QtObj, MSS("clicked()", QSIGNAL), slotKnEval.QtObj, MSS("Slot()", QSLOT));

		QSlot slotKnLoad = new QSlot(&on_knLoad, aThis);
		// связываем кнопку с нашим слотом и обработчиком
		connect(knLoad.QtObj, MSS("clicked()", QSIGNAL), slotKnLoad.QtObj, MSS("Slot()", QSLOT));
		
		// QSlot slotKnHelp = new QSlot(&on_knHelp, aThis);
		QAction slotKnHelp = new QAction(null, &on_knHelp, aThis); 
		slotKnHelp.setText("Помощь").setHotKey(QtE.Key.Key_F5);
		// связываем кнопку с нашим слотом и обработчиком
		connect(knHelp.QtObj, MSS("clicked()", QSIGNAL), slotKnHelp.QtObj, MSS("Slot()", QSLOT));
		
		// Связываю настоящий сигнал QLineEdit::returnPressed() со своим слотом &on_knEval
		connect(leCmdStr.QtObj, MSS("returnPressed()", QSIGNAL), slotKnEval.QtObj, MSS("Slot()", QSLOT));
				
		// ---- Forth ----
		// initForth(); 		// Активизируем Форт
		// Запишем в общ таблицу адрес функции вызова
		// setCommonAdr(0, cast(pp)&on_fromForth);
		// setCommonAdr(1, cast(pp)&on_type);
		
		QAction ma2 = new QAction(null, &on_knHelp, aThis); ma2.setText("Это №2");
		QIcon qik1 = new QIcon(); qik1.addFile("ICONS/save.ico");
		QAction ma3 = new QAction(null, &on_knHelp, aThis); ma3.setText("Save").setIcon(qik1);
		
		setNoDelete(true);

		// QAction ac1 = new QAction(null, &on_knHelp, aThis); ac1.setText("Hello1");
		
		menu2 = new QMenu(this); menu2.setTitle("Испытание");
		menu2.addAction(slotKnHelp);
		menu2.addSeparator();
		menu2.addAction(ma3);
		menu2.addAction(ma2); ma2.setEnabled(false);
		
 		menu1 = new QMenu(this); menu1.setTitle("Help");
		menu1.addAction(slotKnHelp);
		menu1.addMenu(menu2);
		menu1.addSeparator();
		menu1.addAction(ma2);
		
		tb = new QToolBar(this); tb.addAction(ma3);
		setToolBar(tb);
		
		connect(slotKnHelp.QtObj, MSS("triggered()", QSIGNAL), slotKnHelp.QtObj, MSS("Slot()", QSLOT));
		mb1 = new QMenuBar(this); mb1.addMenu(menu1);

		setMenuBar(mb1);
		setStatusBar(stBar);
 		
		
	}
	// Вывод на экран команды и очистка строчного редактора
	void updateKmd(string cmd) {
		teLog.appendPlainText(cmd); leCmdStr.clear();
	}
	// Выполнить строку форта
	void EvalString() {
 	    // string cmd = strip(leCmdStr.text!string());
		// if(cmd.length != 0) { evalForth(cmd); updateKmd(cmd); }
	}
	// INCLUDE
	void IncludedFile() {
	    // string cmd = strip(leCmdStr.text!string());
		// if(cmd.length != 0) { includedForth(cmd); updateKmd(cmd); }
	}
	// Help
	void Help() {
		writeln(toCON("Help()"));
		// Попробуем изготовить QMessageBox()
		msgbox();
	}
	void* workPress(void* ev) {
		// 1 - Схватить событие пришедшее из Qt и сохранить его в моём классе
		QKeyEvent qe = new QKeyEvent('+', ev); 
		// 2 - Выдать тип события
		writeln(qe.type, "  -- key -> ", qe.key, "  -- count -> ", qe.count);
		if(qe.key == 65) {
			// попробуем написовать окно
			writeln("wdhelp.show();");
			wdhelp.resize(250, 150).move(150, 150);
			wdhelp.show();
		}
		return ev;
	}
}
 
int main(string[] args) {
	bool fDebug;		// T - выдавать диагностику загрузки QtE5
	string sEval;		// Строка для выполнения eval
	string sInclude;	// Строка с именем файла для INCLUDE
	
  	// Разбор аргументов коммандной строки
 	try {
		auto helpInformation = getopt(args, std.getopt.config.caseInsensitive,
			"d|debug",   toCON("включить диагностику QtE5"), &fDebug,
			"e|eval",    toCON("выполнить строку-команду в форт"), &sEval,
			"i|include", toCON("имя файла для INCLUDE"), &sInclude);
		if (helpInformation.helpWanted) defaultGetoptPrinter(helps(), helpInformation.options);
	} catch { writeln(toCON("Ошибка разбора аргументов командной стоки ...")); return 1; }
	
	// Загрузка графической библиотеки
	if (1 == LoadQt(dll.QtE5Widgets, fDebug)) return 1;  // Выйти,если ошибка загрузки библиотеки
	// Изготавливаем само приложение
	QApplication app = new QApplication(&Runtime.cArgs.argc, Runtime.cArgs.argv, 1);
	FormaMain formaMain = new FormaMain(); formaMain.show().saveThis(&formaMain);
	
	return app.exec();
}
