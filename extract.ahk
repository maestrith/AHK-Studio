Extract(fileobj,top,rootfile){
	static ResDir:=ComObjCreate("Scripting.FileSystemObject")
	nextfile:=[],showicon:=settings.ssn("//icons/pe/@show").text
	SplitPath,A_AhkPath,,ahkdir
	ahkdir.="\lib"
	SplitPath,rootfile,rootfn,rootfolder
	if(!main:=cexml.ssn("//main[@file='" rootfile "']"))
		main:=cexml.Add2("main",{file:rootfile},"",1),cexml.under(main,"file",{type:"File",parent:rootfile,file:rootfile,name:rootfn,folder:rootfolder,order:"name,type,folder"})
	for a,filename in fileobj{
		SplitPath,filename,fn,dir
		maindir:=dir,fff:=FileOpen(filename,"R"),encoding:=fff.encoding,text:=file:=fff.read(fff.length),fff.close(),dir:=Trim(dir,"\"),text:=RegExReplace(text,"\R","`n"),update({file:filename,text:text,load:1}),update:=files.ssn("//main[@file='" rootfile "']/descendant::file[@file='" filename "']")
		for a,b in {filename:fn,encoding:encoding}
			update.SetAttribute(a,b)
		for a,b in StrSplit(text,"`n"){
			if(InStr(b,"*i"))
				StringReplace,b,b,*i ,,All
			if(RegExMatch(b,"iOm`n)^\s*\x23Include\s*,?\s*(.*)",found)){
				ff:=RegExReplace(found.1,"\R")
				SplitPath,ff,incfn,,ext
				if(InStr(found.1,":"))
					incfile:=ResDir.GetAbsolutePathName(found.1)
				else if(InStr(found.1,".."))
					incfile:=ResDir.GetAbsolutePathName(dir "\" found.1)
				if(!incfile)
					incfile:=ResDir.GetAbsolutePathName(rootfolder "\" found.1)
				if(ext=""&&InStr(found.1,"<")=0){
					dir:=InStr(found.1,"%A_ScriptDir%")?RegExReplace(found.1,"i)\x25A_ScriptDir\x25",maindir):found.1,dir:=Trim(dir,"\")
					incfile:=ext:=""
					Continue
				}else if(FileExist(incfile)&&ext){
					if(!ssn(top,"descendant::file[@file='" incfile "']"))
						spfile:=incfile
					nextfile.Push(incfile)
				}else if(InStr(found.1,"<")||InStr(found.1,"%")){
					if(look:=RegExReplace(found.1,"(<|>)"))
						look.=".ahk"
					if(!FileExist(look))
						if(SubStr(look,-3)!=".ahk")
							if(FileExist(look ".ahk"))
								look.=".ahk"
					for a,b in {"mainlib":ahkdir,"%A_ScriptDir%":maindir,"%A_MyDocuments%":A_MyDocuments "\AutoHotkey\Lib","lib":maindir "\lib","%A_AppData%":A_AppData,"%A_AppDataCommon%":A_AppDataCommon}{
						if(InStr(look,a))
							look:=RegExReplace(look,"i)" a "\\")
						if(FileExist(b "\" look)){
							nextfile.Push(b "\" look)
							if(!ssn(top,"descendant::file[@file='" b "\" look "']"))
								spfile:=b "\" look
							break
				}}}else if(FileExist(incfile:=ResDir.GetAbsolutePathName(dir "\" found.1))){
					if(!ssn(top,"descendant::file[@file='" incfile "']"))
						spfile:=incfile
					nextfile.Push(incfile)
				}
				if(spfile){
					SplitPath,spfile,fnme,folder
					SplitPath,folder,last
					last:=last?last:"lib",next:=top
					if(folder!=rootfolder&&v.options.Disable_Folders_In_Project_Explorer!=1){
						if(v.options.Full_Tree){
							relative:=StrSplit(RelativePath(rootfile,spfile),"\")
							for a,b in relative
								if(a=relative.MaxIndex())
									Continue
							else if(!foldernode:=ssn(next,"folder[@name='" b "']"))
								next:=files.under(next,"folder",{name:b,tv:FEAdd(b,ssn(next,"@tv").text,"Icon1 First Sort")})
							else
								next:=foldernode
						}else{
							if(!ssn(top,"folder[@name='" last "']"))
								slash:=v.options.Remove_Directory_Slash?"":"\",next:=files.under(top,"folder",{name:last,tv:FEAdd(slash last,ssn(top,"@tv").text,"Icon1 First Sort")})
							else
								next:=ssn(top,"folder[@name='" last "']")
						}
					}
					FileGetTime,time,%spfile%
					files.under(next,"file",{time:time,file:spfile,include:Trim(found.0,"`n"),tv:FEAdd(fnme,ssn(next,"@tv").text,"Icon2 First Sort"),github:(folder!=rootfolder)?last "\" fnme:fnme})
					cexml.under(main,"file",{type:"File",parent:rootfile,file:spfile,name:fnme,folder:folder,order:"name,type,folder"})
					spfile:=""
				}
				incfile:=ext:=""
			}
		}
	}
	if(nextfile.1)
		extract(nextfile,top,rootfile)
}