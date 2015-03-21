class debug{
	static socket
	__New(){
		if (this.socket){
			debug.Send("stop")
			sleep,500
			this.disconnect()
		}
		sock:=-1
		DllCall("LoadLibrary","str","ws2_32","ptr"),VarSetCapacity(wsadata,394+A_PtrSize)
		DllCall("ws2_32\WSAStartup","ushort",0,"ptr",&wsadata)
		DllCall("ws2_32\WSAStartup","ushort",NumGet(wsadata,2,"ushort"),"ptr",&wsadata)
		OnMessage(0x9987,"Sock"),socket:=sock
		next:=debug.addrinfo(),sockaddrlen:=NumGet(next+0,16,"uint"),sockaddr:=NumGet(next+0,16+(2*A_PtrSize),"ptr")
		socket:=DllCall("ws2_32\socket","int",NumGet(next+0,4,"int"),"int",1,"int",6,"ptr")
		if (DllCall("ws2_32\bind","ptr",socket,"ptr",sockaddr,"uint",sockaddrlen,"int")!=0)
			return m(DllCall("ws2_32\WSAGetLastError"))
		DllCall("ws2_32\freeaddrinfo","ptr",next)
		DllCall("ws2_32\WSAAsyncSelect","ptr",socket,"ptr",A_ScriptHwnd,"uint",0x9987,"uint",0x29)
		ss:=DllCall("ws2_32\listen","ptr",socket,"int",32)
		debug.socket:=socket
	}
	addrinfo(){
		VarSetCapacity(hints,8*A_PtrSize,0)
		for a,b in {6:8,1:12}
			NumPut(a,hints,b)
		DllCall("ws2_32\getaddrinfo",astr,"127.0.0.1",astr,"9000","uptr",hints,"ptr*",results)
		return results
	}
	Run(filename){
		v.debugfilename:=filename
		new debug()
		SetTimer,runn,50
		return
		runn:
		SetTimer,runn,Off
		filename:=v.debugfilename
		SplitPath,filename,,dir
		Run,"%A_AhkPath%" /debug "%filename%",%dir%,,pid
		v.pid:=pid
		SetTimer,cee,200
		return
		cee:
		SetTimer,cee,Off
		if WinExist("ahk_pid" v.pid){
			ControlGetText,text,Static1,% "ahk_pid" v.pid
			info:=striperror(text,v.debugfilename),sc:=csc()
			if (info.line&&info.file){
				tv(tv:=files.ssn("//file[@file='" info.file "']/@tv").text)
				sleep,200
				sc:=csc()
				start:=sc.2128(info.line),end:=sc.2136(info.line)
				sc.2160(start,end)
			}
		}
		return
	}
	encode(text){ ;original http://www.autohotkey.com/forum/viewtopic.php?p=238120#238120
		if text=""
			return
		cp:=0
		VarSetCapacity(rawdata,StrPut(text,"utf-8")),sz:=StrPut(text,&rawdata,"utf-8")-1
		DllCall("Crypt32.dll\CryptBinaryToString","ptr",&rawdata,"uint",sz,"uint",0x40000001,"ptr",0,"uint*",cp)
		VarSetCapacity(str,cp*(A_IsUnicode?2:1))
		DllCall("Crypt32.dll\CryptBinaryToString","ptr",&rawdata,"uint",sz,"uint",0x40000001,"str",str,"uint*",cp)
		return str
	}
	decode(string){ ;original http://www.autohotkey.com/forum/viewtopic.php?p=238120#238120
		if string=""
			return
		DllCall("Crypt32.dll\CryptStringToBinary","ptr",&string,"uint",StrLen(string),"uint",1,"ptr",0,"uint*",cp:=0,"ptr",0,"ptr",0) ;getsize
		VarSetCapacity(bin,cp)
		DllCall("Crypt32.dll\CryptStringToBinary","ptr",&string,"uint",StrLen(string),"uint",1,"ptr",&bin,"uint*",cp,"ptr",0,"ptr",0)
		return StrGet(&bin,cp,"utf-8")
	}
	Off(){
		for a,b in [10002,10003,10004]
			toolbar.list.10002.setstate(b,16)
		for a,b in [10000,10001]
			toolbar.list.10002.setstate(b,4)
	}
	On(){
		for a,b in [10002,10003,10004]
			toolbar.list.10002.setstate(b,4)
		for a,b in [10000,10001]
			toolbar.list.10002.setstate(b,16)
	}
	register(){
		DllCall("ws2_32\WSAAsyncSelect","ptr",debug.socket,"ptr",A_ScriptHwnd,"uint",0x9987,"uint",0x29)
	}
	disconnect(){
		DllCall("ws2_32\WSAAsyncSelect","uint",debug.socket,"ptr",A_ScriptHwnd,"uint",0,"uint",0)
		DllCall("ws2_32\closesocket","uint",debug.socket,"int")
		DllCall("ws2_32\WSACleanup"),debug.socket:=""
		debug.Off()
	}
	accept(){
		if ((sock:=DllCall("ws2_32\accept","ptr",debug.socket,"ptr",0,"int",0,"ptr"))!=-1)
			debug.socket:=sock,debug.register()
		Else
			debug.disconnect()
	}
	Send(message){
		message.=Chr(0),len:=strlen(message),VarSetCapacity(buffer,len)
		ll:=StrPut(message,&buffer,"utf-8")
		DllCall("ws2_32\send","ptr",debug.socket,uptr,&buffer,"int",ll,"int",0,"cdecl")
	}
	
}
Sock(info*){
	if (info.3=0x9987){
		if (info.2&0xFFFF=1)
			receive()
		if (info.2&0xffff=8)
			debug.accept()
		if (info.2&0xFFFF=32)
			debug.disconnect() ;("disconnect")
	}
}
debug(text){
	Gui,55:Destroy
	Gui,55:Add,Edit,w800 h800 -Wrap,%text%
	Gui,55:Show
}