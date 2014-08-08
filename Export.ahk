Export(){
	indir:=settings.ssn("//export/file[@file='" ssn(current(1),"@file").text "']")
	FileSelectFile,filename,S16,% indir.text,Export Compiled AHK,*.ahk
	SplitPath,filename,,outdir
	filename:=InStr(filename,".ahk")?filename:filename ".ahk"
	FileDelete,%filename%
	FileAppend,% publish(1),%filename%,UTF-8
	if !indir.text
		indir:=settings.Add({path:"export/file",att:{file:ssn(current(1),"@file").text},dup:1})
	indir.text:=outdir
}