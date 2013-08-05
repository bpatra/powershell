$aliasesPath = Join-Path -Path ([System.IO.Path]::GetDirectoryName($PROFILE)) -ChildPath "alias.txt"
function CreateAliasesForExeInDirectory($path,$aliasDict)
{
    $result = Get-ChildItem (Join-Path $path "*") -Include *.exe | 
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

function Export-AliasWithEXEInPATH
{
    $aliasDict = @{}
    $existingAlias = Get-Alias | ForEach-Object {$_.Name}
    foreach($aliasName in $existingAlias)
    {
        $aliasDict.Add($aliasName,"")
    }
    $env:PATH.Split(';') | Where-Object {($_ -ne "")} | Where-Object { (Test-Path $_ )} | ForEach-Object { CreateAliasesForExeInDirectory $_ $aliasDict}
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