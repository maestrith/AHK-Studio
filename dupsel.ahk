addsel(){
	addsel:
	MouseGetPos,x,y,,con
	ControlGetPos,xx,yy,,,%con%,% hwnd([1])
	sc:=csc(),pos:=sc.2023(x-xx,y-yy)
	for a,b in v.selectedduplicates{
		if (b-1<pos&&pos<sc.2509(3,b)+1){
			Loop,% sc.2570
				if (b=sc.2585(A_Index-1))
					Break,2
			sc.2573(sc.2509(3,b),b)
		}
	}
	return
}