import qte5;				// Графическая библиотека QtE5
import core.runtime;		// Обработка входных параметров
import std.stdio;

extern(C)
{
	void onDraw(QGraphicsBox* boxPointer, void* eventPointer, void* painterPointer)
	{
		(*boxPointer).runPaint(eventPointer, painterPointer);
	}
	void onMousePressEvent(QGraphicsBox* uk, void* uc) {
		(*uk).runMouseEvent(uc);
	}
	void onMouseReleaseEvent(QGraphicsBox* uk, void* uc) {
		(*uk).runMouseEvent2(uc);
	}

}

class QGraphicsBox : QWidget
{
	private
	{
		QWidget parent;
		string fileName;
		// Координаты 1 точки
		int x1, y1, x2, y2;
	}

	this(QWidget parent)
	{
		super(parent);
		this.parent = parent;
		setStyleSheet(`background : white`);
		setPaintEvent(&onDraw, aThis);
	}

	void runPaint(void* eventPointer, void* painterPointer)
	{
		QPainter painter = new QPainter('+', painterPointer);
		QColor color = new QColor;
		color.setRgb(0, 50, 250, 200);

		QTurtleState turtleState = new QTurtleState(150, 150, (0 * 3.1415926) / 180.0);
		QTurtle turtle = new QTurtle(painter, color, turtleState, 300, (144 * 3.1415926) / 180.0);
		turtle.execute("F+F+F+F+F+");
		color.setRgb(0, 250, 0, 200);
		turtleState.setX(155); turtleState.setY(155);   turtle.execute("F+F+F+F+F+");
		color.setRgb(192, 0, 0, 255);
		turtleState.setX(160); turtleState.setY(160);   turtle.execute("F+F+F+F+F+");
		if( !(x1 == 0  && y1 ==0 && x2 ==0 && y2 == 0) ) {
			color.setRgb(0, 0, 0);
			QPen pen = new QPen;
			pen.setColor(color); pen.setWidth(5);
			painter.setPen(pen);
			painter.drawLine(x1, y1, x2, y2);
		}
		painter.end;
	}
	// ______________________________
	// Событие мыша
	void runMouseEvent(void* uc) {
		QMouseEvent qe = new QMouseEvent('+', uc);
		x1 = qe.x; y1 = qe.y;
		// writeln("buttob = ", qe.button());
	}
	// ______________________________
	// Событие мыша 2
	void runMouseEvent2(void* uc) {
		QMouseEvent qe = new QMouseEvent('+', uc);
		x2 = qe.x; y2 = qe.y;
		update();
		// writeln("--MouseReleaseEvent - x = ", qe.x, "  y = ", qe.y, "    gX = ", qe.globalX, " = ", qe.globalY);
		// writeln("--GLOBAL - ", x1, " - ", y1, " - ", x2, " - ", y2);
	}
}


class MainForm : QWidget
{
	private
	{
		QVBoxLayout mainBox;
		QGraphicsBox box0;
	}

	this(QWidget parent, WindowType windowType)
	{
		super(parent, windowType);
		resize(600, 400);
		setWindowTitle("Пример черепашьей графики QtE5");
		setStyleSheet("background : white");
		mainBox = new QVBoxLayout(this);
		box0 = new QGraphicsBox(this);
		box0.saveThis(&box0);
		mainBox.addWidget(box0);
		setLayout(mainBox);
		box0.setMousePressEvent(&onMousePressEvent, box0.aThis());
		box0.setMouseReleaseEvent(&onMouseReleaseEvent, box0.aThis());
	}
}

alias WindowType = QtE.WindowType; // псевдонимы под Qt'шные типы
alias normalWindow = WindowType.Window;

void main(string[] ards) {
	bool fDebug = true;
	if (1 == LoadQt(dll.QtE5Widgets, fDebug)) return;
	QApplication app = new QApplication(&Runtime.cArgs.argc, Runtime.cArgs.argv, 1);
	// ---- код программы
	MainForm widget = new MainForm(null, normalWindow);
	widget.saveThis(&widget); widget.show();
	// ----
	app.exec();
}
