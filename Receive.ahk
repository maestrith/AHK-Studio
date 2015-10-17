Receive(){
	;Thank you Lexikos and fincs http://ahkscript.org/download/tools/DBGP.ahk
	Critical
	socket:=debug.socket
	while,DllCall("ws2_32\recv","ptr",socket,"char*",c,"int",1,"int",0){
		if c=0
			break
		length.=Chr(c)
	}
	VarSetCapacity(packet,++length,0)
	received:=0,text:=""
	While,(received<length){
		r:=DllCall("ws2_32\recv","ptr",socket,"ptr",&packet+received,"int",length-received,"int",0)
		if(r<1){
			error:=DllCall("GetLastError"),stop()
			return m(r,socket,length,received,"An error occured",error,"Possible reasons for the error:","1.  Sending OutputDebug faster than 1ms per message","2.  Max_Depth or Max_Children value too large")
		}
		received+=r
	}
	Critical,Off
	if(!IsObject(v.displaymsg))
		v.displaymsg:=[]
	if(info:=StrGet(&packet,"utf-8")){
		v.displaymsg.push(info)
		SetTimer,display,-10
	}
}