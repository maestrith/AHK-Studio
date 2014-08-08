compile_main_gist(filename){
	fn:=sn(current(1),"file/@file")
	while,f:=fn.item(A_Index-1).text{
		if A_Index=1
			continue
		SplitPath,f,filename
		text.="`r`n" Chr(35) "Include " filename
	}
	return text
}