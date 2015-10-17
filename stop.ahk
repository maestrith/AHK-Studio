stop(x:=0){
	if(debug.socket=""&&x=0)
		return m("Currently no file being debugged"),debug.off()
	debug.send("stop")
	sleep,200
	debug.disconnect()
	debug.off()
	csc("Scintilla1")
}