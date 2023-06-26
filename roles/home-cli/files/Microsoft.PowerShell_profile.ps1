# Put this in the location of $PROFILE. For PowerShell 5+ this is either
#   C:\Users\USERNAME\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1
# or
#   C:\Users\USERNAME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1

function Prompt {
    if ($IsWindows -or ($env:OS -eq "Windows_NT")) {
        [string]$monoPrompt = ""
        $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
        if ($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
            $monoPrompt = $env:USERNAME + "@" + $env:COMPUTERNAME.ToLower() + "# "
        } else {
            $monoPrompt = $env:USERNAME + "@" + $env:COMPUTERNAME.ToLower() + "> "
        }
        if ($PSVersionTable.PSVersion -ge [System.Version]"6.0.0.0") {
            # Print the prompt in bold.
            "`e[1m" + $monoPrompt + "`e[0m"
        } else {
            $monoPrompt
        }
    } elseif ($IsLinux) {
        "`e[1m" + $(id -un) + "@" + $(hostname -s) + "> `e[0m"
    } else {
        "PS> "
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

Function mkcd {
    param (
        [Parameter(Mandatory)]
        [string]$Path
    )
    New-Item -ItemType Directory -Path $Path
    Set-Location -Path $Path
}

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

# Keep this at the end.
$LocalProfilePath = Join-Path -Path "$PSScriptRoot" -ChildPath "local.ps1"
if (Test-Path $LocalProfilePath -PathType Leaf) {
    . $LocalProfilePath
}
