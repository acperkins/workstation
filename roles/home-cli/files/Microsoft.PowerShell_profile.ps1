# Put this in the location of $PROFILE. For PowerShell 5+ this is either
#   C:\Users\USERNAME\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1
# or
#   C:\Users\USERNAME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1

function Prompt {
    if ($IsWindows -or ($env:OS -eq "Windows_NT")) {
        $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
        if ($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
            return "${env:USERNAME}@$(${env:COMPUTERNAME}.ToLower())# "
        } else {
            return "${env:USERNAME}@$(${env:COMPUTERNAME}.ToLower())> "
        }
    } elseif ($IsLinux) {
        return "$(id -un)@$(hostname -s)> "
    } else {
        return "PS> "
    }
}

function ADUserInfo {
    param (
        [Parameter(Mandatory)]
        [string]$User
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
        'Title'
        'Department'
        'Created'
        'Modified'
        'PasswordLastSet'
    )
    $ADPropertiesGetOnly = @(
        'msDS-UserPasswordExpiryTimeComputed'
    )
    $ADPropertiesPrintOnly = @(
        @{Name = "PasswordExpiresDate"; Expression = { [datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed") } }
    )
    $ADPropertiesGet = $ADPropertiesCommon + $ADPropertiesGetOnly
    $ADPropertiesPrint = $ADPropertiesCommon + $ADPropertiesPrintOnly
    Get-ADUser -Properties $ADPropertiesGet -Identity $User | Select-Object -Property $ADPropertiesPrint
}

function mkcd {
    param (
        [Parameter(Mandatory)]
        [string]$Path
    )
    New-Item -ItemType Directory -Path $Path
    Set-Location -Path $Path
}

if ($IsWindows -or ($env:OS -eq "Windows_NT")) {
    function who {
        & "$env:SystemRoot\System32\query.exe" user
    }

    # Drop elevation privileges.
    $env:__COMPAT_LAYER = "RunAsInvoker"
}

if ($nvim = Get-Command nvim.exe -ErrorAction SilentlyContinue) {
    Set-Alias -Name vi -Value $nvim.Source
}
Remove-Variable -Name nvim

# Force UTF-8 output.
$OutputEncoding = [System.Text.Encoding]::UTF8

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
Set-PSReadLineKeyHandler -Chord Ctrl+LeftArrow -Function BackwardWord
Set-PSReadLineKeyHandler -Chord Ctrl+RightArrow -Function ForwardWord
Set-PSReadLineKeyHandler -Chord Ctrl+Backspace -Function BackwardKillWord
Set-PSReadLineKeyHandler -Chord Ctrl+Delete -Function KillWord
Set-PSReadLineKeyHandler -Chord Shift+Spacebar -Function SelfInsert

# Keep this at the end.
if (Test-Path "$PSScriptRoot/local.ps1") {
    . "$PSScriptRoot/local.ps1"
}
