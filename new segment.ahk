new_segment(new:="",text:="",adjusted:=""){
	cur:=adjusted?adjusted:current(2).file
	SplitPath,cur,,dir
	if !new
	{
		FileSelectFile,new,s,%dir%,Create a new Segment,*.ahk
		new:=new~="\.ahk$"?new:new ".ahk"
		if FileExist(new)
			return m("File Already Exists.","Please create a new file")
		if ErrorLevel
			return
		SplitPath,new,filename,dir,,func
	}
	if node:=ssn(current(1),"descendant::file[@file='" new "']")
		return tv(ssn(node,"@tv").Text)
	SplitPath,new,file,newdir,,function
	Gui,1:Default
	Relative:=relativepath(cur,new),func:=clean(func),current:=ssn(current(1),"@file").text
	SplitPath,current,,currentdir
	obj:=NewFile(cur,new),select:=files.under(obj.obj,"file",{file:new,filename:file,include:Chr(35) "Include " Relative,tv:TV_Add(file,obj.tv,"Sort")}),update({file:new,text:text})
	if(adjusted)
		return tv(ssn(select,"@tv").text)
	mainfile:=ssn(current(1),"@file").text
	SplitPath,mainfile,,outdir
	main:=update({get:mainfile}),main.="`n#Include " Relative,update({file:mainfile,text:main}),current(1).firstchild.removeattribute("sc")
	if (text=""){
		MsgBox,36,Insert Function?,Add a new function named %func% to the new Segment?
		IfMsgBox,Yes
			text:=func "(){`n`n}"
	}
	update({edited:cur}),update({edited:new}),update({file:new,text:text}),tv(ssn(select,"@tv").text)
	Sleep,200
	IfMsgBox,Yes
	{
		if v.options.full_auto{
			fix_indent()
			sc:=csc(),sc.2025(StrLen(text)-1)
		}
	}
}