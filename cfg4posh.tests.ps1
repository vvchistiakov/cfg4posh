$here = Split-Path -Path $MyInvocation.MyCommand.Path -Parent;
$env:PSModulePath = $env:PSModulePath.Insert(0, (Split-Path -Path $here -Parent) + ';');
$name = $MyInvocation.MyCommand.Name.Split('.')[0];
Import-Module $name -Force;

function test1 {
	Write-Host "Test 1: Load Cfg"
	$cfg = Get-Config -path .\test.cfg;
	return $cfg;
}

function test2 {
	Write-Host "Test 2: Load JSON"
	$cfg = Get-Config -path .\test.json -type 'JSON'
	return $cfg;
}

function test3 {
	Write-Host "Test 3: Convert PSObject"
	$obj = New-Object -TypeName psobject;
	$obj = Add-Member -InputObject $obj -MemberType NoteProperty -Name 'string' -Value 'test' -PassThru;
	$obj = Add-Member -InputObject $obj -MemberType NoteProperty -Name 'bool' -Value $true -PassThru;
	$obj = Add-Member -InputObject $obj -MemberType NoteProperty -Name 'int' -Value 13 -PassThru;
	$obj.gettype().fullName;
	$hash = ConvertFrom-PSObjectToHashtable -psobject $obj;
	$hash.gettype().fullName;
	$hash;
}

function test4 {
	Write-Host "Test 4: Convert Null PSObject"
	$obj = $null;
	$obj.gettype().fullName;
	$hash = ConvertFrom-PSObjectToHashtable -psobject $obj;
	$hash.gettype().fullName;
	$hash -eq $null;
}

function test5 {
	Write-Host "Test 5: Convert PSObject from pipeline"
	$obj = New-Object -TypeName psobject;
	$obj = Add-Member -InputObject $obj -MemberType NoteProperty -Name 'string' -Value 'test' -PassThru;
	$obj = Add-Member -InputObject $obj -MemberType NoteProperty -Name 'bool' -Value $true -PassThru;
	$obj = Add-Member -InputObject $obj -MemberType NoteProperty -Name 'int' -Value 13 -PassThru;
	$obj.gettype().fullName;
	$hash = $obj | ConvertFrom-PSObjectToHashtable;
	$hash.gettype().fullName;
	$hash;
}


#test1;
#test2;
test3;
test4;
test5;