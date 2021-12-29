begin {
    
    if ($false -eq (Test-Path $env:SystemRoot\System32\WindowsPowerShell\v1.0\Modules)) {
        New-Item -ItemType Directory -Path $env:SystemRoot\System32\WindowsPowerShell\v1.0\Modules1 -Force
    }
    $ScriptPath = Get-Location
    Import-Module PSWindowsUpdate -Force
    # Specify the path usage of Windows Update registry keys
    $Path = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows'
    }
process {
    if ($false -eq (Test-Path $Path\WindowsUpdate)) {
        New-Item -Path $Path -Name WindowsUpdate
        New-ItemProperty $Path\WindowsUpdate -Name DisableDualScan -PropertyType DWord -Value '0'
        New-ItemProperty $Path\WindowsUpdate -Name WUServer -PropertyType DWord -Value $null
        New-ItemProperty $Path\WindowsUpdate -Name WUStatusServer -PropertyType DWord -Value $null
    }
    else {
        try {
            Set-ItemProperty $Path\WindowsUpdate -Name DisableDualScan -value "0" -ErrorAction SilentlyContinue
            Set-ItemProperty $Path\WindowsUpdate -Name WUServer -Value $null -ErrorAction SilentlyContinue
            Set-ItemProperty $Path\WindowsUpdate -Name WUStatusServer -Value $null -ErrorAction SilentlyContinue
        }
        catch {
            Write-Output 'Skipped modifying registry keys'
        }
    }
    Add-WUServiceManager -ServiceID 7971f918-a847-4430-9279-4a52d1efe18d -Confirm:$false
    Start-Sleep 30
    Get-WUInstall -MicrosoftUpdate -AcceptAll
   # Get-WUInstall -MicrosoftUpdate Driver -AcceptAll
   # Get-WUInstall -MicrosoftUpdate Software -AcceptAll -IgnoreReboot
}

end {

}