//------------------------------
// Консоль для forthD на QtE5
// MGW 19.03.2016 22:32:10
//------------------------------

import asc1251;			// Поддержка cp1251 в консоли
import std.getopt;		// Раазбор аргументов коммандной строки
import std.stdio;
import std.file;
import forth;			// Сам forth написан на 32 разрядном D (asm)
import qte5;
import core.runtime;     // Обработка входных параметров
import std.string: strip, format;
import std.conv;

const strElow  = "background: #F8FFA1";
const strGreen = "background: #F79F81";

extern (C) {
    void on_knEval(FormaMain* uk) { (*uk).EvalString();    }
    void on_knLoad(FormaMain* uk) { (*uk).IncludedFile();  }
    void on_knHelp(FormaMain* uk) { (*uk).Help();          }
	
	// Обработчик с параметром. Параметр позволяет не плодить обработчики
	void on_about(FormaMain* uk) 	{ (*uk).about(1); }
	void on_aboutQt(FormaMain* uk)	{ (*uk).about(2); }
	
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
	void onCloseWin(FormaMain* uk, void* ev) {
		(*uk).workCloseForth(ev);
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

// Интефейс описывающий взаимодействие формы с логом и строкой
interface IFormLogCmd  {
	string getCmd();			// Дай команду
	void addStrInLog(string s);	// Добавь строку в лог
	void appendCmd(string s);	// Допиши коммандную строку
}
class CMdiFormLogCmd : QWidget, IFormLogCmd {
  private
	QBoxLayout	vblAll;			// Общий вертикальный выравниватель
	QHBoxLayout	hb2;			// Общий вертикальный выравниватель
	QPlainTextEdit	teLog;		// Окно лога
    QLineEdit		leCmdStr;	// Строка команды
	QTableWidget	teHelp;		// Таблица подсказок

	// -------------------------------------------
	this(QWidget parent, QtE.WindowType fl) {
		super(parent, fl);
		resize(200, 180);
		// Горизонтальный и вертикальный выравниватели
		vblAll  = new  QBoxLayout(this);			// Главный выравниватель
		//Строка команды
		leCmdStr = new QLineEdit(this);			// Строка команды
		leCmdStr.setKeyPressEvent(&onChar, parent.aThis);
		// Текстовый редактор, окно лога
		teLog = new QPlainTextEdit(this);
		teHelp = new QTableWidget(this); teHelp.setColumnCount(1).setRowCount(10);
		teHelp.setMaximumWidth(200);
		hb2 = new QHBoxLayout;
		hb2.addWidget(teLog).addWidget(teHelp);
		// Методы обработки расположены в родительском классе
		// teLog.setKeyPressEvent(&onChar, parent.aThis);
		// Вставляем всё в вертикальный выравниватель
		vblAll.addLayout(hb2).addWidget(leCmdStr);
		setLayout(vblAll);
		setWindowTitle("--[ FORTH ]--");
	}
	string getCmd() {
		return strip(leCmdStr.text!string());
	}
	void addStrInLog(string cmd) {
		teLog.appendPlainText(cmd); leCmdStr.clear().setFocus();
	}
	void appendCmd(string s) {
		string old = leCmdStr.text!string();
		leCmdStr.setText(old ~ s ~ " ");
	} 
}

 
// Форма для работы  
class FormaMain: QMainWindow {
	// ____________________________________________________________________
	QVBoxLayout 	vblAll;			// Общий вертикальный выравниватель
	QProgressBar    zz;
	QStatusBar      stBar;			// Строка сообщений
	
	QMdiArea		mainWid;
	CMdiFormLogCmd  winForth;
	
	QToolBar tb;
	QFrame wdhelp;
	QMenu menu1, menu2;
	QMenuBar mb1;
	QFont qf;
	QAction acEval, acIncl, acHelp, acAbout, acAboutQt;
	// ____________________________________________________________________
	// Конструктор по умолчанию
	this() {
		// --------------- Инициализация -----------------
		// Шрифт
		qf = new QFont(); qf.setPointSize(12);
		// Главный виджет, в который всё вставим
		mainWid = new QMdiArea(this);
		// Горизонтальный и вертикальный выравниватели
		vblAll  = new  QVBoxLayout();			// Главный выравниватель
		zz = new QProgressBar(null);
		// Строка сообщений
		stBar = new QStatusBar(this); stBar.setStyleSheet(strGreen);
		// ToolBar
		tb = new QToolBar(this); 
		// Menu
 		menu2 = new QMenu(this),  menu1 = new QMenu(this); 
		// MenuBar
		mb1 = new QMenuBar(this); mb1.addMenu(menu1).addMenu(menu2);
		// Обработчики
		acEval 	  = new QAction(null, &on_knEval,   aThis); 
		acIncl 	  = new QAction(null, &on_knLoad,   aThis); 
		acHelp    = new QAction(null, &on_knHelp,   aThis);
		acAbout   = new QAction(null, &on_about,    aThis, 1); 			// 1 - это парам перед в обработчик 
		acAboutQt = new QAction(null, &on_aboutQt,  aThis, 2); 			// 2 - это парам перед в обработчик 
		
		// --------------- Взаимные настройки -----------------
		menu2.setTitle("About")
			.addAction(		acAbout		)
			.addAction(		acAboutQt 	);
		
		menu1.setTitle("Help")
			.addAction(		acEval		)
			.addAction(     acIncl      )
			.addAction(		acHelp   	);

		// Определим наиновейший обработчик на основе QAction для Eval
		acEval.setText("Eval(string)").setHotKey(QtE.Key.Key_R | QtE.Key.Key_ControlModifier);
		acEval.setIcon("ICONS/continue.ico").setToolTip("Выполнить! как строку в Eval()");
		
		// -------- Связываю три сигнала с одним слотом -----------
		// Связываю сигнал QMenu::returnPressed() с слотом action acEval
		connects(acEval, "triggered()", acEval, "Slot()");

		// Определим наиновейший обработчик на основе QAction для Include
		acIncl.setText("Include file").setHotKey(QtE.Key.Key_I | QtE.Key.Key_ControlModifier);
		acIncl.setIcon("ICONS/ArrowDownGreen.ico").setToolTip("Загрузить и выполнить файл");
		// -------- Связываю сигнала с одним слотом -----------
		connects(acIncl, "triggered()", acIncl, "Slot()");

		// Определим наиновейший обработчик на основе QAction для Help
		acHelp.setText("Help").setHotKey(QtE.Key.Key_H | QtE.Key.Key_ControlModifier);
		acHelp.setIcon("ICONS/Help.ico").setToolTip("Помощь + документация");
		connects(acHelp, "triggered()", acHelp, "Slot()");
		
		// Обработчик для About и AboutQt
		acAbout.setText("About");
		connects(acAbout, "triggered()", acAbout, "Slot()");
		acAboutQt.setText("AboutQt");
		connects(acAboutQt, "triggered()", acAboutQt, "Slot()");

		// Создаю неубиваемое окошко Форта
		createWinForth();

		// Настраиваем ToolBar
		tb.setToolButtonStyle(QToolBar.ToolButtonStyle.ToolButtonTextBesideIcon);
		tb.addAction(acEval).addAction(acIncl).addSeparator().addAction(acHelp);
		tb.addWidget(zz); zz.setValue(1);
		
		// --------------- Установки класса -----------------

		setFont(qf);
		// Заголовки и размеры
		setWindowTitle("--- Консоль forthD на QtE5 ---"); resize(700, 400);
		// Центральный виджет в QMainWindow
		setCentralWidget(mainWid); 
		
		addToolBar(QToolBar.ToolBarArea.BottomToolBarArea, tb); tb.setStyleSheet(strElow);

		setMenuBar(mb1);
		setStatusBar(stBar);
		stBar.setFont(qf);
 		
		setNoDelete(true);
		

		// Выскакивающие окошко
		wdhelp = new QFrame(this, QtE.WindowType.Popup);
		QVBoxLayout 	wdhelpLV = new QVBoxLayout();

		QTableWidget pte = new QTableWidget(wdhelp);
		pte.setColumnCount(1).setRowCount(10);
		wdhelpLV.addWidget(pte);
		wdhelp.setLayout(wdhelpLV);

		// ---- Forth ----
		initForth(); 		// Активизируем Форт
		// Проверим и выполним переменные командной строки
		pvtInclude(sInclude);
		// if(sEval.length != 0) evalForth(sEval);
		
		// Запишем в общ таблицу адрес функции вызова
		// setCommonAdr(0, cast(pp)&on_fromForth);
		// setCommonAdr(1, cast(pp)&on_type);
		
	}
	// ____________________________________________________________________
	// Повторяющейся код для Include
	void pvtInclude(string cmd) {
		if(cmd.length != 0) { 
			if(!exists(cmd)) {
				msgbox("Не найден файл для Include:\n\n[" ~ cmd ~ "]", 
					"Include ...", QMessageBox.Icon.Critical);
				return;
			}
			includedForth(cmd); 
			winForth.addStrInLog("INCLUDE " ~ cmd);
			// updateKmd("INCLUDE " ~ cmd);
		}
	}
	// ____________________________________________________________________
	// Выполнить строку форта
	void EvalString() {
		// Обработка теперь берется с новой формы: 
 	    string cmd = winForth.getCmd();
		if(cmd.length != 0) { 
			try {
				evalForth(cmd); 
			} catch {
				msgbox("Error ...");
			}
			winForth.addStrInLog(cmd);
		}
//		QDate d = new QDate(); QTime t = new QTime();
//		writeln(toCON(d.toString("dd MMMM yyyy")), " ", toCON(t.toString("h:m:zzz")));
	}
	// ____________________________________________________________________
	// INCLUDE
	void IncludedFile() {
		// Проверим работу открытия файла
		QFileDialog fileDlg = new QFileDialog(null);
		string cmd = fileDlg.getOpenFileName("INCLUDE ...", "", "*.f");
		pvtInclude(cmd);
	}
	// ____________________________________________________________________
	// Help
	void Help() {
		msgbox("Окно с помощью ....", "Помощь", QMessageBox.Icon.Warning);
	}
	// ____________________________________________________________________
	// Создать и показать окно Forth
	void createWinForth() {
		// Создадим окно forth
		winForth = new CMdiFormLogCmd(this, 
			  QtE.WindowType.Window
		);
		// Поставим обработку закрытия окна
		winForth.setCloseEvent(&onCloseWin, aThis()); 
		// Добавим в MDI
		mainWid.addSubWindow(winForth);
		winForth.showMaximized();
		// Связываю сигнал QLineEdit::returnPressed() с слотом action acEval
		connects(winForth.leCmdStr,"returnPressed()", acEval, "Slot()");
	}
	// ____________________________________________________________________
	// closeWinMDI обработки событий
	void* workCloseForth(void* ev) {
		// 1 - Схватить событие пришедшее из Qt и сохранить его в моём классе
		QEvent qe = new QEvent('+', ev); 
		qe.ignore();
		msgbox("Закрытие этого окна не предусмотрено.", "Внимание!");
		return ev;
	}
	// ____________________________________________________________________
	// Проверка обработки событий
	void* workPress(void* ev) {
		// 1 - Схватить событие пришедшее из Qt и сохранить его в моём классе
		QKeyEvent qe = new QKeyEvent('+', ev); 
		// 2 - Выдать тип события
		string ss = format("type[%s] -- key[%s] -- count[%s]", qe.type, qe.key, qe.count);
		// writeln(ss);
		//stBar.showMessage(ss);
		string soob = "";
		if(qe.key == 16777235) soob = " Стрелка вверх ...";
		if(qe.key == 16777237) soob = " Стрелка вниз ...";

		if(qe.key == 16777264) {
			soob = " F1";
			winForth.appendCmd("SWAP");
		}
		if(qe.key == 16777265) soob = " F2";
		if(qe.key == 16777266) soob = " F3";
		if(qe.key == 16777267) soob = " F4";
		if(qe.key == 16777268) soob = " F5";
		if(qe.key == 16777269) soob = " F6";
		if(qe.key == 16777270) soob = " F7";
		if(qe.key == 16777271) soob = " F8";
		if(qe.key == 16777272) soob = " F9";
		if(qe.key == 16777273) soob = " F10";

		string cmd = winForth.getCmd() ~ to!string(cast(char)qe.key);
		stBar.showMessage("[" ~ cmd ~ "] --> " ~ ss ~ soob);
		if(cmd == "GEN") {
			// msgbox("GEN в строке ....");
			wdhelp.resize(250, 150).move(350, 350);
			wdhelp.show();
		}
/* 		if(qe.key == 65) {
			// попробуем написовать окно
			wdhelp.resize(250, 150).move(150, 150);
			wdhelp.show();
		}
 */		return ev;
	}
	// ____________________________________________________________________
	// Обработка About и AboutQt
	void about(int n) {
		if(n == 1) {
			msgbox("MGW 2016\n\n<b>Консоль для forth на D</b>", "about");
		}
		if(n == 2) {
			app.aboutQt();
		}
	}
}
// ____________________________________________________________________
// Глобальные переменные программы
QApplication app;
string sEval;		// Строка для выполнения eval
string sInclude;	// Строка с именем файла для INCLUDE

// ____________________________________________________________________
int main(string[] args) {
	bool fDebug;		// T - выдавать диагностику загрузки QtE5
	
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
	app = new QApplication(&Runtime.cArgs.argc, Runtime.cArgs.argv, 1);
	FormaMain formaMain = new FormaMain(); formaMain.show().saveThis(&formaMain);

	
	return app.exec();
}
