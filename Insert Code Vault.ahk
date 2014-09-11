Insert_Code_Vault_Text(){
	list:=vault.sn("//code"),vaultlist:="",sc:=csc()
	while,ll:=list.item[A_Index-1]
		vaultlist.=ssn(ll,"@name").text "-"
	vaultlist:=Trim(vaultlist,"-")
	Sort,vaultlist,D-
	sc.2117(2,Trim(RegExReplace(vaultlist,"-"," ")))
}