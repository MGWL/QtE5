/** DGui project file.

Copyright: Trogu Antonio Davide 2011-2013

License: $(HTTP boost.org/LICENSE_1_0.txt, Boost License 1.0).

Authors: Trogu Antonio Davide
*/
module dgui.core.exception;

import std.string: format;
import std.windows.syserror;
import dgui.core.winapi: GetLastError;

mixin template exceptionBody()
{
	public this(string msg)
	{
		super(msg);
	}
}

final class DGuiException: Exception
{
	mixin exceptionBody;
}

final class Win32Exception: Exception
{
	mixin exceptionBody;
}

final class RegistryException: Exception
{
	mixin exceptionBody;
}

final class GDIException: Exception
{
	mixin exceptionBody;
}

final class WindowsNotSupportedException: Exception
{
	mixin exceptionBody;
}

void throwException(T1, T2...)(string fmt, T2 args)
{
	static if(is(T1: Win32Exception))
	{
		throw new T1(format(fmt ~ "\nWindows Message: '%s'", args, sysErrorString(GetLastError())));
	}
	else
	{
		throw new T1(format(fmt, args));
	}
}
