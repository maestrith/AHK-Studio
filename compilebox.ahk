compilebox(win){
	static list:={2:0,3:1,4:2,5:3,6:4,7:5,8:6,9:16384,11:16,12:32,13:48
	,14:64,17:8192,18:262144,19:4096,22:256,23:512,25:524288,26:1048576}
	total=0
	for a,b in ["Edit1","Edit2","Edit3"]
		ControlGetText,edit%a%,Edit%a%,ahk_id%win%
	for a,b in list{
		ControlGet,value,Checked,,Button%a%
		if value
			total+=b
	}
	edit1:=edit1?edit1:"Testing"
	msg=MsgBox,%total%,%edit1%,%edit2%
	msg.=edit3?"," edit3:""
	return msg
}