rgb(c){
	setformat,IntegerFast,H
	c:=(c&255)<<16 | (c&65280) | (c>>16),c:=SubStr(c,1)
	SetFormat, integerfast,D
	return c
}