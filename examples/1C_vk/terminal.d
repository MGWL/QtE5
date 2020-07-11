/**
 * Module for supporting cursor and color manipulation on the console.
 *
 * The main interface for this module is the Terminal struct, which
 * encapsulates the functions of the terminal. Creating an instance of
 * this struct will perform console initialization; when the struct
 * goes out of scope, any changes in console settings will be automatically
 * reverted.
 *
 * Note: on Posix, it traps SIGINT and translates it into an input event. You should
 * keep your event loop moving and keep an eye open for this to exit cleanly; simply break
 * your event loop upon receiving a UserInterruptionEvent. (Without
 * the signal handler, ctrl+c can leave your terminal in a bizarre state.)
 *
 * As a user, if you have to forcibly kill your program and the event doesn't work, there's still ctrl+\
 */
module terminal;

// FIXME: ctrl+d eof on stdin

// FIXME: http://msdn.microsoft.com/en-us/library/windows/desktop/ms686016%28v=vs.85%29.aspx

version(linux)
	enum SIGWINCH = 28; // FIXME: confirm this is correct on other posix

version(Posix) {
	__gshared bool windowSizeChanged = false;
	__gshared bool interrupted = false; /// you might periodically check this in a long operation and abort if it is set. Remember it is volatile. It is also sent through the input event loop via RealTimeConsoleInput
	__gshared bool hangedUp = false; /// similar to interrupted.

	version(with_eventloop)
		struct SignalFired {}

	extern(C)
	void sizeSignalHandler(int sigNumber) nothrow {
		windowSizeChanged = true;
		version(with_eventloop) {
			import arsd.eventloop;
			try
				send(SignalFired());
			catch(Exception) {}
		}
	}
	extern(C)
	void interruptSignalHandler(int sigNumber) nothrow {
		interrupted = true;
		version(with_eventloop) {
			import arsd.eventloop;
			try
				send(SignalFired());
			catch(Exception) {}
		}
	}
	extern(C)
	void hangupSignalHandler(int sigNumber) nothrow {
		hangedUp = true;
		version(with_eventloop) {
			import arsd.eventloop;
			try
				send(SignalFired());
			catch(Exception) {}
		}
	}

}

// parts of this were taken from Robik's ConsoleD
// https://github.com/robik/ConsoleD/blob/master/consoled.d

// Uncomment this line to get a main() to demonstrate this module's
// capabilities.
//version = Demo

version(Windows) {
	import core.sys.windows.windows;
	import std.string : toStringz;
	private {
		enum RED_BIT = 4;
		enum GREEN_BIT = 2;
		enum BLUE_BIT = 1;
	}
}

version(Posix) {
}

enum Bright = 0x08;

/// Defines the list of standard colors understood by Terminal.
enum Color : ushort {
	black = 0, /// .
	red = RED_BIT, /// .
	green = GREEN_BIT, /// .
	yellow = red | green, /// .
	blue = BLUE_BIT, /// .
	magenta = red | blue, /// .
	cyan = blue | green, /// .
	white = red | green | blue, /// .
	DEFAULT = 256,
}

/// When capturing input, what events are you interested in?
///
/// Note: these flags can be OR'd together to select more than one option at a time.
///
/// Ctrl+C and other keyboard input is always captured, though it may be line buffered if you don't use raw.
/// The rationale for that is to ensure the Terminal destructor has a chance to run, since the terminal is a shared resource and should be put back before the program terminates.
enum ConsoleInputFlags {
	raw = 0, /// raw input returns keystrokes immediately, without line buffering
	echo = 1, /// do you want to automatically echo input back to the user?
	mouse = 2, /// capture mouse events
	paste = 4, /// capture paste events (note: without this, paste can come through as keystrokes)
	size = 8, /// window resize events

	releasedKeys = 64, /// key release events. Not reliable on Posix.

	allInputEvents = 8|4|2, /// subscribe to all input events. Note: in previous versions, this also returned release events. It no longer does, use allInputEventsWithRelease if you want them.
	allInputEventsWithRelease = allInputEvents|releasedKeys, /// subscribe to all input events, including (unreliable on Posix) key release events.
}

/// Defines how terminal output should be handled.
enum ConsoleOutputType {
	linear = 0, /// do you want output to work one line at a time?
	cellular = 1, /// or do you want access to the terminal screen as a grid of characters?
	//truncatedCellular = 3, /// cellular, but instead of wrapping output to the next line automatically, it will truncate at the edges

	minimalProcessing = 255, /// do the least possible work, skips most construction and desturction tasks. Only use if you know what you're doing here
}

/// Some methods will try not to send unnecessary commands to the screen. You can override their judgement using a ForceOption parameter, if present
enum ForceOption {
	automatic = 0, /// automatically decide what to do (best, unless you know for sure it isn't right)
	neverSend = -1, /// never send the data. This will only update Terminal's internal state. Use with caution.
	alwaysSend = 1, /// always send the data, even if it doesn't seem necessary
}

// we could do it with termcap too, getenv("TERMCAP") then split on : and replace \E with \033 and get the pieces

/// Encapsulates the I/O capabilities of a terminal.
///
/// Warning: do not write out escape sequences to the terminal. This won't work
/// on Windows and will confuse Terminal's internal state on Posix.
struct Terminal {
	// @disable this();
	@disable this(this);
	private ConsoleOutputType type;

	version(Posix) {
		private int fdOut;
		private int fdIn;
		private int[] delegate() getSizeOverride;
	}

	version(Posix) {
		bool terminalInFamily(string[] terms...) {
			import std.process;
			import std.string;
			auto term = environment.get("TERM");
			foreach(t; terms)
				if(indexOf(term, t) != -1)
					return true;

			return false;
		}

		static string[string] termcapDatabase;
		static void readTermcapFile(bool useBuiltinTermcap = false) {
			import std.file;
			import std.stdio;
			import std.string;

			if(!exists("/etc/termcap"))
				useBuiltinTermcap = true;

			string current;

			void commitCurrentEntry() {
				if(current is null)
					return;

				string names = current;
				auto idx = indexOf(names, ":");
				if(idx != -1)
					names = names[0 .. idx];

				foreach(name; split(names, "|"))
					termcapDatabase[name] = current;

				current = null;
			}

			void handleTermcapLine(in char[] line) {
				if(line.length == 0) { // blank
					commitCurrentEntry();
					return; // continue
				}
				if(line[0] == '#') // comment
					return; // continue
				size_t termination = line.length;
				if(line[$-1] == '\\')
					termination--; // cut off the \\
				current ~= strip(line[0 .. termination]);
				// termcap entries must be on one logical line, so if it isn't continued, we know we're done
				if(line[$-1] != '\\')
					commitCurrentEntry();
			}

			if(useBuiltinTermcap) {
				foreach(line; splitLines(builtinTermcap)) {
					handleTermcapLine(line);
				}
			} else {
				foreach(line; File("/etc/termcap").byLine()) {
					handleTermcapLine(line);
				}
			}
		}

		static string getTermcapDatabase(string terminal) {
			import std.string;

			if(termcapDatabase is null)
				readTermcapFile();

			auto data = terminal in termcapDatabase;
			if(data is null)
				return null;

			auto tc = *data;
			auto more = indexOf(tc, ":tc=");
			if(more != -1) {
				auto tcKey = tc[more + ":tc=".length .. $];
				auto end = indexOf(tcKey, ":");
				if(end != -1)
					tcKey = tcKey[0 .. end];
				tc = getTermcapDatabase(tcKey) ~ tc;
			}

			return tc;
		}

		string[string] termcap;
		void readTermcap() {
			import std.process;
			import std.string;
			import std.array;

			string termcapData = environment.get("TERMCAP");
			if(termcapData.length == 0) {
				termcapData = getTermcapDatabase(environment.get("TERM"));
			}

			auto e = replace(termcapData, "\\\n", "\n");
			termcap = null;

			foreach(part; split(e, ":")) {
				// FIXME: handle numeric things too

				auto things = split(part, "=");
				if(things.length)
					termcap[things[0]] =
						things.length > 1 ? things[1] : null;
			}
		}

		string findSequenceInTermcap(in char[] sequenceIn) {
			char[10] sequenceBuffer;
			char[] sequence;
			if(sequenceIn.length > 0 && sequenceIn[0] == '\033') {
				if(!(sequenceIn.length < sequenceBuffer.length - 1))
					return null;
				sequenceBuffer[1 .. sequenceIn.length + 1] = sequenceIn[];
				sequenceBuffer[0] = '\\';
				sequenceBuffer[1] = 'E';
				sequence = sequenceBuffer[0 .. sequenceIn.length + 1];
			} else {
				sequence = sequenceBuffer[1 .. sequenceIn.length + 1];
			}

			import std.array;
			foreach(k, v; termcap)
				if(v == sequence)
					return k;
			return null;
		}

		string getTermcap(string key) {
			auto k = key in termcap;
			if(k !is null) return *k;
			return null;
		}

		// Looks up a termcap item and tries to execute it. Returns false on failure
		bool doTermcap(T...)(string key, T t) {
			import std.conv;
			auto fs = getTermcap(key);
			if(fs is null)
				return false;

			int swapNextTwo = 0;

			R getArg(R)(int idx) {
				if(swapNextTwo == 2) {
					idx ++;
					swapNextTwo--;
				} else if(swapNextTwo == 1) {
					idx --;
					swapNextTwo--;
				}

				foreach(i, arg; t) {
					if(i == idx)
						return to!R(arg);
				}
				assert(0, to!string(idx) ~ " is out of bounds working " ~ fs);
			}

			char[256] buffer;
			int bufferPos = 0;

			void addChar(char c) {
				import std.exception;
				enforce(bufferPos < buffer.length);
				buffer[bufferPos++] = c;
			}

			void addString(in char[] c) {
				import std.exception;
				enforce(bufferPos + c.length < buffer.length);
				buffer[bufferPos .. bufferPos + c.length] = c[];
				bufferPos += c.length;
			}

			void addInt(int c, int minSize) {
				import std.string;
				auto str = format("%0"~(minSize ? to!string(minSize) : "")~"d", c);
				addString(str);
			}

			bool inPercent;
			int argPosition = 0;
			int incrementParams = 0;
			bool skipNext;
			bool nextIsChar;
			bool inBackslash;

			foreach(char c; fs) {
				if(inBackslash) {
					if(c == 'E')
						addChar('\033');
					else
						addChar(c);
					inBackslash = false;
				} else if(nextIsChar) {
					if(skipNext)
						skipNext = false;
					else
						addChar(cast(char) (c + getArg!int(argPosition) + (incrementParams ? 1 : 0)));
					if(incrementParams) incrementParams--;
					argPosition++;
					inPercent = false;
				} else if(inPercent) {
					switch(c) {
						case '%':
							addChar('%');
							inPercent = false;
						break;
						case '2':
						case '3':
						case 'd':
							if(skipNext)
								skipNext = false;
							else
								addInt(getArg!int(argPosition) + (incrementParams ? 1 : 0),
									c == 'd' ? 0 : (c - '0')
								);
							if(incrementParams) incrementParams--;
							argPosition++;
							inPercent = false;
						break;
						case '.':
							if(skipNext)
								skipNext = false;
							else
								addChar(cast(char) (getArg!int(argPosition) + (incrementParams ? 1 : 0)));
							if(incrementParams) incrementParams--;
							argPosition++;
						break;
						case '+':
							nextIsChar = true;
							inPercent = false;
						break;
						case 'i':
							incrementParams = 2;
							inPercent = false;
						break;
						case 's':
							skipNext = true;
							inPercent = false;
						break;
						case 'b':
							argPosition--;
							inPercent = false;
						break;
						case 'r':
							swapNextTwo = 2;
							inPercent = false;
						break;
						// FIXME: there's more
						// http://www.gnu.org/software/termutils/manual/termcap-1.3/html_mono/termcap.html

						default:
							assert(0, "not supported " ~ c);
					}
				} else {
					if(c == '%')
						inPercent = true;
					else if(c == '\\')
						inBackslash = true;
					else
						addChar(c);
				}
			}

			writeStringRaw(buffer[0 .. bufferPos]);
			return true;
		}
	}

	version(Posix)
	/**
	 * Constructs an instance of Terminal representing the capabilities of
	 * the current terminal.
	 *
	 * While it is possible to override the stdin+stdout file descriptors, remember
	 * that is not portable across platforms and be sure you know what you're doing.
	 *
	 * ditto on getSizeOverride. That's there so you can do something instead of ioctl.
	 */
	this(ConsoleOutputType type, int fdIn = 0, int fdOut = 1, int[] delegate() getSizeOverride = null) {
		this.fdIn = fdIn;
		this.fdOut = fdOut;
		this.getSizeOverride = getSizeOverride;
		this.type = type;

		readTermcap();

		if(type == ConsoleOutputType.minimalProcessing) {
			_suppressDestruction = true;
			return;
		}

		if(type == ConsoleOutputType.cellular) {
			doTermcap("ti");
			moveTo(0, 0, ForceOption.alwaysSend); // we need to know where the cursor is for some features to work, and moving it is easier than querying it
		}

		if(terminalInFamily("xterm", "rxvt", "screen")) {
			writeStringRaw("\033[22;0t"); // save window title on a stack (support seems spotty, but it doesn't hurt to have it)
		}
	}

	version(Windows)
		HANDLE hConsole;

	version(Windows)
	/// ditto
	this(ConsoleOutputType type) {
		hConsole = GetStdHandle(STD_OUTPUT_HANDLE);
		if(type == ConsoleOutputType.cellular) {
			/*
http://msdn.microsoft.com/en-us/library/windows/desktop/ms686125%28v=vs.85%29.aspx
http://msdn.microsoft.com/en-us/library/windows/desktop/ms683193%28v=vs.85%29.aspx
			*/
			COORD size;
			/*
			CONSOLE_SCREEN_BUFFER_INFO sbi;
			GetConsoleScreenBufferInfo(hConsole, &sbi);
			size.X = cast(short) GetSystemMetrics(SM_CXMIN);
			size.Y = cast(short) GetSystemMetrics(SM_CYMIN);
			*/

			// FIXME: this sucks, maybe i should just revert it. but there shouldn't be scrollbars in cellular mode
			size.X = 80;
			size.Y = 24;
			SetConsoleScreenBufferSize(hConsole, size);
			moveTo(0, 0, ForceOption.alwaysSend); // we need to know where the cursor is for some features to work, and moving it is easier than querying it
		}
	}

	// only use this if you are sure you know what you want, since the terminal is a shared resource you generally really want to reset it to normal when you leave...
	bool _suppressDestruction;

	version(Posix)
	~this() {
		if(_suppressDestruction) {
			flush();
			return;
		}
		if(type == ConsoleOutputType.cellular) {
			doTermcap("te");
		}
		if(terminalInFamily("xterm", "rxvt", "screen")) {
			writeStringRaw("\033[23;0t"); // restore window title from the stack
		}
		showCursor();
		reset();
		flush();

		if(lineGetter !is null)
			lineGetter.dispose();
	}

	version(Windows)
	~this() {
		reset();
		flush();
		showCursor();

		if(lineGetter !is null)
			lineGetter.dispose();
	}

	// lazily initialized and preserved between calls to getline for a bit of efficiency (only a bit)
	// and some history storage.
	LineGetter lineGetter;

	int _currentForeground = Color.DEFAULT;
	int _currentBackground = Color.DEFAULT;
	bool reverseVideo = false;

	/// Changes the current color. See enum Color for the values.
	void color(int foreground, int background, ForceOption force = ForceOption.automatic, bool reverseVideo = false) {
		if(force != ForceOption.neverSend) {
			version(Windows) {
				// assuming a dark background on windows, so LowContrast == dark which means the bit is NOT set on hardware
				/*
				foreground ^= LowContrast;
				background ^= LowContrast;
				*/

				ushort setTof = cast(ushort) foreground;
				ushort setTob = cast(ushort) background;

				// this isn't necessarily right but meh
				if(background == Color.DEFAULT)
					setTob = Color.black;
				if(foreground == Color.DEFAULT)
					setTof = Color.white;

				if(force == ForceOption.alwaysSend || reverseVideo != this.reverseVideo || foreground != _currentForeground || background != _currentBackground) {
					flush(); // if we don't do this now, the buffering can screw up the colors...
					if(reverseVideo) {
						if(background == Color.DEFAULT)
							setTof = Color.black;
						else
							setTof = cast(ushort) background | (foreground & Bright);

						if(background == Color.DEFAULT)
							setTob = Color.white;
						else
							setTob = cast(ushort) (foreground & ~Bright);
					}
					SetConsoleTextAttribute(
						GetStdHandle(STD_OUTPUT_HANDLE),
						cast(ushort)((setTob << 4) | setTof));
				}
			} else {
				import std.process;
				// I started using this envvar for my text editor, but now use it elsewhere too
				// if we aren't set to dark, assume light
				/*
				if(getenv("ELVISBG") == "dark") {
					// LowContrast on dark bg menas
				} else {
					foreground ^= LowContrast;
					background ^= LowContrast;
				}
				*/

				ushort setTof = cast(ushort) foreground & ~Bright;
				ushort setTob = cast(ushort) background & ~Bright;

				if(foreground & Color.DEFAULT)
					setTof = 9; // ansi sequence for reset
				if(background == Color.DEFAULT)
					setTob = 9;

				import std.string;

				if(force == ForceOption.alwaysSend || reverseVideo != this.reverseVideo || foreground != _currentForeground || background != _currentBackground) {
					writeStringRaw(format("\033[%dm\033[3%dm\033[4%dm\033[%dm",
						(foreground != Color.DEFAULT && (foreground & Bright)) ? 1 : 0,
						cast(int) setTof,
						cast(int) setTob,
						reverseVideo ? 7 : 27
					));
				}
			}
		}

		_currentForeground = foreground;
		_currentBackground = background;
		this.reverseVideo = reverseVideo;
	}

	private bool _underlined = false;

	/// Note: the Windows console does not support underlining
	void underline(bool set, ForceOption force = ForceOption.automatic) {
		if(set == _underlined && force != ForceOption.alwaysSend)
			return;
		version(Posix) {
			if(set)
				writeStringRaw("\033[4m");
			else
				writeStringRaw("\033[24m");
		}
		_underlined = set;
	}
	// FIXME: do I want to do bold and italic?

	/// Returns the terminal to normal output colors
	void reset() {
		version(Windows)
			SetConsoleTextAttribute(
				GetStdHandle(STD_OUTPUT_HANDLE),
				cast(ushort)((Color.black << 4) | Color.white));
		else
			writeStringRaw("\033[0m");

		_underlined = false;
		_currentForeground = Color.DEFAULT;
		_currentBackground = Color.DEFAULT;
		reverseVideo = false;
	}

	// FIXME: add moveRelative

	/// The current x position of the output cursor. 0 == leftmost column
	@property int cursorX() {
		return _cursorX;
	}

	/// The current y position of the output cursor. 0 == topmost row
	@property int cursorY() {
		return _cursorY;
	}

	private int _cursorX;
	private int _cursorY;

	/// Moves the output cursor to the given position. (0, 0) is the upper left corner of the screen. The force parameter can be used to force an update, even if Terminal doesn't think it is necessary
	void moveTo(int x, int y, ForceOption force = ForceOption.automatic) {
		if(force != ForceOption.neverSend && (force == ForceOption.alwaysSend || x != _cursorX || y != _cursorY)) {
			executeAutoHideCursor();
			version(Posix)
				doTermcap("cm", y, x);
			else version(Windows) {

				flush(); // if we don't do this now, the buffering can screw up the position
				COORD coord = {cast(short) x, cast(short) y};
				SetConsoleCursorPosition(hConsole, coord);
			} else static assert(0);
		}

		_cursorX = x;
		_cursorY = y;
	}

	/// shows the cursor
	void showCursor() {
		version(Posix)
			doTermcap("ve");
		else {
			CONSOLE_CURSOR_INFO info;
			GetConsoleCursorInfo(hConsole, &info);
			info.bVisible = true;
			SetConsoleCursorInfo(hConsole, &info);
		}
	}

	/// hides the cursor
	void hideCursor() {
		version(Posix) {
			doTermcap("vi");
		} else {
			CONSOLE_CURSOR_INFO info;
			GetConsoleCursorInfo(hConsole, &info);
			info.bVisible = false;
			SetConsoleCursorInfo(hConsole, &info);
		}

	}

	private bool autoHidingCursor;
	private bool autoHiddenCursor;
	// explicitly not publicly documented
	// Sets the cursor to automatically insert a hide command at the front of the output buffer iff it is moved.
	// Call autoShowCursor when you are done with the batch update.
	void autoHideCursor() {
		autoHidingCursor = true;
	}

	private void executeAutoHideCursor() {
		if(autoHidingCursor) {
			version(Windows)
				hideCursor();
			else version(Posix) {
				// prepend the hide cursor command so it is the first thing flushed
				writeBuffer = "\033[?25l" ~ writeBuffer;
			}

			autoHiddenCursor = true;
			autoHidingCursor = false; // already been done, don't insert the command again
		}
	}

	// explicitly not publicly documented
	// Shows the cursor if it was automatically hidden by autoHideCursor and resets the internal auto hide state.
	void autoShowCursor() {
		if(autoHiddenCursor)
			showCursor();

		autoHidingCursor = false;
		autoHiddenCursor = false;
	}

	/*
	// alas this doesn't work due to a bunch of delegate context pointer and postblit problems
	// instead of using: auto input = terminal.captureInput(flags)
	// use: auto input = RealTimeConsoleInput(&terminal, flags);
	/// Gets real time input, disabling line buffering
	RealTimeConsoleInput captureInput(ConsoleInputFlags flags) {
		return RealTimeConsoleInput(&this, flags);
	}
	*/

	/// Changes the terminal's title
	void setTitle(string t) {
		version(Windows) {
			SetConsoleTitleA(toStringz(t));
		} else {
			import std.string;
			if(terminalInFamily("xterm", "rxvt", "screen"))
				writeStringRaw(format("\033]0;%s\007", t));
		}
	}

	/// Flushes your updates to the terminal.
	/// It is important to call this when you are finished writing for now if you are using the version=with_eventloop
	void flush() {
		version(Posix) {
			ssize_t written;

			while(writeBuffer.length) {
				written = unix.write(this.fdOut, writeBuffer.ptr, writeBuffer.length);
				if(written < 0)
					throw new Exception("write failed for some reason");
				writeBuffer = writeBuffer[written .. $];
			}
		} else version(Windows) {
			while(writeBuffer.length) {
				DWORD written;
				/* FIXME: WriteConsoleW */
				WriteConsoleA(hConsole, writeBuffer.ptr, writeBuffer.length, &written, null);
				writeBuffer = writeBuffer[written .. $];
			}
		}
		// not buffering right now on Windows, since it probably isn't on ssh anyway
	}

	int[] getSize() {
		version(Windows) {
			CONSOLE_SCREEN_BUFFER_INFO info;
			GetConsoleScreenBufferInfo( hConsole, &info );
        
			int cols, rows;
        
			cols = (info.srWindow.Right - info.srWindow.Left + 1);
			rows = (info.srWindow.Bottom - info.srWindow.Top + 1);

			return [cols, rows];
		} else {
			if(getSizeOverride is null) {
				winsize w;
				ioctl(0, TIOCGWINSZ, &w);
				return [w.ws_col, w.ws_row];
			} else return getSizeOverride();
		}
	}

	void updateSize() {
		auto size = getSize();
		_width = size[0];
		_height = size[1];
	}

	private int _width;
	private int _height;

	/// The current width of the terminal (the number of columns)
	@property int width() {
		if(_width == 0 || _height == 0)
			updateSize();
		return _width;
	}

	/// The current height of the terminal (the number of rows)
	@property int height() {
		if(_width == 0 || _height == 0)
			updateSize();
		return _height;
	}

	/*
	void write(T...)(T t) {
		foreach(arg; t) {
			writeStringRaw(to!string(arg));
		}
	}
	*/

	/// Writes to the terminal at the current cursor position.
	void writef(T...)(string f, T t) {
		import std.string;
		writePrintableString(format(f, t));
	}

	/// ditto
	void writefln(T...)(string f, T t) {
		writef(f ~ "\n", t);
	}

	/// ditto
	void write(T...)(T t) {
		import std.conv;
		string data;
		foreach(arg; t) {
			data ~= to!string(arg);
		}

		writePrintableString(data);
	}

	/// ditto
	void writeln(T...)(T t) {
		write(t, "\n");
	}

	/+
	/// A combined moveTo and writef that puts the cursor back where it was before when it finishes the write.
	/// Only works in cellular mode. 
	/// Might give better performance than moveTo/writef because if the data to write matches the internal buffer, it skips sending anything (to override the buffer check, you can use moveTo and writePrintableString with ForceOption.alwaysSend)
	void writefAt(T...)(int x, int y, string f, T t) {
		import std.string;
		auto toWrite = format(f, t);

		auto oldX = _cursorX;
		auto oldY = _cursorY;

		writeAtWithoutReturn(x, y, toWrite);

		moveTo(oldX, oldY);
	}

	void writeAtWithoutReturn(int x, int y, in char[] data) {
		moveTo(x, y);
		writeStringRaw(toWrite, ForceOption.alwaysSend);
	}
	+/

	void writePrintableString(in char[] s, ForceOption force = ForceOption.automatic) {
		// an escape character is going to mess things up. Actually any non-printable character could, but meh
		// assert(s.indexOf("\033") == -1);

		// tracking cursor position
		foreach(ch; s) {
			switch(ch) {
				case '\n':
					_cursorX = 0;
					_cursorY++;
				break;
				case '\r':
					_cursorX = 0;
				break;
				case '\t':
					_cursorX ++;
					_cursorX += _cursorX % 8; // FIXME: get the actual tabstop, if possible
				break;
				default:
					if(ch <= 127) // way of only advancing once per dchar instead of per code unit
						_cursorX++;
			}

			if(_wrapAround && _cursorX > width) {
				_cursorX = 0;
				_cursorY++;
			}

			if(_cursorY == height)
				_cursorY--;

			/+
			auto index = getIndex(_cursorX, _cursorY);
			if(data[index] != ch) {
				data[index] = ch;
			}
			+/
		}

		writeStringRaw(s);
	}

	/* private */ bool _wrapAround = true;

	deprecated alias writePrintableString writeString; /// use write() or writePrintableString instead

	private string writeBuffer;

	// you really, really shouldn't use this unless you know what you are doing
	/*private*/ void writeStringRaw(in char[] s) {
		// FIXME: make sure all the data is sent, check for errors
		version(Posix) {
			writeBuffer ~= s; // buffer it to do everything at once in flush() calls
		} else version(Windows) {
			writeBuffer ~= s;
		} else static assert(0);
	}

	/// Clears the screen.
	void clear() {
		version(Posix) {
			doTermcap("cl");
		} else version(Windows) {
			// TBD: copy the code from here and test it:
			// http://support.microsoft.com/kb/99261
			assert(0, "clear not yet implemented");
		}

		_cursorX = 0;
		_cursorY = 0;
	}

	/// gets a line, including user editing. Convenience method around the LineGetter class and RealTimeConsoleInput facilities - use them if you need more control.
	/// You really shouldn't call this if stdin isn't actually a user-interactive terminal! So if you expect people to pipe data to your app, check for that or use something else.
	// FIXME: add a method to make it easy to check if stdin is actually a tty and use other methods there.
	string getline(string prompt = null) {
		if(lineGetter is null)
			lineGetter = new LineGetter(&this);
		// since the struct might move (it shouldn't, this should be unmovable!) but since
		// it technically might, I'm updating the pointer before using it just in case.
		lineGetter.terminal = &this;

		lineGetter.prompt = prompt;

		auto line = lineGetter.getline();

		// lineGetter leaves us exactly where it was when the user hit enter, giving best
		// flexibility to real-time input and cellular programs. The convenience function,
		// however, wants to do what is right in most the simple cases, which is to actually
		// print the line (echo would be enabled without RealTimeConsoleInput anyway and they
		// did hit enter), so we'll do that here too.
		writePrintableString("\n");

		return line;
	}

}

/+
struct ConsoleBuffer {
	int cursorX;
	int cursorY;
	int width;
	int height;
	dchar[] data;

	void actualize(Terminal* t) {
		auto writer = t.getBufferedWriter();

		this.copyTo(&(t.onScreen));
	}

	void copyTo(ConsoleBuffer* buffer) {
		buffer.cursorX = this.cursorX;
		buffer.cursorY = this.cursorY;
		buffer.width = this.width;
		buffer.height = this.height;
		buffer.data[] = this.data[];
	}
}
+/

/**
 * Encapsulates the stream of input events received from the terminal input.
 */
struct RealTimeConsoleInput {
	@disable this();
	@disable this(this);

	version(Posix) {
		private int fdOut;
		private int fdIn;
		private sigaction_t oldSigWinch;
		private sigaction_t oldSigIntr;
		private sigaction_t oldHupIntr;
		private termios old;
		ubyte[128] hack;
		// apparently termios isn't the size druntime thinks it is (at least on 32 bit, sometimes)....
		// tcgetattr smashed other variables in here too that could create random problems
		// so this hack is just to give some room for that to happen without destroying the rest of the world
	}

	version(Windows) {
		private DWORD oldInput;
		private DWORD oldOutput;
		HANDLE inputHandle;
	}

	private ConsoleInputFlags flags;
	private Terminal* terminal;
	private void delegate()[] destructor;

	/// To capture input, you need to provide a terminal and some flags.
	public this(Terminal* terminal, ConsoleInputFlags flags) {
		this.flags = flags;
		this.terminal = terminal;

		version(Windows) {
			inputHandle = GetStdHandle(STD_INPUT_HANDLE);

			GetConsoleMode(inputHandle, &oldInput);

			DWORD mode = 0;
			mode |= ENABLE_PROCESSED_INPUT /* 0x01 */; // this gives Ctrl+C which we probably want to be similar to linux
			//if(flags & ConsoleInputFlags.size)
			mode |= ENABLE_WINDOW_INPUT /* 0208 */; // gives size etc
			if(flags & ConsoleInputFlags.echo)
				mode |= ENABLE_ECHO_INPUT; // 0x4
			if(flags & ConsoleInputFlags.mouse)
				mode |= ENABLE_MOUSE_INPUT; // 0x10
			// if(flags & ConsoleInputFlags.raw) // FIXME: maybe that should be a separate flag for ENABLE_LINE_INPUT

			SetConsoleMode(inputHandle, mode);
			destructor ~= { SetConsoleMode(inputHandle, oldInput); };


			GetConsoleMode(terminal.hConsole, &oldOutput);
			mode = 0;
			// we want this to match linux too
			mode |= ENABLE_PROCESSED_OUTPUT; /* 0x01 */
			mode |= ENABLE_WRAP_AT_EOL_OUTPUT; /* 0x02 */
			SetConsoleMode(terminal.hConsole, mode);
			destructor ~= { SetConsoleMode(terminal.hConsole, oldOutput); };

			// FIXME: change to UTF8 as well
		}

		version(Posix) {
			this.fdIn = terminal.fdIn;
			this.fdOut = terminal.fdOut;

			if(fdIn != -1) {
				tcgetattr(fdIn, &old);
				auto n = old;

				auto f = ICANON;
				if(!(flags & ConsoleInputFlags.echo))
					f |= ECHO;

				n.c_lflag &= ~f;
				tcsetattr(fdIn, TCSANOW, &n);
			}

			// some weird bug breaks this, https://github.com/robik/ConsoleD/issues/3
			//destructor ~= { tcsetattr(fdIn, TCSANOW, &old); };

			if(flags & ConsoleInputFlags.size) {
				import core.sys.posix.signal;
				sigaction_t n;
				n.sa_handler = &sizeSignalHandler;
				n.sa_mask = cast(sigset_t) 0;
				n.sa_flags = 0;
				sigaction(SIGWINCH, &n, &oldSigWinch);
			}

			{
				import core.sys.posix.signal;
				sigaction_t n;
				n.sa_handler = &interruptSignalHandler;
				n.sa_mask = cast(sigset_t) 0;
				n.sa_flags = 0;
				sigaction(SIGINT, &n, &oldSigIntr);
			}

			{
				import core.sys.posix.signal;
				sigaction_t n;
				n.sa_handler = &hangupSignalHandler;
				n.sa_mask = cast(sigset_t) 0;
				n.sa_flags = 0;
				sigaction(SIGHUP, &n, &oldHupIntr);
			}



			if(flags & ConsoleInputFlags.mouse) {
				// basic button press+release notification

				// FIXME: try to get maximum capabilities from all terminals
				// right now this works well on xterm but rxvt isn't sending movements...

				terminal.writeStringRaw("\033[?1000h");
				destructor ~= { terminal.writeStringRaw("\033[?1000l"); };
				if(terminal.terminalInFamily("xterm")) {
					// this is vt200 mouse with full motion tracking, supported by xterm
					terminal.writeStringRaw("\033[?1003h");
					destructor ~= { terminal.writeStringRaw("\033[?1003l"); };
				} else if(terminal.terminalInFamily("rxvt", "screen")) {
					terminal.writeStringRaw("\033[?1002h"); // this is vt200 mouse with press/release and motion notification iff buttons are pressed
					destructor ~= { terminal.writeStringRaw("\033[?1002l"); };
				}
			}
			if(flags & ConsoleInputFlags.paste) {
				if(terminal.terminalInFamily("xterm", "rxvt", "screen")) {
					terminal.writeStringRaw("\033[?2004h"); // bracketed paste mode
					destructor ~= { terminal.writeStringRaw("\033[?2004l"); };
				}
			}

			// try to ensure the terminal is in UTF-8 mode
			if(terminal.terminalInFamily("xterm", "screen", "linux")) {
				terminal.writeStringRaw("\033%G");
			}

			terminal.flush();
		}


		version(with_eventloop) {
			import arsd.eventloop;
			version(Windows)
				auto listenTo = inputHandle;
			else version(Posix)
				auto listenTo = this.fdIn;
			else static assert(0, "idk about this OS");

			version(Posix)
			addListener(&signalFired);

			if(listenTo != -1) {
				addFileEventListeners(listenTo, &eventListener, null, null);
				destructor ~= { removeFileEventListeners(listenTo); };
			}
			addOnIdle(&terminal.flush);
			destructor ~= { removeOnIdle(&terminal.flush); };
		}
	}

	version(with_eventloop) {
		version(Posix)
		void signalFired(SignalFired) {
			if(interrupted) {
				interrupted = false;
				send(InputEvent(UserInterruptionEvent()));
			}
			if(windowSizeChanged)
				send(checkWindowSizeChanged());
			if(hangedUp) {
				hangedUp = false;
				send(InputEvent(HangupEvent()));
			}
		}

		import arsd.eventloop;
		void eventListener(OsFileHandle fd) {
			auto queue = readNextEvents();
			foreach(event; queue)
				send(event);
		}
	}

	~this() {
		// the delegate thing doesn't actually work for this... for some reason
		version(Posix)
			if(fdIn != -1)
				tcsetattr(fdIn, TCSANOW, &old);

		version(Posix) {
			if(flags & ConsoleInputFlags.size) {
				// restoration
				sigaction(SIGWINCH, &oldSigWinch, null);
			}
			sigaction(SIGINT, &oldSigIntr, null);
			sigaction(SIGHUP, &oldHupIntr, null);
		}

		// we're just undoing everything the constructor did, in reverse order, same criteria
		foreach_reverse(d; destructor)
			d();
	}

	/// Returns true if there is input available now
	bool kbhit() {
		return timedCheckForInput(0);
	}

	/// Check for input, waiting no longer than the number of milliseconds
	bool timedCheckForInput(int milliseconds) {
		version(Windows) {
			auto response = WaitForSingleObject(terminal.hConsole, milliseconds);
			if(response  == 0)
				return true; // the object is ready
			return false;
		} else version(Posix) {
			if(fdIn == -1)
				return false;

			timeval tv;
			tv.tv_sec = 0;
			tv.tv_usec = milliseconds * 1000;

			fd_set fs;
			FD_ZERO(&fs);

			FD_SET(fdIn, &fs);
			select(fdIn + 1, &fs, null, null, &tv);

			return FD_ISSET(fdIn, &fs);
		}
	}

	/// Get one character from the terminal, discarding other
	/// events in the process. Returns dchar.init upon receiving end-of-file.
	dchar getch() {
		auto event = nextEvent();
		while(event.type != InputEvent.Type.CharacterEvent || event.characterEvent.eventType == CharacterEvent.Type.Released) {
			if(event.type == InputEvent.Type.UserInterruptionEvent)
				throw new Exception("Ctrl+c");
			if(event.type == InputEvent.Type.HangupEvent)
				throw new Exception("Hangup");
			if(event.type == InputEvent.Type.EndOfFileEvent)
				return dchar.init;
			event = nextEvent();
		}
		return event.characterEvent.character;
	}

	//char[128] inputBuffer;
	//int inputBufferPosition;
	version(Posix)
	int nextRaw(bool interruptable = false) {
		if(fdIn == -1)
			return 0;

		char[1] buf;
		try_again:
		auto ret = read(fdIn, buf.ptr, buf.length);
		if(ret == 0)
			return 0; // input closed
		if(ret == -1) {
			import core.stdc.errno;
			if(errno == EINTR)
				// interrupted by signal call, quite possibly resize or ctrl+c which we want to check for in the event loop
				if(interruptable)
					return -1;
				else
					goto try_again;
			else
				throw new Exception("read failed");
		}

		//terminal.writef("RAW READ: %d\n", buf[0]);

		if(ret == 1)
			return inputPrefilter ? inputPrefilter(buf[0]) : buf[0];
		else
			assert(0); // read too much, should be impossible
	}

	version(Posix)
		int delegate(char) inputPrefilter;

	version(Posix)
	dchar nextChar(int starting) {
		if(starting <= 127)
			return cast(dchar) starting;
		char[6] buffer;
		int pos = 0;
		buffer[pos++] = cast(char) starting;

		// see the utf-8 encoding for details
		int remaining = 0;
		ubyte magic = starting & 0xff;
		while(magic & 0b1000_000) {
			remaining++;
			magic <<= 1;
		}

		while(remaining && pos < buffer.length) {
			buffer[pos++] = cast(char) nextRaw();
			remaining--;
		}

		import std.utf;
		size_t throwAway; // it insists on the index but we don't care
		return decode(buffer[], throwAway);
	}

	InputEvent checkWindowSizeChanged() {
		auto oldWidth = terminal.width;
		auto oldHeight = terminal.height;
		terminal.updateSize();
		version(Posix)
		windowSizeChanged = false;
		return InputEvent(SizeChangedEvent(oldWidth, oldHeight, terminal.width, terminal.height));
	}


	// character event
	// non-character key event
	// paste event
	// mouse event
	// size event maybe, and if appropriate focus events

	/// Returns the next event.
	///
	/// Experimental: It is also possible to integrate this into
	/// a generic event loop, currently under -version=with_eventloop and it will
	/// require the module arsd.eventloop (Linux only at this point)
	InputEvent nextEvent() {
		terminal.flush();
		if(inputQueue.length) {
			auto e = inputQueue[0];
			inputQueue = inputQueue[1 .. $];
			return e;
		}

		wait_for_more:
		version(Posix)
		if(interrupted) {
			interrupted = false;
			return InputEvent(UserInterruptionEvent());
		}

/* 		if(hangedUp) {
			hangedUp = false;
			return InputEvent(HangupEvent());
		}
 */
		version(Posix)
		if(windowSizeChanged) {
			return checkWindowSizeChanged();
		}

		auto more = readNextEvents();
		if(!more.length)
			goto wait_for_more; // i used to do a loop (readNextEvents can read something, but it might be discarded by the input filter) but now it goto's above because readNextEvents might be interrupted by a SIGWINCH aka size event so we want to check that at least

		assert(more.length);

		auto e = more[0];
		inputQueue = more[1 .. $];
		return e;
	}

	InputEvent* peekNextEvent() {
		if(inputQueue.length)
			return &(inputQueue[0]);
		return null;
	}

	enum InjectionPosition { head, tail }
	void injectEvent(InputEvent ev, InjectionPosition where) {
		final switch(where) {
			case InjectionPosition.head:
				inputQueue = ev ~ inputQueue;
			break;
			case InjectionPosition.tail:
				inputQueue ~= ev;
			break;
		}
	}

	InputEvent[] inputQueue;

	version(Windows)
	InputEvent[] readNextEvents() {
		terminal.flush(); // make sure all output is sent out before waiting for anything

		INPUT_RECORD[32] buffer;
		DWORD actuallyRead;
			// FIXME: ReadConsoleInputW
		auto success = ReadConsoleInputA(inputHandle, buffer.ptr, buffer.length, &actuallyRead);
		if(success == 0)
			throw new Exception("ReadConsoleInput");

		InputEvent[] newEvents;
		input_loop: foreach(record; buffer[0 .. actuallyRead]) {
			switch(record.EventType) {
				case KEY_EVENT:
					auto ev = record.KeyEvent;
					CharacterEvent e;
					NonCharacterKeyEvent ne;

					e.eventType = ev.bKeyDown ? CharacterEvent.Type.Pressed : CharacterEvent.Type.Released;
					ne.eventType = ev.bKeyDown ? NonCharacterKeyEvent.Type.Pressed : NonCharacterKeyEvent.Type.Released;

					// only send released events when specifically requested
					if(!(flags & ConsoleInputFlags.releasedKeys) && !ev.bKeyDown)
						break;

					e.modifierState = ev.dwControlKeyState;
					ne.modifierState = ev.dwControlKeyState;

					if(ev.UnicodeChar) {
						e.character = cast(dchar) cast(wchar) ev.UnicodeChar;
						newEvents ~= InputEvent(e);
					} else {
						ne.key = cast(NonCharacterKeyEvent.Key) ev.wVirtualKeyCode;

						// FIXME: make this better. the goal is to make sure the key code is a valid enum member
						// Windows sends more keys than Unix and we're doing lowest common denominator here
						foreach(member; __traits(allMembers, NonCharacterKeyEvent.Key))
							if(__traits(getMember, NonCharacterKeyEvent.Key, member) == ne.key) {
								newEvents ~= InputEvent(ne);
								break;
							}
					}
				break;
				case MOUSE_EVENT:
					auto ev = record.MouseEvent;
					MouseEvent e;

					e.modifierState = ev.dwControlKeyState;
					e.x = ev.dwMousePosition.X;
					e.y = ev.dwMousePosition.Y;

					switch(ev.dwEventFlags) {
						case 0:
							//press or release
							e.eventType = MouseEvent.Type.Pressed;
							static DWORD lastButtonState;
							auto lastButtonState2 = lastButtonState;
							e.buttons = ev.dwButtonState;
							lastButtonState = e.buttons;

							// this is sent on state change. if fewer buttons are pressed, it must mean released
							if(cast(DWORD) e.buttons < lastButtonState2) {
								e.eventType = MouseEvent.Type.Released;
								// if last was 101 and now it is 100, then button far right was released
								// so we flip the bits, ~100 == 011, then and them: 101 & 011 == 001, the
								// button that was released
								e.buttons = lastButtonState2 & ~e.buttons;
							}
						break;
						case MOUSE_MOVED:
							e.eventType = MouseEvent.Type.Moved;
							e.buttons = ev.dwButtonState;
						break;
						case 0x0004/*MOUSE_WHEELED*/:
							e.eventType = MouseEvent.Type.Pressed;
							if(ev.dwButtonState > 0)
								e.buttons = MouseEvent.Button.ScrollDown;
							else
								e.buttons = MouseEvent.Button.ScrollUp;
						break;
						default:
							continue input_loop;
					}

					newEvents ~= InputEvent(e);
				break;
				case WINDOW_BUFFER_SIZE_EVENT:
					auto ev = record.WindowBufferSizeEvent;
					auto oldWidth = terminal.width;
					auto oldHeight = terminal.height;
					terminal._width = ev.dwSize.X;
					terminal._height = ev.dwSize.Y;
					newEvents ~= InputEvent(SizeChangedEvent(oldWidth, oldHeight, terminal.width, terminal.height));
				break;
				// FIXME: can we catch ctrl+c here too?
				default:
					// ignore
			}
		}

		return newEvents;
	}

	version(Posix)
	InputEvent[] readNextEvents() {
		terminal.flush(); // make sure all output is sent out before we try to get input

		InputEvent[] charPressAndRelease(dchar character) {
			if((flags & ConsoleInputFlags.releasedKeys))
				return [
					InputEvent(CharacterEvent(CharacterEvent.Type.Pressed, character, 0)),
					InputEvent(CharacterEvent(CharacterEvent.Type.Released, character, 0)),
				];
			else return [ InputEvent(CharacterEvent(CharacterEvent.Type.Pressed, character, 0)) ];
		}
		InputEvent[] keyPressAndRelease(NonCharacterKeyEvent.Key key, uint modifiers = 0) {
			if((flags & ConsoleInputFlags.releasedKeys))
				return [
					InputEvent(NonCharacterKeyEvent(NonCharacterKeyEvent.Type.Pressed, key, modifiers)),
					InputEvent(NonCharacterKeyEvent(NonCharacterKeyEvent.Type.Released, key, modifiers)),
				];
			else return [ InputEvent(NonCharacterKeyEvent(NonCharacterKeyEvent.Type.Pressed, key, modifiers)) ];
		}

		char[30] sequenceBuffer;

		// this assumes you just read "\033["
		char[] readEscapeSequence(char[] sequence) {
			int sequenceLength = 2;
			sequence[0] = '\033';
			sequence[1] = '[';

			while(sequenceLength < sequence.length) {
				auto n = nextRaw();
				sequence[sequenceLength++] = cast(char) n;
				// I think a [ is supposed to termiate a CSI sequence
				// but the Linux console sends CSI[A for F1, so I'm
				// hacking it to accept that too
				if(n >= 0x40 && !(sequenceLength == 3 && n == '['))
					break;
			}

			return sequence[0 .. sequenceLength];
		}

		InputEvent[] translateTermcapName(string cap) {
			switch(cap) {
				//case "k0":
					//return keyPressAndRelease(NonCharacterKeyEvent.Key.F1);
				case "k1":
					return keyPressAndRelease(NonCharacterKeyEvent.Key.F1);
				case "k2":
					return keyPressAndRelease(NonCharacterKeyEvent.Key.F2);
				case "k3":
					return keyPressAndRelease(NonCharacterKeyEvent.Key.F3);
				case "k4":
					return keyPressAndRelease(NonCharacterKeyEvent.Key.F4);
				case "k5":
					return keyPressAndRelease(NonCharacterKeyEvent.Key.F5);
				case "k6":
					return keyPressAndRelease(NonCharacterKeyEvent.Key.F6);
				case "k7":
					return keyPressAndRelease(NonCharacterKeyEvent.Key.F7);
				case "k8":
					return keyPressAndRelease(NonCharacterKeyEvent.Key.F8);
				case "k9":
					return keyPressAndRelease(NonCharacterKeyEvent.Key.F9);
				case "k;":
				case "k0":
					return keyPressAndRelease(NonCharacterKeyEvent.Key.F10);
				case "F1":
					return keyPressAndRelease(NonCharacterKeyEvent.Key.F11);
				case "F2":
					return keyPressAndRelease(NonCharacterKeyEvent.Key.F12);


				case "kb":
					return charPressAndRelease('\b');
				case "kD":
					return keyPressAndRelease(NonCharacterKeyEvent.Key.Delete);

				case "kd":
				case "do":
					return keyPressAndRelease(NonCharacterKeyEvent.Key.DownArrow);
				case "ku":
				case "up":
					return keyPressAndRelease(NonCharacterKeyEvent.Key.UpArrow);
				case "kl":
					return keyPressAndRelease(NonCharacterKeyEvent.Key.LeftArrow);
				case "kr":
				case "nd":
					return keyPressAndRelease(NonCharacterKeyEvent.Key.RightArrow);

				case "kN":
				case "K5":
					return keyPressAndRelease(NonCharacterKeyEvent.Key.PageDown);
				case "kP":
				case "K2":
					return keyPressAndRelease(NonCharacterKeyEvent.Key.PageUp);

				case "kh":
				case "K1":
					return keyPressAndRelease(NonCharacterKeyEvent.Key.Home);
				case "kH":
					return keyPressAndRelease(NonCharacterKeyEvent.Key.End);
				case "kI":
					return keyPressAndRelease(NonCharacterKeyEvent.Key.Insert);
				default:
					// don't know it, just ignore
					//import std.stdio;
					//writeln(cap);
			}

			return null;
		}


		InputEvent[] doEscapeSequence(in char[] sequence) {
			switch(sequence) {
				case "\033[200~":
					// bracketed paste begin
					// we want to keep reading until
					// "\033[201~":
					// and build a paste event out of it


					string data;
					for(;;) {
						auto n = nextRaw();
						if(n == '\033') {
							n = nextRaw();
							if(n == '[') {
								auto esc = readEscapeSequence(sequenceBuffer);
								if(esc == "\033[201~") {
									// complete!
									break;
								} else {
									// was something else apparently, but it is pasted, so keep it
									data ~= esc;
								}
							} else {
								data ~= '\033';
								data ~= cast(char) n;
							}
						} else {
							data ~= cast(char) n;
						}
					}
					return [InputEvent(PasteEvent(data))];
				case "\033[M":
					// mouse event
					auto buttonCode = nextRaw() - 32;
						// nextChar is commented because i'm not using UTF-8 mouse mode
						// cuz i don't think it is as widely supported
					auto x = cast(int) (/*nextChar*/(nextRaw())) - 33; /* they encode value + 32, but make upper left 1,1. I want it to be 0,0 */
					auto y = cast(int) (/*nextChar*/(nextRaw())) - 33; /* ditto */


					bool isRelease = (buttonCode & 0b11) == 3;
					int buttonNumber;
					if(!isRelease) {
						buttonNumber = (buttonCode & 0b11);
						if(buttonCode & 64)
							buttonNumber += 3; // button 4 and 5 are sent as like button 1 and 2, but code | 64
							// so button 1 == button 4 here

						// note: buttonNumber == 0 means button 1 at this point
						buttonNumber++; // hence this


						// apparently this considers middle to be button 2. but i want middle to be button 3.
						if(buttonNumber == 2)
							buttonNumber = 3;
						else if(buttonNumber == 3)
							buttonNumber = 2;
					}

					auto modifiers = buttonCode & (0b0001_1100);
						// 4 == shift
						// 8 == meta
						// 16 == control

					MouseEvent m;

					if(buttonCode & 32)
						m.eventType = MouseEvent.Type.Moved;
					else
						m.eventType = isRelease ? MouseEvent.Type.Released : MouseEvent.Type.Pressed;

					// ugh, if no buttons are pressed, released and moved are indistinguishable...
					// so we'll count the buttons down, and if we get a release
					static int buttonsDown = 0;
					if(!isRelease && buttonNumber <= 3) // exclude wheel "presses"...
						buttonsDown++;

					if(isRelease && m.eventType != MouseEvent.Type.Moved) {
						if(buttonsDown)
							buttonsDown--;
						else // no buttons down, so this should be a motion instead..
							m.eventType = MouseEvent.Type.Moved;
					}


					if(buttonNumber == 0)
						m.buttons = 0; // we don't actually know :(
					else
						m.buttons = 1 << (buttonNumber - 1); // I prefer flags so that's how we do it
					m.x = x;
					m.y = y;
					m.modifierState = modifiers;

					return [InputEvent(m)];
				default:
					// look it up in the termcap key database
					auto cap = terminal.findSequenceInTermcap(sequence);
					if(cap !is null) {
						return translateTermcapName(cap);
					} else {
						if(terminal.terminalInFamily("xterm")) {
							import std.conv, std.string;
							auto terminator = sequence[$ - 1];
							auto parts = sequence[2 .. $ - 1].split(";");
							// parts[0] and terminator tells us the key
							// parts[1] tells us the modifierState

							uint modifierState;

							int modGot;
							if(parts.length > 1)
								modGot = to!int(parts[1]);
							mod_switch: switch(modGot) {
								case 2: modifierState |= ModifierState.shift; break;
								case 3: modifierState |= ModifierState.alt; break;
								case 4: modifierState |= ModifierState.shift | ModifierState.alt; break;
								case 5: modifierState |= ModifierState.control; break;
								case 6: modifierState |= ModifierState.shift | ModifierState.control; break;
								case 7: modifierState |= ModifierState.alt | ModifierState.control; break;
								case 8: modifierState |= ModifierState.shift | ModifierState.alt | ModifierState.control; break;
								case 9:
								..
								case 16:
									modifierState |= ModifierState.meta;
									if(modGot != 9) {
										modGot -= 8;
										goto mod_switch;
									}
								break;

								// this is an extension in my own terminal emulator
								case 20:
								..
								case 36:
									modifierState |= ModifierState.windows;
									modGot -= 20;
									goto mod_switch;
								default:
							}

							switch(terminator) {
								case 'A': return keyPressAndRelease(NonCharacterKeyEvent.Key.UpArrow, modifierState);
								case 'B': return keyPressAndRelease(NonCharacterKeyEvent.Key.DownArrow, modifierState);
								case 'C': return keyPressAndRelease(NonCharacterKeyEvent.Key.RightArrow, modifierState);
								case 'D': return keyPressAndRelease(NonCharacterKeyEvent.Key.LeftArrow, modifierState);

								case 'H': return keyPressAndRelease(NonCharacterKeyEvent.Key.Home, modifierState);
								case 'F': return keyPressAndRelease(NonCharacterKeyEvent.Key.End, modifierState);

								case 'P': return keyPressAndRelease(NonCharacterKeyEvent.Key.F1, modifierState);
								case 'Q': return keyPressAndRelease(NonCharacterKeyEvent.Key.F2, modifierState);
								case 'R': return keyPressAndRelease(NonCharacterKeyEvent.Key.F3, modifierState);
								case 'S': return keyPressAndRelease(NonCharacterKeyEvent.Key.F4, modifierState);

								case '~': // others
									switch(parts[0]) {
										case "5": return keyPressAndRelease(NonCharacterKeyEvent.Key.PageUp, modifierState);
										case "6": return keyPressAndRelease(NonCharacterKeyEvent.Key.PageDown, modifierState);
										case "2": return keyPressAndRelease(NonCharacterKeyEvent.Key.Insert, modifierState);
										case "3": return keyPressAndRelease(NonCharacterKeyEvent.Key.Delete, modifierState);

										case "15": return keyPressAndRelease(NonCharacterKeyEvent.Key.F5, modifierState);
										case "17": return keyPressAndRelease(NonCharacterKeyEvent.Key.F6, modifierState);
										case "18": return keyPressAndRelease(NonCharacterKeyEvent.Key.F7, modifierState);
										case "19": return keyPressAndRelease(NonCharacterKeyEvent.Key.F8, modifierState);
										case "20": return keyPressAndRelease(NonCharacterKeyEvent.Key.F9, modifierState);
										case "21": return keyPressAndRelease(NonCharacterKeyEvent.Key.F10, modifierState);
										case "23": return keyPressAndRelease(NonCharacterKeyEvent.Key.F11, modifierState);
										case "24": return keyPressAndRelease(NonCharacterKeyEvent.Key.F12, modifierState);
										default:
									}
								break;

								default:
							}
						} else if(terminal.terminalInFamily("rxvt")) {
							// FIXME: figure these out. rxvt seems to just change the terminator while keeping the rest the same
							// though it isn't consistent. ugh.
						} else {
							// maybe we could do more terminals, but linux doesn't even send it and screen just seems to pass through, so i don't think so; xterm prolly covers most them anyway
							// so this space is semi-intentionally left blank
						}
					}
			}

			return null;
		}

		auto c = nextRaw(true);
		if(c == -1)
			return null; // interrupted; give back nothing so the other level can recheck signal flags
		if(c == 0)
			return [InputEvent(EndOfFileEvent())];
		if(c == '\033') {
			if(timedCheckForInput(50)) {
				// escape sequence
				c = nextRaw();
				if(c == '[') { // CSI, ends on anything >= 'A'
					return doEscapeSequence(readEscapeSequence(sequenceBuffer));
				} else if(c == 'O') {
					// could be xterm function key
					auto n = nextRaw();

					char[3] thing;
					thing[0] = '\033';
					thing[1] = 'O';
					thing[2] = cast(char) n;

					auto cap = terminal.findSequenceInTermcap(thing);
					if(cap is null) {
						return charPressAndRelease('\033') ~
							charPressAndRelease('O') ~
							charPressAndRelease(thing[2]);
					} else {
						return translateTermcapName(cap);
					}
				} else {
					// I don't know, probably unsupported terminal or just quick user input or something
					return charPressAndRelease('\033') ~ charPressAndRelease(nextChar(c));
				}
			} else {
				// user hit escape (or super slow escape sequence, but meh)
				return keyPressAndRelease(NonCharacterKeyEvent.Key.escape);
			}
		} else {
			// FIXME: what if it is neither? we should check the termcap
			auto next = nextChar(c);
			if(next == 127) // some terminals send 127 on the backspace. Let's normalize that.
				next = '\b';
			return charPressAndRelease(next);
		}
	}
}

/// Input event for characters
struct CharacterEvent {
	/// .
	enum Type {
		Released, /// .
		Pressed /// .
	}

	Type eventType; /// .
	dchar character; /// .
	uint modifierState; /// Don't depend on this to be available for character events
}

struct NonCharacterKeyEvent {
	/// .
	enum Type {
		Released, /// .
		Pressed /// .
	}
	Type eventType; /// .

	// these match Windows virtual key codes numerically for simplicity of translation there
	//http://msdn.microsoft.com/en-us/library/windows/desktop/dd375731%28v=vs.85%29.aspx
	/// .
	enum Key : int {
		escape = 0x1b, /// .
		F1 = 0x70, /// .
		F2 = 0x71, /// .
		F3 = 0x72, /// .
		F4 = 0x73, /// .
		F5 = 0x74, /// .
		F6 = 0x75, /// .
		F7 = 0x76, /// .
		F8 = 0x77, /// .
		F9 = 0x78, /// .
		F10 = 0x79, /// .
		F11 = 0x7A, /// .
		F12 = 0x7B, /// .
		LeftArrow = 0x25, /// .
		RightArrow = 0x27, /// .
		UpArrow = 0x26, /// .
		DownArrow = 0x28, /// .
		Insert = 0x2d, /// .
		Delete = 0x2e, /// .
		Home = 0x24, /// .
		End = 0x23, /// .
		PageUp = 0x21, /// .
		PageDown = 0x22, /// .
		}
	Key key; /// .

	uint modifierState; /// A mask of ModifierState. Always use by checking modifierState & ModifierState.something, the actual value differs across platforms

}

/// .
struct PasteEvent {
	string pastedText; /// .
}

/// .
struct MouseEvent {
	// these match simpledisplay.d numerically as well
	/// .
	enum Type {
		Moved = 0, /// .
		Pressed = 1, /// .
		Released = 2, /// .
		Clicked, /// .
	}

	Type eventType; /// .

	// note: these should numerically match simpledisplay.d for maximum beauty in my other code
	/// .
	enum Button : uint {
		None = 0, /// .
		Left = 1, /// .
		Middle = 4, /// .
		Right = 2, /// .
		ScrollUp = 8, /// .
		ScrollDown = 16 /// .
	}
	uint buttons; /// A mask of Button
	int x; /// 0 == left side
	int y; /// 0 == top
	uint modifierState; /// shift, ctrl, alt, meta, altgr. Not always available. Always check by using modifierState & ModifierState.something
}

/// .
struct SizeChangedEvent {
	int oldWidth;
	int oldHeight;
	int newWidth;
	int newHeight;
}

/// the user hitting ctrl+c will send this
/// You should drop what you're doing and perhaps exit when this happens.
struct UserInterruptionEvent {}

/// If the user hangs up (for example, closes the terminal emulator without exiting the app), this is sent.
/// If you receive it, you should generally cleanly exit.
struct HangupEvent {}

/// Sent upon receiving end-of-file from stdin.
struct EndOfFileEvent {}

interface CustomEvent {}

version(Windows)
enum ModifierState : uint {
	shift = 0x10,
	control = 0x8 | 0x4, // 8 == left ctrl, 4 == right ctrl

	// i'm not sure if the next two are available
	alt = 2 | 1, //2 ==left alt, 1 == right alt

	// FIXME: I don't think these are actually available
	windows = 512,
	meta = 4096, // FIXME sanity

	// I don't think this is available on Linux....
	scrollLock = 0x40,
}
else
enum ModifierState : uint {
	shift = 4,
	alt = 2,
	control = 16,
	meta = 8,

	windows = 512 // only available if you are using my terminal emulator; it isn't actually offered on standard linux ones
}

/// GetNextEvent returns this. Check the type, then use get to get the more detailed input
struct InputEvent {
	/// .
	enum Type {
		CharacterEvent, ///.
		NonCharacterKeyEvent, /// .
		PasteEvent, /// The user pasted some text. Not always available, the pasted text might come as a series of character events instead.
		MouseEvent, /// only sent if you subscribed to mouse events
		SizeChangedEvent, /// only sent if you subscribed to size events
		UserInterruptionEvent, /// the user hit ctrl+c
		EndOfFileEvent, /// stdin has received an end of file
		HangupEvent, /// the terminal hanged up - for example, if the user closed a terminal emulator
		CustomEvent /// .
	}

	/// .
	@property Type type() { return t; }

	/// .
	@property auto get(Type T)() {
		if(type != T)
			throw new Exception("Wrong event type");
		static if(T == Type.CharacterEvent)
			return characterEvent;
		else static if(T == Type.NonCharacterKeyEvent)
			return nonCharacterKeyEvent;
		else static if(T == Type.PasteEvent)
			return pasteEvent;
		else static if(T == Type.MouseEvent)
			return mouseEvent;
		else static if(T == Type.SizeChangedEvent)
			return sizeChangedEvent;
		else static if(T == Type.UserInterruptionEvent)
			return userInterruptionEvent;
		else static if(T == Type.EndOfFileEvent)
			return endOfFileEvent;
		else static if(T == Type.HangupEvent)
			return hangupEvent;
		else static if(T == Type.CustomEvent)
			return customEvent;
		else static assert(0, "Type " ~ T.stringof ~ " not added to the get function");
	}

	private {
		this(CharacterEvent c) {
			t = Type.CharacterEvent;
			characterEvent = c;
		}
		this(NonCharacterKeyEvent c) {
			t = Type.NonCharacterKeyEvent;
			nonCharacterKeyEvent = c;
		}
		this(PasteEvent c) {
			t = Type.PasteEvent;
			pasteEvent = c;
		}
		this(MouseEvent c) {
			t = Type.MouseEvent;
			mouseEvent = c;
		}
		this(SizeChangedEvent c) {
			t = Type.SizeChangedEvent;
			sizeChangedEvent = c;
		}
		this(UserInterruptionEvent c) {
			t = Type.UserInterruptionEvent;
			userInterruptionEvent = c;
		}
		this(HangupEvent c) {
			t = Type.HangupEvent;
			hangupEvent = c;
		}
		this(EndOfFileEvent c) {
			t = Type.EndOfFileEvent;
			endOfFileEvent = c;
		}
		this(CustomEvent c) {
			t = Type.CustomEvent;
			customEvent = c;
		}

		Type t;

		union {
			CharacterEvent characterEvent;
			NonCharacterKeyEvent nonCharacterKeyEvent;
			PasteEvent pasteEvent;
			MouseEvent mouseEvent;
			SizeChangedEvent sizeChangedEvent;
			UserInterruptionEvent userInterruptionEvent;
			HangupEvent hangupEvent;
			EndOfFileEvent endOfFileEvent;
			CustomEvent customEvent;
		}
	}
}

version(Demo)
void main() {
	auto terminal = Terminal(ConsoleOutputType.cellular);

	//terminal.color(Color.DEFAULT, Color.DEFAULT);

	//
	/*
	auto getter = new LineGetter(&terminal, "test");
	getter.prompt = "> ";
	terminal.writeln("\n" ~ getter.getline());
	terminal.writeln("\n" ~ getter.getline());
	terminal.writeln("\n" ~ getter.getline());
	getter.dispose();
	*/

	terminal.writeln(terminal.getline());
	terminal.writeln(terminal.getline());
	terminal.writeln(terminal.getline());

	//input.getch();

	// return;
	//

	terminal.setTitle("Basic I/O");
	auto input = RealTimeConsoleInput(&terminal, ConsoleInputFlags.raw | ConsoleInputFlags.allInputEvents);
	terminal.color(Color.green | Bright, Color.black);

	terminal.write("test some long string to see if it wraps or what because i dont really know what it is going to do so i just want to test i think it will wrap but gotta be sure lolololololololol");
	terminal.writefln("%d %d", terminal.cursorX, terminal.cursorY);

	int centerX = terminal.width / 2;
	int centerY = terminal.height / 2;

	bool timeToBreak = false;

	void handleEvent(InputEvent event) {
		terminal.writef("%s\n", event.type);
		final switch(event.type) {
			case InputEvent.Type.UserInterruptionEvent:
			case InputEvent.Type.HangupEvent:
			case InputEvent.Type.EndOfFileEvent:
				timeToBreak = true;
				version(with_eventloop) {
					import arsd.eventloop;
					exit();
				}
			break;
			case InputEvent.Type.SizeChangedEvent:
				auto ev = event.get!(InputEvent.Type.SizeChangedEvent);
				terminal.writeln(ev);
			break;
			case InputEvent.Type.CharacterEvent:
				auto ev = event.get!(InputEvent.Type.CharacterEvent);
				terminal.writef("\t%s\n", ev);
				if(ev.character == 'Q') {
					timeToBreak = true;
					version(with_eventloop) {
						import arsd.eventloop;
						exit();
					}
				}

				if(ev.character == 'C')
					terminal.clear();
			break;
			case InputEvent.Type.NonCharacterKeyEvent:
				terminal.writef("\t%s\n", event.get!(InputEvent.Type.NonCharacterKeyEvent));
			break;
			case InputEvent.Type.PasteEvent:
				terminal.writef("\t%s\n", event.get!(InputEvent.Type.PasteEvent));
			break;
			case InputEvent.Type.MouseEvent:
				terminal.writef("\t%s\n", event.get!(InputEvent.Type.MouseEvent));
			break;
			case InputEvent.Type.CustomEvent:
			break;
		}

		terminal.writefln("%d %d", terminal.cursorX, terminal.cursorY);

		/*
		if(input.kbhit()) {
			auto c = input.getch();
			if(c == 'q' || c == 'Q')
				break;
			terminal.moveTo(centerX, centerY);
			terminal.writef("%c", c);
			terminal.flush();
		}
		usleep(10000);
		*/
	}

	version(with_eventloop) {
		import arsd.eventloop;
		addListener(&handleEvent);
		loop();
	} else {
		loop: while(true) {
			auto event = input.nextEvent();
			handleEvent(event);
			if(timeToBreak)
				break loop;
		}
	}
}

/**
	FIXME: support lines that wrap
	FIXME: better controls maybe

	FIXME: fix lengths on prompt and suggestion

	A note on history:

	To save history, you must call LineGetter.dispose() when you're done with it.
	History will not be automatically saved without that call!

	The history saving and loading as a trivially encountered race condition: if you
	open two programs that use the same one at the same time, the one that closes second
	will overwrite any history changes the first closer saved.

	GNU Getline does this too... and it actually kinda drives me nuts. But I don't know
	what a good fix is except for doing a transactional commit straight to the file every
	time and that seems like hitting the disk way too often.

	We could also do like a history server like a database daemon that keeps the order
	correct but I don't actually like that either because I kinda like different bashes
	to have different history, I just don't like it all to get lost.

	Regardless though, this isn't even used in bash anyway, so I don't think I care enough
	to put that much effort into it. Just using separate files for separate tasks is good
	enough I think.
*/
class LineGetter {
	/* A note on the assumeSafeAppends in here: since these buffers are private, we can be
	   pretty sure that stomping isn't an issue, so I'm using this liberally to keep the
	   append/realloc code simple and hopefully reasonably fast. */

	// saved to file
	string[] history;

	// not saved
	Terminal* terminal;
	string historyFilename;

	/// Make sure that the parent terminal struct remains in scope for the duration
	/// of LineGetter's lifetime, as it does hold on to and use the passed pointer
	/// throughout.
	///
	/// historyFilename will load and save an input history log to a particular folder.
	/// Leaving it null will mean no file will be used and history will not be saved across sessions.
	this(Terminal* tty, string historyFilename = null) {
		this.terminal = tty;
		this.historyFilename = historyFilename;

		line.reserve(128);

		if(historyFilename.length)
			loadSettingsAndHistoryFromFile();

		regularForeground = cast(Color) terminal._currentForeground;
		background = cast(Color) terminal._currentBackground;
		suggestionForeground = Color.blue;
	}

	/// Call this before letting LineGetter die so it can do any necessary
	/// cleanup and save the updated history to a file.
	void dispose() {
		if(historyFilename.length)
			saveSettingsAndHistoryToFile();
	}

	/// Override this to change the directory where history files are stored
	///
	/// Default is $HOME/.arsd-getline on linux and %APPDATA%/arsd-getline/ on Windows.
	string historyFileDirectory() {
		version(Windows) {
			char[1024] path;
			// FIXME: this doesn't link because the crappy dmd lib doesn't have it
			if(0) { // SHGetFolderPathA(null, CSIDL_APPDATA, null, 0, path.ptr) >= 0) {
				import core.stdc.string;
				return cast(string) path[0 .. strlen(path.ptr)] ~ "\\arsd-getline";
			} else {
				import std.process;
				return environment["APPDATA"] ~ "\\arsd-getline";
			}
		} else version(Posix) {
			import std.process;
			return environment["HOME"] ~ "/.arsd-getline";
		}
	}

	/// You can customize the colors here. You should set these after construction, but before
	/// calling startGettingLine or getline.
	Color suggestionForeground;
	Color regularForeground; /// .
	Color background; /// .
	//bool reverseVideo;

	/// Set this if you want a prompt to be drawn with the line. It does NOT support color in string.
	string prompt;

	/// Turn on auto suggest if you want a greyed thing of what tab
	/// would be able to fill in as you type.
	///
	/// You might want to turn it off if generating a completion list is slow.
	bool autoSuggest = true;


	/// Override this if you don't want all lines added to the history.
	/// You can return null to not add it at all, or you can transform it.
	string historyFilter(string candidate) {
		return candidate;
	}

	/// You may override this to do nothing
	void saveSettingsAndHistoryToFile() {
		import std.file;
		if(!exists(historyFileDirectory))
			mkdir(historyFileDirectory);
		auto fn = historyPath();
		import std.stdio;
		auto file = File(fn, "wt");
		foreach(item; history)
			file.writeln(item);
	}

	private string historyPath() {
		import std.path;
		auto filename = historyFileDirectory() ~ dirSeparator ~ historyFilename ~ ".history";
		return filename;
	}

	/// You may override this to do nothing
	void loadSettingsAndHistoryFromFile() {
		import std.file;
		history = null;
		auto fn = historyPath();
		if(exists(fn)) {
			import std.stdio;
			foreach(line; File(fn, "rt").byLine)
				history ~= line.idup;

		}
	}

	/**
		Override this to provide tab completion. You may use the candidate
		argument to filter the list, but you don't have to (LineGetter will
		do it for you on the values you return).

		Ideally, you wouldn't return more than about ten items since the list
		gets difficult to use if it is too long.

		Default is to provide recent command history as autocomplete.
	*/
	protected string[] tabComplete(in dchar[] candidate) {
		return history.length > 20 ? history[0 .. 20] : history;
	}

	private string[] filterTabCompleteList(string[] list) {
		if(list.length == 0)
			return list;

		string[] f;
		f.reserve(list.length);

		foreach(item; list) {
			import std.algorithm;
			if(startsWith(item, line[0 .. cursorPosition]))
				f ~= item;
		}

		return f;
	}

	/// Override this to provide a custom display of the tab completion list
	protected void showTabCompleteList(string[] list) {
		if(list.length) {
			// FIXME: allow mouse clicking of an item, that would be cool

			//if(terminal.type == ConsoleOutputType.linear) {
				terminal.writeln();
				foreach(item; list) {
					terminal.color(suggestionForeground, background);
					import std.utf;
					auto idx = codeLength!char(line[0 .. cursorPosition]);
					terminal.write("  ", item[0 .. idx]);
					terminal.color(regularForeground, background);
					terminal.writeln(item[idx .. $]);
				}
				updateCursorPosition();
				redraw();
			//}
		}
	}

	/// One-call shop for the main workhorse
	/// If you already have a RealTimeConsoleInput ready to go, you
	/// should pass a pointer to yours here. Otherwise, LineGetter will
	/// make its own.
	public string getline(RealTimeConsoleInput* input = null) {
		startGettingLine();
		if(input is null) {
			auto i = RealTimeConsoleInput(terminal, ConsoleInputFlags.raw | ConsoleInputFlags.allInputEvents);
			while(workOnLine(i.nextEvent())) {}
		} else
			while(workOnLine(input.nextEvent())) {}
		return finishGettingLine();
	}

	private int currentHistoryViewPosition = 0;
	private dchar[] uncommittedHistoryCandidate;
	void loadFromHistory(int howFarBack) {
		if(howFarBack < 0)
			howFarBack = 0;
		if(howFarBack > history.length) // lol signed/unsigned comparison here means if i did this first, before howFarBack < 0, it would totally cycle around.
			howFarBack = cast(int) history.length;
		if(howFarBack == currentHistoryViewPosition)
			return;
		if(currentHistoryViewPosition == 0) {
			// save the current line so we can down arrow back to it later
			if(uncommittedHistoryCandidate.length < line.length) {
				uncommittedHistoryCandidate.length = line.length;
			}

			uncommittedHistoryCandidate[0 .. line.length] = line[];
			uncommittedHistoryCandidate = uncommittedHistoryCandidate[0 .. line.length];
			uncommittedHistoryCandidate.assumeSafeAppend();
		}

		currentHistoryViewPosition = howFarBack;

		if(howFarBack == 0) {
			line.length = uncommittedHistoryCandidate.length;
			line.assumeSafeAppend();
			line[] = uncommittedHistoryCandidate[];
		} else {
			line = line[0 .. 0];
			line.assumeSafeAppend();
			foreach(dchar ch; history[$ - howFarBack])
				line ~= ch;
		}

		cursorPosition = cast(int) line.length;
	}

	bool insertMode = true;

	private dchar[] line;
	private int cursorPosition = 0;

	// used for redrawing the line in the right place
	// and detecting mouse events on our line.
	private int startOfLineX;
	private int startOfLineY;

	private string suggestion(string[] list = null) {
		import std.algorithm, std.utf;
		auto relevantLineSection = line[0 .. cursorPosition];
		// FIXME: see about caching the list if we easily can
		if(list is null)
			list = filterTabCompleteList(tabComplete(relevantLineSection));

		if(list.length) {
			string commonality = list[0];
			foreach(item; list[1 .. $]) {
				commonality = commonPrefix(commonality, item);
			}

			if(commonality.length) {
				return commonality[codeLength!char(relevantLineSection) .. $];
			}
		}

		return null;
	}

	/// Adds a character at the current position in the line. You can call this too if you hook events for hotkeys or something.
	/// You'll probably want to call redraw() after adding chars.
	void addChar(dchar ch) {
		assert(cursorPosition >= 0 && cursorPosition <= line.length);
		if(cursorPosition == line.length)
			line ~= ch;
		else {
			assert(line.length);
			if(insertMode) {
				line ~= ' ';
				for(int i = cast(int) line.length - 2; i >= cursorPosition; i --)
					line[i + 1] = line[i];
			}
			line[cursorPosition] = ch;
		}
		cursorPosition++;
	}

	/// .
	void addString(string s) {
		// FIXME: this could be more efficient
		// but does it matter? these lines aren't super long anyway. But then again a paste could be excessively long (prolly accidental, but still)
		foreach(dchar ch; s)
			addChar(ch);
	}

	/// Deletes the character at the current position in the line.
	/// You'll probably want to call redraw() after deleting chars.
	void deleteChar() {
		if(cursorPosition == line.length)
			return;
		for(int i = cursorPosition; i < line.length - 1; i++)
			line[i] = line[i + 1];
		line = line[0 .. $-1];
		line.assumeSafeAppend();
	}

	int lastDrawLength = 0;
	void redraw() {
		terminal.moveTo(startOfLineX, startOfLineY);

		terminal.write(prompt);

		terminal.write(line);
		auto suggestion = ((cursorPosition == line.length) && autoSuggest) ? this.suggestion() : null;
		if(suggestion.length) {
			terminal.color(suggestionForeground, background);
			terminal.write(suggestion);
			terminal.color(regularForeground, background);
		}
		if(line.length < lastDrawLength)
		foreach(i; line.length + suggestion.length + prompt.length .. lastDrawLength)
			terminal.write(" ");
		lastDrawLength = cast(int) (line.length + suggestion.length + prompt.length); // FIXME: graphemes and utf-8 on suggestion/prompt

		// FIXME: wrapping
		terminal.moveTo(startOfLineX + cursorPosition + cast(int) prompt.length, startOfLineY);
	}

	/// Starts getting a new line. Call workOnLine and finishGettingLine afterward.
	///
	/// Make sure that you've flushed your input and output before calling this
	/// function or else you might lose events or get exceptions from this.
	void startGettingLine() {
		// reset from any previous call first
		cursorPosition = 0;
		lastDrawLength = 0;
		justHitTab = false;
		currentHistoryViewPosition = 0;
		if(line.length) {
			line = line[0 .. 0];
			line.assumeSafeAppend();
		}

		updateCursorPosition();
		terminal.showCursor();

		redraw();
	}

	private void updateCursorPosition() {
		terminal.flush();

		// then get the current cursor position to start fresh
		version(Windows) {
			CONSOLE_SCREEN_BUFFER_INFO info;
			GetConsoleScreenBufferInfo(terminal.hConsole, &info);
			startOfLineX = info.dwCursorPosition.X;
			startOfLineY = info.dwCursorPosition.Y;
		} else {
			// request current cursor position

			// we have to turn off cooked mode to get this answer, otherwise it will all
			// be messed up. (I hate unix terminals, the Windows way is so much easer.)
			RealTimeConsoleInput input = RealTimeConsoleInput(terminal, ConsoleInputFlags.raw);

			terminal.writeStringRaw("\033[6n");
			terminal.flush();

			import core.sys.posix.unistd;
			// reading directly to bypass any buffering
			ubyte[16] buffer;
			auto len = read(terminal.fdIn, buffer.ptr, buffer.length);
			if(len <= 0)
				throw new Exception("Couldn't get cursor position to initialize get line");
			auto got = buffer[0 .. len];
			if(got.length < 6)
				throw new Exception("not enough cursor reply answer");
			if(got[0] != '\033' || got[1] != '[' || got[$-1] != 'R')
				throw new Exception("wrong answer for cursor position");
			auto gots = cast(char[]) got[2 .. $-1];

			import std.conv;
			import std.string;

			auto pieces = split(gots, ";");
			if(pieces.length != 2) throw new Exception("wtf wrong answer on cursor position");

			startOfLineX = to!int(pieces[1]) - 1;
			startOfLineY = to!int(pieces[0]) - 1;
		}

		// updating these too because I can with the more accurate info from above
		terminal._cursorX = startOfLineX;
		terminal._cursorY = startOfLineY;
	}

	private bool justHitTab;

	/// for integrating into another event loop
	/// you can pass individual events to this and
	/// the line getter will work on it
	///
	/// returns false when there's nothing more to do
	bool workOnLine(InputEvent e) {
		switch(e.type) {
			case InputEvent.Type.EndOfFileEvent:
				justHitTab = false;
				return false;
			break;
			case InputEvent.Type.CharacterEvent:
				if(e.characterEvent.eventType == CharacterEvent.Type.Released)
					return true;
				/* Insert the character (unless it is backspace, tab, or some other control char) */
				auto ch = e.characterEvent.character;
				switch(ch) {
					case 4: // ctrl+d will also send a newline-equivalent 
					case '\r':
					case '\n':
						justHitTab = false;
						return false;
					case '\t':
						auto relevantLineSection = line[0 .. cursorPosition];
						auto possibilities = filterTabCompleteList(tabComplete(relevantLineSection));
						import std.utf;

						if(possibilities.length == 1) {
							auto toFill = possibilities[0][codeLength!char(relevantLineSection) .. $];
							if(toFill.length) {
								addString(toFill);
								redraw();
							}
							justHitTab = false;
						} else {
							if(justHitTab) {
								justHitTab = false;
								showTabCompleteList(possibilities);
							} else {
								justHitTab = true;
								/* fill it in with as much commonality as there is amongst all the suggestions */
								auto suggestion = this.suggestion(possibilities);
								if(suggestion.length) {
									addString(suggestion);
									redraw();
								}
							}
						}
					break;
					case '\b':
						justHitTab = false;
						if(cursorPosition) {
							cursorPosition--;
							for(int i = cursorPosition; i < line.length - 1; i++)
								line[i] = line[i + 1];
							line = line[0 .. $ - 1];
							line.assumeSafeAppend();
							redraw();
						}
					break;
					default:
						justHitTab = false;
						addChar(ch);
						redraw();
				}
			break;
			case InputEvent.Type.NonCharacterKeyEvent:
				if(e.nonCharacterKeyEvent.eventType == NonCharacterKeyEvent.Type.Released)
					return true;
				justHitTab = false;
				/* Navigation */
				auto key = e.nonCharacterKeyEvent.key;
				switch(key) {
					case NonCharacterKeyEvent.Key.LeftArrow:
						if(cursorPosition)
							cursorPosition--;
						redraw();
					break;
					case NonCharacterKeyEvent.Key.RightArrow:
						if(cursorPosition < line.length)
							cursorPosition++;
						redraw();
					break;
					case NonCharacterKeyEvent.Key.UpArrow:
						loadFromHistory(currentHistoryViewPosition + 1);
						redraw();
					break;
					case NonCharacterKeyEvent.Key.DownArrow:
						loadFromHistory(currentHistoryViewPosition - 1);
						redraw();
					break;
					case NonCharacterKeyEvent.Key.PageUp:
						loadFromHistory(cast(int) history.length);
						redraw();
					break;
					case NonCharacterKeyEvent.Key.PageDown:
						loadFromHistory(0);
						redraw();
					break;
					case NonCharacterKeyEvent.Key.Home:
						cursorPosition = 0;
						redraw();
					break;
					case NonCharacterKeyEvent.Key.End:
						cursorPosition = cast(int) line.length;
						redraw();
					break;
					case NonCharacterKeyEvent.Key.Insert:
						insertMode = !insertMode;
						// FIXME: indicate this on the UI somehow
						// like change the cursor or something
					break;
					case NonCharacterKeyEvent.Key.Delete:
						deleteChar();
						redraw();
					break;
					default:
						/* ignore */
				}
			break;
			case InputEvent.Type.PasteEvent:
				justHitTab = false;
				addString(e.pasteEvent.pastedText);
				redraw();
			break;
			case InputEvent.Type.MouseEvent:
				/* Clicking with the mouse to move the cursor is so much easier than arrowing
				   or even emacs/vi style movements much of the time, so I'ma support it. */

				auto me = e.mouseEvent;
				if(me.eventType == MouseEvent.Type.Pressed) {
					if(me.buttons & MouseEvent.Button.Left) {
						if(me.y == startOfLineY) {
							// FIXME: prompt.length should be graphemes or at least code poitns
							int p = me.x - startOfLineX - cast(int) prompt.length;
							if(p >= 0 && p < line.length) {
								justHitTab = false;
								cursorPosition = p;
								redraw();
							}
						}
					}
				}
			break;
			case InputEvent.Type.SizeChangedEvent:
				/* We'll adjust the bounding box. If you don't like this, handle SizeChangedEvent
				   yourself and then don't pass it to this function. */
				// FIXME
			break;
			case InputEvent.Type.UserInterruptionEvent:
				/* I'll take this as canceling the line. */
				throw new Exception("user canceled"); // FIXME
			break;
			case InputEvent.Type.HangupEvent:
				/* I'll take this as canceling the line. */
				throw new Exception("user hanged up"); // FIXME
			break;
			default:
				/* ignore. ideally it wouldn't be passed to us anyway! */
		}

		return true;
	}

	string finishGettingLine() {
		import std.conv;
		auto f = to!string(line);
		auto history = historyFilter(f);
		if(history !is null)
			this.history ~= history;

		// FIXME: we should hide the cursor if it was hidden in the call to startGettingLine
		return f;
	}
}

version(Windows) {
	// to get the directory for saving history in the line things
	enum CSIDL_APPDATA = 26;
	extern(Windows) HRESULT SHGetFolderPathA(HWND, int, HANDLE, DWORD, LPSTR);
}

/*

	// more efficient scrolling
	http://msdn.microsoft.com/en-us/library/windows/desktop/ms685113%28v=vs.85%29.aspx
	// and the unix sequences


	rxvt documentation:
	use this to finish the input magic for that


       For the keypad, use Shift to temporarily override Application-Keypad
       setting use Num_Lock to toggle Application-Keypad setting if Num_Lock
       is off, toggle Application-Keypad setting. Also note that values of
       Home, End, Delete may have been compiled differently on your system.

                         Normal       Shift         Control      Ctrl+Shift
       Tab               ^I           ESC [ Z       ^I           ESC [ Z
       BackSpace         ^H           ^?            ^?           ^?
       Find              ESC [ 1 ~    ESC [ 1 $     ESC [ 1 ^    ESC [ 1 @
       Insert            ESC [ 2 ~    paste         ESC [ 2 ^    ESC [ 2 @
       Execute           ESC [ 3 ~    ESC [ 3 $     ESC [ 3 ^    ESC [ 3 @
       Select            ESC [ 4 ~    ESC [ 4 $     ESC [ 4 ^    ESC [ 4 @
       Prior             ESC [ 5 ~    scroll-up     ESC [ 5 ^    ESC [ 5 @
       Next              ESC [ 6 ~    scroll-down   ESC [ 6 ^    ESC [ 6 @
       Home              ESC [ 7 ~    ESC [ 7 $     ESC [ 7 ^    ESC [ 7 @
       End               ESC [ 8 ~    ESC [ 8 $     ESC [ 8 ^    ESC [ 8 @
       Delete            ESC [ 3 ~    ESC [ 3 $     ESC [ 3 ^    ESC [ 3 @
       F1                ESC [ 11 ~   ESC [ 23 ~    ESC [ 11 ^   ESC [ 23 ^
       F2                ESC [ 12 ~   ESC [ 24 ~    ESC [ 12 ^   ESC [ 24 ^
       F3                ESC [ 13 ~   ESC [ 25 ~    ESC [ 13 ^   ESC [ 25 ^
       F4                ESC [ 14 ~   ESC [ 26 ~    ESC [ 14 ^   ESC [ 26 ^
       F5                ESC [ 15 ~   ESC [ 28 ~    ESC [ 15 ^   ESC [ 28 ^
       F6                ESC [ 17 ~   ESC [ 29 ~    ESC [ 17 ^   ESC [ 29 ^
       F7                ESC [ 18 ~   ESC [ 31 ~    ESC [ 18 ^   ESC [ 31 ^
       F8                ESC [ 19 ~   ESC [ 32 ~    ESC [ 19 ^   ESC [ 32 ^
       F9                ESC [ 20 ~   ESC [ 33 ~    ESC [ 20 ^   ESC [ 33 ^
       F10               ESC [ 21 ~   ESC [ 34 ~    ESC [ 21 ^   ESC [ 34 ^
       F11               ESC [ 23 ~   ESC [ 23 $    ESC [ 23 ^   ESC [ 23 @
       F12               ESC [ 24 ~   ESC [ 24 $    ESC [ 24 ^   ESC [ 24 @
       F13               ESC [ 25 ~   ESC [ 25 $    ESC [ 25 ^   ESC [ 25 @
       F14               ESC [ 26 ~   ESC [ 26 $    ESC [ 26 ^   ESC [ 26 @
       F15 (Help)        ESC [ 28 ~   ESC [ 28 $    ESC [ 28 ^   ESC [ 28 @
       F16 (Menu)        ESC [ 29 ~   ESC [ 29 $    ESC [ 29 ^   ESC [ 29 @

       F17               ESC [ 31 ~   ESC [ 31 $    ESC [ 31 ^   ESC [ 31 @
       F18               ESC [ 32 ~   ESC [ 32 $    ESC [ 32 ^   ESC [ 32 @
       F19               ESC [ 33 ~   ESC [ 33 $    ESC [ 33 ^   ESC [ 33 @
       F20               ESC [ 34 ~   ESC [ 34 $    ESC [ 34 ^   ESC [ 34 @
                                                                 Application
       Up                ESC [ A      ESC [ a       ESC O a      ESC O A
       Down              ESC [ B      ESC [ b       ESC O b      ESC O B
       Right             ESC [ C      ESC [ c       ESC O c      ESC O C
       Left              ESC [ D      ESC [ d       ESC O d      ESC O D
       KP_Enter          ^M                                      ESC O M
       KP_F1             ESC O P                                 ESC O P
       KP_F2             ESC O Q                                 ESC O Q
       KP_F3             ESC O R                                 ESC O R
       KP_F4             ESC O S                                 ESC O S
       XK_KP_Multiply    *                                       ESC O j
       XK_KP_Add         +                                       ESC O k
       XK_KP_Separator   ,                                       ESC O l
       XK_KP_Subtract    -                                       ESC O m
       XK_KP_Decimal     .                                       ESC O n
       XK_KP_Divide      /                                       ESC O o
       XK_KP_0           0                                       ESC O p
       XK_KP_1           1                                       ESC O q
       XK_KP_2           2                                       ESC O r
       XK_KP_3           3                                       ESC O s
       XK_KP_4           4                                       ESC O t
       XK_KP_5           5                                       ESC O u
       XK_KP_6           6                                       ESC O v
       XK_KP_7           7                                       ESC O w
       XK_KP_8           8                                       ESC O x
       XK_KP_9           9                                       ESC O y
*/