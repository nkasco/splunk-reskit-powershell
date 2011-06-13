﻿param( $fixture )

Describe "get-splunkLicenseFile" {

	$fields = data {
				"Creationtime"
	        	"expiration"
	        	"features"
				"groupid"
		        "label"
				"Hash"
		        "MaxViolations"
		        "Quota"
		        "SourceTypes"
		        "StackID"
		        "Status"
		        "Type"
				"WindowPeriod"
	};

	It "fetches enterprise license using default parameters" {
		Get-SplunkLicenseFile | verify-results -fields $fields | verify-all;
	}
	
	It "fetches all licenses using default parameters" {
		Get-SplunkLicenseFile -all | verify-results -fields $fields | verify-all;
	}
	
	It "fetches enterprise license using custom splunk connection parameters" {
		Get-SplunkLicenseFile -ComputerName $script:fixture.splunkServer `
			-port $script:fixture.splunkPort `
			-Credential $script:fixture.splunkAdminCredentials | 
			verify-results -fields $fields | 
			verify-all;
	}
	
	It "fetches all licenses using custom splunk connection parameters" {
		Get-SplunkLicenseFile -all `
			-ComputerName $script:fixture.splunkServer `
			-port $script:fixture.splunkPort `
			-Credential $script:fixture.splunkAdminCredentials | 
			verify-results -fields $fields | 
			verify-all;
	}
	
}

Describe "get-splunklicensepool" {
	
	$fields = data {
		"ComputerName"
		"Description"
		"ID"
		"PoolName"
		"SlavesUsageBytes"
		"StackID"
		"UsedBytes"
	};
				
	It "fetches license pools using default connection parameters" {
		get-SplunkLicensePool | verify-results -fields $fields | verify-all;
	}
	
	It "fetches license pools using custom splunk connection parameters" {
		get-SplunkLicensePool -ComputerName $script:fixture.splunkServer `
			-port $script:fixture.splunkPort `
			-Credential $script:fixture.splunkAdminCredentials | 
			verify-results -fields $fields | 
			verify-all;	
	}

	It "can filter pools by name" {
		$local:pools = Get-SplunkLicensePool;
		
		$result = get-SplunkLicensePool -filter $local:pools[0].PoolName;
		$result -and @($result).length -eq 1;
	}
	
	It "can find pools by name" {
		$local:pools = Get-SplunkLicensePool;
		
		$result = get-SplunkLicensePool -name $local:pools[0].PoolName;
		$result -and @($result).length -eq 1;
	}

}

Describe "get-splunklicensestack" {
	
	$fields = data {
		"ComputerName"
		"ID"
		"Label"
		"Quota"
		"StackName"
		"Type"

	};
				
	It "fetches enterprise license stacks using default connecction parameters" {
		get-SplunkLicenseStack | verify-results -fields $fields | verify-all;
	}
	
	
	It "fetches license stacks using custom splunk connection parameters" {
		get-SplunkLicenseStack -ComputerName $script:fixture.splunkServer `
			-port $script:fixture.splunkPort `
			-Credential $script:fixture.splunkAdminCredentials | 
			verify-results -fields $fields | 
			verify-all;	
	}

	It "can filter stacks by name" {
		$local:pools = Get-SplunkLicenseStack;
		
		$result = get-SplunkLicenseStack -filter $local:pools[0].StackName;
		$result -and @($result).length -eq 1;
	}
	
	It "can find stacks by name" {
		$local:pools = Get-SplunkLicenseStack;
		
		$result = get-SplunkLicenseStack -name $local:pools[0].StackName;
		$result -and @($result).length -eq 1;
	}

}

Describe "get-splunklicensegroup" {
	
	$fields = data {
		"ComputerName"
		"GroupName"
		"ID"
		"IsActive"
		"StackIDs"
	};					
	
	It "fetches license groups using default connecction parameters" {
		get-SplunkLicenseGroup | verify-results -fields $fields | verify-all;
	}
	
	It "fetches license groups using custom splunk connection parameters" {
		get-SplunkLicensegroup -ComputerName $script:fixture.splunkServer `
			-port $script:fixture.splunkPort `
			-Credential $script:fixture.splunkAdminCredentials | 
			verify-results -fields $fields | 
			verify-all;	
	}

	It "can filter groups by name" {
		$local:pools = Get-SplunkLicensegroup;
		
		$result = get-SplunkLicensegroup -filter $local:pools[0].groupName;
		$result -and @($result).length -eq 1;
	}
	
	It "can find groups by name" {
		$local:pools = Get-SplunkLicensegroup;
		
		$result = get-SplunkLicensegroup -name $local:pools[0].GroupName;
		$result -and @($result).length -eq 1;
	}

}