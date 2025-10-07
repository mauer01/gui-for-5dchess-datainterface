
#include-once
#include <Array.au3>
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
		Call($callback, $item, $arg)
		If @error Then Return SetError(@error)
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
	Return _some($e, "_stringinstringcallback", $string)
EndFunc   ;==>_someStringinStringcallback


Func _map($list, $callback, $arg = "")
	Local $newList[0]
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
