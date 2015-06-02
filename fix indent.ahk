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
NewIndent(indentwidth:=""){
	Critical
	sc:=csc(),codetext:=sc.getuni(),indentation:=sc.2121,line:=sc.2166(sc.2008),posinline:=sc.2008-sc.2128(line),selpos:=posinfo(),sc.2078,lock:=[],block:=[],aa:=ab:=braces:=0,code:=StrSplit(codetext,"`n"),aaobj:=[]
	GuiControl,1:-Redraw,% sc.sc
	GuiControl,1:+g,% sc.sc
	for a,text in code{
		if(InStr(text,Chr(59)))
			text:=RegExReplace(text,"\s" Chr(59) ".*"),comment:=1
		text:=Trim(text,"`t "),first:=SubStr(text,1,1),last:=SubStr(text,0,1),firsttwo:=SubStr(text,1,2),ss:=(text~="i)^\s*(&&|OR|AND|\.|\,|\|\||:|\?)"),indentcheck:=RegExMatch(text,"iA)}?\s*\b(" v.indentregex ")\b")
		if(first="("&&last!=")")
			skip:=1
		if(first=")"&&skip){
			skip:=0
			continue
		}
		if(skip)
			continue
		if(firsttwo="*/")
			block:=[],aa:=0
		block.MinIndex()?(current:=block,cur:=1):(current:=lock,cur:=0),braces:=current[current.MaxIndex()].braces+1?current[current.MaxIndex()].braces:0,aa:=aaobj[cur]+0?aaobj[cur]:0
		if(first="}"){
			while,((found:=SubStr(text,A_Index,1))~="(}|\s)"){
				if(found~="\s")
					Continue
				if(cur&&current.MaxIndex()<=1)
					Break
				special:=current.pop().ind,braces--
			}
		}
		if(first="{"&&aa)
			aa--
		tind:=current[current.MaxIndex()].ind+1?current[current.MaxIndex()].ind:0,tind+=aa?aa*indentation:0,tind:=tind+1?tind:0,tind:=special?special-indentation:tind
		if(!(ss&&v.options.Manual_Continuation_Line||text=""&&comment=1)&&sc.2127(a-1)!=tind)
			sc.2126(a-1,tind)
		if(firsttwo="/*"){
			if(block.1.ind="")
				block.Insert({ind:(lock.1.ind!=""?lock[lock.MaxIndex()].ind+indentation:indentation),aa:aa,braces:lock.1.ind+1?Lock[lock.MaxIndex()].braces+1:1})
			current:=block,aa:=0
		}
		if(last="{"){
			braces++,aa:=ss&&last="{"?aa-1:aa
			if(!current.MinIndex())
				current.Insert({ind:(aa+braces)*indentation,aa:aa,braces:braces})
			else
				current.Insert({ind:(aa+current[current.MaxIndex()].aa+braces)*indentation,aa:aa+current[current.MaxIndex()].aa,braces:braces})
			aa:=0
		}
		if((aa||ss||indentcheck)&&(indentcheck&&last!="{"))
			aa++
		if(aa>0&&(ss||indentcheck)=0)
			aa:=0
		aaobj[cur]:=aa,special:=0,comment:=0
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
	line:=sc.2166(sc.2008)
	GuiControl,1:-Redraw,% sc.sc
	if(sc.2008=sc.2128(line)&&v.options.Manual_Continuation_Line){
		ss:=(sc.getline(line-1)~="i)^\s*(&&|OR|AND|\.|\,|\|\||:|\?)")
		if ss
			sc.2126(line,sc.2127(line-1)),sc.2025(sc.2128(line))
	}
	GuiControl,1:+Redraw,% sc.sc
}