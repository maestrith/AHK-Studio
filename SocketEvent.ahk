receive(){
	socket:=debug.socket
	;Thank you Lexikos and fincs http://ahkscript.org/download/tools/DBGP.ahk
	Critical
	VarSetCapacity(buffer)
	while,DllCall("ws2_32\recv","ptr",socket,"char*",c,"int",1,"int",0){
		if c=0
			break
		length.=chr(c)
	}
	VarSetCapacity(packet,++length)
	received:=0
	While,(received<length){
		r:=DllCall("ws2_32\recv","ptr",socket,"ptr",&packet+received,"int",length-received,"int",0)
		if (r<1)
			return m("An error occured",DllCall("GetLastError"))
		received += r
		sleep,100
	}
	Critical,Off
	info:=StrGet(&packet,"utf-8")
	if (info)
		display(info)
}