function Optimize-BTImageSource {
    param (
        [Parameter(Mandatory)]
        [String] $Source,

        [Switch] $ForceRefresh
    )

    if ([bool]([System.Uri]$Source).IsUnc -or $Source -like 'http?://*') {
        $RemoteFileName = [string]::Join('-', $Source.Split([System.IO.Path]::GetInvalidFileNameChars()))

        $NewFilePath = Join-Path -Path $Env:TEMP -ChildPath $RemoteFileName

        if (!(Test-Path -Path $NewFilePath) -or $ForceRefresh) {
            if ([bool]([System.Uri]$Source).IsUnc) {
                Copy-Item -Path $Source -Destination $NewFilePath -Force
            } else {
                Invoke-WebRequest -Uri $Source -OutFile $NewFilePath
            }
        }

        $NewFilePath
    } else {
        try {
            (Get-Item -Path $Source -ErrorAction Stop).FullName
        } catch {
            Write-Warning -Message "The image source '$Source' doesn't exist, failed back to icon."
        }
    }
}