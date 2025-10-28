#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <include\JSON.au3>
#include <include\moreArray.au3>
Func jsonEditForm($jsondata, $parentwin = 0)
	GUISetState(@SW_DISABLE, $parentwin)
	#Region ### START Koda GUI section ### Form=D:\5d chess\scripts\gui-for-5dchess-datainterface\kodaForms\fJsonEdit.kxf
	$fJsonEdit = GUICreate("quick json editor", 615, 437, 192, 164, -1, -1, $parentwin)
	$Edit1 = GUICtrlCreateEdit("", 16, 8, 593, 393)
	GUICtrlSetData(-1, _JSON_generate($jsondata))
	$Button1 = GUICtrlCreateButton("Save", 16, 408, 75, 25)
	$Button2 = GUICtrlCreateButton("Rename", 96, 408, 75, 25)
	$label = GUICtrlCreateLabel("Rename will replace the old variant even if it has a new name", 180, 410, 400, 20)
	GUISetState(@SW_SHOW)
	#EndRegion ### END Koda GUI section ###
	While 1
		$nMsg = GUIGetMsg($fJsonEdit)
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				$ms = MsgBox(3, "Close", "Are you sure you want to close without saving?") = 6
				If Not $ms Then
					ContinueLoop
				EndIf
				$i = 0
				$return = False
				ExitLoop

			Case $Button1
				$return = _JSON_Parse(GUICtrlRead($Edit1))
				$i = 0
				ExitLoop

			Case $Button2
				$return = _JSON_Parse(GUICtrlRead($Edit1))
				$i = 1
				ExitLoop

		EndSwitch
	WEnd
	GUIDelete($fJsonEdit)
	GUISetState(@SW_RESTORE, $parentwin)
	GUISetState(@SW_ENABLE, $parentwin)
	Return SetExtended($i, $return)
EndFunc   ;==>jsonEditForm
