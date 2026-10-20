# Load System Overview function
. "$PSScriptRoot/Modules/Windows/SystemInfo/SystemOverview.ps1"

while($true){
    Write-Host "================================" -ForegroundColor Green
    Write-Host "       SYSADMIN TOOLKIT" -ForegroundColor Green
    Write-Host "================================" -ForegroundColor Green

    # Menu
    Write-Host "1. System Overview" -ForegroundColor Green
    Write-Host "0. Exit" -ForegroundColor Red

    # Receive user input
    Write-Host "Select an option:" -ForegroundColor Cyan
    $choice = Read-Host

    # Using switch check which option was selected
    switch($choice){
        "1"{
            Clear-Host
            GetSystemOverview | Format-List
            Read-Host "Press Enter to return"
        }

        "0"{
            break
        }

        default{
            Write-Host "Invalid option!" -ForegroundColor Red
            Start-Sleep -Seconds 1
        }
    }

    #When equal to 0 will stop execute
    if ($choice -eq "0") {
    break
    }
}