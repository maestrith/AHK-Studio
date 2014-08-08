find(){
	static
	file:=ssn(current(1),"@file").text
	infopos:=positions.ssn("//*[@file='" file "']")
	last:=ssn(infopos,"@search").text
	hwfind:=setup(5)
	search:=last?last:"Type in your query here"
	ea:=settings.ea(settings.ssn("//search/find"))
	for a,b in ["Edit,gfindcheck w500 vfind r1," search ,"TreeView,w500 h300 AltSubmit gstate","Checkbox,vregex,Regex Search","Checkbox,vgr x+10,Greed","Checkbox,xm vcs,Case Sensitive","Checkbox,vsort gfsort,Sort by Segment","Checkbox,vallfiles,Search in All Files"]{
		StringSplit,b,b,`,
		Gui,5:Add,%b1%,%b2%,%b3%
		b2:=b3:=""
	}
	Gui,5:Add,Button,gsearch Default,% " Search "
	Gui,5:Add,Button,gcomment,Toggle Comment
	Gui,5:Show,% Center(5)
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
		ff:="",ff.=gr?"":"U"
		ff.=cs?"O)":"Oi)",refreshing:=1,foundinfo:=[]
		main:=regex=0?"(.*)(\Q" find "\E)(.*)":"(" find ")"
		f:=gr&&regex?ff "(" find ")":ff main
		infopos.setattribute("search",find)
		Gui,5:Default
		GuiControl,5:-Redraw,SysTreeView321
		if allfiles
			list:=files.sn("//@file")
		else
			list:=sn(current(1),"*/@file")
		contents:=update("get").1,TV_Delete()
		while,l:=list.item(A_Index-1){
			out:=contents[l.text],found=1,r=0,fn:=l.text
			SplitPath,fn,file
			if !regex{
				while,found:=RegExMatch(out,"`n" ff main,fo,found){
					r:=sort&&A_Index=1?TV_Add(l.text):r
					parent:=TV_Add(fo.value(),r)
					foundinfo[parent]:={pos:fo.pos(2)-1,file:l.text,found:fo.len(2)}
					found:=fo.pos(3)+StrLen(fo.value())
				}
			}
			else
			{
				while,found:=RegExMatch(out,"`nOi)(.*" find ".*)",pof,found){
					fff:=1,r:=sort&&A_Index=1?TV_Add(l.text):r
					while,fff:=RegExMatch(pof.value(),ff main,fo,fff){
						parent:=TV_Add(fo.value(1) " : " pof.value(),r)
						foundinfo[parent]:={pos:found+fo.pos(1)-2,file:l.text,found:fo.len(1),parent:ssn(l.ParentNode.ParentNode,"@file").text}
						fff:=fo.pos(1)+fo.len(1)
					}
					found+=pof.len(0)
				}
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
		sc.2160(ea.pos,ea.pos+ea.found)
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
	settings.add({path:"search/find",att:{regex:regex,cs:cs,sort:sort,gr:gr}}),foundinfo:=""
	hwnd({rem:5})
	return
	comment:
	sc:=csc()
	toggle_comment_line()
	return
}