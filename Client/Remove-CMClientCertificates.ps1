# Remove all CM Certificates
Remove-Item -Path 'HKLM:\SOFTWARE\Microsoft\SystemCertificates\SMS\Certificates\*' -force;
# Restart the CM Client Agent
Restart-Service ccmexec
