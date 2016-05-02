//------------------------------
// Прототип IDE для D + QtE5
// MGW 29.04.2016 17:00:10
//------------------------------

import asc1251;			// Поддержка cp1251 в консоли
import std.getopt;		// Раазбор аргументов коммандной строки
import std.stdio;
// import std.file;
// import forth;			// Сам forth написан на 32 разрядном D (asm)
import qte5;
import core.runtime;     // Обработка входных параметров
// import std.string: strip, format, split;
import std.conv;
import qte5prs;

const strElow  = "background: #F8FFA1";
const strGreen = "background: #F79F81";
const strEdit  = "font-size: 10pt; font-family: arial; tab-size: 2";

string helps() { 
	return	toCON(
"Использование консоли для forthD: 
--------------------------------
Запуск:
console5_forthd [-d, -e, -i] ...
");
}

// =================================================================
// Форма Окно редактора 
// =================================================================
extern (C) {
	void* onKeyReleaseEvent(CEditWin* uk, void* ev) {return (*uk).runKeyReleaseEvent(ev); }
	void*   onKeyPressEvent(CEditWin* uk, void* ev) {return (*uk).runKeyPressEvent(ev); }
}
// __________________________________________________________________
class CEditWin: QWidget { //=> Окно редактора D кода
  private
	enum Sost { //-> Состояние редактора
		Normal,			// Нормальное состояние
		Change
	}
  private
	CFormaMain parentQtE5;		// Ссылка на родительскую форму
	Sost editSost = Sost.Normal;
	QVBoxLayout	vblAll;			// Общий вертикальный выравниватель
	QHBoxLayout	hb2;			// Горизонтальный выравниватель
	QPlainTextEdit	teEdit;		// Окно Редактора
	QTableWidget	teHelp;		// Таблица подсказок
	QTableWidgetItem[10] mTi;	// Массив на 10 ячеек подсказок
	QTextCursor txtCursor;		// Текстовый курсор
	CFinder finder1;			// Поисковик
	int pozInTable;				// Позиция в таблице
	// ______________________________________________________________
	// Конструктор по умолчанию
	this(QWidget parent, QtE.WindowType fl) { //-> Базовый конструктор
		super(parent, fl); 
		// Горизонтальный и вертикальный выравниватели
		vblAll  = new  QVBoxLayout();		// Главный выравниватель
		hb2  	= new  QHBoxLayout();		// Горизонтальный выравниватель

		teEdit = new QPlainTextEdit(this);	// Окно редактора
		teEdit.setTabStopWidth(24).setStyleSheet(strEdit);
		
		teHelp = new QTableWidget(this); teHelp.setColumnCount(1).setRowCount(10);
		teHelp.setMaximumWidth(250); teHelp.setColumnWidth(0, 200);
		
		hb2.addWidget(teEdit).addWidget(teHelp);

		vblAll.addLayout(hb2); // .addWidget(leCmdStr);
		setLayout(vblAll);
		setWindowTitle("--[ FORTH ]--");

		// Обработка клавиш в редакторе
		teEdit.setKeyReleaseEvent(&onKeyReleaseEvent, aThis);
		teEdit.setKeyPressEvent(&onKeyPressEvent, aThis);
		// Инициализируем текстовый курсор
		txtCursor = new QTextCursor();
 		
		// Делаю массив для таблицы
 		for(int i; i != 10; i++) {
			mTi[i] = new QTableWidgetItem(0); 
			mTi[i].setText("");
			// mTi[i].setBackground(qbr);
			teHelp.setItem(i, 0, mTi[i]);
		}
		teHelp.setEnabled(false);
		
		finder1 = new CFinder();
		finder1.addFile("qte5.d");
		finder1.addFile("ide5.d");
		finder1.addFile("asc1251.d");
	}
	// ______________________________________________________________
	void setParentQtE5(CFormaMain p) { //-> Задать ссылку на родительскую форму
		parentQtE5 = p;
	}
	// ______________________________________________________________
	void* runKeyPressEvent(void* ev) { //-> Обработка события нажатия кнопки
		if( editSost == Sost.Normal) {
			return ev;
		} else {
			return null;
		}
	}
	// ______________________________________________________________
	void* runKeyReleaseEvent(void* ev) { //-> Обработка события отпускания кнопки
		QKeyEvent qe = new QKeyEvent('+', ev); 
		if( editSost == Sost.Normal) {
			write("N"); stdout.flush();
		} else {
			write("C"); stdout.flush();
		}
		
		if( editSost == Sost.Normal) {
			if(qe.key == 16777216) { // ESC
				editSost = Sost.Change; 
				teHelp.setCurrentCell(pozInTable, 0);
		        parentQtE5.showInfo(to!string(editSost) ~ "  " ~ to!string(qe.key)); 
				return null;
			}
			teEdit.textCursor(txtCursor);
			int poz = txtCursor.positionInBlock();
			QTextBlock tb = new QTextBlock(txtCursor);
			// Строка под курсором
			string strFromBlock = tb.text!string();
			// Вычленить слово и по нему заполнить таблицу
			setTablHelp(finder1.getEq(getWordLeft(strFromBlock, poz)));
			// Добавим в поисковик текущую строку
			finder1.addLine(strFromBlock);
			// Показать строку статуса
			parentQtE5.showInfo(to!string(editSost) ~ "  " ~ to!string(qe.key)); 
		} else {
			if(qe.key == 16777216) { // ESC
				editSost = Sost.Normal;
				teHelp.setCurrentCell(100, 0);
				pozInTable = 0; 
		        parentQtE5.showInfo(to!string(editSost) ~ "  " ~ to!string(qe.key)); 
				return null;
			}
			if(qe.key == 16777237) { // Стрелка вниз
				if(pozInTable < 10)	teHelp.setCurrentCell(++pozInTable, 0);
			//	write("V"); stdout.flush();
			}
			if(qe.key == 16777235) { // Стрелка вверх
				if(pozInTable > 0)	teHelp.setCurrentCell(--pozInTable, 0);
			//	write("A"); stdout.flush();
			}
			if(qe.key == 16777220) { // CR
				teHelp.setCurrentCell(100, 0);
				editSost = Sost.Normal;
				// Слово из таблицы
				string shabl = mTi[pozInTable].text!string();
				pozInTable = 0; 
				teEdit.insertPlainText(shabl);
			}
		//	write("+"); stdout.flush();
			return null;
		}
		//write("*"); stdout.flush();
		return ev;	// Вернуть событие в C++ Qt для дальнейшей обработки
	}	
	// ______________________________________________________________
	string getWordLeft(string str, int poz) { //-> Выдать строку от курсора до начала слова
		string rez; char[] rezch;
		if(poz == 0) return rez;
		if(poz > str.length) return rez;
		char[] line = fromUtf8to1251(cast(char[])str);
		int i; for(i = poz-1; i > -1; i--) {
			if( (line[i] == ' ') || (line[i] == '\t')  || (line[i] == '(')) break;	
		}
		if(i == -1) {	rezch = line[0 .. poz]; 	} 
		else 		{	rezch = line[i+1 .. poz];	}
		rez = cast(string)from1251toUtf8(rezch);
		return rez;
	}
	// ____________________________________________________________________
	// Заполним таблицу подсказок
	void setTablHelp(string[] mStr) { //-> Заполнить таблицу подсказок
		mStr.length = 10; 
		for(int i; i != 10; i++) mTi[i].setText(mStr[i]);
	}
}


// =================================================================
// CFormaMain - Главная Форма для работы  
// =================================================================
extern (C) {
	void on_knOpen(CFormaMain* uk)		{ (*uk).OpenFile();  }
	// Обработчик с параметром. Параметр позволяет не плодить обработчики
	void on_about(CFormaMain* uk) 		{ (*uk).about(1); }
	void on_aboutQt(CFormaMain* uk)		{ (*uk).about(2); }
}
// __________________________________________________________________
class CFormaMain: QMainWindow { //=> Основной MAIN класс приложения
	const maxKolEdit = 10;
	QMdiArea		mainWid;				// Область дочерних mdi виджетов
	CEditWin[maxKolEdit]	winEdit;		// 10 окошек Edit
	int 			winEditKol;				// Количество окошек редактора
	QMenu menu1, menu2;						// Меню
	QMenuBar mb1;							// Строка меню сверху
	QAction acOpen;							// Обработчик открыть редактор
	QAction acAbout, acAboutQt;
	QStatusBar      stBar;					// Строка сообщений
	// ______________________________________________________________
	this() { //-> Базовый конструктор
		// Главный виджет, в который всё вставим
		mainWid = new QMdiArea(this);
		// Обработчики
		acOpen	= new QAction(null, &on_knOpen,   aThis); 
		acOpen.setText("Open").setHotKey(QtE.Key.Key_O | QtE.Key.Key_ControlModifier);
		connects(acOpen, "triggered()", acOpen, "Slot()");

		acAbout   = new QAction(null, &on_about,    aThis, 1); 	// 1 - парам в обработчик 
		acAboutQt = new QAction(null, &on_aboutQt,  aThis, 2); 	// 2 - парам в обработчик 
		// Обработчик для About и AboutQt
		acAbout.setText("About");
		connects(acAbout, "triggered()", acAbout, "Slot()");
		acAboutQt.setText("AboutQt");
		connects(acAboutQt, "triggered()", acAboutQt, "Slot()");
		// Строка сообщений
		stBar = new QStatusBar(this); stBar.setStyleSheet(strGreen);

		// Menu
 		menu2 = new QMenu(this),  menu1 = new QMenu(this); 
		// MenuBar
		mb1 = new QMenuBar(this); mb1.addMenu(menu1).addMenu(menu2);
		// --------------- Взаимные настройки -----------------
		menu2.setTitle("About")
			.addAction(		acAbout		)
			.addAction(		acAboutQt 	);
		
		menu1.setTitle("File")
			.addAction(		acOpen		);
			
		setMenuBar(mb1);
		setStatusBar(stBar);
		
		// Центральный виджет в QMainWindow
		setCentralWidget(mainWid); 
		setNoDelete(true); // Не вызывай delete C++ для этой формы
	}
	// ______________________________________________________________
	void OpenFile() { //-> Запросить файл для редактирования
		EditFile("ide5.d");
	}
	// ______________________________________________________________
	void EditFile(string nameFile) { //-> Открыть файл для редактирования
		if(winEditKol < maxKolEdit) {
			winEdit[winEditKol] = new CEditWin(this, QtE.WindowType.Window); 
			winEdit[winEditKol].setParentQtE5(this);
			winEdit[winEditKol].saveThis(&winEdit[winEditKol]);
			mainWid.addSubWindow(winEdit[winEditKol]);
			winEdit[winEditKol].showNormal(); 
			winEditKol++;
		}
	}
	// ______________________________________________________________
	// Обработка About и AboutQt
	void about(int n) {
		if(n == 1) msgbox("MGW 2016\n\nIDE для D + QtE5 + Qt-5", "about");
		if(n == 2) app.aboutQt();
	}
	// ______________________________________________________________
	void showInfo(string s) { //-> Отобразить строку состояния
		stBar.showMessage(s);
	}
}

// __________________________________________________________________
// Глобальные переменные программы
QApplication app;	// Само приложение
string sEedit;		// Строка файла для редактирования
string sIniFile;	// Строка с именем файла ini
// __________________________________________________________________
int main(string[] args) {
	bool fDebug;		// T - выдавать диагностику загрузки QtE5
	
	// Разбор аргументов коммандной строки
	try {
		auto helpInformation = getopt(args, std.getopt.config.caseInsensitive,
			"d|debug",	toCON("включить диагностику QtE5"), 		&fDebug,
			"e|edit",	toCON("открыть файл на редактирование"), 	&sEedit,
			"i|ini", 	toCON("имя INI файла"), 					&sIniFile);
		if (helpInformation.helpWanted) defaultGetoptPrinter(helps(), helpInformation.options);
	} catch { 
		writeln(toCON("Ошибка разбора аргументов командной стоки ...")); return 1; 
	}
	// Загрузка графической библиотеки
	if (1 == LoadQt(dll.QtE5Widgets, fDebug)) return 1;  // Выйти,если ошибка загрузки библиотеки
	// Изготавливаем само приложение
	app = new QApplication(&Runtime.cArgs.argc, Runtime.cArgs.argv, 1);
	
	CFormaMain formaMain = new CFormaMain(); formaMain.show().saveThis(&formaMain);
	QSpinBox sb = new QSpinBox(null); sb.show(); sb.setStyleSheet("font-size: 12pt;");
	sb.setPrefix("Толщина линии: ").setSuffix(" пкс."); sb.setReadOnly(true);
	
	return app.exec();
}
