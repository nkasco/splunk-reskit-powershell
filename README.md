# Notice of archival

May 22nd, 2018: We had some fun, but this project has not been actively maintained for some time. Feel free to fork and prosper, but at this time, Splunk will not be making any future contributions to the project. 

---

# Splunk PowerShell Resource Kit

The Splunk PowerShell Resource Kit enables IT administrators to manage their 
Splunk topology, configure Splunk internals, and engage the Splunk search 
engine from their PowerShell session.  

## Example Uses

Here are a few of the tasks enabled by the Resource Kit:

* 	Determine or change the status of Splunk services across a set of Splunk 
	servers in parallel.
*	Force one or more Splunk servers to reload their configuration, in parallel.
*	Deploy multiple Splunk forwarders to all active hosts in a Windows domain.
*	Retrieve a list of Splunk server classes, optionally filtered by last 
	deployment client connection time, associated applications, or matching 
	patterns.
*	Issue a Splunk search and format the retrieved events as a table, a list, 
	or in a windowed grid view. 

## Installation

1. Download the source code repository.  Unblock the ZIP archive and extract it to a folder.  (You can alternatively clone the GitHub repository)
2. Open the folder to which you extracted or cloned the source code.
3. Run install.bat.  This will copy the Splunk PowerShell module into your module path.

To verify the Splunk module is available, open PowerShell and type:

    get-module Splunk
    
You should see output similar to the following:


    ModuleType Name                      ExportedCommands                                                           
    ---------- ----                      ----------------                                                           
    Script     splunk                    {... 

## Documentation

Most of the documentation lives in the "Splunk PowerShell Resource Kit 
Cookbook", which we highly recommend you read. You can find it here at
[Docs/Splunk PowerShell Resource Kit.docx][1]

[1]: https://github.com/splunk/splunk-reskit-powershell/raw/master/Docs/Splunk%20PowerShell%20Resource%20Kit.docx

## Resources

You can find anything having to do with developing on Splunk at the Splunk
developer portal:

*   http://dev.splunk.com

You can also find full reference documentation of the REST API:

*   http://docs.splunk.com/Documentation/Splunk/latest/RESTAPI

## Community

* Chat: Join us on the Splunk-Usergroups Slack team! Instructions to join: https://docs.splunk.com/Documentation/Community/1.0/community/Chat
* Email: Contact the Splunk Dev Platform team: devinfo@splunk.com
* Answers: Check out this tag on Splunk answers for:  
    http://splunk-base.splunk.com/tags/powershell/
* Blog:  http://blogs.splunk.com/dev/
* Twitter: [@splunkdev](http://twitter.com/splunkdev)

### Support

* Resource Kits in Preview will not be Splunk supported.  Once the PowerShell 
Resource Kit an Open Beta we will provide more detail on support.  

* Issues should be filed here: https://github.com/splunk/splunk-reskit-powershell/issues

## License

The Splunk PowerShell Resource Kit is licensed under the Apache
License 2.0. Details can be found in the file LICENSE.
