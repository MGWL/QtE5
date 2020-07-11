#include <stdlib.h>
#include <stdio.h>
#include "mgwGC.hpp"

// ---- mgwGC.cpp -----------------------------------
mgwGC::mgwGC()  {	// Начальная инициализация массивов
	for(int i = 0; i != MAXLENMAS; i++) { mMem[i] = NULL; mSiz[i] = 0; }
};
mgwGC::~mgwGC() { 
	for(int i = 0; i != MAXLENMAS; i++) { if( mMem[i] != NULL ) free(mMem[i]); }
};
void mgwGC::printStat() { 
	for(int i = 0; i != MAXLENMAS; i++) printf("Stat GC: %4d -- %p\n", mSiz[i], mMem[i]); 
};
void* mgwGC::newMem(int size) { // Выделить память размера size
	bool fl = false; int nomFree = 0;
	for(int i = 0; i != MAXLENMAS; i++) { if( mMem[i] == NULL ) { nomFree = i; fl = true; break; } }
	if(fl) {
		void* uk = malloc(size); 
		if(uk) { mMem[nomFree] = uk; mSiz[nomFree] = size; *(char*)uk = 0; return mMem[nomFree]; }
	}
	return NULL;
};
void mgwGC::delMem(void* adr) { // Удалить адрес
	for(int i = 0; i != MAXLENMAS; i++) { 
		if( mMem[i] == adr ) { free(mMem[i]); mMem[i] = NULL; mSiz[i] = 0; break; } 
	}
}
