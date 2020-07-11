//------------------------------
// Анализ, подготовка и создание БД ФИОД
// MGW 07.08.2016 16:12
//------------------------------
import asc1251;			// Поддержка cp1251 в консоли
import std.getopt;			// Раазбор аргументов коммандной строки
import std.stdio;			//
import qte5;
import std.conv;
import std.file;
import std.string;
import core.runtime;		// Обработка входных параметров
import std.container;		// Деревья

alias Elem = string;

// =================================================================
// CFormaLog - Форма лога
// =================================================================
extern (C) {
 	void on_CloseLog(CFormaLog* uk)		  	{ (*uk).runCloseLog(); }
// 	void on_Test(CFormaLog* uk)			{ (*uk).runTest(); }
}
// __________________________________________________________________
class CFormaLog: QWidget { //=> Форма лога
	QVBoxLayout	layV;
	QPlainTextEdit	textEdit;
	CFormaMain		parent;		// Родительская форма QMainWidget
	// ______________________________________________________________
	this(CFormaMain pr) { //-> Базовый конструктор
		// Главный виджет, в который всё вставим
		super(pr); setWindowTitle("Log"); parent = pr;
		layV = new QVBoxLayout(this);
		textEdit = new QPlainTextEdit(this);
		layV.addWidget(textEdit);
		setCloseEvent(&on_CloseLog, aThis);
	}
	// ______________________________________________________________
	void runCloseLog() { //-> Событие закрытия окна лога
		setCloseEvent(null); parent.bIsLog = false; parent = null;
	}
	// ______________________________________________________________
	void appendStr(string str) { //-> Добавить строку в Log
		textEdit.appendHtml("<p>" ~ str ~ "</b>");
	}
}

//
// formaMain.CFormaMain
// +===============================+
// |                               | <-- mb1.QMenuBar
// | [ File ]                      | File - menuFile.QMenu
// |  acTest                       | acTest.QAction
// |  acExit                       | acExit.QAction
// |                               | 
// +===============================+
// |  wLog.CFormaLog               | 
// |  +---------------------+      | 
// |  | textEdit.QTextEdit  | 
// |  |                     |      | 
// |  +---------------------+      |
// |                               | 
// |                               | 
// +-------------------------------+
//
//
// =================================================================
// CFormaMain - Главная Форма для работы
// =================================================================
extern (C) {
	void on_Exit(CFormaMain* uk)				{ (*uk).runExit(); }
	void on_Test(CFormaMain* uk)				{ (*uk).runTest(); }
	void on_about(CFormaMain* uk, int n)		{ (*uk).about(n);  }
	void on_NameRead(CFormaMain* uk, int n)		{ (*uk).runNameRead(); }
	void on_NameWrite(CFormaMain* uk, int n)	{ (*uk).runNameWrite(); }
	void on_OtvRead(CFormaMain* uk, int n)		{ (*uk).runOtvRead(); }
	void on_OtvWrite(CFormaMain* uk, int n)		{ (*uk).runOtvWrite(); }
}
// __________________________________________________________________
class CFormaMain: QMainWindow { //=> Основной MAIN класс приложения
	QMdiArea	mainWid;			// Область дочерних mdi виджетов
	QMenuBar 	mb1;				// Строка меню сверху
	QMenu 		menuFile, menuWork, menuSet, menuHelp;
	QStatusBar	sbSoob;				// Статусбар внизу

	QAction 	acExit, acTest;
	QAction 	acNameRead, acNameWrite, acOtvRead, acOtvWrite;
	QAction 	acAbout, acAboutQt;
	CFormaLog 	wLog;				// Окно лога
	bool		bIsLog;				// если Log на экране, то .T.
	// Деревья
	RedBlackTree!string	rbFio, rbNames, rbOtv;
	// ______________________________________________________________
	this() { //-> Базовый конструктор
		// Главный виджет, в который всё вставим
		super(null); resize(600, 400); setWindowTitle("Подготовка информации о ФИОД");
		mainWid = new QMdiArea(this);

		// Обработчики
		acExit	= new QAction(this, &on_Exit,   aThis);
		acExit.setText("Exit").setHotKey(QtE.Key.Key_Q | QtE.Key.Key_ControlModifier);
		acExit.setIcon("ICONS/doc_error.ico").setToolTip("Выйти из программы");
		connects(acExit, "triggered()", acExit, "Slot()");

		acTest	= new QAction(this, &on_Test,   aThis);
		acTest.setText("Test").setHotKey(QtE.Key.Key_T | QtE.Key.Key_ControlModifier);
		connects(acTest, "triggered()", acTest, "Slot()");

		sbSoob = new QStatusBar(this);

		// Центральный виджет в QMainWindow
		setCentralWidget(mainWid);
		// MenuBar
		mb1 = new QMenuBar(this);
		// Menu
		menuFile = new QMenu(this);
		menuFile.setTitle("&File")
			.addAction(		acTest		)
			.addSeparator()
			.addAction(		acExit		);

		menuWork = new QMenu(this);
		menuSet = new QMenu(this);

		menuHelp = new QMenu(this);
		acAbout   = new QAction(this, &on_about, aThis, 1); 	// 1 - парам в обработчик
		acAbout.setText("about").setToolTip("об программе");
		connects(acAbout, "triggered()", acAbout, "Slot_v__A_N_v()");
		acAboutQt = new QAction(this, &on_about, aThis, 2); 	// 2 - парам в обработчик
		acAboutQt.setText("aboutQt").setToolTip("об фреймворке Qt");
		connects(acAboutQt, "triggered()", acAboutQt, "Slot_v__A_N_v()");

		menuHelp.setTitle("&Help")
			.addAction(		acAbout		)
			.addAction(		acAboutQt	     );

		// пара Имена
		acNameRead = new QAction(this, &on_NameRead, aThis);
		acNameRead.setText("Имена Читать").setToolTip("Читать файл с именами и заполнять дерево");
		connects(acNameRead, "triggered()", acNameRead, "Slot_v__A_N_v()");

		acNameWrite = new QAction(this, &on_NameWrite, aThis);
		acNameWrite.setText("Имена Писать").setToolTip("Писать файл с именами из дерева");
		connects(acNameWrite, "triggered()", acNameWrite, "Slot_v__A_N_v()");

		menuWork = new QMenu(this);
		menuWork.setTitle("Work")
			.addAction(		acNameRead		)
			.addAction(		acNameWrite		);

		// пара Отчества
		acOtvRead = new QAction(this, &on_OtvRead, aThis);
		acOtvRead.setText("Отчества Читать").setToolTip("Читать файл с отчествами и заполнять дерево");
		connects(acOtvRead, "triggered()", acOtvRead, "Slot_v__A_N_v()");

		acOtvWrite = new QAction(this, &on_OtvWrite, aThis);
		acOtvWrite.setText("Отчества Писать").setToolTip("Писать файл с отчествами из дерева");
		connects(acOtvWrite, "triggered()", acOtvWrite, "Slot_v__A_N_v()");

		menuWork
			.addSeparator()
			.addAction(		acOtvRead		)
			.addAction(		acOtvWrite		);

		// формируем всё остальное
		mb1.addMenu(menuFile).addMenu(menuWork).addMenu(menuHelp);
		setMenuBar(mb1);
		setStatusBar(sbSoob);

		showLog(); 

		// Деревья
		rbNames = new RedBlackTree!string();	wLog.appendStr("rbNames - create");
		rbFio   = new RedBlackTree!string();	wLog.appendStr("rbFio - create");
		rbOtv   = new RedBlackTree!string();	wLog.appendStr("rbOtv - create");


	} // this()
	// ______________________________________________________________
	void runTest() { //-> Выйти из программы
		showLog();
	}
	// ______________________________________________________________
	void showLog() { //-> Открыть окно лога
		if(!bIsLog) {
			wLog = new CFormaLog(this); wLog.saveThis(&wLog);
			mainWid.addSubWindow(wLog); 
			wLog.show();
			bIsLog = true;
			showsb("Log на экране", 3000);
		}
	}
	// ______________________________________________________________
	void runExit() { //-> Выйти из программы
		hide();	app.quit();
	}
	// ______________________________________________________________
	void showsb(string s, int timeout = 0) { //-> Показать сообщение в статусной строке
		sbSoob.showMessage(s, timeout);
	}
	// ______________________________________________________________
	void about(int n) { //-> о программе и Qt
		if(n == 1) {
			msgbox(
"
<H3>CreateDB - подготовка к созданию БД</H3>
<H5>MGW 2016 ver 0.1 от 01.08.2016</H5>
<BR>
<IMG src='ICONS/qte5.png'>
"
, "о программе");
		}
		if(n == 2) {	app.aboutQt();	}

	}
	// ______________________________________________________________
	void createRbTree(string nameFile, RedBlackTree!string rb) { //-> Читать файл формировать дерево
		File fhNames;
		string stringName;
		try {
			fhNames = File(nameFile, "r");
		} catch goto m1;
		try {
			foreach(line; fhNames.byLine()) {
				string name = strip(to!string(line));
				if(name == "") continue;		// Обойти пустые строки
				stringName = capitalize(name);
				if(stringName !in rb) {
					rb.insert(stringName);	wLog.appendStr(stringName ~ " ---> добавлено");
				} else {
					// wLog.appendStr(stringName ~ " - skip");
				}
			}
		} 
		catch {
			msgbox("Ошибка чтения файла " ~ nameFile, 
				"Внимание! стр: " ~ to!string(__LINE__), QMessageBox.Icon.Critical);
			goto m1;
		}
m1:
	}
	// ______________________________________________________________
	void runNameRead() { //-> Читать файл с именами и формировать дерево
		QFileDialog fileDlg = new QFileDialog('+', null);
		string cmd = fileDlg.getOpenFileNameSt("Открыть файл с именами ...", "", "*.txt");
		if(cmd != "") {
			createRbTree(cmd, rbNames);
		}
	}
	// ______________________________________________________________
	void runNameWrite() { //-> Писать файл с именами из дерева
		foreach(s; rbNames) writeln(s);
	}
	// ______________________________________________________________
	void runOtvRead() { //-> Читать файл с отчествами и формировать дерево
		QFileDialog fileDlg = new QFileDialog('+', null);
		string cmd = fileDlg.getOpenFileNameSt("Открыть файл с отчествами ...", "", "*.txt");
		if(cmd != "") {
			createRbTree(cmd, rbOtv);
		}
	}
	// ______________________________________________________________
	void runOtvWrite() { //-> Писать файл с отчествами
		foreach(s; rbOtv) writeln(s);
	}

} // class CFormaMain

// __________________________________________________________________
// Глобальные функции

string helps() {
	return	toCON(
"Использование консоли для forthD:
--------------------------------
Запуск:
console5_forthd [-d, -e, -i] ...
");
}

// __________________________________________________________________
// Глобальные переменные программы
QApplication app;			// Само приложение
CFormaMain formaMain;		// Основное окно программы
// __________________________________________________________________
int main(string[] args) {
	bool fDebug;		// T - выдавать диагностику загрузки QtE5

	// Разбор аргументов коммандной строки
	try {
		auto helpInformation = getopt(args, std.getopt.config.caseInsensitive,
			"d|debug",	toCON("включить диагностику QtE5"), 		&fDebug);
		if (helpInformation.helpWanted) defaultGetoptPrinter(helps(), helpInformation.options);
	} catch {
		writeln(toCON("Ошибка разбора аргументов командной стоки ...")); return 1;
	}
	// Загрузка графической библиотеки
	if (1 == LoadQt(dll.QtE5Widgets, fDebug)) return 1;  // Выйти,если ошибка загрузки библиотеки
	// Изготавливаем само приложение
	app = new QApplication(&Runtime.cArgs.argc, Runtime.cArgs.argv, 1);

	formaMain = new CFormaMain(); formaMain.saveThis(&formaMain);
	formaMain.show();

	return app.exec();
}
/*
// Простейшая программа
void main() {
	string str;
	RedBlackTree!string rbTree = new  RedBlackTree!string();
	str = "Мохов";
	rbTree.insert(str);		// Вставить элемент

	string[] t = ["Иванова", "Петрова"];
	rbTree.insert(t);
	writeln("Иванова1" in rbTree);

	writeln("Hello...", rbTree);
	writeln("----------");
	foreach(s; rbTree) {
		writeln(s);
	}
}
*/
