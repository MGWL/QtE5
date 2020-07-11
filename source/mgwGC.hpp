// ---- mgwGC.hpp ------------------------------------
#ifndef __mgwGC_H
#define __mgwGC_H 1

class mgwGC {
	#define MAXLENMAS 10
	protected:
		void* mMem[MAXLENMAS];
		int   mSiz[MAXLENMAS];
	public:
		mgwGC(); ~mgwGC();
		void printStat();
		void* newMem(int);			// Дай память размером в int
		void  delMem(void*);		// Удали память по указателю
};
// static mgwGC* uGC; uGC = new mgwGC(); .... uGC->newMem(100) uGC->delMem(uk); .... delete uGC;

#endif
