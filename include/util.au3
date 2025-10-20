#include-once
#include <JSON.au3>
#include <moreArray.au3>
Global Const $standardLang = _JSON_Parse('{' & @CRLF & _
		'    "main": "Gui for Datainterface",' & @CRLF & _
		'    "tJsonLoader": "JSON Loader",' & @CRLF & _
		'    "bAddJsonFile": "Add",' & @CRLF & _
		'    "bRemoteJsonDownload": "Download",' & @CRLF & _
		'    "bLocalJsonFileRemove": "Remove",' & @CRLF & _
		'    "bLocalJsonFileCopy": "Copy",' & @CRLF & _
		'    "bLocalJsonFileRename": "Rename",' & @CRLF & _
		'    "bLocalJsonFileBackup": "Backup",' & @CRLF & _
		'    "bOpenJsonFolder": "Open Folder",' & @CRLF & _
		'    "bRunVariant": "Run",' & @CRLF & _
		'    "bVariantRemove": "Remove",' & @CRLF & _
		'    "bVariantEdit": "Edit",' & @CRLF & _
		'    "bAddVariantfromClip": "Clipboard",' & @CRLF & _
		'    "laddSpecifier": "Add new Variant via Methods:",' & @CRLF & _
		'    "bAddVariantFromFile": "Textfile",' & @CRLF & _
		'    "baddVariantsFromJsonFile": "Combine JsonFiles",' & @CRLF & _
		'    "tSettings": "Settings",' & @CRLF & _
		'    "cClocks": "Clocks",' & @CRLF & _
		'    "cClocksChoices": "Long|Medium|Short",' & @CRLF & _
		'    "iClockTime": "Time",' & @CRLF & _
		'    "iClockDelay": "Delay",' & @CRLF & _
		'    "bClockSet": "Set",' & @CRLF & _
		'    "bClockReset": "Reset to default",' & @CRLF & _
		'    "Label1": "+",' & @CRLF & _
		'    "cbUndoMove": "Undo Move",' & @CRLF & _
		'    "cbRestartGameOnCrash": "Restart Game on Crash",' & @CRLF & _
		'    "lTravelAnimations": "Travel Animations:",' & @CRLF & _
		'    "rAnimationsAlwaysOn": "Always On",' & @CRLF & _
		'    "rAnimationsAlwaysOff": "Always Off",' & @CRLF & _
		'    "rAnimationsIgnore": "Ignore",' & @CRLF & _
		'    "bInsertCode": "Insert Room Code",' & @CRLF & _
		'    "bResumeGame": "Resume Game",' & @CRLF & _
		'    "tPgnLoader": "PGN Loader",' & @CRLF & _
		'    "bPgnAdd": "Add",' & @CRLF & _
		'    "bPgnOpenPath": "Choose Path",' & @CRLF & _
		'    "bPgnAddClipboard": "Add from Clipboard",' & @CRLF & _
		'    "bPgnRun": "Run",' & @CRLF & _
		'    "bPgnRemove": "Remove",' & @CRLF & _
		'    "bPgnEdit": "Edit"' & @CRLF & _
		'}')
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

Func _LoadLanguage($language = Null)
	If Not FileExists("language.json") Or Not $language Then
		Return $standardLang
	EndIf
	Local $filedata = FileRead("language.json")
	Local $filejson = _JSON_Parse($filedata)
	If Not MapExists($filejson, $language) Then
		Return SetError(1, 0, $standardLang)
	EndIf
	If Not _arrayinarray(MapKeys($filejson[$language]), MapKeys($standardLang)) Then
		Return SetError(1, 0, $standardLang)
	EndIf
	Return $filejson[$language]
EndFunc   ;==>_LoadLanguage


