GetInclude(){
	GetInclude:
	main:=current(2).file
	SplitPath,main,,dir
	FileSelectFile,filename,,%dir%,Select a file to include,*.ahk
	if(ErrorLevel||filename="")
		return
	newfile:=filename~="\.ahk$"?filename:filename ".ahk"
	Relative:=RelativePath(ssn(current(),"@file").text,newfile)
	sc:=csc(),cp:=sc.2008,sc.2003(cp," " relative),sc.2160(cp+StrLen(" " Relative),cp+StrLen(" " Relative))
	FileRead,text,%newfile%
	StringReplace,text,text,`r`n,`n,All
	StringReplace,text,text,`r,`n,All
	new_segment(newfile,text,ssn(current(),"@file").text)
	return
}