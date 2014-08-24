help(){
	help=
(
Quick Search:
	Pressing Escape while using the Quick Search bar will return you to the main window
Toolbars:
	Right Click on a toolbar to change the buttons that appear in them.
	Shift+Drag buttons to re-arange them without using the Right Click option.
	Control+Click a button to change its icon.
	Alt+Click anywhere on a Toolbar to add a button (other than the debug Toolbar)
	Control+Right Click to delete a button (can not be undone).
Menu:
	Edit/Menu Editor allows you to change the way that the menus are arranged.
Auto Indent:
	Full Auto will adjust the indent of your script whenever you add a {, }, or press the enter key.
	Fix Next Line will just fix the next line adjusting for {, }, if statements, and a few others.
	Edit/Fix Indent will fix the indentation of your document as though you had on Full Auto.
)
	setup(11)
	Gui,Margin,0,0
	sc:=new s(11,{pos:"x0 y0 w800 h500"}),csc({hwnd:sc})
	SendMessage,0x400+91,1,,,% "ahk_id" sc.sc
	Gui,Add,Button,,Online Help
	Gui,Show,,AHK Studio Help
	sc.2181(0,help),sc.2025(0),hotkeys([11],{"Esc":"11GuiClose"})
	return
	11GuiClose:
	hwnd({rem:11}),csc({hwnd:s.main.1})
	return
	11buttononlinehelp:
	Run,http://github.com/maestrith/AHK-Studio/wiki
	return
}