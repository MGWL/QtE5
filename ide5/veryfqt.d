// Verification of presence of Qt-5 for QtE5
// MGW 21.05.16

import core.runtime;     // Загрузка DLL Для Win
import std.stdio;        // writeln

version(linux) {   
    import core.sys.posix.dlfcn;  // define dlopen() and dlsym()
    extern (C) void* rt_loadLibrary(const char* name) { return dlopen(name, RTLD_GLOBAL || RTLD_LAZY);  }
    void* GetProcAddress(void* hLib, string nameFun) {  return dlsym(hLib, nameFun.ptr);    }
}
version(Windows) {
	import std.c.windows.windows;  // GetProcAddress для Windows
}

int main(string[] args) {
	int rez;		// return variable
	string[] namesDll, namesRpm;

	version (linux) {
		version (X86) {		// ... 32 bit code ...
			namesDll = ["libQt5Core.so", "libQt5Gui.so", "libQt5Widgets.so", "libQtE5Widgets32.so"];
			namesRpm = ["qt5qtbase-devel", "qt5-qtbase-devel", 
				"qt5-qtbase-devel", "libQtE5Widgets32.so from https://github.com/MGWL/QtE5/tree/master/linux32"];
		}
		version (X86_64) {	// ... 64 bit code
			namesDll = ["libQt5Core.so", "libQt5Gui.so", "libQt5Widgets.so", "libQtE5Widgets64.so"];
			namesRpm = ["qt5qtbase-devel", "qt5-qtbase-devel", 
				"qt5-qtbase-devel", "libQtE5Widgets64.so from https://github.com/MGWL/QtE5/tree/master/linux64"];
		}
	}
	version (Windows) {
		version (X86) {		// ... 32 bit code ...
			namesDll = ["Qt5Core.dll", "Qt5Gui.dll", "Qt5Widgets.dll", "QtE5Widgets32.dll"];
			namesRpm = ["Qt5Core.dll", "Qt5Gui.dll", 
				"Qt5Widgets.dll", "QtE5Widgets32.dll"];
		}
	}
	foreach(i, nameLibrary; namesDll) {
		try {
			auto h = Runtime.loadLibrary(nameLibrary);
			if(h is null) {
				rez = 1;
				writeln("Error load: ", nameLibrary);
				writeln("copy ", namesRpm[i], " from https://github.com/MGWL/QtE5/blob/master/windows32"); 
				break;
			}
		} catch {
			rez = 1;
			writeln("Error verification: ", nameLibrary, " - problems in libraries D");
			break;
		}
	}
	return rez;
}
