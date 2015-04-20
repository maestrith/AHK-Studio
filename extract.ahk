extract(list,top){
	static ResolveDir:=ComObjCreate("Scripting.FileSystemObject")
	disable:=v.options.Disable_Folders_In_Project_Explorer,filelist:=[]
	for index,obj in list{
		filename:=obj.file
		if !FileExist(filename)
			Continue
		SplitPath,filename,fn,dir
		backupdir:=dir
		ffff:=FileOpen(filename,"RW"),encoding:=ffff.pos=3?"UTF-8":ffff.pos=2?"UTF-16":"CP0",text:=ffff.read(ffff.length)
		if !next:=ssn(top,"descendant::file[@file='" obj.parent "']")
			next:=files.under(top,"file",{file:filename,tv:FEAdd(fn,0,"Sort"),filename:fn,skip:skip,encoding:encoding})
		else{
			cfile:=obj.file,pfile:=obj.parent
			SplitPath,cfile,,cdir
			SplitPath,pfile,,pdir
			if (cdir!=pdir&&disable!=1){
				build:=""
				for a,b in {"%A_AppData%":A_AppData,"%A_AppDataCommon%":A_AppDataCommon}
					if(InStr(cfile,b))
						StringReplace,build,cfile,%b%,%a%,All
				build:=build?build:RelativePath(pfile,cfile)
				folderlist:=""
				SplitPath,build,cfname,build
				for e,f in StrSplit(build,"\"){
					folderlist.=f "\"
					if !folder:=ssn(top,"descendant::folder[@folder='" folderlist "']")
						next:=files.under(next,"folder",{folder:folderlist,tv:FEAdd(f,ssn(next,"@tv").text,"First Sort")})
				}
				next:=folder.xml?folder:next
				tv:=disable?ssn(top.FirstChild,"@tv").text:ssn(next,"@tv").text
				files.under(next,"file",{file:filename,tv:FEAdd(cfname,tv,"First Sort"),filename:fn,skip:skip,encoding:encoding,include:obj.include})
			}else{
				tv:=disable?ssn(top.FirstChild,"@tv").text:ssn(next,"@tv").text
				files.under(next,"file",{file:filename,tv:FEAdd(fn,tv,"Sort"),filename:fn,skip:skip,encoding:encoding,include:obj.include})
			}
		}
		StringReplace,text,text,`r`n,`n,All
		StringReplace,text,text,`r,`n,All
		update({file:filename,text:text,load:1})
		for a,b in StrSplit(text,"`n","`r"){
			original:=b
			if regexmatch(b,"iO)^\s*#(include|includeagain),?\s*(.*)",name){
				skip:=InStr(b,";*")?1:0
				if skip
					Continue
				b:=Trim(RegExReplace(RegExReplace(RegExReplace(name.2,"\/","\"),"\*i "),"(\;.*)"))
				if RegExMatch(name.2,"UO)\<(.*)\>",lib){
					mainfile:=ssn(top,"@file").text
					SplitPath,mainfile,,dir
					for i,dd in [dir "\lib\",A_MyDocuments "\AutoHotkey\Lib\"]{
						if FileExist(dd lib.1 ".ahk"){
							b:=dd lib.1 ".ahk"
							goto extractnext
						}
					}
					Continue
				}
				for find,replace in {"%A_LineFile%":filename,"%A_ScriptDir%":backupdir,"%A_AppData%":A_AppData,"%A_AppDataCommon%":A_AppDataCommon}
					if InStr(b,find)
						StringReplace,b,b,%find%,%replace%,All
				extractnext:
				SplitPath,b,file,outdir
				newfile:=RegExReplace(outdir,"(\.|\\)")?b:dir "\" b
				if(FileExist(newfile)="D"){
					dir:=newfile
					files.under(top,"remove",{inc:original})
					Continue
				}
				if !FileExist(newfile)
					newfile:=dir "\" newfile
				if !FileExist(newfile)
					Continue
				newfilename:=ResolveDir.GetAbsolutePathName(newfile)
				if !ssn(top,"descendant-or-self::file[@file='" newfilename "']")
					filelist.Insert({file:newfilename,parent:filename,include:original})
			}
		}
	}
	if filelist.MinIndex()
		return filelist
}