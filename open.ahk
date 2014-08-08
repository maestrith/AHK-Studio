open(filelist="",show=""){
	static root,top
	if !filelist{
		FileSelectFile,filename,,,,*.ahk
		if ErrorLevel
			return
		if ff:=files.ssn("//main[@file='" filename "']"){
			Gui,1:Default
			tv:=ssn(ff.firstchild,"@tv").text
			TV_Modify(tv,"Select Vis Focus")
			return
		}
		fff:=FileOpen(filename,"RW","utf-8")
		file1:=file:=fff.read(fff.length)
		gosub,addfile
		Gui,1:TreeView,SysTreeView321
		TV_Modify(root,"Select Vis Focus")
		filelist:=files.sn("//main[@file='" filename "']/*")
		while,filename:=filelist.item[A_Index-1]
			code_explorer.scan(filename)
		code_explorer.Refresh_Code_Explorer()
	}else{
		for a,b in StrSplit(filelist,"`n"){
			if files.ssn("//main[@file='" b "']")
				continue
			fff:=FileOpen(b,"RW","utf-8")
			file1:=file:=fff.read(fff.length)
			filename:=b
			gosub,addfile
			filelist:=files.sn("//main[@file='" filename "']/*")
			while,fn:=filelist.item[A_Index-1]
				code_explorer.scan(fn)
			if show
				tv(root)
		}
	}
	return root
	addfile:
	Gui,1:Default
	SplitPath,filename,fn,dir
	top:=files.add({path:"main",att:{file:filename},dup:1})
	v.filelist[filename]:=1
	pos:=1
	Gui,1:TreeView,SysTreeView321
	root:=TV_Add(fn)
	StringReplace,file,file,`r`n,`n,All
	StringReplace,file,file,`r,`n,All
	file1:=file
	files.under({under:top,node:"file",att:{file:filename,tv:root,filename:fn}})
	for a,b in strsplit(file1,"`n"){
		if InStr(b,"#include"){
			b:=RegExReplace(b,"\/","\")
			while,(d:=substr(b,instr(b," ",0,1,a_index)+1))&&instr(b," ",0,1,a_index){
				newfn:=FileExist(dir "\" d)?dir "\" d:FileExist(d)?d:""
				SplitPath,newfn,ff
				if (ff=".."){
					newfn:=""
					Break
				}
				if (newfn)
					Break
			}
		}
		if (newfn){
			StringReplace,file1,file1,%b%,,All
		}
		if !newfn
			continue
		if ssn(top,"file[@file='" newfn "']")
			continue
		SplitPath,newfn,fn
		child:=TV_Add(fn,root,"Sort")
		top:=files.ssn("//main[@file='" filename "']")
		files.under({under:top,node:"file",att:{file:newfn,include:b,tv:child,filename:fn}})
		v.filelist[newfn]:=1
		ffff:=FileOpen(newfn,"RW","utf-8")
		text:=ffff.read(ffff.length)
		StringReplace,text,text,`r`n,`n,All
		update({file:newfn,text:text,load:1})
	}
	update({file:filename,text:Trim(file,"`r`n"),load:1})
	ff:=files.sn("//file")
	if !settings.ssn("//open/file[text()='" filename "']")
		settings.add({path:"open/file",text:filename,dup:1})
	Gui,1:Default
	TV_Modify(TV_GetChild(0),"Select Focus Vis")
	return
}