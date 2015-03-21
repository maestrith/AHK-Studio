eol(){
	eol:
	csc().2314,key:=StrSplit(A_ThisHotkey," "),key:=key[key.MaxIndex()]
	Send,{%key%}
	return
}