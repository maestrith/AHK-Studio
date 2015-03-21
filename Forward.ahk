Forward(){
	history({stop:1}),list:=history(),next:=list.current+1
	while,(next<=list.history.MaxIndex()){
		if tv:=files.ssn("//file[@file='" list.history[next] "']/@tv").text{
			tv(tv)
			break
		}else{
			list.history.Remove(next)
			Continue
		}
		next++
	}
	if (next&&next<=list.history.MaxIndex())
		history({current:next})
	Sleep,200
	history({stop:0})
}