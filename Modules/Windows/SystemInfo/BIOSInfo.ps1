
function GetBIOSInfo {
    # Retrieve BIOS information
    $bios = Get-CimInstance Win32_BIOS
    # Retrieve computer information
    $system = Get-CimInstance Win32_ComputerSystem
    # Retrieve motherboard information
    $board = Get-CimInstance Win32_BaseBoard

    Write-Host "========== BIOS Information ==========" -ForegroundColor Green

    # Display BIOS and hardware information
    [PSCustomObject]@{
        # BIOS manufacturer
        BIOSManufacturer = $bios.Manufacturer
        # BIOS version
        BIOSVersion = $bios.SMBIOSBIOSVersion
        # BIOS release date
        BIOSReleaseDate = $bios.ReleaseDate.ToString("yyyy-MM-dd")
        # Computer serial number
        BIOSSerialNumber = $bios.SerialNumber
        # Computer manufacturer
        ComputerManufacturer = $system.Manufacturer
        # Computer model
        ComputerModel = $system.Model
        # Motherboard manufacturer
        MotherboardManufacturer = $board.Manufacturer
        # Motherboard model
        MotherboardModel = $board.Product
    } | Format-List | Out-String | ForEach-Object {Write-Host $_.Trim() }
    Write-Host "========== END OF BIOS Information ==========" -ForegroundColor Green
}