Create so or dll:
--> qmake-qt5 QtE5widgets.pro
--> make
Rename or move 
--> mv libQtE5Widgets.so.1.0 libQtE5Widgets64.so # for Linux 64
--> copy QtE5Widgets.dll QtE5Widgets32.dll # for Windows 32
--> copy QtE5Widgets.dll QtE5Widgets64.dll # for Windows 64
