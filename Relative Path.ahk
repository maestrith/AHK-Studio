RelativePath(main,new){
	SplitPath,main,,mdir
	SplitPath,new,filename,ndir
	for a,b in {"%A_AppData%":A_AppData,"%A_AppDataCommon%":A_AppDataCommon}
		if InStr(new,b)
			return RegExReplace(new,"\Q" b "\E",a)
	smain:=StrSplit(mdir,"\"),snew:=StrSplit(ndir,"\")
	if(smain.1!=snew.1)
		return new
	for a,b in smain{
		if(b!=snew[a]){
			Loop,% smain.MaxIndex()-(a-1)
				pre.="..\"
			for c,d in snew{
				if(c>=a)
					build.=d "\"
			}
			return pre build filename
		}remove.=b "\"
	}
	StringReplace,Relative,new,%remove%
	return Relative
}