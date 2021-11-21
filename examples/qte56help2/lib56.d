module lib56;

// import std.stdio;

// QString|name|QString%nn|int%nn
// void|name|QString%nn|int%nn2
// void|name|int%nn|QString%nn2

import std.conv;
import std.string: split, strip, replace, join, indexOf;
import asc1251;

enum TypeArg {
	Nan,				// Не знаю, что это
	Pusto,				// ""
	Void,				// void
	Int,				// int
	Bool,				// bool
	Enum,				// Xxx::Yyy
	QString				// QString
}
// __________________________________________________________________
// Детектировать тип аргумента
TypeArg detectTypeArg(string strt) {
	TypeArg rez = TypeArg.Nan;
	if(strt == "") 		 	return  TypeArg.Pusto; 
	if(strt == "int") 	 	return  TypeArg.Int;   
	if(strt == "bool") 	 	return  TypeArg.Bool;  
	if(strt == "void") 	 	return  TypeArg.Void;  
	if(strt == "QString")	return  TypeArg.QString;  
	if( indexOf(strt, "::") > 0 ) return  TypeArg.Enum;  // А может это перечисление?
	return rez;
}
unittest {
	assert(detectTypeArg("int")      == TypeArg.Int);
	assert(detectTypeArg("bool")     == TypeArg.Bool);
	assert(detectTypeArg("void")     == TypeArg.Void);
	assert(detectTypeArg("Xx::Yy")   == TypeArg.Enum);
	assert(detectTypeArg("")         == TypeArg.Pusto);
	assert(detectTypeArg("Qxwer")    == TypeArg.Nan);
	assert(detectTypeArg("QString")  == TypeArg.QString);
}

// __________________________________________________________________
// Берет исходную строку с функцией
// bool	tabsClosable(int index, const QString &tip) const
// bool|tabsClosable|int:index|QString:tip
// Если ? - то ошибка разбора
string parseSourceStr(string astr) {
	string str = strip(astr);
	if(!str.length) return "?";
	str = str.replace("\t", " ").replace("  ", " ").replace("  ", " ").replace("virtual", "").strip();
	str = str.replace(" * ", "* ");

	// 1 - проверяю, что только одна пара скобок
	int kp, kpMax;
	foreach(ch; str) {
		if(ch == '(') { kp++; if(kp > kpMax) kpMax = kp; }
		if(ch == ')') kp--;
	}
	if(kp)           { return "?"; } 	// Скобки не парные
	if(kpMax != 1)   { return "?"; } 	// Не только одна пара скобок

	// 2 - Раскидываю на типВозврата|имяФункции|аргументы
	string typeRet, nameFun, argsFun;
	{
		string[] mas1 = split(str.replace(" &)", " nm"), ')');
		string[] mas2 = split(mas1[0], '(');
		argsFun = mas2[1];
		while(true) {
			auto dl1 = mas2[0].length;
			mas2[0] = mas2[0].replace("  ", " ");
			auto dl2 = mas2[0].length;
			if(dl1 == dl2) break;
		}
		string[] mas3 = split(mas2[0], ' ');
		if(mas3.length == 1) {
			typeRet = ""; nameFun = mas3[0];
		} else {
			typeRet = mas3[0]; nameFun = mas3[1];
		}
	}

	// 3 - Обработка аргументов функции
	string[] masArgsFun;
	{
		string[] mas1 = split(argsFun, ',');
		foreach(arg; mas1) {
			string sArg = strip(arg);
			if(!sArg.length) { masArgsFun ~= ""; continue; }
			// Аргумент не пустой
			sArg = sArg.replace("const", "").replace("&", "").strip();
			string[] mas2 = split(sArg, '=');
			string[] mas3 = split(mas2[0].strip(), " ");
			if(mas3.length == 1) {
				// Тип не понятен и представляет одно слово
				// Возможен тип: int, bool, XXX::YYY
				if(detectTypeArg(mas3[0]) == TypeArg.Int) {
					masArgsFun ~= mas3[0] ~ "%xz";
				} else {
					if(detectTypeArg(mas3[0]) == TypeArg.Bool) {
						masArgsFun ~= mas3[0] ~ "%xz";
					} else {
						// Надо посмотреть, а вдруг перечисление?
						if(detectTypeArg(mas3[0]) == TypeArg.Enum) {
							masArgsFun ~= mas3[0] ~ "%xz";
						} else {
							// Не знаю,что это
							if(detectTypeArg(mas3[0]) == TypeArg.QString)
								masArgsFun ~= mas3[0] ~ "%xz";
							else
								return "?";
						}
					}
				}
			} else {
				masArgsFun ~= mas3[0] ~ "%" ~ mas3[1];
			}
		}
	}
	return typeRet ~ "|" ~ nameFun ~ "|" ~ join(masArgsFun, '|');
}
unittest {
	assert(lib56.parseSourceStr("  ") == "?");
	// Скобки
	assert(lib56.parseSourceStr("bool	tabsClosable int index, const QString &tip) const") == "?");
	assert(lib56.parseSourceStr("bool	tabsClosable((void*)int index, const QString &tip) const") == "?");
	assert(lib56.parseSourceStr("bool	tabsClosable void*int index, const QString &tip const") == "?");

	assert(lib56.parseSourceStr(
			"void	setCornerWidget(QWidget *widget, Qt::Corner corner = Qt::TopRightCorner)")
			==
			"void|setCornerWidget|QWidget%*widget|Qt::Corner%corner"
		);
	assert(lib56.parseSourceStr(
			"void	removeTab(int index)")
			==
			"void|removeTab|int%index"
		);
	assert(lib56.parseSourceStr(
			"	QTabWidget(QWidget *parent = nullptr)")
			==
			"|QTabWidget|QWidget%*parent"
		);
	assert(lib56.parseSourceStr(
			"QTabWidget::TabPosition	tabPosition() const")
			==
			"QTabWidget::TabPosition|tabPosition|"
		);
	assert(lib56.parseSourceStr(
			"virtual bool	event(QEvent *ev) override")
			==
			"bool|event|QEvent%*ev"
		);
	assert(lib56.parseSourceStr(
			"int     addTab(QWidget *page, const QString &label)")
			==
			"int|addTab|QWidget%*page|QString%label"
		);
	assert(lib56.parseSourceStr(
			"QWidget *       cornerWidget(Qt::Corner corner = Qt::TopRightCorner) const")
			==
			"QWidget*|cornerWidget|Qt::Corner%corner"
		);
	assert(lib56.parseSourceStr(
			"void	move(const QPoint &)")
			==
			"void|move|QPoint%nm"
		);
	assert(lib56.parseSourceStr(
			"void	setSizePolicy(QSizePolicy)")
			==
			"?"
		);
	assert(lib56.parseSourceStr(
			"QWidget *       cornerWidget(int myInt, Qt::Corner corner = Qt::TopRightCorner) const")
			==
			"QWidget*|cornerWidget|int%myInt|Qt::Corner%corner"
		);
	assert(lib56.parseSourceStr(
			"void       cornerWidget(int myInt, Qt::Corner corner = Qt::TopRightCorner) const")
			==
			"void|cornerWidget|int%myInt|Qt::Corner%corner"
		);
	assert(lib56.parseSourceStr(
			"bool       cornerWidget(int myInt, Qt::Corner corner = Qt::TopRightCorner) const")
			==
			"bool|cornerWidget|int%myInt|Qt::Corner%corner"
		);
	assert(lib56.parseSourceStr(
			"int       cornerWidget(int myInt, Qt::Corner corner = Qt::TopRightCorner) const")
			==
			"int|cornerWidget|int%myInt|Qt::Corner%corner"
		);
	assert(lib56.parseSourceStr(
			"int       cornerWidget(Qt::Corner corner, int myInt ) const")
			==
			"int|cornerWidget|Qt::Corner%corner|int%myInt"
		);
	assert(lib56.parseSourceStr(
			"int       cornerWidget(Qt::Corner corner, bool myInt ) const")
			==
			"int|cornerWidget|Qt::Corner%corner|bool%myInt"
		);
		
	assert(lib56.parseSourceStr(
			"QString	windowRole() const")
			==
			"QString|windowRole|"
		);
	assert(lib56.parseSourceStr(
			"QString	windowRole(const QString &role) const")
			==
			"QString|windowRole|QString%role"
		);
	assert(lib56.parseSourceStr(
			"QString	windowRole(const QString &) const")
			==
			"QString|windowRole|QString%nm"
		);
		
}

/*

Имеем набор функций ...

void|unsetLocale|
void|update|int%x|int%y|int%w|int%h
void|update|QRect%rect
void|update|QRegion%rgn
void|updateGeometry|
int|x|
int|y|

Будем классифицировать их по наборам.
Номер набора будет определять функция
*/
// __________________________________________________________________
// Набор №1 = На выходе void|int|bool|Xxx::Yyy на входе 1 void|int|bool|Xxx::Yyy
string n1__void_int_bool__1_void_int_bool(string astr) {
	if(strip(astr) == "") return astr;
	string typeRet, nameFun, argsFun1;
	{
		string[] mas1 = split(astr, '|');
		if(mas1.length != 3) return astr;       // Больше одного аргумента
		typeRet = mas1[0];
		if(!typeRet.length) return astr; // Нет возвращаемого значения
		// У функции всего один аргумент ...
		nameFun  = mas1[1];
		if(!isLetters1251E(nameFun[0])) return astr; // Имя функции не определено
		argsFun1 = mas1[2];
	}
	if(argsFun1.length) {
		// Да, есть один аргумент
		string[] mas = split(argsFun1, '%');
		if( !( (detectTypeArg(mas[0]) == TypeArg.Int) || (detectTypeArg(mas[0]) == TypeArg.Bool) )) {
			// Может это Xxx::Yyy
			if( !(detectTypeArg(mas[0]) == TypeArg.Enum) ) {
				return astr; // Это что то непонятное
			}
		}
	}
	if(!((  detectTypeArg(typeRet) == TypeArg.Int) 
		|| (detectTypeArg(typeRet) == TypeArg.Bool) 
		|| (detectTypeArg(typeRet) == TypeArg.Void)
		|| (detectTypeArg(typeRet) == TypeArg.Enum)
		)) {
		return astr; // Возвращаемый тип не подходит
	}
	// Если дошла до сюда, значит эта стока попадает под набор set1
	return "1~" ~ astr;
}

unittest {
	assert(lib56.n1__void_int_bool__1_void_int_bool("int|x|") == "1~int|x|");
	assert(lib56.n1__void_int_bool__1_void_int_bool("bool|x|") == "1~bool|x|");
	assert(lib56.n1__void_int_bool__1_void_int_bool("void|x|") == "1~void|x|");
	assert(lib56.n1__void_int_bool__1_void_int_bool("Xxx::Yyy|x|") == "1~Xxx::Yyy|x|");

	assert(lib56.n1__void_int_bool__1_void_int_bool("int|x|int%a") == "1~int|x|int%a");
	assert(lib56.n1__void_int_bool__1_void_int_bool("bool|x|int%a") == "1~bool|x|int%a");
	assert(lib56.n1__void_int_bool__1_void_int_bool("void|x|int%a") == "1~void|x|int%a");
	assert(lib56.n1__void_int_bool__1_void_int_bool("int|x|Xx::Yy%a") == "1~int|x|Xx::Yy%a");

	assert(lib56.n1__void_int_bool__1_void_int_bool("int|x|bool%a") == "1~int|x|bool%a");
	assert(lib56.n1__void_int_bool__1_void_int_bool("bool|x|bool%a") == "1~bool|x|bool%a");
	assert(lib56.n1__void_int_bool__1_void_int_bool("void|x|bool%a") == "1~void|x|bool%a");
	assert(lib56.n1__void_int_bool__1_void_int_bool("void|x|Xx::Yy%a") == "1~void|x|Xx::Yy%a");

	assert(lib56.n1__void_int_bool__1_void_int_bool("int|x|bool%a|bool%b") == "int|x|bool%a|bool%b");
	assert(lib56.n1__void_int_bool__1_void_int_bool("bool|x|bool%a|bool%b") == "bool|x|bool%a|bool%b");
	assert(lib56.n1__void_int_bool__1_void_int_bool("void|x|bool%a|bool%b") == "void|x|bool%a|bool%b");
	assert(lib56.n1__void_int_bool__1_void_int_bool("bool|x|Xx::Yy%a") == "1~bool|x|Xx::Yy%a");
	
	assert(lib56.n1__void_int_bool__1_void_int_bool("Xxx::Yyy|x|Xx::Yy%a") == "1~Xxx::Yyy|x|Xx::Yy%a");

	assert(lib56.n1__void_int_bool__1_void_int_bool("QString|x|bool%a") == "QString|x|bool%a");
	assert(lib56.n1__void_int_bool__1_void_int_bool("int|x|QString%a") == "int|x|QString%a");
	
	assert(lib56.n1__void_int_bool__1_void_int_bool("int|x|int%a|int%b")  == "int|x|int%a|int%b");
	assert(lib56.n1__void_int_bool__1_void_int_bool("bool|x|int%a|int%b") == "bool|x|int%a|int%b");
	assert(lib56.n1__void_int_bool__1_void_int_bool("void|x|int%a|int%b") == "void|x|int%a|int%b");
	assert(lib56.n1__void_int_bool__1_void_int_bool("void|x|int%a|int%b") == "void|x|int%a|int%b");
	assert(lib56.n1__void_int_bool__1_void_int_bool("void|setWindowFlag|Qt::WindowType%flag|bool%on") == "void|setWindowFlag|Qt::WindowType%flag|bool%on");
	assert(lib56.n1__void_int_bool__1_void_int_bool("int|setBaseSize|int%basew|int%baseh") == "int|setBaseSize|int%basew|int%baseh");
	
	
}

// __________________________________________________________________
// Набор №2 = На выходе int|bool|Xxx::Yyy,int|bool|Xxx::Yyy  на входе 2 int|cornerWidget|Qt::Corner%corner|int%myInt
string n2__void_int_bool__2_int_bool_enum(string astr) {
	if(strip(astr) == "") return astr;
	string typeRet, nameFun, argsFun1, argsFun2;
	{
		string[] mas1 = split(astr, '|');
		if(mas1.length != 4) return astr;       // Больше одного аргумента
		typeRet = mas1[0];
		if(!typeRet.length) return astr; // Нет возвращаемого значения
		// У функции всего один аргумент ...
		nameFun  = mas1[1];
		if(!isLetters1251E(nameFun[0])) return astr; // Имя функции не определено
		argsFun1 = mas1[2];
		argsFun2 = mas1[3];
	}
	if(argsFun1.length && argsFun2.length) {
		// Да, есть два аргумента
		string[] mas1 = split(argsFun1, '%');
		if( !( (detectTypeArg(mas1[0]) == TypeArg.Int) || (detectTypeArg(mas1[0]) == TypeArg.Bool) )) {
			// Может это Xxx::Yyy
			if( !(detectTypeArg(mas1[0]) == TypeArg.Enum) ) {
				return astr; // Это что то непонятное
			}
		}
		string[] mas2 = split(argsFun2, '%');
		if( !( (detectTypeArg(mas2[0]) == TypeArg.Int) || (detectTypeArg(mas2[0]) == TypeArg.Bool) )) {
			// Может это Xxx::Yyy
			if( !(detectTypeArg(mas2[0]) == TypeArg.Enum) ) {
				return astr; // Это что то непонятное
			}
		}
	}
	if(!((  detectTypeArg(typeRet) == TypeArg.Int) 
		|| (detectTypeArg(typeRet) == TypeArg.Bool) 
		|| (detectTypeArg(typeRet) == TypeArg.Void)
		|| (detectTypeArg(typeRet) == TypeArg.Enum)
		)) {
		return astr; // Возвращаемый тип не подходит
	}
	// Если дошла до сюда, значит эта стока попадает под набор set1
	return "2~" ~ astr;
}
unittest {
	assert(lib56.n2__void_int_bool__2_int_bool_enum("int|x|int%a|int%b")  == "2~int|x|int%a|int%b");
	assert(lib56.n2__void_int_bool__2_int_bool_enum("bool|x|int%a|int%b") == "2~bool|x|int%a|int%b");
	assert(lib56.n2__void_int_bool__2_int_bool_enum("void|x|int%a|int%b") == "2~void|x|int%a|int%b");
	assert(lib56.n2__void_int_bool__2_int_bool_enum("void|x|int%a|int%b") == "2~void|x|int%a|int%b");
	assert(lib56.n2__void_int_bool__2_int_bool_enum("void|setWindowFlag|Qt::WindowType%flag|bool%on") == "2~void|setWindowFlag|Qt::WindowType%flag|bool%on");
	assert(lib56.n2__void_int_bool__2_int_bool_enum("int|setBaseSize|int%basew|int%baseh") == "2~int|setBaseSize|int%basew|int%baseh");
	
	assert(lib56.n2__void_int_bool__2_int_bool_enum("int|x|")              == "int|x|");
	assert(lib56.n2__void_int_bool__2_int_bool_enum("bool|x|")             == "bool|x|");
	assert(lib56.n2__void_int_bool__2_int_bool_enum("void|x|")             == "void|x|");
	assert(lib56.n2__void_int_bool__2_int_bool_enum("Xxx::Yyy|x|")         == "Xxx::Yyy|x|");
	assert(lib56.n2__void_int_bool__2_int_bool_enum("int|x|int%a")         == "int|x|int%a");
	assert(lib56.n2__void_int_bool__2_int_bool_enum("bool|x|int%a")        == "bool|x|int%a");
	assert(lib56.n2__void_int_bool__2_int_bool_enum("void|x|int%a")        == "void|x|int%a");
	assert(lib56.n2__void_int_bool__2_int_bool_enum("int|x|Xx::Yy%a")      == "int|x|Xx::Yy%a");
	assert(lib56.n2__void_int_bool__2_int_bool_enum("int|x|bool%a")        == "int|x|bool%a");
	assert(lib56.n2__void_int_bool__2_int_bool_enum("bool|x|bool%a")       == "bool|x|bool%a");
	assert(lib56.n2__void_int_bool__2_int_bool_enum("void|x|bool%a")       == "void|x|bool%a");
	assert(lib56.n2__void_int_bool__2_int_bool_enum("void|x|Xx::Yy%a")     == "void|x|Xx::Yy%a");
	
	assert(lib56.n2__void_int_bool__2_int_bool_enum("bool|x|Xx::Yy%a")     == "bool|x|Xx::Yy%a");
	assert(lib56.n2__void_int_bool__2_int_bool_enum("Xxx::Yyy|x|Xx::Yy%a") == "Xxx::Yyy|x|Xx::Yy%a");
	assert(lib56.n2__void_int_bool__2_int_bool_enum("QString|x|bool%a")    == "QString|x|bool%a");
	assert(lib56.n2__void_int_bool__2_int_bool_enum("int|x|QString%a")     == "int|x|QString%a");
	
}



/*

Имеем список строк на входе ...

1~void|unsetLocale|
void|update|int%x|int%y|int%w|int%h
void|update|QRect%rect
void|update|QRegion%rgn
1~void|updateGeometry|
1~int|x|
1~int|y|

Найти все строки попадающие на 1 набор
*/

import std.stdio;



// __________________________________________________________________
// Генерирует строку в CASE функции на C++ На входе: int|x| --> rez = wd->x();
string genExecCppFun(string rawFun) {
	string rez;
	string typeRet, nameFun, argsFun1;
	string[] mas1 = split(rawFun, '|');
	typeRet = mas1[0]; nameFun = mas1[1]; argsFun1 = mas1[2];

	if(detectTypeArg(typeRet) == TypeArg.Int) {
		if(argsFun1 == "") {
			rez = "rez = wd->" ~ nameFun ~ "();";
		} else {
			string[] masArg = split(argsFun1, '%');
			switch(detectTypeArg(masArg[0]))
			{
				case TypeArg.Int:
					rez = "rez = wd->" ~ nameFun ~ "(arg);";
					break;
				case TypeArg.Bool:
					rez = "rez = wd->" ~ nameFun ~ "((bool)arg);";
					break;
				case TypeArg.Enum:
					rez = "rez = wd->" ~ nameFun ~ "((" ~ masArg[0] ~ ")arg);";
					break;
				default:
					rez = "";
					break;
			}
		}
	}
	if(detectTypeArg(typeRet) == TypeArg.Bool) {
		if(argsFun1 == "") {
			rez = "rez = (int)wd->" ~ nameFun ~ "();";
		} else {
			string[] masArg = split(argsFun1, '%');
			switch(detectTypeArg(masArg[0]))
			{
				case TypeArg.Int:
					rez = "rez = (int)wd->" ~ nameFun ~ "(arg);";
					break;
				case TypeArg.Bool:
					rez = "rez = (int)wd->" ~ nameFun ~ "((bool)arg);";
					break;
				case TypeArg.Enum:
					rez = "rez = (int)wd->" ~ nameFun ~ "((" ~ masArg[0] ~ ")arg);";
					break;
				default:
					rez = "";
					break;
			}
		}
	}
	if(detectTypeArg(typeRet) == TypeArg.Void) {
		if(argsFun1 == "") {
			rez = "wd->" ~ nameFun ~ "();";
		} else {
			string[] masArg = split(argsFun1, '%');
			switch(detectTypeArg(masArg[0]))
			{
				case TypeArg.Int:
					rez = "wd->" ~ nameFun ~ "(arg);";
					break;
				case TypeArg.Bool:
					rez = "wd->" ~ nameFun ~ "((bool)arg);";
					break;
				case TypeArg.Enum:
					rez = "wd->" ~ nameFun ~ "((" ~ masArg[0] ~ ")arg);";
					break;
				default:
					rez = "";
					break;
			}
		}
	}
	if(detectTypeArg(typeRet) == TypeArg.Enum) {
		if(argsFun1 == "") {
			rez = "rez = (int)wd->" ~ nameFun ~ "();";
		} else {
			string[] masArg = split(argsFun1, '%');
			switch(detectTypeArg(masArg[0]))
			{
				case TypeArg.Int:
					rez = "rez = (int)wd->" ~ nameFun ~ "(arg);";
					break;
				case TypeArg.Bool:
					rez = "rez = (int)wd->" ~ nameFun ~ "((bool)arg);";
					break;
				case TypeArg.Enum:
					rez = "rez = (int)wd->" ~ nameFun ~ "((" ~ masArg[0] ~ ")arg);";
					break;
				default:
					rez = "";
					break;
			}
		}
	}
	return rez;
}

unittest {
	// Эта функция не предпологает неверного входного параметра
	assert(genExecCppFun("int|x|")              == "rez = wd->x();"            );
	assert(genExecCppFun("int|x|int%nom")       == "rez = wd->x(arg);"         );
	assert(genExecCppFun("int|x|bool%nom")      == "rez = wd->x((bool)arg);"   );
	assert(genExecCppFun("int|x|Xx::Yy%nom")    == "rez = wd->x((Xx::Yy)arg);" );
	
	assert(genExecCppFun("bool|x|")             == "rez = (int)wd->x();"              );
	assert(genExecCppFun("bool|x|int%nom")      == "rez = (int)wd->x(arg);"           );
	assert(genExecCppFun("bool|x|bool%nom")     == "rez = (int)wd->x((bool)arg);"     );
	assert(genExecCppFun("bool|x|Xx::Yy%nom")   == "rez = (int)wd->x((Xx::Yy)arg);"   );

	assert(genExecCppFun("void|x|")             == "wd->x();"              );
	assert(genExecCppFun("void|x|int%nom")      == "wd->x(arg);"           );
	assert(genExecCppFun("void|x|bool%nom")     == "wd->x((bool)arg);"     );

	assert(genExecCppFun("void|x|Xx::Yy%nom")   == "wd->x((Xx::Yy)arg);"   );
	assert(genExecCppFun("Xx::Yy|x|Xx::Yy%nom") == "rez = (int)wd->x((Xx::Yy)arg);" );
}

// __________________________________________________________________
// Генерирует строку в CASE функции на C++ для второго набора
string genExecCppFun2(string rawFun) {
	//return "---ФункцияИз_№2---";
	
	string rez;
	string typeRet, nameFun, argsFun1, argsFun2;
	string[] mas1 = split(rawFun, '|');
	typeRet = mas1[0]; nameFun = mas1[1]; argsFun1 = mas1[2]; argsFun2 = mas1[3];

	if(detectTypeArg(typeRet) == TypeArg.Int) {
		string[] masArg1 = split(argsFun1, '%');
		string[] masArg2 = split(argsFun2, '%');
		switch(detectTypeArg(masArg1[0]))
		{
			case TypeArg.Int:
				switch(detectTypeArg(masArg2[0]))
				{
					case TypeArg.Int:
						rez = "rez = wd->" ~ nameFun ~ "(arg1, arg2);";
						break;
					case TypeArg.Bool:
						rez = "rez = wd->" ~ nameFun ~ "(arg1, (bool)arg2);";
						break;
					case TypeArg.Enum:
						rez = "rez = wd->" ~ nameFun ~ "(arg1, (" ~ masArg2[0] ~ ")arg2);";
						break;
					default:
						rez = "";
						break;
				}
				break;
			case TypeArg.Bool:
				switch(detectTypeArg(masArg2[0]))
				{
					case TypeArg.Int:
						rez = "rez = wd->" ~ nameFun ~ "((bool)arg1, arg2);";
						break;
					case TypeArg.Bool:
						rez = "rez = wd->" ~ nameFun ~ "((bool)arg1, (bool)arg2);";
						break;
					case TypeArg.Enum:
						rez = "rez = wd->" ~ nameFun ~ "((bool)arg1, (" ~ masArg2[0] ~ ")arg2);";
						break;
					default:
						rez = "";
						break;
				}
				break;
			case TypeArg.Enum:
				switch(detectTypeArg(masArg2[0]))
				{
					case TypeArg.Int:
						rez = "rez = wd->" ~ nameFun ~ "((" ~ masArg1[0] ~ ")arg1, arg2);";
						break;
					case TypeArg.Bool:
						rez = "rez = wd->" ~ nameFun ~ "((" ~ masArg1[0] ~ ")arg1, (bool)arg2);";
						break;
					case TypeArg.Enum:
						rez = "rez = wd->" ~ nameFun ~ "((" ~ masArg1[0] ~ ")arg1, (" ~ masArg2[0] ~ ")arg2);";
						break;
					default:
						rez = "";
						break;
				}
				break;
			default:
				rez = "";
				break;
		}
	}
	if(detectTypeArg(typeRet) == TypeArg.Bool) {
		string[] masArg1 = split(argsFun1, '%');
		string[] masArg2 = split(argsFun2, '%');
		switch(detectTypeArg(masArg1[0]))
		{
			case TypeArg.Int:
				switch(detectTypeArg(masArg2[0]))
				{
					case TypeArg.Int:
						rez = "rez = (int)wd->" ~ nameFun ~ "(arg1, arg2);";
						break;
					case TypeArg.Bool:
						rez = "rez = (int)wd->" ~ nameFun ~ "(arg1, (bool)arg2);";
						break;
					case TypeArg.Enum:
						rez = "rez = (int)wd->" ~ nameFun ~ "(arg1, (" ~ masArg2[0] ~ ")arg2);";
						break;
					default:
						rez = "";
						break;
				}
				break;
			case TypeArg.Bool:
				switch(detectTypeArg(masArg2[0]))
				{
					case TypeArg.Int:
						rez = "rez = (int)wd->" ~ nameFun ~ "((bool)arg1, arg2);";
						break;
					case TypeArg.Bool:
						rez = "rez = (int)wd->" ~ nameFun ~ "((bool)arg1, (bool)arg2);";
						break;
					case TypeArg.Enum:
						rez = "rez = (int)wd->" ~ nameFun ~ "((bool)arg1, (" ~ masArg2[0] ~ ")arg2);";
						break;
					default:
						rez = "";
						break;
				}
				break;
			case TypeArg.Enum:
				switch(detectTypeArg(masArg2[0]))
				{
					case TypeArg.Int:
						rez = "rez = (int)wd->" ~ nameFun ~ "((" ~ masArg1[0] ~ ")arg1, arg2);";
						break;
					case TypeArg.Bool:
						rez = "rez = (int)wd->" ~ nameFun ~ "((" ~ masArg1[0] ~ ")arg1, (bool)arg2);";
						break;
					case TypeArg.Enum:
						rez = "rez = (int)wd->" ~ nameFun ~ "((" ~ masArg1[0] ~ ")arg1, (" ~ masArg2[0] ~ ")arg2);";
						break;
					default:
						rez = "";
						break;
				}
				break;
			default:
				rez = "";
				break;
		}
	}
	if(detectTypeArg(typeRet) == TypeArg.Void) {
		string[] masArg1 = split(argsFun1, '%');
		string[] masArg2 = split(argsFun2, '%');
		switch(detectTypeArg(masArg1[0]))
		{
			case TypeArg.Int:
				switch(detectTypeArg(masArg2[0]))
				{
					case TypeArg.Int:
						rez = "wd->" ~ nameFun ~ "(arg1, arg2);";
						break;
					case TypeArg.Bool:
						rez = "wd->" ~ nameFun ~ "(arg1, (bool)arg2);";
						break;
					case TypeArg.Enum:
						rez = "wd->" ~ nameFun ~ "(arg1, (" ~ masArg2[0] ~ ")arg2);";
						break;
					default:
						rez = "";
						break;
				}
				break;
			case TypeArg.Bool:
				switch(detectTypeArg(masArg2[0]))
				{
					case TypeArg.Int:
						rez = "wd->" ~ nameFun ~ "((bool)arg1, arg2);";
						break;
					case TypeArg.Bool:
						rez = "wd->" ~ nameFun ~ "((bool)arg1, (bool)arg2);";
						break;
					case TypeArg.Enum:
						rez = "wd->" ~ nameFun ~ "((bool)arg1, (" ~ masArg2[0] ~ ")arg2);";
						break;
					default:
						rez = "";
						break;
				}
				break;
			case TypeArg.Enum:
				switch(detectTypeArg(masArg2[0]))
				{
					case TypeArg.Int:
						rez = "wd->" ~ nameFun ~ "((" ~ masArg1[0] ~ ")arg1, arg2);";
						break;
					case TypeArg.Bool:
						rez = "wd->" ~ nameFun ~ "((" ~ masArg1[0] ~ ")arg1, (bool)arg2);";
						break;
					case TypeArg.Enum:
						rez = "wd->" ~ nameFun ~ "((" ~ masArg1[0] ~ ")arg1, (" ~ masArg2[0] ~ ")arg2);";
						break;
					default:
						rez = "";
						break;
				}
				break;
			default:
				rez = "";
				break;
		}
	}
	if(detectTypeArg(typeRet) == TypeArg.Enum) {
		string[] masArg1 = split(argsFun1, '%');
		string[] masArg2 = split(argsFun2, '%');
		switch(detectTypeArg(masArg1[0]))
		{
			case TypeArg.Int:
				switch(detectTypeArg(masArg2[0]))
				{
					case TypeArg.Int:
						rez = "rez = (int)wd->" ~ nameFun ~ "(arg1, arg2);";
						break;
					case TypeArg.Bool:
						rez = "rez = (int)wd->" ~ nameFun ~ "(arg1, (bool)arg2);";
						break;
					case TypeArg.Enum:
						rez = "rez = (int)wd->" ~ nameFun ~ "(arg1, (" ~ masArg2[0] ~ ")arg2);";
						break;
					default:
						rez = "";
						break;
				}
				break;
			case TypeArg.Bool:
				switch(detectTypeArg(masArg2[0]))
				{
					case TypeArg.Int:
						rez = "rez = (int)wd->" ~ nameFun ~ "((bool)arg1, arg2);";
						break;
					case TypeArg.Bool:
						rez = "rez = (int)wd->" ~ nameFun ~ "((bool)arg1, (bool)arg2);";
						break;
					case TypeArg.Enum:
						rez = "rez = (int)wd->" ~ nameFun ~ "((bool)arg1, (" ~ masArg2[0] ~ ")arg2);";
						break;
					default:
						rez = "";
						break;
				}
				break;
			case TypeArg.Enum:
				switch(detectTypeArg(masArg2[0]))
				{
					case TypeArg.Int:
						rez = "rez = (int)wd->" ~ nameFun ~ "((" ~ masArg1[0] ~ ")arg1, arg2);";
						break;
					case TypeArg.Bool:
						rez = "rez = (int)wd->" ~ nameFun ~ "((" ~ masArg1[0] ~ ")arg1, (bool)arg2);";
						break;
					case TypeArg.Enum:
						rez = "rez = (int)wd->" ~ nameFun ~ "((" ~ masArg1[0] ~ ")arg1, (" ~ masArg2[0] ~ ")arg2);";
						break;
					default:
						rez = "";
						break;
				}
				break;
			default:
				rez = "";
				break;
		}
	}
	return rez;
}
unittest {
	// Эта функция не предпологает неверного входного параметра
	assert(genExecCppFun2("int|contains|int%x|int%y")             == "rez = wd->contains(arg1, arg2);");
	assert(genExecCppFun2("int|contains|int%x|bool%y")            == "rez = wd->contains(arg1, (bool)arg2);");
	assert(genExecCppFun2("int|contains|int%x|Qw::Zx%y")          == "rez = wd->contains(arg1, (Qw::Zx)arg2);");
	assert(genExecCppFun2("bool|contains|int%x|int%y")            == "rez = (int)wd->contains(arg1, arg2);");
	assert(genExecCppFun2("bool|contains|int%x|bool%y")           == "rez = (int)wd->contains(arg1, (bool)arg2);");
	assert(genExecCppFun2("bool|contains|int%x|Qw::Zx%y")         == "rez = (int)wd->contains(arg1, (Qw::Zx)arg2);");
	assert(genExecCppFun2("void|contains|int%x|int%y")            == "wd->contains(arg1, arg2);");
	assert(genExecCppFun2("void|contains|int%x|bool%y")           == "wd->contains(arg1, (bool)arg2);");
	assert(genExecCppFun2("void|contains|int%x|Qw::Zx%y")         == "wd->contains(arg1, (Qw::Zx)arg2);");
	assert(genExecCppFun2("Nn::Nn|contains|int%x|int%y")          == "rez = (int)wd->contains(arg1, arg2);");
	assert(genExecCppFun2("Nn::Nn|contains|int%x|bool%y")         == "rez = (int)wd->contains(arg1, (bool)arg2);");
	assert(genExecCppFun2("Nn::Nn|contains|int%x|Qw::Zx%y")       == "rez = (int)wd->contains(arg1, (Qw::Zx)arg2);");
	assert(genExecCppFun2("int|contains|bool%x|int%y")            == "rez = wd->contains((bool)arg1, arg2);");
	assert(genExecCppFun2("int|contains|bool%x|bool%y")           == "rez = wd->contains((bool)arg1, (bool)arg2);");
	assert(genExecCppFun2("int|contains|bool%x|Qw::Zx%y")         == "rez = wd->contains((bool)arg1, (Qw::Zx)arg2);");
	assert(genExecCppFun2("bool|contains|bool%x|int%y")           == "rez = (int)wd->contains((bool)arg1, arg2);");
	assert(genExecCppFun2("bool|contains|bool%x|bool%y")          == "rez = (int)wd->contains((bool)arg1, (bool)arg2);");
	assert(genExecCppFun2("bool|contains|bool%x|Qw::Zx%y")        == "rez = (int)wd->contains((bool)arg1, (Qw::Zx)arg2);");
	assert(genExecCppFun2("void|contains|bool%x|int%y")           == "wd->contains((bool)arg1, arg2);");
	assert(genExecCppFun2("void|contains|bool%x|bool%y")          == "wd->contains((bool)arg1, (bool)arg2);");
	assert(genExecCppFun2("void|contains|bool%x|Qw::Zx%y")        == "wd->contains((bool)arg1, (Qw::Zx)arg2);");
	assert(genExecCppFun2("Nn::Nn|contains|bool%x|int%y")         == "rez = (int)wd->contains((bool)arg1, arg2);");
	assert(genExecCppFun2("Nn::Nn|contains|bool%x|bool%y")        == "rez = (int)wd->contains((bool)arg1, (bool)arg2);");
	assert(genExecCppFun2("Nn::Nn|contains|bool%x|Qw::Zx%y")      == "rez = (int)wd->contains((bool)arg1, (Qw::Zx)arg2);");
	assert(genExecCppFun2("int|contains|Qw1::Zx1%x|int%y")        == "rez = wd->contains((Qw1::Zx1)arg1, arg2);");
	assert(genExecCppFun2("int|contains|Qw1::Zx1%x|bool%y")       == "rez = wd->contains((Qw1::Zx1)arg1, (bool)arg2);");
	assert(genExecCppFun2("int|contains|Qw1::Zx1%x|Qw::Zx%y")     == "rez = wd->contains((Qw1::Zx1)arg1, (Qw::Zx)arg2);");
	assert(genExecCppFun2("bool|contains|Qw1::Zx1%x|int%y")       == "rez = (int)wd->contains((Qw1::Zx1)arg1, arg2);");
	assert(genExecCppFun2("bool|contains|Qw1::Zx1%x|bool%y")      == "rez = (int)wd->contains((Qw1::Zx1)arg1, (bool)arg2);");
	assert(genExecCppFun2("bool|contains|Qw1::Zx1%x|Qw::Zx%y")    == "rez = (int)wd->contains((Qw1::Zx1)arg1, (Qw::Zx)arg2);");
	assert(genExecCppFun2("void|contains|Qw1::Zx1%x|int%y")       == "wd->contains((Qw1::Zx1)arg1, arg2);");
	assert(genExecCppFun2("void|contains|Qw1::Zx1%x|bool%y")      == "wd->contains((Qw1::Zx1)arg1, (bool)arg2);");
	assert(genExecCppFun2("void|contains|Qw1::Zx1%x|Qw::Zx%y")    == "wd->contains((Qw1::Zx1)arg1, (Qw::Zx)arg2);");
	assert(genExecCppFun2("Nn::Nn|contains|Qw1::Zx1%x|int%y")     == "rez = (int)wd->contains((Qw1::Zx1)arg1, arg2);");
	assert(genExecCppFun2("Nn::Nn|contains|Qw1::Zx1%x|bool%y")    == "rez = (int)wd->contains((Qw1::Zx1)arg1, (bool)arg2);");
	assert(genExecCppFun2("Nn::Nn|contains|Qw1::Zx1%x|Qw::Zx%y")  == "rez = (int)wd->contains((Qw1::Zx1)arg1, (Qw::Zx)arg2);");
}

// __________________________________________________________________
// Генерирует функцию D ...
string[] genFunDlang(string rawFun, int nomFunQtE, int nppLine, string nameClassCpp) {
	// writeln( `genFunDlang("`, rawFun, `", `,  nomFunQtE, `, `, nppLine, `, "`, nameClassCpp, `"`);
	string[] rez;
	string typeRet, nameFun, argsFun1;
	string[] mas1 = split(rawFun, '|');
	typeRet = mas1[0]; nameFun = mas1[1]; argsFun1 = mas1[2];
	string[string] dict;

	// Шаблон для генерации функции на Dlang
	string shDlang1 =
`
zgl|// _________________________ [[NPP_LINE]] -- [[RAW_FUN]]
rbu|@property [[TYPE_RET]] [[NAME_FUN]]([[TYPE_ARG1]] [[NAME_ARG1]]) {
vbu|@property [[TYPE_RET]] [[NAME_FUN]]() {
rbc|[[NAME_CLASS]] [[NAME_FUN]]([[TYPE_ARG1]] [[NAME_ARG1]]) {
vbc|[[NAME_CLASS]] [[NAME_FUN]]() {
llv|    (cast(t_i__qp_i_i) pFunQt[ [[NOM_FUN]] ])(QtObj, 0, [[NPP_LINE]]);
llx|    (cast(t_i__qp_i_i) pFunQt[ [[NOM_FUN]] ])(QtObj, [[NAME_ARG1]], [[NPP_LINE]]);
lly|    (cast(t_i__qp_i_i) pFunQt[ [[NOM_FUN]] ])(QtObj, cast(int)[[NAME_ARG1]], [[NPP_LINE]]);
li0|    return (cast(t_i__qp_i_i) pFunQt[ [[NOM_FUN]] ])(QtObj, 0, [[NPP_LINE]]);
lii|    return (cast(t_i__qp_i_i) pFunQt[ [[NOM_FUN]] ])(QtObj, [[NAME_ARG1]], [[NPP_LINE]]);
lib|    return (cast(t_i__qp_i_i) pFunQt[ [[NOM_FUN]] ])(QtObj, cast(int)[[NAME_ARG1]], [[NPP_LINE]]);
ll0|    return cast(bool)(cast(t_i__qp_i_i) pFunQt[ [[NOM_FUN]] ])(QtObj, 0, [[NPP_LINE]]);
lli|    return cast(bool)(cast(t_i__qp_i_i) pFunQt[ [[NOM_FUN]] ])(QtObj, [[NAME_ARG1]], [[NPP_LINE]]);
llb|    return cast(bool)(cast(t_i__qp_i_i) pFunQt[ [[NOM_FUN]] ])(QtObj, cast(int)[[NAME_ARG1]], [[NPP_LINE]]);

le0|    return cast([[TYPE_RET]])(cast(t_i__qp_i_i) pFunQt[ [[NOM_FUN]] ])(QtObj, 0, [[NPP_LINE]]);
lei|    return cast([[TYPE_RET]])(cast(t_i__qp_i_i) pFunQt[ [[NOM_FUN]] ])(QtObj, [[NAME_ARG1]], [[NPP_LINE]]);
leb|    return cast([[TYPE_RET]])(cast(t_i__qp_i_i) pFunQt[ [[NOM_FUN]] ])(QtObj, cast(int)[[NAME_ARG1]], [[NPP_LINE]]);


ret|    return this;
zsk|}
`;

	dict["RAW_FUN"]  = rawFun;
	dict["NPP_LINE"] = to!string(nppLine);
	dict["NAME_FUN"] = nameFun;
	dict["NAME_CLASS"] = nameClassCpp;
	dict["TYPE_RET"] = typeRet;
	dict["NOM_FUN"] = to!string(nomFunQtE);

	rez ~= sh1c(shDlang1, "zgl", dict);
	if(detectTypeArg(typeRet) == TypeArg.Int) {
		if(argsFun1 == "") {
			rez ~= sh1c(shDlang1, "vbu", dict);
			rez ~= sh1c(shDlang1, "li0", dict);
		} else {
			string[] masArg = split(argsFun1, '%');
			dict["TYPE_ARG1"] = masArg[0];
			dict["NAME_ARG1"] = masArg[1];
			rez ~= sh1c(shDlang1, "rbu", dict);
			if(detectTypeArg(masArg[0]) == TypeArg.Int) {
				rez ~= sh1c(shDlang1, "lii", dict);
			}
			if(detectTypeArg(masArg[0]) == TypeArg.Bool) {
				rez ~= sh1c(shDlang1, "lib", dict);
			}
			if(detectTypeArg(masArg[0]) == TypeArg.Enum) {
				rez ~= sh1c(shDlang1, "lib", dict);
			}
		}
	}
	if(detectTypeArg(typeRet) == TypeArg.Bool) {
		if(argsFun1 == "") {
			rez ~= sh1c(shDlang1, "vbu", dict);
			rez ~= sh1c(shDlang1, "ll0", dict);
		} else {
			string[] masArg = split(argsFun1, '%');
			dict["TYPE_ARG1"] = masArg[0];
			dict["NAME_ARG1"] = masArg[1];
			rez ~= sh1c(shDlang1, "rbu", dict);
			if(detectTypeArg(masArg[0]) == TypeArg.Int) {
				rez ~= sh1c(shDlang1, "lli", dict);
			}
			if(detectTypeArg(masArg[0]) == TypeArg.Bool) {
				rez ~= sh1c(shDlang1, "llb", dict);
			}
			if(detectTypeArg(masArg[0]) == TypeArg.Enum) {
				rez ~= sh1c(shDlang1, "llb", dict);
			}
		}
	}
	if(detectTypeArg(typeRet) == TypeArg.Void) {
		if(argsFun1 == "") {
			rez ~= sh1c(shDlang1, "vbc", dict);
			rez ~= sh1c(shDlang1, "llv", dict);
			rez ~= sh1c(shDlang1, "ret", dict);
		} else {
			string[] masArg = split(argsFun1, '%');
			dict["TYPE_ARG1"] = masArg[0];
			dict["NAME_ARG1"] = masArg[1];
			rez ~= sh1c(shDlang1, "rbc", dict);
			if(detectTypeArg(masArg[0]) == TypeArg.Int) {
				rez ~= sh1c(shDlang1, "llx", dict);
			}
			if(detectTypeArg(masArg[0]) == TypeArg.Bool) {
				rez ~= sh1c(shDlang1, "lly", dict);
			}
			if(detectTypeArg(masArg[0]) == TypeArg.Enum) {
				rez ~= sh1c(shDlang1, "lly", dict);
			}
			rez ~= sh1c(shDlang1, "ret", dict);
			rez ~= sh1c(shDlang1, "z3", dict);
		}
	}
	if(detectTypeArg(typeRet) == TypeArg.Enum) {
		if(argsFun1 == "") {
			rez ~= sh1c(shDlang1, "vbu", dict);
			rez ~= sh1c(shDlang1, "le0", dict);
		} else {
			string[] masArg = split(argsFun1, '%');
			dict["TYPE_ARG1"] = masArg[0];
			dict["NAME_ARG1"] = masArg[1];
			rez ~= sh1c(shDlang1, "rbu", dict);
			if(detectTypeArg(masArg[0]) == TypeArg.Int) {
				rez ~= sh1c(shDlang1, "lei", dict);
			}
			if(detectTypeArg(masArg[0]) == TypeArg.Bool) {
				rez ~= sh1c(shDlang1, "leb", dict);
			}
			if(detectTypeArg(masArg[0]) == TypeArg.Enum) {
				rez ~= sh1c(shDlang1, "leb", dict);
			}
		}
	}
	rez ~= sh1c(shDlang1, "zsk", dict);
	// writeln(rez[2]);
	string[] rezOk;
	foreach(line; rez) {
		if(line.strip() == "") continue;
		rezOk ~= line;
	}
	return rezOk;
}
unittest {
	assert((genFunDlang("int|nameFun|int%arg", 45, 1, "QLabel"))[2].strip()
	== "return (cast(t_i__qp_i_i) pFunQt[ 45 ])(QtObj, arg, 1);"
	);
	assert((genFunDlang("int|nameFun|bool%arg", 45, 1, "QLabel"))[2].strip()
	== "return (cast(t_i__qp_i_i) pFunQt[ 45 ])(QtObj, cast(int)arg, 1);"
	);
	assert((genFunDlang("int|nameFun|Qz::Qz%arg", 45, 1, "QLabel"))[2].strip()
	== "return (cast(t_i__qp_i_i) pFunQt[ 45 ])(QtObj, cast(int)arg, 1);"
	);
}
// __________________________________________________________________
// Генерирует функцию D ...
string[] genFunDlang2(string rawFun, int nomFunQtE, int nppLine, string nameClassCpp) {
	string[] rez;
	string typeRet, nameFun, argsFun1, argsFun2;
	string[] mas1 = split(rawFun, '|');
	typeRet = mas1[0]; nameFun = mas1[1]; argsFun1 = mas1[2]; argsFun2 = mas1[3];
	string[string] dict;

	// Шаблон для генерации функции на Dlang
	string shDlang1 =
`
zgl2|// _________________________ [[NPP_LINE]] -- [[RAW_FUN]]
rbu2|@property [[TYPE_RET]] [[NAME_FUN]]([[TYPE_ARG1]] [[NAME_ARG1]], [[TYPE_ARG2]] [[NAME_ARG2]]) {
rbc2|[[NAME_CLASS]] [[NAME_FUN]]([[TYPE_ARG1]] [[NAME_ARG1]], [[TYPE_ARG2]] [[NAME_ARG2]]) {
qqqq|===================
iii2|    return (cast(t_i__qp_i_i_i) pFunQt[ [[NOM_FUN]] ])(QtObj, [[NAME_ARG1]], [[NAME_ARG2]], [[NPP_LINE]]);
iib2|    return (cast(t_i__qp_i_i_i) pFunQt[ [[NOM_FUN]] ])(QtObj, [[NAME_ARG1]], cast(int)[[NAME_ARG2]], [[NPP_LINE]]);
iie2|    return (cast(t_i__qp_i_i_i) pFunQt[ [[NOM_FUN]] ])(QtObj, [[NAME_ARG1]], cast([[TYPE_ARG1]])[[NAME_ARG2]], [[NPP_LINE]]);
bii2|    return cast(bool)(cast(t_i__qp_i_i_i) pFunQt[ [[NOM_FUN]] ])(QtObj, [[NAME_ARG1]], [[NAME_ARG2]], [[NPP_LINE]]);
bib2|    return cast(bool)(cast(t_i__qp_i_i_i) pFunQt[ [[NOM_FUN]] ])(QtObj, [[NAME_ARG1]], cast(int)[[NAME_ARG2]], [[NPP_LINE]]);
bie2|    return cast(bool)(cast(t_i__qp_i_i_i) pFunQt[ [[NOM_FUN]] ])(QtObj, [[NAME_ARG1]], cast([[TYPE_ARG1]])[[NAME_ARG2]], [[NPP_LINE]]);
vii2|    (cast(t_i__qp_i_i_i) pFunQt[ [[NOM_FUN]] ])(QtObj, [[NAME_ARG1]], [[NAME_ARG2]], [[NPP_LINE]]);
vib2|    (cast(t_i__qp_i_i_i) pFunQt[ [[NOM_FUN]] ])(QtObj, [[NAME_ARG1]], cast(int)[[NAME_ARG2]], [[NPP_LINE]]);
vie2|    (cast(t_i__qp_i_i_i) pFunQt[ [[NOM_FUN]] ])(QtObj, [[NAME_ARG1]], cast([[TYPE_ARG1]])[[NAME_ARG2]], [[NPP_LINE]]);
eii2|    return cast([[TYPE_RET]])(cast(t_i__qp_i_i_i) pFunQt[ [[NOM_FUN]] ])(QtObj, [[NAME_ARG1]], [[NAME_ARG2]], [[NPP_LINE]]);
eib2|    return cast([[TYPE_RET]])(cast(t_i__qp_i_i_i) pFunQt[ [[NOM_FUN]] ])(QtObj, [[NAME_ARG1]], cast(int)[[NAME_ARG2]], [[NPP_LINE]]);
eie2|    return cast([[TYPE_RET]])(cast(t_i__qp_i_i_i) pFunQt[ [[NOM_FUN]] ])(QtObj, [[NAME_ARG1]], cast(int)[[NAME_ARG2]], [[NPP_LINE]]);
qqqq|===================
ibi2|    return (cast(t_i__qp_i_i_i) pFunQt[ [[NOM_FUN]] ])(QtObj, cast(int)[[NAME_ARG1]], [[NAME_ARG2]], [[NPP_LINE]]);
ibb2|    return (cast(t_i__qp_i_i_i) pFunQt[ [[NOM_FUN]] ])(QtObj, cast(int)[[NAME_ARG1]], cast(int)[[NAME_ARG2]], [[NPP_LINE]]);
ibe2|    return (cast(t_i__qp_i_i_i) pFunQt[ [[NOM_FUN]] ])(QtObj, cast(int)[[NAME_ARG1]], cast(int)[[NAME_ARG2]], [[NPP_LINE]]);
bbi2|    return cast(bool)(cast(t_i__qp_i_i_i) pFunQt[ [[NOM_FUN]] ])(QtObj, cast(int)[[NAME_ARG1]], [[NAME_ARG2]], [[NPP_LINE]]);
bbb2|    return cast(bool)(cast(t_i__qp_i_i_i) pFunQt[ [[NOM_FUN]] ])(QtObj, cast(int)[[NAME_ARG1]], cast(int)[[NAME_ARG2]], [[NPP_LINE]]);
bbe2|    return cast(bool)(cast(t_i__qp_i_i_i) pFunQt[ [[NOM_FUN]] ])(QtObj, cast(int)[[NAME_ARG1]], cast(int)[[NAME_ARG2]], [[NPP_LINE]]);
vbi2|    (cast(t_i__qp_i_i_i) pFunQt[ [[NOM_FUN]] ])(QtObj, cast(int)[[NAME_ARG1]], [[NAME_ARG2]], [[NPP_LINE]]);
vbb2|    (cast(t_i__qp_i_i_i) pFunQt[ [[NOM_FUN]] ])(QtObj, cast(int)[[NAME_ARG1]], cast(int)[[NAME_ARG2]], [[NPP_LINE]]);
vbe2|    (cast(t_i__qp_i_i_i) pFunQt[ [[NOM_FUN]] ])(QtObj, cast(int)[[NAME_ARG1]], cast(int)[[NAME_ARG2]], [[NPP_LINE]]);
ebi2|    return cast([[TYPE_RET]])(cast(t_i__qp_i_i_i) pFunQt[ [[NOM_FUN]] ])(QtObj, cast(int)[[NAME_ARG1]], [[NAME_ARG2]], [[NPP_LINE]]);
ebb2|    return cast([[TYPE_RET]])(cast(t_i__qp_i_i_i) pFunQt[ [[NOM_FUN]] ])(QtObj, cast(int)[[NAME_ARG1]], cast(int)[[NAME_ARG2]], [[NPP_LINE]]);
ebe2|    return cast([[TYPE_RET]])(cast(t_i__qp_i_i_i) pFunQt[ [[NOM_FUN]] ])(QtObj, cast(int)[[NAME_ARG1]], cast(int)[[NAME_ARG2]], [[NPP_LINE]]);
qqqq|===================
iei2|    return (cast(t_i__qp_i_i_i) pFunQt[ [[NOM_FUN]] ])(QtObj, cast(int)[[NAME_ARG1]], [[NAME_ARG2]], [[NPP_LINE]]);
ieb2|    return (cast(t_i__qp_i_i_i) pFunQt[ [[NOM_FUN]] ])(QtObj, cast(int)[[NAME_ARG1]], cast(int)[[NAME_ARG2]], [[NPP_LINE]]);
iee2|    return (cast(t_i__qp_i_i_i) pFunQt[ [[NOM_FUN]] ])(QtObj, cast(int)[[NAME_ARG1]], cast(int)[[NAME_ARG2]], [[NPP_LINE]]);
bei2|    return cast(bool)(cast(t_i__qp_i_i_i) pFunQt[ [[NOM_FUN]] ])(QtObj, cast(int)[[NAME_ARG1]], [[NAME_ARG2]], [[NPP_LINE]]);
beb2|    return cast(bool)(cast(t_i__qp_i_i_i) pFunQt[ [[NOM_FUN]] ])(QtObj, cast(int)[[NAME_ARG1]], cast(int)[[NAME_ARG2]], [[NPP_LINE]]);
bee2|    return cast(bool)(cast(t_i__qp_i_i_i) pFunQt[ [[NOM_FUN]] ])(QtObj, cast(int)[[NAME_ARG1]], cast(int)[[NAME_ARG2]], [[NPP_LINE]]);
vei2|    (cast(t_i__qp_i_i_i) pFunQt[ [[NOM_FUN]] ])(QtObj, cast(int)[[NAME_ARG1]], [[NAME_ARG2]], [[NPP_LINE]]);
veb2|    (cast(t_i__qp_i_i_i) pFunQt[ [[NOM_FUN]] ])(QtObj, cast(int)[[NAME_ARG1]], cast(int)[[NAME_ARG2]], [[NPP_LINE]]);
vee2|    (cast(t_i__qp_i_i_i) pFunQt[ [[NOM_FUN]] ])(QtObj, cast(int)[[NAME_ARG1]], cast(int)[[NAME_ARG2]], [[NPP_LINE]]);
eei2|    return cast([[TYPE_RET]])(cast(t_i__qp_i_i_i) pFunQt[ [[NOM_FUN]] ])(QtObj, cast(int)[[NAME_ARG1]], [[NAME_ARG2]], [[NPP_LINE]]);
eeb2|    return cast([[TYPE_RET]])(cast(t_i__qp_i_i_i) pFunQt[ [[NOM_FUN]] ])(QtObj, cast(int)[[NAME_ARG1]], cast(int)[[NAME_ARG2]], [[NPP_LINE]]);
eee2|    return cast([[TYPE_RET]])(cast(t_i__qp_i_i_i) pFunQt[ [[NOM_FUN]] ])(QtObj, cast(int)[[NAME_ARG1]], cast(int)[[NAME_ARG2]], [[NPP_LINE]]);
qqqq|===================
ret2|    return this;
zsk2|}
`;

	dict["RAW_FUN"]  = rawFun;
	dict["NPP_LINE"] = to!string(nppLine);
	dict["NAME_FUN"] = nameFun;
	dict["NAME_CLASS"] = nameClassCpp;
	dict["TYPE_RET"] = typeRet;
	dict["NOM_FUN"] = to!string(nomFunQtE);

	// Начальный заголовок - комментарий
	rez ~= sh1c(shDlang1, "zgl2", dict);

	string[] masArg1 = split(argsFun1, '%');
	string[] masArg2 = split(argsFun2, '%');
	dict["TYPE_ARG1"] = masArg1[0];
	dict["NAME_ARG1"] = masArg1[1];
	dict["TYPE_ARG2"] = masArg2[0];
	dict["NAME_ARG2"] = masArg2[1];
	if(detectTypeArg(typeRet) == TypeArg.Int) {
		// Заголовок функции с двумя параметрами
		rez ~= sh1c(shDlang1, "rbu2", dict);
		switch(detectTypeArg(masArg1[0]))
		{
			case TypeArg.Int:  // 1 - int
				switch(detectTypeArg(masArg2[0]))
				{
					case TypeArg.Int:  // 1 - int 2 - int
						rez ~= sh1c(shDlang1, "iii2", dict);
						break;
					case TypeArg.Bool: // 1 - int 2 - bool
						rez ~= sh1c(shDlang1, "iib2", dict);
						break;
					case TypeArg.Enum: // 1 - int 2 - enum
						rez ~= sh1c(shDlang1, "iie2", dict);
						break;
					default:
						rez ~= "{{ERROR}}";
						break;
				}
				break;
			case TypeArg.Bool:
				switch(detectTypeArg(masArg2[0]))
				{
					case TypeArg.Int:  // 1 - bool 2 - int
						rez ~= sh1c(shDlang1, "ibi2", dict);
						break;
					case TypeArg.Bool: // 1 - bool 2 - bool
						rez ~= sh1c(shDlang1, "ibb2", dict);
						break;
					case TypeArg.Enum: // 1 - bool 2 - enum
						rez ~= sh1c(shDlang1, "ibe2", dict);
						break;
					default:
						rez ~= "{{ERROR}}";
						break;
				}
				break;
			case TypeArg.Enum:
				switch(detectTypeArg(masArg2[0]))
				{
					case TypeArg.Int:   // 1 - enum 2 - int
						rez ~= sh1c(shDlang1, "iei2", dict);
						break;
					case TypeArg.Bool:  // 1 - enum 2 - bool
						rez ~= sh1c(shDlang1, "ieb2", dict);
						break;
					case TypeArg.Enum:  // 1 - enum 2 - enum
						rez ~= sh1c(shDlang1, "iee2", dict);
						break;
					default:
						rez ~= "{{ERROR}}";
						break;
				}
				break;
			default:
				break;
		}
	}
	if(detectTypeArg(typeRet) == TypeArg.Bool) {
		// Заголовок функции с двумя параметрами
		rez ~= sh1c(shDlang1, "rbu2", dict);
		switch(detectTypeArg(masArg1[0]))
		{
			case TypeArg.Int:  // 1 - int
				switch(detectTypeArg(masArg2[0]))
				{
					case TypeArg.Int:  // 1 - int 2 - int
						rez ~= sh1c(shDlang1, "bii2", dict);
						break;
					case TypeArg.Bool: // 1 - int 2 - bool
						rez ~= sh1c(shDlang1, "bib2", dict);
						break;
					case TypeArg.Enum: // 1 - int 2 - enum
						rez ~= sh1c(shDlang1, "bie2", dict);
						break;
					default:
						rez ~= "{{ERROR}}";
						break;
				}
				break;
			case TypeArg.Bool:
				switch(detectTypeArg(masArg2[0]))
				{
					case TypeArg.Int:  // 1 - bool 2 - int
						rez ~= sh1c(shDlang1, "bbi2", dict);
						break;
					case TypeArg.Bool: // 1 - bool 2 - bool
						rez ~= sh1c(shDlang1, "bbb2", dict);
						break;
					case TypeArg.Enum: // 1 - bool 2 - enum
						rez ~= sh1c(shDlang1, "bbe2", dict);
						break;
					default:
						rez ~= "{{ERROR}}";
						break;
				}
				break;
			case TypeArg.Enum:
				switch(detectTypeArg(masArg2[0]))
				{
					case TypeArg.Int:   // 1 - enum 2 - int
						rez ~= sh1c(shDlang1, "bei2", dict);
						break;
					case TypeArg.Bool:  // 1 - enum 2 - bool
						rez ~= sh1c(shDlang1, "beb2", dict);
						break;
					case TypeArg.Enum:  // 1 - enum 2 - enum
						rez ~= sh1c(shDlang1, "bee2", dict);
						break;
					default:
						rez ~= "{{ERROR}}";
						break;
				}
				break;
			default:
				break;
		}
	}
	if(detectTypeArg(typeRet) == TypeArg.Enum) {
		// Заголовок функции с двумя параметрами
		rez ~= sh1c(shDlang1, "rbu2", dict);
		switch(detectTypeArg(masArg1[0]))
		{
			case TypeArg.Int:  // 1 - int
				switch(detectTypeArg(masArg2[0]))
				{
					case TypeArg.Int:  // 1 - int 2 - int
						rez ~= sh1c(shDlang1, "eii2", dict);
						break;
					case TypeArg.Bool: // 1 - int 2 - bool
						rez ~= sh1c(shDlang1, "eib2", dict);
						break;
					case TypeArg.Enum: // 1 - int 2 - enum
						rez ~= sh1c(shDlang1, "eie2", dict);
						break;
					default:
						rez ~= "{{ERROR}}";
						break;
				}
				break;
			case TypeArg.Bool:
				switch(detectTypeArg(masArg2[0]))
				{
					case TypeArg.Int:  // 1 - bool 2 - int
						rez ~= sh1c(shDlang1, "ebi2", dict);
						break;
					case TypeArg.Bool: // 1 - bool 2 - bool
						rez ~= sh1c(shDlang1, "ebb2", dict);
						break;
					case TypeArg.Enum: // 1 - bool 2 - enum
						rez ~= sh1c(shDlang1, "ebe2", dict);
						break;
					default:
						rez ~= "{{ERROR}}";
						break;
				}
				break;
			case TypeArg.Enum:
				switch(detectTypeArg(masArg2[0]))
				{
					case TypeArg.Int:   // 1 - enum 2 - int
						rez ~= sh1c(shDlang1, "eei2", dict);
						break;
					case TypeArg.Bool:  // 1 - enum 2 - bool
						rez ~= sh1c(shDlang1, "eeb2", dict);
						break;
					case TypeArg.Enum:  // 1 - enum 2 - enum
						rez ~= sh1c(shDlang1, "eee2", dict);
						break;
					default:
						rez ~= "{{ERROR}}";
						break;
				}
				break;
			default:
				break;
		}
	}
	if(detectTypeArg(typeRet) == TypeArg.Void) {
		// Заголовок функции с двумя параметрами
		rez ~= sh1c(shDlang1, "rbc2", dict);
		switch(detectTypeArg(masArg1[0]))
		{
			case TypeArg.Int:  // 1 - int
				switch(detectTypeArg(masArg2[0]))
				{
					case TypeArg.Int:  // 1 - int 2 - int
						rez ~= sh1c(shDlang1, "vii2", dict);
						break;
					case TypeArg.Bool: // 1 - int 2 - bool
						rez ~= sh1c(shDlang1, "vib2", dict);
						break;
					case TypeArg.Enum: // 1 - int 2 - enum
						rez ~= sh1c(shDlang1, "vie2", dict);
						break;
					default:
						rez ~= "{{ERROR}}";
						break;
				}
				break;
			case TypeArg.Bool:
				switch(detectTypeArg(masArg2[0]))
				{
					case TypeArg.Int:  // 1 - bool 2 - int
						rez ~= sh1c(shDlang1, "vbi2", dict);
						break;
					case TypeArg.Bool: // 1 - bool 2 - bool
						rez ~= sh1c(shDlang1, "vbb2", dict);
						break;
					case TypeArg.Enum: // 1 - bool 2 - enum
						rez ~= sh1c(shDlang1, "vbe2", dict);
						break;
					default:
						rez ~= "{{ERROR}}";
						break;
				}
				break;
			case TypeArg.Enum:
				switch(detectTypeArg(masArg2[0]))
				{
					case TypeArg.Int:   // 1 - enum 2 - int
						rez ~= sh1c(shDlang1, "vei2", dict);
						break;
					case TypeArg.Bool:  // 1 - enum 2 - bool
						rez ~= sh1c(shDlang1, "veb2", dict);
						break;
					case TypeArg.Enum:  // 1 - enum 2 - enum
						rez ~= sh1c(shDlang1, "vee2", dict);
						break;
					default:
						rez ~= "{{ERROR}}";
						break;
				}
				break;
			default:
				break;
		}
		rez ~= sh1c(shDlang1, "ret2", dict);
	}
	rez ~= sh1c(shDlang1, "zsk2", dict);
	// writeln(rez[2]);
	string[] rezOk;
	foreach(line; rez) {
		if(line.strip() == "") continue;
		rezOk ~= line;
	}
	return rezOk;
}
unittest {
	// Ok
	assert((genFunDlang2("int|contains|int%x|int%y", 45, 0, "QLabel"))[2].strip() 
	== `return (cast(t_i__qp_i_i_i) pFunQt[ 45 ])(QtObj, x, y, 0);`
	);
	assert((genFunDlang2("int|contains|int%x|bool%y", 45, 0, "QLabel"))[2].strip() 
	== `return (cast(t_i__qp_i_i_i) pFunQt[ 45 ])(QtObj, x, cast(int)y, 0);`
	);
	assert((genFunDlang2("int|contains|int%x|Qw::Zx%y", 45, 0, "QLabel"))[2].strip() 
	== `return (cast(t_i__qp_i_i_i) pFunQt[ 45 ])(QtObj, x, cast(int)y, 0);`
	);
	assert((genFunDlang2("bool|contains|int%x|int%y", 45, 0, "QLabel"))[2].strip() 
	== `return cast(bool)(cast(t_i__qp_i_i_i) pFunQt[ 45 ])(QtObj, x, y, 0);`
	);
	assert((genFunDlang2("bool|contains|int%x|bool%y", 45, 0, "QLabel"))[2].strip() 
	== `return cast(bool)(cast(t_i__qp_i_i_i) pFunQt[ 45 ])(QtObj, x, cast(int)y, 0);`
	);
	assert((genFunDlang2("bool|contains|int%x|Qw::Zx%y", 45, 0, "QLabel"))[2].strip() 
	== `return cast(bool)(cast(t_i__qp_i_i_i) pFunQt[ 45 ])(QtObj, x, cast(int)y, 0);`
	);
	assert((genFunDlang2("int|contains|int%x|int%y", 45, 1, "QLabel"))[2].strip()
	== "return (cast(t_i__qp_i_i_i) pFunQt[ 45 ])(QtObj, x, y, 1);"
	);
	assert((genFunDlang2("int|contains|int%x|bool%y", 45, 1, "QLabel"))[2].strip()
	== "return (cast(t_i__qp_i_i_i) pFunQt[ 45 ])(QtObj, x, cast(int)y, 1);"
	);
	assert((genFunDlang2("int|contains|int%x|Qw::Zx%y", 45, 1, "QLabel"))[2].strip()
	== "return (cast(t_i__qp_i_i_i) pFunQt[ 45 ])(QtObj, x, cast(int)y, 1);"
	);
	assert((genFunDlang2("bool|contains|int%x|int%y", 45, 1, "QLabel"))[2].strip()
	== "return cast(bool)(cast(t_i__qp_i_i_i) pFunQt[ 45 ])(QtObj, x, y, 1);"
	);
	assert((genFunDlang2("bool|contains|int%x|bool%y", 45, 1, "QLabel"))[2].strip()
	== "return cast(bool)(cast(t_i__qp_i_i_i) pFunQt[ 45 ])(QtObj, x, cast(int)y, 1);"
	);
	assert((genFunDlang2("bool|contains|int%x|Qw::Zx%y", 45, 1, "QLabel"))[2].strip()
	== "return cast(bool)(cast(t_i__qp_i_i_i) pFunQt[ 45 ])(QtObj, x, cast(int)y, 1);"
	);
	assert((genFunDlang2("void|contains|int%x|int%y", 45, 1, "QLabel"))[2].strip()
	== "(cast(t_i__qp_i_i_i) pFunQt[ 45 ])(QtObj, x, y, 1);"
	);
	assert((genFunDlang2("void|contains|int%x|bool%y", 45, 1, "QLabel"))[2].strip()
	== "(cast(t_i__qp_i_i_i) pFunQt[ 45 ])(QtObj, x, cast(int)y, 1);"
	);
	assert((genFunDlang2("void|contains|int%x|Qw::Zx%y", 45, 1, "QLabel"))[2].strip()
	== "(cast(t_i__qp_i_i_i) pFunQt[ 45 ])(QtObj, x, cast(int)y, 1);"
	);
	assert((genFunDlang2("Nn::Nn|contains|int%x|int%y", 45, 1, "QLabel"))[2].strip()
	== "return cast(Nn::Nn)(cast(t_i__qp_i_i_i) pFunQt[ 45 ])(QtObj, x, y, 1);"
	);
	assert((genFunDlang2("Nn::Nn|contains|int%x|bool%y", 45, 1, "QLabel"))[2].strip()
	== "return cast(Nn::Nn)(cast(t_i__qp_i_i_i) pFunQt[ 45 ])(QtObj, x, cast(int)y, 1);"
	);
	assert((genFunDlang2("Nn::Nn|contains|int%x|Qw::Zx%y", 45, 1, "QLabel"))[2].strip()
	== "return cast(Nn::Nn)(cast(t_i__qp_i_i_i) pFunQt[ 45 ])(QtObj, x, cast(int)y, 1);"
	);
	assert((genFunDlang2("int|contains|bool%x|int%y", 45, 1, "QLabel"))[2].strip()
	== "return (cast(t_i__qp_i_i_i) pFunQt[ 45 ])(QtObj, cast(int)x, y, 1);"
	);
	assert((genFunDlang2("int|contains|bool%x|bool%y", 45, 1, "QLabel"))[2].strip()
	== "return (cast(t_i__qp_i_i_i) pFunQt[ 45 ])(QtObj, cast(int)x, cast(int)y, 1);"
	);
	assert((genFunDlang2("int|contains|bool%x|Qw::Zx%y", 45, 1, "QLabel"))[2].strip()
	== "return (cast(t_i__qp_i_i_i) pFunQt[ 45 ])(QtObj, cast(int)x, cast(int)y, 1);"
	);
	assert((genFunDlang2("bool|contains|bool%x|int%y", 45, 1, "QLabel"))[2].strip()
	== "return cast(bool)(cast(t_i__qp_i_i_i) pFunQt[ 45 ])(QtObj, cast(int)x, y, 1);"
	);
	assert((genFunDlang2("bool|contains|bool%x|bool%y", 45, 1, "QLabel"))[2].strip()
	== "return cast(bool)(cast(t_i__qp_i_i_i) pFunQt[ 45 ])(QtObj, cast(int)x, cast(int)y, 1);"
	);
	assert((genFunDlang2("bool|contains|bool%x|Qw::Zx%y", 45, 1, "QLabel"))[2].strip()
	== "return cast(bool)(cast(t_i__qp_i_i_i) pFunQt[ 45 ])(QtObj, cast(int)x, cast(int)y, 1);"
	);
	assert((genFunDlang2("void|contains|bool%x|int%y", 45, 1, "QLabel"))[2].strip()
	== "(cast(t_i__qp_i_i_i) pFunQt[ 45 ])(QtObj, cast(int)x, y, 1);"
	);
	assert((genFunDlang2("void|contains|bool%x|bool%y", 45, 1, "QLabel"))[2].strip()
	== "(cast(t_i__qp_i_i_i) pFunQt[ 45 ])(QtObj, cast(int)x, cast(int)y, 1);"
	);
	assert((genFunDlang2("void|contains|bool%x|Qw::Zx%y", 45, 1, "QLabel"))[2].strip()
	== "(cast(t_i__qp_i_i_i) pFunQt[ 45 ])(QtObj, cast(int)x, cast(int)y, 1);"
	);
	assert((genFunDlang2("Nn::Nn|contains|bool%x|int%y", 45, 1, "QLabel"))[2].strip()
	== "return cast(Nn::Nn)(cast(t_i__qp_i_i_i) pFunQt[ 45 ])(QtObj, cast(int)x, y, 1);"
	);
	assert((genFunDlang2("Nn::Nn|contains|bool%x|bool%y", 45, 1, "QLabel"))[2].strip()
	== "return cast(Nn::Nn)(cast(t_i__qp_i_i_i) pFunQt[ 45 ])(QtObj, cast(int)x, cast(int)y, 1);"
	);
	assert((genFunDlang2("Nn::Nn|contains|bool%x|Qw::Zx%y", 45, 1, "QLabel"))[2].strip()
	== "return cast(Nn::Nn)(cast(t_i__qp_i_i_i) pFunQt[ 45 ])(QtObj, cast(int)x, cast(int)y, 1);"
	);
	assert((genFunDlang2("int|contains|Qw1::Zx1%x|int%y", 45, 1, "QLabel"))[2].strip()
	== "return (cast(t_i__qp_i_i_i) pFunQt[ 45 ])(QtObj, cast(int)x, y, 1);"
	);
	assert((genFunDlang2("int|contains|Qw1::Zx1%x|bool%y", 45, 1, "QLabel"))[2].strip()
	== "return (cast(t_i__qp_i_i_i) pFunQt[ 45 ])(QtObj, cast(int)x, cast(int)y, 1);"
	);
	assert((genFunDlang2("int|contains|Qw1::Zx1%x|Qw::Zx%y", 45, 1, "QLabel"))[2].strip()
	== "return (cast(t_i__qp_i_i_i) pFunQt[ 45 ])(QtObj, cast(int)x, cast(int)y, 1);"
	);
	assert((genFunDlang2("bool|contains|Qw1::Zx1%x|int%y", 45, 1, "QLabel"))[2].strip()
	== "return cast(bool)(cast(t_i__qp_i_i_i) pFunQt[ 45 ])(QtObj, cast(int)x, y, 1);"
	);
	assert((genFunDlang2("bool|contains|Qw1::Zx1%x|bool%y", 45, 1, "QLabel"))[2].strip()
	== "return cast(bool)(cast(t_i__qp_i_i_i) pFunQt[ 45 ])(QtObj, cast(int)x, cast(int)y, 1);"
	);
	assert((genFunDlang2("bool|contains|Qw1::Zx1%x|Qw::Zx%y", 45, 1, "QLabel"))[2].strip()
	== "return cast(bool)(cast(t_i__qp_i_i_i) pFunQt[ 45 ])(QtObj, cast(int)x, cast(int)y, 1);"
	);
	assert((genFunDlang2("void|contains|Qw1::Zx1%x|int%y", 45, 1, "QLabel"))[2].strip()
	== "(cast(t_i__qp_i_i_i) pFunQt[ 45 ])(QtObj, cast(int)x, y, 1);"
	);
	assert((genFunDlang2("void|contains|Qw1::Zx1%x|bool%y", 45, 1, "QLabel"))[2].strip()
	== "(cast(t_i__qp_i_i_i) pFunQt[ 45 ])(QtObj, cast(int)x, cast(int)y, 1);"
	);
	assert((genFunDlang2("void|contains|Qw1::Zx1%x|Qw::Zx%y", 45, 1, "QLabel"))[2].strip()
	== "(cast(t_i__qp_i_i_i) pFunQt[ 45 ])(QtObj, cast(int)x, cast(int)y, 1);"
	);
	assert((genFunDlang2("Nn::Nn|contains|Qw1::Zx1%x|int%y", 45, 1, "QLabel"))[2].strip()
	== "return cast(Nn::Nn)(cast(t_i__qp_i_i_i) pFunQt[ 45 ])(QtObj, cast(int)x, y, 1);"
	);
	assert((genFunDlang2("Nn::Nn|contains|Qw1::Zx1%x|bool%y", 45, 1, "QLabel"))[2].strip()
	== "return cast(Nn::Nn)(cast(t_i__qp_i_i_i) pFunQt[ 45 ])(QtObj, cast(int)x, cast(int)y, 1);"
	);
	assert((genFunDlang2("Nn::Nn|contains|Qw1::Zx1%x|Qw::Zx%y", 45, 1, "QLabel"))[2].strip()
	== "return cast(Nn::Nn)(cast(t_i__qp_i_i_i) pFunQt[ 45 ])(QtObj, cast(int)x, cast(int)y, 1);"
	);
}
// __________________________________________________________________
// Смотрит на все строки и выбирает все подхлдящие для набора №1
string[] createSet_1(string[] listFun, int nomFunQtE, string nameClassCpp, string suficsFunCPP) {
	string[] rez;
	string[] funDlang;
	// Шаблон для генерации функции на C++
	string shCpp =
`
nm|// [[NOM_FUN]]
zg|extern "C" MSVC_API int [[NAME_CLASS_CPP]]_[[SUF_CPP]]([[NAME_CLASS_CPP]]* wd, int arg, int pr) {
in|int rez = 0;
sw|    switch ( pr ) {
ls|        case [[N_CASE]]:   [[EXEC_FUN]]   break;  // [[RAW_FUN]]
p1|    }
p2|    return rez;
pe|}
`;
	string[string] dict;
	int nppLine;

	dict["NOM_FUN"] = to!string(nomFunQtE);
	dict["NAME_CLASS_CPP"] = nameClassCpp;
	dict["SUF_CPP"] = suficsFunCPP;

	rez ~= sh1c(shCpp, "nm", dict);
	rez ~= sh1c(shCpp, "zg", dict);
	rez ~= sh1c(shCpp, "in", dict);
	rez ~= sh1c(shCpp, "sw", dict);

	foreach(s; listFun) {
		if(!s.length) continue;
		if(isDigit1251(s[0])) {
			if(s[0] == '1') {
				// Это мой функция из набора №1
				string rawFun = s[2 .. $];
				dict["N_CASE"] = to!string(nppLine);
				dict["EXEC_FUN"] = genExecCppFun(rawFun);
				dict["RAW_FUN"] = rawFun;
				// Генерю строку функции C++
				rez ~= sh1c(shCpp, "ls", dict);
				// Генерю функцию Dlang
				funDlang ~= genFunDlang(rawFun, nomFunQtE, nppLine, nameClassCpp);
				nppLine++;
			}
		}
	}
	rez ~= sh1c(shCpp, "p1", dict);
	rez ~= sh1c(shCpp, "p2", dict);
	rez ~= sh1c(shCpp, "pe", dict);
	rez ~= funDlang;
	return rez;
}

// __________________________________________________________________
// Смотрит на все строки и выбирает все подхлдящие для набора №2
string[] createSet_2(string[] listFun, int nomFunQtE, string nameClassCpp, string suficsFunCPP) {
	string[] rez;
	string[] funDlang;
	// Шаблон для генерации функции на C++
	string shCpp =
`
nm|// [[NOM_FUN]]
zg|extern "C" MSVC_API int [[NAME_CLASS_CPP]]_[[SUF_CPP]]([[NAME_CLASS_CPP]]* wd, int arg1, int arg2, int pr) {
in|int rez = 0;
sw|    switch ( pr ) {
ls|        case [[N_CASE]]:   [[EXEC_FUN]]   break;  // [[RAW_FUN]]
p1|    }
p2|    return rez;
pe|}
`;
	string[string] dict;
	int nppLine;

	dict["NOM_FUN"] = to!string(nomFunQtE);
	dict["NAME_CLASS_CPP"] = nameClassCpp;
	dict["SUF_CPP"] = suficsFunCPP;

	rez ~= sh1c(shCpp, "nm", dict);
	rez ~= sh1c(shCpp, "zg", dict);
	rez ~= sh1c(shCpp, "in", dict);
	rez ~= sh1c(shCpp, "sw", dict);

	foreach(s; listFun) {
		if(!s.length) continue;
		if(isDigit1251(s[0])) {
			if(s[0] == '2') {
				// Это мой функция из набора №1
				string rawFun = s[2 .. $];
				dict["N_CASE"] = to!string(nppLine);
				dict["EXEC_FUN"] = genExecCppFun2(rawFun);
				dict["RAW_FUN"] = rawFun;
				// Генерю строку функции C++
				rez ~= sh1c(shCpp, "ls", dict);
				// Генерю функцию Dlang
				funDlang ~= genFunDlang2(rawFun, nomFunQtE, nppLine, nameClassCpp);
				nppLine++;
			}
		}
	}
	rez ~= sh1c(shCpp, "p1", dict);
	rez ~= sh1c(shCpp, "p2", dict);
	rez ~= sh1c(shCpp, "pe", dict);
	rez ~= funDlang;
	return rez;
}

// __________________________________________________________________
// Набор №3 = На выходе int|bool|Xxx::Yyy,int|bool|Xxx::Yyy  на входе 2 int|cornerWidget|Qt::Corner%corner|QString%myInt
// Либо на входе, либо на выходе есть QString. Аргумент ОДИН или ОТСУТСТВУЕТ
string n3__qs__1_int_bool_qs(string astr) {
	if(strip(astr) == "") return astr;
	auto setRet1 = [TypeArg.Int: true, TypeArg.Bool: true, TypeArg.Void: true, TypeArg.Enum: true];
	auto setArg1 = [TypeArg.Int: true, TypeArg.Bool: true, TypeArg.Enum: true, TypeArg.Pusto: true];
	bool fIsQsRet, fIsQsArg1, fIsQsArg2;

	TypeArg typeTRet, typeArg1;
	string typeRet, nameFun, argsFun1, argsFun2;
	{
		string[] mas1 = split(astr, '|');
		if(mas1.length != 3) return astr;       // Нет нужного количества аргументов
		typeRet = mas1[0];
		if(!typeRet.length)  return astr;       // Нет возвращаемого значения
		nameFun  = mas1[1];
		if(!isLetters1251E(nameFun[0])) return astr; // Имя функции не определено
		argsFun1 = mas1[2];
	}
	// Вычислил тип возврата
	typeTRet = detectTypeArg(typeRet);
	if(typeTRet !in setRet1) {
		// А может это QString? ...
		if(typeTRet == TypeArg.QString) {
			// Ok - this is QString
			fIsQsRet = true;
		} else {
			//Возврат не подпадает под нужный формат
			return astr; // Это что то непонятное
		}
	}
	// С выходным типом разобрались ...
	if(argsFun1 == "") {
		typeArg1 = TypeArg.Pusto;
	} else {
		string[] mas1 = split(argsFun1, '%');
		typeArg1 = detectTypeArg(mas1[0]);
	}
	// Посмотрим на первый аргумент
	if(typeArg1 !in setArg1) {
		// А может это QString? ...
		if(typeArg1 == TypeArg.QString) {
			// Ok - this is QString
			fIsQsArg1 = true;
		} else {
			// Первый аргумент не подпадает по нужный формат
			return astr; // Это что то непонятное
		}
	}
	if( !(fIsQsRet || fIsQsArg1) ) {
		// Нету QString
		return astr; // Это что то непонятное
	}
	// Хорошо, если мы тут то все типы нормальные, задвоенных нет, всё Ок
	return "3~" ~ astr;
}
unittest {
	assert(lib56.n3__qs__1_int_bool_qs("void|Name|QString%name")        == "3~void|Name|QString%name");
	assert(lib56.n3__qs__1_int_bool_qs("Qzz|Name|QString%name")         == "Qzz|Name|QString%name");
	assert(lib56.n3__qs__1_int_bool_qs("void|Name|int%name")            == "void|Name|int%name");
	assert(lib56.n3__qs__1_int_bool_qs("Qt::ty|Name|int%name")          == "Qt::ty|Name|int%name");
	assert(lib56.n3__qs__1_int_bool_qs("Qt::ty|Name|QString%name")      == "3~Qt::ty|Name|QString%name");
	assert(lib56.n3__qs__1_int_bool_qs("QString|NameFun|QString%name")  == "3~QString|NameFun|QString%name");
	assert(lib56.n3__qs__1_int_bool_qs("QString|NameFun|")              == "3~QString|NameFun|");
	assert(lib56.n3__qs__1_int_bool_qs("QString|windowRole|")           == "3~QString|windowRole|");
}

// __________________________________________________________________
// Генерирует строку в CASE функции на C++ для 3 (QString) набора
string genExecCppFun3(string rawFun) {
	string rez;
	string typeRet, nameFun, argsFun1;
	string[] mas1 = split(rawFun, '|');
	typeRet = mas1[0]; nameFun = mas1[1]; argsFun1 = mas1[2];

	if(detectTypeArg(typeRet) == TypeArg.Int) {
		// rez = wd-> ...
		if(argsFun1 == "") {
			rez = "rez = wd->" ~ nameFun ~ "();";
		} else {
			string[] masArg = split(argsFun1, '%');
			switch(detectTypeArg(masArg[0]))
			{
				case TypeArg.Int:
					rez = "rez = wd->" ~ nameFun ~ "(arg);";
					break;
				case TypeArg.Bool:
					rez = "rez = wd->" ~ nameFun ~ "((bool)arg);";
					break;
				case TypeArg.Enum:
					rez = "rez = wd->" ~ nameFun ~ "((" ~ masArg[0] ~ ")arg);";
					break;
				case TypeArg.QString:
					rez = "rez = wd->" ~ nameFun ~ "(*qsIn);";
					break;
				default:
					rez = "";
					break;
			}
		}
	}
	if(detectTypeArg(typeRet) == TypeArg.Bool) {
		// rez = (int)wd-> ...
		if(argsFun1 == "") {
			rez = "rez = (int)wd->" ~ nameFun ~ "();";
		} else {
			string[] masArg = split(argsFun1, '%');
			switch(detectTypeArg(masArg[0]))
			{
				case TypeArg.Int:
					rez = "rez = (int)wd->" ~ nameFun ~ "(arg);";
					break;
				case TypeArg.Bool:
					rez = "rez = (int)wd->" ~ nameFun ~ "((bool)arg);";
					break;
				case TypeArg.Enum:
					rez = "rez = (int)wd->" ~ nameFun ~ "((" ~ masArg[0] ~ ")arg);";
					break;
				case TypeArg.QString:
					rez = "rez = (int)wd->" ~ nameFun ~ "(*qsIn);";
					break;
				default:
					rez = "";
					break;
			}
		}
	}
	if(detectTypeArg(typeRet) == TypeArg.Void) {
		// wd-> ...
		if(argsFun1 == "") {
			rez = "wd->" ~ nameFun ~ "();";
		} else {
			string[] masArg = split(argsFun1, '%');
			switch(detectTypeArg(masArg[0]))
			{
				case TypeArg.Int:
					rez = "wd->" ~ nameFun ~ "(arg);";
					break;
				case TypeArg.Bool:
					rez = "wd->" ~ nameFun ~ "((bool)arg);";
					break;
				case TypeArg.Enum:
					rez = "wd->" ~ nameFun ~ "((" ~ masArg[0] ~ ")arg);";
					break;
				case TypeArg.QString:
					rez = "wd->" ~ nameFun ~ "(*qsIn);";
					break;
				default:
					rez = "";
					break;
			}
		}
	}
	if(detectTypeArg(typeRet) == TypeArg.Enum) {
		// rez = (int)wd-> ...
		if(argsFun1 == "") {
			rez = "rez = (int)wd->" ~ nameFun ~ "();";
		} else {
			string[] masArg = split(argsFun1, '%');
			switch(detectTypeArg(masArg[0]))
			{
				case TypeArg.Int:
					rez = "rez = (int)wd->" ~ nameFun ~ "(arg);";
					break;
				case TypeArg.Bool:
					rez = "rez = (int)wd->" ~ nameFun ~ "((bool)arg);";
					break;
				case TypeArg.Enum:
					rez = "rez = (int)wd->" ~ nameFun ~ "((" ~ masArg[0] ~ ")arg);";
					break;
				case TypeArg.QString:
					rez = "rez = (int)wd->" ~ nameFun ~ "(*qsIn);";
					break;
				default:
					rez = "";
					break;
			}
		}
	}
	if(detectTypeArg(typeRet) == TypeArg.QString) {
		// *qsOut = wd-> ...
		if(argsFun1 == "") {
			rez = "*qsOut = wd->" ~ nameFun ~ "();";
		} else {
			string[] masArg = split(argsFun1, '%');
			switch(detectTypeArg(masArg[0]))
			{
				case TypeArg.Int:
					rez = "*qsOut = wd->" ~ nameFun ~ "(arg);";
					break;
				case TypeArg.Bool:
					rez = "*qsOut = wd->" ~ nameFun ~ "((bool)arg);";
					break;
				case TypeArg.Enum:
					rez = "*qsOut = wd->" ~ nameFun ~ "((" ~ masArg[0] ~ ")arg);";
					break;
				case TypeArg.QString:
					rez = "*qsOut = wd->" ~ nameFun ~ "(*qsIn);";
					break;
				default:
					rez = "";
					break;
			}
		}
	}
	return rez;
}
unittest {
	// Эта функция не предпологает неверного входного параметра
	assert(genExecCppFun3("void|Name|QString%name")      == "wd->Name(*qsIn);"            );
	assert(genExecCppFun3("int|Name|QString%name")       == "rez = wd->Name(*qsIn);"      );
	assert(genExecCppFun3("bool|Name|QString%name")      == "rez = (int)wd->Name(*qsIn);" );
	assert(genExecCppFun3("Qtz::Qtz|Name|QString%name")  == "rez = (int)wd->Name(*qsIn);" );
	assert(genExecCppFun3("QString|Name|int%name")   == "*qsOut = wd->Name(arg);"   );
	assert(genExecCppFun3("QString|Name|bool%name")   == "*qsOut = wd->Name((bool)arg);"   );
	assert(genExecCppFun3("QString|Name|Qtz::Qtz%name")   == "*qsOut = wd->Name((Qtz::Qtz)arg);"   );
	
}

// __________________________________________________________________
// Смотрит на все строки и выбирает все подхлдящие для набора №3 + QString
string[] createSet_3(string[] listFun, int nomFunQtE, string nameClassCpp, string suficsFunCPP) {
	string[] rez;
	string[] funDlang;
	// Шаблон для генерации функции на C++
	string shCpp =
`
nm|// [[NOM_FUN]]
zg|extern "C" MSVC_API int [[NAME_CLASS_CPP]]_[[SUF_CPP]]([[NAME_CLASS_CPP]]* wd, int arg, QString* qsOut, QString* qsIn, int pr) {
in|int rez = 0;
sw|    switch ( pr ) {
ls|        case [[N_CASE]]:   [[EXEC_FUN]]   break;  // [[RAW_FUN]]
p1|    }
p2|    return rez;
pe|}
`;
	string[string] dict;
	int nppLine;

	dict["NOM_FUN"] = to!string(nomFunQtE);
	dict["NAME_CLASS_CPP"] = nameClassCpp;
	dict["SUF_CPP"] = suficsFunCPP;

	rez ~= sh1c(shCpp, "nm", dict);
	rez ~= sh1c(shCpp, "zg", dict);
	rez ~= sh1c(shCpp, "in", dict);
	rez ~= sh1c(shCpp, "sw", dict);

	foreach(s; listFun) {
		if(!s.length) continue;
		if(isDigit1251(s[0])) {
			if(s[0] == '3') {
				// Это мой функция из набора №1
				string rawFun = s[2 .. $];
				dict["N_CASE"] = to!string(nppLine);
				dict["EXEC_FUN"] = genExecCppFun3(rawFun);
				dict["RAW_FUN"] = rawFun;
				// Генерю строку функции C++
				rez ~= sh1c(shCpp, "ls", dict);
				// Генерю функцию Dlang
				funDlang ~= genFunDlang3(rawFun, nomFunQtE, nppLine, nameClassCpp);
				nppLine++;
			}
		}
	}
	rez ~= sh1c(shCpp, "p1", dict);
	rez ~= sh1c(shCpp, "p2", dict);
	rez ~= sh1c(shCpp, "pe", dict);
	rez ~= funDlang;
	return rez;
}
// __________________________________________________________________
// Генерирует функцию D для QString ...
string[] genFunDlang3(string rawFun, int nomFunQtE, int nppLine, string nameClassCpp) {
	// writeln( `genFunDlang("`, rawFun, `", `,  nomFunQtE, `, `, nppLine, `, "`, nameClassCpp, `"`);
	string[] rez;
	string typeRet, nameFun, argsFun1;
	string[] mas1 = split(rawFun, '|');
	typeRet = mas1[0]; nameFun = mas1[1]; argsFun1 = mas1[2];
	string[string] dict;

	// Шаблон для генерации функции на Dlang
	string shDlang1 =
`
zgl|// _________________________ [[NPP_LINE]] -- [[RAW_FUN]]
zg1|[[NAME_CLASS]] [[NAME_FUN]](T)(T [[NAME_ARG1]]) {
zg2|[[NAME_CLASS]] [[NAME_FUN]](string [[NAME_ARG1]]) {
zg3|[[NAME_CLASS]] [[NAME_FUN]](QString [[NAME_ARG1]]) {
cs1|    (cast(t_i__qp_i_qp_qp_i) pFunQt[ [[NOM_FUN]] ])(QtObj, 0, qsOut.QtObj, sQString(to!string([[NAME_ARG1]])).QtObj, [[NPP_LINE]]);
cs2|    (cast(t_i__qp_i_qp_qp_i) pFunQt[ [[NOM_FUN]] ])(QtObj, 0, qsOut.QtObj, sQString([[NAME_ARG1]]).QtObj, [[NPP_LINE]]);
cs3|    (cast(t_i__qp_i_qp_qp_i) pFunQt[ [[NOM_FUN]] ])(QtObj, 0, qsOut.QtObj, [[NAME_ARG1]].QtObj, [[NPP_LINE]]);
st_|    sQString qsOut = sQString("");
ob_|    QString qsOut = new QString("");
re1|    return this;
zsk|}
zg4|@property T [[NAME_FUN]](T)() {
zg5|@property string [[NAME_FUN]]() {
zg6|@property T [[NAME_FUN]](T: QString)() {
si1|    (cast(t_i__qp_i_qp_qp_i) pFunQt[ [[NOM_FUN]] ])(QtObj, 0, qsOut.QtObj, null, [[NPP_LINE]]);
rt1|    return to!T(qsOut.String);
rt2|    return qsOut.String;
rt3|    return qsOut;
zg7|@property [[TYPE_RET]] [[NAME_FUN]](T)(T [[NAME_ARG1]]) {
zg8|@property [[TYPE_RET]] [[NAME_FUN]](string [[NAME_ARG1]]) {
zg9|@property [[TYPE_RET]] [[NAME_FUN]](QString [[NAME_ARG1]]) {
rt4|    return (cast(t_i__qp_i_qp_qp_i) pFunQt[ [[NOM_FUN]] ])(QtObj, 0, qsOut.QtObj, sQString(to!string([[NAME_ARG1]])).QtObj, [[NPP_LINE]]);
rt5|    return (cast(t_i__qp_i_qp_qp_i) pFunQt[ [[NOM_FUN]] ])(QtObj, 0, qsOut.QtObj, sQString([[NAME_ARG1]]).QtObj, [[NPP_LINE]]);
rt6|    return (cast(t_i__qp_i_qp_qp_i) pFunQt[ [[NOM_FUN]] ])(QtObj, 0, qsOut.QtObj, [[NAME_ARG1]].QtObj, [[NPP_LINE]]);
z10|@property T [[NAME_FUN]](T)([[TYPE_ARG1]] [[NAME_ARG1]]) {
z11|@property string [[NAME_FUN]]([[TYPE_ARG1]] [[NAME_ARG1]]) {
z12|@property T [[NAME_FUN]](T: QString)([[TYPE_ARG1]] [[NAME_ARG1]]) {
cs4|    (cast(t_i__qp_i_qp_qp_i) pFunQt[ [[NOM_FUN]] ])(QtObj, [[NAME_ARG1]], qsOut.QtObj, null, [[NPP_LINE]]);
rt7|    return cast([[TYPE_RET]])(cast(t_i__qp_i_qp_qp_i) pFunQt[ [[NOM_FUN]] ])(QtObj, 0, qsOut.QtObj, sQString(to!string([[NAME_ARG1]])).QtObj, [[NPP_LINE]]);
rt8|    return cast([[TYPE_RET]])(cast(t_i__qp_i_qp_qp_i) pFunQt[ [[NOM_FUN]] ])(QtObj, 0, qsOut.QtObj, sQString([[NAME_ARG1]]).QtObj, [[NPP_LINE]]);
rt9|    return cast([[TYPE_RET]])(cast(t_i__qp_i_qp_qp_i) pFunQt[ [[NOM_FUN]] ])(QtObj, 0, qsOut.QtObj, [[NAME_ARG1]].QtObj, [[NPP_LINE]]);
cs5|    (cast(t_i__qp_i_qp_qp_i) pFunQt[ [[NOM_FUN]] ])(QtObj, cast(int)[[NAME_ARG1]], qsOut.QtObj, null, [[NPP_LINE]]);
z13|@property string [[NAME_FUN]](T)(T [[NAME_ARG1]]) {
z14|@property string [[NAME_FUN]](string [[NAME_ARG1]]) {
z15|@property string [[NAME_FUN]](QString [[NAME_ARG1]]) {
z16|@property T2 [[NAME_FUN]](T2: QString, T)(T [[NAME_ARG1]]) {
z17|@property T2 [[NAME_FUN]](T2: QString)(string [[NAME_ARG1]]) {
z18|@property T2 [[NAME_FUN]](T2: QString)(QString [[NAME_ARG1]]) {
`;

	dict["RAW_FUN"]  = rawFun;
	dict["NPP_LINE"] = to!string(nppLine);
	dict["NAME_FUN"] = nameFun;
	dict["NAME_CLASS"] = nameClassCpp;
	dict["TYPE_RET"] = typeRet;
	dict["NOM_FUN"] = to!string(nomFunQtE);

	rez ~= sh1c(shDlang1, "zgl", dict);
	if(detectTypeArg(typeRet) == TypeArg.Int) {
		if(argsFun1 == "") {
			rez ~= sh1c(shDlang1, "vbu", dict);
			rez ~= sh1c(shDlang1, "li0", dict);
		} else {
			string[] masArg = split(argsFun1, '%');
			dict["TYPE_ARG1"] = masArg[0];
			dict["NAME_ARG1"] = masArg[1];
			if(detectTypeArg(masArg[0]) == TypeArg.QString) {
				string[] list = ["zg7","st_","rt4","zsk",   "zg8","st_","rt5","zsk",   "zg9","st_","rt6","zsk"];
				foreach(s; list) rez ~= sh1c(shDlang1, s, dict);
			}
		}
	}
	if(detectTypeArg(typeRet) == TypeArg.Bool) {
		if(argsFun1 == "") {
			rez ~= sh1c(shDlang1, "vbu", dict);
			rez ~= sh1c(shDlang1, "ll0", dict);
		} else {
			string[] masArg = split(argsFun1, '%');
			dict["TYPE_ARG1"] = masArg[0];
			dict["NAME_ARG1"] = masArg[1];
			if(detectTypeArg(masArg[0]) == TypeArg.QString) {
				string[] list = ["zg7","st_","rt7","zsk",   "zg8","st_","rt8","zsk",   "zg9","st_","rt9","zsk"];
				foreach(s; list) rez ~= sh1c(shDlang1, s, dict);
			}
		}
	}
	if(detectTypeArg(typeRet) == TypeArg.Void) {
		if(argsFun1 == "") {
			rez ~= sh1c(shDlang1, "vbc", dict);
			rez ~= sh1c(shDlang1, "llv", dict);
			rez ~= sh1c(shDlang1, "ret", dict);
		} else {
			string[] masArg = split(argsFun1, '%');
			dict["TYPE_ARG1"] = masArg[0];
			dict["NAME_ARG1"] = masArg[1];
			if(detectTypeArg(masArg[0]) == TypeArg.QString) {
				string[] list = ["zg1","st_","cs1","re1","zsk",   "zg2","st_","cs2","re1","zsk",   "zg3","st_","cs3","re1","zsk"];
				foreach(s; list) rez ~= sh1c(shDlang1, s, dict);
			}
		}
	}
	if(detectTypeArg(typeRet) == TypeArg.Enum) {
		if(argsFun1 == "") {
			rez ~= sh1c(shDlang1, "vbu", dict);
			rez ~= sh1c(shDlang1, "le0", dict);
		} else {
			string[] masArg = split(argsFun1, '%');
			dict["TYPE_ARG1"] = masArg[0];
			dict["NAME_ARG1"] = masArg[1];
			if(detectTypeArg(masArg[0]) == TypeArg.QString) {
				string[] list = ["zg7","st_","rt7","zsk",   "zg8","st_","rt8","zsk",   "zg9","st_","rt9","zsk"];
				foreach(s; list) rez ~= sh1c(shDlang1, s, dict);
			}
		}
	}
	if(detectTypeArg(typeRet) == TypeArg.QString) {
		if(argsFun1 == "") {
			string[] list = ["zg4","st_","si1","rt1","zsk",   "zg5","st_","si1","rt2","zsk",   "zg6","ob_","si1","rt3","zsk"];
			foreach(s; list) rez ~= sh1c(shDlang1, s, dict);
		} else {
			string[] masArg = split(argsFun1, '%');
			dict["TYPE_ARG1"] = masArg[0];
			dict["NAME_ARG1"] = masArg[1];
			if(detectTypeArg(masArg[0]) == TypeArg.Int) {
				string[] list = ["z10","st_","cs4","rt1","zsk",   "z11","st_","cs4","rt2","zsk",   "z12","ob_","cs4","rt3","zsk"];
				foreach(s; list) rez ~= sh1c(shDlang1, s, dict);
			}
			if(detectTypeArg(masArg[0]) == TypeArg.Bool) {
				string[] list = ["z10","st_","cs5","rt1","zsk",   "z11","st_","cs5","rt2","zsk",   "z12","ob_","cs5","rt3","zsk"];
				foreach(s; list) rez ~= sh1c(shDlang1, s, dict);
			}
			if(detectTypeArg(masArg[0]) == TypeArg.Enum) {
				string[] list = ["z10","st_","cs5","rt1","zsk",   "z11","st_","cs5","rt2","zsk",   "z12","ob_","cs5","rt3","zsk"];
				foreach(s; list) rez ~= sh1c(shDlang1, s, dict);
			}
			if(detectTypeArg(masArg[0]) == TypeArg.QString) {
				string[] list = [
					"z13","st_","cs1","rt2","zsk",   "z14","st_","cs2","rt2","zsk",   "z15","st_","cs3","rt2","zsk",
					"z16","ob_","cs1","rt3","zsk",   "z17","ob_","cs2","rt3","zsk",   "z18","ob_","cs3","rt3","zsk"
				];
				foreach(s; list) rez ~= sh1c(shDlang1, s, dict);
			}
		}
	}
	// writeln(rez[2]);
	string[] rezOk;
	foreach(line; rez) {
		if(line.strip() == "") continue;
		rezOk ~= line;
	}
	return rezOk;
}


/*
// __________________________________________________________________
// Набор №4 = На выходе int|bool|Xxx::Yyy,int|bool|Xxx::Yyy|QString%myInt|void  на входе 1 int|cornerWidget|Qt::Corner%corner|QString%myInt
string n4__void_int_bool__1_int_bool_qs(string astr) {
	if(strip(astr) == "") return astr;
	auto setRet1 = [TypeArg.Int: true, TypeArg.Bool: true, TypeArg.Void: true, TypeArg.Enum: true];
	auto setArg1 = [TypeArg.Int: true, TypeArg.Bool: true, TypeArg.Enum: true];
	bool fIsQsRet, fIsQsArg1, fIsQsArg2;
	writeln("---0---", astr);

	string typeRet, nameFun, argsFun1, argsFun2;
	{
		string[] mas1 = split(astr, '|');
		writeln("---0--- mas1.length = ", mas1.length);
		if(mas1.length != 3) return astr;       // Нет нужного количества аргументов
		typeRet = mas1[0];
		if(!typeRet.length)  return astr;       // Нет возвращаемого значения
		nameFun  = mas1[1];
		if(!isLetters1251E(nameFun[0])) return astr; // Имя функции не определено
		argsFun1 = mas1[2];
		argsFun2 = mas1[3];
	}
	string[] mas1 = split(argsFun1, '%');
	string[] mas2 = split(argsFun2, '%');
	// Здесь имеем: typeRet, nameFun, argsFun1, argsFun2
	TypeArg typeTRet = detectTypeArg(typeRet);
	TypeArg typeArg1 = detectTypeArg(mas1[0]);
	TypeArg typeArg2 = detectTypeArg(mas2[0]);
	
	writeln("---1---", typeTRet);
	
	if(typeTRet !in setRet1) {
		// Это не обычный возврат, а может это QString
		if(typeTRet == TypeArg.QString) {
			fIsQsRet = true;
		} else {
			// Нет смысла продолжать, возвращаемый тип непонятен
			return astr; // Это что то непонятное
		}
	}
	// С выходным типом разобрались ...
	writeln("---2---", astr);

	// Посмотрим на первый аргумент
	if(typeArg1 !in setArg1) {
		// А может это QString? ...
		if(typeArg1 == TypeArg.QString) {
			// Ok - this is QString
			fIsQsArg1 = true;
		} else {
			// Первый аргумент не подпадает по нужный формат
			return astr; // Это что то непонятное
		}
	}
	writeln("---3---", astr);

	// Посмотрим на второй аргумент
	if(typeArg2 !in setArg1) {
		// А может это QString? ...
		if(typeArg2 == TypeArg.QString) {
			// Ok - this is QString
			fIsQsArg2 = true;
		} else {
			// Второй аргумент не подпадает под нужный формат
			return astr; // Это что то непонятное
		}
	}
	writeln("---4---", astr);

	// Проверим на задвояемость QString
	if(fIsQsArg1 && fIsQsArg2) {
		writeln("---5---", astr);
		// Задвоенные, такой вариант не подойдет
		return astr; // Это что то непонятное
	}
	writeln("---6---", astr);
	
	// Хорошо, если мы тут то все типы нормальные, задвоенных нет, всё Ок
	return "4~" ~ astr;
}

unittest {
	assert(lib56.n4__void_int_bool__1_int_bool_qs("void|accessibleName|QString%name")      == "4~void|accessibleName|QString%name|int%r");
	assert(lib56.n4__void_int_bool__1_int_bool_qs("int|accessibleName|QString%name")       == "4~int|accessibleName|QString%name");

	assert(lib56.n4__void_int_bool__1_int_bool_qs("QString|accessibleName|int%r")          == "4~QString|accessibleName|int%r");
	
	assert(lib56.n4__void_int_bool__1_int_bool_qs("QString|accessibleName|")   == "3~QString|accessibleName|QString%name|int%r");

	assert(lib56.n4__void_int_bool__1_int_bool_qs("QString|accessibleName|QString%name|QString%name2")   == "QString|accessibleName|QString%name|QString%name2");

}
*/