Dlg_Color(Color,hwnd){
	static
	if settings.ssn("//colorinput").text{
		color:=InputBox(csc().sc,"Color Code","Input your color code in RGB",RGB(color))
		if !InStr(color,"0x")
			color:="0x" color
		if !ErrorLevel
			return RGB(color)
		return
	}
	if !cc{
		VarSetCapacity(cccc,16*A_PtrSize,0),cc:=1,size:=VarSetCapacity(CHOOSECOLOR,9*A_PtrSize,0)
		Loop,16{
			IniRead,col,color.ini,color,%A_Index%,0
			NumPut(col,cccc,(A_Index-1)*4,"UInt")
		}
	}
	NumPut(size,CHOOSECOLOR,0,"UInt"),NumPut(hwnd,CHOOSECOLOR,A_PtrSize,"UPtr"),NumPut(Color,CHOOSECOLOR,3*A_PtrSize,"UInt"),NumPut(3,CHOOSECOLOR,5*A_PtrSize,"UInt"),NumPut(&cccc,CHOOSECOLOR,4*A_PtrSize,"UPtr"),ret:=DllCall("comdlg32\ChooseColorW","UPtr",&CHOOSECOLOR,"UInt")
	if !ret
		exit
	Loop,16
		IniWrite,% NumGet(cccc,(A_Index-1)*4,"UInt"),color.ini,color,%A_Index%
	IniWrite,% Color:=NumGet(CHOOSECOLOR,3*A_PtrSize,"UInt"),color.ini,default,color
	return Color
}