import std.stdio;
import qte5;				// Графическая библиотека QtE5
import core.runtime;		// Обработка входных параметров
import asc1251;
import std.socket;
import std.getopt;		// Раазбор аргументов коммандной строки

string helps() {
	return	toCON(
"Использование консоли для forthD:
--------------------------------
Запуск:
console5_forthd [-d, -e, -i] ...
");
}

extern (C) {
	// void* onChar(CChat* uk, void* ev) {}
	void  onReturn(CChat* uk)		{ (*uk).runReturn(); }
	void  onRes(CChat* uk)		   { (*uk).runRes(); }
}
// __________________________________________________________________
class CChat : QWidget {
	QVBoxLayout	vblAll;			// Общий вертикальный выравниватель
	QPlainTextEdit	teLog;			// Окно чата
	QLineEdit		leMes;				// Строка сообщения
	QAction		acSend;			// Действие послать ...
	QAction		acRes;				// Действие принять ...
	QTimer			timer;				// Таймер
	string nUser;
	char[1024] buf;
	bool triger;
	UdpSocket udp2;
	InternetAddress adrRes;
	QLCDNumber lcd;
	// ______________________________________________________________
	this(string user) {
		super(this);
		resize(300, 400);
		nUser = (user == "") ? "unknow ..." : user; setWindowTitle(nUser);
		acSend   = new QAction(this, &onReturn,   aThis); 
		acRes    = new QAction(this, &onRes,      aThis); 

		lcd = new QLCDNumber(this);

		udp2 = new UdpSocket();
		adrRes = new InternetAddress("0.0.0.0", 11719);
		udp2.setOption(SocketOptionLevel.SOCKET, SocketOption.REUSEADDR, true);
		udp2.bind(adrRes);
		udp2.blocking(false);

		timer = new QTimer(this); timer.setSingleShot(false);
		connects(timer, "timeout()", acRes, "Slot()");

		vblAll  = new  QVBoxLayout(this);		// Главный выравниватель
		teLog   = new QPlainTextEdit(this);
		leMes   = new QLineEdit(this);
		vblAll.addWidget(teLog).addWidget(leMes).addWidget(lcd);
		setLayout(vblAll);
		leMes.setFocus();
		// Свяжем событие CR в строке сообщения с слотом runReturn()
		connects(leMes,"returnPressed()", acSend, "Slot()");
		timer.start(100);
	}
	~this() {

	}
	// ______________________________________________________________
	void runRes() {
		auto z = udp2.receiveFrom(buf);
		if(z > 0) {
			teLog.appendPlainText(buf[0..z]);
		}
		// writefln("%s\n", buf[0..z]);
		// write(z, " "); stdout.flush();  // Отладка
	}
	// ______________________________________________________________
	void runReturn() {
		string str = nUser ~ ": "~ leMes.text!string();
		if(str == "") return;
		auto adrSend = new InternetAddress("255.255.255.255", 11719);
		auto udpSend = new UdpSocket();
		udpSend.setOption(SocketOptionLevel.SOCKET, SocketOption.BROADCAST, true);
		auto ss = udpSend.sendTo(str, adrSend);
		udpSend.close();
		leMes.clear();
	}
}

int main(string[] args) {
	bool fDebug = true; 
	string nameUser;
	// Разбор аргументов коммандной строки
	try {
		auto helpInformation = getopt(args, std.getopt.config.caseInsensitive,
			"u|user",	toCON("имя пользователя"), 		&nameUser,
			"d|debug",	toCON("включить диагностику QtE5"), 		&fDebug);
		if (helpInformation.helpWanted) defaultGetoptPrinter(helps(), helpInformation.options);
	} catch {
		writeln(toCON("Ошибка разбора аргументов командной стоки ...")); return 1;
	}

	if (1 == LoadQt(dll.QtE5Widgets, fDebug)) return 1;
	QApplication app = new QApplication(&Runtime.cArgs.argc, Runtime.cArgs.argv, 1);
	// ---- код программы
	CChat wChat = new CChat(nameUser); wChat.saveThis(&wChat);
	wChat.show();
	// ---- конец кода программы
	app.exec();
	return 0;
}