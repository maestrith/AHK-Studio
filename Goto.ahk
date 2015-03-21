Goto(){
	goto:
	sc:=csc(),sc.2003(sc.2008,","),sc.2025(sc.2008+1),list:=cexml.sn("//main[@file='" current(2).file "']descendant::info[@type='Label']"),labels:=""
	while,ll:=list.item[A_Index-1]
		labels.=cexml.ea(ll).text " "
	Sort,labels,D%A_Space%
	sc.2100(0,Trim(labels))
	return
}