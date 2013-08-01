function CreateAliasesForDirectory($path)
{
    $result = Get-ChildItem (Join-Path $path "*") -Include *.exe | ForEach-Object { Set-Alias $_.BaseName $_}                                                                                                        
}

$env:PATH.Split(';')  | Where-Object {Test-Path $_ } | ForEach-Object { CreateAliasesForDirectory $_ }