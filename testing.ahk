testing(){
	;m("testing")
	sc:=csc()
	info:=StrSplit(sc.getseltext(),",")
	replace:=info.2 ":=InputBox(," Chr(34) info.3 Chr(34) "," Chr(34) info.4 Chr(34) "," Chr(34) info.12 Chr(34) ")"
	sc.2170(0,replace)
}