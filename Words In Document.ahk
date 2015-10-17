Words_In_Document(){
	doc:=update({get:ssn(current(),"@file").text}),sc:=csc(),word:=sc.getword(),words:=RegExReplace(RegExReplace(doc,"[\W|\d]"," "),"\s+","|")
	Sort,words,D|U
	for a,b in StrSplit(words,"|")
		if StrLen(b)>2
			list.=b " "
	if word
		StringReplace,list,list,%word%%A_Space%,,All
	sc.2100(StrLen(word),Trim(list))
}