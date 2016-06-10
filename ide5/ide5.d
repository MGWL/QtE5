//------------------------------
// Прототип IDE для D + QtE5
// MGW 29.04.2016 17:00:10
//------------------------------
//	writeln("--1--"); stdout.flush();

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
import std.process;

const strElow  = "background: #F8FFA1";
const strGreen = "background: #F79F81";
// const strEdit  = "font-size: 12pt; font-family: 'Inconsolata';";
// const strTabl  = "font-size: 12pt; font-family: 'Inconsolata';";
const strEdit  = "font-size: 12pt; font-family: 'DejaVu SansMono';";
const strTabl  = "font-size: 12pt; font-family: 'DejaVu SansMono';";

const constNameLog = "dmderror.log"; 	// Имя файла протокола
const maxKolEdit = 10;   				// Количество окошек редактора

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
//	void  onPaintCLineNumberArea(CLineNumberArea* uk, void* ev, void* qpaint)  {
//		(*uk).runPaint(ev, qpaint);
//	}
}
// __________________________________________________________________
class CLineNumberArea : QWidget {
  private
	QPlainTextEdit		teEdit;
//	int 				widthArea = 50;	// Ширина области номеров строк
//	int 				oldWidthArea;
	// ______________________________________________________________
	// Конструктор по умолчанию
	this(QPlainTextEdit parent) { //-> Базовый конструктор
		super(parent); teEdit = parent; setStyleSheet(strElow);
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
	void  onNumStr(CEditWin* uk, int n)             { (*uk).runNumStr(); };
//	void  onCtrlS(CEditWin* uk, int n)              { (*uk).runCtrlS(); }
	void  onPaintCEditWin(CEditWin* uk, void* ev, void* qpaint)  { (*uk).runPaint(ev, qpaint); };
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
//	CFinder finder1;			// Поисковик
	int pozInTable;				// Позиция в таблице
	QSlider sliderEdit;			// Слайдер для редактора
	QAction acSlider;			// Событие для слайдера
	QSlider sliderTabl;			// Слайдер для таблицы
	QAction acSliderTabl;		// Событие для слайдера
	QAction acNumStr;			// Событие для перехода на строку
	// QAction acCtrlS;			// Событие для CtrlS
	Highlighter highlighter;	// Подсветка синтаксиса
	QStatusBar	sbSoob;			// Строка статуса
	// Проверка нумерации строк и новых сигналов
	QAction		acUpdateLineNumberAreaWidth;
	CLineNumberArea		lineNumberArea;		// Область нумерации строк
	QSpinBox	spNumStr;		// Спин для перехода на строку

	// ______________________________________________________________
	// Конструктор по умолчанию
	this(QWidget parent, QtE.WindowType fl) { //-> Базовый конструктор
		super(parent, fl);

		// Делаем слайдер для таблицы
		acSliderTabl = new QAction(this, &onSliderTab, aThis);
		sliderTabl = new QSlider(this, QtE.Orientation.Vertical);
		sliderTabl.setSliderPosition(12);
		connects(sliderTabl, "sliderMoved(int)", acSliderTabl, "Slot_v__A_N_i(int)");

		// Горизонтальный и вертикальный выравниватели
		vblAll  = new  QVBoxLayout(null);		// Главный выравниватель
		hb2  	= new  QHBoxLayout(null);		// Горизонтальный выравниватель
		vblAll.setNoDelete(true);
		hb2.setNoDelete(true);

		teEdit = new QPlainTextEdit(this);	// Окно редактора
		teEdit.setTabStopWidth(24).setStyleSheet(strEdit);
		// Выключим перенос строчек ...
		QTextOption textOption = new QTextOption();
		textOption.setWrapMode(QTextOption.WrapMode.NoWrap);
		teEdit.setWordWrapMode(textOption);


		teHelp = new QTableWidget(this); teHelp.setColumnCount(1).setRowCount(sizeTabHelp);
		teHelp.setMaximumWidth(230).setStyleSheet(strTabl); teHelp.setColumnWidth(0, 200);

		// Строка сообщений
		sbSoob = new QStatusBar(this);

		// Делаю спин
		spNumStr = new QSpinBox(this); spNumStr.hide(); spNumStr. setStyleSheet(strGreen);
		acNumStr = new QAction(this, &onNumStr, aThis);
		connects(spNumStr, "editingFinished()", acNumStr, "Slot_v__A_N_v()");

		hb2
			.addWidget(teHelp)
			.addWidget(teEdit)
			.addWidget(sliderTabl);
		sliderTabl.setMinimum(6).setMaximum(20);

		vblAll.addLayout(hb2).addWidget(spNumStr).addWidget(sbSoob);
		setLayout(vblAll);

		// Обработка клавиш в редакторе
		teEdit.setKeyReleaseEvent(&onKeyReleaseEvent, aThis);
		teEdit.setKeyPressEvent(&onKeyPressEvent, aThis);
		// Инициализируем текстовый курсор
		txtCursor = new QTextCursor();

		// Область нумерации строк
 		lineNumberArea = new CLineNumberArea(teEdit); lineNumberArea.saveThis(&lineNumberArea);
		setResizeEvent(&onResEventEdit, aThis);

//		acUpdateLineNumberAreaWidth = new QAction(this, &onUpdateLineNumberAreaWidth, aThis);
//		connects(teEdit, "blockCountChanged(int)", acUpdateLineNumberAreaWidth, "Slot_v__A_N_i(int)");

		// Делаю массив для таблицы
 		for(int i; i != sizeTabHelp; i++) {
			mTi[i] = new QTableWidgetItem(0);
			// mTi[i].setNoDelete(true);
			mTi[i].setText("");
			// mTi[i].setBackground(qbr);
			teHelp.setItem(i, 0, mTi[i]);
		}
		// teHelp.setEnabled(false);
		highlighter = new Highlighter(teEdit.document());

		lineNumberArea.setPaintEvent(&onPaintCEditWin, aThis());

		setNoDelete(true);
	}
	~this() {
	}
	// ______________________________________________________________
	// Перерисовать себя
	void runPaint(void* ev, void* qpaint) { //-> Перерисовка области
		QPainter qp = new QPainter('+', qpaint);

		// Получим шрифт, которым рисует painter
		QFont font = new QFont(); qp.font(font);
		QFontMetrics fontMetrics = new QFontMetrics(font);

		QTextBlock tb = new QTextBlock();
		teEdit.firstVisibleBlock(tb);  // Забрали текстовый блок из ред.

		string strNomerStr;
		int blockNumber; // Номер строки (блока)
		int lineUnderCursor = getNomerLineUnderCursor();

		int kol = 100;
		while(tb.isValid() && tb.isVisible()) {
			blockNumber = tb.blockNumber();
			if(blockNumber == lineUnderCursor) {
				strNomerStr = format("%4d->", blockNumber + 1);
			} else {
				strNomerStr = format("%4d", blockNumber + 1);
			}
			qp.setText(0, teEdit.bottomTextBlock(tb) - fontMetrics.descent(), strNomerStr);
			tb.next(tb);
			if(kol-- == 0) break; // Ограничение на перерисовку больших файлов
		}
		qp.end();
	}
	// ______________________________________________________________
	void runNumStr() { //-> Обработка события перехода на строку
		int num = spNumStr.value();
		spNumStr.hide();


		// msgbox("Переход на строку №" ~ to!string(spNumStr.value()));
		writeln("N = ", num);
		teEdit.setFocus();
	}
	// ______________________________________________________________
	// Обработка изменения размеров редактора. Область нумерации перерисовывается
	// при изменениии размеров редактора
	void ResEventEdit(void* ev) {
		// Взять размер пользовательской области teEdit
		QRect RectContens = new QRect();
		teEdit.contentsRect(RectContens);
		// Изменить размеры области нумерации
		teEdit.setViewportMargins(70, 0, 0, 0);
		lineNumberArea.setGeometry(1, 1, 70, RectContens.height() -1 );
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
		parentQtE5.loadParser(); // Заполним парсер
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
				teEdit.appendPlainText(str);
				parentQtE5.finder1.addLine(str);
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
	void runCtrlS() { //-> Сохранить файл на диске
		if(nameEditFile == "") {

		}
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
		// lineNumberArea.setStyleSheet(zn);
		// Вычислим ширину lineNumberArea
		// teEdit.setViewportMargins(lineNumberArea.getWidthArea(), 0, 0, 0); // getWidthArea
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
	// Выдать номер строки на которой стоит визуальный курсор
	int getNomerLineUnderCursor() { //-> Выдать номер строки с визуальным курсором
		QTextCursor txtCursor = new QTextCursor();
		teEdit.textCursor(txtCursor); // Выдернули курсор из QPlainText
		return txtCursor.blockNumber;
	}
	// ______________________________________________________________
	// Выдать строку на которой стоит визуальный курсор
	string getStrUnderCursor() { //-> Выдать строку под курсором
		QTextCursor txtCursor = new QTextCursor();
		teEdit.textCursor(txtCursor); // Выдернули курсор из QPlainText
		QTextBlock tb = new QTextBlock(txtCursor);
		return tb.text!string();		// Строка под курсором
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
		// Перерисуем номера строк, вызвам событие Paint через Update
		lineNumberArea.update();
		QKeyEvent qe = new QKeyEvent('+', ev);
		if(editSost == Sost.Normal) {
			if(qe.key == 16777216) { // ESC
				editSost = Sost.Change;
				teHelp.setCurrentCell(pozInTable, 0);
		        parentQtE5.showInfo(to!string(editSost) ~ "  " ~ to!string(qe.key));
				return null;
			}

			teEdit.textCursor(txtCursor); // Выдернули курсор из QPlainText

			// Ctrl+Spase вставка верхнего слова с таблицы
			if( (qe.key == QtE.Key.Key_Space) & (qe.modifiers == QtE.KeyboardModifier.ControlModifier) ) {
				insWordFromTableByNomer(0, txtCursor);
				return null;
			}

			// Ctrl+D - удаление строки
			if( (qe.key == QtE.Key.Key_D) & (qe.modifiers == QtE.KeyboardModifier.ControlModifier) ) {
				txtCursor.select(QTextCursor.SelectionType.BlockUnderCursor).removeSelectedText();
				txtCursor.movePosition(QTextCursor.MoveOperation.NextBlock);
				txtCursor.movePosition(QTextCursor.MoveOperation.NextWord);
				teEdit.setTextCursor(txtCursor);
				return null;
			}

			// Ctrl+K - удаление до конца строки
			if( (qe.key == QtE.Key.Key_K) & (qe.modifiers == QtE.KeyboardModifier.ControlModifier) ) {
				return null;
			}

			if(qe.key == 16777266) { // F3
				int poz = txtCursor.positionInBlock();
				QTextBlock tb = new QTextBlock(txtCursor);
				// Строка под курсором
				string strFromBlock = tb.text!string();
				// Вычленить слово и по нему заполнить таблицу
				string ffWord = getWordLeft(strFromBlock, poz);
				parentQtE5.finder1.getSubFromAll(ffWord);
				setTablHelp( parentQtE5.finder1.getSubFromAll(ffWord) );
				sbSoob.showMessage("[" ~ ffWord ~ "]  --> Список вхождений");
				return null;
			}

			if(qe.key == 16777268) { // F5
				txtCursor.beginEditBlock();
				txtCursor.movePosition(QTextCursor.MoveOperation.Start);
				// Два раза вниз
				txtCursor.movePosition(QTextCursor.MoveOperation.NextBlock);
				txtCursor.movePosition(QTextCursor.MoveOperation.NextBlock);

				// txtCursor.movePosition(QTextCursor.MoveOperation.StartOfBlock);
				txtCursor.insertText("ABCD");
				txtCursor.movePosition(QTextCursor.MoveOperation.EndOfBlock);
				txtCursor.insertText("EFGH");
				teEdit.setTextCursor(txtCursor);
				txtCursor.endEditBlock();
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
			setTablHelp(parentQtE5.finder1.getEq(ffWord));
			// Добавим в поисковик текущую строку
			parentQtE5.finder1.addLine(strFromBlock);
			// Показать строку статуса
			parentQtE5.showInfo(to!string(editSost) ~ "  " ~ to!string(qe.key) ~ "  " ~ format("%s", qe.modifiers()));
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
/* 			if(qe.key == 16777220) { // CR
				insWordFromTableByNomer(pozInTable, txtCursor);
				sbSoob.showMessage("");
			}
 */			// Space - вернуть выбранное слово из таблицы и уйти в редактор
			if( (qe.key == QtE.Key.Key_Space) & (qe.modifiers == QtE.KeyboardModifier.NoModifier) ) {
				insWordFromTableByNomer(pozInTable, txtCursor);  return null;
			}


			return null;
		}
		return ev;	// Вернуть событие в C++ Qt для дальнейшей обработки
	}
	// ______________________________________________________________
	void insWordFromTableByNomer(int poz, QTextCursor txtCursor) { //-> Вставить слово из таблицы по номеру в редактируемый текст
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
	// ____________________________________________________________________
	string getNameEditFile() { //-> Выдать имя редактируемого в данный момент файла
		return nameEditFile;
	}
}


// =================================================================
// CFormaMain - Главная Форма для работы
// =================================================================
extern (C) {
	void on_knOpen(CFormaMain* uk)		{ (*uk).OpenFile();  }
	void on_knNew(CFormaMain* uk)		{ (*uk).NewFile();  }
	// Сохранение файла
	void on_knSave(CFormaMain* uk)		{ (*uk).SaveFile();  }
	// Обработчик с параметром. Параметр позволяет не плодить обработчики
	void on_about(CFormaMain* uk) 		{ (*uk).about(1); }
	void on_aboutQt(CFormaMain* uk)		{ (*uk).about(2); }
	void on_Exit(CFormaMain* uk)			{ (*uk).runExit(); }
	void on_DynAct(CFormaMain* uk, int n) { (*uk).runDynAct(n);  }
	void onRunApp(CFormaMain* uk)       { (*uk).runRunApp(); }
	void onRunProj(CFormaMain* uk)       { (*uk).runRunProj(); }
	void onSwEdit(CFormaMain* uk, int n) {  (*uk).runSwEdit(n); }
}
// __________________________________________________________________
class CFormaMain: QMainWindow { //=> Основной MAIN класс приложения
	const  nameCompile = "dmd.exe"; 		// Имя компилятора
	string[10]	listFilesForParser;			// Массив с файлами для парсинга 0 .. 9
	string[10]	listFileModul;				// Список с файлами модулями 0 .. 9
	string 		nameFileShablons;			// Имя файла шаблонов
	string		nameMainFile;				// Имя main файла

	QMdiArea		mainWid;				// Область дочерних mdi виджетов

	CEditWin[maxKolEdit]	winEdit;		// 10 окошек Edit
	QPushButton[maxKolEdit] winKnEdit;      // 10 кнопок переключателей
	QAction[maxKolEdit]     winAcEdit;		// 10 обработчиков событий

	CEditWin				activeWinEdit;	// Активный в данный момент редактор
	int 			winEditKol;				// Количество окошек редактора
	QMenu menu1, menu2;						// Меню
	QAction[] menuActDyn;
	QMenu[] menuDyn;						// Динамическое меню
	QMenuBar mb1;							// Строка меню сверху
	QAction acOpen, acNewFile, acSave, acSaveAs;	// Обработчики
	QAction acAbout, acAboutQt, acExit, acRunApp, acRunProj;
	QStatusBar      stBar;					// Строка сообщений
	QToolBar tb, tbSwWin;					// Строка кнопок
	string[]	sShabl;						// Массив шаблонов. Первые 2 цифры - индекс
	CFinder finder1;						// Поисковик

	// ______________________________________________________________
	this() { //-> Базовый конструктор
		// Главный виджет, в который всё вставим
		super();
		mainWid = new QMdiArea(this);

		// Обработчики
		acExit	= new QAction(this, &on_Exit,   aThis);
		acExit.setText("Exit").setHotKey(QtE.Key.Key_Q | QtE.Key.Key_ControlModifier);
		acExit.setIcon("ICONS/doc_error.ico").setToolTip("Выйти из ide5");
		connects(acExit, "triggered()", acExit, "Slot()");

		acOpen	= new QAction(this, &on_knOpen,   aThis);
		acOpen.setText("Open").setHotKey(QtE.Key.Key_O | QtE.Key.Key_ControlModifier);
		acOpen.setIcon("ICONS/DocAdd.ico").setToolTip("Загрузить файл с диска ...");
		connects(acOpen, "triggered()", acOpen, "Slot()");

		acNewFile	= new QAction(this, &on_knNew,   aThis);
		acNewFile.setText("New").setHotKey(QtE.Key.Key_N | QtE.Key.Key_ControlModifier);
		acNewFile.setIcon("ICONS/DocEdit.ico").setToolTip("Новый файл ...");
		connects(acNewFile, "triggered()", acNewFile, "Slot()");

		acSave	= new QAction(this, &on_knSave,   aThis);
		acSave.setText("Save").setHotKey(QtE.Key.Key_S | QtE.Key.Key_ControlModifier);
		acSave.setIcon("ICONS/save.ico").setToolTip("Сохранить на диск ...");
		connects(acSave, "triggered()", acSave, "Slot()");

		// acSaveAs = new QAction(this, &on_knOpen,   aThis);
		// acSaveAs.setText("Save as").setHotKey(QtE.Key.Key_S | QtE.Key.Key_ControlModifier);
		// connects(acSaveAs, "triggered()", acSave, "Slot()");

		// Актион
		acRunApp = new QAction(this, &onRunApp, aThis);
		acRunApp.setText("Старт").setHotKey(QtE.Key.Key_R | QtE.Key.Key_ControlModifier);
		acRunApp.setIcon("ICONS/document_into.ico").setToolTip("Компилировать и выполнить ...");
		connects(acRunApp, "triggered()", acRunApp, "Slot()");

		acRunProj = new QAction(this, &onRunProj, aThis);
		acRunProj.setText("СтартПоект").setHotKey(QtE.Key.Key_P | QtE.Key.Key_ControlModifier);
		acRunProj.setIcon("ICONS/nsi.ico").setToolTip("Компилировать и выполнить проект ...");
		connects(acRunProj, "triggered()", acRunProj, "Slot()");

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

/* 		for(int j; j !=2; j++) {
			menuDyn ~= new QMenu(this);
			menuDyn[j].setTitle("Бар №" ~ to!string(j));
			mb1.addMenu(menuDyn[j]);
			// Моделируем цикл
			for(int i; i !=4; i++) {
				menuActDyn ~= new QAction(this, &on_DynAct,   aThis, (j * 10 ) + i);
				menuActDyn[i].setText("Меню №" ~ to!string(i));
				menuDyn[j].addAction(menuActDyn[i]);
				connects(menuActDyn[i], "triggered()", menuActDyn[i], "Slot_v__A_N_v()");
			}
		}
 */
		// ToolBar
		tb = new QToolBar(this); tbSwWin = new QToolBar(this);
		// tb.setStyleSheet(strElow);
		tbSwWin.setStyleSheet( strElow );
		// Настраиваем ToolBar
		tb.setToolButtonStyle(QToolBar.ToolButtonStyle.ToolButtonTextBesideIcon);
		tb
			.addAction(acOpen)
			.addSeparator()
			// .addAction(acExit)
			.addAction(acRunApp)
			.addAction(acRunProj);

		addToolBar(QToolBar.ToolBarArea.TopToolBarArea, tb);

		tbSwWin.setToolButtonStyle(QToolBar.ToolButtonStyle.ToolButtonTextBesideIcon);
		addToolBar(QToolBar.ToolBarArea.BottomToolBarArea, tbSwWin);

		setMenuBar(mb1);
		setStatusBar(stBar);

		// Центральный виджет в QMainWindow
		setCentralWidget(mainWid);
		setNoDelete(true); // Не вызывай delete C++ для этой формы

		// Читаем параметры из INI файла
		readIniFile();
		// Настроим парсер
		finder1 = new CFinder();
		loadParser();

		// Читаем файл шаблонов
		File fhFileSh;
		if(!exists(nameFileShablons)) {
			msgbox("Нет файла шаблонов: " ~ "<b>" ~ nameFileShablons ~ "</b>",
				"Внимание! стр: " ~ to!string(__LINE__),
				QMessageBox.Icon.Critical);
		} else {
			// Читать файл шаблонов
			try {
				fhFileSh = File(nameFileShablons, "r");
			} catch {
				msgbox("Не могу открыть: " ~ nameFileShablons, "Внимание! стр: "
					~ to!string(__LINE__), QMessageBox.Icon.Critical);
				return;
			}
		}
		try {
			int ks, ind;
			foreach(line; fhFileSh.byLine()) {
				if(line.length > 0) if((line[0] == '#') || (line[0] == ';')) continue;
				// Проверка на BOM
				if(ks++ == 0) if(line.length>2 && line[0]==239 && line[1]==187 && line[2]==191) line = line[3 .. $].dup;
				string str = to!string(line);
				// Нужная мне строка с указанием действий
				if( (str.length > 0) && ( str[0] == '%') ) {
					auto partStr = split(str, "|");
					// Горизонтальное или вертикальное меню?
					if(str[2] == '|') {		// Это описание горизонтального
						int nomj = to!int(str[1])-48;
						// Создадим пункт горизонтального меню
						menuDyn ~= new QMenu(this);
						menuDyn[nomj].setTitle(to!string(partStr[1]));
						mb1.addMenu(menuDyn[nomj]);
					} else {				// Это описание вертикального
						int nomj = to!int(str[1])-48;
						int nomi = to!int(str[2])-48;
						// Создадим пункт вертикального меню
						ind = ((nomj+1) * 10 ) + nomi + 1;
						QAction tmpAct = new QAction(this, &on_DynAct, aThis, ind);
						tmpAct.setText(partStr[1]);
						menuActDyn ~= tmpAct;
						// writeln("[", partStr[1],"] nomJ = ", nomj, "   nomI = ", nomi);
						menuDyn[nomj].addAction(tmpAct);
						connects(tmpAct, "triggered()", tmpAct, "Slot_v__A_N_v()");
					}
				} else {
					if(ind > 0) sShabl ~= format("%2s", ind) ~ str;
				}
			}
		} catch {
			msgbox("Не могу читать: " ~ nameFileShablons, "Внимание! стр: "
				~ to!string(__LINE__), QMessageBox.Icon.Critical);
			return;
		}
	}
	~this() {
	}
	// ______________________________________________________________
	void loadParser() { //-> Загрузить парсер файлами из проекта
		// Заполним парсер
		try {
			foreach(nameFilePrs; listFPrs()) {
				if(exists(nameFilePrs)) finder1.addFile(nameFilePrs);
			}
		} catch {
			msgbox("Не могу загрузить файлы из INI в парсер: ", "Внимание! стр: "
				~ to!string(__LINE__), QMessageBox.Icon.Critical);
			return;
		}
	}
	// ______________________________________________________________
	void setActWinForNom(int nom, bool y) { //-> Покрась в активный цвет кнопку
		if(y) {
			winKnEdit[nom].setStyleSheet(strGreen);
		} else {
			winKnEdit[nom].setStyleSheet(strElow);
		}
	}
	// ______________________________________________________________
	void runSwEdit(int n) { //-> Переключатель экранов
		// Есть номер экрана ...
		try {
			if(!winEdit[n].isVisible()) winEdit[n].setVisible(true);
			winEdit[n].showMaximized(); winEdit[n].teEdit.setFocus();
			if(n != activeWinEdit.tekNomer) {
				setActWinForNom(n, true); setActWinForNom(activeWinEdit.tekNomer, false);
			}
			activeWinEdit = winEdit[n];
		} catch {
			winKnEdit[n].setEnabled(false); 	winKnEdit[n].setText("");
		}
	}
	// ______________________________________________________________
	string nameDMDonOs() { //-> Выдать имя компилятора в зависимости от ОС
		string rez;
		version (Windows) {	rez = nameCompile;         }
		version (linux)   { rez = nameCompile[0..$-4]; }
		return rez;
	}
	// ______________________________________________________________
	void runRunProj() { //-> Компиляция и запуск проекта
		string[] listModuls; // Список модулей
		if(nameMainFile == "") {
			msgbox("Не задано имя файла с main()", "Внимание! стр: "
				~ to!string(__LINE__), QMessageBox.Icon.Critical);
			return;
		}
		listModuls ~= nameDMDonOs();	// Имя компилятора
		listModuls ~= nameMainFile; 	// Файл с именем main() - имя программы
		for(int i; i != 10; i++) {
			if(listFileModul[i] != "") {
				listModuls ~= listFileModul[i];
			}
		}
		// Готовимся к компиляции
		string nameLog = constNameLog;
		auto logFile = File(nameLog, "w");
			auto pid = spawnProcess(listModuls,
				std.stdio.stdin,
				std.stdio.stdout,
				logFile
			);
		if (wait(pid) != 0) {
			string sLog = cast(string)read(nameLog);
			msgbox(sLog, "Ошибки компиляции ...");
		} else {
			string nameRunFile;
			version (Windows) {
				nameRunFile = nameMainFile[0..$-2];
			}
			version (linux) {
				nameRunFile = "./" ~ nameMainFile[0..$-2];
			}
			writeln(toCON("---- Выполняю: " ~ nameRunFile), " ------------------------");
			// msgbox(nameRunFile ~ " -- запускаю программу", "Внимание!");
			try {
				auto pid2 = spawnProcess([nameRunFile]);
			} catch {
				msgbox(nameRunFile ~ " -- Ошибка выполнения ...", "Внимание! стр: "
					~ to!string(__LINE__), QMessageBox.Icon.Critical);
				return;
			}
		}
	}
	// ______________________________________________________________
	void runRunApp() { //-> Компиляция и запуск
		SaveFile();		// Сохраним перед запуском
		// Определим активное окно редактора
		int aWinEd = actWinEdit();
		if(aWinEd == -1) {
			msgbox("Нет активного окна для выполнения кода!", "Внимание! стр: "
				~ to!string(__LINE__), QMessageBox.Icon.Critical);
			return;
		}
		string nameFile = winEdit[aWinEd].getNameEditFile();
		string nameLog = constNameLog;
		if(nameFile == "") {
			msgbox("Не задано имя файла, не могу компилировать", "Внимание! стр: "
				~ to!string(__LINE__), QMessageBox.Icon.Critical);
			return;
		}
		if(aWinEd > -1) {
			auto logFile = File(nameLog, "w");
				auto pid = spawnProcess([nameDMDonOs(), nameFile, "asc1251", "qte5"],
					std.stdio.stdin,
					std.stdio.stdout,
					logFile
				);
			if (wait(pid) != 0) {
				string sLog = cast(string)read(nameLog);
				msgbox(sLog, "Ошибки компиляции ...");
			} else {
				writeln(toCON("---- Выполняю: " ~ nameFile[0..$-2]), " ------------------------");
				// msgbox(nameFile[0..$-2]);
				auto pid2 = spawnProcess([nameFile[0..$-2]]);
			}
		} else {
			msgbox("Не выбрано окно исходного текста для сохранения", "Внимание! стр: "
				~ to!string(__LINE__), QMessageBox.Icon.Critical);
		}
	}
	// ______________________________________________________________
	void runDynAct(int nom) { //-> Процедура обработки меню шаблона
		// Определим активное окно редактора
		int aWinEd = actWinEdit();
		if(aWinEd > -1) {
			string s = winEdit[aWinEd].getStrUnderCursor();
			// крутим массив шаблонов и выводим строки сод индекс
			foreach(strm; sShabl) {
				if(strm[0..2] == format("%2s", nom)) {
					winEdit[aWinEd].teEdit.insertPlainText(
						"\n" ~ getOtstup(s) ~ strm[2..$]
					);
				}
			}
		} else {
			msgbox("Не выбрано окно редактора для вставки шаблона", "Внимание! стр: "
				~ to!string(__LINE__), QMessageBox.Icon.Critical);
		}
	}
	// ______________________________________________________________
	void readIniFile() { //-> Прочитать INI файл в память
		Ini ini = new Ini(sIniFile);
		for(int i; i != 10; i++) listFilesForParser[i] = strip(ini["ForParser"]["FileParser" ~ to!string(i)]);
		nameFileShablons = ini["Main"]["FileShablons"];
		nameMainFile = ini["Project"]["FileMain"];
		for(int i; i != 10; i++) listFileModul[i] = strip(ini["Project"]["FileMod" ~ to!string(i)]);
	}
	// ______________________________________________________________
	string[] listFPrs() { //-> Выдать список имен файлов для парсинга
		return listFilesForParser;
	}
	// ______________________________________________________________
	int actWinEdit() { //-> либо номер активногоокна, либо -1 если нет активных
		int rez = -1;
		foreach(ed; winEdit) {
			if(ed is null) continue;
			try {
				if(ed.teEdit.hasFocus())     { rez = ed.tekNomer; break; }
				if(ed.teHelp.hasFocus())     { rez = ed.tekNomer; break; }
				if(ed.sliderTabl.hasFocus()) { rez = ed.tekNomer; break; }
			} catch {
				return -1;
			}
		}
		return rez;
	}
	// ______________________________________________________________
	void SaveFile() { //-> Сохранить файл на диске
		// Определим активное окно редактора
		int aWinEd = actWinEdit();
		if(aWinEd > -1) {
			if(winEdit[aWinEd].getNameEditFile() == "") {
				QFileDialog fileDlg = new QFileDialog('+', null);
				string cmd = fileDlg.getSaveFileNameSt("Save file ...", "", "*.d *.ini *.txt");
				if(cmd != "") {
					winEdit[aWinEd].nameEditFile = cmd;
					winEdit[aWinEd].setWindowTitle(cmd);
					winKnEdit[aWinEd].setText(cmd);
				} else {
					return;
				}
			}
			winEdit[aWinEd].runCtrlS();
		} else {
			msgbox("Не выбрано окно исходного текста для сохранения", "Внимание! стр: "
				~ to!string(__LINE__), QMessageBox.Icon.Critical);
		}
	}
	// ______________________________________________________________
	void NewFile() { //-> Запросить файл для редактирования и открыть редактор
		EditFile("");
	}
	// ______________________________________________________________
	void OpenFile() { //-> Запросить файл для редактирования и открыть редактор
		QFileDialog fileDlg = new QFileDialog('+', null);
		string cmd = fileDlg.getOpenFileNameSt("Open file ...", "", "*.d *.ini *.txt");
		if(cmd != "") EditFile(cmd);
	}
	// ______________________________________________________________
	void EditFile(string nameFile) { //-> Открыть файл для редактирования
		int preNomAct = -1;
		if(winEditKol < maxKolEdit) {
			if(activeWinEdit !is null) preNomAct = activeWinEdit.tekNomer;
			// writeln(preNomAct, " is active ", activeWinEdit);
			winEdit[winEditKol] = new CEditWin(this, QtE.WindowType.Window);
			// winEdit[winEditKol].setNoDelete(true);
			winEdit[winEditKol].setParentQtE5(this);
			winEdit[winEditKol].saveThis(&winEdit[winEditKol]);
			mainWid.addSubWindow(winEdit[winEditKol]);
			activeWinEdit = winEdit[winEditKol]; // Активный в данный момент
			winEdit[winEditKol].tekNomer = winEditKol;
			if(nameFile != "") {
				winEdit[winEditKol].openWinEdit(nameFile);
			} else {
				// winEdit[winEditKol].loadParser(); // Заполним парсер
			}
			winEdit[winEditKol].showNormal();
			winEdit[winEditKol].teEdit.setFocus();
			// Делаю для него кнопку
			winKnEdit[winEditKol] = new QPushButton(nameFile, this);
			tbSwWin.addWidget(winKnEdit[winEditKol]);
			winAcEdit[winEditKol] = new QAction(this, &onSwEdit, aThis, winEditKol);
			connects(winKnEdit[winEditKol], "clicked()", winAcEdit[winEditKol], "Slot_v__A_N_v()");

			setActWinForNom(winEditKol, true);
			if(preNomAct > -1) setActWinForNom(preNomAct, false);
			winEditKol++;
		}
	}
	// ______________________________________________________________
	// Обработка About и AboutQt
	void about(int n) {
		if(n == 1) {

			msgbox("MGW 2016

miniIDE for dmd + QtE5 + Qt-5

ver 0.1", "About ...");
		}
		if(n == 2) {	app.aboutQt();	}
	}
	// ______________________________________________________________
	void showInfo(string s) { //-> Отобразить строку состояния
		stBar.showMessage(s);
	}
	// ______________________________________________________________
	void runExit() { //-> Выйти из программы
		hide();	app.exit(0);
	}
}
// __________________________________________________________________
// Глобальные, независимые функции
string getOtstup(string str) { // Вычислить отступ используя строку
	string rez;
	if(str == "") return rez;
	// writeln(representation(cast(char[])str));
	for(int i; i != str.length; i++) {
		if( (str[i] == ' ') || (str[i] == '\t')  ) {
			rez ~= str[i];
		} else break;
	}
	// writeln(representation(cast(char[])rez));
	return rez;
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

	// Проверяем путь до INI файла
	if(!exists(sIniFile)) {
		msgbox("Нет INI файла: " ~ "<b>" ~ sIniFile ~ "</b>", "Внимание! стр: " ~ to!string(__LINE__),
			QMessageBox.Icon.Critical); return(1);
	}
	CFormaMain formaMain = new CFormaMain(); formaMain.show().saveThis(&formaMain);
	QEndApplication endApp = new QEndApplication('+', app.QtObj);
	return app.exec();
}

// Проверка изменений
