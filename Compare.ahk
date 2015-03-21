Compare(){
	file:=update("get").1,compare:=[]
	for a,b in s.Main{
		ea:=files.ea("//*[@sc='" b.2357 "']")
		compare.Insert({text:file[ea.file],sc:b,file:ea.file})
	}
	for a,b in compare
	for c,d in compare{
		if (d.file=b.file)
			Continue
		for e,f in StrSplit(b.text,"`n"){
			if !InStr(d.text,Trim(Trim(f," "),"`t"))
				b.sc.2242(4,1),b.sc.2240(4,5),b.sc.2532(A_Index-1,48)
		}
	}
}