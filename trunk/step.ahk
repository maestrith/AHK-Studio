step(){
	if !debug.socket
		return m("Currently no file being debugged"),debug.off()
	debug.send("step_into")
}