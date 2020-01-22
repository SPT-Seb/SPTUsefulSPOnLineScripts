<#
.SYNOPSIS
    Import from CSV file data as user properties into SharePoint Online.
.DESCRIPTION
    CSV file must have Column with Exact same name.
	First create custom properties (see https://gnanasivamgunasekaran.wordpress.com/2016/01/22/creating-managed-properties-for-custom-user-profile-properties-and-get-it-in-search-results-in-sharepoint-onlineo-365/ )
	Use "UserPrincipalName" field to retreive user based on email.
	Beware : expected date format is MM/DD/YYYY
.NOTES
    File Name      : Set-BulkSPOUserUpdate.ps1
    Author         : Sébastien Paulet (SPT Conseil)
    Prerequisite   : PowerShell V5.1 and SharePoint PNP module (Import-Module SharePointPnpPowershellOnline -DisableNameChecking)
.PARAMETER CSVSourceFile
    Full path to the folder to export
    Prerequisite   : PowerShell V5.1 and SharePoint PNP module (Import-Module SharePointPnpPowershellOnline -DisableNameChecking)
.PARAMETER TargetSharePointTenantUrl
    Url of SharePoint admin collection. Do not forget the -admin in the URL https://<tenant name>-admin.sharepoint.com/
.PARAMETER CSVSeparator
    CSV separator (by default ';')
.PARAMETER CSVEncoding
    CSV separator (by default 'Default')
.EXAMPLE
    .\Set-BulkSPOUserUpdate.ps1 -CSVSourceFile ".\MyCSVProperties.csv" -TargetSharePointTenantUrl "https://contoso-admin.sharepoint.com/"
#>
param(
    [Parameter(Mandatory = $true)]
    [String]$CSVSourceFile,
	[Parameter(Mandatory = $true)]
	[String]$TargetSharePointTenantUrl,
    [String]$CSVSeparator = ';',
	[String]$CSVEncoding = 'Default'
)

Connect-PnPOnline -Url $TargetSharePointTenantUrl -UseWebLogin
Import-Csv -Path $CSVSourceFile -Delimiter $CSVSeparator -Encoding $CSVEncoding | % {
	Set-PnPUserProfileProperty -Account $_.UserPrincipalName -Property 'MATRICULE' -Values $_.MATRICULE
	Set-PnPUserProfileProperty -Account $_.UserPrincipalName -Property 'SPS-HireDate' -Values $_.'SPS-HireDate'
	
	#COMPLETE WITH EXPECTED CUSTOM FIELDS
	
	Write-Host "User profile $($_.UserPrincipalName) updated"
}
DisConnect-PnPOnline