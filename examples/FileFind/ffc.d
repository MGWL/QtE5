/**
 * Быстрый поиск в именах файлов Win 32/64, Linux 32/64
 *
 * MGW 26.04.2014 18:56:44  +  ревизия 29.07.17
 *
 */

import std.file;
import std.stdio;
import std.path;
import asc1251;

string[]  dirs;                 // Список точек входа для индексации
string  nameFileIndex;          // Имя файла индекса
size_t[1000]  vec;              // вектор кеша на строки до 1000 символов 

struct StNameFile {
    size_t      FullPath;       // Полный путь из массива mPath
    char[]      NameFile;       // Имя файла
	ulong		sizeFile;		// Размер файла
}
StNameFile[] mName;             // массив имен файлов

char[][]  mPath;                // массив Путей. Номер соответствует полнуму пути
size_t[]  iPath;                // Массив списка длинн

void help() {
    writeln();
    writeln("usage: ffc NameFileIndex.txt Dir1 Dir2 ...");
    writeln("------------------------------------------");
    writeln(`ffc index.txt C:\windows D:\ E:\  ---> Example for Windows`);
    writeln(`./ffc index.txt / ---> Start with root user. Example for Linux`);
}

int main(string[] args) {
    char[] nameFile, pathFile; 
    
    foreach (i, arg; args)  { 
        switch(i) {
            case 0:         // Имя программы
                break;
            case 1:         // Имя файла индекса
                nameFileIndex = arg;    break;
            default:
                dirs ~= arg;            break;
        }
    }
    // Проверка имени индекса
    if(nameFileIndex.length == 0) { writeln("Error: Not name file index");  help(); return 1;  }
    // Проверка точек входа
    if(dirs.length == 0) {  writeln("Error: Not dir for index");  help(); return 2;    }
    
    size_t predNom; char[] predPath;                   // Ускоритель
    
    // Вернуть номер пути из массива
    size_t getNomPath(char[] path) {      
        size_t rez, i; bool f = false;
        size_t dlPath = path.length;   // Длина пути уже известна, отлично!
        if(predPath == path)  return predNom;
            
        // Взять длину и посмотреть, если там == 0, то выйти и добавить
        if(vec[dlPath] > 0) {
            size_t nomTest = vec[dlPath] - 1;
            for(;nomTest != 0;) {
                if(path == mPath[nomTest]) {  
                    rez = nomTest; f = true;            // Найдено!!!
                    predPath = path; predNom = rez;     // Запомним в ускорителе
                    break;  
                }  
                else {
                    nomTest = iPath[nomTest];           // Ищем дальше ...
                    if(nomTest>0) nomTest--; 
                }
            }
        }
        
        if(!f) {    // Ни чего не найдено, надо создавать запись
            mPath ~= path;                              // Добавить путь в массив
            rez = mPath.length-1;                       // Запомним новый размер
            // нужно сделать объмен с кешом
            iPath ~= vec[dlPath]; vec[dlPath] = rez + 1;
        }
        return rez;
    } // end getNomPath -----------------------------
    
    string name;
    File fError = File("err" ~ nameFileIndex, "w");
    foreach(nameDir; dirs) {
        // Формируем массивы mPath и iPath
        try {
            // Здесь обрабатываем точки входа
            // char[] tmpName; auto name;
            auto p = dirEntries(nameDir, SpanMode.depth, false); 
            while(!p.empty) {
zz:                    
                try  {
                    name = p.front;
                    char[] tmpName = cast(char[])name;
                    bool f;
                    try {
                        f = isDir(tmpName);
                    }
                    catch(Exception e) {
version(Windows) {
                    fError.writeln(fromUtf8to1251(cast(char[])e.msg), "  - while()");
}
version(linux) {
                    fError.writeln(e.msg, "  - while()");
}					
                        p.popFront();  // NEXT
                        goto zz;
                    }    
                    if(!f) {
                        pathFile = fromUtf8to1251(cast(char[])dirName(tmpName));
                        nameFile = fromUtf8to1251(cast(char[])baseName(tmpName));
                        size_t nom = getNomPath(pathFile);
                        // Добавить элемент в массивы
                        StNameFile el; el.FullPath = nom; el.NameFile = nameFile; el.sizeFile = getSize(name); mName ~= el;
                    }
                    p.popFront();  // NEXT
                }
                catch(Exception e)  {
version(Windows) {
                    fError.writeln(fromUtf8to1251(cast(char[])e.msg), "  - while()");
}
version(linux) {
                    fError.writeln(e.msg, "  - while()");
}					
                    goto zz;
                }
            }
        }
        catch(Exception ee) {   
version(Windows) {
            fError.writeln(fromUtf8to1251(cast(char[])ee.msg), "  - dirEntries()");
}	
version(linux) {
            fError.writeln(ee.msg, "  - dirEntries()");
}	
        }    
    }
    // Массивы построены. Сохраняем в файл.
    File fIndex = File(nameFileIndex, "w");
    foreach(el; mPath) { fIndex.writeln(el); }
    fIndex.writeln("#####");
    foreach(el; mName) { fIndex.writeln(el.FullPath, "|", el.NameFile, "|", el.sizeFile); }
    
    return 0;
}
