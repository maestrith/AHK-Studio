Notes(NoActivate:=0){
	static lastfile
	last:=current(3).file,parent:=current(2).file
	if(last=""&&parent="")
		return m("Please create or open a file before making notes")
	if(!FileExist("notes"))
		FileCreateDir,Notes
	SplitPath,parent,filename,,,nne
	if(!note:=notesxml.ssn("//note[@file='" current(2).file "']"))
		note:=notesxml.under(notesxml.ssn("//notes"),"note",{file:current(2).file})
	if(note.text){
		FileAppend,% note.text,Notes\%nne%.txt
		note.text:=""
	}
	main:=main:=files.ssn("//main[@file='" parent "']/descendant::*[@note='1']"),ea:=xml.ea(main)
	if(!main){
		main:=files.ssn("//file[@file='" parent "']"),mm:=xml.ea(main),files.under(main,"file",{note:1,file:A_ScriptDir "\notes\" nne ".txt",filename:filename,tv:(tv:=TV_Add(nne ".txt",mm.tv))})
		text:=FileOpen(A_ScriptDir "\notes\" nne ".txt","r"),update({file:A_ScriptDir "\notes\" nne ".txt",text:RegExReplace(text.Read(text.length),"\R","`n")}),tv(tv,1)
	}else if(current(3).file=A_ScriptDir "\notes\" nne ".txt"){
		tv(files.ssn("//file[@file='" lastfile "']/@tv").text)
	}else
		tv(ea.tv)
	lastfile:=last
}