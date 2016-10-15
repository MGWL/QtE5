import qte5;				// Графическая библиотека QtE5
import core.runtime;		// Обработка входных параметров

extern(C)
{
	void onDraw(QGraphicsBox* boxPointer, void* eventPointer, void* painterPointer) 
	{ 
		(*boxPointer).runPaint(eventPointer, painterPointer);
	}
}

class QGraphicsBox : QWidget
{
	private
	{
		QWidget parent;
		string fileName;
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
		painter.end;
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