Binding Qt for tcl language. 

Dependes: Headers (*.h) for TCL, arsd lib for DLang (D), QtE5 - binding Qt for DLang (D)

Make:
// Windows
dmd qtt.d -shared -m32 -ofqtt.dll qte5.d tcltk/tcl.d tcltk/tcldecls.d tcltk/tclplatdecls.d arsd/http2.d -release -O -version=without_openssl -version=winTcl   --> for ActiveTcl
// Linux
dmd qtt.d -shared tcltk/tcl.d tcltk/tcldecls.d tcltk/tclplatdecls.d arsd/http2.d -version=without_openssl -release -O -ofqtt.so

Run:
tclsh ttt2.tcl


