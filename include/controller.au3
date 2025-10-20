#include-once
#include <datainterfaceService.au3>
#include <moreArray.au3>
#include <multiversechess.au3>
#include <GUIConstantsEx.au3>

Func _frontController(ByRef $context, ByRef $mainGui)
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Return "exit"

		Case $mainGui["json"]["bAddJsonFile"]
		Case $mainGui["json"]["bAddVariantfromClip"]
		Case $mainGui["json"]["bAddVariantFromFile"]
		Case $mainGui["json"]["cRemoteJsons"]
		Case $mainGui["json"]["bRemoteJsonDownload"]
		Case $mainGui["json"]["cLocalJsonFiles"]
		Case $mainGui["json"]["bLocalJsonFileRemove"]
		Case $mainGui["json"]["bLocalJsonFileCopy"]
		Case $mainGui["json"]["bLocalJsonFileRename"]
		Case $mainGui["json"]["bLocalJsonFileBackup"]
		Case $mainGui["json"]["bOpenJsonFolder"]
		Case $mainGui["json"]["bRunVariant"]
		Case $mainGui["json"]["bVariantRemove"]
		Case $mainGui["json"]["bVariantEdit"]
		Case $mainGui["json"]["baddVariantsFromJsonFile"]
		Case $mainGui["settings"]["bClockSet"]
			Local $time = GUICtrlRead($mainGui["settings"]["iClockTime"])
			Local $delay = GUICtrlRead($mainGui["settings"]["iClockDelay"])
			Local $type[]
			$type["Medium"] = "M"
			$type["Long"] = "L"
			$type["Short"] = "S"
			Local $msg = _controller_changeTimer($context.data, $time, $delay, $type[GUICtrlRead($mainGui["settings"]["cClockType"])])
			If @error Then Return SetError(@error, 0, $msg)
		Case $mainGui["settings"]["bClockReset"]
		Case $mainGui["settings"]["cbUndoMove"]
			_controller_undoMoveToggle($context.data)
		Case $mainGui["settings"]["cbRestartGameOnCrash"]
		Case $mainGui["settings"]["rAnimationsAlwaysOn"]
			_controller_animationSetting($context.data, "on")
		Case $mainGui["settings"]["rAnimationsAlwaysOff"]
			_controller_animationSetting($context.data, "off")
		Case $mainGui["settings"]["rAnimationsIgnore"]
			_controller_animationSetting($context.data, "ignore")
		Case $mainGui["settings"]["bInsertCode"]
			_controller_trigger($context.data, ClipGet())
		Case $mainGui["settings"]["bResumeGame"]
			_controller_trigger($context.data)
		Case $mainGui["pgn"]["bPgnAdd"]
		Case $mainGui["pgn"]["bPgnOpenPath"]
		Case $mainGui["pgn"]["cPgnList"]
		Case $mainGui["pgn"]["bPgnRun"]
		Case $mainGui["pgn"]["bPgnRemove"]
		Case $mainGui["pgn"]["bPgnEdit"]
		Case $mainGui["pgn"]["bPgnAddClipboard"]
	EndSwitch
	_checkIsRunning($context.data)
EndFunc   ;==>_frontController





Func _controller_changeTimer(ByRef $data, $time, $delay, $type)
	Local $except[2] = ["reset", ":"]
	If $type <> "L" And $type <> "M" And $type <> "S" Then
		Return SetError(1, 0, "Type must be L, M, or S")
	EndIf

	_checkString($time, $except)
	If @error Then Return SetError(1, 0, "Time is not in either a : split format or in milliseconds or reset")
	_checkString($delay, $except)
	If @error Then Return SetError(1, 0, "Delay is not in either a : split format or in milliseconds or reset")
	Local $map[]
	$map["L"] = 6
	$map["M"] = 4
	$map["S"] = 2
	If ($time And $delay) Then
		_settingOptions($data, $map[$type], $time)
		_waitForResponse($data, "Action executed. Returning to menu")
		_settingOptions($data, $map[$type] + 1, $delay)
	ElseIf $time Then
		_settingOptions($data, $map[$type], $time)
	ElseIf $delay Then
		_settingOptions($data, $map[$type] + 1, $delay)
	EndIf
EndFunc   ;==>_controller_changeTimer

Func _checkString($string, $exceptions = "")
	If Not StringIsDigit($string) And Not _some($exceptions, "stringinstr", $string) Then
		Return SetError(1, 0, "string must be in a numeric or follow a format")
	EndIf
EndFunc   ;==>_checkString
Func _controller_undoMoveToggle(ByRef $data)
	Static $toggled = False
	If $toggled Then
		_optionsOrTriggers($data, 1, 2)
		$toggled = False
	Else
		_optionsOrTriggers($data, 1, 1)
		$toggled = True
	EndIf
EndFunc   ;==>_controller_undoMoveToggle

Func _controller_animationSetting(ByRef $data, $setting)
	Local $map[]
	$map["on"] = 1
	$map["off"] = 2
	$map["ignore"] = 3
	If IsString($setting) Then
		$setting = $map[$setting]
	EndIf
	If $setting < 1 Or $setting > 3 Then
		Return SetError(1, 0, "Setting out of range")
	EndIf
	_settingOptions($data, 1, $setting)
EndFunc   ;==>_controller_animationSetting

Func _controller_removeVariant(ByRef $data, $variantId)
	_removeVariantFromJson($data, $variantId)
EndFunc   ;==>_controller_removeVariant

Func _controller_runPGN(ByRef $data, $pgn)
	If ProcessExists("5dchesswithmultiversetimetravel.exe") Then
		_runPGN($data, $pgn)
	Else
		Return SetError(1, 0, "game not running")
	EndIf
EndFunc   ;==>_controller_runPGN



Func _controller_addVariant(ByRef $data, $multiverse)
	If Not MapExists($multiverse, "Name") Then
		Return SetError(1, 0, "name missing")
	EndIf
	$variant = _JSON_MYGenerate(_multiversetovariant($multiverse, $multiverse["Name"], "pgn to variant"))
	_addVariantToJson($data, $variant, $multiverse["Name"])
EndFunc   ;==>_controller_addVariant



Func _controller_downloadVariants(ByRef $data, $cacheOnly = False, $variantfiles = "all")
	_cacheJsonUrls($data)
	If $cacheOnly Then
		Return
	EndIf
	If $variantfiles <> "all" Then
		If Not IsArray($variantfiles) Then
			If _some($data["remoteJsonUrls"], "StringInStr", $variantfiles) = -1 Then
				Return SetError(1, 0, "variant file not found in cached urls")
			EndIf
		EndIf
		If Not _some($data["remoteJsonUrls"], "_someStringinStringcallback", $variantfiles) Then
			Return SetError(2, 0, "some variant file not found in cached urls")
		EndIf
	EndIf
	If $variantfiles = "all" Then
		$variantfiles = MapKeys($data["remoteJsonUrls"])
	EndIf
	_downloadAndInstallJsonFiles($data, $variantfiles)
EndFunc   ;==>_controller_downloadVariants


Func _controller_replaceVariant(ByRef $data, $input, $variantnumber, ByRef $fullJSON)
	$newJSON = _JSON_Parse($input)
	$check = _checkVariant($newJSON)
	If IsString($check) Then
		Return SetError(1, 0, $check) ; variant not valid
	EndIf
	$fullJSON[$variantnumber - 1] = $newJSON
	updateJSONVariants($data, $fullJSON)
	Return True
EndFunc   ;==>_controller_replaceVariant



Func _controller_trigger(ByRef $data, $code = False)
	If Not $code Then
		_optionsOrTriggers($data, 3)
		Return
	EndIf
	If Not StringInStr($code, "\:\]") Then
		Return SetError(1)
	EndIf

	_optionsOrTriggers($data, 2, $code)
EndFunc   ;==>_controller_trigger
