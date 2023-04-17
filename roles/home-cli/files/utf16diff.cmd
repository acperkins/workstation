@ECHO OFF
REM Add "*.ps1 diff=utf16diff" to ~/.config/git/attributes to use this.
powershell.exe -Command "%~dp0\utf16diff.ps1" "%1"
