#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%


Clip(Text="", Reselect="")
{
    /*
        The following has been stolen from https://github.com/berban/Clip/blob/master/Clip.ahk
    */
	Static BackUpClip, Stored, LastClip
	If (A_ThisLabel = A_ThisFunc) {
		If (Clipboard == LastClip)
			Clipboard := BackUpClip
		BackUpClip := LastClip := Stored := ""
	} Else {
		If !Stored {
			Stored := True
			BackUpClip := ClipboardAll ; ClipboardAll must be on its own line
		} Else
			SetTimer, %A_ThisFunc%, Off
		LongCopy := A_TickCount, Clipboard := "", LongCopy -= A_TickCount ; LongCopy gauges the amount of time it takes to empty the clipboard which can predict how long the subsequent clipwait will need
		If (Text = "") {
			SendInput, ^c
			ClipWait, LongCopy ? 0.6 : 0.2, True
		} Else {
			Clipboard := LastClip := Text
			ClipWait, 10
			SendInput, ^v
		}
		SetTimer, %A_ThisFunc%, -700
		Sleep 20 ; Short sleep in case Clip() is followed by more keystrokes such as {Enter}
		If (Text = "")
			Return LastClip := Clipboard
		Else If ReSelect and ((ReSelect = True) or (StrLen(Text) < 3000))
			SendInput, % "{Shift Down}{Left " StrLen(StrReplace(Text, "`r")) "}{Shift Up}"
	}
	Return
	Clip:
	Return Clip()
}

Clipnt()
{
    /*
        1. Takes previous clipboard copy and stores it
        2. Uses current selection (storing in clipboard in the process)
        3. returning clipboard to original data
    */
    static previousClip, postClip
    
    previousClip := clipboard
    clipboard := ""

    LongCopy := A_TickCount, Clipboard := "", LongCopy -= A_TickCount ; stolen from clip()

    SendInput, ^c
    ClipWait, LongCopy ? 0.6 : 0.2, True ; stolen from Clip()
    if ErrorLevel {
        MsgBox, The attempt to copy text onto the clipboard failed.
        return 
    }

    postClip := clipboard
    clipboard := ""
    clipboard := previousClip

    Return postClip


}
+.::

MsgBox, % "Clipnt: " Clipnt()

; selected := Clip()
; board := Clipboard
; msgbox, % "Selected Text:\n" selected "\nboard:\n" board
; Run, https://www.autohotkey.com/

return

+Esc::
ExitApp, 21