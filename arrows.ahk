arrows(){
	left:
	right:
	sc:=csc(),selcount:=sc.2570,pos:=[],current:=sc.2008,canchor:=sc.2009
	if selcount>1
		loop,%selcount%
			pos[A_Index-1]:={caret:sc.2577(A_Index-1),anchor:sc.2579(A_Index-1)}
	ControlGetFocus,Focus,A
	Send,{%A_ThisLabel%}
	if !InStr(Focus,"scintilla")
		return
	uppos()
	for a,b in pos{
		add:=A_ThisLabel="left"?-1:1
		if (b.caret!=b.anchor){
			if (A_ThisLabel="left"&&b.caret!=current)
				use:=b.caret>b.anchor?b.anchor:b.caret,sc.2573(use,use)
			else if (A_ThisLabel="right"&&b.anchor!=canchor)
				use:=b.caret>b.anchor?b.caret:b.anchor,sc.2573(use,use)
		}else if (b.caret!=current)
			sc.2573(b.caret+add,b.caret+add)
	}
	if selcount>1
		sc.2606
	return
	+left:
	+right:
	ControlGetFocus,Focus,A
	if(InStr(Focus,"Edit")),label:=Trim(A_ThisLabel,"+")
		Send,+{%Label%}
	if !InStr(Focus,"scintilla")
		return
	sc:=csc(),selcount:=sc.2570,pos:=[]
	if (selcount>1){
		loop,%selcount%
			pos[A_Index-1]:={start:sc.2577(A_Index-1),end:sc.2579(A_Index-1)}
		for a,b in pos{
			add:=A_ThisHotkey="+left"?-1:1,cursor:=b.start,anchor:=b.end+add
			if A_Index=1
				sc.2160(anchor,cursor)
			else
				sc.2573(cursor,anchor)
		}
		sc.2606
	}else{
		label:=SubStr(A_ThisLabel,2)
		Send,+{%label%}
	}
	uppos()
	return
}