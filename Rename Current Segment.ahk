Rename_Current_Segment(current:=""){
	if(!current.xml)
		current:=current()
	ea:=xml.ea(current)
	FileSelectFile,Rename,S16,% ea.file,Rename Current Segment,*.ahk
	if(ErrorLevel)
		return
	SplitPath,rename,,,ext
	if(!ext)
		rename.=".ahk"
	mainfile:=ssn(current,"ancestor::main/@file").text,relative:=RelativePath(mainfile,rename)
	FileMove,% ea.file,%relative%,1
	text:=update({get:mainfile}),text:=RegExReplace(text,"\Q" ea.include "\E","#Include " relative),update({file:mainfile,text:text}),current(1).firstchild.removeattribute("sc")
	SplashTextOn,,100,Indexing Files,Please Wait....
	Refresh_Project_Explorer(rename)
	SplashTextOff
}