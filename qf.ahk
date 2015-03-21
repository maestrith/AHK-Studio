qf(){
	static quickfind:=[],find,lastfind,minmax
	qf:
	sc:=csc()
	if (sc.2570=1)
		begin:=sc.2008
	ControlGetText,find,Edit1,% hwnd([1])
	if (find=lastfind&&sc.2570>1){
		if (GetKeyState("Shift","P"))
			return previous_found()
		return sc.2606,sc.2169()
	}
	pre:="O",find1:=""
	find1:=v.options.regex?find:"\Q" RegExReplace(find, "\\E", "\E\\E\Q") "\E"
	pre.=v.options.greed?"":"U",pre.=v.options.case_sensitive?"":"i",pre.=v.options.multi_line?"m`n":""
	find1:=pre ")" find1 ""
	if (find=""||find="."||find=".*"||find="\"){
		sc.2571
		return
	}
	text:=sc.getuni()
	if sc.2508(0,start:=quickfind[sc.2357]+1)!=""{
		end:=sc.2509(0,start)
		if end
			text:=SubStr(text,1,end)
	}
	pos:=start?start:1
	pos:=pos=0?1:pos
	mainsel:=""
	if InStr(text,find)
		sc.2571
	if IsObject(minmax){
		index:=1
		for a,b in MinMax{
			start:=b.min,search:=sc.textrange(b.min,b.max,1),pos:=1
			while,pos:=RegExMatch(search,find1,found,pos){
				np:=StrPut(SubStr(search,1,found.Pos(0)),"utf-8")-1-(StrPut(SubStr(found.0,1,1),"utf-8")-1)
				if (index=1){
					sc.2160(start+np,start+np+StrPut(found.0,"utf-8")-1),index++,sc.2232(sc.2166(sc.2008(start+np)))
					Sleep,1
				}else{
					sc.2573(start+np+StrPut(found.0,"utf-8")-1,start+np),sc.2232(sc.2166(sc.2008(start+np+StrPut(found.0,"utf-8")-1)))
					Sleep,1
				}
				if !found.len()
					break
				pos+=found.len()
			}
		}
	}
	Else
		while,pos:=RegExMatch(text,find1,found,pos){
		np:=StrPut(SubStr(text,1,found.Pos(0)),"utf-8")-1-(StrPut(SubStr(found.0,1,1),"utf-8")-1)
		if (begin<np&&!mainsel)
			mainsel:=sc.2570=1?0:sc.2570
		if (A_Index=1){
			sc.2160(np,np+StrPut(found.0,"utf-8")-1),sc.2232(sc.2166(sc.2008(np)))
			Sleep,1
		}Else{
			sc.2573(np+StrPut(found.0,"utf-8")-1,np),sc.2232(sc.2166(sc.2008(np+StrPut(found.0,"utf-8")-1)))
			Sleep,1
		}
		pos+=found.len()
	}
	if mainsel>=0
		sc.2574(mainsel)
	sc.2169(),lastfind:=find
	return
	next:
	sc:=csc()
	sc.2606
	sc.2169
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
	if (Focus="Edit1")
		goto,qf
	else if(A_ThisHotkey="+Enter")
		replace()
	else
		marginwidth()
	if (v.options.full_auto)
		SetTimer,full,-20
	return
	full:
	fix_indent()
	return
}