fold_all(){
	csc().2662()
}
fold_current_level(){
	sc:=csc(),level:=sc.2223(sc.2166(sc.2008))&0xff,level:=level-1>=0?level-1:level
	fold_level_x(level)
}
fold_level_x(level=""){
	sc:=csc()
	if (level="")
		level:=InputBox(sc,"Fold Levels","Enter a level to fold")
	current:=0
	while,(current<sc.2154){
		fold:=sc.2223(current)
		if (fold&0xff=level)
			sc.2237(current,0),current:=sc.2224(current,fold)
		current+=1
	}
}
unfold_all(){
	csc().2662(1)
}
unfold_current_level(){
	sc:=csc(),level:=sc.2223(sc.2166(sc.2008))&0xff
	unfold_level_x(level)
}
unfold_level_x(level=""){
	sc:=csc()
	if (level="")
		level:=InputBox(sc,"Fold Levels","Enter a level to unfold")
	if ErrorLevel
		return
	fold=0
	while,sc.2618(fold)>=0,fold:=sc.2618(fold){
		lev:=sc.2223(fold)
		if (lev&0xff=level)
			sc.2237(fold,1)
		fold++
	}
}