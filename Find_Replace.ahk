Find_Replace(){
	static
	infopos:=positions.ssn("//*[@file='" current(3).file "']"),last:=ssn(infopos,"@findreplace").text,ea:=settings.ea("//findreplace"),newwin:=new windowtracker(30),value:=[]
	for a,b in ea
		value[a]:=b?"Checked":""
	newwin.Add(["Text,,Find","Edit,w200 vfind","Text,,Replace","Edit,w200 vreplace","Checkbox,vregex " value.regex ",Regex","Checkbox,vcs " value.cs ",Case Sensitive","Checkbox,vgreed " value.greed ",Greed","Checkbox,vml " value.ml ",Multi-Line","Button,gfrfind Default,&Find","Button,x+5 gfrreplace,&Replace","Button,x+5 gfrall,Replace &All","Checkbox,xm vsegment " value.segment ",Current Segment Only","Checkbox,xm vcurrentsel hwndcs gcurrentsel " value.currentsel ",In Current Selection"]),newwin.Show("Find & Replace")
	Gui,30:Show,AutoSize
	sc:=csc(),order:=[],order[sc.2585(0)]:=1,order[sc.2587(0)]:=1,last:=(order.MinIndex()!=order.MaxIndex())?sc.textrange(order.MinIndex(),order.MaxIndex()):last
	hotkeys([30],{"!e":"frregex"})
	if(!value.currentsel)
		ControlSetText,Edit1,%last%,% hwnd([30])
	else
		gosub,checksel
	ControlSend,Edit1,^a,% hwnd([30])
	Gui,1:-Disabled
	return
	checksel:
	sc:=csc()
	if(sc.2008=sc.2009)
		GuiControl,30:,In Current Selection,0
	else
		gosub,currentsel
	return
	frregex:
	Send,{!e,up}
	ControlGet,check,Checked,,Button1,% hwnd([30])
	check:=!check
	GuiControl,30:,Button1,%check%
	return
	30GuiClose:
	30GuiEscape:
	info:=newwin[],fr:=settings.Add({path:"findreplace"})
	for a,b in {regex:info.regex,cs:info.cs,greed:info.greed,ml:info.ml,segment:info.segment,currentsel:info.currentsel}
		fr.SetAttribute(a,b)
	fr:=positions.ssn("//*[@file='" current(3).file "']"),fr.SetAttribute("findreplace",info.find)
	hwnd({rem:30})
	if(start!=""&&end!="")
		sc.2160(start,end),start:=end:="",sc.2500(2),sc.2505(0,sc.2006)
	return
	currentsel:
	ControlGet,check,Checked,,In Current Selection,% hwnd([30])
	sc:=csc(),sc.2500(2),sc.2505(0,sc.2006)
	if(!check){
		if(start!=""&&end!="")
			sc.2500(2),sc.2505(0,sc.2006),sc.2160(start,end)
		return
	}
	start:=sc.2008>sc.2009?sc.2009:sc.2008
	end:=sc.2008<sc.2009?sc.2009:sc.2008
	sc.2504(start,end-start),sc.2025(start)
	if(start=end){
		GuiControl,30:,In Current Selection,0
		return m("Select Some Text First")
	}
	return
	frfind:
	info:=newwin[]
	startsearch:=0,sc:=csc(),stop:=current(3).file,looped:=0,current:=current(1),pos:=sc.2008,pre:="O",find:="",find:=info.regex?info.find:"\Q" RegExReplace(info.find, "\\E", "\E\\E\Q") "\E",pre.=info.greed?"":"U",pre.=info.cs?"":"i",pre.=info.ml?"":"m`n",find:=pre ")" find ""
	if(info.currentsel){
		end:=sc.2509(2,start)
		text:=SubStr(sc.getuni(),start+1,end-start+1)
		greater:=sc.2008>sc.2009?sc.2008:sc.2009
		pos:=greater>start?greater-start:1
		if(RegExMatch(text,find,found,pos)){
			fp:=found.Pos(1)!=""?found.Pos(1):found.Pos(0),fl:=found.len(1)!=""?found.len(1):found.len(0)
			sc.2160(start+fp-1,start+fp-1+fl)
		}else{
			pos:=1
			if(RegExMatch(text,find,found,pos)){
				fp:=found.Pos(1)!=""?found.Pos(1):found.Pos(0),fl:=found.len(1)!=""?found.len(1):found.len(0)
				sc.2160(start+fp-1,start+fp-1+fl)
			}
		}
		return
	}
	frrestart:
	if !info.find
		return m("Enter search text")
	list:=info.segment?sn(current(1),"descendant::file[@file='" current(3).file "']"):sn(current(1),"descendant::file")
	while,current:=list.Item[A_Index-1],ea:=xml.ea(current){
		if(ea.file!=stop&&startsearch=0)
			continue
		startsearch:=1
		text:=update({get:ea.file})
		if pos:=RegExMatch(text,find,found,pos){
			tv(files.ssn("//file[@file='" ea.file "']/@tv").text)
			Sleep,200
			np:=StrPut(SubStr(text,1,pos-1),"utf-8")-1,sc.2160(np,np+StrPut(found.0,"utf-8")-1)
			return
		}
		if(ea.file=stop&&looped=1)
			return m("No Matches Found")
		pos:=1
	}
	current:=current(1).firstchild,looped:=1
	goto,frrestart
	return
	frreplace:
	info:=newwin[],text:=sc.getseltext(),replace:=info.replace
	for a,b in {"``n":"`n","``r":"`n","``t":"`t","\r":"`n","\t":"`t","\n":"`n"}
		StringReplace,replace,replace,%a%,%b%,All
	csc().2170(0,[RegExReplace(text,info.find,replace)])
	goto,frfind
	return
	frall:
	info:=newwin[],sc:=csc(),stop:=current(3).file,looped:=0,current:=current(),pos:=sc.2008,pre:="O",find:="",find:=info.regex?info.find:"\Q" RegExReplace(info.find, "\\E", "\E\\E\Q") "\E",pre.=info.greed?"":"U",pre.=info.cs?"":"i",pre.=info.ml?"":"m`n",find:=pre ")" find ""
	if(info.currentsel)
		return pos:=1,end:=sc.2509(2,start),text:=SubStr(sc.getuni(),start+1,end-start),text:=RegExReplace(text,find,info.replace),sc.2190(start),sc.2192(end),sc.2194(StrPut(text,"utf-8")-1,[text]),sc.2500(2),sc.2505(0,sc.2006),sc.2504(start,len:=StrPut(text,"utf-8")-1),end:=start+len
	if info.segment
		goto,frseg
	list:=sn(current(1),"descendant::file"),All:=update("get").1
	info:=newwin[],replace:=info.replace
	for a,b in {"``n":"`n","``r":"`n","``t":"`t","\r":"`n","\t":"`t","\n":"`n"}
		StringReplace,replace,replace,%a%,%b%,All
	while,ll:=list.Item[A_Index-1]{
		text:=All[ssn(ll,"@file").text]
		if(RegExMatch(text,find,found)){
			rep:=RegExReplace(text,find,replace),ea:=xml.ea(ll)
			if(ea.sc){
				tv(ea.tv)
				Sleep,300
				sc.2181(0,[rep])
			}else
				update({file:ea.file,text:rep})
		}
	}
	return
	frseg:
	getpos(),info:=newwin[],sc:=csc(),pre:="O",find:="",find:=info.regex?info.find:"\Q" RegExReplace(info.find, "\\E", "\E\\E\Q") "\E",pre.=info.greed?"":"U",pre.=info.cs?"":"i",pre.=info.ml?"":"m`n",find:=pre ")" find ""
	replace:=info.replace
	for a,b in {"``n":"`n","``r":"`n","``t":"`t","\r":"`n","\t":"`t","\n":"`n"}
		StringReplace,replace,replace,%a%,%b%,All
	sc.2181(0,[RegExReplace(sc.gettext(),find,replace)]),setpos(ssn(current(),"@tv").text)
	return
}