$ChocoInstallPath = "$env:SystemDrive\ProgramData\chocolatey\bin"
$env:Path += ";$ChocoInstallPath"

if (!(Test-Path $ChocoInstallPath)) {
  # Install Chocolatey
  iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))
}
