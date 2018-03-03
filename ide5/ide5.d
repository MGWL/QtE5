//------------------------------!
// Прототип IDE для D + QtE5
// MGW 29.04.2016 17:00:10 -- 1 version
// MGW 04.11.2017 00:22:00 -- 2 version
//------------------------------
// dmd ide5 qte5prs asc1251 ini qte5 -release -m32

import asc1251;				// Поддержка cp1251 в консоли
import std.getopt;			// Раазбор аргументов коммандной строки
// import qte5;
import qte5, core.runtime;
import std.stdio;
import std.conv;
import std.string;
import std.file;
import ini;					// Работа с INI файлами
import qte5prs;				// Парсер исходного кода
import std.process;
import std.path;
import core.time: Duration;
import std.datetime.stopwatch: StopWatch;

string nameApp = "IDE5 - mini ide for D";
string  verApp = "ver 1.0.1 ";
string timeStm = "[ " ~ __TIMESTAMP__ ~ " ]";

const strElow  = "background: #F8FFA1";
const strGreen = "background: #F79F81";
const strEdit  = "font-size: 9pt; font-family: 'Anonymous Pro';";
const strTabl  = "font-size: 9pt; font-family: 'Anonymous Pro';";
const constMesAhtung = "Внимание! стр: ";
const constNameLog = "dmderror.log"; 	// Имя файла протокола

// __________________________________________________________________
string helps() {
	return	toCON(
"Использование ide5:
--------------------------------
Запуск:
ide5 [-d, -i] ИмяINIфайлаПроекта.ini
");
}
// __________________________________________________________________
class CLineNumberArea : QWidget {
 private
	// QPlainTextEdit		teEdit;

	this(){}
	this(QPlainTextEdit parent) { //-> Базовый конструктор
		super(parent); // setStyleSheet(strElow);
		// teEdit = parent; // setStyleSheet(strElow);
	}
}

//============================================
//====         Форма Окно редактора       ====
//============================================
extern (C) {
	void* onKeyReleaseEvent(CEditWin* uk, void* ev)      { return (*uk).runKeyReleaseEvent(ev); }
	void* onKeyPressEvent(CEditWin* uk, void* ev)        { return (*uk).runKeyPressEvent(ev); }
	void  onResEventEdit(CEditWin* uk, void* ev)         { (*uk).ResEventEdit(ev); };
	void  onPaintCEditWin(CEditWin* uk, void* ev, void* qpaint)  { (*uk).runPaint(ev, qpaint); };
	void  onPaintCEditWinTeEdit(CEditWin* uk, void* ev, void* qpaint)  { (*uk).runPaintTeEdit(ev, qpaint); };
	void  onMouseKeyPressEvent(CEditWin* uk, void* ev)   { (*uk).runMouseKeyPressEvent(ev); };
	void  onMouseQWheelEvent(CEditWin* uk, void* ev)     { (*uk).runMouseQWheelEvent(ev); };
	void  onNumStr(CEditWin* uk, int n)                  { (*uk).runNumStr(); }; // Это спин
}
// __________________________________________________________________
class CEditWin: QWidget { //=> Окно редактора D кода
  private
	const sizeTabHelp = 30;
	enum Sost { //-> Состояние редактора
		Normal,			// Нормальное состояние
		Cmd,			// Командный режим
		Change			// Режим работы с таблицей подсказок
	}
	Sost editSost = Sost.Normal;				// Состояние редактора
	// Текущее слово поиска для finder1.
	// Алгоритм поиска:
	//     Если в слове нет точки, то ffWord=слово, ffMetod=""
	//     Если в слове есть точка, то ffWord=слово_без_метода, ffMetod=метод
	string ffWord, ffMetod;

	QVBoxLayout		vblAll;						// Общий вертикальный выравниватель
	QHBoxLayout		hb2;						// Горизонтальный выравниватель
	
	QPlainTextEdit	teEdit;						// Окно Редактора
	QTableWidget	teHelp;						// Таблица подсказок
	QStatusBar		sbSoob;						// Строка статуса
	Highlighter 	highlighter;				// Подсветка синтаксиса
	CLineNumberArea	lineNumberArea;				// Область нумерации строк
	QAction acNumStr;			// Событие для перехода на строку
	
	QRect 			RectContens;				// Промежуточные вычисления для гум строк
	QPainter	qp;
	QTextBlock tb1;
	QTextCursor txtCursor;
	string strNomerStr;
	QFont   fontPainter;
	bool fYasPaint;
	int pozInTable;								// Позиция в таблице

	CFormaMain parentMainWin;					// Ссылка на родительскую форму
	QTableWidgetItem[sizeTabHelp] mTi;	// Массив на sizeTabHelp ячеек подсказок
	
	static enum mPointMax = 10;
	int[mPointMax] mPoint;						// Массив точек для запом позиции в Редакторе
	int     sizeFontEditor;
	string	nameEditFile;						// Имя файла редактируемого в данный момент

	QSpinBox	spNumStr;						// Спин для перехода на строку
	QWidget 	wdFind;							// Виджет строки поиска поиска
	QHBoxLayout laFind;							// Выравниватель
	QLineEdit	leFind;							// Строка поиска
	QCheckBox	cbReg;							// T - регулярное выражение
	QCheckBox	cbCase;							// T - рег зависимый поиск
	bool trigerNumStr;							// Странно, но 2 раза вызывается ... отсечем 2 раз
	string 	strBeforeEnter;		// Строка перед нажатием на Enter
	// ______________________________________________________________
	this(){}
	// ______________________________________________________________
	// Конструктор по умолчанию
	this(QWidget parent, QtE.WindowType fl) { //-> Базовый конструктор
		super(parent, fl);
		
		// Горизонтальный и вертикальный выравниватели
		vblAll  = new  QVBoxLayout(null);		// Главный выравниватель
		hb2  	= new  QHBoxLayout(null);		// Горизонтальный выравниватель
		
		// Настройка редактора
		teEdit = new QPlainTextEdit(this);	 // teEdit.setStyleSheet(strElow);
		teEdit.setTabStopWidth(24).setStyleSheet(strEdit);

		{
			scope QTextOption textOption = new QTextOption(null);
			textOption.setWrapMode(QTextOption.WrapMode.NoWrap);
			teEdit.setWordWrapMode(textOption);
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

		// Делаю массив для таблицы
 		for(int i; i != sizeTabHelp; i++) {
			mTi[i] = new QTableWidgetItem(0);
			mTi[i].setText("");
			teHelp.setItem(i, 0, mTi[i]);
		}

		// Подсветка синтаксиса
		highlighter = new Highlighter(teEdit.document());
		highlighter.setNoDelete(true);

		// Область нумерации строк
 		lineNumberArea = new CLineNumberArea(teEdit); 
		lineNumberArea.saveThis(&lineNumberArea);

		// Для Painter
		RectContens    = new QRect();
				   tb1 = new QTextBlock();
		txtCursor      = new QTextCursor(null); // Явно ошибка, но непонятно в чем
		fontPainter    = new QFont();

		setResizeEvent(&onResEventEdit, aThis);
		
		lineNumberArea.setMousePressEvent(&onMouseKeyPressEvent, aThis);
		lineNumberArea.setMouseWheelEvent(&onMouseQWheelEvent, aThis);
		
		teEdit.setViewportMargins(70, 0, 0, 0);
		
		        teEdit.setPaintEvent(&onPaintCEditWinTeEdit, aThis());
		lineNumberArea.setPaintEvent(&onPaintCEditWin,       aThis());
		
		// Готовлю сттруктуру и виджет для поиска
		wdFind = new QWidget(this); wdFind.hide();	wdFind.setMinimumWidth(100);
		laFind = new QHBoxLayout(wdFind);
		leFind = new QLineEdit(this); // leFind.setAlignment(QtE.AlignmentFlag.AlignCenter);
		cbReg =  new QCheckBox("R", this); cbReg.setToolTip("Регулярное выражение");
		cbCase = new QCheckBox("C", this); cbCase.setToolTip("РегистроЗависимость");
		laFind.addWidget(leFind).addWidget(cbReg).addWidget(cbCase);
		wdFind.setLayout(laFind);
		sbSoob.addPermanentWidget(wdFind);
		
		// Делаю спин
		spNumStr = new QSpinBox(this); spNumStr.hide(); spNumStr.setStyleSheet(strGreen);
		spNumStr.setPrefix("Goto №:  ");
		sbSoob.addPermanentWidget(spNumStr);
		acNumStr = new QAction(this, &onNumStr, aThis);
		connects(spNumStr, "editingFinished()", acNumStr, "Slot_v__A_N_v()");
	}
	// ______________________________________________________________
	// Выдать строку на которой стоит визуальный курсор
	string getStrUnderCursor() { //-> Выдать строку под курсором
		scope QTextCursor txtCursor = new QTextCursor(null);
		teEdit.textCursor(txtCursor); // Выдернули курсор из QPlainText
		sQTextBlock tb = sQTextBlock(txtCursor);
		return tb.text!string();		// Строка под курсором
	}
	// ______________________________________________________________
	void runNumStr() { //-> Обработка события перехода на строку
		spNumStr.hide();
		if(trigerNumStr) { trigerNumStr = false; return; }
		int num = spNumStr.value();
		teEdit.setCursorPosition(num - 1, 0);
		teEdit.setFocus();
		trigerNumStr = true;
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
		// А если рано 0 Возьмем строку раскраски для редактора и извлечем размер 
		auto m1 = split(strEdit, ';');
		auto m2 = split(m1[0], ':');
		if(m2[0] == "font-size") {
			sizeFontEditor = to!int(strip(m2[1][0 .. $-2]));
		}
	}
	// ______________________________________________________________
	// Вычислить номер строки для перехода по сохраненной точке
	// 0 - нет перехода
	//
	pure nothrow int lineGoTo(int tek, bool va) {
		int rez, i, ml = mPoint.length;
		if(ml == 0) return 0;
	 	if(ml == 1) return mPoint[0];
		if( (!va) && (tek > mPoint[$-1]) ) {
			rez = mPoint[$-1]; goto mm;
		}
		while((i + 1) < ml) {
			if( (mPoint[i] <= tek) && (tek <= mPoint[i+1]) ) {
				rez = va ? mPoint[i+1] : mPoint[i];
				if((rez == tek) && va) { i++; continue;	}
				break;
			} else i++;
		}
mm:
		if(rez == tek) rez = 0;
		return rez;
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
	void insNewString(string s) {
		teEdit.textCursor(txtCursor); // Выдернули курсор из QPlainText
		txtCursor.beginEditBlock();
			txtCursor.movePosition(QTextCursor.MoveOperation.StartOfBlock);
			txtCursor.insertText(s);
			txtCursor.movePosition(QTextCursor.MoveOperation.EndOfBlock);
		txtCursor.endEditBlock();
		teEdit.setTextCursor(txtCursor);
	}
	// ______________________________________________________________
	void insParaSkobki(string s) {
		txtCursor.insertText(s).movePosition(QTextCursor.MoveOperation.PreviousCharacter);
		teEdit.setTextCursor(txtCursor);
	}
	// ______________________________________________________________
	void* runKeyReleaseEvent(void* ev) { //-> Обработка события отпускания кнопки
		sQKeyEvent qe = sQKeyEvent(ev); 
		if(editSost == Sost.Normal) {
			// Переход в левую таблицу подсказки
			if(qe.key == QtE.Key.Key_Escape) { // ESC
				editSost = Sost.Change;	
				teHelp.setCurrentCell(pozInTable, 0);
				qe.ignore();
			}
		
			// Этот NL обеспечивает выравнивание блоков, отступ
			// как на предыдущей строке
			if(qe.key == QtE.Key.Key_Return) {
				// Надо найти последовательность до первого видимого символа
				insNewString(getOtstup(strBeforeEnter));
			}

			// Ctrl+Spase вставка верхнего слова с таблицы
			if( (qe.key == QtE.Key.Key_Space) & (qe.modifiers == QtE.KeyboardModifier.ControlModifier) ) {
				insWordFromTableByNomer(0, txtCursor);
				return null;
			}

			// Выделяю слово, по которому будет работать парсер
			sQTextBlock tb = sQTextBlock(txtCursor);
			string strFromBlock = tb.text!string(); int poz = txtCursor.positionInBlock();
			ffWord = getWordLeft(strFromBlock, poz); ffMetod = ""; // Строка под курсором
			//sbSoob.showMessage("ffWord = " ~ ffWord ~ " = [" ~ strFromBlock ~ "] = " ~ to!string(poz));
			
			// А может в слове есть символ "." и это метод?
			auto pozPoint = lastIndexOf(ffWord, '.');
			if(pozPoint > -1) {		// Есть '.'
				ffMetod = ffWord[pozPoint +1 .. $]; ffWord = ffWord[0 .. pozPoint];
				// sbSoob.showMessage("ffWord = " ~ ffWord ~ " - [" ~ ffMetod ~ "]");
				// Если в слове после точки стоит '-' то это нечеткий поиск
				if(ffMetod.length > 2) {
					if(ffMetod[0] == '-') {
						if(!teHelp.isHidden) {
							// Попробовать взять с списка методов
				// sbSoob.showMessage("ffMetod[1 .. $] = " ~ ffMetod[1 .. $] ~ " - [" ~ ffMetod ~ "]");
							setTablHelp(parentMainWin.finder1.getSubFromAll(ffMetod[1 .. $]));
						}
					} else {
						if(!teHelp.isHidden) {
							setTablHelp(parentMainWin.finder1.getEqMet1(ffMetod[0 .. $] ));
						}
					}
				}
			} else {				// Нет  '.'
				// Если таблица подсказки открыта, то искать слово 
				if(!teHelp.isHidden) setTablHelp(parentMainWin.finder1.getEq(ffWord));

				
				// Добавим в поисковик текущую строку, если введен пробел
				if((qe.key == QtE.Key.Key_Space) || (qe.key == QtE.Key.Key_Return)) 
					parentMainWin.finder1.addLine(strFromBlock);
				//sbSoob.showMessage("qe.key == " ~ to!string(qe.key));
			}
		} else {
			if(editSost == Sost.Change) {
				if(qe.key == QtE.Key.Key_Escape) { // ESC
					editSost = Sost.Normal;
					teHelp.setCurrentCell(100, 0);
					pozInTable = 0;
				}
				if(qe.key == QtE.Key.Key_Down) { // Стрелка вниз
					if(pozInTable < sizeTabHelp-1)	{
						string str = mTi[pozInTable+1].text!string();
						sbSoob.showMessage(parentMainWin.finder1.getRawMet(str));
						if( str != "" ) teHelp.setCurrentCell(++pozInTable, 0);
					}
				}
				if(qe.key == QtE.Key.Key_Up) { // Стрелка вверх
					if(pozInTable > 0)	{
						teHelp.setCurrentCell(--pozInTable, 0);
						string str = mTi[pozInTable].text!string();
						sbSoob.showMessage(parentMainWin.finder1.getRawMet(str));
					}
				}
				// Space - вернуть выбранное слово из таблицы и уйти в редактор
				if( (qe.key == QtE.Key.Key_Space) & (qe.modifiers == QtE.KeyboardModifier.NoModifier) ) {
					insWordFromTableByNomer(pozInTable, txtCursor);
				}
				qe.ignore();
			}
		}
		return ev;	// Вернуть событие в C++ Qt для дальнейшей обработки
	}
	// ______________________________________________________________
	void* runKeyPressEvent(void* ev) { //-> Обработка события нажатия кнопки
		sQKeyEvent qe = sQKeyEvent(ev); 
		if( editSost == Sost.Normal) {
			// Ctrl+Del удаление текущей строки
			if( (qe.key == QtE.Key.Key_Delete) & (qe.modifiers == QtE.KeyboardModifier.ControlModifier) ) {
				teEdit.textCursor(txtCursor); // Выдернули курсор из QPlainText
				
				txtCursor.beginEditBlock();
				txtCursor.select(QTextCursor.SelectionType.BlockUnderCursor).removeSelectedText();
				// txtCursor.movePosition(QTextCursor.MoveOperation.StartOfBlock);
				// txtCursor.movePosition(QTextCursor.MoveOperation.NextBlock);
				txtCursor.endEditBlock();
				
				teEdit.setTextCursor(txtCursor);
				return null;
			}
		
			switch(qe.key) {
				case '"': insParaSkobki("\"");	break;
				case '(': insParaSkobki(")");	break;
				case '[': insParaSkobki("]");	break;
				case '{': insParaSkobki("}");	break;
				case QtE.Key.Key_Return:
						sQTextBlock tb = sQTextBlock(txtCursor);
						strBeforeEnter = tb.text!string();
					break;
				case QtE.Key.Key_L:
					if(qe.modifiers == QtE.KeyboardModifier.ControlModifier) {
						editSost = Sost.Cmd;
					}
					break;
				default: break;
			}
		} else {
			if( editSost == Sost.Change) {
				qe.ignore(); return null;
			} else {
			
				if( editSost == Sost.Cmd) {
					if(qe.modifiers == QtE.KeyboardModifier.ControlModifier) {
						switch(qe.key) {
							case QtE.Key.Key_L:
								break;
							default: break;
						}
					} else {
						// Срабатывает на нажатие символа после Ctrl+L
						switch(qe.key) {
							// Вставить комментарий
							case QtE.Key.Key_Slash:
							/*
								teEdit.textCursor(txtCursor); // Выдернули курсор из QPlainText
								txtCursor.beginEditBlock();
									txtCursor.movePosition(QTextCursor.MoveOperation.StartOfBlock);
									txtCursor.insertText("// ");
									txtCursor.movePosition(QTextCursor.MoveOperation.StartOfBlock);
									txtCursor.movePosition(QTextCursor.MoveOperation.NextBlock);
								txtCursor.endEditBlock();
								teEdit.setTextCursor(txtCursor);
							*/
								break;
							// Удаоить строку
							case QtE.Key.Key_D:
							/*
								teEdit.textCursor(txtCursor); // Выдернули курсор из QPlainText
								txtCursor.beginEditBlock();
									txtCursor.select(QTextCursor.SelectionType.BlockUnderCursor).removeSelectedText();
									txtCursor.movePosition(QTextCursor.MoveOperation.StartOfBlock);
									txtCursor.movePosition(QTextCursor.MoveOperation.NextBlock);
								txtCursor.endEditBlock();
								teEdit.setTextCursor(txtCursor);
							*/
								break;
							// Запомнить номер строки для перехода
							case QtE.Key.Key_T:
								{
									auto z = 1 + getNomerLineUnderCursor();
									// Проверить, есть ли такой ... если есть убрать
									bool isTakoy;
									for(int i; i != mPointMax; i++) {
										if(mPoint[i] == z) { mPoint[i] = 0; isTakoy = true; }
									}
									if(!isTakoy) {
										// Значит такой надо вставить
										if(mPoint[0] == 0) { mPoint[0] = z; }
									}
									import std.algorithm;
									mPoint[0..$].sort!();
                                    // (cast(int[])mas).sort!();
								}
								break;
							default: break;
						}
						editSost = Sost.Normal;
					}
					return null;
				}
			}
		}
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
				findImport(str);
				teEdit.appendPlainText(str);
				// parentQtE5.finder1.addLine(str);
			}
			sbSoob.showMessage("Загружено: " ~ nameFile, 2000); 
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
	// Функция обнаружения импорта
	void findImport(string str) {
		long pozImport; string rawStr;
		pozImport = indexOf(str, "import");
		if(pozImport >= 0) {		// Искать фразу import
			rawStr = str.replace("import", "");
			rawStr = rawStr.replace(" ", "");
			// Нужно выделить список файлов;
			// На этой строке есть ';'
			if(indexOf(rawStr, ";") > 0) {			// На этой строке есть ';'
				rawStr = rawStr.replace(";", "");
				// auto mas = parentMainWin.getPathSrcDmd();
				// writeln("--0--");
				// writeln(split(rawStr, ","));
				// writeln(parentMainWin.getPathSrcDmd());
				// for(int j; j !=5; j++) writeln(parentMainWin.PathForSrcDmd[j]);
				// writeln(parentMainWin.PathForSrcDmd);
				//parentMainWin.finder1.addImpPrs(split(rawStr, ","), parentMainWin.PathForSrcDmd);
			}
		}
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
			fIsPoint = false;
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
			sbSoob.showMessage("Сохранено: " ~ nameEditFile, 2000);
		} catch(Throwable) {
			msgbox("Не могу записать: " ~ nameEditFile, constMesAhtung
				~ to!string(__LINE__), QMessageBox.Icon.Critical);
		}
	}
	// ______________________________________________________________
	void insWordFromTableByNomer(int poz, QTextCursor txtCursor) { //-> Вставить слово из таблицы по номеру в редактируемый текст
		static import std.utf;
		// Выключить подсветку таблицы
		teHelp.setCurrentCell(100, 0); editSost = Sost.Normal;
		// Слово из таблицы
		string shabl = mTi[poz].text!string(); pozInTable = 0;
		// Замена слова для поиска, словом из таблицы
		txtCursor.beginEditBlock();

		if(ffMetod == "") {
			for(int i; i != std.utf.count(ffWord); i++) {
				txtCursor.movePosition(QTextCursor.MoveOperation.PreviousCharacter, QTextCursor.MoveMode.KeepAnchor);
				txtCursor.removeSelectedText();
			}
		} else {
			for(int i; i != std.utf.count(ffMetod); i++) {
				txtCursor.movePosition(QTextCursor.MoveOperation.PreviousCharacter, QTextCursor.MoveMode.KeepAnchor);
				txtCursor.removeSelectedText();
			}
		}
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
	void on_knOpen(CFormaMain* uk)			{ (*uk).runknOpenFile();  }
	void on_knNew(CFormaMain* uk)			{ (*uk).runknNew();       }
	void on_knSave(CFormaMain* uk)			{ (*uk).SaveFile();       }
	void on_knSwap(CFormaMain* uk)			{ (*uk).runknSwap();      }
	void on_Exit(CFormaMain* uk)			{ (*uk).runExit();        }
	void on_helpIde(CFormaMain* uk) 		{ (*uk).runHelpIde();     }

	void on_about(CFormaMain* uk) 			{ (*uk).about(1);         }
	void on_aboutQt(CFormaMain* uk)			{ (*uk).about(2);         }
	
	void onPointN3(CFormaMain* uk, int n)  	{ (*uk).runPointN3(n);    }
	void onGotoNum(CFormaMain* uk)         	{ (*uk).runGotoNum();     }
	void onFind(CFormaMain* uk)            	{ (*uk).runFind();        }
	void onFindA(CFormaMain* uk)           	{ (*uk).runFindA();       }
	void on_DynAct(CFormaMain* uk, int n)   { (*uk).runDynAct(n);     }
	void onRunApp(CFormaMain* uk)           { (*uk).runRunApp();      }
	void onCompile(CFormaMain* uk)          { (*uk).runCompile();     }
	void onUnitTest(CFormaMain* uk)         { (*uk).runUnitTest();    }
	void onRunProj(CFormaMain* uk)          { (*uk).runRunProj();     }
}
// __________________________________________________________________
class CFormaMain: QMainWindow { //=> Основной MAIN класс приложения
	const  nameCompile = "dmd.exe"; 			// Имя компилятора
	string[]	listFilesForParser;				// Массив с файлами для парсинга 0 .. 9
	string[]	listFileModul;					// Список с файлами модулями 0 .. 9
	string[]	listPathSourceModul;			// Список с путями для 'import xxx'
	string[]	listFileLib;					// Список библиотек для компиляции
	string 		nameFileShablons;				// Имя файла шаблонов
	string		nameMainFile;					// Имя main файла
	string[5]	PathForSrcDmd;					// Массив путей до Win32, Win64, Linux32, Linux64, MacOSX64

	QMdiArea	mainWid;						// Область дочерних mdi виджетов
	CEditWin[]  lcd;							// Массив редакторов
	void*[]     lcdp;							// Массив Того, что возвращает QMdiArea.activeWindow
	
	// Обработчики действий
	QAction acNewFile, 
		acSwapView, acExit, acOpen, 
		acSave, acOnOffHelp, acPoint, acPointA,
		acHelpIde, acGotoNum, acCompile, acFind, acFindA,
		acRunApp, acUnitTest, acRunProj, acAbout, acAboutQt;
		
	QToolBar 	tb;  							// Строка кнопок, часть обработчиков из меню
	QStatusBar	stBar;							// Строка сообщений
	bool 		fSwap;							// Переключатель отображения окон
	
	QMenu menu1, menu2, menu3, menu4, menu5;	// Меню
	QAction[] menuActDyn;
	QMenu[] menuDyn;							// Динамическое меню
	QMenuBar mb1;								// Строка меню сверху

	QCheckBox cbDebug, cb3264;
	QLineEdit leArgApp;
	QLabel llArgApp;
//	string[] swCompile = [ "qte5", "asc1251" ];
	CFinder finder1;							// Поисковик
	string[]	sShabl;							// Массив шаблонов. Первые 2 цифры - индекс

	// ______________________________________________________________
	this(QWidget parent) { //-> Базовый конструктор
		super(parent);
		resize(900, 700);
		setWindowTitle(nameApp ~ " " ~ verApp ~ " " ~ timeStm);
		
		// Область создать
		mainWid = new QMdiArea(this);
		mainWid.setViewMode(QMdiArea.ViewMode.TabbedView);
		mainWid.setTabsClosable(true);
		mainWid.setTabsMovable(true);
		setCentralWidget(mainWid);
		
		// Актионы создать
		acAbout   = new QAction(this, &on_about,    aThis, 1); 	// 1 - парам в обработчик
		acAboutQt = new QAction(this, &on_aboutQt,  aThis, 2); 	// 2 - парам в обработчик
		
		// Обработчик для About и AboutQt
		acAbout.setText("About");
		acAbout.setIcon("ICONS/about_icon.png");
		connects(acAbout, "triggered()", acAbout, "Slot()");

		acAboutQt.setText("AboutQt");
		acAboutQt.setIcon("ICONS/qt_icon.png");
		connects(acAboutQt, "triggered()", acAboutQt, "Slot()");
		
		acNewFile	= new QAction(this, &on_knNew,   aThis);
		acNewFile.setText("New").setHotKey(QtE.Key.Key_N | QtE.Key.Key_ControlModifier);
		acNewFile.setIcon("ICONS/DocAdd.ico").setToolTip("Новый файл ...");
		connects(acNewFile, "triggered()", acNewFile, "Slot()");

		acOpen	= new QAction(this, &on_knOpen,   aThis);
		acOpen.setText("Open").setHotKey(QtE.Key.Key_O | QtE.Key.Key_ControlModifier);
		acOpen.setIcon("ICONS/document_into.ico").setToolTip("Загрузить файл с диска ...");
		connects(acOpen, "triggered()", acOpen, "Slot()");
		
		acSwapView	= new QAction(this, &on_knSwap,   aThis);
		acSwapView.setText("Swap").setHotKey(QtE.Key.Key_M | QtE.Key.Key_ControlModifier);
		acSwapView.setToolTip("Переключить интерфейс отображения Вкладок/Окон ...");
		connects(acSwapView, "triggered()", acSwapView, "Slot()");
		
		acExit	= new QAction(this, &on_Exit,   aThis);
		acExit.setText("Exit").setHotKey(QtE.Key.Key_Q | QtE.Key.Key_ControlModifier);
		acExit.setIcon("ICONS/exit_icon.png").setToolTip("Выйти из ide5");
		connects(acExit, "triggered()", acExit, "Slot()");

		acSave	= new QAction(this, &on_knSave,   aThis);
		acSave.setText("Save").setHotKey(QtE.Key.Key_S | QtE.Key.Key_ControlModifier);
		acSave.setIcon("ICONS/save.ico").setToolTip("Сохранить на диск ...");
		connects(acSave, "triggered()", acSave, "Slot()");

		acHelpIde = new QAction(this, &on_helpIde,  aThis);
		acHelpIde.setText("Help IDE");
		connects(acHelpIde, "triggered()", acHelpIde, "Slot()");
		
		acGotoNum = new QAction(this, &onGotoNum, aThis);
		acGotoNum.setText("На строку №").setHotKey(QtE.Key.Key_G | QtE.Key.Key_ControlModifier);
		acGotoNum.setIcon("ICONS/nsi.ico").setToolTip("Компилировать и выполнить проект ...");
		connects(acGotoNum, "triggered()", acGotoNum, "Slot()");
		
		// ----------------------------------------------------------------

		acFind = new QAction(this, &onFind, aThis);
		acFind.setText("Поиск V").setHotKey(
			QtE.Key.Key_F | QtE.KeyboardModifier.ControlModifier);
		// acFind.setIcon("ICONS/nsi.ico").setToolTip("Компилировать и выполнить проект ...");
		connects(acFind, "triggered()", acFind, "Slot()");

		acFindA = new QAction(this, &onFindA, aThis);
		acFindA.setText("Поиск A").setHotKey(
			QtE.Key.Key_F | QtE.KeyboardModifier.ControlModifier  | QtE.KeyboardModifier.ShiftModifier);
		// acFind.setIcon("ICONS/nsi.ico").setToolTip("Компилировать и выполнить проект ...");
		connects(acFindA, "triggered()", acFindA, "Slot()");

		// Актион
		acRunProj = new QAction(this, &onRunProj, aThis);
		acRunProj.setText("СтартПоект").setHotKey(QtE.Key.Key_P | QtE.Key.Key_ControlModifier);
		acRunProj.setIcon("ICONS/gcalc.ico").setToolTip("Компилировать и выполнить проект ...");
		connects(acRunProj, "triggered()", acRunProj, "Slot()");
		
		acCompile = new QAction(this, &onCompile, aThis);
		acCompile.setText("Compile").setHotKey(QtE.Key.Key_B | QtE.Key.Key_ControlModifier);
		acCompile.setIcon("ICONS/unmark.ico").setToolTip("Компилировать и выполнить ...");
		acCompile.setToolTip("Просто компиляция без выполнения, проверка ошибок ...");
		connects(acCompile, "triggered()", acCompile, "Slot()");
		
		acRunApp = new QAction(this, &onRunApp, aThis);
		acRunApp.setText("Run").setHotKey(QtE.Key.Key_R | QtE.Key.Key_ControlModifier);
		acRunApp.setIcon("ICONS/continue.ico").setToolTip("Компилировать и выполнить ...");
		connects(acRunApp, "triggered()", acRunApp, "Slot()");

		acUnitTest = new QAction(this, &onUnitTest, aThis);
		acUnitTest.setText("UnitTest");
		acUnitTest.setIcon("ICONS/Tester.ico").setToolTip("Компилировать UnitTest и выполнить ...");
		connects(acUnitTest, "triggered()", acUnitTest, "Slot()");

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

		acOnOffHelp = new QAction(this, &onPointN3, aThis, 3);
		acOnOffHelp.setText("On/Off Таблица").setHotKey(QtE.Key.Key_H | QtE.Key.Key_ControlModifier);
		connects(acOnOffHelp, "triggered()", acOnOffHelp, "Slot_AN()");
		// ----------------------------------------------------------------
		
		// CheckBox for debug compile options
		cbDebug = new QCheckBox(this);
		cbDebug.setText("debug");
		cbDebug.setToolTip("-debug --> in parametrs of compile");

		// CheckBox for 32 / 64 режима компиляции
		cb3264 = new QCheckBox(this);
		cb3264.setText("m64");
		cb3264.setToolTip("-m64 --> in parametrs of compile");

		leArgApp = new QLineEdit(this);
		llArgApp = new QLabel(this); llArgApp.setText(" App args: ");
		
		// Создать таббы и меню
		tb = new QToolBar(this);
		addToolBar(QToolBar.ToolBarArea.TopToolBarArea, tb);
		tb
			.addAction(acExit)
			.addSeparator()
			.addAction(acOpen)
			.addAction(acSave)
			.addSeparator()
			.addAction(		acCompile	)
			.addAction(		acRunApp	)
            .addAction(		acUnitTest 	)
			.addAction(		acRunProj 	)
			.addSeparator()
			.addWidget(cbDebug)
			.addWidget(cb3264)
			.addSeparator()
			.addWidget(llArgApp)
			.addWidget(leArgApp);

		// MenuBar
		mb1 = new QMenuBar(this);

        // Menu
 		menu5 = new QMenu(this), menu4 = new QMenu(this), menu3 = new QMenu(this),  
 		menu2 = new QMenu(this),  menu1 = new QMenu(this);
 		
		// --------------- Настройки меню -----------------
		menu1.setTitle("File")
			.addAction(		acNewFile	)
			.addAction(		acOpen		)
			.addAction(		acSave		)
			.addSeparator()
			.addAction(		acExit		);

		menu2.setTitle("Edit")
			.addAction(     acGotoNum	)
			.addAction(     acFind		)
			.addAction(     acFindA		)
			.addAction(     acPoint		)
			.addAction(     acPointA	);

		menu3.setTitle("Build")
			.addAction(		acCompile	)
			.addAction(		acRunApp	)
            .addAction(		acUnitTest 	)
			.addAction(		acRunProj 	);

        menu4.setTitle("View")
			.addAction(		acSwapView	)
			.addAction(		acOnOffHelp	);

        menu5.setTitle("About")
			.addAction(		acAbout	)
			.addAction(		acAboutQt	)
			.addAction(		acHelpIde	);

		mb1.addMenu(menu1).addMenu(menu2).addMenu(menu3).addMenu(menu4).addMenu(menu5);
		setMenuBar(mb1);

		// Строка сообщений
		stBar = new QStatusBar(this); // stBar.setStyleSheet(strGreen);
		setStatusBar(stBar);
		
		// Читаем параметры из INI файла
		readIniFile();
		// Настроим парсер
		finder1 = new CFinder();
		loadParser();				// Читаем в парсер файлы проекта
		
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
			} catch(Throwable) {
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
		} catch(Throwable) {
			msgbox("Не могу читать: " ~ nameFileShablons, "Внимание! стр: "
				~ to!string(__LINE__), QMessageBox.Icon.Critical);
			return;
		}
	}
	// ______________________________________________________________
	void runFind2(int n) { //-> Промежуточная для поиска
		CEditWin winEd = getActiveWinEdit(); if(winEd is null) return;
		if(winEd.wdFind.isHidden) {	
		winEd.leFind.setAllSelection();
			winEd.wdFind.show(); 		
			winEd.leFind.setFocus();
			winEd.leFind.setAllSelection();
		} else {
			winEd.wdFind.hide(); winEd.teEdit.find( winEd.leFind.text!QString(), n );
			winEd.teEdit.setFocus();
		}
	}
	// ______________________________________________________________
	void runFind() { //-> Запросить строку поиска и аргументы
		runFind2(0);
	}
	// ______________________________________________________________
	void runFindA() { //-> Запросить строку поиска и аргументы
		runFind2(1);
	}
	// ______________________________________________________________
	// Запросить номер строки и перейти на неё. При этом открывается спин на активном окне
	void runGotoNum() { //-> переход на строку N
		CEditWin winEd = getActiveWinEdit(); if(winEd is null) return;
		winEd.spNumStr.setMinimum(1).setMaximum(winEd.teEdit.blockCount());
		winEd.spNumStr.setValue(1 + winEd.getNomerLineUnderCursor());
		winEd.spNumStr.show().setFocus(); winEd.spNumStr.selectAll();
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
		lcd[last].parentMainWin = this;
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
	void runknSwap() { //-> Переключает режим отображения Закладки/Окошки
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
		
		int nomGoTo;
		switch(n) {
			case 1: // Переход на точку вверх 
				nomGoTo = activeWinEdit.lineGoTo(1 + activeWinEdit.getNomerLineUnderCursor, false);
				if(nomGoTo > 0) activeWinEdit.teEdit.setCursorPosition(nomGoTo - 1, 0);
				break;
			case 2: // Переход на точку вниз
				nomGoTo = activeWinEdit.lineGoTo(1 + activeWinEdit.getNomerLineUnderCursor, true);
				if(nomGoTo > 0) activeWinEdit.teEdit.setCursorPosition(nomGoTo - 1, 0);
				break;
			case 3: // On Off таблицы подсказок
				if(activeWinEdit.teHelp.isHidden) 
					activeWinEdit.teHelp.show(); 
				else 
					activeWinEdit.teHelp.hide();
				break;
			default: break;	
		}
	}
	// ______________________________________________________________
	void runUnitTest() { //-> Компиляция и выполнение UnitTest
		msgbox("UnitTest ... не реализовано");
	}
	// ______________________________________________________________
	void runRunProj() { //-> Компиляция и запуск проекта
		scope CEditWin activeWinEdit = getActiveWinEdit();
		if(activeWinEdit is null) return;
	
		if(nameMainFile == "") {
			msgbox("Не задано имя файла с main()", "Внимание! стр: "
				~ to!string(__LINE__), QMessageBox.Icon.Critical);
			return;
		}
		string nameRunFile = stripExtension(nameMainFile);
		string outFile = "-of=" ~ nameRunFile;
		string ss, nameLog = constNameLog;
		auto logFile = File(nameLog, "w");
		
		string[] swCompileMain = [ nameDMDonOs() ]; // ] , "-release", nameFile];
		
		if(cbDebug.checkState == QtE.CheckState.Checked)	swCompileMain ~= "-debug" ~ "-g";
		else												swCompileMain ~= "-release";
		if(cb3264.checkState == QtE.CheckState.Checked)		swCompileMain ~= "-m64";
		else												swCompileMain ~= "-m32";
		swCompileMain ~= outFile;
		foreach(el; listPathSourceModul) swCompileMain ~= ("-I=" ~ el);
		swCompileMain ~= listFileLib;
		
		swCompileMain ~= nameMainFile ~ listFileModul;
		ss = join(swCompileMain, ' ');
		showInfo("Компиляция: " ~ ss);
		
			writeln();
			writeln("----------------------------------------");
			writeln("Compile: " ~ ss);
		StopWatch sw;
		sw.reset();
		sw.start();
		auto pid = spawnProcess(swCompileMain,
			std.stdio.stdin, std.stdio.stdout, logFile
		);
		if (wait(pid) != 0) {
			string sLog = cast(string)read(nameLog);
			msgbox(sLog, "Compile  ...", QMessageBox.Icon.Critical);
		} else {
			sw.stop();
			Duration t1 = sw.peek();

			writeln("Compile time: " ~ t1.toString());
			string appargs = leArgApp.text!string();
			auto mAppArgs = split(appargs, ' ');

			writeln();
			writeln("Run project: " ~ nameRunFile ~ " " ~ appargs);
			writeln("----------------------------------------");

			try {
				auto pid2 = spawnProcess([ nameRunFile ] ~  mAppArgs);
			} catch(Throwable) {
				writeln("Panic: " ~ nameRunFile ~ " " ~ appargs);
			}
		}
		activeWinEdit.teEdit.setFocus();
	}
	// ______________________________________________________________
	void runCompile() { //-> Компиляция проверка ошибок
		scope CEditWin activeWinEdit = getActiveWinEdit();
		if(activeWinEdit is null) return;

		string nameFile = activeWinEdit.getNameEditFile();
		if(nameFile == "???") {
			msgbox("Не задано имя файла, не могу компилировать", "Внимание! стр: "
				~ to!string(__LINE__), QMessageBox.Icon.Critical);
			return;
		}
		SaveFile();		// Сохраним перед запуском
		// стандартные проверки позади
		string nameLog = constNameLog;
		auto logFile = File(nameLog, "w");
			string[] swCompileMain = [ nameDMDonOs(), "-c", "-release", nameFile ];
			if(cbDebug.checkState == QtE.CheckState.Checked) swCompileMain ~= "-debug";
			if(cb3264.checkState == QtE.CheckState.Checked)
				swCompileMain ~= "-m64";
			else
				swCompileMain ~= "-m32";
			auto pid = spawnProcess(swCompileMain,
				std.stdio.stdin,
				std.stdio.stdout,
				logFile
			);
		if (wait(pid) != 0) {
			string sLog = cast(string)read(nameLog);
			msgbox(sLog, "Compile obj ...", QMessageBox.Icon.Critical);
		} else {
			msgbox("Compile is Ok", "Compile  ...");
		}
		activeWinEdit.teEdit.setFocus();
	}
	// ______________________________________________________________
	void runRunApp() { //-> Компиляция и запуск
		scope CEditWin activeWinEdit = getActiveWinEdit();
		if(activeWinEdit is null) return;

		string nameFile = activeWinEdit.getNameEditFile();
		if(nameFile == "???") {
			msgbox("Не задано имя файла, не могу компилировать", "Внимание! стр: "
				~ to!string(__LINE__), QMessageBox.Icon.Critical);
			return;
		}
		SaveFile();		// Сохраним перед запуском
		// Это не правильно, нужно использовать библиотечные функции
		string nameRunFile = stripExtension(nameFile);
		string outFile = "-of=" ~ nameRunFile;
		string ss, nameLog = constNameLog;
		auto logFile = File(nameLog, "w");
		
		string[] swCompileMain = [ nameDMDonOs() ]; // ] , "-release", nameFile];
		
		if(cbDebug.checkState == QtE.CheckState.Checked)	swCompileMain ~= "-debug" ~ "-g";
		else												swCompileMain ~= "-release";
		if(cb3264.checkState == QtE.CheckState.Checked)		swCompileMain ~= "-m64";
		else												swCompileMain ~= "-m32";
		swCompileMain ~= outFile;
		swCompileMain ~= nameFile ~ listFileModul;
		ss = join(swCompileMain, ' ');
		showInfo("Компиляция: " ~ ss);
			writeln();
			writeln("----------------------------------------");
			writeln("Compile: " ~ ss);
		StopWatch sw;
		sw.reset();
		sw.start();
		auto pid = spawnProcess(swCompileMain,
			std.stdio.stdin, std.stdio.stdout, logFile
		);
		if (wait(pid) != 0) {
			string sLog = cast(string)read(nameLog);
			msgbox(sLog, "Compile  ...", QMessageBox.Icon.Critical);
		} else {
			sw.stop();
			Duration t1 = sw.peek();

			writeln("Compile time: " ~ t1.toString());
		
			string appargs = leArgApp.text!string();
			auto mAppArgs = split(appargs, ' ');
			writeln();
			writeln("Run: " ~ nameRunFile ~ " " ~ appargs);
			writeln("----------------------------------------");
			try {
				auto pid2 = spawnProcess([ nameRunFile ] ~  mAppArgs);
			} catch(Throwable) {
				writeln("Panic: " ~ nameRunFile ~ " " ~ appargs);
			}
		}
		activeWinEdit.teEdit.setFocus();
	}
	// ______________________________________________________________
	string nameDMDonOs() { //-> Выдать имя компилятора в зависимости от ОС
		string rez;
		version (Windows)		{ rez = nameCompile;         }
		version (linux)			{ rez = nameCompile[0..$-4]; }
		version (OSX)			{ rez = nameCompile[0..$-4]; }
		return rez;
	}
	// ______________________________________________________________
	void runHelpIde() { //-> Открыть окно с подсказками по кнопкам
		string sHtml =
`
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Здесь название страницы, отображаемое в верхнем левом углу браузера</title>
</head>
<body id="help IDE5">
<h2 align="center">Краткий справочник по ide5</h2>
<p><font color="red"><b>Вставка слова из таблицы подсказок:</b></font></p>
<pre>
	Esc           - Переход и возврат в таблицу подсказок
	Space         - Вставка выделенного слова, если в таблице подсказок
	Ctrl+Space    - Вставка самого верхнего слова, если в редакторе
</pre>
<p><font color="red"><b>Закладки:</b></font></p>
<pre>
Закладки отображаются символом ">>" в колонке номеров строк и индивидуальны
для каждого окна редактора.
	Ctrl+L, T     - Поставить закладку или снять закладку
	Ctrl+T        - Вниз  на след закладку
	Ctrl+Shift+T  - Вверх на пред закладку
</pre>
<p><font color="red"><b>Разное:</b></font></p>
<pre>
	Ctrl+L, /     - Вставить комментарий
	Ctrl+L, D     - Удалить текущ стоку
	F3            - Список всех похожих слов
</pre>

<br>
</body>
</html>
`;
		scope QLabel w1 = new QLabel(this); w1.saveThis(&w1);
		w1.setText(sHtml);
		void* rez = mainWid.addSubWindow(w1);
		w1.show();
	}
	// ______________________________________________________________
	void runDynAct(int nom) { //-> Процедура обработки меню шаблона
		CEditWin activeWinEdit = getActiveWinEdit(); if(activeWinEdit is null) return;
		// if(tabbar.count == 0) return;
		string s = activeWinEdit.getStrUnderCursor();
		// крутим массив шаблонов и выводим строки сод индекс
		foreach(strm; sShabl) {
			if(strm[0..2] == format("%2s", nom)) {
				activeWinEdit.teEdit.insertPlainText( getOtstup(s) ~ strm[2..$]	~ "\n");
			}
		}
	}
	// ______________________________________________________________
	void printArgsIni() { //-> Отладка того, что в ини файле
		writeln(toCON("Шаблон меню: FileShablons = ["), nameFileShablons, "]");
		writeln(toCON("Файлы для парсинга: listFilesForParser = ["), listFilesForParser, "]");
		writeln(toCON("main проекта: nameMainFile = ["), nameMainFile, "]");
		writeln(toCON("файлы проекта: listFileModul = ["), listFileModul, "]");
		
		writeln(toCON("PathForSrcWin32   = ["), PathForSrcDmd[0], "]");
		writeln(toCON("PathForSrcWin64   = ["), PathForSrcDmd[1], "]");
		writeln(toCON("PathForSrcLinux32 = ["), PathForSrcDmd[2], "]");
		writeln(toCON("PathForSrcLinux64 = ["), PathForSrcDmd[3], "]");
		writeln(toCON("PathForSrcOSX64   = ["), PathForSrcDmd[4], "]");
		writeln();
		writeln(toCON("пути import: listPathSourceModul = ["), listPathSourceModul, "]");
		writeln(toCON(" библиотеки:         listFileLib = ["), listFileLib, "]");
	}
	// ______________________________________________________________
	void readIniFile() { //-> Прочитать INI файл в память
		const kolFilesFor = 10;
		Ini ini = new Ini(sIniFile);
		nameFileShablons = ini["Main"]["FileShablons"];

		for(int i; i != kolFilesFor; i++) {
			string rawStr = strip(ini["ForParser"]["FileParser" ~ to!string(i)]);
			if(rawStr != "") listFilesForParser ~= rawStr; else break;
		}
		
		nameMainFile = ini["Project"]["FileMain"];
		
		for(int i; i != kolFilesFor; i++) {
			string rawStr = strip(ini["Project"]["FileMod" ~ to!string(i)]);
			if(rawStr != "") listFileModul ~= rawStr; else break;
		}
		for(int i; i != kolFilesFor; i++) {
			string rawStr = strip(ini["Project"]["PathSourceMod" ~ to!string(i)]);
			if(rawStr != "") listPathSourceModul ~= rawStr; else break;
		}
		for(int i; i != kolFilesFor; i++) {
			string rawStr = strip(ini["Project"]["FileLib" ~ to!string(i)]);
			if(rawStr != "") listFileLib ~= rawStr; else break;
		}
		
		// Читаю пути до SRC для парсера
		for(int i; i != 5; i++) PathForSrcDmd[i] = "";
		PathForSrcDmd[0] = strip(ini["PathForSrcDmd"]["PathForSrcWin32"]).dup;
		PathForSrcDmd[1] = strip(ini["PathForSrcDmd"]["PathForSrcWin64"]).dup;
		PathForSrcDmd[2] = strip(ini["PathForSrcDmd"]["PathForSrcLinux32"]).dup;
		PathForSrcDmd[3] = strip(ini["PathForSrcDmd"]["PathForSrcLinux64"]).dup;
		PathForSrcDmd[4] = strip(ini["PathForSrcDmd"]["PathForSrcOSX64"]).dup;
	}
	// ______________________________________________________________
	string[] listFPrs() { //-> Выдать список имен файлов для парсинга
		return listFilesForParser;
	}
	// ______________________________________________________________
	void showInfo(string s) { //-> Отобразить строку состояния
		stBar.showMessage(s, 5000);
	}
	// ______________________________________________________________
	string[5] getPathSrcDmd() { //-> Выдать массив с путями до SRC каталога
		return PathForSrcDmd;
	}
	// ______________________________________________________________
	void loadParser() { //-> Загрузить парсер файлами из проекта
		try {
			foreach(nameFilePrs; listFPrs()) {
				// Если имя отсутст в списке уже распарсенных, то распарсить и добавить
				if(nameFilePrs == "") continue;
				if(!finder1.isFileInParserAfter(nameFilePrs)) {
					if(exists(nameFilePrs)) {
						showInfo("Parsing: " ~ strip(join(listFPrs, "  ")));
						finder1.addFile(nameFilePrs);
						finder1.addParserAfter(nameFilePrs);
					}
				}
			}
		} catch(Throwable) {
			msgbox("Не могу загрузить файлы из INI в парсер: ", "Внимание! стр: "
				~ to!string(__LINE__), QMessageBox.Icon.Critical);
			return;
		}
		// finder1.printUc();
	}
	void about(int n) {
		if(n == 1) {

			msgbox(
"
<H2>IDE5 - miniIDE for dmd</H2>
<H3>MGW 2016 " ~ verApp ~ "</H3>
<BR>
<IMG src='ICONS/qte5.png'>
<h4>" ~ verQtE5 ~ "</h4>
<p>miniIDE for dmd + QtE5 + Qt-5</p>
<p>It application is only demo work with QtE5</p>


"

, "About IDE5");
		}
		if(n == 2) {	 app.aboutQt();	
			// printArgsIni();
		}
	}

}
// __________________________________________________________________
// Глобальные, независимые функции
string getOtstup(string str) { // Вычислить отступ используя строку
	string rez;
	if(str == "") return rez;
	for(int i; i != str.length; i++) {
		if( (str[i] == ' ') || (str[i] == '\t')  ) {
			rez ~= str[i];
		} else break;
	}
	return rez;
}
// __________________________________________________________________
// Глобальные переменные программы
QApplication app;	// Само приложение
string sIniFile;	// Строка с именем файла ini
string sFileStyle;
// __________________________________________________________________
int main(string[] args) {
	bool fDebug;		// T - выдавать диагностику загрузки QtE5
	try {
		auto helpInformation = getopt(args, std.getopt.config.caseInsensitive,
			"d|debug",	toCON("включить диагностику QtE5"), 		&fDebug,
			"s|style",    toCON("загрузить файл стилей"),       &sFileStyle,
			"i|ini", 	toCON("имя INI файла"), 					&sIniFile);
		if (helpInformation.helpWanted) defaultGetoptPrinter(helps(), helpInformation.options);
	} catch(Throwable) {
		writeln(toCON("Ошибка разбора аргументов командной стоки ...")); return 1;
	}
	if (1 == LoadQt(dll.QtE5Widgets, fDebug)) return 1;  // Выйти,если ошибка загрузки библиотеки
	app = new QApplication(&Runtime.cArgs.argc, Runtime.cArgs.argv, 1);
	// Проверяем путь до файла стилей
	if(sFileStyle != "") {
		if(!exists(sFileStyle)) {
			msgbox("Нет файла Стилей: " ~ "<b>" ~ sFileStyle ~ "</b>", "Внимание! стр: " ~ to!string(__LINE__),
				QMessageBox.Icon.Critical); return(1);
		} else {
			app.setStyleSheet(cast(string) read(sFileStyle));
		}
	}
	// Проверяем путь до INI файла
	if(!exists(sIniFile)) {
		msgbox("Нет INI файла: " ~ "<b>" ~ sIniFile ~ "</b>", "Внимание! стр: " ~ to!string(__LINE__),
			QMessageBox.Icon.Critical); return(1);
	}
	
	scope CFormaMain w1 = new CFormaMain(null); w1.show().saveThis(&w1);
	
    return app.exec();
}

__EOF__ _________________________________________________________________________________

Следует добавить:

1 - Списки путей, для поиска исходников, интерфейсов
2 - Список необходимых библиотек, для включения в командную строку
		