Margin_Left(set:=0){
	sc:=csc()
	if(set){
		sc.2155(0,Round(settings.ssn("//marginleft").text))
		return
	}
	margin:=sc.2156(),number:=InputBox(sc.sc,"Left Margin","Enter a new value for the left margin",margin!=""?margin:6)
	if(number="")
		return
	settings.add2("marginleft","",number),Margin_Left(1)
}