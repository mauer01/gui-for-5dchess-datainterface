#include-once
#include <datainterfaceService.au3>
#include <multiversechess.au3>
Func _controller_changeTimer(ByRef $data, $time, $delay, $type)
	If $type <> "L" And $type <> "M" And $type <> "S" Then
		Return SetError(1, 0, 0)
	EndIf
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
	If $setting < 1 Or $setting > 3 Then
		Return SetError(1, 0, 0)
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
		Return SetError(1, 0, 0) ; game not running
	EndIf
EndFunc   ;==>_controller_runPGN



Func _controller_addVariant(ByRef $data, $multiverse)
	If Not MapExists($multiverse, "Name") Then
		Return SetError(1, 0, 0) ; name missing
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
				Return SetError(1, 0, 0) ; variant file not found in cached urls
			EndIf
		EndIf
		If Not _some($data["remoteJsonUrls"], "_someStringinStringcallback", $variantfiles) Then
			Return SetError(2, 0, 0) ; some variant file not found in cached urls
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
