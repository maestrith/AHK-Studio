cut(){
	cut:
	Send,^x
	Clipboard:=RegExReplace(Clipboard,"\n","`r`n")
	return
}