Func _unZip($sZipFile, $sDestFolder)
	If Not FileExists($sZipFile) Then Return SetError(1)    ; source file does not exists
	If Not FileExists($sDestFolder) Then
		If Not DirCreate($sDestFolder) Then Return SetError(2)      ; unable to create destination
	Else
		If Not StringInStr(FileGetAttrib($sDestFolder), "D") Then Return SetError(3)      ; destination not folder
	EndIf
	Local $oShell = ObjCreate("shell.application")
	Local $oZip = $oShell.NameSpace($sZipFile)
	Local $iZipFileCount = $oZip.items.Count
	Local $dest = $oShell.NameSpace($sDestFolder)
	If Not $iZipFileCount Then Return SetError(4)    ; zip file empty
	$dest.copyhere($oZip.items, 16)
EndFunc   ;==>_unZip
