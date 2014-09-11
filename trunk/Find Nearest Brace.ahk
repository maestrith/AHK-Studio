Find_Nearest_Brace(){
	sc:=csc()
	line:=sc.2166(start:=sc.2008)
	linestart:=sc.2128(line)
	while,(linestart<start){
		start--
		current:=sc.2007(start)
		if current in 41,125,93
			start:=sc.2353(start)
		if current in 40,123,91
		{
			sc.2351(start,sc.2353(start))
			Break
		}
	}
}