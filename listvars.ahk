listvars(){
	if !debug.socket
		return m("Currently no file being debugged"),debug.off()
	debug.send("context_get -c 1")
	/*
		;this can get a single value.
		so when the user clicks on a top level item, have it get it's children
		debug.send("feature_set -n max_depth -v 1")
		Sleep,50
		debug.send("feature_set -n max_children -v 200")
		Sleep,50
		debug.send("property_get -n xml")
	*/
}