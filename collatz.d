import qte5;
import core.runtime;     // Обработка входных параметров
import std.range;
import std.traits;
extern (C) void onPaint1(MainForm* uk, void* ev, void* qpaint)   { 
	(*uk).runPaint1(ev, qpaint);
}
// ____________________________________________________________________
auto foreverApply(alias Functional, Argument)(Argument x) {
	alias FunctorType = ReturnType!Functional;
	struct ForeverFunctorRange {
		FunctorType argument;
 
		this(Argument)(Argument argument) {
			this.argument = cast(FunctorType) argument;
		}
		enum empty = false;
 
		FunctorType front() {
			return argument;
		}
 
		void popFront() {
			argument = Functional(argument);
		}
	}
	return ForeverFunctorRange(x);
}
// ____________________________________________________________________
auto doTimes(alias Functional, Argument, Number)(Argument x, Number n) {
	assert(n >= 0, "Argument must be not negative !");
	auto N = cast(size_t) n;
	return foreverApply!Functional(x).take(N);
}
// ____________________________________________________________________
class MainForm : QWidget {
	const strWhite = "background: White";  // Таблица цветов из HTML
	QColor color1; QPen pero;
	// ____________________________________________________________________
	this(QWidget parent, QtE.WindowType fl) {
		super(parent, fl); resize(500, 500); setWindowTitle("Collatz Sequence");
		setStyleSheet(strWhite);
		color1 = new QColor(); color1.setRgb(192, 0, 0, 128);
		pero = new QPen(); pero.setWidth(3).setColor(color1);
		setPaintEvent(&onPaint1, aThis);
	}
	// ____________________________________________________________________
	void runPaint1(void* ev, void* qpaint) {
		// Схватить переданный из Qt указатель на QPaint и обработать его 
		QPainter qp = new QPainter('+', qpaint); 
		drawGrid(qp); qp.setPen(pero); drawCollatz(qp); qp.end();
	}
	// ____________________________________________________________________
	void drawGrid(QPainter graphics) {
		for (int i = 0; i < 500; i += 5) {
			for (int j = 0; j < 500; j += 5) {
				graphics.drawLine(i, 0, i, 500);
				graphics.drawLine(0, j, 500, j);
			}
		}
	}
	// ____________________________________________________________________
	void drawCollatz(QPainter graphics) {
		auto doubleTwo(int x) {
			if ((x % 2) == 0) return x / 2; else return 3 * x + 1;
		}
		auto collatz27 = doTimes!doubleTwo(27, 112);
		
		auto firstX = 0; auto firstY = collatz27.front;
		
		foreach (elem; collatz27.enumerate(0)) {
			graphics.drawLine(firstX, firstY, elem[0] * 4, 250 - (elem[1] / 40));
			firstX = elem[0] * 4;
			firstY = 250 - (elem[1] / 40);
		}
	}
}
// ____________________________________________________________________
int main(string[] args) {
	bool fDebug; if (1 == LoadQt(dll.QtE5Widgets, fDebug)) return 1;
	QApplication  app = new QApplication(&Runtime.cArgs.argc, Runtime.cArgs.argv, 1);
	MainForm fMain = new MainForm(null, QtE.WindowType.Window);
	fMain.show().saveThis(&fMain);
	return app.exec();
}
