Debug_Current_Script(){
	if (ssn(current(1),"@file").text=A_ScriptFullPath)
		return m("Can not debug AHK Studio using AHK Studio.")
	save(),debug.Run(ssn(current(1),"@file").text)
}