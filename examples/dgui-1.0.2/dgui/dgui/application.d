/** DGui project file.

Copyright: Trogu Antonio Davide 2011-2013

License: $(HTTP boost.org/LICENSE_1_0.txt, Boost License 1.0).

Authors: Trogu Antonio Davide
*/
module dgui.application;

pragma(lib, "gdi32.lib");
pragma(lib, "comdlg32.lib");

import std.path;
private import dgui.core.winapi;
private import dgui.core.utils;
private import dgui.richtextbox;
private import dgui.form;
private import dgui.button;
private import dgui.label;
private import std.utf: toUTFz;
private import std.file;
private import std.conv;
public import dgui.resources;

private enum
{
	info = "Exception Information:",
	xpManifestFile = "dgui.xml.manifest",
	errMsg = "An application exception has occured.\n1) Click \"Ignore\" to continue (The program can be unstable).\n2) Click \"Quit\" to exit.\n",
	xpManifest = `<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<assembly xmlns="urn:schemas-microsoft-com:asm.v1" manifestVersion="1.0">
<assemblyIdentity
version="1.0.0.0"
processorArchitecture="X86"
name="client"
type="win32"
/>
<description></description>

<!-- Enable Windows XP and higher themes with common controls -->
<dependency>
<dependentAssembly>
<assemblyIdentity
type="win32"
name="Microsoft.Windows.Common-Controls"
version="6.0.0.0"
processorArchitecture="X86"
publicKeyToken="6595b64144ccf1df"
language="*"
/>
</dependentAssembly>
</dependency>

<!-- Disable Windows Vista UAC compatibility heuristics -->
<trustInfo xmlns="urn:schemas-microsoft-com:asm.v2">
<security>
<requestedPrivileges>
<requestedExecutionLevel level="asInvoker"/>
</requestedPrivileges>
</security>
</trustInfo>

<!-- Enable Windows Vista-style font scaling on Vista -->
<asmv3:application xmlns:asmv3="urn:schemas-microsoft-com:asm.v3">
<asmv3:windowsSettings xmlns="http://schemas.microsoft.com/SMI/2005/WindowsSettings">
<dpiAware>true</dpiAware>
</asmv3:windowsSettings>
</asmv3:application>
</assembly>`
}
private alias extern(Windows) BOOL function(HANDLE hActCtx, ULONG_PTR* lpCookie) ActivateActCtxProc;
private alias extern(Windows) HANDLE function(ACTCTXW* pActCtx) CreateActCtxWProc;
private alias extern(Windows) bool function(INITCOMMONCONTROLSEX*) InitCommonControlsExProc;

/**
   The _Application class manage the whole program, it can be used for load embedded resources,
   close the program, get the current path and so on.
   Internally in initialize manifest (if available), DLLs, and it handle exceptions showing a window with exception information.
  */
class Application
{
	private static class ExceptionForm: Form
	{
		public this(Throwable e)
		{
			this.text = "An Exception was thrown...";
			this.size = Size(400, 220);
			this.controlBox = false;
			this.startPosition = FormStartPosition.centerParent;
			this.formBorderStyle = FormBorderStyle.fixedDialog;

			this._lblHead = new Label();
			this._lblHead.alignment = TextAlignment.middle | TextAlignment.left;
			this._lblHead.foreColor = Color(0xB4, 0x00, 0x00);
			this._lblHead.dock = DockStyle.top;
			this._lblHead.height = 50;
			this._lblHead.text = errMsg;
			this._lblHead.parent = this;

			this._lblInfo = new Label();
			this._lblInfo.alignment = TextAlignment.middle | TextAlignment.left;
			this._lblInfo.dock = DockStyle.top;
			this._lblInfo.height = 20;
			this._lblInfo.text = info;
			this._lblInfo.parent = this;

			this._rtfText = new RichTextBox();
			this._rtfText.borderStyle = BorderStyle.fixed3d;
			this._rtfText.dock = DockStyle.top;
			this._rtfText.height = 90;
			this._rtfText.backColor = SystemColors.colorButtonFace;
			this._rtfText.scrollBars = true;
			this._rtfText.readOnly = true;
			this._rtfText.text = e.msg;
			this._rtfText.parent = this;

			this._btnQuit = new Button();
			this._btnQuit.bounds = Rect(310, 164, 80, 23);
			this._btnQuit.dialogResult = DialogResult.abort;
			this._btnQuit.text = "Quit";
			this._btnQuit.parent = this;

			this._btnIgnore = new Button();
			this._btnIgnore.bounds = Rect(225, 164, 80, 23);
			this._btnIgnore.dialogResult = DialogResult.ignore;
			this._btnIgnore.text = "Ignore";
			this._btnIgnore.parent = this;
		}

		private RichTextBox _rtfText;
		private Label _lblHead;
		private Label _lblInfo;
		private Button _btnIgnore;
		private Button _btnQuit;
	}

	/// Static constructor (it enable the manifest, if available)
	public static this()
	{
		Application.enableManifest(); //Enable Manifest (if available)
	}

	/**
	      This method calls GetModuleHandle() API

		Returns:
			HINSTANCE of the program
	  */
	@property public static HINSTANCE instance()
	{
		return getHInstance();
	}

	/**
		Returns:
			String value of the executable path ($(B including) the executable name)
	   */
	@property public static string executablePath()
	{
		return getExecutablePath();
	}

	/**
	   This method calls GetTempPath() API

		Returns:
			String value of the system's TEMP directory
	   */
	@property public static string tempPath()
	{
		return dgui.core.utils.getTempPath();
	}

	/**
	   Returns:
		String value of the executable path ($(B without) the executable name)
	   */
	@property public static string startupPath()
	{
		return getStartupPath();
	}

	/**
	   This property allows to load embedded _resources.

		Returns:
			The Instance of reource object

		See_Also:
			Resources Class
	 */
	@property public static Resources resources()
	{
		return Resources.instance;
	}

	/**
	   Internal method that enable XP Manifest (if available)
	 */
	private static void enableManifest()
	{
		HMODULE hKernel32 = getModuleHandle("kernel32.dll");

		if(hKernel32)
		{
			CreateActCtxWProc createActCtx = cast(CreateActCtxWProc)GetProcAddress(hKernel32, "CreateActCtxW");

			if(createActCtx) // Don't break Win2k compatibility
			{
				string temp = dgui.core.utils.getTempPath();
				ActivateActCtxProc activateActCtx = cast(ActivateActCtxProc)GetProcAddress(hKernel32, "ActivateActCtx");
				temp = std.path.buildPath(temp, xpManifestFile);
				std.file.write(temp, xpManifest);

				ACTCTXW actx;

				actx.cbSize = ACTCTXW.sizeof;
				actx.dwFlags = 0;
				actx.lpSource = toUTFz!(wchar*)(temp);

				HANDLE hActx = createActCtx(&actx);

				if(hActx != INVALID_HANDLE_VALUE)
				{
					ULONG_PTR cookie;
					activateActCtx(hActx, &cookie);
				}

				if(std.file.exists(temp))
				{
					std.file.remove(temp);
				}
			}
		}

		initCommonControls();
	}

	/**
	  Internal method that loads ComCtl32 DLL
	  */
	private static void initCommonControls()
	{
		INITCOMMONCONTROLSEX icc = void;

		icc.dwSize = INITCOMMONCONTROLSEX.sizeof;
		icc.dwICC = 0xFFFFFFFF;

		HMODULE hComCtl32 = loadLibrary("comctl32.dll");

		if(hComCtl32)
		{
			InitCommonControlsExProc iccex = cast(InitCommonControlsExProc)GetProcAddress(hComCtl32, "InitCommonControlsEx");

			if(iccex)
			{
				iccex(&icc);
			}
		}
	}

	/**
	  Start the program and handles handles Exception
	  Params:
		mainForm = The Application's main form

	  Returns:
		Zero
	  */

	private static int doRun(Form mainForm)
	{
		//try
		//{
			mainForm.show();
		/*}
		catch(Throwable e)
		{
			switch(Application.showExceptionForm(e))
			{
				case DialogResult.abort:
					TerminateProcess(GetCurrentProcess(), -1);
					break;

				case DialogResult.ignore:
					Application.doRun(mainForm);
					break;

				default:
					break;
			}
		}*/

		return 0;
	}

	/**
	  Start the program and adds onClose() event at the MainForm
	  Params:
		mainForm = The Application's main form

	  Returns:
		Zero
	  */
	public static int run(Form mainForm)
	{
		mainForm.close.attach(&onMainFormClose);
		return Application.doRun(mainForm);
	}

	/**
	  Close the program.
	  Params:
		exitCode = Exit code of the program (usually is 0)
	  */
	public static void exit(int exitCode = 0)
	{
		ExitProcess(exitCode);
	}

	/**
	  When an exception was thrown, the _Application class call this method
	  showing the exception information, the user has the choice to continue the
	  application or terminate it.

	  Returns:
		A DialogResult enum that contains the button clicked by the user (ignore or abort)
	  */
	package static DialogResult showExceptionForm(Throwable e)
	{
		ExceptionForm ef = new ExceptionForm(e);
		return ef.showDialog();
	}

	/**
	  Close _Application event attached (internally) at the main form
	  */
	private static void onMainFormClose(Control sender, EventArgs e)
	{
		Application.exit();
	}
}
