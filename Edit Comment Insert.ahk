Edit_Comment_Insert(){
	format:=settings.ssn("//comment").text,format:=format?format:";"
	InputBox,Insert,New Comment Insert,Enter the comment format you wish to use,,,,,,,,% RegExReplace(format,"%a_space%"," ")
	if ErrorLevel
		return
	settings.add2("comment","",RegExReplace(insert," ","%a_space%"))
}