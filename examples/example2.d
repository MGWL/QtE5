// example2.d - Basic concepts of QAction.QtE5
// -------- compile ---------
// dmd example2 qte5

import qte5;
import core.runtime;

// (1) handler receives the pointer on object of myQWidget. 
extern (C) void handler(myQWidget* wd) {
	msgbox("pressed key on the form");
}

class myQWidget : QWidget {
	this() {
		// Create widget and set size
		super(this); resize(200, 100);
		// Create button for demo signal -- slot
		// the button generates to us a signal
		auto kn1 = new QPushButton("Press me ...", this);
		
		// Create QAction for processings of the slot
		auto actSlot1 = new QAction(this, &handler, aThis);
		// We connect a signal to slots standard means
		connects(kn1, "clicked()", actSlot1, "Slot()");
	}
}

int main(string[] args) {
	// Load library QtE5
	if (1 == LoadQt(dll.QtE5Widgets, true)) return 1;
	// Create app
	QApplication app = new QApplication(&Runtime.cArgs.argc, Runtime.cArgs.argv, 1);

	// (1) Create obj of myQWidget and to save this address in obj
	myQWidget mywid = new myQWidget(); mywid.saveThis(&mywid);
	
	mywid.show;

	app.exec();
	return 0;
}
