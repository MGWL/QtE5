@echo off
set DGUI_LIB=DGui.lib
set SAMPLES_DIR=dgui_samples\
set OUT_DIR=%SAMPLES_DIR%

set samples=events, gradient_rect, gradient_triangle, grid, hello, menu, picture, rawbitmap, resources, splitter, toolbar_32_x_32
set resources=%SAMPLES_DIR%resource.res

if not exist %DGUI_LIB% echo %DGUI_LIB% not found. Build DGui first. && goto reportError

echo Building DGui samples...
setlocal EnableDelayedExpansion
for /d %%f in (%samples%) do (
	echo     %%f.d !%%f!
	dmd -release -de -w  -of%OUT_DIR%%%f.exe -L/SUBSYSTEM:WINDOWS:5.01 %SAMPLES_DIR%%%f.d !%%f! %RES% %DGUI_LIB% || goto reportError
	del %OUT_DIR%%%f.obj
)


goto noError
:reportError
echo Building samples failed.
:noError
echo Done. Somples are here: %OUT_DIR%
