module app;

import core.runtime;

import std.conv;
import std.random;
import std.range;


import qte5;

import functors;

extern (C)
{
	void onPaint1(MainForm* mainFormPointer, void* eventPointer, void* painterPointer) 
	{ 
		(*mainFormPointer).runPaint(eventPointer, painterPointer);
	}

	void onDrawButton(MainForm* mainFormPointer) {
		(*mainFormPointer).runDrawButton;
	}

	void onClearButton(MainForm* mainFormPointer) {
		(*mainFormPointer).runClearButton;
	}
}


void drawCollatzSequence(QPainter painter, int number)
{
	auto doubleX(int x)
	{
		if ((x % 2) == 0)
		{
			return x / 2;
		}
		else
		{
			return 3 * x + 1;
		}
	}

	
	QColor color = new QColor;
	color.setRgb(0, 0, 192, 128);
	
	QPen pen = new QPen;
	pen.setColor(color);
	pen.setWidth(2);
	
	painter.setPen(pen);

	auto collatzSequence = doTimes!doubleX(number, 112);
	
	auto firstX = 0; 
	auto firstY = collatzSequence.front;
	
	foreach (elem; collatzSequence.enumerate(0)) 
	{
		painter.drawLine(firstX, firstY, elem[0] * 4, 250 - (elem[1] / 40));
		firstX = elem[0] * 4;
		firstY = 250 - (elem[1] / 40);
	}
}

alias WindowType = QtE.WindowType;

class MainForm : QWidget
{
	private
	{
		QHBoxLayout horizontalBox;
		QVBoxLayout verticalBox;
		QPushButton drawButton, clearButton;
		QLabel label;
		QSpinBox number;
		QAction action1, action2;
		QWidget drawArea;

		bool startDrawing;
	}

	this(QWidget parent, WindowType windowType) 
	{
		super(parent, windowType); 
		resize(1030, 530); 
		setWindowTitle("QtE Calculator");
		setStyleSheet("background : white");

		horizontalBox = new QHBoxLayout;
		verticalBox = new QVBoxLayout;

		with (drawArea = new QWidget(null))
		{
			setToolTip("<font color=black>Область рисования графики</font>");
			setStyleSheet("background : white");
		}

		with (number = new QSpinBox(this))
		{
			setStyleSheet("font-size: 16pt;");
			setPrefix("Начало последовательности: ");
			setMinimum(2);
			setMaximum(1000);
		}

		label = new QLabel(this);
		label.setText("<h3>Программа для рисования чисел-градин</h3><p>Этот демо пример разработали Мохов Г.В. и Бахарев О.Ю.</p>");

		
		drawButton = new QPushButton("Draw", this);
		clearButton = new QPushButton("Clear", this);

		action1 = new QAction(null, &onDrawButton, aThis);
		action2 = new QAction(null, &onClearButton, aThis);

		connects(drawButton, "clicked()", action1, "Slot()");
		connects(clearButton, "clicked()", action2, "Slot()");

		verticalBox
			.addWidget(number)
				.addWidget(drawButton)
				.addWidget(clearButton)
				.addWidget(label);

		horizontalBox
			.addLayout(verticalBox)
				.addWidget(drawArea);

		setLayout(horizontalBox);

		drawArea.setPaintEvent(&onPaint1, aThis);
	}

	void runPaint(void* eventPointer, void* painterPointer) 
	{

		QPainter painter = new QPainter('+', painterPointer); 

		QColor color = new QColor;
		color.setRgb(200, 200, 200, 250);

		QPen pen = new QPen;
		pen.setColor(color);

		painter.setPen(pen);

		for (int i = 0; i < 510; i += 10)
		{
			painter.drawLine(0, i, 500, i);
			painter.drawLine(i, 0, i, 500);
		}

		if (startDrawing)
		{
			startDrawing = false;
			auto N = cast(int) number.value;
			painter.drawCollatzSequence(N);
		}

		painter.end;
	}

	void runDrawButton() 
	{
		startDrawing = true;
		update();
	}

	void runClearButton()
	{
		drawArea.update();
	}
}


int main(string[] args) 
{
	alias normalWindow = WindowType.Window;
	
	if (LoadQt(dll.QtE5Widgets, true)) 
	{
		return 1;
	}
	
	QApplication app = new QApplication(&Runtime.cArgs.argc, Runtime.cArgs.argv, 1);
	
	MainForm mainForm = new MainForm(null, normalWindow);
	
	mainForm
		.show
			.saveThis(&mainForm);
	
	return app.exec;
}