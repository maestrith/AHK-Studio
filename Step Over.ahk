Step_Over(){
	if !debug.socket
		Debug_Current_Script()
	debug.Send("step_over")
	;debug.Send("step_over")
}
Step_Into(){
	if !debug.socket
		Debug_Current_Script()
	debug.Send("step_into")
}
Step_Out(){
	if !debug.socket
		Debug_Current_Script()
	debug.Send("step_out")
}