module qte5prs;

import asc1251 : fromUtf8to1251;
import std.string : translate, split, strip, indexOf, toLower;
private import std.stdio : File, writeln, readln;

// Должен быть объект, получающий на вход строку. Строка раскладываается
// на состовные слова и запоминается в поисковике. Список слов может
// быть найден (выдан) по входной последовательности

// ==================================================================
// CFinder - поисковик
// ==================================================================
// __________________________________________________________________

struct s2 {
	string c;  // class
	string p;  // parent
}

class CFinder { //=> Поисковик. Помнит все слова в файле
	// ______________________________________________________________
	this() {
	}
	// ______________________________________________________________
	~this() {
	}
	// ______________________________________________________________
	private struct fNode { //-> Узел списка гирлянды
		string 		str;		// Строка (слово)
		//-----------------
		un	 		link;		// Указатель на следующий или null
	}
	alias fNode* un; // Ссылка на узел цепочки

	private struct fMetod { //-> Узел списка метода
		string name;			// Имя самого  метода
		string rawStr;			// Исходная строка описания
		//-----------------
		uc	 	link;			// Указатель на следующий или null
	}
	alias fMetod* um; // Ссылка на узел цепочки

	private struct fClass { //-> Узел списка гирлянды для класса
		string name;			// Имя самого класса
		string rawStr;			// Исходная строка описания
		uc		parent;			// Указатель на родителя или null
		//-----------------
		uc	 	link;			// Указатель на следующий или null
	}
	alias fClass* uc; // Ссылка на узел цепочки класса
	// ______________________________________________________________
	void printUc() {
		uc nod = trapClass;
		while(nod !is null) {
			writeln(nod," --> [", nod.name, "]");
			nod = nod.link;
		}
		nod = findClass("QFrame");
		writeln("QFrame.Parent = ", nod.parent.name);
		writeln(nod.rawStr);
	}
	// ______________________________________________________________
	uc findClass(string nameClass) { //-> Найти или добавить класс
		uc nod = trapClass;
m1:		if(nod is null) {
			nod = new fClass;  nod.name = nameClass; 
			nod.link = trapClass; trapClass = nod;
			// writeln("add: ", nameClass);
			return nod;
		} else {
			while(nod !is null) {
				// writeln("compare: ", nameClass, " == ", nod.name);
				if(nod.name == nameClass) { return nod; } 
				else { nod = nod.link; }
			}
		}
		if(nod is null) goto m1;
		return nod;
	}
	// ______________________________________________________________
	// Получает на вход Класс:Родитель и ИсходнаяСтрокаКласса и сохраняет в цепочке классов
	uc insertClassParent(s2 cp, string rewStr) { //-> Вставить в цепочку классов Класс:Родитель+ИсхСтрока
		// 1 - Разобраться с Parent
		uc uparent, uclass;
		if(cp.p != "") uparent = findClass(cp.p);
		if(cp.c == "") return null;
		uclass = findClass(cp.c);
		uclass.name = cp.c; uclass.rawStr = rewStr; uclass.parent = uparent;
		return uclass;
	}
	// ______________________________________________________________
	private un[256] harrow; 	//-> гребенка, для 256 списков слов
	dchar[dchar] transTable1;
	un[]  masAllWords;			// Список указателей на все слова
	uc    trapClass;			// Базовый якорь для цепочки Классов
	// ______________________________________________________________
	ubyte getC0(string s) { //-> Выдать индекс в гребенке
		import std.utf: stride;
		if(s.length == 0) return 0;
		char[] w1251 = fromUtf8to1251(cast(char[])s[0..stride(s, 0)]);
		return w1251[0];
	}
	// ______________________________________________________________
	void addWord(string w) { //-> Добавить слово в список, если его нет
		if(w.length == 0) return;
		ubyte c0;
		if(!isWordMono(w)) {
			c0 = getC0(w);	// Первая буква слова, как индекс цепочки в harrow
			// Создадим узел цепочки (списка)
			un nod = new fNode;  nod.str = w;
			masAllWords ~= nod;		// Запомним это слово в полном списке слов
			nod.link = harrow[c0];	// Вставим новый узел в цепочку
			harrow[getC0(w)] = nod;	// Подвесим обновленную цепочку
/* 			
			// Надо идти по цепочке и удалять все производные слова
			int dlw = w.length, dln;
			un ukaz  = nod, ukaz0 = ukaz;
			while(!(ukaz is null)) {
				dln = ukaz.str.length;
				if(dln < dlw) {
					// Найденное слово короче вставленного слова
					if(w[0 .. dln] == ukaz.str) {
						// Удаляем этот элемент
						ukaz0.link = ukaz.link; delete ukaz;
						if( !(ukaz0.link is null) ) { ukaz = ukaz0.link; }
						else { break; }
					}
				}
				ukaz0 = ukaz; ukaz = ukaz.link;
			}
			
 */			
			
		} 
	}
	// ______________________________________________________________
	bool isWordMono(string w) { //-> Есть целое слово в списке?
		size_t dlw, dln;
		bool rez; ubyte ind = getC0(w); un ukaz = harrow[ind];
		dlw = w.length;
		while(!(ukaz is null)) {
			dln = ukaz.str.length;
			if(dln == dlw) {
				if(ukaz.str == w) {
					rez = true; break;
				}
			}
			ukaz = ukaz.link;
		}
		return rez;
	}
	// ______________________________________________________________
	bool isWord(string w) { //-> Есть целое слово или производные в списке?
		size_t dlw, dln;
		bool rez; ubyte ind = getC0(w); un ukaz = harrow[ind];
		dlw = w.length;
		while(!(ukaz is null)) {
			dln = ukaz.str.length;
			if(dln >= dlw) {
				if(ukaz.str[0 .. dlw] == w) {
					rez = true; break;
				}
			}
			ukaz = ukaz.link;
		}
		return rez;
	}
	// ______________________________________________________________
	string[] getSubFromAll(string w) { //-> Выдать массив похожих слов из общего хранилища 
		string[] rez;
		string sh = toLower(w);
		foreach(el; masAllWords) {
			string wrd = toLower(el.str);
			if(indexOf(wrd, sh) >= 0) rez ~= el.str;
		}
		return rez;
	}
	// ______________________________________________________________
	string[] getEq(string w) { //-> Выдать массив похожих слов из хранилища 
		string[] rez; size_t dlw, dln;
		if(w.length == 0) return rez;
		ubyte ind = getC0(w); un ukaz = harrow[ind];
		while(!(ukaz is null)) {
			dlw = w.length; dln = ukaz.str.length;
			if(dln >= dlw) { if(ukaz.str[0 .. dlw] == w) rez ~= ukaz.str; }
			ukaz = ukaz.link;
		}
		return rez;
	}
	// ______________________________________________________________
	void addLine(string line) { //-> Добавить строку в хранилище
		// import std.stdio;
		string clearLine = strip(line);
		if(clearLine == "") return;
		dchar[dchar] transTable = [
			'(':' ',
			')':' ',
			9:' ',
			'*':' ',
			';':' ',
			'.':' ',
			'[':' ',
			']':' ',
			',':' ',
			'"':' ',
			'!':' ',
			'/':' ',
			'=':' ',
			'\\':' ',
			':':' ',
			'@':' '
		];
		static import asc1251;
		string zish = translate(clearLine, transTable);
		auto ms = split(zish, ' ');
	try {
		foreach(i, string el; ms) {
			if(el == "") continue;
			// string z = cast(string)strip(el);
			if(el.length > 2) 	addWord(el);
			// Всё добавлено в список поиска, можно проверить на нужные
			// мне строки
			if((el == "class") && (i == 0)) {
				insertClassParent(nameClass(zish), strip(line.dup));
			}
			if(el == "->") {
				// writeln(i, " -- M-> ", asc1251.toCON(zish));
				// writeln(nameMethod(zish));
			}
		}
	} catch {
		// writeln("catch: ", line);
		// writeln("catch: ", ms);
	}
		
		
		// if( indexOf(line, "//->") > 0 ) { writeln(zish);
		// }
		// Есть:
		// Class : Parent
		// Method : Функция(арг, ...) { //-> Описание функции
	}
	// ______________________________________________________________
	s2 nameClass(string s) { //-> Промежуточная. Выдать имя класса и родителя из строки
		s2 rez;
		auto ms = split(s, ' ');
		string[] arg;
		foreach(i, string el; ms) {
			if(el == "") continue;
			arg ~= el; 
		}
		// arg --> очищенный массив строк
		if(arg[0] == "class") {
			if(arg.length == 1) return rez;
			if(arg.length == 2) { rez.c = arg[1]; rez.p = ""; return rez; }
			if(arg.length == 3) { rez.c = arg[1]; 
				if(arg[2] == "{") {
					rez.p = "";
				} else {
					rez.p = arg[2];
				}
				return rez; 
			}
			if(arg[3] == "{") { 	// class Name: Parent {
				rez.c = arg[1]; rez.p = arg[2];
			} else {
				if(arg[2] == "{") {	// class Name {
					rez.c = arg[1]; rez.p = "";
				}
			}
		}
		return rez;
	}
	// ______________________________________________________________
	string nameMethod(string s) { //-> Промежуточная. Выдать имя метода из строки
		string rez;
		auto ms = split(s, ' ');
		string[] arg;
		foreach(i, string el; ms) {
			if(el == "") continue;
			arg ~= el; 
		}
		rez = arg[1];
		return rez;
	}
	// ______________________________________________________________
	void addFile(string nameFile) { //-> Добавить файл в хранилище
		// writeln("parsing: ", nameFile);
		File fileSrc = File(nameFile, "r");
		int ks;
		try {
			foreach(line; fileSrc.byLine()) {
				try {
					// Проверка на BOM
					ks++;
					// if(ks++ == 0) if(line.length>2 && line[0]==239 && line[1]==187 && line[2]==191) line = line[3 .. $].dup;
					addLine(cast(string)line);
				} catch {
					writeln("Warning! Error parsing string: [", cast(string)strip(line), "]");
				}
			}
		} catch {
			writeln("Error read file: ", nameFile);
			readln();
		}
	}
}

unittest {
	CFinder finder1 = new CFinder(); 
	bool b1;

	// Проверка работы поиска слов
	finder1.addWord("Gena"); 
	b1 = finder1.isWordMono("Gena");	assert(b1 == true);
	b1 = finder1.isWordMono("gena");	assert(b1 == false);
	b1 = finder1.isWord("Gen");			assert(b1 == true);
	b1 = finder1.isWord("gen");			assert(b1 == false);

	string[] m;
	m = finder1.getEq("Gen");	assert(m == ["Gena"]);
	m = finder1.getEq("gen");	assert(m == []);
	m = finder1.getSubFromAll("Gen");	assert(m == ["Gena"]);
	m = finder1.getSubFromAll("gen");	assert(m == ["Gena"]);
	m = finder1.getSubFromAll("len");	assert(m == []);

	// Проверяем работу с Классами
	CFinder.uc adr;
	adr = finder1.findClass("CTest1");	assert(adr.name == "CTest1");
}