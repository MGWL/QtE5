// Тестирование загрузки ресурсов 08/10/17
// ------------------------------
// dmd testres.d qte5.d asc1251
//
// Файл ресурсов: t.qrc
/*
<!DOCTYPE RCC><RCC version="1.0">
	<qresource>
		<file>ICONS/exit_icon.png</file>
		<file>ICONS/about_icon.png</file>
	</qresource>
	</RCC>
*/
// Компиляция ресурсов только rcc.exe Qt:
// rcc -binary t.qrc -o t.rcc
//
// Запуск программы:
// testres qt t.rcc

import std.stdio;
import qte5;				// Графическая библиотека QtE5
import core.runtime;		// Обработка входных параметров
import asc1251;
import std.file;

extern (C) {
	void  onPaintWidget(CView* uk, void* ev, void* qpaint)  { (*uk).runPaint(ev, qpaint); };
}
class CView : QWidget {
	QImage im;
	QPoint pointer;
	QPixmap pm1;

	this() {
		super(null);	resize(600, 250);
		pm1 = new QPixmap();
		pm1.load(":ICONS/exit_icon.png","PNG");
		setPaintEvent(&onPaintWidget, aThis());
	}
	// ______________________________________________________________
	// Перерисовать себя
	void runPaint(void* ev, void* qpaint) { //-> Перерисовка области
		QBitmap bm = new QBitmap(new QSize(pm1.width, pm1.height)); 
				bm.setNoDelete(true); // В Linux без этого валится ...
		bm.fill();

		QPainter qp2 = new QPainter(bm);
		qp2.setPen( new QPen(new QColor(QtE.GlobalColor.color1)) );
		QFont fnt = new QFont(); fnt.setPointSize(160); fnt.setBold(true);
		qp2.setFont( fnt );
		qp2.drawText(50, 150, "Привет из QtE5");
		qp2.end();
		
		pm1.setMask(bm);
		
		QPainter qp = new QPainter('+', qpaint);
		qp.drawPixmap(pm1,  0, 0, pm1.width, pm1.height);
		qp.end();
	}
}

void help() {
	writeln(toCON("Запуск: testres.exe qt|d имяФайлаРесурсов.rcc"));
}

int main(string[] ards) {
	bool fDebug = true; 
	if (1 == LoadQt(dll.QtE5Widgets, fDebug)) return 1;
	QApplication app = new QApplication(&Runtime.cArgs.argc, Runtime.cArgs.argv, 1);

	if(ards.length != 3) { help(); return 1; }
	QResource res = new QResource();
	bool r;
	try {
		switch(ards[1]) {
			case "qt":
				r = res.registerResource(ards[2]);
				break;
			case "d":
				auto data = cast(ubyte[]) read(ards[2]);
				r = res.registerResource(cast(ubyte*)data);
				break;
			default:
				help(); return 1;
		}
	} catch(Throwable) { help(); return 1; }
	if(!r) {
		writeln(toCON("Файл ресурсов загружен, но он кривой ...")); return 1;
	}
	CView widget = new CView(); widget.saveThis(&widget); widget.show();
	return app.exec();
}