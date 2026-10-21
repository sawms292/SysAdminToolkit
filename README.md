# SysAdminToolkit

A PowerShell toolkit for viewing Windows system and hardware information.

## Features

| Option | Feature | Description |
| --- | --- | --- |
| 1 | System Overview | Displays basic computer and Windows details. |
| 2 | CPU Information | Displays processor specifications. |
| 3 | RAM Information | Displays installed memory details. |
|4| Storage Information | Displays disk details, health status, and storage usage for each drive. |
| 0 | Exit | Closes the toolkit. |

## Requirements

- Windows 10 or 11
- [PowerShell 7](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows) recommended

Administrator access is not required for these information checks.

## Installation

Download the repository using **Code > Download ZIP** on [GitHub](https://github.com/sawms292/SysAdminToolkit), then extract it. Alternatively, clone it:

```powershell
git clone https://github.com/sawms292/SysAdminToolkit.git
cd SysAdminToolkit
```

## Usage

Open PowerShell 7 in the project folder and run:

```powershell
pwsh -NoProfile -File .\StartToolkit.ps1
```

If script execution is blocked, and you have reviewed and trust the code, use:

```powershell
pwsh -NoProfile -ExecutionPolicy Bypass -File .\StartToolkit.ps1
```

This applies only to the new PowerShell process. It does not override organization-enforced security policies.

Select **1**, **2**, **3**, or **4** to view system information, or **0** to exit. Follow the on-screen prompt to return to the menu.

## Project Structure

```text
SysAdminToolkit/
├── StartToolkit.ps1
└── Modules/
    └── Windows/
        └── SystemInfo/
            ├── SystemOverview.ps1
            ├── CPUInfo.ps1
            ├── RAMInfo.ps1
            └── StorageInfo.ps1
```

The menu is currently handled by `StartToolkit.ps1`. A separate `MainMenu.ps1` is not used in this version.

## Notes

This project is under development. Available hardware details may vary between computers. Review scripts before running them.
