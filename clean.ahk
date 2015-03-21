clean(clean,tab=""){
	if tab
		return RegExReplace(clean,"[^\w ]")
	clean:=RegExReplace(RegExReplace(clean,"&")," ","_")
	if InStr(clean,"`t")
		clean:=SubStr(clean,1,InStr(clean,"`t")-1)
	return clean
}