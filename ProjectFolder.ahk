ProjectFolder(){
	return settings.ssn("//directory").text?settings.ssn("//directory").text:A_ScriptDir "\Project"
}