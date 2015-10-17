ProcessText(text,process*){
	split:=!IsObject(process.1)?(process.1,process.RemoveAt(1)):Chr(34)
	for a,b in StrSplit(text,split){
		if(!Mod(A_Index,2))
			newtext.=split b split
		else{
			for c,d in process{
				while,b:=RegExReplace(b,d.1,d.2,count)
					if(!count)
						break
			}
			newtext.=b
		}
	}
	return newtext
}