cut(){
	cut:
	sc:=csc()
	if(!sc.getseltext())
		sc.2337
	else
		Send,^x
	update({sc:sc.2357})
	Clipboard:=RegExReplace(Clipboard,"\n","`r`n")
	return
}