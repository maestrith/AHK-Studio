save(option=""){
	sc:=csc(),getpos(),update({sc:sc.2357}),info:=update("get"),now:=A_Now
	if(option=1){
		for a,b in info.2{
			MsgBox,35,Save File?,File contents have been updated for %a%.`nWould you like to save the updates?
			IfMsgBox,No
				info.2.Remove(a)
			IfMsgBox,Cancel
				return "cancel"
		}
	}savedfiles:=[]
	for filename in info.2{
		text:=info.1[filename],main:=ssn(current(1),"@file").text,savedfiles.push(1)
		if(settings.ssn("//options/@Enable_Close_On_Save").text)
			for process in ComObjGet("winmgmts:").ExecQuery("Select * from Win32_Process"){
				prog:=Trim(StrSplit(process.CommandLine,Chr(34)).4,Chr(34))
				if(InStr(process.commandline,"autohotkey")&&prog!=A_ScriptFullPath&&prog)
					if(prog=main)
						Process,Close,% process.processid
			}
		SplitPath,filename,file,dir
		setstatus("Saving " file,3)
		if(!v.options.disable_backup){
			if(!FileExist(dir "\backup"))
				FileCreateDir,% dir "\backup"
			if(!FileExist(dir "\backup\" now))
				FileCreateDir,% dir "\backup\" now
			FileMove,%filename%,% dir "\backup\" now "\" file,1
			if(ErrorLevel)
				m("There was an issue saving " filename,"Please close any error messages and try again")
		}else
			FileDelete,%filename%
		StringReplace,text,text,`n,`r`n,All
		encoding:=files.ssn("//file[@file='" filename "']/@encoding").text,encoding:=encoding?encoding:"UTF-8"
		if(encoding!="UTF-16"&&RegExMatch(text,"[^\x00-\x7F]"))
			encoding:="UTF-16"
		if(v.options.Force_UTF8)
			encoding:="UTF-8"
		file:=fileopen(filename,"rw",encoding),file.seek(0),file.write(text),file.length(file.position)
		Gui,1:TreeView,% hwnd("fe")
		multi:=files.sn("//file[@file='" filename "']")
		while,mm:=multi.item[A_Index-1]
			ea:=files.ea(mm),TV_Modify(ea.tv,"",ea.filename)
		FileGetTime,time,%filename%
		ff:=files.sn("//*[@file='" filename "']")
		while,fff:=ff.item[A_Index-1]
			fff.SetAttribute("time",time)
		if(!IsObject(v.savelinestat))
			v.savelinestat:=[]
		v.savelinestat[filename]:=1
	}
	plural:=savedfiles.MaxIndex()=1?"":"s",setstatus(Round(savedfiles.MaxIndex()) " File" plural " Saved",3)
	Loop,% sc.2154{
		if(sc.2533(A_Index-1)=30)
			sc.2532(A_Index-1,31)
	}
	savegui(),positions.save(1),vversion.save(1),lastfiles(),update("clearupdated"),PERefresh()
}