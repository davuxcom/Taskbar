
function Get-ConsoleWindowHWND {
    add-type -MemberDefinition @"
[DllImport("KERNEL32.DLL")]
public static extern int GetConsoleWindow();
"@ -Namespace $null -Name GCW
    [GCW]::GetConsoleWindow()
}

function Set-PowerShellAppId($AppId) {
    if (!$IsTaskHost -and !$IsRemote -and !$IsBackground) {
        try {
            add-type -Path $PsScriptRoot\Microsoft.WindowsAPICodePack.Shell.dll
            $tb = [Microsoft.WindowsAPICodePack.Taskbar.TaskbarManager]::Instance
            $tb.SetApplicationIdForSpecificWindow((Get-ConsoleWindowHWND), $AppId)
        } catch [exception] { msg "Didn't update taskbar" }
    }
}

function Set-TaskbarOverlayIcon($icoPath, $accText) {
    if (!$IsTaskHost -and !$IsRemote -and !$IsBackground) {
        try {
            add-type -Path $PsScriptRoot\Microsoft.WindowsAPICodePack.Shell.dll
            $tb = [Microsoft.WindowsAPICodePack.Taskbar.TaskbarManager]::Instance
            $tb.SetOverlayIcon([System.Drawing.Icon]$icoPath, $accText)
        } catch [exception] { msg "Didn't update taskbar" }
    }
}