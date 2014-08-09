Words_In_Document(){
	doc:=update({get:ssn(current(),"@file").text}),sc:=csc()
	words:=RegExReplace(RegExReplace(doc,"[\W|\d]"," "),"\s+","|")
	Sort,words,D|U
	for a,b in StrSplit(words,"|")
		if StrLen(b)>2
			list.=b " "
	start:=sc.2266(sc.2008,1),end:=sc.2267(sc.2008,1)
	sc.2100(end-start,Trim(list))
}