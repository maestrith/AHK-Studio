fix_indent(sc=""){
	return newindent()
	skip:=1
	move_selected:
	return
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
	sc:=csc(),codetext:=sc.getuni(),indentation:=sc.2121,line:=sc.2166(sc.2008),posinline:=sc.2008-sc.2128(line),selpos:=posinfo(),sc.2078,lock:=[],iflock:={},aa:=ab:=braces:=0,code:=StrSplit(codetext,"`n"),conind:=[],block:=[]
	GuiControl,1:-Redraw,% sc.sc
	GuiControl,1:+g,% sc.sc
	for a,text in code{
		if (InStr(text,Chr(59)))
			text:=RegExReplace(text,"\s" Chr(59) ".*")
		text:=Trim(text,"`t "),first:=SubStr(text,1,1),last:=SubStr(text,0,1),firsttwo:=SubStr(text,1,2)
		ss:=(text~="i)^\s*(&&|OR|AND|\.|\,|\|\||:|\?)")
		indentcheck:=RegExMatch(text,"iA)}?\s*\b(" v.indentregex ")\b")
		if(first="("&&last!=")")
			skip:=1
		if(first=")"&&skip){
			skip:=0
			continue
		}
		if(skip)
			continue
		if(ss&&aa<=0){
			if(v.options.Manual_Continuation_Line)
				Continue
		}
		if(firsttwo="*/")
			block:=[],blocks:=0
		if(first="}"){
			while,((found:=SubStr(text,A_Index,1))~="(}|\s)"){
				if(found=" ")
					Continue
				if(block.1+1){
					if (block.MaxIndex()>1){
						lastind:=block.pop(),otherbraces--
					}
				}
				else if(iflock.1+1)
					lastind:=iflock.pop()
				else
					lastind:=lock.pop(),braces--
			}
		}
		if(iflock.1+1)
			sc.2126(a-1,(iflock[iflock.MaxIndex()]-(first="{"?1:0))*indentation)
		else if(block.1){
			if(sc.2127(a-1)!=(block[block.MaxIndex()])*indentation)
				sc.2126(a-1,(block[block.MaxIndex()])*indentation)
		}else if(lock.1){
			iii:=lastind>0?lastind-1:(lock[lock.MaxIndex()])
			if(sc.2127(a-1)!=iii*indentation)
				sc.2126(a-1,iii*indentation)
		}else{
			sc.2126(a-1,(lastind?lastind-1:0)*indentation)
		}
		if(last="{"){
			if(block.1+1)
				otherbraces++,block.Insert(otherbraces+blocks)
			else if(iflock[iflock.MaxIndex()]+1){
				lock.Insert(iflock[iflock.MaxIndex()]+(first="{"?0:1)),braces++
				if(a=84)
					t(lock[lock.MaxIndex()],iflock[iflock.MaxIndex()])
				iflock:=[]
			}
			else
				lock.Insert(++braces)
		}
		if(indentcheck){
			if(iflock.1+1=""){
				if block.1+1
					iftemp:=block[block.MaxIndex()]
				else
					iftemp:=lock[lock.MaxIndex()]?lock[lock.MaxIndex()]:0
				if(last!="{")
					iflock.Insert(iftemp)
			}
			if(iflock.1+1&&last!="{")
				iflock.Insert(++iftemp)
		}else if(ss=0){
			iflock:=[]
		}else if(ss=1&&last="{")
			lock[lock.MaxIndex()]:=Lock[lock.MaxIndex()]-1
		if(firsttwo="/*")
			blocks:=1,otherbraces:=braces,block.Insert(otherbraces+blocks)
		lastind:=0
	}
	update({sc:sc.2357}),sc.2079
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