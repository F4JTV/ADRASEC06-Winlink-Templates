<#
    set-version.ps1

    Aligns the version number of the ADRASEC templates and of the Inno Setup
    installer, which otherwise live in seven hard-coded places and drift apart.

    Usage, from the folder holding this script:
        .\set-version.ps1 1.1.2

    Touches only the ADRASEC files and the .iss. The FNRASEC folder keeps its
    own version (25.10.1), which belongs to its authors.
#>

param(
    [Parameter(Mandatory = $true)]
    [ValidatePattern('^\d+\.\d+\.\d+$')]
    [string]$Version
)

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $MyInvocation.MyCommand.Definition

$fichiers = @(
    'ADRASEC\ADRASEC_Message_Initial.html',
    'ADRASEC\ADRASEC_Message_Viewer.html',
    'ADRASEC\ADRASEC_AR_Initial.html',
    'ADRASEC\ADRASEC_AR_Viewer.html',
    'ADRASEC06_Templates.iss'
)

# Un seul groupe capturant : ce qui precede le numero de version.
$motifs = @(
    '(<meta name="version" content=")[0-9][0-9.]*',
    '(id="(?:TemplateVersion|arVersion)" value=")[0-9][0-9.]*',
    '(ADRASEC - (?:Message|AR) v)[0-9][0-9.]*',
    '(#define AppVersion\s+")[0-9][0-9.]*'
)

$total = 0

foreach ($relatif in $fichiers) {
    $chemin = Join-Path $root $relatif
    if (-not (Test-Path -LiteralPath $chemin)) {
        Write-Warning "absent, ignore : $relatif"
        continue
    }

    # Lire en preservant la presence ou l'absence de BOM : Inno Setup exige un
    # BOM sur le .iss pour les accents, les HTML n'en ont pas.
    $octets = [System.IO.File]::ReadAllBytes($chemin)
    $avecBom = ($octets.Length -ge 3 -and $octets[0] -eq 0xEF -and $octets[1] -eq 0xBB -and $octets[2] -eq 0xBF)
    $texte = [System.IO.File]::ReadAllText($chemin)

    $avant = $texte
    foreach ($motif in $motifs) {
        $texte = [regex]::Replace($texte, $motif, { param($m) $m.Groups[1].Value + $Version })
    }

    if ($texte -ne $avant) {
        $encodage = New-Object System.Text.UTF8Encoding($avecBom)
        [System.IO.File]::WriteAllText($chemin, $texte, $encodage)
        Write-Host "  mis a jour : $relatif"
        $total++
    } else {
        Write-Host "  inchange   : $relatif"
    }
}

Write-Host ""
Write-Host "Version $Version appliquee a $total fichier(s)."
Write-Host "Recompilez ensuite l'installateur :"
Write-Host '  "C:\Program Files (x86)\Inno Setup 6\ISCC.exe" ADRASEC06_Templates.iss'
