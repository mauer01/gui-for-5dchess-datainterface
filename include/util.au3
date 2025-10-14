#include-once
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

Func _ProcessGetLocation($sProc = @ScriptFullPath)
	Local $iPID = ProcessExists($sProc)
	If $iPID = 0 Then Return SetError(1, 0, -1)

	Local $aProc = DllCall('kernel32.dll', 'hwnd', 'OpenProcess', 'int', BitOR(0x0400, 0x0010), 'int', 0, 'int', $iPID)
	If $aProc[0] = 0 Then Return SetError(1, 0, -1)

	Local $vStruct = DllStructCreate('int[1024]')
	DllCall('psapi.dll', 'int', 'EnumProcessModules', 'hwnd', $aProc[0], 'ptr', DllStructGetPtr($vStruct), 'int', DllStructGetSize($vStruct), 'int*', 0)

	Local $aReturn = DllCall('psapi.dll', 'int', 'GetModuleFileNameEx', 'hwnd', $aProc[0], 'int', DllStructGetData($vStruct, 1), 'str', '', 'int', 2048)
	If StringLen($aReturn[3]) = 0 Then Return SetError(2, 0, '')
	Return $aReturn[3]
EndFunc   ;==>_ProcessGetLocation
