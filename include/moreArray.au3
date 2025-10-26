
#include-once
#include <Array.au3>
#include <JSON.au3>
Func _some(ByRef $list, $callback, $arg)
	For $item In $list
		If Call($callback, $item, $arg) Then
			Return True
		EndIf
	Next
	Return False
EndFunc   ;==>_some

Func _arrayinarray($array1, $array2)
	If UBound($array2) > UBound($array1) Then Return False
	For $item In $array2
		If Not _some($array1, "_equalityCallback", $item) Then
			Return False
		EndIf
	Next
	Return True
EndFunc   ;==>_arrayinarray

Func _equalityCallback($a, $b)
	Return $a = $b
EndFunc   ;==>_equalityCallback

Func _find($list, $callback, $arg)

	For $item In $list
		If Call($callback, $item, $arg) Then
			Return $item
		EndIf
	Next
	Return SetError(1, 0, 0)
EndFunc   ;==>_find

Func _every($list, $callback, $arg)
	For $item In $list
		If Not Call($callback, $item, $arg) Then
			Return False
		EndIf
	Next
	Return True
EndFunc   ;==>_every

Func _forEach($list, $callback, $arg = "")
	For $item In $list
		$msg = Call($callback, $item, $arg)
		If @error Then Return SetError(@error, 0, _JSON_generate($item) & ": " & $msg)
	Next
EndFunc   ;==>_forEach

Func _arrayCountEquals($array1, $array2)
	If UBound($array1) <> UBound($array2) Then Return False
	For $item In $array1
		If Not _some($array2, "_equalityCallback", $item) Then
			Return False
		EndIf
	Next
	Return True
EndFunc   ;==>_arrayCountEquals

Func _someStringinStringcallback($e, $string)
	Return _some($e, "stringinstr", $string)
EndFunc   ;==>_someStringinStringcallback


Func _map($list, $callback, $arg = "")
	Local $newList[0]
	If Not IsArray($list) Or UBound($list) = 0 Then Return SetError(1, 0, "_map: first argument is not an array")
	For $item In $list
		_ArrayAdd($newList, Call($callback, $item, $arg))
	Next
	Return $newList
EndFunc   ;==>_map

Func _filter($list, $callback, $arg = "")
	Local $newList[]
	If Not IsMap($list) Then
		$list = _arraytoMap($list)
	EndIf
	$keys = MapKeys($list)
	For $i = 0 To UBound($list) - 1
		If Call($callback, $list[$keys[$i]], $arg) Then
			$newList[$keys[$i]] = $list[$keys[$i]]
		EndIf
	Next
	Return $newList
EndFunc   ;==>_filter

Func _arraytoMap($array)
	Local $map[]
	For $item In $array
		MapAppend($map, $item)
	Next
	Return $map
EndFunc   ;==>_arraytoMap


Func _multidimfind($array, $callback, $arg = "")

	For $i = 0 To UBound($array) - 1
		For $j = 0 To UBound($array, 2) - 1
			If Call($callback, $array[$i][$j], $arg) Then

				Return $array[$i][$j + 1]
			EndIf
		Next
	Next
	Return SetError(1, 0, 0)
EndFunc   ;==>_multidimfind


Func _twodimarraytoMap($array)
	Local $map[]
	For $i = 0 To UBound($array) - 1
		$map[$array[$i][0]] = $array[$i][1]
	Next
	Return $map
EndFunc   ;==>_twodimarraytoMap


Func _newMap()
	Local $map[]
	Return $map
EndFunc   ;==>_newMap

Func _newArray()
	Local $__emptyArray[0] = []
	Return $__emptyArray
EndFunc   ;==>_newArray


Func _isLastOne($item, ByRef $array)
	If IsArray($array) Then
		Return $array[UBound($array) - 1] = $item
	EndIf
	If IsMap($array) Then
		Return $item = _MapValues($array)[UBound(_MapValues($array)) - 1]
	EndIf
EndFunc   ;==>_isLastOne

Func _MapValues(ByRef $map)
	Local $values[0]
	For $key In MapKeys($map)
		_ArrayAdd($values, $map[$key])
	Next
	Return $values
EndFunc   ;==>_MapValues


Func _MapArraySet(ByRef $map, $key, $idx, $val) ; Autoit is FUN
	Local $arr = $map[$key]
	If IsArray($arr) And $idx >= 0 And $idx < UBound($arr) Then
		$arr[$idx] = $val
		$map[$key] = $arr
		Return True
	EndIf
	Return False
EndFunc   ;==>_MapArraySet
