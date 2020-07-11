#include <stdio.h>
#include <string.h>

const int sByte = 256;

const int tBad		= 0;		// Бяка
const int tDigit	= 1;		// Цифра
const int tEl		= 2; 		// Анг Маленькие
const int tEu 		= 4; 		// Анг Большие
const int tPrint 	= 8; 		// Печатные
const int tRl 		= 16; 		// Рус Маленькие
const int tRu 		= 32; 		// Рус Большие

const char mm1251_Utf8[][sByte] = {
	/* 0 */
	"\x00", /* 1 */ "\x01", /* 2 */ "\x02", /* 3 */ "\x03", /* 4 */ "\x04",/* 5 */
	"\x05", /* 6 */ "\x06", /* 7 */ "\x07", /* 8 */ "\x08", /* 9 */ "\x09",/* 10 */
	"\x0A", /* 11 */ "\x0B", /* 12 */ "\x0C", /* 13 */ "\x0D", /* 14 */ "\x0E",/* 15 */
	"\x0F", /* 16 */ "\x10", /* 17 */ "\x11", /* 18 */ "\x12", /* 19 */ "\x13",/* 20 */
	"\x14", /* 21 */ "\x15", /* 22 */ "\x16", /* 23 */ "\x17", /* 24 */ "\x18",/* 25 */
	"\x19", /* 26 */ "\x1A", /* 27 */ "\x1B", /* 28 */ "\x1C", /* 29 */ "\x1D",/* 30 */
	"\x1E", /* 31 */ "\x1F", /* 32 */ "\x20", /* 33 */ "\x21", /* 34 */ "\x22",/* 35 */
	"\x23", /* 36 */ "\x24", /* 37 */ "\x25", /* 38 */ "\x26", /* 39 */ "\x27",/* 40 */
	"\x28", /* 41 */ "\x29", /* 42 */ "\x2A", /* 43 */ "\x2B", /* 44 */ "\x2C",/* 45 */
	"\x2D", /* 46 */ "\x2E", /* 47 */ "\x2F", /* 48 */ "\x30", /* 49 */ "\x31",/* 50 */
	"\x32", /* 51 */ "\x33", /* 52 */ "\x34", /* 53 */ "\x35", /* 54 */ "\x36",/* 55 */
	"\x37", /* 56 */ "\x38", /* 57 */ "\x39", /* 58 */ "\x3A", /* 59 */ "\x3B",/* 60 */
	"\x3C", /* 61 */ "\x3D", /* 62 */ "\x3E", /* 63 */ "\x3F", /* 64 */ "\x40",/* 65 */
	"\x41", /* 66 */ "\x42", /* 67 */ "\x43", /* 68 */ "\x44", /* 69 */ "\x45",/* 70 */
	"\x46", /* 71 */ "\x47", /* 72 */ "\x48", /* 73 */ "\x49", /* 74 */ "\x4A",/* 75 */
	"\x4B", /* 76 */ "\x4C", /* 77 */ "\x4D", /* 78 */ "\x4E", /* 79 */ "\x4F",/* 80 */
	"\x50", /* 81 */ "\x51", /* 82 */ "\x52", /* 83 */ "\x53", /* 84 */ "\x54",/* 85 */
	"\x55", /* 86 */ "\x56", /* 87 */ "\x57", /* 88 */ "\x58", /* 89 */ "\x59",/* 90 */
	"\x5A", /* 91 */ "\x5B", /* 92 */ "\x5C", /* 93 */ "\x5D", /* 94 */ "\x5E",/* 95 */
	"\x5F", /* 96 */ "\x60", /* 97 */ "\x61", /* 98 */ "\x62", /* 99 */ "\x63",/* 100 */
	"\x64", /* 101 */ "\x65", /* 102 */ "\x66", /* 103 */ "\x67", /* 104 */ "\x68",/* 105 */
	"\x69", /* 106 */ "\x6A", /* 107 */ "\x6B", /* 108 */ "\x6C", /* 109 */ "\x6D",/* 110 */
	"\x6E", /* 111 */ "\x6F", /* 112 */ "\x70", /* 113 */ "\x71", /* 114 */ "\x72",/* 115 */
	"\x73", /* 116 */ "\x74", /* 117 */ "\x75", /* 118 */ "\x76", /* 119 */ "\x77",/* 120 */
	"\x78", /* 121 */ "\x79", /* 122 */ "\x7A", /* 123 */ "\x7B", /* 124 */ "\x7C",/* 125 */
	"\x7D", /* 126 */ "\x7E", /* 127 */ "\x7F", /* 128 */ "\xD0\x82", /* 129 */ "\xD0\x83",
	/* 130 */
	"\xE2\x80\x9A", /* 131 */ "\xD1\x93", /* 132 */ "\xE2\x80\x9E", /* 133 */ "\xE2\x80\xA6", /* 134 */ "\xE2\x80\xA0", /* 135 */ "\xE2\x80\xA1",
	/* 136 */
	"\xE2\x82\xAC", /* 137 */ "\xE2\x80\xB0", /* 138 */ "\xD0\x89", /* 139 */ "\xE2\x80\xB9", /* 140 */ "\xD0\x8A", /* 141 */ "\xD0\x8C",
	/* 142 */
	"\xD0\x8B", /* 143 */ "\xD0\x8F", /* 144 */ "\xD1\x92", /* 145 */ "\xE2\x80\x98", /* 146 */ "\xE2\x80\x99", /* 147 */ "\xE2\x80\x9C",
	/* 148 */
	"\xE2\x80\x9D", /* 149 */ "\xE2\x80\xA2", /* 150 */ "\xE2\x80\x93", /* 151 */ "\xE2\x80\x94", /* 152 */ "\xC2\x98", /* 153 */ "\xE2\x84\xA2",
	/* 154 */
	"\xD1\x99", /* 155 */ "\xE2\x80\xBA", /* 156 */ "\xD1\x9A", /* 157 */ "\xD1\x9C", /* 158 */ "\xD1\x9B", /* 159 */ "\xD1\x9F",
	/* 160 */
	"\xC2\xA0", /* 161 */ "\xD0\x8E", /* 162 */ "\xD1\x9E", /* 163 */ "\xD0\x88", /* 164 */ "\xC2\xA4", /* 165 */ "\xD2\x90",
	/* 166 */
	"\xC2\xA6", /* 167 */ "\xC2\xA7", /* 168 */ "\xD0\x81", /* 169 */ "\xC2\xA9", /* 170 */ "\xD0\x84", /* 171 */ "\xC2\xAB",
	/* 172 */
	"\xC2\xAC", /* 173 */ "\xC2\xAD", /* 174 */ "\xC2\xAE", /* 175 */ "\xD0\x87", /* 176 */ "\xC2\xB0", /* 177 */ "\xC2\xB1",
	/* 178 */
	"\xD0\x86", /* 179 */ "\xD1\x96", /* 180 */ "\xD2\x91", /* 181 */ "\xC2\xB5", /* 182 */ "\xC2\xB6", /* 183 */ "\xC2\xB7",
	/* 184 */
	"\xD1\x91", /* 185 */ "\xE2\x84\x96", /* 186 */ "\xD1\x94", /* 187 */ "\xC2\xBB", /* 188 */ "\xD1\x98", /* 189 */ "\xD0\x85",
	/* 190 */
	"\xD1\x95", /* 191 */ "\xD1\x97", /* 192 */ "\xD0\x90", /* 193 */ "\xD0\x91",/* 194 */
	"\xD0\x92", /* 195 */ "\xD0\x93", /* 196 */ "\xD0\x94", /* 197 */ "\xD0\x95",
	/* 198 */
	"\xD0\x96", /* 199 */ "\xD0\x97", /* 200 */ "\xD0\x98", /* 201 */ "\xD0\x99",/* 202 */
	"\xD0\x9A", /* 203 */ "\xD0\x9B", /* 204 */ "\xD0\x9C", /* 205 */ "\xD0\x9D",
	/* 206 */
	"\xD0\x9E", /* 207 */ "\xD0\x9F", /* 208 */ "\xD0\xA0", /* 209 */ "\xD0\xA1",/* 210 */
	"\xD0\xA2", /* 211 */ "\xD0\xA3", /* 212 */ "\xD0\xA4", /* 213 */ "\xD0\xA5",
	/* 214 */
	"\xD0\xA6", /* 215 */ "\xD0\xA7", /* 216 */ "\xD0\xA8", /* 217 */ "\xD0\xA9",/* 218 */
	"\xD0\xAA", /* 219 */ "\xD0\xAB", /* 220 */ "\xD0\xAC", /* 221 */ "\xD0\xAD",
	/* 222 */
	"\xD0\xAE", /* 223 */ "\xD0\xAF", /* 224 */ "\xD0\xB0", /* 225 */ "\xD0\xB1",/* 226 */
	"\xD0\xB2", /* 227 */ "\xD0\xB3", /* 228 */ "\xD0\xB4", /* 229 */ "\xD0\xB5",
	/* 230 */
	"\xD0\xB6", /* 231 */ "\xD0\xB7", /* 232 */ "\xD0\xB8", /* 233 */ "\xD0\xB9",/* 234 */
	"\xD0\xBA", /* 235 */ "\xD0\xBB", /* 236 */ "\xD0\xBC", /* 237 */ "\xD0\xBD",
	/* 238 */
	"\xD0\xBE", /* 239 */ "\xD0\xBF", /* 240 */ "\xD1\x80", /* 241 */ "\xD1\x81",/* 242 */
	"\xD1\x82", /* 243 */ "\xD1\x83", /* 244 */ "\xD1\x84", /* 245 */ "\xD1\x85",
	/* 246 */
	"\xD1\x86", /* 247 */ "\xD1\x87", /* 248 */ "\xD1\x88", /* 249 */ "\xD1\x89",/* 250 */
	"\xD1\x8A", /* 251 */ "\xD1\x8B", /* 252 */ "\xD1\x8C", /* 253 */ "\xD1\x8D",
	/* 254 */
	"\xD1\x8E", /* 255 */ "\xD1\x8F"
};


int mm1251[sByte]= {tBad,tBad,tBad,tBad,tBad,tBad,tBad,tBad,tBad,tBad,tBad,tBad,tBad,tBad,tBad,tBad,tBad,tBad,	/* 18 */
	tBad,tBad,tBad,tBad,tBad,tBad,tBad,tBad,tBad,tBad,tBad,tBad,tBad,tBad, 
	/* 32 */ tBad, /* 33 */ tPrint, /* 34 */ tPrint, /* 35 */ tPrint,
	/* 36 */
	tPrint, /* 37 */ tPrint, /* 38 */ tPrint, /* 39 */ tPrint, /* 40 */ tPrint, /* 41 */ tPrint, /* 42 */ tPrint, /* 43 */ tPrint, /* 44 */ tPrint,
	/* 45 */
	tPrint, /* 46 */ tPrint, /* 47 */ tPrint, /* 48 */ tPrint + tDigit, /* 49 */ tPrint + tDigit, /* 50 */ tPrint + tDigit, /* 51 */ tPrint + tDigit,
	/* 52 */
	tPrint + tDigit, /* 53 */ tPrint + tDigit, /* 54 */ tPrint + tDigit, /* 55 */ tPrint + tDigit,
	/* 56 */
	tPrint + tDigit, /* 57 */ tPrint + tDigit, /* 58 */ tPrint, /* 59 */ tPrint, /* 60 */ tPrint, /* 61 */ tPrint,
	/* 62 */
	tPrint, /* 63 */ tPrint, /* 64 */ tPrint,/* 65 */
	tPrint + tEu, /* 66 */ tPrint + tEu, /* 67 */ tPrint + tEu, /* 68 */ tPrint + tEu, /* 69 */ tPrint + tEu, /* 70 */ tPrint + tEu,
	/* 71 */
	tPrint + tEu, /* 72 */ tPrint + tEu, /* 73 */ tPrint + tEu, /* 74 */ tPrint + tEu, /* 75 */ tPrint + tEu, /* 76 */ tPrint + tEu,
	/* 77 */
	tPrint + tEu, /* 78 */ tPrint + tEu, /* 79 */ tPrint + tEu, /* 80 */ tPrint + tEu, /* 81 */ tPrint + tEu, /* 82 */ tPrint + tEu,
	/* 83 */
	tPrint + tEu, /* 84 */ tPrint + tEu, /* 85 */ tPrint + tEu, /* 86 */ tPrint + tEu, /* 87 */ tPrint + tEu, /* 88 */ tPrint + tEu,
	/* 89 */
	tPrint + tEu, /* 90 */ tPrint + tEu,/* 91 */
	tPrint, /* 92 */ tPrint, /* 93 */ tPrint, /* 94 */ tPrint, /* 95 */ tPrint,
	/* 96 */
	tPrint,/* 97 */
	tPrint + tEl, /* 98 */ tPrint + tEl, /* 99 */ tPrint + tEl, /* 100 */ tPrint + tEl, /* 101 */ tPrint + tEl, /* 102 */ tPrint + tEl,
	/* 103 */
	tPrint + tEl, /* 104 */ tPrint + tEl, /* 105 */ tPrint + tEl, /* 106 */ tPrint + tEl, /* 107 */ tPrint + tEl, /* 108 */ tPrint + tEl,
	/* 109 */
	tPrint + tEl, /* 110 */ tPrint + tEl, /* 111 */ tPrint + tEl, /* 112 */ tPrint + tEl, /* 113 */ tPrint + tEl, /* 114 */ tPrint + tEl,
	/* 115 */
	tPrint + tEl, /* 116 */ tPrint + tEl, /* 117 */ tPrint + tEl, /* 118 */ tPrint + tEl, /* 119 */ tPrint + tEl, /* 120 */ tPrint + tEl,
	/* 121 */
	tPrint + tEl, /* 122 */ tPrint + tEl, /* 123 */ tPrint, /* 124 */ tPrint, /* 125 */ tPrint, /* 126 */ tPrint, /* 127 */ tPrint, /* 128 */ tPrint,
	/* 129 */
	tPrint,/* 130 */
	tPrint, /* 131 */ tPrint, /* 132 */ tPrint, /* 133 */ tPrint, /* 134 */ tPrint, /* 135 */ tPrint, /* 136 */ tPrint, /* 137 */ tPrint,/* 138 */
	tPrint, /* 139 */ tPrint, /* 140 */ tPrint, /* 141 */ tPrint, /* 142 */ tPrint, /* 143 */ tPrint, /* 144 */ tPrint, /* 145 */ tPrint,/* 146 */
	tPrint, /* 147 */ tPrint, /* 148 */ tPrint, /* 149 */ tPrint, /* 150 */ tPrint, /* 151 */ tPrint, /* 152 */ tPrint, /* 153 */ tPrint,/* 154 */
	tPrint, /* 155 */ tPrint, /* 156 */ tPrint, /* 157 */ tPrint, /* 158 */ tPrint, /* 159 */ tPrint, /* 160 */ tPrint, /* 161 */ tPrint,/* 162 */
	tPrint, /* 163 */ tPrint, /* 164 */ tPrint, /* 165 */ tPrint, /* 166 */ tPrint, /* 167 */ tPrint, /* 168 */ tPrint + tRu, /* 169 */ tPrint,
	/* 170 */
	tPrint, /* 171 */ tPrint, /* 172 */ tPrint, /* 173 */ tPrint, /* 174 */ tPrint, /* 175 */ tPrint, /* 176 */ tPrint, /* 177 */ tPrint,/* 178 */
	tPrint, /* 179 */ tPrint, /* 180 */ tPrint, /* 181 */ tPrint, /* 182 */ tPrint, /* 183 */ tPrint, /* 184 */ tPrint + tRl, /* 185 */ tPrint,
	/* 186 */
	tPrint, /* 187 */ tPrint, /* 188 */ tPrint, /* 189 */ tPrint, /* 190 */ tPrint, /* 191 */ tPrint, /* 192 */ tPrint + tRu,
	/* 193 */
	tPrint + tRu, /* 194 */ tPrint + tRu, /* 195 */ tPrint + tRu, /* 196 */ tPrint + tRu, /* 197 */ tPrint + tRu, /* 198 */ tPrint + tRu,
	/* 199 */
	tPrint + tRu, /* 200 */ tPrint + tRu, /* 201 */ tPrint + tRu, /* 202 */ tPrint + tRu, /* 203 */ tPrint + tRu, /* 204 */ tPrint + tRu,
	/* 205 */
	tPrint + tRu, /* 206 */ tPrint + tRu, /* 207 */ tPrint + tRu, /* 208 */ tPrint + tRu, /* 209 */ tPrint + tRu, /* 210 */ tPrint + tRu,
	/* 211 */
	tPrint + tRu, /* 212 */ tPrint + tRu, /* 213 */ tPrint + tRu, /* 214 */ tPrint + tRu, /* 215 */ tPrint + tRu, /* 216 */ tPrint + tRu,
	/* 217 */
	tPrint + tRu, /* 218 */ tPrint + tRu, /* 219 */ tPrint + tRu, /* 220 */ tPrint + tRu, /* 221 */ tPrint + tRu, /* 222 */ tPrint + tRu,
	/* 223 */
	tPrint + tRu, /* 224 */ tPrint + tRl, /* 225 */ tPrint + tRl, /* 226 */ tPrint + tRl, /* 227 */ tPrint + tRl, /* 228 */ tPrint + tRl,
	/* 229 */
	tPrint + tRl, /* 230 */ tPrint + tRl, /* 231 */ tPrint + tRl, /* 232 */ tPrint + tRl, /* 233 */ tPrint + tRl, /* 234 */ tPrint + tRl,
	/* 235 */
	tPrint + tRl, /* 236 */ tPrint + tRl, /* 237 */ tPrint + tRl, /* 238 */ tPrint + tRl, /* 239 */ tPrint + tRl, /* 240 */ tPrint + tRl,
	/* 241 */
	tPrint + tRl, /* 242 */ tPrint + tRl, /* 243 */ tPrint + tRl, /* 244 */ tPrint + tRl, /* 245 */ tPrint + tRl, /* 246 */ tPrint + tRl,
	/* 247 */
	tPrint + tRl, /* 248 */ tPrint + tRl, /* 249 */ tPrint + tRl, /* 250 */ tPrint + tRl, /* 251 */ tPrint + tRl, /* 252 */ tPrint + tRl,
	/* 253 */
	tPrint + tRl, /* 254 */ tPrint + tRl, /* 255 */ tPrint + tRl};
	

// ё и Ё не правильно обрабатываются при upper/loverCase
const char uppercase1251R[] = "\xC0\xC1\xC2\xC3\xC4\xC5\xC6\xC7\xC8\xC9\xCA\xCB\xCC\xCD\xCE\xCF\xD0\xD1\xD2\xD3\xD4\xD5\xD6\xD7\xD8\xD9\xDA\xDB\xDC\xDD\xDE\xDF"; /// А..Я
const char lowercase1251R[] = "\xE0\xE1\xE2\xE3\xE4\xE5\xE6\xE7\xE8\xE9\xEA\xEB\xEC\xED\xEE\xEF\xF0\xF1\xF2\xF3\xF4\xF5\xF6\xF7\xF8\xF9\xFA\xFB\xFC\xFD\xFE\xFF"; /// А..Я
const char _1251_866[] = "\x00\x01\x02\x03\x04\x05\x06\x07\x08\x09\x0A\x0B\x0C\x0D\x0E\x0F\x10\x11\x12\x13\x14\x15\x18\x19\x1A\x1B......\x20!\x22#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~.+++++++++++++++++++++++++++++++++++++++1\xF0\x33\x34\x35+++++++++++1\xF1\xFC++++++\x80\x81\x82\x83\x84\x85\x86\x87\x88\x89\x8A\x8B\x8C\x8D\x8E\x8F\x90\x91\x92\x93\x94\x95\x96\x97\x98\x99\x9A\x9B\x9C\x9D\x9E\x9F\xA0\xA1\xA2\xA3\xA4\xA5\xA6\xA7\xA8\xA9\xAA\xAB\xAC\xAD\xAE\xAF\xE0\xE1\xE2\xE3\xE4\xE5\xE6\xE7\xE8\xE9\xEA\xEB\xEC\xED\xEE\xEF";

const char tbl_xD1[62] = {
240,241,242,243,244,245,246,247,248,249,250,251,252,253,254,255,  0,184,144,131,186,190,
179,191,188,154,156,158,157,  0,162,159,  0,  0,210,211,212,213,214,215,216,217,218,219,
220,221,222,223,224,225,226,227,228,229,230,231,232,233,234,235,236,237
};
const char tbl_xD0[63] = {
168,128,129,170,189,178,175,163,138,140,142,141,  0,161,143,192,193,194,195,196,197,198,
199,200,201,202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219,220,
221,222,223,224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239
};
const char tbl_x80[40] = {
150,151,  0,  0,  0,145,146,130,  0,147,148,132,  0,134,135,149,  0,  0,  0,133,  0,  0,
  0,  0,  0,  0,  0,  0,  0,137,  0,  0,  0,  0,  0,  0,  0,  0,139,155
};
const char tbl_xC2[36] = {
152,  0,  0,  0,  0,  0,  0,  0,160,  0,  0,  0,164,  0,166,167,  0,169,  0,171,172,173,
174,  0,176,177,  0,  0,  0,181,182,183,  0,  0,  0,187
};

bool isDigit1251(unsigned char c)	  		{ return (mm1251[c] & tDigit) != 0; }
bool isLower1251E(unsigned char c)	  		{ return (mm1251[c] & tEl) != 0;    }
bool isUpper1251E(unsigned char c)	  		{ return (mm1251[c] & tEu) != 0;    }
bool isLower1251R(unsigned char c)	  		{ return (mm1251[c] & tRl) != 0;    }
bool isUpper1251R(unsigned char c)	  		{ return (mm1251[c] & tRu) != 0;    }
bool isLetters1251E(unsigned char c)	  		{ return (mm1251[c] & (tEu + tEl)) != 0; }
bool isLetters1251R(unsigned char c)	  		{ return (mm1251[c] & (tRu + tRl)) != 0; }
bool isLetters1251(unsigned char c)	  		{ return (mm1251[c] & (tRu + tRl + tEu + tEl)) != 0; }
bool isPrintLetters1251(unsigned char c)   	{ return (mm1251[c] & (tPrint)) != 0; }

int CharacterCodeUnitCount(char* stringIterator)   {
	int codeUnitCount = 0;
	char firstCodePoint = *stringIterator;		// Взять первый символ из исходного буфера
	// Если самый значительный бит равен 1, то это символ мульти-кодовой единицы.
	if(firstCodePoint & 0x80)	{
		// Если первый байт равен 11110, то символ состоит из 4 единиц кода
		if((firstCodePoint & 0xF0) == 0xF0)			codeUnitCount = 4;
		// If the first byte is 1110, then the character is composed of 3 code units
		else if((firstCodePoint & 0xE0) == 0xE0)	codeUnitCount = 3;
		// If the first byte is 110, then the character is composed of 2 code units
		else if((firstCodePoint & 0xC0) == 0xC0)	codeUnitCount = 2;
	}
	else	codeUnitCount = 1;

	return codeUnitCount;
} 

// Дописать ch к строке С++
void strChCat(char* str, char ch) {
	int mdl = strlen(str); *(str + mdl) = ch; *(str + mdl + 1) = 0;
}
char* fromUtf8to1251(char* str, char* rez)  {
	int dl = strlen(str);	if(dl == 0) return NULL;
	int id; int r;
	for (int i = 0;;) {
		id = CharacterCodeUnitCount( (str + i) );
		switch(id) {
			case 1:
				strncat(rez, (str + i), 1);		break;
			case 3:
				strcat(rez, "3");				break;
			case 4:
				strcat(rez, "4");				break;
			case 2:
				switch ( *(str + i) )  {
					case '\xD0':
						strChCat(rez, tbl_xD0[(unsigned char)*(str + i + 1) - 129]);
						break;
					case '\xD1':
						strChCat(rez, tbl_xD1[(unsigned char)*(str + i + 1) - 128]);
						break;
					case '\xD2':
						switch ( *(str + i + 1) ) {
							case '\x91': strChCat(rez, 180); break;
							case '\x90': strChCat(rez, 165); break;
							default:     strChCat(rez, 7);   break;
						}
						break;
					case '\xD3':
						break;
					case '\xC2':
						strChCat(rez, tbl_xC2[(unsigned char)*(str + i + 1) - 152]);
						break;
					default:
						strChCat(rez, 63);
				}
		}
		i = i + id;	if (i >= dl) break;
	}
	return rez;
}
char* from1251toUtf8(char* str, char* rez) {
	for(int i = 0; i != strlen(str); i++) {
		char* str1 = (char*)mm1251_Utf8[(unsigned char)*(str + i)];
		strncat(rez, str1, strlen(str1));
	}
	return rez;
}
char toUpper1251(char c) {
	return isLower1251E(c) | isLower1251R(c) ? (unsigned char)(c - 32) : c;
}
char toLower1251(char c) {
	return isUpper1251E(c) | isUpper1251R(c) ? (unsigned char)(c + 32) : c;
}
char* toUpper1251(char* str, char* rez) {
	for(int i = 0; i != strlen(str); i++) strChCat(rez, toUpper1251( *(str + i) ));
	return rez;
}
char* from1251to866(char* str, char* rez) {
	for(int i = 0; i != strlen(str); i++) {
		strncat(rez, &(_1251_866[(unsigned char)*(str + i)]), 1);
	}
	return rez;
}
