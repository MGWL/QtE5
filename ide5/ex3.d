// ex3 - Test MiniMono for D
//
// Compile:
//      dmd ex3 minimono zdll

import core.runtime;     // Загрузка DLL Для Win
import std.stdio;        // writeln
import minimono;
import zdll;
import std.conv;
import std.string;

int main(string[] args) {
	// virtual machine settings
	MINIMONOVM vm;
	
	MINIM_STR command;
	MINIM_STR expr;
    MINIM_STR res;
	MINIM_STR str;
	MINIM_STR list;
	MINIM_STR value;

	//
	int ret;
	int r;

	
	// Load DLL/SO for MiniMono
	auto rload = loadMiniMonoDll(libMiniMono);
	if(rload != MINIMONO_SUCCESS) writeln("Error load DLL: " ~ libMiniMono); 
	
	// get default MiniMono settings
	GetDefaultSettingsVM(&vm);

	vm.DataFile = "empty.dat";		// assign datafile name you are using
	vm.DBCacheSize = 10;							// 10 Mbytes
	vm.JournalingEnabled = 0;						// this example does not require journaling
	vm.LocaleFileName = "Rus.n";		// assign datafile name you are using
	
	ret = CreateMiniMonoVM( &vm );
	switch(ret)
	{
	case MINIMONO_SUCCESS:
		writeln("CreateMiniMonoVM: MiniMono virtual machine created");	  break;
	case MINIMONO_CREATED:
			writeln("Virtual machine already exists ...");  FreeMiniMonoVM(); return 1;	  break;
	default:
			writeln("Error created virtual machine ..."); FreeMiniMonoVM(); return 1;
	}

	// -------------------------------------------------------------
	// execute commands
	command.len = cast(ushort)sprintf( cast(char*)command.data, `s var=$lb("AAA","BBB",777,12.3)`);
	vm.cbfunc.Execute( &command );

	// read value of an expression
	expr.len = cast(ushort)sprintf( cast(char*)expr.data, "var"); vm.cbfunc.Eval( &expr, &list);

	// display list length was read de facto
	int n = MNMListLength( &list);
	printf( "Actual length of the list is: %d\n", n);

	// unpack and display list items separately
	for( int i = 1; i <= n; i ++)  {
		// unpack i item from list into value
		MNMListGet( &list, i, &value);
		// convert into string in any case
		vm.cbfunc.GetStr( &value, &str);
		// show value as a string
		printf( "Item %d : %.*s\n", i, str.len, cast(char*)str.data);
	}
	writeln();

	// create list structure
	// initial value of the list is an empty string
	list.len = 0;
	command.len = 0;
	value.len = 0;
	
	// add integer value
	vm.cbfunc.SetInt32( 123456, &value);
	// set as 1 list item
	MNMListSet( &list, 1, &value);
	
	// add double value
	vm.cbfunc.SetDouble( 123.456, &value);
	// set as 2 list item
	MNMListSet( &list, 2, &value);

	// add string value
	value.len = cast(ushort)sprintf( cast(char*)value.data, "Hello, lists!");
	// set as 3 list item
	MNMListSet( &list, 3, &value);

	// write to local variable
	vm.cbfunc.WriteLocal( cast(char*)"varname".ptr, 0, null, &list);
	
	// display list length was read de facto
	expr.len = cast(ushort)sprintf( cast(char*)expr.data, "varname");	vm.cbfunc.Eval( &expr, &list);
	n = MNMListLength( &list);
	printf( "Actual length of the list is: %d\n", n);

	MINIM_STR value2, str2;

	// unpack and display list items separately
	for( int i = 1; i != n+1; i ++)  {
		// unpack i item from list into value
		MNMListGet( &list, i, &value2);
		// convert into string in any case
		// vm.cbfunc.GetStr( &value2, &str2);
		// show value as a string
		// printf( "Item %d : %.*s\n", i, str2.len, cast(char*)str2.data);
		switch(value2.type) {
			case MT_MT_DOUBLE:
				writeln("Rez is double: ", *cast(double*)value2.data);
				break;
			case MT_INT32:
				writeln("Rez is integer: ", *cast(int*)value2.data);
				break;
			case MT_INT64:
				writeln("Rez is long: ", *cast(long*)value2.data);
				break;
			default:
				writeln( "String: ", fromStringz(cast(char*)value2.data) );
				break;
		}
		
	}
	writeln();

	// execute commands
	command.len = cast(ushort)sprintf( cast(char*)command.data, `s var=$lb("AAA","BBB",777,12.3)`);
	vm.cbfunc.Execute( &command );

	// read value of an expression
	expr.len = cast(ushort)sprintf( cast(char*)expr.data, "var");
	vm.cbfunc.Eval( &expr, &list);

	// display list length was read de facto
	n = MNMListLength( &list);
	printf( "Actual length of the list is: %d\n", n);

	// unpack and display list items separately
	for( int i = 1; i <= n; i ++)  {
		// unpack i item from list into value
		MNMListGet( &list, i, &value);
		// convert into string in any case
		vm.cbfunc.GetStr( &value, &str);
		// show value as a string
		printf( "Item %d : %.*s\n", i, str.len, cast(char*)str.data);
	}
	writeln();
 
	// read list items from MUMPS context
	for( int i = 1; i <= 3; i++)	{
		expr.len = cast(ushort)sprintf( cast(char*)expr.data, cast(char*)"$lg(varname,%d)", i);
		vm.cbfunc.Eval( &expr, &value);
		// values can have non-string format, convert before display
		vm.cbfunc.GetStr( &value, &str);
		printf( "List item %d : %.*s\n", i, str.len, cast(char*)str.data);
	}

	// show special symbols decoration
	writeln( "Strings decorated with MUMPS expression syntax:");

	// number
	value.len = cast(ushort)sprintf( cast(char*)value.data, "%G,%s", 123.456, "hello".ptr);
	MNMText( &value, &str);
	// result is always a string, separate conversion does not required
	printf( "Result: %.*s\n", str.len, cast(char*)str.data);
	
	// printable string
	value.len = cast(ushort)sprintf( cast(char*)value.data, "%s", "Hello, world!".ptr);
	MNMText( &value, &str);
	printf( "Result: %.*s\n", str.len, cast(char*)str.data);

	// string with nonprintable characters
	value.len = cast(ushort)sprintf( cast(char*)value.data, "%s", "String\r\nwith line feeds\r\n\tand tabs\t".ptr);
	MNMText( &value, &str);
	printf( "Result: %.*s\n", str.len, cast(char*)str.data);

	// free virtual machine
	FreeMiniMonoVM();

	return 0;
}

