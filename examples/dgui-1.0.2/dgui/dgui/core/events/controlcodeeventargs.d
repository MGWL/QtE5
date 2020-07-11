/** DGui project file.

Copyright: Trogu Antonio Davide 2011-2013

License: $(HTTP boost.org/LICENSE_1_0.txt, Boost License 1.0).

Authors: Trogu Antonio Davide
*/
module dgui.core.events.controlcodeeventargs;

public import dgui.core.events.eventargs;
public import dgui.core.winapi;

enum ControlCode: uint
{
	ignore					= 0,
	button 			    	= DLGC_BUTTON,
	defaultPushButton 	= DLGC_DEFPUSHBUTTON,
	hasSetSel				= DLGC_HASSETSEL,
	radioButton			= DLGC_RADIOBUTTON,
	static_					= DLGC_STATIC,
	noDefaultPushButton  = DLGC_UNDEFPUSHBUTTON,
	wantAllKeys			= DLGC_WANTALLKEYS,
	wantArrows				= DLGC_WANTARROWS,
	wantChars				= DLGC_WANTCHARS,
	wantTab				= DLGC_WANTTAB,
}

class ControlCodeEventArgs: EventArgs
{
	private ControlCode _ctrlCode = ControlCode.ignore;

	@property public ControlCode controlCode()
	{
		return this._ctrlCode;
	}

	@property public void controlCode(ControlCode cc)
	{
		this._ctrlCode = cc;
	}
}
