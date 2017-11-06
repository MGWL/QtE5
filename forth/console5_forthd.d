//------------------------------
// Консоль для forthD на QtE5
// MGW 19.03.2016 22:32:10
//------------------------------
//
// QtE5 - обёртка для Qt-5. Сейчас для D, но архитектура позволяет
//        использовать С, С++, Forth и любой другой язык с поддержкой
//        вызовов extern (C)

import asc1251;			// Поддержка cp1251 в консоли
import std.getopt;		// Раазбор аргументов коммандной строки
import std.stdio;
import std.file;
import forth;			// Сам forth написан на 32 разрядном D (asm)
import qte5;
import core.runtime;     // Обработка входных параметров
import std.string: strip, format, split;
import std.conv;
import std.datetime;

const strElow  = "background: #F8FFA1";
const strGreen = "background: #F79F81";

string ts = "ABC";

string helps() { 
	return	toCON(
"Использование консоли для forthD: 
--------------------------------
Запуск:
console5_forthd [-d, -e, -i] ...
");
}
// ==================================================================
// Форма Settings - Проверка отображения раздичных элементов
// ==================================================================
extern (C) {
	void onac1(CSetting* uk, int N, QtE.CheckState st) { 	// Обработка флажков
		(*uk).testCheks(N, st);
	}
	void onar1(CSetting* uk, int N, bool bp) {
		(*uk).testRasio(N, bp);
	}
	// Проверка KeyReleaseEvent 
	void* onKeyReleaseEvent(CSetting* uk, void* ev) {
		// Вызвать метод FormaMain.workPress(из_С++__KeyEvent*)
		// Этот обработчик, просто транзитом передаёт всё дальше
		// return возвратит KeyEvent* обратно в C++, для дальнейшей обработки
		return (*uk).runKeyReleaseEvent(ev);
	}
}
// __________________________________________________________________
class CSetting : QWidget {
	// Нужны выравниватели
	QVBoxLayout	vblAll;			// Общий вертикальный выравниватель
	QVBoxLayout	vblGr, vblGr2;
	QHBoxLayout vblLong;

	QGroupBox gr1;
	QCheckBox    cb1, cb2, cb3;
	QRadioButton rb1, rb2, rb3;
	
	QAction ac1, ac2, ac3;				// Обработка флажков
	QAction ar1, ar2, ar3;				// Обработка флажков
	
	QPlainTextEdit pte;
	QTextCursor txtCursor;
	QRect qRect;
	QWidget popWinHelp;
	// ______________________________________________________________
	// Конструктор фрмы
	this(QWidget parent, QtE.WindowType fl) {
		super(parent, fl); // resize(100, 100); 
		setWindowTitle("--[ Settings ]--");
		vblAll  = new  QVBoxLayout(this);		// Главный выравниватель
		vblGr   = new  QVBoxLayout(null);		// для группы
		vblGr2  = new  QVBoxLayout(null);		// для второй группы
		vblLong = new  QHBoxLayout(null);		// для групп кнопок
		// Экранный редактор
		pte = new QPlainTextEdit(this);
		
		// РадиоБатоны
		rb1 = new QRadioButton("№1 Первый", this); 
		rb2 = new QRadioButton("№2 Первый", this); 
		rb3 = new QRadioButton("№3 Первый", this); 
		vblGr2.addWidget(rb1).addWidget(rb2).addWidget(rb3);
		// Чекбоксы
		cb1 = new QCheckBox("Первый", this); 
		cb2 = new QCheckBox("Второй", this); 
		cb3 = new QCheckBox("Третий", this); 
		vblGr.addWidget(cb1).addWidget(cb2).addWidget(cb3);
		
		// Включим все кнопки
		// cb1.setCheckState(QtE.CheckState.Checked);
		// cb2.setCheckState(QtE.CheckState.Checked);
		//  cb3.setCheckState(QtE.CheckState.Checked);
		cb1.setChecked(true);
		rb2.setChecked(true);

		// Горизонтальная группировка кнопок
		vblLong.addLayout(vblGr).addLayout(vblGr2);
		// Группировка
		gr1 = new QGroupBox(this); // gr1.setMinimumHeight(160);
		gr1.setLayout(vblLong);
		
		// Обработка событий
		ac1 = new QAction(this, &onac1, aThis, 1);
		ac2 = new QAction(this, &onac1, aThis, 2);
		ac3 = new QAction(this, &onac1, aThis, 3);
		connects(cb1, "stateChanged(int)", ac1, "Slot_v__A_N_i(int)");
		connects(cb2, "stateChanged(int)", ac2, "Slot_v__A_N_i(int)");
		connects(cb3, "stateChanged(int)", ac3, "Slot_v__A_N_i(int)");
		
		// События на радиобатоны
		ar1 = new QAction(this, &onar1, aThis, 1);
		ar2 = new QAction(this, &onar1, aThis, 2);
		ar3 = new QAction(this, &onar1, aThis, 3);
		connects(rb1, "toggled(bool)", ar1, "Slot_v__A_N_b(bool)");
		connects(rb2, "toggled(bool)", ar2, "Slot_v__A_N_b(bool)");
		connects(rb3, "toggled(bool)", ar3, "Slot_v__A_N_b(bool)");
		

		vblAll.addWidget(gr1); 
		vblAll.addWidget(pte);
		

		setLayout(vblAll);
		gr1.setText("Группа").setAlignment(QtE.AlignmentFlag.AlignRight);
		
		// Обработка клавиш в редакторе
		pte.setKeyReleaseEvent(&onKeyReleaseEvent, aThis);

		txtCursor = new QTextCursor();
		qRect = new QRect();
		popWinHelp = new QWidget(this, QtE.WindowType.Popup);
		
	}
	// ______________________________________________________________
	// Первая кнопка
	void testCheks(int N, QtE.CheckState st) {  //-> Обработка выбора флажков
		writeln("N = ", N, "  st = ", st);
		// Состояние всех кнопок
		writefln("cb1 = %s  cb2 = %s  cb3 = %s  ", cb1.checkState(), cb2.checkState(), cb3.checkState());
		if(cb1.checkState() == QtE.CheckState.Checked) {
			cb3.setTristate();
		}
		writefln("rb1  -- %s = autoExclusive()   %s = autoRepeat()   %s = isCheckable()  %s = isChecked()   %s = isDown()",
			rb1.autoExclusive(), rb1.autoRepeat(), rb1.isCheckable(), rb1.isChecked(), rb1.isDown());
	}
	// ______________________________________________________________
	// Провкрка РадиоБатонов
	void testRasio(int N, bool bp) {  //-> Обработка радио кнопок
		writeln(bp, "  ", N);
		writefln("rb1  -- %s = autoExclusive()   %s = autoRepeat()   %s = isCheckable()  %s = isChecked()   %s = isDown()",
			rb1.autoExclusive(), rb1.autoRepeat(), rb1.isCheckable(), rb1.isChecked(), rb1.isDown());
		writefln("rb2  -- %s = autoExclusive()   %s = autoRepeat()   %s = isCheckable()  %s = isChecked()   %s = isDown()",
			rb2.autoExclusive(), rb2.autoRepeat(), rb2.isCheckable(), rb2.isChecked(), rb2.isDown());
		writefln("rb3  -- %s = autoExclusive()   %s = autoRepeat()   %s = isCheckable()  %s = isChecked()   %s = isDown()",
			rb3.autoExclusive(), rb3.autoRepeat(), rb3.isCheckable(), rb3.isChecked(), rb3.isDown());
	}
	// ______________________________________________________________
	// Обработка события KeyReleaseEvent
	void* runKeyReleaseEvent(void* ev) {
		QKeyEvent qe = new QKeyEvent('+', ev); 
		pte.textCursor(txtCursor); pte.cursorRect(qRect);
		// Расчитаем X и Y для точного позиционирования
		int nx = pte.x() + qRect.right();
		int ny = pte.y() + qRect.bottom();
		write(qe.key, " - ", nx, ":", ny); stdout.flush();
		if(qe.key == 65) {
			popWinHelp.move(nx, ny); popWinHelp.show();
		}
		return ev;	// Вернуть событие в C++ Qt для дальнейшей обработки
	}
}

// ==================================================================
// Форма Model - Отобразить модель (массив) построенную в Forth
// ==================================================================
extern (C) {
	void onPaintModel(CModel* uk, void* ev, void* qpaint) { 
		(*uk).runPaintModel(ev, qpaint);
	}
	void onKn1(CModel* uk) {
		(*uk).runKn1();
	}
}
// __________________________________________________________________
class CModel : QWidget {
	struct t_uk  { int X; int Y; pp Buf; }
	struct t_rgb { ubyte R; ubyte G; ubyte B; ubyte L; };
	t_uk*   uk;			// указатель на структуру Форта
	// Нужны выравниватели
	QVBoxLayout	vblAll;			// Общий вертикальный выравниватель
	QHBoxLayout	laHkn;			// Выравниватель кнопок
	// Кнопки
	QPushButton kn1, kn2;
	QLCDNumber lcdN1;
	QSlider slIder;
	// Screen
	QWidget screen;
	QAction acKn1, acKn2;
	// Рисование
	QColor color;
	QPen   pero;
	QIcon ik1;
	QGroupBox gr1;
	// ______________________________________________________________
	// Конструктор фрмы
	this(QWidget parent, QtE.WindowType fl) {
		super(parent, fl); resize(100, 100); 
		setWindowTitle("--[ Model ]--");
		// Горизонтальный и вертикальный выравниватели
		vblAll  = new  QVBoxLayout(this);		// Главный выравниватель
		laHkn   = new  QHBoxLayout(null);
		// Группировка
		gr1 = new QGroupBox(this); gr1.setMaximumHeight(70); gr1.setText("Группа");
		gr1.setAlignment(QtE.AlignmentFlag.AlignCenter);
		
		// Кнопки
		kn1  = new QPushButton("Первая кнопка:", this);
		kn2 = new QPushButton("Вторая кнопка", this); 
		ik1 = new QIcon(); ik1.addFile("ICONS/ArrowDownGreen.ico");
		kn1.setIcon(ik1);
		
		acKn1 = new QAction(null, &onKn1, aThis);
		connects(kn1, "clicked()", acKn1, "Slot()");
		
		lcdN1 = new QLCDNumber(this, 2); lcdN1.setMaximumHeight(30).setMaximumWidth(60);
		lcdN1.setStyleSheet(strGreen);
		lcdN1.display(15).setSegmentStyle(QLCDNumber.SegmentStyle.Flat).setMode(QLCDNumber.Mode.Hex);
		
		slIder = new QSlider(this, QtE.Orientation.Horizontal);
		slIder.setMinimum(0).setMaximum(10);
		
		screen = new QWidget(this, QtE.WindowType.Widget);
		// screen.setStyleSheet(strElow);
		screen.setPaintEvent(&onPaintModel, aThis);

		// Собираем кнопки в выравниватель
		laHkn.addWidget(kn1).addWidget(kn2).addWidget(lcdN1);
		gr1.setLayout(laHkn);
		
		// Соберем все в основной выравниватель
		vblAll.addWidget(gr1).addWidget(slIder).addWidget(screen);
		setLayout(vblAll);
		
		color = new QColor(); pero = new QPen(); 
		pero.setColor(color);

		
	}
	// ______________________________________________________________
	// Первая кнопка
	void runKn1() {
/* 		uk = cast(t_uk*)getCommonAdr(7);
		writefln("X = %s  Y = %s  Buf = %s", uk.X, uk.Y, uk.Buf);
		t_rgb rgb = cast()*uk.Buf;
		writefln("R = %s  G = %s  B = %s  L = %s", rgb.R, rgb.G, rgb.B, rgb.L);
		msgbox("Нажата 1");
 */	}
	// ______________________________________________________________
	// Обработчик paint
	void runPaintModel(void* ev, void* qpaint) {
 		// Схватить переданный из Qt указатель на QPaint и запомнить его 
		// в своем объекте, для дальнейшей обработки
		uk = cast(t_uk*)getCommonAdr(7);
		if(uk is null) return;
		t_rgb* urgb = cast(t_rgb*)uk.Buf;
		t_rgb rgb, rgb_before = { 0, 0, 0, 0 };
		QPainter qp = new QPainter('+', qpaint); 
		int sm;
		for(int x; x != uk.X; x++) {
			for(int y; y != uk.Y; y++) {
				rgb        = *( urgb + sm++ );
				rgb_before = *( urgb + sm );
				{
					rgb_before = rgb;
					color.setRgb(rgb.R, rgb.G, rgb.B, rgb.L);
					pero.setColor(color); 
					qp.setPen(pero); 
					qp.drawPoint(x, y);
				}
			}
		}
		qp.end();
	}
}
/* 		// Попробуем вызвать из D слово Форта
		pp adrWordForth = getCommonAdr(6);
		writeln("adrWordForth = ", adrWordForth);
 */

// ==================================================================
// Форма Paint - Отобразим в отдельном окне график
// ==================================================================
extern (C) {
	void onPaint1(CPaint* uk, void* ev, void* qpaint) { 
		(*uk).runPaint1(ev, qpaint);
	}
}
// __________________________________________________________________
class CPaint : QWidget {
	QColor color1;
	QBrush qbr;
	QPen pero;
	// ______________________________________________________________
	// Конструктор фрмы
	this(QWidget parent, QtE.WindowType fl) {
		super(parent, fl); resize(400, 600); 
		setWindowTitle("--[ Paint ]--");
		// Установить обработчик Paint на onPaint1
		color1 = new QColor(); 
		color1.setRgb(255, 128, 0, 128); // Оранжевый
		qbr = new QBrush(); qbr.setColor(color1).setStyle();
		pero = new QPen(); 
		pero.setColor(color1)
			.setStyle(QtE.PenStyle.DotLine)
			.setWidth(3);
		setPaintEvent(&onPaint1, aThis);
	}
	// ______________________________________________________________
	// Обработчик paint
	void runPaint1(void* ev, void* qpaint) {
		// Схватить переданный из Qt указатель на QPaint и запомнить его 
		// в своем объекте, для дальнейшей обработки
		QPainter qp = new QPainter('+', qpaint); 
		qp.setBrush(qbr).setPen(pero);
		
		for(int i; i != 100; i++) qp.drawPoint(i, i);
		qp.drawLine(10, 20, 140, 310);
		// write(qpaint, "."); stdout.flush;
		qp.setText(140, 200, "Привет! ...");
		qp.end();
	}
}

// ==================================================================
// Форма DUMP - Отобразим в окошке диалог с дампом памяти
// ==================================================================
extern (C) {
	void onDumpR(CMdiDump* uk)   { (*uk).clickDumpR();   }
	void onDumpL(CMdiDump* uk)   { (*uk).clickDumpL();   }
	void onDumpRaz(CMdiDump* uk) { (*uk).clickDumpRaz(); }
	void onLoadSt(CMdiDump* uk)  { (*uk).clickLoadSt();  }
	void onCopy(CMdiDump* uk)    { (*uk).clickCopy();    }
}
// __________________________________________________________________
class CMdiDump : QWidget {
	const zzz = 7;
	int  id;
  private
	QVBoxLayout	vblAll;			// Общий вертикальный выравниватель
	QHBoxLayout	laHkn;			// Выравниватель кнопок
	
	QTableWidget	tbDump;		// Таблица самого Dump
	QComboBox		cbStack;	// список значений стека
	QPushButton knLoad, knDump1, knRaz, knCopy, knDump2; // Кнопки
	QLineEdit		leAdr;		// Ввод адреса
	
	QTableWidgetItem[10] 		colAdr; 
	QTableWidgetItem[10][10] 	strAdr;

	QAction acLoad, acCopy, acDumpL, acDumpR, acDumpRaz;
	// ______________________________________________________________
	// Конструктор фрмы
	this(QWidget parent, QtE.WindowType fl) {
		super(parent, fl);
		resize(200, 180);
		// Горизонтальный и вертикальный выравниватели
		vblAll  = new  QVBoxLayout(this);		// Главный выравниватель
		laHkn   = new  QHBoxLayout(null);
		//Строка адреса
		leAdr   = new QLineEdit(this);		// Строка адреса
		leAdr.setToolTip("Адрес для DUMP (можно редактировать)");
		leAdr.setMinimumWidth(140);
		// Кнопки
		knLoad  = new QPushButton("Load SD:", this);
		knLoad.setToolTip("Загрузить список адресов со стека SD");
		knDump1 = new QPushButton("<DUMP", this);
		knDump1.setToolTip("DUMP адреса из левого выпадающего списка");
		knDump2 = new QPushButton("<DUMP", this);
		knDump2.setToolTip("DUMP адреса из левой строки редактора");
		knRaz   = new QPushButton("-@->", this);  knRaz.setMinimumWidth(40);
		knRaz.setToolTip("разименовать из списка в строку редактора");
		knCopy  = new QPushButton("--->", this); knCopy.setMinimumWidth(40);
		knCopy.setToolTip("скоптровать из списка в строку редактора");
		// Выпадающий список
		cbStack	= new QComboBox(this); cbStack.setMinimumWidth(140);
		// Таблица
		tbDump = new QTableWidget(this); tbDump.setColumnCount(11).setRowCount(10);
		tbDump.setColumnWidth(0,80);
		for(int i = 0; i != 10; i++) {
			colAdr[i] = new QTableWidgetItem(0);
			colAdr[i].setTextAlignment(QtE.AlignmentFlag.AlignCenter);
			tbDump.setItem(i, 0, colAdr[i]);
		}
		for(int i = 1; i != 11; i++) tbDump.setColumnWidth(i, 50);
		// Назначим оставшиеся ячейки тпблицы
		for(int i; i != 10; i++ ) {
			for(int j; j != 10; j++) {
				strAdr[i][j] = new QTableWidgetItem(0);
				tbDump.setItem(i, j+1, strAdr[i][j]);
				// strAdr[i][j].setText(format("% 3s [%s]", i, j));
				strAdr[i][j].setTextAlignment(QtE.AlignmentFlag.AlignCenter);
			}
		}
		// События
		acCopy = new QAction(null, &onCopy,   aThis);
		connects(knCopy, "clicked()", acCopy, "Slot()");

		acLoad = new QAction(null, &onLoadSt,   aThis);
		connects(knLoad, "clicked()", acLoad, "Slot()");

		acDumpR = new QAction(null, &onDumpR,   aThis);
		connects(knDump2, "clicked()", acDumpR, "Slot()");

		acDumpL = new QAction(null, &onDumpL,   aThis);
		connects(knDump1, "clicked()", acDumpL, "Slot()");

		acDumpRaz = new QAction(null, &onDumpRaz,   aThis);
		connects(knRaz, "clicked()", acDumpRaz, "Slot()");

		// Собираем кнопки в выравниватель
		laHkn.addWidget(knLoad).addWidget(cbStack).addWidget(knDump1)
			.addWidget(knRaz).addWidget(knCopy)
			.addWidget(leAdr).addWidget(knDump2);
		// Соберем все в основной выравниватель
		vblAll.addLayout(laHkn).addWidget(tbDump);
		setLayout(vblAll);
		setWindowTitle("--[ DUMP ]--");
	}
	// ____________________________________________________________________
	// DUMP строки адреса
	void wDump(string sAdr) {
		string strAdr;
		int      iAdr;
		try {
			strAdr = strip(sAdr);
		} catch(Throwable) {
			sAdr = "";
		}
		if(sAdr == "") return;
		try {
			iAdr = to!int(sAdr);
			showDump2(iAdr);
		} catch(Throwable) {}
	}
	// ____________________________________________________________________
	// Обработка кнопки dump R
	void clickDumpR() {
		wDump(leAdr.text!string());
	}
	// ____________________________________________________________________
	// Обработка кнопки dump L
	void clickDumpL() {
		wDump(cbStack.text!string());
	}
	// ____________________________________________________________________
	// Обработка кнопки dump R
	void clickDumpRaz() {
		string strAdr;
		pp      ppAdr;
		int      iAdr;
		string sAdr = cbStack.text!string();
		try {
			strAdr = strip(sAdr);
		} catch(Throwable) {
			sAdr = "";
		}
		if(sAdr == "") return;
		try {
			ppAdr = cast(pp)(to!int(sAdr));
			iAdr = to!int(cast(int)*ppAdr);
			leAdr.setText(to!string(iAdr));
		} catch(Throwable) {}
	}
	// ____________________________________________________________________
	// Копирование аргумента с Combo в LineEdit
	void clickCopy() {
		leAdr.setText(cbStack.text!string());
	}
	// ____________________________________________________________________
	// DUMP - полученного адреса
	void showDump2(int adr) {
		try {
			char* uCh2, uCh = cast(char*)adr;
			// Обход по строкам
			for(int row; row != 10; row++) {
				colAdr[row].setText(format("%s", cast(int)(  (row * 10) + uCh  )  ));
				// Цикл по колонкам
				for(int column; column != 10; column++) {
					uCh2 = (((row * 10) + uCh) + column);
					char ch = *uCh2; // write(cast(ubyte)ch, " - "); stdout.flush();
					// Не отображать символы меньше 32
					if(ch < 32)  ch = ' ';
					if(ch > 128) ch = ' ';
					strAdr[row][column].setText(format("%3s [%s]", cast(ubyte)(*uCh2), ch));
					// writeln(format("%3s [%s]", cast(ubyte)(*uCh2), ch));
				}
			}
		} catch(Throwable) {
			msgbox("Ошибка преобразования", "Внимание", QMessageBox.Icon.Critical);
		}
	}
	// ____________________________________________________________________
	// Заполнить выпадающий список Combo значенияси со стека данных
	void clickLoadSt() {
		// Дно стека
		pp a = cast(pp)adr_cSD;
		// Указатель стека
		pp b = cast(pp)adr_SD;
		// Разница
		auto r = a - (b-2);
		if(r == 0) {
				// Стек пуст
		} else {
			if(r > 0) {
				cbStack.clear();
				// На стеке элементы ...
				for(int i = r - 1; i != -1; i--) {
					cbStack.addItem(to!string( cast(int)*(a-i) ), i);
					// str1 = str1 ~ to!string( cast(int)*(a-i) ) ~ "  ";
				}
			} 
		}
	}
	
}

// ____________________________________________________________________
// Интефейс описывающий взаимодействие формы с логом и строкой
interface IFormLogCmd  {
	string getCmd(int km = 0);	// Дай команду
	void addStrInLog(string s);	// Добавь строку в лог
}
// Форма - консоль Forth
class CMdiFormLogCmd : QWidget, IFormLogCmd {
  private
	QBoxLayout	vblAll;			// Общий вертикальный выравниватель
	QHBoxLayout	hb2;			// Общий вертикальный выравниватель
	QPlainTextEdit	teLog;		// Окно лога
    QLineEdit		leCmdStr;	// Строка команды
	QTableWidget	teHelp;		// Таблица подсказок
	QTableWidgetItem[10] mTi;	// Массив на 10 ячеек подсказок
	string[100] mHistory;		// 100 строчек истории
	int tekUkHistory;			// Указатель на текущую строку истории
	QTableWidgetItem teHelpС1header;
	// ____________________________________________________________________
	// Конструктор фрмы
	this(QWidget parent, QtE.WindowType fl) {
		super(parent, fl);
		resize(200, 180);
		// Горизонтальный и вертикальный выравниватели
		vblAll  = new  QBoxLayout(this);			// Главный выравниватель
		//Строка команды
		leCmdStr = new QLineEdit(this);			// Строка команды
		leCmdStr.setKeyPressEvent(&onChar, parent.aThis);
		leCmdStr.setToolTip("Строка команды.\nДоступны стрелки вверх/вниз и F1 .. F10 быстрой вствки");

		// Текстовый редактор, окно лога
		teLog = new QPlainTextEdit(this);
		teHelp = new QTableWidget(this); teHelp.setColumnCount(1).setRowCount(10);
		teHelp.setMaximumWidth(250);
		teHelp.setColumnWidth(0, 200);
		teHelp.setToolTip("от F1 до F10 - быстрая вставка слова в командной строке");
		teHelp.ResizeModeColumn(0);
		// Создаю раскраску
		QColor color1 = new QColor(); color1.setRgb(255, 128, 0, 128); // Оранжевый
		QBrush qbr = new QBrush(); qbr.setColor(color1).setStyle();
		
		// Делаю массив для таблицы
 		for(int i; i != 10; i++) {
			mTi[i] = new QTableWidgetItem(0); 
			// mTi[i].setBackground(qbr);
			teHelp.setItem(i, 0, mTi[i]);
		}
		hb2 = new QHBoxLayout(null); hb2.addWidget(teLog).addWidget(teHelp);
		
		// Установка заголовка на колонку таблицы
		teHelpС1header = new QTableWidgetItem(0); 
		teHelp.setHorizontalHeaderItem(0, teHelpС1header);
		teHelpС1header.setText("Найдено:").setTextAlignment(QtE.AlignmentFlag.AlignCenter);
		teHelpС1header.setBackground(qbr);
		// Методы обработки расположены в родительском классе
		// teLog.setKeyPressEvent(&onChar, parent.aThis);
		// Вставляем всё в вертикальный выравниватель
		vblAll.addLayout(hb2).addWidget(leCmdStr);
		setLayout(vblAll);
		setWindowTitle("--[ FORTH ]--");
	}
	// ____________________________________________________________________
	// Отразить строку истории в ком строке
	void cmdStrHistory(int sm) {
		if((sm > 0) && (tekUkHistory < 99)) {
			if(mHistory[tekUkHistory] != "") {
				leCmdStr.setText(mHistory[tekUkHistory]);
				if(mHistory[tekUkHistory + 1] != "") tekUkHistory++;
				return;
			}
		}
		if((sm < 0) && (tekUkHistory > 0)) {
			if(mHistory[tekUkHistory - 1] != "") {
				tekUkHistory--; leCmdStr.setText(mHistory[tekUkHistory]); 
				return;
			}
		}
		if((sm < 0) && (tekUkHistory == 0)) {
			leCmdStr.setText(""); 
		}
	}
	// ____________________________________________________________________
	// Добавить строку команды в историю
	void addStrHistory(string str) {
		string s = strip(str);
		if(s == "") return;
		// Не сохранять в истории дубли
		if(s == mHistory[0]) return;
		// Сдвинуть массив вниз
		for(int i = 99; i != 0; i--) mHistory[i] = mHistory[i - 1];
		mHistory[0] = str; tekUkHistory = 0;
	}
	// ____________________________________________________________________
	// Выдать строку команды наружу
	string getCmd(int km = 0) {
		string rez;
		if(km == 0) rez = strip(leCmdStr.text!string());
		if(km == 1) rez = leCmdStr.text!string();
		return rez;
	}
	// ____________________________________________________________________
	// Добавить строку в лог и читать команду
	void addStrInLog(string cmd) {
		teLog.appendPlainText(cmd); addStrHistory(cmd);
		leCmdStr.clear().setFocus();
	}
	// ____________________________________________________________________
	// Заполним таблицу подсказок
	void setTablHelp(string[] mStr) {
		mStr.length = 10; 
		for(int i; i != 10; i++) mTi[i].setText(mStr[i]);
	}
	// ____________________________________________________________________
	// Дописать строку из таблицы по номеру
	void getStrN(int nomStr) {
		string rez;
		// Слово из таблицы
		string shabl = mTi[nomStr - 1].text!string();
		// Командная строка
		string sOld = leCmdStr.text!string();
		// надо найти или пробел, или место для вставки
		bool fNaideno;
		for(int i = (sOld.length-1); i != -1; i--) {
			if(sOld[i] == ' ') {
				rez = sOld[0 .. i]; fNaideno = true; break;
			}
		}
		if(fNaideno) {
			leCmdStr.setText(rez ~ " " ~ shabl ~ " ");
		} else {
			leCmdStr.setText(shabl ~ " ");
		}
	}
}
 
// ==================================================================
// FormaMain - Главная Форма для работы  
// ==================================================================
extern (C) {
	void on_knEval(FormaMain* uk)		{ (*uk).EvalString();    }
	void on_knLoad(FormaMain* uk)		{ (*uk).IncludedFile();  }
	void on_knHelp(FormaMain* uk)		{ (*uk).Help();          }
	void on_knTest(FormaMain* uk)		{ (*uk).Test();          }
	void on_testEdited(FormaMain* uk)	{ (*uk).EndEditCmd();    }
	void on_ShowDump(FormaMain* uk)		{ (*uk).ShowDump();      }
	
	// Обработчик с параметром. Параметр позволяет не плодить обработчики
	void on_about(FormaMain* uk) 		{ (*uk).about(1); }
	void on_aboutQt(FormaMain* uk)		{ (*uk).about(2); }
	
	// Проверка события KeyPressEvent 
	void* onChar(FormaMain* uk, void* ev) {
		// Вызвать метод FormaMain.workPress(из_С++__KeyEvent*)
		// Этот обработчик, просто транзитом передаёт всё дальше
		// return возвратит KeyEvent* обратно в C++, для дальнейшей обработки
		return (*uk).workPress(ev);
	}
	void onCloseWin(FormaMain* uk, void* ev) { (*uk).workCloseForth(ev); }
}
// __________________________________________________________________
class FormaMain: QMainWindow {
	int tForth = 7;
	QVBoxLayout 	vblAll;			// Общий вертикальный выравниватель
	QProgressBar    zz;
	QStatusBar      stBar;			// Строка сообщений
	
	QMdiArea		mainWid;
	CMdiFormLogCmd  winForth;
	CMdiDump[10]    winDump;     // 10 окошек DUMP
	int 			winDumpKol;  // Количество открытых
	
	QToolBar tb;
	QMenu menu1, menu2;
	QMenuBar mb1;
	QFont qf;
	QAction acEval, acIncl, acHelp, acAbout, acAboutQt;
	QAction acTest, acTest1, acShowDump;
	StopWatch 		sw;   			// Секундомер для измерения времени
	
	CPaint   fPaint;
	CModel   fModel;					// Форма с моделью
	CSetting fSetting;					// Форма с модальными настройками
	// __________________________________________________________________
	// Конструктор по умолчанию
	this() {
		super(null);
		// --------------- Инициализация -----------------
		// Шрифт
		qf = new QFont(); qf.setPointSize(12);
		// Главный виджет, в который всё вставим
		mainWid = new QMdiArea(this);
		// Горизонтальный и вертикальный выравниватели
		vblAll  = new  QVBoxLayout(this);			// Главный выравниватель
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
		acAbout   = new QAction(null, &on_about,    aThis, 1); 	// 1 - это парам перед в обработчик 
		acAboutQt = new QAction(null, &on_aboutQt,  aThis, 2); 	// 2 - это парам перед в обработчик 
		acTest    = new QAction(null, &on_knTest,   aThis);
		acTest1   = new QAction(null, &on_testEdited, aThis);
		acShowDump= new QAction(null, &on_ShowDump, aThis);
		
		// --------------- Взаимные настройки -----------------
		menu2.setTitle("About")
			.addAction(		acAbout		)
			.addAction(		acAboutQt 	);
		
		menu1.setTitle("Help")
			.addAction(		acEval		)
			.addAction(     acIncl      )
			.addAction(     acTest      )
			.addAction(		acHelp   	)
			.addAction(   acShowDump	);

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

		// Определим обработчик на основе QAction для Test
		acTest.setText("Test").setHotKey(QtE.Key.Key_T | QtE.Key.Key_ControlModifier);
		acTest.setIcon("ICONS/Tester.ico").setToolTip("Тест ...");
		connects(acTest, "triggered()", acTest, "Slot()");

		// Определим обработчик на основе QAction для ShowDump
		acShowDump.setText("Dump").setHotKey(QtE.Key.Key_D | QtE.Key.Key_ControlModifier);
		acShowDump.setIcon("ICONS/calc.ico").setToolTip("Распечатка памяти ...");
		connects(acShowDump, "triggered()", acShowDump, "Slot()");
		
		// Создаю неубиваемое окошко Форта
		createWinForth();

		acTest1.setText("Test1");
		connects(winForth.leCmdStr, "textEdited(QString)", acTest1, "Slot()");

		// Настраиваем ToolBar
		tb.setToolButtonStyle(QToolBar.ToolButtonStyle.ToolButtonTextBesideIcon);
		tb.addAction(acEval).addAction(acIncl)
			.addSeparator().addAction(acHelp).addAction(acTest);
		tb.addWidget(zz); zz.setValue(1);
		
		// --------------- Установки класса -----------------
		setFont(qf);
		// Заголовки и размеры
		setWindowTitle("--- Консоль forthD на QtE5 ---"); resize(700, 450);
		// Центральный виджет в QMainWindow
		setCentralWidget(mainWid); 
		
		addToolBar(QToolBar.ToolBarArea.BottomToolBarArea, tb); 
		tb.setStyleSheet(strElow);

		setMenuBar(mb1); setStatusBar(stBar); stBar.setFont(qf);
 		
		setNoDelete(true); // Не вызывай delete C++ для этой формы
		
		// -------- Forth --------
		initForth(); 		// Активизируем Форт
		
		// Проверим и выполним переменные командной строки
		pvtInclude(sInclude);
		evalForth(to!string(fromUtf8to1251(cast(char[])sEval))); 

		// Начнем передачу параметров в forth
 		setCommonAdr(0, cast(pp)5);
		setCommonAdr(1, cast(pp)7);
		setCommonAdr(2, cast(pp)&sr); // Функция D: int sr(int, int);
		setCommonAdr(3, cast(pp)&ts);
		setCommonAdr(4, cast(pp)aThis);
		setCommonAdr(5, cast(pp)this);
		
		// Отобразим результат работы на слайдере
		stBar.showMessage(showSD());
		zz.setMinimum(cast(int)adr_begKDF()); // Начало кодофайла
		zz.setMaximum(cast(int)adr_endKDF()); // Конец кодовайла
		zz.setValue(cast(int)adr_here());     // А здесь HERE тусуется
		zz.setToolTip("Заполнение кодофайла опираясь на HERE");
		
	}
	// ______________________________________________________________
	// Повторяющейся код для Include
	void pvtInclude(string cmd) {
		if(cmd.length != 0) { 
			if(!exists(cmd)) {
				msgbox("Не найден файл для Include:\n\n[" ~ cmd ~ "]", 
					"Include ...", QMessageBox.Icon.Critical);
				return;
			}
			sw.reset();
			sw.start();
			// -------------------------
			includedForth(cmd); 
			// -------------------------
			sw.stop();
			winForth.addStrInLog("INCLUDED " ~ cmd);
			// string s; //  = "   { " ~ to!string(sw.peek().usecs) ~ " microsec}";
			stBar.showMessage(showSD() ~ "   { " ~ to!string(sw.peek().usecs) ~ " microsec}" );
			zz.setValue(cast(int)adr_here());     // А здесь HERE тусуется
		}
	}
	// ______________________________________________________________
	// Выполнить строку форта
	void EvalString() {
		// Обработка теперь берется с новой формы: 
 	    string cmd = winForth.getCmd();
		if(cmd.length != 0) { 
			try {
				// В Qt строка в Utf-8 конвертнем в cp1251
				sw.reset();
				sw.start();
				// -------------------------
				evalForth(to!string(fromUtf8to1251(cast(char[])cmd))) ; 
				// -------------------------
				sw.stop();
			} catch(Throwable) {
				msgbox("Error ...");
			}
			winForth.addStrInLog(cmd);
			stBar.showMessage(showSD() ~ "   { " ~ to!string(sw.peek().usecs) ~ " microsec}" );
			zz.setValue(cast(int)adr_here());     // А здесь HERE тусуется
		}
	}
	// ______________________________________________________________
	// INCLUDE
	void IncludedFile() {
		// Проверим работу открытия файла
		QFileDialog fileDlg = new QFileDialog(null);
		string cmd = fileDlg.getOpenFileName("INCLUDE ...", "", "*.f");
		pvtInclude(cmd);
	}
	// ______________________________________________________________
	// Help
	void Help() {
		// msgbox("Окно с помощью ....", "Помощь", QMessageBox.Icon.Warning);
		QLabel ql = new QLabel(null);
		ql.setText(
"<h2>Очень краткая инструкция</h2>
<p>Всё просто! Вводите команды форта, и жмете Enter.<br>
Если есть похожие слова в словаре, то они высвечиваются в таблице справа.<br>
Для выбора нужного слова кнопки F1 .. F10</p>
<hr>
<p>Так же работают стрелки вверх/вниз показывая историю команд.</p>
"		
		);
		// ql.show();
		// -----------------------
		if(fModel is null) {
			fModel = new CModel(this, QtE.WindowType.Window); fModel.saveThis(&fModel);
			mainWid.addSubWindow(fModel);
		}
		fModel.show();
		// -----------------------
		if(fSetting is null) {
			fSetting = new CSetting(null, QtE.WindowType.Dialog); fSetting.saveThis(&fSetting);
			// fSetting.setMaximumHeight(100).setMaximumHeight(100); 
			mainWid.addSubWindow(fSetting);
		}
		fSetting.show();
	}
	// ______________________________________________________________
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
	// ______________________________________________________________
	// closeWinMDI обработки событий
	void* workCloseForth(void* ev) {
		// 1 - Схватить событие пришедшее из Qt и сохранить его в моём классе
		QEvent qe = new QEvent('+', ev); 
		qe.ignore();
		msgbox("Закрытие этого окна не предусмотрено.", "Внимание!");
		return ev;
	}
	// ______________________________________________________________
	// Проверка обработки событий
	void* workPress(void* ev) {
		// 1 - Схватить событие пришедшее из Qt и сохранить его в моём классе
		QKeyEvent qe = new QKeyEvent('+', ev); 
		// 2 - Выдать тип события
		
		// Стрелки вверх/вниз
		if(qe.key == 16777235) winForth.cmdStrHistory(1);
		if(qe.key == 16777237) winForth.cmdStrHistory(-1);
		// Кнопки F1 .. F10
		if(qe.key == 16777264) { winForth.getStrN(1); }
		if(qe.key == 16777265) { winForth.getStrN(2); }
		if(qe.key == 16777266) { winForth.getStrN(3); }
		if(qe.key == 16777267) { winForth.getStrN(4); }
		if(qe.key == 16777268) { winForth.getStrN(5); }
		if(qe.key == 16777269) { winForth.getStrN(6); }
		if(qe.key == 16777270) { winForth.getStrN(7); }
		if(qe.key == 16777271) { winForth.getStrN(8); }
		if(qe.key == 16777272) { winForth.getStrN(9); }
		if(qe.key == 16777273) { winForth.getStrN(10); }
		if(qe.key == QtE.Key.Key_Return) {
			EvalString();
		}
		return ev;	// Вернуть событие в C++ Qt для дальнейшей обработки
	}
	// ______________________________________________________________
	// Обработка сигнала - Конец редактирования cmd
	void EndEditCmd() {
		// Взять последнее слово из команд строки
		string s1 = getLastWord(winForth.getCmd(1));
		// Заполнить таблицу подсказок 
		winForth.setTablHelp(getMasNamesForth(s1));
	}
	// ______________________________________________________________
	// Обработка About и AboutQt
	void about(int n) {
		if(n == 1) msgbox("MGW 2016\n\nКонсоль для forth на asm D\n\nD + QtE5 + Qt-5", "about");
		if(n == 2) app.aboutQt();
	}
	// ______________________________________________________________
	// проверочный Test
	void Test() {
		// Проверка Paint
		// fPaint = new CPaint(null, QtE.WindowType.Window); fPaint.saveThis(&fPaint);
		// fPaint.show();
		// -------------
		
		// Попробуем вызвать из D слово Форта
		pp adrWordForth = getCommonAdr(6);
		writeln("adrWordForth = ", adrWordForth);
		// Вызовем на выполнение слово форта
		sw.reset();
		sw.start();
		// -------------------------
		pp rez = executeForth(adrWordForth, 2, 5, 6);
		// -------------------------
		sw.stop();
		stBar.showMessage(showSD() ~ "   { " ~ to!string(sw.peek().usecs) ~ " microsec}" );
		zz.setValue(cast(int)adr_here());     // А здесь HERE тусуется
		writeln(rez);
		
		sw.reset();
		sw.start();
		// -------------------------
		int q = sr(5, 6);
		// -------------------------
		sw.stop();
		writeln(q, "   { " ~ to!string(sw.peek().usecs) ~ " microsec}");
		
		// msgbox("Проверочный Test");
	}
	// ______________________________________________________________
	// Состояние на стеке
	string showSD() {
		string str, str1;
		// Дно стека
		pp a = cast(pp)adr_cSD;
		// Указатель стека
		pp b = cast(pp)adr_SD;
		// Разница
		auto r = a - (b-2);
		str = "[" ~ to!string(r) ~ "]-> ";
		if(r == 0) {
				// Стек пуст
		} else {
			if(r > 0) {
				// На стеке элементы ...
				for(int i; i != r; i++) {
					str1 ~= (to!string( cast(int)*(a-i) ) ~ "  ");
				}
			} 
		}
		return str ~ str1;
	}
	// ______________________________________________________________
	// Проверка вызова метода из forth
	int test3(int a) {
		writeln("a = ", a); stdout.flush();
		return a + a;
	}
	// ______________________________________________________________
	// Создать и показать окошко с DUMP
	void ShowDump() {
		// Проверка создания формы DUMP
		// CMdiDump winDump1 = new CMdiDump(this, QtE.WindowType.Window); 
		if(winDumpKol < 10) {
			winDump[winDumpKol] = new CMdiDump(this, QtE.WindowType.Window); 
			winDump[winDumpKol].saveThis(&winDump[winDumpKol]);
			winDump[winDumpKol].id = winDumpKol;
			mainWid.addSubWindow(winDump[winDumpKol]);
			winForth.showNormal(); 
			winDump[winDumpKol].show();
			winDumpKol++;
		}
	}
}
// __________________________________________________________________
// Глобальные переменные программы
QApplication app;
string sEval;		// Строка для выполнения eval
string sInclude;	// Строка с именем файла для INCLUDE

// __________________________________________________________________
// Глобальная функция. Выдать массив строк из forth, у которых
// есть соответствие в имени
string[] getMasNamesForth(string str1) {
	string[] rez;
	// Выйти, если строка пуста
	if(str1.length == 0) return rez;
	// Конвертнем из Utf-8 (D + Qt) в cp1251 (forth)
	string str = cast(string)fromUtf8to1251(cast(char[])str1);
	pp[256]* mContext = cast(pp[256]*)adrContext(); // Указатель на вектор
	ps nfa = cast(ps)(*mContext)[str[0]]; // Мы на первом слове в цепочке
	// Будем перебирать все слова в цепочке и искать вхождения
	for(;;) {
		if(nfa == null) break;	// Выйти, цепочка закончилась
		string s = to!string((nfa+1));
		// не искать слова в цепочке, если шаблон длинее
		if(str.length <= s.length) {
			// проверим на соответствие шаблону
			if(s[0 .. str.length] == str) {
				// Имена в цепочке в cp1251
				rez ~= to!string(from1251toUtf8(cast(char[])s));
			}
		}
		// Идем на следующее слово в цепочке словаря
		nfa = cast(ps)(*cast(pp)(nfa + (*nfa + 4)));
	}
	return rez;
}
// __________________________________________________________________
// Выдать последнее слово в строке
string getLastWord(string str) {
	string rez;
	string s = strip(str); if(s == "") return rez;
	auto mWords = split(s, " ");
	return mWords[$-1];
}

// __________________________________________________________________
// Замер времени выполнения, для сравнения с фортом
int sr(int a, int b) {
	int rez;
	for(int i; i != 10000; i++) rez = rez + a + b;
	return rez;
}

// __________________________________________________________________
int main(string[] args) {
	bool fDebug;		// T - выдавать диагностику загрузки QtE5
	
  	// Разбор аргументов коммандной строки
   	try {
		auto helpInformation = getopt(args, std.getopt.config.caseInsensitive,
			"d|debug",   toCON("включить диагностику QtE5"), &fDebug,
			"e|eval",    toCON("выполнить строку-команду в форт"), &sEval,
			"i|include", toCON("имя файла для INCLUDE"), &sInclude);
		if (helpInformation.helpWanted) defaultGetoptPrinter(helps(), helpInformation.options);
	} catch(Throwable) { 
		writeln(toCON("Ошибка разбора аргументов командной стоки ...")); return 1; 
	}


	// Загрузка графической библиотеки
	if (1 == LoadQt(dll.QtE5Widgets, fDebug)) return 1;  // Выйти,если ошибка загрузки библиотеки
	// Изготавливаем само приложение
	app = new QApplication(&Runtime.cArgs.argc, Runtime.cArgs.argv, 1);
	FormaMain formaMain = new FormaMain(); formaMain.show().saveThis(&formaMain);

	
	return app.exec();
}
