function GetSystemOverview {
    # Retrieves management information using CIM
    $os = Get-CimInstance Win32_OperatingSystem
    # Retrieves computer hardware informaiton
    $computer = Get-CimInstance Win32_ComputerSystem
    # Retrieves processor information, behind first 1 because usually desktop only one cpu
    $cpu = Get-CimInstance Win32_Processor | Select-Object -First 1
    # Retrieves ram information
    $ram = (Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum
    # (Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum / 1GB

    Write-Host "========== SYSTEM Information ==========" -ForegroundColor Green
        
        [PSCustomObject]@{
        # Windows computer name
        ComputerName = $env:COMPUTERNAME
        # Windows edition
        OperatingSystem = $os.Caption
        # 64/32-bit
        Architecture = $os.OSArchitecture
        # OS version
        WindowsVersion = $os.Version
        # Brands
        Manufacturer = $computer.Manufacturer
        # Computer model
        Model = $computer.Model
        # CPU
        Processor = $cpu.Name
        # Total RAM
        InstalledRAM = "$($ram / 1GB) GB"
        # Approximate RAM
        SystemRAM = "$([math]::Round($computer.TotalPhysicalMemory / 1GB, 2)) GB"
        # Last startup
        LastBootTime = $os.LastBootUpTime

    } | Format-List |Out-String | ForEach-Object {Write-Host $_.Trim() }
    Write-Host "========== END OF SYSTEM Information ==========" -ForegroundColor Green


}