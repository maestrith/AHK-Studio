Send_WM_COPYDATA(AID,String,Key=25565){
	VarSetCapacity(Struct,12,0)
	NumPut(StrPut(string,"utf-8")*2,struct,4),NumPut(&string,struct,8)
	SendMessage,0x4a,%Key%,&Struct,,ahk_id %AID% ahk_class AutoHotkey
}