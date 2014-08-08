stop(){
	if !debug.socket
		return m("Currently no file being debugged"),debug.off()
	debug.send("stop")
	sleep,500
	hwnd({rem:99}),debug.disconnect()
	WinWaitClose,% hwnd
	debug.off()
	csc("Scintilla1")
}