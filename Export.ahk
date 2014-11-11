Export(){
	indir:=settings.ssn("//export/file[@file='" ssn(current(1),"@file").text "']")
	warn:=settings.ssn("//options/@Warn_Overwrite_On_Export").text?"S16":""
	FileSelectFile,filename,%warn%,% indir.text,Export Compiled AHK,*.ahk
	SplitPath,filename,,outdir
	filename:=InStr(filename,".ahk")?filename:filename ".ahk"
	FileDelete,%filename%
	FileAppend,% publish(1),%filename%,UTF-8
	if !indir
		indir:=settings.Add({path:"export/file",att:{file:ssn(current(1),"@file").text},dup:1})
	if outdir
		indir.text:=outdir
}