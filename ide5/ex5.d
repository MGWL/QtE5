import qte5;
import core.runtime;     // Обработка входных параметров
import std.stdio;

// =================================================================
// Форма: Проверка QTextEdit
// =================================================================
extern (C) {
	void onKn1(CTest* uk) { (*uk).runKn1(); }
	void onKn2(CTest* uk) { (*uk).runKn2(); }
	void onD(CTest* uk, int n, int ab)   { (*uk).D(ab, n); }
	void onPaintWidget(CTest* uk, void* ev, void* qpaint)  { (*uk).runPaint(ev, qpaint); };
}

class CTest : QFrame {
	QVBoxLayout	vblAll;			// Общий вертикальный выравниватель
	QHBoxLayout	hb2;			// Горизонтальный выравниватель
	QTextEdit	edTextEdit;		// Сам редактор для проверки
	QPushButton kn1, kn2;
	QAction acKn1, acKn2, acDes1, acDes2;
	QLineEdit lineEdit;			// Строка строчного редактора
	QWidget view;
	QStatusBar stBar;
	QSpinBox wdPermInBar1;
	QImage im;
	QPoint pointer;
	// ______________________________________________________________
	// Конструктор по умолчанию
	this(QWidget parent, QtE.WindowType fl) { //-> Базовый конструктор
		super(parent, fl);
		// Горизонтальный и вертикальный выравниватели
		vblAll  = new  QVBoxLayout(null);		// Главный выравниватель
		hb2  	= new  QHBoxLayout(null);		// Горизонтальный выравниватель
		// Изготавливаем редактор
		edTextEdit = new QTextEdit(this);
		vblAll.addWidget(edTextEdit);
		lineEdit = new QLineEdit(this);  lineEdit.setNoDelete(true);
		lineEdit.setText("Привет ребята ...");
		lineEdit.setReadOnly(true);
		// Область изображения
		view = new QWidget(this); 
		view.setMinimumHeight(400); 
		// view.setStyleSheet("background: Red");

		// Статус Бар
		wdPermInBar1 = new QSpinBox(this); 
		wdPermInBar1.setStyleSheet("background: cyan");
		wdPermInBar1.setMaximumWidth(70);
		wdPermInBar1.hide();
		stBar = new QStatusBar(this);  
		stBar.addPermanentWidget(wdPermInBar1, 120); // wdPermInBar1.show();
		// Кнопки
		kn1  = new QPushButton("Укажите имя файла:", this);
		kn2  = new QPushButton("Вторая кнопка",  this); 
		acKn1 = new QAction(this, &onKn1, aThis); connects(kn1, "clicked()", acKn1, "Slot()");
		acKn2 = new QAction(this, &onKn2, aThis); connects(kn2, "clicked()", acKn2, "Slot()");
		// Кнопки в выравниватель
		hb2.addWidget(kn1).addWidget(kn2);
		vblAll.addWidget(lineEdit).addWidget(view).addLayout(hb2).addWidget(stBar);
		resize(700, 500); setWindowTitle("Проверка QTextEdit");
		// Создадим QImage, файл будут предопределенный
		im = new QImage(300, 400, QImage.Format.Format_ARGB32_Premultiplied); 
		im.fill(QtE.GlobalColor.cyan);
		pointer = new QPoint(10, 10);

		for(int i; i != 90; i++) {
			im.setPixel(i, i, 0);//  
		}
		//  im.load("Lenna.ppm");
		// Паинт для VIEW  !!!, но сама обработка в CTest 
		//           ---- 
		view.setPaintEvent(&onPaintWidget, aThis());
 		   
		setLayout(vblAll);
	}
	// ______________________________________________________________
	// Перерисовать себя
	void runPaint(void* ev, void* qpaint) { //-> Перерисовка области
		QPainter qp = new QPainter('+', qpaint);
		// В полном размере
		qp.drawImage(pointer, im); // В полном размере
		// Масштабируем по размеру виджета
		// qp.drawImage(contentsRect(new QRect()), im);
		qp.end();
	}
 	// ______________________________________________________________
	void D(int ab, int n) {
		writeln(n, "--------------------------------D---------------------->", ab);
	}
	// ______________________________________________________________
	void runKn1() { //-> Обработка кнопки №1
		writeln("this is Button 1");
/* 
		// Запросить файл для редактирования и открыть редактор
		QFileDialog fileDlg = new QFileDialog('+', null);
		string cmd = fileDlg.getOpenFileNameSt("Open file ...", "", "*.d *.ini *.txt");
		if(cmd != "") { 
			lineEdit.setText(cmd); stBar.showMessage(cmd);
			wdPermInBar1.show();
		}
*/
		im.fill(new QColor(45678)); // Темно зеленый цвет 
		view.update();
	}
	// ______________________________________________________________
	void runKn2() { //-> Обработка кнопки №2
		writeln("this is Button 2");
		wdPermInBar1.hide();
		for(int i; i != 90; i++) {
			im.setPixel(i + 10, i, 0);  
		}
		writeln("height = ", im.height(), "   width = ", im.width());
		writeln("bitPlaneCount = ", im.bitPlaneCount());
		writeln("byteCount = ", im.byteCount());
		writeln("bytesPerLine = ", im.bytesPerLine());
		writeln("colorCount = ", im.colorCount());
		writeln("depth = ", im.depth());
		writeln("dotsPerMeterX = ", im.dotsPerMeterX(), "  dotsPerMeterY = ", im.dotsPerMeterY());
		// Проверим манипуляции с цветом
		QColor obc = new QColor(); obc.setRgb(121, 122, 123, 200);
		int r, g, b, a;
		obc.getRgb(&r, &g, &b, &a);
		writeln("rgba = ", r, " ", g, " ", b, " ", a);

		// В Qt обнаружился интересный формат QRgb = uint 
		// Выдаёт в uint - надо бы определить record удобный для работы 
		// с таким форматом   
		writeln(im.pixel(10, 10));
		// Под этот формат немного доработал QColor
		writeln( "obc.rgb() = ", obc.rgb() );
		// Можно установить цвет используя uint
		obc.setRgba(23456);  
		view.update();
		  
	}
	
}
// ____________________________________________________________________
int main(string[] args) {
	bool fDebug = true; if (1 == LoadQt(dll.QtE5Widgets, fDebug)) return 1;
	QApplication  app = new QApplication(&Runtime.cArgs.argc, Runtime.cArgs.argv, 1);
	
	CTest ct = new CTest(null, QtE.WindowType.Window); ct.show().saveThis(&ct);

	// QEndApplication endApp = new QEndApplication('+', app.QtObj);
	return app.exec();
}