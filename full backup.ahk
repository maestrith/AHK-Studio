Full_Backup(){
	save(),sc:=csc()
	SplashTextOn,300,100,Backing up...,Please wait, This may take some time if it has been a while since your last full backup.
	cur:=current(2).file
	SplitPath,cur,,dir
	backup:=dir "\backup\Full Backup" A_Now
	FileCreateDir,%backup%
	if(v.options.Full_Backup_All_Files){
		loop,%dir%\*.*,0,1
		{
			if(InStr(a_loopfilename,".exe")||InStr(A_LoopFileName,".dll")||InStr(A_LoopFileDir,dir "\backup"))
				Continue
			file:=Trim(RegExReplace(A_LoopFileFullPath,"i)\Q" dir "\E"),"\")
			SplitPath,file,filename,ddir
			if !FileExist(backup "\" ddir)
				FileCreateDir,% backup "\" ddir
			ndir:=ddir?backup "\" ddir:backup
			FileCopy,%A_LoopFileFullPath%,%ndir%\%filename%
		}
	}else{
		allfiles:=sn(current(1),"descendant::file/@file")
		while,af:=allfiles.item[A_Index-1]{
			file:=Trim(RegExReplace(af.text,"i)\Q" dir "\E"),"\")
			SplitPath,file,filename,ddir
			if !FileExist(backup "\" ddir)
				FileCreateDir,% backup "\" ddir
			ndir:=ddir?backup "\" ddir:backup
			FileCopy,% af.text,%ndir%\%filename%
		}
	}
	loop,%dir%\backup\*.*,2
		if !InStr(A_LoopFileFullPath,"Full Backup")
			FileRemoveDir,%A_LoopFileFullPath%,1
	SplashTextOff
}