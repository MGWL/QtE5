import forth;
int main(string[] args) {
   initForth();         // Активизируем Форт
   includedForth("testQtE5.f");   // Читаю файл
   return 0;
}