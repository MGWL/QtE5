import std.stdio;
import qte5;				// Графическая библиотека QtE5
import core.runtime;		// Обработка входных параметров

extern (C) {
	void onWinClose(CMyWidget* uk, void* uc) {
		writeln("--1--", uk, "  ", uc);
		(*uk).runWinClose(uc);
	}
	void onMousePressEvent(CMyWidget* uk, void* uc) {
		writeln("--3--", uk, "  ", uc);
		(*uk).runMouseEvent(uc);
	}
	void onMouseReleaseEvent(CMyWidget* uk, void* uc) {
		writeln("--4--", uk, "  ", uc);
		(*uk).runMouseEvent2(uc);
	}
}

class CMyWidget : QWidget {
	// ______________________________
	this(QWidget parent) {
		super(parent);
	}

	// !!! Почему события именно перехватываются. Потому, что их генерирует Qt
	// а мы можем их только поймать и рассмотреть. Уничтожать не можем. Возможно
	// можем сгененировать из программы, но это надо проверять ...

	// ______________________________
	// Обработка закрытия окна
	void runWinClose(void* uc) {
		QEvent qe = new QEvent('+', uc); // Перехват события закрытия окна
		writeln("--CloseWin -->", uc);
	}
	// ______________________________
	// Событие мыша, кнопка нажата, какая кнопка видно в qe.button()
	void runMouseEvent(void* uc) {
		QMouseEvent qe = new QMouseEvent('+', uc);
		writeln("--MouseEvent - x = ", qe.x, "  y = ", qe.y, "    gX = ", qe.globalX, " = ", qe.globalY);
		writeln("buttob = ", qe.button());
	}
	// ______________________________
	// Событие мыша 2, кнопка мыша отпускается, какая кнопка видно в qe.button()
	void runMouseEvent2(void* uc) {
		QMouseEvent qe = new QMouseEvent('+', uc);
		writeln("--MouseReleaseEvent - x = ", qe.x, "  y = ", qe.y, "    gX = ", qe.globalX, " = ", qe.globalY);
	}
}

void main(string[] ards) {
	bool fDebug = true;
	if (1 == LoadQt(dll.QtE5Widgets, fDebug)) return;
	QApplication app = new QApplication(&Runtime.cArgs.argc, Runtime.cArgs.argv, 1);
	// ---- код программы
	CMyWidget widget = new CMyWidget(null); widget.saveThis(&widget);
	// взводим событие закрытия окна
	widget.setCloseEvent(&onWinClose,   widget.aThis());
	// взводим событие нажатия/отпускания кнопки мыша
	widget.setMousePressEvent(&onMousePressEvent, widget.aThis());
	widget.setMouseReleaseEvent(&onMouseReleaseEvent, widget.aThis());

	widget.show();
	// ----
	app.exec();
}


/*

// Обработчик --> в блок extern (C)
void on????(CForma????* uk, int n) { (*uk).run????(n);  }
// Актион
ac????	= new QAction(this, &on????, aThis);
ac????.setText("ТекстКнопки").setHotKey(QtE.Key.Key_??? | QtE.Key.Key_ControlModifier);
connects(acOpen, "triggered()", acOpen, "Slot()");
// Метод
void run????(int n) { //-> ...
}
*/