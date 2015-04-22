compile(main=""){
	main:=ssn(current(1),"@file").Text
	SplitPath,main,,dir,,name
	RegRead,ahkpath,HKLM,Software\AutoHotkey,InstallDir
	Loop,%dirr%\Ahk2Exe.exe,1,1
		file:=A_LoopFileFullPath
	FileDelete,%dir%\temp.upload
	FileAppend,% publish(1),%dir%\temp.upload
	SplashTextOn,200,100,Compiling,Please wait.
	Loop,%dir%\*.ico
		icon:=A_LoopFileFullPath
	if icon
		add=/icon "%icon%"
	RunWait,%file% /in "%dir%\temp.upload" /out "%dir%\%name%.exe" %add%
	If FileExist("upx.exe"){
		SplashTextOn,,50,Compressing EXE,Please wait...
		RunWait,upx.exe -9 "%dir%\%name%.exe",,Hide
		SplashTextOff
	}
	FileDelete,%dir%\temp.upload
	SplashTextOff
}
