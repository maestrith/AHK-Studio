Save_As(){
	current:=current(1),currentfile:=current(2).file
	SplitPath,currentfile,,dir
	FileSelectFile,newfile,S,%dir%,Save File As...,*.ahk
	newfile:=SubStr(newfile,-3)=".ahk"?newfile:newfile ".ahk"
	if FileExist(newfile)
		return m("File exists... Please choose another")
	filelist:=sn(current(1),"descendant::*")
	SplitPath,newfile,newfn,newdir
	while,fl:=filelist.item[A_Index-1],ea:=xml.ea(fl)
		if(newfn=ea.filename)
			return m("File conflicts with an include.  Please choose another filename")
	SplashTextOn,200,100,Creating New File(s)
	while,fl:=filelist.item[A_Index-1],ea:=xml.ea(fl){
		filename:=ea.file
		SplitPath,filename,file
		if (A_Index=1)
			FileAppend,% update({get:filename}),%newdir%\%newfn%,% ea.encoding
		else if !FileExist(newdir "\" file)
			FileAppend,% update({get:filename}),%newdir%\%file%
	}
	SplashTextOff
	open(newfile)
}