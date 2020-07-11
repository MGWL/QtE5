/** DGui project file.

Copyright: Trogu Antonio Davide 2011-2013

License: $(HTTP boost.org/LICENSE_1_0.txt, Boost License 1.0).

Authors: Trogu Antonio Davide
*/
module dgui.core.events.keyeventargs;

public import dgui.core.events.eventargs;

enum Keys: uint // docmain
{
	none =     0, /// No keys specified.

	///
	shift =    0x10000, /// Modifier keys.
	control =  0x20000,
	alt =      0x40000,

	a = 'A', /// Letters.
	b = 'B',
	c = 'C',
	d = 'D',
	e = 'E',
	f = 'F',
	g = 'G',
	h = 'H',
	i = 'I',
	j = 'J',
	k = 'K',
	l = 'L',
	m = 'M',
	n = 'N',
	o = 'O',
	p = 'P',
	q = 'Q',
	r = 'R',
	s = 'S',
	t = 'T',
	u = 'U',
	v = 'V',
	w = 'W',
	x = 'X',
	y = 'Y',
	z = 'Z',

	d0 = '0', /// Digits.
	d1 = '1',
	d2 = '2',
	d3 = '3',
	d4 = '4',
	d5 = '5',
	d6 = '6',
	d7 = '7',
	d8 = '8',
	d9 = '9',

	f1 = 112, /// F - function keys.
	f2 = 113,
	f3 = 114,
	f4 = 115,
	f5 = 116,
	f6 = 117,
	f7 = 118,
	f8 = 119,
	f9 = 120,
	f10 = 121,
	f11 = 122,
	f12 = 123,
	f13 = 124,
	f14 = 125,
	f15 = 126,
	f16 = 127,
	f17 = 128,
	f18 = 129,
	f19 = 130,
	f20 = 131,
	f21 = 132,
	f22 = 133,
	f23 = 134,
	f24 = 135,

	numPad0 = 96, /// Numbers on keypad.
	numPad1 = 97,
	numPad2 = 98,
	numPad3 = 99,
	numPad4 = 100,
	numPad5 = 101,
	numPad6 = 102,
	numPad7 = 103,
	numPad8 = 104,
	numPad9 = 105,

	add = 107, ///
	apps = 93, /// Application.
	attn = 246, ///
	back = 8, /// Backspace.
	cancel = 3, ///
	capital = 20, ///
	capsLock = 20,
	clear = 12, ///
	controlKey = 17, ///
	crSel = 247, ///
	decimal = 110, ///
	del = 46, ///
	delete_ = del, ///
	period = 190, ///
	dot = period,
	divide = 111, ///
	down = 40, /// Down arrow.
	end = 35, ///
	enter = 13, ///
	eraseEOF = 249, ///
	escape = 27, ///
	execute = 43, ///
	exsel = 248, ///
	finalMode = 4, /// IME final mode.
	hangulMode = 21, /// IME Hangul mode.
	hanguelMode = 21,
	hanjaMode = 25, /// IME Hanja mode.
	help = 47, ///
	home = 36, ///
	imeAccept = 30, ///
	imeConvert = 28, ///
	imeModeChange = 31, ///
	imeNonConvert = 29, ///
	insert = 45, ///
	junjaMode = 23, ///
	kanaMode = 21, ///
	kanjiMode = 25, ///
	leftControl = 162, /// Left Ctrl.
	left = 37, /// Left arrow.
	lineFeed = 10, ///
	leftMenu = 164, /// Left Alt.
	leftShift = 160, ///
	leftWin = 91, /// Left Windows logo.
	menu = 18, /// Alt.
	multiply = 106, ///
	next = 34, /// Page down.
	noName = 252, // Reserved for future use.
	numLock = 144, ///
	oem8 = 223, // OEM specific.
	oemClear = 254,
	pa1 = 253,
	pageDown = 34, ///
	pageUp = 33, ///
	pause = 19, ///
	play = 250, ///
	print = 42, ///
	printScreen = 44, ///
	processKey = 229, ///
	rightControl = 163, /// Right Ctrl.
	return_ = 13, ///
	right = 39, /// Right arrow.
	rightMenu = 165, /// Right Alt.
	rightShift = 161, ///
	rightWin = 92, /// Right Windows logo.
	scroll = 145, /// Scroll lock.
	select = 41, ///
	separator = 108, ///
	shiftKey = 16, ///
	snapshot = 44, /// Print screen.
	space = 32, ///
	spacebar = space, // Extra.
	subtract = 109, ///
	tab = 9, ///
	up = 38, /// Up arrow.
	zoom = 251, ///

	// Windows 2000+
	browserBack = 166, ///
	browserFavorites = 171,
	browserForward = 167,
	browserHome = 172,
	browserRefresh = 168,
	browserSearch = 170,
	browserStop = 169,
	launchApplication1 = 182, ///
	launchApplication2 = 183,
	launchMail = 180,
	mediaNextTrack = 176, ///
	mediaPlayPause = 179,
	mediaPreviousTrack = 177,
	mediaStop = 178,
	oemBackslash = 226, // OEM angle bracket or backslash.
	oemCloseBrackets = 221,
	oemComma = 188,
	oemMinus = 189,
	oemOpenBrackets = 219,
	oemPeriod = 190,
	oemPipe = 220,
	oemPlus = 187,
	oemQuestion = 191,
	oemQuotes = 222,
	oemSemicolon = 186,
	oemTilde = 192,
	selectMedia = 181, ///
	volumeDown = 174, ///
	volumeMute = 173,
	volumeUp = 175,

	/// Bit mask to extract key code from key value.
	keyCode = 0xFFFF,

	/// Bit mask to extract modifiers from key value.
	modifiers = 0xFFFF0000,
}

class KeyEventArgs: EventArgs
{
	private Keys _keys;
	private bool _handled = true;

	public this(Keys keys)
	{
		this._keys = keys;
	}

	@property public Keys keyCode()
	{
		return this._keys;
	}

	@property public bool handled()
	{
		return this._handled;
	}

	@property public void handled(bool b)
	{
		this._handled = b;
	}
}

class KeyCharEventArgs: KeyEventArgs
{
	private char _keyChar;

	public this(Keys keys, char keyCh)
	{
		super(keys);
		this._keyChar = keyCh;
	}

	@property public char keyChar()
	{
		return this._keyChar;
	}
}
