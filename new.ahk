new(filename:="",text:=""){
	template:=settings.ssn("//template")
	if(template.xml)
		template:=template.text
	else
		FileRead,template,c:\windows\shellnew\template.ahk
	if (filename=1){
		index:=0
		if !FileExist(A_WorkingDir "\Projects")
			FileCreateDir,% A_WorkingDir "\Projects"
		if !FileExist(A_WorkingDir "\Projects\Untitled")
			FileCreateDir,% A_WorkingDir "\Projects\Untitled"
		while,FileExist(A_WorkingDir "\Projects\Untitled\Untitled" A_Index)
			index:=A_Index
		index++
		FileCreateDir,% A_WorkingDir "\Projects\Untitled\Untitled" index
		filename:=A_WorkingDir "\Projects\Untitled\Untitled" index "\Untitled.ahk"
		text:=text?text:template
		FileAppend,%text%,%filename%
	}else if (filename=""){
		FileSelectFile,filename,S,% ProjectFolder(),Create A New Project,*.ahk
		if ErrorLevel
			return
		filename:=SubStr(filename,-3,1)="."?filename:filename ".ahk"
		if InStr(filename,".ahk")
			FileAppend,%template%,%filename%
	}else if(text){
		SplitPath,filename,,outdir
		FileCreateDir,%outdir%
		FileAppend,%text%,%filename%
	}
	Gui,1:Default
	Gui,1:TreeView,SysTreeView321
	tv:=open(filename,1)
	tv(tv)
}