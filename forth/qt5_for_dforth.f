1 2 3 4 5 // Проверка стека на выходе

S" stdlib.f" 1+ INCLUDED
IF=W Lib" QtE5Widgets32.dll" QtE5Widgets
IF=W Library@ QtE5Widgets 3 CDECL-Call" qteQApplication_create1"  new_qteQApplication
IF=W Library@ QtE5Widgets 1 CDECL-Call" qteQApplication_exec"     qteExec
IF=W Library@ QtE5Widgets 1 CDECL-Call" qteQApplication_aboutQt"  aboutQt
IF=W Library@ QtE5Widgets 2 CDECL-Call" qteQWidget_create1"       new_QWidget
IF=W Library@ QtE5Widgets 2 CDECL-Call" qteQWidget_setVisible"    setVisible
IF=W LibraryLoad QtE5Widgets

// Лень изготавливать argc и argv, просто моделирую их
VAR argc 1 argc ! // Это argc
VAR s2 VAR s3 VAR s1 0 s1 ! s1 @ s2 ! s2 @ s3 ! // s3 - это argv
argc s3 1 new_qteQApplication VAR app app !  // app = new QApplication(argc, s3, 1);
app @ aboutQt  // app.aboutQt();

0 0 new_QWidget VAR win1 win1 ! DROP // win1 = new QWidget(null, 0);
1 win1 @ SWAP setVisible DROP // win1.setVisible(true);
app @ qteExec DROP // app.exec();

S" --1--" 1+ TYPE // Визуализация загрузки
. . . . . // Проверка стека на выходе

