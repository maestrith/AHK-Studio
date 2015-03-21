move_selected_lines_up(){
	GuiControl,-Redraw,% csc().sc
	csc().2620
	if (v.options.full_auto)
		newindent(settings.ssn("//tab").text?settings.ssn("//tab").text:5)
	GuiControl,+Redraw,% csc().sc
}
/*
	fixindent(){
		sc:=csc(),codetext:=sc.gettext()
		firstvis:=sc.2152,line:=sc.2166(sc.2008),linestart:=sc.2128(line),posinline:=sc.2008-linestart
		selpos:=posinfo(),startline:=sc.2166(selpos.start),endline:=sc.2166(selpos.end-1)
		add:=[],braces:=0,code:=StrSplit(codetext,"`n"),state:=[]
		for a,b in code{
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
			if(SubStr(text,1,1)="}"||SubStr(text,1,2)="*/")
				braces--
			if lastind
				add:=[]
			if(text="{")
				add:=[]
			if(braces||add.MaxIndex()){
				in:=5,max:=add.MaxIndex()?add.MaxIndex():0,indent:=(braces+max)*in,sc.2126(a-1,indent)
			}
			if RegExMatch(text,"iA)\b(" v.indentregex ")\b",found)
				add.Insert({line:a})
			else
				add:=[]
			if(SubStr(text,0,1)="{"||SubStr(text,1,2)="/*")
				braces++,lastind:=1
			else
				lastind:=0
			if(a!=code.MaxIndex())
				new.="`n"
		}
		GuiControl,+Redraw,% sc.sc
	}
*/