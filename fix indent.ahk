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
	Critical
	sc:=csc(),codetext:=sc.getuni(),indentation:=sc.2121
	GuiControl,1:-Redraw,% sc.sc
	GuiControl,1:+g,% sc.sc
	firstvis:=sc.2152,line:=sc.2166(sc.2008),linestart:=sc.2128(line),posinline:=sc.2008-linestart
	selpos:=posinfo(),sc.2078
	add:=[],braces:=0,code:=StrSplit(codetext,"`n"),state:=[],aa:=ab:=0
	for a,b in code{
		text:=b
		if (InStr(text,Chr(59)))
			text:=RegExReplace(text,"(\s" Chr(59) ".*)")
		text:=Trim(text,"`t "),first:=SubStr(text,1,1)
		if (first="("&&SubStr(text,0,1)!=")")
			skip:=1
		if (first=")"&&skip){
			skip:=0
			continue
		}
		if (skip)
			continue
		for c,d in ["&&","OR","AND",".",",","||"]{
			if(SubStr(text,1,StrLen(d))=d){
				ss:=1
				break
			}
		}
		if(ss){
			ss:=0
			if(v.options.Manual_Continuation_Line)
				Continue
			if specialind
				sc.2126(a-1,specialind)
			specialind:=sc.2127(a-1)
			Continue
		}
		specialind:=0
		if RegExMatch(text,"iA)}?\s*\b(" v.indentregex ")\b",found)
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
			if add.MaxIndex(){
				if(sc.2127(a-1)!=(braces+add.MaxIndex())*indentation)
					sc.2126(a-1,(braces+add.MaxIndex())*indentation)
			}else{
				if(sc.2127(a-1)!=braces*indentation)
					sc.2126(a-1,braces*indentation)
			}
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
	}
	sc.2079
	GuiControl,1:+gnotify,% sc.sc
	if(indentwidth)
		return
	if braces
		ToolTip,Segment Open,0,0
	else
		t()
	if(codetext=new){
		GuiControl,1:+Redraw,% sc.sc
		return
	}
	if(selpos.start=selpos.end){
		newpos:=sc.2128(line)+posinline
		newpos:=newpos>sc.2128(line)?newpos:sc.2128(line)
		sc.2160(newpos,newpos)
	}else
		sc.2160(sc.2167(startline),sc.2136(endline))
	GuiControl,1:+Redraw,% sc.sc
}