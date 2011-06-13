#region Helper cmdlets

#region ConvertFrom-UnixTime

function ConvertFrom-UnixTime
{
	<# .ExternalHelp ..\Splunk-Help.xml #>

    [CmdletBinding()]
    param(
        [Parameter()]
        [string]$Verb = "*",
        [Parameter()]
        [string]$noun = "*"
    )


    Process
    {
        Get-Command -Module Splunk -Verb $verb -noun $noun
    }#Process

} # Get-Splunk

# Adding System.Web namespace
Add-Type -AssemblyName System.Web 

New-Variable -Name SplunkModuleHome              -Value $psScriptRoot -Scope Global -Force
New-Variable -Name SplunkDefaultConnectionObject -Value $null         -Scope Script -Force

# code to load scripts
Get-ChildItem $SplunkModuleHome *.ps1xml -Recurse | foreach-object{ Update-FormatData $_.fullname -ea 0 } 
