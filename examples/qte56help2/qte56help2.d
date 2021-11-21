// QtE56Help - утилита подсказок ...
// ---------------------------------
import std.stdio;
import qte56, core.runtime;
import std.conv, std.file;
import std.array, std.format, std.string;
import lib56;
import std.algorithm.iteration;
import std.array;

// dmd qte56help2.d qte56.d lib56.d asc1251.d -release -J. -mcpu=native -m64
// __________________________________________________________________
// a3.qrc - файл ресурсов Qt из QtDesigner: rcc -binary a3.qrc -o a3.rcc
// Загружаю файл a3.qrc ресурсов
ubyte* gResource = cast(ubyte*)import("a3.rcc");
const nameFileThemas = "qte56help2.html";

// Работа с текстовым файлом, как сборником статей
class CHelpTxt {
alias t_listStr = string[];
public:
	// ______________________________________________
	// Конструктор
	this() {
		_status = 1;					// Нет готовности
	}
	// ______________________________________________
	// Конструктор
	this(string nameFileHelpTxt) {
		_nameFileHelpTxt = nameFileHelpTxt;
		_status = 1;					// Нет готовности
	}
	// ______________________________________________
	// Записать / прочитать имя файла с текстами
	@property string nameFileHelpTxt(string nfht = "") {
		if(!nfht.length) {
			return _nameFileHelpTxt;
		} else {
			_nameFileHelpTxt = nfht;
		}
		return "";
	}	
	// ______________________________________________
	// Прочитать статус
	@property ubyte status() {
		return _status;
	}	
	// ______________________________________________
	// Включить / Выключить готовность 
	@property onOff(bool cmd) {
		if(cmd) {
			// Пытаюсь включится
			tryOn();
		} else {
			// Выключаюсь ...
			_status = 1;
		}
	}	
	// ______________________________________________
	// Дай список тем
	string[] getListThemas() {
		string[] rez;
		foreach(ind,kl; _themas) rez ~= ind;
		return rez;
	}
	// ______________________________________________
	// Дай список статей на основании темы
	string[] getListArticls(string thema) {
		return _themas[thema];
	}
	// ______________________________________________
	// Дай статью имея на входе тему и статью
	string[] getArticl(string thema, string articl) {
		string[] rez;
		File hf;
		try {
			hf = File(_nameFileHelpTxt, "r");
		} catch (Throwable) {
			_status = 4; return rez;
		} 
		// Читаю оглавление
		string s;
		bool trgIsArticl;		// F - нет, T - под нами статья
		try {
			foreach(line; hf.byLine()) {
				s = to!string(line);
				if(trgIsArticl) {
					// Над статьёй
					if(s == "%!!") {
						trgIsArticl = false;
						break;
					}
					rez ~= s;
				} else {
					// Это Не статья
					s = strip(s);
					if(!s.length) continue;
					if(s[0] == '%') {
						if(s.length > 2) {
							if(s[1] == '!') {
								// Это заголовок статьи
								string shb = "%!" ~ thema ~ "|" ~ articl;
								if(shb == s) {
									// Найден нужный мне заголовок
									trgIsArticl = true;
									continue;
								}
							}
						}
					}
				}
			}
		} catch (Throwable) {
			_status = 4; return rez;
		} 
		return rez;
	}
protected:
	string 		_nameFileHelpTxt;		// Хранит имя файла со статьями
	ubyte		_status;				// 0=Ok, 1=Begin, 2=NoName 3=NoFile 4=ErRead ... Error
	t_listStr[string]	_themas;		// Список тем
	
	// ______________________________________________
	// Попытка включится ... 
	void tryOn() {
		// 1 - А имя файла то вообще то есть?
		if(!_nameFileHelpTxt.length)  { _status = 2; return; }
		// 2 - Файл то существует?
		if(!exists(_nameFileHelpTxt)) { _status = 3; return; }
		// 3 - Будем считать, что включились	
		File hf;
		try {
			hf = File(_nameFileHelpTxt, "r");
		} catch (Throwable) {
			_status = 4; return;
		} 
		// Читаю оглавление
		string s;
		try {
			foreach(line; hf.byLine()) {
				s = to!string(line);
				s = strip(s);
				if(!s.length) continue;
				if(s[0] == '%') {
					if(s.length > 2) {
						if(s[1] == '%') {
							// Это команды
							if(s == "%%|") break; // Конец секции команд
							// Это просто команда %%, будем на неё смотреть
							string[] m = split(s[2 .. $], '|');
							_themas[m[0]] ~= m[1]; // Добавить статью в список
						}
					}
				}
			}
		} catch (Throwable) {
			_status = 4; return;
		} 
		// writeln(_themas);
		_status = 0;
		hf.close();
	}
}

unittest {
/*
	CHelpTxt fh = new CHelpTxt();
	fh.nameFileHelpTxt = "";
	assert(fh.status == 1);
	fh.onOff = true;
	assert(fh.status == 2);
	fh.nameFileHelpTxt = "edweewe";
	fh.onOff = true;
	assert(fh.status == 3);
	fh.nameFileHelpTxt = "shlp.d";
	fh.onOff = true;
	assert(fh.status == 0);
	assert(fh.getListThemas() == ["Демо", "Простые примеры"]);
	assert(fh.getListArticls("Демо") == ["Демо №1", "Демо №2", "Демо №3"]);
*/
}


// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// QtE56Help - Главное окно программы
// __________________________________________________________________
extern (C) {
    void onExit(QtE56Help* uk, int n)	    { (*uk).runExit();    }
    void onAbout(QtE56Help* uk, int n)	    { (*uk).runAbout(n);  }
    void onExecNabor(QtE56Help* uk, int n)	{ (*uk).runExecNabor(n);  }
    void onMeta(QtE56Help* uk, int n)	    { (*uk).runMeta();  }
    void onSaveSource(QtE56Help* uk, int n)	{ (*uk).runSaveSource();  }
    void onViewSource(QtE56Help* uk, int n)	{ (*uk).runViewSource();  }
	
	void onCmbTema(QtE56Help* uk, int n, int sg)	{ (*uk).runCmbTema(n, sg);  }
	void onCmbPage(QtE56Help* uk, int n, int sg)	{ (*uk).runCmbPage(n, sg);  }
}
// __________________________________________________________________
class QtE56Help: QMainWindow {
protected:
	QFormBuilder 	qfb;   		// Генератор форм из ресурсов Qt
	QAction      	acAboutQt, acAboutApp, acExit;
	// Страница Построители
	QAction			acExecNabor, acMeta;
	QComboBox    	cmb_Nabor;
	QPushButton  	knNabor, knMeta;
	QSpinBox		spNomFunc;
	QLineEdit		lineEdit_Class, lineEdit_Suffiks;
	QPlainTextEdit	plainTextEdit_Post;
	QStatusBar		sb;
	// Нужно запомнить изначальную строку (перечень)
	string			saveFromPost;
	QAction			acSaveSource, acViewSource;
	QPushButton  	knSaveSource, knViewSource;
	QComboBox    	cmbExTema, cmbExPage;
	QAction         aExTema, aExPage;
	CHelpTxt        objThema;
	
	QTextEdit		textEditPage;

public:
	// _____________________________________________________________
	// Конструктор
	this() {
		// Инициализирую предка
		super(null, QtE.WindowType.Window);
		// Изготавливаю генератор форм
		qfb = new QFormBuilder(this);
		// Гружу форму Qt из ресурса, и встраиваю в форму D
		setQtObj((qfb.load(":/fQtE56help.ui")).QtObj);
		// Устанавливаю заголовок и размер главной формы
		setWindowTitle("QtE56Help - утилита подсказок"); 
		
		resize(new QSize(900, 500));
		
		// При создании D-шного Актиона, ищу Qt-шный Актион и запоминаю его в D-шном 
		acExit = new QAction('+', qfb.findChildAdr!string("actionExit"), this, &onExit,  aThis); 
		// acExit.getAdrActionQt --> Выдать из D-шного Актиона указатель на Qt-шный Актион
		// connects ... Связать сигел Qt-шный Актион с слотом D-шный Актион (&onExit --> runExit)
		connects(acExit.getAdrActionQt, "triggered()", acExit, "Slot_AN()");
		// AboutQt
		acAboutQt = new QAction('+', qfb.findChildAdr!string("actionAboutQt"), this, &onAbout,  aThis, 2); 
		connects(acAboutQt.getAdrActionQt, "triggered()", acAboutQt, "Slot_AN()");
		// AboutApp
		acAboutApp = new QAction('+', qfb.findChildAdr!string("actionAboutApp"), this, &onAbout,  aThis, 1); 
		connects(acAboutApp.getAdrActionQt, "triggered()", acAboutApp, "Slot_AN()");
		// Ищу ComboBox выбора набора
		cmb_Nabor = new QComboBox('+', qfb.findChildAdr!string("comboBox_Nabor")); 
		cmb_Nabor.setStyleSheet("background: Tan");
		cmb_Nabor.addItem("Набор №1", 0).addItem("Набор №2", 1).addItem("Набор №3-test", 2);
		// Ищу Кнопку старта на форме
		knNabor = new QPushButton('+', qfb.findChildAdr!string("pushButton_Nabor")); 
		acExecNabor = new QAction(this, &onExecNabor,  aThis);
		connects(knNabor, "clicked()", acExecNabor, "Slot_AN()");

		// Ищу ComboBox тема и статья
		cmbExTema = new QComboBox('+', qfb.findChildAdr!string("cmbExTema")); 
		cmbExPage = new QComboBox('+', qfb.findChildAdr!string("cmbExPage")); 

		// Ищу QStatusBar
		sb = new QStatusBar('+', qfb.findChildAdr!string("sb")); 
		// Ищу Кнопку meta на форме
		knMeta = new QPushButton('+', qfb.findChildAdr!string("knMeta")); 
		acMeta = new QAction(this, &onMeta,  aThis);
		connects(knMeta, "clicked()", acMeta, "Slot_AN()");

		// Ищу Кнопку Save на форме
		knSaveSource = new QPushButton('+', qfb.findChildAdr!string("knSave")); 
		acSaveSource = new QAction(this, &onSaveSource,  aThis);
		connects(knSaveSource, "clicked()", acSaveSource, "Slot_AN()");

		// Ищу Кнопку View на форме
		knViewSource = new QPushButton('+', qfb.findChildAdr!string("knView")); 
		acViewSource = new QAction(this, &onViewSource,  aThis);
		connects(knViewSource, "clicked()", acViewSource, "Slot_AN()");
		
		spNomFunc = new QSpinBox('+', qfb.findChildAdr!string("spinBox_Nomer")); 
		spNomFunc.setValue(12);
		
		lineEdit_Class = new QLineEdit('+', qfb.findChildAdr!string("lineEdit_Class")); 
		lineEdit_Suffiks = new QLineEdit('+', qfb.findChildAdr!string("lineEdit_Suffiks"));
		lineEdit_Class.setText = "QWidget";
		lineEdit_Suffiks.setText = "setXX2";
		plainTextEdit_Post = new QPlainTextEdit('+', qfb.findChildAdr!string("plainTextEdit_Post")); 
		
		textEditPage = new QTextEdit('+', qfb.findChildAdr!string("textEditPage")); 
		
		objThema = new CHelpTxt(nameFileThemas); // Создаю объект список статей
		objThema.onOff = true;
		if(objThema.status == 0) {
			// Набираю список тем
			int n;
			foreach(sThema; objThema.getListThemas()) cmbExTema.addItem(sThema, n++);
			// Нужно прочитать первую тему
			n = 0;
			// Читаю список статей
			foreach(sArticl; objThema.getListArticls(cmbExTema.text!string)) cmbExPage.addItem(sArticl, n++);
		} else {
			sb.showMessage("Ошибка чтения файла" ~ nameFileThemas ~ " st = " ~ to!string(objThema.status), 5000);
		}
		aExTema = new QAction(this, &onCmbTema,  aThis);
		connects(cmbExTema, "activated(int)", aExTema, "Slot_ANI(int)");

		aExPage = new QAction(this, &onCmbPage,  aThis);
		connects(cmbExPage, "activated(int)", aExPage, "Slot_ANI(int)");
		
	// fh.onOff = true;
	// assert(fh.status == 0);
	// assert(fh.getListThemas() == ["Демо", "Простые примеры"]);
	// assert(fh.getListArticls("Демо") == ["Демо №1", "Демо №2", "Демо №3"]);
		
	}
	// _____________________________________________________________
	// slot - Показать сохранённый исходный текст
	void runViewSource() {
		plainTextEdit_Post.clear();
		plainTextEdit_Post.setPlainText(saveFromPost);
		sb.showMessage("Исходный текст востановлен ...", 5000);
	}
	// _____________________________________________________________
	// slot - Сохранить исходный текст в буфере
	void runSaveSource() {
		saveFromPost = plainTextEdit_Post.toPlainText!string();
		sb.showMessage("Исходный текст сохранён ...", 5000);
	}
	// _____________________________________________________________
	// slot - Кнопка мета
	void runMeta() {
		plainTextEdit_Post.clear();
		int tekIndexNabor = cmb_Nabor.currentIndex();
		string sReply;
		
		string strSource = saveFromPost; // Из сохранённого plainTextEdit_Post.toPlainText!string();
		auto mas = split(strSource, "\n");
		
		string[] listFun1, listFun2;
		string s, sRawForm, sTest, sTest2, sTest3;
	
		foreach(line; mas) {
			s = strip(to!string(line));
			if(!s.length) continue;
			sRawForm = parseSourceStr(s);
			sTest = n1__void_int_bool__1_void_int_bool(sRawForm);
			if( sTest[0] == '1') { listFun1 ~=  sTest; continue; }
			sTest2 = n2__void_int_bool__2_int_bool_enum(sRawForm);
			if(sTest2[0] == '2') { listFun1 ~= sTest2; continue; }
			sTest3 = n3__qs__1_int_bool_qs(sRawForm);
			if(sTest3[0] == '3') { listFun1 ~= sTest3; continue; }
			listFun1 ~= "*~" ~ sRawForm;
		}
		// К этому моменту в listFun1 - нужный мне список
		sReply = join(listFun1, "\n");
		plainTextEdit_Post.setPlainText(sReply);
	}
	// _____________________________________________________________
	// slot - Кнопка запуска набора
	void runExecNabor(int n) {
		plainTextEdit_Post.clear();
		int tekIndexNabor = cmb_Nabor.currentIndex();
		string sReply;
		
		string strSource = saveFromPost; // Из сохранённого plainTextEdit_Post.toPlainText!string();
		auto mas = split(strSource, "\n");
		
		string[] listFun1, listFun2, listFun3;
		string s, sRawForm, sTest, sTest2, sTest3;
	
		foreach(line; mas) {
			s = strip(to!string(line));
			if(!s.length) continue;
			sRawForm = parseSourceStr(s);
			sTest = n1__void_int_bool__1_void_int_bool(sRawForm);
			if(sTest[0] == '1') {
				listFun1 ~= sTest;
			}
			else {
				sTest2 = n2__void_int_bool__2_int_bool_enum(sRawForm);
				if(sTest2[0] == '2') {
					listFun2 ~= sTest2;
				} else {
					sTest3 = n3__qs__1_int_bool_qs(sRawForm);
					if(sTest3[0] == '3') listFun3 ~= sTest3;
				}
			}
		}
		// Определяю номер набора
		if(tekIndexNabor == 0) {
			auto q = createSet_1(listFun1, spNomFunc.value(), lineEdit_Class.text!string(), lineEdit_Suffiks.text!string());
			sReply = join(q, "\n");
			plainTextEdit_Post.setPlainText(sReply);
		}
		if(tekIndexNabor == 1) {
			auto q = createSet_2(listFun2, spNomFunc.value(), lineEdit_Class.text!string(), lineEdit_Suffiks.text!string());
			sReply = join(q, "\n");
			plainTextEdit_Post.setPlainText(sReply);
		}
		if(tekIndexNabor == 2) {
			auto q = createSet_3(listFun3, spNomFunc.value(), lineEdit_Class.text!string(), lineEdit_Suffiks.text!string());
			sReply = join(q, "\n");
			plainTextEdit_Post.setPlainText(sReply);
		}
		
		// plainTextEdit_Post.setPlainText(sReply);
		// msgbox("Кнопка запуска набора ... " ~ to!string(cmb_Nabor.currentIndex()));
	}
	// _____________________________________________________________
	// slot - Выход из программы
	void runExit() { 
		app.quit(); 
	}
	// _____________________________________________________________
	// slot - About ... Здесь n - это параметр привязанный к D-шном Актионе (см new QAction(..., 1 или 2);
	void runAbout(int n) { 
		if(n == 1) {
			msgbox(
`<html><head/><body><p><span style=" font-weight:600; color:#aa007f;">
Программа &quot;Подсказчик&quot;.</span></p></body></html><hr>`	~ verQtE56(),
				null, QMessageBox.Icon.Information, this
			);
		}
		if(n == 2) app.aboutQt();	
	}
	// _____________________________________________________________
	// slot - Вызывается на изменение cmbExTema - выбор тем 
	void runCmbTema(int n2, int sg) {
		cmbExPage.clear();
		string s = cmbExTema.text!string;
		// sb.showMessage("cmbExTema = " ~ s, 5000);
		int n;
		foreach(sArticl; objThema.getListArticls(cmbExTema.text!string)) cmbExPage.addItem(sArticl, n++);
		runCmbPage(0, 0);
	}
	// _____________________________________________________________
	// slot - Вызывается на изменение cmbExPage - выбор тем 
	void runCmbPage(int n, int sg) {
		string st = cmbExTema.text!string;
		string ar = cmbExPage.text!string;
	
		string[] s = objThema.getArticl(st, ar);
		if(!objThema.status) {
			textEditPage.setHtml(join(s, "\n"));
		} else {
			sb.showMessage("Error: Чтение статьи ...", 5000);
		}
	}
}
// __________________________________________________________________
// Глобальные переменные программы
QApplication app;
// __________________________________________________________________
// Старт программы
int main(string[] args) {
	// Динамическм гружу QtE56Widgets.dll(so) и если ошибка то выход с 1
	if (1 == LoadQt(dll.QtE6Widgets | dll.QtE6core, false)) return 1;
	// Создаю глобальную переменную приложения
	app = new QApplication(&Runtime.cArgs.argc, Runtime.cArgs.argv, 1);
	QResource qrs = new QResource(); qrs.registerResource(gResource);
	// Перед началом работы разворачиваю файл ресурсов в памяти и активизирую их
	// QResource res = new QResource(); (
	// (new QResource()).registerResource(gResource);
	// Создаю главное окно, сохраняю ссылку на сомо себя и визуализирую
	QtE56Help wn = new QtE56Help(); wn.saveThis(&wn);
	wn.setWindowFlag(QtE.WindowType.WindowMaximizeButtonHint, true);
	wn.show();
	// Обрабатываю поток событий
    return app.exec();
}
__EOF__ ___________________________________________________________ 

