import std.stdio;
import qte5;				// Графическая библиотека QtE5
import core.runtime;		// Обработка входных параметров

const strGreen = "background: #F79F81";

/*
Концепция обмена информацией QtE5 <--> QML
------------------------------------------
1 - Нет регистрации объектов, т.к. создать объект в D использующий метасистему Qt (слот/сигнал)
    можно, но сложно. Пример есть в dqml - но очень сложно и не документировано
2 - Все взаимодействие строится на регистрации Property --> qmlEngine.setContextProperty("test", w1.acTest);
    Фактически мы в QML вкидываем новое свойство/объект. В QML оно может запомнить или выдать всего
    два параметра (одна строка и одно число) и имеет возможность вызвать один слот QtE5 передавая ему число в
    качестве параметра.
3 - Со стороны QtE5 все взаимодействие построено на QAction, который наделен фиксированным набором 
    слотов и сигналов, в том числе и для взвимодействия с QML.
    С QML это qstr - присваеваем, значит в QAction пишется строка, читаем, значит читаем строку из QAction
    qint - присваеваем, значит в QAction пишется число, читаем, значит читаем число из QAction
    С QtE читать и писать эту строку и число можно используя методы QAction:
    fromQmlString(), toQmlString(T)(T str), fromQmlInt(), toQmlInt(int str)
*/

// __________________________________________________________________
extern (C) {
	void onTest(MyWindow* uk, int n) { (*uk).runTest(n);  }
	void onTest2(MyWindow* uk, int n, int ob) { (*uk).runTest2(n, ob);  }
}
class MyWindow: QWidget {
public:
	QAction		acTest, acKn;
	QPushButton knAdd;		// Кнопки управления
	QLineEdit	leRead;
	QHBoxLayout	vblCmd;
	
	this() {
		super(null);
		resize(300, 200);
		setWindowTitle("Окно QtE5");
		vblCmd		= new QHBoxLayout(null);		// Выравниватель для кнопок управления
		
		// acTest - это актион для взаимодействие с QML
		acTest	= new QAction(this, &onTest2, aThis, 1); // При вызове слота с QML будет вызван onTest2
		acTest.toQmlString("Еще более пламенный привет"); // Строка для передачи в QML

		acKn	= new QAction(this, &onTest, aThis, 1);
		knAdd 		= new QPushButton("Строку в QML",  this);
		connects(knAdd, "clicked()", acKn, "Slot_AN()");
		
		leRead		= new QLineEdit(this);
		vblCmd.addWidget(leRead).addWidget(knAdd);
		setLayout(vblCmd);
		
	}
	void runTest(int n) {
		writeln("call runTest from kn n = ", n);
		// Мы здесь, поскольку нажата кнопка в окне QtE5
		acTest.toQmlString(leRead.text!string()); // и записываем в QML
	}
	void runTest2(int n, int ob) {
		// А этот слот вызван из QML путем строки: test.Qml_Slot_ANI(13);
		writeln("call runTest n = ", n, "   ob = ", ob);
		string s = acTest.fromQmlString; // Читаем строку из актиона, которую туда положил QML
		leRead.setText(s);
	}
}

int main(string[] args) {
	if (1 == LoadQt(dll.QtE5Widgets + dll.QtE5Qml, false)) return 1;
	QApplication app = new QApplication(&Runtime.cArgs.argc, Runtime.cArgs.argv, 1);

	MyWindow w1 = new MyWindow(); w1.saveThis(&w1);
	w1.show(); w1.setStyleSheet(strGreen);
	
	QQmlApplicationEngine qmlEngine = new QQmlApplicationEngine(null);
	qmlEngine.setContextProperty("test", w1.acTest);
	qmlEngine.evaluate("var mgw = 'Привет из Dlang';");
	qmlEngine.load( args[1] );  // Грузим файл из параметра


	return app.exec();
}
