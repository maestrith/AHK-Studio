listvars(){
	if !debug.socket
		return m("Currently no file being debugged"),debug.off()
	debug.send("context_get -c 1")
}