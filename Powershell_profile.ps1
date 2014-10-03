
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


Import-Module PSReadline


