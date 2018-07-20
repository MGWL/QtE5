/*
 20.07.2018 10:12 - секций/шаблонов + date
 07.07.2018 10:12 - Добавлен алгоритм секций/шаблонов
 19.03.2018 12:58 - Применен алгоритм Максима Шибнева для fromUtf8to1251 (3-x кратное ускорение)
 01.12.2017 17:57 - Темплате на toCON
 13.08.2017  6:32 - Проверка и ускорение cp1251 -- Utf-8 -- cp1251
 21.04.2016 18:13 - Проверка ИНН на корректность
 31.05.2014 7:36:58
 Add x64
 Repair LTrim and RTrim
 */
/*
 ё - 184  0451  d1-91
 Ё - 168  0401  d0-81
 » -      00BB
 « -      00AB
 */
module asc1251;

import std.ascii;
import std.conv;
import std.utf;
import std.datetime;
import std.string: split;


bool isDigit1251(char c)	pure nothrow { return (mm1251[c] & tDigit) != 0; }

bool isLower1251E(char c)	pure nothrow { return (mm1251[c] & tEl) != 0;    }

bool isUpper1251E(char c)	pure nothrow { return (mm1251[c] & tEu) != 0;    }

bool isLower1251R(char c)	pure nothrow { return (mm1251[c] & tRl) != 0;    }

bool isUpper1251R(char c)	pure nothrow { return (mm1251[c] & tRu) != 0;    }

bool isLetters1251E(char c)	pure nothrow { return (mm1251[c] & (tEu + tEl)) != 0; }

bool isLetters1251R(char c)	pure nothrow { return (mm1251[c] & (tRu + tRl)) != 0; }

bool isLetters1251(char c)	pure nothrow { return (mm1251[c] & (tRu + tRl + tEu + tEl)) != 0; }

bool isPrintLetters1251(char c) pure nothrow {	return (mm1251[c] & (tPrint)) != 0; }

unittest {
	foreach (char c; "0123456789")
		assert(asc1251.isDigit1251(c));
	foreach (char c; lowercase)
		assert(asc1251.isLower1251E(c));
	foreach (char c; uppercase)
		assert(asc1251.isUpper1251E(c));
	foreach (char c; lowercase1251R)
		assert(asc1251.isLower1251R(c));
	foreach (char c; uppercase1251R)
		assert(asc1251.isUpper1251R(c));
	foreach (char c; uppercase ~ lowercase)
		assert(asc1251.isLetters1251E(c));
	foreach (char c; uppercase1251R ~ lowercase1251R)
		assert(asc1251.isLetters1251R(c));
}

char[] LTrim1251(char[] str) {
	char[] rez;
	if (str.length == 0)
		return rez;
	for (auto i = 0; i < str.length; i++) {
		if (!isPrintLetters1251(str[i]))
			continue;
		rez = str[i .. $];
		break;
	}
	return rez;
}

char[] RTrim1251(char[] str) {
	char[] rez;
	if (str.length == 0)
		return rez;
	for (auto i = str.length; i != 0; i--) {
		if (!isPrintLetters1251(str[i - 1]))
			continue;
		rez = str[0 .. i];
		break;
	}
	return rez;
}

char[] Trim1251(char[] str) {
	return LTrim1251(RTrim1251(str));
}

unittest {
	assert(LTrim1251(cast(char[]) "") == cast(char[]) "");
	assert(RTrim1251(cast(char[]) "") == cast(char[]) "");
	assert(LTrim1251(cast(char[]) "   Hello  ") == cast(char[]) "Hello  ");
	assert(RTrim1251(cast(char[]) "   Hello  ") == cast(char[]) "   Hello");
	assert(LTrim1251(cast(char[]) "   " ~ uppercase1251R) == cast(char[]) uppercase1251R);
	assert(LTrim1251(cast(char[]) "   " ~ lowercase1251R) == cast(char[]) lowercase1251R);
	assert(RTrim1251(lowercase1251R ~ cast(char[]) "   ") == cast(char[]) lowercase1251R);
	assert(Trim1251(cast(char[]) "   " ~ "1234567890" ~ "\x0E\x0F") == cast(char[]) "1234567890");
	assert(LTrim1251(cast(char[]) " " ~ cast(char[]) "1") == cast(char[]) "1");
}

char toUpper1251(char c) {
	return isLower1251E(c) | isLower1251R(c) ? cast(char)(c - 32) : c;
}

char[] toUpper1251(char[] str) {
	char[] rez;
	foreach (char c; str) {
		rez ~= toUpper1251(c);
	}
	return rez;
}

char toLower1251(char c) {
	return isUpper1251E(c) | isUpper1251R(c) ? cast(char)(c + 32) : c;
}

char[] toLower1251(char[] str) {
	char[] rez;
	foreach (char c; str) {
		rez ~= toLower1251(c);
	}
	return rez;
}

char[] toFio1251(char[] str) {
	if (str.length == 0) {
		return str;
	} else {
		if (str.length == 1) {
			char[] rez;
			return rez ~= toUpper1251(str[0]);
		} else {
			return toUpper1251(str[0]) ~ toLower1251(str[1 .. $]);
		}
	}
}

unittest {
	assert(toUpper1251('a') == 'A');
	foreach (char c; lowercase)
		assert(toUpper1251(c) == std.ascii.toUpper(c));
	foreach (char c; lowercase1251R)
		assert(toUpper1251(c) == uppercase1251R[c - 224]);
	assert(toUpper1251(cast(char[]) "hello[23]") == "HELLO[23]");
	assert(toUpper1251(cast(char[]) "") == "");
	assert(toLower1251(cast(char[]) "17(HELLO)") == "17(hello)");
	assert(toFio1251(cast(char[]) "HELLO!!!") == "Hello!!!");
	assert(toFio1251(cast(char[]) "") == "");
	assert(toFio1251(cast(char[]) "a") == "A");
}

// Функция, возвращает подстроку используя разделитель.
char[] Split1251(char[] from, char rz, int poz) {
	char[] rez;
	int i, b, e, k;
	auto dLfrom = from.length;
	for (i = 0; i < dLfrom; i++) {
		if (from[i] == rz) {
			e = i;
			if (k == poz) {
				rez = from[b .. e]; // Есть начало и есть конец. Надо переписать
				return rez;
			} else {
				b = i + 1;
				k++;
			}
		}
	}
	if (poz == k)
		rez ~= from[b .. $];
	return rez;
}

unittest {
	assert(Split1251(cast(char[]) "ABC|DEF", '|', 0) == "ABC");
	assert(Split1251(cast(char[]) "ABC|DEF", '|', 1) == "DEF");
	assert(Split1251(cast(char[]) "ABC|DEF", '|', 2) == "");
	assert(Split1251(cast(char[]) "ABC|DEF", '#', 2) == "");
	assert(Split1251(cast(char[]) "ABC|DEF", '#', 0) == "ABC|DEF");
}
// Шифрация-Дешифрация осуществляется в том же буфере в Win-1251 и AsciiZ
// sh  - T - шифрация, F - дешифрция
// str - указатель на строку
void shifr(bool sh, char* str) {
	char ch;
	int z;

	if (sh) {
		z = -1;
	} else {
		z = +1;
	}
	for (char* i = str;; i++) {
		ch = *i;
		if (ch == 0)
			break;
		*i = cast(char)(ch + z);
	}
}
/* // Шифрует строки utf-8
 // T - зашифровать, F - расшифровать
 string shifr8(bool sh, string str) {
 string rez; ubyte b;
 if(str.length == 0) return rez;
 if(sh) {
 for(int i; i != str.length; i++) {
 b = cast(ubyte)str[i];
 if(b > 31) rez ~= "B" ~ (cast(char)(str[i]-1)); else rez ~= "A" ~ (cast(char)(str[i]+1));
 }
 }
 else {
 for(int i; i != str.length; i+=2) {
 b = cast(ubyte)str[i];
 if(b == 66) rez ~= (cast(char)(str[i+1]+1)); else rez ~= (cast(char)(str[i+1]-1));
 }
 }
 return rez;
 }
 */
 

string shifr8n(T)(bool sh, T inStr) {
	string rez;
	ubyte b;
	string str = cast(string) inStr;
	if (str.length == 0) return rez;
	if (sh) {
		for (int i; i != str.length; i++) {
			b = cast(ubyte) str[i];
			if (b > 31)
				rez ~= "B" ~ (cast(char)(str[i] - 1));
			else
				rez ~= "A" ~ (cast(char)(str[i] + 1));
		}
	} else {
		for (int i; i != str.length; i += 2) {
			b = cast(ubyte) str[i];
			if (b == 66)
				rez ~= (cast(char)(str[i + 1] + 1));
			else
				rez ~= (cast(char)(str[i + 1] - 1));
		}
	}
	return rez;
}

// Перевод русского текста в транслитерал. Алгортм из 1С 8.3
string translit(string s) {
	import std.string: replace;
	string str = s;
	str = str.replace("а","a");	str = str.replace("б","b");	str = str.replace("в","v");	str = str.replace("г","g");
	str = str.replace("д","d");	str = str.replace("е","e");	str = str.replace("ё","e");	str = str.replace("ж","zh");
	str = str.replace("з","z");	str = str.replace("и","i");	str = str.replace("к","k");	str = str.replace("л","l");
	str = str.replace("м","m");	str = str.replace("н","n");	str = str.replace("о","o");	str = str.replace("п","p");
	str = str.replace("р","r");	str = str.replace("с","s");	str = str.replace("т","t");	str = str.replace("у","u");
	str = str.replace("ф","f");	str = str.replace("х","h");	str = str.replace("ч","ch");	str = str.replace("ш","sh");
	str = str.replace("щ","sch");	str = str.replace("ъ","");	str = str.replace("ь","");	str = str.replace("э","e");
	str = str.replace("ю","yu");	str = str.replace("й","i");	str = str.replace("ц","c");	str = str.replace("я","ya");
	str = str.replace("ы","i");	str = str.replace("А","A");	str = str.replace("Б","B");	str = str.replace("В","V");
	str = str.replace("Г","G");	str = str.replace("Д","D");	str = str.replace("Е","E");	str = str.replace("Ё","E");
	str = str.replace("Ж","ZH");	str = str.replace("З","Z");	str = str.replace("И","I");	str = str.replace("К","K");
	str = str.replace("Л","L");	str = str.replace("М","M");	str = str.replace("Н","N");	str = str.replace("О","O");
	str = str.replace("П","P");	str = str.replace("Р","R");	str = str.replace("С","S");	str = str.replace("Т","T");
	str = str.replace("У","U");	str = str.replace("Ф","F");	str = str.replace("Х","H");	str = str.replace("Ч","CH");
	str = str.replace("Ш","SH");	str = str.replace("Щ","SCH");	str = str.replace("Ъ","");	str = str.replace("Ь","");
	str = str.replace("Ы","I");	str = str.replace("Ц","C");	str = str.replace("Э","E");	str = str.replace("Ю","YU");
	str = str.replace("Я","YA");	str = str.replace("Й","I");
	return str;
}

// На вход получаю строку вида "26.02.1916", а на выход отдаю тип Date
Date strToDate(string s) {
	int y, m, d;
	try {
		auto mm = split(s, "."); d = to!int(mm[0]); m = to!int(mm[1]); y = to!int(mm[2]);
	} catch(Throwable) {		d = 0; m = 0; y = 0;  	}
	return Date(y, m, d);
}

// Входит в временную зону T или нет F
// На вход 1 - контролирукмая дата, D1 и D2 - период действия D1+ и D2-
bool isSupport(string dk, string d1, string d2) {
	bool rez;
	if(d1.length == 0) 	return true;
	if(d2.length == 0) 	return true;
	Date ddk, dd1, dd2;	ddk = strToDate(dk);	 dd1 = strToDate(d1); dd2 = strToDate(d2);
	rez = (dd1 <= ddk) && (ddk < dd2);
	return rez;
}

// strShablon - Текст с использованием шаблонов и секций
// nameSection - Имя секции для отбора
// dict - Словарь замены
/*
string shablonHtmlFile = 
`
    head1|  [[zg2]]Вопрос №</td>
    head1|  [[zg2]]Количество выборов</td>
    head1|  [[zg2]]Средний % истинности</td>
    head1|  [[zg2]]Среднее время в Сек</td>
    head1| </tr>
 strTable| <tr align="center">
 strTable|  [[zg2]][[vprosN]]</td>
 strTable|  [[zg2]][[kolPoint]]</td>
 strTable|  [[zg2]][[sredProc]]</td>
 strTable|  [[zg2]][[sredSek]]</td>
 strTable| </tr>
   podval|</table>
   podval|</body>
   podval|</html>
`;
*/
string sh1c(string strShablon, string nameSection, string[string] dict) {
	import std.string: split, join, strip;
	string rez;
	// Проверки входных параметров
	if(strShablon == "") return rez;
	if(nameSection == "") return rez;
	// Разделение шаблона
	auto strSh2 = split(strShablon, "\n");
	string[] rez2;
	foreach(str; strSh2) {
		if(strip(str) == "") continue;
		auto fields = split(str, "|");
		string sek = strip(fields[0]); string nameField, strOut;
		if(sek == nameSection) {	
			string rez5; int iSost; char predCh = 0;
			foreach(ch; fields[1]) {
				if(iSost == 0) {	if(ch == '[') iSost = 1;
				} else {
					if(iSost == 1) { if(predCh == '[') 	iSost = 2; else	{ iSost = 0;  nameField = ""; }
					} else {
						if(iSost == 2) {	if(ch == ']') { { iSost = 0; nameField = ""; }
							} else {	iSost = 3;
							}
						} else {
							if(iSost == 3) {	if(ch == ']')  iSost = 4;
							} else {
								if(iSost == 4) { if(ch == ']')  iSost = 5; else { iSost = 0; nameField = ""; }
								} else {	if(iSost == 5) { if(ch == '[') iSost = 1; else { iSost = 0; } nameField = "";	}}
							}
						}
					}
				}
				if(iSost == 0) strOut ~= ch;
				if(iSost == 3) nameField ~= ch;
				if(iSost == 5) { auto p = (nameField in dict); if (p !is null) strOut ~= dict[nameField]; }
				predCh = ch;
			}
			rez2 ~= strOut;
		}
	}
	rez = join(rez2, "\n"); 	return rez;
}

// strShablon - Текст с использованием шаблонов и секций
// nameSection - Имя секции для отбора
// td - дата в виде строки, если пусто, то все строки входят
// dict - Словарь замены
/*
string shablonHtmlFile = 
`
    head1|01.01.2000|01.01.2900|  [[zg2]]Вопрос №</td>
    head1|01.01.2000|01.01.2900|  [[zg2]]Количество выборов</td>
    head1|01.01.2000|01.01.2900|  [[zg2]]Средний % истинности</td>
    head1|01.01.2030|01.01.2900|  [[zg2]]Среднее время в Сек</td>
    head1|01.01.2000|01.01.2900| </tr>
 strTable|01.01.2000|01.01.2900| <tr align="center">
 strTable|01.01.2000|01.01.2900|  [[zg2]][[vprosN]]</td>
 strTable|01.01.2000|01.01.2900|  [[zg2]][[kolPoint]]</td>
 strTable|01.01.2000|01.01.2900|  [[zg2]][[sredProc]]</td>
 strTable|01.01.2000|01.01.2900|  [[zg2]][[sredSek]]</td>
 strTable|01.01.2000|01.01.2900| </tr>
   podval|01.01.2000|01.01.2900|</table>
   podval|01.01.2000|01.01.2900|</body>
   podval|01.01.2000|01.01.2900|</html>
`;
*/
string shd1c(string strShablon, string nameSection, string td, string[string] dict) {
	import std.string: split, join, strip;
	string strip_td = strip(td);
	string rez;
	// Проверки входных параметров
	if(strShablon == "") return rez;
	if(nameSection == "") return rez;
	// Разделение шаблона
	auto strSh2 = split(strShablon, "\n");
	string[] rez2;
	foreach(str; strSh2) {
		if(strip(str) == "") continue;
		auto fields = split(str, "|");
		string sek = strip(fields[0]); string nameField, strOut;
		if(sek == nameSection) {	
			// Проверим дату вхождения
			if(strip_td != "") if( !isSupport(td, strip(fields[1]), strip(fields[2]))  ) { continue; }
			string rez5; int iSost; char predCh = 0;
			foreach(ch; fields[3]) {
				if(iSost == 0) {	if(ch == '[') iSost = 1;
				} else {
					if(iSost == 1) { if(predCh == '[') 	iSost = 2; else	{ iSost = 0;  nameField = ""; }
					} else {
						if(iSost == 2) {	if(ch == ']') { { iSost = 0; nameField = ""; }
							} else {	iSost = 3;
							}
						} else {
							if(iSost == 3) {	if(ch == ']')  iSost = 4;
							} else {
								if(iSost == 4) { if(ch == ']')  iSost = 5; else { iSost = 0; nameField = ""; }
								} else {	if(iSost == 5) { if(ch == '[') iSost = 1; else { iSost = 0; } nameField = "";	}}
							}
						}
					}
				}
				if(iSost == 0) strOut ~= ch;
				if(iSost == 3) nameField ~= ch;
				if(iSost == 5) { auto p = (nameField in dict); if (p !is null) strOut ~= dict[nameField]; }
				predCh = ch;
			}
			rez2 ~= strOut;
		}
	}
	rez = join(rez2, "\n"); 	return rez;
}

unittest {
	assert(translit("") == "");
	assert(translit("Иванова Мария Константиновна") == "Ivanova Mariya Konstantinovna");
	assert(translit("Иванова Мария Константиновна") == "Ivanova Mariya Konstantinovna");
	assert(translit("АБВГДЕЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯабвгдежзийклмнопрстуфхцчшщъыьэюя0123456789") 
	== "ABVGDEZHZIIKLMNOPRSTUFHCCHSHSCHIEYUYAabvgdezhziiklmnoprstufhcchshschieyuya0123456789");	
	assert(sh1c("s1|[[F]] [[I]]", "s1", ["F":"Иванова","I":"Мария"]) == "Иванова Мария");
}

// Проверка даты вида '27.12.2014' на корректность
// str = '27.12.2014'
// Return: T - коррктная дата
bool TestDate1251(char[] str) {
	bool rez = true;
	char[] s;
	char r = '.';
	if (str.length != 10)
		return false;
	s = Split1251(str, r, 0);
	if (s.length != 2)
		return false;
	else {
		if (!isDigit1251(s[0]) || !isDigit1251(s[1]))
			return false;
		int day = to!int(s);
		if (!(day > 0 && day < 32))
			return false;
	}
	s = Split1251(str, r, 1);
	if (s.length != 2)
		return false;
	else {
		if (!isDigit1251(s[0]) || !isDigit1251(s[1]))
			return false;
		int mes = to!int(s);
		if (!(mes > 0 && mes < 13))
			return false;
	}
	s = Split1251(str, r, 2);
	if (s.length != 4)
		return false;
	else {
		if (!isDigit1251(s[0]) || !isDigit1251(s[1]) || !isDigit1251(s[2]) || !isDigit1251(s[3]))
			return false;
		int yar = to!int(s);
		if (!(yar > 1900 && yar < 3000))
			return false;
	}
	return rez;
}

// Проверка на соответствие ФИО, 'Иванов А.Н.', 1 большая, остальные маленькие и в конце инициалы
bool isFioii1251(char[] str) {
	bool rez = true;
	bool b1 = true;
	bool b2 = true;
	if (str.length < 6)
		return false;
	if (!(isUpper1251E(str[0]) || isUpper1251R(str[0])))
		return false;
	if (!((str[$ - 1] == '.') && (str[$ - 3] == '.')))
		return false;
	if (!(isUpper1251E(str[$ - 2]) || isUpper1251R(str[$ - 2])))
		return false;
	if (!(isUpper1251E(str[$ - 4]) || isUpper1251R(str[$ - 4])))
		return false;
	if (!(str[$ - 5] == ' '))
		return false;
	if (str.length > 6)
	foreach (char c; str[1 .. $ - 6]) {
		if (!(isLower1251E(c) || isLower1251R(c)))
			return false;
	}
	return rez;
}

// Проверка на соответствие ФИО, 'Иванов', 1 большая, остальные маленькие
bool isFio1251(char[] str) {
	bool rez = true;
	bool b1 = true;
	bool b2 = true;
	if (str.length == 0)
		return false;
	if (!(isUpper1251E(str[0]) || isUpper1251R(str[0])))
		return false;
	foreach (char c; str[1 .. $]) {
		if (!(isLower1251E(c) || isLower1251R(c)))
			return false;
	}
	return rez;
}
// Проверка на соответствие 987, целое число
bool isInt1251(char[] str) {
	bool rez = true;
	bool b1 = true;
	bool b2 = true;
	if (str.length == 0)
		return false;
	foreach (char c; str[0 .. $]) {
		if (!isDigit(c))
			return false;
	}
	return rez;
}

unittest {
	assert(TestDate1251(cast(char[]) "12.10.1961") == true);
	assert(TestDate1251(cast(char[]) "10.10.161") == false);
	assert(TestDate1251(cast(char[]) "00.10.1621") == false);
	assert(TestDate1251(cast(char[]) "31.10.1621") == false);
	assert(TestDate1251(cast(char[]) "32.10.2001") == false);
	assert(TestDate1251(cast(char[]) "31.12.1621") == false);
	assert(TestDate1251(cast(char[]) "31.13.2621") == false);
	assert(TestDate1251(cast(char[]) "31.13.3001") == false);
	// ------------------
	assert(isFio1251(cast(char[]) "Gena") == true);
	assert(isFio1251(cast(char[]) "Ge na") == false);
	assert(isFio1251(cast(char[]) "\xC3\xE5\xED\xE0") == true);
	assert(isFio1251(cast(char[]) "GenA") == false);
	assert(isFio1251(cast(char[]) "\xC3\xE5\xED\xC0") == false);
}

// Проверка правильности ИНН string[10]
bool tstINN(string s) {
	string s1;
	bool rez;
	int[10] weights = [2, 4, 10, 3, 5, 9, 4, 6, 8, 0];
	int summ;
	
	if((s.length == 0) || (s.length > 10) ) return rez;
	foreach(ch; s) {
		if(!isDigit1251(ch)) return rez;
	}
	import std.string: format, strip;
	import std.conv: to;
	try {
		s1 = format("%.10s", to!long(strip(s)));
	} catch(Throwable) {
		return rez;			// Ошибка конвертации
	}
	if(s1 == "0000000000") return true;
	// Перебор цифр и вычисление суммы
	for(int i; i != 9; i++) {
		auto digit = s1[i] - 48; 
		summ += digit * weights[i];
	}
	auto ost = summ % 11;
	if (ost > 9) ost = ost % 10;
	if (ost == (s1[9] - 48)) rez = true;
	return rez;
}

unittest {
	assert(tstINN("") == false);
	assert(tstINN("0000000000") == true);
	assert(tstINN("0") == true);
	assert(tstINN("0000A00000") == false);
	assert(tstINN("+000000000") == false);
	assert(tstINN("9999999999") == false);
	assert(tstINN("05911013765") == false);

	assert(tstINN("5905033450") == true);
	assert(tstINN("5913001268") == true);
	assert(tstINN("6607000556") == true);
	assert(tstINN("5911013765") == true);
}

char[] from1251toUtf8(char[] str) pure nothrow @trusted {
	char[] rez;
	foreach (char c1; str) rez ~= mm1251_Utf8[c1];
	return rez;
}
string from1251toUtf8(T)(T str) pure nothrow {
	char[] rez; 
	foreach (char c1; cast(char[])str) rez ~= mm1251_Utf8[c1];
	return cast(string)rez;
}
T1 fromUtf8to1251(T1, T2)(T2 str) {
	return to!(T1)(fromUtf8to1251(to!(char[])(str)));
}

pragma(inline) size_t utf8Length(char[] src) pure nothrow @trusted {	size_t len; foreach (ref b; src) { if ((b & 0xC0) != 0x80) len++; } return len; }
char[] fromUtf8to1251(char[] str) pure
{
	if (str.length == 0) return str;

	auto ret = new char[str.utf8Length];
	//auto ret = new char[str.length * 4];
	//char prb;
	size_t srcPos;
	size_t dstPos;
	size_t id;

	while(srcPos < str.length) {
		id = stride(str, srcPos);
		switch (id) {
			case 1:
				ret[dstPos] = str[srcPos];
				break;
			case 2:
				switch (str[srcPos]) {
					case '\xD0':
						immutable prb = tbl_xD0[(str[srcPos + 1]) - 129];
						ret[dstPos] = ((prb == 0) ? '?' : prb);
						break;
					case '\xD1':
						immutable prb = tbl_xD1[(str[srcPos + 1]) - 128];
						ret[dstPos] = ((prb == 0) ? '2' : prb);
						break;
					case '\xD2':
						switch (str[srcPos + 1]) {
							case '\x91':
								ret[dstPos] = cast(char)180;
								break;
							case '\x90':
								ret[dstPos] = cast(char)165;
								break;
							default:
								ret[dstPos] = cast(char)7;
								break;
						}
						break;
					case '\xD3':
						break;
					case '\xC2':
						immutable prb = tbl_xC2[(str[srcPos + 1]) - 152];
						ret[dstPos] = ((prb == 0) ? '3' : prb);
						break;
					default:
						ret[dstPos] = '?';
						break;
				}
				break;
			case 3:
				if (str[srcPos] == '\xE2') {
					switch (str[srcPos + 1]) {
						case '\x80':
							immutable prb = tbl_x80[(str[srcPos + 2]) - 147];
							ret[dstPos] = ((prb == 0) ? '?' : prb);
							break;
						case '\x82':
							ret[dstPos] = ((str[srcPos + 2] == '\xAC') ? cast(char)136 : '?');
							break;
						case '\x84':
							switch (str[srcPos + 2]) {
								case '\x96':
									ret[dstPos] = (cast(char)185);
									break;
								case '\xA2':
									ret[dstPos] = (cast(char)153);
									break;
								default:
									ret[dstPos] = '?';
									break;
							}
							break;
						default:
							break;
					}
				}
				break;
			default: // 4, 5, 6
				break;
		} // switch (id)

		srcPos += id;
		dstPos++;
	}

	return ret;
}


unittest {
	assert(from1251toUtf8(cast(char[]) "\xC3\xE5\xED\xE0") == "Гена");
	assert(from1251toUtf8(cast(char[]) "Gena123") == "Gena123");

	assert(fromUtf8to1251(cast(char[]) "Гена") == "\xC3\xE5\xED\xE0");
	assert(fromUtf8to1251(cast(char[]) "Gena123") == "Gena123");
	char[] g = [ 'G', 'e', 'n', 'a', '1', '2', '3' ];
	assert(fromUtf8to1251!(char[])("Gena123") == g);
	assert(fromUtf8to1251!(char[])("Гена") == "\xC3\xE5\xED\xE0");

}

char[] from1251to866(char[] str) {
	if (str.length == 0) return str;
	size_t dlStr = str.length;
	auto ret = new char[dlStr];	for(int i; i != dlStr; i++) ret[i] = _1251_866[str[i]];
	return ret;
}

string toCON(T)(T s) {
	version (Windows) {
		return to!string(from1251to866(fromUtf8to1251(cast(char[]) s)));
	}
	version (linux) {
		return cast(string)s;
	}
	version (OSX) {
		return cast(string)s;
	}
}
string char1251toUtf8(char ch) {
	return mm1251_Utf8[ch];
}

private:

const int sByte = ubyte.max + 1;

const tBad = 0; // Бяка
const tDigit = 1; // Цифра
const tEl = 2; // Анг Маленькие
const tEu = 4; // Анг Большие
const tPrint = 8; // Печатные
const tRl = 16; // Рус Маленькие
const tRu = 32; // Рус Большие

private immutable char[][sByte]  mm1251_Utf8= [
	/* 0 */
	"\x00", /* 1 */ "\x01", /* 2 */ "\x02", /* 3 */ "\x03", /* 4 */ "\x04",/* 5 */
	"\x05", /* 6 */ "\x06", /* 7 */ "\x07", /* 8 */ "\x08", /* 9 */ "\x09",/* 10 */
	"\x0A", /* 11 */ "\x0B", /* 12 */ "\x0C", /* 13 */ "\x0D", /* 14 */ "\x0E",/* 15 */
	"\x0F", /* 16 */ "\x10", /* 17 */ "\x11", /* 18 */ "\x12", /* 19 */ "\x13",/* 20 */
	"\x14", /* 21 */ "\x15", /* 22 */ "\x16", /* 23 */ "\x17", /* 24 */ "\x18",/* 25 */
	"\x19", /* 26 */ "\x1A", /* 27 */ "\x1B", /* 28 */ "\x1C", /* 29 */ "\x1D",/* 30 */
	"\x1E", /* 31 */ "\x1F", /* 32 */ "\x20", /* 33 */ "\x21", /* 34 */ "\x22",/* 35 */
	"\x23", /* 36 */ "\x24", /* 37 */ "\x25", /* 38 */ "\x26", /* 39 */ "\x27",/* 40 */
	"\x28", /* 41 */ "\x29", /* 42 */ "\x2A", /* 43 */ "\x2B", /* 44 */ "\x2C",/* 45 */
	"\x2D", /* 46 */ "\x2E", /* 47 */ "\x2F", /* 48 */ "\x30", /* 49 */ "\x31",/* 50 */
	"\x32", /* 51 */ "\x33", /* 52 */ "\x34", /* 53 */ "\x35", /* 54 */ "\x36",/* 55 */
	"\x37", /* 56 */ "\x38", /* 57 */ "\x39", /* 58 */ "\x3A", /* 59 */ "\x3B",/* 60 */
	"\x3C", /* 61 */ "\x3D", /* 62 */ "\x3E", /* 63 */ "\x3F", /* 64 */ "\x40",/* 65 */
	"\x41", /* 66 */ "\x42", /* 67 */ "\x43", /* 68 */ "\x44", /* 69 */ "\x45",/* 70 */
	"\x46", /* 71 */ "\x47", /* 72 */ "\x48", /* 73 */ "\x49", /* 74 */ "\x4A",/* 75 */
	"\x4B", /* 76 */ "\x4C", /* 77 */ "\x4D", /* 78 */ "\x4E", /* 79 */ "\x4F",/* 80 */
	"\x50", /* 81 */ "\x51", /* 82 */ "\x52", /* 83 */ "\x53", /* 84 */ "\x54",/* 85 */
	"\x55", /* 86 */ "\x56", /* 87 */ "\x57", /* 88 */ "\x58", /* 89 */ "\x59",/* 90 */
	"\x5A", /* 91 */ "\x5B", /* 92 */ "\x5C", /* 93 */ "\x5D", /* 94 */ "\x5E",/* 95 */
	"\x5F", /* 96 */ "\x60", /* 97 */ "\x61", /* 98 */ "\x62", /* 99 */ "\x63",/* 100 */
	"\x64", /* 101 */ "\x65", /* 102 */ "\x66", /* 103 */ "\x67", /* 104 */ "\x68",/* 105 */
	"\x69", /* 106 */ "\x6A", /* 107 */ "\x6B", /* 108 */ "\x6C", /* 109 */ "\x6D",/* 110 */
	"\x6E", /* 111 */ "\x6F", /* 112 */ "\x70", /* 113 */ "\x71", /* 114 */ "\x72",/* 115 */
	"\x73", /* 116 */ "\x74", /* 117 */ "\x75", /* 118 */ "\x76", /* 119 */ "\x77",/* 120 */
	"\x78", /* 121 */ "\x79", /* 122 */ "\x7A", /* 123 */ "\x7B", /* 124 */ "\x7C",/* 125 */
	"\x7D", /* 126 */ "\x7E", /* 127 */ "\x7F", /* 128 */ "\xD0\x82", /* 129 */ "\xD0\x83",
	/* 130 */
	"\xE2\x80\x9A", /* 131 */ "\xD1\x93", /* 132 */ "\xE2\x80\x9E", /* 133 */ "\xE2\x80\xA6", /* 134 */ "\xE2\x80\xA0", /* 135 */ "\xE2\x80\xA1",
	/* 136 */
	"\xE2\x82\xAC", /* 137 */ "\xE2\x80\xB0", /* 138 */ "\xD0\x89", /* 139 */ "\xE2\x80\xB9", /* 140 */ "\xD0\x8A", /* 141 */ "\xD0\x8C",
	/* 142 */
	"\xD0\x8B", /* 143 */ "\xD0\x8F", /* 144 */ "\xD1\x92", /* 145 */ "\xE2\x80\x98", /* 146 */ "\xE2\x80\x99", /* 147 */ "\xE2\x80\x9C",
	/* 148 */
	"\xE2\x80\x9D", /* 149 */ "\xE2\x80\xA2", /* 150 */ "\xE2\x80\x93", /* 151 */ "\xE2\x80\x94", /* 152 */ "\xC2\x98", /* 153 */ "\xE2\x84\xA2",
	/* 154 */
	"\xD1\x99", /* 155 */ "\xE2\x80\xBA", /* 156 */ "\xD1\x9A", /* 157 */ "\xD1\x9C", /* 158 */ "\xD1\x9B", /* 159 */ "\xD1\x9F",
	/* 160 */
	"\xC2\xA0", /* 161 */ "\xD0\x8E", /* 162 */ "\xD1\x9E", /* 163 */ "\xD0\x88", /* 164 */ "\xC2\xA4", /* 165 */ "\xD2\x90",
	/* 166 */
	"\xC2\xA6", /* 167 */ "\xC2\xA7", /* 168 */ "\xD0\x81", /* 169 */ "\xC2\xA9", /* 170 */ "\xD0\x84", /* 171 */ "\xC2\xAB",
	/* 172 */
	"\xC2\xAC", /* 173 */ "\xC2\xAD", /* 174 */ "\xC2\xAE", /* 175 */ "\xD0\x87", /* 176 */ "\xC2\xB0", /* 177 */ "\xC2\xB1",
	/* 178 */
	"\xD0\x86", /* 179 */ "\xD1\x96", /* 180 */ "\xD2\x91", /* 181 */ "\xC2\xB5", /* 182 */ "\xC2\xB6", /* 183 */ "\xC2\xB7",
	/* 184 */
	"\xD1\x91", /* 185 */ "\xE2\x84\x96", /* 186 */ "\xD1\x94", /* 187 */ "\xC2\xBB", /* 188 */ "\xD1\x98", /* 189 */ "\xD0\x85",
	/* 190 */
	"\xD1\x95", /* 191 */ "\xD1\x97", /* 192 */ "\xD0\x90", /* 193 */ "\xD0\x91",/* 194 */
	"\xD0\x92", /* 195 */ "\xD0\x93", /* 196 */ "\xD0\x94", /* 197 */ "\xD0\x95",
	/* 198 */
	"\xD0\x96", /* 199 */ "\xD0\x97", /* 200 */ "\xD0\x98", /* 201 */ "\xD0\x99",/* 202 */
	"\xD0\x9A", /* 203 */ "\xD0\x9B", /* 204 */ "\xD0\x9C", /* 205 */ "\xD0\x9D",
	/* 206 */
	"\xD0\x9E", /* 207 */ "\xD0\x9F", /* 208 */ "\xD0\xA0", /* 209 */ "\xD0\xA1",/* 210 */
	"\xD0\xA2", /* 211 */ "\xD0\xA3", /* 212 */ "\xD0\xA4", /* 213 */ "\xD0\xA5",
	/* 214 */
	"\xD0\xA6", /* 215 */ "\xD0\xA7", /* 216 */ "\xD0\xA8", /* 217 */ "\xD0\xA9",/* 218 */
	"\xD0\xAA", /* 219 */ "\xD0\xAB", /* 220 */ "\xD0\xAC", /* 221 */ "\xD0\xAD",
	/* 222 */
	"\xD0\xAE", /* 223 */ "\xD0\xAF", /* 224 */ "\xD0\xB0", /* 225 */ "\xD0\xB1",/* 226 */
	"\xD0\xB2", /* 227 */ "\xD0\xB3", /* 228 */ "\xD0\xB4", /* 229 */ "\xD0\xB5",
	/* 230 */
	"\xD0\xB6", /* 231 */ "\xD0\xB7", /* 232 */ "\xD0\xB8", /* 233 */ "\xD0\xB9",/* 234 */
	"\xD0\xBA", /* 235 */ "\xD0\xBB", /* 236 */ "\xD0\xBC", /* 237 */ "\xD0\xBD",
	/* 238 */
	"\xD0\xBE", /* 239 */ "\xD0\xBF", /* 240 */ "\xD1\x80", /* 241 */ "\xD1\x81",/* 242 */
	"\xD1\x82", /* 243 */ "\xD1\x83", /* 244 */ "\xD1\x84", /* 245 */ "\xD1\x85",
	/* 246 */
	"\xD1\x86", /* 247 */ "\xD1\x87", /* 248 */ "\xD1\x88", /* 249 */ "\xD1\x89",/* 250 */
	"\xD1\x8A", /* 251 */ "\xD1\x8B", /* 252 */ "\xD1\x8C", /* 253 */ "\xD1\x8D",
	/* 254 */
	"\xD1\x8E", /* 255 */ "\xD1\x8F"
];

private immutable int[sByte]  mm1251= [/* 0 */
	tBad, /* 1 */ tBad, /* 2 */ tBad, /* 3 */ tBad, /* 4 */ tBad, /* 5 */ tBad, /* 6 */ tBad, /* 7 */ tBad, /* 8 */ tBad,
	/* 9 */
	tBad, /* 10 */ tBad, /* 11 */ tBad, /* 12 */ tBad, /* 13 */ tBad, /* 14 */ tBad, /* 15 */ tBad, /* 16 */ tBad, /* 17 */ tBad,
	/* 18 */
	tBad, /* 19 */ tBad, /* 20 */ tBad, /* 21 */ tBad, /* 22 */ tBad, /* 23 */ tBad, /* 24 */ tBad, /* 25 */ tBad, /* 26 */ tBad,
	/* 27 */
	tBad, /* 28 */ tBad, /* 29 */ tBad, /* 30 */ tBad, /* 31 */ tBad, /* 32 */ tBad, /* 33 */ tPrint, /* 34 */ tPrint, /* 35 */ tPrint,
	/* 36 */
	tPrint, /* 37 */ tPrint, /* 38 */ tPrint, /* 39 */ tPrint, /* 40 */ tPrint, /* 41 */ tPrint, /* 42 */ tPrint, /* 43 */ tPrint, /* 44 */ tPrint,
	/* 45 */
	tPrint, /* 46 */ tPrint, /* 47 */ tPrint, /* 48 */ tPrint + tDigit, /* 49 */ tPrint + tDigit, /* 50 */ tPrint + tDigit, /* 51 */ tPrint + tDigit,
	/* 52 */
	tPrint + tDigit, /* 53 */ tPrint + tDigit, /* 54 */ tPrint + tDigit, /* 55 */ tPrint + tDigit,
	/* 56 */
	tPrint + tDigit, /* 57 */ tPrint + tDigit, /* 58 */ tPrint, /* 59 */ tPrint, /* 60 */ tPrint, /* 61 */ tPrint,
	/* 62 */
	tPrint, /* 63 */ tPrint, /* 64 */ tPrint,/* 65 */
	tPrint + tEu, /* 66 */ tPrint + tEu, /* 67 */ tPrint + tEu, /* 68 */ tPrint + tEu, /* 69 */ tPrint + tEu, /* 70 */ tPrint + tEu,
	/* 71 */
	tPrint + tEu, /* 72 */ tPrint + tEu, /* 73 */ tPrint + tEu, /* 74 */ tPrint + tEu, /* 75 */ tPrint + tEu, /* 76 */ tPrint + tEu,
	/* 77 */
	tPrint + tEu, /* 78 */ tPrint + tEu, /* 79 */ tPrint + tEu, /* 80 */ tPrint + tEu, /* 81 */ tPrint + tEu, /* 82 */ tPrint + tEu,
	/* 83 */
	tPrint + tEu, /* 84 */ tPrint + tEu, /* 85 */ tPrint + tEu, /* 86 */ tPrint + tEu, /* 87 */ tPrint + tEu, /* 88 */ tPrint + tEu,
	/* 89 */
	tPrint + tEu, /* 90 */ tPrint + tEu,/* 91 */
	tPrint, /* 92 */ tPrint, /* 93 */ tPrint, /* 94 */ tPrint, /* 95 */ tPrint,
	/* 96 */
	tPrint,/* 97 */
	tPrint + tEl, /* 98 */ tPrint + tEl, /* 99 */ tPrint + tEl, /* 100 */ tPrint + tEl, /* 101 */ tPrint + tEl, /* 102 */ tPrint + tEl,
	/* 103 */
	tPrint + tEl, /* 104 */ tPrint + tEl, /* 105 */ tPrint + tEl, /* 106 */ tPrint + tEl, /* 107 */ tPrint + tEl, /* 108 */ tPrint + tEl,
	/* 109 */
	tPrint + tEl, /* 110 */ tPrint + tEl, /* 111 */ tPrint + tEl, /* 112 */ tPrint + tEl, /* 113 */ tPrint + tEl, /* 114 */ tPrint + tEl,
	/* 115 */
	tPrint + tEl, /* 116 */ tPrint + tEl, /* 117 */ tPrint + tEl, /* 118 */ tPrint + tEl, /* 119 */ tPrint + tEl, /* 120 */ tPrint + tEl,
	/* 121 */
	tPrint + tEl, /* 122 */ tPrint + tEl, /* 123 */ tPrint, /* 124 */ tPrint, /* 125 */ tPrint, /* 126 */ tPrint, /* 127 */ tPrint, /* 128 */ tPrint,
	/* 129 */
	tPrint,/* 130 */
	tPrint, /* 131 */ tPrint, /* 132 */ tPrint, /* 133 */ tPrint, /* 134 */ tPrint, /* 135 */ tPrint, /* 136 */ tPrint, /* 137 */ tPrint,/* 138 */
	tPrint, /* 139 */ tPrint, /* 140 */ tPrint, /* 141 */ tPrint, /* 142 */ tPrint, /* 143 */ tPrint, /* 144 */ tPrint, /* 145 */ tPrint,/* 146 */
	tPrint, /* 147 */ tPrint, /* 148 */ tPrint, /* 149 */ tPrint, /* 150 */ tPrint, /* 151 */ tPrint, /* 152 */ tPrint, /* 153 */ tPrint,/* 154 */
	tPrint, /* 155 */ tPrint, /* 156 */ tPrint, /* 157 */ tPrint, /* 158 */ tPrint, /* 159 */ tPrint, /* 160 */ tPrint, /* 161 */ tPrint,/* 162 */
	tPrint, /* 163 */ tPrint, /* 164 */ tPrint, /* 165 */ tPrint, /* 166 */ tPrint, /* 167 */ tPrint, /* 168 */ tPrint + tRu, /* 169 */ tPrint,
	/* 170 */
	tPrint, /* 171 */ tPrint, /* 172 */ tPrint, /* 173 */ tPrint, /* 174 */ tPrint, /* 175 */ tPrint, /* 176 */ tPrint, /* 177 */ tPrint,/* 178 */
	tPrint, /* 179 */ tPrint, /* 180 */ tPrint, /* 181 */ tPrint, /* 182 */ tPrint, /* 183 */ tPrint, /* 184 */ tPrint + tRl, /* 185 */ tPrint,
	/* 186 */
	tPrint, /* 187 */ tPrint, /* 188 */ tPrint, /* 189 */ tPrint, /* 190 */ tPrint, /* 191 */ tPrint, /* 192 */ tPrint + tRu,
	/* 193 */
	tPrint + tRu, /* 194 */ tPrint + tRu, /* 195 */ tPrint + tRu, /* 196 */ tPrint + tRu, /* 197 */ tPrint + tRu, /* 198 */ tPrint + tRu,
	/* 199 */
	tPrint + tRu, /* 200 */ tPrint + tRu, /* 201 */ tPrint + tRu, /* 202 */ tPrint + tRu, /* 203 */ tPrint + tRu, /* 204 */ tPrint + tRu,
	/* 205 */
	tPrint + tRu, /* 206 */ tPrint + tRu, /* 207 */ tPrint + tRu, /* 208 */ tPrint + tRu, /* 209 */ tPrint + tRu, /* 210 */ tPrint + tRu,
	/* 211 */
	tPrint + tRu, /* 212 */ tPrint + tRu, /* 213 */ tPrint + tRu, /* 214 */ tPrint + tRu, /* 215 */ tPrint + tRu, /* 216 */ tPrint + tRu,
	/* 217 */
	tPrint + tRu, /* 218 */ tPrint + tRu, /* 219 */ tPrint + tRu, /* 220 */ tPrint + tRu, /* 221 */ tPrint + tRu, /* 222 */ tPrint + tRu,
	/* 223 */
	tPrint + tRu, /* 224 */ tPrint + tRl, /* 225 */ tPrint + tRl, /* 226 */ tPrint + tRl, /* 227 */ tPrint + tRl, /* 228 */ tPrint + tRl,
	/* 229 */
	tPrint + tRl, /* 230 */ tPrint + tRl, /* 231 */ tPrint + tRl, /* 232 */ tPrint + tRl, /* 233 */ tPrint + tRl, /* 234 */ tPrint + tRl,
	/* 235 */
	tPrint + tRl, /* 236 */ tPrint + tRl, /* 237 */ tPrint + tRl, /* 238 */ tPrint + tRl, /* 239 */ tPrint + tRl, /* 240 */ tPrint + tRl,
	/* 241 */
	tPrint + tRl, /* 242 */ tPrint + tRl, /* 243 */ tPrint + tRl, /* 244 */ tPrint + tRl, /* 245 */ tPrint + tRl, /* 246 */ tPrint + tRl,
	/* 247 */
	tPrint + tRl, /* 248 */ tPrint + tRl, /* 249 */ tPrint + tRl, /* 250 */ tPrint + tRl, /* 251 */ tPrint + tRl, /* 252 */ tPrint + tRl,
	/* 253 */
	tPrint + tRl, /* 254 */ tPrint + tRl, /* 255 */ tPrint + tRl];

// char mm1251u[sByte];
private immutable uppercase1251R = "\xC0\xC1\xC2\xC3\xC4\xC5\xC6\xC7\xC8\xC9\xCA\xCB\xCC\xCD\xCE\xCF\xD0\xD1\xD2\xD3\xD4\xD5\xD6\xD7\xD8\xD9\xDA\xDB\xDC\xDD\xDE\xDF"; /// А..Я
private immutable lowercase1251R = "\xE0\xE1\xE2\xE3\xE4\xE5\xE6\xE7\xE8\xE9\xEA\xEB\xEC\xED\xEE\xEF\xF0\xF1\xF2\xF3\xF4\xF5\xF6\xF7\xF8\xF9\xFA\xFB\xFC\xFD\xFE\xFF"; /// А..Я
private immutable _1251_866 = "\x00\x01\x02\x03\x04\x05\x06\x07\x08\x09\x0A\x0B\x0C\x0D\x0E\x0F\x10\x11\x12\x13\x14\x15\x18\x19\x1A\x1B......\x20!\x22#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~.+++++++++++++++++++++++++++++++++++++++1\xF0345+++++++++++1\xF1\xFC++++++\x80\x81\x82\x83\x84\x85\x86\x87\x88\x89\x8A\x8B\x8C\x8D\x8E\x8F\x90\x91\x92\x93\x94\x95\x96\x97\x98\x99\x9A\x9B\x9C\x9D\x9E\x9F\xA0\xA1\xA2\xA3\xA4\xA5\xA6\xA7\xA8\xA9\xAA\xAB\xAC\xAD\xAE\xAF\xE0\xE1\xE2\xE3\xE4\xE5\xE6\xE7\xE8\xE9\xEA\xEB\xEC\xED\xEE\xEF";
private immutable char[62] tbl_xD1 = [
240,241,242,243,244,245,246,247,248,249,250,251,252,253,254,255,  0,184,144,131,186,190,
179,191,188,154,156,158,157,  0,162,159,  0,  0,210,211,212,213,214,215,216,217,218,219,
220,221,222,223,224,225,226,227,228,229,230,231,232,233,234,235,236,237
];
private immutable char[63] tbl_xD0 = [
168,128,129,170,189,178,175,163,138,140,142,141,  0,161,143,192,193,194,195,196,197,198,
199,200,201,202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219,220,
221,222,223,224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239
];
private immutable char[40] tbl_x80 = [
150,151,  0,  0,  0,145,146,130,  0,147,148,132,  0,134,135,149,  0,  0,  0,133,  0,  0,
  0,  0,  0,  0,  0,  0,  0,137,  0,  0,  0,  0,  0,  0,  0,  0,139,155
];
private immutable char[36] tbl_xC2 = [
152,  0,  0,  0,  0,  0,  0,  0,160,  0,  0,  0,164,  0,166,167,  0,169,  0,171,172,173,
174,  0,176,177,  0,  0,  0,181,182,183,  0,  0,  0,187
];

bool isAtr1251(char c, int atr) {
	return (mm1251[c] & atr) != 0;
}