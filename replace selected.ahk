replace_selected(){
	replace:=InputBox(csc().sc,"Replace Selected","Input text to replace what is selected")
	if ErrorLevel
		return
	sc:=csc(),clip:=Clipboard
	strip:="``r,``n,``r``n,\r,\n,\r\n"
	for a,b in StrSplit(strip,","){
		replace:=RegExReplace(replace,"i)\Q" b "\E",Chr(13))
	}
	sc.2614(1)
	Clipboard:=replace
	sc.2179
	Clipboard:=clip
}