cut(){
	cut:
	sc:=csc()
	if (!sc.getseltext())	;Can check for "Copy/Cut Entire Line When Selection Empty" option here
		sc.2337
	else
		Send,^x
	Clipboard:=RegExReplace(Clipboard,"\n","`r`n")
	return
}
