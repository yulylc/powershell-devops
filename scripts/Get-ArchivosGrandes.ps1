# Al inicio del archivo, esto activa advertencias útiles
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
function Get-ArchivosGrandes {
    param(
        [string]$Ruta = "C:\Users\yulylc\Downloads\",
        [int]$Top = 10,
        [int]$Dias = 7,
        [string]$ExportarCSV
    )

    $resultado = Get-ChildItem -Path $Ruta -File -Recurse -ErrorAction SilentlyContinue |
        Where-Object LastWriteTime -GT (Get-Date).AddDays(-$Dias) |
        Sort-Object Length -Descending |
        Select-Object -First $Top -Property Name,
            @{Name='TamañoMB'; Expression={[math]::Round($_.Length / 1MB, 2)}},
            LastWriteTime,
            FullName

    if ($ExportarCSV) {
        try {  
        $rutaFinal = Join-Path -Path $ExportarCSV -ChildPath "ArchivosGrandes.csv"
        $resultado | Export-Csv -Path $rutaFinal -NoTypeInformation
        Write-Host "Exportado exitosamente: $rutaFinal" -ForegroundColor Green
        } catch {
            Write-Error "Error al exportar a CSV: $_"
        }
    } else {
        $resultado
    }
}