# Put this in the location of $PROFILE. For PowerShell 5+ this is either
#   C:\Users\USERNAME\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1
# or
#   C:\Users\USERNAME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1

function Prompt {
    if ($IsWindows -or $PSVersionTable.PSVersion -lt [System.Version]"6.0") {
        $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
        if ($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
            $env:USERNAME + "@" + $env:COMPUTERNAME.ToLower() + "# "
        } else {
            $env:USERNAME + "@" + $env:COMPUTERNAME.ToLower() + "> "
        }
    }
    elseif ($IsLinux) {
        "`e[1m" + $(id -un) + "@" + $(hostname -s) + "> `e[0m"
    }
}

function ADUserInfo {
    Param (
        [Parameter(Mandatory=$true)] [string]$User
    )
    Import-Module ActiveDirectory -ErrorAction Stop
    $ADPropertiesCommon = @(
        'SamAccountName'
        'UserPrincipalName'
        'DisplayName'
        'Enabled'
        'PasswordExpired'
        'LockedOut'
        'CannotChangePassword'
        'PasswordNeverExpires'
        'GivenName'
        'Surname'
        'DistinguishedName'
        'EmployeeID'
        'PersonalPager'
        'Title'
        'Division'
        'Department'
        'Created'
        'Modified'
        'PasswordLastSet'
    )
    $ADPropertiesGetOnly = @(
        'msDS-UserPasswordExpiryTimeComputed'
    )
    $ADPropertiesPrintOnly = @(
        @{Name="PasswordExpiresDate";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}}
    )
    $ADPropertiesGet = $ADPropertiesCommon + $ADPropertiesGetOnly
    $ADPropertiesPrint = $ADPropertiesCommon + $ADPropertiesPrintOnly
    Get-ADUser -Properties $ADPropertiesGet -Identity $User | Select-Object -Property $ADPropertiesPrint
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

if ($PSVersionTable.PSVersion -ge [System.Version]"7.2") {
    $AnsiReset = "`e[0m"
    Set-PSReadLineOption -Colors @{
        Default = $AnsiReset;
        Command = $AnsiReset;
        Comment = $AnsiReset;
        ContinuationPrompt = $AnsiReset;
        Emphasis = $AnsiReset;
        Error = $AnsiReset;
        InlinePrediction = $AnsiReset;
        Keyword = $AnsiReset;
        Member = $AnsiReset;
        Number = $AnsiReset;
        Operator = $AnsiReset;
        Parameter = $AnsiReset;
        Selection = $AnsiReset;
        String = $AnsiReset;
        Type = $AnsiReset;
        Variable = $AnsiReset;
    }
}
