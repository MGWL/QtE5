module main;

import core.runtime;

import qte5;

import gui;

alias normalWindow = WindowType.Window;

int QtDebugInfo(bool flag)
{
    return LoadQt(dll.QtE5Widgets, flag);
}

int main(string[] args) 
{
	QtDebugInfo(true);
	
	QApplication app = new QApplication(&Runtime.cArgs.argc, Runtime.cArgs.argv, 1);
	MainForm mainForm = new MainForm(null, normalWindow);
	
	mainForm.saveThis(&mainForm);	
	mainForm.showMaximized;
	
	return app.exec;
}
