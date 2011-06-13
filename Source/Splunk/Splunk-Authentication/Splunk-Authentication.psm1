#region Authentication

#region New-SplunkCredential

# Helper function to Get and Store Credentials to be used against the Splunk API
function New-SplunkCredential
{
	<# .ExternalHelp ..\Splunk-Help.xml #>
	
	[Cmdletbinding()]
    Param(
	
		[Parameter()]
		[STRING]$UserName,
		
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
		Write-Verbose " [Get-SplunkdUser] :: Starting..."
	}
	Process
	{
		Write-Verbose " [Get-SplunkdUser] :: Parameters"
		Write-Verbose " [Get-SplunkdUser] ::  - UserName     = $UserName"
		Write-Verbose " [Get-SplunkdUser] ::  - ComputerName = $ComputerName"
		Write-Verbose " [Get-SplunkdUser] ::  - Port         = $Port"
		Write-Verbose " [Get-SplunkdUser] ::  - Protocol     = $Protocol"
		Write-Verbose " [Get-SplunkdUser] ::  - Timeout      = $Timeout"
		Write-Verbose " [Get-SplunkdUser] ::  - Credential   = $Credential"
		
		if($UserName)
		{
			$ServiceURL = "/services/authentication/users/$UserName"
		}
		else
		{
			$ServiceURL = "/services/authentication/users"
		}	

		Write-Verbose " [Get-SplunkdUser] :: Setting up Invoke-APIRequest parameters"
		$InvokeAPIParams = @{
			ComputerName = $ComputerName
			Port         = $Port
			Protocol     = $Protocol
			Timeout      = $Timeout
			Credential   = $Credential
			Endpoint     = $ServiceURL
			Verbose      = $VerbosePreference -eq "Continue"
		}
			
		Write-Verbose " [Get-SplunkdUser] :: Calling Invoke-SplunkAPIRequest @InvokeAPIParams"
		try
		{
			[XML]$Results = Invoke-SplunkAPIRequest @InvokeAPIParams
		}
		catch
		{
			Write-Verbose " [Get-SplunkdUser] :: Invoke-SplunkAPIRequest threw an exception: $_"
            Write-Error $
_		}
		if($Results)
		{
			foreach($Entry in $Results.feed.entry)
			{
				$MyObj = @{}
				$MyObj.Add("ComputerName",$ComputerName)
				$MyObj.Add("UserName",$Entry.Title)
				Write-Verbose " [Get-SplunkdUser] :: Creating Hash Table to be used to create 'Splunk.SDK.Splunkd.User'"
				switch ($Entry.content.dict.key)
				{
		        	{$_.name -eq "email"}						{$Myobj.Add("Email",$_.'#text');continue}
					{$_.name -eq "password"}					{$Myobj.Add("password",$_.'#text');continue}
			        {$_.name -eq "realname"}					{$Myobj.Add("FullName",$_.'#text');continue}
			        {$_.name -eq "roles"}						{$Myobj.Add("roles",$_.list.item);continue}
			        {$_.name -eq "type"}						{$Myobj.Add("Type",$_.'#text');continue}
					{$_.name -eq "defaultApp"}		    		{$Myobj.Add("DefaultApp",$_.'#text');continue}
		        	{$_.name -eq "defaultAppIsUserOverride"}	{$Myobj.Add("Splunk_Home",$_.'#text');continue}
					{$_.name -eq "defaultAppSourceRole"}		{$Myobj.Add("defaultAppSourceRole",$_.'#text');continue}
				}
				
				# Creating Splunk.SDK.Splunkd.User
			    $obj = New-Object PSObject -Property $MyObj
			    $obj.PSTypeNames.Clear()
			    $obj.PSTypeNames.Add('Splunk.SDK.Splunkd.User')
			    $obj
			}
		}
		else
		{
			Write-Verbose " [Get-SplunkdUser] :: No Response from REST API. Check for Errors from Invoke-SplunkAPIRequest"
		}
	}
	End
	{
		Write-Verbose " [Get-SplunkdUser] :: =========    End   ========="
	}
} # Get-SplunkdUser

#endregion Get-SplunkdUser

#endregion Authentication

################################################################################


