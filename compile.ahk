compile(main=""){
	main:=ssn(current(1),"@file").Text
	SplitPath,main,,dir,,name
	SplitPath,A_AhkPath,file,dirr
	Loop,%dirr%\Ahk2Exe.exe,1,1
		file:=A_LoopFileFullPath
	FileDelete,temp.upload
	FileAppend,% publish(1),temp.upload
	SplashTextOn,200,100,Compiling,Please wait.
	Loop,%dir%\*.ico
		icon:=A_LoopFileFullPath
	if icon
		add=/icon "%icon%"
	RunWait,%file% /in temp.upload /out "%dir%\%name%.exe" %add%
	If FileExist("upx.exe"){
		SplashTextOn,,50,Compressing EXE,Please wait...
		RunWait,upx.exe -9 "%dir%\%name%.exe",,Hide
		SplashTextOff
	}
	FileDelete,temp.upload
	SplashTextOff
}