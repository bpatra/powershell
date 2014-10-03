
$aliasesPath = Join-Path -Path ([System.IO.Path]::GetDirectoryName($PROFILE)) -ChildPath "alias.txt"
 
function Export-AliasWithEXEInPATH
{
    $aliasDict = @{}
    $existingAlias = Get-Alias | ForEach-Object {$_.Name}
    foreach($aliasName in $existingAlias)
    {
        $aliasDict.Add($aliasName,"")
    }
    $pathDirectories = $env:PATH.Split(';') | Where-Object {($_ -ne "") -and (Test-Path $_ )}
    foreach($pathDir in $pathDirectories)
    {
        $result = Get-ChildItem (Join-Path $pathDir "*") -Include *.exe | 
            ForEach-Object {
                                Write-Host "Checking" $_.BaseName "for aliasing"
                                If(-Not $aliasDict.ContainsKey($_.BaseName))
                                {
                                    $alias = $_.BaseName.ToString()
                                    $for = $_.Name
                                    Set-Alias -Name $alias -Value $for -Verbose -Scope "Global"
                                }
                            }             
    }
    Export-Alias $aliasesPath
}
 
if(-Not (Test-Path $aliasesPath))
{
    Write-Error "Cannot find alias.txt execute function Export-AliasWithEXEInPATH"
}
else
{
    Import-Alias $aliasesPath -Force
}


function GitLog
{
     git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n'' %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' --all
}

#Subsample of the powershell community extensions
function Invoke-BatchFile
{
    param([string]$Path, [string]$Parameters) 

    $tempFile = [IO.Path]::GetTempFileName() 

    ## Store the output of cmd.exe.  We also ask cmd.exe to output  
    ## the environment table after the batch file completes 
    cmd.exe /c " `"$Path`" $Parameters && set > `"$tempFile`" "

    ## Go through the environment variables in the temp file. 
    ## For each of them, set the variable in our local environment. 
    Get-Content $tempFile | Foreach-Object {  
        if ($_ -match "^(.*?)=(.*)$") 
        {
            Set-Content "env:\$($matches[1])" $matches[2] 
        }
    } 

    Remove-Item $tempFile
}

function Import-VS2008Vars
{
    Invoke-BatchFile "${env:VS90COMNTOOLS}..\..\VC\vcvarsall.bat" $vcargs
}

function Import-VS2010Vars
{
    Invoke-BatchFile "${env:VS100COMNTOOLS}..\..\VC\vcvarsall.bat" $vcargs
}

function Import-VS2012Vars
{
    Invoke-BatchFile "${env:VS110COMNTOOLS}..\..\VC\vcvarsall.bat" $vcargs
     #VCVARS invoke in VS2012 are silent...
    Write-Host "VS2012 vcvars loaded..."
}

function Import-VS2013Vars
{
    Invoke-BatchFile "${env:VS120COMNTOOLS}..\..\VC\vcvarsall.bat" $vcargs
     #VCVARS invoke in VS2012 are silent...
    Write-Host "VS2013 vcvars loaded..."
}


#Import-Module PSReadline

<############### Start of PowerTab Initialization Code ########################
    Added to profile by PowerTab setup for loading of custom tab expansion.
    Import other modules after this, they may contain PowerTab integration.
#>

#Import-Module "PowerTab" -ArgumentList "C:\Users\Benoit\Documents\WindowsPowerShell\PowerTabConfig.xml"
################ End of PowerTab Initialization Code ##########################


