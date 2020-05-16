# Correctly Partition Disk 0 During Operating System Deployment

$Partitions = (gwmi -Namespace 'ROOT\Cimv2' -Query "SELECT * FROM Win32_DiskDrive WHERE DeviceID Like '%PHYSICALDRIVE0'").Partitions

if($Partitions -gt 0) {
    exit 0
}

$tsenv = New-Object -COMObject Microsoft.SMS.TSEnvironment
$IsUefi = $tsenv.Value("_SMSTSBootUEFI").ToLower().Equals("true")


if (!$IsUefi) {

$DPCommands =
@"
select disk 0
clean
create partition size=350
format fs=ntfs quick label="System Reserved"
create partition
format fs=ntfs quick label="Windows"
Assign Letter=C
shrink desired=984 minimum=984
create partition primary
format quick fs=ntfs label="Recovery"
set id=27
"@
}

if ($IsUefi) {

$DPCommands =
@"
select disk 0
clean
convert gpt
create partition efi size=260
format quick fs=fat32 label="System"
create partition msr size=128
create partition primary
format quick fs=ntfs label="Windows"
shrink desired=984 minimum=984
assign letter=C
create partition primary
format quick fs=ntfs label="Recovery"
set id="de94bba4-06d1-4d40-a16a-bfd50179d6ac"
gpt attributes=0x8000000000000001
"@
}


$DPCommands | Out-File -FilePath "diskpart.txt" -Encoding ascii -Force

Start-Process -FilePath "diskpart.exe" -ArgumentList @("/S diskpart.txt") -WindowStyle Hidden -Wait -EA SilentlyContinue

# This script can potentially replace standard "Format and Partion", uncomment the next line if experimenting with that.
# $tsenv.Value("OSDisk") = "C:"
