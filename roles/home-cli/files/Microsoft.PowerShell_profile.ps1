# Put this in the location of $PROFILE. For PowerShell 5+ this is either
#   C:\Users\USERNAME\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1
# or
#   C:\Users\USERNAME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1

function Prompt {
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    if ($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        $env:USERNAME + "@" + $env:COMPUTERNAME.ToLower() + "# "
    } else {
        $env:USERNAME + "@" + $env:COMPUTERNAME.ToLower() + "> "
    }
}

Set-Alias -Name json -Value ConvertTo-Json
Set-PSReadlineOption -BellStyle None
Set-PSReadlineOption -EditMode Emacs
Set-PSReadlineKeyHandler -Key Tab -Function Complete
Set-PSReadLineKeyHandler -Key UpArrow -ScriptBlock {
        [Microsoft.PowerShell.PSConsoleReadLine]::HistorySearchBackward()
        [Microsoft.PowerShell.PSConsoleReadLine]::EndOfLine()
}
Set-PSReadLineKeyHandler -Key DownArrow -ScriptBlock {
        [Microsoft.PowerShell.PSConsoleReadLine]::HistorySearchForward()
        [Microsoft.PowerShell.PSConsoleReadLine]::EndOfLine()
}
Set-PSReadLineKeyHandler -Chord Shift+Spacebar -Function SelfInsert
Set-PSReadLineKeyHandler -Chord Ctrl+LeftArrow -Function BackwardWord
Set-PSReadLineKeyHandler -Chord Ctrl+RightArrow -Function ForwardWord
Set-PSReadLineKeyHandler -Chord Ctrl+Backspace -Function BackwardKillWord
Set-PSReadLineKeyHandler -Chord Ctrl+Delete -Function KillWord
