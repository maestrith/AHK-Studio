Get_Include(){
	getinclude:
	FileSelectFile,filename,,,Select a file to include,*.ahk
	if(ErrorLevel||filename="")
		return
	SplitPath,filename,fn,outdir
	current:=ssn(current(1),"@file").text
	SplitPath,current,,currentdir
	newfile:=outdir=currentdir?fn:outdir "\" fn
	sc:=csc(),cp:=sc.2008
	sc.2003(cp," " newfile)
	sc.2160(cp+StrLen(" " newfile),cp+StrLen(" " newfile))
	return
}