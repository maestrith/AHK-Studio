new_segment(new="",text=""){
	cur:=ssn(current(1),"@file").Text
	SplitPath,cur,,dir,,func
	if !new
	{
		FileSelectFile,new,s,%dir%,Create a new Segment,*.ahk
		if FileExist(new)
			Return m("File Already Exists.","Please create a new file")
		if ErrorLevel
			return
		SplitPath,new,filename,dir,,func
		new:=InStr(new,".ahk")?new:new ".ahk"
	}
	if node:=ssn(current(1),"file[@file='" new "']")
		return tv(ssn(node,"@tv").Text)
	SplitPath,new,file,newdir,,function
	incfile:=(newdir=dir)?file:new
	Gui,1:Default
	top:=TV_Add(file,ssn(current(1),"file/@tv").text,"Sort"),func:=clean(func)
	current:=ssn(current(1),"@file").text
	SplitPath,current,,currentdir
	incfilename:=newdir=currentdir?file:new
	select:=files.under({node:"file",att:{file:new,filename:file,include:Chr(35) "Include " incfilename,tv:top},under:current(1)})
	v.filelist[new]:=1
	mainfile:=ssn(current(1),"@file").text
	main:=update({get:mainfile}),main.="`n#Include " incfilename
	update({file:mainfile,text:main})
	current(1).firstchild.removeattribute("sc")
	if (text=""){
		MsgBox,36,Insert Function?,Add a new function named %func% to the new Segment?
		IfMsgBox,Yes
			text:=func "(){`r`n`r`n}"
	}
	update({file:new,text:text})
	update({edited:cur}),update({edited:new})
	;future add a way to add stuff to the new file
	tv(top)
}