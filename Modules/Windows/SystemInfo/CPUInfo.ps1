function GetCPUInfo{
    # Retrieve cpu info, first 1 to fetch first cpu only
    $cpu = Get-CimInstance Win32_Processor | Select-Object -First 1
    # Retrieve system info
    $system = Get-CimInstance Win32_ComputerSystem

    # Check virtualization status
    if ($system.HypervisorPresent) {
        $virtualization = "Enabled (Hypervisor Active)"
    }
    elseif ($cpu.VirtualizationFirmwareEnabled) {
        $virtualization = "Enabled"
    }
    else {
        $virtualization = "Disabled"
    }

    Write-Host "========== CPU Information ==========" -ForegroundColor Green

    # CPU information
    [PSCustomObject]@{
        # Cpu model
        ProcessorName = $cpu.Name
        # Cpu brand
        Manufacturer = $cpu.Manufacturer
        # Cpu physical cores
        PhysicalCores = $cpu.NumberOfCores
        # Cpu logical processors
        LogicalProcessors = $cpu.NumberOfLogicalProcessors
        # Current clock speed
        CurrentClockMHz = "$([math]::Round($cpu.CurrentClockSpeed /1000,2)) GHz"
        #Cpu socket
        Socket = $system.NumberOfProcessors
        # virtualization
        Virtualization = $virtualization
        # Approximate CPU usage
        CPUUsagePercent     = "$($cpu.LoadPercentage)%"

    } | Format-List |Out-String | ForEach-Object {Write-Host $_.Trim() }
    Write-Host "========== END OF CPU Information ==========" -ForegroundColor Green

}