/** DGui project file.

Copyright: Trogu Antonio Davide 2011-2013

License: $(HTTP boost.org/LICENSE_1_0.txt, Boost License 1.0).

Authors: Trogu Antonio Davide
*/
module dgui.statusbar;

import std.utf: toUTFz;
import dgui.core.controls.subclassedcontrol;

final class StatusPart
{
	private StatusBar _owner;
	private string _text;
	private int _width;

	package this(StatusBar sb, string txt, int w)
	{
		this._owner = sb;
		this._text = txt;
		this._width = w;
	}

	@property public string text()
	{
		return this._text;
	}

	@property public void text(string s)
	{
		this._text = s;

		if(this._owner && this._owner.created)
		{
			this._owner.sendMessage(SB_SETTEXTW, MAKEWPARAM(this.index, 0), cast(LPARAM)toUTFz!(wchar*)(s));
		}
	}

	@property public int width()
	{
		return this._width;
	}

	@property public int index()
	{
		foreach(int i, StatusPart sp; this._owner.parts)
		{
			if(sp is this)
			{
				return i;
			}
		}

		return -1;
	}

	@property public StatusBar statusBar()
	{
		return this._owner;
	}
}

class StatusBar: SubclassedControl
{
	private Collection!(StatusPart) _parts;
	private bool _partsVisible = false;

	public StatusPart addPart(string s, int w)
	{
		if(!this._parts)
		{
			this._parts = new Collection!(StatusPart)();
		}

		StatusPart sp = new StatusPart(this, s, w);
		this._parts.add(sp);

		if(this.created)
		{
			StatusBar.insertPart(sp);
		}

		return sp;
	}

	public StatusPart addPart(int w)
	{
		return this.addPart(null, w);
	}

	/*
	public void removePanel(int idx)
	{

	}
	*/

	@property public bool partsVisible()
	{
		return this._partsVisible;
	}

	@property public void partsVisible(bool b)
	{
		this._partsVisible = b;

		if(this.created)
		{
			this.setStyle(SBARS_SIZEGRIP, b);
		}
	}

	@property public StatusPart[] parts()
	{
		if(this._parts)
		{
			return this._parts.get();
		}

		return null;
	}

	private static void insertPart(StatusPart stp)
	{
		StatusBar owner = stp.statusBar;
		StatusPart[] sparts = owner.parts;
		uint[] parts = new uint[sparts.length];

		foreach(int i, StatusPart sp; sparts)
		{
			if(!i)
			{
				parts[i] = sp.width;
			}
			else
			{
				parts[i] = parts[i - 1] + sp.width;
			}
		}

		owner.sendMessage(SB_SETPARTS, sparts.length, cast(LPARAM)parts.ptr);

		foreach(int i, StatusPart sp; sparts)
		{
			owner.sendMessage(SB_SETTEXTW, MAKEWPARAM(i, 0), cast(LPARAM)toUTFz!(wchar*)(sp.text));
		}
	}

	protected override void createControlParams(ref CreateControlParams ccp)
	{
		this._dock = DockStyle.bottom; //Force dock

		ccp.superclassName = WC_STATUSBAR;
		ccp.className = WC_DSTATUSBAR;

		if(this._partsVisible)
		{
			this.setStyle(SBARS_SIZEGRIP, true);
		}

		super.createControlParams(ccp);
	}

	protected override void onHandleCreated(EventArgs e)
	{
		if(this._parts)
		{
			foreach(StatusPart sp; this._parts)
			{
				StatusBar.insertPart(sp);
			}
		}

		super.onHandleCreated(e);
	}
}
