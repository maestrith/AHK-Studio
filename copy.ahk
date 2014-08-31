copy(){
	copy:
	Clipboard:=RegExReplace(csc().getseltext(),"\n","`r`n")
	Return
}