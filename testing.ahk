testing(){
	Refresh_Variable_List()
	;add this list to the auto list that pops up for commands
	/*
		static stuff:={"~o":"Ãµ","~n":"Ã±"},winhwnd
		WinGet,winhwnd,id,A
		Gui,27:Destroy
		Gui,27:Default
		Gui,+hwndhwnd
		hwnd(27,hwnd)
		Hotkeys([27],{Enter:"insgo"})
		Gui,Add,Edit,w200 gins
		Gui,Add,ListView,w200 r6,Input|Replace
		Gui,Show,,Insert
		goto popins
		return
		insgo:
		Gui,27:Default
		LV_GetText(ins,LV_GetNext(),2)
		WinActivate,ahk_id%winhwnd%
		Send,%ins%
		return
		ins:
		Gosub,popins
		return
		popins:
		Gui,27:Default
		ControlGetText,ins,Edit1,% hwnd([27])
		LV_Delete()
		for a,b in stuff
			if InStr(a,ins)
				LV_Add("",a,b)
		Loop,2
			LV_ModifyCol(A_Index,"AutoHDR")
		LV_Modify(1,"Select Vis Focus")
		return
		27GuiEscape:
		hwnd({rem:27})
		return
	*/
	/*
		;how to get the info below
		;GET /user/repos	
		repo:=new github()
		url:=repo.url "/users/" repo.owner "/repos" repo.token
		;return m(url)
		cb:=repo.Send("GET",url)
		FileAppend,%cb%,1info.txt
	*/
	/*
		;how to upload files that are not normal :)
		FileSelectFile,_from_file,,,,*.dll
		Ptr := A_IsUnicode ? "Ptr" : "UInt"
		H:=DllCall("CreateFile",Ptr,&_From_File,"UInt",0x80000000,"UInt",3,"UInt",0,"UInt",3,"UInt",0,"UInt",0)
		VarSetCapacity(FileSize,8,0)
		DllCall("GetFileSizeEx",Ptr,H,"Int64*",FileSize)
		FileSize:=FileSize=-1?0:FileSize
		VarSetCapacity(InData,FileSize,0)
		DllCall("ReadFile",Ptr,H,Ptr,&InData,"UInt",FileSize,"UInt*",0,"UInt",0)
		DllCall("Crypt32.dll\CryptBinaryToString"(A_IsUnicode?"W":"A"),Ptr,&InData,UInt,FileSize,UInt,1,UInt,0,UIntP,Bytes,"CDECLInt")
		VarSetCapacity(OutData,Bytes*=(A_IsUnicode?2:1))
		DllCall("Crypt32.dll\CryptBinaryToString"(A_IsUnicode?"W":"A"),Ptr,&InData,UInt,FileSize,UInt,1,Str,OutData,UIntP,Bytes,"CDECLInt")
		;PUT /repos/:owner/:repo/contents/:path
		StringReplace,outdata,outdata,`r`n,,All
		SplitPath,_from_file,filename
		InputBox,message,Commit Message,Enter a quick message
		ea:=settings.ea("//github")
		http:=ComObjCreate("WinHttp.WinHttpRequest.5.1")
		if proxy:=settings.ssn("//proxy").text
			http.setProxy(2,proxy)
		url:=github.url "/repos/maestrith/AHK-Studio/contents/" filename "?access_token=" ea.token
		json={"message":"%message%","committer":{"name":"Chad Wilson","email":"maestrith@gmail.com"},"content":
		json.= Chr(34) outdata chr(34) "}"
		http.open("PUT",url)
		http.Send(json)
		m(Clipboard:=http.ResponseText)
	*/
}