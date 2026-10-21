
function GetStorageInfo {
    # Retrieve disk information
    $disks = Get-Disk
    Write-Host "===== STORAGE INFORMATION =====`n" -ForegroundColor Green

    foreach ($disk in $disks) {
        Write-Host "========== DISK $($disk.Number) ==========" -ForegroundColor Green
        Write-Host "[ALERT] Test used disks with dedicated diagnostic tools before purchasing!" -ForegroundColor Red
        Write-Host "[ALERT] Disk health status is not a complete diagnostic! Further testing is recommended!" -ForegroundColor Red

        # Retrieve disk health information
        $physicalDisk = Get-PhysicalDisk | Where-Object { $_.DeviceId -eq $disk.Number } | Select-Object -First 1

        if ($physicalDisk) {
            # Check is SSD or
            $diskType = $physicalDisk.MediaType
            # Storage status like healthy, warning and etc
            $health = $physicalDisk.HealthStatus
            # Operational status is ok or not
            $status = $physicalDisk.OperationalStatus
        }
        # if value dont have set to unknown
        else {
            $diskType = "Unknown"
            $health = "Unknown"
            $status = "Unknown"
        }

        # Display disk information
        [PSCustomObject]@{
            # disk model
            Model             = $disk.FriendlyName
            # disk serial number
            SerialNumber      = $disk.SerialNumber
            # SSD or
            DiskType          = $diskType
            # is NVMe or
            BusType           = $disk.BusType
            # disk total storage
            Capacity          = "$([math]::Round($disk.Size / 1GB, 2)) GB"
            # health status
            HealthStatus      = $health
            # operational state
            OperationalStatus = $status

            # convert all to string and remove additional space
        }| Format-List | Out-String | ForEach-Object { Write-Host $_.Trim() }

        # Retrieve partitions to this disk, DriveLetter it help to display which drive with storage
        # Without DriveLetter it will display this disk all partitions include is system, recovery storage
        $partitions = Get-Partition -DiskNumber $disk.Number | Where-Object { $_.DriveLetter }

        foreach ($partition in $partitions) {

            # Retrieve partition volume information
            $volume = $partition | Get-Volume

            # if volume object is missing, continue with next
            if ($null -eq $volume) {
                continue
            }

            # -gt is greater than 0
            if ($volume.Size -gt 0) {
            # used space / total space * 100
                $usage = [math]::Round((($volume.Size - $volume.SizeRemaining) / $volume.Size) * 100, 2)
            }
            else {
                $usage = 0
            }

            Write-Host "----- DRIVE $($partition.DriveLetter): -----" -ForegroundColor Yellow

            # Display drive information
            [PSCustomObject]@{
                VolumeName      = $volume.FileSystemLabel
                FileSystem      = $volume.FileSystem
                # drive total storage
                TotalCapacity   = "$([math]::Round($volume.Size / 1GB, 2)) GB"
                # drive storage was used
                UsedSpace       = "$([math]::Round(($volume.Size - $volume.SizeRemaining) / 1GB, 2)) GB"
                # drive storage available
                FreeSpace       = "$([math]::Round($volume.SizeRemaining / 1GB, 2)) GB"
                # drive storage usage %
                UsagePercentage = "$usage%"
            } | Format-List | Out-String | ForEach-Object {Write-Host $_.Trim() }
        }
        Write-Host "========== END OF DISK $($disk.Number) ==========`n" -ForegroundColor Green
    }
    Write-Host "===== END OF STORAGE INFORMATION =====" -ForegroundColor Green
}