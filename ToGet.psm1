enum ensure {
    Absent
    Present
}

[DscResource()]
class PackageManagement {
    [DscProperty(Key)]
    [string] $Name

    [DscProperty(Mandatory)]
    [ensure] $ensure

    [DscProperty()]
    [string] $RequiredVersion

    [DscProperty()]
    [string] $MinimumVersion

    [DscProperty()]
    [string] $MaximumVersion

    [DscProperty()]
    [string] $Source

    [DscProperty()]
    [PSCredential] $SourceCredential
    
    [DscProperty()]
    [string] $ProviderName

    [PackageManagement] Get() {

        $parameters = @{}
        $this.psobject.Properties | ForEach-Object {
            if ($_.Value -and -not ($_.Name -in 'Source','SourceCredential','ensure')) {
                $parameters.Add($_.Name,$_.Value)
            }
        }
            
        $result = PackageManagement\Get-Package @parameters -ErrorAction SilentlyContinue -WarningAction SilentlyContinue | Select-Object -First 1
    
        if ($result) {
            return  @{
                Ensure = 'Present'
                Name = $result.Name
                ProviderName = $result.ProviderName
                Source = $result.source
                RequiredVersion = $result.Version
            } 
        } else {
            return @{
                Ensure = 'Absent'
                Name = $this.Name
                ProviderName = $this.ProviderName
                RequiredVersion = $this.RequiredVersion
                MinimumVersion = $this.MinimumVersion
                MaximumVersion = $this.MaximumVersion
            }
        }
    }
    
    <#
        This method is equivalent of the Set-TargetResource script function.
        It sets the resource to the desired state.
    #>
    [void] Set() {
        $set = Set-File -ensure $this.ensure -path $this.path -content $this.content
    }
    
    <#
        This method is equivalent of the Test-TargetResource script
        function. It should return True or False, showing whether the
        resource is in a desired state.
    #>
    [bool] Test() {
        $test = Test-File -ensure $this.ensure -path $this.path -content $this.content
        return $test
    }
}