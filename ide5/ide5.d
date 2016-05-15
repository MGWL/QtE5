//------------------------------
// Прототип IDE для D + QtE5
// MGW 29.04.2016 17:00:10
//------------------------------

import asc1251;				// Поддержка cp1251 в консоли
import std.getopt;			// Раазбор аргументов коммандной строки
import std.stdio;			// 
import ini;					// Работа с INI файлами
import std.string;
import std.file;
import qte5;
import core.runtime;		// Обработка входных параметров
import std.conv;
import qte5prs;				// Парсер исходного кода

const strElow  = "background: #F8FFA1";
const strGreen = "background: #F79F81";
const strEdit  = "font-size: 12pt; font-family: 'Inconsolata';";
const strTabl  = "font-size: 12pt; font-family: 'Inconsolata';";

string helps() { 
	return	toCON(
"Использование консоли для forthD: 
--------------------------------
Запуск:
console5_forthd [-d, -e, -i] ...
");
}


// =================================================================
// Область номеров строк в редакторе
// =================================================================
extern (C) {
	void  onPaint(CLineNumberArea* uk, void* ev, void* qpaint)  { (*uk).runPaint(ev, qpaint); };
}
// __________________________________________________________________
class CLineNumberArea : QWidget {
  private
	QPlainTextEdit		codeEditor;
	// ______________________________________________________________
	// Конструктор по умолчанию
	this(QPlainTextEdit parent) { //-> Базовый конструктор
		super(parent);	codeEditor = parent;
		// Рисование области нумерации строк
		setPaintEvent(&onPaint, aThis);
	}
	~this() {
		setPaintEvent(null, aThis);
	}
	// ______________________________________________________________
	// Перерисовать себя
	void runPaint(void* ev, void* qpaint) { //-> Перерисовка области
		QTextBlock tb = new QTextBlock();
		codeEditor.firstVisibleBlock(tb);  // Забрали текстовый блок из ред.
		string strFromBlock = tb.text!string();
		// writeln("[", tb.blockNumber(), "] ", strFromBlock);
 		QPainter qp = new QPainter('+', qpaint);
		qp.setText(0, codeEditor.bottomTextBlock(tb), "1");
		// qp.setText(0, 60, "2");
		// qp.setText(0, 90, "3");
		qp.end();
	}
}


// =================================================================
// Форма Окно редактора 
// =================================================================
extern (C) {
	void* onKeyReleaseEvent(CEditWin* uk, void* ev) {return (*uk).runKeyReleaseEvent(ev); }
	void* onKeyPressEvent(CEditWin* uk, void* ev)   {return (*uk).runKeyPressEvent(ev); }
//	void  onSlider(CEditWin* uk, int n, int nom)    { (*uk).runSlider(nom);    }
	void  onSliderTab(CEditWin* uk, int n, int nom) { (*uk).runSliderTab(nom); }
	void  onUpdateLineNumberAreaWidth(CEditWin* uk, int n, int nBlok) { (*uk).updateLineNumberAreaWidth(nBlok); }
	void  onResEventEdit(CEditWin* uk, void* ev)    { (*uk).ResEventEdit(ev); };
//	void  onCtrlS(CEditWin* uk, int n)              { (*uk).runCtrlS(); }
}
// __________________________________________________________________
class CEditWin: QWidget { //=> Окно редактора D кода
	const sizeTabHelp = 30;
  private
	enum Sost { //-> Состояние редактора
		Normal,			// Нормальное состояние
		Change			// Режим работы с таблицей подсказок
	}
  private
	string	nameEditFile;		// Имя файла редактируемого в данный момент
	Sost editSost = Sost.Normal;
	int tekNomer;				// Текущий номер
	CFormaMain parentQtE5;		// Ссылка на родительскую форму
	QVBoxLayout	vblAll;			// Общий вертикальный выравниватель
	QHBoxLayout	hb2;			// Горизонтальный выравниватель
	QPlainTextEdit	teEdit;		// Окно Редактора
	QTableWidget	teHelp;		// Таблица подсказок
	QTableWidgetItem[sizeTabHelp] mTi;	// Массив на sizeTabHelp ячеек подсказок
	QTextCursor txtCursor;		// Текстовый курсор
	CFinder finder1;			// Поисковик
	int pozInTable;				// Позиция в таблице
	QSlider sliderEdit;			// Слайдер для редактора
	QAction acSlider;			// Событие для слайдера
	QSlider sliderTabl;			// Слайдер для таблицы
	QAction acSliderTabl;		// Событие для слайдера
	// QAction acCtrlS;			// Событие для CtrlS
	Highlighter highlighter;	// Подсветка синтаксиса
	QStatusBar	sbSoob;			// Строка статуса
	// Проверка нумерации строк и новых сигналов
	QAction		acUpdateLineNumberAreaWidth;
	CLineNumberArea		lineNumberArea;		// Область нумерации строк
	// ______________________________________________________________
	// Конструктор по умолчанию
	this(QWidget parent, QtE.WindowType fl) { //-> Базовый конструктор
		super(parent, fl);

		// Делаю актион на Ctrl+S
		// acCtrlS 	  = new QAction(null, &onCtrlS,   aThis); 
		// acCtrlS.setText("Save").setHotKey(QtE.Key.Key_S | QtE.Key.Key_ControlModifier);
		// acIncl.setIcon("ICONS/ArrowDownGreen.ico").setToolTip("Загрузить и выполнить файл");
		
		// Делаем слайдер для таблицы
		acSliderTabl = new QAction(null, &onSliderTab, aThis);
		sliderTabl = new QSlider(this, QtE.Orientation.Vertical);
		sliderTabl.setSliderPosition(12);
		connects(sliderTabl, "sliderMoved(int)", acSliderTabl, "Slot_v__A_N_i(int)");

		// Делаем слайдер
//		acSlider = new QAction(null, &onSlider, aThis);
//		sliderEdit = new QSlider(this, QtE.Orientation.Vertical);
//		sliderEdit.setSliderPosition(12);
//		connects(sliderEdit, "sliderMoved(int)", acSlider, "Slot_v__A_N_i(int)");
		
		// Горизонтальный и вертикальный выравниватели
		vblAll  = new  QVBoxLayout();		// Главный выравниватель
		hb2  	= new  QHBoxLayout();		// Горизонтальный выравниватель

		teEdit = new QPlainTextEdit(this);	// Окно редактора
		teEdit.setTabStopWidth(24).setStyleSheet(strEdit);
		
		teHelp = new QTableWidget(this); teHelp.setColumnCount(1).setRowCount(sizeTabHelp);
		teHelp.setMaximumWidth(230).setStyleSheet(strTabl); teHelp.setColumnWidth(0, 200);

		// Строка сообщений
		sbSoob = new QStatusBar(this);
		
		hb2.addWidget(teEdit)
//			.addWidget(sliderEdit)
			.addWidget(teHelp)
			.addWidget(sliderTabl);
//		sliderEdit.setMinimum(6).setMaximum(20);
		sliderTabl.setMinimum(6).setMaximum(20);

		vblAll.addLayout(hb2).addWidget(sbSoob);
		setLayout(vblAll);

		// Обработка клавиш в редакторе
		teEdit.setKeyReleaseEvent(&onKeyReleaseEvent, aThis);
		teEdit.setKeyPressEvent(&onKeyPressEvent, aThis);
		// Инициализируем текстовый курсор
		txtCursor = new QTextCursor();

		// Нумерация строк
 		lineNumberArea = new CLineNumberArea(teEdit);		// Область нумерации строк
		lineNumberArea.saveThis(&lineNumberArea);
		lineNumberArea.show(); lineNumberArea.setStyleSheet(strElow);
		teEdit.setViewportMargins(20, 0, 0, 0);
		setResizeEvent(&onResEventEdit, aThis);
		
		
		acUpdateLineNumberAreaWidth = new QAction(this, &onUpdateLineNumberAreaWidth, aThis);
		connects(teEdit, "blockCountChanged(int)", acUpdateLineNumberAreaWidth, "Slot_v__A_N_i(int)");
 		
		// Делаю массив для таблицы
 		for(int i; i != sizeTabHelp; i++) {
			mTi[i] = new QTableWidgetItem(0); 
			mTi[i].setNoDelete(true);
			mTi[i].setText("");
			// mTi[i].setBackground(qbr);
			teHelp.setItem(i, 0, mTi[i]);
		}
		// teHelp.setEnabled(false);
		highlighter = new Highlighter(teEdit.document());
		finder1 = new CFinder();
	}
	~this() {
	}
	// ______________________________________________________________
	// Обработка изменения размеров редактора. Область нумерации перерисовывается
	// при изменениии размеров редактора
	void ResEventEdit(void* ev) {
		QResizeEvent qe = new QResizeEvent('+', ev);
		// Взять размер пользовательской области teEdit
		QRect RectContens = new QRect(); teEdit.contentsRect(RectContens); RectContens.setNoDelete(true);
		// Изменить размеры области нумерации
		lineNumberArea.setGeometry(RectContens.x(), RectContens.y(), 20, RectContens.height());
	}
	// ______________________________________________________________
	// Счетчик изменяющихся блоков
	void updateLineNumberAreaWidth(int nBlok) {
		// writeln("nBlok ---> ", nBlok);
	}
	// ______________________________________________________________
	void openWinEdit(string nameFile) { //-> Открыть на редактирование окно с файлом
		// Очистить всё, что было
		teEdit.clear();
		// Читать файл в редактор
		File fhFile;
		try {
			fhFile = File(nameFile, "r");
		} catch {
			msgbox("Не могу открыть: " ~ nameFile, "Внимание! стр: "
				~ to!string(__LINE__), QMessageBox.Icon.Critical);
			return;
		}
		try {
			int ks;
			// Заполним парсер
			foreach(nameFilePrs; parentQtE5.listFPrs()) {
				if(exists(nameFilePrs)) finder1.addFile(nameFilePrs);
			}
			foreach(line; fhFile.byLine()) {
				// Проверка на BOM
				if(ks++ == 0) if(line.length>2 && line[0]==239 && line[1]==187 && line[2]==191) line = line[3 .. $].dup;
				string str = to!string(line);
				teEdit.appendPlainText(str);
				finder1.addLine(str);
			}
			sbSoob.showMessage("Загружено: " ~ nameEditFile); nameEditFile = nameFile;
		} catch {
			msgbox("Не могу читать: " ~ nameFile, "Внимание! стр: "
				~ to!string(__LINE__), QMessageBox.Icon.Critical);
			return;	
		}
		setWindowTitle(nameEditFile);
	}
 	// ______________________________________________________________
	void runCtrlS() {
		File fhFile;
		try {
			fhFile = File(nameEditFile, "w");
		} catch {
			msgbox("Не могу создать: " ~ nameEditFile, "Внимание! стр: " 
				~ to!string(__LINE__), QMessageBox.Icon.Critical);
		}
		try {
			fhFile.write(teEdit.toPlainText!string());
			sbSoob.showMessage("Сохранено: " ~ nameEditFile);
		} catch {
			msgbox("Не могу записать: " ~ nameEditFile, "Внимание! стр: "
				~ to!string(__LINE__), QMessageBox.Icon.Critical);
		}
	}
	// ______________________________________________________________
	void runSliderTab(int nom) { //-> Обработка события слайдера таблицы
		string zn = to!string(nom);
		zn = "font-size: " ~ zn ~ "pt; font-family: 'Inconsolata';";
		teHelp.setStyleSheet(zn);
		teEdit.setStyleSheet(zn);
	}
	// ______________________________________________________________
//	void runSlider(int nom) { //-> Обработка события слайдера
//		string zn = to!string(nom);
//		zn = "font-size: " ~ zn ~ "pt; font-family: 'Inconsolata';";
//		teEdit.setStyleSheet(zn);
//	}
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
			if(qe.key == 16777216) { // ESC
				editSost = Sost.Change; 
				teHelp.setCurrentCell(pozInTable, 0);
		        parentQtE5.showInfo(to!string(editSost) ~ "  " ~ to!string(qe.key)); 
				return null;
			}
			teEdit.textCursor(txtCursor); // Выдернули курсор из QPlainText
			if(qe.key == 16777264) { // F1 - Вставить верхнне слово из таблицы
				insWordInText(0, txtCursor);
				return null;
			}
			if(qe.key == 16777266) { // F3
				int poz = txtCursor.positionInBlock();
				QTextBlock tb = new QTextBlock(txtCursor);
				// Строка под курсором
				string strFromBlock = tb.text!string();
				// Вычленить слово и по нему заполнить таблицу
				string ffWord = getWordLeft(strFromBlock, poz);
				finder1.getSubFromAll(ffWord);
				setTablHelp( finder1.getSubFromAll(ffWord) );
				sbSoob.showMessage("[" ~ ffWord ~ "]  --> Список вхождений");
				return null;
			}

			int poz = txtCursor.positionInBlock();
			QTextBlock tb = new QTextBlock(txtCursor);
			// Строка под курсором
			string strFromBlock = tb.text!string();
			
			// Вычленить слово и по нему заполнить таблицу
			string ffWord = getWordLeft(strFromBlock, poz);
			sbSoob.showMessage("[" ~ ffWord ~ "]");
			// setWindowTitle("[" ~ ffWord ~ "]");
			setTablHelp(finder1.getEq(ffWord));
			// Добавим в поисковик текущую строку
			finder1.addLine(strFromBlock);
			// Показать строку статуса
			// parentQtE5.showInfo(to!string(editSost) ~ "  " ~ to!string(qe.key)); 
		} else {
			if(qe.key == 16777216) { // ESC
				editSost = Sost.Normal;
				teHelp.setCurrentCell(100, 0);
				pozInTable = 0; 
		        parentQtE5.showInfo(to!string(editSost) ~ "  " ~ to!string(qe.key)); 
				return null;
			}
			if(qe.key == 16777237) { // Стрелка вниз
				if(pozInTable < sizeTabHelp-1)	{
					string str = strip( mTi[pozInTable+1].text!string() );
					if( str != "" ) teHelp.setCurrentCell(++pozInTable, 0);
				}
			//	write("V"); stdout.flush();
			}
			if(qe.key == 16777235) { // Стрелка вверх
				if(pozInTable > 0)	teHelp.setCurrentCell(--pozInTable, 0);
			//	write("A"); stdout.flush();
			}
			if(qe.key == 16777220) { // CR
				insWordInText(pozInTable, txtCursor);
				sbSoob.showMessage("");
			}
			return null;
		}
		//write("*"); stdout.flush();
		return ev;	// Вернуть событие в C++ Qt для дальнейшей обработки
	}
	// ______________________________________________________________
	void insWordInText(int poz, QTextCursor txtCursor) { //-> Вставить слово из таблицы по номеру в редактируемый текст
		// Выключить подсветку таблицы
		teHelp.setCurrentCell(100, 0); editSost = Sost.Normal;
		// Слово из таблицы
		string shabl = mTi[poz].text!string(); pozInTable = 0; 
		// Замена текущего слова под курсором
		txtCursor.beginEditBlock();
		txtCursor.movePosition(QTextCursor.MoveOperation.StartOfWord);
		txtCursor.movePosition(QTextCursor.MoveOperation.EndOfWord, QTextCursor.MoveMode.KeepAnchor);
		txtCursor.removeSelectedText();
		txtCursor.insertText(shabl);
		teEdit.setTextCursor(txtCursor); // вставили курсор опять в QPlainText
		txtCursor.endEditBlock();
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
		mStr.length = sizeTabHelp; 
		for(int i; i != sizeTabHelp; i++) mTi[i].setText(mStr[i]);
	}
}


// =================================================================
// CFormaMain - Главная Форма для работы  
// =================================================================
extern (C) {
	void on_knOpen(CFormaMain* uk)		{ (*uk).OpenFile();  }
	// Сохранение файла
	void on_knSave(CFormaMain* uk)		{ (*uk).SaveFile();  }
	// Обработчик с параметром. Параметр позволяет не плодить обработчики
	void on_about(CFormaMain* uk) 		{ (*uk).about(1); }
	void on_aboutQt(CFormaMain* uk)		{ (*uk).about(2); }
	void on_Exit(CFormaMain* uk)		{ (*uk).runExit(); }
}
// __________________________________________________________________
class CFormaMain: QMainWindow { //=> Основной MAIN класс приложения
	string[10]	listFilesForParser;			// Массив с файлами для парсинга
	const maxKolEdit = 10;
	QMdiArea		mainWid;				// Область дочерних mdi виджетов
	CEditWin[maxKolEdit]	winEdit;		// 10 окошек Edit
	CEditWin				activeWinEdit;	// Активный в данный момент редактор
	int 			winEditKol;				// Количество окошек редактора
	QMenu menu1, menu2;						// Меню
	QMenuBar mb1;							// Строка меню сверху
	QAction acOpen, acNewFile, acSave, acSaveAs;	// Обработчики
	QAction acAbout, acAboutQt, acExit;
	QStatusBar      stBar;					// Строка сообщений
	QToolBar tb, tbSwWin;					// Строка кнопок
	// ______________________________________________________________
	this() { //-> Базовый конструктор
		// Главный виджет, в который всё вставим
		mainWid = new QMdiArea(this);

		// Обработчики
		acExit	= new QAction(this, &on_Exit,   aThis); 
		acExit.setText("Exit").setHotKey(QtE.Key.Key_Q | QtE.Key.Key_ControlModifier);
		acExit.setIcon("ICONS/doc_error.ico").setToolTip("Выйти из ide5");
		connects(acExit, "triggered()", acExit, "Slot()");

		acOpen	= new QAction(this, &on_knOpen,   aThis); 
		acOpen.setText("Open").setHotKey(QtE.Key.Key_O | QtE.Key.Key_ControlModifier);
		connects(acOpen, "triggered()", acOpen, "Slot()");

		acNewFile	= new QAction(this, &on_knOpen,   aThis); 
		acNewFile.setText("New").setHotKey(QtE.Key.Key_N | QtE.Key.Key_ControlModifier);
		connects(acNewFile, "triggered()", acNewFile, "Slot()");

		acSave	= new QAction(this, &on_knSave,   aThis); 
		acSave.setText("Save").setHotKey(QtE.Key.Key_S | QtE.Key.Key_ControlModifier);
		connects(acSave, "triggered()", acSave, "Slot()");

		// acSaveAs = new QAction(this, &on_knOpen,   aThis); 
		// acSaveAs.setText("Save as").setHotKey(QtE.Key.Key_S | QtE.Key.Key_ControlModifier);
		// connects(acSaveAs, "triggered()", acSave, "Slot()");
		
		acAbout   = new QAction(this, &on_about,    aThis, 1); 	// 1 - парам в обработчик 
		acAboutQt = new QAction(this, &on_aboutQt,  aThis, 2); 	// 2 - парам в обработчик 
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
			.addAction(		acNewFile	)
			.addAction(		acOpen		)
			.addAction(		acSave		)
			// .addAction(		acSaveAs	)
			.addSeparator()
			.addAction(		acExit		);

		// ToolBar
		tb = new QToolBar(this); tbSwWin = new QToolBar(this);
		// tb.setStyleSheet(strElow);
		tbSwWin.setStyleSheet( strElow );
		// Настраиваем ToolBar
		tb.setToolButtonStyle(QToolBar.ToolButtonStyle.ToolButtonTextBesideIcon);
		tb.addAction(acOpen).addSeparator().addAction(acExit);
		addToolBar(QToolBar.ToolBarArea.TopToolBarArea, tb); 

		tbSwWin.setToolButtonStyle(QToolBar.ToolButtonStyle.ToolButtonTextBesideIcon);
		tbSwWin.addAction(acOpen).addSeparator().addAction(acExit);
		addToolBar(QToolBar.ToolBarArea.BottomToolBarArea, tbSwWin); 
			
		setMenuBar(mb1);
		setStatusBar(stBar);
		
		// Центральный виджет в QMainWindow
		setCentralWidget(mainWid); 
		setNoDelete(true); // Не вызывай delete C++ для этой формы
		
		// Читаем параметры из INI файла
		readIniFile();
	}
	~this() {
	}
	// ______________________________________________________________
	void readIniFile() { //-> Прочитать INI файл в память
		Ini ini = new Ini(sIniFile);
		for(int i; i != 10; i++) listFilesForParser[i] = strip(ini["ForParser"]["FileParser" ~ to!string(i)]);
	}
	// ______________________________________________________________
	string[] listFPrs() { //-> Выдать список имен файлов для парсинга
		return listFilesForParser;
	}
	// ______________________________________________________________
	int actWinEdit() { //-> либо номер активногоокна, либо -1 если нет активных
		int rez = -1;
		foreach(ed; winEdit) {
			try {
				if(ed.teEdit.hasFocus()) { rez = ed.tekNomer; break; }
				// writefln(" hasFocus = %s  tekNomer = %s", ed.teEdit.hasFocus(), ed.tekNomer);
			} catch {}
		}
		return rez;
	}
	// ______________________________________________________________
	void SaveFile() { //-> Сохранить файл на диске
		// Определим активное окно редактора
		int aWinEd = actWinEdit();
		if(aWinEd > -1) {
			winEdit[aWinEd].runCtrlS();
		} else {
			msgbox("Не выбрано окно исходного текста для сохранения", "Внимание! стр: "
				~ to!string(__LINE__), QMessageBox.Icon.Critical);
		}
	}	
	// ______________________________________________________________
	void OpenFile() { //-> Запросить файл для редактирования и открыть редактор
		QFileDialog fileDlg = new QFileDialog('+', null);
		string cmd = fileDlg.getOpenFileNameSt("Open file ...", "", "*.d *.ini");
		if(cmd != "") EditFile(cmd);
	}
	// ______________________________________________________________
	void EditFile(string nameFile) { //-> Открыть файл для редактирования
		if(winEditKol < maxKolEdit) {
			winEdit[winEditKol] = new CEditWin(this, QtE.WindowType.Window); 
			winEdit[winEditKol].setNoDelete(true);
			winEdit[winEditKol].setParentQtE5(this);
			winEdit[winEditKol].saveThis(&winEdit[winEditKol]);
			mainWid.addSubWindow(winEdit[winEditKol]);
			activeWinEdit = winEdit[winEditKol]; // Активный в данный момент
			winEdit[winEditKol].tekNomer = winEditKol;
			winEdit[winEditKol].openWinEdit(nameFile);
			winEdit[winEditKol].showNormal(); 
			winEdit[winEditKol].teEdit.setFocus();
			winEditKol++;
		}
	}
	// ______________________________________________________________
	// Обработка About и AboutQt
	void about(int n) {
		if(n == 1) msgbox("MGW 2016\n\nIDE для D + QtE5 + Qt-5", "about");
		if(n == 2) {	app.aboutQt();	}
	}
	// ______________________________________________________________
	void showInfo(string s) { //-> Отобразить строку состояния
		stBar.showMessage(s);
	}
	// ______________________________________________________________
	void runExit() { //-> Выйти из программы
		hide();
		app.exit(0);
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
	app = new QApplication(&Runtime.cArgs.argc, Runtime.cArgs.argv, 1);	// app.setNoDelete(true);

	// Проверяем путь до INI файла
	if(!exists(sIniFile)) { 
		msgbox("Нет INI файла: " ~ "<b>" ~ sIniFile ~ "</b>", "Внимание! стр: " ~ to!string(__LINE__),
			QMessageBox.Icon.Critical); return(1); 
	} 
	CFormaMain formaMain = new CFormaMain(); formaMain.show().saveThis(&formaMain);
	return app.exec();
}

// Проверка изменений