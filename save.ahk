save(option=""){
	sc:=csc(),update({sc:sc.2357}),getpos(),info:=update("get"),now:=A_Now,currentdoc:=sc.2357
	GuiControl,-Redraw,% sc.sc
	if (option=1){
		for a,b in info.2{
			MsgBox,35,Save File?,File contents have been updated for %a%.`nWould you like to save the updates?
			IfMsgBox,No
				info.2.Remove(a)
			IfMsgBox,Cancel
				return
		}
	}
	for filename in info.2{
		text:=info.1[filename],main:=ssn(current(1),"@file").text
		if settings.ssn("//options/@Enable_Close_On_Save").text
			for process in ComObjGet("winmgmts:").ExecQuery("Select * from Win32_Process"){
			prog:=Trim(StrSplit(process.CommandLine,Chr(34)).4,Chr(34))
			if (InStr(process.commandline,"autohotkey")&&prog!=A_ScriptFullPath&&prog)
				if (prog=main)
					Process,Close,% process.processid
		}
		SplitPath,filename,file,dir
		if !(v.options.disable_backup){
			if !FileExist(dir "\backup")
				FileCreateDir,% dir "\backup"
			if !FileExist(dir "\backup\" now)
				FileCreateDir,% dir "\backup\" now
			FileMove,%filename%,% dir "\backup\" now "\" file,1
		}else
			FileDelete,%filename%
		StringReplace,text,text,`n,`r`n,All
		encoding:=files.ssn("//file[@file='" filename "']/@encoding").text,encoding:=encoding?encoding:"UTF-8"
		if(encoding!="UTF-16"&&RegExMatch(text,"[^\x00-\x7F]"))
			encoding:="UTF-16"
		if(v.options.Force_UTF8)
			encoding:="UTF-8"
		FileAppend,%text%,%filename%,%encoding%
		Gui,1:TreeView,% hwnd("fe")
		multi:=files.sn("//file[@file='" filename "']")
		while,mm:=multi.item[A_Index-1]
			ea:=files.ea(mm),TV_Modify(ea.tv,"",ea.filename)
		if !ea.sc
			Continue
		sc.2358(0,ea.sc)
		Sleep,100
		Loop,% sc.2154{
			if sc.2533(A_Index-1)=30
				sc.2532(A_Index-1,31)
		}
		FileGetTime,time,%filename%
		ff:=files.sn("//*[@file='" filename "']")
		while,fff:=ff.item[A_Index-1]
			fff.SetAttribute("time",time)
	}
	GuiControl,+Redraw,% sc.sc
	sc.2358(0,currentdoc),cd:=files.ssn("//file[@sc='" currentdoc "']"),posinfo:=positions.ssn("//main[@file='" ssn(cd.ParentNode,"@file").text "']/file[@file='" ssn(cd,"@file").text "']")
	ea:=xml.ea(posinfo),fold:=ea.fold,breakpoint:=ea.breakpoint
	Loop,Parse,fold,`,
		sc.2231(A_LoopField)
	Loop,Parse,breakpoint,`,
		sc.2043(A_LoopField,0)
	if ea.start&&ea.end
		sc.2613(ea.scroll),sc.2160(ea.start,ea.end)
	savegui(),positions.save(1),vversion.save(1),lastfiles()
	update("clearupdated")
}