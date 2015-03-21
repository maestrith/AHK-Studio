fix_indent(sc=""){
	return newindent()
	skip:=1
	move_selected:
	return
	auto_delete:
	if !sc.sc
		sc:=csc
	cpos:=sc.2008,begin:=cpos-sc.2128(sc.2166(cpos))
	fix_paste:
	settimer,%A_ThisLabel%,Off
	if(v.options.full_auto)
		newindent()
	return
	fullauto:
	settimer,%A_ThisLabel%,Off
	return
	Critical
	next:=0,cpos:=0,indent:=0,add:=0
	lock:=[],track:=[]
	if !WinExist("ahk_id" sc.sc)
		sc:=csc()
	filename:=files.ssn("//*[@sc='" sc.2357 "']/@filename").text
	SplitPath,filename,,,ext
	if(ext="xml")
		return
	if (ext!="ahk"&&v.scratch.sc!=sc.sc&&skip!=1&&v.options.Disable_auto_indent_for_non_ahk_files!=1)
		return
	skip:=""
}
newindent(indentwidth:=""){
	sc:=csc(),codetext:=sc.getuni()
	firstvis:=sc.2152,line:=sc.2166(sc.2008),linestart:=sc.2128(line),posinline:=sc.2008-linestart
	selpos:=posinfo(),startline:=sc.2166(selpos.start),endline:=sc.2166(selpos.end-1)
	add:=[],braces:=0,code:=StrSplit(codetext,"`n"),state:=[],aa:=ab:=0
	for a,b in code{
		state[a-1]:=sc.2533(a-1)
		text:=b
		if (InStr(text,Chr(59)))
			text:=RegExReplace(text,"(\s" Chr(59) ".*)")
		text:=Trim(text,"`t")
		if (SubStr(text,1,1)="("&&SubStr(text,0,1)!=")")
			skip:=1
		if (SubStr(text,1,1)=")"&&skip){
			skip:=0,new.=b "`n"
			continue
		}
		if (skip){
			new.=b "`n"
			continue
		}
		if RegExMatch(text,"iA)}?\b(" v.indentregex ")\b",found)
			aa:=1
		else
			aa:=0
		if(SubStr(text,1,1)="}"||SubStr(text,1,2)="*/"){
			if(aa)
				ab:=1
			braces--
		}
		if lastind
			add:=[]
		if(text="{")
			add:=[]
		if !(indentwidth){
			if add.MaxIndex()
				Loop,% add.MaxIndex()
					new.="`t"
			Loop,%braces%
				new.="`t"
			new.=Trim(b)
		}else{
			max:=add.MaxIndex()?add.MaxIndex():0,indent:=(braces+max)*indentwidth
			if(indent!=sc.2127(a-1))
				sc.2126(a-1,indent)
		}
		if(aa||ab)
			add.Insert({line:a}),ab:=0
		else
			add:=[]
		if(SubStr(text,0,1)="{"||SubStr(text,1,2)="/*")
			braces++,lastind:=1
		else
			lastind:=0
		if(a!=code.MaxIndex())
			new.="`n"
	}
	if(indentwidth)
		return
	if braces
		ToolTip,Segment Open,0,0
	else
		t()
	if(codetext=new)
		return
	GuiControl,-Redraw,% sc.sc
	length:=VarSetCapacity(text,strput(new,"utf-8")),StrPut(new,&text,length,"utf-8"),sc.2181(0,&text),sc.2613(firstvis)
	if(selpos.start=selpos.end){
		newpos:=sc.2128(line)+posinline
		newpos:=newpos>sc.2128(line)?newpos:sc.2128(line)
		sc.2160(newpos,newpos)
	}else{
		sc.2160(sc.2167(startline),sc.2136(endline))
	}
	for a,b in state
		sc.2532(a,b)
	GuiControl,+Redraw,% sc.sc
}