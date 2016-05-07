module app;

import core.runtime; 
import std.conv;

import qte5;

QLCDNumber lcd;

int result;
string resultRegister, numberRegister;
string operationSign;

extern(C)
{
	void updateLCD(string number)
	{
		numberRegister ~= number;
		lcd.display(to!int(numberRegister));
		lcd.update;
	}

	void setOperationSign(string sign)
	{
		resultRegister = numberRegister;
		operationSign = sign;
		numberRegister = "";
		result = 0;
	}

	void onButton0(void* button)
	{
		updateLCD("0");
	}

	void onButton1(void* button)
	{
		updateLCD("1");
	}

	void onButton2(void* button)
	{
		updateLCD("2");
	}

	void onButton3(void* button)
	{
		updateLCD("3");
	}

	void onButton4(void* button)
	{
		updateLCD("4");
	}
	
	void onButton5(void* button)
	{
		updateLCD("5");
	}
	
	void onButton6(void* button)
	{
		updateLCD("6");
	}

	void onButton7(void* button)
	{
		updateLCD("7");
	}
	
	void onButton8(void* button)
	{
		updateLCD("8");
	}
	
	void onButton9(void* button)
	{
		updateLCD("9");
	}

	void onAddButton(void* button)
	{
		setOperationSign("+");
	}

	void onSubtractButton(void* button)
	{
		setOperationSign("-");
	}

	void onMultiplyButton(void* button)
	{
		setOperationSign("*");
	}

	void onDivideButton(void* button)
	{
		setOperationSign("/");
	}

	void onClearButton(void* button)
	{
		numberRegister = "0";
		lcd.display(0);
		lcd.update;
	}

	void onSignButton(void* button)
	{
		numberRegister = "-" ~ numberRegister;
		lcd.display(to!int(numberRegister));
		lcd.update;
	}

	void onEqualButton(void* button)
	{
		switch (operationSign)
		{
			case "+":
				result = to!int(resultRegister) + to!int(numberRegister);
				numberRegister = to!string(result);
				break;
			case "-":
				result = to!int(resultRegister) - to!int(numberRegister);
				numberRegister = to!string(result);
				break;
			case "*":
				result = to!int(resultRegister) * to!int(numberRegister);
				numberRegister = to!string(result);
				break;
			case "/":
				result = to!int(resultRegister) / to!int(numberRegister);
				numberRegister = to!string(result);
				break;
			default:
				numberRegister = resultRegister;
				break;
		}

		lcd.display(result);
		lcd.update;
	}
}

alias WindowType = QtE.WindowType;
enum WHITE = "background : white";

class MainForm : QWidget 
{
	QVBoxLayout verticalSizer, verticalSizer1, buttonGroup5;
	QHBoxLayout horizontalSizer, buttonGroup1, buttonGroup2, buttonGroup3, buttonGroup4;
	QPushButton button0, button1, button2, button3,
		button4, button5, button6, 
		button7, button8, button9,
		sign, clear, 
		add, subtract, multiply,divide, equal;

	this(QWidget parent, WindowType windowType) 
	{
		super(parent, windowType); 
		resize(300, 400); 
		setWindowTitle("QtE Calculator");
		setStyleSheet(WHITE);

		lcd = new QLCDNumber(this);
		lcd.setMode(QLCDNumber.Mode.Dec);
		lcd.setStyleSheet("background: lightgreen; color : gray");
		lcd.display(0);
		
		verticalSizer = new QVBoxLayout;
		verticalSizer1 = new QVBoxLayout;
		horizontalSizer = new QHBoxLayout;

		with (buttonGroup1 = new QHBoxLayout)
		{
			sign = new QPushButton("+/-", this);
			button0 = new QPushButton("0", this);
			clear = new QPushButton("C", this);

			QAction action0 = new QAction(null, &onButton0, null);
			connects(button0, "clicked()", action0, "Slot()");

			QAction actionSign = new QAction(null, &onSignButton, null);
			connects(sign, "clicked()", actionSign, "Slot()");

			QAction actionClear = new QAction(null, &onClearButton, null);
			connects(clear, "clicked()", actionClear, "Slot()");
			
			addWidget(sign);
			addWidget(button0);
			addWidget(clear);
		}

		with (buttonGroup2 = new QHBoxLayout)
		{
			button1 = new QPushButton("1", this);
			button2 = new QPushButton("2", this);
			button3 = new QPushButton("3", this);

			QAction action1 = new QAction(null, &onButton1, null);
			connects(button1, "clicked()", action1, "Slot()");

			QAction action2 = new QAction(null, &onButton2, null);
			connects(button2, "clicked()", action2, "Slot()");

			QAction action3 = new QAction(null, &onButton3, null);
			connects(button3, "clicked()", action3, "Slot()");

			addWidget(button1);
			addWidget(button2);
			addWidget(button3);
		}

		with (buttonGroup3 = new QHBoxLayout)
		{
			button4 = new QPushButton("4", this);
			button5 = new QPushButton("5", this);
			button6 = new QPushButton("6", this);

			QAction action4 = new QAction(null, &onButton4, null);
			connects(button4, "clicked()", action4, "Slot()");
			
			QAction action5 = new QAction(null, &onButton5, null);
			connects(button5, "clicked()", action5, "Slot()");
			
			QAction action6 = new QAction(null, &onButton6, null);
			connects(button6, "clicked()", action6, "Slot()");
			
			addWidget(button4);
			addWidget(button5);
			addWidget(button6);
		}

		with (buttonGroup4 = new QHBoxLayout)
		{
			button7 = new QPushButton("7", this);
			button8 = new QPushButton("8", this);
			button9 = new QPushButton("9", this);

			QAction action7 = new QAction(null, &onButton7, null);
			connects(button7, "clicked()", action7, "Slot()");
			
			QAction action8 = new QAction(null, &onButton8, null);
			connects(button8, "clicked()", action8, "Slot()");
			
			QAction action9 = new QAction(null, &onButton9, null);
			connects(button9, "clicked()", action9, "Slot()");
			
			addWidget(button7);
			addWidget(button8);
			addWidget(button9);
		}

		with (buttonGroup5 = new QVBoxLayout)
		{
			add = new QPushButton("+", this);
			subtract = new QPushButton("-", this);
			multiply = new QPushButton("*", this);
			divide = new QPushButton("/", this);

			QAction actionAdd = new QAction(null, &onAddButton, null);
			connects(add, "clicked()", actionAdd, "Slot()");

			QAction actionSubtract = new QAction(null, &onSubtractButton, null);
			connects(subtract, "clicked()", actionSubtract, "Slot()");
			
			QAction actionMultiply = new QAction(null, &onMultiplyButton, null);
			connects(multiply, "clicked()", actionMultiply, "Slot()");

			QAction actionDivide = new QAction(null, &onDivideButton, null);
			connects(divide, "clicked()", actionDivide, "Slot()");
			
			addWidget(add);
			addWidget(subtract);
			addWidget(multiply);
			addWidget(divide);
		}

		equal = new QPushButton("=", this);

		QAction actionEqual = new QAction(null, &onEqualButton, null);
		connects(equal, "clicked()", actionEqual, "Slot()");

		verticalSizer1
			.addLayout(buttonGroup4)
				.addLayout(buttonGroup3)
				.addLayout(buttonGroup2)
				.addLayout(buttonGroup1);

		horizontalSizer
			.addLayout(verticalSizer1)
				.addLayout(buttonGroup5);

		
		verticalSizer
			.addWidget(lcd)
				.addLayout(horizontalSizer)
				.addWidget(equal);
		
		setLayout(verticalSizer);
	}
}


int main(string[] args) 
{
	alias normalWindow = QtE.WindowType.Window;

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
