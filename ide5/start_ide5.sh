#!/bin/sh
dmd veryfqt
if [ $? -eq 0 ]; then
	LD_LIBRARY_PATH=`pwd` 
	export LD_LIBRARY_PATH
	./veryfqt
	if [ $? -eq 0 ]; then
		dmd ide5 qte5 qte5prs ini asc1251
		./ide5 -i pr1.ini
	else
		echo "Problem with Qt."
	fi
else
	echo "Compile veryfqt.d is bad. Veryfy dmd install."
fi
