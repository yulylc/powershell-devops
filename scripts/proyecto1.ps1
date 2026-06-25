# Al inicio del archivo, esto activa advertencias útiles
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
function Get-ArchivosGrandes {
    param(
        [string]$Ruta = "C:\Users\yulylc\Downloads\",
        [int]$Top = 10,
        [int]$Dias = 7,
        [string]$ExportarCSV = ''
    )
    if ($ExportarCSV -ne '') {
        $ExportarCSV = Join-Path -Path $ExportarCSV -ChildPath "ArchivosGrandes.csv"
        Get-ChildItem -Path $Ruta -File -Recurse -ErrorAction SilentlyContinue |
        Where-Object LastWriteTime -GT (Get-Date).AddDays(-$Dias) |
        Sort-Object Length -Descending |
        Select-Object -First $Top -Property Name,
        @{Name = 'TamañoMB'; Expression = { [math]::Round($_.Length / 1MB, 2) } },
        LastWriteTime,
        FullName | Export-Csv -Append -NoTypeInformation -Path $ExportarCSV
    }
    else {
        Get-ChildItem -Path $Ruta -File -Recurse -ErrorAction SilentlyContinue |
        Where-Object LastWriteTime -GT (Get-Date).AddDays(-$Dias) |
        Sort-Object Length -Descending |
        Select-Object -First $Top -Property Name,
        @{Name = 'TamañoMB'; Expression = { [math]::Round($_.Length / 1MB, 2) } },
        LastWriteTime,
        FullName
    }
}