#include-once
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <TabConstants.au3>
#include <WindowsConstants.au3>
Func _MainGui($context)
	#Region ### START Koda GUI section ### Form=.\kodaForms\main.kxf
	Local $main = GUICreate($context["labels"]["main"], 604, 210, 1140, 268)
	Local $tab = GUICtrlCreateTab(0, 0, 601, 209)
	GUICtrlCreateTabItem($context["labels"]["tJsonLoader"])
	GUIStartGroup()
	Local $iJsonFileNewPath = GUICtrlCreateInput("", 8, 34, 225, 21)
	Local $bAddJsonFile = GUICtrlCreateButton($context["labels"]["bAddJsonFile"], 240, 32, 35, 25, $BS_PUSHLIKE)
	GUIStartGroup()
	GUIStartGroup()
	Local $cRemoteJsons = GUICtrlCreateCombo("", 8, 66, 225, 25, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL))
	Local $bRemoteJsonDownload = GUICtrlCreateButton($context["labels"]["bRemoteJsonDownload"], 240, 64, 67, 25)
	GUIStartGroup()
	GUIStartGroup()
	Local $cLocalJsonFiles = GUICtrlCreateCombo("", 8, 98, 225, 25, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL))
	Local $bLocalJsonFileRemove = GUICtrlCreateButton($context["labels"]["bLocalJsonFileRemove"], 240, 96, 50, 25)
	Local $bLocalJsonFileCopy = GUICtrlCreateButton($context["labels"]["bLocalJsonFileCopy"], 294, 96, 50, 25)
	Local $bLocalJsonFileRename = GUICtrlCreateButton($context["labels"]["bLocalJsonFileRename"], 348, 96, 50, 25)
	Local $bLocalJsonFileBackup = GUICtrlCreateButton($context["labels"]["bLocalJsonFileBackup"], 402, 96, 50, 25)
	Local $bOpenJsonFolder = GUICtrlCreateButton($context["labels"]["bOpenJsonFolder"], 456, 96, 75, 25)
	GUIStartGroup()
	GUIStartGroup()
	Local $cListOfVariants = GUICtrlCreateCombo("", 8, 130, 225, 25, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL))
	Local $bRunVariant = GUICtrlCreateButton($context["labels"]["bRunVariant"], 240, 128, 43, 25)
	Local $bVariantRemove = GUICtrlCreateButton($context["labels"]["bVariantRemove"], 288, 128, 59, 25)
	Local $bVariantEdit = GUICtrlCreateButton($context["labels"]["bVariantEdit"], 352, 128, 43, 25)
	GUIStartGroup()
	GUIStartGroup()
	Local $bAddVariantfromClip = GUICtrlCreateButton($context["labels"]["bAddVariantfromClip"], 168, 160, 75, 25)
	GUICtrlCreateLabel($context["labels"]["laddSpecifier"], 16, 165, 146, 17)
	Local $bAddVariantFromFile = GUICtrlCreateButton($context["labels"]["bAddVariantFromFile"], 248, 160, 59, 25)
	Local $baddVariantsFromJsonFile = GUICtrlCreateButton($context["labels"]["baddVariantsFromJsonFile"], 312, 160, 115, 25)
	GUIStartGroup()
	GUICtrlCreateTabItem($context["labels"]["tSettings"])
	GUIStartGroup()
	Local $cClocks = GUICtrlCreateCombo($context["labels"]["cClocks"], 8, 32, 145, 25, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, $context["labels"]["cClocksChoices"])
	Local $iClockTime = GUICtrlCreateInput($context["labels"]["iClockTime"], 8, 56, 65, 21)
	Local $iClockDelay = GUICtrlCreateInput($context["labels"]["iClockDelay"], 88, 56, 65, 21)
	Local $bClockSet = GUICtrlCreateButton($context["labels"]["bClockSet"], 160, 56, 51, 25)
	Local $bClockReset = GUICtrlCreateButton($context["labels"]["bClockReset"], 160, 32, 91, 25)
	GUICtrlCreateLabel($context["labels"]["Label1"], 76, 58, 10, 17)
	GUIStartGroup()
	GUIStartGroup()
	Local $cbUndoMove = GUICtrlCreateCheckbox($context["labels"]["cbUndoMove"], 8, 96, 89, 17)
	Local $cbRestartGameOnCrash = GUICtrlCreateCheckbox($context["labels"]["cbRestartGameOnCrash"], 8, 112, 129, 17)
	GUIStartGroup()
	GUIStartGroup()
	GUICtrlCreateLabel($context["labels"]["lTravelAnimations"], 264, 96, 91, 17)
	Local $rAnimationsAlwaysOn = GUICtrlCreateRadio($context["labels"]["rAnimationsAlwaysOn"], 280, 112, 113, 17)
	Local $rAnimationsAlwaysOff = GUICtrlCreateRadio($context["labels"]["rAnimationsAlwaysOff"], 280, 128, 113, 17)
	Local $rAnimationsIgnore = GUICtrlCreateRadio($context["labels"]["rAnimationsIgnore"], 280, 144, 113, 17)
	GUIStartGroup()
	GUIStartGroup()
	Local $bInsertCode = GUICtrlCreateButton($context["labels"]["bInsertCode"], 144, 96, 107, 25)
	Local $bResumeGame = GUICtrlCreateButton($context["labels"]["bResumeGame"], 144, 120, 107, 25)
	GUIStartGroup()
	GUICtrlCreateTabItem($context["labels"]["tPgnLoader"])
	GUICtrlSetState(-1, $GUI_SHOW)
	GUIStartGroup()
	Local $iPgnLoaderPath = GUICtrlCreateInput("", 8, 32, 217, 21)
	Local $bPgnAdd = GUICtrlCreateButton($context["labels"]["bPgnAdd"], 232, 32, 51, 25)
	Local $bPgnOpenPath = GUICtrlCreateButton($context["labels"]["bPgnOpenPath"], 288, 32, 75, 25)
	GUIStartGroup()
	GUIStartGroup()
	Local $bPgnAddClipboard = GUICtrlCreateButton($context["labels"]["bPgnAddClipboard"], 8, 64, 107, 25)
	GUIStartGroup()
	GUIStartGroup()
	Local $cPgnList = GUICtrlCreateCombo($context["labels"]["cPgnList"], 8, 96, 217, 25, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL))
	Local $bPgnRun = GUICtrlCreateButton($context["labels"]["bPgnRun"], 232, 96, 51, 25)
	Local $bPgnRemove = GUICtrlCreateButton($context["labels"]["bPgnRemove"], 288, 96, 51, 25)
	Local $bPgnEdit = GUICtrlCreateButton($context["labels"]["bPgnEdit"], 344, 96, 43, 25)
	GUIStartGroup()
	GUISetState(@SW_SHOW)
	#EndRegion ### END Koda GUI section ###

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				Exit

			Case $main
			Case $tab
			Case $bAddJsonFile
			Case $bAddVariantfromClip
			Case $bAddVariantFromFile
			Case $cRemoteJsons
			Case $bRemoteJsonDownload
			Case $cLocalJsonFiles
			Case $bLocalJsonFileRemove
			Case $bLocalJsonFileCopy
			Case $bLocalJsonFileRename
			Case $bLocalJsonFileBackup
			Case $bOpenJsonFolder
			Case $bRunVariant
			Case $bVariantRemove
			Case $bVariantEdit
			Case $baddVariantsFromJsonFile
			Case $bClockSet
			Case $bClockReset
			Case $cbUndoMove
			Case $cbRestartGameOnCrash
			Case $rAnimationsAlwaysOn
			Case $rAnimationsAlwaysOff
			Case $rAnimationsIgnore
			Case $bInsertCode
			Case $bResumeGame
			Case $bPgnAdd
			Case $bPgnOpenPath
			Case $cPgnList
			Case $bPgnRun
			Case $bPgnRemove
			Case $bPgnEdit
			Case $bPgnAddClipboard
		EndSwitch
	WEnd
EndFunc   ;==>_MainGui
