
#include-once
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
