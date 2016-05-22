@echo off
rem Make veryfy Qt-5
dmd veryfqt
if errorlevel 1 goto d1_error

veryfqt
if errorlevel 1 goto d_end

rem €зготовление ide5 - прототипа интегрированной среды
dmd ide5 qte5 qte5prs asc1251 ini
if errorlevel 1 goto d2_error

rem start
ide5 -i pr1.ini
goto d_end

:d2_error
echo Error make ide5
goto d_end

:d1_error
echo Error make veryfqt.exe from veryfqt.d
goto d_end

:d_end
