;; vimify
;; https://github.com/efskap/Vimify/

F13:: ; <- hotkey
tmp := A_Temp . "\.vimify.tmp"
StringReplace, tmp, tmp, \, /, All
FileDelete, %tmp%
ClipSaved := ClipboardAll       ;save clipboard
clipboard := ""  ; empty clipboard
Send, ^c ; copy text
ClipWait, 0.2		; wait for the clipboard to contain data
if (ClipSaved == clipboard Or (!ErrorLevel And text_selected)) ; !ErrorLevel => clipwait found data
{
FileAppend, %clipboard%, %tmp% ; save to temp file
}
params := "vim -b " . tmp . " +0" ; command to open temp file in vim with the cursor at the start

clipboard := ClipSaved ; restore clipboard while vim is running

RunWait, %params% ; run vim

ClipSaved := ClipboardAll
clipboard := ""

FileRead, clipboard_temp, %tmp% ; read back temp file
unchanged := (clipboard_temp == clipboard) ; true if the file wasn't changed
clipboard := clipboard_temp 
if (!unchanged) ; if the file was changed
Send, ^v ; paste it
Sleep, 90
clipboard := ClipSaved       ; restore original clipboard
ClipSaved := ""   ;  free the memory in case the clipboard was very large.
FileDelete, %tmp% ; delete temp file
return

OnClipboardChange:
if(A_EventInfo=1)
{
text_selected := true
}
else
text_selected := false
return