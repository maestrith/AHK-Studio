fix_indent(sc=""){
	return newindent()
	skip:=1
	move_selected:
	return
	/*
		auto_delete:
		if !sc.sc
			sc:=csc
		cpos:=sc.2008,begin:=cpos-sc.2128(sc.2166(cpos))
	*/
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
	sc:=csc(),codetext:=sc.getuni(),indentation:=sc.2121,firstvis:=sc.2152,line:=sc.2166(sc.2008),linestart:=sc.2128(line),posinline:=sc.2008-linestart,selpos:=posinfo(),sc.2078,lock:=[],aa:=ab:=braces:=0,code:=StrSplit(codetext,"`n")
	spind:=[]
	GuiControl,1:-Redraw,% sc.sc
	GuiControl,1:+g,% sc.sc
	for a,text in code{
		if (InStr(text,Chr(59)))
			text:=RegExReplace(text,"\s" Chr(59) ".*")
		text:=Trim(text,"`t "),first:=SubStr(text,1,1),last:=SubStr(text,0,1),lasttwo:=SubStr(text,1,2)
		indentcheck:=RegExMatch(text,"iA)}?\s*\b(" v.indentregex ")\b")
		if(first="("&&last!=")")
			skip:=1
		if(first=")"&&skip){
			skip:=0
			continue
		}
		if(skip)
			continue
		ss:=(text~="i)^\s*(&&|OR|AND|\.|\,|\|\||:|\?)")
		if(ss){
			if(v.options.Manual_Continuation_Line)
				Continue
			if(last="{")
				spind.Insert(sc.2127(a-1))
		}
		if(first="}"||lasttwo="*/"){
			while,((found:=SubStr(text,A_Index,1))~="(}|\s)")
				if(found="}")
					backbrace:=lock.pop(),braces--
			if(lasttwo="*/")
				backbrace:=lock.pop(),braces--
			aa:=0,spid:=spind.pop(),pop:=1
		}
		if(backbrace)
			plus:=backbrace-1,backbrace:=0
		else
			plus:=lock[lock.MaxIndex()],plus:=plus!=""?plus:0
		if(text="{"&&aa)
			aa--
		if(spind.MinIndex()||(pop&&spid>=0)){
			sc.2126(a-1,popp?spid:spind[spind.MaxIndex()]+(ss?0:indentation))
		}else if(sc.2127(a-1)!=(plus+aa)*indentation)
			sc.2126(a-1,(plus+aa)*indentation)
		if(indentcheck&&last="{"&&aa&&text!="{")
			skipcheck:=1
		if(last="{"||lasttwo="/*")
			braces+=1,lock.Insert(plus+aa+1)
		if(indentcheck&&skipcheck!=1){
			if(last!="{")
				aa++
		}else
			aa:=0
		skipcheck:=0,ss:=0,spid:=0,pop:=0
	}
	sc.2079
	GuiControl,1:+gnotify,% sc.sc
	if(indentwidth)
		return
	WinGetTitle,title,% hwnd([1])
	if(braces&&InStr(title,"Segment Open!   -   ")=0)
		WinSetTitle,% hwnd([1]),,% "Segment Open!   -   AHK Studio - " current(3).file
	else if(braces=0&&InStr(title,"Segment Open!   -   "))
		WinSetTitle,% hwnd([1]),,% "AHK Studio - " current(3).file
	if(selpos.start=selpos.end)
		newpos:=sc.2128(line)+posinline,newpos:=newpos>sc.2128(line)?newpos:sc.2128(line),sc.2160(newpos,newpos)
	else
		sc.2160(sc.2167(startline),sc.2136(endline))
	GuiControl,1:+Redraw,% sc.sc
}