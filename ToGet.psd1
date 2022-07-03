
@{
    GUID = "db8d2ba8-5fd9-49c7-8d3e-11cd4c1623de"
    Author = "Ethan Bergstrom"
    ModuleVersion = "0.0.1"
    RootModule = "ToGet.psm1"

    DscResourcesToExport = 'PackageManagement'

	PrivateData = @{
        PSData = @{
            Tags = @('PackageManagement', 'PSEdition_Core', 'Linux', 'Mac')
        }
    }
}
