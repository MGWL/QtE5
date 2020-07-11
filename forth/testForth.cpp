#include <stdio.h>
#include <stdlib.h>
#include <windows.h>
#include <windows.h>
// #include <winbase.h>
#include <windows.h>


int main(int argc, char** argv) {
    HANDLE hLib = NULL;

    if(argc != 2) {
        printf("usage: testForth nameFile.f\n"); return 1;
    }
    // Имя файла есть, будем его загружать argv[1]
    hLib = LoadLibrary("forthd.dll");
    if (!hLib) {
        printf("Error load DLL --> %s\n", "forthd.dll");
    }

    typedef void (* initForth_t)();
    typedef void (* includedForth_t)(char*);

    // Ищем имена функций
    initForth_t dll_initForth = (initForth_t)GetProcAddress(hLib,"dll_initForth");
    if(!dll_initForth) {
        printf("Error find function --> h %s\n", "dll_initForth"); return 1;
    }
    includedForth_t dll_includedForth = (includedForth_t)GetProcAddress(hLib,"dll_includedForth");
    if(!dll_initForth) {
        printf("Error find function --> h %s\n", "dll_includedForth"); return 1;
    }
    // вызов интерпретатора Forth
    dll_initForth();
    dll_includedForth(argv[1]);

	return 0;
}