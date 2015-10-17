Goto(){
	goto:
	sc:=csc(),sc.2003(sc.2008,","),sc.2025(sc.2008+1),labels:="",list:=cexml.sn("//file[@file='" current(3).file "']descendant::info[@type='Label']")
	while,ll:=list.item[A_Index-1]
		labels.=cexml.ea(ll).text " "
	Sort,labels,D%A_Space%
	sc.2100(0,Trim(labels))
	return
}