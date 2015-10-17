add_space_before_and_after_commas(){
	sc:=csc()
	if(!sel:=sc.getseltext())
		sc.2160(sc.2128(line:=sc.2166(sc.2008)),sc.2136(line)),sel:=sc.getseltext()
	sc.2170(0,[ProcessText(sel,["U),(\S)",", $1"],["U)(\S),","$1 ,"])])
}