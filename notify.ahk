notify(csc=""){
	notify:
	static last,lastline
	fn:=[],info:=A_EventInfo
	if (info=512){
		ControlGetFocus,con,% hwnd([A_Gui])
		ControlGet,hwnd,hwnd,,%con%,% hwnd([A_Gui])
		sc:=csc({hwnd:hwnd}),filename:=files.ssn("//*[@sc='" sc.2357 "']/@file").text
		if filename
			WinSetTitle,% hwnd([1]),,AHK Studio - %filename%
		return
	}
	;{15:"foldLevelPrev",16:"margin",17:"listType",18:"x",19:"y",21:"token",22:"annotLinesAdded",23:"updated"}
	for a,b in {0:"Obj",2:"Code",3:"position",4:"ch",5:"mod",6:"modType",7:"text",8:"length",9:"linesadded",10:"msg",11:"wparam",12:"lparam",13:"line",14:"fold",17:"listType",22:"updated"}
		fn[b]:=NumGet(Info+(A_PtrSize*a))
	if (fn.code=""||fn.code=2013||Info=256)
		return
	sc:=csc?csc:csc(),csc:=""
	if (fn.code=2002){
		Gui,1:TreeView,% hwnd("fe")
		list:=files.sn("//*[@file='" current(3).file "']")
		while,ll:=list.item[A_Index-1],ea:=xml.ea(ll)
			TV_Modify(ea.tv,"",ea.filename)
	}
	if (fn.code=2014){
		if (fn.listtype=1){
			if !IsObject(scintilla)
				scintilla:=new xml("scintilla","lib\scintilla.xml")
			command:=StrGet(fn.text,"utf-8")
			info:=scintilla.ssn("//commands/item[@name='" command "']")
			ea:=xml.ea(info),start:=sc.2266(sc.2008,1),end:=sc.2267(sc.2008,1)
			syn:=ea.syntax?ea.code "()":ea.code,sc.2160(start,end),sc.2170(0,[syn])
			if ea.syntax
				sc.2025(sc.2008-1),sc.2200(start,ea.code ea.syntax)
		}Else if(fn.listType=2){
			vv:=StrGet(fn.text,"utf-8")
			start:=sc.2266(sc.2008,1),end:=sc.2267(sc.2008,1)
			sc.2645(start,end-start)
			sc.2003(sc.2008,vault.ssn("//*[@name='" vv "']").text)
			if v.options.full_auto
				SetTimer,fullauto,-1
		}else if(fn.listType=3){
			args:=ssn(cexml.ssn("//main[@file='" current(2).file "']/descendant::*[@type='Method' or @type='Property'][@upper='" upper(text:=StrGet(fn.text,"utf-8")) "']"),"@args").text
			start:=sc.2266(sc.2008,1),end:=sc.2267(sc.2008,1)
			text.="()",sc.2645(start,end-start),sc.2003(sc.2008,text),sc.2025(sc.2008+StrLen(text)-1)
		}
	}
	;if (fn.code=2027)
	;switch this out with 2027 and use GetKeyState("Control","P") and stuff
	if (fn.code=2019){
		v.style:={style:sc.2010(fn.position),mod:fn.mod}
		if fn.mod=0
			SetTimer,styleclick,1
		if fn.mod=2
			SetTimer,editfont,1
		if fn.mod=4
			SetTimer,editback,1
	}
	if (fn.code=2008){
		if ((fn.modtype&0x01)||(fn.modtype&0x02))
			update({sc:sc.2357})
		if (fn.modtype&0x02){
			update({sc:sc.2357})
		}
		if fn.linesadded
			marginwidth(sc)
		if (sc.sc=v.codevault.sc){
			LV_GetText(code,LV_GetNext())
			if !locker:=vault.ssn("//code[@name='" code "']")
				locker:=vault.Add({path:"code",att:{name:code},dup:1})
			locker.text:=sc.gettext()
		}
	}
	if (fn.code=2004&&sc.sc=v.codevault.sc)
		m("Please create or select a code snippet")
	if (fn.code=2001){
		if(fn.ch=46){
			object:=sc.textrange(sc.2266(sc.2008-1,1),sc.2267(sc.2008-1,1))
			ea:=xml.ea(cexml.ssn("//main[@file='" current(2).file "']/descendant::*[@type='Object' and @upper='" upper(object) "']"))
			if ea.class{
				disp:=cexml.ssn("//main[@file='" current(2).file "']/descendant::*[@type='Class' and @upper='" upper(ea.class) "']")
				show:=sn(disp,"*[@type='Method' or @type='Property']"),list:=""
				while,ss:=show.item[A_Index-1],ea:=xml.ea(ss)
					list.=ea.text " "
				sc.2117(3,Trim(list))
			}
		}
		if ((fn.ch=10||fn.ch=123||fn.ch=125)&&v.options.full_auto&&sc.2102=0){
			if fn.ch=10
				SetTimer,FullAuto,50
			else
				SetTimer,auto_delete,250
		}else if (fn.ch=10&&v.options.fix_next_line)
			SetTimer,fix_next,50
		cpos:=sc.2008,start:=sc.2266(cpos,1),end:=sc.2267(cpos,1),word:=sc.textrange(sc.2266(cpos,1),cpos)
		if (StrLen(word)>1&&sc.2102=0){
			list:=Trim(v.keywords[SubStr(word,1,1)]) code_explorer.varlist[current(2).file]
			if list&&instr(list,word)
				sc.2100(StrLen(word),list)
		}
		style:=sc.2010(sc.2008-2)
		settimer,context,150
		c:=fn.ch
		if c in 44,32
			replace()
	}
	if (fn.code=2010){
		margin:=NumGet(info+64)
		if margin=0
			return theme({margin:margin,mod:fn.mod})
		scpos:=NumGet(info+12)
		modifier:=NumGet(info+20)
		if margin=3
			sc.2231(sc.2166(scpos))
		if (Margin=1){
			line:=sc.2166(scpos)
			if(GetKeyState("Shift","P")){
				text:=Trim(sc.getline(line))
				if RegExMatch(text,Chr(59) "#\[.*\]")
					Delete_Bookmark(line)
				else
					Add_Bookmark(line)
			}else{
				if (sc.2046(line)&1){
					sc.2044(line,0)
				}else
					sc.2043(line,0)
			}
			getpos()
		}
	}
	if (fn.code=2022){
		if v.options.Autocomplete_Enter_Newline
			SetTimer,sendenter,100
		Else{
			v.word:=StrGet(fn.text,"utf-8")
			if(v.word="#Include"&&v.options.Disable_Include_Dialog!=1)
				SetTimer,getinclude,-200
			else if(v.word~="i)(goto|gosub)")
				SetTimer,goto,-100
			else
				SetTimer,automenu,100
		}
	}
	if (fn.code=2001)
		uppos(),width:=sc.2276(32,"aaa"),text1:="Last Entered Character: " Chr(fn.ch) " Code:" fn.ch,last:=width*StrLen(text1 1),SB_SetParts(v.lastwidth,last,40),SB_SetText(text1,2)
	if (fn.code=2007)
		uppos()
	if(fn.code=2021)
		t(fn.position) ;this is for the multiple calltips 1=up 2=down
	return
	Full_Auto:
	Fix_Next_Line:
	onoff:=settings.ssn("//Auto_Indent/@ " A_ThisLabel).text?0:1
	att:=[],att[A_ThisLabel]:=onoff
	settings.add({path:"Auto_Indent",att:att})
	togglemenu(A_ThisLabel)
	v.options[A_ThisLabel]:=onoff
	return
	sendenter:
	SetTimer,sendenter,Off
	Send,{Enter}
	if v.options.full_auto
		SetTimer,fullauto,10
	return
}