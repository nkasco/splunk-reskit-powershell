#region SplunkD

#region Get-Splunkd

function Get-Splunkd
{

	<# .ExternalHelp ..\Splunk-Help.xml #>

	[Cmdletbinding(SupportsShouldProcess=$true,DefaultParameterSetName="byFilter")]
    Param(
    
		[Parameter(ValueFromPipeline=$true,Position=0,ParameterSetName="byLogger")]
		[Object]$Logger,
		
        [Parameter(Position=0,ParameterSetName="byFilter")]
        [STRING]$Filter = '.*',
	
		[Parameter(Position=0,ParameterSetName="byName")]
		[STRING]$Name,
        
        [Parameter()]        
        [ValidateSet("WARN" , "DEBUG" , "INFO" , "CRIT" , "ERROR" , "FATAL")]
		[STRING]$NewLevel,
	
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
        [System.Management.Automation.PSCredential]$Credential = $SplunkDefaultConnectionObject.Credential
        
    )
	
	Begin
	{
		Write-Verbose " [Set-SplunkdLogging] :: Starting..."
        $ParamSetName = $pscmdlet.ParameterSetName
        
        switch ($ParamSetName)
        {
            "byFilter"  { $LoggerObjects = Get-SplunkdLogging -Filter $Filter	} 
            "byName"    { $LoggerObjects = Get-SplunkdLogging -Name $Name 		}
        }
        
	}
	Process
	{
		Write-Verbose " [Set-SplunkdLogging] :: Parameters"
        Write-Verbose " [Set-SplunkdLogging] ::  - ParameterSet = $ParamSetName"
		Write-Verbose " [Set-SplunkdLogging] ::  - ComputerName = $ComputerName"
		Write-Verbose " [Set-SplunkdLogging] ::  - Port         = $Port"
		Write-Verbose " [Set-SplunkdLogging] ::  - Protocol     = $Protocol"
		Write-Verbose " [Set-SplunkdLogging] ::  - Timeout      = $Timeout"
		Write-Verbose " [Set-SplunkdLogging] ::  - Credential   = $Credential"
        Write-Verbose " [Set-SplunkdLogging] ::  - LevelFilter  = $LevelFilter"
        Write-Verbose " [Set-SplunkdLogging] ::  - WhereFilter  = $WhereFilter"

		if($Logger -and $Logger.PSTypeNames -contains "Splunk.SDK.Splunkd.Logger")
		{
			$LoggerObjects = $Logger
		}
		
		foreach($LoggerObject in $LoggerObjects)
		{

			Write-Verbose " [Set-SplunkdLogging] :: Setting up Invoke-APIRequest parameters"
			$InvokeAPIParams = @{
				ComputerName = $ComputerName
				Port         = $Port
				Protocol     = $Protocol
				Timeout      = $Timeout
				Credential   = $Credential
				Endpoint     = $LoggerObject.ServiceURL
				Verbose      = $VerbosePreference -eq "Continue"
			}
			$Arguments = @{"level"=$NewLevel}
			
            Write-Verbose " [Set-SplunkdLogging] :: Using endpoint $($LoggerObject.ServiceURL)"
			Write-Verbose " [Set-SplunkdLogging] :: Calling Invoke-SplunkAPIRequest @InvokeAPIParams"
			try
			{
				if($Force -or $PSCmdlet.ShouldProcess($ComputerName,"Setting Splunkd Logging [$($LoggerObject.Name)] to [$NewLevel]"))
				{
					[XML]$Results = Invoke-SplunkAPIRequest @InvokeAPIParams -Arguments $Arguments -RequestType POST
					if($Results -and ($Results -is [System.Xml.XmlDocument]))
					{
						Get-SplunkdLogging -Name $LoggerObject.Name
					}
					else
					{
						Write-Verbose " [Set-SplunkdLogging] :: No Response from REST API. Check for Errors from Invoke-SplunkAPIRequest"
					}
				}
			}
			catch
			{
				Write-Verbose " [Set-SplunkdLogging] :: Invoke-SplunkAPIRequest threw an exception: $_"
                Write-Error $
_			}
		}
	}
	End
	{
		Write-Verbose " [Set-SplunkdLogging] :: =========    End   ========="
	}
} # Set-SplunkdLogging

#endregion Set-SplunkdLogging

#endregion SplunkD

################################################################################


