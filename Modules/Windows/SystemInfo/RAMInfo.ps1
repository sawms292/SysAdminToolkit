function GetRAMInfo{
    # Retrieve Ram information
    $ram = Get-CimInstance Win32_PhysicalMemory
    $ramSlots = Get-CimInstance Win32_PhysicalMemoryArray
    # Retrieve management information
    $os = Get-CimInstance Win32_OperatingSystem
    # Retrieve Computer model
    $computer = Get-CimInstance Win32_ComputerSystem
    # Retrieve Motherboard model
    $board = Get-CimInstance Win32_BaseBoard

    # Overview
    Write-Host "===== RAM INFORMATION =====" -ForegroundColor Green
    Write-Host "[ALERT] Verify RAM slots with computer / motherboard model" -ForegroundColor Red
    Write-Host "[NOTE] Computer Model: $($computer.Model)" -ForegroundColor Cyan
    Write-Host "[NOTE] Motherboard: $($board.Manufacturer) $($board.Product)" -ForegroundColor Cyan

    [PSCustomObject]@{
        # Total RAM
        TotalInstalledRAM = "$([math]::Round(($ram | Measure-Object -Property Capacity -Sum).Sum / 1GB, 2)) GB"
        # Total usable RAM
        UsableRAM = "$([math]::Round($os.TotalVisibleMemorySize / 1MB, 2)) GB"
        # Available RAM
        AvailableRAM = "$([math]::Round($os.FreePhysicalMemory / 1MB, 2)) GB"
        # RAM was used
        UsedRAM = "$([math]::Round(($os.TotalVisibleMemorySize / 1MB) - ($os.FreePhysicalMemory / 1MB), 2)) GB"
        # RAM usage percentage
        MemoryUsage = "$([math]::Round((($os.TotalVisibleMemorySize - $os.FreePhysicalMemory) / $os.TotalVisibleMemorySize) * 100, 2))%"
        # RAM slots was used
        RAMSlotsUsed = @($ram).Count
        # Total RAM slots can install
        TotalRAMSlots = ($ramSlots | Measure-Object -Property MemoryDevices -Sum).Sum

        #Out String used to convert output to String
        # each item remove white space
    }| Format-List | Out-String | ForEach-Object { Write-Host $_.Trim() }

        $moduleNumber = 1

    foreach ($module in $ram) {
        # Identify RAM type
        switch ($module.SMBIOSMemoryType) {
            24 { $ramType = "DDR3" }
            26 { $ramType = "DDR4" }
            34 { $ramType = "DDR5" }
            default { $ramType = "Unknown" }
        }

        # Identify form factor
        switch ($module.FormFactor) {
            8  { $formFactor = "DIMM" }
            12 { $formFactor = "SODIMM" }
            default { $formFactor = "Unknown" }
        }

        Write-Host "`n----- RAM MODULE $moduleNumber -----" -ForegroundColor Yellow

        [PSCustomObject]@{
            # Install in motherboard which slot
            SlotLocation    = $module.DeviceLocator
            # RAM brand
            Manufacturer    = $module.Manufacturer
            # Model
            PartNumber      = $module.PartNumber.Trim()
            # RAM serial number
            SerialNumber    = $module.SerialNumber
            # Memory
            Capacity        = "$([math]::Round($module.Capacity / 1GB, 2)) GB"
            # TYpe of RAM
            RAMType         = $ramType
            # Current speed
            ConfiguredSpeed = "$($module.ConfiguredClockSpeed) MT/s"
            # Max speed
            RatedSpeed      = "$($module.Speed) MT/s"
            # RAM format
            FormFactor      = $formFactor
        } | Format-List | Out-String | ForEach-Object { Write-Host $_.Trim() }

        $moduleNumber++
    }
    Write-Host "===== END OF RAM INFORMATION =====" -ForegroundColor Green
} 