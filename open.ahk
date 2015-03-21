open(filelist="",show=""){
	static root,top
	if !filelist{
		openfile:=current(2).file
		SplitPath,openfile,,dir
		FileSelectFile,filename,,%dir%,,*.ahk
		if ErrorLevel
			return
		if ff:=files.ssn("//main[@file='" filename "']"){
			Gui,1:Default
			tv(xml.ea(ff.firstchild).tv)
			return
		}
		if !FileExist(filename)
			return m("File does not exist. Create a new file with File/New")
		fff:=FileOpen(filename,"RW"),file1:=file:=fff.read(fff.length)
		gosub,addfile
		Gui,1:TreeView,SysTreeView321
		filelist:=files.sn("//main[@file='" filename "']/descendant::file"),TV(files.ea("//main[@file='" filename "']/file").tv)
		while,filename:=filelist.item[A_Index-1]
			code_explorer.scan(filename)
		code_explorer.Refresh_Code_Explorer()
	}else{
		WinSetTitle,% hwnd([1]),,AHK Studio - Scanning files....
		for a,b in StrSplit(filelist,"`n"){
			if InStr(b,"'")
				return m("Filenames and folders can not contain the ' character (Chr(39))")
			if files.ssn("//main[@file='" b "']")
				continue
			fff:=FileOpen(b,"RW"),file1:=file:=fff.read(fff.length),filename:=b
			gosub,addfile
			v.filescan.Insert(filename)
		}
		if Show
			SetTimer,scanfiles,-100
		return
		scanfiles:
		if !v.filescan.1{
			SetTimer,scanfiles,Off
			WinSetTitle,% hwnd([1]),,% "AHK Studio - " current(3).file
			code_explorer.Refresh_Code_Explorer(),v.wait:=0
			return
		}
		filename:=v.filescan.1
		filelist:=files.sn("//main[@file='" filename "']/descendant::file")
		while,fn:=filelist.item[A_Index-1]
			code_explorer.scan(fn)
		v.filescan.Remove(1),v.wait:=0
		return
	}
	return root
	addfile:
	Gui,1:Default
	SplitPath,filename,fn,dir
	top:=files.add({path:"main",att:{file:filename},dup:1})
	list:=[{file:filename,parent:""}]
	while,list:=extract(list,top){
	}ff:=files.sn("//file")
	if !settings.ssn("//open/file[text()='" filename "']")
		settings.add({path:"open/file",text:filename,dup:1})
	Gui,1:Default
	TV_Modify(TV_GetChild(0),"Select Focus Vis")
	return
}