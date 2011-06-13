#region Splunk License

#region Get-SplunkLicenseFile

function Get-SplunkLicenseFile
{

	<# .ExternalHelp ..\Splunk-Help.xml #>

    [Cmdletbinding(SupportsShouldProcess=$true,ConfirmImpact='High')]
    Param(

		[Parameter(ValueFromPipelineByPropertyName=$true,Mandatory=$True)]
		[STRING]$GroupName,

        [Parameter(ValueFromPipelineByPropertyName=$true,ValueFromPipeline=$true)]
        [String]$ComputerName = $SplunkDefaultConnectionObject.ComputerName,
        
        [Parameter()]
        [int]$Port            = $SplunkDefaultConnectionObject.Port,
        
        [Parameter()]
		[ValidateSet("http", "https")]
        [STRING]$Protocol     = $SplunkDefaultConnectionObject.Protocol,
        
        [Parameter()]
        [int]$Timeout         = $SplunkDefaultConnectionObject.Timeout,

        [Parameter()]
        [System.Management.Automation.PSCredential]$Credential = $SplunkDefaultConnectionObject.Credential,
        
        [Parameter()]
        [SWITCH]$Force
        
    )
    Begin
	{
		Write-Verbose " [Get-SplunkLicenseGroup] :: Starting..."
	}
	Process
	{
		Write-Verbose " [Set-SplunkLicenseGroup] :: Parameters"
		Write-Verbose " [Set-SplunkLicenseGroup] ::  - ComputerName = $ComputerName"
		Write-Verbose " [Set-SplunkLicenseGroup] ::  - Port         = $Port"
		Write-Verbose " [Set-SplunkLicenseGroup] ::  - Protocol     = $Protocol"
		Write-Verbose " [Set-SplunkLicenseGroup] ::  - Timeout      = $Timeout"
		Write-Verbose " [Set-SplunkLicenseGroup] ::  - Credential   = $Credential"

		Write-Verbose " [Set-SplunkLicenseGroup] :: Setting up Invoke-APIRequest parameters"
		$InvokeAPIParams = @{
			ComputerName = $ComputerName
			Port         = $Port
			Protocol     = $Protocol
			Timeout      = $Timeout
			Credential   = $Credential
			Endpoint     = "/services/licenser/groups/${GroupName}"
			Verbose      = $VerbosePreference -eq "Continue"
		}
        
        $GroupPostParam = @{
            is_active = 1
        }
        
		Write-Verbose " [Set-SplunkLicenseGroup] :: Calling Invoke-SplunkAPIRequest @InvokeAPIParams"
		try
		{
            if($Force -or $PSCmdlet.ShouldProcess($ComputerName,"Setting Active Group to [$GroupName]"))
			{
			    [XML]$Results = Invoke-SplunkAPIRequest @InvokeAPIParams -Arguments $GroupPostParam -RequestType POST
            }
        }
        catch
		{
			Write-Verbose " [Set-SplunkLicenseGroup] :: Invoke-SplunkAPIRequest threw an exception: $_"
            Write-Error $
_		}
        try
        {
			if($Results -and ($Results -is [System.Xml.XmlDocument]))
			{
                Write-Host " [Set-SplunkLicenseGroup] :: Please restart Splunkd"
                Get-SplunkLicenseGroup -Name $GroupName
			}
			else
			{
				Write-Verbose " [Set-SplunkLicenseGroup] :: No Response from REST API. Check for Errors from Invoke-SplunkAPIRequest"
			}
		}
		catch
		{
			Write-Verbose " [Set-SplunkLicenseGroup] :: Set-SplunkLicenseGroup threw an exception: $_"
            Write-Error $
_		}
	}
	End
	{
		Write-Verbose " [Set-SplunkLicenseGroup] :: =========    End   ========="
	}

}    # Set-SplunkLicenseGroup

#endregion Set-SplunkLicenseGroup

#endregion SPlunk License

################################################################################


