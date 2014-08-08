newwin(info){
	DetectHiddenWindows,On
	Gui,%info%:Default
	Gui,+hwndnewwin
	hwnd(info,newwin)
	Gui,Margin,0,0
	Gui,Add,edit,y0 y2 w100 gqf
	case:=settings.ssn("//Quick_Search/@case").text?"Checked":""
	regex:=settings.ssn("//Quick_Search/@regex").text?"Checked":""
	greed:=settings.ssn("//Quick_Search/@greed").text?"Checked":""
	Gui,Add,Checkbox,xm  gcase %case%,Case
	Gui,Add,Checkbox,gregex %regex%,Regex
	Gui,Add,Checkbox,x+5 gcase %greed%,Greed
	Gui,Add,Button,xm gnext,Next
	Gui,Add,Button,x+5 gsetselection,Set Search Area
	Gui,-Caption
	Gui,%info%:+parent1
	Gui,Show,NA AutoSize
	WinGetPos,,,w,h,% "ahk_id" newwin
	return {h:h,w:w,hwnd:newwin}
}