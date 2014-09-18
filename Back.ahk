Back(){
	history({stop:1}),list:=history(),prev:=list.current-1
	while,(prev>0){
		file:=list.history[prev]
		if tv:=files.ssn("//file[@file='" file "']/@tv").text{
			tv(tv)
			break
		}
		prev--
	}
	if prev
		history({current:prev})
	Sleep,200
	history({stop:0})
}