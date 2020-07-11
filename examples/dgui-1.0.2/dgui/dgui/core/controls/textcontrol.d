/** DGui project file.

Copyright: Trogu Antonio Davide 2011-2013

License: $(HTTP boost.org/LICENSE_1_0.txt, Boost License 1.0).

Authors: Trogu Antonio Davide
*/
module dgui.core.controls.textcontrol;

public import dgui.core.controls.subclassedcontrol;

abstract class TextControl: SubclassedControl
{
	public Event!(Control, EventArgs) textChanged;

	public void appendText(string s)
	{
		if(this.created)
		{
			this.sendMessage(EM_REPLACESEL, true, cast(LPARAM)toUTFz!(wchar*)(s));
		}
		else
		{
			this._text ~= s;
		}
	}

	@property public final bool readOnly()
	{
		return cast(bool)(this.getStyle() & ES_READONLY);
	}

	@property public final void readOnly(bool b)
	{
		this.setStyle(ES_READONLY, b);
	}

	public void undo()
	{
		this.sendMessage(EM_UNDO, 0, 0);
	}

	public void cut()
	{
		this.sendMessage(WM_CUT, 0, 0);
	}

	public void copy()
	{
		this.sendMessage(WM_COPY, 0, 0);
	}

	public void paste()
	{
		this.sendMessage(WM_PASTE, 0, 0);
	}

	public void selectAll()
	{
		this.sendMessage(EM_SETSEL, 0, -1);
	}

	public void clear()
	{
		this.sendMessage(WM_CLEAR, 0, 0);
	}

	@property public bool modified()
	{
		if(this.created)
		{
			return cast(bool)this.sendMessage(EM_GETMODIFY, 0, 0);
		}

		return false;
	}

	@property public void modified(bool b)
	{
		this.sendMessage(EM_SETMODIFY, b, 0);
	}

	@property public int textLength()
	{
		if(this.created)
		{
			return getWindowTextLength(this._handle);
		}

		return this._text.length;
	}

	@property public final string selectedText()
	{
		CHARRANGE chrg = void; //Inizializzata sotto

		this.sendMessage(EM_EXGETSEL, 0, cast(LPARAM)&chrg);
		return this.text[chrg.cpMin..chrg.cpMax];
	}

	@property public final int selectionStart()
	{
		CHARRANGE chrg = void; //Inizializzata sotto

		this.sendMessage(EM_EXGETSEL, 0, cast(LPARAM)&chrg);
		return chrg.cpMin;
	}

	@property public final int selectionLength()
	{
		CHARRANGE chrg = void; //Inizializzata sotto

		this.sendMessage(EM_EXGETSEL, 0, cast(LPARAM)&chrg);
		return chrg.cpMax - chrg.cpMin;
	}

	protected override void createControlParams(ref CreateControlParams ccp)
	{
		this.setStyle(WS_TABSTOP, true);
		ccp.defaultBackColor = SystemColors.colorWindow;

		super.createControlParams(ccp);
	}

	protected override void onReflectedMessage(ref Message m)
	{
		if(m.msg == WM_COMMAND && HIWORD(m.wParam) == EN_CHANGE && TextControl.hasBit(this._cBits, ControlBits.canNotify))
		{
			this.onTextChanged(EventArgs.empty);
		}

		super.onReflectedMessage(m);
	}

	protected override void onHandleCreated(EventArgs e)
	{
		this.modified = false; // Force to 'False'

		super.onHandleCreated(e);
	}

	protected void onTextChanged(EventArgs e)
	{
		this.textChanged(this, e);
	}
}
