#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <GuiComboBox.au3>
#include <include\pgnRepository.au3>
#include <include\moreArray.au3>
#include <debug.au3>
Func cb($Param, $list)
	Return $Param & ": " & $list[$Param]
EndFunc   ;==>cb
Func pgneditForm(ByRef $pgnData)
	Local $moveIndex, $fenIndex, $tagIndex, $tagsselected = False, $fenselected = False, $movesselected = False
	Local $tags = _map(MapKeys($pgnData["tags"]), "cb", $pgnData["tags"])
	_DebugOut(_JSON_generate($pgnData))
	Local $selectedTag = $pgnData["tags"][MapKeys($pgnData["tags"])[0]]
	$fPgnEditor = GUICreate("Pgn Editor", 518, 220, 538, 544)
	GUICtrlCreateGroup("[] Tags", 8, 8, 505, 57)
	$Input1 = GUICtrlCreateInput("", 16, 52, 449, 21)
	$bTagSet = GUICtrlCreateButton("Set", 472, 40, 35, 25)
	$cTags = GUICtrlCreateCombo("Tags", 16, 24, 449, 25, BitOR($WS_VSCROLL, $CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData($cTags, _ArrayToString($tags))
	GUICtrlCreateGroup("Fens", 8, 77, 505, 57)
	$Input2 = GUICtrlCreateInput("", 16, 118, 449, 21)
	$bfenSet = GUICtrlCreateButton("Set", 475, 104, 35, 25)
	$cFens = GUICtrlCreateCombo("Fens", 16, 93, 449, 25, BitOR($WS_VSCROLL, $CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData($cFens, _ArrayToString($pgnData["fen"]))
	GUICtrlCreateGroup("Moves", 8, 148, 505, 57)
	$Input3 = GUICtrlCreateInput("", 16, 192, 449, 21)
	$bMoveSet = GUICtrlCreateButton("Set", 472, 160, 35, 25)
	$cMoves = GUICtrlCreateCombo("Moves", 16, 164, 449, 25, BitOR($WS_VSCROLL, $CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData($cMoves, _ArrayToString($pgnData["moves"]))
	GUISetState(@SW_SHOW, $fPgnEditor)

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				GUIDelete($fPgnEditor)
				Return

			Case $bTagSet
				$tagKey = StringSplit(GUICtrlRead($cTags), ": ", 3)[0]
				$pgnData["tags"][$tagKey] = GUICtrlRead($Input1)
				$tagIndex = _GUICtrlComboBox_GetCurSel($cTags)
				_GUICtrlComboBox_DeleteString($cTags, $tagIndex)
				_GUICtrlComboBox_InsertString($cTags, $tagKey & ": " & GUICtrlRead($Input1), $tagIndex)
				_GUICtrlComboBox_SetCurSel($cTags, $tagIndex)
				_DebugOut(_JSON_generate($pgnData))

			Case $bfenSet
				$fenIndex = _GUICtrlComboBox_GetCurSel($cFens)
				If _MapArraySet($pgnData, "fen", $fenIndex, GUICtrlRead($Input2)) Then
					_GUICtrlComboBox_DeleteString($cFens, $fenIndex)
					_GUICtrlComboBox_InsertString($cFens, GUICtrlRead($Input2), $fenIndex)
					_GUICtrlComboBox_SetCurSel($cFens, $fenIndex)
				EndIf

			Case $bMoveSet
				$moveIndex = _GUICtrlComboBox_GetCurSel($cMoves)
				If _MapArraySet($pgnData, "moves", $moveIndex, GUICtrlRead($Input3)) Then
					_GUICtrlComboBox_DeleteString($cMoves, $moveIndex)
					_GUICtrlComboBox_InsertString($cMoves, GUICtrlRead($Input3), $moveIndex)
					_GUICtrlComboBox_SetCurSel($cMoves, $moveIndex)
				EndIf

			Case $cTags
				If GUICtrlRead($cTags) = "Tags" Then ContinueLoop
				$read = GUICtrlRead($cTags)
				If Not $tagsselected Then
					$tagsselected = True
					GUICtrlSetData($cTags, "")
					GUICtrlSetData($cTags, _ArrayToString($tags), $read)
				EndIf
				GUICtrlSetData($Input1, $pgnData["tags"][StringSplit($read, ": ", 3)[0]])

			Case $cFens
				If GUICtrlRead($cFens) = "Fens" Then ContinueLoop
				$read = GUICtrlRead($cFens)
				If Not $fenselected Then
					$fenselected = True
					GUICtrlSetData($cFens, "")
					GUICtrlSetData($cFens, _ArrayToString($pgnData["fen"]), $read)
				EndIf
				GUICtrlSetData($Input2, $read)
			Case $cMoves
				If GUICtrlRead($cMoves) = "Moves" Then ContinueLoop
				$read = GUICtrlRead($cMoves)
				If Not $movesselected Then
					$movesselected = True
					GUICtrlSetData($cMoves, "")
					GUICtrlSetData($cMoves, _ArrayToString($pgnData["moves"]), $read)
				EndIf

				$moveIndex = _GUICtrlComboBox_GetCurSel($cMoves)
				If $moveIndex >= 0 Then GUICtrlSetData($Input3, $read)
		EndSwitch
	WEnd
EndFunc   ;==>pgneditForm



