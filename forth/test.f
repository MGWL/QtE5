// ��������: ��������� � �������� ������ �� ������
// � ����������� � CP1251 ��� Windows
// 1 2 3 4 5 

S" stdlib.f" 1+ INCLUDED // ��������� ����������� ����������

// ��������� �� ������� ����� ������ �������� ������� ������ ���������� RDTC
// ��������� �������� ������ �� mOleg ����������. ��. SPF-Fork
: TIMER@ // ( --> ud )
         [ 137 B, 69 B, 252 B, 15 B, 49 B, 137 B,
           85 B, 248 B, 141 B, 109 B, 248 B, 135 B, 69 B, 0 B, ] ;
: (measure) // ( xt --> dt ) // �������� ������������ ���������� �����, ��������������� ����� xt
    TIMER@ >R >R EXECUTE TIMER@ R> R> DROP SWAP DROP - ;

IF=W Lib" MSVCRT.DLL" MsVcrt
IF=W Library@ MsVcrt 1 CDECL-Call" malloc"  malloc
IF=W Library@ MsVcrt 1 CDECL-Call" free"    free


// �������� Windows
IF=W Lib" CRTDLL.DLL" CrtDll
IF=W Library@ CrtDll 1 CDECL-Call" strlen"  strlen
IF=W Library@ CrtDll 2 CDECL-Call" strcmp"  strcmp
IF=W Library@ CrtDll 1 CDECL-Call" strncmp" strncmp
IF=W Library@ CrtDll 2 CDECL-Call" fputc"   putc
IF=W Library@ CrtDll 1 CDECL-Call" _fputchar"   _fputchar
IF=W Library@ CrtDll 2 CDECL-Call" fputwc"   fputwc
IF=W Library@ CrtDll 2 CDECL-Call" fputs"   fputs
IF=W Library@ CrtDll 2 CDECL-Call" fputwc"   fputwc
IF=W Library@ CrtDll 1 CDECL-Call" fgetwc"   fgetwc
IF=W Library@ CrtDll 2 CDECL-Call" fopen"   fopen
IF=W Library@ CrtDll 1 CDECL-Call" fclose"  fclose
IF=W Library@ CrtDll 0 GADR-Call" _iob"  ms6_iob

// �������� Linux
IF=L Lib" libc.so.6" libcSo
IF=L Library@ libcSo 1 CDECL-Call" strlen"  strlen
IF=L Library@ libcSo 3 CDECL-Call" printf"  printf
IF=L Library@ libcSo 2 CDECL-Call" putc"    putc
IF=L Library@ libcSo 2 CDECL-Call" fopen"   fopen
IF=L Library@ libcSo 2 CDECL-Call" fputs"   fputs
IF=L Library@ libcSo 1 CDECL-Call" fclose"  fclose
IF=L Library@ libcSo 1 CDECL-Call" malloc"  malloc
IF=L Library@ libcSo 1 CDECL-Call" free"    free


IF=W Lib" USER32.DLL" User32
IF=W Library@ User32 4 WINAPI-Call" MessageBoxA"  messagebox

IF=W LibraryLoad CrtDll
IF=W LibraryLoad User32
IF=W LibraryLoad MsVcrt

IF=L LibraryLoad libcSo

// ������ �� C++ QtE5
// : w . ;
// : t 5 >R ['] w >R A_CALL_AN CALL_A R> DROP R> DROP DROP ;

// : WW 2 >R S" nbv" 1+ >R S" ABC" 1+ >R 0  >R messagebox CALL_A DROP . ;
: MessageBox // ( hwnd Az_��������� Az_����� n������ -- ����� )
    messagebox
    ;
// �������� ������ ������ MessageBoxA
: testMessageBox // ( -- )
  0     // hwnd - ��� ��� �� �����, �� NULL
  S" ������ �� ForthD ���������� WinApi" 1+ // ����� ��������� 1+ ������ ������� � ������ ������
  S" ��������!" 1+        // ���������. S" ABC" --> 3 65 66 67 0    --> �� ����� ��� ������
  17                      // ��������� ���������� �������� � �������� ...
  messagebox              // ����� ����� ������� (������� ������ � stdlib.f)
  DROP                    // ������� �����, ���� �� ����� ������ ������ ....
  ;
    
// 10 .
// 0 COMMONADR@ .

// 10 COMMONADR@ DUMP
: WW 0 10 COMMONADR@ S" AS" 1+ 2 MessageBox DROP ;
// ������� ������ � VBA
// WW
// : WW 0 S" nbv" 1+ S" ABC" 1+ 2  messagebox  . ;
// 11 .

// ���������� �������� �������� �� �������� ����� 
VAR v_STDOUT        // stdout
VAR v_STDIN         // stdin
VAR v_STDERR        // stderr


IF=L (STDOUT)     v_STDOUT ! // � Linux  stdout == �++ gcc
IF=W ms6_iob 32 + v_STDOUT ! // � Winows stdout �������� ��������������� �� _iob[1];
IF=W ms6_iob      v_STDIN  ! // � Winows stdin �������� �� _iob[0];

// ��������� ������ � �������� ����� ������� ���������� stdc
: EMIT v_STDOUT @ putc DROP ; // ( N -- ) ����� ������� �� ����������� �����

: F_EMIT // ( File N -- ) ������� ������ � ����
    SWAP putc DROP ;
: CR  // ( -- ) ������� ������
IF=W 13 EMIT
     10 EMIT
    ;
: F_CR  // ( File -- ) ������� ������
    >R
IF=W R@ 13 F_EMIT
     R@ 10 F_EMIT RDROP
    ;
: TYPE  // ( Astrz N -- ) ���������� ������
    DUP B@ BEGIN DUP WHILE SWAP 1+ DUP B@ EMIT SWAP 1- REPEAT DROP DROP ;
: F_TYPE // ( File Astrz -- ) ���������� ������ � ����
    SWAP >R DUP B@ BEGIN DUP WHILE SWAP 1+ DUP B@ R@ SWAP F_EMIT SWAP 1- REPEAT
    DROP DROP RDROP ;


\ �������� ������ ����
: ������������ // ( -- )
    S" -----------------------------------------" TYPE CR
    S" Test working forth ---> " TYPE 2 5 + .
    S" -----------------------------------------" TYPE CR
    ;
������������
// IF=W testMessageBox

// ������� �������� ������ ���� ����� �� D �� ����� Eval, � ����� CALL ASM
VAR sum 0 sum !
: TestForthWord
    + 10000 0 DO DUP sum @ + sum ! LOOP DROP sum @
    ; LATEST @ 6 COMMONADR!  // �������� ����� � 6 ����� ������ ��� ������ � D

// �������� ������ � �������
// ---------------------------
HERE 3 CELLS ALLOT CONST uk // uk - ���� ��������� �� ��������� �� 3 int
: ukX uk 0 CELLS + ; : ukY uk 1 CELLS + ; : ukBuf uk 2 CELLS + ;

// ������� ������ ������������ ������
400 500   ukX !  ukY !

// ������� ������ ��� ������ ������ � �������� �� ���� ���������
: BufCreate    // ( -- ) ������ ����� ��� ������ �������� �� ��������� uk
    ukX @ ukY @ * CELLS malloc ukBuf !
    ; BufCreate
uk 7 COMMONADR!  // ��������� � D ��������� �� ���������

: full    // ( color -- ) ��������� �������� ������
    ukX @ ukY @ * 0 DO DUP ukBuf @ I CELLS + ! LOOP DROP
    ;
: point   // ( color y x -- )
    ukY @ * + CELLS ukBuf @ + !
    ;
-9000    CONST �����
300      CONST ������
-53441   CONST �����
-9364862 CONST ��������
VAR sm 0 sm ! : sm+ sm @ 1+ DUP sm ! + ;
: �����100 100 0 DO DUP I I sm+ point LOOP DROP ;

// -05453748
// 100 CONST sizeb1         // ������ ����� ������
// VAR b1                   // ��������� �� ���� ������
// sizeb1 CELLS malloc b1 ! // �������� ������ ��� ������

// : Buf! CELLS b1 @ + ! ;   // ( �������� ������������� -- ) �������� �� � ������
// : b1@ CELLS b1 @ + @ ;   // ( ������������� -- �������� ) ��������� ��
// ������� ������
// : b1init sizeb1 0 DO 0 I b1! LOOP ; b1init

Lib" libtk8.6.so"   tk86
Lib" libtcl8.6.so" tcl86

Library@ tcl86 0 CDECL-Call" Tcl_CreateInterp"  Tcl_CreateInterp
Library@ tcl86 0 CDECL-Call" Tcl_CreateInterp"  Tcl_CreateInterp
Library@ tcl86 0 CDECL-Call" Tcl_Main"          Tcl_Main

Library@  tk86 3 CDECL-Call" Tk_MainEx"          Tk_Main

LibraryLoad tcl86
LibraryLoad tk86

Tcl_CreateInterp CONST interp


// http://lipid.phys.cmu.edu/tview/src/tvMain.cpp

// . . . . .