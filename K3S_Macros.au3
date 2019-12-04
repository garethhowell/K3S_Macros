#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=elecraft_qLx_2.ico
#AutoIt3Wrapper_Outfile_x64=c:\M5KVK\K3S_Macros.exe
#AutoIt3Wrapper_Res_Description=A set of macros to allow a Griffin Powermate to K3S control an Elecraft K3S transceiver
#AutoIt3Wrapper_Res_Fileversion=1.0.0.11
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#comments-start
This script written by Gareth Howell (M5KVK) but based heavily on a similar one by
Iain Kelly (M0PCB) for a ShuttlePro

Send Macro commands to an Elecraft K3 Transceiver on COMPORT 18 at 38400Baud 8N1 using Key combinations.
Powermate is connected via USB and configured (using the Powermate utility) to send keypad keys as follows:
  Right - CTRL-RIGHT - tune up in current step
  Left - CTRL-LEFT - tune down in current step
  Push - CTRL-UP - change to next higher tuning step
  Push and hold - CTRL_DOWN - change to lowest tuning step

Tuning steps are 1Hz, 10Hz, 100Hz, 1kHz, 5kHz

Pre-requisites
- Powermate utility must be installed and running (can be auto-started on boot)
- In my environment, radio is controlled by Win4K3Suite. W4K3S is configured to deliver COM18

#comments-end
#include "CommMG64.au3"
#include <String.au3>
#include <Array.au3>

Global $error, $rawfreq, $freq, $mode, $baud, $comport, $apfstate, $ic

$comport = 18
$baud = 38400
CONST $tuningSteps[5] = [1, 10, 100, 1000, 5000]
$tuningStepIndex = 0

_CommSetDllPath("C:\M5KVK\commg64.dll")

HotKeySet("^!{F12}", "_Exit") ;If you press Ctrl-Shift-F12 the script will stop
HotKeySet("+{F1}", "_ShowMacros") ;If you press SHIFT + F1, the script will show witch sites you have on witch keys
HotKeySet("^{RIGHT}", "_TuneVFOAUp")
HotKeySet("^{LEFT}", "_TuneVFOADown")
HotKeySet("^{UP}", "_NextTuningStepUp")
HotKeySet("^{DOWN}", "_LowestTuningStep")

While 1
Sleep(100)
WEnd

Func _Exit()
Sleep(100)
Exit
EndFunc ;==> _Exit()

Func _ShowMacros()
MsgBox(0, "M5KVK's K3S Controller / Macro Sender V2", "To Exit use Ctrl-Alt-F12")
EndFunc

Func _TuneVFOAUp()
	Switch $tuningStepIndex
		Case 0
			_TuneAUp1Hz()
		Case 1
			_TuneAup10Hz()
		Case 2
			_TuneAup100Hz()
		Case 3
			_TuneAup1kHz()
		Case 4
			_TuneAup5kHz()
	EndSwitch
EndFunc

Func _TuneVFOADown()
	Switch $tuningStepIndex
		Case 0
			_TuneAdwn1Hz()
		Case 1
			_TuneAdwn10Hz()
		Case 2
			_TuneAdwn100Hz()
		Case 3
			_TuneAdwn1kHz()
		Case 4
			_TuneAdwn5kHz()
	EndSwitch
EndFunc

Func _NextTuningStepUp()
	$tuningStepIndex = $tuningStepIndex + 1
	If $tuningStepIndex = 4 Then $tuningStepIndex = 0
EndFunc

Func _LowestTuningStep()
	$tuningStepIndex = 0
EndFunc

Func _TuneAup1Hz()
   _CommSetPort($comport, $error, $baud, 8, 0, 1, 2, 3, 2)
   _CommSendString("UP0;", 0)
   _CommCloseport()
   EndFunc

Func _TuneAup10Hz()
   _CommSetPort($comport, $error, $baud, 8, 0, 1, 2, 3, 2)
   _CommSendString("UP1;", 0)
   _CommCloseport()
   EndFunc

Func _TuneAup100Hz()
   _CommSetPort($comport, $error, $baud, 8, 0, 1, 2, 3, 2)
   _CommSendString("UP8;", 0)
   _CommCloseport()
EndFunc

Func _TuneAup1kHz()
   _CommSetPort($comport, $error, $baud, 8, 0, 1, 2, 3, 2)
   _CommSendString("UP4;", 0)
   _CommCloseport()
EndFunc

Func _TuneAup5kHz()
   _CommSetPort($comport, $error, $baud, 8, 0, 1, 2, 3, 2)
   _CommSendString("UP7;", 0)
   _CommCloseport()
EndFunc

Func _TuneAdwn1Hz()
   _CommSetPort($comport, $error, $baud, 8, 0, 1, 2, 3, 2)
   _CommSendString("DN0;", 0)
   _CommCloseport()
EndFunc

Func _TuneAdwn10Hz()
   _CommSetPort($comport, $error, $baud, 8, 0, 1, 2, 3, 2)
   _CommSendString("DN1;", 0)
   _CommCloseport()
EndFunc

Func _TuneAdwn100Hz()
   _CommSetPort($comport, $error, $baud, 8, 0, 1, 2, 3, 2)
   _CommSendString("DN8;", 0)
   _CommCloseport()
EndFunc

Func _TuneAdwn1KHz()
   _CommSetPort($comport, $error, $baud, 8, 0, 1, 2, 3, 2)
   _CommSendString("DN4;", 0)
   _CommCloseport()
EndFunc

Func _TuneAdwn5kHz()
   _CommSetPort($comport, $error, $baud, 8, 0, 1, 2, 3, 2)
   _CommSendString("DN7;",0)
   _CommCloseport()
EndFunc
