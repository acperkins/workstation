// Test the keyboard.
var WshShell = WScript.CreateObject("WScript.Shell");
while (1) {
    WshShell.SendKeys('{SCROLLLOCK}');
    WshShell.SendKeys('{SCROLLLOCK}');
    WScript.Sleep(1000 * 60 * 4);  // 1000ths of a second.
}
