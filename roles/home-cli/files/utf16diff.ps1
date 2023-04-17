[string]$file = $args[0]
[string]$encoding = $(&"C:\Program Files\Git\usr\bin\file.exe" -b --mime-encoding $file)
&"C:\Program Files\Git\usr\bin\iconv.exe" -c -f $encoding -t UTF-8 $file
