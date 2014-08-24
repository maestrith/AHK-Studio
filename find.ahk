find(){
	static
	file:=ssn(current(1),"@file").text,infopos:=positions.ssn("//*[@file='" file "']")
	last:=ssn(infopos,"@search").text,hwfind:=setup(5),search:=last?last:"Type in your query here"
	ea:=settings.ea(settings.ssn("//search/find"))
	for a,b in ["Edit,gfindcheck w500 vfind r1," debug.decode(search) ,"TreeView,w500 h300 AltSubmit gstate","Checkbox,vregex,Regex Search","Checkbox,vgr x+10,Greed","Checkbox,xm vcs,Case Sensitive","Checkbox,vsort gfsort,Sort by Segment","Checkbox,vallfiles,Search in All Files"]{
		StringSplit,b,b,`,
		Gui,5:Add,%b1%,%b2%,%b3%
		b2:=b3:=""
	}
	Gui,5:Add,Button,gsearch Default,% " Search "
	Gui,5:Add,Button,gcomment,Toggle Comment
	Gui,5:Show,% Center(5),Find
	for a,b in ea
		if b
			GuiControl,,%a%,%b%
	for a,b in xml.easyatt(settings.ssn("//search/find"))
		GuiControl,5:,%a%,%b%
	ControlSend,Edit1,^a,% hwnd([5])
	return
	findcheck:
	ControlGetText,Button,Button6,% hwnd([5])
	if (Button!="search")
		ControlSetText,Button6,Search,% hwnd([5])
	return
	search:
	ControlGetText,Button,Button6,% hwnd([5])
	if (InStr(button,"search")){
		Gui,5:Submit,Nohide
		if !find
			return
		infopos.setattribute("search",debug.encode(find)),foundinfo:=[]
		Gui,5:Default
		GuiControl,5:-Redraw,SysTreeView321
		list:=allfiles?files.sn("//file/@file"):sn(current(1),"*/@file")
		contents:=update("get").1,TV_Delete()
		pre:="m`nO",pre.=cs?"":"i",pre.=greed?"":"U",parent:=0
		while,l:=list.item(A_Index-1){
			out:=contents[l.text],found:=1,r:=0,fn:=l.text
			SplitPath,fn,file
			ff:=regex?find:"\Q" find "\E"
			while,found:=RegExMatch(out,pre ")(^.*" ff ".*\n)",pof,found){
				if (sort&&lastl!=fn)
					parent:=TV_Add(fn)
				np:=found=1?0:StrPut(SubStr(out,1,found),"utf-8")-1-(StrPut(SubStr(pof.1,1,1),"utf-8")-1)
				fpos:=1
				while,fpos:=RegExMatch(pof.1,pre ")[^.*]?(" ff ")",loof,fpos){
					add:=loof.Pos(1)-1
					foundinfo[TV_Add(loof.1 " : " Trim(pof.1,"`t"),parent)]:={start:np+add,end:np+add+StrPut(loof.1,"Utf-8")-1,file:l.text}
					fpos+=StrLen(loof.1)
				}
				found:=found+add
				lastl:=fn
			}
		}
		if TV_GetCount()
			ControlFocus,SysTreeView321
		GuiControl,5:+Redraw,SysTreeView321
		ControlSetText,Button6,Jump,% hwnd([5])
		refreshing:=0
	}
	else if (Button="jump"){
		Gui,5:Submit,Nohide
		ea:=foundinfo[TV_GetSelection()]
		sc:=csc()
		tv(files.ssn("//*[@file='" ea.file "']/@tv").text)
		Sleep,100
		sc.2160(ea.start,ea.end)
		sc.2169
	}
	else
		sel:=TV_GetSelection(),TV_Modify(sel,ec:=TV_Get(sel,"E")?"-Expand":"Expand")
	state:
	sel:=TV_GetSelection()
	Gui,5:TreeView,SysTreeView321
	if refreshing
		return
	ControlGetFocus,focus,% hwnd([5])
	if !InStr(Focus,"SysTreeView321"){
		ControlSetText,Button6,Search,% hwnd([5])
		return
	}
	if TV_GetChild(sel)
		ControlSetText,Button6,% TV_Get(sel,"E")?"Contract":"Expand",% hwnd([5])
	else if TV_GetCount()
		ControlSetText,Button6,Jump,% hwnd([5])
	else
		ControlSetText,Button6,Search,% hwnd([5])
	return
	sel:=TV_GetSelection()
	if TV_GetChild(sel)
		ControlSetText,Button6,% TV_Get(sel,"E")?"Contract":"Expand",% hwnd([5])
	else
		ControlSetText,Button6,Jump,% hwnd([5])
	return
	fsort:
	ControlSetText,Button6,Search,% hwnd([5])
	goto search
	return
	5GuiEscape:
	5GuiClose:
	Gui,5:Submit,NoHide
	settings.add({path:"search/find",att:{regex:regex,cs:cs,sort:sort,gr:gr,allfiles:allfiles}}),foundinfo:=""
	hwnd({rem:5})
	return
	comment:
	sc:=csc()
	toggle_comment_line()
	return
}