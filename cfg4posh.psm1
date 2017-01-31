<#
.SYNOPSIS
Get configuration file
.DESCRIPTION
Read config file and create hash bank of items
.PARAMETER path
Path to configure file
.PARAMETER type
Type of config file
.INPUTS
You can pipe path to cfg
.OUTPUTS
System.Collections.Hashtable. Get-Config return hash bank of items: [section][item]=value
#>
function Get-Config {
	[CmdletBinding()]
	param(
		[parameter(Mandatory = $true, valueFromPipeline = $true)]
		[string]$path,

		[Parameter()]
		[ValidateSet('INI', 'JSON')]
		[string]$type = 'INI'
	)
	begin {
		$hash = @{};
	}
	process {
		switch ($type) {
			'INI' { 
				$content = Get-Content -Path $path;
				switch -regex  ($content) {
					# comment
					"^[#;](.*)$" {
						continue;
					}
					# create section
					"^\[(.+)\]$" {
						$section = $matches[1]
						$hash[$section] = @{};
					}
					# add item=value to section
					"^(.+)=(.+)$" {
						$name = $matches[1];
						$value = $matches[2];
						$hash[$section][$name] = $value;
					}	
				}
			}
			'JSON' {
				$content = Get-Content -Path $path -Raw;
				$hash = $content | ConvertFrom-Json;
			}
		}
		return $hash;
	}
}

<#
.SYNOPSIS
Convert psobject to hashtable
.DESCRIPTION
Convert attributes psobject to hashtable, wher name -> key; value -> Item(key)
.PARAMETER psobject
Powershell object
.INPUTS
You can pipe psobject to cmdlet
.OUTPUTS
System.Collections.Hashtable.
#>
function ConvertFrom-PSObjectToHashtable {
	[CmdletBinding()]
	param(
		[Parameter(mandatory = $true, valueFromPipeline = $true)]
		[AllowNull()]
		[System.Object]$psobject
	)

	process {
		switch ($psobject) {
			$null { 
				return $null;
			}
			Default {
				$hashtable = @{};
				$psobject.psobject.properties | 
				ForEach-Object -Process {
					$hashtable[$_.Name] = $_.Value;
				}
				return $hashtable;
			}
		}
	}
}