<#
.SYNOPSIS
    Import from CSV file data as user properties into Azure Active Directory. 
	Use "UserPrincipalName" field to retreive user based on email.
	"PictureFilePath" field contains path to picture in 648x648 (recomanded) and size < 100Kb (mandatory) for preview. 
.DESCRIPTION
    CSV file must have Column with Exact same name.
	About pictures rules, see article https://paulryan.com.au/2016/user-photos-office-365/
.NOTES
    File Name      : Set-BulkAzureADUserUpdate.ps1
    Author         : Sébastien Paulet (SPT Conseil)
    Prerequisite   : PowerShell V5.1 and AzureAD module (Import-Module AzureAD)
.PARAMETER CSVSourceFile
    Full path to the folder to export
.PARAMETER CSVSeparator
    CSV separator (by default ';')
.PARAMETER CSVEncoding
    CSV separator (by default 'Default')
.EXAMPLE
    .\Set-BulkAzureADUserUpdate.ps1 ".\MyCSVProperties.csv" 
#>
param(
    [Parameter(Mandatory = $true)]
    [String]$CSVSourceFile,
    [String]$CSVSeparator = ';',
	[String]$CSVEncoding = 'Default'
)

Connect-AzureAD
Import-Csv -Path $CSVSourceFile -Delimiter $CSVSeparator -Encoding $CSVEncoding | % {
	$user = Set-AzureADUser -ObjectId $_.UserPrincipalName  -City $_.City -Country $_.Country -Department $_.Department -DisplayName $_.DisplayName -FacsimileTelephoneNumber $_.FacsimileTelephoneNumber -GivenName $_.GivenName -JobTitle $_.JobTitle -MailNickName $_.MailNickName -Mobile $_.Mobile -PhysicalDeliveryOfficeName $_.PhysicalDeliveryOfficeName -PostalCode $_.PostalCode -State $_.State -StreetAddress $_.StreetAddress -Surname $_.Surname -TelephoneNumber $_.TelephoneNumber
	if ($_.PictureFilePath) {
		$pic = Set-AzureADUserThumbnailPhoto -ObjectId $_.UserPrincipalName -FilePath $_.PictureFilePath
	}
	Write-Host "User profile $($_.UserPrincipalName) updated"
}
DisConnect-AzureAD