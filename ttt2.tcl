# encoding system utf-8;
set OS [lindex $tcl_platform(os) 0]
if { $OS == "Windows" } { load qtt.dll Qtt; } else { load qtt.so Qtt; }
# алиас, что бы короче кнопку писать
set Kn QPushButton;
# Главное приложение
set qt_app [QApplication new]; 
# Делаю центральный виджет
set qt_w1 [QWidget new null]; QWidget setStyleSheet $qt_w1 { background: Moccasin };
# Делаю кнопку
set qt_kn1 [$Kn new $qt_w1 "Это кнопка"]; $Kn setStyleSheet $qt_kn1 {background: Green};
# Устанавливаю QAction
set qt_ac1 [QAction new $qt_w1 {
	puts {Привет из QAction};
	QWidget setWindowTitle $qt_w1 "Дата: [clock format [clock seconds] -format {%a %D}]";
	# Попытка вставить результат команды в окно
	puts "--1--";
	if { $OS == "Windows" } { 
		puts "--10--"; set q [auto_execok dir]; set q "$q /B" 
	} else { 
		puts "--11--"; set q [auto_execok ls]; set q "$q -l" 
	}
	puts "--2--";
	QPlainTextEdit appendPlainText $qt_PlanText [ 
		exec {*}$q 
		if { $OS == "Windows" } {exec {*}$q} else { puts "--1--"; exec ls -l; } 
	];
	puts "--3--";
	puts {---------- Список файлов -----------}
}]; QConnects $qt_kn1 clicked() $qt_ac1 Slot_v__A_N_v(); QAction setText $qt_ac1 {Список}
QAction setIcon $qt_ac1 {ICONS/document_into.ico}
# Делаю ещё одну кнопку
set qt_kn2 [$Kn new $qt_w1 "Проверка"]; $Kn setStyleSheet $qt_kn2 {background: Blue};
set qt_ac2 [QAction new $qt_w1 {
	puts {Вторая кнопка};
	puts "Пароль: [QLineEdit text $qt_le]"
	QStatusBar showMessage $qt_sb {Статусная строка};
}]; QConnects $qt_kn2 clicked() $qt_ac2 Slot_v__A_N_v()
# Делаю окно редактора
set qt_PlanText [QPlainTextEdit new null];
# Делаю редактор строки
set qt_le [QLineEdit new $qt_w1]; QLineEdit setText $qt_le {Привет ребята}
# Горизонтальный выравниватель
set qt_Hlaybox [QBoxLayout new null >]
QBoxLayout addWidget $qt_Hlaybox $qt_kn1; 
QBoxLayout addWidget $qt_Hlaybox $qt_kn2; 

# Вертикальный выравниватель
set qt_laybox [QBoxLayout new $qt_w1 V]
QBoxLayout addWidget $qt_laybox $qt_PlanText;
QBoxLayout addWidget $qt_laybox $qt_le;
QBoxLayout addLayout $qt_laybox $qt_Hlaybox;

# ToolBar добавляю
set qt_toolBar [QToolBar new null]; QToolBar addAction $qt_toolBar $qt_ac1;
# СтатусБар
set qt_sb [QStatusBar new null]; QStatusBar setStyleSheet $qt_sb {background: Grey}

# Делаю окно приложения
set qt_MainWin [QMainWindow new null]; QMainWindow setWindowTitle $qt_MainWin {QtE5Tcl ver 0.1};
# Вставляю виджет в MainWindow
QMainWindow setCentralWidget $qt_MainWin $qt_w1
QMainWindow setStatusBar $qt_MainWin $qt_sb; QMainWindow addToolBar $qt_MainWin $qt_toolBar
QMainWindow show $qt_MainWin;
set rez [QApplication exec $qt_app];
puts $rez
# exit
