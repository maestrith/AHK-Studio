full_backup(){
	save(),sc:=csc()
	SplashTextOn,300,100,Backing up...,Please wait, This may take some time if it has been a while since your last full backup.
	cur:=ssn(current(1),"@file").Text
	SplitPath,cur,,dir
	backup:=dir "\backup\Full Backup" A_Now
	FileCreateDir,%backup%
	loop,%dir%\*.*
	{
		if InStr(a_loopfilename,".exe") || InStr(A_LoopFileName,".dll")
			continue
		filecopy,%A_LoopFileFullPath%,%backup%\%A_LoopFileName%
	}
	loop,%dir%\backup\*.*,2
		if !InStr(A_LoopFileFullPath,"Full Backup")
			fileremovedir,%a_loopfilefullpath%,1
	SplashTextOff
}