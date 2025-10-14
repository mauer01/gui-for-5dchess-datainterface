#include-once
#include <datainterfaceService.au3>
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
