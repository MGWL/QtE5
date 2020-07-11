import std.stdio;
import qte5;				// Графическая библиотека QtE5
import core.runtime;		// Обработка входных параметров

const strRed   = "background: red";

void main(string[] ards) {
	string s = 
`<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=Utf-8">
</head>
<body>
<h2>При контроле эхо - методом измеряют следующие характеристики несплошности (выберите наиболее полный ответ):</h2>
<hr>
<h3>1) глубину расположения;</h3>
<h3>2) координаты, эквивалентные и условные размеры;</h3>
<h3>3) амплитуду эхосигнала;</h3>
<h3>4)  местоположение несплошности относительно начала координат.</h3>
</body>
</html>`;
	bool fDebug = true; 
	if (1 == LoadQt(dll.QtE5Widgets, fDebug)) return;
	QApplication app = new QApplication(&Runtime.cArgs.argc, Runtime.cArgs.argv, 1);
	// ---- код программы
	QTextEdit asa = new QTextEdit(null);
	asa.setHtml(s);
	asa.show();
	asa.setReadOnly(true);
// 	writeln("--->", asa.parentQtObj());
// 	writeln("===>", asa.toPlainText!string());
// 	writeln("===>", asa.toHtml!string());
	// ----
	app.exec();
}