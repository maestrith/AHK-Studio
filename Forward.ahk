Forward(){
	history({stop:1}),list:=history(),next:=list.current+1
	while,(next<=list.history.MaxIndex()){
		if tv:=files.ssn("//file[@file='" list.history[next] "']/@tv").text{
			tv(tv)
			break
		}
		next++
	}
	if (next&&next<=list.history.MaxIndex())
		history({current:next})
	history({stop:0})
}