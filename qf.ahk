qf(){
	static quickfind:=[],find,lastfind,minmax
	qf:
	sc:=csc()
	if(sc.2570=1)
		begin:=sc.2008
	ControlGetText,find,Edit1,% hwnd([1])
	if (find=lastfind&&sc.2570>1){
		if (GetKeyState("Shift","P"))
			return previous_found()
		return sc.2606,sc.2169()
	}
	pre:="O",find1:="",find1:=v.options.regex?find:"\Q" RegExReplace(find, "\\E", "\E\\E\Q") "\E",pre.=v.options.greed?"":"U",pre.=v.options.case_sensitive?"":"i",pre.=v.options.multi_line?"m`n":"",find1:=pre ")" find1 ""
	if (find=""||find="."||find=".*"||find="\")
		return sc.2571
	text:=sc.getuni()
	if sc.2508(0,start:=quickfind[sc.2357]+1)!=""{
		end:=sc.2509(0,start)
		if end
			text:=SubStr(text,1,end)
	}
	pos:=start?start:1
	pos:=pos=0?1:pos
	mainsel:=""
	if !IsObject(minmax)
		minmax:=[],minmax.1:={min:0,max:sc.2006},delete:=1
	if IsObject(minmax){
		start:=StrPut(SubStr(text,1,b.min),"utf-8")-2,index:=1
		for a,b in MinMax{
			search:=sc.textrange(b.min,b.max,1),pos:=1
			while,RegExMatch(search,find1,found,pos){
				if found.Count(){
					Loop,% found.Count(){
						if !found.len(A_Index)
							Break,2
						ns:=StrPut(SubStr(search,1,found.Pos(A_Index)),"utf-8")-1,sc[Index=1?2160:2573](start+ns,start+ns+StrPut(found[A_Index])-1),pos:=found.Pos(A_Index)+found.len(A_Index),index++
					}
				}else{
					if(found.len=0)
						Break
					ns:=StrPut(SubStr(search,1,found.Pos(0)),"utf-8")-1,sc[Index=1?2160:2573](start+ns,start+ns+StrPut(found[0])-1),pos:=found.Pos(0)+found.len(0),index++
				}
			}
		}
	}
	if delete
		minmax:="",delete:=0
	if mainsel>=0
		sc.2574(mainsel)
	sc.2169(),lastfind:=find
	return
	next:
	sc:=csc(),sc.2606(),sc.2169()
	return
	clear_selection:
	sc:=csc(),sc.2500(2),sc.2505(0,sc.2006)
	quickfind.remove(sc.2357)
	minmax:=""
	return
	set_selection:
	sc:=csc()
	if (sc.2008=sc.2009)
		goto,clear_selection
	sc.2505(0,sc.2006),sc.2500(2)
	if !IsObject(MinMax),pos:=posinfo()
		minmax:=[]
	Loop,% sc.2570
	{
		caret:=sc.2577(A_Index-1),anchor:=sc.2579(A_Index-1)
		if (caret>anchor)
			min:=anchor,max:=caret
		Else
			min:=caret,max:=anchor
		minmax.Insert({min:min,max:max})
	}
	for a,b in minmax
		sc.2504(b.min,b.max-b.min)
	return
	quick_find:
	if v.options.Auto_Set_Area_On_Quick_Find
		gosub,set_selection
	ControlFocus,Edit1,% hwnd([1])
	Sleep,200
	ControlSend,Edit1,^A,% hwnd([1])
	return
	Case_Sensitive:
	Regex:
	Multi_Line:
	Greed:
	onoff:=settings.ssn("//Quick_Find_Settings/@ " A_ThisLabel).text?0:1
	att:=[],att[A_ThisLabel]:=onoff,settings.add({path:"Quick_Find_Settings",att:att}),togglemenu(A_ThisLabel),v.options[A_ThisLabel]:=onoff,lastfind:=""
	goto,qf
	return
	checkqf:
	ControlGetFocus,Focus,% hwnd([1])
	if(Focus="Edit1")
		goto,qf
	else if(A_ThisHotkey="+Enter"||A_ThisHotkey="enter")
		replace()
	else
		marginwidth()
	if(v.options.full_auto){
		GuiControl,1:-Redraw,% sc.sc
		SetTimer,full,-10
	}
	return
	full:
	sc:=csc()
	GuiControl,1:-Redraw,% sc.sc
	SetTimer,gofull,-1
	return
	gofull:
	fix_indent()
	GuiControl,1:+Redraw,% sc.sc
	return
}