// ex2 - Test MiniMono for D
//
// Compile:
//      dmd ex1 minimono zdll

import core.runtime;     // Загрузка DLL Для Win
import std.stdio;        // writeln
import minimono;
import zdll;
import std.conv;
import std.string;

int main(string[] args) {
	// virtual machine settings
	MINIMONOVM vm;
	MINIM_STR expr, res;
	MINIM_STR strm;

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
			writeln("CreateMiniMonoVM: MiniMono virtual machine created");
	  break;
	case MINIMONO_CREATED:
			writeln("Virtual machine already exists ...");  FreeMiniMonoVM(); return 1;
	  break;
	default:
			writeln("Error created virtual machine ..."); FreeMiniMonoVM(); return 1;
	}

	int n = 5;
	string z = format("f i=1:1:%s s a(i)=(i*i*i*i)+7591567314", n);
	
	fromStringToExp(&expr, z);
	r = vm.cbfunc.Execute( &expr );     if(r) writeln(("Error Execute()")); 
	  // read result of assignment made by commands
	for( int i = 1; i <= n; i++) {
		// create an expression to read
		fromStringToExp(&expr, format("a(%s)", i));
		r = vm.cbfunc.Eval( &expr, &res);	if(r) writeln(("Error Eval()")); 
		// Read using D
		writeln("D = ", cast(long)*(cast(long*)res.data.ptr));
		// Read using Minimono
		writeln("M = ", vm.cbfunc.GetInt64(&res));

		vm.cbfunc.GetStr( &res, &strm);
		writeln( "Convert to string: " ~ fromResToString(&strm) );
	}
	// free virtual machine
	FreeMiniMonoVM();
	return 0;
}

