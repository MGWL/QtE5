/** DGui project file.

Copyright: Trogu Antonio Davide 2011-2013

License: $(HTTP boost.org/LICENSE_1_0.txt, Boost License 1.0).

Authors: Trogu Antonio Davide
*/

/**
  DGui Main Import Module.

  $(B $(RED DLL Versions and prerequisites:))

  $(TABLE
		$(TR	$(TD $(B Version)) $(TD $(B DLL))		$(TD $(B Distribution Platform)))
		$(TR	$(TD 4.0)		$(TD All)				$(TD Windows 95 and Windows NT 4.0))
		$(TR	$(TD 4.7)		$(TD All)				$(TD Windows Internet Explorer 3.x))
		$(TR	$(TD 4.71)		$(TD All)				$(TD Internet Explorer 4.0. $(I $(LPAREN)See note 2$(RPAREN))))
		$(TR	$(TD 4.72)		$(TD All)				$(TD Internet Explorer 4.01 and Windows 98. See note 2))
		$(TR	$(TD 5.0)		$(TD Shlwapi.dll)		$(TD Internet Explorer 5 and Windows 98 SE. See note 3))
		$(TR	$(TD 5.5)		$(TD Shlwapi.dll)		$(TD Internet Explorer 5.5 and Windows Millennium Edition (Windows Me)))
		$(TR	$(TD 6.0)		$(TD Shlwapi.dll)		$(TD Windows XP and Windows Vista))
		$(TR	$(TD 5.0)		$(TD Shell32.dll)		$(TD Windows 2000 and Windows Me. $(I $(LPAREN)See note 3$(RPAREN))))
		$(TR	$(TD 6.0)		$(TD Shell32.dll)		$(TD Windows XP))
		$(TR	$(TD 6.0.1)		$(TD Shell32.dll)		$(TD Windows Vista))
		$(TR	$(TD 6.1)			$(TD Shell32.dll)		$(TD Windows 7))
		$(TR	$(TD 5.8)		$(TD Comctl32.dll)		$(TD Internet Explorer 5. $(I $(LPAREN)See note 3$(RPAREN))))
		$(TR	$(TD 5.81)		$(TD Comctl32.dll)		$(TD Windows 2000 and Windows Me. $(I $(LPAREN)See note 3$(RPAREN))))
		$(TR	$(TD 5.82)		$(TD Comctl32.dll)		$(TD Windows XP and Windows Vista. $(I $(LPAREN)See note 4$(RPAREN))))
		$(TR	$(TD 6.0)		$(TD Comctl32.dll)		$(TD Windows XP, Windows Vista and Windows 7 $(LPAREN)Not redistributable$(RPAREN) ))
  )

  $(B $(BLUE NOTE 1:))

  The 4.00 versions of Shell32.dll and Comctl32.dll are found on the original
  versions of Windows 95 and Windows NT 4.0. New versions of Commctl.dll were shipped
  with _all Internet Explorer releases. Shlwapi.dll shipped with Internet Explorer 4.0,
  so its initial version number here is 4.71. The Shell was not updated with the Internet Explorer 3.0 release,
  so Shell32.dll does not have a version 4.70.
  While Shell32.dll versions 4.71 and 4.72 were shipped with the corresponding Internet Explorer releases,
  they were not necessarily installed (see note 2).
  For subsequent releases, the version numbers for the three DLLs are not identical.
  In general, you should assume that _all three DLLs may have different version numbers,
  and test each one separately.


  $(B $(BLUE NOTE 2:))

  All systems with Internet Explorer 4.0 or 4.01 will have the associated version of Comctl32.dll
  and Shlwapi.dll (4.71 or 4.72, respectively). However, for systems prior to Windows 98,
  Internet Explorer 4.0 and 4.01 can be installed with or without the integrated Shell.
  If they are installed with the integrated Shell, the associated version of Shell32.dll will be installed.
  If they are installed without the integrated Shell, Shell32.dll is not updated.
  No other versions of Internet Explorer update Shell32.dll. In other words, the presence of
  version 4.71 or 4.72 of Comctl32.dll or Shlwapi.dll on a system does not guarantee that Shell32.dll
  has the same version number. All Windows 98 systems have version 4.72 of Shell32.dll.


  $(B $(BLUE NOTE 3:))

  Version 5.80 of Comctl32.dll and version 5.0 of Shlwapi.dll are distributed with Internet Explorer 5.
  They will be found on all systems on which Internet Explorer 5 is installed, except Windows 2000.
  Internet Explorer 5 does not update the Shell, so version 5.0 of Shell32.dll will not be found on Windows NT,
  Windows 95, or Windows 98 systems.
  Version 5.0 of Shell32.dll will be distributed with Windows 2000 and Windows Me,
  along with version 5.0 of Shlwapi.dll, and version 5.81 of Comctl32.dll.


  $(B $(BLUE NOTE 4:))

  ComCtl32.dll version 6 is not redistributable.
  If you want your application to use ComCtl32.dll version 6,
  you must add an application manifest that indicates that version 6 should be used if it is available.

  $(I Source:) $(LINK2 http://msdn.microsoft.com/en-us/library/bb776779%28VS.85%29.aspx, MSDN)
 */

module dgui.all;

public import dgui.application;
public import dgui.messagebox, dgui.imagelist;
public import dgui.toolbar, dgui.statusbar, dgui.progressbar, dgui.trackbar;
public import dgui.core.geometry, dgui.core.events.event, dgui.core.utils;
public import dgui.colordialog, dgui.fontdialog, dgui.filebrowserdialog, dgui.folderbrowserdialog;
public import dgui.form, dgui.button, dgui.label, dgui.textbox, dgui.richtextbox, dgui.tabcontrol,
			  dgui.combobox, dgui.listbox, dgui.listview, dgui.treeview, dgui.picturebox,
			  dgui.scrollbar, dgui.tooltip;
