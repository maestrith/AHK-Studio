New_Segment(new:="",text:="",adjusted:=""){
	cur:=adjusted?adjusted:current(2).file,sc:=csc(),parent:=mainfile:=current(2).file
	SplitPath,cur,,dir
	maindir:=dir
	if(!new){
		FileSelectFile,new,s,%dir%,Create a new Segment,*.ahk
		if ErrorLevel
			return
		new:=new~="\.ahk$"?new:new ".ahk"
		if FileExist(new)
			return m("File Already Exists.","Please create a new file")
		SplitPath,new,filename,dir,,func
	}
	if node:=ssn(current(1),"descendant::file[@file='" new "']")
		return tv(ssn(node,"@tv").Text)
	SplitPath,new,file,newdir,,function
	Gui,1:Default
	Relative:=RegExReplace(relativepath(cur,new),"i)^lib\\([^\\]+)\.ahk$","<$1>"),func:=clean(func)
	SplitPath,newdir,last
	under:=files.ssn("//main[@file='" parent "']").firstchild
	if(v.options.Disable_Folders_In_Project_Explorer!=1&&newdir!=maindir){
		last:=InStr(last,":")||last=""?"lib":last
		if(!top:=ssn(under,"descendant::folder[@name='" last "']"))
			top:=files.under(under,"folder",{name:last})
		under:=top
	}
	newnode:=files.under(under,"file",{file:new,filename:file,encoding:"CP0",include:Chr(35) "Include " relative}),Refresh_Project_Treeview(new,parent)
	Sleep,400
	if(text){
		sc.2181(0,[text])
	}else{
		MsgBox,36,Insert Function?,Add a new function named %func% to the new Segment?
		IfMsgBox,Yes
			sc.2181(0,text:=func "(){`n`t`n}"),fix_indent(),sc.2025(StrLen(text)-2)
	}
	main:=update({get:mainfile}),main.="`n#Include " Relative,update({file:mainfile,text:main}),current(1).firstchild.removeattribute("sc")
}