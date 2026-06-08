$rootCert = New-SelfSignedCertificate -Type Custom -KeySpec Signature `
-Subject "CN=MohitAzureVPNRootCA" -KeyExportPolicy Exportable `
-HashAlgorithm sha256 -KeyLength 2048 `
-CertStoreLocation "Cert:\CurrentUser\My" `
-KeyUsageProperty Sign -KeyUsage CertSign

New-SelfSignedCertificate -Type Custom -DnsName "OnPremWindowsServer2016" `
-KeySpec Signature -KeyExportPolicy Exportable `
-HashAlgorithm sha256 -KeyLength 2048 `
-CertStoreLocation "Cert:\CurrentUser\My" `
-Signer $rootCert -TextExtension @("2.5.29.37={text}1.3.6.1.5.5.7.3.2")

<# 

Press the Windows Key + R on your keyboard to open the Run dialogue box.Type certmgr.msc and press Enter.
(Note: If you previously typed certlm.msc, that opened the Local Computer manager, which is why they looked missing).
Look at the very top left folder of the new window.
It should explicitly say Certificates - Current User.Expand the Personal folder, then click on Certificates

#/>
