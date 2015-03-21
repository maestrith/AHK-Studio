Code_Vault(){
	static ev,mainfile,newwin
	v.lastsc:=csc(),mainfile:=ssn(current(1),"@file").text
	newwin:=new windowtracker(19)
	newwin.Add(["ListView,w100 h400 AltSubmit gdisplayvault Section,Code,h","Button,xm gaddcode,Add Code,y","Button,x+10 ginsertcode Default,Insert Into Segment,y","Button,x+10 gcreatenewsegment,Create New Segment,y","Button,x+10 gremovevaultentry,Remove Selected Entries,y"])
	v.codevault:=new s(19,{pos:"xs+110 ys w600 h400"}),csc({hwnd:v.codevault.sc})
	newwin.resize.Insert({control:v.codevault.sc,pos:"wh"})
	sc:=csc(),sc.2171(1),bracesetup(19),hotkeys([19],{esc:"19GuiClose"})
	newwin.Show("Code Vault")
	pupulatevault:
	locker:=vault.sn("//code"),LV_Delete()
	while,ll:=locker.item[A_Index-1]
		LV_Add("",ssn(ll,"@name").text)
	LV_Modify(1,"Vis Focus Select")
	Gui,Show,,Code Vault
	WinWaitActive,% hwnd([19])
	ControlFocus,SysTreeView321,% hwnd([19])
	return
	createnewsegment:
	SplitPath,mainfile,,cdir
	file:=InputBox(csc().sc,"New Segment","Enter a name for this new file","")
	if ErrorLevel
		return
	file:=!InStr(file,".ahk")?file ".ahk":file
	if FileExist(cdir "\" file)
		return m("File already exists")
	text:=csc().gettext(),csc({hwnd:v.lastsc.sc}),new_segment(cdir "\" file,text),hwnd({rem:19})
	return
	insertcode:
	text:=csc().gettext(),sc:=v.lastsc,sc.2003(sc.2008,text),fix_indent(sc),hwnd({rem:19}),csc({hwnd:v.lastsc.sc}),update({sc:sc.2357})
	return
	19GuiClose:
	19GuiEscape:
	hwnd({rem:19}),vault.save(1),csc({hwnd:v.lastsc.sc})
	return
	addcode:
	newcode:=InputBox(csc().sc,"Name for code snippet","Please enter a name for a new code snippet.","") 
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