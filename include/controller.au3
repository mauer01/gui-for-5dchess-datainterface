#include-once
#include <datainterfaceService.au3>
#include <moreArray.au3>
#include <multiversechess.au3>

Func _frontController(ByRef $context, ByRef $mainGui)
	Local $nMsg, $msg

	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case -3
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
		Case $mainGui["settings"]["cClocks"]
			Local $settingmap = _newMap()
			$type = GUICtrlRead($mainGui["settings"]["cClocks"])
			$keys = MapKeys($context["data"]["settings"])
			$settingmap["S"] = _newMap()
			$settingmap["S"]["timer"] = $keys[1]
			$settingmap["S"]["increment"] = $keys[2]
			$settingmap["M"] = _newMap()
			$settingmap["M"]["timer"] = $keys[3]
			$settingmap["M"]["increment"] = $keys[4]
			$settingmap["L"] = _newMap()
			$settingmap["L"]["timer"] = $keys[5]
			$settingmap["L"]["increment"] = $keys[6]

			GUICtrlSetData($mainGui["settings"]["iClockTime"], $context["data"]["settings"][$settingmap[$mainGui["settings"]["Timers"][$type]]["timer"]])
			GUICtrlSetData($mainGui["settings"]["iClockDelay"], $context["data"]["settings"][$settingmap[$mainGui["settings"]["Timers"][$type]]["increment"]])
		Case $mainGui["settings"]["bClockSet"]
			Local $time = GUICtrlRead($mainGui["settings"]["iClockTime"])
			Local $delay = GUICtrlRead($mainGui["settings"]["iClockDelay"])
			Local $type = GUICtrlRead($mainGui["settings"]["cClocks"])
			If Not _some(MapKeys($mainGui["settings"]["Timers"]), "stringinstr", $type) = -1 Then
				MsgBox(16, "Error", "Choose a valid clock type.")
				Return
			EndIf
			$msg = _controller_changeTimer($context, $mainGui["settings"]["Timers"][$type], $time, $delay)
			If @error Then
				MsgBox(16, "Error", $msg)
				Return
			EndIf

		Case $mainGui["settings"]["bClockReset"]
			Local $type = GUICtrlRead($mainGui["settings"]["cClocks"])
			$msg = _controller_changeTimer($context, $mainGui["settings"]["Timers"][$type], "reset", "reset")
			If @error = 1 Then MsgBox(16, "Error", "Select a Clock Type to reset.")
		Case $mainGui["settings"]["cbUndoMove"]
			_controller_undoMoveToggle($context["data"])
		Case $mainGui["settings"]["cbRestartGameOnCrash"]
		Case $mainGui["settings"]["rAnimationsAlwaysOn"]
			_controller_animationSetting($context["data"], "on")
		Case $mainGui["settings"]["rAnimationsAlwaysOff"]
			_controller_animationSetting($context["data"], "off")
		Case $mainGui["settings"]["rAnimationsIgnore"]
			_controller_animationSetting($context["data"], "ignore")
		Case $mainGui["settings"]["bInsertCode"]
			_controller_trigger($context["data"], ClipGet())
		Case $mainGui["settings"]["bResumeGame"]
			_controller_trigger($context["data"])
		Case $mainGui["pgn"]["bPgnAdd"]
		Case $mainGui["pgn"]["bPgnOpenPath"]
		Case $mainGui["pgn"]["cPgnList"]
		Case $mainGui["pgn"]["bPgnRun"]
		Case $mainGui["pgn"]["bPgnRemove"]
		Case $mainGui["pgn"]["bPgnEdit"]
		Case $mainGui["pgn"]["bPgnAddClipboard"]
	EndSwitch
	If @error Then Return SetError(@error, 0, "uncaught error" & @CRLF & "Potentially an Errormessage: " & $msg)
	Return
EndFunc   ;==>_frontController

Func _controller_changeTimer(ByRef $context, $type, $time = Null, $delay = Null)
	Local $data = $context["data"]
	Local $except[2] = ["reset", ":"]
	If $type <> "L" And $type <> "M" And $type <> "S" Then
		Return SetError(1, 0, "Type must be L, M, or S")
	EndIf
	_checkString($time, $except)
	If @error Then Return SetError(2, 0, "Time is not in either a : split format or in milliseconds or reset")
	_checkString($delay, $except)
	If @error Then Return SetError(3, 0, "Delay is not in either a : split format or in milliseconds or reset")
	Local $map[], $settingmap[]
	$map["L"] = 6
	$map["M"] = 4
	$map["S"] = 2
	$keys = MapKeys($context["data"]["settings"])
	$settingmap["S"] = _newMap()
	$settingmap["S"]["timer"] = $keys[1]
	$settingmap["S"]["increment"] = $keys[2]
	$settingmap["M"] = _newMap()
	$settingmap["M"]["timer"] = $keys[3]
	$settingmap["M"]["increment"] = $keys[4]
	$settingmap["L"] = _newMap()
	$settingmap["L"]["timer"] = $keys[5]
	$settingmap["L"]["increment"] = $keys[6]
	If StringInStr($time, ":") Then
		$time = _timetoSeconds($time)
		If @error Then Return SetError(4, 0, "Time format invalid")
	EndIf

	If StringInStr($delay, ":") Then
		$delay = _timetoSeconds($delay)
		If @error Then Return SetError(5, 0, "Delay format invalid")
	EndIf
	$keyinc = $settingmap[$type]["increment"]
	$keytimer = $settingmap[$type]["timer"]
	If ($time And $delay) Then
		_settingOptions($data, $map[$type], $time)
		_waitForResponse($data, "Action executed. Returning to menu")
		_settingOptions($data, $map[$type] + 1, $delay)
		$context["data"]["settings"][$keytimer] = $time
		$context["data"]["settings"][$keyinc] = $delay
	ElseIf $time Then
		_settingOptions($data, $map[$type], $time)
		$context["data"]["settings"][$keytimer] = $time
	ElseIf $delay Then
		_settingOptions($data, $map[$type] + 1, $delay)
		$context["data"]["settings"][$keyinc] = $delay
	Else
		Return SetError(6, 0, "No time or delay provided")
	EndIf
EndFunc   ;==>_controller_changeTimer

Func _checkString($string, $exceptions = "")
	If $string = "" Then Return
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
	$map["ignore"] = 1
	$map["on"] = 2
	$map["off"] = 3
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
		Return SetError(1, 0, $check)         ; variant not valid
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



Func _timetoSeconds($time)
	Local $parts = StringSplit($time, ":")
	If $parts[0] = 2 Then
		Return ($parts[1] * 60) + $parts[2]
	ElseIf $parts[0] = 3 Then
		Return ($parts[1] * 3600) + ($parts[2] * 60) + $parts[3]
	Else
		Return SetError(1, 0, "time format invalid")
	EndIf
EndFunc   ;==>_timetoSeconds


