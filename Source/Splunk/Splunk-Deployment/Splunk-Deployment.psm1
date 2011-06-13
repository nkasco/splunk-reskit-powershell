#region Deployment

#region Get-SplunkServerClass

function Get-SplunkServerClass
{
	<# .ExternalHelp ..\Splunk-Help.xml #>

    [Cmdletbinding(DefaultParameterSetName="byFilter")]
    Param(

        [Parameter(Position=0,ParameterSetName="byFilter")]
        [STRING]$Filter = '.*',
	
		[Parameter(Position=0,ParameterSetName="byName")]
		[STRING]$Name,

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
		Write-Verbose " [Get-SplunkDeploymentClient] :: Starting..."
        $ParamSetName = $pscmdlet.ParameterSetName
        
        switch ($ParamSetName)
        {
            "byFilter"  { $WhereFilter = { $_.Name -match $Filter } } 
            "byName"    { $WhereFilter = { $_.Name -eq    $Name } }
        }
	}
	Process
	{
		Write-Verbose " [Get-SplunkDeploymentClient] :: Parameters"
        Write-Verbose " [Get-SplunkDeploymentClient] ::  - ParameterSet = $ParamSetName"
		Write-Verbose " [Get-SplunkDeploymentClient] ::  - ComputerName = $ComputerName"
		Write-Verbose " [Get-SplunkDeploymentClient] ::  - Port         = $Port"
		Write-Verbose " [Get-SplunkDeploymentClient] ::  - Protocol     = $Protocol"
		Write-Verbose " [Get-SplunkDeploymentClient] ::  - Timeout      = $Timeout"
		Write-Verbose " [Get-SplunkDeploymentClient] ::  - Credential   = $Credential"
        Write-Verbose " [Get-SplunkDeploymentClient] ::  - WhereFilter  = $WhereFilter"

		Write-Verbose " [Get-SplunkDeploymentClient] :: Setting up Invoke-APIRequest parameters"
		$InvokeAPIParams = @{
			ComputerName = $ComputerName
			Port         = $Port
			Protocol     = $Protocol
			Timeout      = $Timeout
			Credential   = $Credential
			Endpoint     = '/servicesNS/nobody/system/deployment/server/default/default.Clients' 
			Verbose      = $VerbosePreference -eq "Continue"
		}
			
		Write-Verbose " [Get-SplunkDeploymentClient] :: Calling Invoke-SplunkAPIRequest @InvokeAPIParams"
		try
		{
			[XML]$Results = Invoke-SplunkAPIRequest @InvokeAPIParams
        }
        catch
		{
			Write-Verbose " [Get-SplunkDeploymentClient] :: Invoke-SplunkAPIRequest threw an exception: $_"
            Write-Error $
_		}
        try
        {
			if($Results -and ($Results -is [System.Xml.XmlDocument]))
			{
				$MyObj = @{}
				Write-Verbose " [Get-SplunkDeploymentClient] :: Creating Hash Table to be used to create Splunk.SDK.Deployment.DeploymentClient"
				switch ($results.feed.entry.content.dict.key)
				{
		        	{$_.name -eq "build"}		    { $Myobj.Add("Build",$_.'#text')    ; continue }
					{$_.name -eq "ip"}	            { $Myobj.Add("IP",$_.'#text')       ; continue }
			        {$_.name -eq "hostname"}	    { $Myobj.Add("ComputerName",$_.'#text'); continue }
                    {$_.name -eq "mgmt"}		    { $Myobj.Add("MgmtPort",$_.'#text') ; continue }
                    {$_.name -eq "name"}		    { $Myobj.Add("Name",$_.'#text')     ; continue }
                    {$_.name -eq "phoneHomeTime"}	{ $Myobj.Add("LastUpdate",(ConvertFrom-SplunkTime $_.'#text')); continue }
                    {$_.name -eq "utsname"}		    { $Myobj.Add("utsname",$_.'#text')  ; continue }
                    {$_.name -eq "id"}		        { $Myobj.Add("ID",$_.'#text')       ; continue }
				}
				
				# Creating Splunk.SDK.ServiceStatus
			    $obj = New-Object PSObject -Property $MyObj
			    $obj.PSTypeNames.Clear()
			    $obj.PSTypeNames.Add('Splunk.SDK.Deployment.DeploymentClient')
			    $obj | Where-Object $WhereFilter
			}
			else
			{
				Write-Verbose " [Get-SplunkDeploymentClient] :: No Response from REST API. Check for Errors from Invoke-SplunkAPIRequest"
			}
		}
		catch
		{
			Write-Verbose " [Get-SplunkDeploymentClient] :: Get-SplunkDeploymentClient threw an exception: $_"
            Write-Error $
_		}
	}
	End
	{
		Write-Verbose " [Get-SplunkDeploymentClient] :: =========    End   ========="
	}

}    # Get-SplunkDeploymentClient

#endregion Get-SplunkDeploymentClient

#endregion Deployment

################################################################################


