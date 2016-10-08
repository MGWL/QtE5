# QtE5 - is a D wrapper for Qt-5 graphics library.

![logo](https://github.com/MGWL/QtE5/blob/master/ICONS/qte5.png)

This is a small study library to work with GUI Qt-5.
It is used for dynamic linking and easy in use on Windows 32/64 and Linux 32/64.

**This short video about qte5 and ide5 [https://www.youtube.com/watch?v=DuOl-4g117E](https://www.youtube.com/watch?v=DuOl-4g117E)**

**Slots and signals in QtE5 http://lhs-blog.info/programming/dlang/slotyi-i-signalyi-v-qte5/**

QtE5 - uses the following libraries depending from OS<br>
    QtE5Widgets32.dll     --->  Windows 32<br>
    QtE5Widgets64.dll     --->  Windows 64<br>
    libQtE5Widgets32.so   --->  Linux   32<br>
    libQtE5Widgets64.so   --->  Linux   64<br>
<p>The most actual version for Windows 32 (QtE5Widgets32.dll) as on it the basic working out and testing is conducted.</p>   
```
{
	...
	"dependencies": { "qte5": "~>0.0.7"	},
	...
}

// ----------------------------------------------------------------
// For Linux before DUB set LD_LYBRARY_PATH for libQtE5WidgetsXX.so
// Example: LD_LIBRARY_PATH=`pwd`; export LD_LIBRARY_PATH; dub run 
// ----------------------------------------------------------------

import core.runtime;
import qte5;

int main(string[] args) {
	string s =	"<p><font size='34' color='red'>QtE5</font>
	<font size='34' color='blue'><i> - a small wrapper of Qt-5 for D</i></font></p>
	";
	if (1 == LoadQt(dll.QtE5Widgets, true)) return 1;
	QApplication app = new QApplication(&Runtime.cArgs.argc, Runtime.cArgs.argv, 1);
	QLabel lb = new QLabel(null);
	lb.setText(s).show();
	return 0;
}
```    
    
##Screenshot    
![screen](https://pp.vk.me/c631922/v631922885/34712/PdhAoT0u4hk.jpg)
![screen](https://pp.vk.me/c604527/v604527885/18d7e/Jjom-jl3uVQ.jpg)
![screen](https://pp.vk.me/c631825/v631825885/4252c/5xmIehp5WI0.jpg)
