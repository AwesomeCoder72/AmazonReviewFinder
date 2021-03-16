#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

/*
    https://github.com/berban/Clip/blob/master/Clip.ahk

    Clip() Source
*/

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

    LongCopy := A_TickCount, Clipboard := "", LongCopy -= A_TickCount ; stolen from Clip()

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
^.::

selection := Clipnt()

selectionList := StrSplit(selection, A_Space)

baseURL := "https://www.amazon.com/s?k="

fullUrl := baseURL

for index, element in selectionList
{
    fullURL .= element
    fullURL .= "+"
}

; above concatened selection into amazon URL

Run, %fullUrl% ; opens amazon url in new chrome tab

; https://www.amazon.com/s?k=search+bar

return

+Esc:: ; escape code: shift+esc otherwise just end script as usual
ExitApp, 1