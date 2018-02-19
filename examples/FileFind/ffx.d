// Быстрый поиск 13.05.2017 10:25

// dmd ffx asc1251 ini qte5 -release

import std.stdio;
import qte5;
import asc1251;
import std.getopt;			// Раазбор аргументов коммандной строки
import std.file;
import std.conv;
import std.string;
import ini;
import core.runtime;		// Обработка входных параметров
import core.sys.windows.windows;
import std.path;
// import std.c.string; - deprecated
import core.stdc.string;
import std.datetime;
import std.process;

const int wr1 = 100;
const int wr = 10000;

version(Windows) {
	string nameIniFile = "C:/fft.ini";
}
version(linux) {
	string nameIniFile = "/home/gena/.local/fft.ini";
}
version(OSX) {
	string nameIniFile = "/Users/gena/qte/ffx.ini";
}

string helps() {
	return	toCON(
"ffx: графический просмотрщик списка файлов по файлу индекса созданному ffc.exe
--------------------------------
ffx [-d] -i ИмяФайлаИндекса.txt
");
}

// Расскраска для виджетов
string strElow  = "background: #FCFDC6"; //#F8FFA1";
string strBlue  = "background: #ACFFF2";
string strFrm   = "background: #FFCC99";

int FFT_width;		// Ширина основной формы, задается в FFT.INI
int FFT_height;		// Высота основной формы, задается в FFT.INI
int GridCol0;
int GridCol1;
int GridCol2;
int GridCol3;

char[][]  mPath;        // массив Путей. Номер соответствует полнуму пути
size_t[]  iPath;        // Массив списка длинн

struct StNameFile {
	size_t      FullPath;       // Полный путь из массива mPath
	char[]      NameFile;       // Имя файла
}

string  nameFileIndex;          // Имя файла индекса
StNameFile[] mName;             // массив имен файлов
char    razd = '|';
// size_t     vec[1000];           // вектор кеша на строки до 1000 символов

bool    runFind;                // Искать или нет

int   mNamelength;

// =================================================================
// ClassMain - Главная Форма для работы
// =================================================================
extern (C) {
	void onAcFind(ClassMain* uk)			{ (*uk).ViewStrs();		}
	void onAcStop(ClassMain* uk)			{ (*uk).knpStop();		}
	void onAcOpen(ClassMain* uk) 			{ (*uk).knpWord();		}
	void  onAcDir(ClassMain* uk) 			{ (*uk).knpOpenDir();	}
}
// __________________________________________________________________
// Основная форма
class ClassMain: QMainWindow {
	QWidget			wd_main;                    // Главное окно
	QVBoxLayout 	lv_main;
	QHBoxLayout 	lh_param, lh_button;
	QStatusBar  	sb_pbar;
	QLabel      	lb_capt1, lb_capt2;         // Подсказка
	QLineEdit   	le_s2,le_s3,le_s4;    		// 2 x 2 поля ввода строк поиска
	QTableWidget 	te_list;                   	// Вывод результата
	QCheckBox   	cb_23;
	// QPushButton 	kn_Edit, kn_Word, kn_Excel, kn_Find;
	QProgressBar   	prb_prog;
	QAction			winAcFind;
	// Выполнители
	QAction act11, act12, act13, act14, act15;
	QAction act21, act22, act23;
	// ToolBar
	QToolBar tb;
	// Вертикальное меню
	QMenu menu11, menu12;
	// Центральная строка меню
	QMenuBar	menuBar;

	// ____________________________
	this() {
		super(null);
		// resize(800, 600); 
		setWindowTitle("Use: " ~ nameFileIndex);
		wd_main = new QWidget(this);
		lv_main = new QVBoxLayout(null);
		sb_pbar = new QStatusBar(this);
		lh_param    = new QHBoxLayout(null);
		lh_button   = new QHBoxLayout(null);

		lb_capt1    = new QLabel(this);		lb_capt1.setText("Путь файла:");
		lb_capt2    = new QLabel(this);		lb_capt2.setText("Имя файла:");

		te_list     = new QTableWidget(this); // te_list.setNoDelete(true);
		
		// le_s1       = new QLineEdit(this);
		le_s2       = new QLineEdit(this);		// le_s2.setStyleSheet(strElow);
		cb_23       = new QCheckBox("", this);
		cb_23.setToolTip("Off = ищется любая комбинайия левой И правой строки
On = то только левая ИЛИ только правая.
Регистр не важен.");
		le_s3       = new QLineEdit(this);		// le_s3.setStyleSheet(strElow);
		le_s4       = new QLineEdit(this);		// le_s4.setStyleSheet(strElow);
		le_s2.setToolTip("Подстрока в ПУТИ файла. Регистр не важен.");
		const string zg = "Подстрока в ИМЕНИ файла. Регистр не важен."; 
		le_s3.setToolTip(zg); le_s4.setToolTip(zg);
		// Кнопки
		// kn_Find     = new QPushButton("Поиск F5", this); kn_Find.setToolTip("Начать поиск ...");

		// kn_Edit     = new QPushButton("Стоп", this); kn_Edit.setToolTip("Остановить поиск ...");
		// kn_Word     = new QPushButton("Открыть файл", this);
		// kn_Word.setToolTip("Windows: Открыть файл использую АССОЦИРОВАННУЮ программу\n
		// 		 Linux: Открыть файл используя текстовый редактор kwrite");
		// kn_Excel    = new QPushButton("Открыть папку с файлом");
		// kn_Excel.setToolTip("Открыть папку содержащию указаный файл.");

		/*
		kn_Find.setStyleSheet(strElow);
		kn_Edit.setStyleSheet(strElow);
		kn_Word.setStyleSheet(strElow);
		kn_Excel.setStyleSheet(strElow);
		*/

		// +++++++++++ Работа с INI файлом +++++++++++
		Ini ini = new Ini(nameIniFile);
		bool isIniFile;		// F = нет ini файла
		isIniFile = ini["Main"] is null;
		if(isIniFile) {
			IniSection sec_ABC = ini.addSection("Main");
			sec_ABC.value("About", "Это INI файл для FFX.EXE - поиск на сервере в ROM");
			sec_ABC.value(".DOC", "? - Укажите путь до WORD");
			sec_ABC.value(".XLS", "? - Укажите путь до EXCEL");

			IniSection sec_Shape = ini.addSection("Shape");
			sec_Shape.value("FFT_width",  "900");
			sec_Shape.value("FFT_height", "500");
			sec_Shape.value("GridCol0", "200");
			sec_Shape.value("GridCol1", "100");
			sec_Shape.value("GridCol2", "100");
			sec_Shape.value("GridCol3", "500");
			resize(900, 500);

			ini.save();
		}

		FFT_width = to!int(ini["Shape"]["FFT_width"]);
		FFT_height = to!int(ini["Shape"]["FFT_height"]);
		GridCol0 = to!int(ini["Shape"]["GridCol0"]);
		GridCol1 = to!int(ini["Shape"]["GridCol1"]);
		GridCol2 = to!int(ini["Shape"]["GridCol2"]);
		GridCol3 = to!int(ini["Shape"]["GridCol3"]);
		// ----------- Работа с INI файлом -----------

		te_list.setColumnCount(4); // Четыре колонки
		te_list.setColumnWidth(0, GridCol0);
		te_list.setColumnWidth(1, GridCol1);
		te_list.setColumnWidth(2, GridCol2);
		te_list.setColumnWidth(3, GridCol3);


		// Делаю кнопку
		winAcFind = new QAction(this, &onAcFind, aThis, 0);
		winAcFind.setHotKey(QtE.Key.Key_S | QtE.Key.Key_ControlModifier);
		// connects(kn_Find, "clicked()", winAcFind, "Slot_v__A_N_v()");


		// Соберем строку с полями ввода и кнопкой. Гориз выравниватель
		lh_param.addWidget(lb_capt1); /* lh_param.addWidget(le_s1); lh_param.addWidget(cb_12); */ 
		lh_param.addWidget(le_s2);
		lh_param.addWidget(lb_capt2);
		lh_param.addWidget(le_s3);
		lh_param.addWidget(cb_23);
		lh_param.addWidget(le_s4);
		cb_23.setText("или");

		// Соберем кнопки
		//lh_button.addWidget(kn_Find);
		//lh_button.addWidget(kn_Edit);
		//lh_button.addWidget(kn_Word);
		//lh_button.addWidget(kn_Excel);

		prb_prog     = new QProgressBar(this);	// prb_prog.setStyleSheet(tmpQsSet(strBlue));

		// Соберем вертикальный выравниватель
		lv_main.addLayout(lh_param);
		lv_main.addWidget(te_list);
		lv_main.addWidget(prb_prog);
		//lv_main.addLayout(lh_button);

		wd_main.setLayout(lv_main);
		setCentralWidget(wd_main);
		setStatusBar(sb_pbar);

		resize(FFT_width, FFT_height);

		// Событие начала поиска файлов
		act11 = new QAction(this, &onAcFind, aThis);
		act11.setText("Find").setHotKey(QtE.Key.Key_F5);
		connects(act11, "triggered()", act11, "Slot_v__A_N_v()");
		act11.setIcon("icon_play.png").setToolTip("F5 - Начать поиск файлов по выбранным шаблонам ...");

		// Событие остановить поиск
		act12 = new QAction(this, &onAcStop, aThis);
		act12.setText("Stop").setHotKey(QtE.Key.Key_Escape);
		connects(act12, "triggered()", act12, "Slot_v__A_N_v()");
		act12.setIcon("icon_stop.png").setToolTip("Esc - Прервать поиск файлов ...");

		// Событие открыть файл
		act13 = new QAction(this, &onAcOpen, aThis);
		act13.setText("Open").setHotKey(QtE.Key.Key_F6);
		connects(act13, "triggered()", act13, "Slot_v__A_N_v()");
		act13.setIcon("icon_open.png").setToolTip("F6 - Открыть выбранный файл ...");

		// Событие открыть папку с файлом
		act14 = new QAction(this, &onAcDir, aThis);
		act14.setText("Folder").setHotKey(QtE.Key.Key_F7);
		connects(act14, "triggered()", act14, "Slot_v__A_N_v()");
		act14.setIcon("icon_folder_open.png").setToolTip("F7 - Открыть папку с файлом ...");

		tb = new QToolBar(this); // tb.setToolButtonStyle(QToolBar.ToolButtonStyle.ToolButtonTextBesideIcon);
		tb.addAction(act11).addAction(act12).addAction(act13).addAction(act14);
		addToolBar(QToolBar.ToolBarArea.TopToolBarArea, tb);
		// Menu
 		menu11 = new QMenu(this);  menu12 = new QMenu(this);
		// Центральная строка меню
		menuBar = new QMenuBar(this);
		// --------------- Взаимные настройки -----------------
		menu11.setTitle("Execute")
			.addAction(		act11	)
			.addAction(		act12	)
			.addAction(		act13	)
			.addAction(		act14	);
		menuBar.addMenu(menu11);
		setMenuBar(menuBar);
	}
	// ____________________________
	void knpStop() {
		runFind = false;
	}
	// ____________________________
	void loadIndex() {      // Прочитать файл в память
		bool f = true;
		bool fLoad;         // Проверка на правильность структуры индексного файла
		StNameFile el;

		void ErrMessage() {
			msgbox("Файл индекса поврежден или не найден!","Внимание!",QMessageBox.Icon.Critical);
			sb_pbar.showMessage("Файл индекса поврежден или не найден!");
		}
		// Прочитаем исходный файл
		if(!exists(nameFileIndex)) {
			ErrMessage();
		}
		File fIndex = File(nameFileIndex, "r");
		int i;
		foreach(line; fIndex.byLine()) {
			if(i==i++/wr1*wr1) app.processEvents();
			if(line == "#####") {
				f = false;
				fLoad = true;
			} else {
				if(f) {
					mPath ~= line.dup;
				} else {
					el.FullPath = to!int(Split1251(line, razd, 0));
					el.NameFile = Split1251(line, razd, 1) ~ 0;
					// el.NameFileU = toUpper1251(Split1251(line, razd, 1) ~ 0);
					mName ~= el;
				}
			}
		}
		// --------------------------
		if(fLoad) {
			string frase = format("Use: %s,  Load folders %s,  files %s", nameFileIndex, mPath.length, mName.length);
			setWindowTitle(frase);
			// sb_pbar.showMessage(frase);
			le_s3.setFocus();
			prb_prog.setValue(0);
		} else {
			ErrMessage();
		}
	}
	// ____________________________
	void ViewStrs() {              // Искать вхождения строк
		int indTab;		// строка в таблице
		size_t n;
		char[] strNames;
		QString qstr = new QString();
		bool pb1, pb2, pb3, pb4;
		bool b1, b2, b3, b4;
		char[] str_cmp1, str_cmp2, str_cmp3, str_cmp4;
		char[] str_empty = cast(char[])"";
		string str_compare;

		// +++++++++++ Работа с INI файлом +++++++++++
		// Запомним текущую позицию и ширину колонок
		Ini ini = new Ini(nameIniFile);
		IniSection sec_Shape = ini.addSection("Shape");
		sec_Shape.value("FFT_width",   to!string(width));
		sec_Shape.value("FFT_height",  to!string(height));
		sec_Shape.value("GridCol0",  to!string(te_list.columnWidth(0)));
		sec_Shape.value("GridCol1",  to!string(te_list.columnWidth(1)));
		sec_Shape.value("GridCol2",  to!string(te_list.columnWidth(2)));
		sec_Shape.value("GridCol3",  to!string(te_list.columnWidth(3)));
		ini.save();
		// ----------- Работа с INI файлом -----------

		mNamelength = cast(int)mName.length-1; // Для ProgressBar
		// Подготовим аргументы сравнения
		// QString qstr_compare = new QString();
		string qstr_compare;

/*
		le_s1.text(qstr_compare);
		if(qstr_compare.size == 0) {
			str_cmp1 = str_empty;
			pb1 = false;
		} else {
			str_cmp1 = toUpper1251(cast(char[])qstr_compare.fromUnicode(str_compare, WIN_1251)) ~ 0;
			pb1 = true;
		}
*/
		qstr_compare = le_s2.text!string();
		if(qstr_compare.length == 0) {
			str_cmp2 = str_empty;
			pb2 = false;
		} else {
			str_cmp2 = toUpper1251(fromUtf8to1251(cast(char[])qstr_compare)) ~ 0;
			pb2 = true;
		}

		qstr_compare = le_s3.text!string();
		if(qstr_compare.length == 0) {
			str_cmp3 = str_empty;
			pb3 = false;
		} else {
			str_cmp3 = toUpper1251(fromUtf8to1251(cast(char[])qstr_compare)) ~ 0;
			pb3 = true;
		}

		qstr_compare = le_s4.text!string();
		if(qstr_compare.length == 0) {
			str_cmp4 = str_empty;
			pb4 = false;
		} else {
			str_cmp4 = toUpper1251(fromUtf8to1251(cast(char[])qstr_compare)) ~ 0;
			pb4 = true;
		}

		prb_prog.setMinimum(0);
		prb_prog.setMaximum(mNamelength);
		int j;
		te_list.setRowCount(0);

		void PrintEk(StNameFile el) {

			if(el.NameFile.length > 0) if(el.NameFile[$-1] == 0) el.NameFile = el.NameFile[0..$-1];
			char[] chM_shortName = from1251toUtf8(el.NameFile);
			char[] chM_fullName  = from1251toUtf8(mPath[el.FullPath]);
			char[] fullName = chM_fullName ~ dirSeparator ~ chM_shortName;
			
			// Попробуем внести сразу в таблицу
			te_list.insertRow(indTab);
			QTableWidgetItem tbNameFile = new QTableWidgetItem(0); tbNameFile.setNoDelete(true);
			tbNameFile.setText(to!string(chM_shortName));
			
			QTableWidgetItem tbFullNameFile = new QTableWidgetItem(0);
			tbFullNameFile.setText(to!string(fullName));
			tbFullNameFile.setNoDelete(true);
			te_list.setItem(indTab, 0, tbNameFile);
			te_list.setRowHeight(indTab, 20);
			// Проверим размер файла и его наличие
			ulong sizeFile;
			bool isFileOnDisk;
			try {
				sizeFile = std.file.getSize(fullName);
				isFileOnDisk = true;
			} catch(Throwable) {
				sizeFile = 0;
				isFileOnDisk = false;
			}
			// Файл существует
			if(isFileOnDisk) {
				QTableWidgetItem twiSize = new QTableWidgetItem(0);
				twiSize.setNoDelete(true);
				twiSize.setText(format("%10s  ", sizeFile));
				twiSize.setTextAlignment(QtE.AlignmentFlag.AlignRight | QtE.AlignmentFlag.AlignVCenter);
				te_list.setItem(indTab, 2, twiSize);

				SysTime atf, mtf;
				getTimes(chM_fullName, atf, mtf);
				string tmpTime = format("%02s.%02s.%4s", to!int(mtf.day), to!int(mtf.month), to!int(mtf.year));
				QTableWidgetItem twiDate = new QTableWidgetItem(0);
				twiDate.setText(tmpTime);
				twiDate.setNoDelete(true);
				twiDate.setTextAlignment(QtE.AlignmentFlag.AlignCenter);
				te_list.setItem(indTab, 1, twiDate);
			}
			te_list.setItem(indTab, 3, tbFullNameFile);
			indTab++;
		}

		runFind = true;

		// Подпрограмма поиска одиночного вхождения
		void find1(char[] str_cmp) {
			bool b;
			char *uksh = cast(char*)(str_cmp).ptr;
			char *uk;
			int i;
			foreach(el; mName) {
				if(!runFind) break;
				if(i==i++/wr*wr) {
					prb_prog.setValue(j);
					app.processEvents();
				}
				j++;
				// b = null != strstr(cast(char*)(toUpper1251(el.NameFile)), uksh);
				// uk = cast(char*)el.NameFileU.ptr;
				uk = cast(char*)(toUpper1251(el.NameFile));
				b = null != strstr(uk, uksh);
				if(b) PrintEk(el);
			}
			prb_prog.setValue(mNamelength);
		}
		// Подпрограмма поиска двойного вхождения
		void find2(char[] str_cmp1, char[] str_cmp2, bool bif) {
			bool b1, b2;
			char *uksh1 = cast(char*)(str_cmp1).ptr;
			char *uksh2 = cast(char*)(str_cmp2).ptr;
			char *uk;
			int i;
			foreach(el; mName) {
				if(!runFind) break;
				if(i==i++/wr*wr) {
					prb_prog.setValue(j);
					app.processEvents();
				}
				j++;
				// b1 = null != strstr(cast(char*)(toUpper1251(el.NameFile)), uksh1);
				// b2 = null != strstr(cast(char*)(toUpper1251(el.NameFile)), uksh2);
				uk = cast(char*)(toUpper1251(el.NameFile));
				if(bif) {
					b1 = null != strstr(uk, uksh1);
					b2 = null != strstr(uk, uksh2);
					if(b1 | b2) PrintEk(el);
				} else    { // оптимизация вычисления 2 выражения
					b1 = null != strstr(uk, uksh1);
					if(b1) {
						b2 = null != strstr(uk, uksh2);
						if(b2) PrintEk(el);
					}
				}
			}
			prb_prog.setValue(mNamelength);
		}

		// Начнем поиск и сравнение
		if(!pb4 & !pb3 & !pb2 & !pb1) {
			goto M1;
		}
		if(pb4 & !pb3 & !pb2 & !pb1) {
			find1(str_cmp4);
			goto M1;
		}
		if(!pb4 & pb3 & !pb2 & !pb1) {
			find1(str_cmp3);
			goto M1;
		}
		if(pb4 & pb3 & !pb2 & !pb1) {
			if(cb_23.isChecked()) {   // Или
				find2(str_cmp3, str_cmp4, true);
			} else {                  // И
				find2(str_cmp3, str_cmp4, false);
			}
			goto M1;
		}
//-----------------------
		if(!pb4 & !pb3 & pb2) {
			int i;
			char *uksh = cast(char*)(str_cmp2).ptr;
			foreach(el; mName) {
				if(!runFind) break;
				if(i==i++/wr*wr) {
					prb_prog.setValue(j);
					app.processEvents();
				}
				j++;
				// char[] pf = mPath[el.FullPath].dup;
				b2 = null != strstr(cast(char*)(toUpper1251(mPath[el.FullPath]) ~ 0), uksh);
				if(b2)  {
					PrintEk(el);
				}
			}
			goto M1;
		}
		if(pb4 & !pb3 & pb2) {
			int i;
			char *uksh2 = cast(char*)(str_cmp2).ptr;
			char *uksh4 = cast(char*)(str_cmp4).ptr;
			foreach(el; mName) {
				if(!runFind) break;
				if(i==i++/wr*wr) {
					prb_prog.setValue(j);
					app.processEvents();
				}
				j++;
				b2 = null != strstr(cast(char*)(toUpper1251(mPath[el.FullPath]) ~ 0), uksh2);
				b4 = null != strstr(cast(char*)(toUpper1251(el.NameFile)), uksh4);
				if(b2 & b4)  {
					PrintEk(el);
				}
			}
			goto M1;
		}

		if(!pb4 & pb3 & pb2) {
			int i;
			char *uksh2 = cast(char*)(str_cmp2).ptr;
			char *uksh3 = cast(char*)(str_cmp3).ptr;
			foreach(el; mName) {
				if(!runFind) break;
				if(i==i++/wr*wr) {
					prb_prog.setValue(j);
					app.processEvents();
				}
				j++;
				b2 = null != strstr(cast(char*)(toUpper1251(mPath[el.FullPath]) ~ 0), uksh2);
				b3 = null != strstr(cast(char*)(toUpper1251(el.NameFile)), uksh3);
				if(b2 & b3)  {
					PrintEk(el);
				}
			}
			goto M1;
		}
		if(pb4 & pb3 & pb2) {
			if(cb_23.isChecked()) {   // Или
				int i;
				if(i==i++/wr*wr) {
					prb_prog.setValue(j);
					app.processEvents();
				}
				j++;
				char *uksh4 = cast(char*)(str_cmp4).ptr;
				char *uksh2 = cast(char*)(str_cmp2).ptr;
				char *uksh3 = cast(char*)(str_cmp3).ptr;
				foreach(el; mName) {
					if(!runFind) break;
					if(i==i++/wr*wr) {
						prb_prog.setValue(j);
						app.processEvents();
					}
					j++;
					b2 = null != strstr(cast(char*)(toUpper1251(mPath[el.FullPath]) ~ 0), uksh2);
					b3 = null != strstr(cast(char*)(toUpper1251(el.NameFile)), uksh3);
					b4 = null != strstr(cast(char*)(toUpper1251(el.NameFile)), uksh4);
					if((b3 | b4) & b2)  {
						PrintEk(el);
					}
				}
			} else {                  // И
				int i;
				if(i==i++/wr*wr) {
					prb_prog.setValue(j);
					app.processEvents();
				}
				j++;
				char *uksh4 = cast(char*)(str_cmp4).ptr;
				char *uksh2 = cast(char*)(str_cmp2).ptr;
				char *uksh3 = cast(char*)(str_cmp3).ptr;
				foreach(el; mName) {
					if(!runFind) break;
					if(i==i++/wr*wr) {
						prb_prog.setValue(j);
						app.processEvents();
					}
					j++;
					b2 = null != strstr(cast(char*)(toUpper1251(mPath[el.FullPath]) ~ 0), uksh2);
					b3 = null != strstr(cast(char*)(toUpper1251(el.NameFile)), uksh3);
					b4 = null != strstr(cast(char*)(toUpper1251(el.NameFile)), uksh4);
					if((b3 & b4) & b2)  {
						PrintEk(el);
					}
				}
			}
			goto M1;
		}

M1:
		// if(!runFind)  prb_prog.setValue(0);
		prb_prog.setValue(mNamelength);
	}
	// ____________________________
	void knpOpenDir() {     // Открыть каталог с файлом
		try {
			QTableWidgetItem ti = te_list.item(te_list.currentRow(), 3);
			string nameProc = ti.text!string();
			// Это реакция на кнопку открыть папку
			version(Windows) {
				auto pid = spawnProcess(["explorer", dirName(nameProc)]);
			}
			version(linux) {
				auto pid = spawnProcess(["dolphin", "--select", nameProc]);
			}
			version(OSX) {
				auto pid = spawnProcess(["open", "-R", nameProc]);
			}
		} catch(Throwable) {
			msgbox("Осуществите поиск и укажите файл.");
		}
	}
	// ____________________________
	void knpWord() {        // Открыть файл в редакторе
		static import std.ascii;
		string FileExec;
		try {
			QTableWidgetItem ti = te_list.item(te_list.currentRow(), 3);
			string nameProc = ti.text!string();
			version(Windows) {
				char[] nameFileAscii = fromUtf8to1251(cast(char[])nameProc) ~ 0 ~ 0;
				writeln(nameFileAscii);
				import core.sys.windows.windows;
				auto z = ShellExecuteA(wd_main.winid(), null, 
					cast(const(char)*)(nameFileAscii).ptr , null, null, SW_SHOWNORMAL);
			}
			version(linux) {
				string extNameFile = extension(nameProc);
				string extNameFileUp;
				for(int i; i != extNameFile.length; i++) extNameFileUp ~= std.ascii.toUpper(extNameFile[i]);
				// Тут надо многое проверить
				Ini ini = new Ini(nameIniFile);
				FileExec = ini["Main"][extNameFileUp];
				if(FileExec.length == 0) {
					msgbox(r"Укажите в C:/FFT.INI строку с программой для вызова " ~ extNameFileUp);
				} else {
					if(FileExec[0] == '?') {
						msgbox(r"Укажите в C:/FFT.INI строку с программой для вызова " ~ extNameFileUp);
					} else {
						auto edQuest = spawnProcess([FileExec, nameProc]);
					}
				}
			}
			version(OSX) {
				string extNameFile = extension(nameProc);
				string extNameFileUp;
				for(int i; i != extNameFile.length; i++) extNameFileUp ~= std.ascii.toUpper(extNameFile[i]);
				// Тут надо многое проверить
				Ini ini = new Ini(nameIniFile);
				FileExec = ini["Main"][extNameFileUp];
				if(FileExec.length == 0) {
					msgbox(r"Укажите в C:/FFT.INI строку с программой для вызова " ~ extNameFileUp);
				} else {
					if(FileExec[0] == '?') {
						msgbox(r"Укажите в C:/FFT.INI строку с программой для вызова " ~ extNameFileUp);
					} else {
						auto edQuest = spawnProcess([FileExec, nameProc]);
					}
				}
			}

			//			writeln("[", extNameFileUp,"] --> [", FileExec,"]");
			// auto edQuest = spawnProcess([MsWord, s]);
			// auto pid = spawnShell('"' ~ nameProc ~ '"');
		} catch(Throwable) {
			msgbox("Возможно не установлены программы на это расширение в INI.");
		}
	}
	
}

// __________________________________________________________________
// Глобальные переменные программы
QApplication app;				// Само приложение
// __________________________________________________________________
int main(string[] args) {
	bool fDebug;		// T - выдавать диагностику загрузки QtE5
	// ClassMain wd_Main;

	// Разбор аргументов коммандной строки
	try {
		auto helpInformation = getopt(args, std.getopt.config.caseInsensitive,
			"d|debug", toCON("включить диагностику QtE5"), 		&fDebug,
			"i|ind", toCON("имя файла индекса"),				&nameFileIndex);
		if (helpInformation.helpWanted) { defaultGetoptPrinter(helps(), helpInformation.options); return 0; }
	} catch(Throwable) {
		writeln(toCON("Ошибка в аргументах, смотри: ffx --help")); return 1;
	}
	// Проверим на существование файл индекса
	if(!exists(nameFileIndex)) {
		writeln(toCON("Ошибка: Не найден индексный файл = [" ~ nameFileIndex ~ "]")); return 1;
	}
	// Загрузка графической библиотеки
	if (1 == LoadQt(dll.QtE5Widgets, fDebug)) return 1;  // Выйти,если ошибка загрузки библиотеки

	// Изготавливаем само приложение
	app = new QApplication(&Runtime.cArgs.argc, Runtime.cArgs.argv, 1);
	ClassMain formaMain = new ClassMain(); formaMain.show().saveThis(&formaMain);

	formaMain.loadIndex();

	return app.exec();
}