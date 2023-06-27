$Files = @(
    "IntelliJ IDEA Global Settings"
    "installed.txt"
    "codestyles"
    "options"
)
Compress-Archive -DestinationPath JetBrains-ACP.zip -Path $Files
