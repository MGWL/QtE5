// ex1 - Test MiniMono for D
//
// Compile:
//      dmd ex1 minimono zdll

import core.runtime;     // Load DLL for Windows
import std.stdio;        // writeln
import minimono;
import zdll;
import std.conv;
import std.string;


int main(string[] args) {
	MINIMONOVM vm;
	MINIM_STR expr, res;

	int ret;
	
	// Load DLL/SO for MiniMono
	auto rload = loadMiniMonoDll(libMiniMono);
	if(rload != MINIMONO_SUCCESS) writeln("Error load DLL: " ~ libMiniMono); 
	
	GetDefaultSettingsVM(&vm);                     // get default MiniMono settings

	vm.DataFile = "empty.dat";                 // assign datafile name you are using
	vm.DBCacheSize = 10;							// 10 Mbytes
	vm.JournalingEnabled = 0;						// this example does not require journaling
	vm.LocaleFileName = "Rus.n";		         // assign datafile name you are using
	
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

	// Char '`' allows to write a line with quotes
	fromStringToExp(&expr, `"Hello from MiniMono! Version MiniMono is "_$zversion`);
	if(vm.cbfunc.Eval( &expr, &res)) writeln("Error Eval(...)"); 
	writeln( " -- ", fromResToString(&res) );

	fromStringToExp(&expr, `"Сurrent date: "_$zdate($h,3)`);
	if(vm.cbfunc.Eval( &expr, &res)) writeln("Error Eval(...)"); 
	writeln( " -- ", fromResToString(&res) );

	// free virtual machine
	FreeMiniMonoVM();
	return 0;
}

