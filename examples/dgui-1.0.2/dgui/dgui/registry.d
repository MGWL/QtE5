/** DGui project file.

Copyright: Trogu Antonio Davide 2011-2013

License: $(HTTP boost.org/LICENSE_1_0.txt, Boost License 1.0).

Authors: Trogu Antonio Davide
*/
module dgui.registry;

pragma(lib, "advapi32.lib");

private import std.utf: toUTFz, toUTF8;
private import std.string: format;
private import std.conv;
import dgui.core.winapi;
import dgui.core.interfaces.idisposable;
import dgui.core.exception;
import dgui.core.handle;

enum RegistryValueType: uint
{
	binary = REG_BINARY,
	dword = REG_DWORD,
	qword = REG_QWORD,
	string_ = REG_SZ,
}

interface IRegistryValue
{
	public void write(RegistryKey owner, string name);
	public RegistryValueType valueType();
}

abstract class RegistryValue(T): IRegistryValue
{
	private T _value;

	public this(T val)
	{
		this._value = val;
	}

	@property public abstract RegistryValueType valueType();
}

final class RegistryValueBinary: RegistryValue!(ubyte[])
{
	public this(ubyte[] b)
	{
		super(b);
	}

	@property public override RegistryValueType valueType()
	{
		return RegistryValueType.binary;
	}

	public override string toString()
	{
		string s;

		foreach(ubyte b; this._value)
		{
			s ~= format("%02X", b);
		}

		return s;
	}

	public void write(RegistryKey owner, string name)
	{
		ulong res = RegSetValueExW(owner.handle, toUTFz!(wchar*)(name), 0, REG_BINARY, cast(ubyte*)this._value.ptr, this._value.length);

		if(res != ERROR_SUCCESS)
		{
			throwException!(RegistryException)("RegSetValueEx failed, Key '%s'", name);
		}
	}
}

final class RegistryValueString: RegistryValue!(string)
{
	public this(string s)
	{
		super(s);
	}

	@property public override RegistryValueType valueType()
	{
		return RegistryValueType.string_;
	}

	public override string toString()
	{
		return this._value.idup;
	}

	public void write(RegistryKey owner, string name)
	{
		ulong res = RegSetValueExW(owner.handle, toUTFz!(wchar*)(name), 0, REG_SZ, cast(ubyte*)this._value.ptr, this._value.length);

		if(res != ERROR_SUCCESS)
		{
			throwException!(RegistryException)("RegSetValueEx failed, Key '%s'", name);
		}
	}
}

final class RegistryValueDword: RegistryValue!(uint)
{
	public this(uint i)
	{
		super(i);
	}

	@property public override RegistryValueType valueType()
	{
		return RegistryValueType.dword;
	}

	public override string toString()
	{
		return to!(string)(this._value);
	}

	public void write(RegistryKey owner, string name)
	{
		ulong res = RegSetValueExW(owner.handle, toUTFz!(wchar*)(name), 0, REG_DWORD, cast(ubyte*)&this._value, uint.sizeof);

		if(res != ERROR_SUCCESS)
		{
			throwException!(RegistryException)("RegSetValueEx failed, Key '%s'", name);
		}
	}
}

final class RegistryValueQword: RegistryValue!(ulong)
{
	public this(ulong l)
	{
		super(l);
	}

	@property public override RegistryValueType valueType()
	{
		return RegistryValueType.qword;
	}

	public override string toString()
	{
		return to!(string)(this._value);
	}

	public void write(RegistryKey owner, string name)
	{
		ulong res = RegSetValueExW(owner.handle, toUTFz!(wchar*)(name), 0, REG_QWORD, cast(ubyte*)&this._value, ulong.sizeof);

		if(res != ERROR_SUCCESS)
		{
			throwException!(RegistryException)("RegSetValueEx failed, Key '%s'", name);
		}
	}
}

final class RegistryKey: Handle!(HKEY), IDisposable
{
	private bool _owned;

	package this(HKEY hKey, bool owned = true)
	{
		this._handle = hKey;
		this._owned = owned;
	}

	public ~this()
	{
		this.dispose();
	}

	public void dispose()
	{
		if(this._owned)
		{
			RegCloseKey(this._handle);
			this._handle = null;
		}
	}

	private void doDeleteSubKey(HKEY hKey, string name)
	{
		const uint MAX_KEY_LENGTH = 0xFF;
		const uint MAX_VALUE_NAME = 0x3FFF;

		HKEY hDelKey;
		uint valuesCount, subKeysCount;
		wchar[] keyName = new wchar[MAX_KEY_LENGTH];
		wchar[] valName = new wchar[MAX_VALUE_NAME];

		if(RegOpenKeyExW(hKey, toUTFz!(wchar*)(name), 0, KEY_ALL_ACCESS, &hDelKey) != ERROR_SUCCESS)
		{
			throwException!(RegistryException)("Cannot open Key '%s'", to!(string)(name.ptr));
		}

		if(RegQueryInfoKeyW(hDelKey, null, null, null, &subKeysCount, null, null, &valuesCount, null, null, null, null) != ERROR_SUCCESS)
		{
			throwException!(RegistryException)("Cannot query Key '%s'", to!(string)(name.ptr));
		}

		for(int i = 0; i < subKeysCount; i++)
		{
			uint size = MAX_KEY_LENGTH;

			RegEnumKeyExW(hDelKey, 0, keyName.ptr, &size, null, null, null, null);
		}
			this.doDeleteSubKey(hDelKey, toUTF8(keyName));

		for(int i = 0; i < valuesCount; i++)
		{
			uint size = MAX_VALUE_NAME;

			if(RegEnumValueW(hDelKey, 0, valName.ptr, &size, null, null, null, null) != ERROR_SUCCESS)
			{
				throwException!(RegistryException)("Cannot enumerate values from key '%s'", name);
			}

			if(RegDeleteValueW(hDelKey, valName.ptr) != ERROR_SUCCESS)
			{
				throwException!(RegistryException)("Cannot delete Value '%s'", toUTF8(valName));
			}
		}

		RegCloseKey(hDelKey);

		if(RegDeleteKeyW(hKey, toUTFz!(wchar*)(name)) != ERROR_SUCCESS)
		{
			throwException!(RegistryException)("Cannot delete Key '%s'", to!(string)(name.ptr));
		}
	}

	public RegistryKey createSubKey(string name)
	{
		HKEY hKey;
		uint disp;

		int res = RegCreateKeyExW(this._handle, toUTFz!(wchar*)(name), 0, null, 0, KEY_ALL_ACCESS, null, &hKey, &disp);

		switch(res)
		{
			case ERROR_SUCCESS:
				return new RegistryKey(hKey);

			default:
				throwException!(RegistryException)("Cannot create Key '%s'", name);
		}

		return null;
	}

	public void deleteSubKey(string name)
	{
		this.doDeleteSubKey(this._handle, name);
	}

	public RegistryKey getSubKey(string name)
	{
		HKEY hKey;

		int res = RegOpenKeyExW(this._handle, toUTFz!(wchar*)(name), 0, KEY_ALL_ACCESS, &hKey);

		switch(res)
		{
			case ERROR_SUCCESS:
				return new RegistryKey(hKey);

			default:
				throwException!(RegistryException)("Cannot retrieve Key '%s'", name);
		}

		return null;
	}

	public void setValue(string name, IRegistryValue val)
	{
		val.write(this, name);
	}

	public IRegistryValue getValue(string name)
	{
		uint len;
		uint type;
		IRegistryValue ival = null;

		int res = RegQueryValueExW(this._handle, toUTFz!(wchar*)(name), null, &type, null, &len);

		if(res != ERROR_SUCCESS)
		{
			return null;
		}

		switch(type)
		{
			case REG_BINARY:
				ubyte[] val = new ubyte[len];
				RegQueryValueExW(this._handle, toUTFz!(wchar*)(name), null, &type, val.ptr, &len);
				ival = new RegistryValueBinary(val);
				break;

			case REG_DWORD:
				uint val;
				RegQueryValueExW(this._handle, toUTFz!(wchar*)(name), null, &type, cast(ubyte*)&val, &len);
				ival = new RegistryValueDword(val);
				break;

			case REG_QWORD:
				ulong val;
				RegQueryValueExW(this._handle, toUTFz!(wchar*)(name), null, &type, cast(ubyte*)&val, &len);
				ival = new RegistryValueQword(val);
				break;

			case REG_SZ:
				wchar[] val = new wchar[len];
				RegQueryValueExW(this._handle, toUTFz!(wchar*)(name), null, &type, cast(ubyte*)val.ptr, &len);
				ival = new RegistryValueString(toUTF8(val));
				break;

			default:
				throwException!(RegistryException)("Unsupported Format");
		}

		return ival;
	}
}

final class Registry
{
	private static RegistryKey _classesRoot;
	private static RegistryKey _currentConfig;
	private static RegistryKey _currentUser;
	private static RegistryKey _dynData;
	private static RegistryKey _localMachine;
	private static RegistryKey _performanceData;
	private static RegistryKey _users;

	private this()
	{

	}

	@property public static RegistryKey classesRoot()
	{
		if(!_classesRoot)
		{
			_classesRoot = new RegistryKey(HKEY_CLASSES_ROOT, false);
		}

		return _classesRoot;
	}

	@property public static RegistryKey currentConfig()
	{
		if(!_currentConfig)
		{
			_currentConfig = new RegistryKey(HKEY_CURRENT_CONFIG, false);
		}

		return _currentConfig;
	}

	@property public static RegistryKey currentUser()
	{
		if(!_currentUser)
		{
			_currentUser = new RegistryKey(HKEY_CURRENT_USER, false);
		}

		return _currentUser;
	}

	@property public static RegistryKey dynData()
	{
		if(!_dynData)
		{
			_dynData = new RegistryKey(HKEY_DYN_DATA, false);
		}

		return _dynData;
	}

	@property public static RegistryKey localMachine()
	{
		if(!_localMachine)
		{
			_localMachine = new RegistryKey(HKEY_LOCAL_MACHINE, false);
		}

		return _localMachine;
	}

	@property public static RegistryKey performanceData()
	{
		if(!_performanceData)
		{
			_performanceData = new RegistryKey(HKEY_PERFORMANCE_DATA, false);
		}

		return _performanceData;
	}


	@property public static RegistryKey users()
	{
		if(!_users)
		{
			_users = new RegistryKey(HKEY_USERS, false);
		}

		return _users;
	}
}
