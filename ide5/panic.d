import qte5;
import qte5, core.runtime;
import std.stdio;
import std.conv;
import std.string;

const strElow  = "background: #F8FFA1";
const strGreen = "background: #F79F81";
const strEdit  = "font-size: 11pt; font-family: 'Anonymous Pro';";
const strTabl  = "font-size: 11pt; font-family: 'Anonymous Pro';";
const constMesAhtung = "Внимание! стр: ";

// __________________________________________________________________
class CLineNumberArea : QWidget {
 private
	// QPlainTextEdit		teEdit;

	this(){}
	this(QPlainTextEdit parent) { //-> Базовый конструктор
		super(parent); 
		// teEdit = parent; // setStyleSheet(strElow);
	}
}

//============================================
//====         Форма Окно редактора       ====
//============================================
extern (C) {
	void* onKeyReleaseEvent(CEditWin* uk, void* ev) {return (*uk).runKeyReleaseEvent(ev); }
	void* onKeyPressEvent(CEditWin* uk, void* ev)   {return (*uk).runKeyPressEvent(ev); }
	void  onResEventEdit(CEditWin* uk, void* ev)    { (*uk).ResEventEdit(ev); };
	void  onPaintCEditWin(CEditWin* uk, void* ev, void* qpaint)  { (*uk).runPaint(ev, qpaint); };
	void  onPaintCEditWinTeEdit(CEditWin* uk, void* ev, void* qpaint)  { (*uk).runPaintTeEdit(ev, qpaint); };
	void  onMouseKeyPressEvent(CEditWin* uk, void* ev)  { (*uk).runMouseKeyPressEvent(ev); };
	void  onMouseQWheelEvent(CEditWin* uk, void* ev)  { (*uk).runMouseQWheelEvent(ev); };
}
// __________________________________________________________________
class CEditWin: QWidget { //=> Окно редактора D кода
  private
	const sizeTabHelp = 30;

	QVBoxLayout		vblAll;						// Общий вертикальный выравниватель
	QHBoxLayout		hb2;						// Горизонтальный выравниватель
	
	QPlainTextEdit	teEdit;						// Окно Редактора
	QTableWidget	teHelp;						// Таблица подсказок
	QStatusBar		sbSoob;						// Строка статуса
	Highlighter 	highlighter;				// Подсветка синтаксиса
	CLineNumberArea	lineNumberArea;				// Область нумерации строк
	
	QRect 			RectContens;				// Промежуточные вычисления для гум строк
	QPainter	qp;
	QTextBlock tb1;
	QTextCursor txtCursor;
	string strNomerStr;
	QFont   fontPainter;
	bool fYasPaint;
	
	static enum mPointMax = 10;
	int[mPointMax] mPoint;						// Массив точек для запом позиции в Редакторе
	int     sizeFontEditor;
	string	nameEditFile;						// Имя файла редактируемого в данный момент

	
	this(){}
	// ______________________________________________________________
	// Конструктор по умолчанию
	this(QWidget parent, QtE.WindowType fl) { //-> Базовый конструктор
		super(parent, fl);
		
		// Горизонтальный и вертикальный выравниватели
		vblAll  = new  QVBoxLayout(null);		// Главный выравниватель
		hb2  	= new  QHBoxLayout(null);		// Горизонтальный выравниватель
		
		// Настройка редактора
		teEdit = new QPlainTextEdit(this);	 teEdit.setStyleSheet(strElow);
		teEdit.setTabStopWidth(24).setStyleSheet(strEdit);
		// Выключим перенос строчек ...
		{
			scope QTextOption textOption = new QTextOption(null);
			textOption.setWrapMode(QTextOption.WrapMode.NoWrap);
			teEdit.setWordWrapMode(textOption);
			delete textOption;
		}

		// Таблица подсказок
		teHelp = new QTableWidget(this); 
		teHelp.setColumnCount(1).setRowCount(sizeTabHelp);
		teHelp.setMaximumWidth(230).setStyleSheet(strTabl); 
		teHelp.setColumnWidth(0, 200);

		// Строка сообщений
		sbSoob = new QStatusBar(this); // sbSoob.setStyleSheet(strGreen);
		// sbSoob.setMaximumHeight(32);

		// Горизонтальный выравниватель наполняю
		hb2
			.addWidget(teHelp)
			.addWidget(teEdit)
		;

		// Вертикальный выравниватель наполняю
		vblAll.addLayout(hb2).addWidget(sbSoob);
		
		// Сформировано окно редактора
		setLayout(vblAll);

		// Обработка клавиш в редакторе
		teEdit.setKeyReleaseEvent( &onKeyReleaseEvent, aThis );
		teEdit.setKeyPressEvent(   &onKeyPressEvent,   aThis );

		// Подсветка синтаксиса
		highlighter = new Highlighter(teEdit.document());
		highlighter.setNoDelete(true);

		// Область нумерации строк
 		lineNumberArea = new CLineNumberArea(teEdit); 
		lineNumberArea.saveThis(&lineNumberArea);
		// lineNumberArea.setStyleSheet(strGreen);

		// Для Painter
		RectContens    = new QRect();
				   tb1 = new QTextBlock();
		txtCursor      = new QTextCursor(null);
		fontPainter    = new QFont();
		

		setResizeEvent(&onResEventEdit, aThis);
		
		lineNumberArea.setMousePressEvent(&onMouseKeyPressEvent, aThis);
		lineNumberArea.setMouseWheelEvent(&onMouseQWheelEvent, aThis);
		
		teEdit.setViewportMargins(70, 0, 0, 0);

		
		
		// ???
		
		        teEdit.setPaintEvent(&onPaintCEditWinTeEdit, aThis());
		lineNumberArea.setPaintEvent(&onPaintCEditWin,       aThis());
		
		
		
		
		
		
	}
	// ______________________________________________________________
	void runSliderTab(int nom) { //-> Изменение размера шрифта в экране
		string zn;		int sizeFont;
		if(sizeFontEditor != 0) {
			sizeFontEditor = sizeFontEditor + nom;
			if(sizeFontEditor < 3)  sizeFontEditor = 3;
			if(sizeFontEditor > 20) sizeFontEditor = 20;
			zn = "font-size: " ~ to!string(sizeFontEditor) ~ "pt; ";
			teEdit.setStyleSheet(zn);
			teHelp.setStyleSheet(zn);
			return;
		}
		// А если рано 0
		// Возьмем строку раскраски для редактора и извлечем размер 
		auto m1 = split(strEdit, ';');
		auto m2 = split(m1[0], ':');
		if(m2[0] == "font-size") {
			sizeFontEditor = to!int(strip(m2[1][0 .. $-2]));
		}
	}
	// ______________________________________________________________
	void* runMouseQWheelEvent(void* ev) { //-> Обработка колнсика мыша
		QWheelEvent wev = new QWheelEvent('+', ev);
		QPoint pp = wev.angleDelta();
		if(pp.y < 0) runSliderTab(-1); else runSliderTab(1);
		return ev;
	}
	// ______________________________________________________________
	void* runMouseKeyPressEvent(void* ev) { //-> Обработка колнсика мыша
		if(teHelp.isHidden) teHelp.show(); 	else 	teHelp.hide();
		return ev;
	}
	// ______________________________________________________________
	void* runKeyReleaseEvent(void* ev) { //-> Обработка события отпускания кнопки
		return ev;	// Вернуть событие в C++ Qt для дальнейшей обработки
	}
	// ______________________________________________________________
	void* runKeyPressEvent(void* ev) { //-> Обработка события нажатия кнопки
		// lineNumberArea.update();
	
		return ev;	// Вернуть событие в C++ Qt для дальнейшей обработки
	}
	// ______________________________________________________________
	void openWinEdit(string nameFile) { //-> Открыть на редактирование окно с файлом
		File fhFile;
		try {
			fhFile = File(nameFile, "r");
		} catch(Throwable) {
			msgbox("Не могу открыть: " ~ nameFile, "Внимание! стр: "
				~ to!string(__LINE__), QMessageBox.Icon.Critical);
			return;
		}
		try {
			int ks;
			foreach(line; fhFile.byLine()) {
				// Проверка на BOM
				if(ks++ == 0) if(line.length>2 && line[0]==239 && line[1]==187 && line[2]==191) line = line[3 .. $].dup;
				string str = to!string(line);
				// Для Linux надо обрезать символы CR в файлах из Windows
				version (linux) {
					if( (str.length > 0) && (str[$-1] == 13)  ) str = str[0 .. $-1];
				}
				// Вот тут надо вставить функцию обнаружения импорта
				// findImport(str);
				teEdit.appendPlainText(str);
				// parentQtE5.finder1.addLine(str);
			}
			sbSoob.showMessage("Загружено: " ~ nameFile); 
			setNameEditFile(nameFile);
			
		} catch(Throwable) {
			msgbox("Не могу читать: " ~ nameFile, "Внимание! стр: "
				~ to!string(__LINE__), QMessageBox.Icon.Critical);
		}
	}
	// ______________________________________________________________
	// Обработка изменения размеров редактора. Область нумерации перерисовывается
	// при изменениии размеров редактора
	void ResEventEdit(void* ev) {
		teEdit.contentsRect(RectContens);
		lineNumberArea.setGeometry(1, 1, 69, RectContens.height() -1 );
	}
	// ______________________________________________________________
	void runPaintTeEdit(void* ev, void* qpaint) { //->
		// При использовании Paint на QPlainTextEdit пользоваться самим Paint нельзя ...
		lineNumberArea.update();
	}
	// ______________________________________________________________
	// Выдать номер строки на которой стоит визуальный курсор
	int getNomerLineUnderCursor() { //-> Выдать номер строки с визуальным курсором
		teEdit.textCursor(txtCursor); // Выдернули курсор из QPlainText
		return txtCursor.blockNumber;
	}
	// ______________________________________________________________
	// Перерисовать себя
	void runPaint(void* ev, void* qpaint) { //-> Перерисовка области
		if(fYasPaint) { return; }
		fYasPaint = true;
		qp = new QPainter('+', qpaint);
		qp.font(fontPainter);
		scope QFontMetrics fontMetrics = new QFontMetrics(fontPainter);

		// Получим список строк с точкам запоминания
		// ?????? Каждый раз что то вычислять
		int[]	pointSave; foreach(el; mPoint) { if(el > 0) pointSave ~= el; }

		
		int blockNumber; // Номер строки (блока)
		int lineUnderCursor = getNomerLineUnderCursor();

		// Вычислим высоту видимой области редактора
		teEdit.contentsRect(RectContens);
		int hightTeEdit = RectContens.height();
		
		teEdit.firstVisibleBlock(tb1);  // Забрали текстовый блок из ред.
		int bottomTb; bool fIsPoint; int ts;
		while( tb1.isValid  && tb1.isVisible ) {
			
			blockNumber = tb1.blockNumber();
			bottomTb = teEdit.bottomTextBlock(tb1);
			
			ts = blockNumber + 1;
			foreach(el; pointSave) {
				if(el == ts) { fIsPoint = true; break; }
			}
			if(fIsPoint) {
				strNomerStr = format("%5d =>", ts);
			} else {
				strNomerStr = format("%5d  ", ts);
			}
			// Подсветка
			if(blockNumber == lineUnderCursor) {
				fontPainter.setOverline(true).setUnderline(true);
				qp.setFont(fontPainter);
				qp.setText(0, bottomTb - fontMetrics.descent(), strNomerStr);
				fontPainter.setOverline(false).setUnderline(false);
				qp.setFont(fontPainter);
			} else {
				qp.setText(0, bottomTb - fontMetrics.descent(), strNomerStr);
			}
			tb1.next(tb1);
			// Если видимая высота блока больше, чем высота окна редактора, то закончить
			if(hightTeEdit < bottomTb) break;
		}

		qp.end();
		fYasPaint = false;
	}
	// ____________________________________________________________________
	string getNameEditFile() { //-> Выдать имя редактируемого в данный момент файла
		return nameEditFile;
	}
	void setNameEditFile(string NameEditFile) { //-> Установить имя редактируемого в данный момент файла
		nameEditFile = NameEditFile; setWindowTitle(nameEditFile);
	}
 	// ______________________________________________________________
	void runCtrlS() { //-> Сохранить файл на диске
		File fhFile;
		try {
			fhFile = File(nameEditFile, "w");
		} catch(Throwable) {
			msgbox("Не могу создать: " ~ nameEditFile, constMesAhtung
				~ to!string(__LINE__), QMessageBox.Icon.Critical);
		}
		try {
			fhFile.write(teEdit.toPlainText!string());
			sbSoob.showMessage("Сохранено: " ~ nameEditFile);
		} catch(Throwable) {
			msgbox("Не могу записать: " ~ nameEditFile, constMesAhtung
				~ to!string(__LINE__), QMessageBox.Icon.Critical);
		}
	}
	
	
}

// =================================================================
// CFormaMain - Главная Форма для работы
// =================================================================
extern (C) {
	void on_knOpen(CFormaMain* uk)			{ (*uk).runknOpenFile();  }
	void on_knNew(CFormaMain* uk)			{ (*uk).runknNew();  }
	void on_knSave(CFormaMain* uk)			{ (*uk).SaveFile();  }
	void on_knSwap(CFormaMain* uk)			{ (*uk).runknSwap();  }
	void on_Exit(CFormaMain* uk)			{ (*uk).runExit(); }
	void onPointN3(CFormaMain* uk, int n)  	{ (*uk).runPointN3(n); }
}
// __________________________________________________________________
class CFormaMain: QMainWindow { //=> Основной MAIN класс приложения
	QMdiArea	mainWid;						// Область дочерних mdi виджетов
	CEditWin[]  lcd;							// Массив редакторов
	void*[]     lcdp;							// Массив Того, что возвращает QMdiArea.activeWindow
	QAction acNewFile, 
		acSwapView, acExit, acOpen, 
		acSave, acOnOffHelp, acPoint, acPointA;				// Обработчики
	QToolBar 	tb;  							// Строка кнопок
	QStatusBar	stBar;							// Строка сообщений
	bool 		fSwap;							// Переключатель отображения окон

	this(QWidget parent) { //-> Базовый конструктор
		super(parent);
		resize(700, 500);
		setWindowTitle("Это CFormaMain()");
		
		// Область создать
		mainWid = new QMdiArea(this);
		mainWid.setViewMode(QMdiArea.ViewMode.TabbedView);
		mainWid.setTabsClosable(true);
		mainWid.setTabsMovable(true);
		setCentralWidget(mainWid);
		
		// Актионы создать
		acNewFile	= new QAction(this, &on_knNew,   aThis);
		acNewFile.setText("New").setHotKey(QtE.Key.Key_N | QtE.Key.Key_ControlModifier);
		connects(acNewFile, "triggered()", acNewFile, "Slot()");

		acOpen	= new QAction(this, &on_knOpen,   aThis);
		acOpen.setText("Open").setHotKey(QtE.Key.Key_O | QtE.Key.Key_ControlModifier);
		acOpen.setIcon("ICONS/DocAdd.ico").setToolTip("Загрузить файл с диска ...");
		connects(acOpen, "triggered()", acOpen, "Slot()");
		
		acSwapView	= new QAction(this, &on_knSwap,   aThis);
		acSwapView.setText("Swap").setHotKey(QtE.Key.Key_M | QtE.Key.Key_ControlModifier);
		connects(acSwapView, "triggered()", acSwapView, "Slot()");
		
		acExit	= new QAction(this, &on_Exit,   aThis);
		acExit.setText("Exit").setHotKey(QtE.Key.Key_Q | QtE.Key.Key_ControlModifier);
		acExit.setIcon("ICONS/doc_error.ico").setToolTip("Выйти из ide5");
		connects(acExit, "triggered()", acExit, "Slot()");

		acSave	= new QAction(this, &on_knSave,   aThis);
		acSave.setText("Save").setHotKey(QtE.Key.Key_S | QtE.Key.Key_ControlModifier);
		acSave.setIcon("ICONS/save.ico").setToolTip("Сохранить на диск ...");
		connects(acSave, "triggered()", acSave, "Slot()");

		// ----------------------------------------------------------------
/*
		acPoint = new QAction(this, &onPointN3, aThis, 2);
		acPoint.setToolTip("Перейти на позицию вниз ...");
		acPoint.setText("Закладка V").setHotKey(
			QtE.Key.Key_T | QtE.KeyboardModifier.ControlModifier);
		connects(acPoint, "triggered()", acPoint, "Slot_AN()");

		acPointA = new QAction(this, &onPointN3, aThis, 1);
		acPointA.setToolTip("Перейти на позицию вверх ...");
		acPointA.setText("Закладка A").setHotKey(
			QtE.Key.Key_T | QtE.KeyboardModifier.ControlModifier | QtE.KeyboardModifier.ShiftModifier);
		connects(acPointA, "triggered()", acPointA, "Slot_AN()");
*/
		acOnOffHelp = new QAction(this, &onPointN3, aThis, 3);
		acOnOffHelp.setText("On/Off Таблица").setHotKey(QtE.Key.Key_H | QtE.Key.Key_ControlModifier);
		connects(acOnOffHelp, "triggered()", acOnOffHelp, "Slot_AN()");
		// ----------------------------------------------------------------
		
		// Создать таббы и меню
		tb = new QToolBar(this);
		addToolBar(QToolBar.ToolBarArea.TopToolBarArea, tb);
		tb.addAction(acNewFile);
		tb.addAction(acSwapView);
		tb.addAction(acExit);
		tb.addAction(acOpen);
		tb.addAction(acSave);
		tb.addAction(acOnOffHelp);
		

		// Строка сообщений
		stBar = new QStatusBar(this); // stBar.setStyleSheet(strGreen);
		setStatusBar(stBar);
		
		
	}
	// ______________________________________________________________
	void runknNew() { //-> Запросить файл для редактирования и открыть редактор
		createEdit("");
	}
	// ______________________________________________________________
	void runknOpenFile() { //-> Запросить файл для редактирования и открыть редактор
		QFileDialog fileDlg = new QFileDialog('+', null);
		string cmd = fileDlg.getOpenFileNameSt("Open file ...", "", "*.d *.ini *.txt");
		if(cmd != "") createEdit(cmd);
	}
	// ______________________________________________________________
	void createEdit(string nameFile) { //-> Изготовить окно редактора
		string nameFile2;
		if(nameFile == "") nameFile2 = "???"; else nameFile2 = nameFile; 
		lcd ~= new CEditWin(this, QtE.WindowType.Window);	// Есть новое окно редактора
		size_t last = lcd.length - 1;
		lcd[last].saveThis(&lcd[last]);
		mainWid.addSubWindow(lcd[last]);
		lcd[last].setNameEditFile(nameFile2);
		if(nameFile2 != "???") lcd[last].openWinEdit(nameFile2);
		lcd[last].show();
		lcdp ~= mainWid.activeSubWindow();   // Запромним индекс
		update();
	}
	// ______________________________________________________________
	CEditWin getActiveWinEdit() { //-> Выдать активное окно
		if(mainWid.activeSubWindow() is null) return null;
		void* ind = mainWid.activeSubWindow();
		int nm;	foreach(int j, el; lcdp) {	if(el == ind) {	nm = j;	break; } }
		return lcd[nm];
	}
	// ______________________________________________________________
	void SaveFile() { //-> Сохранить файл на диске
		scope CEditWin activeWinEdit = getActiveWinEdit();
		if(activeWinEdit is null) return;
		string nameFile = activeWinEdit.getNameEditFile();
		if(activeWinEdit.getNameEditFile() == "???") {
			QFileDialog fileDlg = new QFileDialog('+', null);
			string cmd = fileDlg.getSaveFileNameSt("Save file ...", "", "*.d *.ini *.txt");
			if(cmd != "") {
				activeWinEdit.setNameEditFile(cmd);
			} else {
				return;
			}
		}
		activeWinEdit.runCtrlS(); // Осуществить реальное сохранение
		return;
	}
	
	// ______________________________________________________________
	void runknSwap() { //-> 
		if(fSwap) {
			mainWid.setViewMode(QMdiArea.ViewMode.TabbedView);
		} else {
			mainWid.setViewMode(QMdiArea.ViewMode.SubWindowView);
		}
		fSwap = !fSwap;
		update();
	}
	// ______________________________________________________________
	void runExit() { //-> Выйти из программы
		hide();	app.exit(0);
	}
	// ______________________________________________________________
	void runPointN3(int n) { //-> Переход A и V на точки сохранения и On/Off табл подсказок
		scope CEditWin activeWinEdit = getActiveWinEdit();
		if(activeWinEdit is null) return;

		switch(n) {
			case 1: // Переход на точку вверх 
			//	nomGoTo = winEd.lineGoTo(1 + winEd.getNomerLineUnderCursor, false);
			//	if(nomGoTo > 0) winEd.teEdit.setCursorPosition(nomGoTo - 1, 0);
				break;
			case 2: // Переход на точку вниз
			//	nomGoTo = winEd.lineGoTo(1 + winEd.getNomerLineUnderCursor, true);
			//	if(nomGoTo > 0) winEd.teEdit.setCursorPosition(nomGoTo - 1, 0);
				break;
			case 3: // On Off таблицы подсказок
				if(activeWinEdit.teHelp.isHidden) 
					activeWinEdit.teHelp.show(); 
				else 
					activeWinEdit.teHelp.hide();
				break;
			default: break;	
		}
/*
		int nomGoTo, aWinEd = actWinEdit();
		if(aWinEd == -1) {
			msgbox(constMesNoActWindow, constMesAhtung ~ to!string(__LINE__), QMessageBox.Icon.Critical);
			return;
		}
		
		
		
		CEditWin winEd = (cast(SMesok*)tabbar.tabData(aWinEd)).pEditWin;
		switch(n) {
			case 1: // Переход на точку вверх 
				nomGoTo = winEd.lineGoTo(1 + winEd.getNomerLineUnderCursor, false);
				if(nomGoTo > 0) winEd.teEdit.setCursorPosition(nomGoTo - 1, 0);
				break;
			case 2: // Переход на точку вниз
				nomGoTo = winEd.lineGoTo(1 + winEd.getNomerLineUnderCursor, true);
				if(nomGoTo > 0) winEd.teEdit.setCursorPosition(nomGoTo - 1, 0);
				break;
			case 3: // On Off таблицы подсказок
				if(winEd.teHelp.isHidden) winEd.teHelp.show(); else winEd.teHelp.hide();
				break;
			default: break;	
		}
*/
	}
	
}

// __________________________________________________________________
// Глобальные переменные программы
QApplication app;	// Само приложение
// __________________________________________________________________
void main(string[] args) {
	bool fDebug;		// T - выдавать диагностику загрузки QtE5
	if (1 == LoadQt(dll.QtE5Widgets, fDebug)) return;  // Выйти,если ошибка загрузки библиотеки
	app = new QApplication(&Runtime.cArgs.argc, Runtime.cArgs.argv, 1);
	
	scope CFormaMain w1 = new CFormaMain(null); w1.show().saveThis(&w1);
	
    app.exec();
}