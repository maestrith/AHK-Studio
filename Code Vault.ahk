Code_Vault(){
	static ev,mainfile
	v.lastsc:=csc(),mainfile:=ssn(current(1),"@file").text,setup(19)
	Gui,Add,ListView,w100 h400 AltSubmit gdisplayvault,Code
	v.codevault:=new s(19,{pos:"x+10 w600 h400"}),csc({hwnd:v.codevault.sc}),hotkeys([19],{esc:"19GuiClose"})
	sc:=csc(),sc.2171(1),bracesetup(19)
	Gui,Add,Button,xm gaddcode,Add Code
	Gui,Add,Button,x+10 ginsertcode Default,Insert Into Segment
	Gui,Add,Button,x+10 gcreatenewsegment,Create New Segment
	Gui,Add,Button,x+10 gremovevaultentry,Remove Selected Entries
	pupulatevault:
	locker:=vault.sn("//code"),LV_Delete()
	while,ll:=locker.item[A_Index-1]
		LV_Add("",ssn(ll,"@name").text)
	LV_Modify(1,"Vis Focus Select")
	Gui,Show,,Code Vault
	WinWaitActive,% hwnd([19])
	ControlFocus,SysTreeView321,% hwnd([19])
	Return
	createnewsegment:
	SplitPath,mainfile,,cdir
	InputBox,file,New Segment,Enter a name for this new file.`nIt will be created in %cdir%
	if ErrorLevel
		return
	file:=!InStr(file,".ahk")?file ".ahk":file
	if FileExist(file)
		return m("File already exists")
	text:=csc().gettext(),csc({hwnd:v.lastsc.sc}),new_segment(cdir "\" file,text),hwnd({rem:19})
	return
	insertcode:
	text:=csc().gettext(),sc:=v.lastsc,sc.2003(sc.2008,text),fix_indent(sc),hwnd({rem:19}),csc({hwnd:v.lastsc.sc}),update({sc:sc.2357})
	return
	19GuiClose:
	19GuiEscape:
	hwnd({rem:19}),vault.save(1),csc({hwnd:v.lastsc.sc})
	Return
	addcode:
	InputBox,newcode,Name for code snippet,Please enter a name for a new code snippet.
	newcode:=RegExReplace(newcode," ","_")
	if ErrorLevel
		return
	if !locker:=vault.ssn("//code[@name='" newcode "']")
		locker:=vault.Add({path:"code",att:{name:newcode},dup:1})
	Gosub,pupulatevault
	return
	displayvault:
	sc:=csc()
	if LV_GetNext()
		sc.2171(0)
	LV_GetText(code,LV_GetNext())
	sc.2181(0,vault.ssn("//code[@name='" code "']").text)
	ControlFocus,SysTreeView321,% hwnd([19])
	return
	removevaultentry:
	MsgBox,292,Can not be undone,Are you sure?
	IfMsgBox,No
		return
	while,next:=LV_GetNext(){
		LV_GetText(name,next)
		rem:=vault.ssn("//code[@name='" name "']")
		rem.ParentNode.RemoveChild(rem),LV_Delete(next)
	}
	return
}