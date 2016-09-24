import std.process;
import std.stdio;
import qte5;				// Графическая библиотека QtE5
import core.runtime;		// Обработка входных параметров

const strRed   = "background: red";

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


void main(string[] ards) {
	environment["LD_LIBRARY_PATH"] = ".";
	bool fDebug = true; 
	if (1 == LoadQt(dll.QtE5Widgets, fDebug)) return;
	QApplication app = new QApplication(&Runtime.cArgs.argc, Runtime.cArgs.argv, 1);
	// ---- код программы
	QLabel w1 = new QLabel(null); w1.saveThis(&w1);	w1.setText(sHtml);
	w1.show();
	// ----
	app.exec();
}
